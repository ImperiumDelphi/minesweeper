unit uGameInterfaces;

interface

uses
   System.UITypes;

Type

   TFieldSize         = (fsVerySmall, fsSmall,   fsMedium, fsLarge, fsVeryLarge);
   TFieldDifficulty   = (fdVeryEasy,  fdEasy,    fdMedium, fdHard,  fdVeryHard);
   TFieldEffects      = (feNome,      feOpacity, feSquare, feRadar);
   TFieldArray        = Array[0..33, 0..33] Of Byte;
   TFieldArrayF       = Array[0..33, 0..33] Of Single;
   TFieldArrayEffects = Array[0..33, 0..33] Of TFieldEffects;
   TFieldArrayColors  = Array[0..33, 0..33] Of TAlphaColor;
   TClickPosition     = Procedure (aButton : TMouseButton; aLx, aLy, aValue : Integer) Of Object;


   IMinesweeper = interface
      ['{EB0956CD-BAC6-4F08-B1A5-706AF60D45AD}']
      Function SetDifficulty(aValue : TFieldDifficulty) : IMinesweeper;
      Function SetFieldSize (aValue : TFieldSize)       : IMinesweeper;
      procedure ClickField(aButton : TMouseButton; aX, aY, aValue: Integer);
      procedure CentralizeMap;
      Procedure StartGame;
      Procedure StartTime;
      procedure ShowStartScreen;
      Procedure Terminate;
      End;

implementation

end.
