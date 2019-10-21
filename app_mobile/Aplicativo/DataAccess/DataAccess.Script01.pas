
(*------------------------------------------------------------------
Propósito da Unit: registra os scripts de manutenção da base de dados
Programador: Data: LMBTec - Lucas M. Belo 29/06/2015
Analista Responsável: LMBTec - Lucas M. Belo
Revisões:
Programador:
Data: Descrição da Revisão
Comentários adicionais: o registro dos scripts a serem executados devem ficar aqui.
------------------------------------------------------------------*)
unit DataAccess.Script01;

interface

uses
  System.Classes, DataAccess.Script, DataAccess.Interfaces;

type
  /// <summary>
  ///   Cria a base de dados se não existir
  /// </summary>
  TScriptBaseDados = class(TInterfacedObject, IScriptChain)
  public
    procedure Chain();
  end;
  /// <summary>
  ///   Cria a tabela de conversor
  /// </summary>
  TScriptPrincipal = class(TInterfacedObject, IScriptChain)
  private
    FScriptChain: IScriptChain;
  public
    constructor Create(AScriptChain: IScriptChain);
    destructor Destroy(); override;

    procedure Chain();
  end;
  /// <summary>
  ///   Inicia o processo de manutenção da base de dados
  /// </summary>
  TScriptPrimario = class(TInterfacedObject, IScriptChain)
  private
    FScriptChain: IScriptChain;
  public
    constructor Create(AScriptChain: IScriptChain);
    destructor Destroy(); override;

    procedure Chain();
  end;

implementation

uses
  IOUtils, DataAccess.Connection, System.SysUtils;

{ TConversorBaseDados }

procedure TScriptBaseDados.Chain;

  procedure CreateIfNotExists();
  var
    LFilePath: string;
  begin
    {$IF DEFINED(ANDROID) OR DEFINED(iOS)}
    LFilePath := TPath.Combine(TPath.GetDocumentsPath, DATABASENAME);
    {$ELSE}
    LFilePath := TPath.Combine(ExtractFilePath(ParamStr(0)), DATABASENAME);
    {$ENDIF}
    if not TFile.Exists(LFilePath) then
      TFile.Create(LFilePath).DisposeOf();
  end;

begin
  CreateIfNotExists();
end;

{ TConversorPrincipal }

constructor TScriptPrincipal.Create(AScriptChain: IScriptChain);
begin
  inherited Create();
  FScriptChain := AScriptChain;
end;

destructor TScriptPrincipal.Destroy;
begin
  FScriptChain := nil;
  inherited;
end;

procedure TScriptPrincipal.Chain;
begin
  //
  if Assigned(FScriptChain) then
    FScriptChain.Chain(); //Sempre executa o decorado primeiro
  //
  with TSimpleScript.Create() do
  begin
    try
      RegisterScript( 'CREATE TABLE IF NOT EXISTS conversor ( idscript INT PRIMARY KEY NOT NULL, versao CHAR(10) NOT NULL );' );
    finally
      Free();
    end;
  end;
end;

{ TConversorPrimario }

constructor TScriptPrimario.Create(AScriptChain: IScriptChain);
begin
  inherited Create();
  FScriptChain := AScriptChain;
end;

destructor TScriptPrimario.Destroy;
begin
  FScriptChain := nil;
  inherited;
end;

procedure TScriptPrimario.Chain;
begin
  //
  if Assigned(FScriptChain) then
    FScriptChain.Chain(); //Sempre executa o decorado primeiro
  //
  with TValidationScript.Create() do
  begin
    try
      //Configurações locais
      RegisterScript( 0001,
        'CREATE TABLE settings (              '+
        '    IMAGE_SERVER_ADDR varchar(255)   '+
        ')                                    '
      );

      RegisterScript( 0002,
        'ALTER TABLE settings ADD              '+
        '    DETRAN_SERVER_ADDR varchar(255)   '+
        '                                      '
      );
    finally
      Free();
    end;
  end;
end;

end.

