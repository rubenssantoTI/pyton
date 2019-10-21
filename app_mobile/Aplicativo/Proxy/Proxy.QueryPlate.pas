unit Proxy.QueryPlate;

interface

uses
  System.SysUtils, System.Classes, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, FMX.Graphics, DataAccess.Settings,
  Model.QueryPlate, FMX.Objects, FMX.Dialogs;

type
  TQueryPlateProxy = class(TDataModule)
    NetHTTPClient1: TNetHTTPClient;
    procedure DataModuleCreate(Sender: TObject);
    procedure NetHTTPClient1RequestCompleted(const Sender: TObject;
      const AResponse: IHTTPResponse);
  private
    FSettingsDataAccess: TSettingsDataAccess;
    FCallback: TProc<TQueryPlateModel>;
  public
    procedure SendRequest(const AImage: TBitmap; ACallback: TProc<TQueryPlateModel>);
  end;

var
  QueryPlateProxy: TQueryPlateProxy;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  System.Net.Mime,
  System.IOUtils,
  FMX.Platform,
  FMX.MediaLibrary,
  System.Threading;

const
  HTTP_RESOURCE = '/uploader';

procedure TQueryPlateProxy.DataModuleCreate(Sender: TObject);
begin
  FSettingsDataAccess := TSettingsDataAccess.Create(Self);
end;

procedure TQueryPlateProxy.NetHTTPClient1RequestCompleted(
  const Sender: TObject; const AResponse: IHTTPResponse);
const
  PLACAS = 'placas';
var
  LModel: TQueryPlateModel;
  LDir: string;
begin
  {$IF DEFINED(ANDROID) OR DEFINED(iOS)}
  LDir := TPath.Combine(TPath.GetDocumentsPath, PLACAS);
  {$ELSE}
  LDir := TPath.Combine(ExtractFilePath(ParamStr(0)), PLACAS);
  {$ENDIF}

  if not TDirectory.Exists(LDir) then TDirectory.CreateDirectory(LDir);

  LModel := nil;
  try
    if Assigned(AResponse) and (AResponse.StatusCode = 200) then begin
      if Assigned(AResponse.ContentStream) and (AResponse.ContentStream.Size > 0) and (AResponse.MimeType = 'image/jpeg') then begin
        var LBitmap := TBitmap.Create();
        try
          LBitmap.LoadFromStream(AResponse.ContentStream);
          LModel := TQueryPlateModel.Create('OPQ-1327', TSituacaoVeiculo.svNormal, LBitmap);
        finally
          LBitmap.DisposeOf;
        end;
      end else if (AResponse.MimeType = 'text/html; charset=utf-8') then begin
        LModel := TQueryPlateModel.Create(AResponse.ContentAsString(), TSituacaoVeiculo.svNormal, nil);
      end;
    end;
  finally
    FCallback(LModel);
  end;
end;

procedure TQueryPlateProxy.SendRequest(const AImage: TBitmap; ACallback: TProc<TQueryPlateModel>);
begin
  FCallback := ACallback;

  var LHost := FSettingsDataAccess.GetImageServerAddr() + HTTP_RESOURCE;

  var LStream := TMemoryStream.Create();
  AImage.SaveToStream(LStream);

  var LFormData := TMultipartFormData.Create(true);
  LFormData.AddStream('file', LStream, FormatDateTime('ddmmyyyyhhssmmzzz', Now()) + '.jpg');

  NetHTTPClient1.Asynchronous := false;
  NetHTTPClient1.Post(LHost, LFormData);
end;

end.
