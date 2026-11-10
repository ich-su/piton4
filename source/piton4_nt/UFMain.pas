(*$R RPiton.res*)

unit UFMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Menus, ComCtrls, StdCtrls, Mask, ToolEdit,
  UFOptLocal, UPiton, TimerLst, isp3, ActiveX;

const
  maxBMPiton = 22;
  StdRealSize = 16;
  ProjectName = 'Питон  IV';

type
  tInfo = class
    Ln, Cl1, Cl2,
    DS, KR, KP: integer;
    Nk        : string;
  end;

  tNetNemo = class
    Num, Idx, Col1, Col2: byte;
    Nick: string;
  end;

  TFMain = class(TForm)
    MainMenu: TMainMenu;
    Vid1: TMenuItem;
    VidInc: TMenuItem;
    VidDec: TMenuItem;
    N1: TMenuItem;
    VidMax: TMenuItem;
    VidMin: TMenuItem;
    Game: TMenuItem;
    GameStart: TMenuItem;
    GamePause: TMenuItem;
    GameStop: TMenuItem;
    VidStd: TMenuItem;
    Option1: TMenuItem;
    OptLocal: TMenuItem;
    OptGame: TMenuItem;
    Help1: TMenuItem;
    Help1About: TMenuItem;
    Help1Help: TMenuItem;
    N2: TMenuItem;
    GameNet: TMenuItem;
    RxTimerList: TRxTimerList;
    RxTimer: TRxTimerEvent;
    Opt1Ob: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure VidDecClick(Sender: TObject);
    procedure VidIncClick(Sender: TObject);
    procedure VidMinClick(Sender: TObject);
    procedure VidMaxClick(Sender: TObject);
    procedure GameStopClick(Sender: TObject);
    procedure VidStdClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OptLocalClick(Sender: TObject);
    procedure OptGameClick(Sender: TObject);
    procedure Help1AboutClick(Sender: TObject);
    procedure Opt1ObClick(Sender: TObject);
    procedure GameNetClick(Sender: TObject);

    public
    StepNumber         : integer;
    Field              : pointer;
    sizeY, sizeX, size,
    realSize           : integer;
    lObjects, lEnimals : tList;
    VivaLength, Mode   : integer;
    bKill              : boolean;
    aBMPiton           : array[0..maxBMPiton] of pointer;

    slIP               : tStringList;
    tlTCP              : tList;
    NetGame, NetState  : integer;
    CntHumPiton,
    CntHumRabbit       : integer;
    yesNet             : boolean;
    lNetNemo           : tList;
    lNetNemoClient     : tList;

    function VerifyField(X,Y: integer; bRb: boolean; var gID: integer): tField;
    procedure SetField(X,Y,NImg,ID: integer; Col1, Col2: byte);
    function NewRabbit(var X,Y: integer): boolean;
    function MinSize: integer;
    procedure SaveObj(fName: string);
    procedure OpenObj(fName: string);
    function NormalPath: string;
    function IDFind(ID: integer): tNemo;
    function IDType(ID: integer): tField;
    procedure MakeSortList(TL: tList);
    procedure SaveDlgToList(LB: tListBox);
    procedure DrawBar(Src: pointer; Dst: tBitMap; XDst, YDst: integer);
    function MaxCntPitons(MS: integer): integer;

    procedure CreateTCP(bClient: boolean);
    procedure NetConnectionRequest(Sender: TObject; requestID: Integer);
    procedure NetError(Sender: TObject; Number: Smallint;
      var Description: WideString; Scode: Integer; const Source,
      HelpFile: WideString; HelpContext: Integer; var CancelDisplay: WordBool);
    procedure NetConnect(Sender: TObject);
    procedure NetDataArrival(Sender: TObject; bytesTotal: Integer);
    procedure NetSendComplete(Sender: TObject);

    function NetNemoToStr(NN: tNetNemo): string;
    procedure SendList(TCP: tTCP; tl: tList; sBegin: string);
    function GetByte(var s: string): byte;
    procedure NetStrToNemoList(s: string; TL: tList; tg: integer);
    procedure SendCntClient;
    procedure SendToAllList;

    private
    aBMSave          : array[0..1] of pointer;
    aArb             : pointer;
    BMBar            : tBitMap;
    minVid           : integer;
    bChSize, bRun,
    startWait,
    startWait2       : boolean;
    lControls        : tList;
    c13, c15         : integer;

    sServer          : string;

    procedure WGetMinMaxInfo(var M: TWMGetMinMaxInfo); message wm_GetMinMaxInfo;
    function SetSizeForm: boolean;
    procedure Draw;
    procedure VidEnabled(rS: integer);
    function MaxRealSize: integer;
    procedure OpenRes;
    procedure MakeField;
    procedure ToField(X,Y: integer; Val: word);
    function FromField(X,Y: integer): word;
    function AllCreate: boolean;
    procedure AllFree;
    procedure ConvertColor(Src, Dst: pointer; Col1, Col2: byte);
    procedure StdObjects;
    function OpenCFG: boolean;
    function OpenINI: boolean;
    procedure SaveCFG;
    procedure SaveINI;
    procedure ErrorDisk(s, fname: string);

    procedure BlWriteV(var f: file; v: integer);
    procedure BlWriteB(var f: file; b: boolean);
    procedure BlWriteS(var f: file; s: string);
    procedure BlWriteSL(var f: file; sl: tStringList);
    procedure BlWriteDt(var f: file; Dt: tDataContr);
    procedure BlWriteTL(var f: file; tl: tList);

    function BlReadV(var f: file): integer;
    function BlReadB(var f: file): boolean;
    function BlReadS(var f: file): string;
    procedure BlReadSL(var f: file; sl: tStringList);
    function BlReadDt(var f: file): tDataContr;
    function BlReadTL(var f: file): tList;

    procedure MakeStsEmpty;
    procedure MakeStatist;
    procedure MakeEndBitMap(BM: tBitMap; Wd: integer);
    procedure InitOption;
    procedure DoneOption;
    procedure MakeHintPitons;

    function dlX: integer;
    function dlY: integer;
    procedure AddIPToList;
    procedure NewPoleSize(newX, newY: integer);
  end;

function VerifyInit: boolean;

const
  stdFileName    = 'piton4.';
  stdFileNameObj = stdFileName+'enm';
  stdFileNameINI = stdFileName+'ini';

  csRead: string  = 'чтении';
  csWrite: string = 'записи';

  netNone   = 0;
  netClient = 1;
  netServer = 2;

  netStNone   = 0;
  netStBegin  = 1;
  netStGame   = 2;

  chCreate = '$';

  NetSetError = [sckClosed, sckError, sckClosing];

var
  FMain: TFMain;

implementation

uses UFGame, UFAbout, UFGEnd, UFOptOb, UFNet,
     UFServ, UFClnt, StrUtils;

{$R *.DFM}

function TFMain.MinSize; begin
  if sizeX > (sizeY+1) then MinSize:=sizeY+1
  else MinSize:=sizeX
end;

function TFMain.IDFind;
var i: integer;
begin
  if ID <> 0 then
    for i:=0 to lEnimals.Count-1 do
      if ID = tNemo(lEnimals.Items[i]).ID then begin
        IDFind:=lEnimals.Items[i]; break
      end
end;

function TFMain.IDType;
var Nm: tNemo;
begin
  if ID = 0 then IDType:=tfEmpty
  else begin
    Nm:=IDFind(ID);
    if Nm is tPiton then IDType:=tfPiton
    else
      if Nm is tRabbit then IDType:=tfRabbit
      else IDType:=tfEmpty
  end
end;

function TFMain.NewRabbit;
var i,j,cnt,num: integer;
begin
  cnt:=0;
  for i:=0 to SizeY-1 do
    for j:=0 to SizeX-1 do
      if FromField(j,i) = tfEmpty then inc(cnt);
  if cnt > 0 then begin
    num:=Random(cnt);
    cnt:=0;
    for i:=0 to SizeY-1 do
      for j:=0 to SizeX-1 do
        if FromField(j,i) = tfEmpty then
          if cnt = num then begin
            X:=j; Y:=i; NewRabbit:=true; exit
          end
          else inc(cnt)
  end;
  NewRabbit:=false;
end;

procedure TFMain.ConvertColor;
var i: integer;
begin
  Move(Src^, Dst^, size*size);
  for i:=0 to size*size-1 do begin
    if (Col1 <> 0) and (tByte(Src^)[i] = c15) then tByte(Dst^)[i]:=ColorConvert[Col1];
    if (Col2 <> 0) and (tByte(Src^)[i] = c13) then tByte(Dst^)[i]:=ColorConvert[Col2]
  end
end;

procedure TFMain.SetField; begin
  ConvertColor(aBMPiton[NImg], aArb, Col1, Col2);
  DrawBar(aArb, BMBar, X, Y);
  ToField(X,Y,ID);
end;

function TFMain.VerifyField;
var
  it: tField;
  ff: integer;
begin
  gID:=-1;
  if (X<0) or (X>=sizeX) or (Y<0) or (Y>=sizeY) then VerifyField:=tfNothing
  else begin
    ff:=FromField(X,Y); gID:=ff;
    it:=IDType(ff);
    if it = tfRabbit then begin
      if bRb then IDFind(ff).Direct:=tdNone;
      VerifyField:=tfRabbit
    end
    else VerifyField:=it;
  end;
end;

procedure TFMain.WGetMinMaxInfo; begin
  inherited;
  if not bChSize then begin
    with M.MinMaxInfo^.ptMinTrackSize do begin
      y:=Height; x:=Width;
    end;
    with M.MinMaxInfo^.ptMaxTrackSize do begin
      y:=Height; x:=Width;
    end
  end
end;

function TFMain.SetSizeForm;
var w,h: integer;
begin
  bChSize:=true;
  w:=Width; h:=Height;
  Width:=realSize*sizeX+dlX;
  Height:=realSize*(sizeY+1)+dlY;
  if (Width <> realSize*sizeX+dlX) or (Height <> realSize*(sizeY+1)+dlY) then begin
    Width:=w; Height:=h;
    MessageDlg('Проблемы при изменении масштаба.', mtInformation, [mbCancel], 0);
    SetSizeForm:=false
  end
  else SetSizeForm:=true;
  bChSize:=false;
end;

procedure TFMain.DrawBar;
var i: integer;
begin
  YDst:=sizeY-YDst-1;
  for i:=0 to size-1 do
    Move(tByte(Src^)[i*size], tByte(Dst.ScanLine[YDst*size+i]^)[XDst*size], size)
end;

procedure TFMain.OpenRes;
var
  BM  : tBitMap;
  i,j : integer;

  procedure RotateBar(Src, Dst: pointer);
  var i,j: integer;
  begin
    for i:=0 to size-1 do
      for j:=0 to size-1 do
        tByte(Dst^)[j*size+size-i-1]:=tByte(Src^)[i*size+j]
  end;

  procedure CopyBar(X,Y, idx: integer);
  var i: integer;
  begin
    for i:=0 to size-1 do
      Move(tByte(BM.ScanLine[i+Y*size]^)[X*size], tByte(aBMPiton[idx]^)[i*size], size);
  end;

  procedure GetBar(X,Y, idx: integer);
  var i: integer;
  begin
    CopyBar(X,Y,idx);
    for i:=1 to 3 do RotateBar(aBMPiton[idx+i-1], aBMPiton[idx+i]);
  end;

begin
  BM:=tBitMap.Create;
  BM.Handle:=LoadBitMap(hInstance, 'Piton');
  BM.PixelFormat:=pf8bit;

  c13:=tByte(BM.ScanLine[15]^)[2]; // BM.Canvas.Pixels[2, 15];
  c15:=tByte(BM.ScanLine[9]^)[2];  // BM.Canvas.Pixels[2, 9];

  for i:=0 to maxBMPiton do GetMem(aBMPiton[i], size*size);
  GetMem(aArb, size*size);
  for i:=0 to 1 do GetMem(aBMSave[i], size*size);

  CopyBar(1,2,0);
  CopyBar(2,0,maxBMPiton-1);
  for i:=0 to size-1 do
    for j:=0 to size-1 do
      tByte(aBMPiton[maxBMPiton]^)[i*size+size-1-j]:=tByte(aBMPiton[maxBMPiton-1]^)[i*size+j];

  GetBar(0,0,1); GetBar(0,0,1);
  GetBar(0,2,5); GetBar(1,0,9);
  GetBar(1,1,13); GetBar(0,1,17);

  Move(aBMPiton[tiTailLeft]^, aBMSave[0]^, size*size);
  Move(aBMPiton[tiHeadRight]^, aBMSave[1]^, size*size);

  for i:=1 to maxBMPiton do
    for j:=0 to size*size-1 do
      if (tByte(aBMPiton[i]^)[j] = 0) and (tByte(aBMPiton[0]^)[j] > 0) then
        tByte(aBMPiton[i]^)[j]:=tByte(aBMPiton[0]^)[j];

  BM.Free;
end;

function TFMain.dlX; begin
  dlX:=Width-ClientWidth;
end;

function TFMain.dlY; begin
  dlY:=Height-ClientHeight;
end;

procedure TFMain.FormCreate(Sender: TObject); begin
  yesNet:=true;
  netGame:=netNone; netState:=netStNone;
  startWait2:=false;
  Caption:=ProjectName;

  lObjects:=tList.Create;
  lEnimals:=tList.Create;
  lControls:=tList.Create;
  slIP:=tStringList.Create;

  Randomize;

  VivaLength:=-1; Mode:=-1;
  minVid:=8;
  bChSize:=false; bRun:=true;
  size:=16;

  if not OpenCFG then begin
    tRxTimerEvent(RxTimerList.Events[0]).Interval:=230;
    sizeX:=32; sizeY:=18;
    Left:=0; Top:=0;
    realSize:=StdRealSize;
  end;

  OpenRes;
  InitOption;
end;

procedure TFMain.InitOption; begin
  while realSize > MaxRealSize do dec(realSize);
  
  VidEnabled(realSize);

  BMBar:=tBitMap.Create;
  BMBar.PixelFormat:=pf8bit;
  BMBar.Width:=size*sizeX;
  BMBar.Height:=size*(sizeY+1);
  BMBar.Canvas.Font.Size:=8;
  BMBar.Canvas.Font.Color:=clWhite;
  BMBar.Canvas.Brush.Color:=clBlack;

  GetMem(Field, SizeOf(word)*sizeX*sizeY);

  bRun:=false;

  MakeField;
  FormPaint(nil);
end;

procedure TFMain.StdObjects;
var DC: tDataContr;
begin
  if lObjects.Count = 0 then begin
    DC:=tDataContr.Create;
    with DC do begin
      idx:=0;
      bHum:=true; bStd:=true; bBuf:=true;
      idxLeft:=3; idxRight:=4; idxUp:=5 ; idxDown:=6;
      idxNoPo:=0; idxPo:=1; idxStop:=77;
      Color:=c15; ColorAdd:=c13; Nick:='Чувак';
    end;
    lObjects.Add(DC);
    DC:=tDataContr.Create;
    with DC do begin
      idx:=1;
      bHum:=false; bStd:=true; bBuf:=true;
      idxLeft:=3; idxRight:=4; idxUp:=5; idxDown:=6;
      idxNoPo:=0; idxPo:=1; idxStop:=77;
      Color:=c15; ColorAdd:=c15; Nick:='';
    end;
    lObjects.Add(DC);
  end
end;

procedure TFMain.BlWriteV; begin
  BlockWrite(f, v, sizeof(v))
end;

procedure TFMain.BlWriteB; begin
  BlockWrite(f, b, sizeof(b))
end;

procedure TFMain.BlWriteS; begin
  BlWriteV(f, length(s));
  BlockWrite(f, s[1], length(s))
end;

procedure TFMain.BlWriteSL;
var i: integer;
begin
  BlWriteV(f, sl.Count);
  for i:=0 to sl.Count-1 do begin
    BlWriteS(f, sl[i]);
//    BlWriteV(f, integer(sl.Objects[i]))
  end;
end;

procedure TFMain.BlWriteDt; begin
  with Dt do begin
    BlWriteV(f, idx);
    BlWriteB(f, bHum); BlWriteB(f, bStd); BlWriteB(f, bBuf);
    BlWriteV(f, idxLeft); BlWriteV(f, idxRight);
    BlWriteV(f, idxUp); BlWriteV(f, idxDown);
    BlWriteV(f, idxNoPo); BlWriteV(f, idxPo);
    BlWriteV(f, idxStop);
    BlWriteV(f, Color); BlWriteV(f, ColorAdd);
    BlWriteS(f, Nick)
  end
end;

procedure TFMain.BlWriteTL;
var i: integer;
begin
  BlWriteV(f, tl.Count);
  for i:=0 to tl.Count-1 do BlWriteDt(f, tl.Items[i])
end;

procedure TFMain.SaveObj;
var f: file;
begin
  try
    AssignFile(f, fName);
    Rewrite(f,1);
    BlWriteTL(f, lObjects);
    CloseFile(f)
  except
    ErrorDisk(csWrite, fname)
  end
end;

procedure TFMain.SaveCFG; begin
  SaveObj(NormalPath+stdFileNameObj);
  SaveINI
end;

function TFMain.BlReadV;
var v: integer;
begin
  BlockRead(f, v, sizeof(v));
  BlReadV:=v
end;

function TFMain.BlReadB;
var b: boolean;
begin
  BlockRead(f, b, sizeof(b));
  BlReadB:=b
end;

function TFMain.BlReadS;
var
  s: string;
  l: integer;
begin
  l:=BlReadV(f);
  SetLength(s, l);
  BlockRead(f, s[1], l);
  BlReadS:=s
end;

procedure TFMain.BlReadSL;
var
  i, cnt, vl: integer;
  s: string;
begin
  cnt:=BlReadV(f);
  for i:=0 to cnt-1 do begin
    s:=BlReadS(f);
//    vl:=BlReadV(f); sl.AddObject(s, pointer(vl))
    sl.Add(s)
  end;
end;

function TFMain.BlReadDt;
var DC: tDataContr;
begin
  DC:=tDataContr.Create;
  with DC do begin
    idx:=BlReadV(f);
    bHum:=BlReadB(f); bStd:=BlReadB(f); bBuf:=BlReadB(f);
    idxLeft:=BlReadV(f); idxRight:=BlReadV(f);
    idxUp:=BlReadV(f); idxDown:=BlReadV(f);
    idxNoPo:=BlReadV(f); idxPo:=BlReadV(f);
    idxStop:=BlReadV(f);
    Color:=BlReadV(f); ColorAdd:=BlReadV(f);
    Nick:=BlReadS(f)
  end;
  BlReadDt:=DC
end;

function TFMain.BlReadTL;
var
  i, cnt: integer;
  tl: tList;
begin
  tl:=tList.Create;
  cnt:=BlReadV(f);
  for i:=0 to cnt-1 do tl.Add(BlReadDt(f));
  BlReadTL:=tl
end;

procedure TFMain.ErrorDisk; begin
  MessageDlg('Ошибка при '+s+' файла "'+fName+'".', mtError, [mbCancel], 0)
end;

procedure TFMain.OpenObj;
var f: file;
begin
  try
    AssignFile(f, fName);
    Reset(f,1);
    lObjects.Free;
    lObjects:=BlReadTL(f);
    CloseFile(f)
  except
    ErrorDisk(csRead, fname)
  end
end;

function TFMain.OpenINI;
var f: file;
begin
  try
    AssignFile(f, NormalPath+stdFileNameINI);
    Reset(f,1);
    Mode:=BlReadV(f);
    VivaLength:=BlReadV(f);

    tRxTimerEvent(RxTimerList.Events[0]).Interval:=BlReadV(f);
    sizeX:=BlReadV(f);
    sizeY:=BlReadV(f);
    Left:=BlReadV(f);
    Top:=BlReadV(f);
    realSize:=BlReadV(f);
    BlReadSL(f, slIP);

    CloseFile(f);
    OpenINI:=true
  except
    ErrorDisk(csRead, NormalPath+stdFileNameINI);
    OpenINI:=false
  end
end;

procedure TFMain.SaveINI;
var f: file;
begin
  try
    AssignFile(f, NormalPath+stdFileNameINI);
    Rewrite(f,1);
    BlWriteV(f, Mode);
    BlWriteV(f, VivaLength);

    BlWriteV(f, tRxTimerEvent(RxTimerList.Events[0]).Interval);
    BlWriteV(f, sizeX);
    BlWriteV(f, sizeY);
    BlWriteV(f, Left);
    BlWriteV(f, Top);
    BlWriteV(f, realSize);
    BlWriteSL(f, slIP);

    CloseFile(f)
  except
    ErrorDisk(csRead, NormalPath+stdFileNameINI)
  end
end;

function TFMain.OpenCFG; begin
  OpenCFG:=OpenINI;
  OpenObj(NormalPath+stdFileNameObj);
  StdObjects;
  if VivaLength = -1 then VivaLength:=50;
  if Mode =-1 then Mode:=1;
end;

procedure TFMain.MakeHintPitons;
var
  BM            : tBitMap;
  tX, tY, hX, hY: byte;
  i, wX, wY,
  LnHint, HgHint: integer;
begin
  BM:=tBitMap.Create;
  BM.Assign(BMBar);

  BMBar.Canvas.Font.Color:=clBlack;
  BMBar.Canvas.Brush.Color:=clWhite;

  for i:=0 to lEnimals.Count-1 do
    if (tNemo(lEnimals.Items[i]) is tPiton) and
       (not (tNemo(lEnimals.Items[i]) is tPitonComp)) then
      with tPiton(lEnimals.Items[i]) do
        if length(Nick) > 0 then begin
          LnHint:=BMBar.Canvas.TextWidth(Nick);
          HgHint:=BMBar.Canvas.TextHeight(Nick);
          GetXY(tX, tY, Tail); GetXY(hX, hY, Head);

          if hY <> tY then begin wX:=tX; wY:=tY end
          else begin wX:=hX; wY:=hY end;
          wY:=SizeY - wY -1;

          if wY >= SizeY div 2 then begin
            if size > HgHint then HgHint:=size-HgHint
            else HgHint:=0;
          end
          else HgHint:=0;

          if wX < sizeX div 2 then LnHint:=size div 2
          else LnHint:=-(LnHint - size div 2);

          wX:=wX*size+LnHint; if wX < 0 then wX:=0;
          wY:=wY*size+HgHint;
          BMBar.Canvas.TextOut(wX, wY, Nick);
        end;

  FormPaint(nil);
  startWait2:=true;
  while startWait do Application.ProcessMessages;

  BMBar.Canvas.Font.Color:=clWhite;
  BMBar.Canvas.Brush.Color:=clBlack;

  BMBar.Assign(BM);
  BM.Free;
  startWait2:=false
end;

procedure TFMain.MakeStsEmpty;
var
  i: integer;
  s: string;
begin
  for i:=2 to size-1 do
    FillChar(BMBar.ScanLine[BMBar.Height-size+i]^, BMBar.Width, 0);
  s:='';
  if lEnimals.Count = 0 then s:='живность ждет, запускайте игру!';
  if startWait then s:='нажмите что-нибудь для начала игры...';
  if length(s) > 0 then BMBar.Canvas.TextOut(2, BMBar.Height-size+2, s);
  if startWait then MakeHintPitons;
end;

procedure TFMain.MakeSortList;
var i: integer;

  procedure AddPiton(Pt: tpiton);
  var
    Inf   : tInfo;
    i, idx: integer;
  begin
    idx:=-1;
    with Pt do begin
      for i:=0 to TL.Count-1 do
        with tInfo(TL.Items[i]) do
          if (
              (not Dead)
              and
              (
               (DS <> -1)
               or
               ((DS = -1) and (Len > Ln))
               or
               ((DS = -1) and (Len = Ln) and (KillRabbit > KR))
               or
               ((DS = -1) and (Len = Ln) and (KillRabbit = KR) and (KillPiton > KP))
              )
             )
             or
             (
              Dead
              and
              (
               ((DS <> -1) and (DeadStep > DS))
               or
               ((DS <> -1) and (DeadStep = DS) and (KillRabbit > KR))
               or
               ((DS <> -1) and (DeadStep = DS) and (KillRabbit = KR) and (KillPiton > KP))
              )
             )
          then begin
            idx:=i; break
          end;
      if idx = -1 then idx:=TL.Count;
      Inf:=tInfo.Create;
      with Inf do begin
        Cl1:=Color; Cl2:=ColorAdd;
        Ln:=Len; DS:=DeadStep;
        KR:=KillRabbit; KP:=KillPiton;
        Nk:=Nick
      end;
      TL.Insert(idx, Inf)
    end
  end;

begin
  for i:=0 to lEnimals.Count-1 do
    if tNemo(lEnimals.Items[i]) is tPiton then
      AddPiton(tPiton(lEnimals.Items[i]));
end;

procedure TFMain.MakeStatist;
var
  i,j: integer;
  TL : tList;
begin
  TL:=tList.Create;
  MakeStsEmpty;
  MakeSortList(TL);
  for i:=0 to TL.Count-1 do with tInfo(TL.Items[i]) do begin
    if (i*4 + 4 > sizeX) or (DS <> -1) then break;
    for j:=2 to size div 2 +1 do
      FillChar(tByte(BMBar.ScanLine[BMBar.Height-size+j]^)[i*size*4], size*2, ColorConvert[Cl1]);
    for j:=size div 2 -2+2 to size-1 do
      FillChar(tByte(BMBar.ScanLine[BMBar.Height-size+j]^)[i*size*4], size*2, ColorConvert[Cl2]);
    BMBar.Canvas.TextOut(size*2*(i*2+1)+2, BMBar.Height-size+2, IntToStr(Ln));
  end;
  TL.Free;
end;

procedure TFMain.MakeField;
var i,j: integer;
begin
  FillChar(Field^, sizeOf(word)*sizeX*sizeY, tfEmpty);
  for i:=0 to sizeY-1 do
    for j:=0 to sizeX-1 do
      DrawBar(aBMPiton[tiEmpty], BMBar, j, i);
  for i:=0 to 1 do
    FillChar(BMBar.ScanLine[BMBar.Height-size+i]^, BMBar.Width, 10+i*2);
  MakeStsEmpty
end;

procedure TFMain.FormPaint(Sender: TObject); begin
  if not bRun then
    StretchBlt(FMain.Canvas.Handle, 0, 0, FMain.ClientWidth, FMain.ClientHeight,
               BMBar.Canvas.Handle, 0, 0, BMBar.Width, BMBar.Height, SRCCOPY);
end;

procedure TFMain.DoneOption; begin
  bRun:=true;
  BMBar.Free;
  FreeMem(Field);
end;

procedure TFMain.FormDestroy(Sender: TObject);
var i: integer;
begin
  SaveCFG;

  bRun:=true;
  for i:=0 to maxBMPiton do FreeMem(aBMPiton[i]);
  FreeMem(aArb);
  for i:=0 to 1 do FreeMem(aBMSave[i]);

  DoneOption;

  if not GameStart.Enabled then AllFree;
  slIP.Free;
  lEnimals.Free;
  lControls.Free;
  lObjects.Free;
end;

procedure TFMain.Draw;
var
  i, N  : integer;
  endLen: boolean;
begin
  inc(StepNumber);
  for i:=0 to lControls.Count-1 do with tContr(lControls.Items[i]) do
    if aBuf.Count > 0 then begin
      Enim.Direct:=integer(aBuf.Items[0]);
      aBuf.Delete(0)
    end;
  N:=0; endLen:=false;
  for i:=0 to lEnimals.Count-1 do begin
    tNemo(lEnimals.Items[i]).Step;
    if tNemo(lEnimals.Items[i]) is tPiton then
      if not tPiton(lEnimals.Items[i]).Dead then begin
        inc(N);
        if tPiton(lEnimals.Items[i]).Len >= VivaLength then endLen:=true;
      end
  end;
  MakeStatist;
  FormPaint(nil);
  if (endLen and (Mode in [1,3])) or (bKill and (N < 2)) then
    GameStopClick(GameStop);
end;

procedure TFMain.MakeEndBitMap;
var
  TL   : tList;
  i,j,k: integer;
  s    : string;
begin
  TL:=tList.Create;
  MakeSortList(TL);
  BM.Height:=TL.Count*size;
  BM.Width:=wd;
  for i:=0 to BM.Height-1 do
    FillChar(BM.ScanLine[i]^, BM.Width, 0);
  for i:=0 to TL.Count-1 do
    with tInfo(TL.Items[i]) do begin
      BM.Canvas.TextOut(size*4, i*size, Nk);
      for j:=0 to 1 do begin
        ConvertColor(aBMSave[j], aArb, Cl1, Cl2);
        for k:=0 to size-1 do
          Move(tByte(aArb^)[k*size], tByte(BM.ScanLine[i*size+k]^)[(j+10)*size], size)
      end;
      BM.Canvas.TextOut(0, i*size, IntToStr(i+1));
      if DS = -1 then s:=IntToStr(Ln)
      else s:='труп ['+IntToStr(Ln)+']';
      BM.Canvas.TextOut(size*14, i*size, s);
      BM.Canvas.TextOut(size*19, i*size, IntToStr(KR));
      BM.Canvas.TextOut(size*22, i*size, IntToStr(KP));
      if DS = -1 then begin
        s:=IntToStr(StepNumber+1);
        if bKill then s:=s+' [до конца]'
      end
      else s:=IntToStr(DS);
      BM.Canvas.TextOut(size*25, i*size, s)
    end;
  TL.Free
end;

procedure TFMain.TimerTimer(Sender: TObject); begin
  if (not GameStart.Enabled) and (not GamePause.Checked)
     and (not startWait) and (not startWait2) then Draw;
end;

procedure TFMain.VidEnabled;
var savers: integer;
begin
  saveRS:=realSize;
  realSize:=rS;
  if not SetSizeForm then realSize:=saveRS;
  VidStd.Enabled:=(realSize <> StdRealSize) and (StdRealSize <= MaxRealSize);
  VidMin.Enabled:=(not (realSize = minVid)) and (minVid <= MaxRealSize);
  VidDec.Enabled:=VidMin.Enabled;
  VidInc.Enabled:=realSize+1 <= MaxRealSize;
  VidMax.Enabled:=realSize <> MaxRealSize;
end;

procedure TFMain.VidDecClick(Sender: TObject); begin
  VidEnabled(realSize-1)
end;

procedure TFMain.VidIncClick(Sender: TObject); begin
  VidEnabled(realSize+1)
end;

procedure TFMain.VidMinClick(Sender: TObject); begin
  VidEnabled(minVid)
end;

function TFMain.MaxRealSize;
var rS: integer;
begin
  rS:=(Screen.Width-dlX) div SizeX;
  while rS > (Screen.Height-dlY) div (SizeY+1) do dec(rS);
  MaxRealSize:=rS
end;

procedure TFMain.VidMaxClick(Sender: TObject); begin
  VidEnabled(MaxRealSize)
end;

procedure TFMain.GameStopClick(Sender: TObject);
var tg: integer;
begin
  tg:=tMenuItem(Sender).Tag;
  case tg of
    0: begin
      MakeField;
      startWait:=true; StepNumber:=0;
      bKill:=Mode in [2,3];
      if not AllCreate then begin
        AllFree; exit
      end;
      SendToAllList;
      GameStart.Enabled:=false;
//      GameNet.Enabled:=false;
      Option1.Enabled:=false;
      MakeStsEmpty;
    end;
    1: GamePause.Checked:=not GamePause.Checked;
    2: begin
      startWait:=false;
      GameStart.Enabled:=true;
//      GameNet.Enabled:=true;
      Option1.Enabled:=true;

      with tFGameEnd.Create(Application) do begin
        MakeEndBitMap(BMEnd, SBEnd.ClientWidth-50);
        ShowModal;
        Free
      end;

      AllFree;
      MakeField;
    end
  end;
  GameStop.Enabled:=not GameStart.Enabled;
  if tg in [0,2] then begin
    GamePause.Enabled:=GameStop.Enabled;
    GamePause.Checked:=false;
  end;
  FormPaint(nil);
end;

procedure TFMain.AllFree;
var i: integer;
begin
  for i:=0 to lEnimals.Count-1 do lEnimals.Delete(0);
  for i:=0 to lControls.Count-1 do lControls.Delete(0);
end;

function TFMain.AllCreate;
var N, NR: integer;

  procedure CreatePiton(bHum: boolean; Color, ColorAdd: byte; Nick: string);
  const
    aY  : array[1..8] of integer = (0,1,1,0,1,0,0,1);
    aY2 : array[1..8] of integer = (1,-1,0,0,-1,1,0,0);
  var xT, xH, yT, yH : integer;

    function Sign0(N: integer): integer; begin
      if aY[((N-1) mod 8)+1] = 0 then Sign0:=1
      else Sign0:=-1
    end;

  begin
    inc(N);

    if odd(N) then begin
      xH:=(N div 2 +1) div 2;
      xT:=N div 4;
    end
    else begin
      xH:=sizeX-1-(((N-1) div 2 +1) div 2);
      xT:=sizeX-1-((N-1) div 4)
    end;
    yT:=aY[((N-1) mod 8)+1]*(sizeY-1) + ((N-1) div 4)*Sign0(N);
    yH:=yT+aY2[((N-1) mod 8)+1];

    if bHum then lEnimals.Add(tPiton.Create(N, sizeY*sizeX*2, xH,yH,xT,yT, Color, ColorAdd, Nick))
    else lEnimals.Add(tPitonComp.Create(N, sizeY*sizeX*2, xH,yH,xT,yT, Color, ColorAdd, Nick))
  end;

  procedure CreateRabbit(bHum: boolean; Color: byte); begin
    inc(NR);
    if bHum then lEnimals.Add(tRabbit.Create(NR-1+tfRabbit, Color))
    else lEnimals.Add(tRabbitComp.Create(NR-1+tfRabbit, Color))
  end;

  procedure CreateContr(DC: tDataContr);
  var tC : tContr;
  begin
    if DC <> nil then
      with DC do begin
        if bStd then begin
          tC:=tContr.Create(lEnimals.Items[lEnimals.Count-1]);
          with tC do begin
            AddContr(aCodeKeys[idxLeft]);
            AddContr(aCodeKeys[idxRight]);
            AddContr(aCodeKeys[idxUp]);
            AddContr(aCodeKeys[idxDown]);
            if idx <> 0 then AddContr(aCodeKeys[idxStop]);
          end
        end
        else begin
          tC:=tContrDbl.Create(lEnimals.Items[lEnimals.Count-1]);
          with tC do begin
            AddContr(aCodeKeys[idxNoPo]);
            AddContr(aCodeKeys[idxPo]);
            // if idx <> 0 then AddContr(aCodeKeys[idxStop]);
          end
        end;
        tC.bBuf:=bBuf;
        lControls.Add(tC);
      end
  end;

  procedure CreateNemo(bHumans: boolean);
  var i : integer;
  begin
    for i:=0 to lObjects.Count-1 do
      with tDataContr(lObjects.Items[i]) do
        if bHumans = bHum then begin
          if idx = 0 then CreatePiton(bHum, Color, ColorAdd, Nick)
          else CreateRabbit(bHum, Color);
          if bHum then CreateContr(lObjects.Items[i])
        end;
  end;

  procedure CreateNetNemo;
  var i, fndHC: integer;

    function FindHumanContr: tDataContr;
    var i, fnd: integer;
    begin
      fnd:=0;
      FindHumanContr:=nil;
      for i:=0 to lObjects.Count-1 do
        if tDataContr(lObjects.Items[i]).bHum then begin
          if fnd = fndHC then begin
            FindHumanContr:=lObjects.Items[i];
            break
          end;
          inc(fnd)
        end;
      inc(fndHC)
    end;

  begin
    fndHC:=0;
    for i:=0 to lNetNemo.Count-1 do
      with tNetNemo(lNetNemo.Items[i]) do begin
        if idx = 0 then CreatePiton(true, Col1, Col2, Nick)
        else CreateRabbit(true, Col1);
        if NetGame = netServer then
          tNemo(lEnimals.Items[lEnimals.Count-1]).TagTCP:=Num;
        if (NetGame = netClient) and (Num = 1) then CreateContr(FindHumanContr)
      end
  end;

begin
  N:=0; NR:=0;

  if NetGame = netClient then
    while NetState <> NetStGame do Application.ProcessMessages;
  // это проверить !!!

  if NetGame in [netNone, netServer] then CreateNemo(true);
  if NetGame <> netNone then CreateNetNemo;
  if NetGame in [netNone, netServer] then CreateNemo(false);

  AllCreate:=true;
  if N = 0 then begin
    AllCreate:=false;
    MessageDlg('Где питоны-то? Как хоть играть-то собрались?', mtError, [mbCancel], 0)
  end
  else
    if bKill and (N < 2) then begin
      AllCreate:=false;
      MessageDlg('Мало питонов для данного вида игры!'#13#10'Наплодите еще, чтобы была как минимум пара штук.', mtError, [mbCancel], 0)
    end
end;

procedure TFMain.ToField; begin
  tWord(Field^)[Y*sizeX+X]:=Val
end;

function TFMain.FromField; begin
  FromField:=tWord(Field^)[Y*sizeX+X]
end;

procedure TFMain.VidStdClick(Sender: TObject); begin
  VidEnabled(StdRealSize);
end;

procedure TFMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var i: integer;
begin
  if startWait then startWait:=false
  else
    for i:=0 to lControls.Count-1 do
      tContr(lControls.Items[i]).SendControl(Key)
end;

procedure TFMain.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var w: word;
begin
  case Button of
    mbLeft: w:=vk_MouseLeft;
    mbRight: w:=vk_MouseRight;
    mbMiddle: w:=vk_MouseMiddle;
  end;
  FormKeyDown(Sender, w, []);
end;

procedure TFMain.SaveDlgToList;
var i: integer;
begin
  lObjects.Clear;
  for i:=0 to LB.Items.Count-1 do lObjects.Add(LB.Items.Objects[i]);
end;

procedure TFMain.OptLocalClick(Sender: TObject);
var i: integer;
begin
  with tFOptLocal.Create(Application) do begin
    repeat
      for i:=0 to lObjects.Count-1 do begin
        LBObj.Items.BeginUpdate;
        LBObj.Items.AddObject(CBNew.Items[tDataContr(lObjects.Items[i]).idx],lObjects.Items[i]);
        LBObj.Items.EndUpdate;
      end;
      if lObjects.Count > 0 then LBObj.ItemIndex:=0;
      ShowModal;
      if ModalResult = mrOk then SaveDlgToList(LBObj);
      for i:=0 to LBObj.Items.Count-1 do LBObj.Items.Delete(0);
    until ModalResult <> mrRetry;
    Free
  end
end;

function TFMain.NormalPath;
var s: string;
begin
  s:=ExtractFilePath(Application.ExeName);
  if s[length(s)] <> '\' then s:=s+'\';
  NormalPath:=s
end;

procedure TFMain.OptGameClick(Sender: TObject); begin
  with tFGame.Create(Application) do begin
    VLen:=VivaLength; Md:=Mode;
    ELen.Text:=IntToStr(VLen);
    case Mode of
      1: RBLen.Checked:=true;
      2: RBLive.Checked:=true;
      3: RBLenLive.Checked:=true;
      4: RBPrik.Checked:=true;
    end;
    ShowModal;
    if ModalResult = mrOk then begin
      VivaLength:=VLen; Mode:=Md;
    end;
    Free
  end
end;

function TFMain.MaxCntPitons;
var max: integer;
begin
  max:=(MS div 2 -1)*4;
  if max > 99 then max:=99;
  MaxCntPitons:=max
end;

procedure TFMain.Help1AboutClick(Sender: TObject); begin
  with tFAbout.Create(Application) do begin
    ShowModal;
    Free
  end
end;

procedure TFMain.NewPoleSize; begin
  if (newX <> SizeX) or (newY <> SizeY) then begin
    DoneOption;
    SizeX:=newX; SizeY:=newY;
    InitOption
  end
end;

procedure TFMain.Opt1ObClick(Sender: TObject); begin
  with TFOptOb.Create(Application) do begin
    EGor.Text:=IntToStr(SizeX); EVer.Text:=IntToStr(SizeY);
    EStep.Text:=IntToStr(RxTimer.Interval);
    RTEStep.Interval:=RxTimer.Interval;
    ShowModal;
    if ModalResult = mrOk then begin
      RxTimer.Interval:=RTEStep.Interval;
      NewPoleSize(StrToInt(EGor.Text), StrToInt(EVer.Text))
    end;
    Free
  end;
end;

function VerifyInit; begin
  VerifyInit:=false;
  CreateSemaphore(nil,0,1,ProjectName);
  if GetLastError = ERROR_ALREADY_EXISTS then begin
    MessageDlg('Нафига пускать еще одного "'+ProjectName+'" в одну эту же память, а? Безобразники, блин. А ну перестать хулиганить!', mtError, [mbCancel], 0);
    exit
  end;
  VerifyInit:=true;
end;

procedure TFMain.SendCntClient;
var i, cnt: integer;
begin
  cnt:=0;
  for i:=1 to tlTCP.Count-1 do
    if tTCP(tlTCP.Items[i]).Tag <> -1 then inc(cnt);
  for i:=1 to tlTCP.Count-1 do
    if tTCP(tlTCP.Items[i]).Tag <> -1 then
      tTCP(tlTCP.Items[i]).SendData(IntToStr(cnt));
  FServ.LCntTCP.Caption:='Подсоединилось: '+IntToStr(cnt);
  FServ.BBOk.Enabled:=cnt > 0;
end;

procedure TFMain.NetConnectionRequest(Sender: TObject; requestID: Integer); begin
  CreateTCP(true);
  tTCP(tlTCP.Items[tlTCP.Count-1]).Accept(requestID);
  FServ.LBClients.Items.Add(tTCP(tlTCP.Items[0]).RemoteHostIP);
  FServ.LBClients.ItemIndex:=FServ.LBClients.Items.Count-1;
  FServ.BBFack.Enabled:=true;
  SendCntClient;
end;

procedure TFMain.NetError(Sender: TObject; Number: Smallint;
  var Description: WideString; Scode: Integer; const Source,
  HelpFile: WideString; HelpContext: Integer; var CancelDisplay: WordBool);
begin
  MessageDlg('Сетевая ошибка #'+IntToStr(Number)+'.'#13'Вот сведения о ней по буржуйски: "'+Description+'".', mtError, [mbCancel], 0);
  CancelDisplay:=true;
end;

function TFMain.NetNemoToStr; begin
  with NN do
    NetNemoToStr:=char(Num)+char(idx)+char(Col1)+char(Col2)+char(length(Nick))+LeftStr(Nick, 9);
end;

function TFMain.GetByte; begin
  if length(s) > 0 then begin
    GetByte:=byte(s[1]);
    Delete(s,1,1);
  end
  else GetByte:=0
end;

procedure TFMain.NetStrToNemoList;
var
  i,l,cnt: integer;
  NN     : tNetNemo;
begin
  cnt:=byte(s[1])+byte(s[2]);
  for i:=0 to cnt-1 do begin
    NN:=tNetNemo.Create;
    with NN do begin
      Num:=GetByte(s);
      idx:=GetByte(s);
      Col1:=GetByte(s);
      Col2:=GetByte(s);
      l:=GetByte(s);
      Nick:=Copy(s,1,9); Delete(s,1,9);
      Nick:=Copy(Nick,1,l);
      Num:=tg
    end;
    TL.Add(NN)
  end
end;

procedure TFMain.SendList;
var
  s: string;
  i: integer;
begin
  s:=sBegin+char(CntHumPiton)+char(CntHumRabbit);
  for i:=0 to tl.Count-1 do s:=s+NetNemoToStr(tl.Items[i]);
  TCP.SendData(s)
end;

const sWaitClient: string = 'Есть контакт! Ждем начала игры...';

procedure TFMain.NetConnect(Sender: TObject); begin
  FClnt.LClient.Caption:=sWaitClient;
  SendList(tTCP(Sender), lNetNemoClient, '');
end;

procedure TFMain.NetDataArrival(Sender: TObject; bytesTotal: Integer);
var
  Data : OleVariant;
  s    : string;
begin
  tTCP(Sender).GetData(Data, VT_BSTR, bytesTotal);

  case NetGame of
    netClient:
      case NetState of
        netStBegin: begin
          if string(Data)[1] = chCreate then begin
          
            NetState:=NetStGame
          end
          else
            FClnt.LClient.Caption:=sWaitClient+#13+'( уже подсоединилось: '+Data+' )';
        end;
      end;
    netServer:
      case NetState of
        netStBegin: begin
          s:=Data;
          FServ.LBClients.Items[tTCP(Sender).Tag-1]:=
            FServ.LBClients.Items[tTCP(Sender).Tag-1] +
            ' ( '+IntToStr(byte(s[1])) + ' , ' + IntToStr(byte(s[2]))+' )';
          NetStrToNemoList(s, lNetNemo, tTCP(Sender).Tag)
        end;
      end;
  end
end;

procedure TFMain.NetSendComplete(Sender: TObject); begin
end;

procedure TFMain.CreateTCP;
var newTCP: tTCP;
begin
  newTCP:=tTCP.Create(FMain);
  with newTCP do begin
    newTCP.LocalPort:=7;
    newTCP.RemotePort:=7;
    newTCP.OnError:=NetError;
    if bClient then begin
      newTCP.RemoteHost:=sServer;
      newTCP.OnConnect:=NetConnect;
      newTCP.OnDataArrival:=NetDataArrival;
      newTCP.OnSendComplete:=NetSendComplete;
    end
    else newTCP.OnConnectionRequest:=NetConnectionRequest
  end;
  tlTCP.Add(newTCP);
  newTCP.Tag:=tlTCP.Count-1
end;

procedure TFMain.AddIPToList;
var i: integer;
begin
  for i:=0 to slIP.Count-1 do
    if sServer = slIP[i] then begin
      slIP.Move(i, 0); exit;
    end;
  slIP.Insert(0, sServer);
  while slIP.Count > 20 do slIP.Delete(slIP.Count-1)
end;

procedure TFMain.SendToAllList;
var
  i,j : integer;
  tl  : tList;
  NN  : tNetNemo;
begin
  if NetGame = netServer then
    for i:=1 to tlTCP.Count-1 do
      if tTCP(tlTCP.Items[i]).Tag <> -1 then begin
        tl:=tList.Create;
        for j:=0 to lEnimals.Count-1 do
          with tNemo(lEnimals.Items[i]) do begin
            NN:=tNetNemo.Create;
            NN.Nick:=Nick;
            NN.Col1:=Color;
            if tNemo(lEnimals.Items[i]) is tPiton then begin
              NN.Col2:=tPiton(lEnimals.Items[i]).ColorAdd;
              NN.Idx:=0
            end
            else NN.Idx:=1;
            if i = TagTCP then NN.Num:=1 else NN.Num:=0;
            tl.Add(NN)
          end;
        SendList(tlTCP.Items[i], tl, char(sizeX)+char(sizeY)+chCreate);
        tl.Free;
      end
end;

procedure TFMain.GameNetClick(Sender: TObject);
var
  mr,i: integer;
  fr  : tForm;

  function MakeFNet: integer;
  var
    i: integer;
    NN: tNetNemo;
  begin
    CntHumPiton:=0;
    CntHumRabbit:=0;
    for i:=0 to lObjects.Count-1 do
      if tDataContr(lObjects.Items[i]).bHum then begin
        if tDataContr(lObjects.Items[i]).idx = 0 then inc(CntHumPiton)
        else inc(CntHumRabbit);
        NN:=tNetNemo.Create;
        NN.Num:=0; // ?
        NN.idx:=tDataContr(lObjects.Items[i]).idx;
        NN.Nick:=tDataContr(lObjects.Items[i]).Nick;
        NN.Col1:=tDataContr(lObjects.Items[i]).Color;
        NN.Col2:=tDataContr(lObjects.Items[i]).ColorAdd;
        lNetNemoClient.Add(NN);
      end;
    with tFNet.Create(Application) do begin
      ShowModal;
      MakeFNet:=ModalResult;
      sServer:=DelSpace(CBAdr.Text);
      Free
    end;
  end;

begin
  lNetNemoClient:=tList.Create;
  lNetNemo:=tList.Create;
  mr:=MakeFNet;
  if mr <> mrCancel then begin
    AddIPToList;
    tlTCP:=tList.Create;
    case mr of
      mrOk: begin
        NetGame:=netServer; fr:=tFServ.Create(Application);
      end;
      mrYes: begin
        NetGame:=netClient; fr:=tFClnt.Create(Application);
      end
    end;
    NetState:=netStBegin;
    CreateTCP(mr = mrYes);
    with fr do begin
      ShowModal;
      mr:=ModalResult;
      Free
    end;

    tTCP(FMain.tlTCP.Items[0]).Close;
    case mr of
      mrAbort: begin
        MessageDlg('Нет связи с сервером.', mtError, [mbCancel], 0);
      end;
      mrOk: GameStopClick(GameStart)
    end;

    NetGame:=netNone;
    for i:=0 to tlTCP.Count-1 do tTCP(tlTCP.Items[i]).Close;
    for i:=0 to tlTCP.Count-1 do tTCP(tlTCP.Items[i]).Free;
    tlTCP.Free
  end;
  lNetNemoClient.Free;
  lNetNemo.Free
end;

end.

