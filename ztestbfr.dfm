object Form1: TForm1
  Left = 54
  Top = 146
  Width = 1088
  Height = 750
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 88
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object PageControl1: TPageControl
    Left = 368
    Top = 248
    Width = 289
    Height = 193
    ActivePage = TabSheet1
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
    end
  end
  object GroupBox1: TGroupBox
    Left = 264
    Top = 120
    Width = 185
    Height = 105
    Caption = 'GroupBox1'
    TabOrder = 2
  end
  object Button2: TButton
    Left = 216
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 3
    OnClick = Button2Click
  end
  object RadioButton1: TRadioButton
    Left = 528
    Top = 88
    Width = 113
    Height = 17
    Caption = 'RadioButton1'
    TabOrder = 4
  end
  object FileListBox1: TFileListBox
    Left = 712
    Top = 168
    Width = 145
    Height = 97
    ItemHeight = 13
    TabOrder = 5
  end
  object DirectoryListBox1: TDirectoryListBox
    Left = 768
    Top = 296
    Width = 145
    Height = 97
    ItemHeight = 16
    TabOrder = 6
  end
  object DriveComboBox1: TDriveComboBox
    Left = 672
    Top = 80
    Width = 145
    Height = 19
    TabOrder = 7
  end
end
