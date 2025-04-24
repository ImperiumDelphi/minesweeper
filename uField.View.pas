unit uField.View;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects,
  uGameInterfaces,
  uField;

type

  TFieldView = class(TFrame)
     private
        FField           : TField;
        FBackground      : TBitmap;
        FOnClickPosition : TClickPosition;
        FClickPos        : TPointF;
        FMouseDown       : Boolean;
        FDownTick        : Cardinal;
        FRadarColor      : TAlphaColor;
        procedure SetRadarColor(const Value: TAlphaColor);
        procedure DoClick(aButton: TMouseButton);
     Protected
        Procedure Paint; Override;
        procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single); Override;
        procedure MouseUp  (Button: TMouseButton; Shift: TShiftState; X, Y: Single); Override;
     public
        Constructor Create(aOwner : TComponent); Override;
        Procedure ShowMines;
        Procedure SetField     (aValue : TField);
        Procedure SetBackground(aValue : TBitmap);
        Procedure ShowIn(aControl : TFMXObject);
        Procedure HideFrame;
        Procedure RadarPulse;
        Property OnClickPosition : TClickPosition Read FOnClickPosition Write FOnClickPosition;
        Property ClickPos        : TPointF        Read FClickPos;
        Property RadarColor      : TAlphaColor    Read FRadarColor       Write SetRadarColor;
     end;

Var
   FieldView : TFieldView;

implementation

uses
  FMX.Ani,
  uGameScore,
  uImages;

{$R *.fmx}

{ TFieldView }

constructor TFieldView.Create(aOwner: TComponent);
begin
inherited;
FRadarColor := TAlphaColors.Black;
end;

procedure TFieldView.HideFrame;
begin
Parent := Nil;
end;

Procedure TFieldView.DoClick(aButton : TMouseButton);
Var
   Lx, Ly  : Integer;
   LSize   : Integer;
   LWidth  : Single;
   LHeight : Single;
Begin
If Assigned(FOnClickPosition) Then
   Begin
   If Assigned(FField) Then
      begin
      LSize   := FField.GetSize;
      LWidth  := Width/LSize;
      LHeight := Height/LSize;
      Lx      := Trunc(FClickPos.X / LWidth)+1;
      LY      := Trunc(FClickPos.Y / LHeight)+1;
      FOnClickPosition(aButton, Lx, Ly, FField.Field[Lx, Ly]);
      end;
   End;
End;

procedure TFieldView.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
inherited;
FMouseDown := True;
FDownTick  := TThread.GetTickCount;
TThread.CreateAnonymousThread(
   Procedure
   Begin
   While FMouseDown And Not(Application.Terminated) Do
      Begin
      If TThread.GetTickCount - FDownTick >= 400 Then
         Begin
         FMouseDown := False;
         FClickPos  := TPointF.Create(x, y);
         DoClick(TMouseButton.mbRight);
         End;
      End;
   End).Start;
end;

procedure TFieldView.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
inherited;
If Not FMouseDown Then Exit;
FMouseDown := False;
FClickPos  := TPointF.Create(x, y);
DoClick(Button);
end;

procedure TFieldView.Paint;
Var
   Lx, Ly       : Integer;
   LSize        : Integer;
   LWidth       : Single;
   LHeight      : Single;

   Procedure DrawBase(Lx, Ly : Integer);
   Var
      LRect        : TRectF;

      Procedure DrawClose;
      Begin
      Canvas.Fill.Color := TAlphaColors.Black;
      Canvas.FillRect(LRect, 0.2);
      End;

      Procedure DrawMineClose;
      Begin
      Canvas.Fill.Color := FRadarColor;
      Canvas.FillRect(LRect, 0.2);
      End;

      Procedure DrawOpen;
      Begin
//      Canvas.DrawBitmap(Images.GramaClara, Images.GramaClara.BoundsF, LRect, 0.3);
      End;

      Procedure DrawElement(aOpacity : Single = 0.2);
      Begin
      Canvas.Fill.Color := TAlphaColors.White;
      If FField.Effects[Lx, Ly] <> TFieldEffects.feNome Then
         Canvas.FillRect(LRect, aOpacity)
      Else
         Canvas.FillRect(LRect, aOpacity);
      End;

      Procedure DrawInformation;
      Var
         LNumber : Integer;
      Begin
      DrawElement(0.3);
      LNumber := FField.Field[Lx, Ly]-200;
      case LNumber of
         1: Canvas.Fill.Color := TAlphaColors.Blue;      // Azul
         2: Canvas.Fill.Color := TAlphaColors.DarkGreen; // Verde
         3: Canvas.Fill.Color := TAlphaColors.Red;       // Vermelho
         4: Canvas.Fill.Color := TAlphaColors.Purple;    // Roxo escuro
         5: Canvas.Fill.Color := TAlphaColors.Maroon;    // Vermelho escuro (marrom)
         6: Canvas.Fill.Color := TAlphaColors.Teal;      // Ciano (turquesa)
         7: Canvas.Fill.Color := TAlphaColors.Black;     // Preto
         8: Canvas.Fill.Color := TAlphaColors.Gray;      // Cinza
      else
         Canvas.Fill.Color := TAlphaColors.Black;        // Padrão (se fora do intervalo)
         end;
      DrawOpen;
      Canvas.Font.Style := [TFontStyle.fsBold];
      Canvas.Font.Size  := LRect.Height-4;
      Canvas.FillText(LRect, LNumber.ToString, False, 1, [], TTextAlign.Center);
      End;

      Procedure DrawFlag;
      Begin
      DrawElement;
      Canvas.DrawBitmap(Images.Flag, Images.Flag.BoundsF, LRect, 1);
      End;

      Procedure DrawMine;
      Begin
      DrawElement;
      Canvas.DrawBitmap(Images.Mine, Images.Mine.BoundsF, LRect, 1);
      End;

   Begin
   LRect := TRectF.Create((Lx-1) * Lwidth, (Ly-1) * LHeight, Lx * Lwidth, Ly * LHeight);
   LRect.Inflate(-0.5, -0.5);
   If FField.Field[Lx, Ly] In [0  ..  8] Then DrawClose;
   If FField.Field[Lx, Ly] = 50          Then DrawMineClose;
   If FField.Field[Lx, Ly] In [100..150] Then DrawFlag;
   If FField.Field[Lx, Ly] = 200         Then DrawOpen;
   If FField.Field[Lx, Ly] In [201..208] Then DrawInformation;
   If FField.Field[Lx, Ly] = 250         Then DrawMine;
   End;

begin
inherited;
If Not Assigned(FField) Then Exit;
LSize                   := FField.GetSize;
LWidth                  := Width/LSize;
LHeight                 := Height/LSize;
Canvas.Stroke.Color     := TAlphaColors.Black;
Canvas.Stroke.Thickness := 1;
Canvas.Stroke.Kind      := TBrushKind.Solid;
Canvas.Fill.Color       := TAlphaColors.Lightgray;
For Ly := 1 To LSize Do
   For Lx := 1 To LSize Do
      Begin
      DrawBase  (Lx, Ly);
      End;
end;

procedure TFieldView.RadarPulse;
begin
FRadarColor := TAlphaColors.Black;
TAnimator.AnimateColor(Self, 'RadarColor', TAlphaColors.White, 0.2);
TThread.CreateAnonymousThread(
   Procedure
   Begin
   Sleep(220);
   TThread.Synchronize(Nil,
      Procedure
      Begin
      TAnimator.AnimateColor(Self, 'RadarColor', TAlphaColors.Black, 0.2);
      End);
   End).Start;
end;

procedure TFieldView.SetBackground(aValue: TBitmap);
begin
FBackground := aValue;
end;

procedure TFieldView.SetField(aValue: TField);
begin
FField := aValue;
Repaint;
end;

procedure TFieldView.SetRadarColor(const Value: TAlphaColor);
begin
FRadarColor := Value;
Repaint;
end;

procedure TFieldView.ShowIn(aControl: TFMXObJect);
Var
   LSize : Single;
begin
Parent := aControl;
If (aControl As IContainerObject).ContainerWidth < (aControl As IContainerObject).ContainerHeight Then
   LSize := (aControl As IContainerObject).ContainerWidth
Else
   LSize := (aControl As IContainerObject).ContainerHeight;
Width  := LSize * 0.9;
Height := Width;
Align  := TAlignLayout.Center;
end;

procedure TFieldView.ShowMines;
Var
   Lx, Ly  : Integer;
   LSize   : Integer;
begin
LSize := FField.GetSize;
For Ly := 1 To LSize Do
   For Lx := 1 To LSize Do
      If FField.Field[Lx, Ly] = 50 Then FField.SetField(Lx, Ly, 250);
Repaint;
end;

end.
