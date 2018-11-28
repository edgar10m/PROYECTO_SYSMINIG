inherited alkFormBrowse: TalkFormBrowse
  Left = 536
  Top = 101
  Width = 830
  Height = 627
  Caption = 'alkFormBrowse'
  FormStyle = fsNormal
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  inherited stbLista: TdxStatusBar
    Top = 562
    Width = 808
  end
  inherited tabLista: TGroupBox
    Width = 808
    Height = 510
    inherited grdDatos: TcxGrid
      Width = 804
      Height = 493
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
  end
  inherited dxComponentPrinter: TdxComponentPrinter
    inherited dxComponentPrinterLink1: TdxGridReportLink
      PrinterPage._dxMeasurementUnits_ = 0
      PrinterPage._dxLastMU_ = 2
      BuiltInReportLink = True
    end
  end
  inherited cxStyleRepository2: TcxStyleRepository
    inherited GridTableViewStyleSheetWindowsStandard: TcxGridTableViewStyleSheet
      BuiltIn = True
    end
  end
end
