unit pfptcarga;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, Grids;

type
  Tffptcarga = class(TForm)
    MainMenu1: TMainMenu;
    Archivo1: TMenuItem;
    CargaMtricas1: TMenuItem;
    Salir1: TMenuItem;
    OpenDialog1: TOpenDialog;
    rxfc: TMemo;
    Utileria1: TMenuItem;
    EditarDirectivas1: TMenuItem;
    EditarReservadas1: TMenuItem;
    dgt: TDrawGrid;
    ExportaraCSV1: TMenuItem;
    SaveDialog1: TSaveDialog;
    procedure CargaMtricas1Click(Sender: TObject);
    procedure EditarDirectivas1Click(Sender: TObject);
    procedure EditarReservadas1Click(Sender: TObject);
    procedure dgtDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure ExportaraCSV1Click(Sender: TObject);
  private
    { Private declarations }
   zz: array of array[0..11] of string;
  public
    { Public declarations }
  end;

var
  ffptcarga: Tffptcarga;
   procedure PR_FPTCARGA;

implementation
uses ptsdm;
{$R *.dfm}
procedure PR_FPTCARGA;
begin
   Application.CreateForm( Tffptcarga, ffptcarga );
   try
      ffptcarga.Showmodal;
   finally
      ffptcarga.Free;
   end;
end;

procedure Tffptcarga.CargaMtricas1Click(Sender: TObject);
var analizablob,analizador,orden,reservadas,nblob,cfpt,dfpt,fecha: string;
   capa,concepto,subconcepto,ccategoria,medida,valor,comentario:string;
   i,j,k:integer;
   lis:Tstringlist;
begin
   orden:=inputbox('Capture','Clave de Orden de Prueba','');
   if trim(orden)='' then exit;
   if opendialog1.Execute=false then exit;
   if fileexists(opendialog1.FileName)=false then begin
      Application.MessageBox(pchar(dm.xlng('ERROR... El archivo no existe')),
                             pchar(dm.xlng('Carga Métricas ')), MB_OK );
      abort;
   end;
   setlength(zz,1);
   dgt.RowCount:=1;
   if dm.sqlselect(dm.q1,'select * from tsutileria '+
      ' where cutileria='+g_q+'RGMLANG'+g_q+
      ' and cblob is not null')=false then begin
      Application.MessageBox(pchar(dm.xlng('ERROR... no esta cargada la utilería RGMLANG')),
                             pchar(dm.xlng('Carga Métricas ')), MB_OK );
      abort;
   end;
   analizablob:=dm.q1.fieldbyname('cblob').AsString;
   analizador:=g_ruta+'hta'+analizablob+'.exe';
   dm.blob2file(analizablob,analizador);
   g_borrar.Add(analizador);
   g_borrar.Add(g_ruta+'source.new');
   if dm.sqlselect(dm.q1,'select * from tsutileria '+
      ' where cutileria='+g_q+'RESERVADAS FFAPA'+g_q+
      ' and cblob is not null') then begin
      nblob:=dm.q1.fieldbyname('cblob').AsString;
      reservadas:=g_ruta+'reserved';
      dm.blob2file(nblob,reservadas);
      g_borrar.Add(reservadas);
   end
   else begin
      Application.MessageBox(pchar(dm.xlng('ERROR... No está cargada la utilería "RESERVADAS FFAPA"')),
                             pchar(dm.xlng('Carga Métricas ')), MB_OK );
      abort;
   end;
   if dm.sqlselect(dm.q1,'select * from tsutileria '+
      ' where cutileria='+g_q+'DIRECTIVAS FFAPA'+g_q+
      ' and cblob is not null') then begin
      nblob:=dm.q1.fieldbyname('cblob').AsString;
      reservadas:=g_ruta+'process.dir';
      dm.blob2file(nblob,reservadas);
      g_borrar.Add(reservadas);
   end
   else begin
      Application.MessageBox(pchar(dm.xlng('ERROR... No está cargada la utileria "DIRECTIVAS FFAPA"')),
                             pchar(dm.xlng('Carga Métricas ')), MB_OK );
      abort;
   end;
   chdir(g_ruta);
   dm.ejecuta_espera(analizador+' '+
      opendialog1.FileName+' >'+g_ruta+'nada.txt',SW_HIDE);
   rxfc.Lines.LoadFromFile(g_ruta+'nada.txt');
   if pos('ERROR...',rxfc.Text)>0 then begin
      Application.MessageBox(pchar(dm.xlng(copy(rxfc.Text,pos('ERROR...',rxfc.Text),100))),
                             pchar(dm.xlng('Carga Métricas ')), MB_OK );
      abort;
   end;
   lis:=Tstringlist.Create;
   cfpt:=formatdatetime('yymmddhhnnsszzz',now);
   fecha:=dm.datedb(formatdatetime('YYYY/MM/DD HH:NN:SS',now),'YYYY/MM/DD HH24:MI:SS');
   for i:=0 to rxfc.Lines.Count-1 do begin
      if trim(rxfc.Lines[i])='' then continue;
      lis.CommaText:=rxfc.Lines[i];
      if lis.Count<>11 then begin
         Application.MessageBox(pchar(dm.xlng('ERROR... línea inconsistente '+rxfc.Lines[i])),
                                pchar(dm.xlng('Carga Métricas ')), MB_OK );
         abort;
      end;
      if lis[0]='XIDEN' then continue;
      dfpt:=lis[1];
      capa:=lis[5];
      concepto:=uppercase(stringreplace(lis[6],'_',' ',[rfreplaceall]));
      subconcepto:=uppercase(stringreplace(lis[7],'_',' ',[rfreplaceall]));
      valor:=lis[8];
      medida:=lis[9];
      comentario:=uppercase(stringreplace(lis[10],'_',' ',[rfreplaceall]));
      ccategoria:='GENERAL';
      if dfpt<>'0' then
         dfpt:=cfpt+dfpt;
      if (medida='SEGCPU') or (medida='%') then begin
         j:=pos('.',valor);
         if j>0 then
            j:=strtoint(copy(valor,1,j-1))*1000+strtoint(copy(copy(valor,j+1,100)+'000',1,3))
         else
            j:=strtoint(valor)*1000;
      end
      else
         j:=strtoint(valor);
      { ---alta fptmetrica anterior
      if dm.sqlinsert('insert into fptmetrica (cfpt,dfpt,corden,cprog,cbib,cclase,'+
         'fecha,capa,concepto,subconcepto,valor,medida,ccategoria,comentario) values('+
         g_q+cfpt+lis[0]+g_q+','+
         g_q+dfpt+g_q+','+
         g_q+orden+g_q+','+
         g_q+lis[2]+g_q+','+
         g_q+lis[3]+g_q+','+
         g_q+lis[4]+g_q+','+
         fecha+','+
         g_q+capa+g_q+','+
         g_q+concepto+g_q+','+
         g_q+subconcepto+g_q+','+
         inttostr(j)+','+
         g_q+medida+g_q+','+
         g_q+ccategoria+g_q+','+
         g_q+comentario+g_q+')')=false then begin
         showmessage('ERROR... no puede insertar en fptmetrica');
         abort;
      end;
      }
      k:=length(zz);
      setlength(zz,k+1);
      zz[k][0]:=lis[2];
      zz[k][1]:=lis[3];
      zz[k][2]:=lis[4];
      zz[k][3]:=capa;
      zz[k][4]:=concepto;
      zz[k][5]:=subconcepto;
      zz[k][6]:=ccategoria;
      zz[k][7]:=medida;
      zz[k][8]:=inttostr(j);
      zz[k][9]:='';
      zz[k][10]:='';
      zz[k][11]:=comentario;
      if dm.sqlselect(dm.q1,'select * from fptumbral '+
         ' where capa='+g_q+capa+g_q+
         ' and concepto='+g_q+concepto+g_q+
         ' and subconcepto='+g_q+subconcepto+g_q+
         ' and ccategoria='+g_q+ccategoria+g_q) then begin
         zz[k][9]:=dm.q1.fieldbyname('minimo').AsString;
         zz[k][10]:=dm.q1.fieldbyname('maximo').AsString;
      end;
   end;
   dgt.RowCount:=length(zz);
   if dgt.RowCount>1 then
      dgt.FixedRows:=1;
   lis.Free;
end;

procedure Tffptcarga.EditarDirectivas1Click(Sender: TObject);
var reservadas,nblob,xblob,magic:string;
begin
   if dm.sqlselect(dm.q1,'select * from tsutileria '+
      ' where cutileria='+g_q+'DIRECTIVAS FFAPA'+g_q+
      ' and cblob is not null') then begin
      nblob:=dm.q1.fieldbyname('cblob').AsString;
      reservadas:=g_ruta+'procdir.txt';
      dm.blob2file(nblob,reservadas);
      g_borrar.Add(reservadas);
      chdir(g_ruta);
      dm.ejecuta_espera(reservadas,SW_HIDE);
      xblob:=dm.file2blob(reservadas,magic);
      if dm.sqlupdate('update tsutileria set '+
         ' cblob='+g_q+xblob+g_q+','+
         ' magic='+g_q+magic+g_q+','+
         ' fecha='+dm.datedb(formatdatetime('YYYY/MM/DD HH:NN:SS',now),'YYYY/MM/DD HH24:MI:SS')+
         ' where cutileria='+g_q+'DIRECTIVAS FFAPA'+g_q)=false then begin
         Application.MessageBox(pchar(dm.xlng('ERROR... no puede actualizar BLOB ')),
                                pchar(dm.xlng('Editar directivas ')), MB_OK );
         abort;
      end;
      dm.sqldelete('delete from tsblob where cblob='+g_q+nblob+g_q);
   end
   else begin
      Application.MessageBox(pchar(dm.xlng('ERROR... No está cargada la utilería "DIRECTIVAS FFAPA"')),
                             pchar(dm.xlng('Editer directivas ')), MB_OK );
      abort;
   end;
end;

procedure Tffptcarga.EditarReservadas1Click(Sender: TObject);
var reservadas,nblob,xblob,magic:string;
begin
   if dm.sqlselect(dm.q1,'select * from tsutileria '+
      ' where cutileria='+g_q+'RESERVADAS FFAPA'+g_q+
      ' and cblob is not null') then begin
      nblob:=dm.q1.fieldbyname('cblob').AsString;
      reservadas:=g_ruta+'reservadas.txt';
      dm.blob2file(nblob,reservadas);
      g_borrar.Add(reservadas);
      chdir(g_ruta);
      dm.ejecuta_espera(reservadas,SW_HIDE);
      xblob:=dm.file2blob(reservadas,magic);
      if dm.sqlupdate('update tsutileria set '+
         ' cblob='+g_q+xblob+g_q+','+
         ' magic='+g_q+magic+g_q+','+
         ' fecha='+dm.datedb(formatdatetime('YYYY/MM/DD HH:NN:SS',now),'YYYY/MM/DD HH24:MI:SS')+
         ' where cutileria='+g_q+'RESERVADAS FFAPA'+g_q)=false then begin
         Application.MessageBox(pchar(dm.xlng('ERROR... no puede actualizar BLOB ')),
                                pchar(dm.xlng('Editar reservadas ')), MB_OK );
         abort;
      end;
      dm.sqldelete('delete from tsblob where cblob='+g_q+nblob+g_q);
   end
   else begin
         Application.MessageBox(pchar(dm.xlng('ERROR... No está cargada la utilería "RESERVADAS FFAPA"')),
                                pchar(dm.xlng('Editar reservadas ')), MB_OK );
      abort;
   end;
end;

procedure Tffptcarga.dgtDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var  texto:string;
      ancho,colororig:integer;
begin
   if acol<0 then exit;
   if arow>length(zz) then exit;
   if acol>11 then exit;
   {
   bitmap.Canvas.FillRect(bitmap.Canvas.ClipRect);
   if arow=0 then begin
      texto:=zz[acol][0];
      if dm.sqlselect(dm.q1,'select * from tsclase '+
         ' where cclase='+g_q+texto+g_q) then
         texto:=dm.q1.fieldbyname('descripcion').AsString;
      dm.imgclases.GetBitmap( dm.lclases.IndexOf(zz[acol][0]), bitmap );
      dgt.Canvas.TextRect(rect,rect.left+17, rect.Top,texto);
      dgt.Canvas.Draw(rect.left,rect.top,bitmap);
      exit;
   end;
   }
   colororig:=dgt.canvas.Brush.Color;
   if (acol=8) and (arow>0) then begin
      if zz[arow][9]<>'' then begin
         if (strtoint(zz[arow][8])<strtoint(zz[arow][9])) or
            (strtoint(zz[arow][8])>strtoint(zz[arow][10])) then
            dgt.canvas.Brush.Color:=clred
         else
            dgt.canvas.Brush.Color:=clgreen;
      end;
   end;
   texto:=zz[arow][acol];
   ancho:=dgt.Canvas.TextWidth(texto);
   if dgt.ColWidths[acol]< ancho+5 then
      dgt.ColWidths[acol]:=ancho+5;
   dgt.Canvas.TextRect(rect,rect.left, rect.Top,texto);
   dgt.canvas.Brush.Color:=colororig;
end;

procedure Tffptcarga.FormCreate(Sender: TObject);
begin
   setlength(zz,1);
   zz[0][0]:='Modulo';
   zz[0][1]:='Biblioteca';
   zz[0][2]:='Clase';
   zz[0][3]:='APA';
   zz[0][4]:='Concepto';
   zz[0][5]:='Subconcepto';
   zz[0][6]:='Categoria';
   zz[0][7]:='Medida';
   zz[0][8]:='Valor';
   zz[0][9]:='Minimo';
   zz[0][10]:='Maximo';
   zz[0][11]:='Comentario';
   dgt.RowCount:=1;
end;

procedure Tffptcarga.ExportaraCSV1Click(Sender: TObject);
var i,j:integer;
   lis:Tstringlist;
   linea,coma:string;
begin
   if savedialog1.Execute=false then exit;
   if fileexists(savedialog1.FileName) then begin
      if application.MessageBox('El archivo ya existe, desea reemplazarlo?',
         'Confirme',MB_YESNO)=IDNO then exit;
   end;
   lis:=Tstringlist.Create;
   for i:=0 to length(zz)-1 do begin
      linea:='';
      coma:='';
      for j:=0 to 11 do begin
         linea:=linea+coma+zz[i][j];
         coma:=',';
      end;
      lis.Add(linea);
   end;
   lis.SaveToFile(savedialog1.FileName);
   lis.Free;
end;

end.
