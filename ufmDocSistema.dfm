inherited fmDocSistema: TfmDocSistema
  Left = 542
  Top = 4
  Width = 632
  Height = 612
  Caption = 'fmDocSistema'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited stbLista: TdxStatusBar
    Top = 547
    Width = 610
    Panels = <
      item
        PanelStyleClassName = 'TdxStatusBarTextPanelStyle'
        PanelStyle.AutoHint = True
        MinWidth = 0
        Width = 150
      end
      item
        PanelStyleClassName = 'TdxStatusBarTextPanelStyle'
        MinWidth = 0
        Width = 200
      end>
  end
  inherited tabLista: TGroupBox
    Top = 78
    Width = 610
    Height = 469
    inherited grdDatos: TcxGrid
      Width = 606
      Height = 452
      inherited grdDatosDBTableView1: TcxGridDBTableView
        DataController.Filter.Criteria = {FFFFFFFF0000000000}
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
            Item = mnuDocumentacion
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
        Caption = 'Documentaci'#243'n'
        DockedDockingStyle = dsTop
        DockedLeft = 0
        DockedTop = 52
        DockingStyle = dsTop
        FloatLeft = 404
        FloatTop = 229
        FloatClientWidth = 23
        FloatClientHeight = 22
        ItemLinks = <
          item
            Item = mnuCargarConfiguracion
            Visible = True
          end
          item
            BeginGroup = True
            Item = mnuGenerarSalidas
            Visible = True
          end
          item
            BeginGroup = True
            Item = mnuGenerarInforme
            Visible = True
          end>
        Name = 'Documentaci'#243'n'
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
      'Documentaci'#243'n'
      'Barra Documentaci'#243'n')
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
    object mnuGenerarInforme: TdxBarButton
      Caption = 'Generar Informe'
      Category = 9
      Hint = 'Generar Informe'
      Visible = ivAlways
      ImageIndex = 14
      OnClick = mnuGenerarInformeClick
    end
    object mnuDocumentacion: TdxBarSubItem
      Caption = 'Documentaci'#243'n'
      Category = 8
      Visible = ivAlways
      ItemLinks = <
        item
          Item = mnuCargarConfiguracion
          Visible = True
        end
        item
          BeginGroup = True
          Item = mnuGenerarSalidas
          Visible = True
        end
        item
          BeginGroup = True
          Item = mnuGenerarInforme
          Visible = True
        end>
    end
    object mnuGenerarSalidas: TdxBarButton
      Caption = 'Generar Salidas'
      Category = 9
      Hint = 'Generar Salidas'
      Visible = ivAlways
      ImageIndex = 15
      OnClick = mnuGenerarSalidasClick
    end
    object mnuCargarConfiguracion: TdxBarButton
      Caption = 'Cargar Configuraci'#243'n'
      Category = 9
      Hint = 'Cargar Configuraci'#243'n'
      Visible = ivAlways
      ImageIndex = 13
      OnClick = mnuCargarConfiguracionClick
    end
  end
  inherited dxComponentPrinter: TdxComponentPrinter
    PreviewOptions.PreviewBoundsRect = {00000000000000000005000020030000}
    inherited dxComponentPrinterLink1: TdxGridReportLink
      PrinterPage._dxMeasurementUnits_ = 0
      PrinterPage._dxLastMU_ = 2
      ReportDocument.CreationDate = 41702.666299907410000000
      BuiltInReportLink = True
    end
  end
end
