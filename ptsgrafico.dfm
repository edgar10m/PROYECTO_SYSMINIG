object fgrafico: Tfgrafico
  Left = 404
  Top = 72
  Width = 852
  Height = 599
  Caption = 'fgrafico'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnMouseDown = FormMouseDown
  OnMouseUp = FormMouseUp
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 557
    Top = 158
    Width = 26
    Height = 26
    Picture.Data = {
      055449636F6E0000010001002020100000000000E80200001600000028000000
      2000000040000000010004000000000080020000000000000000000000000000
      0000000000000000000080000080000000808000800000008000800080800000
      80808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
      FFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000
      0000000FF000000000000000000000000000000FF00000000000000000000000
      0000000FF000000000000000000000000000000FF00000078FF8700000000000
      0000000FF000078FFFFFF870000000000000000FF0007FFFFFFFFFF700000000
      0000000FF0008FFFFFFFFFF8000000000000000FF007FFFFFFFFFFFF70000000
      0000000FF008FFFFFFFFFFFF800000000000000FF00FFFFFFFFFFFFFF0000000
      0000000FF00FFFFFFFFFFFFFF00000000000000FF008FFFFFFFFFFFF80000000
      0000000FF007FFFFFFFFFFFF700000000000000FF0008FFFFFFFFFF800000000
      0000000FF0007FFFFFFFFFF7000000000000000FF000078FFFFFF8778FF87000
      0000000FF00000078FF8707FFFFFF7000000000FF0000000000007FFFFFFFF70
      0000000FF0000000000008FFFFFFFF800000000FF000000000000FFFFFFFFFF0
      0788700FF000000000000FFFFFFFFFF07FFFF70FF0000000000008FFFFFFFF80
      8FFFF80FF0000000000007FFFFFFFF708FFFF80FF00000000000007FFFFFF700
      7FFFF70FF0000000000000078FF870000788700FF00000000000000000000000
      0000000FF000000000000000000000000000000FF00000000000000000000000
      0000000FF000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000}
  end
  object MainMenu1: TMainMenu
    Left = 368
    Top = 152
    object Archivo1: TMenuItem
      Caption = 'Archivo'
      object Guardar1: TMenuItem
        Caption = 'Guardar'
      end
      object Guardarcomo1: TMenuItem
        Caption = 'Guardar como'
      end
      object Convertira1: TMenuItem
        Caption = 'Exportar a SVG'
      end
      object ExportaraVML1: TMenuItem
        Caption = 'Exportar a VML'
      end
      object ExportaraJPG1: TMenuItem
        Caption = 'Exportar a JPG'
        OnClick = ExportaraJPG1Click
      end
      object Imprimir1: TMenuItem
        Caption = 'Imprimir'
        OnClick = Imprimir1Click
      end
      object Salir1: TMenuItem
        Caption = 'Salir'
        OnClick = Salir1Click
      end
    end
    object Organizar1: TMenuItem
      Caption = 'Organizar'
      object ModularMayoresEnlaces1: TMenuItem
        Caption = 'Modular Mayores Enlaces'
        Checked = True
        OnClick = ModularMayoresEnlaces1Click
      end
      object SistemasPrioridad1: TMenuItem
        Caption = 'Sistemas Prioridad'
        OnClick = SistemasPrioridad1Click
      end
    end
    object Configuracin1: TMenuItem
      Caption = 'Configuraci'#243'n'
      object PermitirMover1: TMenuItem
        Caption = 'Permitir Mover'
        Checked = True
        OnClick = PermitirMover1Click
      end
    end
    object Enlaces1: TMenuItem
      Caption = 'Enlaces'
      object Central1: TMenuItem
        Caption = 'Central'
        Checked = True
        OnClick = Central1Click
      end
      object LadoMedio1: TMenuItem
        Caption = 'Lado Medio'
        OnClick = LadoMedio1Click
      end
      object opdown1: TMenuItem
        Caption = 'Top-Down'
        OnClick = opdown1Click
      end
    end
    object Ver1: TMenuItem
      Caption = 'Ver'
      object GuasdeImpresin1: TMenuItem
        Caption = 'Gu'#237'as de Impresi'#243'n'
        Checked = True
        OnClick = GuasdeImpresin1Click
      end
    end
  end
end
