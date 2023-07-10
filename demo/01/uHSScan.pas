unit uHSScan;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls, uHS110DemoExt;

type
  THSScanFrm = class(TForm)
    ListBox1: TListBox;
    Panel1: TPanel;
    PBar: TProgressBar;
    Refresh: TButton;
    procedure FormShow(Sender: TObject);
    procedure RefreshClick(Sender: TObject);
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

procedure OnScanned;
begin
  HSScanFrm.PBar.Position := HSScanFrm.PBar.Position + 1;
end;

procedure OnFound(nIP: Cardinal);
begin
  var Info: THS1x0_SystemInfoResponse := nil;
  var RTime  : THS1x0_GetRealtimeCVResponse := nil;
  var IP := IpAddrToStr(nIP);
  var HS1x0 := THS1x0.Create(IP);
  try
    Info := HS1x0.System_GetSysinfo;
    if Info = nil then Exit;
    RTime := HS1x0.Emeter_GetRealtime;
    if RTime = Nil then Exit;
    var Str := IP + ': ' + Info.Fsystem.Fget_5Fsysinfo.Falias + ' is '+ BStrONOFF[Boolean(Info.Fsystem.Fget_5Fsysinfo.Frelay_state)];
    Str := Str + ' @ ' +vartostr(RTime.Femeter.Fget_5Frealtime.Fpower) + 'W';
    HSScanFrm.ListBox1.Items.Add(Str);
  finally
    RTime.Free;
    Info.Free;
    HS1x0.Free;
  end;
end;

procedure THSScanFrm.FormShow(Sender: TObject);
begin
  Scanner := THS1x0Discovery.Create;
  Scanner.OnScanned := OnScanned;
  Scanner.OnFound := OnFound;
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
