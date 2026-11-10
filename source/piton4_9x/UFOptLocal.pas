unit UFOptLocal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, RXCtrls;

const
  vk_MouseLeft   = $7FFF;
  vk_MouseRight  = $7FFE;
  vk_MouseMiddle = $7FFD;

  CntKeys = 97;
  aWrKeys : array[0..CntKeys] of string =
  (
   'MouseLeft',
   'MouseRight',
   'MouseMiddle',
   'Left',
   'Right',
   'Up',
   'Down',
   'Insert',
   'Delete',
   'Home',
   'End',
   'PageUp',
   'PageDown',
   'NumPad0',
   'NumPad1',
   'NumPad2',
   'NumPad3',
   'NumPad4',
   'NumPad5',
   'NumPad6',
   'NumPad7',
   'NumPad8',
   'NumPad9',
   'NumDel',
   'Num+',
   'Num-',
   'Num*',
   'Num/',
   'ScrollLock',
   'Pause',

   '1',
   '2',
   '3',
   '4',
   '5',
   '6',
   '7',
   '8',
   '9',
   '0',

   'A',
   'B',
   'C',
   'D',
   'E',
   'F',
   'G',
   'H',
   'I',
   'J',
   'K',
   'L',
   'M',
   'N',
   'O',
   'P',
   'Q',
   'R',
   'S',
   'T',
   'U',
   'V',
   'W',
   'X',
   'Y',
   'Z',

   '`',
   '-',
   '=',
   '\',
   '[',
   ']',
   ';',
   '''',
   ',',
   '.',
   '/',

   'Space',
   'LShift',
   'RShift',
   'LCntrl',
   'RCntrl',
   'BackSpace',
   'Tab',
   'Enter',

   'F1',
   'F2',
   'F3',
   'F4',
   'F5',
   'F6',
   'F7',
   'F8',
   'F9',
   'F10',
   'F11',
   'F12',
   'Esc'
   );

  aCodeKeys : array[0..CntKeys] of word =
  (
   vk_MouseLeft,
   vk_MouseRight,
   vk_MouseMiddle,
   vk_Left,
   vk_Right,
   vk_Up,
   vk_Down,
   vk_Insert,
   vk_Delete,
   vk_Home,
   vk_End,
   vk_Prior,
   vk_Next,
   vk_NumPad0,
   vk_NumPad1,
   vk_NumPad2,
   vk_NumPad3,
   vk_NumPad4,
   vk_NumPad5,
   vk_NumPad6,
   vk_NumPad7,
   vk_NumPad8,
   vk_NumPad9,
   vk_Decimal,
   vk_Add,
   vk_SubTract,
   vk_Multiply,
   vk_Divide,
   vk_Scroll,
   vk_Pause,

   $30,
   $31,
   $32,
   $33,
   $34,
   $35,
   $36,
   $37,
   $38,
   $39,

   $41,
   $42,
   $43,
   $44,
   $45,
   $46,
   $47,
   $48,
   $49,
   $4A,
   $4B,
   $4C,
   $4D,
   $4E,
   $4F,
   $50,
   $51,
   $52,
   $53,
   $54,
   $55,
   $56,
   $57,
   $58,
   $59,
   $5A,

   192,
   189,
   187,
   220,
   219,
   221,
   186,
   222,
   188,
   190,
   191,

   vk_Space,
   vk_LShift,
   vk_RShift,
   vk_LControl,
   vk_RControl,
   vk_Back,
   vk_Tab,
   vk_Return,

   vk_F1,
   vk_F2,
   vk_F3,
   vk_F4,
   vk_F5,
   vk_F6,
   vk_F7,
   vk_F8,
   vk_F9,
   vk_F10,
   vk_F11,
   vk_F12,
   vk_Escape
   );

type
  tDataContr = class
    idx: integer;
    bHum, bStd, bBuf: boolean;
    idxLeft, idxRight, idxUp,
    idxDown, idxNoPo, idxPo,
    idxStop: integer;
    Color, ColorAdd: byte;
    Nick: string;
    public
    procedure Assign(DC: tDataContr);
  end;

  TFOptLocal = class(TForm)
    CBNew: TComboBox;
    BBAdd: TBitBtn;
    LBObj: TListBox;
    BBDel: TBitBtn;
    LHum: TLabel;
    RBStd: TRadioButton;
    RBSokr: TRadioButton;
    Label3: TLabel;
    CBLeft: TComboBox;
    Label4: TLabel;
    CBRight: TComboBox;
    Label5: TLabel;
    CBUp: TComboBox;
    Label6: TLabel;
    CBDown: TComboBox;
    Label7: TLabel;
    CBNoPo: TComboBox;
    Label8: TLabel;
    CBPo: TComboBox;
    CBBuf: TCheckBox;
    Panel1: TPanel;
    LCntrl: TLabel;
    RBHum: TRadioButton;
    RBComp: TRadioButton;
    LCol: TLabel;
    LColDop: TLabel;
    PBColor: TPaintBox;
    PBColorAdd: TPaintBox;
    BBOpen: TBitBtn;
    BBSave: TBitBtn;
    ODEnim: TOpenDialog;
    SDEnim: TSaveDialog;
    BBUp: TBitBtn;
    BBDown: TBitBtn;
    LStop: TLabel;
    CBStop: TComboBox;
    PLine1: TPanel;
    PLine2: TPanel;
    BBOk: TBitBtn;
    BBCancel: TBitBtn;
    LName: TLabel;
    EName: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LBObjClick(Sender: TObject);
    procedure BBAddClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BBDelClick(Sender: TObject);
    procedure CBLeftChange(Sender: TObject);
    procedure RBCompClick(Sender: TObject);
    procedure RBStdClick(Sender: TObject);
    procedure CBBufClick(Sender: TObject);
    procedure PBColorPaint(Sender: TObject);
    procedure PBColorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BBOpenClick(Sender: TObject);
    procedure BBSaveClick(Sender: TObject);
    procedure BBUpClick(Sender: TObject);
    procedure BBDownClick(Sender: TObject);
    procedure ENameChange(Sender: TObject);

    private
    BM: tBitMap;

    procedure WriteObj;
    procedure Enableds(WC: tWinControl; en: boolean);
    procedure MakeBitMap;
    procedure Cursor(PB: tPaintBox; Color: byte);

    public
    lObj: tList;

    procedure AddObj(i: integer);
    procedure Swap(idx, dy: integer);
  end;

implementation

uses UFMain, UPiton;

{$R *.DFM}

procedure tDataContr.Assign; begin
  idx:=DC.idx;
  bHum:=DC.bHum;
  bStd:=DC.bStd;
  bBuf:=DC.bBuf;
  idxLeft:=DC.idxLeft;
  idxRight:=DC.idxRight;
  idxUp:=DC.idxUp;
  idxDown:=DC.idxDown;
  idxNoPo:=DC.idxNoPo;
  idxStop:=DC.idxStop;
  idxPo:=DC.idxPo;
  Color:=DC.Color;
  ColorAdd:=DC.ColorAdd;
  Nick:=DC.Nick
end;

procedure TFOptLocal.Enableds;
var i: integer;
begin
  for i:=0 to WC.ComponentCount-1 do
    if WC.Components[i].Tag = 1 then tWinControl(WC.Components[i]).Enabled:=en;
end;

procedure TFOptLocal.WriteObj; begin
  with LBObj do
    if (Items.Count > 0) and (ItemIndex >= 0) then
      with tDataContr(Items.Objects[ItemIndex]) do begin
        Enableds(Self, true);
        RBComp.Checked:=not bHum;
        RBHum.Checked:=bHum;
        RBStd.Checked:=bStd;
        RBSokr.Checked:=not bStd;
        CBLeft.ItemIndex:=idxLeft;
        CBRight.ItemIndex:=idxRight;
        CBDown.ItemIndex:=idxDown;
        CBUp.ItemIndex:=idxUp;
        CBNoPo.ItemIndex:=idxNoPo;
        CBPo.ItemIndex:=idxPo;
        CBStop.ItemIndex:=idxStop;
        CBBuf.Checked:=bBuf;
        EName.Text:=Nick;
        PBColorPaint(nil);
        if idx <> 0 then begin
          LColDop.Enabled:=false;
          PBColorAdd.Enabled:=false;
          LStop.Enabled:=true;
          CBStop.Enabled:=true;
        end
        else begin
          LStop.Enabled:=false;
          CBStop.Enabled:=false;
        end;

        BBUp.Enabled:=ItemIndex <> 0;
        BBDown.Enabled:=ItemIndex <> Items.Count-1;

      end
    else Enableds(Self, false)
end;

procedure TFOptLocal.AddObj;
var DC: tDataContr;
begin
  DC:=tDataContr.Create;
  with DC do begin
    idx:=i;
    bHum:=false;
    bStd:=true;
    bBuf:=true;
    idxLeft:=3;
    idxRight:=4;
    idxUp:=5;
    idxDown:=6;
    idxNoPo:=0;
    idxPo:=1;
    idxStop:=77;
    Randomize;
    Color:=random(15)+1;
    ColorAdd:=random(15)+1;
    Nick:='bot';

    LBObj.Items.AddObject(CBNew.Items[idx], DC);
    LBObj.ItemIndex:=LBObj.Items.Count-1;
    WriteObj
  end;
end;

procedure TFOptLocal.FormCreate(Sender: TObject);
var i: integer;
begin
  PBColor.Width:=16*15;
  PBColor.Height:=16;
  PBColorAdd.Width:=16*15;
  PBColorAdd.Height:=16;
  BM:=tBitMap.Create;
  BM.PixelFormat:=pf8bit;
  BM.Width:=PBColor.Width;
  BM.Height:=PBColorAdd.Width;
  MakeBitMap;

  lObj:=tList.Create;
  CBNew.ItemIndex:=0;
  for i:=0 to CntKeys do CBLeft.Items.Add(aWrKeys[i]);
  CBRight.Items.Assign(CBLeft.Items);
  CBUp.Items.Assign(CBLeft.Items);
  CBDown.Items.Assign(CBLeft.Items);
  CBNoPo.Items.Assign(CBLeft.Items);
  CBPo.Items.Assign(CBLeft.Items);
  CBStop.Items.Assign(CBLeft.Items);
end;

procedure TFOptLocal.FormDestroy(Sender: TObject); begin
  lObj.Free;
end;

procedure TFOptLocal.LBObjClick(Sender: TObject); begin
  WriteObj
end;

procedure TFOptLocal.BBAddClick(Sender: TObject);
var i, cnt, max: integer;
begin
  if CBNew.ItemIndex = 0 then begin
    cnt:=0;
    for i:=0 to LBObj.Items.Count-1 do
      if tDataContr(LBObj.Items.Objects[i]).idx = 0 then inc(cnt);
    max:=FMain.MaxCntPitons(FMain.MinSize);
    if cnt >= max then begin
      MessageDlg('Слишком много питонов. Для данного размера поля их максимальное количество равно '+IntToStr(max)+'.',
                 mtInformation, [mbCancel], 0);
      exit
    end
  end;
  Addobj(CBNew.ItemIndex)
end;

procedure TFOptLocal.FormShow(Sender: TObject); begin
  WriteObj;
end;

procedure TFOptLocal.BBDelClick(Sender: TObject);
var i: integer;
begin
  i:=LBObj.ItemIndex;
  LBObj.Items.Delete(i);
  dec(i);
  if LBObj.Items.Count > 0 then
    if i >=0 then LBObj.ItemIndex:=i
    else LBObj.ItemIndex:=0;
  WriteObj
end;

procedure TFOptLocal.CBLeftChange(Sender: TObject); begin
  with tDataContr(LBObj.Items.Objects[LBObj.ItemIndex]) do begin
    idxLeft:=CBLeft.ItemIndex;
    idxRight:=CBRight.ItemIndex;
    idxUp:=CBUp.ItemIndex;
    idxDown:=CBDown.ItemIndex;
    idxNoPo:=CBNoPo.ItemIndex;
    idxPo:=CBPo.ItemIndex;
    idxStop:=CBStop.ItemIndex;
  end
end;

procedure TFOptLocal.RBCompClick(Sender: TObject); begin
  with tDataContr(LBObj.Items.Objects[LBObj.ItemIndex]) do bHum:=RBHum.Checked;
end;

procedure TFOptLocal.RBStdClick(Sender: TObject); begin
  with tDataContr(LBObj.Items.Objects[LBObj.ItemIndex]) do bStd:=RBStd.Checked;
end;

procedure TFOptLocal.CBBufClick(Sender: TObject); begin
  with tDataContr(LBObj.Items.Objects[LBObj.ItemIndex]) do bBuf:=CBBuf.Checked;
end;

procedure TFOptLocal.MakeBitMap;
var i,j: integer;
begin
  for i:=1 to 15 do
    for j:=0 to 15 do
      FillChar(tByte(BM.ScanLine[j]^)[(i-1)*16], 16, i);
end;

procedure TFOptLocal.Cursor;
var i: integer;
begin
  for i:=0 to 6 do
    FillChar(tByte(BM.ScanLine[5+i]^)[5+(Color-1)*16], 6, 0);
end;

procedure TFOptLocal.PBColorPaint(Sender: TObject); begin
  MakeBitMap;
  if (LBObj.Items.Count > 0) and (LBObj.ItemIndex >= 0) then
    Cursor(PBColor, tDataContr(LBObj.Items.Objects[LBObj.ItemIndex]).Color);
  PBColor.Canvas.Draw(0,0,BM);
  MakeBitMap;
  if (LBObj.Items.Count > 0) and (LBObj.ItemIndex >= 0) and
     (tDataContr(LBObj.Items.Objects[LBObj.ItemIndex]).idx = 0) then
    Cursor(PBColor, tDataContr(LBObj.Items.Objects[LBObj.ItemIndex]).ColorAdd);
  PBColorAdd.Canvas.Draw(0,0,BM);
end;

procedure TFOptLocal.PBColorMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Sender = PBColor then
    tDataContr(LBObj.Items.Objects[LBObj.ItemIndex]).Color:=X div 16 +1
  else
    tDataContr(LBObj.Items.Objects[LBObj.ItemIndex]).ColorAdd:=X div 16 +1;
  PBColorPaint(nil);
end;

procedure TFOptLocal.BBOpenClick(Sender: TObject); begin
  ODEnim.InitialDir:=FMain.NormalPath;
  if ODEnim.Execute then begin
    FMain.OpenObj(ODEnim.FileName);
    Close;
    ModalResult:=mrRetry;
  end;
end;

procedure TFOptLocal.BBSaveClick(Sender: TObject);
var b: boolean;
begin
  SDEnim.InitialDir:=FMain.NormalPath;
  if SDEnim.Execute then begin
    b:=FileExists(SDEnim.FileName);
    if (not b) or (b and (MessageDlg('Файл с именем'#13#10'"'+SDEnim.FileName+
       '"'#13#10'уже существует! Переписать?', mtConfirmation, [mbYes, mbNo], 0) = mrYes)) then begin
      FMain.SaveDlgToList(LBObj);
      FMain.SaveObj(SDEnim.FileName);
    end
  end
end;

procedure TFOptLocal.Swap;
var
  s: string;
  p: pointer;
begin
  with LBObj do begin
    s:=Items[idx];
    p:=Items.Objects[idx];
    Items[idx]:=Items[idx+dy];
    Items.Objects[idx]:=Items.Objects[idx+dy];
    Items[idx+dy]:=s;
    Items.Objects[idx+dy]:=p;
    ItemIndex:=ItemIndex+dy
  end
end;

procedure TFOptLocal.BBUpClick(Sender: TObject); begin
  Swap(LBObj.ItemIndex, -1)
end;

procedure TFOptLocal.BBDownClick(Sender: TObject); begin
  Swap(LBObj.ItemIndex, 1)
end;

procedure TFOptLocal.ENameChange(Sender: TObject); begin
  tDataContr(LBObj.Items.Objects[LBObj.ItemIndex]).Nick:=tEdit(Sender).Text
end;

end.

