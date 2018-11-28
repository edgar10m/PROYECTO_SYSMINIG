object Editar: TEditar
  Left = 82
  Top = 204
  Width = 571
  Height = 186
  BiDiMode = bdLeftToRight
  Caption = 'Editar'
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  ParentBiDiMode = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Ayuda: TRichEdit
    Left = 0
    Top = 0
    Width = 555
    Height = 122
    Align = alClient
    HideScrollBars = False
    PlainText = True
    ScrollBars = ssBoth
    TabOrder = 0
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
        FloatLeft = 751
        FloatTop = 304
        FloatClientWidth = 91
        FloatClientHeight = 174
        ItemLinks = <
          item
            Item = mnuActualizar
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
    Left = 16
    Top = 16
    DockControlHeights = (
      0
      0
      0
      26)
    object mnuActualizar: TdxBarButton
      Caption = 'Actualizar'
      Category = 0
      Hint = 'Actualizar'
      Visible = ivAlways
      PaintStyle = psCaptionGlyph
      ShortCut = 16464
      OnClick = mnuActualizarClick
    end
    object mnuCancelar: TdxBarButton
      Caption = 'Cancelar'
      Category = 0
      Hint = 'Cancelar'
      Visible = ivAlways
      PaintStyle = psCaptionGlyph
    end
  end
end
