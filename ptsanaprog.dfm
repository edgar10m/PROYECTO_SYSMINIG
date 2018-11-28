object ftsanaprog: Tftsanaprog
  Left = -50
  Top = 26
  Width = 1300
  Height = 728
  Caption = 'ftsanaprog'
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
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1284
    Height = 690
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      BorderWidth = 2
      Caption = 'Componentes'
      object Splitter1: TSplitter
        Left = 281
        Top = 0
        Width = 5
        Height = 658
        Beveled = True
        Color = cl3DDkShadow
        ParentColor = False
      end
      object Splitter2: TSplitter
        Left = 150
        Top = 0
        Width = 5
        Height = 658
        Beveled = True
        Color = cl3DDkShadow
        ParentColor = False
      end
      object grbOriginales: TGroupBox
        Left = 0
        Top = 0
        Width = 150
        Height = 658
        Align = alLeft
        Caption = 'Originales'
        Color = clWhite
        ParentColor = False
        TabOrder = 0
        object dbg: TDBGrid
          Left = 2
          Top = 15
          Width = 146
          Height = 641
          HelpContext = 1804
          Align = alClient
          DataSource = DataSource1
          FixedColor = 16765864
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
        end
      end
      object GroupBox3: TGroupBox
        Left = 155
        Top = 0
        Width = 126
        Height = 658
        HelpContext = 1807
        Align = alLeft
        Caption = 'Operaci'#243'n'
        Color = clWhite
        ParentColor = False
        TabOrder = 1
        object Label3: TLabel
          Left = 12
          Top = 304
          Width = 83
          Height = 13
          Caption = 'Analiza Biblioteca'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Visible = False
        end
        object Label2: TLabel
          Left = 38
          Top = 150
          Width = 41
          Height = 13
          Caption = 'M'#225'scara'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label5: TLabel
          Left = 40
          Top = 26
          Width = 37
          Height = 13
          Caption = 'Sistema'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label1: TLabel
          Left = 6
          Top = 68
          Width = 104
          Height = 13
          Caption = 'Clase de Componente'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label6: TLabel
          Left = 35
          Top = 110
          Width = 46
          Height = 13
          Caption = 'Biblioteca'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label4: TLabel
          Left = 8
          Top = 251
          Width = 97
          Height = 13
          Caption = 'Analiza Componente'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Visible = False
        end
        object Label7: TLabel
          Left = 35
          Top = 190
          Width = 45
          Height = 13
          Caption = 'COPYLIB'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object bdir: TBitBtn
          Left = 21
          Top = 320
          Width = 80
          Height = 25
          Caption = '>>>'
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnClick = bdirClick
        end
        object txtmascara: TEdit
          Left = 10
          Top = 166
          Width = 97
          Height = 21
          HelpContext = 1801
          TabOrder = 3
          Text = '*'
          OnChange = cmbbibChange
        end
        object cmbsistema: TComboBox
          Left = 10
          Top = 41
          Width = 97
          Height = 21
          HelpContext = 1808
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          OnChange = cmbsistemaChange
        end
        object cmbclase: TComboBox
          Left = 10
          Top = 83
          Width = 97
          Height = 21
          HelpContext = 1810
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 1
          OnChange = cmbclaseChange
        end
        object cmbbib: TComboBox
          Left = 10
          Top = 125
          Width = 97
          Height = 21
          HelpContext = 1806
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 2
          OnChange = cmbbibChange
        end
        object barchivo: TBitBtn
          Left = 21
          Top = 267
          Width = 80
          Height = 25
          Caption = '>'
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnClick = barchivoClick
        end
        object bcompara: TBitBtn
          Left = 21
          Top = 392
          Width = 75
          Height = 25
          HelpContext = 1805
          Caption = 'Ver fuente'
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          OnClick = bcomparaClick
        end
        object cmbcopylib: TComboBox
          Left = 10
          Top = 205
          Width = 97
          Height = 21
          HelpContext = 1806
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 7
          OnChange = cmbbibChange
        end
        object butileria: TBitBtn
          Left = 21
          Top = 432
          Width = 75
          Height = 25
          HelpContext = 1805
          Caption = 'Carga Utiler'#237'a'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
          OnClick = butileriaClick
        end
      end
      object GroupBox4: TGroupBox
        Left = 286
        Top = 0
        Width = 986
        Height = 658
        Align = alClient
        Caption = '-'
        Color = clWhite
        ParentColor = False
        TabOrder = 2
        object Label10: TLabel
          Left = 979
          Top = 577
          Width = 5
          Height = 73
          Align = alRight
          AutoSize = False
        end
        object Label11: TLabel
          Left = 2
          Top = 577
          Width = 1
          Height = 73
          Align = alLeft
          AutoSize = False
        end
        object Label12: TLabel
          Left = 2
          Top = 650
          Width = 982
          Height = 6
          Align = alBottom
          AutoSize = False
        end
        object Splitter3: TSplitter
          Left = 2
          Top = 569
          Width = 982
          Height = 8
          Cursor = crVSplit
          Align = alTop
          Beveled = True
        end
        object Splitter4: TSplitter
          Left = 2
          Top = 289
          Width = 982
          Height = 6
          Cursor = crVSplit
          Align = alTop
          Beveled = True
        end
        object fuente: TMemo
          Left = 3
          Top = 577
          Width = 976
          Height = 73
          HelpContext = 1814
          Align = alClient
          Color = clMenuBar
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          PopupMenu = pop
          ScrollBars = ssBoth
          TabOrder = 0
          WordWrap = False
          OnMouseDown = fuenteMouseDown
        end
        object mresultado: TMemo
          Left = 2
          Top = 295
          Width = 982
          Height = 274
          HelpContext = 1814
          Align = alTop
          Color = clMenuBar
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          ScrollBars = ssBoth
          TabOrder = 1
          WordWrap = False
        end
        object Memo1: TMemo
          Left = 2
          Top = 15
          Width = 982
          Height = 274
          HelpContext = 1814
          Align = alTop
          Color = clMenuBar
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          ScrollBars = ssBoth
          TabOrder = 2
          WordWrap = False
        end
      end
    end
  end
  object ttsprog: TADOQuery
    Parameters = <>
    Left = 100
    Top = 80
  end
  object DataSource1: TDataSource
    DataSet = ttsprog
    Left = 100
    Top = 120
  end
  object pop: TPopupMenu
    Left = 682
    Top = 616
    object Fuente1: TMenuItem
      Caption = 'Fuente'
      OnClick = Fuente1Click
    end
  end
end
