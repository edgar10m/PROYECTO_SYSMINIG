object ftsfix: Tftsfix
  Left = 479
  Top = 48
  Width = 1188
  Height = 1002
  Caption = 'Correcci'#243'n masiva'
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
    Width = 1172
    Height = 964
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
        Height = 932
        Beveled = True
        Color = cl3DDkShadow
        ParentColor = False
      end
      object Splitter2: TSplitter
        Left = 150
        Top = 0
        Width = 5
        Height = 932
        Beveled = True
        Color = cl3DDkShadow
        ParentColor = False
      end
      object grbOriginales: TGroupBox
        Left = 0
        Top = 0
        Width = 150
        Height = 932
        Align = alLeft
        Caption = 'Originales'
        Color = clWhite
        ParentColor = False
        TabOrder = 0
        object dbg: TDBGrid
          Left = 2
          Top = 15
          Width = 146
          Height = 915
          HelpContext = 1804
          Align = alClient
          DataSource = DataSource1
          FixedColor = 16765864
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnCellClick = dbgCellClick
        end
      end
      object GroupBox3: TGroupBox
        Left = 155
        Top = 0
        Width = 126
        Height = 932
        HelpContext = 1807
        Align = alLeft
        Caption = 'Operaci'#243'n'
        Color = clWhite
        ParentColor = False
        TabOrder = 1
        object Label3: TLabel
          Left = 12
          Top = 440
          Width = 82
          Height = 13
          Caption = 'Corrige Biblioteca'
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
          Top = 387
          Width = 96
          Height = 13
          Caption = 'Corrige Componente'
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
        object Label8: TLabel
          Left = 8
          Top = 299
          Width = 103
          Height = 13
          Caption = 'Longitudes de Campo'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Visible = False
        end
        object bdir: TBitBtn
          Left = 21
          Top = 456
          Width = 80
          Height = 25
          Caption = '>>>'
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
          Top = 403
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
          Top = 528
          Width = 75
          Height = 25
          HelpContext = 1805
          Caption = 'Compara'
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
        end
        object butileria: TBitBtn
          Left = 21
          Top = 568
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
          Visible = False
        end
        object chkafectado: TCheckBox
          Left = 16
          Top = 248
          Width = 97
          Height = 17
          Caption = 'AFECTADO'
          Checked = True
          State = cbChecked
          TabOrder = 9
          OnClick = chkafectadoClick
        end
        object chkwarning: TCheckBox
          Left = 16
          Top = 272
          Width = 97
          Height = 17
          Caption = 'WARNING'
          Checked = True
          State = cbChecked
          TabOrder = 10
          OnClick = chkwarningClick
        end
        object txtlongitudes: TEdit
          Left = 16
          Top = 320
          Width = 81
          Height = 21
          TabOrder = 11
          OnChange = txtlongitudesChange
          OnKeyPress = txtlongitudesKeyPress
        end
      end
      object GroupBox4: TGroupBox
        Left = 286
        Top = 0
        Width = 874
        Height = 932
        Align = alClient
        Caption = '-'
        Color = clWhite
        ParentColor = False
        TabOrder = 2
        object Label10: TLabel
          Left = 867
          Top = 206
          Width = 5
          Height = 718
          Align = alRight
          AutoSize = False
        end
        object Label11: TLabel
          Left = 2
          Top = 206
          Width = 1
          Height = 718
          Align = alLeft
          AutoSize = False
        end
        object Label12: TLabel
          Left = 2
          Top = 924
          Width = 870
          Height = 6
          Align = alBottom
          AutoSize = False
        end
        object Splitter4: TSplitter
          Left = 2
          Top = 200
          Width = 870
          Height = 6
          Cursor = crVSplit
          Align = alTop
          Beveled = True
        end
        object Splitter5: TSplitter
          Left = 2
          Top = 193
          Width = 870
          Height = 7
          Cursor = crVSplit
          Align = alTop
          Beveled = True
        end
        object dbgmaestra: TDBGrid
          Left = 2
          Top = 15
          Width = 870
          Height = 178
          HelpContext = 1804
          Align = alTop
          DataSource = DataSource2
          FixedColor = 16765864
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnCellClick = dbgmaestraCellClick
        end
        object memo: TRichEdit
          Left = 3
          Top = 206
          Width = 864
          Height = 718
          Align = alClient
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
      end
    end
  end
  object ttsprog: TADOQuery
    Parameters = <>
    Left = 74
    Top = 176
  end
  object DataSource1: TDataSource
    DataSet = ttsprog
    Left = 66
    Top = 224
  end
  object DataSource2: TDataSource
    DataSet = adoqmaestra
    Left = 538
    Top = 88
  end
  object adoqmaestra: TADOQuery
    Connection = dm.ADOConnection1
    Parameters = <>
    Left = 634
    Top = 104
  end
  object SaveDialog1: TSaveDialog
    Left = 434
    Top = 296
  end
end
