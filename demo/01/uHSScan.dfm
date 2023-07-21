object HSScanFrm: THSScanFrm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Simple HS Scan'
  ClientHeight = 353
  ClientWidth = 318
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 13
  object ListBox1: TListBox
    Left = 0
    Top = 73
    Width = 318
    Height = 191
    Align = alClient
    ItemHeight = 13
    TabOrder = 0
    OnClick = ListBox1Click
    ExplicitWidth = 314
    ExplicitHeight = 190
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 318
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 314
    object Refresh: TButton
      Left = 0
      Top = 0
      Width = 318
      Height = 25
      Align = alTop
      Caption = 'Scan'
      TabOrder = 0
      OnClick = RefreshClick
      ExplicitWidth = 314
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 318
    Height = 32
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitWidth = 314
    object PBar: TProgressBar
      Left = 0
      Top = 0
      Width = 318
      Height = 17
      Align = alTop
      BorderWidth = 2
      Max = 255
      TabOrder = 0
      ExplicitWidth = 314
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 264
    Width = 318
    Height = 89
    Align = alBottom
    TabOrder = 3
    ExplicitTop = 263
    ExplicitWidth = 314
  end
end
