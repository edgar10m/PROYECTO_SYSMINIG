inherited fmDocHistorial: TfmDocHistorial
  Left = 509
  Top = 114
  Width = 627
  Height = 597
  Caption = 'fmDocHistorial'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited stbLista: TdxStatusBar
    Top = 533
    Width = 605
  end
  inherited tabLista: TGroupBox
    Top = 78
    Width = 605
    Height = 455
    inherited grdDatos: TcxGrid
      Width = 601
      Height = 438
      inherited grdDatosDBTableView1: TcxGridDBTableView
        DataController.Filter.Criteria = {FFFFFFFF0000000000}
        Filtering.CustomizeDialog = False
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
            Item = mnuDatos
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
            BeginGroup = True
            Item = mnuDocumento
            Visible = True
          end
          item
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
        DockedLeft = 302
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
      end
      item
        AllowClose = False
        AllowQuickCustomizing = False
        Caption = 'Documento'
        DockedDockingStyle = dsTop
        DockedLeft = 0
        DockedTop = 52
        DockingStyle = dsTop
        FloatLeft = 1723
        FloatTop = 339
        FloatClientWidth = 23
        FloatClientHeight = 22
        ItemLinks = <
          item
            Item = mnuDescargar
            Visible = True
          end>
        Name = 'Documento'
        OneOnRow = True
        Row = 2
        UseOwnFont = False
        UseRestSpace = True
        Visible = True
        WholeRow = False
      end>
    Categories.Strings = (
      'Lista'
      'Edicion'
      'Ver'
      'Exportar'
      'Buscar'
      'Barra DB Navigator'
      'Barra Buscar'
      'Datos'
      'Documento'
      'Barra Documento')
    Categories.ItemsVisibles = (
      2
      2
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
      True
      True
      True)
    DockControlHeights = (
      0
      0
      78
      0)
    object mnuDocumento: TdxBarSubItem
      Caption = 'Documento'
      Category = 8
      Visible = ivAlways
      ItemLinks = <
        item
          Item = mnuDescargar
          Visible = True
        end>
    end
    object mnuDescargar: TdxBarButton
      Caption = 'Descargar'
      Category = 9
      Hint = 'Descargar'
      Visible = ivAlways
      ImageIndex = 14
      OnClick = mnuDescargarClick
    end
  end
  inherited dxComponentPrinter: TdxComponentPrinter
    inherited dxComponentPrinterLink1: TdxGridReportLink
      PrinterPage._dxMeasurementUnits_ = 0
      PrinterPage._dxLastMU_ = 2
      ReportDocument.CreationDate = 41646.714336655100000000
      BuiltInReportLink = True
    end
  end
end
