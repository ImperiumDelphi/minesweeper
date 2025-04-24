unit uStartScreen;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Objects, FMX.Layouts, FMX.Ani;

type
  TStartScreen = class(TFrame)
    Title: TImage;
    Layout1: TLayout;
    GameMessage: TImage;
    AniRect: TFloatAnimation;
    Airplane: TLayout;
    Image1: TImage;
    AirplaneAni: TPathAnimation;
    TimerAirplane: TTimer;
    imgConfigSound: TImage;
    procedure TitleClick(Sender: TObject);
    procedure TimerAirplaneTimer(Sender: TObject);
    procedure AirplaneAniFinish(Sender: TObject);
    procedure imgConfigSoundClick(Sender: TObject);
  private
     FBackground      : TBitmap;
     FFieldsRect      : TArray<TRectF>;
     FRectImage       : TRectF;
     FAniOpacity      : Single;
     FSelectedField   : Integer;
     FImageRatio      : Single;
     FStartImageRatio : Single;
     FImageOffSetX    : Single;
     FImageOffSetY    : Single;
     FFlashFields     : Boolean;
     FRotas           : TArray<String>;
     FRota            : Integer;
     function  ProportionalRect(aRect: TRectF; aWidth : Single = 2048): TRectF;
     procedure SetAniOpacity   (const Value: Single);
     procedure SetSelectedField(const Value: Integer);
     procedure SetRectImage    (const Value: TRectF);
     procedure SetImageRatio   (const Value: Single);
     procedure SetImageOffSetX (const Value: Single);
     procedure SetImageOffSetY (const Value: Single);
     procedure SetFlashFields  (const Value: Boolean);
     procedure ShowAirplane;
  Protected
     Procedure Paint; Override;
     Procedure DoResized; Override;
     procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Single); Override;
  public
     Constructor Create(aOwner : TComponent); Override;
     Procedure ShowIn(aForm : TFMXObject);
     Procedure CentralizeField(aField : Integer);
     Procedure CentralizeMap;
     Procedure HideMessage;
     procedure ShowMessage;
     Property AniOpacity    : Single  Read FAniOpacity     Write SetAniOpacity;
     Property SelectedField : Integer Read FSelectedField  Write SetSelectedField;
     Property RectImage     : TRectF  Read FRectImage      Write SetRectImage;
     Property ImageRatio    : Single  Read FimageRatio     Write SetImageRatio;
     Property ImageOffSetX  : Single  Read FImageOffSetX   Write SetImageOffSetX;
     Property ImageOffSetY  : Single  Read FImageOffSetY   Write SetImageOffSetY;
     Property FlashFields   : Boolean Read FFlashFields    Write SetFlashFields;
  end;

Var
   StartScreen : TStartScreen;

implementation

Uses
   uImages,
   uMedia,
   uConfig,
   uField.View,
   uInstructions;

{$R *.fmx}

{ TFrame1 }

Function TStartScreen.ProportionalRect(aRect : TRectF; aWidth : Single = 2048): TRectF;

   Function Proportional(aValue : Single) : Single;
   Begin
   Result := (aValue*FRectImage.Width)/aWidth;
   End;

Begin
Result := TRectF.Create(Proportional(aRect.Left), Proportional(aRect.Top), Proportional(aRect.Right), Proportional(aRect.Bottom));
End;

procedure TStartScreen.CentralizeField(aField: Integer);
Var
   LRatio   : Single;
   LRectOff : TRectF;
   LRealRat : Single;
   LOffX    : Single;
   LOffY    : Single;
begin
LRectOff := ProportionalRect(FFieldsRect[aField]);
LRatio   := Width / LRectOff.Height;
LRealRat := LRatio * FStartImageRatio;
LOffX    := (FFieldsRect[aField].Left * LRealRat)+(Width  - (FBackground.Width  * LRealRat))/2;
LoffX    := LOffX + ((FFieldsRect[aField].Width*LRealRat)-(FFieldsRect[aField].Height*LRealRat)) / 2;
LOffY    := (FFieldsRect[aField].Top  * LRealRat)+(Height - (FBackground.Height * LRealRat))/2;
LOffY    := LOffY - (Height - FFieldsRect[aField].Height*LRealRat)/2;
Tanimator.AnimateFloat(Self, 'ImageRatio',   LRatio, 1.5, TAnimationType.InOut, TInterpolationType.Exponential);
Tanimator.AnimateFloat(Self, 'ImageOffSetX', -LOffX, 1.5, TAnimationType.InOut, TInterpolationType.Exponential);
Tanimator.AnimateFloat(Self, 'ImageOffSetY', -LOffY, 1.5, TAnimationType.InOut, TInterpolationType.Exponential);
end;

Procedure TStartScreen.CentralizeMap;
Begin
Tanimator.AnimateFloat(Self, 'ImageRatio',   1, 1.5, TAnimationType.InOut, TInterpolationType.Exponential);
Tanimator.AnimateFloat(Self, 'ImageOffSetX', 0, 1.5, TAnimationType.InOut, TInterpolationType.Exponential);
Tanimator.AnimateFloat(Self, 'ImageOffSetY', 0, 1.5, TAnimationType.InOut, TInterpolationType.Exponential);
End;

constructor TStartScreen.Create(aOwner: TComponent);
begin
inherited;
Airplane.Position.x := 0;
Airplane.Position.y := -90;
Setlength(FRotas, 4);
FRota     := 0;
FRotas[3] := 'M 60.957 8.282 '+
             'C 72.418 84.734 272.376 63.067 348.248 98.651 '+
             'C 413.606 129.304 358.481 221.54 346.239 233.997 '+
             'C 259.838 321.91 120.175 290.655 127.294 224.273 '+
             'C 136.1 142.16 200.272 141.101 266.451 150.604 '+
             'C 300.593 155.507 454.929 231.646 340.258 297.847 '+
             'C 21.421 481.916 296.289 487.42 319.364 495.942';
FRotas[2] := 'M 416.763 25.178 '+
             'C 438.097 167.488 372.211 206.614 346.239 233.997 '+
             'C 264.331 320.355 211.595 270.183 196.534 237.525 '+
             'C 171.296 182.799 210.181 153.164 266.451 150.604 '+
             'C 300.908 149.036 408.125 184.154 340.258 297.847 '+
             'C 280.664 397.682 9.286 479.081 30.147 488.322';
FRotas[1] := 'M 163.657 2.318 '+
             'C 175.118 78.77 182.816 107.327 191.216 132.443 '+
             'C 205.786 176.01 266.606 231.065 204.115 296.28 '+
             'C 118.834 385.28 23.266 288.781 29.232 222.285 '+
             'C 33.883 170.444 72.854 145.796 122.671 146.297 '+
             'C 194.999 147.024 292.858 174.519 265.386 324.019 '+
             'C 255.325 378.773 87.082 404.231 141.461 498.593';
FRotas[0] := 'M 216.995 1.655 '+
             'C 94.283 47.297 30.119 108.777 23.583 148.675 '+
             'C 6.534 252.742 163.502 99.708 208.091 182.979 '+
             'C 259.428 278.852 -15.888 347.317 29.232 222.285 '+
             'C 46.9 173.326 58.853 118.804 103.456 140.997 '+
             'C 137.619 157.995 201.021 156.45 172.562 235.986 '+
             'C 165.737 255.059 134.783 251.772 93.305 254.993 '+
             'C 58.549 257.692 25.76 320.222 48.059 346.215 '+
             'C 88.4 393.241 171.929 397.972 141.461 498.593';

FBackground    := Images.Background;
FSelectedField := -1;
FAniOpacity    := 0;
FImageOffSetX  := 0;
FImageOffSetY  := 0;
SetLength(FFieldsRect, 7);
FFieldsRect[0] := TRectF.Create( 286,  745,  505,  872);
FFieldsRect[1] := TRectF.Create( 620,  638,  830,  783);
FFieldsRect[2] := TRectF.Create(1048,  806, 1265,  948);
FFieldsRect[3] := TRectF.Create(1480,  489, 1700,  633);
FFieldsRect[4] := TRectF.Create( 423, 1195,  657, 1336);
FFieldsRect[5] := TRectF.Create(1323, 1203, 1539, 1344);
FFieldsRect[6] := TRectF.Create( 548, 1434,  749, 1578);
AniRect.PropertyName := 'AniOpacity';
AniRect.Enabled      := True;
GameMessage.Opacity  := 0;
Title      .Opacity  := 0;
end;

Procedure TStartScreen.ShowAirplane;
Var
   LPath : TPathData;
Begin
TimerAirplane.Enabled    := False;
Airplane     .Position.x := 0;
Airplane     .Position.y := -90;
Media.AirPlane;
LPath      := TPathData.Create;
LPath.Data := FRotas[FRota];
Lpath.Scale(1, 2);
LPath.FitToRect(TRectF.Create(0, 0, Width, Height*1.2));
LPath.Translate(0, 30);
AirplaneAni.Stop;
AirplaneAni.Duration  := 20;
AirplaneAni.Path.Data := LPath.Data;
AirPlaneAni.Start;
Inc(FRota); If FRota >= Length(FRotas) Then FRota := 0;
End;

procedure TStartScreen.AirplaneAniFinish(Sender: TObject);
begin
TimerAirplane.Interval := 10000;
TimerAirplane.Enabled  := True;
end;

procedure TStartScreen.TimerAirplaneTimer(Sender: TObject);
begin
If GameMessage.Opacity = 1 Then
   Begin
   TimerAirplane.Enabled := False;
   ShowAirplane;
   End;
end;

procedure TStartScreen.DoResized;
begin
inherited;
If Assigned(FBackground) Then
   Begin
   FStartImageRatio := Width/FBackground.Width;
   ImageRatio       := 1;
   End;
end;

procedure TStartScreen.ShowIn(aForm: TFMXObject);
begin
parent := aForm;
Align  := TAlignLayout.Contents;
ShowMessage;
end;

procedure TStartScreen.ShowMessage;
begin
Media.ChooseField;
TAnimator.AnimateFloat(GameMessage,    'Opacity', 1, 0.4);
TAnimator.AnimateFloat(Title,          'Opacity', 1, 0.4);
TAnimator.AnimateFloat(imgConfigSound, 'Opacity', 1, 0.4);
end;

procedure TStartScreen.HideMessage;
begin
Media.ChooseFieldOut;
TAnimator.AnimateFloat(GameMessage,    'Opacity', 0, 0.4);
TAnimator.AnimateFloat(Title,          'Opacity', 0, 0.4);
TAnimator.AnimateFloat(imgConfigSound, 'Opacity', 0, 0.4);
end;

procedure TStartScreen.imgConfigSoundClick(Sender: TObject);
begin
COnfig.ShowIn(Self);
end;

procedure TStartScreen.TitleClick(Sender: TObject);
begin
ShowAirplane;
end;

procedure TStartScreen.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Single);
Var
   I     : Integer;
   LRect : TRectF;
begin
inherited;
Media.Click2;
If FieldView.Parent <> Nil Then Exit;
For i := 0 To 6 Do
   Begin
   LRect := ProportionalRect(FFieldsRect[i]);
   LRect.OffSet(FRectImage.Left, FRectImage.Top);
   If LRect.Contains(TPointF.Create(X, y)) Then
      Begin
      FSelectedField := i;
      FrameInstructions.SetField(i+1);
      FrameInstructions.ShowIn(Self);
      Break;
      End;
   End;
end;

procedure TStartScreen.Paint;
Var
   i     : Integer;
   LRect : TRectF;
begin
inherited;
Canvas.Fill.Color := $ff2e5d70;
Canvas.Fill.Kind  := TBrushKind.Solid;
Canvas.FillRect(BoundsRect, 1);
FRectImage.SetLocation((Width-FRectImage.Width)/2+FImageOffSetX, (Height-FRectImage.Height)/2+FImageOffSetY);
Canvas.DrawBitmap(FBackground, FBackground.BoundsF, FRectImage, 1);
Canvas.Stroke.Kind      := TBrushKind.Solid;
Canvas.Stroke.Thickness := 3;
For i := 0 To 6 Do
   Begin
   LRect := ProportionalRect(FFieldsRect[i]);
   LRect.OffSet(FRectImage.Left, FRectImage.Top);
   If i = FSelectedField Then
      Canvas.Stroke.Color := TAlphaColors.Greenyellow
   Else
      Canvas.Stroke.Color := TAlphaColors.White;
   Canvas.DrawRect(LRect, FAniOpacity);
   End;
end;

procedure TStartScreen.SetAniOpacity(const Value: Single);
begin
FAniOpacity := Value;
Repaint;
end;

procedure TStartScreen.SetFlashFields(const Value: Boolean);
begin
FFlashFields    := Value;
AniRect.Enabled := Value;
Repaint;
end;

procedure TStartScreen.SetImageOffSetX(const Value: Single);
begin
FImageOffSetX := Value;
Repaint;
end;

procedure TStartScreen.SetImageOffSetY(const Value: Single);
begin
FImageOffSetY := Value;
Repaint;
end;

procedure TStartScreen.SetImageRatio(const Value: Single);
begin
FImageRatio       := Value;
FRectImage        := FBackground.BoundsF;
FRectImage.Width  := FBackground.Width * (FImageRatio * FStartImageRatio);
FRectImage.Height := FRectImage.Width;
Repaint;
end;

procedure TStartScreen.SetRectImage(const Value: TRectF);
begin
FRectImage := Value;
Repaint;
end;

procedure TStartScreen.SetSelectedField(const Value: Integer);
begin
FSelectedField := Value;
Repaint;
end;

end.
