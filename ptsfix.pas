unit ptsfix;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, ExtCtrls, ComCtrls, DB, ADODB,shellapi;
type
      Tgl=record
      linea:integer;
      texto:string;
end;

type
  Tftsfix = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    grbOriginales: TGroupBox;
    dbg: TDBGrid;
    GroupBox3: TGroupBox;
    Label3: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label1: TLabel;
    Label6: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    bdir: TBitBtn;
    txtmascara: TEdit;
    cmbsistema: TComboBox;
    cmbclase: TComboBox;
    cmbbib: TComboBox;
    barchivo: TBitBtn;
    bcompara: TBitBtn;
    cmbcopylib: TComboBox;
    butileria: TBitBtn;
    GroupBox4: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Splitter4: TSplitter;
    ttsprog: TADOQuery;
    DataSource1: TDataSource;
    dbgmaestra: TDBGrid;
    Splitter5: TSplitter;
    DataSource2: TDataSource;
    adoqmaestra: TADOQuery;
    memo: TRichEdit;
    chkafectado: TCheckBox;
    chkwarning: TCheckBox;
    Label8: TLabel;
    txtlongitudes: TEdit;
    SaveDialog1: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure cmbsistemaChange(Sender: TObject);
    procedure cmbclaseChange(Sender: TObject);
   procedure cmbbibChange(Sender: TObject);
    procedure dbgCellClick(Column: TColumn);
    procedure dbgmaestraCellClick(Column: TColumn);
    procedure txtlongitudesKeyPress(Sender: TObject; var Key: Char);
    procedure txtlongitudesChange(Sender: TObject);
    procedure chkafectadoClick(Sender: TObject);
    procedure chkwarningClick(Sender: TObject);
    procedure barchivoClick(Sender: TObject);
    procedure bcomparaClick(Sender: TObject);
    procedure bdirClick(Sender: TObject);
  private
    { Private declarations }
    mm:Tstringlist;
    g_modomsj:word;
   fmensaje:textfile;
   b_noprocesa:boolean;
   valores:Tstringlist;
   b_trae_utilerias:boolean;
   el_fuente:string;
   origen,nuevos:Tstringlist;
   dir_salida:string;
   convertido:Tstringlist;
   modis:array of Tgl;
   procedure procesa_bms;
   procedure smensaje(mensaje:string);
   procedure expande(cblbib,cblprog:string);
   procedure afectados;
   function  encuentra(texto:string; k:integer):integer;
   procedure reemplaza_picture(texto:string; k:integer);
  public
    { Public declarations }
  end;

var
  ftsfix: Tftsfix;
   procedure PR_FIX;

implementation
uses ptsdm;

{$R *.dfm}

procedure PR_FIX;
begin
   Application.CreateForm( Tftsfix, ftsfix );
   try
      ftsfix.Showmodal;
   finally
      ftsfix.Free;
   end;
end;

procedure Tftsfix.FormCreate(Sender: TObject);
begin
   dm.feed_combo(cmbcopylib,'select distinct cbib from tsprog where cclase='+g_q+'CPY'+g_q+' order by 1');
   if cmbcopylib.Items.Count=1 then
      cmbcopylib.ItemIndex:=0;
   dm.feed_combo( cmbsistema, 'select csistema from tssistema order by csistema' );
   if cmbsistema.Items.Count = 1 then
      cmbsistema.ItemIndex := 0;
//   progok := Tstringlist.Create;
//   progmal := Tstringlist.Create;
//   bf := Tstringlist.Create;
   ttsprog.Connection := dm.ADOConnection1;
   adoqmaestra.Connection := dm.ADOConnection1;
   mm:=Tstringlist.Create;
   valores:=Tstringlist.Create;
   b_trae_utilerias:=true;
   convertido:=Tstringlist.Create;
   origen:=Tstringlist.Create;
   nuevos:=Tstringlist.Create;
   origen.CommaText:=
      '"9(03)" ,"X(003)" ,"9(7)V99" ,"X(3)" ,"9(03)V99" ,"9(4)" ,"S9(009)" ,"S9(04)V99" ,"ZZZZZZZZ9" ,'+
      '"X(1)" ,"ZZZ9.99" ,"S9(09)" ,"S9(06)" ,"9(06)" ,"S9(9)" ,"X(2)" ,"S9(6)V9(2)" ,"9(04)V99" ,'+
      '"S9(4)" ,"X(07)" ,"X(09)" ,"9(9)" ,"X(02)" ,"S9(04)" ,"S9(4)V9(2)" ,"X(04)" ,"ZZZZZZZZZ" ,'+
      '"ZZZZ" ,"9(009)" ,"9(09)" ,"9(4)V99" ,"X(4)" ,"X(01)" ,"9(02)" ,"X(03)" ,"S9(06)V99" ,"S9(7)V9(2)" ,'+
      '"9(4)V9(2)" ,"9(05)" ,"ZZZZ9" ,"S9(07)V99" ,"X(9)" ,"X(009)" ,"X(5)" ,"9(04)" ,"ZZZZZZZ9" ,"ZZZ9","9(07)V99"';
   nuevos.CommaText:=
      '"9(04)" ,"X(004)" ,"9(8)V99" ,"X(4)" ,"9(04)V99" ,"9(5)" ,"S9(010)" ,"S9(05)V99" ,"ZZZZZZZZZ9",'+
      '"X(2)" ,"ZZZZ9.99","S9(10)" ,"S9(07)" ,"9(07)" ,"S9(10)","X(3)" ,"S9(7)V9(2)" ,"9(05)V99" ,'+
      '"S9(5)" ,"X(08)" ,"X(10)" ,"9(10)","X(03)" ,"S9(05)" ,"S9(5)V9(2)" ,"X(05)" ,"ZZZZZZZZZZ",'+
      '"ZZZZZ","9(010)" ,"9(10)" ,"9(5)V99" ,"X(5)" ,"X(02)" ,"9(03)" ,"X(04)" ,"S9(07)V99" ,"S9(8)V9(2)" ,'+
      '"9(5)V9(2)" ,"9(06)" ,"ZZZZZ9","S9(08)V99" ,"X(10)","X(010)" ,"X(6)" ,"9(05)" ,"ZZZZZZZZ9","ZZZZ9","9(08)V99"';
   chdir(g_tmpdir);
end;
procedure Tftsfix.smensaje(mensaje:string);
var
   fMsj: TextFile;
   sFechaHoraActual: String;
begin
   AssignFile(fMsj,g_tmpdir+'\ptsanaprog_mensajes.txt');

   if FileExists(g_tmpdir+'\ptsanaprog_mensajes.txt') then
      Append(fMsj)
   else
      Rewrite(fMsj);

   sFechaHoraActual:=formatdatetime('YYYY/MM/DD HH:NN:SS',now);

   writeln(fMsj,sFechaHoraActual,'<>',mensaje);
   closefile(fMsj);
end;

procedure Tftsfix.cmbsistemaChange(Sender: TObject);
begin
   dm.feed_combo( cmbclase, 'select distinct cclase from tsprog ' +
      ' where sistema=' + g_q + cmbsistema.text + g_q +
      ' order by cclase' );
   cmbbib.clear;
   barchivo.enabled := false;
   //bdir.enabled := false;
   ttsprog.Close;

end;

procedure Tftsfix.cmbclaseChange(Sender: TObject);
var
   lista: Tstringlist;
   bib: string;
begin
   dm.feed_combo( cmbbib, 'select distinct cbib from tsprog ' +
      ' where sistema=' + g_q + cmbsistema.text + g_q +
      ' and   cclase=' + g_q + cmbclase.text + g_q +
      ' order by cbib' );
   barchivo.enabled := false;
  // bdir.enabled := false;
   ttsprog.Close;
end;

procedure Tftsfix.cmbbibChange(Sender: TObject);
begin
   dir_salida:='';
   ttsprog.Close;
   ttsprog.SQL.Clear;
   ttsprog.SQL.Add( 'select cprog Componente from tsprog ' +
      ' where sistema=' + g_q + cmbsistema.text + g_q +
      ' and cclase=' + g_q + cmbclase.Text + g_q +
      ' and cbib=' + g_q + cmbbib.Text + g_q +
      ' and cprog like ' + g_q + stringreplace( txtmascara.Text, '*', '%', [ rfreplaceall ] ) + g_q +
      ' order by cprog' );
   ttsprog.open;
   if ttsprog.Eof then begin
      //   if ttsprog.RecordCount=0 then begin
      Application.MessageBox( pchar( dm.xlng( 'Sin registros' ) ),
         pchar( dm.xlng( 'Conversión ' ) ), MB_OK );
      barchivo.Enabled := false;
      //bdir.Enabled := false;
      //bcompara.Enabled := false;
   end
   else
      ttsprog.First;
   //bdir.Enabled := ( ( cmbclase.Text <> '' ) and
   //   ( trim( cmbsistema.text ) <> '' ) and
   //   ( trim( cmbbib.text ) <> '' ) );
   barchivo.Enabled := ( ( dbg.SelectedField <> nil ) and
      ( cmbclase.Text <> '' ) and
      ( trim( cmbsistema.text ) <> '' ) and
      ( trim( cmbbib.text ) <> '' ) );
   //bcompara.Enabled := barchivo.Enabled;
   el_fuente:='';
end;
procedure Tftsfix.expande(cblbib,cblprog:string);
var ruta_expandidos,ruta_cwacomm:string;
begin
   if el_fuente=cblprog then
      exit;
   SetCurrentDir( g_tmpdir );
   ruta_expandidos:=g_ruta+'transito\expandidos\'+cblbib;
   ruta_cwacomm:=g_ruta+'transito\cwacomm\'+cblbib;
   forcedirectories(ruta_expandidos);
   forcedirectories(ruta_cwacomm);
   // RGM para acelerar el proceso      trae_copys(copylib,memo.Lines);
   // RGM para acelerar el proceso      SetEnvironmentVariable( pchar( 'COPYLIB' ), pchar( g_tmpdir ));
   SetEnvironmentVariable( pchar( 'COPYLIB' ), pchar( dm.pathbib('COPYLIB')));
   SetEnvironmentVariable( pchar( 'CWACOMM' ), pchar( ruta_cwacomm ));
   if b_trae_utilerias then begin
      dm.get_utileria('COMPARACION DE FUENTES',g_tmpdir+'\htacompara.exe');
      dm.get_utileria( 'INSERTA_COPY', g_tmpdir + '\inserta_copy.dir' );
      dm.get_utileria( 'RGMLANG', g_tmpdir + '\htainserta_copy.exe' );
      b_trae_utilerias:=false;
   end;
   if fileexists(ruta_expandidos+'\'+cblprog)=false then begin
      dm.bfile2file( cblprog,cblbib,g_tmpdir+'\mintras.txt');
      dm.ejecuta_espera(g_tmpdir+'\htainserta_copy.exe '+
                        g_tmpdir+'\mintras.txt '+
                        ruta_expandidos+'\'+cblprog+' '+
                        g_tmpdir+'\inserta_copy.dir >'+
                        g_tmpdir+'\expandido_'+cblprog+'.log',SW_HIDE);
   end;
   memo.PlainText:=true;
   memo.Lines.Clear;
   memo.Lines.LoadFromFile(ruta_expandidos+'\'+cblprog);
   el_fuente:=cblprog;
   barchivo.Enabled:=true;
   //commarea.LoadFromFile(g_tmpdir+'\CWACOMM_mintras.txt');
end;
procedure Tftsfix.afectados;
var filtro_longitudes,filtro_estado,coma:string;
begin
   if txtlongitudes.Text<>'' then begin
      while copy(txtlongitudes.Text,1,1)=',' do
         txtlongitudes.text:=copy(txtlongitudes.Text,2,100);
      if length(txtlongitudes.Text)>0 then
         while copy(txtlongitudes.Text,length(txtlongitudes.Text),1)=',' do
            txtlongitudes.Text:=copy(txtlongitudes.Text,1,length(txtlongitudes.Text)-1);
   end;
   if txtlongitudes.Text<>'' then
      filtro_longitudes:=' and b.longitud in ('+txtlongitudes.Text+') '
   else
      filtro_longitudes:='';
   filtro_estado:='';
   coma:='';
   if chkafectado.Checked then begin
      filtro_estado:=filtro_estado+coma+g_q+chkafectado.Caption+g_q;
      coma:=',';
   end;
   if chkwarning.Checked then begin
      filtro_estado:=filtro_estado+coma+g_q+chkwarning.Caption+g_q;
      coma:=',';
   end;
   if filtro_estado<>'' then
      filtro_estado:=' and estado in ('+filtro_estado+') ';

   adoqmaestra.Close;
   adoqmaestra.SQL.Clear;
   if cmbclase.Text='CBL' then begin
      adoqmaestra.SQL.Add( 'select a.cprog,a.cbib,a.cclase,a.creg,a.ccampo,'+
         ' estado,b.nivel,b.longitud,picture,usage,linea,texto from tsmaestra a,tsvarcbl b' +
         ' where (a.cprog,a.cbib,a.cclase,a.creg,a.ccampo) in '+
         ' (select cprog,cbib,cclase,creg,ccampo from tsmaestra '+
         '   where cprog='+g_q+ttsprog.fieldbyname('Componente').AsString+g_q+
         '   and   cbib=' + g_q + cmbbib.Text + g_q +
         '   and   cclase=' + g_q + cmbclase.Text + g_q +
         '   and   creg<>'+g_q+'FILE'+g_q+
         '   and   substr(ccampo,1,6)<>'+g_q+'FILLER'+g_q+
         '   minus '+
         '   select hcprog,hcbib,hcclase,hcreg,hccampo from tsrelavcbl '+
         '   where hcprog='+g_q+ttsprog.fieldbyname('Componente').AsString+g_q+
         '   and   hcbib=' + g_q + cmbbib.Text + g_q +
         '   and   hcclase=' + g_q + cmbclase.Text + g_q +
         '   and   pcclase='+g_q+'CPY'+g_q+')'+
         filtro_estado+
         filtro_longitudes+
         ' and a.cprog=b.cprog '+
         ' and a.cbib=b.cbib '+
         ' and a.cclase=b.cclase '+
         ' and a.creg=b.creg '+
         ' and a.ccampo=b.ccampo '+
         ' order by linea desc' );
   end;
   if cmbclase.Text='CPY' then begin
      adoqmaestra.SQL.Add( 'select distinct a.cprog,a.cbib,a.cclase,a.creg,a.ccampo,'+
         ' a.estado,b.nivel niv,b.longitud,b.picture,b.usage,b.texto from tsmaestra a,tsvarcbl b, tsrelavcbl c '+
         ' where  a.cprog='+g_q+ttsprog.fieldbyname('Componente').AsString+g_q+
         ' and    a.cbib=' + g_q + cmbbib.Text + g_q +
         ' and    a.cclase=' + g_q + cmbclase.Text + g_q +
         filtro_estado+
         filtro_longitudes+
         ' and    a.cprog= c.pcprog '+
         ' and    a.cbib= c.pcbib '+
         ' and    a.cclase= c.pcclase '+
         ' and    a.creg= c.pcreg '+
         ' and    a.ccampo= c.pccampo '+
         ' and    c.hcprog= b.cprog '+
         ' and    c.hcbib= b.cbib '+
         ' and    c.hcclase= b.cclase '+
         ' and    c.hcreg= b.creg '+
         ' and    c.hccampo= b.ccampo '+
         ' order by a.creg,a.ccampo' );
   end;
   if cmbclase.Text='BMS' then begin
      adoqmaestra.SQL.Add( 'select a.cprog,a.cbib,a.cclase,a.creg,a.ccampo campo,'+
         ' estado,b.nivel,b.longitud longi,picture,inicial,linea,texto from tsmaestra a,tsvarcbl b' +
         ' where a.cprog='+g_q+ttsprog.fieldbyname('Componente').AsString+g_q+
         ' and   a.cbib=' + g_q + cmbbib.Text + g_q +
         ' and   a.cclase='+g_q+'BMS'+g_q+
         filtro_estado+
         filtro_longitudes+
         ' and a.cprog=b.cprog '+
         ' and a.cbib=b.cbib '+
         ' and a.cclase=b.cclase '+
         ' and a.ccampo=b.picture '+
         ' order by linea desc, inicial desc' );
   end;
   adoqmaestra.open;

   if adoqmaestra.Eof then begin
      //   if ttsprog.RecordCount=0 then begin
      //Application.MessageBox( pchar( dm.xlng( 'Sin registros' ) ),
      //   pchar( dm.xlng( 'Conversión ' ) ), MB_OK );
      barchivo.Enabled := false;
      //bdir.Enabled := false;
      //bcompara.Enabled := false;
   end
   else begin
      barchivo.Enabled := true;
      dbgmaestra.Columns[0].Width:=70;
      dbgmaestra.Columns[1].Width:=50;
      dbgmaestra.Columns[2].Width:=25;
      dbgmaestra.Columns[3].Width:=150;
      dbgmaestra.Columns[4].Width:=150;
      dbgmaestra.Columns[5].Width:=70;
      dbgmaestra.Columns[6].Width:=30;
      dbgmaestra.Columns[7].Width:=70;
      dbgmaestra.Columns[8].Width:=70;
      dbgmaestra.Columns[9].Width:=35;
      adoqmaestra.First;
      if (cmbclase.Text='CBL') or
         (cmbclase.Text='CPY') then begin
         expande(cmbbib.text,ttsprog.fieldbyname('Componente').AsString);
      end;
      if cmbclase.Text='BMS' then begin
         dm.trae_fuente(ttsprog.fieldbyname('Componente').AsString,cmbbib.text,memo);
      end;
   end;
end;


procedure Tftsfix.dbgCellClick(Column: TColumn);
begin
   afectados;
end;

procedure Tftsfix.dbgmaestraCellClick(Column: TColumn);
var k,lin:integer;
begin
   lin:=adoqmaestra.fieldbyname('linea').asinteger;
   memo.SelAttributes.Color := clgreen;
   memo.SelStart := memo.Perform( EM_LINEINDEX, lin - 1, 0 );
   memo.Perform( EM_SCROLLCARET, 0, 0 );
   k := memo.Perform( EM_GETFIRSTVISIBLELINE, 0, 0 );
   k := lin - k - 30;
   memo.Perform( EM_LINESCROLL, 0, k );
   memo.SelLength := length( memo.Lines[ lin - 1 ] );
   memo.SelAttributes.Color := clblue;

end;

procedure Tftsfix.txtlongitudesKeyPress(Sender: TObject; var Key: Char);
begin
   if not(Key in ['0'..'9',#8,',']) then
      key:=chr(0);
end;

procedure Tftsfix.txtlongitudesChange(Sender: TObject);
begin
   while copy(txtlongitudes.Text,1,1)=',' do
      txtlongitudes.Text:=copy(txtlongitudes.Text,2,100);
   if length(txtlongitudes.Text)>0 then
      if copy(txtlongitudes.Text,length(txtlongitudes.Text),1)=',' then
         exit;
   afectados;
end;

procedure Tftsfix.chkafectadoClick(Sender: TObject);
begin
   afectados;
end;

procedure Tftsfix.chkwarningClick(Sender: TObject);
begin
   afectados;
end;
function Tftsfix.encuentra(texto:string; k:integer):integer;
begin
   while k<=memo.Lines.Count do begin
      if copy(memo.Lines[k-1],1,6)<>'VERSAR' then begin
         if pos(' '+texto,memo.Lines[k-1])>0 then begin
            encuentra:=k;
            exit;
         end;
      end;
      inc(k);
   end;
   encuentra:=-1;
end;
procedure Tftsfix.reemplaza_picture(texto:string; k:integer);
var n:integer;
   renglon:string;
begin
   n:=origen.IndexOf(texto);
   if n=-1 then begin
      showmessage('ERROR... no encuentra el picture '+texto+' en reemplaza');
      exit;
   end;
   renglon:='VERSAR '+stringreplace(copy(memo.Lines[k-1],8,200),texto,nuevos[n],[]);
   if trim(copy(renglon,73,1))<>'' then begin
      if pos('  PIC',renglon)>0 then
         renglon:=stringreplace(renglon,'  PIC',' PIC',[]);
   end
   else begin
      if length(renglon)>length(memo.Lines[k-1]) then
         delete(renglon,73,1);
   end;
   memo.Lines.Insert(k,renglon);
   memo.Lines[k-1]:='VERSAR*'+copy(memo.Lines[k-1],8,200);

end;
procedure Tftsfix.procesa_bms;
var lin,i,k:integer;
   s1,s2,s3,s4,s5:string;
   car:string;
   tex:string;
   procedure guarda(n:integer;texto:string);
   var i,j,k,nn:integer;
      tt:string;
   begin
            k:=length(modis);
            setlength(modis,k+1);
            for i:=0 to k-1 do begin
               if n<modis[i].linea then begin
                  for j:=k downto i+1 do begin
                     modis[j].linea:=modis[j-1].linea;
                     modis[j].texto:=modis[j-1].texto;
                  end;
                  modis[i].linea:=n;
                  modis[i].texto:=texto;
                  exit;
               end;
            end;
            modis[k].linea:=n;
            modis[k].texto:=texto;
   end;
   procedure pinta(n:integer; tex:string);
   begin
         if length(tex)>71 then begin                                               // si se pasa de la 71
            guarda(n,copy(tex,1,71)+'*');
            tex:='               '+copy(tex,72,500);
            guarda(n,tex);
         end
         else begin
            guarda(n,tex);
         end;
   end;
   procedure comentario(n:integer);
   begin
      memo.Lines[n]:='* '+copy(memo.Lines[n],3,100);
      if copy(memo.Lines[n],72,1)='*' then begin
         memo.Lines[n]:=copy(memo.Lines[n],1,71)+' '+copy(memo.Lines[i],73,100);
         memo.Lines[n+1]:='* '+copy(memo.Lines[n+1],3,100);
      end;
   end;
   function  busca_espacio_adelante(y:integer; x:integer):integer;
   var paso,paso2,hasta:string;
      j:integer;
   begin
      if dm.sqlselect(dm.q2,'select * from tsvarcbl '+
               ' where cprog='+g_q+adoqmaestra.fieldbyname('cprog').AsString+g_q+
               ' and   cbib='+g_q+adoqmaestra.fieldbyname('cbib').AsString+g_q+
               ' and   cclase='+g_q+adoqmaestra.fieldbyname('cclase').AsString+g_q+
               ' and   nivel='+inttostr(y)+
               ' and   inicial>'+inttostr(x)+
               ' order by inicial ') then begin
         j:=x;
         while not dm.q2.Eof do begin
            if (copy(dm.q2.fieldbyname('ccampo').AsString,1,6)='LABEL_') and
               (pos(' ',dm.q2.fieldbyname('value').AsString)>0) then begin
               paso:=stringreplace(dm.q2.fieldbyname('value').AsString,' ','',[]);
               paso2:=dm.q2.fieldbyname('value').AsString;
               paso:=stringreplace(dm.q2.fieldbyname('texto').AsString,paso2,paso,[]);
               paso:=stringreplace(paso,
                     'LENGTH='+inttostr(dm.q2.fieldbyname('longitud').asinteger),
                     'LENGTH='+inttostr(dm.q2.fieldbyname('longitud').asinteger-1),[]);
               paso:=stringreplace(paso,
                     ','+inttostr(dm.q2.fieldbyname('inicial').asinteger)+')',
                     ','+inttostr(dm.q2.fieldbyname('inicial').asinteger+1)+')',[]);
               pinta(dm.q2.fieldbyname('linea').AsInteger,'* --->VERSARIA    AMPLIACION DE CAMPO ORDEN_ID');
               pinta(dm.q2.fieldbyname('linea').Asinteger,'         '+paso);
               comentario(dm.q2.fieldbyname('linea').Asinteger);
               hasta:=dm.q2.fieldbyname('ccampo').AsString;
               dm.q2.First;
               while hasta<>dm.q2.fieldbyname('ccampo').AsString do begin
                  paso:=dm.q2.fieldbyname('texto').AsString;
                  paso:=stringreplace(paso,
                        ','+inttostr(dm.q2.fieldbyname('inicial').asinteger)+')',
                        ','+inttostr(dm.q2.fieldbyname('inicial').asinteger+1)+')',[]);
                  pinta(dm.q2.fieldbyname('linea').AsInteger,'* --->VERSARIA    AMPLIACION DE CAMPO ORDEN_ID');
                  pinta(dm.q2.fieldbyname('linea').Asinteger,'         '+paso);
                  comentario(dm.q2.fieldbyname('linea').Asinteger);
                  dm.q2.Next;
               end;
               busca_espacio_adelante:=dm.q2.fieldbyname('linea').AsInteger;
               exit;
            end;
            dm.q2.Next;
         end;
      end;
      busca_espacio_adelante:=0;
   end;
   function  busca_hueco_adelante(y:integer; x:integer):integer;
   var paso,paso2:string;
      j:integer;
      b_alfinal:boolean;
   begin
      if dm.sqlselect(dm.q2,'select * from tsvarcbl '+
               ' where cprog='+g_q+adoqmaestra.fieldbyname('cprog').AsString+g_q+
               ' and   cbib='+g_q+adoqmaestra.fieldbyname('cbib').AsString+g_q+
               ' and   cclase='+g_q+adoqmaestra.fieldbyname('cclase').AsString+g_q+
               ' and   nivel='+inttostr(y)+
               ' and   inicial>'+inttostr(x)+
               ' order by inicial ') then begin
         j:=x;
         b_alfinal:=false;
         while not dm.q2.Eof do begin
            if (dm.q2.FieldByName('inicial').AsInteger>j+1) or (b_alfinal) then begin
               dm.q2.First;
               while (dm.q2.FieldByName('inicial').AsInteger<j) and
                  (dm.q2.Eof=false) do begin
                  if copy(dm.q2.fieldbyname('ccampo').AsString,1,6)='LABEL_' then
                     paso2:='         '
                  else
                     paso2:='';
                  paso:=stringreplace(dm.q2.fieldbyname('texto').AsString,
                     ','+inttostr(dm.q2.fieldbyname('inicial').asinteger)+')',
                     ','+inttostr(dm.q2.fieldbyname('inicial').asinteger+1)+')',[]);
                  pinta(dm.q2.fieldbyname('linea').AsInteger-1,'* --->VERSARIA    AMPLIACION DE CAMPO ORDEN_ID');
                  pinta(dm.q2.fieldbyname('linea').Asinteger-1,paso2+paso);
                  comentario(dm.q2.fieldbyname('linea').Asinteger-1);
                  dm.q2.Next;
               end;
               busca_hueco_adelante:=dm.q2.fieldbyname('linea').Asinteger;
               exit;
            end
            else
               j:=dm.q2.FieldByName('inicial').AsInteger+
                  dm.q2.fieldbyname('longitud').asinteger;
            dm.q2.Next;
            if dm.q2.Eof then begin
               if j<80 then begin
                  b_alfinal:=true;
                  dm.q2.First;
               end;
            end;
         end;
      end;
      busca_hueco_adelante:=0;
   end;

   function  busca_espacio_atras(y:integer; x:integer):integer;
   var paso,paso2:string;
   begin
      if dm.sqlselect(dm.q2,'select * from tsvarcbl '+
               ' where cprog='+g_q+adoqmaestra.fieldbyname('cprog').AsString+g_q+
               ' and   cbib='+g_q+adoqmaestra.fieldbyname('cbib').AsString+g_q+
               ' and   cclase='+g_q+adoqmaestra.fieldbyname('cclase').AsString+g_q+
               ' and   nivel='+inttostr(y)+
               ' and   inicial<'+inttostr(x)+
               ' order by inicial desc') then begin
         while not dm.q2.Eof do begin
            if copy(dm.q2.fieldbyname('ccampo').AsString,1,6)='LABEL_' then begin
               if pos(' ',dm.q2.fieldbyname('value').AsString)>0 then begin
                  paso:=dm.q2.fieldbyname('value').AsString;
                  delete(paso,pos(' ',paso),1);
                  paso:='INITIAL='+paso;
                  paso2:='INITIAL='+dm.q2.fieldbyname('value').AsString;
                  paso:=stringreplace(dm.q2.fieldbyname('texto').AsString,paso2,paso,[]);
                  paso:=stringreplace(paso,
                     'LENGTH='+inttostr(dm.q2.fieldbyname('longitud').asinteger),
                     'LENGTH='+inttostr(dm.q2.fieldbyname('longitud').asinteger-1),[]);
                  pinta(dm.q2.fieldbyname('linea').AsInteger,'* --->VERSARIA    AMPLIACION DE CAMPO ORDEN_ID');
                  pinta(dm.q2.fieldbyname('linea').Asinteger,'         '+paso);
                  comentario(dm.q2.fieldbyname('linea').Asinteger);
                  busca_espacio_atras:=dm.q2.fieldbyname('linea').Asinteger;
                  exit;
               end;
            end;
            dm.q2.Next;
         end;
      end;
      busca_espacio_atras:=0;
   end;
   procedure actualiza_orden(ini:integer);
   var k:integer;
      tex:string;
   begin
      tex:=adoqmaestra.fieldbyname('texto').AsString;
      tex:=stringreplace(tex,'LENGTH=9','LENGTH=10',[]);
      k:=pos('INITIAL=',tex);
      if k>0 then begin
         tex:=copy(tex,1,k+10)+copy(tex,k+10,1)+copy(tex,k+10+1,200);
      end;
      if ini<>0 then begin
         tex:=stringreplace(tex,','+adoqmaestra.FieldByName('inicial').AsString+')',','+  // cambia posicion inicial
            inttostr(ini)+')',[]);
      end;
      pinta(adoQmaestra.fieldbyname('linea').AsInteger-1,'* --->VERSARIA    AMPLIACION DE CAMPO ORDEN_ID');
      pinta(adoQmaestra.fieldbyname('linea').AsInteger-1,tex);
      comentario(adoQmaestra.fieldbyname('linea').AsInteger-1);
   end;
begin
   if dm.sqlselect(dm.q1,'select * from tsvarcbl '+
            ' where cprog='+g_q+adoqmaestra.fieldbyname('cprog').AsString+g_q+
            ' and   cbib='+g_q+adoqmaestra.fieldbyname('cbib').AsString+g_q+
            ' and   cclase='+g_q+adoqmaestra.fieldbyname('cclase').AsString+g_q+
            ' and   picture<>'+g_q+adoqmaestra.fieldbyname('campo').AsString+g_q+
            ' and   nivel='+g_q+adoqmaestra.fieldbyname('nivel').AsString+g_q+
            ' and   inicial<'+g_q+inttostr(adoqmaestra.fieldbyname('inicial').Asinteger+adoqmaestra.fieldbyname('longi').AsInteger+2)+g_q+
            ' and   inicial>='+g_q+inttostr(adoqmaestra.fieldbyname('inicial').Asinteger)+g_q) then begin
      if (copy(dm.q1.FieldByName('ccampo').AsString,1,6)='LABEL_') and        // Localiza campo siguiente
         (copy(dm.q1.FieldByName('value').AsString,2,1)=' ') then begin
         //tex:=memo.Lines[dm.q1.FieldByName('linea').AsInteger-1];
         tex:='         '+dm.q1.FieldByName('texto').AsString;
         tex:=stringreplace(tex,'INITIAL='' ','INITIAL=''',[]);                     // le quita un espacio
         tex:=stringreplace(tex,','+dm.q1.FieldByName('inicial').AsString+')',','+  // incrementa posicion inicial
            inttostr(dm.q1.FieldByName('inicial').asinteger+1)+')',[]);
         tex:=stringreplace(tex,'LENGTH='+dm.q1.FieldByName('longitud').AsString,'LENGTH='+  // decrementa longitud
                     inttostr(dm.q1.FieldByName('longitud').asinteger-1),[]);
         pinta(dm.q1.fieldbyname('linea').AsInteger-1,'* --->VERSARIA    AMPLIACION DE CAMPO ORDEN_ID');
         pinta(dm.q1.fieldbyname('linea').AsInteger-1,tex);
         comentario(dm.q1.fieldbyname('linea').AsInteger-1);
         actualiza_orden(0);
      end
      else
      if busca_hueco_adelante(adoqmaestra.fieldbyname('nivel').Asinteger,
         adoqmaestra.fieldbyname('inicial').Asinteger+
         adoqmaestra.fieldbyname('longi').Asinteger)>0 then begin
         actualiza_orden(0);
      end
      else
      if busca_espacio_adelante(adoqmaestra.fieldbyname('nivel').Asinteger,
         adoqmaestra.fieldbyname('inicial').Asinteger+
         adoqmaestra.fieldbyname('longi').Asinteger)>0 then begin
         actualiza_orden(0);
      end
      else
      if busca_espacio_atras(adoqmaestra.fieldbyname('nivel').Asinteger,
         adoqmaestra.fieldbyname('inicial').Asinteger)>0 then begin
         actualiza_orden(adoqmaestra.fieldbyname('inicial').Asinteger-1);
         exit;
      end
      else
         showmessage('Invasion....'+adoqmaestra.fieldbyname('cprog').AsString+' - '+adoqmaestra.fieldbyname('campo').AsString+
            ' - '+dm.q1.fieldbyname('ccampo').AsString);
   end
   else begin
      actualiza_orden(0);
   end;
end;
    {




   lin:=adoqmaestra.fieldbyname('linea').AsInteger-1;

   s1:='LENGTH='+adoqmaestra.fieldbyname('longi').asstring;
   s2:='LENGTH='+inttostr(adoqmaestra.fieldbyname('longi').asinteger+1);
   if length(s1)=length(s2) then begin
      while lin<memo.Lines.Count do begin
         if pos(s1,memo.Lines[lin])>0 then begin
            s3:=stringreplace(memo.Lines[lin],s1,s2,[]);
            //memo.Lines.Insert(lin+1,s3);
            guarda(lin+1,s3);
            s3:='* '+copy(memo.Lines[lin],3,100);
            guarda(lin,s3);
            memo.Lines[lin]:='* --->VERSARIA    AMPLIACION DE CAMPO ORDEN_ID';
            exit;
         end;
         inc(lin);
      end;
   end;
   if length(s1)<length(s2) then begin
      car:='';
      while lin<memo.Lines.Count do begin
         if pos(s1,memo.Lines[lin])>0 then begin
            s3:=stringreplace(memo.Lines[lin],s1,s2,[]);
            if copy(s3,73,1)<>' ' then begin      // era continuacion
               if copy(s3,72,1)=' ' then begin    // tiene espacio antes de continuacion
                  delete(s3,72,1);
                  guarda(lin+1,s3);
                  s3:='* '+copy(memo.Lines[lin],3,100);
                  memo.Lines[lin]:=s3;
                  guarda(lin,'* --->VERSARIA    AMPLIACION DE CAMPO ORDEN_ID');
                  exit;
               end
               else begin                 // rescata caracter para pegarlo abajo
                  car:=copy(s3,72,1);
                  delete(s3,72,1);
                  s4:='';
                  i:=1;
                  while copy(memo.lines[lin+1],i,1)=' ' do
                     inc(i);
                  s4:=copy(memo.lines[lin+1],1,i-1)+car+copy(memo.Lines[lin+1],i,100);
                  delete(s4,72,1);
                  s5:='* '+copy(memo.Lines[lin+1],3,100);
                  guarda(lin,'* --->VERSARIA    AMPLIACION DE CAMPO ORDEN_ID');
                  guarda(lin+1,s5);
                  guarda(lin+2,s3);
                  guarda(lin+2,s4);
                  //memo.LineS.Insert(lin+2,s4);
                  //memo.LineS.Insert(lin+2,s3);
                  //s5:='* '+copy(memo.Lines[lin+1],3,100);
                  //memo.Lines[lin+1]:=s5;
                  s3:='* '+copy(memo.Lines[lin],3,100);
                  memo.Lines[lin]:=s3;
                  //memo.Lines.Insert(lin,'* --->VERSARIA    AMPLIACION DE CAMPO ORDEN_ID');
                  exit;
               end;
            end
            else begin                           // no es continuacion
               if copy(s3,72,1)=' ' then begin    // tiene espacio antes de continuacion
                  guarda(lin,'* --->VERSARIA    AMPLIACION DE CAMPO ORDEN_ID');
                  delete(s3,73,1);
                  //memo.LineS.Insert(lin+1,s3);
                  guarda(lin+1,s3);
                  s3:='* '+copy(memo.Lines[lin],3,100);
                  memo.Lines[lin]:=s3;
                  //memo.Lines.Insert(lin,'* --->VERSARIA    AMPLIACION DE CAMPO ORDEN_ID');
                  exit;
               end
               else begin                      // invade caracter de continuacion
                  car:=copy(s3,72,1);          // rescata caracter para pegarlo abajo
                  delete(s3,72,1);
                  s4:='               '+car;
                  guarda(lin,'* --->VERSARIA    AMPLIACION DE CAMPO ORDEN_ID');
                  guarda(lin+1,s3);
                  guarda(lin+1,s4);
                  //memo.LineS.Insert(lin+1,s4);
                  //memo.LineS.Insert(lin+1,s3);
                  s3:='* '+copy(memo.Lines[lin],3,100);
                  memo.Lines[lin]:=s3;
                  //memo.Lines.Insert(lin,'* --->VERSARIA    AMPLIACION DE CAMPO ORDEN_ID');
                  exit;
               end;
            end;
         end;
         inc(lin);
      end;
   end;
end;
}
procedure Tftsfix.barchivoClick(Sender: TObject);
var i,k,lin:integer;
   cero:string;
   sal:Tstringlist;
begin
   adoqmaestra.First;
   while not adoqmaestra.Eof do begin
      if cmbclase.Text='BMS' then begin
         procesa_bms;
         adoqmaestra.Next;
         continue;
      end;
      if cmbclase.text='CPY' then
         lin:=1
      else
         lin:=adoqmaestra.fieldbyname('linea').AsInteger;
      k:=encuentra(adoqmaestra.FieldByName('ccampo').AsString,lin);
      if k=-1 then begin
         showmessage('ERROR... no encuentra la variable '+adoqmaestra.FieldByName('ccampo').AsString);
         abort;
      end;
      if adoqmaestra.FieldByName('picture').AsString='' then begin
         if dm.sqlselect(dm.q1,'select nivel,tsvarcbl.linea lin, tsvarcbl.texto tex from tsrelavcbl,tsvarcbl '+
            ' where pcprog='+g_q+adoqmaestra.fieldbyname('cprog').AsString+g_q+
            ' and   pcbib='+g_q+adoqmaestra.fieldbyname('cbib').AsString+g_q+
            ' and   pcclase='+g_q+adoqmaestra.fieldbyname('cclase').AsString+g_q+
            ' and   pcreg='+g_q+adoqmaestra.fieldbyname('creg').AsString+g_q+
            ' and   pccampo='+g_q+adoqmaestra.fieldbyname('ccampo').AsString+g_q+
            ' and   modo='+g_q+'DOWN'+g_q+
            ' and   hcprog=cprog '+
            ' and   hcbib=cbib '+
            ' and   hcclase=cclase '+
            ' and   hcreg=creg '+
            ' and   hccampo=ccampo '+
            ' order by tsvarcbl.linea') then begin
            cero:='VERSAR ';
            i:=8;
            while copy(dm.q1.FieldByName('tex').AsString,i,1)=' ' do begin  // sangria
               cero:=cero+' ';
               inc(i);
            end;
            while copy(dm.q1.FieldByName('tex').AsString,i,1)<>' ' do inc(i); // nivel
            if dm.q1.fieldbyname('nivel').AsInteger<10 then
               cero:=cero+'0';
            cero:=cero+inttostr(dm.q1.fieldbyname('nivel').AsInteger);
            while copy(dm.q1.FieldByName('tex').AsString,i,1)=' ' do begin  // espacios despues de nivel
               cero:=cero+' ';
               inc(i);
            end;
            cero:=cero+'FILLER';
            i:=i+6;
            k:=pos('PIC',dm.q1.FieldByName('tex').AsString);
            if k>i+1 then begin
               while i<k-1 do begin  // espacios despues del campo
                  cero:=cero+' ';
                  inc(i);
               end;
            end;
            cero:=cero+' PIC  X.';
            memo.Lines.Insert(dm.q1.fieldbyname('lin').AsInteger-1,cero);
//            memo.Lines.Insert(dm.q1.fieldbyname('lin').AsInteger-1,
//               'VERSAR '+cero+inttostr(dm.q1.fieldbyname('nivel').AsInteger)+
//               ' FILLER                        PIC X.');
         end;
      end
      else begin
         k:=encuentra(adoqmaestra.FieldByName('picture').AsString,k);
         if k=-1 then begin
            showmessage('ERROR... no encuentra el picture '+adoqmaestra.FieldByName('ccampo').AsString);
            abort;
         end;
         reemplaza_picture(adoqmaestra.FieldByName('picture').AsString,k);
      end;
      adoqmaestra.Next;
   end;
   if cmbclase.Text='BMS' then begin
      sal:=Tstringlist.Create;
      for i:=0 to length(modis)-1 do
         sal.Add(inttostr(modis[i].linea)+'-'+modis[i].texto);
      sal.SaveToFile(g_tmpdir+'\salida.txt');
      sal.Free;
      for i:=length(modis)-1 downto 0 do begin
         memo.Lines.Insert(modis[i].linea,modis[i].texto);
      end;
      i:=0;
      while copy(memo.Lines[i],1,1)='*' do
         inc(i);
      memo.Lines.Insert(i,'* *                                                              **');
      memo.Lines.Insert(i,'* *  DESCR : AMPLIACION DEL ORDEN-ID A 10 POSICIONES             **');
      memo.Lines.Insert(i,'* *  FECHA : '+formatdatetime('DD/MMM/YYYY',now)+'       AUTOR: VERSARIA                   **');
      memo.Lines.Insert(i,'* *  ID    : VERSAR                                              **');
      convertido.Clear;
      convertido.AddStrings(memo.Lines);
      setlength(modis,0);
   end
   else begin
      if cmbclase.Text='CPY' then begin
         for i:=0 to memo.Lines.Count-1 do begin
            if copy(memo.Lines[i],7,1)<>'*' then break;
         end;
         i:=i-1;
      end
      else begin
         for k:=0 to memo.Lines.Count-1 do begin
            if copy(memo.Lines[k],7,2)<>'**' then break;
         end;
         for i:=k-1 downto 0 do begin
            if copy(memo.Lines[i],7,3)='** ' then break;
         end;
      end;
      memo.Lines.Insert(i+1,'      **                                                              **');
      memo.Lines.Insert(i+1,'      **  DESCR : AMPLIACION DEL ORDEN-ID A 10 POSICIONES             **');
      memo.Lines.Insert(i+1,'      **  FECHA : '+formatdatetime('DD/MMM/YYYY',now)+'       AUTOR: VERSARIA                   **');
      memo.Lines.Insert(i+1,'      **  ID    : VERSAR                                              **');
      convertido.Clear;
      for i:=0 to memo.Lines.Count-1 do begin
         if copy(memo.Lines[i],1,7)='SVS****' then
            memo.lines[i]:='       '+copy(memo.lines[i],8,200);
         if copy(memo.Lines[i],1,3)<>'SVS' then
            convertido.Add(memo.Lines[i]);
      end;
   end;
   if dir_salida='' then begin
      savedialog1.FileName:=adoqmaestra.fieldbyname('cprog').AsString;
      if savedialog1.Execute=false then exit;
      dir_salida:=extractfilepath(savedialog1.FileName);
   end;
   convertido.SaveToFile(dir_salida+'\'+adoqmaestra.fieldbyname('cprog').AsString);
   barchivo.Enabled:=false;
end;

procedure Tftsfix.bcomparaClick(Sender: TObject);
begin
   if b_trae_utilerias then begin
      dm.get_utileria('COMPARACION DE FUENTES',g_tmpdir+'\htacompara.exe');
      dm.get_utileria( 'INSERTA_COPY', g_tmpdir + '\inserta_copy.dir' );
      dm.get_utileria( 'RGMLANG', g_tmpdir + '\htainserta_copy.exe' );
      b_trae_utilerias:=false;
   end;
   if dir_salida='' then begin
      savedialog1.FileName:=adoqmaestra.fieldbyname('cprog').AsString;
      if savedialog1.Execute=false then exit;
      dir_salida:=extractfilepath(savedialog1.FileName);
   end;
   dm.bfile2file(adoqmaestra.fieldbyname('cprog').AsString,cmbbib.Text,g_tmpdir+'\'+adoqmaestra.fieldbyname('cprog').AsString);
   ShellExecute( 0, 'open', pchar( g_tmpdir+'\htacompara.exe' ),
      pchar(g_tmpdir+'\'+adoqmaestra.fieldbyname('cprog').AsString+' '
      +dir_salida+adoqmaestra.fieldbyname('cprog').AsString), PChar( g_tmpdir ), SW_SHOW );

end;

procedure Tftsfix.bdirClick(Sender: TObject);
begin
   screen.Cursor := crsqlwait;
   if b_trae_utilerias then begin
      dm.get_utileria('COMPARACION DE FUENTES',g_tmpdir+'\htacompara.exe');
      dm.get_utileria( 'INSERTA_COPY', g_tmpdir + '\inserta_copy.dir' );
      dm.get_utileria( 'RGMLANG', g_tmpdir + '\htainserta_copy.exe' );
      b_trae_utilerias:=false;
   end;
   b_noprocesa:=true;
   //Ttsprog.First;
   while not ttsprog.Eof do begin
      afectados;
      if barchivo.Enabled then
         barchivoclick(sender);
      ttsprog.next;
   end;
   b_noprocesa:=false;
   screen.Cursor := crdefault;

end;

end.
