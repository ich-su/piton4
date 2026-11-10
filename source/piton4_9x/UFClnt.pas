unit UFClnt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, TimerLst;

type
  TFClnt = class(TForm)
    LClient: TLabel;
    BBCancel: TBitBtn;
    RTList: TRxTimerList;
    RTEv: TRxTimerEvent;
    procedure FormActivate(Sender: TObject);
    procedure RTEvTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  end;

var FClnt: tFClnt;

implementation

uses isp3, UFMain;

{$R *.DFM}

procedure TFClnt.FormActivate(Sender: TObject); begin
  tTCP(FMain.tlTCP.Items[0]).Connect(
    tTCP(FMain.tlTCP.Items[0]).RemoteHost,
    tTCP(FMain.tlTCP.Items[0]).RemotePort);
  RTList.Active:=true;
end;

procedure TFClnt.RTEvTimer(Sender: TObject); begin
  if tTCP(FMain.tlTCP.Items[0]).State in NetSetError then begin
    Close;
    ModalResult:=mrAbort;
  end
end;

procedure TFClnt.FormCreate(Sender: TObject); begin
  FClnt:=self
end;

end.

