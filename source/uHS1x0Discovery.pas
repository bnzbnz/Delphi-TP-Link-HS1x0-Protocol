unit uHS1x0Discovery;

interface
uses Classes, System.Generics.Collections;

type

  THS1x0Discovery  = class;
  TDiscoveryThread = class;

  THS1x0Discovery_DoneEvent   = procedure of object;
  THS1x0Discovery_ScanIPEvent = procedure(nIP: Cardinal) of object;
  THS1x0Discovery_FoundEvent  = THS1x0Discovery_ScanIPEvent;

  TDiscoveryThread = class(TThread)
  public
    Index: integer;
    IP: string;
    IPs: TList<Cardinal>;
    ScanNumTh: Integer;
    StartIP, EndIP: Integer;
    FOnScanIP: THS1x0Discovery_ScanIPEvent;
    FOnNewDevice: THS1x0Discovery_FoundEvent;
    FOnDone: THS1x0Discovery_DoneEvent;
    procedure Execute; override;
  end;

  THS1x0Discovery = class(TObject)
  private
    FThreadCount: Integer;
    FOnScanIP: THS1x0Discovery_ScanIPEvent;
    FOnNewDevice: THS1x0Discovery_FoundEvent;
    FOnDone: THS1x0Discovery_DoneEvent;
    IPs: TList<Cardinal>;
    ScanThreadList: TObjectList<TDiscoveryThread>;
    procedure   JustWaitFor;
    procedure   DoDone;
  public
    class function Call: TList<Cardinal>;

    procedure   Start(FromPort: Byte = 0; ToPort: Byte = 255);
    procedure   Stop;
    function    GetRunningThreadCount: Cardinal;
    constructor Create(
                    ScanIPEvent: THS1x0Discovery_ScanIPEvent;
                    NewDeviceEvent: THS1x0Discovery_FoundEvent;
                    DoneEvent: THS1x0Discovery_DoneEvent
                ); overload;
    destructor  Destroy; override;
    property    OnScanIP: THS1x0Discovery_ScanIPEvent read FOnScanIP write FOnScanIP;
    property    OnNewDevice: THS1x0Discovery_FoundEvent read FOnNewDevice write FOnNewDevice;
    property    OnDone: THS1x0Discovery_DoneEvent read FOnDone write FOnDone;
  end;

implementation
uses uHS1x0, uNetUtils, windows;

constructor THS1x0Discovery.Create(
                ScanIPEvent: THS1x0Discovery_ScanIPEvent;
                NewDeviceEvent: THS1x0Discovery_FoundEvent;
                DoneEvent: THS1x0Discovery_DoneEvent
            );
begin
  inherited Create;
  ScanThreadList := TObjectList<TDiscoveryThread>.Create(False);
  Self.OnScanIP := ScanIPEvent;
  Self.OnNewDevice := NewDeviceEvent;
  Self.OnDone := DoneEvent;
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
    ScanThreadList.Add(TH);
    Th.Start;
    Exit;
  end;

  FThreadCount:= 8;
  if not IsDebuggerPresent then FThreadCount := 128;
  for var i := 0 to FThreadCount - 1 do
  begin
    var Th := TDiscoveryThread.Create(True);
    Th.Priority := tpIdle;
    Th.FreeOnTerminate := False;
    TH.StartIP :=  i * (256 div FThreadCount);
    TH.EndIP := (i + 1) * (256 div FThreadCount) - 1;
    TH.FOnScanIP := FOnScanIP;
    TH.FOnNewDevice := FOnNewDevice;
    TH.FOnDone := DoDone;
    TH.IPs := IPs;
    ScanThreadList.Add(TH);
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

procedure THS1x0Discovery.DoDone;
begin
  Dec(FThreadCount);
  if (FThreadCount = 0) and Assigned(FOnDone) then FOnDone;
end;

procedure TDiscoveryThread.Execute;
begin

try
  var BaseIp := StrToIpAddr(LocalIP) and $FFFFFF00; // Class C, like a Merc :)
  for var i := StartIP to EndIP do
  begin
    if Terminated then Break;
    var nIP := BaseIP + Cardinal(Abs(i));
    IP := IpAddrToStr(nIP);
    Synchronize(
                  procedure
                  begin
                    try
                      if assigned(FOnScanIP) then FOnScanIP(nIP);
                    except
                    end;
                  end
               );


    var HS1x0 := THS1x0.Create(IP);
    if HS1x0 <> Nil then
    begin
      try
        if HS1x0.ping then
        begin
          Synchronize( procedure begin try if assigned(FOnNewDevice) then FOnNewDevice(nIP); except end; end );
          Synchronize( procedure begin try if assigned(IPs) then IPs.Add(nIP); except end; end );
        end;
      except; end;
      HS1x0.Free;
    end;
  end;
finally
  Synchronize( procedure begin if assigned(FOnDone) then FOnDone; end );
  Terminate;
end;

end;

end.
