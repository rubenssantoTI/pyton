(*------------------------------------------------------------------
Propósito da Unit: executa scripts de criação/manutenção da base de dados local
Programador: Data: Lucas M. Belo 16/09/2019
Analista Responsável: Lucas M. Belo
Revisões:
Programador:
Data: Descrição da Revisão
Comentários adicionais: a criação de novas tabelas ou a manutenção de tabelas
existentes devem ser realizadas através dos recursos disponíveis aqui.
------------------------------------------------------------------*)
unit DataAccess.Script;

interface

type
  TScriptExecutor = class
  protected
    procedure Execute( const AScript: string );
  end;

  TScript = class abstract(TObject)
  private
    FScriptExecutor: TScriptExecutor;
  protected
    procedure RegisterScript( const AScript: string ); virtual;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;

  TSimpleScript = class sealed(TScript)
  public
    procedure RegisterScript( const AScript: string ); override;
  end;

  TValidationScript = class sealed(TScript)
  private
    function IsRegistered( const AID: integer ): Boolean;
  protected
     procedure RegisterScript( const AScript: string ); overload; override;
  public
    procedure RegisterScript( const AID: integer; const AScript: string ); reintroduce; overload;
  end;

const
  DBVERSAO = '1.0.0.001';

implementation

uses
  DataAccess.Connection, System.SysUtils;

{ TScriptExecutor }

procedure TScriptExecutor.Execute(const AScript: string);
begin
  with ConnectionDataAccess.CustomCommand() do
  begin
    Execute(AScript);
  end;
end;

{ TConversor }

procedure TScript.AfterConstruction;
begin
  inherited;
  FScriptExecutor := TScriptExecutor.Create;
end;

procedure TScript.BeforeDestruction;
begin
  inherited;
  FScriptExecutor.DisposeOf();
end;

procedure TScript.RegisterScript(const AScript: string);
begin
  FScriptExecutor.Execute( AScript );
end;

{ TConversorSimples }

procedure TSimpleScript.RegisterScript(const AScript: string);
begin
  inherited RegisterScript(AScript);
end;

{ TConversorValidacao }

function TValidationScript.IsRegistered(const AID: integer): Boolean;
begin
  with ConnectionDataAccess.CustomQuery() do begin
    SQL.Text := 'select idscript, versao from conversor where idscript = :idscript';
    ParamByName('idscript').AsInteger := AID;
    Open();
    Result := RecordCount > 0; //Verifica se o script está na lista de executados
    Close();
  end;
end;

procedure TValidationScript.RegisterScript(const AScript: string);
begin
  inherited RegisterScript(AScript);
end;

procedure TValidationScript.RegisterScript(const AID: integer;
  const AScript: string);
begin
  //Verifica se o script já não foi executado anteriormente
  if not IsRegistered(AID) then
  begin
    ConnectionDataAccess.DefaultConnection().StartTransaction();
    try
      RegisterScript(AScript); //Executa o script
      with ConnectionDataAccess.CustomCommand() do
      begin
        //Incluir o script na lista de executados, prevenindo-o de ser executado novamente
        Execute( 'insert into conversor(idscript, versao) values(' + AID.ToString() + ', ' + QuotedStr(DBVERSAO) + ');' );
      end;
      ConnectionDataAccess.DefaultConnection().Commit();
    except
      ConnectionDataAccess.DefaultConnection().Rollback();
    end;
  end;
end;

end.
