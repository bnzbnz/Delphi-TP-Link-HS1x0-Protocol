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
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
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
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 318
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Refresh: TButton
      Left = 0
      Top = 0
      Width = 318
      Height = 25
      Align = alTop
      Caption = 'Scan'
      TabOrder = 0
      OnClick = RefreshClick
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
    object PBar: TProgressBar
      Left = 0
      Top = 0
      Width = 318
      Height = 17
      Align = alTop
      BorderWidth = 2
      Max = 255
      TabOrder = 0
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 264
    Width = 318
    Height = 89
    Align = alBottom
    TabOrder = 3
  end
end
