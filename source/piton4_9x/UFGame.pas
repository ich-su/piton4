unit UFGame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TFGame = class(TForm)
    RBLen: TRadioButton;
    RBLive: TRadioButton;
    RBLenLive: TRadioButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    RBPrik: TRadioButton;
    Label4: TLabel;
    BBOk: TBitBtn;
    BBCancel: TBitBtn;
    ELen: TEdit;
    Label5: TLabel;
    procedure RBLenClick(Sender: TObject);
    procedure ELenExit(Sender: TObject);
    procedure ELenKeyPress(Sender: TObject; var Key: Char);
    procedure BBOkClick(Sender: TObject);
  public
    VLen, Md: integer;
  private
    inBad: boolean;
  end;

implementation

{$R *.DFM}

procedure TFGame.RBLenClick(Sender: TObject); begin
  Md:=tWinControl(Sender).Tag
end;

procedure TFGame.ELenExit(Sender: TObject);
var l: integer;
begin
  try
    l:=StrToInt(ELen.Text);
    if l >= 3 then begin
      VLen:=l; inBad:=false
    end
    else inBad:=true
  except
    inBad:=true
  end
end;

procedure TFGame.ELenKeyPress(Sender: TObject; var Key: Char); begin
  if not (Key in [#0..#31,'0'..'9']) then Key:=#27
end;

procedure TFGame.BBOkClick(Sender: TObject); begin
  ELenExit(nil);
  if not inBad then begin
    Close;
    ModalResult:=mrOk
  end
  else begin
    MessageDlg('Неправильно заполнено поле "Длина".', mtError, [mbCancel], 0);
    ActiveControl:=tWinControl(Sender)
  end
end;

end.

