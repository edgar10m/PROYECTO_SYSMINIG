object tsfds_A: Ttsfds_A
  Left = 285
  Top = 112
  Width = 992
  Height = 499
  Caption = 'tsfds'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 41
    Height = 420
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 976
    Height = 41
    Align = alTop
    TabOrder = 0
    object lblMascara: TLabel
      Left = 16
      Top = 8
      Width = 41
      Height = 13
      Caption = 'Mascara'
    end
    object lblProg: TLabel
      Left = 288
      Top = 8
      Width = 45
      Height = 13
      Caption = 'Programa'
      Visible = False
    end
    object txtMascara: TEdit
      Left = 64
      Top = 8
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object btnMascara: TButton
      Left = 192
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Busca'
      TabOrder = 1
      OnClick = btnMascaraClick
    end
    object cbProg: TComboBox
      Left = 344
      Top = 8
      Width = 273
      Height = 21
      ItemHeight = 13
      TabOrder = 2
      Visible = False
    end
    object btnProg: TButton
      Left = 624
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Busca'
      TabOrder = 3
      Visible = False
      OnClick = btnProgClick
    end
  end
end
