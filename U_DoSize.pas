unit U_DoSize;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, Spin;

type
  TFormSize = class(TForm)
    BtnClose: TBitBtn;
    Bevel1: TBevel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    FontName: TEdit;
    Bevel2: TBevel;
    NBPix_R: TSpinEdit;
    NBPix_D: TSpinEdit;
    NBPix_W: TSpinEdit;
    NBPix_H: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure BtnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Déclarations privées }
    procedure CheckValue;
  public
    { Déclarations publiques }
  end;

var
  FormSize: TFormSize;

implementation

uses U_DoFont;

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TFormSize.CheckValue;
begin
  if NBPix_R.Value > 5 then NBPix_R.Value := 5;
  if NBPix_D.Value > 5 then NBPix_D.Value := 5;
  if NBPix_W.Value > NBPix_W.MaxValue then NBPix_W.Value := 48;
  if NBPix_H.Value > NBPix_H.MaxValue then NBPix_H.Value := 48;
end;

procedure TFormSize.BtnCloseClick(Sender: TObject);
begin
  CheckValue;
  FormFont.STColonne.Caption := IntToStr(NBPix_W.Value);
  FormFont.STLigne.Caption := IntToStr(NBPix_H.Value);
  Close;
end;

procedure TFormSize.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CheckValue;
  FormFont.STColonne.Caption := IntToStr(NBPix_W.Value);
  FormFont.STLigne.Caption := IntToStr(NBPix_H.Value);
end;

end.
