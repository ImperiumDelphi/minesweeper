unit uField;

interface

Uses
   System.Classes,
   System.UITypes,
   System.Types,
   FMX.Controls,
   FMX.Types,
   FMX.Ani,
   uGameInterfaces;

Type

   TField = Class(TFMXObject)
      Private
         FField      : TFieldArray;
         FOpacities  : TFieldArrayF;
         FEffects    : TFieldArrayEFfects;
         FColors     : TFieldArrayColors;
         FDifficulty : TFieldDifficulty;
         FSize       : TFieldSize;
         FOnMine     : TClickPosition;
         FOnFinish   : TClickPosition;
         FLastPoint  : TPoint;
         Procedure ClearField;
         procedure SetDifficulty(const Value: TFieldDifficulty);
         procedure SetSize      (const Value: TFieldSize);
         function  GetFlagsCount: Integer;
      Public
         Constructor Create(aOwner : TComponent); Override;
         Destructor Destroy; Override;
         Procedure GenerateField;
         procedure Open            (aX, aY : Integer);
         procedure Flag            (aX, aY : Integer);
         procedure UnFlag          (aX, aY : Integer);
         Procedure SetField        (aX, aY : Integer; aValue   : Byte);
         Procedure SetEffect       (aX, aY : Integer; aEffect  : TFieldEffects);
         Procedure SetEffectColor  (aX, aY : Integer; aColor   : TAlphaColor);
         Procedure SetEffectOpacity(aX, aY : Integer; aOpacity : Single);
         procedure CheckFinish;
         Function GetSize  : Integer;
         Function GetMines : Integer;
         Function GetSafePoint : TPoint;
         Property Size       : TFieldSize         Read FSize          Write SetSize;
         Property Difficulty : TFieldDifficulty   Read FDifficulty    Write SetDifficulty;
         Property Field      : TFieldArray        Read FField         Write FField;
         Property Effects    : TFieldArrayEffects Read FEffects;
         Property Opacities  : TFieldArrayF       Read FOpacities;
         Property Colors     : TFieldArrayColors  Read FColors;
         Property FlagsCount : Integer            Read GetFlagsCount;
         Property MinesCount : Integer            Read GetMines;
         Property OnMine     : TClickPosition     Read FOnMine        Write FOnMine;
         Property OnFinish   : TClickPosition     Read FOnFinish      Write FOnFinish;
      End;

Var
   Field : TField;

implementation

Uses
   System.SysUtils,
   uImages,
   uField.View;

{ TField }

//     Valores para os campos
//
//            0 - Campo aberto não explorado
//          200 - Campo aberto Explodado
//       1..  8 - Indicadores de Minas não mostardos
//     201..208 - Indicadores de Minas mostrados
//          250 - Flag
//           50 - Mina oculta


//    Valores para Efeitos
//
//            0 - Nada
//            1 - Opacidade
//            2 - Reatngulo
//            3 - Radar


constructor TField.Create(aOwner : TComponent);
begin
Inherited;
Randomize;
ClearField;
FDifficulty := TFieldDifficulty.fdMedium;
FSize       := TFieldSize     .fsMedium;
GenerateField;
end;

destructor TField.Destroy;
begin
inherited;
end;

procedure TField.Flag(aX, aY: Integer);
begin
FField[aX, aY] := FField[aX, aY] + 100;
end;

procedure TField.UnFlag(aX, aY: Integer);
begin
FField[aX, aY] := FField[aX, aY] - 100;
end;

procedure TField.ClearField;
Var
   Lx, Ly : Integer;
Begin
For Ly := 1 To GetSize Do
   For Lx := 1 To GetSize Do
      Begin
      FField    [Lx, Ly] := 0;
      FOpacities[Lx, Ly] := 0;
      FColors   [Lx, Ly] := TAlphaColors.Null;
      FEffects  [Lx, Ly] := TFieldEffects.feNome;
      End;
end;

procedure TField.GenerateField;

   Procedure GenerateMinePos(aLinCol : Integer);
   Var
      Lx, LY : Integer;
   Begin
   Repeat
      Lx := Random(aLinCol-1)+1;
      Ly := Random(aLinCol-1)+1;
      Until FField[Lx, Ly] = 0;
   FField[Lx, Ly] := 50;
   End;

   Procedure GenerateMineInformation(aLinCol : Integer);
   Var
      Lx, Ly : Integer;
      LQtd   : Byte;
   Begin
   For Ly := 1 To aLinCol Do
      For Lx := 1 To aLinCol Do
         If FField[Lx, Ly] <> 50 Then
            Begin
            LQtd := 0;
            If FField[Lx-1, Ly-1] = 50 Then Inc(LQtd);
            If FField[Lx-1, Ly  ] = 50 Then Inc(LQtd);
            If FField[Lx-1, Ly+1] = 50 Then Inc(LQtd);
            If FField[Lx+1, Ly-1] = 50 Then Inc(LQtd);
            If FField[Lx+1, Ly  ] = 50 Then Inc(LQtd);
            If FField[Lx+1, Ly+1] = 50 Then Inc(LQtd);
            If FField[Lx  , Ly-1] = 50 Then Inc(LQtd);
            If FField[Lx  , Ly+1] = 50 Then Inc(LQtd);
            FField[Lx, Ly] := LQtd;
            End;
   End;

Var
   i : Integer;
begin
ClearField;
For i := 1 To GetMines Do
   GenerateMinePos(GetSize);
GenerateMineInformation(GetSize);
end;

function TField.GetFlagsCount: Integer;
Var
   LX, LY  : Integer;
Begin
Result := 0;
For Ly := 1 To GetSize Do
   For Lx := 1 To GetSize Do
      If FField[Lx, Ly] In [100..150] Then
         Inc(Result);
end;

function TField.GetMines: Integer;
begin
Result := 0;
Case Difficulty Of
   fdVeryEasy  : Result := Trunc(GetSize / 2);
   fdEasy      : Result := GetSize;
   fdMedium    : Result := GetSize * 2;
   fdHard      : Result := GetSize * 3;
   fdVeryHard  : Result := GetSize * 4;
   End;
end;

function TField.GetSafePoint: TPoint;
Var
   LX : Integer;
   LY : Integer;
   LC : Integer;
begin
Lc := 0;
For LY := 1 To GetSize Do
   For LX := 1 To GetSize Do
      If FField[LX, LY] = 0 Then
         Inc(LC);
Result := TPoint.Create(-1, -1);
If LC > 0 Then
   Begin
   Repeat
      LX := Random(GetSize-1)+1;
      LY := Random(GetSize-1)+1;
      Until FField[LX, LY] = 0;
   Result := TPoint.Create(LX, LY);
   End;
end;

function TField.GetSize: Integer;
begin
Result := 0;
Case Size Of
   fsVerySmall : Result := 8;
   fsSmall     : Result := 10;
   fsMedium    : Result := 12;
   fsLarge     : Result := 16;
   fsVeryLarge : Result := 18;
   End;
end;

Procedure TField.CheckFinish;
Var
   LX, LY  : Integer;
Begin
Ly := 1;
While Ly < GetSize Do
   begin
   Lx := 1;
   While Lx < GetSize Do
      Begin
      If FField[LX, LY] In [0..8, 50, 100, 250] Then
         Exit;
      Lx := Lx + 1;
      End;
   Ly := Ly + 1;
   end;
If Assigned(FOnFinish) Then FOnFinish(TMouseButton.mbLeft, FLastPoint.X, FLastPoint.Y, 0);
End;

procedure TField.Open(aX, aY: Integer);

   Procedure DoOpen(aX, aY : Integer);
   Begin
   If (aX < 1) Or (aY < 1) or (aX > GetSize) Or (aY > GetSize) Then Exit;
   If FField[aX, aY] = 0 Then
      Begin
      FField[aX, aY] := 200;
      DoOpen(aX-1, aY-1);
      DoOpen(aX-1, aY);
      DoOpen(aX-1, aY+1);
      DoOpen(aX+1, aY-1);
      DoOpen(aX+1, aY);
      DoOpen(aX+1, aY+1);
      DoOpen(aX,   aY-1);
      DoOpen(aX,   aY+1);
      End;
   End;

   Procedure DoOpenInformation(aX, aY : Integer);
   Var
      LX, LY : Integer;
   Begin
   For LY := 1 To GetSize Do
      For LX := 1 To GetSize Do
         If FField[LX, LY] = 200 Then
            Begin
            If FField[Lx-1, Ly-1] In [1..8] Then FField[Lx-1, Ly-1] := FField[Lx-1, Ly-1] + 200;
            If FField[Lx-1, Ly  ] In [1..8] Then FField[Lx-1, Ly  ] := FField[Lx-1, Ly  ] + 200;
            If FField[Lx-1, Ly+1] In [1..8] Then FField[Lx-1, Ly+1] := FField[Lx-1, Ly+1] + 200;
            If FField[Lx+1, Ly-1] In [1..8] Then FField[Lx+1, Ly-1] := FField[Lx+1, Ly-1] + 200;
            If FField[Lx+1, Ly  ] In [1..8] Then FField[Lx+1, Ly  ] := FField[Lx+1, Ly  ] + 200;
            If FField[Lx+1, Ly+1] In [1..8] Then FField[Lx+1, Ly+1] := FField[Lx+1, Ly+1] + 200;
            If FField[Lx  , Ly-1] In [1..8] Then FField[Lx  , Ly-1] := FField[Lx  , Ly-1] + 200;
            If FField[Lx  , Ly+1] In [1..8] Then FField[Lx  , Ly+1] := FField[Lx  , Ly+1] + 200;
            End;
   End;

begin
FLastPoint := TPoint.Create(aX, aY);
If FField[aX, aY] = 0 Then
   Begin
   DoOpen(Ax, aY);
   DoOpenInformation(aX, aY);
   End;
If FField[aX, aY] In [1..8] Then
   FField[aX, aY] := FField[aX, aY] + 200;
If FField[ax, aY] = 50 Then
   Begin
   FField[aX, aY] := 250;
   If Assigned(FOnMine) Then
      FOnMine(TMouseButton.mbLeft, aX, aY, 50);
   End;
end;

procedure TField.SetSize(const Value: TFieldSize);
begin
FSize := Value;
GenerateField;
end;

procedure TField.SetDifficulty(const Value: TFieldDifficulty);
begin
FDifficulty := Value;
GenerateField;
end;

procedure TField.SetEffect(aX, aY: Integer; aEffect: TFieldEffects);
begin
FEffects[aX, aY] := aEffect;
end;

procedure TField.SetEffectColor(aX, aY: Integer; aColor: TAlphaColor);
begin
FColors[aX, aY] := aColor;
end;

procedure TField.SetEffectOpacity(aX, aY: Integer; aOpacity: Single);
begin
FOpacities[aX, aY] := aOpacity;
end;

procedure TField.SetField(aX, aY: Integer; aValue: Byte);
begin
FField[aX, aY] := aValue;
end;

end.
