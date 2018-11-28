inherited fmUMLPaquetes: TfmUMLPaquetes
  Left = 356
  Top = 123
  Width = 588
  Height = 507
  Caption = 'fmUMLPaquetes'
  OldCreateOrder = True
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  inherited TabSheet2: TGroupBox
    Width = 566
    Height = 359
    inherited cxGrid1: TcxGrid
      Width = 562
      Height = 342
      inherited cxGrid1DBTableView1: TcxGridDBTableView
        DataController.Filter.Criteria = {FFFFFFFF0000000000}
      end
    end
    inherited atDiagrama: TatDiagram
      Width = 562
      Height = 342
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
            Item = mnuArchivo
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
        Caption = 'Objetos'
        DockedDockingStyle = dsTop
        DockedLeft = 0
        DockedTop = 26
        DockingStyle = dsTop
        FloatLeft = 404
        FloatTop = 229
        FloatClientWidth = 23
        FloatClientHeight = 22
        ItemLinks = <
          item
            Item = mnuObjetoColor
            Visible = True
          end
          item
            Item = mnuGradiente
            Visible = True
          end
          item
            Item = mnuCepillarEstilo
            Visible = True
          end
          item
            Item = mnuSombra
            Visible = True
          end
          item
            Item = mnuLineaEstilo
            Visible = True
          end
          item
            Item = mnuLineaColor
            Visible = True
          end
          item
            Item = mnuTransparencia
            Visible = True
          end
          item
            Item = mnuLineaAncho
            Visible = True
          end
          item
            Item = mnuTextoColor
            Visible = True
          end
          item
            BeginGroup = True
            Item = mnuFontTipo
            Visible = True
          end
          item
            BeginGroup = True
            Item = mnuFontTamanio
            Visible = True
          end
          item
            BeginGroup = True
            Item = mnuBold
            Visible = True
          end
          item
            Item = mnuItalic
            Visible = True
          end
          item
            Item = mnuUnderline
            Visible = True
          end
          item
            Item = mnuStrikeOut
            Visible = True
          end>
        Name = 'Objetos'
        OneOnRow = True
        Row = 1
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
        DockedTop = 78
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
        OneOnRow = True
        Row = 3
        UseOwnFont = False
        UseRestSpace = True
        Visible = True
        WholeRow = False
      end
      item
        AllowClose = False
        AllowQuickCustomizing = False
        Caption = 'Alineacion'
        DockedDockingStyle = dsTop
        DockedLeft = 0
        DockedTop = 52
        DockingStyle = dsTop
        FloatLeft = 909
        FloatTop = 358
        FloatClientWidth = 23
        FloatClientHeight = 22
        ItemLinks = <
          item
            Item = mnuAlinearBordesIzquierdo
            Visible = True
          end
          item
            Item = mnuAlinearBordesDerechos
            Visible = True
          end
          item
            Item = mnuAlinearCentrosHorizontales
            Visible = True
          end
          item
            BeginGroup = True
            Item = mnuAlinearBordesSuperiores
            Visible = True
          end
          item
            Item = mnuAlinearBordesInferiores
            Visible = True
          end
          item
            Item = mnuAlinearCentrosVerticales
            Visible = True
          end
          item
            BeginGroup = True
            Item = mnuHacerMismoAncho
            Visible = True
          end
          item
            Item = mnuHacerMismaAltura
            Visible = True
          end
          item
            Item = mnuHacerMismoTamano
            Visible = True
          end
          item
            BeginGroup = True
            Item = mnuEspacioIgualHorizontal
            Visible = True
          end
          item
            Item = mnuIncrementarEspacioHorizontal
            Visible = True
          end
          item
            Item = mnuDisminuirEspacioHorizontal
            Visible = True
          end
          item
            BeginGroup = True
            Item = mnuEspacioIgualVertical
            Visible = True
          end
          item
            Item = mnuIncrementarEspacioVertical
            Visible = True
          end
          item
            Item = mnuDisminuirEspacioVertical
            Visible = True
          end>
        Name = 'Alineacion'
        OneOnRow = True
        Row = 2
        UseOwnFont = False
        UseRestSpace = True
        Visible = True
        WholeRow = False
      end>
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    DockControlHeights = (
      0
      0
      104
      0)
  end
end
