object alkGridReingresa: TalkGridReingresa
  Left = 291
  Top = 109
  Width = 844
  Height = 368
  Caption = 'Seleccione un documento'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object grdReingresa: TStringGrid
    Left = 0
    Top = 0
    Width = 828
    Height = 330
    Cursor = crHandPoint
    Hint = 'Seleccione un documento'
    Align = alClient
    ColCount = 13
    DefaultColWidth = 80
    DefaultRowHeight = 30
    TabOrder = 0
    OnSelectCell = grdReingresaSelectCell
  end
end
