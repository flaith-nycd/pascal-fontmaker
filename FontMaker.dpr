program FontMaker;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  U_DoFont in 'U_DoFont.pas' {FormFont},
  U_DoSize in 'U_DoSize.pas' {FormSize},
  U_DoAbout in 'U_DoAbout.pas' {AboutBox};

{.$R *.res}

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormFont, FormFont);
  Application.CreateForm(TFormSize, FormSize);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
