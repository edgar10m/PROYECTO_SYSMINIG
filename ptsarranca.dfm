object ftsarranca: Tftsarranca
  Left = 13
  Top = 132
  Width = 1305
  Height = 675
  Caption = 'ftsarranca'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label4: TLabel
    Left = 224
    Top = 0
    Width = 60
    Height = 13
    Caption = 'Componente'
  end
  object Label5: TLabel
    Left = 432
    Top = 32
    Width = 60
    Height = 13
    Caption = 'Componente'
  end
  object Splitter1: TSplitter
    Left = 320
    Top = 97
    Width = 9
    Height = 540
    Beveled = True
  end
  object Splitter2: TSplitter
    Left = 937
    Top = 97
    Width = 9
    Height = 540
    Beveled = True
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1289
    Height = 97
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 32
      Top = 0
      Width = 26
      Height = 13
      Caption = 'Clase'
    end
    object Label2: TLabel
      Left = 120
      Top = 0
      Width = 46
      Height = 13
      Caption = 'Biblioteca'
    end
    object Label3: TLabel
      Left = 232
      Top = 0
      Width = 60
      Height = 13
      Caption = 'Componente'
    end
    object Label6: TLabel
      Left = 328
      Top = 0
      Width = 39
      Height = 13
      Caption = 'Registro'
    end
    object Label7: TLabel
      Left = 432
      Top = 0
      Width = 33
      Height = 13
      Caption = 'Campo'
    end
    object ComboBox1: TComboBox
      Left = 16
      Top = 16
      Width = 81
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object ComboBox2: TComboBox
      Left = 112
      Top = 16
      Width = 89
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
    end
    object ComboBox3: TComboBox
      Left = 216
      Top = 16
      Width = 89
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
    end
    object bejecuta: TButton
      Left = 528
      Top = 13
      Width = 75
      Height = 25
      Caption = 'Ejecuta'
      TabOrder = 3
    end
  end
  object ComboBox4: TComboBox
    Left = 320
    Top = 16
    Width = 89
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
  end
  object ComboBox5: TComboBox
    Left = 424
    Top = 16
    Width = 89
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 97
    Width = 320
    Height = 540
    Align = alLeft
    DataSource = DataSource1
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object DBGrid2: TDBGrid
    Left = 946
    Top = 97
    Width = 343
    Height = 540
    Align = alClient
    DataSource = DataSource3
    TabOrder = 4
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object DBGrid3: TDBGrid
    Left = 329
    Top = 97
    Width = 608
    Height = 540
    Align = alLeft
    DataSource = DataSource2
    TabOrder = 5
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object DataSource1: TDataSource
    DataSet = ADOQuery1
    Left = 136
    Top = 184
  end
  object DataSource2: TDataSource
    DataSet = ADOQuery2
    Left = 448
    Top = 200
  end
  object DataSource3: TDataSource
    DataSet = ADOQuery3
    Left = 1008
    Top = 208
  end
  object ADOQuery1: TADOQuery
    Parameters = <>
    Left = 104
    Top = 192
  end
  object ADOQuery2: TADOQuery
    Parameters = <>
    Left = 424
    Top = 216
  end
  object ADOQuery3: TADOQuery
    Parameters = <>
    Left = 976
    Top = 208
  end
end
