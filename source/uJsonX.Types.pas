unit uJsonX.Types;

///
///  Author:  Laurent Meyer
///  Contact: HS1x0@ea4d.com
///
///  https://github.com/bnzbnz/Delphi-TP-Link-HS1x0-Protocol
///
///  License: MPL 1.1 / GPL 2.1
///

interface
uses  System.Generics.Collections, Classes;

type

  TJsonXParsingOption = (
    jxoReturnEmptyObject,
    jxoWarnOnMissingField,
    jxoRaiseException,
    jxoPropertiesOnly,
    // INTERNAL
    jxoReadLowMemory,
    jxoWriteLowMemory,
    jxoWriteLowMemory_Level2_EXPERIMENTAL // Hyper memory efficient... Hyper slow :(
  );
  TJsonXParsingOptions = set of TJsonXParsingOption;

  TJsonXSystemParameters = class(TObject)
    Thread:  TThread;
    Options: TJsonXParsingOptions;
    constructor Create(aThread: TThread = Nil; aOptions: TJsonXParsingOptions = []); overload;
    destructor Destroy; override;
    procedure Clear;
  end;

  TJsonXSystemStatus = class
  public
    OpsCount: NativeInt;
    ProcessJsonMS: Int64;
    ProcessObjectMS: Int64;
    DurationMS: Int64;
    VarCount: Int64;
    NilVarCount: Int64;
    ObjCount: Int64;
    ObjListCount: Int64;
    VarListCount: Int64;
    VarObjDicCount: Int64;
    VarVarDicCount: Int64;
    DecodeCount: Int64;
    DecodeMs: Int64;
    procedure Clear;
  end;

 // Json eXtended Classes

  TJsonXBaseType      = class(TObject)
  end;

  TJsonXVarListType   = class;
  TJsonXVarListType   = class(TList<variant>)
    function CLone: TJsonXVarListType;
  end;

  TJsonXObjListType   = class(TObjectList<TObject>); // Requires AJsonXClassType Attribute(Object class type)
  TJsonXVarVarDicType = class(TDictionary<variant, variant>);
  TJsonXVarObjDicType = class(TObjectDictionary<variant, TObject>);  // Requires AJsonXClassType Attribute(Object class type)

  TJsonXBaseExType = class(TJsonXBaseType)
  public
    //class function NewInstance: TObject; override;
    //procedure FreeInstance; override;
    procedure ClonePropertiesTo(T : TJsonXBaseExType); virtual;
    function Clone: TJsonXBaseExType; virtual;
  end;

  TJsonXBaseEx2Type = class(TJsonXBaseExType)
  public
    destructor Destroy; override;
  end;

  TJsonXBaseEx3Type = class(TJsonXBaseEx2Type)
  protected
    RTTIID: Integer;
  public
    constructor Create; overload;
    procedure InitCreate; virtual; abstract;
  end;

implementation
uses RTTI, uJsonX.RTTI, SysUtils, Variants;


function TJsonXVarListType.CLone: TJsonXVarListType;
begin
  Result := TJsonXVarListType.create;
  for var v in Self do Result.add(v);
end;

{ TJsonXSystemParameters }

procedure TJsonXSystemParameters.Clear;
begin
  Thread := Nil;
  Options := [];
end;

constructor TJsonXSystemParameters.Create(aThread: TThread = Nil; aOptions: TJsonXParsingOptions = []);
begin
  inherited Create;
  Thread := aThread;
  Options := aOptions;
end;

destructor TJsonXSystemParameters.Destroy;
begin
  inherited;
end;

{ TJsonXBaseExType}

(*
class function TJsonXBaseExType.NewInstance: TObject;
begin
  GetMem(Pointer(Result), InstanceSize);
  PPointer(Result)^ := Self;
end;

procedure TJsonXBaseExType.FreeInstance;
begin
  // We have no WeakRef => faster cleanup
  FreeMem(Pointer(Self));
end;
*)


{ TJsonXBaseExType2 }

destructor TJsonXBaseEx2Type.Destroy;
begin
  for var RTTIField in uJsonX.RTTI.GetFields(Self) do
    if RTTIField.FieldType.TypeKind in [tkClass] then
      RTTIField.GetValue(Self).AsObject.Free;
  inherited;
end;

{ TJsonXBaseEx3Type }

constructor TJsonXBaseEx3Type.Create;
begin
  Inherited Create;
  InitCreate;
end;


{ TJsonXSystemStatus }

procedure TJsonXSystemStatus.Clear;
begin
  OpsCount := 0;
  ProcessJsonMS := 0;
  ProcessObjectMS := 0;
  DurationMS := 0;
  VarCount := 0;
  ObjCount := 0;
  VarObjDicCount := 0;
  ObjListCount := 0;
  VarListCount := 0;
  VarVarDicCount := 0;
  NilVarCount := 0;
  DecodeCount := 0;
  DecodeMs := 0;
end;

{ TJsonXBaseExType }

function TJsonXBaseExType.Clone: TJsonXBaseExType;
begin
  Result := TJsonXBaseExType(Self.ClassType.Create);
  Self.ClonePropertiesTo(Result);
end;

procedure TJsonXBaseExType.ClonePropertiesTo(T: TJsonXBaseExType);
begin
  if T = nil then exit;
  var rttictx := TRttiContext.Create();
  var rttitype := rttictx.GetType(Self.ClassType);
  for var field in rttitype.GetFields do
    if field.FieldType.TypeKind = tkVariant then
    begin
      var v :=  field.GetValue(Self);
      if not VarIsEmpty(v.AsVariant) then field.SetValue(T, v);
    end else
    if field.FieldType.TypeKind in [tkClass] then
      begin
        var Instance := field.FieldType.AsInstance;

       if Instance.MetaclassType = TJsonXVarListType then
         field.SetValue(T,  TJsonXVarListType(field.GetValue(Self).AsObject).Clone)
       else
         asm int 3 end; // TODO: Missing Type Cloning


      end;
  rttictx.Free;
end;

end.

