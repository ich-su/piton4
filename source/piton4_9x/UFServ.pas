unit UFServ;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, TimerLst;

type
  TFServ = class(TForm)
    BBOk: TBitBtn;
    BBCancel: TBitBtn;
    LInfo: TLabel;
    LBClients: TListBox;
    RTList: TRxTimerList;
    RTEv: TRxTimerEvent;
    BBFack: TBitBtn;
    LCntTCP: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure RTEvTimer(Sender: TObject);
    procedure BBFackClick(Sender: TObject);
    procedure LBClientsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    public
    procedure FackClient(i: integer);
  end;

var FServ: tFServ;

implementation

uses UFMain, isp3;

{$R *.DFM}

procedure TFServ.FormActivate(Sender: TObject); begin
  tTCP(FMain.tlTCP.Items[0]).Listen;
  RTList.Active:=true;
end;

procedure TFServ.RTEvTimer(Sender: TObject);
var i: integer;
begin
  with FMain do begin
    for i:=1 to tlTCP.Count-1 do
      if (tTCP(tlTCP.Items[i]).Tag <> -1) and
         (tTCP(tlTCP.Items[i]).State in NetSetError) then FackClient(i);
    SendCntClient;
  end
end;

procedure TFServ.FackClient; begin
  with FMain do begin
    tTCP(tlTCP.Items[i]).Tag:=-1;
    LBClients.Items[i-1]:=LBClients.Items[i-1]+' / связь потерена';
    tTCP(tlTCP.Items[i]).Close;
    if i = LBClients.ItemIndex +1 then BBFack.Enabled:=false;
  end
end;

procedure TFServ.BBFackClick(Sender: TObject); begin
  FackClient(LBClients.ItemIndex+1)
end;

procedure TFServ.LBClientsClick(Sender: TObject); begin
  BBFack.Enabled:=(LBClients.Items.Count > 0) and
                  (tTCP(FMain.tlTCP.Items[LBClients.ItemIndex+1]).Tag <> -1)
end;

procedure TFServ.FormCreate(Sender: TObject); begin
  FServ:=self
end;

end.
