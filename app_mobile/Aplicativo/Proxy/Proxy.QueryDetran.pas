unit Proxy.QueryDetran;

interface

uses
  System.SysUtils, System.Classes, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, DataAccess.Settings, Model.QueryDetran,
  FMX.Objects, FMX.Dialogs;

type
  TQueryDetranProxy = class(TDataModule)
    NetHTTPClient1: TNetHTTPClient;
    procedure NetHTTPClient1RequestCompleted(const Sender: TObject;
      const AResponse: IHTTPResponse);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  private
    FSettingsDataAccess: TSettingsDataAccess;
    FCallback: TProc<TQueryDetranModel>;
  public
    procedure SendRequest(const APlaca: string; ACallback: TProc<TQueryDetranModel>);
  end;

var
  QueryDetranProxy: TQueryDetranProxy;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  System.IOUtils, System.JSON;

{ TQueryDetranProxy }

procedure TQueryDetranProxy.DataModuleCreate(Sender: TObject);
begin
  FSettingsDataAccess := TSettingsDataAccess.Create(Self);
end;

procedure TQueryDetranProxy.NetHTTPClient1RequestCompleted(
  const Sender: TObject; const AResponse: IHTTPResponse);
var
  LModel: TQueryDetranModel;
begin
  LModel := nil;
  try
    if Assigned(AResponse) and (AResponse.StatusCode = 200) then begin
      if (AResponse.MimeType = 'application/json; charset=utf-8') then begin
        if (AResponse.ContentAsString() <> EmptyStr) then begin
          var LJSONValue := TJSONObject.ParseJSONValue(AResponse.ContentAsString());
          try
            LModel := TQueryDetranModel.Create();
            LModel.Situacao := LJSONValue.P['situacao'].AsType<TJSONString>().Value;
            LModel.Modelo := LJSONValue.P['modelo'].AsType<TJSONString>().Value;
            LModel.Marca := LJSONValue.P['marca'].AsType<TJSONString>().Value;
            LModel.Cor := LJSONValue.P['cor'].AsType<TJSONString>().Value;
            LModel.Ano := LJSONValue.P['ano'].AsType<TJSONString>().Value;
            LModel.AnoModelo := LJSONValue.P['anoModelo'].AsType<TJSONString>().Value;
            LModel.UF := LJSONValue.P['uf'].AsType<TJSONString>().Value;
            LModel.Municipio := LJSONValue.P['municipio'].AsType<TJSONString>().Value;
            LModel.Chassi := LJSONValue.P['chassi'].AsType<TJSONString>().Value;
          finally
            LJSONValue.DisposeOf;
          end;
        end;
      end;
    end;
  finally
    FCallback(LModel);
  end;
end;

procedure TQueryDetranProxy.SendRequest(const APlaca: string; ACallback: TProc<TQueryDetranModel>);
begin
  FCallback := ACallback;
  var LHost := FSettingsDataAccess.GetDetranServerAddr();
  NetHTTPClient1.Asynchronous := true;
  NetHTTPClient1.Get(TPath.Combine(LHost, APlaca));
end;

end.
