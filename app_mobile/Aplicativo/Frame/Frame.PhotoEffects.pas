unit Frame.PhotoEffects;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, System.Actions, FMX.ActnList, FMX.Effects, FMX.Filter.Effects,
  System.Generics.Collections, FMX.Objects, FMX.Ani;

type
  TPhotoEffectsFrame = class(TFrame)
    lvEffects: TListView;
    ActionList1: TActionList;
    EmbossEffect1: TEmbossEffect;
    RadialBlurEffect1: TRadialBlurEffect;
    ContrastEffect1: TContrastEffect;
    ColorKeyAlphaEffect1: TColorKeyAlphaEffect;
    InvertEffect1: TInvertEffect;
    SepiaEffect1: TSepiaEffect;
    TilerEffect1: TTilerEffect;
    PixelateEffect1: TPixelateEffect;
    ToonEffect1: TToonEffect;
    PencilStrokeEffect1: TPencilStrokeEffect;
    RippleEffect1: TRippleEffect;
    WaveEffect1: TWaveEffect;
    InnerGlowEffect1: TInnerGlowEffect;
    procedure FrameResize(Sender: TObject);
    procedure lvEffectsItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    FEffects: TObjectList<TFilterEffect>;
    FItemsEffectsMap: TDictionary<Integer, TFilterEffect>;
    FUndoEffectList: TObjectStack<TFilterEffect>;
    FUndoEffectItem: TListViewItem;
    FTopWhenShown: Extended;
    FImage: TImage;
    procedure LoadPhoto;
    procedure RecalcMenuPosition();
    procedure RemoveCurrentEffect(ARemoveFromList: boolean);
    function EffectNameByClassName(const AClassName: string): string;
    procedure ShowEffects();
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;

    procedure ShowFrame;
    procedure ClearEffects;

    property Image: TImage read FImage write FImage;
  end;

implementation

{$R *.fmx}

uses
  System.RegularExpressions;

{ TFrame1 }

procedure TPhotoEffectsFrame.ClearEffects;
begin
  while FUndoEffectList.Count > 0 do begin
    Image.RemoveObject(FUndoEffectList.Peek);
    FUndoEffectList.Pop;
  end;
end;

constructor TPhotoEffectsFrame.Create(AOwner: TComponent);
var
  eff: TFmxObject;
begin
  inherited;
  Visible := false;
  FEffects := TObjectList<TFilterEffect>.Create(true);
  FItemsEffectsMap := TDictionary<Integer, TFilterEffect>.Create();
  FUndoEffectList := TObjectStack<TFilterEffect>.Create(false);

  lvEffects.Position.Y := -lvEffects.Height;

  lvEffects.BeginUpdate();
  try
    FUndoEffectItem := lvEffects.Items.Add();
    FUndoEffectItem.Text := 'Undo';

    for eff in Children do begin
      if eff is TFilterEffect then begin
        var lbi := lvEffects.Items.Add();
        lbi.Text := EffectNameByClassName(eff.ClassName);
        FItemsEffectsMap.Add(lbi.Index, TFilterEffect(eff));
        FEffects.Add(TFilterEffect(eff));
        Self.RemoveObject(eff);
        TFilterEffect(eff).Enabled := true;
      end;
    end;
  finally
    lvEffects.EndUpdate();
  end;
end;

destructor TPhotoEffectsFrame.Destroy;
begin
  FUndoEffectList.DisposeOf();
  FItemsEffectsMap.DisposeOf();
  inherited;
end;

function TPhotoEffectsFrame.EffectNameByClassName(const AClassName: string): string;
begin
  Result := AClassName.Substring(1);
  Result := TRegEx.Replace(Result, '[A-Z]', ' $0').TrimLeft;
end;

procedure TPhotoEffectsFrame.FrameResize(Sender: TObject);
begin
  RecalcMenuPosition;
end;

procedure TPhotoEffectsFrame.LoadPhoto;
begin
  RemoveCurrentEffect(false);
  FUndoEffectList.Clear();
end;

procedure TPhotoEffectsFrame.lvEffectsItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  TAnimator.AnimateFloatDelay(
    lvEffects, 'Position.Y', -lvEffects.Height - 500, 0.3, 0.1,
    TAnimationType.&In, TInterpolationType.Back
  );

  if (AItem = FUndoEffectItem) then begin
    RemoveCurrentEffect(true);
    if FUndoEffectList.Count > 0 then
      Image.AddObject(FUndoEffectList.Peek);
  end else begin
    RemoveCurrentEffect(false);
    FUndoEffectList.Push(FItemsEffectsMap[AItem.Index]);
    Image.AddObject(FUndoEffectList.Peek);
  end;
  Visible := false;
end;

procedure TPhotoEffectsFrame.RecalcMenuPosition;
var
  LClientHeight: integer;
  LClienteWidth: integer;
begin
  if (Owner is TForm) then begin
    LClientHeight := (Owner as TForm).ClientHeight;
    LClienteWidth := (Owner as TForm).ClientWidth;
    FTopWhenShown := (LClientHeight / 2 - lvEffects.Height / 2);
    lvEffects.Height := LClientHeight / 2;
    lvEffects.Position.X := LClienteWidth / 2 - lvEffects.Width / 2;
  end;
end;

procedure TPhotoEffectsFrame.RemoveCurrentEffect(ARemoveFromList: boolean);
begin
  if FUndoEffectList.Count = 0 then
    Exit;

  Image.RemoveObject(FUndoEffectList.Peek);
  if ARemoveFromList then
    FUndoEffectList.Pop;
end;

procedure TPhotoEffectsFrame.ShowEffects;
begin
  if FUndoEffectList.Count = 0 then
    FUndoEffectItem.Text := '<No effect to undo>'
  else
    FUndoEffectItem.Text := '[Undo ' + EffectNameByClassName(FUndoEffectList.Peek.ClassName) + ']';

  TAnimator.AnimateFloat(lvEffects, 'Position.Y', FTopWhenShown,
    0.4, TAnimationType.&Out, TInterpolationType.Back);
end;

procedure TPhotoEffectsFrame.ShowFrame;
begin
  Visible := true;
  if (not Assigned(FImage)) then LoadPhoto();
  RecalcMenuPosition();
  ShowEffects();
end;

end.
