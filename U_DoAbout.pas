unit U_DoAbout;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TAboutBox = class(TForm)
    OKButton: TButton;
    StaticText1: TStaticText;
    StaticText3: TStaticText;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

end.
 
