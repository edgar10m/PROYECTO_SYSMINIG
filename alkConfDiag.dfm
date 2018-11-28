object alkFormConfDiag: TalkFormConfDiag
  Left = 266
  Top = 118
  Width = 480
  Height = 521
  Caption = 'Configurar Diagrama'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label7: TLabel
    Left = 10
    Top = 8
    Width = 86
    Height = 20
    Caption = 'Seleccione :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 58
    Top = 40
    Width = 133
    Height = 20
    Caption = 'Tipo de Diagrama: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 58
    Top = 176
    Width = 135
    Height = 20
    Caption = 'Formato de salida: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 24
    Top = 312
    Width = 204
    Height = 20
    Caption = 'Cambiar la carpeta de salida:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object rgTipo: TRadioGroup
    Left = 224
    Top = 40
    Width = 137
    Height = 113
    Items.Strings = (
      'Horizontal'
      'Vertical'
      'Split (partes)')
    TabOrder = 0
    OnClick = rgTipoClick
  end
  object rgFormato: TRadioGroup
    Left = 224
    Top = 176
    Width = 137
    Height = 105
    Items.Strings = (
      'Imagen (jpg)'
      'PDF')
    TabOrder = 1
    OnClick = rgFormatoClick
  end
  object Button1: TButton
    Left = 336
    Top = 408
    Width = 75
    Height = 25
    Caption = 'Generar'
    TabOrder = 2
    OnClick = Button1Click
  end
  object lbruta: TEdit
    Left = 24
    Top = 366
    Width = 353
    Height = 21
    ReadOnly = True
    TabOrder = 3
  end
  object Button2: TButton
    Left = 384
    Top = 363
    Width = 33
    Height = 25
    Caption = '...'
    TabOrder = 4
    OnClick = Button2Click
  end
  object SaveDialog: TSaveDialog
    Left = 296
    Top = 320
  end
end
