unit Model.QueryDetran;

interface

type
  TQueryDetranModel = class
  private
    FCor: string;
    FChassi: string;
    FUF: string;
    FModelo: string;
    FANo: string;
    FMunicipio: string;
    FSituacao: string;
    FMarca: string;
    FPlaca: string;
    FAnoModelo: string;
  public
    property Situacao: string read FSituacao write FSituacao;
    property Modelo: string read FModelo write FModelo;
    property Marca: string read FMarca write FMarca;
    property Cor: string read FCor write FCor;
    property Ano: string read FANo write FAno;
    property AnoModelo: string read FAnoModelo write FAnoModelo;
    property Placa: string read FPlaca write FPlaca;
    property UF: string read FUF write FUF;
    property Municipio: string read FMunicipio write FMunicipio;
    property Chassi: string read FChassi write FChassi;
  end;

implementation

end.
