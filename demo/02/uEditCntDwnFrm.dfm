object EditCntDwnFrm: TEditCntDwnFrm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'ee'
  ClientHeight = 181
  ClientWidth = 217
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  TextHeight = 15
  object Label1: TLabel
    Left = 16
    Top = 49
    Width = 41
    Height = 15
    Caption = 'Action :'
  end
  object Label2: TLabel
    Left = 16
    Top = 85
    Width = 132
    Height = 15
    Caption = 'Delay (Hours / Minutes) :'
  end
  object CkbEnable: TCheckBox
    Left = 16
    Top = 17
    Width = 65
    Height = 17
    Caption = 'Enable'
    TabOrder = 0
  end
  object ComboBox1: TComboBox
    Left = 115
    Top = 46
    Width = 88
    Height = 23
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 1
    Text = 'Power OFF'
    Items.Strings = (
      'Power OFF'
      'Power ON')
  end
  object Button1: TButton
    Left = 16
    Top = 144
    Width = 187
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 3
  end
  object TimePicker1: TTimePicker
    Left = 16
    Top = 106
    Width = 187
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    TabOrder = 2
    Time = 45120.239460648150000000
    TimeFormat = 'h:nn'
  end
end
