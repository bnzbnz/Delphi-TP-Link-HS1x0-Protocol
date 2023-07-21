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

function LocalIP: string;
function IpAddrToStr( IPAddr: Cardinal ): string;
function StrToIpAddr( IPStr: string ): Cardinal;

implementation
uses  IdGlobal, IdStack, IdUDPClient, winsock2, IpHlpAPI, IpExport, IdIcmpClient,
      SysUtils, IdTCPClient, StrUtils;

function LocalIP: string;
type
  TaPInAddr = array[0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  Buffer: array[0..63] of PAnsiChar;
begin
  Result := '';
  var InitData: TWSAData;
  WSAStartup($101, InitData);
  try
    if gethostname(@Buffer, SizeOf(Buffer)) <> 0 then Exit;
    var HbyN := gethostbyname(@buffer);
    if HbyN = nil then Exit;
    try
      var pPtr := PaPInAddr(HbyN^.h_addr_list);
      var i := 0;
      while pPtr^[i] <> nil do
      begin
        Result := string(inet_ntoa(pPtr^[i]^));
        Inc(i);
      end;
    except
      Result := '';
    end;
  finally
    WSACleanup;
  end;
end;

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
  Result :=  0;
  var R := '';
  var Parts := IPStr.Split(['.']);
  if Length(Parts)<> 4  then Exit;
  for var i := 0 to 3 do R := R + IntToHex(StrToInt(Parts[i]), 2);
  Result := Cardinal(StrToInt('$' + R));
end;

end.


