unit uHS1x0Discovery;

interface
uses Classes, System.Generics.Collections;

type

  THS1x0Discovery = class;
  THS1x0ScannedCallback = procedure(nIP: Cardinal);
  THS1x0FoundCallback = procedure(nIP: Cardinal);

  TDiscoveryThread = class(TThread)
  public
    Index: integer;
    IP: string;
    IPs: TList<Cardinal>;
    ScanNumTh: Integer;
    StartIP, EndIP: Integer;
    FOnScanned: THS1x0ScannedCallback;
    FOnFound: THS1x0FoundCallback;
    procedure Execute; override;
  end;

  THS1x0Discovery = class(TObject)
  private
    FOnScanned: THS1x0ScannedCallback;
    FOnFound: THS1x0FoundCallback;
    IPs: TList<Cardinal>;
    ScanThreadList: TObjectList<TDiscoveryThread>;
    procedure   JustWaitFor;
  public
    class function Call: TList<Cardinal>;
    procedure   Start(FromPort: Byte = 0; ToPort: Byte = 255);
    procedure   Stop;
    constructor Create; overload;
    destructor  Destroy; override;
    property    OnScanned: THS1x0ScannedCallback read FOnScanned write FOnScanned;
    property    OnFound: THS1x0FoundCallback read FOnFound write FOnFound;
  end;

implementation
uses uHS1x0, uNetUtils, windows;

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

class function THS1x0Discovery.Call: TList<Cardinal>;
begin
  var T := THS1x0Discovery.Create;
  T.IPs:= TList<Cardinal>.Create;
  T.Start;
  T.JustWaitFor;
  T.Stop;
  T.IPs.Sort;
  Result := T.IPs;
  T.Free;
end;

procedure  THS1x0Discovery.Start(FromPort, ToPort: Byte);
begin
  if (FromPort <> 0) and (ToPort <>255) then
  begin
    var Th := TDiscoveryThread.Create(True);
    Th.Priority := tpIdle;
    Th.FreeOnTerminate := False;
    TH.StartIP := FromPort;
    TH.EndIP := ToPort;
    TH.FOnScanned := FOnScanned;
    TH.FOnFound := FOnFound;
    TH.IPs := IPs;
    ScanThreadList.Add(Th);
    Th.Start;
    Exit;
  end;

  var NumThread := 8;
  if not IsDebuggerPresent then NumThread := 128;
  for var i := 0 to NumThread - 1 do
  begin
    var Th := TDiscoveryThread.Create(True);
    Th.Priority := tpIdle;
    Th.FreeOnTerminate := False;
    TH.StartIP :=  i * (256 div NumThread);
    TH.EndIP := (i + 1) * (256 div NumThread) - 1;
    TH.FOnScanned := FOnScanned;
    TH.FOnFound := FOnFound;
    TH.IPs := IPs;
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

procedure THS1x0Discovery.JustWaitFor;
begin
  for var Th in ScanThreadList do
   Th.WaitFor;
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
    var nIP := BaseIP + Cardinal(Abs(i));
    IP := IpAddrToStr(nIP);
    Synchronize( procedure begin  if assigned(FOnScanned) then FOnScanned(nIP); ; end );
    var HS110 := THS1x0.Create(IP);
    if HS110 <> Nil then
    begin
      if HS110.ping then
      begin
        Synchronize( procedure begin if assigned(FOnFound) then FOnFound(nIP); end );
        Synchronize( procedure begin if assigned(IPs) then IPs.Add(nIP) end );
      end;
      HS110.Free;
    end;
  end;
  Terminate;
end;


end.
