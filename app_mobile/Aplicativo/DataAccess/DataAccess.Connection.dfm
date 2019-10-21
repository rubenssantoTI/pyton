object ConnectionDataAccess: TConnectionDataAccess
  OldCreateOrder = False
  Height = 369
  Width = 254
  object fdcDefault: TFDConnection
    BeforeConnect = fdcDefaultBeforeConnect
    Left = 104
    Top = 32
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 104
    Top = 88
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 104
    Top = 160
  end
  object fdcCustomCommand: TFDCommand
    Connection = fdcDefault
    Left = 104
    Top = 214
  end
  object fdqCustomQuery: TFDQuery
    Connection = fdcDefault
    Left = 104
    Top = 270
  end
end
