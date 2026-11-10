unit UTest;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, OleCtrls, isp3, ActiveX;

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
    LOk: TLabel;
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
  private
    procedure Enabls(en, md: boolean);
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
  end;
  BBDisConnect.Enabled:=not en;
end;

procedure TForm1.BBListenClick(Sender: TObject); begin
  TCPS.Listen;
  Enabls(false, true);
end;

procedure TForm1.TCPSConnectionRequest(Sender: TObject; requestID: Integer); begin
  TCPC.Accept(requestID);
  TCPS.Close;
  Enabls(false, false);
end;

procedure TForm1.FormCreate(Sender: TObject); begin
  Enabls(true, false);
  TCPC.RemotePort:=7;
  TCPS.LocalPort:=7;
end;

procedure TForm1.BBDisConnectClick(Sender: TObject); begin
  TCPC.Close;
  Enabls(true, false)
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
  Enabls(false, false);
end;

procedure TForm1.TCPCDataArrival(Sender: TObject; bytesTotal: Integer);
var Data: OleVariant;
begin
  TCPC.GetData(Data, VT_BSTR, bytesTotal);
  EGet.Text:=Data;
end;

procedure TForm1.BBSendClick(Sender: TObject); begin
  LOk.Caption:='';
  TCPC.SendData(ESend.Text);
end;

procedure TForm1.FormDestroy(Sender: TObject); begin
  TCPS.Close; TCPC.Close;
end;

procedure TForm1.TCPCSendComplete(Sender: TObject); begin
  LOk.Caption:='OK';
end;

end.
