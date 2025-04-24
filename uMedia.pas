unit uMedia;

interface

uses
  System.Classes,
  FMX.Media;

Type

   TMedia = Class(TComponent)
      Private
         FMedia        : TArray<TMediaPlayer>;
         FPath         : String;
         FRadarBeep    : Integer;
         FApplause     : Integer;
         FGameMusic    : Integer;
         FStartMusic   : Integer;
         FAirplane     : Integer;
         FButtonClick  : Integer;
         FExplosion    : Integer;
      Public
         Constructor Create(aOwner : TComponent); Override;
         Procedure StopAll;
         Procedure Click1;
         Procedure Click2;
         Procedure Click3;
         Procedure SonarPulse;
         Procedure AirPlane;
         Procedure Explosion;
         Procedure PlayRandom;
         Procedure StopRandom;
         Procedure PlayApplause;
         Procedure ChooseField;
         Procedure ChooseFieldOut;
         Procedure LoadVolumes;
         Procedure SaveVolumes;
         Property VolumeStartMusic  : Integer Read FStartMusic   Write FStartMusic;
         Property VolumeGameMusic   : Integer Read FGameMusic    Write FGameMusic;
         Property VolumeAirplane    : Integer Read FAirplane     Write FAirplane;
         Property VolumeExplosion   : Integer Read FExplosion    Write FExplosion;
         Property VolumeApplause    : Integer Read FApplause     Write FApplause;
         Property VolumeRadarBeep   : Integer Read FRadarBeep    Write FRadarBeep;
         Property VolumeButtonClick : Integer Read FButtonClick  Write FButtonClick;
      End;

Var

   Media : TMedia;

implementation

uses
  System.Types,
  System.IOUtils,
  System.StrUtils,
  System.SysUtils,
  FMX.Ani;

{ TMedia }

constructor TMedia.Create(aOwner: TComponent);

   Procedure TestMediaFiles;

      Procedure TestResource(aResName : String);
      var
         LResStream : TResourceStream;
         LFile      : String;
      begin
      LFile := TPath.Combine(FPath, aResName+'.mp3');
      If Not FileExists(LFile) Then
         Begin
         LResStream := TResourceStream.Create(HInstance, aResName, RT_RCDATA);
         LResStream.SaveToFile(LFile);
         End;
      End;

   Begin
   FPath := TPath.Combine(TPath.GetDocumentsPath, 'GameAudio');
   If Not DirectoryExists(FPath) Then
      CreateDir(FPath);
   TestResource('AirPlane1');
   TestResource('AirPlane2');
   TestResource('Bomb');
   TestResource('StartScreen');
   TestResource('Applause');
   TestResource('Click1');
   TestResource('Click2');
   TestResource('Click3');
   TestResource('Radar');
   TestResource('Music1');
   TestResource('Music2');
   TestResource('Music3');
   TestResource('Music4');
   TestResource('Music5');
   TestResource('Music6');
   TestResource('Music7');
   TestResource('Music8');
   TestResource('Music9');
   TestResource('Music10');
   TestResource('Music11');
   TestResource('Music12');
   TestResource('Music13');
   TestResource('Music14');
   TestResource('Music15');
   End;

Var
   i : Integer;

begin
inherited;
TestMediaFiles;
SetLength(FMedia, 7);
For i := 0 To 6 Do
   FMedia[i] := TmediaPlayer.Create(Self);
LoadVolumes;
FMedia[0].FileName := TPath.Combine(FPath, 'Click1.mp3');
FMedia[1].FileName := TPath.Combine(FPath, 'Click2.mp3');
FMedia[2].FileName := TPath.Combine(FPath, 'Click3.mp3');
FMedia[3].FileName := TPath.Combine(FPath, 'AirPlane2.mp3');
FMedia[5].FileName := TPath.Combine(FPath, 'StartScreen.mp3');
end;

procedure TMedia.LoadVolumes;
Var
   LText : TStringList;
   LFile : String;
begin
LText := TStringList.Create;
LFile := TPath.Combine(FPath, 'volumes.txt');
If FileExists(LFile) Then
   LText.LoadFromFile(LFile)
Else
   begin
   LText.Clear;
   LText.Add('8');
   LText.Add('8');
   LText.Add('7');
   LText.Add('7');
   LText.Add('8');
   LText.Add('8');
   LText.Add('8');
   LText.SaveToFile(LFile);
   end;
FRadarBeep   := LText[0].ToInteger;
FApplause    := LText[1].ToInteger;
FGameMusic   := LText[2].ToInteger;
FStartMusic  := LText[3].ToInteger;
FAirplane    := LText[4].ToInteger;
FButtonClick := LText[5].ToInteger;
FExplosion   := LText[6].ToInteger;
LText.Free;
end;

procedure TMedia.SaveVolumes;
Var
   LText : TStringList;
   LFile : String;
begin
LText := TStringList.Create;
LFile := TPath.Combine(FPath, 'volumes.txt');
LText.Clear;
LText.Add(VolumeRadarBeep  .ToString);
LText.Add(VolumeApplause   .ToString);
LText.Add(VolumeGameMusic  .ToString);
LText.Add(VolumeStartMusic .ToString);
LText.Add(VolumeAirplane   .ToString);
LText.Add(VolumeButtonClick.ToString);
LText.Add(VolumeExplosion  .ToString);
LText.SaveToFile(LFile);
end;

procedure TMedia.StopAll;
Var
   i : Integer;
begin
For i := 0 To 5 Do
   Begin
   FMedia[i].Stop;
   FMedia[i].Clear;
   End;
end;

procedure TMedia.Click1;
begin
FMedia[0].Volume      := FButtonClick*0.1;
FMedia[0].CurrentTime := 0;
FMedia[0].Play;
end;

procedure TMedia.Click2;
begin
FMedia[1].Volume      := FButtonClick*0.1;
FMedia[1].CurrentTime := 0;
FMedia[1].Play;
end;

procedure TMedia.Click3;
begin
FMedia[2].Volume      := FButtonClick*0.1;
FMedia[2].CurrentTime := 0;
FMedia[2].Play;
end;

procedure TMedia.AirPlane;
begin
FMedia[3].Volume      := FAirplane*0.1;
FMedia[3].CurrentTime := 0;
FMedia[3].Play;
end;

procedure TMedia.Explosion;
begin
FMedia[4].FileName    := TPath.Combine(FPath, 'Bomb.mp3');
FMedia[4].Volume      := FExplosion*0.1;
FMedia[4].CurrentTime := 0;
FMedia[4].Play;
end;

procedure TMedia.PlayApplause;
begin
FMedia[4].FileName    := TPath.Combine(FPath, 'Applause.mp3');
FMedia[4].Volume      := FApplause*0.1;
FMedia[4].CurrentTime := 0;
FMedia[4].Play;
end;

procedure TMedia.SonarPulse;
begin
FMedia[4].FileName    := TPath.Combine(FPath, 'Radar.mp3');
FMedia[4].Volume      := FRadarBeep*0.1;
FMedia[4].CurrentTime := 0;
FMedia[4].Play;
end;

procedure TMedia.ChooseField;
begin
FMedia[5].Volume      := 0;
FMedia[5].CurrentTime := 0;
FMedia[5].Play;
TAnimator.AnimateFloat(FMedia[5], 'Volume', FStartMusic*0.1, 1);
TThread.CreateAnonymousThread(
   Procedure
   Begin
   Sleep(FMedia[5].Duration+2000);
   TThread.Queue(Nil,
      Procedure
      Begin
      If FMedia[5].CurrentTime > 0 Then
         ChooseField;
      End);
   End).Start;
end;

procedure TMedia.ChooseFieldOut;
begin
TAnimator.AnimateFloat(FMedia[5], 'Volume', 0, 1);
TThread.CreateAnonymousThread(
   Procedure
   Begin
   Sleep(1100);
   If FMedia[5].State = TMediaState.Playing Then
      TThread.Queue(Nil,
         Procedure
         Begin
         FMedia[5].Stop;
         FMedia[5].CurrentTime := 0;
         End);
   End).Start;
end;

procedure TMedia.PlayRandom;
begin
FMedia[6].Stop;
FMedia[6].FileName := TPath.Combine(FPath, 'Music'+Trunc(Random(14)+1).ToString+'.mp3');
FMedia[6].Volume      := 0;
FMedia[6].CurrentTime := 0;
FMedia[6].Play;
TAnimator.AnimateFloat(FMedia[6], 'Volume', FGameMusic*0.1, 1);
TThread.CreateAnonymousThread(
   Procedure
   Begin
   Sleep(FMedia[6].Duration+2000);
   TThread.Queue(Nil,
      Procedure
      Begin
      If FMedia[6].CurrentTime > 0 Then
         PlayRandom;
      End);
   End).Start;
end;

procedure TMedia.StopRandom;
begin
TAnimator.AnimateFloat(FMedia[6], 'Volume', 0, 1);
TThread.CreateAnonymousThread(
   Procedure
   Begin
   Sleep(1100);
   If FMedia[6].State = TMediaState.Playing Then
      TThread.Queue(Nil,
         Procedure
         Begin
         FMedia[6].Stop;
         FMedia[6].CurrentTime := 0;
         End);
   End).Start;

end;




end.
