program MineSweeper;



{$R 'Media.res' 'Media.rc'}

uses
  System.StartUpCopy,
  FMX.Forms,
  uMineSweeper in 'uMineSweeper.pas' {Form5},
  uField in 'uField.pas',
  uField.View in 'uField.View.pas' {FieldView: TFrame},
  uImages in 'uImages.pas',
  uStartScreen in 'uStartScreen.pas' {StartScreen: TFrame},
  uInstructions in 'uInstructions.pas' {Instructions: TFrame},
  uArrow in 'Resources\uArrow.pas' {Arrow: TFrame},
  uSelector in 'Resources\uSelector.pas' {Selector: TFrame},
  uButton in 'Resources\uButton.pas' {GameButton: TFrame},
  uGameInterfaces in 'uGameInterfaces.pas',
  uLose in 'uLose.pas' {Lose: TFrame},
  uWin in 'uWin.pas' {Win: TFrame},
  uGameScore in 'uGameScore.pas' {Score: TFrame},
  uGameActions in 'uGameActions.pas' {Actions: TFrame},
  uPause in 'uPause.pas' {Pause: TFrame},
  uMedia in 'uMedia.pas',
  uConfig in 'uConfig.pas' {Config: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
