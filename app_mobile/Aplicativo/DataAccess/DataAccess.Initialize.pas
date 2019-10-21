unit DataAccess.Initialize;

interface

type
  TLocalDataAccessInitService = class
  public
    class procedure Initialize(); static;
  end;

implementation

uses
  DataAccess.Script01, DataAccess.Interfaces;

class procedure TLocalDataAccessInitService.Initialize();
var
  LChain: IScriptChain;
begin
  LChain := TScriptBaseDados.Create();
  LChain := TScriptPrincipal.Create(LChain);
  LChain := TScriptPrimario.Create(LChain);
  try
    LChain.Chain();
  finally
    LChain := nil;
  end;
end;

end.
