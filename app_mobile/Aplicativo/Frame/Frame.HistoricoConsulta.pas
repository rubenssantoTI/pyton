unit Frame.HistoricoConsulta;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Objects, FMX.ListView, FMX.Controls.Presentation, FMX.Layouts;

type
  TQueryHistoryFrame = class(TFrame)
    Rectangle1: TRectangle;
    Layout1: TLayout;
    Image1: TImage;
    lbPlaca: TLabel;
    lbSituacao: TLabel;
    Layout2: TLayout;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Layout3: TLayout;
    Image3: TImage;
    Label3: TLabel;
    Label4: TLabel;
    Layout4: TLayout;
    Image4: TImage;
    Label5: TLabel;
    Label6: TLabel;
    ScrollBox1: TScrollBox;
    Layout5: TLayout;
    Image5: TImage;
    Label7: TLabel;
    Label8: TLabel;
    Layout6: TLayout;
    Image6: TImage;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Line1: TLine;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
