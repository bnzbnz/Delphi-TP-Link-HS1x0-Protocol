unit uHSScan;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls, uHS1x0Discovery,
  Vcl.Samples.Spin, uHS1x0;

type
  THSScanFrm = class(TForm)
    ListBox1: TListBox;
    Panel1: TPanel;
    Refresh: TButton;
    Panel2: TPanel;
    PBar: TProgressBar;
    Memo1: TMemo;
    procedure FormShow(Sender: TObject);
    procedure RefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure DoScanIP(nIPv4: Cardinal);
    procedure DoNewDevice(HS1x0: THS1x0; Info: THS1x0_System_GetSysInfoResponse);
    procedure DoDone;
  public
    { Public declarations }
    Scanner: THS1x0Discovery;
  end;

var
  HSScanFrm: THSScanFrm;

implementation
uses uNetUtils;

{$R *.dfm}

const
  BStrONOFF: array[Boolean] of string = ('OFF','ON');

procedure THSScanFrm.DoScanIP(nIPv4: Cardinal);
begin
  Caption := 'Scanning IP : ' + IpAddrToStr(nIPv4);
  PBar.Position := PBar.Position + 1;
end;

procedure THSScanFrm.DoDone;
begin
  Caption := 'Simple HS Scan';
  PBar.Position := 0;
end;

procedure THSScanFrm.DoNewDevice(HS1x0: THS1x0; Info: THS1x0_System_GetSysInfoResponse);
begin
  var RTime: THS1x0_EMeter_GetRealtimeCVResponse := nil;
  try
    RTime := HS1x0.Emeter_GetRealtime;
    var Watt := -1; // HS100 - no EMeter
    if RTime <> nil then Watt := RTime.Femeter.Fget_5Frealtime.Fpower;
    var Str := Format(
                  '%s : %s is %s @ %d W',
                  [
                      HS1x0.IPv4
                    , Info.Fsystem.Fget_5Fsysinfo.Falias
                    , BStrONOFF[Boolean(Info.Fsystem.Fget_5Fsysinfo.Frelay_state)]
                    , Watt
                  ]
               );
    ListBox1.Items.AddObject(Str, TObject(HS1x0.nIPv4));
  finally
    RTime.Free;
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
  Scanner := THS1x0Discovery.Create(DoScanIP, DoNewDevice, DoDone);
  Scanner.Start;
end;

procedure THSScanFrm.ListBox1Click(Sender: TObject);
begin
  Memo1.Clear;
  if ListBox1.ItemIndex = -1 then Exit;
  var Info: THS1x0_System_GetSysInfoResponse := nil;
  var HS1x0: THS1x0 := nil;
  try
    var nIPv4 := Cardinal(ListBox1.Items.Objects[ListBox1.ItemIndex]);
    HS1x0 := THS1x0.Create(nIPv4);
    Info := HS1x0.System_GetSysinfo;
    if Info = nil then Exit;
    Memo1.Lines.Add('Alias: ' + Info.Fsystem.Fget_5Fsysinfo.Falias);
    Memo1.Lines.Add('Model: ' + Info.Fsystem.Fget_5Fsysinfo.Fmodel);
    Memo1.Lines.Add('Feature: ' + Info.Fsystem.Fget_5Fsysinfo.Ffeature);
    Memo1.Lines.Add('Version: ' + Info.Fsystem.Fget_5Fsysinfo.Fhw_5Fver);
  finally
    HS1x0.Free;
    Info.Free;
  end;
end;

procedure THSScanFrm.RefreshClick(Sender: TObject);
begin
  Scanner.Stop;
  PBar.Position := 0;
  ListBox1.Clear;
  Scanner.Start;
end;

end.
