object ftsrecibe: Tftsrecibe
  Left = 327
  Top = 0
  Width = 1033
  Height = 725
  Caption = 'Recepci'#243'n de Componentes'
  Color = clBtnFace
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
    FF00FF00FF00ACA9A4FF726C65FF726C65FF726C65FFACA9A4FFFF00FF00FF00
    FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
    FF00726C65FF726C65FF442AE7FF726C65FF2F13DFFF726C65FF726C65FFFF00
    FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00726C
    65FF442AE7FF442AE7FF442AE7FF726C65FF2F13DFFF2F13DFFF2F13DFFF726C
    65FFACA9A4FF726C65FF726C65FF726C65FFACA9A4FFFF00FF00FF00FF00726C
    65FF442AE7FF442AE7FF442AE7FF726C65FF2F13DFFF2F13DFFF2F13DFFF726C
    65FF726C65FF6DF393FF726C65FF2AB940FF726C65FF726C65FFFF00FF00726C
    65FF442AE7FF442AE7FF442AE7FF726C65FF2F13DFFF2F13DFFF726C65FF6DF3
    93FF6DF393FF6DF393FF726C65FF2AB940FF2AB940FF2AB940FF726C65FF726C
    65FF442AE7FF442AE7FF726C65FF726C65FF726C65FF2F13DFFF726C65FF6DF3
    93FF6DF393FF6DF393FF726C65FF2AB940FF2AB940FF2AB940FF726C65FF726C
    65FF726C65FF726C65FF0DE0EDFF726C65FF0DE0EDFF726C65FF726C65FF6DF3
    93FF6DF393FF726C65FF726C65FF726C65FF2AB940FF2AB940FF726C65FF726C
    65FF0DE0EDFF0DE0EDFF0DE0EDFF726C65FF0DE0EDFF0DE0EDFF0DE0EDFF726C
    65FF726C65FF6DF393FF6DF393FF6DF393FF726C65FF726C65FF726C65FF726C
    65FF0DE0EDFF0DE0EDFF0DE0EDFF726C65FF0DE0EDFF0DE0EDFF0DE0EDFF726C
    65FF6DF393FF6DF393FF6DF393FF6DF393FF6DF393FF6DF393FF726C65FF726C
    65FF0DE0EDFF0DE0EDFF726C65FF726C65FF726C65FF0DE0EDFF0DE0EDFF726C
    65FF726C65FF6DF393FF6DF393FF6DF393FF726C65FF726C65FFFF00FF00726C
    65FF726C65FF726C65FF0DBEF1FF0DBEF1FF0DBEF1FF726C65FF726C65FF726C
    65FFFF00FF00726C65FF726C65FF726C65FFFF00FF00FF00FF00FF00FF00726C
    65FF0DBEF1FF0DBEF1FF0DBEF1FF0DBEF1FF0DBEF1FF0DBEF1FF0DBEF1FF726C
    65FFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
    FF00726C65FF726C65FF0DBEF1FF0DBEF1FF0DBEF1FF726C65FF726C65FFFF00
    FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
    FF00FF00FF00ACA9A4FF726C65FF726C65FF726C65FFACA9A4FFFF00FF00FF00
    FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
    FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
    FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FFFF
    0000C1FF000080FF000000030000000100000000000000000000000000000000
    0000000000000001000000470000007F000080FF0000C1FF0000FFFF0000}
  KeyPreview = True
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter5: TSplitter
    Left = 254
    Top = 0
    Width = 5
    Height = 661
    Beveled = True
    Color = cl3DDkShadow
    ParentColor = False
  end
  object Splitter6: TSplitter
    Left = 446
    Top = 0
    Width = 5
    Height = 661
    Beveled = True
    Color = cl3DDkShadow
    ParentColor = False
    OnMoved = Splitter6Moved
  end
  object grbRecepcion: TGroupBox
    Left = 0
    Top = 0
    Width = 254
    Height = 661
    HelpType = htKeyword
    Align = alLeft
    Caption = 'Recepci'#243'n'
    Color = clCream
    ParentColor = False
    TabOrder = 0
    OnClick = grbRecepcionClick
    object split: TSplitter
      Left = 2
      Top = 249
      Width = 250
      Height = 5
      Cursor = crVSplit
      Align = alTop
      Beveled = True
      Color = cl3DDkShadow
      ParentColor = False
    end
    object dir: TDirectoryListBox
      Left = 2
      Top = 49
      Width = 250
      Height = 200
      HelpType = htKeyword
      Align = alTop
      Color = clWhite
      FileList = archivo
      ItemHeight = 16
      TabOrder = 0
      OnClick = dirClick
      OnMouseDown = dirMouseDown
    end
    object archivo: TFileListBox
      Left = 2
      Top = 254
      Width = 250
      Height = 405
      Align = alClient
      ItemHeight = 13
      MultiSelect = True
      PopupMenu = poparchivo
      TabOrder = 1
      OnClick = archivoClick
      OnDblClick = barchivoClick
    end
    object ydrive: TPanel
      Left = 2
      Top = 15
      Width = 250
      Height = 34
      Align = alTop
      Color = clCream
      TabOrder = 2
      object Drive: TDriveComboBox
        Left = 8
        Top = 6
        Width = 233
        Height = 19
        HelpType = htKeyword
        DirList = dir
        TabOrder = 0
        OnClick = DriveClick
      end
    end
    object lbxarchivo: TListBox
      Left = 2
      Top = 254
      Width = 250
      Height = 405
      HelpType = htKeyword
      Align = alClient
      Color = clWhite
      ItemHeight = 13
      MultiSelect = True
      TabOrder = 3
      Visible = False
      OnClick = archivoClick
      OnDblClick = barchivoClick
    end
  end
  object groupbox2: TGroupBox
    Left = 259
    Top = 0
    Width = 187
    Height = 661
    HelpType = htKeyword
    Align = alLeft
    Caption = 'Operaci'#243'n'
    Color = clWhite
    ParentColor = False
    TabOrder = 1
    object Label2: TLabel
      Left = 10
      Top = 223
      Width = 52
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'M'#225'scara'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 10
      Top = 63
      Width = 46
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Sistema'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 10
      Top = 106
      Width = 110
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Clase de Componente'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 10
      Top = 149
      Width = 53
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Biblioteca'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 34
      Top = 298
      Width = 116
      Height = 13
      HelpType = htKeyword
      Alignment = taCenter
      AutoSize = False
      Caption = 'Integra Componentes'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 10
      Top = 22
      Width = 41
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Oficina'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object pie: TLabel
      Left = 5
      Top = 650
      Width = 5
      Height = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object txtsufijo: TEdit
      Left = 14
      Top = 238
      Width = 97
      Height = 21
      HelpType = htKeyword
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      Text = '*.*'
      OnChange = txtsufijoChange
      OnClick = txtsufijoClick
    end
    object cmbsistema: TComboBox
      Left = 10
      Top = 78
      Width = 152
      Height = 21
      HelpType = htKeyword
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 1
      OnChange = cmbsistemaChange
      OnClick = cmbsistemaClick
    end
    object cmbclase: TComboBox
      Left = 10
      Top = 121
      Width = 152
      Height = 21
      HelpType = htKeyword
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 2
      OnChange = cmbsistemaChange
      OnClick = cmbclaseClick
    end
    object cmbbiblioteca: TComboBox
      Left = 10
      Top = 164
      Width = 152
      Height = 21
      HelpType = htKeyword
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 3
      OnChange = cmbsistemaChange
      OnClick = cmbbibliotecaClick
    end
    object barchivo: TBitBtn
      Left = 49
      Top = 314
      Width = 80
      Height = 25
      HelpType = htKeyword
      Caption = '>>'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnClick = barchivoClick
    end
    object bseltodo: TBitBtn
      Left = 12
      Top = 266
      Width = 152
      Height = 25
      HelpType = htKeyword
      Caption = 'Selecciona  Todo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = bseltodoClick
    end
    object chkversion: TCheckBox
      Left = 23
      Top = 402
      Width = 105
      Height = 17
      HelpType = htKeyword
      Caption = 'Revisa Versiones'
      Checked = True
      State = cbChecked
      TabOrder = 8
      OnClick = chkversionClick
    end
    object cmboficina: TComboBox
      Left = 10
      Top = 37
      Width = 152
      Height = 21
      HelpType = htKeyword
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 0
      OnChange = cmboficinaChange
      OnClick = cmboficinaClick
    end
    object rgnombre: TRadioGroup
      Left = 23
      Top = 541
      Width = 118
      Height = 81
      HelpType = htKeyword
      Caption = 'Nombre Componente'
      ItemIndex = 2
      Items.Strings = (
        'Actual'
        'min'#250'sculas'
        'MAYUSCULAS')
      TabOrder = 12
      OnClick = rgnombreClick
    end
    object chkexiste: TCheckBox
      Left = 23
      Top = 385
      Width = 105
      Height = 16
      HelpType = htKeyword
      Caption = 'Omite existentes'
      TabOrder = 7
      OnClick = chkexisteClick
    end
    object chkanaliza: TCheckBox
      Left = 23
      Top = 419
      Width = 107
      Height = 17
      HelpType = htKeyword
      Caption = 'Analiza Fuente'
      Enabled = False
      TabOrder = 9
      OnClick = chkanalizaClick
    end
    object blog: TButton
      Left = 48
      Top = 624
      Width = 80
      Height = 25
      Caption = 'Log'
      TabOrder = 13
      OnClick = blogClick
    end
    object chkruta: TCheckBox
      Left = 10
      Top = 189
      Width = 128
      Height = 17
      HelpType = htKeyword
      Caption = 'Incluye subdirectorios'
      TabOrder = 14
      OnClick = chkrutaClick
    end
    object chkparams: TCheckBox
      Left = 23
      Top = 500
      Width = 155
      Height = 17
      HelpType = htKeyword
      Caption = 'Procesa Par'#225'metros JOB'
      Enabled = False
      TabOrder = 11
      Visible = False
      OnClick = chkparamsClick
    end
    object yextra: TGroupBox
      Left = 8
      Top = 342
      Width = 169
      Height = 41
      HelpType = htKeyword
      Caption = 'Par'#225'metros adicionales'
      Color = clWhite
      ParentColor = False
      TabOrder = 15
      Visible = False
      object chkextra: TCheckBox
        Left = 7
        Top = 17
        Width = 26
        Height = 16
        HelpType = htKeyword
        TabOrder = 0
        OnClick = chkextraClick
      end
      object txtextra: TEdit
        Left = 24
        Top = 14
        Width = 137
        Height = 21
        HelpType = htKeyword
        Enabled = False
        TabOrder = 1
        OnClick = txtextraClick
      end
    end
    object chktodas: TCheckBox
      Left = 112
      Top = 147
      Width = 57
      Height = 17
      HelpType = htKeyword
      Caption = 'Todas'
      TabOrder = 16
      OnClick = chktodasClick
    end
    object chkextension: TCheckBox
      Left = 23
      Top = 436
      Width = 121
      Height = 17
      HelpType = htKeyword
      Caption = 'Conserva Extensi'#243'n'
      TabOrder = 10
      OnClick = chkextensionClick
    end
    object chkverifica: TCheckBox
      Left = 23
      Top = 470
      Width = 121
      Height = 12
      HelpType = htKeyword
      Caption = 'Verifica Clase'
      TabOrder = 17
      OnClick = chkverificaClick
    end
    object chkproduccion: TCheckBox
      Left = 23
      Top = 453
      Width = 121
      Height = 15
      HelpType = htKeyword
      Caption = 'Analiza Producci'#243'n'
      TabOrder = 18
      OnClick = chkproduccionClick
    end
    object chknombre_version: TCheckBox
      Left = 23
      Top = 486
      Width = 121
      Height = 12
      HelpType = htKeyword
      Caption = 'Nombre_Version'
      TabOrder = 19
      OnClick = chknombre_versionClick
    end
  end
  object GroupBox3: TGroupBox
    Left = 451
    Top = 0
    Width = 566
    Height = 661
    Align = alClient
    Caption = 'Resultados'
    TabOrder = 2
    object Splitter1: TSplitter
      Left = 2
      Top = 104
      Width = 562
      Height = 5
      Cursor = crVSplit
      Align = alTop
      Beveled = True
      Color = cl3DDkShadow
      ParentColor = False
    end
    object Splitter2: TSplitter
      Left = 2
      Top = 198
      Width = 562
      Height = 5
      Cursor = crVSplit
      Align = alTop
      Beveled = True
      Color = cl3DDkShadow
      ParentColor = False
    end
    object Splitter3: TSplitter
      Left = 2
      Top = 323
      Width = 562
      Height = 5
      Cursor = crVSplit
      Align = alTop
      Beveled = True
      Color = cl3DDkShadow
      ParentColor = False
    end
    object gtsprog: TDBGrid
      Left = 2
      Top = 328
      Width = 562
      Height = 314
      HelpType = htKeyword
      Align = alClient
      Color = clWhite
      DataSource = DataSource1
      FixedColor = 16765864
      PopupMenu = poparchivo
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnCellClick = gtsprogCellClick
      OnDblClick = gtsprogDblClick
    end
    object gtsversion: TDBGrid
      Left = 2
      Top = 203
      Width = 562
      Height = 120
      HelpType = htKeyword
      Align = alTop
      Color = clWhite
      DataSource = DataSource2
      FixedColor = 16765864
      ReadOnly = True
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
    end
    object rxfuente: TMemo
      Left = 2
      Top = 109
      Width = 562
      Height = 89
      HelpType = htKeyword
      Align = alTop
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 2
      OnClick = rxfuenteClick
    end
    object rxfc: TMemo
      Left = 2
      Top = 15
      Width = 562
      Height = 89
      HelpType = htKeyword
      Align = alTop
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 3
      WordWrap = False
      OnClick = rxfcClick
    end
    object barra: TProgressBar
      Left = 2
      Top = 642
      Width = 562
      Height = 17
      Align = alBottom
      TabOrder = 4
      Visible = False
    end
  end
  object DataSource1: TDataSource
    DataSet = tsprog
    Left = 456
    Top = 368
  end
  object tsprog: TADOQuery
    Parameters = <>
    Left = 408
    Top = 328
  end
  object tsversion: TADOQuery
    Parameters = <>
    Left = 416
    Top = 96
  end
  object DataSource2: TDataSource
    DataSet = tsversion
    Left = 456
    Top = 144
  end
  object poparchivo: TPopupMenu
    OnPopup = poparchivoPopup
    Left = 200
    Top = 408
    object N1: TMenuItem
      Caption = '-'
    end
  end
  object ImageList1: TImageList
    Left = 390
    Top = 228
    Bitmap = {
      494C010101000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      00000000000000000000000000000000000000000000F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF00F0FBFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080C0C00080E0E00080C0C00080E0
      E00080E0E00080E0E00080C0E00080C0E00080C0E00080C0E00080C0E00080C0
      E00080C0E00080C0E00080C0E000406060000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080C0C00080E0E00080E0E00080E0
      E00080E0E00080E0E00080E0E00080E0E00080E0E00080E0E00080E0E00080E0
      E00080E0E00080E0E000F0FBFF00406060000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080A0A00080E0E00080E0E00080E0
      E00080E0E00080E0E00080E0E00080E0E00080E0E00080E0E00080E0E00080E0
      E00080E0E00080E0E00080E0E000406060000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080A0C00080E0E00080E0E00080E0
      E00080E0E00080E0E00080E0E00080E0E00080E0E00080E0E00080E0E00080E0
      E00080E0E00080E0E00080E0E000406060000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080A0A00080E0E00080E0E00080E0
      E00080E0E00080E0E00080E0E00080E0E00080E0E00080E0E00080E0E00080E0
      E00080E0E00080E0E00080E0E000406060000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080A0A00080E0E00080E0E00080E0
      E00080E0E00080E0E00080E0E00080E0E00080E0E00080E0E00080E0E00080E0
      E00080E0E00080E0E00080E0E000406060000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080A0A00080E0E00080E0E00080E0
      E00080E0E00080E0E00080E0E00080E0E00080E0E00080E0E00080E0E00080E0
      E00080E0E00080E0E00080E0E000406060000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080A0A00080E0E00080E0E00080E0
      E00080E0E00080E0E00080E0E00080E0E00080E0E00080E0E00080E0E00080E0
      E00080E0E00080E0E00080E0E000406060000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080A0A00080E0E00080E0E00080E0
      E00080E0E00080E0E00080E0E00080E0E00080E0E00080E0E00080E0E00080E0
      E00080E0E00080E0E00080E0E000406060000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080A0A000F0FBFF0080E0E00080E0
      E00080E0E00080E0E00080E0E00080E0E00080E0E00080E0E00080E0E00080E0
      E00080E0E00080E0E000F0FBFF00406060000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A4A0A000F0FBFF00F0FBFF0080E0
      E000F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00C0DCC000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080C0C000C0DCC00080E0E00080E0
      E00080E0E00080E0E00080C0C00080C0C0004080800080C0C00080C0C00080C0
      C00080C0C00080A0C00080C0C000F0FBFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0FBFF0080E0E00080E0E00080E0
      E00080E0E00080E0E00080E0E00040808000F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF00F0FBFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0FBFF00C0DCC00080C0C00080C0
      C00040A0A00080C0C00040A0A000F0FBFF00F0FBFF00F0FBFF00F0FBFF000000
      00000000000000000000F0FBFF00F0FBFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0FBFF000000000000000000F0FB
      FF00F0FBFF00F0FBFF00F0FBFF00F0FBFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF0080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      001C00000000000060FF00000000000000000000000000000000000000000000
      000000000000}
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
            Item = mnuCargaUtileria
            Visible = True
          end
          item
            BeginGroup = True
            Item = mnuTodasLasLibrerias
            Visible = True
          end
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
    LookAndFeel.Kind = lfUltraFlat
    LookAndFeel.NativeStyle = False
    PopupMenuLinks = <>
    Style = bmsFlat
    UseSystemFont = False
    Left = 144
    Top = 408
    DockControlHeights = (
      0
      0
      0
      26)
    object mnuCargaUtileria: TdxBarButton
      Caption = 'Carga Utileria'
      Category = 0
      Hint = 'Carga Utileria'
      Visible = ivAlways
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000FF00FF00FF00
        FF00FF00FF00FF00FF00133E55FF285D84FF4886B9FF497FA0FF595758FF7656
        40FFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF0096D2E0FF2A6482FF93C7F9FF90C9F9FF4084C9FF2267A9FF5262
        6AFF278A51FF62B388FF88BCA1FFFF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF0067A1ACFF6E6F6FFF4288A9FFE0F2FFFF5399D8FF1979BDFF4897C4FF367E
        B5FF58A892FF575F5BFF4E4E4EFF507360FFFF00FF00FF00FF00FF00FF00AECA
        CFFFBBBBBBFFDEDEDEFF708DA1FF79B5D5FF8FB6D1FF54C9E4FF5ADFF5FF77D0
        EDFF4490D1FF96A2ACFFD2D2D2FF7F7F7FFF749483FFFF00FF00FF00FF00CDD3
        D4FFA5A5A5FFD5D5D5FFC4C4C4FF90B3C3FF74B8D6FFC1F6FDFF62DFF7FF5CE2
        F8FF78D3F0FF4695DAFFB8C2CDFF6C6D6DFF66917AFFFF00FF00FF00FF00FF00
        FF0079ADC6FFC4C4C4FFC0C0C0FFC4C4C4FF8BAFC1FF76CBE7FFC7F7FDFF5DDC
        F5FF59E1F7FF7AD4F1FF4695D9FF5D8E8DFFFF00FF00FF00FF00ACA29AFF908B
        88FF98A0A3FFCFCFCFFFC5C5C5FFCCCCCCFF82A8AFFF42BDDBFF78D3EEFFC7F7
        FDFF5EDCF5FF5AE2F7FF79D6F2FF4193D4FF51656BFF505F6EFFBEBDBDFFE2E2
        E2FFD2D2D2FFC5C5C5FFCDCDCDFFB0B0B0FFA3D5DDFFFF00FF0040D0F0FF7AD4
        EEFFC3F6FDFF6BDDF6FF6CCAEDFF62A2D7FF659ED2FF5E6771FFC3C2C2FFE9E9
        E9FFD6D6D6FFC9C9C9FFCECECEFFA4A4A4FF73B1CEFFFF00FF00FF00FF0052C2
        DEFF7ED4ECFFB1E3F9FF8ABFE7FFADD3F6FFC3E0FCFF659CD0FFCCC3BBFFBFBA
        B7FFC0BFBDFFD8D8D8FFCDCDCDFFBBBBBBFF949B9CFF83C8D5FF7DC8D6FF8AA1
        A5FF89BECEFF76BDE7FFB3D2F0FFE5F3FFFFABD2EFFF4A89C1FFFF00FF00FF00
        FF00CFC4B5FFD4D4D4FFCCCCCCFFC9C9C9FFB9B9B9FF9B9B9BFFA0A0A0FFC1C1
        C1FFC5C5C5FF91BACAFF57A4D8FF84B0DBFF459CD0FF2D90D7FFFF00FF00B8A2
        93FFC3C3C3FFDCDCDCFFD4D4D4FFD9D9D9FFDBDBDBFFD6D6D6FFD4D4D4FFD9D9
        D9FFD2D2D2FFCBCBCBFFC8C8C8FF787878FF4F83A7FFFF00FF00FF00FF00B9A0
        8FFFDCDCDCFFEDEDEDFFDBDBDBFFBDBFBFFFBCBDBDFFD6D6D6FFD4D4D4FFAFAF
        AFFFA6ABADFFCBCBCBFFE7E7E7FFB6B6B6FF708D9DFFFF00FF00FF00FF00FF00
        FF00C8BAAEFFCECECDFFCCCBCAFFE3DAD4FFBBC0C3FFDEDEDEFFDDDDDDFFAFB6
        B7FFBBEBF3FFB2B2B2FFA5A5A6FF7E949EFFFF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00BD9F85FFAD8567FFAB8060FFC4C0BEFFE5E5E5FFE4E4E4FFAEB0
        B1FFDDF7FBFF48AEE0FF7094A1FFFF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00AD8F7AFFBCAFA7FFACB6BBFF72B4
        D4FFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
      PaintStyle = psCaptionGlyph
      OnClick = mnuCargaUtileriaClick
    end
    object mnuTodasLasLibrerias: TdxBarButton
      Caption = 'Todas las librerias'
      Category = 0
      Hint = 'Todas las librerias'
      Visible = ivAlways
      PaintStyle = psCaptionGlyph
      OnClick = mnuTodasLasLibreriasClick
    end
    object mnuAyuda: TdxBarButton
      Align = iaRight
      Caption = 'Ayuda'
      Category = 0
      Hint = 'Ayuda a nivel pantalla'
      Visible = ivAlways
      ImageIndex = 30
      ShortCut = 112
      OnClick = mnuAyudaClick
    end
  end
end
