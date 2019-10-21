object SettingsDataAccess: TSettingsDataAccess
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 201
  Width = 204
  object fdData: TFDQuery
    Connection = ConnectionDataAccess.fdcDefault
    SQL.Strings = (
      'select * from settings')
    Left = 56
    Top = 80
  end
  object dsData: TDataSource
    DataSet = fdData
    Left = 112
    Top = 80
  end
end
