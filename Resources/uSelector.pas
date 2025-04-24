unit uSelector;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uArrow, FMX.Layouts;

type
  TSelector = class(TFrame)
    ArrowLeft: TArrow;
    ArrowRight: TArrow;
    Selection: TLayout;
  private
    FBitmap  : TBitmap;
    FOptions : TArray<TBitmap>;
    FIndex   : Integer;
    FPosX: Single;
    procedure SetIndex(const Value: Integer);
    Procedure CreateBitmap;
    procedure SetPosX(const Value: Single);
  Protected
    Procedure Paint; Override;
    Procedure DoResized; Override;
  public
    Constructor Create(aOwner : TComponent); Override;
    Destructor Destroy; Override;
    Procedure SetOptions(aValues : TArray<TBitmap>);
    Property PosX      : Single  Read FPosX  Write SetPosX;
    Property ItemIndex : Integer Read FIndex Write SetIndex;
  end;

implementation

Uses
   FMX.Ani;

{$R *.fmx}

{ TSelector }

constructor TSelector.Create(aOwner: TComponent);
begin
inherited;
FBitmap := TBitmap.Create;
ArrowLeft.OnClicked  := Procedure
                        Begin
                        If ItemIndex > 0 Then ItemIndex := ItemIndex -1;
                        End;
ArrowRight.OnClicked := Procedure
                        Begin
                        If ItemIndex < Length(FOptions)-1 Then ItemIndex := ItemIndex +1;
                        End;
SetLength(FOptions, 0);
end;

destructor TSelector.Destroy;
begin
FBitmap.Free;
inherited;
end;

procedure TSelector.DoResized;
begin
inherited;
If Assigned(FBitmap) Then
   begin
   CreateBitmap;
   SetIndex(FIndex);
   end;
end;

procedure TSelector.Paint;
Var
   LRect : TRectF;
begin
inherited;
LRect := TRectF.Create(FPosX, 0, FPosX+Selection.Width, Selection.Height);
Canvas.DrawBitmap(FBitmap, LRect, Selection.BoundsRect, 1);
end;

procedure TSelector.CreateBitmap;
Var
   i           : Integer;
   LRectBitmap : TRectF;
   LRect       : TRectF;
begin
If Length(FOptions) < 1 Then Exit;
FBitmap.SetSize(Trunc(Selection.Width*Length(FOptions)), Trunc(Selection.Height));
FBitmap.Canvas.BeginScene;
FBitmap.Canvas.Clear(TAlphaColors.Null);
FBitmap.Canvas.Fill.Color := TAlphaColors.Green;
FBitmap.Canvas.Font.Size  := 20;
For i := 0 To Length(FOptions)-1 Do
   begin
   LRectBitmap := TRectF.Create(i*Selection.Width, 0, (i+1)*Selection.Width, Selection.Height);
   LRect       := FOptions[i].BoundsF;
   LRectBitmap.Inflate(-4, -2);
   LRect.Fit(LRectBitmap);
   FBitmap.Canvas.DrawBitmap(FOptions[i], FOptions[i].BoundsF, LRect, 1);
   end;
FBitmap.Canvas.EndScene;
FPosX := 0;
Repaint;
end;

procedure TSelector.SetIndex(const Value: Integer);
begin
If Findex = Value Then
   Begin
   FPosX  := FIndex * Selection.Width;
   Repaint;
   End
Else
   Begin
   FIndex := Value;
   TAnimator.AnimateFloat(Self, 'PosX', FIndex * Selection.Width, 0.3);
   End;
end;

procedure TSelector.SetOptions(aValues: TArray<TBitmap>);
begin
FOptions := aValues;
CreateBitmap;
Repaint;
end;

procedure TSelector.SetPosX(const Value: Single);
begin
FPosX := Value;
Repaint;
end;

end.
