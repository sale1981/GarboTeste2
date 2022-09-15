object BotDao: TBotDao
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 244
  Width = 361
  object CN: TFDConnection
    Params.Strings = (
      'Database=C:\SISTEMA\DADOS\SAC_DB.FDB'
      'User_Name=sysdba'
      'Password=CPDgarbo'
      'Port=3050'
      'DriverID=IB')
    LoginPrompt = False
    Left = 32
    Top = 16
  end
  object qry_pesquisa: TFDQuery
    Connection = CN
    Left = 32
    Top = 80
  end
  object qry_registrarVotoRuim: TFDQuery
    Connection = CN
    Left = 40
    Top = 144
  end
  object qry_registrarVotoBOM: TFDQuery
    Connection = CN
    Left = 152
    Top = 136
  end
  object qry_registrarVotoOtimo: TFDQuery
    Connection = CN
    Left = 272
    Top = 136
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 120
    Top = 16
  end
  object FDPhysIBDriverLink1: TFDPhysIBDriverLink
    VendorLib = 'C:\Alessandro\whatsapp Pesquisa\BIN\fbclient.dll'
    Left = 248
    Top = 56
  end
end
