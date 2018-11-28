object ftscompver: Tftscompver
  Left = 244
  Top = 185
  Width = 1088
  Height = 744
  Caption = 'ftscompver'
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
    Left = 400
    Top = 0
    Width = 8
    Height = 706
    Beveled = True
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 400
    Height = 706
    Align = alLeft
    TabOrder = 0
    object Splitter2: TSplitter
      Left = 1
      Top = 291
      Width = 398
      Height = 7
      Cursor = crVSplit
      Align = alTop
      Beveled = True
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 398
      Height = 72
      Align = alTop
      Color = 13405336
      TabOrder = 0
      object Label5: TLabel
        Left = 8
        Top = 18
        Width = 26
        Height = 13
        Caption = 'Clase'
      end
      object Label3: TLabel
        Left = 8
        Top = 49
        Width = 48
        Height = 11
        Alignment = taCenter
        AutoSize = False
        Caption = 'M'#225'scara'
      end
      object cmbclase: TComboBox
        Left = 63
        Top = 13
        Width = 265
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        OnClick = cmbclaseClick
      end
      object txtfil: TEdit
        Left = 62
        Top = 44
        Width = 265
        Height = 21
        TabOrder = 1
      end
      object Button1: TButton
        Left = 328
        Top = 42
        Width = 66
        Height = 25
        Caption = 'Ejecutar'
        TabOrder = 2
        OnClick = Button1Click
      end
    end
    object lver: TListView
      Tag = 1
      Left = 1
      Top = 346
      Width = 398
      Height = 359
      Align = alClient
      Color = 14988991
      Columns = <
        item
          Caption = 'Fecha'
          Width = 150
        end
        item
          AutoSize = True
          Caption = 'Paquete'
        end>
      DragMode = dmAutomatic
      GridLines = True
      MultiSelect = True
      RowSelect = True
      TabOrder = 1
      ViewStyle = vsReport
      OnClick = lverClick
    end
    object lv: TListView
      Tag = 1
      Left = 1
      Top = 73
      Width = 398
      Height = 177
      Align = alTop
      Color = 14988991
      Columns = <
        item
          Caption = 'Biblioteca'
          Width = 75
        end
        item
          AutoSize = True
          Caption = 'Componente'
        end>
      DragMode = dmAutomatic
      GridLines = True
      RowSelect = True
      TabOrder = 2
      ViewStyle = vsReport
      OnClick = lvClick
    end
    object Panel3: TPanel
      Left = 1
      Top = 298
      Width = 398
      Height = 48
      Align = alTop
      Caption = 'Seleccione 2 versiones con <CTRL> y Click'
      Color = 13405336
      TabOrder = 3
      object bcompara: TButton
        Left = 328
        Top = 15
        Width = 66
        Height = 25
        Caption = 'Compara'
        TabOrder = 0
        Visible = False
      end
      object Button3: TButton
        Left = 9
        Top = 15
        Width = 66
        Height = 25
        Caption = 'Salir'
        TabOrder = 1
        OnClick = Button3Click
      end
    end
    object Panel4: TPanel
      Left = 1
      Top = 250
      Width = 398
      Height = 41
      Align = alTop
      TabOrder = 4
      object lbltotal: TLabel
        Left = 16
        Top = 4
        Width = 30
        Height = 13
        Caption = 'Total'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object bmas: TButton
        Left = 294
        Top = 3
        Width = 79
        Height = 25
        Caption = 'M'#225's...'
        TabOrder = 0
        Visible = False
        OnClick = bmasClick
      end
    end
  end
  object RichEdit1: TRichEdit
    Left = 408
    Top = 0
    Width = 664
    Height = 706
    Align = alClient
    Lines.Strings = (
      'RichEdit1')
    TabOrder = 1
  end
end
