unit DataAccess.Connection;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Phys.SQLite, FireDAC.Comp.UI;

type
  TConnectionDataAccess = class(TDataModule)
    fdcDefault: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    fdcCustomCommand: TFDCommand;
    fdqCustomQuery: TFDQuery;
    procedure fdcDefaultBeforeConnect(Sender: TObject);
  public
    function DefaultConnection(): TFDConnection;
    function CustomCommand(): TFDCommand;
    function CustomQuery(): TFDQuery;
  end;

var
  ConnectionDataAccess: TConnectionDataAccess;

const
  DATABASENAME = 'sinicv.sdb';

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  System.IOUtils;

procedure TConnectionDataAccess.fdcDefaultBeforeConnect(Sender: TObject);
var
  LConnection: TFDConnection;
begin
  LConnection := Sender as TFDConnection;
  LConnection.Params.Clear();
  LConnection.Params.Values['DriverID'] := 'SQLite';
  {$IF DEFINED(ANDROID) OR DEFINED(iOS)}
  LConnection.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, DATABASENAME);
  {$ELSE}
  LConnection.Params.Values['Database'] := TPath.Combine(ExtractFilePath(ParamStr(0)), DATABASENAME);
  {$ENDIF}
end;

function TConnectionDataAccess.DefaultConnection(): TFDConnection;
begin
  Result := fdcDefault
end;

function TConnectionDataAccess.CustomCommand: TFDCommand;
begin
  Result := fdcCustomCommand;
end;

function TConnectionDataAccess.CustomQuery: TFDQuery;
begin
  Result := fdqCustomQuery;
end;

end.
