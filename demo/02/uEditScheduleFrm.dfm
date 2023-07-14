object EditScheduleFrm: TEditScheduleFrm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Schedule Editor'
  ClientHeight = 318
  ClientWidth = 220
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
    Top = 80
    Width = 41
    Height = 15
    Caption = 'Action :'
  end
  object Label2: TLabel
    Left = 16
    Top = 106
    Width = 129
    Height = 15
    Caption = 'Time (Hours / Minutes) :'
  end
  object Label3: TLabel
    Left = 16
    Top = 49
    Width = 32
    Height = 15
    Caption = 'Name'
  end
  object CkbEnable: TCheckBox
    Left = 16
    Top = 25
    Width = 65
    Height = 17
    Caption = 'Enable'
    TabOrder = 0
  end
  object ComboBox1: TComboBox
    Left = 115
    Top = 77
    Width = 88
    Height = 23
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 2
    Text = 'Power OFF'
    Items.Strings = (
      'Power OFF'
      'Power ON')
  end
  object TimePicker1: TTimePicker
    Left = 16
    Top = 127
    Width = 187
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    TabOrder = 3
    Time = 0.238888888888888900
    TimeFormat = 'hh:nn'
  end
  object Button1: TButton
    Left = 16
    Top = 282
    Width = 187
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 5
  end
  object Edit1: TEdit
    Left = 82
    Top = 48
    Width = 121
    Height = 23
    TabOrder = 1
  end
  object CheckListBox1: TCheckListBox
    Left = 16
    Top = 165
    Width = 187
    Height = 111
    ItemHeight = 17
    Items.Strings = (
      'Sunday'
      'Monday'
      'Ttuesday'
      'Wednesday'
      'Thursday'
      'Friday'
      'Saturday')
    TabOrder = 4
  end
end
