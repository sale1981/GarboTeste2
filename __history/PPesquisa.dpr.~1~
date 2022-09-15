program PPesquisa;

uses
  Vcl.Forms,
  uTInject.ConfigCEF,
  uBotConversa in 'uBotConversa.pas',
  uBotGestor in 'uBotGestor.pas',
  UfrmPrincipal in 'UfrmPrincipal.pas' {frmPrincipal},
  UBotDao in 'UBotDao.pas' {BotDao: TDataModule};

{$R *.res}

begin
  if not GlobalCEFApp.StartMainProcess then
    Exit;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TBotDao, BotDao);
  Application.Run;
end.
