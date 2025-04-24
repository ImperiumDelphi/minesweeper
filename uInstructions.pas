unit uInstructions;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Objects, uSelector, uButton, FMX.Effects,
  FMX.Layouts;

type
  TInstructions = class(TFrame)
    Rectangle1: TRectangle;
    FieldName: TImage;
    Field1: TImage;
    Field2: TImage;
    Field3: TImage;
    Field4: TImage;
    Field5: TImage;
    FIeld6: TImage;
    Field7: TImage;
    Image: TRectangle;
    FieldSize: TSelector;
    FieldDifficulty: TSelector;
    Layout1: TLayout;
    ShadowEffect1: TShadowEffect;
    BtIniciar: TImage;
    BtCancelar: TImage;
    Image3: TImage;
    Image4: TImage;
    procedure BtCancelarClick(Sender: TObject);
    procedure BtIniciarClick(Sender: TObject);
  private
  public
    Constructor Create(aOwner : TComponent); Override;
    Procedure SetField(aValue : Integer);
    Procedure ShowIn(aControl : TControl);
    Procedure CloseFrame;
  end;

Var
   FrameInstructions : TInstructions;

implementation

Uses
   FMX.Ani,
   uImages,
   uMedia,
   uGameInterfaces;
{$R *.fmx}

{ TInstructions }

constructor TInstructions.Create(aOwner: TComponent);
begin
inherited;
FieldDifficulty.SetOptions([Images.VeryEasy,  Images.Easy,  Images.Medium, Images.Hard,  Images.VeryHard]);
FieldSize      .SetOptions([Images.VerySmall, Images.Small, Images.Medium, Images.Large, Images.VeryLarge]);
end;

procedure TInstructions.ShowIn(aControl: TControl);
begin
{$IF Defined(Android) Or Defined(iOS)}
Image.Align := TAlignLayout.Client;
{$ELSE}
Image.Align := TAlignLayout.Center;
{$ENDIF}
Parent     := aControl;
Width      := aControl.Width;
Height     := aControl.Width;
Position.X := 0;
Position.Y := aControl.Height+1;
TAnimator.AnimateFloat(Self, 'Position.Y', aControl.Height - Height, 0.5, TAnimationType.Out, TInterpolationType.Back);
end;

procedure TInstructions.CloseFrame;
begin
TAnimator.AnimateFloat(Self, 'Position.Y', (Parent As TControl).Height + Height+1 , 0.5, TAnimationType.In, TInterpolationType.Back);
TThread.CreateAnonymousThread(
   Procedure
   Begin
   Sleep(510);
   TThread.Queue(Nil, Procedure Begin Parent := Nil; End);
   End);
end;

procedure TInstructions.BtCancelarClick(Sender: TObject);
begin
media.Click3;
(Owner As IMinesweeper).ShowStartScreen;
Closeframe;
end;

procedure TInstructions.BtIniciarClick(Sender: TObject);
begin
media.Click3;
CloseFrame;
TThread.CreateAnonymousThread(
   procedure
   Begin
   Sleep(600);
   TThread.Synchronize(Nil,
      Procedure
      Begin
      (Owner As IMinesweeper)
         .SetDifficulty(TFieldDifficulty(FieldDifficulty.ItemIndex))
         .SetFieldSize(TFieldSize(FieldSize.ItemIndex))
         .StartGame;
      End);
   End).Start;
end;

procedure TInstructions.SetField(aValue: Integer);
begin
Case aValue Of
   1 : FieldName.Bitmap.Assign(Field1.Bitmap);
   2 : FieldName.Bitmap.Assign(Field2.Bitmap);
   3 : FieldName.Bitmap.Assign(Field3.Bitmap);
   4 : FieldName.Bitmap.Assign(Field4.Bitmap);
   5 : FieldName.Bitmap.Assign(Field5.Bitmap);
   6 : FieldName.Bitmap.Assign(Field6.Bitmap);
   7 : FieldName.Bitmap.Assign(Field7.Bitmap);
   End;
end;

end.
