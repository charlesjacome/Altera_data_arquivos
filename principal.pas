unit principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  System.Math,
  System.RegularExpressions,
  System.IOUtils,
  System.DateUtils,
  FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls;

type

  Tarquivo = record
    F_nome_arquivo     : string;
    f_datahora         : TDateTime;
    f_flag_imagem      : boolean;
    F_pode_alterar_data: boolean;
  end;

  TForm1 = class(TForm)
    qy_arquivos: TFDMemTable;
    qy_arquivosid: TIntegerField;
    qy_arquivosDiretorio: TStringField;
    qy_arquivosName: TStringField;
    ds_arquivos: TDataSource;
    pnl1: TPanel;
    dbgrd1: TDBGrid;
    edt_pasta: TEdit;
    qy_arquivosName_novo: TStringField;
    qy_arquivoshorario: TDateTimeField;
    edt_destino: TEdit;
    mmo_saida: TMemo;
    btn_salvar: TButton;
    dlgSave1: TSaveDialog;
    qy_arquivosnovo_horario: TDateTimeField;
    pnl_ajuste_de_data: TPanel;
    rg_opcoes: TRadioGroup;
    btn_processa: TButton;
    lbl1: TLabel;
    lbl2: TLabel;
    qy_arquivosfl_pode_alterar_data: TBooleanField;
    chk_nao_mude_nome: TCheckBox;
    btn_close: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btn_processaClick(Sender: TObject);
    procedure btn_salvarClick(Sender: TObject);
    procedure btn_closeClick(Sender: TObject);
  private
    procedure copia_e_troca_nome;
    procedure troca_data_arquivos;
    { Private declarations }
  public
    { Public declarations }
    function DefineDataHoraArq(NomeArq: string; DataHora: TDateTime): integer;
    function TemAtributo(Attr, Val: Integer): Boolean;
    procedure pega_arquivos(Diretorio: string; Sub:Boolean);
    function  fn_novo_nome( diretorio: string; f :TSearchRec; indice:integer) : Tarquivo;
  end;

var
  Form1: TForm1;
  F_id,
  F_intervalo : integer;
  Regex: TRegEx;
  Match: TMatch;
  Matches: TMatchCollection;
  SourceFile,
  DestFile,
  TempNome: string;

implementation

{$R *.dfm}

procedure TForm1.btn_closeClick(Sender: TObject);
begin
    qy_arquivos.EmptyDataSet;
    qy_arquivos.close;
    qy_arquivos.open;
end;

procedure TForm1.btn_processaClick(Sender: TObject);
begin
   case rg_opcoes.ItemIndex of
                 0 : begin
                      qy_arquivos.close;
                      qy_arquivos.open;
                      qy_arquivos.EmptyDataSet;
                      F_id := 1;
                      pega_arquivos( edt_pasta.Text , true);
                 end;

                 1: begin
                     if MessageDlg('Processo os arquivos?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
                     copia_e_troca_nome;
                 end;
                 2: begin
                      if MessageDlg('Processo os arquivos?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
                      troca_data_arquivos;
                 end;
   end;
  ShowMessage('Terminou');
end;


procedure TForm1.copia_e_troca_nome;
begin
  qy_arquivos.first;
  while not qy_arquivos.eof do
  begin
     SourceFile := qy_arquivosDiretorio.AsString  + '\' + qy_arquivosName.AsString;
     DestFile   := edt_destino.Text + '\' + qy_arquivosName_novo  .AsString;

     if qy_arquivosfl_pode_alterar_data.AsBoolean then
      begin

         TFile.Copy(SourceFile, DestFile, True);

      end
      else  mmo_saida.Lines.Add('sem data:' + DestFile);

      if F_intervalo > 200 then
      begin
        F_intervalo := 0;
        Application.ProcessMessages;
      end;

    qy_arquivos.next;
  end;

end;

procedure TForm1.troca_data_arquivos;
var
   cod_erro : Integer;
begin
  qy_arquivos.first;
  while not qy_arquivos.eof do
  begin
     DestFile   := edt_destino.Text + '\' + qy_arquivosName_novo  .AsString;

     if qy_arquivosfl_pode_alterar_data.AsBoolean then
      begin
       cod_erro := DefineDataHoraArq( DestFile, qy_arquivosnovo_horario.AsDateTime );
      end
      else  mmo_saida.Lines.Add('sem data:' + DestFile);

      if F_intervalo > 200 then
      begin
        F_intervalo := 0;
        Application.ProcessMessages;
      end;

    qy_arquivos.next;
  end;

end;


procedure TForm1.btn_salvarClick(Sender: TObject);
begin
  if dlgSave1.Execute then
      mmo_saida.Lines.SaveToFile(dlgSave1.FileName);
end;

function TForm1.DefineDataHoraArq(NomeArq: string; DataHora: TDateTime): integer;
var
  hFile: THandle;
  ftCreation, ftLastAccess, ftLastWrite: TFileTime;
  stCreation, stLastAccess, stLastWrite: TSystemTime;
begin
    Result:=0;
    // Open the file with write attributes access
    hFile := CreateFile(PChar(NomeArq), GENERIC_WRITE or FILE_WRITE_ATTRIBUTES,
    FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);

    if hFile = INVALID_HANDLE_VALUE then
    begin
      RaiseLastOSError; // Handle error if file cannot be opened
    end;

    try
      // Convert TDateTime values to SYSTEMTIME and then to FILETIME
      DateTimeToSystemTime(DataHora, stCreation);
      SystemTimeToFileTime(stCreation, ftCreation);

      //DateTimeToSystemTime(DataHora, stLastAccess);
      //SystemTimeToFileTime(stLastAccess, ftLastAccess);

      //DateTimeToSystemTime(DataHora, stLastWrite);
      //SystemTimeToFileTime(stLastWrite, ftLastWrite);

      // Set the file times
      if not SetFileTime(hFile, @ftCreation, @ftCreation, @ftCreation) then
      begin
        RaiseLastOSError; // Handle error if setting file times fails
      end;
    finally
      CloseHandle(hFile); // Always close the file handle
    end;
end;

function extrai_numero(entrada: string): string;
begin
  Result := '';
  if RegEx.Match(entrada). Success then
     Result := RegEx.Match(entrada).Value;
end;


function f_digits(texto_entrada, Default:string):string;
var
  x:integer;
  saida : string;
begin
   saida := '';
   for x := 1 to Length( texto_entrada)  do
     begin
        if CharInSet(texto_entrada[x] , ['0','1'..'9']) then
           saida := saida + texto_entrada[x];
     end;
  if saida = '' then saida := Default;
  Result := saida;
end;

function f_extrai_ano(texto_entrada:string):string;
begin
 result := Copy(texto_entrada, 0,4);
 if not InRange( StrToIntDef(result, 0),  1920, 2040) then
     result := texto_entrada;
end;

function TForm1.fn_novo_nome(diretorio : string; f: TSearchRec; indice:integer): Tarquivo;
var
  nome_arquivo,
  extensao,
  st_ano,
  st_mes : string;
  nu_ano,
  nu_mes : SmallInt;
begin
   result.F_nome_arquivo := f.Name;
   result.f_datahora     := f.TimeStamp;
   extensao              := ExtractFileExt(result.F_nome_arquivo);
   result.f_flag_imagem  := pos(extensao, '.jpg|.jpeg|.bmp|') > 0 ;
   result.F_pode_alterar_data := true;

   //pega diretorio e verifica se pode extrair YYYY_MM
   diretorio := f_digits( diretorio, '');

   st_ano := Copy(diretorio, 0,4);
   nu_ano := StrToIntDef(st_ano, 0);

   if not InRange( nu_ano,  1920,2040) then nu_ano :=0;

   if nu_ano =0 then
   begin
       //caso noa consiga tenta extrair YYYY_MM pelo nome do arquivo
      nome_arquivo := f.Name;
      diretorio := f_digits( f.Name, '');

      st_ano := Copy(diretorio, 0,4);
      nu_ano := StrToIntDef(st_ano, 0);

      if not InRange( nu_ano,  1920,2040) then nu_ano :=0;

      if nu_ano =0 then
      begin
         result.F_pode_alterar_data := false;
         result.F_nome_arquivo := TPath.GetFileNameWithoutExtension(nome_arquivo) + indice.ToString + extensao;
         exit;
      end
   end;

   st_mes := Copy(diretorio, 5,2);
   nu_mes := StrToIntDef(st_mes, 0);

   if InRange(nu_mes, 1, 12)  then
   begin
      nome_arquivo := st_ano + '_' + st_mes + '_' + indice.ToString
   end
      else
   begin
       nome_arquivo := st_ano + '_01_' + indice.ToString;
       nu_mes := 1;
   end;

   result.f_datahora     :=  EncodeDateTime(nu_ano, nu_mes, 2, 10, 11, 12, 13);
   result.F_nome_arquivo :=  nome_arquivo + extensao;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  F_intervalo := 1;
  RegEx := TRegex.Create('^[Z0-9_.+-]+_[Z0-9-]');
  mmo_saida.Lines.Clear;
end;

function TForm1.TemAtributo(Attr, Val: Integer): Boolean;
begin
  Result := Attr and Val = Val;
end;

procedure TForm1.pega_arquivos(Diretorio: string; Sub:Boolean);
var
  F       : TSearchRec;
  Farquivo: Tarquivo;
  Ret     : Integer;
begin
  Ret := FindFirst(Diretorio+'\*.*', faAnyFile, F);
  try
    while Ret = 0 do
    begin
      if TemAtributo(F.Attr, faDirectory) then
      begin
        if (F.Name <> '.') And (F.Name <> '..') then

          if Sub = True then

          begin
            TempNome := Diretorio+'\' + F.Name;
            pega_arquivos(TempNome, True);
          end;
      end
      else
      begin
       Farquivo :=  fn_novo_nome(Diretorio, F, F_id);
       if Farquivo.f_flag_imagem then
       begin
            qy_arquivos.Append;
            qy_arquivosid          .AsInteger  := F_id ;
            qy_arquivosDiretorio   .AsString   := Diretorio;
            qy_arquivosName        .AsString   := F.Name;
            qy_arquivoshorario     .AsDateTime := f.TimeStamp;

           if chk_nao_mude_nome.Checked = false
              then qy_arquivosName_novo   .AsString   := Farquivo.F_nome_arquivo
              else qy_arquivosName_novo   .AsString   := F.Name;

            qy_arquivosnovo_horario.AsDateTime := Farquivo.f_datahora;
            qy_arquivosfl_pode_alterar_data   .AsBoolean := Farquivo.F_pode_alterar_data;
            qy_arquivos.post;

            inc(F_id);
            inc(F_intervalo);
            if F_intervalo > 600 then
            begin
              F_intervalo := 0;
              Application.ProcessMessages;
            end;
       end;
      end;
        Ret := FindNext(F);
    end;
  finally
  begin
    FindClose(F);
  end;

  end;
end;


end.
