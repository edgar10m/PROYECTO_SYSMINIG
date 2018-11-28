object fbarra: Tfbarra
  Left = 385
  Top = 409
  BorderIcons = []
  BorderStyle = bsNone
  Caption = ' '
  ClientHeight = 21
  ClientWidth = 356
  Color = clMenu
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 2
    Top = 1
    Width = 354
    Height = 16
    BevelOuter = bvNone
    Color = clMenu
    TabOrder = 0
    object StatusBar1: TStatusBar
      Left = 0
      Top = 3
      Width = 354
      Height = 13
      Color = clMenu
      Panels = <
        item
          Bevel = pbNone
          Text = 'Procesando'
          Width = 60
        end
        item
          Bevel = pbNone
          Style = psOwnerDraw
          Width = 50
        end>
      OnDrawPanel = StatusBar1DrawPanel
    end
  end
  object ProgressBar1: TProgressBar
    Left = 78
    Top = 8
    Width = 265
    Height = 3
    Smooth = True
    TabOrder = 1
  end
end
