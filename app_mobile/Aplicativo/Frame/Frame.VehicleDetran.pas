unit Frame.VehicleDetran;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Ani, FMX.Layouts,
  Model.QueryDetran;

type
  TVehicleDetranFrame = class(TFrame)
    Layout4: TLayout;
    Rectangle5: TRectangle;
    AnimaMenu: TFloatAnimation;
    Rectangle2: TRectangle;
    Layout1: TLayout;
    Label1: TLabel;
    Layout2: TLayout;
    SpeedButton1: TSpeedButton;
    Layout3: TLayout;
    Line1: TLine;
    Line2: TLine;
    Label2: TLabel;
    lblSituacao: TLabel;
    Label3: TLabel;
    lblMarca: TLabel;
    Label4: TLabel;
    lblModelo: TLabel;
    Layout6: TLayout;
    Label6: TLabel;
    lblAno: TLabel;
    lblAnoModelo: TLabel;
    Label8: TLabel;
    Layout7: TLayout;
    Label9: TLabel;
    lblMunicipio: TLabel;
    Layout8: TLayout;
    Label11: TLabel;
    lblUF: TLabel;
    Layout5: TLayout;
    Label5: TLabel;
    lblChassi: TLabel;
    lblCor: TLabel;
    Label12: TLabel;
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;

    procedure ShowFrame(const AModel: TQueryDetranModel);
  end;

implementation

{$R *.fmx}

{ TVehicleDetranFrame }

constructor TVehicleDetranFrame.Create(AOwner: TComponent);
begin
  inherited;
  Visible := false;
end;

destructor TVehicleDetranFrame.Destroy;
begin
  inherited;
end;

procedure TVehicleDetranFrame.ShowFrame(const AModel: TQueryDetranModel);
begin
  lblSituacao.Text := AModel.Situacao;
  lblMarca.Text := AModel.Marca;
  lblModelo.Text := AModel.Modelo;
  lblAno.Text := AModel.Ano;
  lblAnoModelo.Text := AModel.AnoModelo;
  lblMunicipio.Text := AModel.Municipio;
  lblUF.Text := AModel.UF;
  lblChassi.Text := AModel.Chassi;
  lblCor.Text := AModel.Cor;
  Visible := true;
end;

procedure TVehicleDetranFrame.SpeedButton1Click(Sender: TObject);
begin
  Visible := false;
end;

end.
