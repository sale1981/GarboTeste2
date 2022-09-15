unit UBotDao;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.VCLUI.Wait, FireDAC.Phys.IBBase, FireDAC.Comp.UI, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Phys.IB, FireDAC.Phys.IBDef;

type
  TBotDao = class(TDataModule)
    CN: TFDConnection;
    qry_pesquisa: TFDQuery;
    qry_registrarVotoRuim: TFDQuery;
    qry_registrarVotoBOM: TFDQuery;
    qry_registrarVotoOtimo: TFDQuery;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysIBDriverLink1: TFDPhysIBDriverLink;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function ListaPesquisa         : string;
    function ListaParcialpesquisa  : string;
    function BuscaID               : Integer;
    procedure registrarVotoRuim (AContato : string; AIDPesquisa: Integer);
    procedure registrarVotoBom  (AContato : string; AIDPesquisa: Integer);
    procedure registrarVotoOtimo(AContato : string; AIDPesquisa: Integer);
  end;

var
  BotDao: TBotDao;

implementation

uses
  Vcl.Dialogs;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function TBotDao.BuscaID: Integer;
begin
  with qry_pesquisa do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select * from tb_pesquisa');
    Open;
  end;
  Result := qry_pesquisa.FieldByName('id').Value;
end;

procedure TBotDao.DataModuleCreate(Sender: TObject);
begin
   try
     CN.Connected := True;
   except on E: Exception do
     showMessage('Não foi Possivel a conexão'+ E.Message);
   end;

end;

function TBotDao.ListaParcialpesquisa: string;
begin
   with qry_pesquisa do
  begin
    Close;
    SQL.Clear;
    SQL.Add(''+
    ' Select COUNT(*) as total,  '+
    '       (count(ruim) / cast(Count(*) as Numeric(9,2)) * 100) as Percentual_RUIM,'+
    '       (count(BOM) / cast(Count(*) as Numeric(9,2)) * 100) as Percentual_BOM,  '+
    '       (count(OTIMO) / cast(Count(*) as Numeric(9,2)) * 100) as Percentual_OTIMO '+
    ' from tb_voto');
    Open;
  end;
  Result := Result +
            'Votos *Ruins*  :' + round(qry_pesquisa.FieldByName('Percentual_ruim').value).ToString + '%\n\n'+
            'Votos *Bons*   :' + round(qry_pesquisa.FieldByName('Percentual_Bom').value).ToString  + '%\n\n'+
            'Votos *Ótimos* :' + round(qry_pesquisa.FieldByName('Percentual_otimo').value).ToString + '%\n\n';

end;

function TBotDao.ListaPesquisa: string;
begin
  with qry_pesquisa do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select * from tb_pesquisa');
    Open;
  end;
  Result := qry_pesquisa.FieldByName('data').AsString + '-'+
            qry_pesquisa.FieldByName('descricao').AsString +' \n\n'
end;

procedure TBotDao.registrarVotoBom(AContato: string; AIDPesquisa: Integer);
begin
  with qry_registrarVotoBOM do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Insert into tb_voto(id_pesquisa,ruim,bom,otimo,contato ) '+
            '             values(:id,null,1,null,:contato);');
    Params.ParamByName('id').Value := AIDPesquisa;
    Params.ParamByName('contato').Value := AContato;
    ExecSQL;
  end;

end;

procedure TBotDao.registrarVotoOtimo(AContato: string; AIDPesquisa: Integer);
begin
  with qry_registrarVotoOtimo do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Insert into tb_voto(id_pesquisa,ruim,bom,otimo,contato ) '+
            '             values(:id,null,null,1,:contato);');
    Params.ParamByName('id').Value := AIDPesquisa;
    Params.ParamByName('contato').Value := AContato;
    ExecSQL;
  end;

end;

procedure TBotDao.registrarVotoRuim(AContato: string; AIDPesquisa: Integer);
begin
  with qry_registrarVotoRuim do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Insert into tb_voto(id_pesquisa,ruim,bom,otimo,contato ) '+
            '             values(:id,1,null,null,:contato);');
    Params.ParamByName('id').Value := AIDPesquisa;
    Params.ParamByName('contato').Value := AContato;
    ExecSQL;
  end;
end;

end.
