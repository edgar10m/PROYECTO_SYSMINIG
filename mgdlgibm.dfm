object fmgdlgibm: Tfmgdlgibm
  Left = 859
  Top = 400
  Width = 252
  Height = 175
  Caption = 'Login Host'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 22
    Height = 13
    Caption = 'Host'
  end
  object Label2: TLabel
    Left = 16
    Top = 32
    Width = 36
    Height = 13
    Caption = 'Usuario'
  end
  object Label3: TLabel
    Left = 16
    Top = 56
    Width = 46
    Height = 13
    Caption = 'Password'
  end
  object txtpassword: TEdit
    Left = 88
    Top = 48
    Width = 145
    Height = 21
    PasswordChar = '*'
    TabOrder = 0
    OnChange = txtpasswordChange
  end
  object cmbusuario: TComboBox
    Left = 88
    Top = 24
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    OnChange = cmbusuarioChange
  end
  object cmbhost: TComboBox
    Left = 88
    Top = 0
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 2
    OnChange = cmbhostChange
  end
  object bsalida: TBitBtn
    Left = 147
    Top = 110
    Width = 75
    Height = 25
    Caption = 'CANCELAR'
    TabOrder = 3
    OnClick = bsalidaClick
  end
  object bconectar: TBitBtn
    Left = 24
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Conectar'
    Default = True
    Enabled = False
    TabOrder = 4
    OnClick = bconectarClick
  end
  object bdesconectar: TBitBtn
    Left = 147
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Desconectar'
    Enabled = False
    TabOrder = 5
    OnClick = bdesconectarClick
  end
  object bok: TBitBtn
    Left = 24
    Top = 110
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    Enabled = False
    TabOrder = 6
    OnClick = bokClick
  end
end
