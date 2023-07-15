object HSScanFrm: THSScanFrm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Simple HS Scan'
  ClientHeight = 353
  ClientWidth = 325
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 0
    Top = 73
    Width = 325
    Height = 280
    Align = alClient
    ItemHeight = 13
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 325
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      325
      41)
    object Refresh: TButton
      Left = 9
      Top = 10
      Width = 312
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Scan'
      TabOrder = 0
      OnClick = RefreshClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 325
    Height = 32
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      325
      32)
    object PBar: TProgressBar
      Left = 9
      Top = 8
      Width = 312
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      BorderWidth = 2
      Max = 255
      TabOrder = 0
    end
  end
end
