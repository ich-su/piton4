unit UFAbout;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Animate, GIFCtrl, ExtCtrls, StdCtrls, Buttons;

type
  TFAbout = class(TForm)
    PGIF: TPanel;
    RGAGif: TRxGIFAnimator;
    LName: TLabel;
    LVer: TLabel;
    Label1: TLabel;
    BBCancel: TBitBtn;
    LInfo: TLabel;
    PLine: TPanel;
    PLine2: TPanel;
    procedure FormCreate(Sender: TObject);
  end;

implementation

{$R *.DFM}

procedure TFAbout.FormCreate(Sender: TObject); begin
  PGif.Height:=47; PGif.Width:=62;
  RGAGif.Height:=45; RGAGif.Width:=60;
end;

end.
