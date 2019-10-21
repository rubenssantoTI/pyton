unit Frame.PhotoOptions;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Ani, FMX.Layouts, Service.QueryPlate,
  Frame.VehiclePlate, Frame.PhotoEffects;

type
  TPhotoOptionsFrame = class(TFrame)
    Layout1: TLayout;
    Rectangle5: TRectangle;
    AnimaMenu: TFloatAnimation;
    Circle1: TCircle;
    Image1: TImage;
    Circle2: TCircle;
    Image2: TImage;
    Circle3: TCircle;
    Image3: TImage;
    Circle4: TCircle;
    Image4: TImage;
    Image5: TImage;
    AniIndicator1: TAniIndicator;
    procedure Circle4Click(Sender: TObject);
    procedure AnimaMenuFinish(Sender: TObject);
    procedure Circle1Click(Sender: TObject);
    procedure Circle3Click(Sender: TObject);
    procedure Circle2Click(Sender: TObject);
  private
    FQuery: TQueryPlateService;
    FVehiclePlateFrame: TVehiclePlateFrame;
    FPhotoEffectsFrame: TPhotoEffectsFrame;
    FNewImage: boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;

    procedure ShowFrame(const AImg: TBitmap);
    procedure HideFrame;
  end;

implementation

uses
  Model.QueryPlate;

{$R *.fmx}

{ TPhotoOptions }

procedure TPhotoOptionsFrame.AnimaMenuFinish(Sender: TObject);
begin
  if AnimaMenu.Inverse = true then
    Layout1.Visible := false;
end;

procedure TPhotoOptionsFrame.Circle1Click(Sender: TObject);
begin
  AnimaMenu.Inverse := true;
  AnimaMenu.Start;
  AniIndicator1.Enabled := true;
  AniIndicator1.Visible := true;
  FQuery.Query(Image5.Bitmap, procedure(AModel: TQueryPlateModel)
    begin
      AniIndicator1.Enabled := false;
      AniIndicator1.Visible := false;

      if Assigned(AModel) then begin
        AModel.Imagem.Assign(Image5.Bitmap);
        FVehiclePlateFrame.ShowFrame(AModel);
        FPhotoEffectsFrame.ClearEffects();
        AModel.DisposeOf();
      end else ShowMessage('Não foi possível localizar a placa. Tente tirar outra foto!');
    end
  );
end;

procedure TPhotoOptionsFrame.Circle2Click(Sender: TObject);
begin
  AnimaMenu.Inverse := true;
  AnimaMenu.Start;
  Image5.Bitmap.DisposeOf();
  FPhotoEffectsFrame.ClearEffects();
  HideFrame();
end;

procedure TPhotoOptionsFrame.Circle3Click(Sender: TObject);
begin
  AnimaMenu.Inverse := true;
  AnimaMenu.Start;
  FPhotoEffectsFrame.Image := Image5;
  FPhotoEffectsFrame.ShowFrame();
  FNewImage := false;
end;

procedure TPhotoOptionsFrame.Circle4Click(Sender: TObject);
var
  LHeight: Single;
begin
  if (Layout1.Visible) then begin
    AnimaMenu.Inverse := true;
    AnimaMenu.Start;
  end else begin
    if (Parent is TForm) then
      LHeight := (Parent as TForm).Height
    else
      LHeight := Self.Height;

    Layout1.Position.Y := LHeight + 20;
    Layout1.Visible := true;

    AnimaMenu.Inverse := false;
    AnimaMenu.StartValue := LHeight + 20;
    AnimaMenu.StopValue := 0;
    AnimaMenu.Start;
  end;
end;

constructor TPhotoOptionsFrame.Create(AOwner: TComponent);
begin
  inherited;
  Visible := false;
  Layout1.Visible := false;
  FQuery := TQueryPlateService.Create();
  FVehiclePlateFrame := TVehiclePlateFrame.Create(Self);
  FVehiclePlateFrame.Parent := Self;
  FPhotoEffectsFrame := TPhotoEffectsFrame.Create(AOwner);
  FPhotoEffectsFrame.Parent := Self;
end;

destructor TPhotoOptionsFrame.Destroy;
begin
  FQuery.DisposeOf();
  inherited;
end;

procedure TPhotoOptionsFrame.HideFrame;
begin
  Visible := false;
end;

procedure TPhotoOptionsFrame.ShowFrame(const AImg: TBitmap);
begin
  Visible := true;
  Image5.Bitmap.Assign(AImg);
  FNewImage := true;
end;

end.
