unit uGameActions;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Objects;

type
  TActions = class(TFrame)
    Rectangle1: TRectangle;
    imgPause: TImage;
    imgRadar: TImage;
    imgSafe: TImage;
    imgAbort: TImage;
    procedure S(Sender: TObject);
    procedure imgAbortClick(Sender: TObject);
    procedure imgSafeClick(Sender: TObject);
    procedure imgRadarClick(Sender: TObject);
  private
    FHeight : Single;
  public
    Procedure ShowIn(aControl : TControl);
    procedure HideActions;
  end;

Var
   Actions : TActions;

implementation

Uses
   FMX.Ani,
   uField,
   uField.View,
   uPause,
   uMedia,
   uGameScore,
   uGameInterfaces;

{$R *.fmx}

{ TActions }

procedure TActions.ShowIn(aControl: TControl);
begin
Parent     := aControl;
FHeight    := aControl.Height;
Position.x := (aControl.Width-Width)/2;
Position.Y := aControl.Height+2;
TAnimator.AnimateFloat(Self, 'Position.Y', aControl.Height-height-20, 1, TAnimationType.Out, TInterpolationType.Back);
ImgRadar.Opacity := 1;
imgSafe .Opacity := 1;
end;

procedure TActions.HideActions;
begin
TAnimator.AnimateFloat(Self, 'Position.Y', Fheight+2, 1, TAnimationType.Out, TInterpolationType.Back);
TThread.CreateAnonymousThread(
   Procedure
   Begin
   Sleep(1010);
   TThread.Queue(Nil, Procedure Begin Parent := Nil; End);
   End).Start;
end;

procedure TActions.S(Sender: TObject);
begin
Media.Click2;
Score.StopTime;
Pause.ShowIn(Owner,
   Procedure
   Begin
   Score.ResumeTime;
   End);
end;

procedure TActions.imgRadarClick(Sender: TObject);
begin
If imgRadar.Opacity <> 1 Then exit;
(Owner As IMinesweeper).StartTime;
Media.SonarPulse;
FieldView.RadarPulse;
Score   .IncTime(20);
imgRadar.Opacity := 0.4;
TThread.CreateAnonymousThread(
   procedure
   Begin
   Sleep(20000);
   TThread.Queue(Nil,
      Procedure
      Begin
      TAnimator.AnimateFloat(imgRadar, 'Opacity', 1, 0.3);
      End);
   End).Start;
end;

procedure TActions.imgSafeClick(Sender: TObject);
Var
   LPos : TPoint;
begin
If imgSafe.Opacity <> 1 Then
   exit;
Media.Click2;
LPos := Field.GetSafePoint;
If LPos.x <> -1 Then
   Begin
   (Owner As IMinesweeper).ClickField(TMouseButton.mbLeft, LPos.X, LPos.Y, 0);
   Score  .IncTime(10);
   imgSafe.Opacity := 0.4;
   TThread.CreateAnonymousThread(
      procedure
      Begin
      Sleep(20000);
      TThread.Queue(Nil,
         Procedure
         Begin
         TAnimator.AnimateFloat(imgSafe, 'Opacity', 1, 0.3);
         End);
      End).Start;
   End;
end;

procedure TActions.imgAbortClick(Sender: TObject);
begin
Media.Click2;
(Owner as IMinesweeper).Terminate;
end;

end.
