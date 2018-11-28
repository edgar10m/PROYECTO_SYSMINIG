inherited fmRefCruz: TfmRefCruz
  Left = 254
  Top = 87
  Width = 630
  Caption = 'fmRefCruz'
  FormStyle = fsNormal
  OldCreateOrder = True
  Visible = False
  PixelsPerInch = 96
  TextHeight = 13
  object mm: TMemo [0]
    Left = -8
    Top = 576
    Width = 653
    Height = 154
    Align = alCustom
    Color = 14988991
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 6
    Visible = False
  end
  inherited stbLista: TdxStatusBar
    Width = 608
  end
  inherited tabLista: TGroupBox
    Width = 608
    inherited grdDatos: TcxGrid
      Width = 604
      Font.Charset = ANSI_CHARSET
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = grdDatosClick
      inherited grdDatosDBTableView1: TcxGridDBTableView
        OnDblClick = grdDatosDBTableView1DblClick
        DataController.Filter.Criteria = {FFFFFFFF0000000000}
        OnFocusedRecordChanged = grdDatosDBTableView1FocusedRecordChanged
        OptionsView.GroupByBox = False
        OptionsView.HeaderHeight = 300
        Styles.Header = cxStyle3
        OnCustomDrawColumnHeader = grdDatosDBTableView1CustomDrawColumnHeader
      end
      object grdDatosBandedTableView1: TcxGridBandedTableView [1]
        DataController.Filter.Criteria = {FFFFFFFF0000000000}
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        NavigatorButtons.ConfirmDelete = False
        Bands = <
          item
          end
          item
          end>
      end
    end
    inherited grdEspejo: TcxGrid
      inherited grdEspejoDBTableView1: TcxGridDBTableView
        DataController.Filter.Criteria = {FFFFFFFF0000000000}
      end
    end
  end
  inherited mnuPrincipal: TdxBarManager
    Bars = <
      item
        AllowClose = False
        AllowCustomizing = False
        AllowQuickCustomizing = False
        AllowReset = False
        Caption = 'Men'#250' Principal'
        DockedDockingStyle = dsTop
        DockedLeft = 0
        DockedTop = 0
        DockingStyle = dsTop
        FloatLeft = 751
        FloatTop = 304
        FloatClientWidth = 91
        FloatClientHeight = 174
        ItemLinks = <
          item
            Item = mnuLista
            Visible = True
          end
          item
            Item = mnuEdicion
            Visible = True
          end
          item
            Item = mnuVer
            Visible = True
          end
          item
            Item = mnuExportar
            Visible = True
          end
          item
            Item = mnuTabular
            Visible = True
          end
          item
            BeginGroup = True
            Item = mnuBuscar
            Visible = True
          end>
        Name = 'Men'#250' Principal'
        OneOnRow = True
        Row = 0
        UseOwnFont = False
        UseRestSpace = True
        Visible = True
        WholeRow = False
      end
      item
        AllowClose = False
        AllowQuickCustomizing = False
        Caption = 'Busqueda'
        DockedDockingStyle = dsTop
        DockedLeft = 0
        DockedTop = 26
        DockingStyle = dsTop
        FloatLeft = 787
        FloatTop = 297
        FloatClientWidth = 23
        FloatClientHeight = 22
        ItemLinks = <
          item
            Item = mnuTextoBuscar
            Visible = True
          end
          item
            Item = mnuBuscarAnterior
            Visible = True
          end
          item
            Item = mnuBuscarSiguiente
            Visible = True
          end>
        Name = 'Busqueda'
        OneOnRow = False
        Row = 1
        UseOwnFont = False
        UseRestSpace = True
        Visible = True
        WholeRow = False
      end
      item
        AllowClose = False
        AllowQuickCustomizing = False
        Caption = 'Navegador'
        DockedDockingStyle = dsTop
        DockedLeft = 311
        DockedTop = 26
        DockingStyle = dsTop
        FloatLeft = 404
        FloatTop = 229
        FloatClientWidth = 23
        FloatClientHeight = 22
        ItemLinks = <
          item
            Item = dxBarDBNavFirst1
            Visible = True
          end
          item
            Item = dxBarDBNavPrev1
            Visible = True
          end
          item
            Item = dxBarDBNavNext1
            Visible = True
          end
          item
            Item = dxBarDBNavLast1
            Visible = True
          end>
        Name = 'Navegador'
        OneOnRow = False
        Row = 1
        UseOwnFont = False
        UseRestSpace = True
        Visible = True
        WholeRow = False
      end>
    Categories.ItemsVisibles = (
      2
      2
      2
      2
      2
      2
      2
      2)
    Categories.Visibles = (
      True
      True
      True
      True
      True
      True
      True
      True)
    DockControlHeights = (
      0
      0
      52
      0)
    inherited mnuTVista: TdxBarSubItem
      ItemLinks = <
        item
          Item = mnuLineas
          Visible = True
        end
        item
          Item = dxBarButton3
          Visible = True
        end
        item
          Item = mnuHeaderHeight
          Visible = True
        end>
    end
    inherited MenuTAccion: TdxBarSubItem
      ItemLinks = <
        item
          Item = mnuExpand
          Visible = True
        end
        item
          Item = mnuColapse
          Visible = True
        end>
    end
    object dxBarButton4: TdxBarButton
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object mnuHeaderHeight: TdxBarSpinEdit
      Caption = 'Ancho Cabecera'
      Category = 0
      Hint = 'Ancho Cabecera'
      Visible = ivAlways
      OnChange = mnuHeaderHeightChange
      Width = 100
      Value = 200.000000000000000000
    end
  end
  inherited tabDatos: TdxMemData
    Indexes = <
      item
        FieldName = 'RecId'
        SortOptions = [soCaseInsensitive]
      end>
    SortedField = 'recid'
  end
  inherited dxComponentPrinter: TdxComponentPrinter
    Left = 496
    Top = 162
    inherited dxComponentPrinterLink1: TdxGridReportLink
      PrinterPage._dxMeasurementUnits_ = 0
      PrinterPage._dxLastMU_ = 2
      ReportDocument.CreationDate = 41659.709094756950000000
      BuiltInReportLink = True
    end
  end
  inherited cxStyleRepository2: TcxStyleRepository
    inherited cxStyle1: TcxStyle
      Font.Charset = ANSI_CHARSET
      Font.Height = -11
      Font.Name = 'Arial Narrow'
    end
    inherited cxStyle2: TcxStyle
      Font.Charset = ANSI_CHARSET
      Font.Height = -11
      Font.Name = 'Arial Narrow'
    end
    inherited cxStyle3: TcxStyle
      Font.Charset = ANSI_CHARSET
      Font.Height = -11
      Font.Name = 'Arial Narrow'
    end
    inherited cxStyle4: TcxStyle
      Font.Charset = ANSI_CHARSET
      Font.Height = -11
      Font.Name = 'Arial Narrow'
    end
    inherited cxStyle5: TcxStyle
      Font.Charset = ANSI_CHARSET
      Font.Height = -11
      Font.Name = 'Arial Narrow'
    end
    inherited cxStyle6: TcxStyle
      Font.Charset = ANSI_CHARSET
      Font.Height = -11
      Font.Name = 'Arial Narrow'
      Font.Style = []
    end
    inherited cxStyle7: TcxStyle
      Font.Charset = ANSI_CHARSET
      Font.Height = -11
      Font.Name = 'Arial Narrow'
      Font.Style = []
    end
    inherited cxStyle8: TcxStyle
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial Narrow'
    end
    inherited cxStyle9: TcxStyle
      Font.Charset = ANSI_CHARSET
      Font.Height = -11
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold, fsUnderline]
    end
    inherited cxStyle10: TcxStyle
      Font.Charset = ANSI_CHARSET
      Font.Height = -11
      Font.Name = 'Arial Narrow'
    end
    inherited cxStyle11: TcxStyle
      Font.Charset = ANSI_CHARSET
      Font.Height = -11
      Font.Name = 'Arial Narrow'
    end
    object cxStyle12: TcxStyle [11]
      AssignedValues = [svFont, svTextColor]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      TextColor = clRed
    end
    inherited GridTableViewStyleSheetWindowsStandard: TcxGridTableViewStyleSheet
      BuiltIn = True
    end
  end
  object ImageList2: TImageList
    Left = 65371
    Top = 24
  end
end
