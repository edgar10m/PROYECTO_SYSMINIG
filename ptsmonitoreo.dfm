object ftsmonitoreo: Tftsmonitoreo
  Left = 556
  Top = 142
  Width = 486
  Height = 480
  Caption = 'Sys-Mining 6.0.1    Monitoreo de Usuarios'
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
  object lv: TListView
    Left = 16
    Top = 24
    Width = 441
    Height = 401
    Columns = <
      item
        Caption = 'Usuario'
      end
      item
        Caption = 'Fecha/Hora Entrada'
      end
      item
        Caption = 'Fecha/Hora Salida'
      end
      item
        Caption = 'Fecha/Hora Control'
      end>
    TabOrder = 0
  end
  object DataSource1: TDataSource
    Left = 104
    Top = 40
  end
  object query: TADOQuery
    Connection = dm.ADOConnection1
    Parameters = <>
    Left = 160
    Top = 40
  end
end
