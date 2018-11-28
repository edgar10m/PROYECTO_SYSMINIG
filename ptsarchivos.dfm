object ftsarchivos: Tftsarchivos
  Left = 607
  Top = 139
  Width = 761
  Height = 583
  HorzScrollBar.ParentColor = False
  VertScrollBar.Range = 30
  AutoScroll = False
  Caption = 'Sys-Mining 6.0.1 - Matriz CRUD'
  Color = 13405336
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  Icon.Data = {
    0000010001001010000001002000680400001600000028000000100000002000
    000001002000000000004004000000000000000000000000000000000000FF00
    FFFF353535FF353535FF353535FF353535FF353535FF353535FF353535FF3535
    35FF353535FF353535FF353535FF353535FF353535FF353535FFFF00FFFF7979
    79FFC0C0C0FF909090FF909090FF909090FF909090FF909090FF909090FF9090
    90FF909090FF909090FF909090FF909090FF818181FF818181FF353535FF7979
    79FFD3D3D3FFBEBEBEFFC0C0C0FFC4C4C4FFC6C6C7FFC9C9C9FFCCCCCCFFCECE
    CFFFD1D1D1FFD3D3D3FFD6D5D5FFD8D7D8FFD9D9DAFF838383FF353535FF7979
    79FFD3D3D3FFBBBBBBFFBEBEBDFFC1C1C1FFC3C4C4FFC6C6C7FFC9C9C9FFCCCC
    CCFFCFCFCEFFD2D1D2FFD3D4D3FFD6D6D6FFD8D8D8FF838383FF353535FF7979
    79FFD3D3D3FFB8B8B8FF000000FF000000FF606060FFC3C4C3FF636363FFCACA
    C9FF666666FFCFCFCFFF0000BCFF0000BCFFD6D6D6FF838383FF353535FF7979
    79FFD9D9D9FFB6B7B7FFB9B9B9FFBBBBBCFFBFBEBFFFC1C1C2FFC4C4C4FFC7C7
    C6FFC9C9CAFFCCCCCDFFCFCFCFFFD1D1D2FFD4D4D4FF878787FF353535FF7979
    79FFE4E4E4FFB4B4B4FF000000FF000000FF5E5E5DFFBFBFBEFF606161FFC4C4
    C4FF636363FFCACACAFF0000BCFF0000BCFFD2D2D2FF8B8B8BFF353535FF7979
    79FFECECECFFB2B2B2FFB4B4B5FFB7B7B6FFB9BAB9FFBCBCBCFFBFBFBFFFC1C2
    C1FFC4C4C5FFC8C7C7FFCACACBFFCDCDCDFFD0CFD0FF8E8E8EFF353535FF7979
    79FFEFEFEFFFB0B0B0FF000000FF000000FF000000FF000000FF5E5E5EFFBFBF
    C0FF616161FFC4C5C5FF0000BCFF0000BCFFCDCDCDFF909090FF353535FF7979
    79FFEFEFEFFFAFAEAEFFB1B0B0FFB2B3B2FFB5B4B5FFB7B7B8FFBABAB9FFBCBC
    BCFFBFC0C0FFC2C2C2FFC5C5C5FFC8C8C7FFCACACBFF909090FF353535FF7979
    79FFEFEFEFFFADACADFF000000FF000000FF595959FFB5B4B5FF5C5C5BFFBABB
    BAFF5E5E5EFFC0C0C0FF0000BCFF0000BCFFC8C8C8FF909090FF353535FF7979
    79FFEFEFEFFFABABABFFADADADFFAEAFAFFFB1B1B0FFB3B3B2FFB5B5B5FFB7B8
    B8FFBABABAFFBDBDBDFFBFC0C0FFC3C2C3FFC5C6C5FF909090FF353535FF7979
    79FFEFEFEFFFAAAAAAFF000000FF000000FF000000FF000000FF595959FFB5B5
    B5FF5C5C5BFFBBBBBAFF0000BCFF0000BCFFC3C3C3FF909090FF353535FF7979
    79FFEFEFEFFFAAAAAAFFAAAAAAFFABACABFFADADADFFAFAFAFFFB1B1B0FFB3B3
    B3FFB6B6B5FFB8B8B8FFBABABBFFBEBEBDFFC0C1C0FF909090FF353535FF7979
    79FFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFECEC
    ECFFE4E4E4FFDCDCDCFFD7D7D7FFD1D1D1FFCACACAFFC1C1C1FF353535FFFF00
    FFFF797979FF797979FF797979FF737373FF6E6E6EFF666666FF5C5C5CFF5757
    57FF4F4F4FFF474747FF3C3C3CFF3C3C3CFF353535FF353535FFFF00FFFF0000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = False
  Position = poDefaultPosOnly
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 364
    Width = 745
    Height = 5
    Cursor = crVSplit
    Align = alBottom
    Beveled = True
    Color = cl3DDkShadow
    ParentColor = False
  end
  object Splitter2: TSplitter
    Left = 0
    Top = 453
    Width = 745
    Height = 5
    Cursor = crVSplit
    Align = alBottom
    Beveled = True
    Color = cl3DDkShadow
    ParentColor = False
  end
  object lv: TListView
    Tag = 2
    Left = 0
    Top = 33
    Width = 909
    Height = 32
    Checkboxes = True
    Color = clWhite
    Columns = <
      item
        Caption = 'Archivo'
        Width = 150
      end
      item
        Caption = 'Tipo'
        Width = 40
      end
      item
        Caption = 'Libreria'
        Width = 60
      end
      item
        Caption = 'Componente'
        Width = 150
      end
      item
        Caption = 'Step'
      end
      item
        Caption = 'Utiler'#237'a'
      end
      item
        Caption = 'Tipo'
      end
      item
        Caption = 'Libreria'
      end
      item
        Caption = 'Componente'
      end
      item
        Caption = 'Organizaci'#243'n'
      end
      item
        Alignment = taCenter
        Caption = 'SQL'
        Width = 58
      end
      item
        Alignment = taCenter
        Caption = 'Input'
      end
      item
        Caption = 'Output'
      end
      item
        Alignment = taCenter
        Caption = 'I-O'
      end
      item
        Caption = 'Shr'
      end
      item
        Caption = 'New'
      end
      item
        Caption = 'Old'
      end
      item
        Caption = 'Mod'
      end>
    DragMode = dmAutomatic
    GridLines = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    Visible = False
    OnClick = lvClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 745
    Height = 33
    Align = alTop
    Color = clMenuBar
    TabOrder = 1
    DesignSize = (
      745
      33)
    object lbltotal: TLabel
      Left = 390
      Top = 11
      Width = 30
      Height = 13
      Caption = 'Total'
      Color = clMenuBar
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Visible = False
    end
    object cmbarchivo: TEdit
      Left = 54
      Top = 4
      Width = 307
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 0
      OnClick = cmbarchivoClick
      OnExit = cmbarchivoExit
      OnKeyPress = cmbarchivoKeyPress
    end
    object bmas: TButton
      Left = 627
      Top = 4
      Width = 113
      Height = 25
      Anchors = [akBottom]
      Caption = 'Cargar m'#225's registros'
      TabOrder = 1
      Visible = False
      OnClick = bmasClick
    end
    object StaticText1: TStaticText
      Left = 8
      Top = 8
      Width = 40
      Height = 17
      Caption = 'Archivo'
      TabOrder = 2
    end
  end
  object lvindice: TListView
    Left = 0
    Top = 458
    Width = 745
    Height = 87
    Align = alBottom
    Color = clMenuBar
    Columns = <
      item
        Caption = 'Linea'
        Width = 100
      end
      item
        Caption = 'Texto'
        Width = 550
      end>
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Courier New'
    Font.Style = []
    GridLines = True
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    TabOrder = 2
    ViewStyle = vsReport
    OnClick = lvindiceClick
  end
  object textorich: TRichEdit
    Left = 240
    Top = 224
    Width = 97
    Height = 49
    Color = clMenuBar
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    PopupMenu = PopupMenu1
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 3
    Visible = False
    WordWrap = False
  end
  object texto: TMemo
    Left = 0
    Top = 369
    Width = 745
    Height = 84
    Align = alBottom
    Color = clMenuBar
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    HideSelection = False
    ParentFont = False
    PopupMenu = PopupMenu1
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 4
    WordWrap = False
  end
  object web: TWebBrowser
    Left = 0
    Top = 33
    Width = 745
    Height = 305
    Align = alClient
    TabOrder = 5
    OnProgressChange = webProgressChange
    OnBeforeNavigate2 = webBeforeNavigate2
    OnDocumentComplete = webDocumentComplete
    ControlData = {
      4C000000FF4C0000861F00000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object SaveDialog1: TSaveDialog
    Left = 176
    Top = 144
  end
  object PopupMenu1: TPopupMenu
    Left = 304
    Top = 160
    object Editarcopia1: TMenuItem
      Caption = 'Editar copia'
      OnClick = textoDblClick
    end
  end
  object ExcelApplication1: TExcelApplication
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    AutoQuit = False
    Left = 432
    Top = 112
  end
  object mnuPrincipal: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    Bars = <
      item
        AllowClose = False
        AllowCustomizing = False
        AllowQuickCustomizing = False
        AllowReset = False
        Caption = 'Men'#250' Principal'
        DockedDockingStyle = dsBottom
        DockedLeft = 0
        DockedTop = 0
        DockingStyle = dsBottom
        FloatLeft = 389
        FloatTop = 579
        FloatClientWidth = 106
        FloatClientHeight = 49
        ItemLinks = <
          item
            Item = mnuImprimir
            Visible = True
          end
          item
            BeginGroup = True
            Item = mnuExportar
            Visible = True
          end>
        Name = 'Menu'
        OneOnRow = True
        Row = 0
        ShowMark = False
        SizeGrip = False
        UseOwnFont = False
        UseRestSpace = True
        Visible = True
        WholeRow = False
      end>
    CanCustomize = False
    Categories.Strings = (
      'Conexion')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    Images = dm.ImageList1
    LookAndFeel.Kind = lfUltraFlat
    LookAndFeel.NativeStyle = False
    PopupMenuLinks = <>
    Style = bmsFlat
    UseSystemFont = False
    Left = 256
    Top = 152
    DockControlHeights = (
      0
      0
      0
      26)
    object mnuImprimir: TdxBarButton
      Caption = 'Imprimir'
      Category = 0
      Hint = 'Imprimir'
      Visible = ivNever
      ImageIndex = 27
      PaintStyle = psCaptionGlyph
      ShortCut = 16464
      OnClick = mnuImprimirClick
    end
    object mnuExportar: TdxBarButton
      Caption = 'Exportar a Excel'
      Category = 0
      Hint = 'Exportar a Excel'
      Visible = ivNever
      ImageIndex = 24
      PaintStyle = psCaptionGlyph
      ShortCut = 49221
      OnClick = mnuExportarClick
    end
  end
  object CustomizeDlg1: TCustomizeDlg
    StayOnTop = False
    Left = 104
    Top = 104
  end
end
