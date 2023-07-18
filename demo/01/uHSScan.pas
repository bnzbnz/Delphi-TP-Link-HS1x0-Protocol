unit uHSScan;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls, uHS1x0Discovery,
  Vcl.Samples.Spin;

type
  THSScanFrm = class(TForm)
    ListBox1: TListBox;
    Panel1: TPanel;
    Refresh: TButton;
    Panel2: TPanel;
    PBar: TProgressBar;
    procedure FormShow(Sender: TObject);
    procedure RefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Scanner: THS1x0Discovery;
  end;

var
  HSScanFrm: THSScanFrm;

implementation
uses uHS1x0, uNetUtils;

{$R *.dfm}

const
  BStrONOFF: array[Boolean] of string = ('OFF','ON');

function DoScanIP(nIP: Cardinal): Boolean;
begin
  HSScanFrm.PBar.Position := HSScanFrm.PBar.Position + 1;
  HSScanFrm.Caption := 'Saanning IP : ' + IpAddrToStr(nIP);
  Result := True;
end;

procedure DoOnDone;
begin
  HSScanFrm.Caption := 'Simple HS Scan';
end;

procedure DoNewDevice(nIP: Cardinal);
begin
  var Info: THS1x0_System_GetSysInfoResponse := nil;
  var RTime: THS1x0_EMeter_GetRealtimeCVResponse := nil;
  var IP := IpAddrToStr(nIP);
  var HS1x0 := THS1x0.Create(IP);
  try
    Info := HS1x0.System_GetSysinfo;
    if Info = nil then Exit;
    RTime := HS1x0.Emeter_GetRealtime;
    if RTime = Nil then Exit;
    var Str := Format(
                  '%s : %s is %s @ %s W',
                  [
                    IP,
                    Info.Fsystem.Fget_5Fsysinfo.Falias,
                    BStrONOFF[Boolean(Info.Fsystem.Fget_5Fsysinfo.Frelay_state)],
                    VarToStr(RTime.Femeter.Fget_5Frealtime.Fpower)
                  ]
                );
    HSScanFrm.ListBox1.Items.Add(Str);
  finally
    RTime.Free;
    Info.Free;
    HS1x0.Free;
  end;
end;

procedure THSScanFrm.FormCreate(Sender: TObject);
begin
  if debugHook <> 0 then
    ShowMessage('You are running in the IDE : Due to a Debugger Bug while multi-threading, the port scanning feature is going to be slow...');
end;

procedure THSScanFrm.FormDestroy(Sender: TObject);
begin
  Scanner.Free;
end;

procedure THSScanFrm.FormShow(Sender: TObject);
begin
  Scanner := THS1x0Discovery.Create;
  Scanner.OnScanIP := DoScanIP;
  Scanner.OnNewDevice := DoNewDevice;
  Scanner.OnDone := DoOnDone;
  Scanner.Start;
end;

procedure THSScanFrm.RefreshClick(Sender: TObject);
begin
  Scanner.Stop;
  PBar.Position := 0;
  ListBox1.Clear;
  Scanner.Start;
end;

end.
