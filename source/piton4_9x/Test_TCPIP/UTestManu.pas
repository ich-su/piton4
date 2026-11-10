unit UTestManu;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, OleCtrls, isp3, ActiveX, ExtCtrls;

type
  TForm1 = class(TForm)
    BBListen: TBitBtn;
    BBConnect: TBitBtn;
    ECon: TEdit;
    BBDisConnect: TBitBtn;
    TCPS: TTCP;
    TCPC: TTCP;
    BBSend: TBitBtn;
    ESend: TEdit;
    EGet: TEdit;
    LGet: TLabel;
    CBClient: TComboBox;
    LClient: TLabel;
    LOk: TLabel;
    BitBtn1: TBitBtn;
    LState: TLabel;
    TState: TTimer;
    LSt: TLabel;
    procedure BBListenClick(Sender: TObject);
    procedure TCPSConnectionRequest(Sender: TObject; requestID: Integer);
    procedure FormCreate(Sender: TObject);
    procedure BBDisConnectClick(Sender: TObject);
    procedure TCPSError(Sender: TObject; Number: Smallint;
      var Description: WideString; Scode: Integer; const Source,
      HelpFile: WideString; HelpContext: Integer;
      var CancelDisplay: WordBool);
    procedure BBConnectClick(Sender: TObject);
    procedure TCPCConnect(Sender: TObject);
    procedure TCPCDataArrival(Sender: TObject; bytesTotal: Integer);
    procedure BBSendClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TCPCSendComplete(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure TStateTimer(Sender: TObject);
  private
    TLTCP: tList;
    cntClient: integer;
    noneTimer: boolean;

    procedure Enabls(en, md: boolean);
    procedure AddTCP(TCP: tTCP; RemHIP: string);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Enabls; begin
  BBListen.Enabled:=en;
  BBConnect.Enabled:=en;
  if not md then begin
    BBSend.Enabled:=not en;
    ESend.Enabled:=not en;
    EGet.Enabled:=not en;
    LGet.Enabled:=not en;
    CBClient.Enabled:=not en;
    LClient.Enabled:=not en;
    LOk.Enabled:=not en;
    LState.Enabled:=not en;
    LSt.Enabled:=not en;
  end;
  BBDisConnect.Enabled:=not en;
end;

procedure TForm1.BBListenClick(Sender: TObject); begin
  TCPS.Listen;
  Enabls(false, true);
end;

procedure TForm1.AddTCP; begin
  CBClient.Items.Add(IntToStr(cntClient)+': '+RemHIP);
  CBClient.ItemIndex:=CBClient.Items.Count-1;
  TLTCP.Add(TCP);
end;

procedure TForm1.TCPSConnectionRequest(Sender: TObject; requestID: Integer);
var newTCP: tTCP;
begin
  noneTimer:=true;
  inc(cntClient);
  if cntClient > 1 then begin
    newTCP:=tTCP.Create(Form1);
    newTCP.RemoteHost:=TCPC.RemoteHost;
    newTCP.LocalPort:=TCPC.LocalPort;
    newTCP.OnConnect:=TCPC.OnConnect;
    newTCP.OnDataArrival:=TCPC.OnDataArrival;
    newTCP.OnError:=TCPC.OnError;
    newTCP.OnSendComplete:=TCPC.OnSendComplete;
  end
  else newTCP:=TCPC;
  newTCP.Accept(requestID);
  Enabls(false, false);
  AddTCP(newTCP, TCPS.RemoteHostIP);
  noneTimer:=false;
end;

procedure TForm1.FormCreate(Sender: TObject); begin
  noneTimer:=true;
  TLTCP:=tList.Create;
  Enabls(true, false);
  TCPC.RemotePort:=7;
  TCPS.LocalPort:=7;
  cntClient:=0;
end;

procedure TForm1.BBDisConnectClick(Sender: TObject);
var i: integer;
begin
  noneTimer:=true;
  TCPS.Close;
  for i:=0 to TLTCP.Count-1 do tTCP(TLTCP.Items[i]).Close;
  for i:=1 to TLTCP.Count-1 do tTCP(TLTCP.Items[i]).Free;
  TLTCP.Clear;
  Enabls(true, false);
  cntClient:=0;
  noneTimer:=false;
end;

procedure TForm1.TCPSError(Sender: TObject; Number: Smallint;
  var Description: WideString; Scode: Integer; const Source,
  HelpFile: WideString; HelpContext: Integer; var CancelDisplay: WordBool);
begin
  MessageDlg('Error :'+IntToStr(Number)+' - '+Description, mtError, [mbCancel], 0);
  CancelDisplay:=true;
end;

procedure TForm1.BBConnectClick(Sender: TObject); begin
  TCPC.Connect(ECon.Text, TCPC.RemotePort);
  Enabls(false, true);
end;

procedure TForm1.TCPCConnect(Sender: TObject); begin
  noneTimer:=true;
  Enabls(false, false); cntClient:=1;
  AddTCP(TCPC, TCPC.RemoteHostIP);
  noneTimer:=false;
end;

procedure TForm1.TCPCDataArrival(Sender: TObject; bytesTotal: Integer);
var Data: OleVariant;
begin
  tTCP(Sender).GetData(Data, VT_BSTR, bytesTotal);
  EGet.Text:=Data+'('+tTCP(Sender).RemoteHostIP+')';
end;

procedure TForm1.BBSendClick(Sender: TObject); begin
  LOk.Caption:='';
  tTCP(TLTCP.Items[CBClient.ItemIndex]).SendData(ESend.Text);
end;

procedure TForm1.FormDestroy(Sender: TObject); begin
  BBDisConnectClick(nil);
  TLTCP.Free;
end;

procedure TForm1.TCPCSendComplete(Sender: TObject); begin
  LOk.Caption:='OK';
end;

procedure TForm1.BitBtn1Click(Sender: TObject); begin
  Close
end;

procedure TForm1.TStateTimer(Sender: TObject); begin
  if (not noneTimer) and (TLTCP.Count > 0) then
    case tTCP(TLTCP.Items[CBClient.ItemIndex]).State of
      sckClosed: LState.Caption:='Closed';
      sckOpen: LState.Caption:='Open';
      sckListening: LState.Caption:='Listening';
      sckConnectionPending: LState.Caption:='ConnectionPending';
      sckResolvingHost: LState.Caption:='ResolvingHost';
      sckHostResolved: LState.Caption:='HostResolved';
      sckConnecting: LState.Caption:='Connecting';
      sckConnected: LState.Caption:='Connected';
      sckClosing: LState.Caption:='Closing';
      sckError: LState.Caption:='Error';
      else LState.Caption:='Unknow';
    end
  else LState.Caption:='None';

end;

end.

