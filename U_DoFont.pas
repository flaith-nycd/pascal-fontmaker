unit U_DoFont;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Windows, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Menus, Buttons;

type
  TFormFont = class(TForm)
    STColonne: TStaticText;
    STLigne: TStaticText;
    MouseX: TStaticText;
    MouseY: TStaticText;
    STRed: TStaticText;
    STGreen: TStaticText;
    STBlue: TStaticText;
    BevelCar: TBevel;
    BevelVertical: TBevel;
    BevelVert1: TBevel;
    ImgBox: TImage;
    PanelColor: TPanel;
    ImgCar: TImage;
    BevelImgBox: TBevel;
    ImgFond: TImage;
    MainMenuFont: TMainMenu;
    MenuFichier: TMenuItem;
    NouvelleFonte: TMenuItem;
    Ouvrir: TMenuItem;
    Enregistrer: TMenuItem;
    N1: TMenuItem;
    Quitter: TMenuItem;
    MenuAbout: TMenuItem;
    Aide: TMenuItem;
    Apropos: TMenuItem;
    ImgViseur: TImage;
    BtPrev: TSpeedButton;
    BtNext: TSpeedButton;
    STPosChar: TStaticText;
    LabelAlphabet: TLabel;
    BtValid: TBitBtn;
    STNbCar: TStaticText;
    OpenDialog: TOpenDialog;
    ImgArrayChar: TImage;
    ScrollBarImgArray: TScrollBar;
    BevelArrayChar: TBevel;
    Bevel1: TBevel;
    BevelHorizontal: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ImgBoxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure QuitterClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure BtNextClick(Sender: TObject);
    procedure BtPrevClick(Sender: TObject);
    procedure NouvelleFonteClick(Sender: TObject);
    procedure BtValidClick(Sender: TObject);
    procedure EnregistrerClick(Sender: TObject);
    procedure ImgBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImgBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ScrollBarImgArrayChange(Sender: TObject);
    procedure AproposClick(Sender: TObject);
    procedure OuvrirClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    FNTLargeur, FNTNBLigne, FNTNBColonne : integer;
    Space_Right, Space_Down : integer;
    LeftClick : boolean;                 // si appuie sur clic gauche
    RightClick : boolean;                // si appuie sur clic droit
    bArray : TBitmap;                    // L'image du tableau de caractères
    procedure PaintBoxFont(Sender: TObject);
    procedure FillBox(color : TColor; X, Y : integer);
    procedure LoadFont(FontName : string);
  end;

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

 // ci dessous la liste des positions que l'on retrouve de le fichier
 // TbPoint.CXY
{
 (1,18,41,47,43,18,83,47,85,18,125,47,127,18,167,47,169,18,209,47,
 211,18,251,47,253,18,293,47,295,18,335,47,337,18,377,47,379,18,419,47,
 421,18,461,47,463,18,503,47,505,18,545,47,          // 1ère ligne

 1,66,41,95,43,66,83,95,85,66,125,95,127,66,167,95,169,66,209,95,
 211,66,251,95,253,66,293,95,295,66,335,95,337,66,377,95,379,66,419,95,
 421,66,461,95,463,66,503,95,505,66,545,95,          // 2

 1,114,41,143,43,114,83,143,85,114,125,143,127,114,167,143,169,114,209,143,
 211,114,251,143,253,114,293,143,295,114,335,143,337,114,377,143,379,114,419,143,
 421,114,461,143,463,114,503,143,505,114,545,143,    // 3

 1,162,41,191,43,162,83,191,85,162,125,191,127,162,167,191,169,162,209,191,
 211,162,251,191,253,162,293,191,295,162,335,191,337,162,377,191,379,162,419,191,
 421,162,461,191,463,162,503,191,505,162,545,191,    // 4

 1,210,41,239,43,210,83,239,85,210,125,239,127,210,167,239,169,210,209,239,
 211,210,251,239,253,210,293,239,295,210,335,239,337,210,377,239,379,210,419,239,
 421,210,461,239,463,210,503,239,505,210,545,239,    // 5

 1,258,41,287,43,258,83,287,85,258,125,287,127,258,167,287,169,258,209,287,
 211,258,251,287,253,258,293,287,295,258,335,287,337,258,377,287,379,258,419,287,
 421,258,461,287,463,258,503,287,505,258,545,287,    // 6

 1,306,41,335,43,306,83,335,85,306,125,335,127,306,167,335,169,306,209,335,
 211,306,251,335,253,306,293,335,295,306,335,335,337,306,377,335,379,306,419,335,
 421,306,461,335,463,306,503,335,505,306,545,335,    // 7

 1,354,41,383,43,354,83,383,85,354,125,383,127,354,167,383,169,354,209,383,
 211,354,251,383);                                   // 8
}

var
  FormFont: TFormFont;

implementation

uses U_DoSize, U_DoAbout;              // Form de saisie du nom de la fonte
                                       // du nbre de lignes
                                       // et du nbre de colonnes + About Box

var Xpos : integer;
    largeur : integer;
    nbcol,nblig : integer;
    nbcar : integer;                   // Nbre de car généré
    Tab_Alpha : array[0..96] of Tcar;  // Table des caractères (97 max)
    TabChar : array[0..96] of char;    // Pour verif des caractères saisis
    entetefile : array[0..15] of byte;
    videfile : array[0..12] of byte;

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TFormFont.LoadFont(FontName : string);
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

procedure TFormFont.FormCreate(Sender: TObject);
var
  i : integer;
  f : file;
begin
  for i:=0 to 96 do TabChar[i] := chr(255);

  assignfile(f,'TbPoint.CXY');          // lecture du fichier des points
  reset(f,1);
  for i:=0 to 96 do                     // 96 car mais 4 points par car
    begin
//      blockwrite(f,ArrayPoint[i],sizeof(integer));
      blockread(f,ArrayPoint[i].X,sizeof(integer));
      blockread(f,ArrayPoint[i].Y,sizeof(integer));
      blockread(f,ArrayPoint[i].X1,sizeof(integer));
      blockread(f,ArrayPoint[i].X1,sizeof(integer));
    end;
  closefile(f);

  TabChar[0] := ' ';  // 1er caractère = espace
  FNTLargeur := 25;   // Largeur par défaut du carré à remplir
  FNTNBColonne := 8;  // Nbre Pixel pour Largeur (Width)
  FNTNBLigne := 9;    // Nbre Pixel pour Hauteur (Height)

  // On définit maintenant le nbre de Pixel séparant les caracères
  // entre eux (donc à droite et en bas)

  Space_Right := 1;   // Nbre pixel alignement à droite
  Space_Down  := 1;   // Nbre pixel alignement en bas

  nbcar := 1;         // Car espace tjrs présent donc commence à 1

  // on crée l'image du tableau des caractères

  bArray := TBitmap.Create;
  bArray.LoadFromFile(Application.GetNamePath+'ArrayChar.bmp');

  ImgArrayChar.Picture.Assign(bArray);

  // Variable pour la scrollbar

  ScrollBarImgArray.Max := ImgArrayChar.Height - 1; // Taille Maxi
  ScrollBarImgArray.LargeChange := 48*4;
  ScrollBarImgArray.SmallChange := 48*4;     // Nb de pixel de défilements
                                             // taille de la zone du car +
                                             // zone du car généré
                                             // x 4 car on a que le début et
                                             // la fin de l'image
  // Reste des initialisations

  ImgBox.Visible := False;
  BtValid.Enabled := False;
  BtPrev.Enabled := False;
  BtNext.Enabled := False;
  LeftClick := False;                      // Clic gauche : on affiche le point
  RightClick := False;                     // Clic droit : on efface le point
  FormFont.Caption := 'Font Maker ][ ©flaith-nycd 2004-2017';
  DoubleBuffered := True;                  // enlève le scintillement
  ImgCar.canvas.Brush.Color := clWhite;    // efface la zone caractère
  ImgCar.canvas.FillRect(Rect(0,0,Height,Width));
  ImgBox.canvas.Brush.Color := clWhite;    // efface la zone grille de saisie
  ImgBox.canvas.FillRect(Rect(0,0,Height,Width));
  ImgFond.canvas.Brush.Color := clSilver;  // Gris clair derrière img du car.
  ImgFond.canvas.FillRect(Rect(0,0,Height,Width));
  Xpos := 1;                               // on commence par le premier caractère
  LabelAlphabet.Caption := copy(Alphabet,Xpos,1);
  PaintBoxFont(nil);
  STPosChar.Caption := IntToStr(Xpos);
end;

procedure TFormFont.ScrollBarImgArrayChange(Sender: TObject);
begin
  ImgArrayChar.Canvas.CopyRect(rect(0,0,bArray.Width,bArray.Height),  // Destination
                               bArray.Canvas,                         // Canvas utilisé
                               rect(0,ScrollBarImgArray.Position,     // Source
                                    bArray.Width,bArray.Height+
                                    ScrollBarImgArray.Position));
end;

procedure TFormFont.PaintBoxFont(Sender: TObject);
var i:integer;
    TheRect : TRect;
begin                                               // affichage de la grille
  largeur := FNTLargeur;
  nbcol := FNTNBColonne;
  nblig := FNTNBLigne;
  ImgBox.Picture.Graphic.Width := largeur*nbcol+1;  // Définition de la taille
  ImgBox.Picture.Graphic.Height := largeur*nblig+1; // de la grille de saisie
  BevelImgBox.Width := largeur*nbcol+5;             // on ajuste le bevel autour
  BevelImgBox.Height := ImgBox.Picture.Graphic.Height+4;
  TheRect := Rect(0,0,largeur*nbcol+1,largeur*nblig+1); // création du rectangle
  ImgBox.Canvas.Brush.Color := clWhite;
  ImgBox.Canvas.FillRect(TheRect);                  // et on efface en blanc
  ImgBox.Canvas.Brush.Color := Clr_G;
  ImgBox.Canvas.FrameRect(TheRect);                 // on l'entoure en
  ImgBox.Canvas.Pen.Color := Clr_G;                 // couleur Clr_G soit Gris

    for i:=1 to Width-2 do                          // on créer les lignes de
      begin                                         // séparations
        ImgBox.Canvas.MoveTo(i*largeur,1);
        ImgBox.Canvas.LineTo(i*largeur,Height-1);   // Lignes horizontales
      end;
    for i:=1 to Height-2 do
      begin
        ImgBox.Canvas.MoveTo(1,i*largeur);
        ImgBox.Canvas.LineTo(Width-1,i*largeur);    // Lignes verticales
      end;

  // Affiche les zones pour l'espace du pixel à droite et en bas
  // cad colonne et ligne d'espacement entre les caractères
  ImgBox.Canvas.Pen.Color := Clr_R;
  // Ligne Verticale (à droite)
  ImgBox.Canvas.MoveTo((ImgBox.Width-Space_Right*largeur)-1,1);
  ImgBox.Canvas.LineTo((ImgBox.Width-Space_Right*largeur)-1,ImgBox.Height-1);
  // Ligne Horizontale (en bas)
  ImgBox.Canvas.Pen.Color := Clr_D;
  ImgBox.Canvas.MoveTo(1,(ImgBox.Height-Space_Down*largeur)-1);
  ImgBox.Canvas.LineTo(ImgBox.Width-1,(ImgBox.Height-Space_Down*largeur)-1);
end;

procedure TFormFont.FillBox(Color : TColor; X, Y : integer);
var
  WhatColor : TColor;
  OldX, OldY : integer;
  PosX, PosY, PosX1, PosY1 : integer;
  CarX, CarY : integer;
begin
  OldX := X; OldY := Y;
  WhatColor := GetPixel(ImgBox.Canvas.Handle,X,Y);
  while (WhatColor <> Clr_G) and
        (WhatColor <> Clr_R) and
        (WhatColor <> Clr_D) do
    begin                           // on verifie sur la position X
      dec(OldX);
      WhatColor := GetPixel(ImgBox.Canvas.Handle,OldX,Y);
    end;
  PosX := OldX+1;
  WhatColor := GetPixel(ImgBox.Canvas.Handle,PosX,Y);
  while (WhatColor <> Clr_G) and
        (WhatColor <> Clr_R) and
        (WhatColor <> Clr_D) do
    begin                           // on verifie sur la position Y
      dec(OldY);
      WhatColor := GetPixel(ImgBox.Canvas.Handle,PosX,OldY);
    end;
  PosY := OldY+1;                   // on connait valeur de X et Y
                                    // on génère X1 et Y1 pour le Rectangle
  PosX1 := PosX + FNTLargeur - 1;
  PosY1 := PosY + FNTLargeur - 1;
  ImgBox.Canvas.Brush.Color := color;
  ImgBox.Canvas.FillRect(Rect(PosX+2, PosY+2, PosX1-2, PosY1-2)); // on remplie
  CarX := ((PosX-1) div FNTLargeur);
  CarY := ((PosY-1) div FNTLargeur);
  ImgCar.Canvas.Pixels[Carx, CarY] := color;        // idem pour le car.
end;

procedure TFormFont.ImgBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  WhatColor : TColor;
begin
  MouseX.Caption := IntToStr(X);
  MouseY.Caption := IntToStr(Y);
  WhatColor := GetPixel(ImgBox.Canvas.Handle,X,Y);
  STRed.Caption   := IntToStr( (WhatColor And $0000FF)        ); //Rouge
  STGreen.Caption := IntToStr( (WhatColor And $00FF00) shr 8  ); //Vert
  STBlue.Caption  := IntToStr( (WhatColor And $FF0000) shr 16 ); //Bleu

  PanelColor.Color := WhatColor;
  X := StrToInt(MouseX.Caption);
  Y := StrToInt(MouseY.Caption);

  // On continue de  remplir si on a laissé le doigt appuyé sur
  // le clic gauche ou droit

  if (LeftClick) then
    begin
      WhatColor := GetPixel(ImgBox.Canvas.Handle,X,Y);
      If WhatColor = clWhite then           // si blanc alors on met en noir
        FillBox(clBlack, X, Y);
    end;
  if (RightClick) then
    begin
      WhatColor := GetPixel(ImgBox.Canvas.Handle,X,Y);
      If WhatColor = clBlack then           // si noir alors on met en blanc
        FillBox(clWhite, X, Y);
    end;
end;

procedure TFormFont.ImgBoxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  LeftClick := False;                       // On n'appuie plus sur clic gauche
  RightClick := False;                      // et sur clic droit
end;

procedure TFormFont.ImgBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  WhatColor : TColor;
begin
WhatColor := GetPixel(ImgBox.Canvas.Handle,X,Y);
if ssLeft in Shift then                   // si clic gauche
  begin
    If WhatColor = clWhite then           // si blanc alors on met en noir
      FillBox(clBlack, X, Y);
    LeftClick := True;
    RightClick := False;
  end;
if ssRight in Shift then                  // si clic droit
  begin
    If WhatColor = clBlack then           // si noir alors on met en blanc
      FillBox(clWhite, X, Y);
    LeftClick := False;
    RightClick := True;
  end;
end;

procedure TFormFont.QuitterClick(Sender: TObject);
begin
  if MessageDlg('Quitter l''application ?',
     mtConfirmation, [mbYes, mbNo], 0) = mrYes then
       application.Terminate;
end;

procedure TFormFont.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  QuitterClick(nil);
end;

procedure TFormFont.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  BevelHorizontal.Width := FormFont.Width;
  BevelVertical.Height := FormFont.Height;
end;

procedure TFormFont.BtNextClick(Sender: TObject);
var
  posX, posY : integer;
  PPosX, PPosY : integer;
  i,j : integer;
  lg : integer;
begin
  inc(Xpos);
  if Xpos > length(Alphabet) then Xpos := length(Alphabet);
  STPosChar.Caption := IntToStr(Xpos);
  if copy(Alphabet,Xpos,1) = '&' then LabelAlphabet.Caption := '&&'
  else LabelAlphabet.Caption := copy(Alphabet,Xpos,1);
  PaintBoxFont(nil);
  ImgCar.Canvas.Brush.Color := clWhite;
  ImgCar.Canvas.FillRect(rect(0,0,ImgCar.Width,ImgCar.Height));
  if TabChar[Xpos] <> chr(255) then
  begin
  PaintBoxFont(nil);
  ImgCar.Canvas.Brush.Color := clWhite;
  ImgBox.Canvas.Brush.Style :=bsSolid;
  ImgBox.Canvas.Brush.Color := clBlack;
  ImgCar.Canvas.FillRect(rect(0,0,ImgCar.Width,ImgCar.Height));
  lg := FNTLargeur div 2;

    for j := 1 to FNTNBLigne do
      for i := 1 to FNTNBColonne do    // FNTNBColonne+1 do
        begin
          PosX := i-1;
          PosY := j-1;
          PPosX := (i * FNTLargeur) - (FNTLargeur div 2);
          PPosY := (j * FNTLargeur) - (FNTLargeur div 2);

          if Tab_Alpha[Xpos].ch[i,j] = 1 then
            begin
              ImgCar.Canvas.Pixels[PosX,PosY] := clBlack;
              ImgBox.Canvas.FillRect(Rect(PPosX-lg+2, PPosY-lg+2, PPosX+lg-2, PPosY+lg-2));
            end;
        end;
  end;
end;

procedure TFormFont.BtPrevClick(Sender: TObject);
var
  posX, posY : integer;
  PPosX, PPosY : integer;
  i,j : integer;
  lg : integer;
begin
  dec(Xpos);
  if Xpos <= 1 then Xpos := 1;
  STPosChar.Caption := IntToStr(Xpos);
  if copy(Alphabet,Xpos,1) = '&' then LabelAlphabet.Caption := '&&'
  else LabelAlphabet.Caption := copy(Alphabet,Xpos,1);
  if TabChar[Xpos] <> chr(255) then
  begin
  PaintBoxFont(nil);
  ImgCar.Canvas.Brush.Color := clWhite;
  ImgBox.Canvas.Brush.Style :=bsSolid;
  ImgBox.Canvas.Brush.Color := clBlack;
  ImgCar.Canvas.FillRect(rect(0,0,ImgCar.Width,ImgCar.Height));
  lg := FNTLargeur div 2;

    for j := 1 to FNTNBLigne do
      for i := 1 to FNTNBColonne do    // FNTNBColonne+1 do
        begin
          PosX := i-1;
          PosY := j-1;
          PPosX := (i * FNTLargeur) - (FNTLargeur div 2);
          PPosY := (j * FNTLargeur) - (FNTLargeur div 2);

          if Tab_Alpha[Xpos].ch[i,j] = 1 then
            begin
              ImgCar.Canvas.Pixels[PosX,PosY] := clBlack;
              ImgBox.Canvas.FillRect(Rect(PPosX-lg+2, PPosY-lg+2, PPosX+lg-2, PPosY+lg-2));
            end;
        end;
  end;
end;

procedure TFormFont.NouvelleFonteClick(Sender: TObject);
var
  i : integer;
  PCarX, PCarY : integer;
begin
  for i:=0 to 97 do TabChar[i] := chr(255);

  FormSize.NBPix_W.MaxValue := 24;
  FormSize.NBPix_H.MaxValue := 24;


  FormSize.FontName.text := 'NewFont';
  FormSize.NBPix_R.Value := Space_Right;
  FormSize.NBPix_D.Value := Space_Down;
  FormSize.NBPix_W.Value := FNTNBColonne;
  FormSize.NBPix_H.Value := FNTNBLigne;

  FormSize.ShowModal;
  FormFont.Caption := 'Font Maker ][ ©flaith-nycd 2004-2017'+' - ['+
                      FormSize.FontName.text+']';

  FNTNBColonne := FormSize.NBPix_W.Value;
  FNTNBLigne := FormSize.NBPix_H.Value;
  Space_Right := FormSize.NBPix_R.Value;
  Space_Down := FormSize.NBPix_D.Value;
  ImgBox.Visible := True;
  BtValid.Enabled := True;
  BtPrev.Enabled := True;
  BtNext.Enabled := True;
  ImgCar.Canvas.Brush.Color := clWhite;
  ImgCar.Canvas.FillRect(rect(0,0,ImgCar.Width,ImgCar.Height));
  nbcar := 1;
  Xpos := 1;
  LabelAlphabet.Caption := copy(Alphabet,Xpos,1);

  // on efface image car

  bArray.Canvas.Brush.Color := clWhite;

  for i := 0 to 96 do
    begin
      PCarX := ArrayPoint[i].X;
      PCarY := ArrayPoint[i].Y;
      bArray.Canvas.FillRect(rect(PCarX,PCarY,PCarX+40,PCarY+30));
    end;

  // on reaffiche l'image du tableau des car
  ImgArrayChar.Picture.Assign(bArray);
  ScrollBarImgArray.Position := 0;

  PaintBoxFont(nil);
  STPosChar.Caption := IntToStr(Xpos);
end;

procedure TFormFont.BtValidClick(Sender: TObject);
var
  i,j,k : integer;
  l : char;
  WhatColor : TColor;
  PosX, PosY : integer;
  // pour calculer la position dans le tableau de caractères
  PCarX, PCarY : integer;
  TmpX, TmpY : integer;
begin
  // maj table de caractères
  k := StrToInt(STPosChar.Caption);

  TmpX := (40-FNTNBColonne) div 2;
  TmpY := (30-FNTNBLigne) div 2;

  PCarX := ArrayPoint[k].X+TmpX;
  PCarY := ArrayPoint[k].Y+TmpY;

  l := chr(k+32);
  Tab_Alpha[k].TheCar := l;
  if TabChar[k] = chr(255) then             // si le car n'est pas créé
    begin
      inc(nbcar);                           // on augmente le nb de car créé
      TabChar[k] := l;                      // et on lui donne sa valeur
    end;

  for j := 1 to FNTNBLigne do
    begin
      for i := 1 to FNTNBColonne+1 do
        begin
          PosX := i-1; PosY := j-1;
          WhatColor := GetPixel(ImgCar.Canvas.Handle,PosX,PosY);
          // on génère la table de caractères
          if WhatColor = clWhite then Tab_Alpha[k].ch[i,j] := 0
                                 else Tab_Alpha[k].ch[i,j] := 1;
          // on affiche sur l'image du tableau de caractères
          // celui que l'on vient de générer
          if WhatColor = clBlack then bArray.Canvas.Pixels[i+PCarX,j+PCarY] := clBlack
                                 else bArray.Canvas.Pixels[i+PCarX,j+PCarY] := clWhite;
        end;
    end;

  // Caractère suivant

  BtNextClick(nil);

  // on reaffiche l'image du tableau des car
  ImgArrayChar.Picture.Assign(bArray);

  // A VOIR : si > n car affichage automatique de la fin de l'image
  ScrollBarImgArrayChange(nil);  // Peut-etre !!!

//  ImgCar.Canvas.Brush.Color := clWhite;
//  ImgCar.Canvas.FillRect(rect(0,0,ImgCar.Width,ImgCar.Height));

  STNbCar.Caption := IntToStr(nbcar);
end;

procedure TFormFont.EnregistrerClick(Sender: TObject);
var
  i,j,k : integer;
//  F     : TextFile;
  B     : File;
  NameF : String;
begin
  NameF := FormSize.FontName.text;
  // caractère 'espace'
  for i := 1 to FNTNBLigne do
    for j := 1 to FNTNBColonne do
      Tab_Alpha[0].ch[i,j] := 0;
  Tab_Alpha[0].TheCar := ' ';

{

  // on enregistre la fonte créée (facon unit delphi)

  assignfile(f,NameF+'.ftd');
  rewrite(f);

  writeln(f,'//');
  writeln(f,'// à insérer dans l''unit');
  writeln(f,'//');
  writeln(f);
  writeln(f,'Const');
  writeln(f,'  NbLig = '+IntToStr(FNTNBLigne)+';');
  writeln(f,'  NbCol = '+IntToStr(FNTNBColonne)+';');
  writeln(f,'  NbCar = '+IntToStr(nbcar)+';');
  writeln(f);
  writeln(f,'Type');
  writeln(f,'  TCar = record');
  writeln(f,'    TheCar : char;');
  writeln(f,'    ch     : array [1..NbLig,1..NbCol] of Byte;');
  writeln(f,'  end;');
  writeln(f);
  writeln(f,'Const');
  writeln(f,'  Alpha : array[1..NbCar] of TCar =');
  writeln(f,'     (');

  for k := 0 to 96 do       // nbcar-1
    begin
      writeln(f,'      (TheCar:'''+Tab_Alpha[k].TheCar+''';');
      write(f,'       ch:((');

      for j := 1 to FNTNBColonne-1 do
          write(f,IntToStr(Tab_Alpha[k].ch[j,1])+',');
      writeln(f,IntToStr(Tab_Alpha[k].ch[FNTNBColonne,1])+'),');

      for i := 2 to FNTNBLigne-1 do
        begin
        write(f,'           ('+IntToStr(Tab_Alpha[k].ch[1,i])+',');
          for j := 2 to FNTNBColonne-1 do
              write(f,IntToStr(Tab_Alpha[k].ch[j,i])+',');
          writeln(f,IntToStr(Tab_Alpha[k].ch[FNTNBColonne,i])+'),');
        end;
        write(f,'           ('+IntToStr(Tab_Alpha[k].ch[1,FNTNBLigne])+',');
          for j := 2 to FNTNBColonne-1 do
              write(f,IntToStr(Tab_Alpha[k].ch[j,FNTNBLigne])+',');
          writeln(f,IntToStr(Tab_Alpha[k].ch[FNTNBColonne,FNTNBLigne])+'))');
        if k < nbcar then writeln(f,'      ),')
                     else writeln(f,'      )');
    end;
  writeln(f,'     );');
  writeln(f);
  closefile(f);

  // puis la version qui sera lu par Font Maker

  assignfile(f,NameF+'.ftm');
  rewrite(f);

  writeln(f,'//');
  writeln(f,'// Fonte version pour MakeFont');
  writeln(f,'//');
  writeln(f,'// NbLigne');
  writeln(f,'// NbColonne');
  writeln(f,'// NbCar');
  writeln(f,IntToStr(FNTNBLigne));
  writeln(f,IntToStr(FNTNBColonne));
  writeln(f,IntToStr(nbcar));

  for k := 1 to 96 do                   // on commence à 1 car
    begin                               // pas le car. espace
      writeln(f,Tab_Alpha[k].TheCar);
      for i := 1 to FNTNBLigne do
        begin
          for j := 1 to FNTNBColonne do
            if Tab_Alpha[k].ch[j,i] = 1 then write(f,'#')
                                        else write(f,'.');
          writeln(f);                   // Ligne suivante
        end;
    end;
  closefile(f);
}

  // et enfin la version binaire (hex)

  nbcar := 97;
  assignfile(b,NameF+'.fth');
  rewrite(b,1);
  blockwrite(b,entete,16);
  blockwrite(b,FNTNBLigne,1);
  blockwrite(b,FNTNBColonne,1);
  blockwrite(b,nbcar,1);
  blockwrite(b,space_right,1);
  blockwrite(b,space_down,1);
  blockwrite(b,vide,11);
  for k := 1 to 96 do                   // on commence à 1 car
    begin                               // pas le car. espace
      Tab_Alpha[k].TheCar := chr(k+32);
      if k = 96 then Tab_Alpha[k].TheCar := chr(169);
      blockwrite(b,Tab_Alpha[k].TheCar,sizeof(char));
      for i := 1 to FNTNBLigne do
        begin
          for j := 1 to FNTNBColonne do
            if Tab_Alpha[k].ch[j,i] = 1 then blockwrite(b,pix,1)
                                        else blockwrite(b,NoPix,1);
        end;
    end;
  closefile(b);
end;

procedure TFormFont.OuvrirClick(Sender: TObject);
var
  PCarX, PCarY, PCarX1, PCarY1 : integer;
  TmpX, TmpY, k, i, j : integer;
begin
  if OpenDialog.Execute then
    begin
      LoadFont(OpenDialog.FileName);
      FormFont.Caption := 'Font Maker ][ ©flaith-nycd 2004-2017'+' - ['+
                      ExtractFileName(OpenDialog.FileName)+']';
      FormSize.FontName.text := ChangeFileExt(ExtractFileName(OpenDialog.FileName),'');
      ImgBox.Visible := True;
      BtValid.Enabled := True;
      BtPrev.Enabled := True;
      BtNext.Enabled := True;
      ImgCar.Canvas.Brush.Color := clWhite;
      ImgCar.Canvas.FillRect(rect(0,0,ImgCar.Width,ImgCar.Height));
      Xpos := 1;
      LabelAlphabet.Caption := copy(Alphabet,Xpos,1);
      STColonne.Caption := IntToStr(FNTNBColonne);
      STLigne.Caption := IntToStr(FNTNBLigne);
      STNbCar.Caption := IntToStr(nbcar);
      PaintBoxFont(nil);
      STPosChar.Caption := IntToStr(Xpos);
      BtPrevClick(nil);  // pour afficher le premier car

      TmpX := (40-FNTNBColonne) div 2;
      TmpY := (30-FNTNBLigne) div 2;

      // on efface

      bArray.Canvas.Brush.Color := clWhite;

      for k := 0 to 96 do
        begin
          PCarX := ArrayPoint[k].X;
          PCarY := ArrayPoint[k].Y;
          PCarX1:= ArrayPoint[k].X1;
          PCarY1:= ArrayPoint[k].Y1;
          bArray.Canvas.FillRect(rect(PCarX,PCarY,PCarX+40,PCarY+30));
        end;

      // et on affiche
      for k := 1 to 96 do
        begin
          PCarX := ArrayPoint[k].X+TmpX;
          PCarY := ArrayPoint[k].Y+TmpY;
          for j := 1 to FNTNBLigne do
              for i := 1 to FNTNBColonne do
                  if Tab_Alpha[k].ch[i,j] = 1
                    then bArray.Canvas.Pixels[i+PCarX,j+PCarY] := clBlack
                    else bArray.Canvas.Pixels[i+PCarX,j+PCarY] := clWhite;
        end;

      // on raffraichit l'image des caractères
      ImgArrayChar.Canvas.CopyRect(rect(0,0,bArray.Width,bArray.Height),  // Destination
                                   bArray.Canvas,                         // Canvas utilisé
                                   rect(0,0,bArray.Width,bArray.Height)); // Source
      ScrollBarImgArray.Position := 0;
    end;
end;

procedure TFormFont.AproposClick(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

end.

