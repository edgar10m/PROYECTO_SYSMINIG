object alkFormJerCla: TalkFormJerCla
  Left = 382
  Top = 158
  Width = 388
  Height = 417
  Caption = 'Jerarquia de clases'
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
    Top = 24
    Width = 163
    Height = 20
    Caption = 'Seleccione un sistema:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Button1: TButton
    Left = 264
    Top = 328
    Width = 75
    Height = 25
    Caption = 'OK'
    Enabled = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object rgSist: TRadioGroup
    Left = 16
    Top = 64
    Width = 337
    Height = 241
    Caption = 'Sistemas'
    TabOrder = 1
    OnClick = rgSistClick
  end
end
