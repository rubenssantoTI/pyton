object QueryPlateProxy: TQueryPlateProxy
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 150
  Width = 215
  object NetHTTPClient1: TNetHTTPClient
    Asynchronous = False
    ConnectionTimeout = 60000
    ResponseTimeout = 60000
    HandleRedirects = True
    AllowCookies = True
    UserAgent = 'Embarcadero URI Client/1.0'
    OnRequestCompleted = NetHTTPClient1RequestCompleted
    Left = 88
    Top = 56
  end
end
