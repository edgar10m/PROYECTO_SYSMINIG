object ftsadminctrusu: Tftsadminctrusu
  Left = 312
  Top = 117
  Width = 652
  Height = 559
  HorzScrollBar.ParentColor = False
  VertScrollBar.ParentColor = False
  Align = alCustom
  BiDiMode = bdLeftToRight
  Caption = 'Sys-Mining  -  Monitorea Usuarios'
  Color = clWhite
  Constraints.MaxWidth = 1350
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010000001002000680400001600000028000000100000002000
    000001002000000000004004000000000000000000000000000000000000FF00
    FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
    FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
    FF00FEFEFEFFFEFDFDFFFEFDFDFFFEFDFDFFFF00FF00FF00FF00FEFEFEFFFCFD
    FCFFFCFDFCFFFCFDFCFFFEFEFEFFFF00FF00FF00FF00FF00FF00FF00FF00FF00
    FF00FEFEFEFFFFFFFFFFFEFEFEFFFFFFFFFFFF00FF00FF00FF00FCFDFCFFF0F9
    F1FFF0F8F1FFF0F9F1FFFBFDFBFFFF00FF00FF00FF00FF00FF00FF00FF00FF00
    FF00FDFAF9FFFCF7F4FFFCF7F4FFFCF7F4FFFF00FF00FF00FF00FAFCFAFFD5ED
    D9FFD5ECD9FFD5EDD9FFF6FBF7FFFF00FF00FF00FF00FF00FF00FF00FF00FF00
    FF00F8EFEBFFF4E1D9FFF3E1D8FFF4E7E1FFF6FBFEFFF6FBFFFFEFF8F7FFBBE2
    C2FFBAE2C2FFBBE2C2FFF1F8F2FFFFFFFFFFFEFEFEFFFFFFFFFFFF00FF00FF00
    FF00F4E4DDFFEBCBBCFFEBCBBCFFE7D3CAFFDAF0FEFFDAF0FFFFD3EDF5FFA0D6
    AAFFA0D6AAFFA0D6AAFFEBF5EEFFFCFCFFFFFCFCFEFFFDFDFFFFFF00FF00FF00
    FF00F0D9CEFFE3B59FFFE3B49FFFDBBFB3FFBEE4FEFFBEE4FFFFB7E1F2FF85CB
    91FF85CA91FF85CB91FFCCDAE7FFDEDFFCFFDDDFFCFFF0F0FDFFFF00FF00FF00
    FF00ECCEC0FFDA9F83FFDA9F83FFCEAB9DFFA3D9FEFFA3D9FFFF9DD6F1FF6ABF
    79FF6ABF79FF6ABF79FFADC0E0FFBDC0F9FFBDC0F9FFE1E3FCFFFF00FF00FF00
    FF00EFDAD0FFD18967FFD18966FFC8B5B1FF87CDFEFF87CDFFFF87CDFEFF60BA
    71FF51B463FF53B565FF9BA2F3FF9CA2F7FF9CA2F6FFD3D5FBFFFF00FF00FF00
    FF00FF00FF00DBA388FFD08865FFDEEDF8FF6BC2FEFF6BC2FFFF6BC2FEFFE0F1
    E8FF52B464FFCBE8D2FF7C83F4FF7C83F4FF7C83F4FFC4C8FAFFFF00FF00FF00
    FF00FAF5F2FFCC7B54FFCB7A53FFD7EAF8FF4FB6FEFF4FB6FFFF65BFFEFF93D0
    B2FF4AB15DFF54B466FF6A72F2FF5C64F1FF5C64F1FFC4C8FAFFFF00FF00FF00
    FF00FF00FF00DDAC96FFD0997FFFFCFDFDFFA8DBFEFF3AADFFFFEFF8FCFFDBEF
    E8FF5EB96FFFBDE0CAFFF3F6FBFF5660F1FF838AF4FFFF00FF00FF00FF00FF00
    FF00FF00FF00FF00FF00FF00FF00FF00FF000C9AFEFF0D9BFFFF95D1F0FFFF00
    FF00FF00FF00FF00FF00D9E1F4FF3540EEFF343FEDFFF8F8FEFFFF00FF00FF00
    FF00FF00FF00FF00FF00FF00FF00FF00FF0056B8FEFF179FFFFFCDE9F8FFFF00
    FF00FF00FF00FF00FF00E8ECF8FF3C47EEFF5A63F0FFFCFCFEFFFF00FF00FF00
    FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
    FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
    FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
    FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FFFF
    0000860F0000860F0000860F0000800100008001000080010000800100008001
    0000C001000080010000C0030000F8E10000F8E10000FFFF0000FFFF0000}
  OldCreateOrder = False
  ParentBiDiMode = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lv: TListView
    Left = 0
    Top = 0
    Width = 644
    Height = 499
    Align = alClient
    Columns = <
      item
        Caption = 'Crol'
        Width = 90
      end
      item
        Caption = 'Cuser'
        Width = 100
      end
      item
        Caption = 'Fecha_Entrada'
        Width = 150
      end
      item
        Caption = 'Fecha_Salida'
        Width = 150
      end
      item
        Caption = 'Control_tiempo'
        Width = 150
      end>
    GridLines = True
    RowSelect = True
    PopupMenu = PopupMenu1
    TabOrder = 0
    ViewStyle = vsReport
    OnColumnClick = lvColumnClick
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 216
    Top = 64
    object ClaveUsuario1: TMenuItem
      Caption = 'Clave Usuario'
      OnClick = ClaveUsuario1Click
    end
    object ControlTiempo1: TMenuItem
      Caption = 'Control Tiempo'
      OnClick = ControlTiempo1Click
    end
    object fecha_entrada: TMenuItem
      Caption = 'Fecha Entrada'
      OnClick = fecha_entradaClick
    end
    object fecha_salida: TMenuItem
      Caption = 'Fecha Salida'
      OnClick = fecha_salidaClick
    end
    object NombreUsuario1: TMenuItem
      Caption = 'Nombre Usuario'
      OnClick = NombreUsuario1Click
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
            Item = mnuAyuda
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
    Left = 280
    Top = 64
    DockControlHeights = (
      0
      0
      0
      26)
    object mnuAyuda: TdxBarButton
      Category = 0
      Hint = 'Ayuda a nivel pantalla'
      Visible = ivAlways
      ImageIndex = 30
      PaintStyle = psCaption
      ShortCut = 112
      OnClick = mnuAyudaClick
    end
  end
end
