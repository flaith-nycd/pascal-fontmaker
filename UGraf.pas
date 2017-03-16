unit UGraf;

interface

  procedure LoadFont(FontName : string);
  procedure SetPos(X, Y : Integer);
  procedure DrawCar(b: TCanvas; WhatCar : char; Couleur : TColor; Shadow : Boolean);
  procedure DrawText(b: Tcanvas; WhatText : String; X1, Y1 : Integer; Couleur : TColor; Shadow : Boolean);

const
  alphabet = '!"#$%&'+chr(39)+'()*+,-./0123456789:;<=>?'
            +'@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_'
            +'`abcdefghijklmnopqrstuvwxyz{|}~'
            +chr(127)+chr(169);

  Clr_R = clRed;                       // couleur Alignement à droite
  Clr_D = clLime;                      // couleur Alignement en bas
  Clr_G = clGray;                      // couleur grille

  entete : array[0..15] of byte =
           ($46,$54,$42,$02,$00,$A9,$32,$30,$30,$34,$20,$4E,$59,$43,$44,$00);
  Pix    : array[0..1]  of byte = ($D7,$00);
  NoPix  : array[0..1]  of byte = ($00,$00);
  vide   : array[0..12] of byte =
           ($00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00);

type
  Tcar = record
    TheCar : char;                     // le caractère
    ch : array [1..20,1..20] of byte;  // Maximum pour un car = 20x20 pixels
  end;

  TbPoint = packed record
    X : LongInt;
    Y : LongInt;
    X1: LongInt;
    Y1: LongInt;
  end;

var
  ArrayPoint : array[0..96] of TbPoint;     // 97 caractères
  Xpos : integer;
  largeur : integer;
  nbcol,nblig : integer;
  nbcar : integer;                          // Nbre de car généré
  Tab_Alpha : array[0..96] of Tcar;         // Table des caractères (97 max)
  TabChar : array[0..96] of char;           // Pour verif des caractères saisis
  entetefile : array[0..15] of byte;
  videfile : array[0..12] of byte;
  FNTLargeur, FNTNBLigne, FNTNBColonne : integer;
  Space_Right, Space_Down : integer;

implementation

procedure LoadFont(FontName : string);
var
  b : file;
  i, j, k : integer;
  cc : char;
  pixfile : byte;
begin
  // on charge la fonte de caractères (si elle existe)
  for i:=0 to 96 do TabChar[i] := chr(255);
  if FileExists(FontName) then
    begin
      assignfile(b,FontName);
      reset(b,1);
      blockread(b,entetefile,16);
      for i:=0 to 15 do
      if entetefile[i] <> entete[i] then
      begin
        if MessageDlg('La fonte de caractères "'+FontName+
           '" ne correspond pas à l''entête !!!'+#13#10+
           'Vous n''utilisez pas une fonte générée par FontMaker ][, ou celle-ci est'+#13#10+
           'défectueuse.',
           mtError, [mbOk], 0) = mrOk then
          application.Terminate;
      end;
      blockread(b,FNTNBLigne,1);
      blockread(b,FNTNBColonne,1);
      blockread(b,nbcar,1);
      blockread(b,space_right,1);
      blockread(b,space_down,1);
      blockread(b,videfile,11);

      if Space_Right = 0 then Space_Right := 1;
      if Space_Down = 0 then Space_Down := 1;

      // 1er car = espace
      for i := 1 to FNTNBLigne do
        for j := 1 to FNTNBColonne do
          Tab_Alpha[0].ch[i,j] := 0;
          Tab_Alpha[0].TheCar := ' ';
          TabChar[0] := ' ';

      for k := 1 to nbcar-1 do                  // on commence à 1 car
        begin                                   // pas le car. espace
          blockread(b,cc,1);
          Tab_Alpha[k].TheCar := cc;
          TabChar[k] := cc;
          for j := 1 to FNTNBLigne do
            for i := 1 to FNTNBColonne do
              begin
                blockread(b,pixfile,1);
                if pixfile = $D7 then Tab_Alpha[k].ch[i,j] := 1
                                 else Tab_Alpha[k].ch[i,j] := 0;
              end;
        end;
      closefile(b);
    end
  else
    if MessageDlg('Le fichier "'+FontName+'" n''existe pas !!!',
        mtError, [mbOk], 0) = mrOk then
        application.Terminate;
end;

Procedure SetPos(X, Y : Integer);
begin
  PosX := X*FNTNBColonne;     // Soit Colonne (0 à 79 ou moins ou plus)
  PosY := Y*FNTNBLigne;      // Soit Ligne   (0 à 23 pareil)
end;

Procedure DrawCar(b : TCanvas; WhatCar : char; Couleur : TColor; Shadow : Boolean);
Var
  i,j,k,oldx : Integer;
Begin
  for k := 1 to NbCarFont do
  if Tab_Alpha[k].TheCar = WhatCar then
    begin
    OldPosY := PosY;
    for i := 1 to FNTNBLigne do
      begin
        OldX := PosX;
        for j := 1 to FNTNBColonne do
          begin
            if Inverse then
              begin
                if (Tab_Alpha[k].ch[i,j]=0) then b.Pixels[PosX,PosY] := clWhite;
              end
            else
              begin
                if (Shadow) then
                  if Tab_Alpha[k].ch[i,j] = 1 then b.Pixels[PosX+1,PosY+1] := clBlack;
                if Tab_Alpha[k].ch[i,j] = 1 then b.Pixels[PosX,PosY] := couleur;
              end;
            inc(PosX);
          end;
          inc(PosY);
          PosX := OldX;
        end;
      PosY := OldPosY;
    end;
inc(PosX,FNTNBColonne);
end;

Procedure DrawText(b: TCanvas; WhatText : String; X1, Y1 : Integer; Couleur : TColor; Shadow : Boolean);
var
  long : integer;
begin
PosX := (X1*FNTNBColonne)-FNTNBColonne;
PosY := Y1*FNTNBLigne;
for long := 0 to length(WhatText) do
  Begin
    if WhatText[long] = #13 then
      begin
        Inc(Y1);
        SetPos(X1,Y1);
      end
    else DrawCar(b,WhatText[long],couleur,Shadow);
  end;
end;


end.
