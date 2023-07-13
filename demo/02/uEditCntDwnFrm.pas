unit uEditCntDwnFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uHS1x0, Vcl.StdCtrls, Vcl.Samples.Spin,
  Vcl.ComCtrls, Vcl.WinXPickers;

type
  TEditCntDwnFrm = class(TForm)
    CkbEnable: TCheckBox;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label2: TLabel;
    Button1: TButton;
    TimePicker1: TTimePicker;
  private
    { Private declarations }
  public
    { Public declarations }
    function ShowAsModal(CD: THS1x0_CountDown): Boolean;
  end;

var
  EditCntDwnFrm: TEditCntDwnFrm;

implementation

{$R *.dfm}

{ TEditCntDwnFrm }

function TEditCntDwnFrm.ShowAsModal(CD: THS1x0_CountDown): Boolean;
var
  D, H, M, S, MS: word;
begin
  CkbEnable.Checked := CD.Fenable;
  ComboBox1.ItemIndex := CD.Fact;
  D:=  CD.Fdelay div 86400;
  H:= ( CD.Fdelay - D * 86400) div 60 div 60;
  M:= ( CD.Fdelay - D * 86400 -  H * 3600) div 60;
  S:=  CD.Fdelay - D * 86400 - H * 3600 - M * 60;
  TimePicker1.Time := EncodeTime(H, M, S, 0);
  Result := Self.ShowModal = mrOK;
  if not Result then Exit;
  CD.Fenable :=  CkbEnable.Checked;
  CD.Fact := Combobox1.ItemIndex = 1;
  DecodeTime(TimePicker1.Time, H, M, S, MS);
  CD.Fdelay := (H * 60 + M) * 60;
end;

end.
