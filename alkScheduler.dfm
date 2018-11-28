object alkFormScheduler: TalkFormScheduler
  Left = 357
  Top = 147
  Width = 542
  Height = 558
  Caption = 'Detalles Scheduler'
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
  object Label1: TLabel
    Left = 34
    Top = 48
    Width = 90
    Height = 20
    Caption = 'Periodicidad:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 34
    Top = 240
    Width = 77
    Height = 20
    Caption = 'Contenido:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object Label3: TLabel
    Left = 10
    Top = 472
    Width = 295
    Height = 20
    Caption = 'El diagrama lo puede encontrar en la ruta:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 10
    Top = 496
    Width = 203
    Height = 18
    Caption = '...Mis Documentos\Scheduler'
    Font.Charset = BALTIC_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 34
    Top = 208
    Width = 107
    Height = 20
    Caption = 'D'#237'a de la malla:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object Label6: TLabel
    Left = 34
    Top = 400
    Width = 116
    Height = 20
    Caption = 'Nivel de la malla:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object Label7: TLabel
    Left = 10
    Top = 16
    Width = 86
    Height = 20
    Caption = 'Seleccione :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object rgTipo: TRadioGroup
    Left = 152
    Top = 240
    Width = 345
    Height = 145
    Items.Strings = (
      'Dependencia de componentes                                 '
      'Dependencia de componentes + Condiciones manuales          ')
    TabOrder = 0
    Visible = False
    OnClick = rgTipoClick
  end
  object Button1: TButton
    Left = 384
    Top = 456
    Width = 75
    Height = 25
    Caption = 'Generar'
    Enabled = False
    TabOrder = 1
    Visible = False
    OnClick = Button1Click
  end
  object rgPer: TRadioGroup
    Left = 152
    Top = 48
    Width = 137
    Height = 145
    Items.Strings = (
      'Mensual'#9'         '
      'Semanal         '
      'Sin Periodicidad         '
      'Todas las anteriores')
    TabOrder = 2
    OnClick = rgPerClick
  end
  object ComboBox1: TComboBox
    Left = 152
    Top = 208
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 3
    Visible = False
    OnChange = ComboBox1Change
    Items.Strings = (
      'Lunes'
      'Martes'
      'Miercoles'
      'Jueves'
      'Viernes'
      'Sabado '
      'Domingo'
      'Todos')
  end
  object Edit1: TEdit
    Left = 160
    Top = 400
    Width = 201
    Height = 21
    TabOrder = 4
    Visible = False
    OnChange = Edit1Change
    OnKeyPress = Edit1KeyPress
  end
  object cbtodos: TCheckBox
    Left = 368
    Top = 400
    Width = 97
    Height = 17
    Caption = 'Todos'
    TabOrder = 5
    Visible = False
    OnClick = cbtodosClick
  end
  object rgtipolinea: TRadioGroup
    Left = 392
    Top = 56
    Width = 105
    Height = 89
    Caption = 'Tipo de L'#237'neas'
    ItemIndex = 0
    Items.Strings = (
      'Normales'
      'Ortogonales')
    TabOrder = 6
  end
end
