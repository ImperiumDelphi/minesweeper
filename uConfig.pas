unit uConfig;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uSelector, FMX.Objects;

type
  TConfig = class(TFrame)
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    StartMusic: TSelector;
    GameMusic: TSelector;
    Airplane: TSelector;
    Explosion: TSelector;
    Applause: TSelector;
    RadarBeep: TSelector;
    ButtonClick: TSelector;
    BtSair: TImage;
    procedure BtSairClick(Sender: TObject);
  private
    F0  : TBitmap;
    F1  : TBitmap;
    F2  : TBitmap;
    F3  : TBitmap;
    F4  : TBitmap;
    F5  : TBitmap;
    F6  : TBitmap;
    F7  : TBitmap;
    F8  : TBitmap;
    F9  : TBitmap;
    F10 : TBitmap;
  public
    Constructor Create(aOwner : TComponent); Override;
    Procedure ShowIn(aControl : TControl);
    Procedure HideFrame;
  end;

Var
   Config : TConfig;

implementation

Uses
   FMX.Ani,
   uImages,
   uMedia;

{$R *.fmx}

{ TFrame1 }

procedure TConfig.BtSairClick(Sender: TObject);
begin
Media.Click2;
HideFrame;
end;

constructor TConfig.Create(aOwner: TComponent);
begin
inherited;
F0  := Images.GetText('0');
F1  := Images.GetText('1');
F2  := Images.GetText('2');
F3  := Images.GetText('3');
F4  := Images.GetText('4');
F5  := Images.GetText('5');
F6  := Images.GetText('6');
F7  := Images.GetText('7');
F8  := Images.GetText('8');
F9  := Images.GetText('9');
F10 := Images.GetText('10');
StartMusic .SetOptions([F0, F1, F2, F3, F4, F5, F6, F7, F8, F9, F10]);
GameMusic  .SetOptions([F0, F1, F2, F3, F4, F5, F6, F7, F8, F9, F10]);
Airplane   .SetOptions([F0, F1, F2, F3, F4, F5, F6, F7, F8, F9, F10]);
Explosion  .SetOptions([F0, F1, F2, F3, F4, F5, F6, F7, F8, F9, F10]);
Applause   .SetOptions([F0, F1, F2, F3, F4, F5, F6, F7, F8, F9, F10]);
RadarBeep  .SetOptions([F0, F1, F2, F3, F4, F5, F6, F7, F8, F9, F10]);
ButtonClick.SetOptions([F0, F1, F2, F3, F4, F5, F6, F7, F8, F9, F10]);
F0 .Free;
F1 .Free;
F2 .Free;
F3 .Free;
F4 .Free;
F5 .Free;
F6 .Free;
F7 .Free;
F8 .Free;
F9 .Free;
F10.Free;
end;

procedure TConfig.ShowIn(aControl: TControl);
begin
Parent     := aControl;
Width      := aControl.Width;
Height     := aControl.Height;
Position.X := 0;
Position.Y := aControl.Height+1;
TAnimator.AnimateFloat(Self, 'Position.Y', 0, 0.5, TAnimationType.Out, TInterpolationType.Linear);
StartMusic .ItemIndex := Media.VolumeStartMusic;
GameMusic  .ItemIndex := Media.VolumeGameMusic;
Airplane   .ItemIndex := Media.VolumeAirplane;
Explosion  .ItemIndex := Media.VolumeExplosion;
Applause   .ItemIndex := Media.VolumeApplause;
RadarBeep  .ItemIndex := Media.VolumeRadarBeep;
ButtonClick.ItemIndex := Media.VolumeButtonClick;
end;

procedure TConfig.HideFrame;
begin
Media.VolumeStartMusic  := StartMusic .ItemIndex;
Media.VolumeGameMusic   := GameMusic  .ItemIndex;
Media.VolumeAirplane    := Airplane   .ItemIndex;
Media.VolumeExplosion   := Explosion  .ItemIndex;
Media.VolumeApplause    := Applause   .ItemIndex;
Media.VolumeRadarBeep   := RadarBeep  .ItemIndex;
Media.VolumeButtonClick := ButtonClick.ItemIndex;
Media.SaveVolumes;
TAnimator.AnimateFloat(Self, 'Position.Y', (Parent As TControl).Height + Height+1 , 0.5, TAnimationType.In, TInterpolationType.Linear);
TThread.CreateAnonymousThread(
   Procedure
   Begin
   Sleep(510);
   TThread.Queue(Nil, Procedure Begin Parent := Nil; End);
   End);
end;

end.
