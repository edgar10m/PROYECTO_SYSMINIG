object ftsdgcompo: Tftsdgcompo
  Left = 387
  Top = 128
  Width = 631
  Height = 600
  VertScrollBar.Color = 14988991
  VertScrollBar.ParentColor = False
  BorderWidth = 3
  Caption = 'Sys-Mining  -  ftsdgcompo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  Icon.Data = {
    0000010001001010000001002000680400001600000028000000100000002000
    0000010020000000000040040000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    00000000000062C06FFF5EBD6BFF5BBA67FF57B763FF00000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000005FBE6CFFABDAB0FFA7D8ADFF54B560FF00000000000000000000
    0000000000000000000000000000000000000000000000000000BDBDBDFFB7B7
    B7FF000000005DBC69FFA8D9AEFFA4D7ABFF52B35DFF00000000000000000000
    0000000000000000000000000000000000000000000000000000BBBBBBFF0000
    0000000000005ABA67FF56B762FF53B45EFF4FB15AFF00000000000000000000
    0000000000000000000000000000000000000000000000000000B8B8B8FF0000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000B3B3B3FF0000
    0000000000000000000000000000000000000000000000000000000000000000
    0000F4BF94FFF0B88AFFE9AF7CFFE1A36CFF0000000000000000ABABABFF0000
    00000000000048FFFFFF48FFFFFF48FFFFFF48FFFFFF00000000000000000000
    0000F0B98AFFF0D4C9FFEDCBBFFFD7985EFF00000000B5B5B5FFA1A1A1FF0000
    00000000000048FFFFFF90FFFFFF90FFFFFF48FFFFFF00000000000000000000
    0000EAB17EFFEECDC1FFEAC2B7FFCD8B4FFF00000000B0B0B0FF989898FF0000
    00000000000048FFFFFF90FFFFFF90FFFFFF00D9D9FF00000000000000000000
    0000E2A76FFFD89B5FFFCE8C50FFC37D41FF00000000000000008D8D8DFF0000
    00000000000048FFFFFF48FFFFFF00D9D9FF00D9D9FF00000000000000000000
    0000000000000000000000000000000000000000000000000000818181FF0000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000767676FF0000
    0000000000000000000000000000000000000000000000000000000000000000
    00000000000000000000000000000000000000000000000000006C6C6CFF0000
    0000000000009090FFFF9090FFFF9090FFFF9090FFFF00000000000000000000
    0000000000000000000000000000000000000000000000000000636363FF5C5C
    5CFF000000009090FFFFB4B4FFFFB4B4FFFF9090FFFF00000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000009090FFFFB4B4FFFFB4B4FFFF6C6CFFFF00000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000009090FFFF9090FFFF6C6CFFFF4848FFFF0000000000000000FFC3
    0000FFC30000FE430000FEC30000FEFF0000FEFF000086C3000084C3000084C3
    000086C30000FEFF0000FEFF0000FEC30000FE430000FFC30000FFC30000}
  KeyPreview = True
  OldCreateOrder = False
  Position = poDefaultPosOnly
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 78
    Width = 617
    Height = 482
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 4
    object TabSheet1: TTabSheet
      BorderWidth = 3
      Caption = 'Web'
      TabVisible = False
      object web1: TWebBrowser
        Left = 0
        Top = 0
        Width = 603
        Height = 448
        Align = alClient
        TabOrder = 0
        OnProgressChange = web1ProgressChange
        OnBeforeNavigate2 = web1BeforeNavigate2
        OnDocumentComplete = web1DocumentComplete
        ControlData = {
          4C000000523E00004D2E00000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126209000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
    end
    object TabSheet2: TTabSheet
      BorderWidth = 3
      Caption = 'Diagrama'
      ImageIndex = 1
      object atDiagramdgcompo: TatDiagram
        Left = 0
        Top = 0
        Width = 603
        Height = 448
        NettoExportOffset = 3
        AutomaticNodes = False
        AutoScroll = True
        AutoPage = False
        Background.Scroll = True
        Background.Style = biTile
        Background.Visible = False
        Background.Gradient.Direction = grTopBottom
        Background.Gradient.StartColor = clWhite
        Background.Gradient.EndColor = clYellow
        Background.Gradient.Visible = False
        Background.PrintGradient = False
        SnapGrid.Active = False
        SnapGrid.Force = False
        SnapGrid.Visible = False
        SnapGrid.SizeX = 8.000000000000000000
        SnapGrid.SizeY = 8.000000000000000000
        SnapGrid.Style = gsDots
        SnapGrid.SnapToRuler = False
        ShowLinkPoints = True
        LeftRuler.Visible = False
        LeftRuler.Divisions = 5
        LeftRuler.Font.Charset = DEFAULT_CHARSET
        LeftRuler.Font.Color = clWindowText
        LeftRuler.Font.Height = -9
        LeftRuler.Font.Name = 'Arial'
        LeftRuler.Font.Style = []
        LeftRuler.Units = unCenti
        LeftRuler.MinorTickLength = 4
        LeftRuler.MajorTickLength = 6
        LeftRuler.Color = clWhite
        LeftRuler.TickColor = clBlack
        LeftRuler.Size = 16
        LeftRuler.AutoFactor = True
        LeftRuler.GridColor = clBlack
        TopRuler.Visible = False
        TopRuler.Divisions = 5
        TopRuler.Font.Charset = DEFAULT_CHARSET
        TopRuler.Font.Color = clWindowText
        TopRuler.Font.Height = -9
        TopRuler.Font.Name = 'Arial'
        TopRuler.Font.Style = []
        TopRuler.Units = unCenti
        TopRuler.MinorTickLength = 4
        TopRuler.MajorTickLength = 6
        TopRuler.Color = clWhite
        TopRuler.TickColor = clBlack
        TopRuler.Size = 16
        TopRuler.AutoFactor = True
        TopRuler.GridColor = clBlack
        Zoom = 100
        BorderColor = clGray
        MouseWheelMode = mwOff
        Layers = <>
        LinkCursor = crHandPoint
        PanCursor = crHandPoint
        ZoomCursor = crDefault
        IgnoreScreenDPI = False
        ShowCrossIndicators = False
        PageLines.Visible = False
        PageLines.Pen.Style = psDot
        KeyActions = [kaEscape, kaMove, kaPage, kaResize, kaSelect]
        HandlesStyle = hsClassic
        SmoothMode = smAntiAlias
        TextRenderingMode = tmAntiAlias
        SelectionMode = slmMultiple
        CanMoveOutOfBounds = True
        PageSettings.PaperName = 'Carta'
        PageSettings.PaperId = 1
        PageSettings.PaperWidth = 215.900000000000000000
        PageSettings.PaperHeight = 279.400000000000000000
        PageSettings.Orientation = dpoPortrait
        PageSettings.LeftMarginStr = '25.4'
        PageSettings.TopMarginStr = '25.4'
        PageSettings.RightMarginStr = '25.4'
        PageSettings.BottomMarginStr = '25.4'
        RulerAutoUnit = False
        MeasUnit = duCenti
        WheelZoom = False
        WheelZoomIncrement = 10
        WheelZoomMin = 10
        WheelZoomMax = 500
        OnSelectDControl = atDiagramdgcompoSelectDControl
        OnDControlDblClick = atDiagramdgcompoDControlDblClick
        Align = alClient
        Anchors = [akLeft, akTop, akRight, akBottom]
        BiDiMode = bdLeftToRight
        BorderStyle = bsSingle
        Color = clBtnFace
        ParentColor = False
        ShowHint = False
        TabOrder = 0
        OnMouseUp = atDiagramdgcompoMouseUp
      end
      object DgrTransparencySelector: TDgrTransparencySelector
        Left = 190
        Top = 2
        Width = 36
        Height = 22
        Hint = 'Transparencia'
        TabOrder = 1
        Version = '2.0.0.0'
        Diagram = atDiagramdgcompo
        AutoThemeAdapt = False
        BorderDownColor = 7021576
        BorderHotColor = clBlack
        Color = clBtnFace
        ColorDown = 11900292
        ColorHot = 14073525
        ColorDropDown = 16251129
        ColorSelected = 14604246
        ColorSelectedTo = clNone
        DropDownButton = True
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA05020A05020A0
          5020A05020A05020A05020A05020A05020A05020A05020FF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFA05020FFA880FFA870FFA070FFA070FF9870FF9860FF98
          60FF9060A05020FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA05020FFB080FF
          A880FFA870FFA070FFA070FF9870FF9860FF9860A05020FF00FFFF00FFFF00FF
          CDE2E71088C01088C01088C01088C01088C01088C0F0A880FFA070FFA070FFA0
          70FF9860A05020FF00FFFF00FFC1DFE61088C070D8F060D0F07098A090C0D090
          C0C090B8C01088C0E0A890FFA070FFA070FFA070A05020FF00FFE2EDE91088C0
          80E0F080E0F070D8F080A0A0A0C8D090C0D090C0C090C0C01088C0F0A880FFA8
          70FFA070A05020FF00FF45A7C790E8F090E0F080E0F080E0F080A0A0A0C8D0A0
          C8D0A0C0D090C0C090C0C01088C0FFA880FFA870A05020FF00FF1088C0A0E8F0
          90E8F090E8F080E0F090A0A0B0D0D0A0C8D0A0C8D0A0C0D090C0C01088C0FFB0
          80FFA880A05020FF00FF1088C0A0F0F0A0E8F090E8F090E8F090A8A0B0D0D0B0
          D0D0A0C8D0A0C8D0A0C8D01088C0FFB080FFB080A05020FF00FF1088C0B0F0F0
          A0F0F0A0E8F0A0E8F090A8A090A8A090A8A080A0A080A0A080A0A01088C0A050
          20A05020A05020FF00FF1088C0B0F0F0B0F0F0A0F0F0A0E8F0A0E8F090E8F090
          E0F080E0F070D8F070D8F01088C0FF00FFFF00FFFF00FFFF00FF39A2C4B0F0F0
          B0F0F0B0F0F0A0F0F0A0E8F0A0E8F090E8F090E0F080E0F080E0F045A7C7FF00
          FFFF00FFFF00FFFF00FFD3E3E71088C0B0F0F0B0F0F0B0F0F0A0F0F0A0F0F0A0
          E8F090E8F090E0F01088C0CDE2E7FF00FFFF00FFFF00FFFF00FFFF00FFC6E4E6
          1088C0B0F0F0B0F0F0B0F0F0B0F0F0A0F0F0A0E8F01088C0C1E2E6FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFD3E3E7399BC41088C01088C01088C010
          88C039A2C4D0E3E7FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        Style = ssButton
        ShowHint = True
        SelectedIndex = -1
      end
      object DgrColorSelector: TDgrColorSelector
        Left = 1
        Top = 2
        Width = 36
        Height = 22
        Hint = 'Color'
        TabOrder = 2
        Version = '2.0.0.0'
        Diagram = atDiagramdgcompo
        SelectedColor = clWhite
        ShowRGBHint = True
        AutoThemeAdapt = False
        BorderDownColor = 7021576
        BorderHotColor = clBlack
        Color = clBtnFace
        ColorDown = 11900292
        ColorHot = 14073525
        ColorDropDown = 16251129
        ColorSelected = 14604246
        ColorSelectedTo = clNone
        DropDownButton = True
        Glyph.Data = {
          3E020000424D3E0200000000000036000000280000000D0000000D0000000100
          1800000000000802000000000000000000000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF00FFFFFFFFFFFFFFFFFFFFFFFF0000007B7B7B000000FFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFF0000007B7B7B7B7B7B7B7B7B00
          0000FFFFFFFFFFFFFFFFFF7B7B7BFFFFFF00FFFFFFFFFFFF000000BDBDBDBDBD
          BDBDBDBD7B7B7B7B7B7B000000FFFFFFFFFFFF7B00007B7B7B00FFFFFF000000
          FFFFFFBDBDBDBDBDBDBDBDBDBDBDBD7B7B7B7B7B7B000000FFFFFF7B00007B00
          0000000000BDBDBDFFFFFFFFFFFFBDBDBDBDBDBDBDBDBDBDBDBD7B7B7B7B7B7B
          7B00007B00007B000000FFFFFF000000BDBDBDFFFFFFFFFFFFBDBDBD000000BD
          BDBDBDBDBD7B7B7B7B00007B00007B000000FFFFFFFFFFFF000000BDBDBDFFFF
          FF0000007B0000000000BDBDBD7B00007B00007B00007B000000FFFFFFFFFFFF
          FFFFFF000000BDBDBDFFFFFF7B0000BDBDBD7B7B7B7B00007B00007B0000FFFF
          FF00FFFFFFFFFFFFFFFFFF7B0000000000BDBDBD7B00007B7B7B0000007B7B7B
          FFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFF7B0000FFFFFF0000007B000000
          00007B7B7BFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFF7B0000FFFF
          FFFFFFFF7B00007B7B7BFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFF
          FFFFFF7B7B7B7B00007B00007B7B7BFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF00}
        ShowHint = True
        Style = ssButton
        ShowMoreColors = False
      end
      object DgrGradientDirectionSelector: TDgrGradientDirectionSelector
        Left = 36
        Top = 2
        Width = 36
        Height = 22
        Hint = 'Gradiente'
        TabOrder = 3
        Version = '2.0.0.0'
        Diagram = atDiagramdgcompo
        ShowSelectedGradient = True
        StartColor = clWhite
        EndColor = clGray
        AutoThemeAdapt = False
        BorderDownColor = 7021576
        BorderHotColor = clBlack
        Color = clBtnFace
        ColorDown = 11900292
        ColorHot = 14073525
        ColorDropDown = 16251129
        ColorSelected = 14604246
        ColorSelectedTo = clNone
        DropDownButton = True
        Style = ssButton
        SelectedIndex = -1
        ShowHint = True
      end
      object DgrBrushStyleSelector: TDgrBrushStyleSelector
        Left = 72
        Top = 2
        Width = 23
        Height = 22
        Hint = 'Relleno Estilo'
        TabOrder = 4
        Version = '2.0.0.0'
        Diagram = atDiagramdgcompo
        BrushAutoColor = True
        AutoThemeAdapt = False
        BorderDownColor = 7021576
        BorderHotColor = clBlack
        Color = clBtnFace
        ColorDown = 11900292
        ColorHot = 14073525
        ColorDropDown = 16251129
        ColorSelected = 14604246
        ColorSelectedTo = clNone
        Glyph.Data = {
          B6030000424DB603000000000000360000002800000012000000100000000100
          18000000000080030000C40E0000C40E00000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFA2B0B5575F6763757CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF96ADB750
          68704078902038408E98A0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9EB2BC60708060B8D040A8C03090B0
          2038408F99A1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFF
          FFFFFFFFFFFF98B3C37090A080D0E070D0E060B8D040A8C03090B0203840919A
          A2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFAFCDD280B8
          C090D8E080E0F080D8F070D0E060B8D040A8C03090B0304050BCBDC0FFFFFFFF
          FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFBDD8E490C0D0B0E8F0C0F8FFA0E8F090
          E0F080D8F070D0E060B8D06098A0605850504840B3B4B3FFFFFFFFFFFFFFFFFF
          0000FFFFFFFFFFFF90D0E0B0E8F0C0FFFFC0FFFFB0F8FFB0F0FF90E0F080D8F0
          80B8C0606060808080606060504840FFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFF
          A0D8E0C0F8FFC0FFFFC0FFFFC0FFFFC0FFFFB0F8FF90C8D0807880A098A08078
          70707070505040FFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFF9AC4D380B8
          C0B0F0F0C0FFFFC0FFFFB0E0E0A0A0A0E0E0E0908880B0A8B0505050918993E5
          E9EBFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFDFE6E992BAC880B0C0B0
          D8E0B0B0B0F0E8F0D0C8C0E0D8E0808080806060674A4AB6B4B6E6EAECFFFFFF
          0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCDD8DDB0B0B0E0E0E0D0C8D0
          E0E0E0A0A0A0C09890D06060903840684A4AB8B5B6FFFFFF0000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD2D4D5B0B0B0B0B0B0B0B0B0CFC7C4B088
          90D09090D06060903840684A4AFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDAC9CBC09090E09090B0
          6870806870FFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE0D8D7C29595C08890FFFFFFFFFFFF
          0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000}
        Style = ssButton
        ShowHint = True
        SelectedIndex = -1
      end
      object DgrShadowSelector: TDgrShadowSelector
        Left = 95
        Top = 2
        Width = 36
        Height = 22
        Hint = 'Sombra'
        TabOrder = 5
        Version = '2.0.0.0'
        Diagram = atDiagramdgcompo
        ShowSettingsOption = True
        AutoThemeAdapt = False
        BorderDownColor = 7021576
        BorderHotColor = clBlack
        Color = clBtnFace
        ColorDown = 11900292
        ColorHot = 14073525
        ColorDropDown = 16251129
        ColorSelected = 14604246
        ColorSelectedTo = clNone
        DropDownButton = True
        Glyph.Data = {
          3E020000424D3E0200000000000036000000280000000D0000000D0000000100
          18000000000008020000C40E0000C40E00000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF00FFFFFF509050607060607060506050304030202820101810101810101810
          101810101810FFFFFF00FFFFFF50905070C08060A86060A06050986050905050
          8850508050507850407040101810FFFFFF00FFFFFF60986080C08070C08070B8
          7060B07060A86060A060509850509040507850101810FFFFFF00FFFFFF609860
          80C89080C08070C08070B87060B07060A86060A060509850508050101810FFFF
          FF00FFFFFF60987090D09080C89080C08070C08070B87060B07060A86060A060
          508850101810FFFFFF00FFFFFF70A070A0D0A090D09080C89080C08070C08070
          B87060B07060A860509050202820FFFFFF00FFFFFF70A880B0D8B0A0D0A090D0
          9080C89080C08070C08070B87060B070509860304030FFFFFF00FFFFFF80B080
          B0E0C0B0D8B0A0D0A090D09080C89080C08070C08070B87060A060506050FFFF
          FF00FFFFFF80B890C0E0C0B0E0C0B0D8B0A0D0A090D09080C89080C08070C080
          60A860607060FFFFFF00FFFFFF80C090C0E0C0C0E0C0B0E0C0B0D8B0A0D0A090
          D09080C89080C08070C080607060FFFFFF00FFFFFF90C8A080C09080B89080B0
          8070A88070A070609870609860609860509050509050FFFFFF00FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF00}
        ShowHint = True
        Style = ssButton
        SelectedIndex = -1
      end
      object DgrPenStyleSelector: TDgrPenStyleSelector
        Left = 131
        Top = 2
        Width = 23
        Height = 22
        Hint = 'Linea Estilo'
        TabOrder = 6
        Version = '2.0.0.0'
        Diagram = atDiagramdgcompo
        AutoThemeAdapt = False
        BorderDownColor = 7021576
        BorderHotColor = clBlack
        Color = clBtnFace
        ColorDown = 11900292
        ColorHot = 14073525
        ColorDropDown = 16251129
        ColorSelected = 14604246
        ColorSelectedTo = clNone
        Glyph.Data = {
          7E030000424D7E030000000000003600000028000000130000000E0000000100
          18000000000048030000C40E0000C40E00000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF000000FFFFFFFFFF
          FF000000000000FFFFFFFFFFFF000000FFFFFFFFFFFF000000000000FFFFFFFF
          FFFF000000FFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFF000000FFFFFFFFFFFF000000000000000000FFFFFF0000000000000000
          00FFFFFF000000000000000000FFFFFF000000000000000000FFFFFFFFFFFF00
          0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF
          000000FFFFFF000000FFFFFF000000FFFFFF000000FFFFFF000000FFFFFF0000
          00FFFFFF000000FFFFFF000000FFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00FFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
          0000}
        Style = ssButton
        ShowHint = True
        SelectedIndex = -1
      end
      object DgrPenColorSelector: TDgrPenColorSelector
        Left = 154
        Top = 2
        Width = 36
        Height = 22
        Hint = 'Linea Color'
        TabOrder = 7
        Version = '2.0.0.0'
        Diagram = atDiagramdgcompo
        AutoThemeAdapt = False
        BorderDownColor = 7021576
        BorderHotColor = clBlack
        Color = clBtnFace
        ColorDown = 11900292
        ColorHot = 14073525
        ColorDropDown = 16251129
        ColorSelected = 14604246
        ColorSelectedTo = clNone
        DropDownButton = True
        Glyph.Data = {
          3E020000424D3E0200000000000036000000280000000D0000000D0000000100
          1800000000000802000000000000000000000000000000000000FF00FF000000
          7B00007B00007B00007B7B7BFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FF00FF00FFFF00FF000000FFFFFF7B00007B00007B0000FF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FF00FF00FFFF00FFFF00FF000000FFFFFF7B00007B00007B
          0000FF00FFFF00FFFF00FFFF00FFFF00FF00FF00FFFF00FFFF00FF000000FFFF
          FF7B00007B00007B00007B0000FF00FFFF00FFFF00FFFF00FF00FF00FFFF00FF
          FF00FFFF00FF000000FFFFFF7B00007B00007B00007B0000FF00FFFF00FFFF00
          FF00FF00FFFF00FFFF00FFFF00FF000000FFFFFFFFFFFF7B00007B00007B0000
          FF00FFFF00FFFF00FF00FF00FFFF00FFFF00FFFF00FFFF00FF000000FFFFFFFF
          FFFF7B00007B0000FF00FFFF00FFFF00FF00FF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FF000000000000000000000000FF00FFFF00FFFF00FF00FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FF7B7B7B00000000FFFF00FFFF000000FF00FFFF00
          FF00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00000000FFFF00FFFF
          000000FF00FFFF00FF00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FF00000000FFFF00FFFF000000FF00FF00FF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FF00}
        ShowHint = True
        SelectedColor = clBlack
        Style = ssButton
        ShowMoreColors = False
      end
      object DgrPenWidthSelector: TDgrPenWidthSelector
        Left = 226
        Top = 2
        Width = 23
        Height = 22
        Hint = 'Linea Ancho'
        TabOrder = 8
        Version = '2.0.0.0'
        Diagram = atDiagramdgcompo
        AutoThemeAdapt = False
        BorderDownColor = 7021576
        BorderHotColor = clBlack
        Color = clBtnFace
        ColorDown = 11900292
        ColorHot = 14073525
        ColorDropDown = 16251129
        ColorSelected = 14604246
        ColorSelectedTo = clNone
        Glyph.Data = {
          A6020000424DA6020000000000003600000028000000110000000C0000000100
          18000000000070020000C40E0000C40E00000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFF000000000000000000000000000000
          000000000000000000000000000000000000000000000000000000000000FFFF
          FF00FFFFFF000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000FFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFF0000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000000FFFFFF00FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF00FFFFFF000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000FFFFFF00FFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFF00}
        ShowHint = True
        Style = ssButton
        SelectedIndex = -1
      end
      object DgrTextColorSelector: TDgrTextColorSelector
        Left = 249
        Top = 2
        Width = 36
        Height = 22
        Hint = 'Texto Color'
        TabOrder = 9
        Version = '2.0.0.0'
        Diagram = atDiagramdgcompo
        AutoThemeAdapt = False
        BorderDownColor = 7021576
        BorderHotColor = clBlack
        Color = clBtnFace
        ColorDown = 11900292
        ColorHot = 14073525
        ColorDropDown = 16251129
        ColorSelected = 14604246
        ColorSelectedTo = clNone
        DropDownButton = True
        Glyph.Data = {
          3E020000424D3E0200000000000036000000280000000D0000000D0000000100
          18000000000008020000C40E0000C40E00000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF00FFFFFFA87D6885513A766049FFFFFFFFFFFFFFFFFFFFFFFF603820704020
          70402067422BFFFFFF00FFFFFFDCDDDD94603AFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFF70382076422BFFFFFFFFFFFF00FFFFFFFFFFFFB58A74A47B5DFFFF
          FFFFFFFFFFFFFFFFFFFF804830704020936E5EFFFFFFFFFFFF00FFFFFFFFFFFF
          DBD6D4A058409F6C529265529F6C5294583A804830703820FFFFFFFFFFFFFFFF
          FF00FFFFFFFFFFFFFFFFFFAC795FFFFFFFFFFFFFFFFFFF95603B905030986F5E
          FFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFCBB9ABAC795FFFFFFFD4C5BC90
          5830905030D0C3BCFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFA468
          4AE3E2E2A073529050309A6246FFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFF
          FFFFFFFFFFFFC59980BB9480A06040905030CDBBB2FFFFFFFFFFFFFFFFFFFFFF
          FF00FFFFFFFFFFFFFFFFFFFFFFFFE6E5E5B07050B07050A4684AFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC08870B07050E3
          D5CCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFBF8F77FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF00}
        ShowHint = True
        SelectedColor = clWindowText
        Style = ssButton
        ShowMoreColors = False
      end
      object DgrFontSelector: TDgrFontSelector
        Left = 2
        Top = 26
        Width = 127
        Height = 22
        Hint = 'Font Tipo'
        Button.Color = clWhite
        Button.ColorTo = 13226453
        Button.ColorHot = 13811126
        Button.ColorHotTo = 13811126
        Button.ColorDown = 11899525
        Button.ColorDownTo = 11899525
        Button.Width = 12
        DropDownCount = 8
        BorderColor = clNone
        BorderHotColor = clBlack
        SelectionColor = 11899525
        SelectionTextColor = clWhite
        Text = 'MS Sans Serif'
        Version = '2.0.0.0'
        DropDownListColor = clWindow
        Diagram = atDiagramdgcompo
        AllowedFontTypes = [aftBitmap, aftTrueType, aftPostScript, aftPrinter, aftFixedPitch, aftProportional]
        FontGlyphTT.Data = {
          D6000000424DD60000000000000076000000280000000D0000000C0000000100
          0400000000006000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDD000000D
          D000DDDDDDD00DDDD000DDDDDDD00DDDD000D77777700DDDD000DDD77DD00DDD
          D000DDD70DD00DD0D000DDD70DD00DD0D000DDD700D00D00D0007DD700000000
          D0007DD77DD7DDDDD00077D77D77DDDDD00077777777DDDDD000}
        FontGlyphPS.Data = {
          D6000000424DD60000000000000076000000280000000D0000000C0000000100
          0400000000006000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
          D000D9997DD997DDD0009999979979DDD000997D7999D79DD000997DD7997DDD
          D000997DDD799DDDD000799DDDD997DDD000D997DDD799DDD000D799DDDD997D
          D000DD799DDD799DD000DDD799DD7997D000DDDDD9999779D000}
        FontGlyphPRN.Data = {
          D6000000424DD60000000000000076000000280000000D0000000C0000000100
          0400000000006000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00D00000000000
          D00007777777AA7700000888888888870000D00000000000D000DD07FFFFF70D
          D000DD0F00000F0DD000DD07FFFFF70DD000DD0F00000F0DD000DD07FFFFF70D
          D000DD0F00000F0DD000DD07FFFFF70DD000DD000000000DD000}
        FontGlyphBMP.Data = {
          D6000000424DD60000000000000076000000280000000D0000000C0000000100
          0400000000006000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
          D000DDDDDD99DD99D000DDDDDD99DD99D000D11DD199DD99D000D11DD1999999
          D000D11DD199DD99D000D1111199DD99D000D11DD199DD99D000D11DD119999D
          D000D11DD11D99DDD000DD1111DDDDDDD000DDD11DDDDDDDD000}
        FontHeight = 12
        ParentShowHint = False
        ShowHint = True
        TabOrder = 10
      end
      object DgrFontSizeSelector1: TDgrFontSizeSelector
        Left = 135
        Top = 26
        Width = 47
        Height = 22
        Hint = 'Font Tama'#241'o'
        Button.Color = clWhite
        Button.ColorTo = 13226453
        Button.ColorHot = 13811126
        Button.ColorHotTo = 13811126
        Button.ColorDown = 11899525
        Button.ColorDownTo = 11899525
        Button.Width = 12
        DisplayRecentSelection = False
        DropDownCount = 8
        BorderColor = clNone
        BorderHotColor = clBlack
        LookUp = False
        SelectionColor = 11899525
        SelectionTextColor = clWhite
        Text = '8'
        Version = '2.0.0.0'
        DropDownListColor = clWindow
        Diagram = atDiagramdgcompo
      end
    end
    object TabSheet3: TTabSheet
      BorderWidth = 3
      Caption = 'Grid'
      ImageIndex = 2
      TabVisible = False
      object cxGrid1: TcxGrid
        Left = 0
        Top = 0
        Width = 603
        Height = 448
        Align = alClient
        TabOrder = 0
        LookAndFeel.Kind = lfUltraFlat
        LookAndFeel.NativeStyle = False
        object cxGrid1DBTableView1: TcxGridDBTableView
          DataController.DataSource = DataSource1
          DataController.Filter.Criteria = {FFFFFFFF0000000000}
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          NavigatorButtons.ConfirmDelete = False
          object cxGrid1DBTableView1RecId: TcxGridDBColumn
            DataBinding.FieldName = 'RecId'
          end
          object cxGrid1DBTableView1Programa: TcxGridDBColumn
            Width = 85
            DataBinding.FieldName = 'Programa'
          end
          object cxGrid1DBTableView1Biblioteca: TcxGridDBColumn
            Width = 90
            DataBinding.FieldName = 'Biblioteca'
          end
          object cxGrid1DBTableView1Clase: TcxGridDBColumn
            DataBinding.FieldName = 'Clase'
          end
          object cxGrid1DBTableView1Renglon: TcxGridDBColumn
            Width = 47
            DataBinding.FieldName = 'Renglon'
          end
          object cxGrid1DBTableView1Columna: TcxGridDBColumn
            Width = 48
            DataBinding.FieldName = 'Columna'
          end
          object cxGrid1DBTableView1Desplaza: TcxGridDBColumn
            Width = 48
            DataBinding.FieldName = 'Desplaza'
          end
          object cxGrid1DBTableView1NFisicoBlock: TcxGridDBColumn
            Width = 173
            DataBinding.FieldName = 'NFisicoBlock'
          end
          object cxGrid1DBTableView1NLogicoBlock: TcxGridDBColumn
            Width = 175
            DataBinding.FieldName = 'NLogicoBlock'
          end
          object cxGrid1DBTableView1LigaBlockOrigen: TcxGridDBColumn
            Width = 181
            DataBinding.FieldName = 'LigaBlockOrigen'
          end
          object cxGrid1DBTableView1LigaBlockDestino: TcxGridDBColumn
            Width = 184
            DataBinding.FieldName = 'LigaBlockDestino'
          end
          object cxGrid1DBTableView1TipoBlock: TcxGridDBColumn
            Width = 137
            DataBinding.FieldName = 'TipoBlock'
          end
        end
        object cxGrid1Level1: TcxGridLevel
          GridView = cxGrid1DBTableView1
        end
      end
    end
  end
  object mnuPrincipal: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Bars = <
      item
        AllowClose = False
        AllowCustomizing = False
        AllowQuickCustomizing = False
        AllowReset = False
        Caption = 'Men'#250' Principal'
        DockedDockingStyle = dsTop
        DockedLeft = 0
        DockedTop = 0
        DockingStyle = dsTop
        FloatLeft = 751
        FloatTop = 304
        FloatClientWidth = 91
        FloatClientHeight = 174
        ItemLinks = <
          item
            Item = mnuGuardar
            Visible = True
          end
          item
            BeginGroup = True
            Item = mnuImprimir
            Visible = True
          end
          item
            Item = mnuVistaPreliminar
            Visible = True
          end
          item
            Item = mnuPaginaConf
            Visible = True
          end
          item
            BeginGroup = True
            Item = mnuDeshacer
            Visible = True
          end
          item
            Item = mnuRehacer
            Visible = True
          end
          item
            BeginGroup = True
            Item = mnuZoom
            Visible = True
          end
          item
            BeginGroup = True
            Item = mnuVer
            Visible = True
          end
          item
            BeginGroup = True
            Item = mnuExportar
            Visible = True
          end
          item
            BeginGroup = True
            Item = mnuBuscar
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
      end
      item
        Caption = 'Objetos'
        DockedDockingStyle = dsTop
        DockedLeft = 0
        DockedTop = 26
        DockingStyle = dsTop
        FloatLeft = 404
        FloatTop = 229
        FloatClientWidth = 23
        FloatClientHeight = 22
        ItemLinks = <
          item
            Item = mnuObjetoColor
            Visible = True
          end
          item
            Item = mnuGradiente
            Visible = True
          end
          item
            Item = mnuCepillarEstilo
            Visible = True
          end
          item
            Item = mnuSombra
            Visible = True
          end
          item
            Item = mnuLineaEstilo
            Visible = True
          end
          item
            Item = mnuLineaColor
            Visible = True
          end
          item
            Item = mnuTransparencia
            Visible = True
          end
          item
            Item = mnuLineaAncho
            Visible = True
          end
          item
            Item = mnuTextoColor
            Visible = True
          end
          item
            BeginGroup = True
            Item = mnuFontTipo
            Visible = True
          end
          item
            BeginGroup = True
            Item = mnuFontTamanio
            Visible = True
          end
          item
            BeginGroup = True
            Item = mnuBold
            Visible = True
          end
          item
            Item = mnuItalic
            Visible = True
          end
          item
            Item = mnuUnderline
            Visible = True
          end
          item
            Item = mnuStrikeOut
            Visible = True
          end>
        Name = 'Objetos'
        OneOnRow = True
        Row = 1
        ShowMark = False
        SizeGrip = False
        UseOwnFont = False
        UseRestSpace = True
        Visible = True
        WholeRow = False
      end
      item
        Caption = 'Busqueda'
        DockedDockingStyle = dsTop
        DockedLeft = 0
        DockedTop = 52
        DockingStyle = dsTop
        FloatLeft = 447
        FloatTop = 215
        FloatClientWidth = 23
        FloatClientHeight = 22
        ItemLinks = <
          item
            Item = mnuTextoBuscar
            Visible = True
          end
          item
            Item = mnuBuscarAnterior
            Visible = True
          end
          item
            Item = mnuBuscarSiguiente
            Visible = True
          end>
        Name = 'Busqueda'
        OneOnRow = True
        Row = 2
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
    ImageListBkColor = clInactiveCaption
    Images = dm.ImageList1
    LookAndFeel.Kind = lfUltraFlat
    LookAndFeel.NativeStyle = False
    PopupMenuLinks = <>
    Style = bmsFlat
    UseSystemFont = False
    Left = 368
    Top = 40
    DockControlHeights = (
      0
      0
      78
      0)
    object mnuExportarExcel: TdxBarButton
      Caption = 'Excel'
      Category = 0
      Hint = 'Exporta a Excel'
      Visible = ivAlways
      ImageIndex = 24
      PaintStyle = psCaptionGlyph
      OnClick = mnuExportarExcelClick
    end
    object mnuAyuda: TdxBarButton
      Align = iaRight
      Caption = 'Ayuda'
      Category = 0
      Hint = 'Ayuda'
      Visible = ivAlways
      ImageIndex = 30
      PaintStyle = psCaption
      ShortCut = 112
      OnClick = mnuAyudaClick
    end
    object mnuGuardar: TdxBarButton
      Caption = 'Guardar'
      Category = 0
      Hint = 'Guardar'
      Visible = ivAlways
      ImageIndex = 32
      OnClick = mnuGuardarClick
    end
    object mnuImprimir: TdxBarButton
      Caption = 'Imprimir'
      Category = 0
      Hint = 'Imprimir'
      Visible = ivAlways
      ImageIndex = 27
      OnClick = mnuImprimirClick
    end
    object mnuVistaPreliminar: TdxBarButton
      Caption = 'Vista Preliminar'
      Category = 0
      Hint = 'Vista Preliminar'
      Visible = ivAlways
      ImageIndex = 34
      OnClick = mnuVistaPreliminarClick
    end
    object mnuPaginaConf: TdxBarButton
      Caption = 'Configurar P'#225'gina'
      Category = 0
      Hint = 'Configurar P'#225'gina'
      Visible = ivAlways
      ImageIndex = 33
      OnClick = mnuPaginaConfClick
    end
    object mnuZoom: TdxBarCombo
      Caption = 'Zoom'
      Category = 0
      Hint = 'Zoom'
      Visible = ivAlways
      Text = '100%'
      OnChange = mnuZoomChange
      ImageIndex = 31
      ShowCaption = True
      Width = 55
      Items.Strings = (
        '500%'
        '200%'
        '150%'
        '100%'
        '75%'
        '50%'
        '25%'
        '10%')
      ItemIndex = 3
    end
    object mnuTransparencia: TdxBarControlContainerItem
      Caption = 'Transparencia'
      Category = 0
      Description = 'Transparencia'
      Hint = 'Transparencia'
      Visible = ivAlways
      Control = DgrTransparencySelector
    end
    object mnuObjetoColor: TdxBarControlContainerItem
      Caption = 'Color'
      Category = 0
      Description = 'Color'
      Hint = 'Color'
      Visible = ivAlways
      Control = DgrColorSelector
    end
    object mnuGradiente: TdxBarControlContainerItem
      Caption = 'Gradiente'
      Category = 0
      Description = 'Gradiente'
      Hint = 'Gradiente'
      Visible = ivAlways
      Control = DgrGradientDirectionSelector
    end
    object mnuCepillarEstilo: TdxBarControlContainerItem
      Caption = 'Relleno Estilo'
      Category = 0
      Description = 'Relleno Estilo'
      Hint = 'Relleno Estilo'
      Visible = ivAlways
      Control = DgrBrushStyleSelector
    end
    object mnuSombra: TdxBarControlContainerItem
      Caption = 'Sombra'
      Category = 0
      Description = 'Sombra'
      Hint = 'Sombra'
      Visible = ivAlways
      Control = DgrShadowSelector
    end
    object mnuLineaEstilo: TdxBarControlContainerItem
      Caption = 'Linea Estilo'
      Category = 0
      Description = 'Linea Estilo'
      Hint = 'Linea Estilo'
      Visible = ivAlways
      Control = DgrPenStyleSelector
    end
    object mnuLineaColor: TdxBarControlContainerItem
      Caption = 'Linea Color'
      Category = 0
      Description = 'Linea Color'
      Hint = 'Linea Color'
      Visible = ivAlways
      Control = DgrPenColorSelector
    end
    object mnuLineaAncho: TdxBarControlContainerItem
      Caption = 'Linea Ancho'
      Category = 0
      Description = 'Linea Ancho'
      Hint = 'Linea Ancho'
      Visible = ivAlways
      Control = DgrPenWidthSelector
    end
    object mnuTextoColor: TdxBarControlContainerItem
      Caption = 'Texto Color'
      Category = 0
      Description = 'Texto Color'
      Hint = 'Texto Color'
      Visible = ivAlways
      Control = DgrTextColorSelector
    end
    object mnuFontTipo: TdxBarControlContainerItem
      Caption = 'Font Tipo'
      Category = 0
      Description = 'Font Tipo'
      Hint = 'Font Tipo'
      Visible = ivAlways
      Control = DgrFontSelector
    end
    object mnuFontTamanio: TdxBarControlContainerItem
      Caption = 'Font Tama'#241'o'
      Category = 0
      Description = 'Font Tama'#241'o'
      Hint = 'Font Tama'#241'o'
      Visible = ivAlways
      Control = DgrFontSizeSelector1
    end
    object mnuBold: TdxBarButton
      Caption = 'Bold'
      Category = 0
      Hint = 'Bold'
      Visible = ivAlways
      ImageIndex = 35
      OnClick = mnuBoldClick
    end
    object mnuItalic: TdxBarButton
      Caption = 'Italic'
      Category = 0
      Hint = 'Italic'
      Visible = ivAlways
      ImageIndex = 36
      OnClick = mnuItalicClick
    end
    object mnuUnderline: TdxBarButton
      Caption = 'Underline'
      Category = 0
      Hint = 'Underline'
      Visible = ivAlways
      ImageIndex = 37
      OnClick = mnuUnderlineClick
    end
    object mnuStrikeOut: TdxBarButton
      Caption = 'StrikeOut'
      Category = 0
      Hint = 'StrikeOut'
      Visible = ivAlways
      ImageIndex = 38
      OnClick = mnuStrikeOutClick
    end
    object mnuVer: TdxBarSubItem
      Caption = 'Ver'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Item = mnuVerReglaIzquierda
          Visible = True
        end
        item
          Item = mnuVerReglaSuperior
          Visible = True
        end
        item
          Item = mnuVerCuadricula
          Visible = True
        end
        item
          BeginGroup = True
          Item = mnuNodosAutomaticos
          Visible = True
        end>
    end
    object mnuVerReglaIzquierda: TdxBarButton
      Caption = 'Regla Izquierda'
      Category = 0
      Hint = 'Regla Izquierda'
      Visible = ivAlways
      OnClick = mnuVerReglaIzquierdaClick
    end
    object mnuVerReglaSuperior: TdxBarButton
      Caption = 'Regla Superior'
      Category = 0
      Hint = 'Regla Superior'
      Visible = ivAlways
      OnClick = mnuVerReglaSuperiorClick
    end
    object mnuVerCuadricula: TdxBarButton
      Caption = 'Cuadr'#237'cula'
      Category = 0
      Hint = 'Cuadr'#237'cula'
      Visible = ivAlways
      OnClick = mnuVerCuadriculaClick
    end
    object mnuNodosAutomaticos: TdxBarButton
      Caption = 'Nodos Autom'#225'ticos'
      Category = 0
      Hint = 'Nodos Autom'#225'ticos'
      Visible = ivAlways
      OnClick = mnuNodosAutomaticosClick
    end
    object mnuDeshacer: TdxBarButton
      Caption = 'Deshacer'
      Category = 0
      Hint = 'Deshacer'
      Visible = ivAlways
      ImageIndex = 40
      ShortCut = 16474
      OnClick = mnuDeshacerClick
    end
    object mnuRehacer: TdxBarButton
      Caption = 'Rehacer'
      Category = 0
      Enabled = False
      Hint = 'Rehacer'
      Visible = ivAlways
      ImageIndex = 41
      ShortCut = 24666
      OnClick = mnuRehacerClick
    end
    object mnuTextoBuscar: TdxBarCombo
      Caption = 'Buscar'
      Category = 0
      Hint = 'Buscar'
      Visible = ivAlways
      OnExit = mnuTextoBuscarExit
      ShowCaption = True
      Width = 200
      ItemIndex = -1
    end
    object mnuBuscar: TdxBarButton
      Align = iaRight
      Caption = 'Buscar'
      Category = 0
      Hint = 'Buscar'
      Visible = ivAlways
      ImageIndex = 31
      ShortCut = 16450
      OnClick = mnuBuscarClick
    end
    object mnuBuscarAnterior: TdxBarButton
      Caption = 'Anterior'
      Category = 0
      Hint = 'Anterior'
      Visible = ivAlways
      ImageIndex = 42
      ShortCut = 8306
      OnClick = mnuBuscarAnteriorClick
    end
    object mnuBuscarSiguiente: TdxBarButton
      Caption = 'Siguiente'
      Category = 0
      Hint = 'Siguiente'
      Visible = ivAlways
      ImageIndex = 43
      ShortCut = 114
      OnClick = mnuBuscarSiguienteClick
    end
    object mnuExportar: TdxBarSubItem
      Caption = 'Exportar'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Item = mnuExportarExcel
          Visible = True
        end
        item
          Item = mnuExportarWMF
          Visible = True
        end>
    end
    object mnuExportarWMF: TdxBarButton
      Caption = 'Formato WMF'
      Category = 0
      Hint = 'Formato WMF'
      Visible = ivAlways
      ImageIndex = 44
      OnClick = mnuExportarWMFClick
    end
  end
  object SaveDialog: TSaveDialog
    Filter = 'Diagram files(*.dgr)|*.dgr'
    Left = 400
    Top = 40
  end
  object DataSource1: TDataSource
    DataSet = tabComponente
    Left = 367
    Top = 84
  end
  object tabComponente: TdxMemData
    Indexes = <>
    SortOptions = []
    Left = 400
    Top = 84
    object tabComponentePrograma: TStringField
      DisplayWidth = 100
      FieldName = 'Programa'
      Size = 100
    end
    object tabComponenteBiblioteca: TStringField
      DisplayWidth = 100
      FieldName = 'Biblioteca'
      Size = 100
    end
    object tabComponenteClase: TStringField
      FieldName = 'Clase'
      Size = 10
    end
    object tabComponenteRenglon: TIntegerField
      FieldName = 'Renglon'
    end
    object tabComponenteColumna: TIntegerField
      FieldName = 'Columna'
    end
    object tabComponenteDesplaza: TIntegerField
      FieldName = 'Desplaza'
    end
    object tabComponenteNFisicoBlock: TStringField
      FieldName = 'NFisicoBlock'
      Size = 100
    end
    object tabComponenteNLogicoBlock: TStringField
      FieldName = 'NLogicoBlock'
      Size = 100
    end
    object tabComponenteLigaBlockOrigen: TStringField
      FieldName = 'LigaBlockOrigen'
      Size = 100
    end
    object tabComponenteLigaBlockDestino: TStringField
      FieldName = 'LigaBlockDestino'
      Size = 100
    end
    object tabComponenteTipoBlock: TStringField
      FieldName = 'TipoBlock'
      Size = 50
    end
  end
end
