unit uImages;

interface

uses
  System.Classes,
  System.Types,
  FMX.Graphics,
  FMX.Types,
  FMX.Controls;

Type

   TExplosion = Class(TControl)
      Private
         FExplosionPass: Single;
         procedure SetExplosionPass(const Value: Single);
      Protected
         Procedure Paint; Override;
      Public
         Constructor Create(aOwner : Tcomponent); Override;
         Procedure DoExplode;
         Property ExplosionPass : Single Read FExplosionPass Write SetExplosionPass;
      End;


   TImages = Class
      private
         FMine           : TBitmap;
         FFlag           : TBitmap;
         FExplosionImage : TBitmap;
         FBackground     : TBitmap;
         FLarge          : TBitmap;
         FSmall          : TBitmap;
         FHard           : TBitmap;
         FEasy           : TBitmap;
         FMedium         : TBitmap;
         FVeryLarge      : TBitmap;
         FVerySmall      : TBitmap;
         FVeryHard       : TBitmap;
         FVeryEasy       : TBitmap;
         FNumbers        : TBitmap;
         FSimbols        : TBitmap;
         Function GetNumber(aNumber : Integer)  : TBitmap;
         Function GetSimbol(aSimbol : Char) : TBitmap;
      Public
         Constructor Create;
         Destructor Destroy; Override;
         Procedure DoExplode(aControl : TControl; aPosition : TPointF);
         Function  GetText(aText : String) : TBitmap;
         Property Mine           : TBitmap Read FMine;
         Property Flag           : TBitmap Read FFlag;
         Property ExplosionImage : TBitmap Read FExplosionImage;
         Property Background     : TBitmap Read FBackground;
         Property Large          : TBitmap Read FLarge;
         Property Small          : TBitmap Read FSmall;
         Property Hard           : TBitmap Read FHard;
         Property Easy           : TBitmap Read FEasy;
         Property Medium         : TBitmap Read FMedium;
         Property VeryLarge      : TBitmap Read FVeryLarge;
         Property VerySmall      : TBitmap Read FVerySmall;
         Property VeryHard       : TBitmap Read FVeryHard;
         Property VeryEasy       : TBitmap Read FVeryEasy;
      End;

Var
   Images : TImages;

implementation

uses
  System.SysUtils,
  System.UITypes,
  FMX.Ani,
  uMedia;

{ TImages }

constructor TImages.Create;

   Procedure GetResource(aImage : TBitmap; aResName : String);
   var
      LResStream: TResourceStream;
   begin
   LResStream := TResourceStream.Create(HInstance, aResName, RT_RCDATA);
   aImage.LoadFromStream(LResStream);
   LResStream.Free;
   End;

begin
Inherited;
FMine           := TBitmap.Create;
FFlag           := TBitmap.Create;
FExplosionImage := TBitmap.Create;
FBackground     := TBitmap.Create;
FLarge          := TBitmap.Create;
FSmall          := TBitmap.Create;
FHard           := TBitmap.Create;
FEasy           := TBitmap.Create;
FMedium         := TBitmap.Create;
FVeryLarge      := TBitmap.Create;
FVerySmall      := TBitmap.Create;
FVeryHard       := TBitmap.Create;
FVeryEasy       := TBitmap.Create;
FNumbers        := TBitmap.Create;
FSimbols        := TBitmap.Create;
GetResource(FMine,           'Mine');
GetResource(FFlag,           'Flag');
GetResource(FBackground,     'Background');
GetResource(FExplosionImage, 'Explosion');
GetResource(FLarge,          'Large');
GetResource(FSmall,          'Small');
GetResource(FHard,           'Hard');
GetResource(FEasy,           'Easy');
GetResource(FMedium,         'Medium');
GetResource(FVeryLarge,      'VeryLarge');
GetResource(FVerySmall,      'VerySmall');
GetResource(FVeryHard,       'VeryHard');
GetResource(FVeryEasy,       'VeryEasy');
GetResource(FNumbers,        'Numbers');
GetResource(FSimbols,        'Simbols');
end;

destructor TImages.Destroy;
begin
FExplosionImage.Free;
FFlag          .Free;
FBackground    .Free;
FMine          .Free;
FLarge         .Free;
FSmall         .Free;
FHard          .Free;
FEasy          .Free;
FMedium        .Free;
FVeryLarge     .Free;
FVerySmall     .Free;
FVeryHard      .Free;
FVeryEasy      .Free;
FNumbers       .Free;
FSimbols       .Free;
Inherited;
end;

procedure TImages.DoExplode(aControl : TControl; aPosition: TPointF);
begin
Media.Explosion;
TThread.CreateAnonymousThread(
   Procedure
   Var
      LExplosion : TExplosion;
   Begin
   LExplosion            := TExplosion.Create(Nil);
   LExplosion.Parent     := aControl;
   LExplosion.Position.x := aPosition.X-LExplosion.Width/2;
   LExplosion.Position.y := aPosition.Y-LExplosion.height/2;
   TThread.Synchronize(Nil,
      Procedure
      Begin
      LExplosion.DoExplode;
      End);
   Sleep(1000);
   LExplosion.Free;
   End).Start;

end;

function TImages.GetNumber(aNumber : Integer) : TBitmap;
Var
   LRect : TRect;
begin
Result := TBitmap.Create;
Result.SetSize(Trunc(FNumbers.Width/10), Trunc(FNumbers.Height));
LRect := Result.Bounds;
LRect.OffSet(Trunc(aNumber*FNumbers.Width/10), 0);
Result.CopyFromBitmap(FNumbers, LRect, 0, 0);
end;

function TImages.GetSimbol(aSimbol: Char): TBitmap;
Var
   LRect : TRect;
   i     : Integer;
begin
i := 0;
Case aSimbol of
  ':' : i := 0;
  '.' : i := 1;
  ',' : i := 2;
  End;
Result := TBitmap.Create;
Result.SetSize(Trunc(FSimbols.Width/3), Trunc(FSimbols.Height));
LRect := Result.Bounds;
LRect.OffSet(Trunc(i*Fsimbols.Width/10), 0);
Result.CopyFromBitmap(FSimbols, LRect, 0, 0);
end;

function TImages.GetText(aText: String): TBitmap;
Var
   I, W  : Integer;
   LChar : Tarray<TBitmap>;
begin
SetLength(LChar, aText.Length);
W := 0;
For i := 0 To aText.Length-1 Do
   Begin
   LChar[i] := Nil;
   If CharInSet(aText.Chars[i], ['0'..'9'])      Then LChar[i] := GetNumber(aText.Substring(i, 1).ToInteger);
   If CharInSet(aText.Chars[i], [':', '.', ',']) Then LChar[i] := GetSimbol(aText.Chars[i]);
   If LChar[i] <> Nil Then
      W := W + Lchar[i].Width;
   End;
Result := TBitmap.Create(W, FNumbers.Height);
Result.Clear(TAlphaColors.Null);
W := 0;
For i := 0 To aText.Length-1 Do
   Begin
   If Assigned(LChar[i]) Then
      Begin
      Result.CopyFromBitmap(LChar[i], LChar[i].Bounds, W, 0);
      W := W + LChar[i].Width;
      LChar[i].Free;
      end;
   End;
end;

{ TExplosion }


constructor TExplosion.Create(aOwner: Tcomponent);
begin
inherited;
Width         := 250;
Height        := 250;
ExplosionPass := 0;
end;

procedure TExplosion.DoExplode;
begin
ExplosionPass := 0;
TAnimator.AnimateFloat(Self, 'ExplosionPass', 100, 1);
end;

procedure TExplosion.Paint;
Var
   LCol, LLin : Integer;
   LBitRect   : TRectF;
begin
inherited;
LLin     := Trunc(FExplosionPass) Div 10;
LCol     := Trunc(FExplosionPass) Mod 10;
LBitRect := TRectF.Create(LCol * 150, LLin*150, LCol*150+150, LLin*150+150);
Canvas.DrawBitmap(Images.ExplosionImage, LBitRect, LocalRect, 1);
end;

procedure TExplosion.SetExplosionPass(const Value: Single);
begin
If Value = 100 Then
   Parent := Nil
Else
   begin
   FExplosionPass := Value;
   Repaint;
   end;
end;

end.
