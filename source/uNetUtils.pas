unit uNetUtils;

///
///  Author:  Laurent Meyer
///  Contact: HS1x0@ea4d.com
///
///  https://github.com/bnzbnz/Delphi-TP-Link-HS1x0-Protocol
///
///  License: MPL 1.1 / GPL 2.1
///

interface
uses Windows;
function  LocalIP: string;
function  IPToHostname(IPAddr: AnsiString): string;
function  IPtoMacAddr(const IPAddress: AnsiString; Sep: Char = ':'): string;
// function  HostToIP(const hostName: string; const ipv6: boolean): string;
procedure WakeOnLan(const AMacAddress: string);
procedure WakeOnLanByIP(const IP: string);
function  Ping(HostnameOrIP: string; Count: Integer = 4; TimeOut: Integer = 250): Integer;

function IpAddrToStr( IPAddr: Cardinal ): string;
function StrToIpAddr( IPStr: string ): Cardinal;

implementation
uses  IdGlobal, IdStack, IdUDPClient, winsock2, IpHlpAPI, IpExport, IdIcmpClient,
      SysUtils, IdTCPClient, StrUtils;

function IpAddrToStr( IPAddr: Cardinal ): string;
begin
  Result := '';
  for var i := 1 to 4 do
  begin
    Result := Format( '%d.', [IPAddr and $FF] ) + Result ;
    IPAddr := IPAddr shr 8;
  end;
  Delete( Result, Length( Result ), 1 );
end;

function StrToIpAddr( IPStr: string ): Cardinal;
begin
  var R := ''; Result :=  0;
  var Parts := IPStr.Split(['.']);
  if Length(Parts)<> 4  then Exit;
  for var i := 0 to 3 do R := R + IntToHex(StrToInt(Parts[i]), 2);
  Result := Cardinal(StrToInt('$' + R));
end;

function LocalIP: string;
type
  TaPInAddr = array[0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe: PHostEnt;
  pptr: PaPInAddr;
  Buffer: array[0..63] of PAnsiChar;
  I: Integer;
  GInitData: TWSAData;
begin
  WSAStartup($101, GInitData);
  Result := '';
  GetHostName(@Buffer, SizeOf(Buffer));
  phe := GetHostByName(@buffer);
  if phe = nil then Exit;
  pPtr := PaPInAddr(phe^.h_addr_list);
  I := 0;
  while pPtr^[I] <> nil do
  begin
    Result := inet_ntoa(pptr^[I]^);
    Inc(I);
  end;
  WSACleanup;
end;

function IPToHostname(IPAddr: AnsiString): string;
var
  SockAddrIn: TSockAddrIn;
  HostEnt: PHostEnt;
  WSAData: TWSAData;
begin
  WSAStartup($101, WSAData);
  SockAddrIn.sin_addr.s_addr := inet_addr(PAnsiChar(IPAddr));
  HostEnt := gethostbyaddr(@SockAddrIn.sin_addr.S_addr, 4, AF_INET);
  if HostEnt <> nil then
    Result := Hostent^.h_name
  else
    Result := '';
  WSACleanup;
end;

function IPtoMacAddr(const IPAddress: AnsiString; Sep: Char = ':'): string;
var
  lDestIP:Cardinal;
  lMacAddr:array[0..5] of byte;
  lPhyAddrLen:Cardinal;
begin
  if Trim(IPAddress) = ''  then Exit('');
  lDestIP:=inet_addr(PAnsiChar(IPAddress));
  lPhyAddrLen:=length(lMacAddr);
 SendARP(lDestIP, 0, @lMacAddr, lPhyAddrLen);
  Result := Format(
              '%2.2x%s%2.2x%s%2.2x%s%2.2x%s%2.2x%s%2.2x',
              [lMacAddr[0],Sep,lMacAddr[1],Sep,lMacAddr[2],Sep,lMacAddr[3],Sep,lMacAddr[4],Sep,lMacAddr[5]]
            );
  if Result = '00:BE:43:65:85:ED' then Result := '';
end;

procedure WakeOnLan(const AMacAddress: string);
type
  TMacAddress = array [1..6] of Byte;
  TWakeRecord = packed record
    Waker : TMACAddress;
    MAC   : array [0..15] of TMacAddress;
  end;
var
  I          : Integer;
  WR         : TWakeRecord;
  MacAddress : TMacAddress;
  UDPClient  : TIdUDPClient;
  sData      : string;
begin
  FillChar(MacAddress, SizeOf(TMacAddress), 0);
  sData := Trim(AMacAddress);
  if Length(sData) = 17 then begin

    for I := 1 to 6 do begin
      MacAddress[I] := StrToIntDef('$' + Copy(sData, 1, 2), 0);
      sData := Copy(sData, 4, 17);
    end;
  end;
  for I := 1 to 6  do WR.Waker[I] := $FF;
  for I := 0 to 15 do WR.MAC[I]   := MacAddress;
  UDPClient := TIdUDPClient.Create(nil);
  try
    UDPClient.BroadcastEnabled := True;
    UDPClient.IPVersion := Id_IPv4;
    UDPClient.Broadcast(RawToBytes(WR, SizeOf(WR)), 32767);
    UDPClient.BroadcastEnabled := False;
  finally
    UDPClient.Free;
  end;
end;

procedure WakeOnLanByIP(const IP: string);
begin
  WakeOnLan(IPtoMacAddr(IP));
end;

function Ping(HostnameOrIP: string; Count: Integer; TimeOut: Integer): Integer;
var
  R: array of  Integer;
  i: integer;
  Icmp: TIdIcmpClient;
begin
  Result := 0;
  Icmp := TIdIcmpClient.Create(Nil);
  try
    Icmp.Host := HostnameOrIP;
    Icmp.ReceiveTimeout := TimeOut;
    SetLength(R, Count);
    for i := 0 to Pred(Count) do
    begin
      try
        Icmp.Ping();
        if Icmp.ReplyStatus.ReplyStatusType <> rsEcho then
          raise Exception.Create('Ping Timeout');
        R[i] := Icmp.ReplyStatus.MsRoundTripTime;
      except
        Result := -1;
        Exit;
      end;
    end;
    for i := 0 to Count - 1 do
      Result := Result + R[i];

      Result := Trunc( Result / Count );
  finally
    Icmp.Free;
  end;
end;

(*
function HostToIP(const hostName: string; const ipv6: boolean): string;
const
  BUFFER_SIZE = 1024;
var
  data: TWSAData;
  error: integer;
  requestError: integer;
  buffer: TArray<byte>;
  length: DWORD;
  SocketHint    : TAddrInfo;
  SocketResult  : PAddrInfo;
begin
  Result := '';
  error:= WSAStartup(514, data);
  try
    if (error = 0)  then
    begin
      try
        ZeroMemory(@SocketHint, sizeof(TAddrInfo));
        if (ipv6) then
          SocketHint.ai_family:= AF_INET6
        else
          SocketHint.ai_family:= AF_INET;
        requestError:= getaddrinfo( PAnsiChar(ShortString(HostName)), '0', SocketHint, SocketResult);
        if (requestError = 0) then
        begin
          length:= BUFFER_SIZE;
          SetLength(Buffer, BUFFER_SIZE);
          if (WSAAddressToString(SocketResult.ai_addr^, SocketResult.ai_addrlen, nil, @Buffer[0], Length) = 0) then
          begin
             SetString(Result, PWideChar(Buffer), Length - 1);
             Exit;
          end else exit;
        end else exit;
      finally
        FreeAddrInfo(SocketResult^);
      end;
    end
  finally
    if (error = 0) then
      WSACleanup();
  end;
end;
*)
end.


