unit uGameScore;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Objects;

type
  TScore = class(TFrame)
    Rectangle1: TRectangle;
    ImgTime: TImage;
    TxtTime: TImage;
    ImageFlag: TImage;
    ImgFlagCount: TImage;
    ImgMinesCount: TImage;
    ImgMines: TImage;
  private
     FTimeStr   : String;
     FTime      : TTime;
     FTimer     : TTimer;
     Procedure UpdateTime(Sender : TObject);
  public
     Constructor Create(aOwner : TComponent); Override;
     Procedure ShowIn(aControl : TControl);
     Procedure HideScore;
     Procedure ShowTime(aTime : string);
     Procedure ShowFlags(aFlags : Integer);
     procedure ShowMines(aMines : Integer);
     Procedure StartTime;
     Procedure StopTime;
     Procedure ResumeTime;
     Procedure IncTime(aSec : Integer);
     Property Time : TTime Read FTime;
  end;

Var
   Score : TScore;

implementation

Uses
   FMX.Ani,
   uImages;

{$R *.fmx}

{ TFrame1 }

constructor TScore.Create(aOwner: TComponent);
begin
inherited;
FTime           := 0;
FTimer          := TTimer.Create(Self);
FTimer.Enabled  := False;
FTimer.Interval := 100;
FTimer.OnTimer  := UpdateTime;
ShowFlags(0);
end;

procedure TScore.ShowIn(aControl: TControl);
begin
Parent     := aControl;
Position.x := (aControl.Width-Width)/2;
Position.Y := -Height-2;
TAnimator.AnimateFloat(Self, 'Position.Y', 20, 1, TAnimationType.Out, TInterpolationType.Back);
ShowTime ('00:00:00');
ShowFlags(0);
end;

procedure TScore.HideScore;
begin
TAnimator.AnimateFloat(Self, 'Position.Y', -Height-2, 1, TAnimationType.Out, TInterpolationType.Back);
TThread.CreateAnonymousThread(
   Procedure
   Begin
   Sleep(420);
   TThread.Synchronize(Nil,
      Procedure
      Begin
      Parent := Nil;
      End);
   End).Start;
end;

procedure TScore.IncTime(aSec: Integer);
begin
If aSec <= 60 Then
   FTime := FTime + StrToTime('00:00:'+FormatFloat('00', aSec));
end;

procedure TScore.ShowMines(aMines: Integer);
Var
   LBitmap : TBitmap;
begin
LBitmap := Images.GetText(aMines.ToString);
ImgMinesCount.Bitmap.Assign(LBitmap);
LBitmap.Free;
end;

procedure TScore.ShowFlags(aFlags: Integer);
Var
   LBitmap : TBitmap;
begin
LBitmap := Images.GetText(aFlags.ToString);
ImgFlagCount.Bitmap.Assign(LBitmap);
LBitmap.Free;
end;

procedure TScore.ShowTime(aTime : string);
Var
   LBitmap : TBitmap;
begin
LBitmap := Images.GetText(aTime);
ImgTime.Bitmap.Assign(LBitmap);
LBitmap.Free;
end;

procedure TScore.StartTime;
begin
FTime          := StrToTime('00:00:00');
FTimeStr       := FormatDateTime('hh:nn:ss', Time);
FTimer.Enabled := True;
end;

procedure TScore.StopTime;
begin
FTimer.Enabled := False;
end;

procedure TScore.ResumeTime;
begin
FTimer.Enabled := True;
end;

procedure TScore.UpdateTime(Sender: TObject);
Var
   LTime : String;
begin
LTime := FormatDateTime('hh:nn:ss', Now);
If FTimeStr <> LTime Then
   Begin
   FTimer.Enabled := False;
   FTime          := FTime + StrToTime('00:00:01');
   ShowTime(FormatDateTime('hh:nn:ss', FTime));
   FTimer.Enabled := True;
   FTimeStr       := LTime;
   End;
end;

end.
