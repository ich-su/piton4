unit UFOptOb;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TimerLst, ExtCtrls, StdCtrls, Buttons;

type
  TFOptOb = class(TForm)
    BBOk: TBitBtn;
    BBCancel: TBitBtn;
    GBSize: TGroupBox;
    LGor: TLabel;
    EGor: TEdit;
    LVer: TLabel;
    EVer: TEdit;
    GBStep: TGroupBox;
    LStep: TLabel;
    EStep: TEdit;
    PBox: TPaintBox;
    RTLStep: TRxTimerList;
    RTEStep: TRxTimerEvent;
    BBPr: TBitBtn;
    LInf: TLabel;
    BBStd: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure PBoxPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RTEStepTimer(Sender: TObject);
    procedure BBPrClick(Sender: TObject);
    procedure EStepKeyPress(Sender: TObject; var Key: Char);
    procedure BBOkClick(Sender: TObject);
    procedure BBStdClick(Sender: TObject);
  private
  BMStep: tBitMap;
  inBad: boolean;
  procedure MakeBMStep(step: integer);
  procedure ErrorDlg(WC: tWinControl; sPl: string);
  function TextToInt(E: tEdit; pl: string; var vl: integer): boolean;
  end;

implementation

uses UPiton, UFMain, UFOptLocal;

const
  aIdxBM: array[1..8, 0..7] of byte =
    ((tiTailLeft, tiLeftRight, tiHeadRight, tiEmpty, tiEmpty, tiEmpty, tiEmpty, tiEmpty),
     (tiEmpty, tiTailLeft, tiLeftRight, tiHeadRight, tiEmpty, tiEmpty, tiEmpty, tiEmpty),
     (tiEmpty, tiEmpty, tiTailLeft, tiLeftDown, tiHeadDown, tiEmpty, tiEmpty, tiEmpty),
     (tiEmpty, tiEmpty, tiEmpty, tiTailUp, tiUpLeft, tiHeadLeft, tiEmpty, tiEmpty),
     (tiEmpty, tiEmpty, tiEmpty, tiEmpty, tiTailRight, tiRightLeft, tiHeadLeft, tiEmpty),
     (tiEmpty, tiEmpty, tiEmpty, tiEmpty, tiEmpty, tiTailRight, tiRightLeft, tiHeadLeft),
     (tiHeadUp, tiEmpty, tiEmpty, tiEmpty, tiEmpty, tiEmpty, tiTailRight, tiRightUp),
     (tiDownRight, tiHeadRight, tiEmpty, tiEmpty, tiEmpty, tiEmpty, tiEmpty, tiTailDown));
  aIdxXY: array[0..7, 0..1] of byte =
    ((0,0), (1,0), (2,0), (3,0), (3,1), (2,1), (1,1), (0,1));

{$R *.DFM}

procedure TFOptOb.FormCreate(Sender: TObject); begin
  with FMain do begin
    PBox.Width:=size*4;
    PBox.Height:=size*2;

    BMStep:=tBitMap.Create;
    BMStep.PixelFormat:=pf8bit;
    BMStep.Width:=size*4;
    BMStep.Height:=size*2;
    LInf.Left:=PBox.Left+PBox.Width+16;
    MakeBMStep(1);
    RTLStep.Active:=true;
  end
end;

procedure TFOptOb.PBoxPaint(Sender: TObject); begin
  PBox.Canvas.Draw(0,0, BMStep)
end;

procedure TFOptOb.FormDestroy(Sender: TObject); begin
  BMStep.Free
end;

procedure TFOptOb.MakeBMStep;
var i,k: integer;
begin
  with FMain do
    for k:=0 to 7 do
      for i:=0 to size-1 do
        Move(tByte(aBMPiton[aIdxBM[step, k]]^)[i*size],
             tByte(BMStep.ScanLine[aIdxXY[k,1]*size+i]^)[aIdxXY[k,0]*size], size);
  LInf.Caption:=IntToStr(RTEStep.Interval)
end;

procedure TFOptOb.RTEStepTimer(Sender: TObject);
const step: integer = 1;
begin
  MakeBMStep(step);
  PBoxPaint(nil);
  step:=step mod 8 +1
end;

procedure TFOptOb.BBPrClick(Sender: TObject);
var vl: integer;
begin
  inBad:=true;
  try
    vl:=StrToInt(EStep.Text);
    if (vl >= 50) and (vl <=1000) then begin
      RTEStep.Interval:=vl;
      inBad:=false
    end
    else ErrorDlg(tWinControl(Sender), LStep.Caption)
  except
    ErrorDlg(tWinControl(Sender), LStep.Caption)
  end
end;

procedure TFOptOb.EStepKeyPress(Sender: TObject; var Key: Char); begin
  if not (Key in [#0..#31, '0'..'9']) then Key:=#27
end;

procedure TFOptOb.ErrorDlg; begin
  MessageDlg('Неправильно заполнено поле "'+Copy(sPl,1,length(sPl)-1)+'".', mtError, [mbCancel], 0);
  ActiveControl:=WC
end;

function TFOptOb.TextToInt; begin
  TextToInt:=false;
  try
    vl:=StrToInt(E.Text);
    if not (vl in [8..50]) then ErrorDlg(E, pl)
    else TextToInt:=true;
  except
    ErrorDlg(E, pl)
  end
end;

procedure TFOptOb.BBOkClick(Sender: TObject);
var i, newX, newY: integer;
begin
  BBPrClick(nil);
  if not inBad then
    if TextToInt(EGor, LGor.Caption, newX) then
      if TextToInt(EVer, LVer.Caption, newY) then begin
        if newX > newY then newX:=newY;
        newY:=0;
        for i:=0 to FMain.lObjects.Count-1 do
          if tDataContr(FMain.lObjects.Items[i]).idx = 0 then inc(newY);
          newX:=FMain.MaxCntPitons(newX);
        if newY > newX then
            MessageDlg('Для новых размеров поля в "Живности" слишком много питонов ('+IntToStr(newY)+
                       '). Для данных размеров их максимальное количество равно '+IntToStr(newX)+
                       '. Сначала удалите лишнюю живность, а уж потом меняйте габариты поля.',
                       mtInformation, [mbCancel], 0)
        else begin
          Close;
          ModalResult:=mrOk
        end
      end
end;

procedure TFOptOb.BBStdClick(Sender: TObject); begin
  EGor.Text:='32';
  EVer.Text:='18';
  EStep.Text:='230';
  BBPrClick(nil);
end;

end.
