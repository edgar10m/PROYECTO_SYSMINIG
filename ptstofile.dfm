object ftstofile: Tftstofile
  Left = 387
  Top = 130
  Width = 870
  Height = 640
  Caption = 'Origenes de Datos'
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
  object Splitter1: TSplitter
    Left = 393
    Top = 71
    Width = 8
    Height = 531
    Beveled = True
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 854
    Height = 71
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 410
      Top = 5
      Width = 60
      Height = 13
      Caption = 'Componente'
    end
    object Label2: TLabel
      Left = 8
      Top = 8
      Width = 37
      Height = 13
      Caption = 'Sistema'
    end
    object Label3: TLabel
      Left = 19
      Top = 32
      Width = 26
      Height = 13
      Caption = 'Clase'
      FocusControl = barchivo
    end
    object Label4: TLabel
      Left = 0
      Top = 56
      Width = 46
      Height = 13
      Caption = 'Biblioteca'
    end
    object txtarchivo: TEdit
      Left = 314
      Top = 19
      Width = 239
      Height = 21
      Enabled = False
      TabOrder = 0
      Text = '*'
    end
    object barchivo: TButton
      Left = 552
      Top = 16
      Width = 17
      Height = 25
      Caption = '*'
      Enabled = False
      TabOrder = 1
      OnClick = barchivoClick
    end
    object cmbarchivo: TComboBox
      Left = 314
      Top = 43
      Width = 257
      Height = 21
      Style = csDropDownList
      Enabled = False
      ItemHeight = 13
      TabOrder = 2
      OnChange = cmbarchivoChange
    end
    object cmbsistema: TComboBox
      Left = 49
      Top = 1
      Width = 185
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 3
      OnChange = cmbsistemaChange
    end
    object cmbclase: TComboBox
      Left = 49
      Top = 25
      Width = 185
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 4
      OnChange = cmbsistemaChange
      Items.Strings = (
        'FIL'
        'TAB')
    end
    object cmbbib: TComboBox
      Left = 49
      Top = 49
      Width = 185
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 5
      OnChange = cmbbibChange
    end
  end
  object tv: TTreeView
    Left = 0
    Top = 71
    Width = 393
    Height = 531
    Align = alLeft
    Images = dm.imgclases
    Indent = 19
    TabOrder = 1
    OnExpanding = tvExpanding
    OnMouseDown = tvMouseDown
  end
  object memo: TRichEdit
    Left = 401
    Top = 71
    Width = 453
    Height = 531
    Align = alClient
    Lines.Strings = (
      'RichEdit1')
    TabOrder = 2
  end
end
