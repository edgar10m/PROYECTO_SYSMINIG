object alkAnCompl: TalkAnCompl
  Left = 339
  Top = 119
  Width = 389
  Height = 419
  Caption = 'An'#225'lisis de complejidad'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 26
    Top = 48
    Width = 205
    Height = 20
    Caption = 'debe seleccionar un sistema:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 26
    Top = 24
    Width = 289
    Height = 20
    Caption = 'Para comenzar el an'#225'lisis de complejidad'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Button1: TButton
    Left = 264
    Top = 336
    Width = 75
    Height = 25
    Caption = 'OK'
    Enabled = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object rgSist: TRadioGroup
    Left = 16
    Top = 80
    Width = 337
    Height = 241
    Caption = 'Sistemas'
    TabOrder = 1
    OnClick = rgSistClick
  end
end
