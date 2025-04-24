unit uPause;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Objects;

type
  TPause = class(TFrame)
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Image1: TImage;
    Background: TRectangle;
    procedure BackgroundClick(Sender: TObject);
  private
    FProc : TProc;
  public
    Procedure ShowIn(aControl : TComponent; aProc : TProc);
    Procedure CloseFrame;
  end;

Var
   Pause : TPause;

implementation

{$R *.fmx}

{ TPause }

procedure TPause.BackgroundClick(Sender: TObject);
begin
CloseFrame;
end;

procedure TPause.CloseFrame;
begin
Parent := Nil;
FProc;
end;

procedure TPause.ShowIn(aControl: TComponent; aProc : TProc);
begin
FProc  := aProc;
Parent := aControl As TFMXObject;
Align  := TAlignLayout.Contents;
BringToFront;
end;

end.
