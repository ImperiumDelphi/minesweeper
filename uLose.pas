unit uLose;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Objects, FMX.Effects;

type
  TLose = class(TFrame)
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Image1: TImage;
  private
  public
    Procedure ShowIn(aControl : TForm);
  end;

Var
   Lose : TLose;

implementation

Uses
   FMX.Ani,
   uGameInterfaces;

{$R *.fmx}


{ TLose }

procedure TLose.ShowIn(aControl: TForm);
begin
Parent := aControl;
Position.X := (aControl.Width  - Width)/2;
Position.Y := (aControl.Height - Height)/2;
BringToFront;
Opacity := 0;
TAnimator.AnimateFloat(Self, 'Opacity', 1, 0.5);
TThread.CreateAnonymousThread(
   Procedure
   Begin
   Sleep(5000);
   TTHread.Synchronize(Nil,
      Procedure
      Begin
      TAnimator.AnimateFloat(Self, 'Opacity', 0 , 0.5);
      End);
   Sleep(510);
   TTHread.Synchronize(Nil,
      Procedure
      Begin
      Parent := Nil;
      (Owner as IMinesweeper).CentralizeMap;
      (Owner as IMinesweeper).ShowStartScreen;
      End);
   End).Start;
end;

end.
