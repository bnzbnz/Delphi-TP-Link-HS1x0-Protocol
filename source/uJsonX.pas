unit uJsonX;

///
///  Author:  Laurent Meyer
///  Contact: HS1x0@ea4d.com
///
///  https://github.com/bnzbnz/Delphi-TP-Link-HS1x0-Protocol
///
///  License: MPL 1.1 / GPL 2.1
///

interface

uses  uJsonX.Types, Classes, JsonDataObjects, System.Generics.Collections;

{$REGION 'Intf.'}

type

  // Atributes

  AJsonXClassType = class(TCustomAttribute)
  public
    FClassType: TClass;
    constructor Create(const AClassType: TClass);
  end;


  // TJsonXPatcher

  TJsonXPatcherCtnr = class
  public
    Hdr, Jsn: string;
  end;

  TJsonXPatcher = class(TObject)
  private
    FParts: TObjectList<TJsonXPatcherCtnr>;
    FLowMemL2: Boolean;
  public
    constructor Create(LowMemL2: Boolean = False); overload;
    procedure Decode(var JsonStr: string; SysParams: TJsonXSystemParameters; SysStatus: TJsonXSystemStatus = nil);
    destructor Destroy; override;
    function Encode(JsonStr: string; Header: string = '"';  Footer: string = '"'): string;
  end;

  // TJsonX

  TJsonXInternal = class(TObject)
  end;

  TJsonX = class
  private
    // Helpers
    class function RTTIToJSONName(const RTTIName: string): string;
    class function FormatJsonValue(V: Variant): string;
    // Engine
    class procedure ObjectParser(aObj: TObject; aJsonObj: JsonDataObjects.TJsonObject;  SysParams: TJsonXSystemParameters; SysStatus: TJsonXSystemStatus; JsonXInternal: TJsonXInternal);
    class procedure ObjectWriter(aJsonObj: JsonDataObjects.TJsonObject; aObj: TObject; JsonPatcher: TJsonXPatcher; SysParams: TJsonXSystemParameters; SysStatus: TJsonXSystemStatus; JsonXInternal: TJsonXInternal);
  protected
    class function  InternalParser<T: class, constructor>(JsonStr: Pointer; Obj: TObject; SysParams: TJsonXSystemParameters; SysStatus: TJsonXSystemStatus): T; overload;
    class function  InternalWriter(var Obj: TObject; SysParams: TJsonXSystemParameters = Nil; SysStatus: TJsonXSystemStatus = Nil): string;
  public
    // Helpers
    class function  PropertiesNameValue(aObj: TObject) : TDictionary<string, Variant>;
    class function  PropertyNameEncode(const ToEncode: string): string;
    class function  PropertyNameDecode(const ToDecode: string): string;
    // Engine
    class function  Parser<T: class, constructor>(JsonStr: PString; SysParams: TJsonXSystemParameters = Nil; SysStatus: TJsonXSystemStatus = Nil): T; overload;
    class function  Parser<T: class, constructor>(JsonStr: string; SysParams: TJsonXSystemParameters = Nil; SysStatus: TJsonXSystemStatus = Nil): T; overload;
    class procedure Parser(Obj: TObject; JsonStr: string; SysParams: TJsonXSystemParameters = Nil; SysStatus: TJsonXSystemStatus = Nil); overload;
    class procedure Parser(Obj: TObject; JsonStr: PString; SysParams: TJsonXSystemParameters = Nil; SysStatus: TJsonXSystemStatus = Nil); overload;

    class function  Writer(PObj: PObject; SysParams: TJsonXSystemParameters = Nil; SysStatus: TJsonXSystemStatus = Nil): string; overload;
    class function  Writer(Obj: TObject; SysParams: TJsonXSystemParameters = Nil; SysStatus: TJsonXSystemStatus = Nil): string; overload;
  end;

{$ENDREGION}

{$REGION 'Interals Intf.'}

   function InitSysObjects(var SysParams: TJsonXSystemParameters; var SysStatus: TJsonXSystemStatus): Byte;
   procedure ExitSysObjects(Flag: Byte; var SysParams: TJsonXSystemParameters; var SysStatus: TJsonXSystemStatus);

{$ENDREGION}

implementation

uses Variants, SysUtils, uJsonX.Utils, DateUtils, System.Diagnostics, RTTI,
     uJsonX.RTTI, windows, Math;

{$REGION 'Helpers Impl.'}
{ Helpers }

function LenStr(var Str: string): Integer; inline;
begin
  Result :=  PInteger(@PByte(Str)[-4])^
end;

function BreakThread(Sys: TJsonXSystemParameters): Boolean; inline;
begin
  Result := (Sys.Thread <> Nil) and (Sys.Thread.CheckTerminated);
end;

{$ENDREGION}

{$REGION 'TJsonXAttr Impl.'}
{ AJsonXClassType }

constructor AJsonXClassType.Create(const AClassType: TClass);
begin
  FClassType := AClassType;
end;

{$ENDREGION}

{$REGION 'TJsonXPatcher Impl.'}

constructor TJsonXPatcher.Create(LowMemL2: Boolean);
begin
  FLowMemL2 := LowMemL2;
  FParts := TObjectList<TJsonXPatcherCtnr>.Create(True);
end;

destructor TJsonXPatcher.Destroy;
begin
  FParts.Free;
  inherited;
end;

procedure TJsonXPatcher.Decode(var JsonStr: string; SysParams: TJsonXSystemParameters; SysStatus: TJsonXSystemStatus);
begin
  if Assigned(SysStatus) then SysStatus.DecodeCount := FParts.Count;
  var Position :=  LenStr(JsonStr);
  try
    for var Idx := FParts.count - 1 downto 0 do
    begin
      Position := OnceFastReplaceStr(JsonStr, TJsonXPatcherCtnr(FParts[Idx]).Hdr, TJsonXPatcherCtnr(FParts[Idx]).Jsn, Position, True);
      FParts.Delete(Idx);
      if (Idx mod 100 = 0) and BreakThread(SysParams) then Exit;
    end;
  finally
    FParts.Clear;
  end;
end;

function TJsonXPatcher.Encode(JsonStr: string; Header: string = '"'; Footer: string = '"'): string;
begin
  Result  := StringGUID;
  var Part := TJsonXPatcherCtnr.Create;
  if Self.FLowMemL2 then
  begin
    Part.Hdr := Header + Result + Footer;
    Part.Jsn := JsonStr;
  end else begin
    var Len := LenStr(Header) + LenStr(Result) + LenStr(Footer) - LenStr(JsonStr);
    if Len > 0 then  JsonStr := JsonStr + StringOfChar(' ', Len)
    else
    if Len < 0 then  Result := Result + StringOfChar(' ', -Len);
    Part.Hdr := Header + Result + Footer;
    Part.Jsn := JsonStr;
  end;
  FParts.Add(Part);
end;

{$ENDREGION}

{$REGION 'TJsonX Impl.'}
{ TJsonStrContainer }

class function TJsonX.PropertyNameDecode(const ToDecode: string): string;
var
  Index: Integer;
  CharCode: Integer;
begin;

  if Pos('_', ToDecode, 1) = 0 then
  begin
    Result := ToDecode;
    exit;
  end;

  Index := 1;
  while (Index <= Length(ToDecode)) do
  begin
    if (ToDecode[Index] = '_') and
      TryStrToInt('$' + Copy(ToDecode, Index + 1, 2), CharCode) then
    begin
      Result := Result + Chr(CharCode);
      Inc(Index, 3);
    end
    else
    begin
      Result := Result + ToDecode[Index];
      Inc(Index, 1);
    end;
  end;
end;

class function TJsonX.PropertyNameEncode(const ToEncode: string): string;
begin
  Result := '';
  for var i := 1 to Length(ToEncode) do
    if CharInSet(ToEncode[i], ['0' .. '9', 'a' .. 'z', 'A' .. 'Z']) then
      Result := Result + ToEncode[i]
    else
    begin
      Result := Result + '_' + Format('%2x', [Ord(ToEncode[i])]);
    end;
end;

class function TJsonX.FormatJsonValue(V: Variant): string;

  function EscapeJSONStr(Str: string): string;
  begin
    Result := '';
    var P := PChar(Pointer(Str));
    var EndP := P + PInteger(@PByte(Str)[-4])^;
    while P < EndP do
    begin
      case P^ of
        #0 .. #31, '\', '"', '/':
          begin
            Result := Result + '\' + P^;
          end;
      else
        Result := Result + P^;
      end;
      Inc(P);
    end;
  end;

begin
  if VarIsStr(V) then
  begin
    Result := '"' + EscapeJSONStr(V) + '"';
  end
  else
    Result := VarToStr(V);
end;

class function TJsonX.RTTIToJSONName(const RTTIName: string): string;
begin
  Result := Copy(PropertyNameDecode(RTTIName), 2, MAXINT);
end;

function InitSysObjects(var SysParams: TJsonXSystemParameters; var SysStatus: TJsonXSystemStatus): Byte;
begin
  Result := 0;
  if SysParams = Nil then
  begin
    SysParams := TJsonXSystemParameters.Create;
    Result := 1;
  end;
  if SysStatus = Nil then
  begin
    //SysStatus := TJsonXSystemStatus.Create;
    //Result := Result + 2;
  end;
end;

procedure ExitSysObjects(Flag: Byte; var SysParams: TJsonXSystemParameters; var SysStatus: TJsonXSystemStatus);
begin
  if Flag and 1 = 1 then FreeAndNil(SysParams);
  if Flag and 2 = 2 then FreeAndNil(SysStatus);
end;

class procedure TJsonX.ObjectParser(
                    aObj: TObject; aJsonObj:
                    JsonDataObjects.TJsonObject;
                    SysParams: TJsonXSystemParameters;
                    SysStatus: TJsonXSystemStatus;
                    JsonXInternal: TJsonXInternal
                );
begin
  if (aJsonObj = Nil) or BreakThread(SysParams) then exit;
  if Assigned(SysStatus) then Inc(SysStatus.OpsCount);
  var  Fields := GetFields(aObj);

  for var JIdx := aJsonObj.count - 1 downto 0 do
  begin
    var JValue := aJsonObj.Items[JIdx];
    var JName := aJsonObj.Names[JIdx];
    var ValueToRTTIFound := False;
    for var RIdx := 0 to Length(Fields) - 1 do
    begin
      var RTTIField := Fields[RIdx];

      var RName: string := RTTIField.Name;
      if (PChar(Pointer(RName))^ = 'F') then
        if JName = RTTIToJSONName(RName) then
        begin

          ValueToRTTIFound := True;
          if RTTIField.FieldType.TypeKind in [tkVariant] then
          begin
            if (JValue.Typ = jdtString) then
            begin
              if (JValue.DateTimeValue <> 0) then
              begin
                RTTIField.SetValue(aObj, TValue(JValue.DateTimeValue));
              end else
                RTTIField.SetValue(aObj, TValue(JValue.Value));
            end
            else
              RTTIField.SetValue(aObj, TValue.FromVariant(JValue.VariantValue));
            if (jxoReadLowMemory in SysParams.Options) then aJsonObj.delete(JIdx);
            if Assigned(SysStatus) then Inc(SysStatus.VarCount);
            Break;
          end
          else if RTTIField.FieldType.TypeKind in [tkClass] then
          begin
            var Instance := RTTIField.FieldType.AsInstance;

            if Instance.MetaclassType = TJsonXVarObjDicType then
            begin
              if Assigned(SysStatus) then Inc(SysStatus.VarObjDicCount);
              var Attr := GetFieldAttribute(RTTIField, AJsonXClassType);
              if Attr <> Nil then
              begin
                var AttrType := AJsonXClassType(Attr).FClassType;
                var NewObj := TJsonXVarObjDicType.Create([doOwnsValues]);
                RTTIField.SetValue(aObj, NewObj);
                var ObjArr := JValue.ObjectValue;
                {$IF CompilerVersion >= 34.0} // 10.4 Sydney
                NewObj.Capacity := ObjArr.count;
                {$ENDIF}
                var isV3 := AttrType.ClassParent = TJsonXBaseEx3Type;
                for var Pair in ObjArr do
                begin
                  var
                  SubObj := AttrType.Create;
                  if isV3 then TJsonXBaseEx3Type(SubObj).InitCreate;
                  NewObj.Add(Pair.Name, SubObj);
                  ObjectParser(SubObj, Pair.Value.ObjectValue, SysParams, SysStatus, JsonXInternal);
                end;
              end
              else if (jxoWarnOnMissingField in SysParams.Options) then
                BreakPoint
                  (Format('TJsonXVarObjDicType %s has no AJsonXClassType Attribute',
                  [RTTIField.Name]));
              if (jxoReadLowMemory in SysParams.Options) then aJsonObj.delete(JIdx);
              Break;
            end
            else

            if Instance.MetaclassType = TJsonXObjListType then
            begin
              if Assigned(SysStatus) then Inc(SysStatus.ObjListCount);
              var Attr := GetFieldAttribute(RTTIField, AJsonXClassType);
              if Attr <> Nil then
              begin
                var AttrType := AJsonXClassType(Attr).FClassType;
                var NewObj := TJsonXObjListType.Create(True);
                RTTIField.SetValue(aObj, NewObj);
                var Arr := JValue.ArrayValue;
                NewObj.Capacity := Arr.count;
                var isV3 := AttrType.ClassParent = TJsonXBaseEx3Type;
                for var i := 0 to Arr.count - 1 do
                begin
                  var
                  TypedObj := AttrType.Create;
                  if isV3 then TJsonXBaseEx3Type(TypedObj).InitCreate;
                  NewObj.Add(TypedObj);
                  ObjectParser(TypedObj, Arr.O[i], SysParams, SysStatus,JsonXInternal);
                end;
              end
              else if (jxoWarnOnMissingField in SysParams.Options) then
                BreakPoint
                  (Format('TJsonXObjListType %s has no AJsonXClassType Attribute',
                  [RTTIField.Name]));
              if (jxoReadLowMemory in SysParams.Options) then aJsonObj.delete(JIdx);
              Break;
            end
            else

            if Instance.MetaclassType = TJsonXVarListType then
            begin
              if Assigned(SysStatus) then Inc(SysStatus.VarListCount);
              var NewObj := TJsonXVarListType.Create;
              RTTIField.SetValue(aObj, NewObj);
              var Arr := JValue.ArrayValue;
              NewObj.Capacity := Arr.count;
              for var i := 0 to Arr.count - 1 do
              begin
                NewObj.Add(Arr.V[i]);
              end;
              if (jxoReadLowMemory in SysParams.Options) then aJsonObj.delete(JIdx);
              Break;
            end
            else

            if Instance.MetaclassType = TJsonXVarVarDicType then
            begin
              if Assigned(SysStatus) then Inc(SysStatus.VarVarDicCount);
              var NewObj := TJsonXVarVarDicType.Create;
              RTTIField.SetValue(aObj, NewObj);
              var
              VVDic := JValue.ObjectValue;
              for var vv := 0 to VVDic.count - 1 do
              begin
                NewObj.Add(VVDic.Names[vv], VVDic.Values[VVDic.Names[vv]]);
              end;
              if (jxoReadLowMemory in SysParams.Options) then aJsonObj.delete(JIdx);
              Break;
            end
            else

            begin
              if Assigned(SysStatus) then Inc(SysStatus.ObjCount);
              var NewObj := Instance.GetMethod('Create').Invoke(Instance.MetaclassType, []).AsObject;
              if NewObj.ClassParent = TJsonXBaseEx3Type then TJsonXBaseEx3Type(NewObj).InitCreate;
              RTTIField.SetValue(aObj, NewObj);
              ObjectParser(NewObj, JValue.ObjectValue, SysParams, SysStatus, JsonXInternal);
              if (jxoReadLowMemory in SysParams.Options) then aJsonObj.delete(JIdx);
              Break;
            end;
            RTTIField.GetValue(aObj).AsObject.Free;
          end
          else
          begin
            BreakPoint
              (Format('The Property " F%s " must be a variant or an object in class : %s',
              [PropertyNameEncode(JName), aObj.ClassName]));
          end;
        end;
    end;
    if not ValueToRTTIFound then
    begin
      aJsonObj.delete( aJsonObj.Count -1 );
      if (jxoWarnOnMissingField in SysParams.Options) then
        BreakPoint(Format('The Property " F%s " is missing in class : %s', [PropertyNameEncode(JName), aObj.ClassName]));
    end;
  end;
end;

class function TJsonX.InternalParser<T>(JsonStr: Pointer; Obj: TObject; SysParams: TJsonXSystemParameters; SysStatus: TJsonXSystemStatus): T;
begin
  Result := Nil;
  if JsonStr = Nil then Exit;
  if not (jxoReturnEmptyObject in SysParams.Options) and (PString(JsonStr)^ = '') then Exit;
  if (SysStatus <> Nil) then SysStatus.OpsCount := 0;
  var JsonObj: TJsonBaseObject := Nil;
  try
    var JsonXInternal := TJsonXInternal.Create;
    try
      var Watch2 := TStopWatch.StartNew;
      JsonObj := JsonDataObjects.TJsonObject.Parse(PString(JsonStr)^);
      if jxoReadLowMemory in SysParams.Options then PString(JsonStr)^ := '';
      if assigned(SysStatus) then SysStatus.ProcessJsonMS := Watch2.ElapsedMilliseconds;
      Watch2.Reset; Watch2.Start;
      if BreakThread(SysParams) then Exit;
      if Obj = Nil then
      begin
        Obj := T.Create;
        ObjectParser(TObject(Obj), JsonDataObjects.TJsonObject(JsonObj), SysParams, SysStatus, JsonXInternal);
        if BreakThread(SysParams) then FreeAndNil(Obj);
        Result := T(Obj);
      end else begin
        ObjectParser(TObject(Obj), JsonDataObjects.TJsonObject(JsonObj), SysParams, SysStatus, JsonXInternal);
        if BreakThread(SysParams) then FreeAndNil(Obj);
        Result := Nil;
      end;
      if assigned(SysStatus) then SysStatus.ProcessObjectMS := Watch2.ElapsedMilliseconds;
    finally
      JsonDataObjects.TJsonObject(JsonObj).Free;
      JsonXInternal.Free;
    end;
  except
    on Ex: Exception do
    begin
      FreeAndNil(Obj);
      if (jxoRaiseException in SysParams.Options) then raise Ex;
    end;
  end;
end;

class function TJsonX.Parser<T>(JsonStr: string; SysParams: TJsonXSystemParameters; SysStatus: TJsonXSystemStatus): T;
begin
  var Watch := TStopWatch.StartNew;
  var Flag := InitSysObjects(SysParams, SysStatus);
  if (SysStatus <> Nil) then SysStatus.Clear;
  var SavedOptions := SysParams.Options;
  Exclude(SysParams.Options, jxoReadLowMemory);
  Result := TJsonX.InternalParser<T>(@JsonStr, Nil, SysParams, SysStatus);
  SysParams.Options := SavedOptions;
  ExitSysObjects(Flag, SysParams, SysStatus);
  if Assigned(SysStatus) then SysStatus.DurationMS := Watch.ElapsedMilliseconds;
end;

class function TJsonX.Parser<T>(JsonStr: PString; SysParams: TJsonXSystemParameters = Nil; SysStatus: TJsonXSystemStatus = Nil): T;
begin
  var Watch := TStopWatch.StartNew;
  var Flag := InitSysObjects(SysParams, SysStatus);
  if (SysStatus <> Nil) then SysStatus.Clear;
  var SavedOptions := SysParams.Options;
  Include(SysParams.Options, jxoReadLowMemory);
  Result := TJsonX.InternalParser<T>(JsonStr, Nil, SysParams, SysStatus);
  SysParams.Options := SavedOptions;
  ExitSysObjects(Flag, SysParams, SysStatus);
  if Assigned(SysStatus) then SysStatus.DurationMS := Watch.ElapsedMilliseconds;
end;

class procedure TJsonX.Parser(Obj: TObject; JsonStr: string; SysParams: TJsonXSystemParameters; SysStatus: TJsonXSystemStatus);
begin
  var Watch := TStopWatch.StartNew;
  var Flag := InitSysObjects(SysParams, SysStatus);
  if (SysStatus <> Nil) then SysStatus.Clear;
  var SavedOptions := SysParams.Options;
  Exclude(SysParams.Options, jxoReadLowMemory);
  TJsonX.InternalParser<TObject>(@JsonStr, Obj, SysParams, SysStatus);
  SysParams.Options := SavedOptions;
  ExitSysObjects(Flag, SysParams, SysStatus);
  if Assigned(SysStatus) then SysStatus.DurationMS := Watch.ElapsedMilliseconds;
end;

class procedure TJsonX.Parser(Obj: TObject; JsonStr: PString; SysParams: TJsonXSystemParameters; SysStatus: TJsonXSystemStatus);
begin
  var Watch := TStopWatch.StartNew;
  var Flag := InitSysObjects(SysParams, SysStatus);
  if (SysStatus <> Nil) then SysStatus.Clear;
  var SavedOptions := SysParams.Options;
  Include(SysParams.Options, jxoReadLowMemory);
  TJsonX.InternalParser<TObject>(JsonStr, Obj, SysParams, SysStatus);
  SysParams.Options := SavedOptions;
  ExitSysObjects(Flag, SysParams, SysStatus);
  if Assigned(SysStatus) then SysStatus.DurationMS := Watch.ElapsedMilliseconds;
end;

class procedure TJsonX.ObjectWriter(
                    aJsonObj: JsonDataObjects.TJsonObject;
                    aObj: TObject;
                    JsonPatcher: TJsonXPatcher;
                    SysParams: TJsonXSystemParameters;
                    SysStatus: TJsonXSystemStatus;
                    JsonXInternal: TJsonXInternal
                );
begin
  if (aObj = nil) or BreakThread(SysParams) then exit;
  if Assigned(SysStatus) then Inc(SysStatus.OpsCount);
  var Fields := GetFields(aObj);
  aJsonObj.Capacity := Length(Fields) + 1;
   for var RTTIField in Fields do
  begin
    var RN := RTTIField.Name;
    if (PChar(Pointer(RN))^ = 'F') then
    if RTTIField.FieldType.TypeKind in [tkVariant] then
    begin

      var V := RTTIField.GetValue(aObj).AsVariant;
      var N := RTTIToJSONName(RN);

      case FindVarData(V)^.VType of
        varEmpty:
        begin
          if Assigned(SysStatus) then Inc(SysStatus.NullVarCount);
          if jxoUnassignedAsNull in SysParams.Options then aJsonObj.InternAddItem(N).VariantValue := Null;
        end;
		varNull:
        begin
          if Assigned(SysStatus) then Inc(SysStatus.NullVarCount);
		      aJsonObj.InternAddItem(N).VariantValue := Null;
        end;
        varOleStr, varString, varUString:
          aJsonObj.InternAddItem(N).Value := (V);
        varSmallInt, varInteger, varShortInt, varByte, varWord, varLongWord:
          aJsonObj.InternAddItem(N).IntValue := (V);
        varDate:
          aJsonObj.InternAddItem(N).DateTimeValue := (V);
        varBoolean:
          aJsonObj.InternAddItem(N).BoolValue := (V);
        varInt64:
          aJsonObj.InternAddItem(N).LongValue := (V);
        varUInt64:
          aJsonObj.InternAddItem(N).ULongValue := (V);
        varSingle, varDouble, varCurrency:
          aJsonObj.InternAddItem(N).FloatValue := (V);
      else
        BreakPoint(Format(
                      'ObjectWriter : Invalid variant Type : %s %s  %d',
                      [aObj.ClassName, N, FindVarData(V)^.VType]
                  ));
      end;

      if (jxoWriteLowMemory in SysParams.Options) then
        RTTIField.SetValue(aObj, TValue.FromVariant(Unassigned));
      if Assigned(SysStatus) then Inc(SysStatus.VarCount);
      Continue
    end
    else if (RTTIField.FieldType.TypeKind in [tkClass]) and not(jxoPropertiesOnly in SysParams.Options) then
    begin
      var Objct := RTTIField.GetValue(aObj).AsObject;
      if Objct = Nil then Continue;

      if Objct.ClassType = TJsonXObjListType then
      begin
        if Assigned(SysStatus) then Inc(SysStatus.ObjListCount);
        var Olist := TJsonXObjListType(Objct);
        var SL := TStringList.Create(#0, ',', [soStrictDelimiter]);
        SL.Capacity := Olist.count + 1;
        var JsonObj := JsonDataObjects.TJsonObject(JsonDataObjects.TJsonObject.NewInstance);
        for var O in Olist do
        begin
          JsonObj.Clear;
          ObjectWriter(JsonObj, O, JsonPatcher, SysParams, SysStatus, JsonXInternal);
          SL.Add(JsonObj.ToJSON(True));
        end;
        JsonObj.Free;
        var N := RTTIToJSONName(RTTIField.Name);
        aJsonObj.InternAddItem(N).Value := JsonPatcher.Encode('[' + SL.DelimitedText + ']');
        SL.Free;
        if (jxoWriteLowMemory in SysParams.Options) then begin FreeAndNil(Objct); RTTIField.SetValue(aObj, Nil); end;
      end
      else

      if Objct.ClassType = TJsonXVarListType then
      begin
        if Assigned(SysStatus) then Inc(SysStatus.VarListCount);
        var Vlist := TJsonXVarListType(Objct);
        var SL := TStringList.Create(#0, ',', [soStrictDelimiter]);
        SL.Capacity := Vlist.count + 1;
        for var V in Vlist do
          SL.Add(FormatJsonValue(V));
        var N := RTTIToJSONName(RTTIField.Name);
        aJsonObj.AddItem(N).Value := JsonPatcher.Encode('"' + N + '":[' + SL.DelimitedText + ']', '"' + N + '":"', '"');
        SL.Free;
        if (jxoWriteLowMemory in SysParams.Options) then begin FreeAndNil(Objct); RTTIField.SetValue(aObj, Nil); end;
      end
      else

      if Objct.ClassType = TJsonXVarVarDicType then
      begin
        if Assigned(SysStatus) then Inc(SysStatus.VarVarDicCount);
        var VDic := TJsonXVarVarDicType(Objct);
        var SL := TStringList.Create(#0, ',', [soStrictDelimiter]);
        SL.Capacity := VDic.count + 1;
        for var V in VDic do
          SL.Add(FormatJsonValue(V.Key) + ':' + FormatJsonValue(V.Value));
        var N := RTTIToJSONName(RTTIField.Name);
        aJsonObj.InternAddItem(N).Value := JsonPatcher.Encode('{' + SL.DelimitedText + '}');
        SL.Free;
        if (jxoWriteLowMemory in SysParams.Options) then begin FreeAndNil(Objct); RTTIField.SetValue(aObj, Nil); end;
      end
      else

      if Objct.ClassType = TJsonXVarObjDicType then
      begin
        if Assigned(SysStatus) then Inc(SysStatus.VarObjDicCount);
        var VDic := TJsonXVarObjDicType(Objct);
        var SL := TStringList.Create(#0, ',', [soStrictDelimiter]);
        SL.Capacity := VDic.count + 1;
        var JsonObj := JsonDataObjects.TJsonObject(JsonDataObjects.TJsonObject.NewInstance);
        for var kv in VDic do
        begin
          JsonObj.Clear;
          ObjectWriter(JsonObj, kv.Value, JsonPatcher, SysParams, SysStatus, JsonXInternal);
          var JsonStr := JsonObj.ToJSON(True);
          SL.Add('"' + (kv.Key) + '":' + JsonStr);
        end;
        JsonObj.Free;
        var N := RTTIToJSONName(RTTIField.Name);
        aJsonObj.AddItem(N).Value := JsonPatcher.Encode('"' + N + '":{' + SL.DelimitedText + '}', '"' + N + '":"', '"');
        SL.Free;
        if (jxoWriteLowMemory in SysParams.Options) then begin FreeAndNil(Objct); RTTIField.SetValue(aObj, Nil); end;
      end
      else

      begin
        if Assigned(SysStatus) then Inc(SysStatus.ObjCount);
        var JsonObj := JsonDataObjects.TJsonObject(JsonDataObjects.TJsonObject.NewInstance);
        ObjectWriter(JsonObj, Objct, JsonPatcher, SysParams, SysStatus, JsonXInternal);
        var JsonStr := JsonObj.ToJSON(True);
        var N := RTTIToJSONName(RTTIField.Name);
        aJsonObj.InternAddItem(N).Value := JsonPatcher.Encode(JsonStr);
        JsonStr := ''; JsonObj.Free;
      end;

      if (jxoWriteLowMemory in SysParams.Options) then begin FreeAndNil(Objct); RTTIField.SetValue(aObj, Nil); end;
      Continue;

    end;
  end;
end;

class function TJsonX.InternalWriter(var Obj: TObject; SysParams: TJsonXSystemParameters; SysStatus: TJsonXSystemStatus): string;
begin
  if (SysStatus <> Nil) then SysStatus.Clear;

  Result := '';
  if Obj = Nil then Exit;
  if Assigned(SysStatus) then SysStatus.OpsCount := 0;
  var JsonObj := JsonDataObjects.TJsonObject(JsonDataObjects.TJsonObject.NewInstance);
  var JsonXInternal := TJsonXInternal.Create;
  var JsonPatcher := TJsonXPatcher.Create(jxoWriteLowMemory_Level2_EXPERIMENTAL in SysParams.Options);
  var Watch2 := TStopWatch.StartNew;
  try
    ObjectWriter(JsonObj, Obj, JsonPatcher, SysParams, SysStatus, JsonXInternal);
    if (jxoWriteLowMemory in SysParams.Options) then FreeAndNil(Obj);
    if BreakThread(SysParams) then Exit;
    if assigned(SysStatus) then SysStatus.ProcessObjectMS := Watch2.ElapsedMilliseconds;
    Watch2.Reset; Watch2.Start;
    Result := JsonObj.ToJSON(True);
    if assigned(SysStatus) then SysStatus.ProcessJsonMS := Watch2.ElapsedMilliseconds;
    FreeAndNil(JsonObj);
    Watch2.Reset; Watch2.Start;
    JsonPatcher.Decode(Result, SysParams, SysStatus);
    if assigned(SysStatus) then SysStatus.DecodeMS := Watch2.ElapsedMilliseconds;
    if BreakThread(SysParams) then Result := '';
  finally
    FreeAndNil(JsonObj);
    FreeAndNil(JsonPatcher);
    FreeAndNil(JsonXInternal);
  end;
end;


class function TJSonX.Writer(PObj: PObject; SysParams: TJsonXSystemParameters = Nil; SysStatus: TJsonXSystemStatus = Nil): string;
begin
  var Watch := TStopWatch.StartNew;
  var Flag := InitSysObjects(SysParams, SysStatus);
  if (SysStatus <> Nil) then SysStatus.Clear;
  var SavedOptions := SysParams.Options;
  Include(SysParams.Options, jxoWriteLowMemory);
  Result := TJsonX.InternalWriter(PObj^, SysParams, SysStatus);
  SysParams.Options := SavedOptions;
  ExitSysObjects(Flag, SysParams, SysStatus);
  if Assigned(SysStatus) then SysStatus.DurationMS := Watch.ElapsedMilliseconds;
end;

class function TJsonX.Writer(Obj: TObject; SysParams: TJsonXSystemParameters; SysStatus: TJsonXSystemStatus): string;
begin
  var Watch := TStopWatch.StartNew;
  var Flag := InitSysObjects(SysParams, SysStatus);
  if (SysStatus <> Nil) then SysStatus.Clear;
  var SavedOptions := SysParams.Options;
  Exclude(SysParams.Options, jxoWriteLowMemory);
  Result := TJsonX.InternalWriter(Obj, SysParams, SysStatus);
  SysParams.Options := SavedOptions;
  ExitSysObjects(Flag, SysParams, SysStatus);
  if Assigned(SysStatus) then SysStatus.DurationMS := Watch.ElapsedMilliseconds;
end;

class function TJsonX.PropertiesNameValue(aObj: TObject): TDictionary<string, Variant>;
begin
  Result := TDictionary<string, Variant>.Create;
  var
  Fields := GetFields(aObj);
  for var Field in Fields do
    if Field.FieldType.TypeKind in [tkVariant] then
      Result.Add(RTTIToJSONName(Field.Name), Field.GetValue(aObj).AsVariant);
end;

{$ENDREGION}

end.


