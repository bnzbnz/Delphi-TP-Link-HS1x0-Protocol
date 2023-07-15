object HSForm: THSForm
  Left = 0
  Top = 0
  Caption = 'HS1x0 Editor'
  ClientHeight = 521
  ClientWidth = 853
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    853
    521)
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 853
    Height = 33
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 849
    DesignSize = (
      853
      33)
    object PBar: TProgressBar
      Left = 16
      Top = 10
      Width = 733
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Max = 255
      TabOrder = 0
      ExplicitWidth = 729
    end
  end
  object Button1: TButton
    Left = 766
    Top = 10
    Width = 75
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'Refresh'
    TabOrder = 1
    OnClick = Button1Click
    ExplicitLeft = 762
  end
  object Panel2: TPanel
    Left = 0
    Top = 327
    Width = 853
    Height = 194
    Align = alBottom
    TabOrder = 2
    ExplicitTop = 326
    ExplicitWidth = 849
    object Panel3: TPanel
      Left = 330
      Top = 1
      Width = 522
      Height = 192
      Align = alClient
      Caption = 'Panel3'
      TabOrder = 0
      ExplicitWidth = 518
      object GridS: TStringGrid
        Left = 1
        Top = 1
        Width = 520
        Height = 112
        Align = alTop
        ColCount = 6
        DoubleBuffered = True
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect, goFixedRowDefAlign]
        ParentDoubleBuffered = False
        PopupMenu = PopupScheds
        ScrollBars = ssVertical
        TabOrder = 0
        OnDblClick = GridSDblClick
        ExplicitWidth = 516
        ColWidths = (
          64
          64
          64
          64
          64
          64)
      end
      object GRidC: TStringGrid
        Left = 1
        Top = 96
        Width = 520
        Height = 95
        Align = alBottom
        DoubleBuffered = True
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect, goFixedRowDefAlign]
        ParentDoubleBuffered = False
        PopupMenu = PopupCntDwn
        TabOrder = 1
        OnDblClick = GRidCDblClick
        ExplicitWidth = 516
        ColWidths = (
          64
          64
          64
          64
          64)
      end
    end
    object GridD: TStringGrid
      Left = 1
      Top = 1
      Width = 329
      Height = 192
      Align = alLeft
      BevelInner = bvNone
      ColCount = 2
      RowCount = 7
      FixedRows = 0
      ScrollBars = ssVertical
      TabOrder = 1
    end
  end
  object Grid: TStringGrid
    Left = 0
    Top = 33
    Width = 853
    Height = 294
    Align = alClient
    ColCount = 10
    DefaultColWidth = 80
    DoubleBuffered = True
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect, goFixedRowDefAlign]
    ParentDoubleBuffered = False
    PopupMenu = Popup
    TabOrder = 3
    OnSelectCell = GridSelectCell
    ExplicitWidth = 849
    ExplicitHeight = 293
  end
  object Popup: TPopupMenu
    Left = 208
    Top = 112
    object Rename1: TMenuItem
      Caption = 'Rename'
      OnClick = Rename1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object PowerON1: TMenuItem
      Caption = 'Power ON'
      OnClick = PowerON1Click
    end
    object PowerOFF1: TMenuItem
      Caption = 'Power OFF'
      OnClick = PowerOFF1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object LedON1: TMenuItem
      Caption = 'Led ON'
      OnClick = LedON1Click
    end
    object LedOFF1: TMenuItem
      Caption = 'Led OFF'
      OnClick = LedOFF1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Reboot1: TMenuItem
      Caption = 'Reboot'
      OnClick = Reboot1Click
    end
    object Reset1: TMenuItem
      Caption = 'Reset'
      OnClick = Reset1Click
    end
    object StatsReset1: TMenuItem
      Caption = 'Stats Reset'
      OnClick = StatsReset1Click
    end
    object DevTestMenu: TMenuItem
      Caption = '~~ DevTest ~~'
      Visible = False
      OnClick = DevTestMenuClick
    end
  end
  object PopupScheds: TPopupMenu
    Left = 746
    Top = 352
    object Enable1: TMenuItem
      Caption = 'Enable / Disable'
      OnClick = Enable1Click
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object Add1: TMenuItem
      Caption = 'Add'
      OnClick = Add1Click
    end
    object Edit3: TMenuItem
      Caption = 'Edit'
      OnClick = Edit3Click
    end
    object Delete1: TMenuItem
      Caption = 'Delete'
      OnClick = Delete1Click
    end
    object DeleteALL1: TMenuItem
      Caption = 'Delete All'
      OnClick = DeleteALL1Click
    end
  end
  object PopupCntDwn: TPopupMenu
    Left = 746
    Top = 448
    object Edit1: TMenuItem
      Caption = 'Enable/Disable'
      OnClick = Edit1Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object Edit2: TMenuItem
      Caption = 'Edit'
      OnClick = Edit2Click
    end
  end
end
