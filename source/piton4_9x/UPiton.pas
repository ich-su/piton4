unit UPiton;

interface

uses classes;

const
  tdNone  = -1;
  tdLeft  = 0;
  tdRight = 1;
  tdUp    = 2;
  tdDown  = 3;
  tdStay  = 4;

  tfEmpty   = 0;
  tfPiton   = 1;
  tfRabbit  = 100;
  tfNothing = -1;

  tiEmpty     = 0;
  tiHeadUp    = 1;
  tiHeadRight = 2;
  tiHeadDown  = 3;
  tiHeadLeft  = 4;
  tiTailDown  = 5;
  tiTailRight = 8;
  tiTailUp    = 7;
  tiTailLeft  = 6;
  tiDownRight = 9;
  tiLeftDown  = 10;
  tiUpLeft    = 11;
  tiRightUp   = 12;
  tiDownLeft  = 13;
  tiLeftUP    = 14;
  tiUpRight   = 15;
  tiRightDown = 16;
  tiDownUp    = 17;
  tiLeftRight = 18;
  tiUpDown    = 19;
  tiRightLeft = 20;
  tiRabbitLeft  = 21;
  tiRabbitRight = 22;

  maxIncLen = 6;
  MaxNoWait = 4;
  RndNoWait = 1;
  RndChange = 18;
  RndChangeStay = 1;
  RndDanger = 4;

type
  tByte = array[0..MaxInt-1] of byte;
  tWord = array[0..MaxInt div 2 - 1] of word;
  tInteger = array[0..MaxInt div 4 - 1] of integer;

  tDirect = tdNone..tdStay;
  tField  = integer; // tfNothing..tfRabbit;
  tTImage = tiEmpty..tiRabbitRight;

  tNemo = class
    Nick   : string;
    Direct : tDirect;
    ID     : integer;
    Color  : byte;
    TagTCP : integer;

    procedure Step; virtual; abstract;
    destructor Destroy; override;
    private
    procedure GetDXDYDirect(var dx, dy: integer);
  end;

  tPiton = class(tNemo)
    Len       : integer;
    Dead      : boolean;
    Head, Tail,
    DeadStep  : integer;
    ColorAdd  : byte;
    KillRabbit,
    KillPiton : integer;

    constructor Create(_ID, LBuf, XHead, YHead, XTail, YTail : integer;
                       Col1, Col2: byte; Nck: string);
    destructor Destroy; override;
    procedure Step; override;
    procedure GetXY(var X,Y: byte; NBuf: integer);

    private
    Buffer       : pointer;
    LenBuff,
    IncLen       : integer;

    procedure SetXY(X,Y: byte; NBuf: integer);
    function IdxImage(NBuf: integer): tTImage;
    function NBufInc(NBuf: integer): integer;
    function NBufDec(NBuf: integer): integer;
    procedure Death;
  end;

  tPitonComp = class(tPiton)
    procedure Step; override;
  end;

  tRabbit = class(tNemo)
    constructor Create(_ID: integer; Col: byte);
    procedure Step; override;

    public
    X, Y              : integer;

    private

    Look              : tDirect;
    NoWait, CurNoWait : integer;

    procedure ChangeDirect;
    procedure Init;
    procedure DrawRabbit;
    function ChNoWait: boolean; virtual;
    function Danger: boolean;
  end;

  tRabbitComp = class(tRabbit)
    function ChNoWait: boolean; override;
  end;

  tContr = class
    Enim: tNemo;
    bBuf: boolean;
    aBuf: tList;

    procedure SendControl(Cntrl: integer); virtual;
    procedure AddContr(Cntrl: word);
    constructor Create(En: tNemo);
    destructor Destroy; override;
    procedure AddDirect(i: integer);
    private
    aCntrl: tList;
  end;

  tContrDbl = class(tContr)
    procedure SendControl(Cntrl: integer); override;
  end;

implementation

uses UFMain;

destructor tContr.Destroy; begin
  aCntrl.Free;
  aBuf.Free;
  inherited
end;

constructor tContr.Create; begin
  Enim:=En;
  aCntrl:=tList.Create;
  aBuf:=tList.Create;
  bBuf:=true;
end;

procedure tContr.AddDirect; begin
  if aBuf.Count = 0 then aBuf.Add(pointer(i))
  else
    if not bBuf then aBuf.Items[0]:=pointer(i)
    else
      if aBuf.Items[aBuf.Count-1] <> pointer(i) then aBuf.Add(pointer(i))
end;

procedure tContr.SendControl;
var i: integer;
begin
  for i:=0 to aCntrl.Count - 1 do
    if integer(aCntrl.Items[i]) = Cntrl then AddDirect(i)
end;

procedure tContrDbl.SendControl;
var i, dir: integer;
begin
  for i:=0 to aCntrl.Count - 1 do
    if integer(aCntrl.Items[i]) = Cntrl then begin
      if i = 0 then
        case Enim.Direct of
          tdLeft: dir:=tdDown;
          tdRight: dir:=tdUp;
          tdUp: dir:=tdLeft;
          tdDown: dir:=tdRight;
        end
      else
        case Enim.Direct of
          tdLeft: dir:=tdUp;
          tdRight: dir:=tdDown;
          tdUp: dir:=tdRight;
          tdDown: dir:=tdLeft;
        end;
      AddDirect(dir)
    end
end;

procedure tContr.AddContr; begin
  aCntrl.Add(pointer(integer(Cntrl)))
end;

destructor tNemo.Destroy; begin
  inherited
end;

procedure tNemo.GetDXDYDirect; begin
  case Direct of
    tdUp: begin dX:=0; dY:=1; end;
    tdDown: begin dX:=0; dY:=-1; end;
    tdLeft: begin dX:=-1; dY:=0; end;
    tdRight: begin dX:=1; dY:=0; end;
    else begin dx:=0; dy:=0 end;
  end
end;

constructor tRabbit.Create; begin
  ID:=_ID; Nick:='';
  Color:=Col;
  Init;
end;

procedure tRabbit.ChangeDirect; begin
  if ChNoWait or (Direct = tdNone) then begin
    Look:=Random(tdRight+1);
    if ChNoWait then Direct:=Random(tdStay+1)
    else Direct:=tdStay
  end;
  if Random(RndNoWait) = 0 then
    if ChNoWait then NoWait:=Random(MaxNoWait)
    else NoWait:=0
  else NoWait:=0;
  CurNoWait:=0;
  DrawRabbit;
end;

procedure tRabbit.DrawRabbit; begin
  if Look = tdLeft then FMain.SetField(X,Y,tiRabbitLeft,ID,Color,0)
  else FMain.SetField(X,Y,tiRabbitRight,ID,Color,0)
end;

procedure tRabbit.Init; begin
  Direct:=tdNone;
  if FMain.NewRabbit(X,Y) then ChangeDirect
end;

function tRabbit.ChNoWait; begin
  ChNoWait:=false
end;

function tRabbitComp.ChNoWait; begin
  ChNoWait:=true
end;

function tRabbit.Danger;
var
  i     : integer;
  xP, yP: byte;
begin
  Danger:=false;
  if ChNoWait then
    with FMain do
      for i:=0 to lEnimals.Count-1 do
        if tNemo(lEnimals.Items[i]) is tPiton then
          with tPiton(lEnimals.Items[i]) do begin
            GetXY(xP, yP, Head);
            if ((xP = X) or (yP = Y)) and (Random(RndDanger) = RndDanger-1) then begin
              if yP = Y then Self.Direct:=Random(2)+tdUp
              else Self.Direct:=Random(tdRight+1);
              Danger:=true; exit
            end
          end
end;

procedure tRabbit.Step;
var dx, dy, em: integer;
begin
  if Direct = tdNone then Init
  else begin
    if (Random(RndChange) = RndChange-1) then ChangeDirect;
    Danger;
    inc(CurNoWait);
    if CurNoWait > NoWait then begin
      CurNoWait:=0;
      if Direct <> tdStay then begin
        FMain.SetField(X,Y,tiEmpty,0,Color,0);
        if (Look = tdRight) and (Direct = tdLeft) then Look:=tdLeft
        else
          if (Look = tdLeft) and (Direct = tdRight) then Look:=tdRight
          else begin
            GetDXDYDirect(dx,dy);
            if FMain.VerifyField(X+dx,Y+dy,false,em) = tfEmpty then begin
              X:=X+dx; Y:=Y+dy
            end
            else
              if ChNoWait then Direct:=Random(tdStay+1)
          end;
        DrawRabbit;
      end
    end
  end
end;

procedure tPiton.SetXY; begin
  tByte(Buffer^)[NBuf*2]:=X;
  tByte(Buffer^)[NBuf*2+1]:=Y;
end;

procedure tPiton.GetXY; begin
  X:=tByte(Buffer^)[NBuf*2];
  Y:=tByte(Buffer^)[NBuf*2+1];
end;

constructor tPiton.Create; begin
  TagTCP:=-1;
  Dead:=false; DeadStep:=-1; KillRabbit:=0; KillPiton:=0;
  Color:=Col1; Nick:=Nck;
  ColorAdd:=Col2;
  ID:=_ID;
  LenBuff:=LBuf;
  GetMem(Buffer, 2*LenBuff);
  if XHead < XTail then Direct:=tdLeft else
    if XHead > XTail then Direct:=tdRight else
      if YHead > YTail then Direct:=tdUp else
        if YHead < YTail then Direct:=tdDown;
  Tail:=0; SetXY(XTail, YTail, Tail);
  Head:=1; SetXY(XHead, YHead, Head);
  FMain.SetField(XHead, YHead, IdxImage(Head),ID,Color,ColorAdd);
  FMain.SetField(XTail, YTail, IdxImage(Tail),ID,Color,ColorAdd);
  Len:=2; IncLen:=0;
end;

destructor tPiton.Destroy; begin
  FreeMem(Buffer);
  inherited;
end;

function tPiton.NBufInc; begin
  if NBuf = LenBuff-1 then NBufInc:=0
  else NBufInc:=NBuf+1
end;

function tPiton.NBufDec; begin
  if NBuf = 0 then NBufDec:=LenBuff-1
  else NBufDec:=NBuf-1
end;

function tPiton.IdxImage;
var X,Y,bX,bY,fX,fY: byte;
begin
  GetXY(X,Y,NBuf);
  GetXY(bX,bY,NBufDec(NBuf));
  GetXY(fX,fY,NBufInc(NBuf));

  if NBuf = Head then
    if X > bX then IdxImage:=tiHeadRight else
      if X < bX then IdxImage:=tiHeadLeft else
        if Y > bY then IdxImage:=tiHeadUp else
          IdxImage:=tiHeadDown
  else
    if NBuf = Tail then
      if X > fX then IdxImage:=tiTailRight else
        if X < fX then IdxImage:=tiTailLeft else
          if Y > fY then IdxImage:=tiTailUp else
            IdxImage:=tiTailDown
    else
      if bX = fX then
        if bY < fY then IdxImage:=tiDownUp else
          IdxImage:=tiUpDown
      else
        if bY = fY then
          if bX < fX then IdxImage:=tiLeftRight else
            IdxImage:=tiRightLeft
        else

          if bX < fX then
            if Y = fY then
              if y > bY then IdxImage:=tiDownRight else
                IdxImage:=tiUpRight
            else
              if y < fY then IdxImage:=tiLeftUp else
                IdxImage:=tiLeftDown
          else
            if Y = fY then
              if y > bY then IdxImage:=tiDownLeft else
                IdxImage:=tiUpLeft
            else
              if y < fY then IdxImage:=tiRightUp else
                IdxImage:=tiRightDown
end;

procedure tPiton.Step;
var
  dX, dY, oldHead,
  gID, dID       : integer;
  oldX, oldY,
  newX, newY     : byte;
  vf             : tField;
  bMoveTail      : boolean;
begin
  if not Dead then begin
    GetDXDYDirect(dX, dY);
    GetXY(oldX, oldY, Head);
    newX:=oldX+dX; newY:=oldY+dY;
    oldHead:=Head;
    bMoveTail:=true;
    vf:=FMain.VerifyField(newX, newY, true, gID);
    if (vf = tfPiton) or (vf = tfNothing) then
      if FMain.bKill then begin
        if gID <> -1 then begin
          if gID = ID then dID:=-1
          else dID:=1;
          inc(tPiton(FMain.IDFind(gID)).KillPiton, dID);
        end;
        Death; exit;
      end
      else
        if Len > 2 then Dec(Len)
        else bMoveTail:=false
    else begin
      Head:=NBufInc(Head);
      SetXY(newX, newY, Head);
      FMain.SetField(oldX, oldY, IdxImage(oldHead),ID,Color,ColorAdd);
      FMain.SetField(newX, newY, IdxImage(Head),ID,Color,ColorAdd);
      if vf = tfRabbit then begin
        IncLen:=IncLen+Random(maxIncLen)+1;
        inc(KillRabbit)
      end
    end;

    if IncLen > 0 then begin
      Dec(IncLen); Inc(Len)
    end
    else
      if bMoveTail then begin
        GetXY(newX, newY, Tail);
        FMain.SetField(newX, newY, tiEmpty,0,Color,ColorAdd);
        Tail:=NBufInc(Tail);
        GetXY(newX, newY, Tail);
        FMain.SetField(newX, newY, IdxImage(Tail),ID,Color,ColorAdd);
      end;
  end
end;

procedure tPitonComp.Step;
type tArr = array[1..(MaxInt div sizeof(integer)) div 3, 0..2] of word;
const
  px: array[1..4] of integer = (-1,1,0,0);
  py: array[1..4] of integer = (0,0,1,-1);
  pr: array[1..8,1..4] of byte =
     ((3,2,1,4),(2,3,4,1),(4,2,1,3),(2,4,3,1),
      (3,1,2,4),(1,3,4,2),(4,1,2,3),(1,4,3,2));
var
  Fld, Curr, Nxt, p: pointer;
  xP, yP, q        : byte;
  CntCurr, CntNext,
  i, idT, dx, dy,
  o, xR, yR        : integer;

  procedure ToFld(X,Y: integer; Val: word); begin
    tWord(Fld^)[Y*FMain.sizeX+X]:=Val
  end;

  function FromFld(X,Y: integer): word; begin
    if (X in [0..FMain.sizeX-1]) and (Y in [0..FMain.sizeY-1]) then
      FromFld:=tWord(Fld^)[Y*FMain.sizeX+X]
    else FromFld:=tfPiton
  end;

  procedure AddRabbitToFld;
  var i: integer;
  begin
    CntNext:=0;
    with FMain do
      for i:=0 to lEnimals.Count-1 do
        if tNemo(lEnimals.Items[i]) is tRabbit then with tRabbit(lEnimals.Items[i]) do
          if Direct <> tdNone then begin
            inc(CntNext);
            tArr(Nxt^)[CntNext, 0]:=X;
            tArr(Nxt^)[CntNext, 1]:=Y;
            tArr(Nxt^)[CntNext, 2]:=ID;
          end;
  end;

  procedure Mark(x,y,id: integer);
  var i: integer;
  begin
    for i:=1 to 4 do
      if FromFld(x+px[i], y+py[i]) = 0 then begin
        ToFld(x+px[i], y+py[i], id);
        inc(CntNext);
        tArr(Nxt^)[CntNext, 0]:=x+px[i];
        tArr(Nxt^)[CntNext, 1]:=y+py[i];
        tArr(Nxt^)[CntNext, 2]:=id;
      end;
  end;

  procedure FindRabbit(var xR, yR: integer);
  var i, l, lmin: integer;
  begin
    lmin:=MaxInt; xR:=-1; yR:=-1;
    with FMain do
      for i:=0 to lEnimals.Count-1 do
        if tNemo(lEnimals.Items[i]) is tRabbit then
          with tRabbit(lEnimals.Items[i]) do
            if Direct <> tdNone then begin
              l:=round(sqrt((X-xP)*(X-xP) + (Y-yP)*(Y-yP)));
              if l < lmin then begin
                lmin:=l; xR:=X; yR:=Y
              end
            end
  end;

begin
  if not Dead then begin
    with FMain do begin
      GetMem(Fld, SizeOf(word)*sizeX*sizeY);
      Move(Field^, Fld^, SizeOf(word)*sizeX*sizeY);
      GetXY(xP, yP, Head);
      ToFld(xP, yP, 0);
      GetMem(Curr, sizeX*sizeY*sizeof(word)*3);
      GetMem(Nxt, sizeX*sizeY*sizeof(word)*3);

      AddRabbitToFld;
      repeat
        p:=Curr; Curr:=Nxt; Nxt:=p;
        CntCurr:=CntNext; CntNext:=0;
        for i:=1 to CntCurr do
          Mark(tArr(Curr^)[i,0], tArr(Curr^)[i,1], tArr(Curr^)[i,2]);
        idT:=FromFld(xP, yP);
      until (idT <> 0) or (CntNext = 0);

      if idT <> 0 then with tRabbit(FMain.IDFind(idT)) do begin
        xR:=X; yR:=Y
      end
      else FindRabbit(xR, yR);

      if xR <> -1 then begin
        dx:=xR-xP; dy:=yR-yP;
        if dx >= 0 then
          if dy >= 0 then
            if abs(dy) > abs(dx) then q:=1 else q:=2
          else
            if abs(dy) > abs(dx) then q:=3 else q:=4
        else
          if dy >= 0 then
            if abs(dy) > abs(dx) then q:=5 else q:=6
          else
            if abs(dy) > abs(dx) then q:=7 else q:=8;
      end
      else q:=random(8)+1;
      for i:=1 to 4 do begin
        o:=FromFld(xP+px[pr[q,i]], yP+py[pr[q,i]]);
        if (o = idT) or ((CntNext = 0) and ((o = tfEmpty) or (o >= tfRabbit))) then begin
          Direct:=pr[q,i]-1; break
        end
      end;

    end;
    FreeMem(Nxt);
    FreeMem(Curr);
    FreeMem(Fld);
    inherited;
  end
end;

procedure tPiton.Death;
var
  i     : integer;
  gX, gY: byte;
begin
  Dead:=true; DeadStep:=FMain.StepNumber;
  i:=Tail;
  repeat
    GetXY(gX, gY, i);
    FMain.SetField(gX, gY, tiEmpty, 0, Color, ColorAdd);
    i:=NBufInc(i);
  until i = Head;
  GetXY(gX, gY, i);
  FMain.SetField(gX, gY, tiEmpty, 0, Color, ColorAdd);
end;

end.

