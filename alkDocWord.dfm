object alkFormDocWord: TalkFormDocWord
  Left = 208
  Top = 115
  BorderStyle = bsSingle
  Caption = 'Generar Documentaci'#243'n'
  ClientHeight = 402
  ClientWidth = 468
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 205
    Width = 468
    Height = 197
    Align = alBottom
    TabOrder = 0
    object Label2: TLabel
      Left = 10
      Top = 5
      Width = 102
      Height = 20
      Caption = 'Configuraci'#243'n:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 18
      Top = 145
      Width = 90
      Height = 16
      Caption = 'Ruta de salida:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 18
      Top = 113
      Width = 35
      Height = 16
      Caption = 'Clase'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 18
      Top = 81
      Width = 49
      Height = 16
      Caption = 'Sistema'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 18
      Top = 49
      Width = 55
      Height = 16
      Caption = 'Empresa'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object cbSistema: TComboBox
      Left = 136
      Top = 76
      Width = 257
      Height = 21
      Enabled = False
      ItemHeight = 13
      TabOrder = 0
      OnChange = cbSistemaChange
    end
    object cbClase: TComboBox
      Left = 136
      Top = 108
      Width = 257
      Height = 21
      Enabled = False
      ItemHeight = 13
      TabOrder = 1
    end
    object lbruta: TEdit
      Left = 136
      Top = 140
      Width = 257
      Height = 21
      Enabled = False
      ReadOnly = True
      TabOrder = 2
    end
    object btnRuta: TButton
      Left = 400
      Top = 136
      Width = 33
      Height = 25
      Caption = '...'
      Enabled = False
      TabOrder = 3
      OnClick = btnRutaClick
    end
    object cbEmpresa: TComboBox
      Left = 136
      Top = 44
      Width = 257
      Height = 21
      Enabled = False
      ItemHeight = 13
      TabOrder = 4
      OnChange = cbEmpresaChange
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 468
    Height = 205
    Align = alClient
    TabOrder = 1
    object Label1: TLabel
      Left = 10
      Top = 24
      Width = 152
      Height = 20
      Caption = 'Documentacion para:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object rgDoc: TRadioGroup
      Left = 40
      Top = 56
      Width = 265
      Height = 113
      Items.Strings = (
        'Documento T'#233'cnico de Sistema'
        'Documento T'#233'cnico de Procesos de Negocio'
        'Documento T'#233'cnico de Componentes')
      TabOrder = 0
      OnClick = rgDocClick
    end
    object btnGenerar: TButton
      Left = 328
      Top = 104
      Width = 75
      Height = 25
      Caption = 'Generar'
      Enabled = False
      TabOrder = 1
      OnClick = btnGenerarClick
    end
  end
  object SaveDialog: TSaveDialog
    Left = 376
    Top = 8
  end
end
