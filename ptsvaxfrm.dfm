object ftsvaxfrm: Tftsvaxfrm
  Left = 42
  Top = 256
  Width = 535
  Height = 427
  Caption = 'ftsvaxfrm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  OnClose = FormClose
  OnCreate = FormCreate
  OnDblClick = FormDblClick
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object PopupMenu1: TPopupMenu
    Left = 392
    Top = 176
    object Exportar1: TMenuItem
      Caption = 'Exportar'
      OnClick = Exportar1Click
    end
  end
  object SavePictureDialog1: TSavePictureDialog
    Left = 48
    Top = 88
  end
end
