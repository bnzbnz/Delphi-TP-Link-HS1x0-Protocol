object HSScanFrm: THSScanFrm
  Left = 0
  Top = 0
  Caption = 'HS Scan'
  ClientHeight = 214
  ClientWidth = 325
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 0
    Top = 41
    Width = 325
    Height = 173
    Align = alClient
    ItemHeight = 13
    TabOrder = 0
    ExplicitWidth = 635
    ExplicitHeight = 258
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 325
    Height = 41
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 635
    DesignSize = (
      325
      41)
    object PBar: TProgressBar
      Left = 9
      Top = 12
      Width = 194
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Max = 255
      TabOrder = 0
      ExplicitWidth = 504
    end
    object Refresh: TButton
      Left = 231
      Top = 9
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Refresh'
      TabOrder = 1
      OnClick = RefreshClick
      ExplicitLeft = 541
    end
  end
end
