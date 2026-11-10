unit UFGEnd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons;

type
  TFGameEnd = class(TForm)
    BBOk: TBitBtn;
    SBEnd: TScrollBox;
    PBEnd: TPaintBox;
    procedure PBEndPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    public
    BMEnd: tBitMap;
  end;

implementation

uses UFMain;

{$R *.DFM}

procedure TFGameEnd.PBEndPaint(Sender: TObject); begin
  PBEnd.Canvas.Draw(0,0,BMEnd);
end;

procedure TFGameEnd.FormShow(Sender: TObject); begin
  PBEnd.Width:=BMEnd.Width;
  PBEnd.Height:=BMEnd.Height;
end;

procedure TFGameEnd.FormCreate(Sender: TObject); begin
  BMEnd:=tBitMap.Create;
  BMEnd.PixelFormat:=pf8bit;
  BMEnd.Canvas.Font.Size:=8;
  BMEnd.Canvas.Font.Color:=clWhite;
  BMEnd.Canvas.Brush.Color:=clBlack;
  with Canvas do begin
    Brush.Color:=clBlack;
  end;
end;

procedure TFGameEnd.FormDestroy(Sender: TObject); begin
  BMEnd.Free
end;

procedure TFGameEnd.FormPaint(Sender: TObject);
const yW = 6;
begin
  with Canvas, FMain do begin
    TextOut(SBEnd.Left, yW, 'Место');
    TextOut(SBEnd.Left+size*4, yW, 'Имя');
    TextOut(SBEnd.Left+size*10, yW, 'Зверь');
    TextOut(SBEnd.Left+size*14, yW, 'Длина');
    TextOut(SBEnd.Left+size*19, yW, 'Съел');
    TextOut(SBEnd.Left+size*22, yW, 'Убил');
    TextOut(SBEnd.Left+size*25, yW, 'Прожил');
  end
end;

end.
