unit uEditScheduleFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uHS1x0, Vcl.WinXPickers, Vcl.StdCtrls,
  Vcl.CheckLst;

type
  TEditScheduleFrm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    CkbEnable: TCheckBox;
    ComboBox1: TComboBox;
    TimePicker1: TTimePicker;
    Button1: TButton;
    Edit1: TEdit;
    CheckListBox1: TCheckListBox;
    Label3: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
    function ShowAsModal(SC: THS1x0_Schedule): Boolean;
  end;

var
  EditScheduleFrm: TEditScheduleFrm;

implementation

{$R *.dfm}

const
   BInt: array[boolean] of integer = (0, 1);

function TEditScheduleFrm.ShowAsModal(SC: THS1x0_Schedule): Boolean;
var
  D, H, M, S, MS: word;
begin
  CkbEnable.Checked := SC.Fenable;
  ComboBox1.ItemIndex := SC.Fsact;
  Edit1.Text := SC.Fname;
  H := SC.Fsmin div 60;
  M := SC.Fsmin - (H *60);
  TimePicker1.Time := EncodeTime(H, M, 0, 0);
  for var i := 0 to SC.Fwday.Count -1 do
    CheckListBox1.Checked[i] := SC.Fwday[i] = 1;

  Result := Self.ShowModal = mrOK;
  if Result then
  begin
    SC.Fenable := CkbEnable.Checked;
    SC.Fsact := Combobox1.ItemIndex = 1;
    SC.Fname := Edit1.Text;
    DecodeTime(TimePicker1.Time, H, M, S, MS);
    SC.Fsmin := (H * 60 + M);
    for var i := 0 to SC.Fwday.Count -1 do
      SC.Fwday[i]  := BInt[CheckListBox1.Checked[i]];
  end;
end;

end.
