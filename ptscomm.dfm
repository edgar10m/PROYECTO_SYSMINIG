object ftscomm: Tftscomm
  Left = 194
  Top = 226
  Width = 1305
  Height = 678
  Caption = 'Resumen COMMAREAS'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFF
    FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000000000FF000
    000000000000000000000000000FF000000000000000000000000000000FF000
    000000000000000000000000000FF00000078FF87000000000000000000FF000
    078FFFFFF870000000000000000FF0007FFFFFFFFFF7000000000000000FF000
    8FFFFFFFFFF8000000000000000FF007FFFFFFFFFFFF700000000000000FF008
    FFFFFFFFFFFF800000000000000FF00FFFFFFFFFFFFFF00000000000000FF00F
    FFFFFFFFFFFFF00000000000000FF008FFFFFFFFFFFF800000000000000FF007
    FFFFFFFFFFFF700000000000000FF0008FFFFFFFFFF8000000000000000FF000
    7FFFFFFFFFF7000000000000000FF000078FFFFFF8778FF870000000000FF000
    00078FF8707FFFFFF7000000000FF0000000000007FFFFFFFF700000000FF000
    0000000008FFFFFFFF800000000FF000000000000FFFFFFFFFF00788700FF000
    000000000FFFFFFFFFF07FFFF70FF0000000000008FFFFFFFF808FFFF80FF000
    0000000007FFFFFFFF708FFFF80FF00000000000007FFFFFF7007FFFF70FF000
    0000000000078FF870000788700FF000000000000000000000000000000FF000
    000000000000000000000000000FF000000000000000000000000000000FF000
    000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 57
    Width = 9
    Height = 583
    Beveled = True
    Visible = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1289
    Height = 57
    Align = alTop
    TabOrder = 0
    object cmbbib: TComboBox
      Left = 9
      Top = 12
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object mas1: TEdit
      Left = 176
      Top = 12
      Width = 89
      Height = 21
      TabOrder = 1
    end
    object mas2: TEdit
      Left = 272
      Top = 12
      Width = 89
      Height = 21
      TabOrder = 2
    end
    object mas3: TEdit
      Left = 368
      Top = 12
      Width = 89
      Height = 21
      TabOrder = 3
    end
    object mas4: TEdit
      Left = 464
      Top = 12
      Width = 89
      Height = 21
      TabOrder = 4
    end
    object mas5: TEdit
      Left = 560
      Top = 12
      Width = 89
      Height = 21
      TabOrder = 5
    end
    object mas6: TEdit
      Left = 656
      Top = 12
      Width = 89
      Height = 21
      TabOrder = 6
    end
    object bejecuta: TButton
      Left = 752
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Ejecuta'
      TabOrder = 7
      OnClick = bejecutaClick
    end
    object chksolo: TCheckBox
      Left = 176
      Top = 32
      Width = 121
      Height = 17
      Caption = 'Registros afectados'
      Checked = True
      State = cbChecked
      TabOrder = 8
    end
    object chkcampo: TCheckBox
      Left = 368
      Top = 32
      Width = 121
      Height = 17
      Caption = 'Campos afectados'
      Checked = True
      State = cbChecked
      TabOrder = 9
    end
    object pb: TProgressBar
      Left = 1
      Top = 48
      Width = 1287
      Height = 8
      Align = alBottom
      TabOrder = 10
      Visible = False
    end
    object brelacionados: TButton
      Left = 832
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Relacionados'
      TabOrder = 11
      OnClick = bejecutaClick
    end
    object breporte: TButton
      Left = 912
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Reporte'
      TabOrder = 12
      Visible = False
      OnClick = breporteClick
    end
  end
  object dg: TDrawGrid
    Left = 9
    Top = 57
    Width = 1041
    Height = 583
    Align = alClient
    ColCount = 1
    DefaultColWidth = 200
    DefaultRowHeight = 20
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goRangeSelect]
    TabOrder = 1
    OnDrawCell = dgDrawCell
  end
  object DrawGrid1: TDrawGrid
    Left = 1050
    Top = 57
    Width = 239
    Height = 583
    Align = alRight
    ColCount = 1
    DefaultColWidth = 200
    DefaultRowHeight = 20
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goRangeSelect]
    TabOrder = 2
    Visible = False
  end
  object SaveDialog1: TSaveDialog
    Left = 800
    Top = 128
  end
end
