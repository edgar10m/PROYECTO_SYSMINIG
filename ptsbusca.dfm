object ftsbusca: Tftsbusca
  Left = 258
  Top = 113
  Width = 1029
  Height = 700
  HelpType = htKeyword
  HelpKeyword = ' '
  HorzScrollBar.ParentColor = False
  BiDiMode = bdLeftToRight
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderWidth = 1
  Caption = 'B'#250'squeda en Componentes'
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  Icon.Data = {
    0000010001001010000001002000680400001600000028000000100000002000
    000001002000000000004004000000000000000000000000000000000000C0C0
    C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
    C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
    C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FF31415AFF31415AFFC0C0
    C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
    C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FF31415AFF31415AFFC0C0C0FFC0C0
    C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
    C0FF846163FFDEA2A5FFBD7D7BFF633031FF4A799CFFC0C0C0FF633031FFFFFF
    FFFFF7E3E7FFEFD3D6FFEFCBCEFFE7BABDFFDEAAADFFDEA2A5FFC0C0C0FF8461
    63FFEFCBCEFFE7BABDFFDEA2A5FFBD7D7BFFBD7D7BFFC0C0C0FF633031FFFFFF
    FFFFFFFFFFFFF7E3E7FFEFD3D6FFEFCBCEFFE7BABDFFDEAAADFFC0C0C0FFE7BA
    BDFFF7E3E7FFEFCBCEFFE7BABDFFDEA2A5FF633031FFC0C0C0FF633031FFFFFF
    FFFFFFFFFFFFFFFFFFFFF7E3E7FFEFD3D6FFEFCBCEFFE7BABDFFC0C0C0FFDEA2
    A5FFFFFFFFFFF7E3E7FFEFCBCEFFE7BABDFF846163FFC0C0C0FF633031FFFFFF
    FFFFFFFFFFFFFFFFFFFFFFFFFFFFF7E3E7FFEFD3D6FFEFCBCEFFC0C0C0FF6330
    31FFEFCBCEFFFFFFFFFFF7E3E7FFBD7D7BFFDEC7C6FFB58E8CFF633031FFFFFF
    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7E3E7FFEFD3D6FFC0C0C0FFC0C0
    C0FFBD7D7BFF633031FF846163FFC0C0C0FFA57573FFAD827BFF633031FF6330
    31FF633031FF633031FF633031FF633031FF633031FF633031FFC0C0C0FFC0C0
    C0FFC6DFDEFFC0C0C0FFC0C0C0FFC0C0C0FF8C5D5AFFB58E8CFFBD9E9CFF6330
    31FF633031FF633031FF633031FF633031FF633031FF633031FFC0C0C0FFC0C0
    C0FF6BDFFFFFBDDBDEFFC0C0C0FFC0C0C0FF733431FFCE9694FFC69A9CFFDEB2
    B5FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
    C0FF6BDFFFFF9CFBFFFF008284FF008284FF6B2C21FF733431FF7B4139FF8449
    42FF108A8CFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
    C0FF6BDFFFFF9CFBFFFF9CFBFFFF9CFBFFFF9CFBFFFF9CFBFFFF9CFBFFFF6B2C
    29FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
    C0FF6BDFFFFF9CFBFFFF008284FF008284FFC0C0C0FFC0C0C0FFC0C0C0FF6B24
    21FF399A9CFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
    C0FF73DFFFFFBDDBDEFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
    C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
    C0FFC6E3E7FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
    C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FF0000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = False
  ParentBiDiMode = False
  Position = poDefaultPosOnly
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMenu: TPanel
    Left = 0
    Top = 0
    Width = 300
    Height = 634
    Align = alLeft
    BevelInner = bvLowered
    BorderWidth = 3
    ParentBackground = False
    TabOrder = 0
    Visible = False
    object grdConsultas: TcxGrid
      Left = 5
      Top = 5
      Width = 290
      Height = 624
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      LookAndFeel.Kind = lfFlat
      LookAndFeel.NativeStyle = True
      RootLevelOptions.DetailFrameColor = clBlack
      object grdConsultasDBTableView1: TcxGridDBTableView
        OnDblClick = grdConsultasDBTableView1DblClick
        DataController.DataSource = dtsConsultas
        DataController.Filter.Criteria = {FFFFFFFF0000000000}
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        NavigatorButtons.ConfirmDelete = False
        OptionsCustomize.ColumnFiltering = False
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsSelection.HideSelection = True
        OptionsSelection.InvertSelect = False
        OptionsView.CellAutoHeight = True
        OptionsView.ColumnAutoWidth = True
        OptionsView.GridLineColor = clBlack
        OptionsView.GroupByBox = False
        OptionsView.HeaderAutoHeight = True
        object grdConsultasDBTableView1ConsultaCaption: TcxGridDBColumn
          Caption = 'Historial de consultas'
          SortOrder = soAscending
          Width = 100
          DataBinding.FieldName = 'ConsultaCaption'
        end
        object grdConsultasDBTableView1ConsultaFechaHora: TcxGridDBColumn
          Caption = 'Fecha-Hora'
          DataBinding.FieldName = 'FechaHoraCaption'
        end
      end
      object grdConsultasLevel1: TcxGridLevel
        GridView = grdConsultasDBTableView1
      end
    end
  end
  object Panel1: TPanel
    Left = 300
    Top = 0
    Width = 711
    Height = 634
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 4
    object Panel4: TPanel
      Left = 1
      Top = 1
      Width = 709
      Height = 157
      Align = alTop
      AutoSize = True
      TabOrder = 0
      object Panel2: TPanel
        Left = 1
        Top = 1
        Width = 707
        Height = 50
        Align = alTop
        BevelOuter = bvNone
        Color = clWhite
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 0
        object Label1: TLabel
          Left = 10
          Top = 6
          Width = 67
          Height = 16
          Caption = 'Bibliotecas'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label3: TLabel
          Left = 10
          Top = 27
          Width = 38
          Height = 16
          Caption = 'Busca'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object combo: TComboBox
          Left = 80
          Top = 26
          Width = 600
          Height = 21
          Color = clWhite
          ItemHeight = 13
          TabOrder = 1
          OnChange = comboChange
          OnClick = comboClick
          Items.Strings = (
            '')
        end
        object cmbbiblioteca: TComboBox
          Left = 80
          Top = 3
          Width = 600
          Height = 21
          HelpKeyword = ' '
          Style = csDropDownList
          Color = clWhite
          ItemHeight = 13
          TabOrder = 0
          OnChange = cmbbibliotecaChange
        end
        object BitBtn1: TBitBtn
          Left = 689
          Top = 3
          Width = 24
          Height = 21
          Hint = 'Ayuda para B'#250'squeda en Componentes'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          Visible = False
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            20000000000000040000130B0000130B00000000000000000000FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00AD744423AC72417DAA703FDBA86D3CF3A76B3AF3A569
            37DBA468357DA3663323FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00B57E5153B37C4EE6D7BBA3FFE9DACAFFECE0D1FFECE0D1FFE8D8
            C8FFD3B59CFFA76C3AE6A66A3853FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00BD895F53BB875BF4E7D5C4FFE5D2BFFFC9A685FFB88E67FFB68A65FFC5A1
            80FFE0CCBAFFE3D0BEFFAB7040F4A96E3D53FFFFFF00FFFFFF00FFFFFF00C695
            6D22C3926AE5EAD8C9FFE3CDBAFFC0946BFFBA8C62FFCFB094FFCFB094FFB789
            5FFFB28761FFDAC0AAFFE4D1C0FFAE7546E5AD734322FFFFFF00FFFFFF00CC9E
            787EE4CCB9FFEAD6C5FFC79971FFBF9066FFBF9066FFF7F1ECFFF6F0EAFFB789
            5FFFB7895FFFB58963FFE2CEBBFFD9BDA6FFB27B4D7EFFFFFF00FFFFFF00D3A7
            84DBEFE1D3FFD9B595FFC7986CFFC39569FFC19367FFBF9066FFBF9066FFBB8B
            63FFB98A63FFB88A62FFCBA786FFEADCCCFFB88357DBFFFFFF00FFFFFF00D9B0
            8FF6F2E4D9FFD1A57AFFC5996BFFC4976AFFC49669FFFAF6F2FFF3EAE1FFC295
            6DFFBE8F65FFBE8F64FFC0956DFFEFE3D5FFBF8C61F6FFFFFF00FFFFFF00E0B9
            99F6F2E5DAFFD1A67EFFCC9D71FFC79A6CFFC5986BFFE2CCB6FFF8F3EEFFF6EE
            E8FFD9BDA1FFC29468FFC59B71FFF0E2D6FFC5956CF6FFFFFF00FFFFFF00E6C1
            A3DBF3E5D9FFDFBB9EFFCFA075FFCD9E72FFF5EBE3FFE4CBB4FFE7D3BFFFFBF8
            F6FFE5D3BFFFC4986BFFD6B491FFEEE0D2FFCC9E78DBFFFFFF00FFFFFF00EBC9
            AD7EF4E3D4FFEFDCCDFFD5A87EFFD0A077FFFBF8F5FFFCF8F5FFFCF8F5FFFBF8
            F5FFD1A881FFCFA47BFFEAD5C3FFEAD4C2FFD2A7837EFFFFFF00FFFFFF00F1D0
            B522EFCEB3E5F6E9DDFFECD8C6FFD7AC81FFDCBB9AFFF6ECE3FFF5ECE2FFE4C8
            AEFFD2A77BFFE6CEBAFFF1E2D5FFDBB391E5D9B08E22FFFFFF00FFFFFF00FFFF
            FF00F4D4BB53F2D2B8F4F7EADFFFEEDED0FFE3C1A7FFD8AE89FFD7AC86FFDDBB
            9CFFEBD6C7FFF3E6D9FFE3BE9FF4E1BB9C53FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00F6D8BF53F5D6BDE6F9E9DCFFF6E8DDFFF3E5DAFFF3E5DAFFF5E7
            DCFFF5E4D6FFEBC8ACE6E9C6A953FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00F9DBC423F8DAC27DF7D8C0DBF6D7BEF3F4D5BCF3F3D3
            B9DBF1D1B77DF0CFB423FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00}
        end
      end
      object Panel6: TPanel
        Left = 1
        Top = 51
        Width = 707
        Height = 71
        Align = alTop
        BevelOuter = bvNone
        Color = clWhite
        TabOrder = 1
        Visible = False
        object lblquery: TLabel
          Left = 10
          Top = 20
          Width = 36
          Height = 16
          Caption = 'Query'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object EditaQuery: TMemo
          Left = 81
          Top = 0
          Width = 600
          Height = 70
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
      object Panel5: TPanel
        Left = 1
        Top = 122
        Width = 707
        Height = 34
        Align = alTop
        BevelOuter = bvNone
        Color = clWhite
        TabOrder = 2
        object Label4: TLabel
          Left = 245
          Top = 6
          Width = 60
          Height = 16
          Caption = 'M'#225'scaras'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          WordWrap = True
        end
        object ypaginas: TPanel
          Left = 0
          Top = -1
          Width = 233
          Height = 30
          Color = clWhite
          TabOrder = 0
          Visible = False
          object Label2: TLabel
            Left = 64
            Top = 12
            Width = 33
            Height = 13
            Caption = 'P'#225'gina'
          end
          object lblpaginas: TLabel
            Left = 171
            Top = 12
            Width = 6
            Height = 13
            Caption = '0'
          end
          object cmbpagina: TComboBox
            Left = 104
            Top = 4
            Width = 57
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 0
            OnClick = cmbpaginaClick
          end
          object Bindice: TButton
            Left = 8
            Top = 2
            Width = 49
            Height = 25
            Caption = 'Indice'
            TabOrder = 1
            OnClick = BindiceClick
          end
        end
        object cmbmascara: TComboBox
          Left = 312
          Top = 1
          Width = 297
          Height = 21
          Color = clWhite
          ItemHeight = 13
          TabOrder = 1
          OnChange = cmbmascaraChange
          Items.Strings = (
            '*')
        end
        object bejecuta: TBitBtn
          Left = 612
          Top = 1
          Width = 69
          Height = 21
          Caption = 'Ejecutar'
          Default = True
          TabOrder = 2
          OnClick = bejecutaClick
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            20000000000000040000130B0000130B00000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFF1FFF2EFD6FFDCCBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFADFFADC617FF32B37CFF8BB0F0FFF2EAFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFB1FFACB000AC03E500D60ECD07FF1999BEFFC3C3FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFB7FFB4A6008302EF009303ED00AD04E500C207D55BFF5F96EAFF
            EAE7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFCBFFC4B103A70099008001E7007F03F7008F03F200A404EF00B7
            01C6B1FFAEB6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFD3FFCAB35BFF446326FF125806B70087009701B3009004CD009D
            05D300C004AB68FF6689FCFFFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFC9FFC5B434FF2A6356FF416365FF4F675EFF4D684DFF466C4EFF
            4E7046FF4874A1FF9D97FEFFFEFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFC2FFC2B813FF216D23FF2A6835FF306549FF396258FF416365FF
            5167DCFFD8BDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFBDFFBDBE10FF207C10FF237519FF2B721DFF20679EFF978CF6FF
            F5EAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFB8FFB7C61DFF26941BFF2A8C29FF3479CDFFCFC3FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFB5FFB2CB1FFF22A381FF7C9FF2FFF2EFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFF2FFF1EFD7FFD2D2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        end
      end
    end
    object Panel3: TPanel
      Left = 1
      Top = 158
      Width = 709
      Height = 475
      Align = alClient
      AutoSize = True
      Caption = 'Panel1'
      TabOrder = 1
      object split1: TSplitter
        Left = 273
        Top = 1
        Width = 5
        Height = 473
        Beveled = True
        Color = cl3DDkShadow
        ParentColor = False
      end
      object web1: TWebBrowser
        Left = 1
        Top = 1
        Width = 272
        Height = 473
        TabStop = False
        Align = alLeft
        TabOrder = 0
        OnBeforeNavigate2 = web1BeforeNavigate2
        OnDocumentComplete = web1DocumentComplete
        ControlData = {
          4C0000001D1C0000E33000000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
      object Panel7: TPanel
        Left = 278
        Top = 1
        Width = 430
        Height = 473
        Align = alClient
        TabOrder = 1
        object Splitter1: TSplitter
          Left = 1
          Top = 162
          Width = 428
          Height = 9
          Cursor = crVSplit
          Align = alTop
          Beveled = True
          Color = cl3DDkShadow
          ParentColor = False
        end
        object rich: TRichEdit
          Left = 1
          Top = 171
          Width = 428
          Height = 301
          Cursor = 8
          TabStop = False
          Align = alClient
          Color = clMenuBar
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier'
          Font.Style = []
          Lines.Strings = (
            '- Requiere al menos de 3 caracteres como patr'#243'n de b'#250'squeda')
          ParentFont = False
          PlainText = True
          ScrollBars = ssBoth
          TabOrder = 0
          WordWrap = False
        end
        object Web2: TWebBrowser
          Left = 1
          Top = 1
          Width = 428
          Height = 161
          Align = alTop
          TabOrder = 1
          OnBeforeNavigate2 = Web2BeforeNavigate2
          ControlData = {
            4C0000003C2C0000A41000000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
      end
    end
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
            Item = mnuAyuda
            Visible = True
          end
          item
            Item = mnuConsultas
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
    Left = 784
    Top = 192
    DockControlHeights = (
      0
      0
      0
      26)
    object mnuAyuda: TdxBarButton
      Caption = ' '
      Category = 0
      Hint = ' '
      Visible = ivAlways
      ImageIndex = 30
      PaintStyle = psCaption
      ShortCut = 112
      OnClick = mnuAyudaClick
    end
    object mnuConsultas: TdxBarButton
      Align = iaRight
      Category = 0
      Visible = ivAlways
      ShortCut = 119
      OnClick = mnuConsultasClick
    end
  end
  object pop: TPopupMenu
    Left = 600
    Top = 272
    object Notepad1: TMenuItem
      Caption = 'Notepad'
      OnClick = Notepad1Click
    end
  end
  object dtsConsultas: TDataSource
    DataSet = dm.tabConsultas
    Left = 664
    Top = 219
  end
end
