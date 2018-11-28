object fmgrecibm: Tfmgrecibm
  Left = 61
  Top = 127
  Width = 1290
  Height = 820
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
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1254
    Height = 735
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
        Height = 697
        Align = alLeft
        AutoSize = False
      end
      object Label7: TLabel
        Left = 0
        Top = 0
        Width = 5
        Height = 697
        Align = alLeft
        AutoSize = False
      end
      object Splitter4: TSplitter
        Left = 761
        Top = 0
        Width = 8
        Height = 697
        Beveled = True
      end
      object Splitter1: TSplitter
        Left = 297
        Top = 0
        Width = 8
        Height = 697
        Beveled = True
      end
      object grbRecepcion: TGroupBox
        Left = 10
        Top = 0
        Width = 287
        Height = 697
        Align = alLeft
        Caption = 'Host'
        TabOrder = 0
        object lvibm: TListView
          Left = 2
          Top = 73
          Width = 283
          Height = 622
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
        end
        object Panel2: TPanel
          Left = 2
          Top = 15
          Width = 283
          Height = 58
          Align = alTop
          Color = clActiveCaption
          TabOrder = 1
          object Label2: TLabel
            Left = 7
            Top = 37
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
          object cmblibreria: TComboBox
            Left = 3
            Top = 4
            Width = 249
            Height = 21
            ItemHeight = 13
            TabOrder = 0
            OnChange = cmblibreriaChange
            OnClick = cmblibreriaClick
          end
          object txtsufijo: TEdit
            Left = 51
            Top = 29
            Width = 97
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            Text = '*'
          end
          object barchivo: TBitBtn
            Left = 166
            Top = 29
            Width = 75
            Height = 21
            Caption = 'Consulta'
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            OnClick = barchivoClick
          end
        end
      end
      object GroupBox3: TGroupBox
        Left = 769
        Top = 0
        Width = 467
        Height = 697
        Align = alClient
        Caption = 'Resultados'
        TabOrder = 1
        object vl: TValueListEditor
          Left = 2
          Top = 89
          Width = 463
          Height = 606
          Align = alClient
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnDragDrop = vlDragDrop
          OnDragOver = vlDragOver
          ColWidths = (
            209
            248)
        end
        object Panel3: TPanel
          Left = 2
          Top = 15
          Width = 463
          Height = 74
          Align = alTop
          TabOrder = 1
          object SpeedButton1: TSpeedButton
            Left = 184
            Top = 40
            Width = 23
            Height = 22
            Caption = '<'
            OnClick = SpeedButton1Click
          end
          object SpeedButton2: TSpeedButton
            Left = 312
            Top = 40
            Width = 23
            Height = 22
            Caption = '>'
            OnClick = SpeedButton2Click
          end
          object SpeedButton3: TSpeedButton
            Left = 232
            Top = 59
            Width = 57
            Height = 14
            Caption = 'GO'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGreen
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            OnClick = SpeedButton3Click
          end
          object lblsize: TLabel
            Left = 16
            Top = 48
            Width = 6
            Height = 13
            Caption = '0'
          end
          object cmbfile: TComboBox
            Left = 8
            Top = 16
            Width = 329
            Height = 21
            ItemHeight = 13
            TabOrder = 0
          end
          object BitBtn1: TBitBtn
            Left = 350
            Top = 13
            Width = 75
            Height = 21
            Caption = 'Analiza'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            OnClick = BitBtn1Click
          end
          object txtgo: TEdit
            Left = 232
            Top = 40
            Width = 57
            Height = 21
            TabOrder = 2
            OnKeyPress = txtgoKeyPress
          end
          object pb: TProgressBar
            Left = 1
            Top = 1
            Width = 461
            Height = 9
            Align = alTop
            TabOrder = 3
          end
        end
      end
      object GroupBox1: TGroupBox
        Left = 305
        Top = 0
        Width = 456
        Height = 697
        Align = alLeft
        Caption = 'Resultados'
        TabOrder = 2
        object memo: TRichEdit
          Left = 2
          Top = 15
          Width = 452
          Height = 680
          Align = alClient
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          ScrollBars = ssBoth
          TabOrder = 0
          WordWrap = False
          OnMouseDown = memoMouseDown
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 735
    Width = 1254
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
      Left = 1179
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
    Left = 535
    Top = 296
  end
  object ftpibm: TIdFTP
    MaxLineAction = maException
    ReadTimeout = 0
    OnWork = ftpibmWork
    TransferType = ftASCII
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    Left = 448
    Top = 64
  end
end
