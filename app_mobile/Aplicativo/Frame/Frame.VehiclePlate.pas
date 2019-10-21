unit Frame.VehiclePlate;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, Model.QueryPlate,
  FMX.Ani, Service.QueryDetran, Frame.VehicleDetran, Model.QueryDetran;

type
  TVehiclePlateFrame = class(TFrame)
    Layout1: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    Rectangle1: TRectangle;
    imgPlaca: TImage;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    lbPlaca: TLabel;
    Rectangle2: TRectangle;
    Layout4: TLayout;
    Rectangle5: TRectangle;
    AnimaMenu: TFloatAnimation;
    Line1: TLine;
    Line2: TLine;
    AniIndicator1: TAniIndicator;
    btnSituacao: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure btnSituacaoClick(Sender: TObject);
  private
    FQuery: TQueryDetranService;
    FVehicleDetranFrame: TVehicleDetranFrame;
    FDetranModel: TQueryDetranModel;
    procedure ConsultarNoDetran(const APlaca: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;

    procedure ShowFrame(const AModel: TQueryPlateModel);
  end;

implementation

{$R *.fmx}

{ TVehicleSituation }

procedure TVehiclePlateFrame.btnSituacaoClick(Sender: TObject);
begin
  if (btnSituacao.Text = 'Indisponível') then begin
    ConsultarNoDetran(lbPlaca.Text);
  end else begin
    FVehicleDetranFrame.ShowFrame(FDetranModel);
  end;
end;

constructor TVehiclePlateFrame.Create(AOwner: TComponent);
begin
  inherited;
  FVehicleDetranFrame := TVehicleDetranFrame.Create(Self);
  FVehicleDetranFrame.Parent := Self;
  Visible := false;
  AniIndicator1.Visible := false;
  btnSituacao.Visible := false;
  FQuery := TQueryDetranService.Create();
end;

destructor TVehiclePlateFrame.Destroy;
begin
  FQuery.DisposeOf;
  inherited;
end;

procedure TVehiclePlateFrame.ShowFrame(const AModel: TQueryPlateModel);
begin
  btnSituacao.Visible := false;
  lbPlaca.Text := AModel.Placa;
  imgPlaca.Bitmap.Assign(AModel.Imagem);
  Visible := true;
  ConsultarNoDetran(lbPlaca.Text);
end;

procedure TVehiclePlateFrame.ConsultarNoDetran(const APlaca: string);
begin
  btnSituacao.Visible := false;
  AniIndicator1.Visible := true;
  AniIndicator1.Enabled := true;
  FQuery.Query(APlaca, procedure(AModel: TQueryDetranModel)
    begin
      FDetranModel := AModel;
      AniIndicator1.Visible := false;
      AniIndicator1.Enabled := false;
      if Assigned(AModel) then begin
        btnSituacao.Enabled := true;
        btnSituacao.Visible := true;
        btnSituacao.Text := AModel.Situacao;
      end else begin
        btnSituacao.Text := 'Indisponível';
        btnSituacao.Enabled := true;
        btnSituacao.Visible := true;
      end;
    end);
end;

procedure TVehiclePlateFrame.SpeedButton1Click(Sender: TObject);
begin
  Visible := false;
end;

end.
