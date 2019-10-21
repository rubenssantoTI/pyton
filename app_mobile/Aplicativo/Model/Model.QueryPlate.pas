unit Model.QueryPlate;

interface

uses
  FMX.Graphics, FMX.Objects, System.Classes;

type
  TSituacaoVeiculo = (svNormal, svSinistro);

  TQueryPlateModel = class
  private
    FImagem: TBitmap;
    FSituacao: TSituacaoVeiculo;
    FPlaca: string;
  public
    constructor Create(const APlaca: string; const ASituacao: TSituacaoVeiculo;
      const AImagem: TBitmap);
    destructor Destroy(); override;

    property Placa: string read FPlaca write FPlaca;
    property Situacao: TSituacaoVeiculo read FSituacao write FSituacao;
    property Imagem: TBitmap read FImagem write FImagem;
  end;

implementation

{ TQueryVehicleModel }

constructor TQueryPlateModel.Create(const APlaca: string;
  const ASituacao: TSituacaoVeiculo; const AImagem: TBitmap);
begin
  FImagem := TBitmap.Create;
  FPlaca := APlaca;
  FSituacao := ASituacao;
  FImagem.Assign(AImagem);
end;

destructor TQueryPlateModel.Destroy;
begin
  FImagem.DisposeOf();
  inherited;
end;

end.
