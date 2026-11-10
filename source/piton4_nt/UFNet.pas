unit UFNet;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TFNet = class(TForm)
    BBSrv: TBitBtn;
    BBCancel: TBitBtn;
    BBCln: TBitBtn;
    CBAdr: TComboBox;
    LAdr: TLabel;
    GroupBox1: TGroupBox;
    LInf: TLabel;
    procedure CBAdrChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  end;

implementation

uses UFMain, UFOptLocal, StrUtils;

{$R *.DFM}

procedure TFNet.CBAdrChange(Sender: TObject); begin
  with FMain do
    BBCln.Enabled:=(CntHumPiton + CntHumRabbit > 0) and (length(DelSpace(tComboBox(Sender).Text)) <> 0) and yesNet;
end;

procedure TFNet.FormCreate(Sender: TObject); begin
  CBAdr.Items.Assign(FMain.slIP);
  CBAdr.ItemIndex:=0;
end;

procedure TFNet.FormShow(Sender: TObject); begin
  BBSrv.Enabled:=FMain.yesNet;
  CBAdrChange(CBAdr)
end;

end.

