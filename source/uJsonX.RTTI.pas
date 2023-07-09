unit uJsonX.RTTI;

interface
uses RTTI, System.Generics.Collections, SyncObjs;

{$DEFINE EA4DRTTICACHE}

function  GetFields(aObj: TObject): TArray<TRTTIField>;
function  GetProps(aObj: TObject): TArray<TRTTIProperty>;
function  GetFieldAttribute(Field: TRTTIField; AttrClass: TClass): TCustomAttribute;
function  GetFieldInstance(Field: TRTTIField) : TRttiInstanceType;

{$IFDEF EA4DRTTICACHE}
var
  _RTTIFieldsCacheDic: TDictionary<TClass, TArray<TRttiField>>;
  _RTTIPropsCacheDic: TDictionary<TClass, TArray<TRTTIProperty>>;
  _RTTIAttrsCacheDic: TDictionary<TRTTIField, TCustomAttribute>;
  _RTTIInstCacheDic: TDictionary<TRTTIField, TRttiInstanceType>;
  _RTTIctx: TRttiContext;
  _JRTTICache: array[0..65535] of TArray<TRttiField>;
  _FielddLock : TCriticalSection;

{$ELSE}
var
  _RTTIctx: TRttiContext;
{$ENDIF}

implementation
uses uJsonX.Types;

type
  MyTJsonXBaseEx3Type = class(TJsonXBaseEx3Type);

function GetFields(aObj: TObject): TArray<TRTTIField>;
begin
{$IFDEF EA4DRTTICACHE}
  if aObj is TJsonXBaseEx3Type then
  begin
    var RTTIID := MyTJsonXBaseEx3Type(aObj).RTTIID;
    if  RTTIID > 0  then
    begin
      _FielddLock.Enter;
      Result := _JRTTICache[RTTIID];
      if Result = nil then
      begin
        Result := _RTTIctx.GetType(aObj.ClassType).GetFields;
        _JRTTICache[RTTIID] := Result;
      end;
      _FielddLock.Leave;
      Exit;
    end;
  end;

  var CType :=aObj.ClassType;
  MonitorEnter(_RTTIFieldsCacheDic);
  if not _RTTIFieldsCacheDic.TryGetValue(CType, Result) then
  begin
    Result :=  _RTTIctx.GetType(CType).GetFields;
    _RTTIFieldsCacheDic.Add(CType, Result);
  end;
  MonitorExit(_RTTIFieldsCacheDic);
{$ELSE}
  Result := _RTTIctx.GetType(aObj.ClassType).GetFields;
{$ENDIF}
end;

function GetProps(aObj: TObject): TArray<TRTTIProperty>;
begin
  var CType :=aObj.ClassType;
{$IFDEF EA4DRTTICACHE}
  MonitorEnter(_RTTIPropsCacheDic);
  if not _RTTIPropsCacheDic.TryGetValue(CType, Result) then
  begin
    Result :=  _RTTIctx.GetType(CType).GetProperties;
    _RTTIPropsCacheDic.Add(CType, Result);
  end;
  MonitorExit(_RTTIPropsCacheDic);
{$ELSE}
  Result := _RTTIctx.GetType(CType).GetProperties;
{$ENDIF}
end;

function GetFieldAttribute(Field: TRTTIField; AttrClass: TClass): TCustomAttribute;

  function GetRTTIFieldAttribute(RTTIField: TRTTIField; AttrClass: TClass): TCustomAttribute;
  begin
  {$IF CompilerVersion >= 35.0} // Alexandria 11.0
    Result := RTTIField.GetAttribute(TCustomAttributeClass(AttrClass));
  {$ELSE}
    Result := Nil;
    for var Attr in RTTIField.GetAttributes do
      if Attr.ClassType = AttrClass then
      begin
          Result := Attr;
          Break;
      end;
  {$IFEND}
  end;

begin
{$IFDEF EA4DRTTICACHE}
  MonitorEnter(_RTTIAttrsCacheDic);
  if not _RTTIAttrsCacheDic.TryGetValue(Field, Result) then
  begin
    Result := GetRTTIFieldAttribute(Field, AttrClass);
    _RTTIAttrsCacheDic.Add(Field, Result);
  end;
  MonitorExit(_RTTIAttrsCacheDic);
{$ELSE}
    Result := GetRTTIFieldAttribute(Field, AttrClass);
{$ENDIF}
end;

function  GetFieldInstance(Field: TRTTIField) : TRttiInstanceType;
begin
{$IFDEF EA4DRTTICACHE}
  MonitorEnter(_RTTIInstCacheDic);
  if not _RTTIInstCacheDic.TryGetValue(Field, Result) then
  begin
    Result := Field.FieldType.AsInstance;
    _RTTIInstCacheDic.Add(Field, Result);
  end;
  MonitorExit(_RTTIInstCacheDic);
{$ELSE}
  Result := Field.FieldType.AsInstance;
{$ENDIF}
end;

initialization
{$IFDEF EA4DRTTICACHE}
  _RTTIFieldsCacheDic := TDictionary<TClass, TArray<TRttiField>>.Create;
  _RTTIPropsCacheDic := TDictionary<TClass, TArray<TRttiProperty>>.Create;
  _RTTIAttrsCacheDic := TDictionary<TRTTIField, TCustomAttribute>.Create;
  _RTTIInstCacheDic := TDictionary<TRTTIField, TRttiInstanceType>.Create;
  for var i :=0 to 65535 do _JRTTICache[i] := Nil;
  _FielddLock := TCriticalSection.Create;

{$ENDIF}
finalization
{$IFDEF EA4DRTTICACHE}
  _FielddLock.Free;
  _RTTIInstCacheDic.Free;
  _RTTIAttrsCacheDic.Free;
  _RTTIPropsCacheDic.Free;
  _RTTIFieldsCacheDic.Free;
{$ENDIF}
end.
