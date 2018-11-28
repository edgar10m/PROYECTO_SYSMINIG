object ftspropaga: Tftspropaga
  Left = 1
  Top = 1
  Width = 1364
  Height = 726
  Caption = 'Propagaci'#243'n de Variables'
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
  object Splitter2: TSplitter
    Left = 763
    Top = 177
    Width = 8
    Height = 511
    Align = alRight
    Beveled = True
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1348
    Height = 177
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 26
      Height = 13
      Caption = 'Clase'
    end
    object cmbbiblioa: TLabel
      Left = 209
      Top = 16
      Width = 46
      Height = 13
      Caption = 'Biblioteca'
    end
    object Label2: TLabel
      Left = 409
      Top = 16
      Width = 60
      Height = 13
      Caption = 'Componente'
    end
    object Label3: TLabel
      Left = 625
      Top = 16
      Width = 33
      Height = 13
      Caption = 'Campo'
    end
    object Label4: TLabel
      Left = 817
      Top = 16
      Width = 39
      Height = 13
      Caption = 'Registro'
    end
    object Label5: TLabel
      Left = 664
      Top = 40
      Width = 32
      Height = 13
      Caption = 'Label5'
    end
    object Label6: TLabel
      Left = 1017
      Top = 16
      Width = 34
      Height = 13
      Caption = 'Analiza'
    end
    object Label7: TLabel
      Left = 8
      Top = 40
      Width = 45
      Height = 13
      Caption = 'COPYLIB'
    end
    object Label8: TLabel
      Left = 809
      Top = 104
      Width = 46
      Height = 13
      Caption = 'Biblioteca'
    end
    object lblregistros: TLabel
      Left = 808
      Top = 152
      Width = 44
      Height = 13
      Caption = 'Registros'
    end
    object cmbclase: TComboBox
      Left = 57
      Top = 8
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = cmbclaseChange
    end
    object cmbbiblioteca: TComboBox
      Left = 257
      Top = 8
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      OnChange = cmbbibliotecaChange
    end
    object cmbcomponente: TComboBox
      Left = 473
      Top = 8
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      OnChange = cmbcomponenteChange
    end
    object cmbcampo: TComboBox
      Left = 665
      Top = 8
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 3
      OnChange = cmbcampoChange
    end
    object cmbregistro: TComboBox
      Left = 865
      Top = 8
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 4
    end
    object cmbanaliza: TComboBox
      Left = 1057
      Top = 8
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 5
    end
    object cmbcopylib: TComboBox
      Left = 57
      Top = 32
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 6
      OnChange = cmbclaseChange
    end
    object bejecuta: TButton
      Left = 1208
      Top = 6
      Width = 65
      Height = 22
      Caption = 'Ejecuta'
      TabOrder = 7
      OnClick = bejecutaClick
    end
    object dbgtsmaestra: TDBGrid
      Left = 0
      Top = 56
      Width = 689
      Height = 120
      DataSource = DataSource1
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      ReadOnly = True
      TabOrder = 8
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnCellClick = dbgtsmaestraCellClick
    end
    object lst: TListBox
      Left = 920
      Top = 56
      Width = 145
      Height = 121
      ItemHeight = 13
      TabOrder = 9
    end
    object btodo: TButton
      Left = 800
      Top = 78
      Width = 65
      Height = 22
      Caption = 'Todo'
      TabOrder = 10
      OnClick = btodoClick
    end
    object bunico: TButton
      Left = 1072
      Top = 70
      Width = 65
      Height = 22
      Caption = 'Ejecuta'
      TabOrder = 11
      OnClick = bunicoClick
    end
    object bvarios: TButton
      Left = 1072
      Top = 110
      Width = 65
      Height = 22
      Caption = 'Todos'
      TabOrder = 12
      OnClick = bvariosClick
    end
    object cmbbib: TComboBox
      Left = 769
      Top = 124
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 13
      OnChange = cmbbibChange
    end
    object Button1: TButton
      Left = 1072
      Top = 142
      Width = 65
      Height = 22
      Caption = 'Edita Fuente'
      TabOrder = 14
      OnClick = Button1Click
    end
    object dbg2: TDBGrid
      Left = 1144
      Top = 57
      Width = 505
      Height = 120
      DataSource = ds2
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      ReadOnly = True
      TabOrder = 15
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnCellClick = dbgtsmaestraCellClick
    end
    object rgclase: TRadioGroup
      Left = 696
      Top = 56
      Width = 65
      Height = 57
      Caption = 'Clase'
      ItemIndex = 0
      Items.Strings = (
        'TAB'
        'FIL')
      TabOrder = 16
    end
  end
  object memo: TRichEdit
    Left = 771
    Top = 177
    Width = 577
    Height = 511
    Align = alRight
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 1
    WordWrap = False
  end
  object dg: TDrawGrid
    Left = 0
    Top = 177
    Width = 763
    Height = 511
    Align = alClient
    ColCount = 1
    DefaultColWidth = 150
    DefaultRowHeight = 54
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    TabOrder = 2
    OnDrawCell = dgDrawCell
    OnSelectCell = dgSelectCell
  end
  object DataSource1: TDataSource
    DataSet = ADOtsmaestra
    Left = 472
    Top = 272
  end
  object ADOtsmaestra: TADOQuery
    Parameters = <>
    Left = 432
    Top = 272
  end
  object ds2: TDataSource
    DataSet = ado2
    Left = 1296
    Top = 144
  end
  object ado2: TADOQuery
    Parameters = <>
    Left = 1256
    Top = 144
  end
end
