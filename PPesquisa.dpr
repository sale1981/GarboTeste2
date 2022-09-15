program PPesquisa;

uses
  Vcl.Forms,
  uTInject.ConfigCEF,
  uBotConversa in 'uBotConversa.pas',
  uBotGestor in 'uBotGestor.pas',
  UfrmPrincipal in 'UfrmPrincipal.pas' {frmPrincipal},
  UBotDao in 'UBotDao.pas' {BotDao: TDataModule},
  NovoForm in 'NovoForm.pas' {Form1},
  UPALMEIRAS_NAO_TEM_MUNDIAL in 'UPALMEIRAS_NAO_TEM_MUNDIAL.pas';

{$R *.res}

begin
  if not GlobalCEFApp.StartMainProcess then
    Exit;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TBotDao, BotDao);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
