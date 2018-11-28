object fmgrecibm: Tfmgrecibm
  Left = 17
  Top = 0
  Width = 771
  Height = 591
  BorderIcons = [biSystemMenu, biMaximize]
  BorderWidth = 10
  Caption = 'Extrae Componentes de HOST'
  Color = clBtnFace
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
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 743
    Height = 506
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      BorderWidth = 5
      Caption = 'Recibe'
      object Label8: TLabel
        Left = 5
        Top = 0
        Width = 5
        Height = 468
        Align = alLeft
        AutoSize = False
      end
      object Label7: TLabel
        Left = 0
        Top = 0
        Width = 5
        Height = 468
        Align = alLeft
        AutoSize = False
      end
      object Splitter4: TSplitter
        Left = 389
        Top = 0
        Height = 468
        Align = alRight
      end
      object grbRecepcion: TGroupBox
        Left = 10
        Top = 0
        Width = 260
        Height = 468
        Align = alClient
        Caption = 'Recepci'#243'n'
        TabOrder = 0
        object lvibm: TListView
          Left = 2
          Top = 44
          Width = 256
          Height = 422
          Align = alClient
          Checkboxes = True
          Color = 15193047
          Columns = <
            item
              Caption = 'Nombre'
            end
            item
              Caption = 'Fecha'
            end
            item
              Caption = 'Tama'#241'o'
            end
            item
              Caption = 'Permisos'
            end>
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          GridLines = True
          ReadOnly = True
          RowSelect = True
          ParentFont = False
          PopupMenu = pop
          TabOrder = 0
          ViewStyle = vsReport
          OnClick = lvibmClick
          OnExit = lvibmExit
          OnMouseDown = lvibmMouseDown
        end
        object Panel2: TPanel
          Left = 2
          Top = 15
          Width = 256
          Height = 29
          Align = alTop
          Color = clActiveCaption
          TabOrder = 1
          object cmblibreria: TComboBox
            Left = 3
            Top = 4
            Width = 249
            Height = 21
            ItemHeight = 13
            TabOrder = 0
            OnChange = cmblibreriaChange
            OnClick = cmblibreriaClick
            OnExit = cmblibreriaExit
          end
        end
      end
      object GroupBox2: TGroupBox
        Left = 270
        Top = 0
        Width = 119
        Height = 468
        Align = alRight
        Caption = 'Operaci'#243'n'
        TabOrder = 1
        object Label2: TLabel
          Left = 39
          Top = 161
          Width = 41
          Height = 13
          Caption = 'M'#225'scara'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label5: TLabel
          Left = 41
          Top = 27
          Width = 37
          Height = 13
          Caption = 'Sistema'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label1: TLabel
          Left = 7
          Top = 74
          Width = 104
          Height = 13
          Caption = 'Clase de Componente'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label6: TLabel
          Left = 36
          Top = 119
          Width = 46
          Height = 13
          Caption = 'Biblioteca'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label4: TLabel
          Left = 20
          Top = 432
          Width = 83
          Height = 13
          Caption = 'Integra Selecci'#243'n'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object txtsufijo: TEdit
          Left = 11
          Top = 176
          Width = 97
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          Text = '*.*'
        end
        object txtsistema: TComboBox
          Left = 11
          Top = 42
          Width = 97
          Height = 21
          Style = csDropDownList
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 13
          ParentFont = False
          TabOrder = 0
          OnChange = txtsistemaChange
        end
        object cmbt: TComboBox
          Left = 11
          Top = 89
          Width = 97
          Height = 21
          Style = csDropDownList
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 13
          ParentFont = False
          TabOrder = 1
          OnChange = cmbtChange
        end
        object txtbiblioteca: TComboBox
          Left = 11
          Top = 134
          Width = 97
          Height = 21
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 13
          ParentFont = False
          TabOrder = 2
          OnChange = txtbibliotecaChange
          OnKeyPress = txtbibliotecaKeyPress
        end
        object barchivo: TBitBtn
          Left = 22
          Top = 448
          Width = 75
          Height = 21
          Caption = '>>'
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnClick = barchivoClick
        end
        object rghost: TRadioGroup
          Left = 8
          Top = 208
          Width = 105
          Height = 65
          Caption = 'Tipo de Host'
          ItemIndex = 0
          Items.Strings = (
            'Unix'
            'IBM'
            'Tandem')
          TabOrder = 5
        end
        object Button2: TButton
          Left = 16
          Top = 288
          Width = 89
          Height = 25
          Caption = 'Selecciona todos'
          TabOrder = 6
          OnClick = Button2Click
        end
        object Button3: TButton
          Left = 16
          Top = 328
          Width = 89
          Height = 25
          Caption = 'Deselecc todos'
          TabOrder = 7
          OnClick = Button3Click
        end
        object Button4: TButton
          Left = 16
          Top = 368
          Width = 89
          Height = 25
          Caption = 'Inconsistentes'
          TabOrder = 8
          OnClick = Button4Click
        end
      end
      object GroupBox3: TGroupBox
        Left = 392
        Top = 0
        Width = 333
        Height = 468
        Align = alRight
        Caption = 'Resultados'
        TabOrder = 2
        object Splitter1: TSplitter
          Left = 2
          Top = 118
          Width = 329
          Height = 3
          Cursor = crVSplit
          Align = alTop
        end
        object Splitter2: TSplitter
          Left = 2
          Top = 224
          Width = 329
          Height = 3
          Cursor = crVSplit
          Align = alTop
        end
        object Splitter3: TSplitter
          Left = 2
          Top = 330
          Width = 329
          Height = 3
          Cursor = crVSplit
          Align = alTop
        end
        object rxfc: TRxRichEdit
          Left = 2
          Top = 15
          Width = 329
          Height = 103
          Align = alTop
          Color = 15193047
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          WordWrap = False
        end
        object rxfuente: TRxRichEdit
          Left = 2
          Top = 121
          Width = 329
          Height = 103
          Align = alTop
          Color = 16116974
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 1
          WordWrap = False
        end
        object lvux: TListView
          Left = 2
          Top = 227
          Width = 329
          Height = 103
          Align = alTop
          Color = 15193047
          Columns = <
            item
              Caption = 'Nombre'
            end
            item
              Caption = 'Fecha'
            end
            item
              Caption = 'Tama'#241'o'
            end
            item
              Caption = 'Permisos'
            end>
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          GridLines = True
          ReadOnly = True
          RowSelect = True
          ParentFont = False
          PopupMenu = pop
          TabOrder = 2
          ViewStyle = vsReport
          OnClick = lvuxClick
          OnMouseDown = lvuxMouseDown
        end
        object lvver: TListView
          Left = 2
          Top = 333
          Width = 329
          Height = 133
          Align = alClient
          Color = 16116974
          Columns = <
            item
              Caption = 'Nombre'
            end
            item
              Caption = 'Fecha'
            end
            item
              Caption = 'Tama'#241'o'
            end
            item
              Caption = 'Permisos'
            end>
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          GridLines = True
          ReadOnly = True
          RowSelect = True
          ParentFont = False
          TabOrder = 3
          ViewStyle = vsReport
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 506
    Width = 743
    Height = 27
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Label3: TLabel
      Left = 8
      Top = 6
      Width = 37
      Height = 13
      Caption = 'Items   :'
    end
    object Label9: TLabel
      Left = 120
      Top = 6
      Width = 36
      Height = 13
      Caption = 'Selecc:'
    end
    object lblselec: TLabel
      Left = 160
      Top = 3
      Width = 11
      Height = 20
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblitems: TLabel
      Left = 48
      Top = 3
      Width = 11
      Height = 20
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Panel6: TPanel
      Left = 668
      Top = 0
      Width = 75
      Height = 27
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object Button1: TButton
        Left = 0
        Top = 6
        Width = 75
        Height = 21
        Caption = 'Salir'
        TabOrder = 0
        OnClick = Button1Click
      end
    end
  end
  object pop: TPopupMenu
    OnPopup = popPopup
    Left = 535
    Top = 296
  end
end
