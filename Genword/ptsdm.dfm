object dm: Tdm
  OldCreateOrder = False
  Left = 2
  Top = 130
  Height = 150
  Width = 384
  object ADOConnection1: TADOConnection
    ConnectionString = 
      'Provider=OraOLEDB.Oracle.1;Password=sysview12;Persist Security I' +
      'nfo=True;User ID=CALIDADT22;Data Source=sysviewsoftscm'
    Provider = 'OraOLEDB.Oracle.1'
    Left = 24
    Top = 16
  end
  object q1: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 128
    Top = 32
  end
  object q4: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 240
    Top = 40
  end
end
