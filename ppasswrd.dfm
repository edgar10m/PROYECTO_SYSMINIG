object fpasswrd: Tfpasswrd
  Left = 551
  Top = 279
  Width = 423
  Height = 219
  Caption = 'Sys-Mining  -  Cambio de Clave de Acceso'
  Color = clMenu
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010000001002000680400001600000028000000100000002000
    000001002000000000004004000000000000000000000000000000000000FF00
    FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
    FF00FF00FF00FF00FF00FF00FF00292929FF0099CCFF292929FFFF00FF00FF00
    FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
    FF00FF00FF00FF00FF00292929FF33CCFFFF0099CCFF292929FFFF00FF00FF00
    FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
    FF00FF00FF00FF00FF00292929FF66CCFFFF3399CCFF0099CCFF292929FFFF00
    FF00FF00FF00B7A293FF634935FF634935FF634935FF634935FF634935FF6349
    35FF634935FF634935FF292929FF66CCFFFF3399FFFF292929FFFF00FF00FF00
    FF00FF00FF00B7A293FFCEBCB0FFCBB9ACFFC8B5A8FFC2AEA0FFBFAC9EFFBDA8
    9AFFBAA697FFB9A495FF292929FF66CCFFFF3399CCFF0099CCFF292929FFFF00
    FF00FF00FF00B7A293FFFF00FF00FF00FF00CEBCB0FFFCF2ECFFFAEDE5FFC2AE
    A0FFF9E1D3FFF7DBCAFF292929FF66CCFFFF3399FFFF292929FFFF00FF00FF00
    FF00FF00FF00B7A293FFD7C6BCFFD4C3B8FFD1C0B4FFCBB9ACFFC8B6A9FF0000
    00FFC2AEA0FFBFAC9DFF292929FF66CCFFFF3399CCFF0099CCFF292929FFFF00
    FF00FF00FF00BEA99AFFFF00FF00FF00FF00000000FF000000FF000000FF0000
    00FF000000FFFAEDE5FF292929FF33CCFFFF3399FFFF292929FFFF00FF00FF00
    FF00FF00FF00C3AE9EFFDDCEC5FFDCCCC1FFD9C9BFFFD4C4B8FFD1C0B4FF0000
    00FFCBB9ACFF292929FF3399CCFF33CCFFFF3399CCFF0066CCFF292929FFFF00
    FF00FF00FF00CCB6A7FFFF00FF00FF00FF00DDCEC5FFFF00FF00FF00FF00D4C4
    B8FF292929FF66CCFFFF33CCFFFF999999FF999999FF0099CCFF0066CCFFFF00
    FF00FF00FF00EAAA8BFFEAAA8BFFE9A584FFE99F7AFFE68E62FFE58656FFE37D
    4AFF292929FF99CCFFFF66CCFFFF040404FF040404FF33CCFFFF0099CCFFFF00
    FF00FF00FF00EAAA8BFFFEC09FFFFDBD9AFFFCB996FFFAB08BFFF9AB84FFF8A7
    7DFFF6A277FF292929FF99CCFFFF99CCFFFF99CCFFFF66CCFFFF292929FFFF00
    FF00FF00FF00EAAA8BFFEAAA8BFFEAAA8BFFEAA686FFE89B76FFE7946CFFE68E
    62FFE58758FFE4814EFF292929FF292929FF292929FF292929FFFF00FF00FF00
    FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
    FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
    FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
    FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
    FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
    FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FFF1
    0000FFE10000FFE00000C0010000C0000000D8010000C0000000D8010000C000
    0000DB000000C0000000C0000000C0010000FFFF0000FFFF0000FFFF0000}
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnHelp = FormHelp
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 64
    Top = 24
    Width = 36
    Height = 13
    Caption = 'Usuario'
  end
  object Label2: TLabel
    Left = 64
    Top = 56
    Width = 27
    Height = 13
    Caption = 'Clave'
  end
  object Label3: TLabel
    Left = 64
    Top = 88
    Width = 44
    Height = 13
    Caption = 'Confirmar'
  end
  object txtpassword: TEdit
    Left = 120
    Top = 61
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
    OnChange = cmbusuarioChange
  end
  object bcancel: TButton
    Left = 114
    Top = 130
    Width = 80
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 3
    OnClick = bcancelClick
  end
  object bok: TButton
    Left = 202
    Top = 130
    Width = 80
    Height = 25
    Caption = 'Aceptar'
    Default = True
    Enabled = False
    TabOrder = 4
    OnClick = bokClick
  end
  object txtconfirmar: TEdit
    Left = 120
    Top = 93
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 2
    OnChange = cmbusuarioChange
  end
  object cmbusuario: TComboBox
    Left = 120
    Top = 21
    Width = 241
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = cmbusuarioChange
    OnClick = cmbusuarioClick
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
