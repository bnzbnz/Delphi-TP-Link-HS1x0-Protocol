unit uHS110DemoExt;

interface
uses Classes, System.Generics.Collections;

type

  THS1x0Discovery = class;
  THS1x0ScannedCallback = procedure;
  THS1x0FoundCallback = procedure(nIP: Cardinal);

  TDiscoveryThread = class(TThread)
  public
    Index: integer;
    IP: string;
    ScanNumTh: Integer;
    StartIP, EndIP: Integer;
    FOnScanned: THS1x0ScannedCallback;
    FOnFound: THS1x0FoundCallback;
    procedure Execute; override;
  end;

  THS1x0Discovery = class(TObject)
  public
    FOnScanned: THS1x0ScannedCallback;
    FOnFound: THS1x0FoundCallback;
    ScannedCnt: Integer;
    ScanThreadList: TObjectList<TDiscoveryThread>;
    procedure   Start;
    procedure   Stop;
    constructor Create; overload;
    destructor  Destroy; override;
    property    OnScanned: THS1x0ScannedCallback read FOnScanned write FOnScanned;
    property    OnFound: THS1x0FoundCallback read FOnFound write FOnFound;
  end;

implementation
uses uHS1x0, uNetUtils;

constructor THS1x0Discovery.Create;
begin
  inherited;
  ScanThreadList := TObjectList<TDiscoveryThread>.Create(False);
end;

destructor THS1x0Discovery.Destroy;
begin
  Stop;
  ScanThreadList.Free;
  inherited;
end;

procedure THS1x0Discovery.Start;
begin
  var NumThread := 4;
  if DebugHook = 0 then NumThread := 64;
  for var i := 0 to NumThread - 1 do
  begin
    var Th := TDiscoveryThread.Create(True);
    Th.Priority := tpIdle;
    Th.FreeOnTerminate := False;
    TH.StartIP :=  i * (256 div NumThread);
    TH.EndIP := (i + 1) * (256 div NumThread) - 1;
    TH.FOnScanned := FOnScanned;
    TH.FOnFound := FOnFound;
    ScanThreadList.Add(Th);
    Th.Start;
  end;
end;

procedure THS1x0Discovery.Stop;
begin
  for var Th in ScanThreadList do
    Th.Terminate;
  for var Th in ScanThreadList do
  begin
    Th.WaitFor;
    Th.Free;
  end;
  ScanThreadList.Clear;
end;

procedure TDiscoveryThread.Execute;
begin
  var BaseIp := StrToIpAddr(LocalIP) and $FFFFFF00; // Class C
  for var i := StartIP to EndIP do
  begin
    if Terminated then
    begin
      Terminate;
      exit;
    end;
    IP := IpAddrToStr(BaseIP + Abs(i));
    Synchronize( procedure begin  if assigned(FOnScanned) then FOnScanned; ; end );
    var HS110 := THS1x0.Create(IP);
    if HS110 <> Nil then
    begin
      if HS110.ping then
        Synchronize( procedure begin if assigned(FOnFound) then FOnFound(BaseIP + Abs(i)); end );
      HS110.Free;
    end;
  end;
  Terminate;
end;


end.
