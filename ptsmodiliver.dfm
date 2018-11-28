object ftsmodiliver: Tftsmodiliver
  Left = 109
  Top = 350
  Width = 1305
  Height = 675
  Caption = 'Convierte JCLs'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFF
    FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000000000FF000
    000000000000000000000000000FF000000000000000000000000000000FF000
    000000000000000000000000000FF00000078FF87000000000000000000FF000
    078FFFFFF870000000000000000FF0007FFFFFFFFFF7000000000000000FF000
    8FFFFFFFFFF8000000000000000FF007FFFFFFFFFFFF700000000000000FF008
    FFFFFFFFFFFF800000000000000FF00FFFFFFFFFFFFFF00000000000000FF00F
    FFFFFFFFFFFFF00000000000000FF008FFFFFFFFFFFF800000000000000FF007
    FFFFFFFFFFFF700000000000000FF0008FFFFFFFFFF8000000000000000FF000
    7FFFFFFFFFF7000000000000000FF000078FFFFFF8778FF870000000000FF000
    00078FF8707FFFFFF7000000000FF0000000000007FFFFFFFF700000000FF000
    0000000008FFFFFFFF800000000FF000000000000FFFFFFFFFF00788700FF000
    000000000FFFFFFFFFF07FFFF70FF0000000000008FFFFFFFF808FFFF80FF000
    0000000007FFFFFFFF708FFFF80FF00000000000007FFFFFF7007FFFF70FF000
    0000000000078FF870000788700FF000000000000000000000000000000FF000
    000000000000000000000000000FF000000000000000000000000000000FF000
    000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1289
    Height = 637
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      BorderWidth = 2
      Caption = 'Componentes'
      object Splitter1: TSplitter
        Left = 289
        Top = 0
        Width = 8
        Height = 605
        Beveled = True
        Color = cl3DDkShadow
        ParentColor = False
      end
      object Splitter2: TSplitter
        Left = 158
        Top = 0
        Width = 5
        Height = 605
        Beveled = True
        Color = cl3DDkShadow
        ParentColor = False
      end
      object Splitter4: TSplitter
        Left = 150
        Top = 0
        Width = 8
        Height = 605
        Beveled = True
        Color = cl3DDkShadow
        ParentColor = False
      end
      object grbOriginales: TGroupBox
        Left = 0
        Top = 0
        Width = 150
        Height = 605
        Align = alLeft
        Caption = 'Originales'
        Color = clWhite
        ParentColor = False
        TabOrder = 0
        object Splitter3: TSplitter
          Left = 2
          Top = 329
          Width = 146
          Height = 7
          Cursor = crVSplit
          Align = alTop
          Beveled = True
        end
        object DirectoryListBox1: TDirectoryListBox
          Left = 2
          Top = 49
          Width = 146
          Height = 280
          Align = alTop
          FileList = FileListBox1
          ItemHeight = 16
          TabOrder = 0
        end
        object FileListBox1: TFileListBox
          Left = 2
          Top = 336
          Width = 146
          Height = 267
          Align = alClient
          ItemHeight = 13
          MultiSelect = True
          TabOrder = 1
          OnClick = FileListBox1Click
        end
        object Panel1: TPanel
          Left = 2
          Top = 15
          Width = 146
          Height = 34
          Align = alTop
          Caption = 'Panel1'
          TabOrder = 2
          object DriveComboBox1: TDriveComboBox
            Left = 1
            Top = 8
            Width = 145
            Height = 19
            DirList = DirectoryListBox1
            TabOrder = 0
          end
        end
      end
      object GroupBox3: TGroupBox
        Left = 163
        Top = 0
        Width = 126
        Height = 605
        HelpContext = 1807
        Align = alLeft
        Caption = 'Operaci'#243'n'
        Color = clWhite
        ParentColor = False
        TabOrder = 1
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
          Visible = False
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
          Visible = False
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
          Visible = False
        end
        object bdir: TBitBtn
          Left = 16
          Top = 320
          Width = 89
          Height = 25
          Caption = 'Selecciona Todo'
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
          Text = '*.*'
          OnChange = txtmascaraChange
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
          Visible = False
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
          Visible = False
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
          Visible = False
          OnChange = cmbbibChange
        end
        object barchivo: TBitBtn
          Left = 16
          Top = 267
          Width = 89
          Height = 25
          Caption = 'Modifica'
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
          Left = 16
          Top = 392
          Width = 89
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
          TabOrder = 7
          Visible = False
        end
      end
      object GroupBox4: TGroupBox
        Left = 297
        Top = 0
        Width = 980
        Height = 605
        Align = alClient
        Caption = '-'
        Color = clWhite
        ParentColor = False
        TabOrder = 2
        object Label10: TLabel
          Left = 973
          Top = 15
          Width = 5
          Height = 582
          Align = alRight
          AutoSize = False
        end
        object Label11: TLabel
          Left = 2
          Top = 15
          Width = 1
          Height = 582
          Align = alLeft
          AutoSize = False
        end
        object Label12: TLabel
          Left = 2
          Top = 597
          Width = 976
          Height = 6
          Align = alBottom
          AutoSize = False
        end
        object memo: TRichEdit
          Left = 3
          Top = 15
          Width = 970
          Height = 582
          Align = alClient
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          ScrollBars = ssBoth
          TabOrder = 0
          WordWrap = False
        end
      end
    end
  end
  object SaveDialog1: TSaveDialog
    Left = 330
    Top = 128
  end
end
