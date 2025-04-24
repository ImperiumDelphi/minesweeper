unit uMineSweeper;

(*
Nota sobre a Indentação do Código

Olá! Se você está analisando o código-fonte do Minesweeper: Operação Ilha Perdida,
talvez tenha notado que a indentação segue um estilo um pouco diferente do padrão moderno
usado no Delphi. Há uma razão para isso: eu programo em Pascal desde 1986, uma época em que
desenvolvíamos em micros domésticos de 8 bits com telas pequenas e limitações técnicas. Para
facilitar a leitura e o desenvolvimento naquele contexto, adotei uma indentação própria que
se tornou parte do meu fluxo de trabalho ao longo de quase quatro décadas. Entendo que esse
estilo pode não agradar a todos, especialmente se você está acostumado com as convenções
atuais do Delphi. No entanto, peço que não critique essa escolha — ela reflete minha trajetória
e as condições em que aprendi a programar. Se preferir um formato mais padrão, o Delphi oferece
uma solução simples: basta usar o atalho Ctrl+D para reformatar o código automaticamente de
acordo com as configurações de indentação do ambiente. Assim, você pode ajustá-lo ao seu gosto
sem esforço. Este projeto foi feito com muito carinho para uma competição de programação, e
espero que você aproveite tanto o jogo quanto o aprendizado que o código pode oferecer.

Obrigado pela compreensão e por apoiar meu trabalho!



Note on Code Indentation

Hello! If you're checking out the source code for Minesweeper: Lost Island Operation,
you might have noticed that the indentation follows a style that's a bit different from the modern
standards used in Delphi. There's a reason for that: I've been programming in Pascal since 1986,
a time when we developed on 8-bit home computers with tiny screens and technical limitations. To
make coding and reading easier in that environment, I developed my own indentation style, which
has become a core part of my workflow over nearly four decades. I understand that this style might
not be to everyone's liking, especially if you're used to the current Delphi conventions. However,
I kindly ask that you refrain from criticizing this choice—it reflects my journey and the conditions
under which I learned to code. If you prefer a more standard format, Delphi offers an easy
solution: simply use the Ctrl+D shortcut to automatically reformat the code according to the
environment's indentation settings. This way, you can adjust it to your preference with minimal
effort. This project was created with a lot of care for a programming competition, and I hope you
enjoy both the game and the learning experience the code can provide.

Thank you for your understanding and for supporting my work!
*)


interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Objects,
  uGameInterfaces;

type
  TForm5 = class(TForm, IMinesweeper)
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
  private
    FStarted : Boolean;
    procedure ClickField(aButton : TMouseButton; aX, aY, aValue : Integer);
    procedure Mine(aButton: TMouseButton; aX, aY, aValue: Integer);
    procedure Finish(aButton: TMouseButton; aX, aY, aValue: Integer);
    Procedure CentralizeMap;
    Function SetDifficulty(aValue : TFieldDifficulty) : IMinesweeper;
    Function SetFieldSize (aValue : TFieldSize)      : IMinesweeper;
    Procedure StartGame;
    Procedure StartTime;
    Procedure ShowStartScreen;
    Procedure Terminate;
  public
  end;

var
  Form5: TForm5;

implementation

Uses
   uField,
   uField.View,
   uStartScreen,
   uConfig,
   uImages,
   uMedia,
   uPause,
   uLose,
   uWin,
   uInstructions,
   uGameScore,
   uGameActions;

{$R *.fmx}

procedure TForm5.StartTime;
begin
If Not FStarted Then
   Begin
   FStarted := True;
   Score.StartTime;
   End;
end;

procedure TForm5.ClickField(aButton : TMouseButton; aX, aY, aValue: Integer);
begin
StartTime;
Media.Click1;
If aButton = TMouseButton.mbLeft  Then
   Field.Open(aX, aY);
If (aButton = TmouseButton.mbRight) And (aValue in [0..50]) Then
   Field.Flag(aX, aY);
If (aButton = TmouseButton.mbRight) And (aValue in [100..150]) Then
   Field.UnFlag(aX, aY);
Field.CheckFinish;
FieldView.Repaint;
Score.ShowFlags(Field.FlagsCount);
end;

function TForm5.SetDifficulty(aValue: TFieldDifficulty): IMinesweeper;
begin
Result            := Self;
Field.Difficulty := aValue;
end;

function TForm5.SetFieldSize(aValue: TFieldSize): IMinesweeper;
begin
Result     := Self;
Field.Size := aValue;
end;

procedure TForm5.CentralizeMap;
begin
StartScreen.CentralizeMap;
end;

procedure TForm5.ShowStartScreen;
begin
StartScreen.FlashFields   := True;
StartScreen.ShowMessage;
StartScreen.SelectedField := -1;
end;

procedure TForm5.StartGame;
begin
FStarted                := False;
StartScreen.FlashFields := False;
StartScreen.HideMessage;
StartScreen.CentralizeField(StartSCreen.SelectedField);
Field      .GenerateField;
FieldView  .OnClickPosition := ClickField;
FieldView  .SetField(Field);
FieldView  .ShowIn(Self);
Score      .ShowIn(StartScreen);
Score      .ShowMines(Field.MinesCount);
Actions    .ShowIn(StartScreen);
TThread.CreateAnonymousThread(
   Procedure
   begin
   Sleep(1500);
   TThread.Queue(Nil,
      Procedure
      Begin
      Media.PlayRandom;
      End);
   end).Start;
end;

procedure TForm5.Finish(aButton : TMouseButton; aX, aY, aValue: Integer);
begin
Score.StopTime;
Media.PlayApplause;
Win.ShowIn(Self);
TThread.CreateAnonymousThread(
   Procedure
   Begin
   Sleep(2500);
   TThread.Synchronize(Nil,
      Procedure
      Begin
      FieldView.HideFrame;
      Score    .HideScore;
      Actions  .HideActions;
      End);
   End).Start;
end;

procedure TForm5.Mine(aButton : TMouseButton; aX, aY, aValue: Integer);
begin
Score    .StopTime;
Images   .DoExplode(FieldView, FieldView.ClickPos);
FieldView.ShowMines;
Media.StopRandom;
TThread.CreateAnonymousThread(
   Procedure
   Begin
   Sleep(1000);
   TThread.Synchronize(Nil,
      Procedure
      Begin
      Lose.ShowIn(Self);
      End);
   Sleep(2500);
   TThread.Synchronize(Nil,
      Procedure
      Begin
      FieldView.HideFrame;
      Score    .HideScore;
      Actions  .HideActions;
      End);
   End).Start;
end;

procedure TForm5.Terminate;
begin
Score    .StopTime;
FieldView.ShowMines;
Media.StopRandom;
TThread.CreateAnonymousThread(
   Procedure
   Begin
   Sleep(1500);
   TThread.Synchronize(Nil,
      Procedure
      Begin
      FieldView.HideFrame;
      Score    .HideScore;
      Actions  .HideActions;
      End);
   Sleep(500);
   TThread.Synchronize(Nil,
      Procedure
      Begin
      CentralizeMap;
      ShowStartScreen;
      End);
   End).Start;
end;

procedure TForm5.FormCreate(Sender: TObject);
begin
Images            := TImages.Create;
Field             := TField .Create(Self);
Field.Size        := TFieldSize      .fsMedium;
Field.Difficulty  := TFieldDifficulty.fdHard;
Field.OnMine      := Mine;
Field.OnFinish    := Finish;
Media             := TMedia       .Create(Self);
StartScreen       := TStartScreen .Create(Self);
Config            := TConfig      .Create(Self);
FrameInstructions := TInstructions.Create(Self);
FieldView         := TFieldView   .Create(Self);
Lose              := TLose        .Create(Self);
Win               := TWin         .Create(Self);
Pause             := TPause       .Create(Self);
Score             := TScore       .Create(Self);
Actions           := TActions     .Create(Self);
StartScreen.ShowIn(Self);
end;

end.
