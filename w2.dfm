object Form2: TForm2
  Left = 194
  Top = 170
  Width = 870
  Height = 640
  Caption = 'Form2'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 88
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object ProgressBar1: TProgressBar
    Left = 200
    Top = 88
    Width = 457
    Height = 17
    TabOrder = 1
    Visible = False
  end
  object bsig: TButton
    Left = 88
    Top = 168
    Width = 75
    Height = 25
    Caption = 'Siguiente forma'
    TabOrder = 2
    OnClick = bsigClick
  end
end
