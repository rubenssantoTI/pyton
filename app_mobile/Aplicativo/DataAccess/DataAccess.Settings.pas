unit DataAccess.Settings;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TSettingsDataAccess = class(TDataModule)
    fdData: TFDQuery;
    dsData: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    function GetImageServerAddr: string;
    procedure SetImageServerAddr(const AAddr: string);

    function GetDetranServerAddr: string;
    procedure SetDetranServerAddr(const AAddr: string);
  end;

var
  SettingsDataAccess: TSettingsDataAccess;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  DataAccess.Connection;

procedure TSettingsDataAccess.DataModuleCreate(Sender: TObject);
begin
  fdData.Open;
end;

function TSettingsDataAccess.GetDetranServerAddr: string;
begin
  Result := fdData.FieldByName('DETRAN_SERVER_ADDR').AsString;
end;

function TSettingsDataAccess.GetImageServerAddr: string;
begin
  Result := fdData.FieldByName('IMAGE_SERVER_ADDR').AsString;
end;

procedure TSettingsDataAccess.SetDetranServerAddr(const AAddr: string);
begin
  fdData.Edit;
  fdData.FieldByName('DETRAN_SERVER_ADDR').AsString := AAddr;
  fdData.Post;
end;

procedure TSettingsDataAccess.SetImageServerAddr(const AAddr: string);
begin
  fdData.Edit;
  fdData.FieldByName('IMAGE_SERVER_ADDR').AsString := AAddr;
  fdData.Post;
end;

end.
