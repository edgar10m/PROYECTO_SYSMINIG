object ftscomarea: Tftscomarea
  Left = 577
  Top = 200
  Width = 1305
  Height = 749
  Caption = 'ftscomarea'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 265
    Width = 1289
    Height = 8
    Cursor = crVSplit
    Align = alTop
    Beveled = True
  end
  object Splitter2: TSplitter
    Left = 0
    Top = 425
    Width = 1289
    Height = 8
    Cursor = crVSplit
    Align = alTop
    Beveled = True
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1289
    Height = 265
    Align = alTop
    TabOrder = 0
    object dbg: TDBGrid
      Left = 538
      Top = 1
      Width = 750
      Height = 263
      Align = alClient
      DataSource = DataSource1
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnCellClick = dbgCellClick
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 537
      Height = 263
      Align = alLeft
      Caption = 'Panel2'
      TabOrder = 1
      object Label1: TLabel
        Left = 168
        Top = 96
        Width = 37
        Height = 24
        Caption = '>>>'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lst: TListBox
        Left = 8
        Top = 0
        Width = 145
        Height = 257
        ItemHeight = 13
        TabOrder = 0
        OnClick = lstClick
      end
      object lnk: TListBox
        Left = 216
        Top = 0
        Width = 145
        Height = 257
        ItemHeight = 13
        TabOrder = 1
        OnClick = lnkClick
      end
      object cmbbib: TComboBox
        Left = 377
        Top = 28
        Width = 145
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 2
        OnChange = cmbbibChange
      end
      object bunico: TButton
        Left = 416
        Top = 3
        Width = 65
        Height = 22
        Caption = 'Ejecuta'
        TabOrder = 3
        Visible = False
        OnClick = bunicoClick
      end
      object bmapa: TButton
        Left = 416
        Top = 139
        Width = 65
        Height = 22
        Caption = 'MAPA'
        TabOrder = 4
        OnClick = bmapaClick
      end
      object bexporta: TButton
        Left = 416
        Top = 227
        Width = 65
        Height = 22
        Caption = 'EXPORTA'
        TabOrder = 5
        Visible = False
        OnClick = bexportaClick
      end
      object chkqueue: TCheckBox
        Left = 408
        Top = 168
        Width = 97
        Height = 17
        Caption = 'QUEUES'
        TabOrder = 6
      end
      object chk300: TCheckBox
        Left = 408
        Top = 192
        Width = 97
        Height = 17
        Caption = '300'
        Checked = True
        State = cbChecked
        TabOrder = 7
      end
      object chksolo: TCheckBox
        Left = 400
        Top = 56
        Width = 121
        Height = 17
        Caption = 'Registros afectados'
        Checked = True
        State = cbChecked
        TabOrder = 8
        OnClick = chksoloClick
      end
      object chkcampo: TCheckBox
        Left = 400
        Top = 80
        Width = 121
        Height = 17
        Caption = 'Campos afectados'
        Checked = True
        State = cbChecked
        TabOrder = 9
        OnClick = chkcampoClick
      end
    end
  end
  object dg: TDrawGrid
    Left = 0
    Top = 273
    Width = 1289
    Height = 152
    Align = alTop
    ColCount = 1
    DefaultColWidth = 200
    DefaultRowHeight = 20
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goRangeSelect]
    PopupMenu = pop
    TabOrder = 1
    OnDrawCell = dgDrawCell
    OnMouseDown = dgMouseDown
    OnSelectCell = dgSelectCell
  end
  object dd: TDrawGrid
    Left = 0
    Top = 433
    Width = 1289
    Height = 278
    Align = alClient
    ColCount = 1
    DefaultColWidth = 80
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    TabOrder = 2
    OnDrawCell = ddDrawCell
  end
  object DataSource1: TDataSource
    DataSet = ADO1
    Left = 776
    Top = 88
  end
  object ADO1: TADOQuery
    Connection = dm.ADOConnection1
    Parameters = <>
    Left = 816
    Top = 88
  end
  object pop: TPopupMenu
    Left = 176
    Top = 384
    object Rastrea1: TMenuItem
      Caption = 'Rastrea'
      OnClick = Rastrea1Click
    end
  end
  object SaveDialog1: TSaveDialog
    Left = 656
    Top = 192
  end
end
