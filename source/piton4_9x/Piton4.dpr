program Piton4;

uses
  Forms,
  UFMain in 'UFMain.pas' {FMain},
  UPiton in 'UPiton.pas',
  UFOptLocal in 'UFOptLocal.pas' {FOptLocal},
  UFGame in 'UFGame.pas' {FGame},
  UFAbout in 'UFAbout.pas' {FAbout},
  UFGEnd in 'UFGEnd.pas' {FGameEnd},
  UFOptOb in 'UFOptOb.pas' {FOptOb},
  UFNet in 'UFNet.pas' {FNet},
  UFServ in 'UFServ.pas' {FServ},
  UFClnt in 'UFClnt.pas' {FClnt};

{$R *.RES}

begin
  if VerifyInit then begin
    Application.Initialize;
    Application.CreateForm(TFMain, FMain);
  Application.Run;
  end
end.
