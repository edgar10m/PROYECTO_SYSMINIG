object alkNuevoDiagrama: TalkNuevoDiagrama
  Left = 306
  Top = 12
  Width = 563
  Height = 432
  BorderIcons = [biSystemMenu]
  Caption = 'Configurar Diagrama de Sistema'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 24
    Width = 525
    Height = 20
    Caption = 
      'Seleccione las clases que desea usar para el nuevo Diagrama de S' +
      'istema:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object btnGenerar: TButton
    Left = 432
    Top = 352
    Width = 75
    Height = 25
    Caption = 'Generar'
    Enabled = False
    TabOrder = 0
    OnClick = btnGenerarClick
  end
  object CheckListBox1: TCheckListBox
    Left = 24
    Top = 168
    Width = 489
    Height = 169
    Columns = 2
    ItemHeight = 13
    TabOrder = 1
    OnClick = CheckListBox1Click
  end
  object rbselecciona: TRadioButton
    Left = 32
    Top = 344
    Width = 113
    Height = 17
    Caption = 'Seleccionar todo'
    Enabled = False
    TabOrder = 2
    OnClick = rbseleccionaClick
  end
  object rbdeselecciona: TRadioButton
    Left = 32
    Top = 368
    Width = 113
    Height = 17
    Caption = 'Deseleccionar todo'
    Enabled = False
    TabOrder = 3
    OnClick = rbdeseleccionaClick
  end
  object rgPadres: TRadioGroup
    Left = 24
    Top = 64
    Width = 489
    Height = 97
    Caption = 'Padres'
    Columns = 4
    TabOrder = 4
    Visible = False
    OnClick = rgPadresClick
  end
end
