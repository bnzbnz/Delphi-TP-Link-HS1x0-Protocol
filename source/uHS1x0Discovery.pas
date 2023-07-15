unit uHS1x0Discovery;

interface
uses Classes, System.Generics.Collections;

type

  THS1x0Discovery = class;
  THS1x0ScanIPCallback = function(nIP: Cardinal): Boolean;
  THS1x0FoundCallback = procedure(nIP: Cardinal);

  TDiscoveryThread = class(TThread)
  public
    Index: integer;
    IP: string;
    IPs: TList<Cardinal>;
    ScanNumTh: Integer;
    StartIP, EndIP: Integer;
    FOnScanIP: THS1x0ScanIPCallback;
    FOnNewDevice: THS1x0FoundCallback;
    procedure Execute; override;
  end;

  THS1x0Discovery = class(TObject)
  private
    FOnScanIP: THS1x0ScanIPCallback;
    FOnNewDevice: THS1x0FoundCallback;
    IPs: TList<Cardinal>;
    ScanThreadList: TObjectList<TDiscoveryThread>;
    procedure   JustWaitFor;
  public
    class function Call: TList<Cardinal>;
    procedure   Start(FromPort: Byte = 0; ToPort: Byte = 255);
    procedure   Stop;
    function    GetRunningThreadCount: Cardinal;
    constructor Create; overload;
    destructor  Destroy; override;
    property    OnScanIP: THS1x0ScanIPCallback read FOnScanIP write FOnScanIP;
    property    OnNewDevice: THS1x0FoundCallback read FOnNewDevice write FOnNewDevice;
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

function THS1x0Discovery.GetRunningThreadCount: Cardinal;
begin
  Result := 0;
  for var T in ScanThreadList do
    if not T.Terminated then Inc(Result);
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

procedure THS1x0Discovery.Start(FromPort, ToPort: Byte);
begin
  if (FromPort <> 0) and (ToPort <>255) then
  begin
    var Th := TDiscoveryThread.Create(True);
    Th.Priority := tpIdle;
    Th.FreeOnTerminate := False;
    TH.StartIP := FromPort;
    TH.EndIP := ToPort;
    TH.FOnScanIP := FOnScanIP;
    TH.FOnNewDevice := FOnNewDevice;
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
    TH.FOnScanIP := FOnScanIP;
    TH.FOnNewDevice := FOnNewDevice;
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

try
  var BaseIp := StrToIpAddr(LocalIP) and $FFFFFF00; // Class C
  for var i := StartIP to EndIP do
  begin
    if Terminated then Break;
    var nIP := BaseIP + Cardinal(Abs(i));
    IP := IpAddrToStr(nIP);
    var MustScan: Boolean := True;
    Synchronize( procedure begin  if assigned(FOnScanIP) then MustScan := FOnScanIP(nIP); ; end );
    var HS1x0 := THS1x0.Create(IP);
    if HS1x0 <> Nil then
    begin
      try
        if HS1x0.ping then
        begin
          Synchronize( procedure begin if assigned(FOnNewDevice) then FOnNewDevice(nIP); end );
          Synchronize( procedure begin if assigned(IPs) then IPs.Add(nIP) end );
        end;
      except; end;
      HS1x0.Free;
    end;
  end;
finally
  Terminate;
end;

end;

end.
