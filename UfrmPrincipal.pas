unit UfrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons,
  //units adicionais obrigatorias
   uTInject.ConfigCEF, uTInject,            uTInject.Constant,      uTInject.JS,     uInjectDecryptFile,
   uTInject.Console,   uTInject.Diversos,   uTInject.AdjustNumber,  uTInject.Config, uTInject.Classes,
   UBotConversa,uBotGestor,UBotDao;

type
  TfrmPrincipal = class(TForm)
    Inject1: TInject;
    sbWhats: TSpeedButton;
    procedure sbWhatsClick(Sender: TObject);
    procedure Inject1GetUnReadMessages(const Chats: TChatList);
  private
    { Private declarations }
    Gestor : TBotmanager;
    ConversaAtual : TBotConversa;
  public
    procedure GestorInteracao (Conversa : TBotConversa);
    procedure EnviarMenuPrincipal;
    procedure EnviarMenuParcial;
    procedure EnviarMensagem(aEtapa :Integer; aTexto : string;aAnexo : string = '');
    procedure EnviarMenu_Resposta  (aResposta : string; AContato : string; AIDPesquisa : Integer);
    procedure EnviarAvisoRespostaInvalida;
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TfrmPrincipal.EnviarAvisoRespostaInvalida;
var
 aText : string;
begin
  aText := aText + Inject1.Emoticons.LoiraNotebook + '*Desculpe, O palmeiras não tem mundial! Tente o Ano que vem* \n\n';
  EnviarMensagem(ConversaAtual.Etapa,Atext, ExtractFilePath(Application.ExeName) + 'img\pesquisa.jpg');
end;

procedure TfrmPrincipal.EnviarMensagem(aEtapa: Integer; aTexto, aAnexo: string);
begin
  ConversaAtual.Etapa    := aEtapa;
  ConversaAtual.Pergunta := aTexto;
  ConversaAtual.Resposta := '';
  if aAnexo <> '' then
    Inject1.SendFile(ConversaAtual.ID,aAnexo,ConversaAtual.Pergunta)
  else
    Inject1.Send(ConversaAtual.ID,ConversaAtual.Pergunta);
end;

procedure TfrmPrincipal.EnviarMenuParcial;
var
 aText : string;
begin
  ConversaAtual.Situacao := saEmAtendimento;
  aText := aText + Inject1.Emoticons.LoiraNotebook +' *Parcial da Nossa pesquisa.* \n\n' ;
  aText := aText + '*Parcial atual:* \n\n';
  aText := aText + BotDao.ListaParcialpesquisa;
  EnviarMensagem(1,Atext, ExtractFilePath(Application.ExeName) + 'img\pesquisa.jpg');
end;

procedure TfrmPrincipal.EnviarMenuPrincipal;
var
 aText : string;
begin
  ConversaAtual.Situacao := saEmAtendimento;
  aText := aText + Inject1.Emoticons.LoiraNotebook +' *Sejam Bem vindos a nossa pesquisa de satisfação!* \n\n' ;
  aText := aText + '*Pergunta:* \n\n';
  aText := aText + Inject1.Emoticons.SetaDireita + BotDao.Listapesquisa;
  aText := aText + Inject1.Emoticons.Um + 'Ruim \n\n';
  aText := aText + Inject1.Emoticons.Dois + 'Bom \n\n';
  aText := aText + Inject1.Emoticons.Tres + 'Otimo \n\n';
  EnviarMensagem(1,Atext, ExtractFilePath(Application.ExeName) + 'img\pesquisa.jpg');

end;


procedure TfrmPrincipal.EnviarMenu_Resposta(aResposta, AContato: string; AIDPesquisa: Integer);
var
AText :  string;
begin
  try
    if aResposta = '1' then
    begin
      BotDao.registrarVotoRuim(AContato,AIDPesquisa);
    end
    else
    if aResposta = '2' then
    begin
      BotDao.registrarVotoBom(AContato,AIDPesquisa);
    end else
      BotDao.registrarVotoOtimo(AContato,AIDPesquisa);

  finally
    aText := aText + Inject1.Emoticons.LoiraNotebook +' *Voto registrado com sucesso!* \n\n' ;
    aText := aText + 'Para ver uma parcial da pesquisa digite *PARCIAL* \n\n' ;
    aText := aText + '*Até logo!* \n\n';
    EnviarMensagem(0,Atext, ExtractFilePath(Application.ExeName) + 'img\pesquisa.jpg');
  end;
end;

procedure TfrmPrincipal.GestorInteracao(Conversa: TBotConversa);
begin
  ConversaAtual := Conversa;
   case Conversa.Situacao of
     saNova :          begin
                         EnviarMenuPrincipal;
                       end;
     saEmAtendimento : begin
                         if Pos(UpperCase(Conversa.Resposta),'INICIO.INÍCIO.INíCIO') >0 then
                         begin
                           EnviarMenuPrincipal;
                         end
                         else
                         if Pos(UpperCase(Conversa.Resposta),'PARCIAL')>0 then
                         begin
                           EnviarMenuParcial;
                         end
                         else
                         begin
                            case Conversa.Etapa of
                              1 : begin
                                     //tratar a resposta
                                     if Pos(UpperCase(Conversa.Resposta),'1.2.3')>0 then
                                     begin
                                       ConversaAtual.IDPesquisa := BotDao.buscaID;
                                       EnviarMenu_Resposta(Conversa.Resposta, ConversaAtual.ID,ConversaAtual.IDPesquisa);
                                     end else
                                       EnviarAvisoRespostaInvalida;
                                  end;

                            end;
                         end;

                       end;

   end;
end;

procedure TfrmPrincipal.Inject1GetUnReadMessages(const Chats: TChatList);
begin
  Gestor.AdministrarChatList(Inject1,Chats);
end;

procedure TfrmPrincipal.sbWhatsClick(Sender: TObject);
begin
  if not Inject1.Auth(false) then
  begin
    Inject1.FormQrCodeType := TFormQrCodeType(Ft_Http);
    Inject1.FormQrCodeStart;
  end;
  if not Inject1.FormQrCodeShowing then
    Inject1.FormQrCodeShowing := True;


  Gestor := TBotmanager.Create(Self);
  Gestor.Simutaneios := 10;
  Gestor.TempoInatividade := (90*1000);
  Gestor.OnInteracao := GestorInteracao;
end;

end.
