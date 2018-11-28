object frcob: Tfrcob
  Left = 0
  Top = 0
  Width = 159
  Height = 25
  Color = clMenuBar
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  object lab: TLabel
    Left = 26
    Top = 0
    Width = 116
    Height = 25
    AutoSize = False
    Caption = 'lab'
    Color = clMenuBar
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'r_ansi'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    WordWrap = True
    OnClick = labClick
  end
  object bot: TSpeedButton
    Left = 142
    Top = 4
    Width = 17
    Height = 17
    Caption = '+'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = botClick
  end
  object img: TImage
    Left = 0
    Top = 0
    Width = 25
    Height = 25
    Stretch = True
    OnDblClick = imgDblClick
  end
end
