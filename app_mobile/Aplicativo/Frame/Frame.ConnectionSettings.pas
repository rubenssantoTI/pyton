unit Frame.ConnectionSettings;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Edit, FMX.Controls.Presentation, FMX.ListBox, FMX.Layouts,
  DataAccess.Settings;

type
  TConnectionSettingsFrame = class(TFrame)
    lbOptions: TListBox;
    ListBoxGroupHeader1: TListBoxGroupHeader;
    ListBoxItem1: TListBoxItem;
    edtImgServAddr: TEdit;
    ClearEditButton3: TClearEditButton;
    ShadowEffect1: TShadowEffect;
    ListBoxItem2: TListBoxItem;
    edtDetranServAddr: TEdit;
    ClearEditButton1: TClearEditButton;
    procedure edtImgServAddrExit(Sender: TObject);
    procedure edtDetranServAddrExit(Sender: TObject);
  private
    FSettingsDataAcess: TSettingsDataAccess;
    procedure LoadHost;
    class function IsQualifiedAddrValid(const AAddr: string): boolean; static;
  public
    constructor Create(AOwner: TComponent); override;

    procedure Options;
  end;

implementation

{$R *.fmx}

procedure TConnectionSettingsFrame.Options;
begin
  var LAnchor := Owner as TButton;
  Position.Y := LAnchor.Position.Y + LAnchor.Height + 15;
  Position.X := LAnchor.Position.X + LAnchor.Width - Width - 10;
  Visible := not Visible;
  if Visible then
  begin
    if lbOptions.CanFocus then lbOptions.SetFocus();
    with lbOptions do begin
      BeginUpdate();
      try
        LoadHost();
      finally
        EndUpdate();
      end;
    end;
    lbOptions.ApplyStyleLookup();
    lbOptions.RealignContent();
    lbOptions.BringToFront();
    BringToFront();
  end else begin
    SendToBack();
  end;
end;

constructor TConnectionSettingsFrame.Create(AOwner: TComponent);
begin
  inherited;
  FSettingsDataAcess := TSettingsDataAccess.Create(Self);
  Visible := false;
end;

procedure TConnectionSettingsFrame.edtDetranServAddrExit(Sender: TObject);
begin
  if ((Sender as TEdit).Text.Length > 0) and IsQualifiedAddrValid((Sender as TEdit).Text) then
  begin
    FSettingsDataAcess.SetDetranServerAddr((Sender as TEdit).Text);
  end else ShowMessage('Caminho para o servidor inválido!');
end;

procedure TConnectionSettingsFrame.edtImgServAddrExit(Sender: TObject);
begin
  if ((Sender as TEdit).Text.Length > 0) and IsQualifiedAddrValid((Sender as TEdit).Text) then
  begin
    FSettingsDataAcess.SetImageServerAddr((Sender as TEdit).Text);
  end else ShowMessage('Caminho para o servidor inválido!');
end;

procedure TConnectionSettingsFrame.LoadHost;
begin
  edtImgServAddr.Text := FSettingsDataAcess.GetImageServerAddr();
  edtDetranServAddr.Text := FSettingsDataAcess.GetDetranServerAddr();
end;

class function TConnectionSettingsFrame.IsQualifiedAddrValid(const AAddr: string): boolean;
begin
  Result := true;
  if (AAddr = '') then
    Result := false;
  if (Pos(':', AAddr) <= 0) then // Verifica se existe o separador host/porta
    Result := false;
  if (Length(Copy(AAddr.Trim(), 0, Pos(':', AAddr.Trim()) - 1)) <= 0) then
    // Verifica o tamanho da string representativa do host
    Result := false;
  if (Length(Copy(AAddr.Trim(), Pos(':', AAddr.Trim()) + 1,
    Length(AAddr.Trim()) - 1)) <= 0) then
    // Verifica o tamanho da string representativa da porta
    Result := false;
end;


end.
