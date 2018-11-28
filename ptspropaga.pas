unit ptspropaga;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,shellapi,ADODB, Grids, DB, DBGrids;
type
   TMyRec = record
      pcprog: string;
      pcbib: string;
      pcclase: string;
      pcreg:string;
      pccampo:string;
      hcprog: string;
      hcbib: string;
      hcclase: string;
      hcreg:string;
      hccampo:string;
      modo:string;
      linea:integer;
      procesado:boolean;
   end;

type
  Tftspropaga = class(TForm)
    Panel1: TPanel;
    cmbclase: TComboBox;
    Label1: TLabel;
    cmbbiblioa: TLabel;
    cmbbiblioteca: TComboBox;
    Label2: TLabel;
    cmbcomponente: TComboBox;
    Label3: TLabel;
    cmbcampo: TComboBox;
    Label4: TLabel;
    cmbregistro: TComboBox;
    memo: TRichEdit;
    Label5: TLabel;
    cmbanaliza: TComboBox;
    Label6: TLabel;
    dg: TDrawGrid;
    Splitter2: TSplitter;
    cmbcopylib: TComboBox;
    Label7: TLabel;
    bejecuta: TButton;
    dbgtsmaestra: TDBGrid;
    DataSource1: TDataSource;
    ADOtsmaestra: TADOQuery;
    lst: TListBox;
    btodo: TButton;
    bunico: TButton;
    bvarios: TButton;
    cmbbib: TComboBox;
    Label8: TLabel;
    lblregistros: TLabel;
    Button1: TButton;
    dbg2: TDBGrid;
    ds2: TDataSource;
    ado2: TADOQuery;
    rgclase: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure cmbclaseChange(Sender: TObject);
    procedure cmbbibliotecaChange(Sender: TObject);
    procedure cmbcomponenteChange(Sender: TObject);
    procedure cmbcampoChange(Sender: TObject);
    procedure dgDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure dgSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure bejecutaClick(Sender: TObject);
    procedure dbgtsmaestraCellClick(Column: TColumn);
    procedure bunicoClick(Sender: TObject);
    procedure bvariosClick(Sender: TObject);
    procedure cmbbibChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btodoClick(Sender: TObject);
  private
    { Private declarations }
      clase_fisico,clase_descripcion: Tstringlist;
    arch,tex,cam,afectados:Tstringlist;
    yx:array of array of string;
    zx,zy:integer;
    archivos:Tstringlist;    // Lista de archivos logicos del cobol afectados
    jcls:Tstringlist;        // Lista de pasos donde se encontró el COBOL
    b_trae_utilerias:boolean;
    fil_prog,fil_bib,fil_logico,fil_reg,fil_campo,externo:string;  // para manejo de archivos
    fil_inicio:integer;
    primer_tamano:integer;
    b_online:boolean;
    rcprog,rcbib,rcclase,rcreg,rccampo:string;
    commarea:Tstringlist;
      procedure conecta;
      procedure procesa_tab(cblbib,cblprog:string);
      procedure expande(cblbib,cblprog:string);
      procedure trae_reg(prog,bib,clase,reg,campo:string;var nivel:integer; var inicio:integer; var longitud:integer);
      procedure trae_pic(prog,bib,clase,reg,campo:string;var nivel:integer; var inicio:integer; var longitud:integer);
      procedure busca_jcl(pcprog,pcbib,pcclase:string; repe:Tstringlist);
      procedure alta_base(afectados:Tstringlist; cprog,cbib,cclase:string);
      Procedure reporta(marca:string;prog,bib,clase:string; acprog:string; acbib:string; acclase:string; acreg:string; accampo:string;
      hcprog:string; hcbib:string; hcclase:string; hcreg:string; hccampo:string; modo:string;linea:integer;xcampo:string;
      nivel,inicio,longitud:integer);
      procedure busca_coboles(cprog:string; cbib:string; cclase:string);
      procedure procesa(cblbib,cblprog,clase,bib,prog,reg,campo:string);
      procedure paso1(cprog,cbib,cclase:string);
      procedure paso2(cprog,cbib,cclase:string);
      procedure paso3(cprog,cbib,cclase:string);
      procedure lee_fd(cprog,cbib,cclase,creg,ccampo:string);
      procedure lee_registro(cprog,cbib,cclase,creg,ccampo:string);
      procedure lee_campo(cprog,cbib,cclase,creg,ccampo:string);
  public
    { Public declarations }
   procedure trae_copys(bib:string; lineas:Tstrings);
  end;

var
  ftspropaga: Tftspropaga;
procedure PR_PROPAGA;

implementation
uses ptsdm;
{$R *.dfm}
procedure PR_PROPAGA;
begin
   Application.CreateForm( Tftspropaga, ftspropaga );
   try
      ftspropaga.Showmodal;
   finally
      ftspropaga.Free;
   end;
end;
//**************************** SIN USO ********************************************
procedure Tftspropaga.procesa(cblbib,cblprog,clase,bib,prog,reg,campo:string);
var i,j:integer;
    tempo:string;
    nivel,inicio,longitud:integer;
begin
   if reg=campo then
      tempo:='-*-'
   else
      tempo:='   ';
   if clase='FIL' then begin
      fil_prog:=cblprog;
      fil_bib:=cblbib;
      fil_campo:='';
      fil_inicio:=strtoint(copy(campo,2,pos('-',campo)-2));
      paso1(prog,bib,clase);
      if fil_campo='' then
         exit;
      //prog:=fil_logico;
      prog:=cblprog;
      bib:=cblbib;
      clase:='CBL';
      reg:=fil_reg;
      campo:=fil_campo;
   end;
   trae_pic(prog,bib,clase,reg,campo,nivel,inicio,longitud);
   {
   b_online:=dm.sqlselect(dm.q3,'select hcprog from tsrela '+
      ' where pcprog='+g_q+cblprog+g_q+
      ' and   pcbib='+g_q+cblbib+g_q+
      ' and   pcclase='+g_q+'CBL'+g_q+
      ' and   hcprog='+g_q+'CICS'+g_q+
      ' and   hcbib='+g_q+'SYSTEM'+g_q+
      ' and   hcclase='+g_q+'UTI'+g_q);
   }
   b_online:=true;
   reporta(tempo,cblprog,cblbib,'CBL',
      prog,bib,clase,reg,campo,
      prog,bib,clase,reg,campo,
      ' ',0,'',
      nivel,inicio,longitud);
   afectados.Sort;
   afectados.SaveToFile(g_tmpdir+'\afectados.csv');
   alta_base(afectados,cblprog,cblbib,'CBL');
   //ShellExecute( 0, 'open', pchar( g_tmpdir+'\mintras2.txt' ), nil, PChar( g_tmpdir ), SW_SHOW );
end;
procedure Tftspropaga.trae_copys(bib:string; lineas:Tstrings);
var i,j:integer;
   lin:string;
begin
   for i:=0 to lineas.Count-1 do begin
      if copy(lineas[i],7,1)<>' ' then continue;
      lin:=copy(uppercase(lineas[i]),8,65);
      j:=pos('COPY',lin);
      if j>0 then begin
         lin:=copy(lin,j+5,100);
         j:=pos('.',lin);
         if j>0 then
            lin:=copy(lin,1,j-1);
         lin:=trim(lin);
         j:=pos(' ',lin);
         if j>0 then
            lin:=copy(lin,1,j-1);
         if dm.sqlselect(dm.q1,'select cprog from tsprog '+
            ' where cprog='+g_q+lin+g_q+
            ' and cbib='+g_q+bib+g_q+
            ' and cclase='+g_q+'CPY'+g_q) then begin
            //dm.bfile2file(lin,bib,g_tmpdir+'\'+lin);
            dm.bfile2file(lin,bib,'CPY',g_tmpdir+'\'+lin);
            g_borrar.Add(g_tmpdir+'\'+lin);
         end;
      end;
      j:=pos('INCLUDE',lin);
      if j>0 then begin
         lin:=copy(lin,j+8,100);
         j:=pos('.',lin);
         if j>0 then
            lin:=copy(lin,1,j-1);
         lin:=trim(lin);
         j:=pos(' ',lin);
         if j>0 then
            lin:=copy(lin,1,j-1);
         if dm.sqlselect(dm.q1,'select cprog from tsprog '+
            ' where cprog='+g_q+lin+g_q+
            ' and cbib='+g_q+bib+g_q+
            ' and cclase='+g_q+'CPY'+g_q) then begin
            //dm.bfile2file(lin,bib,g_tmpdir+'\'+lin);
            dm.bfile2file(lin,bib,'CPY',g_tmpdir+'\'+lin);
            g_borrar.Add(g_tmpdir+'\'+lin);
         end;
      end;
   end;
end;
procedure Tftspropaga.bejecutaClick(Sender: TObject);  //FALTA SISTEMA JCR
var i,j:integer;
    tempo, lwClase:string;
    niv,ini,lon:integer;
begin
   arch.Clear;
   tex.clear;
   cam.clear;
   dg.ColCount:=1;
   dg.RowCount:=1;
   setlength(yx,1);
   setlength(yx[0],1);
   yx[0][0]:='--';
   zx:=0;
   zy:=0;
   label5.Caption:=copy(cmbanaliza.Text,1,pos(',',cmbanaliza.text)-1)+' - '+copy(cmbanaliza.Text,pos(',',cmbanaliza.text)+1,100);

   lwClase := '';
   if dm.sqlselect( dm.q5, 'select cclase from tsprog ' +
      ' where cprog=' + g_q + copy(cmbanaliza.Text,pos(',',cmbanaliza.text)+1,100) + g_q +
      ' and   cbib=' + g_q + copy(cmbanaliza.Text,1,pos(',',cmbanaliza.text)-1) + g_q + ' group by cclase') then
      lwClase := dm.q5.fieldbyname( 'cclase' ).AsString;

   dm.trae_fuente( ' ', copy(cmbanaliza.Text,pos(',',cmbanaliza.text)+1,100), copy(cmbanaliza.Text,1,pos(',',cmbanaliza.text)-1),lwClase,  memo );
   trae_copys(cmbcopylib.Text,memo.Lines);
   memo.Lines.SaveToFile(g_tmpdir+'\mintras.txt');
   dm.get_utileria( 'INSERTA_COPY', g_tmpdir + '\inserta_copy.dir' );
   dm.get_utileria( 'RGMLANG', g_tmpdir + '\htainserta_copy.exe' );
//   if trim(cmbcopylib.Text)='' then
      SetEnvironmentVariable( pchar( 'COPYLIB' ), pchar( g_tmpdir ));
//   else
//      SetEnvironmentVariable( pchar( 'COPYLIB' ), pchar( dm.pathbib(cmbcopylib.Text ) ));
   dm.ejecuta_espera(g_tmpdir+'\htainserta_copy.exe '+g_tmpdir+'\mintras.txt '+
      g_tmpdir+'\mintras2.txt '+g_tmpdir+'\inserta_copy.dir >'+
      g_tmpdir+'\inserta_copy.res',SW_HIDE);
   memo.Lines.Clear;
   memo.Lines.LoadFromFile(g_tmpdir+'\mintras2.txt');
   afectados.Clear;
   if cmbregistro.Text=cmbcampo.Text then
      tempo:='-*-'
   else
      tempo:='   ';
   archivos.Clear;
   trae_pic(cmbcomponente.Text,
            cmbbiblioteca.Text,
            cmbclase.Text,
            cmbregistro.Text,
            cmbcampo.Text,
            niv,ini,lon);
   reporta(tempo,copy(cmbanaliza.Text,pos(',',cmbanaliza.text)+1,100),copy(cmbanaliza.Text,1,pos(',',cmbanaliza.text)-1),'CBL',
      cmbcomponente.Text,cmbbiblioteca.Text,cmbclase.Text,cmbregistro.Text,cmbcampo.Text,
      cmbcomponente.Text,cmbbiblioteca.Text,cmbclase.Text,cmbregistro.Text,cmbcampo.Text,
      ' ',0,'',niv,ini,lon);
   afectados.Sort;
   afectados.SaveToFile('afectados.csv');
   alta_base(afectados,copy(cmbanaliza.Text,pos(',',cmbanaliza.text)+1,100),copy(cmbanaliza.Text,1,pos(',',cmbanaliza.text)-1),'CBL');
   ShellExecute( 0, 'open', pchar( g_tmpdir+'\mintras2.txt' ), nil, PChar( g_tmpdir ), SW_SHOW );

end;
                       // sin uso de momento
procedure Tftspropaga.dbgtsmaestraCellClick(Column: TColumn);
begin
   exit;
   lst.Items.Clear;
   memo.Lines.Clear;
   if adotsmaestra.fieldbyname('CLASE').AsString='TAB' then begin
      dm.feed_combo(cmbbib,'select distinct hcbib '+
         ' from tsrelavcbl '+
         ' where pcprog='+g_q+adotsmaestra.fieldbyname('COMPO').AsString+g_q+
         ' and   pcbib='+g_q+adotsmaestra.fieldbyname('BIB').AsString+g_q+
         ' and   pcclase='+g_q+adotsmaestra.fieldbyname('CLASE').AsString+g_q+
         ' and   pcreg='+g_q+adotsmaestra.fieldbyname('REGISTRO').AsString+g_q+
         ' and   pccampo='+g_q+adotsmaestra.fieldbyname('CAMPO').AsString+g_q+
         ' and   hcclase='+g_q+'CBL'+g_q+
         ' order by 1');
   end
   else begin
      if dm.sqlselect(dm.q1,'select distinct pcprog,pcbib,pcclase '+    // Busca el paso JCL
         ' from tsrela '+
         ' where hcprog='+g_q+adotsmaestra.fieldbyname('COMPO').AsString+g_q+
         ' and   hcbib='+g_q+adotsmaestra.fieldbyname('BIB').AsString+g_q+
         ' and   hcclase='+g_q+adotsmaestra.fieldbyname('CLASE').AsString+g_q+
         ' and   pcclase='+g_q+'STE'+g_q+
         ' order by 1') then begin
         while not dm.q1.Eof do begin
            busca_coboles(dm.q1.fieldbyname('pcprog').AsString,
                          dm.q1.fieldbyname('pcbib').AsString,
                          dm.q1.fieldbyname('pcclase').AsString);
            dm.q1.Next;
         end;
      end;

   end;

end;
//*******************************************************************************
procedure Tftspropaga.conecta;
begin
   adotsmaestra.Close;
   adotsmaestra.SQL.Clear;
   adotsmaestra.SQL.Add('select cclase CLASE,cbib BIB,cprog COMPO,creg REGISTRO,ccampo CAMPO,estado,fecha from tsarranca '+
      ' where cclase='+g_q+rgclase.items[rgclase.itemindex]+g_q+
      ' and estado='+g_q+'AFECTADO'+g_q+
      ' order by 1,2,3,4,5');
   adotsmaestra.Open;
   dbgtsmaestra.Columns[0].Width:=50;
   dbgtsmaestra.Columns[1].Width:=50;
   dbgtsmaestra.Columns[2].Width:=250;
   dbgtsmaestra.Columns[3].Width:=100;
   dbgtsmaestra.Columns[4].Width:=100;
   dbgtsmaestra.Columns[5].Width:=80;
   dbgtsmaestra.Columns[6].Width:=80;
end;
procedure Tftspropaga.FormCreate(Sender: TObject);
var
   lwInSQL : string;
   prodclase,lwSale, Wuser, lwLista : String;
   m : tstringlist;
   j : Integer;
begin
   dm.feed_combo(cmbcopylib,'select distinct cbib from tsprog where cclase='+g_q+'CPY'+g_q+' order by 1');
   if cmbcopylib.Items.Count=1 then
      cmbcopylib.ItemIndex:=0;
   adotsmaestra.Connection:=dm.ADOConnection1;
   conecta;
   b_trae_utilerias:=true;


   dm.feed_combo(cmbclase,'select distinct pcclase from tsrelavcbl order by pcclase');
   dm.feed_combo(cmbanaliza,'select distinct pcbib||'+g_q+','+g_q+'||pcprog from tsrelavcbl '+
      ' where pcclase in ('+g_q+'CBL'+g_q+','+g_q+'CPY'+g_q+')'+
      ' order by 1');
   clase_fisico := tstringlist.Create; // Arma arreglo de fisicos
   clase_descripcion := tstringlist.Create;

  {
   if dm.sqlselect( dm.q1, 'select cclase,descripcion from tsclase ' +
      ' where objeto=' + g_q + 'FISICO' + g_q +
      ' order by cclase' ) then begin
      while not dm.q1.Eof do begin
         clase_fisico.Add( dm.q1.fieldbyname( 'cclase' ).AsString );
         clase_descripcion.Add( dm.q1.fieldbyname( 'descripcion' ).AsString );
         dm.q1.Next;
      end;
   end;
 }
 Wuser := 'ADMIN'; //Temporal  JCR
 lwSale := 'FALSE';
   while  lwSale = 'FALSE' do begin
      if ProdClase <> 'TRUE' then begin
         if dm.sqlselect( dm.q1, 'select cclase,descripcion from tsclase ' +
            ' where objeto=' + g_q + 'FISICO' + g_q +
            ' order by cclase' ) then begin
            while not dm.q1.Eof do begin
               clase_fisico.Add( dm.q1.fieldbyname( 'cclase' ).AsString );
               clase_descripcion.Add( dm.q1.fieldbyname( 'descripcion' ).AsString );
               dm.q1.Next;
            end;
         end;
         lwSale := 'TRUE';
      end else begin
         if dm.sqlselect( dm.q1, 'select * from tsproductos  where  ccapacidad = ' + g_q + g_producto + g_q +
            ' and cuser = ' + g_q + Wuser + g_q ) then begin
            lwLista := dm.q1.fieldbyname( 'cclaseprod' ).AsString;
            m := Tstringlist.Create;
            m.CommaText := lwLista;
            for j:=0 to m.count-1 do begin
               lwInSQL := trim( lwInSQL)+' '+g_q+trim(m[j])+g_q+' ';
            end;
            m.Free;
            lwInSQL:=Trim(lwInSQL);
            if lwInSQL = '' then begin
               ProdClase := 'FALSE' ;
               CONTINUE;
            end;
            lwInSQL:=stringreplace( lwInSQL,' ',',', [ rfreplaceall ] );
            if dm.sqlselect( dm.q2, 'select distinct hcclase from tsrela ' +
               ' where hcclase in ('+ lwInSQL + ')' + ' order by hcclase' ) then begin
               while not dm.q2.Eof do begin
                  if dm.sqlselect( dm.q1, 'select cclase,descripcion from tsclase ' +
                  ' where cclase = '+g_q+dm.q2.fieldbyname( 'hcclase' ).AsString+g_q+
                  ' order by cclase' ) then begin
                     clase_fisico.Add( dm.q1.fieldbyname( 'cclase' ).AsString );
                     clase_descripcion.Add( dm.q1.fieldbyname( 'descripcion' ).AsString );
                  end;
                  dm.q2.Next;
               end;
            end;
            lwSale := 'TRUE';
         end;
      end;
   end;


   label5.caption:='';
   arch:=Tstringlist.Create;
   tex:=Tstringlist.Create;
   cam:=Tstringlist.Create;
   afectados:=Tstringlist.Create;
   setlength(yx,1);
   setlength(yx[0],1);
   yx[0][0]:='--';
   zx:=0;
   zy:=0;
   jcls:=Tstringlist.Create;
   archivos:=Tstringlist.Create;
   dm.feed_combo(cmbbib,'select distinct cbib from tsprog '+
      ' where cclase='+g_q+'CBL'+g_q+
      ' order by cbib');
   commarea:=Tstringlist.Create;
end;
procedure Tftspropaga.trae_reg(prog,bib,clase,reg,campo:string;var nivel:integer; var inicio:integer; var longitud:integer);
begin                                // regresa nivel, posicion inicial del campo en el registro y su longitud
   nivel:=0;
   inicio:=0;
   longitud:=0;
   if  copy(reg,4,6)='QUEUE_' then begin
      nivel:=1;
      inicio:=1;
      longitud:=9999;
      exit;
   end;
   if reg='_CONST_' then
      exit;
   if dm.sqlselect(dm.q2,'select * from tsvarcbl '+
      ' where cprog='+g_q+prog+g_q+
      ' and   cbib='+g_q+bib+g_q+
      ' and   cclase='+g_q+clase+g_q+
      ' and   creg='+g_q+reg+g_q+
      ' and   ccampo='+g_q+campo+g_q) then begin
      nivel:=dm.q2.fieldbyname('nivel').AsInteger;
      inicio:=dm.q2.fieldbyname('inicial').AsInteger;
      longitud:=dm.q2.fieldbyname('longitud').AsInteger;
   end;
end;
procedure Tftspropaga.trae_pic(prog,bib,clase,reg,campo:string;var nivel:integer; var inicio:integer; var longitud:integer);
begin                                     // regresa nivel y longitud del campo, inicio=1
   nivel:=0;
   inicio:=0;
   longitud:=0;
   if  copy(reg,4,6)='QUEUE_' then begin
      nivel:=1;
      inicio:=1;
      longitud:=9999;
      exit;
   end;
   if (reg='_CONST_')  then
      exit;
   if dm.sqlselect(dm.q2,'select * from tsvarcbl '+
      ' where cprog='+g_q+prog+g_q+
      ' and   cbib='+g_q+bib+g_q+
      ' and   cclase='+g_q+clase+g_q+
      ' and   creg='+g_q+reg+g_q+
      ' and   ccampo='+g_q+campo+g_q) then begin
      nivel:=dm.q2.fieldbyname('nivel').AsInteger;
      inicio:=1;
      longitud:=dm.q2.fieldbyname('longitud').AsInteger;
   end;
end;

procedure Tftspropaga.cmbclaseChange(Sender: TObject);
begin
   dm.feed_combo(cmbbiblioteca,'select distinct pcbib from tsrelavcbl where pcclase='+g_q+cmbclase.Text+g_q+'order by pcbib');
end;

procedure Tftspropaga.cmbbibliotecaChange(Sender: TObject);
begin
   dm.feed_combo(cmbcomponente,'select distinct pcprog from tsrelavcbl where pcbib='+g_q+cmbbiblioteca.Text+g_q+' order by pcprog');
end;

procedure Tftspropaga.cmbcomponenteChange(Sender: TObject);
begin
   dm.feed_combo(cmbcampo,'select distinct pccampo from tsrelavcbl where pcbib='+g_q+cmbbiblioteca.Text+g_q+
      ' and pcprog='+g_q+cmbcomponente.text+g_q+' order by pccampo');
end;

procedure Tftspropaga.cmbcampoChange(Sender: TObject);
begin
   dm.feed_combo(cmbregistro,'select distinct pcreg from tsrelavcbl where pcbib='+g_q+cmbbiblioteca.Text+g_q+
      ' and pcprog='+g_q+cmbcomponente.text+g_q+
      ' and pccampo='+g_q+cmbcampo.Text+g_q+
      ' order by pcreg');
end;
procedure Tftspropaga.dgDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
  var texto:string;
begin
   if trim(yx[arow][acol])='' then exit;
   if pos(' FIL ',yx[arow][acol])>0 then begin
      dg.Canvas.Brush.Color:=clFuchsia;
      dg.Canvas.FillRect(rect);
   end
   else
   if pos(' TAB ',yx[arow][acol])>0 then begin
      dg.Canvas.Brush.Color:=clred;
      dg.Canvas.FillRect(rect);
   end
   else
   if pos('-->',yx[arow][acol])>0 then begin
      dg.Canvas.Brush.Color:=clmoneygreen;
      dg.Canvas.FillRect(rect);
   end
   else
   if pos('<--',yx[arow][acol])>0 then begin
      dg.Canvas.Brush.Color:=clyellow;
      dg.Canvas.FillRect(rect);
   end
   else
   if pos('-.-',yx[arow][acol])>0 then begin
      dg.Canvas.Brush.Color:=claqua;
      dg.Canvas.FillRect(rect);
   end
   else
   if pos('-*-',yx[arow][acol])>0 then begin
      dg.Canvas.Brush.Color:=clskyblue;
      dg.Canvas.FillRect(rect);
   end;
   texto:=yx[arow][acol];
   dg.Canvas.TextOut(rect.Left,rect.Top,copy(texto,1,pos(',',texto)-1));
   texto:=copy(texto,pos(',',texto)+1,100);
   dg.Canvas.TextOut(rect.Left,rect.Top+18,copy(texto,1,pos(',',texto)-1));
   texto:=copy(texto,pos(',',texto)+1,100);
   dg.Canvas.TextOut(rect.Left,rect.Top+36,texto);
end;

Procedure Tftspropaga.reporta(marca:string;prog,bib,clase:string;
      acprog:string; acbib:string; acclase:string; acreg:string; accampo:string;
      hcprog:string; hcbib:string; hcclase:string; hcreg:string; hccampo:string;
      modo:string;linea:integer;xcampo:string;
      nivel,inicio,longitud:integer);
var qq:Tadoquery;
   repe,tt,dato,afec:string;
   dow:integer;
   titu:string;
   i,mk:integer;
   mzy,mzx:integer;
   ureg,ucampo:string;
   niv,ini,lon,ini_en_reg,ini_afecta,paso1,paso2:integer;
   estado,condicion_subcampo:string;
begin
   if primer_tamano=0 then
      primer_tamano:=nivel;
   if nivel>9 then
      estado:='WARNING'
   else
      estado:='AFECTADO';
   if (hcclase='CBL') and (hcreg<>'_CONST_') and (hcreg<>'FILE') and (hcreg<>hccampo) then
      xcampo:=hcreg+','+hccampo;
   afec:=hcprog+','+hcbib+','+hcclase+','+hcreg+','+hccampo+','+'COB'+','+estado;
   if afectados.IndexOf(afec)=-1 then begin
      afectados.Add(afec);
      if hcclase='FIL' then
         archivos.Add(hcprog);
   end;
   repe:=inttostr(linea)+' '+acclase+' '+acbib+' '+acprog+' '+acreg+' '+accampo+' - '+
      hcclase+' '+hcbib+' '+hcprog+' '+hcreg+' '+hccampo+' '+modo;
   mk:=cam.IndexOf(repe);
   if mk=-1 then
      mk:=cam.Count;
//   titu:=marca+'['+inttostr(mk)+'] '+inttostr(linea)+' '+hcclase+' '+hcbib+' '+hcprog+','+hcreg+' '+hccampo+' '+modo;
   titu:=marca+'['+inttostr(mk)+'] '+inttostr(linea)+' '+hcclase+' '+hcprog+','+hcreg+','+hccampo+','+
      inttostr(nivel)+','+inttostr(inicio)+','+inttostr(longitud);
   if zy>=dg.RowCount then begin
      dg.RowCount:=dg.RowCount+1;
      setlength(yx,dg.RowCount);
      setlength(yx[dg.rowcount-1],dg.ColCount);
   end;
   if zx>=dg.ColCount then begin
      dg.ColCount:=dg.ColCount+1;
      for i:=0 to dg.RowCount-1 do
         setlength(yx[i],dg.ColCount);
   end;
   yx[zy][zx]:=titu;
   mzx:=zx;
   if cam.IndexOf(repe)<>-1 then
      exit;
   cam.Add(repe);
   qq:=Tadoquery.Create(self);
   qq.Connection:=dm.ADOConnection1;
   if marca<>'-*-' then begin   // Aquí afecta subcampos
      trae_reg(hcprog,hcbib,hcclase,hcreg,hccampo,niv,ini_en_reg,lon);
      ini_afecta:=ini_en_reg+inicio-1;
      if b_online then
         condicion_subcampo:=' and inicial='+inttostr(ini_en_reg+inicio-1)+        // afecta si inicia misma posicion y tiene misma longitud
                             ' and longitud='+inttostr(longitud)
      else
         condicion_subcampo:=' and inicial>='+inttostr(ini_en_reg+inicio-1)+       // afecta el campo si inicia en el area del afectado anterior
                             ' and inicial<='+inttostr(ini_en_reg+inicio-1+longitud-1);
      if dm.sqlselect(qq,'select * from tsvarcbl '+
         ' where cprog='+g_q+hcprog+g_q+
         ' and   cbib='+g_q+hcbib+g_q+
         ' and   cclase='+g_q+hcclase+g_q+
         ' and   creg='+g_q+hcreg+g_q+
         ' and   ccampo<>'+g_q+hccampo+g_q+
         ' and   ccampo<>creg '+
         condicion_subcampo) then begin
         {
      if dm.sqlselect(qq,'select * from tsrelavcbl '+
         ' where ocprog='+g_q+prog+g_q+
         ' and pcprog='+g_q+hcprog+g_q+
         ' and pcbib='+g_q+hcbib+g_q+
         ' and pcclase='+g_q+hcclase+g_q+
         ' and pcreg='+g_q+hcreg+g_q+
         ' and pccampo='+g_q+hccampo+g_q+
         ' and modo='+g_q+'DOWN'+g_q+
         ' order by linea') then begin
         }
         while not qq.Eof do begin
            {
            if (qq.fieldbyname('hcprog').AsString=acprog) and
               (qq.fieldbyname('hcbib').AsString=acbib) and
               (qq.fieldbyname('hcclase').AsString=acclase) and
               (qq.fieldbyname('hcreg').AsString=acreg) and
               (qq.fieldbyname('hccampo').AsString=accampo) then begin
               qq.Next;
               continue;
            end;
            }
               zy:=zy+1;
               zx:=zx+1;
               //marca:='-.-';
               {
               reporta('-.-',prog,bib,clase,hcprog,hcbib,hcclase,hcreg,hccampo,
                  qq.fieldbyname('hcprog').AsString, qq.fieldbyname('hcbib').AsString,
                  qq.fieldbyname('hcclase').AsString, qq.fieldbyname('hcreg').AsString,
                  stringreplace(qq.fieldbyname('hccampo').AsString,'''','''''',[rfreplaceall]),
                  qq.fieldbyname('modo').Asstring,qq.fieldbyname('linea').Asinteger,xcampo);
               }
               ini:=ini_afecta-qq.fieldbyname('inicial').AsInteger+1;    //                                         //          --XXXXX  ->  --XXX
               lon:=lon-ini+1;                                      //          --XX---  ->  --XX-
               niv:=qq.fieldbyname('longitud').AsInteger;  // longitud del campo
               if longitud<lon then
                  lon:=longitud;
               reporta('-.-',prog,bib,clase,hcprog,hcbib,hcclase,hcreg,hccampo,
                  qq.fieldbyname('cprog').AsString,
                  qq.fieldbyname('cbib').AsString,
                  qq.fieldbyname('cclase').AsString,
                  qq.fieldbyname('creg').AsString,
                  stringreplace(qq.fieldbyname('ccampo').AsString,'''','''''',[rfreplaceall]),
                  'DOWN',
                  qq.fieldbyname('linea').Asinteger,
                  xcampo,
                  niv,ini,lon);
               zx:=mzx;
            qq.Next;
         end;
      end;
   end;
   if marca<>'-.-' then begin   // Busca registro padre
      trae_reg(hcprog,hcbib,hcclase,hcreg,hccampo,niv,ini_en_reg,lon);
      ini_afecta:=ini_en_reg+inicio-1;
      if dm.sqlselect(qq,'select * from tsrelavcbl '+
         ' where ocprog='+g_q+prog+g_q+
         ' and hcprog='+g_q+hcprog+g_q+
         ' and hcbib='+g_q+hcbib+g_q+
         ' and hcclase='+g_q+hcclase+g_q+
         ' and hcreg='+g_q+hcreg+g_q+
         ' and hccampo='+g_q+hccampo+g_q+
         ' and modo='+g_q+'DOWN'+g_q+
         ' order by linea') then begin
         while not qq.Eof do begin
            if (qq.fieldbyname('pcprog').AsString=acprog) and
               (qq.fieldbyname('pcbib').AsString=acbib) and
               (qq.fieldbyname('pcclase').AsString=acclase) and
               (qq.fieldbyname('pcreg').AsString=acreg) and
               (qq.fieldbyname('pccampo').AsString=accampo) then begin
               qq.Next;
               continue;
            end;
            ureg:=qq.fieldbyname('pcreg').AsString;
            ucampo:=stringreplace(qq.fieldbyname('pccampo').AsString,'''','''''',[rfreplaceall]);
            if qq.fieldbyname('pcclase').AsString='FIL' then begin
               if dm.sqlselect(dm.q1,'select longitud,occurs from tsvarcbl '+
                  ' where cprog='+g_q+qq.fieldbyname('ocprog').AsString+g_q+
                  ' and   cbib='+g_q+qq.fieldbyname('ocbib').AsString+g_q+
                  ' and   cclase='+g_q+qq.fieldbyname('occlase').AsString+g_q+
                  ' and   creg='+g_q+copy(xcampo,1,pos(',',xcampo)-1)+g_q+
                  ' and   ccampo='+g_q+copy(xcampo,1,pos(',',xcampo)-1)+g_q) then begin
                  ureg:=inttostr(dm.q1.fieldbyname('longitud').Asinteger*dm.q1.fieldbyname('occurs').Asinteger);
               end;
               if dm.sqlselect(dm.q1,'select inicial,longitud,occurs from tsvarcbl '+
                  ' where cprog='+g_q+qq.fieldbyname('ocprog').AsString+g_q+
                  ' and   cbib='+g_q+qq.fieldbyname('ocbib').AsString+g_q+
                  ' and   cclase='+g_q+qq.fieldbyname('occlase').AsString+g_q+
                  ' and   creg='+g_q+copy(xcampo,1,pos(',',xcampo)-1)+g_q+
                  ' and   ccampo='+g_q+copy(xcampo,pos(',',xcampo)+1,500)+g_q) then begin
                  ucampo:='F'+dm.q1.fieldbyname('inicial').AsString+'-'+inttostr(dm.q1.fieldbyname('longitud').Asinteger*dm.q1.fieldbyname('occurs').Asinteger);
               end;
            end;
            trae_reg(qq.fieldbyname('pcprog').AsString,
                     qq.fieldbyname('pcbib').AsString,
                     qq.fieldbyname('pcclase').AsString,
                     qq.fieldbyname('pcreg').AsString,
                     qq.fieldbyname('pccampo').AsString,niv,ini,lon);
            // if (inicio>0) and (ini>=ini_afecta) and (ini<=ini_afecta+longitud) then begin
               niv:=lon;
               ini:=ini_afecta-ini+1;
               lon:=lon-ini+1;
               if longitud<lon then
                  lon:=longitud;
               zy:=zy+1;
               zx:=zx+1;
               //marca:='-*-';
               reporta('-*-',prog,bib,clase,hcprog,hcbib,hcclase,hcreg,hccampo,
                  qq.fieldbyname('pcprog').AsString, qq.fieldbyname('pcbib').AsString,qq.fieldbyname('pcclase').AsString,
                  ureg,ucampo,qq.fieldbyname('modo').Asstring,qq.fieldbyname('linea').Asinteger,xcampo,niv,ini,lon);
               zx:=mzx;
            // end;
            qq.Next;
         end;
      end;
   end;
   if hcreg<>'_CONST_' then begin
      if dm.sqlselect(qq,'select * from tsrelavcbl '+
         ' where ocprog='+g_q+prog+g_q+
         ' and pcprog='+g_q+hcprog+g_q+
         ' and pcbib='+g_q+hcbib+g_q+
         ' and pcclase='+g_q+hcclase+g_q+
         ' and pcreg='+g_q+hcreg+g_q+
         ' and pccampo='+g_q+hccampo+g_q+
         ' and modo<>'+g_q+'DOWN'+g_q+
         ' order by linea') then begin
         while not qq.Eof do begin
            if (qq.fieldbyname('hcprog').AsString=acprog) and
               (qq.fieldbyname('hcbib').AsString=acbib) and
               (qq.fieldbyname('hcclase').AsString=acclase) and
               (qq.fieldbyname('hcreg').AsString=acreg) and
               (qq.fieldbyname('hccampo').AsString=accampo) then begin
               qq.Next;
               continue;
            end;
            trae_pic(qq.fieldbyname('hcprog').AsString,
                     qq.fieldbyname('hcbib').AsString,
                     qq.fieldbyname('hcclase').AsString,
                     qq.fieldbyname('hcreg').AsString,
                     qq.fieldbyname('hccampo').AsString,niv,ini,lon);  // siempre regresa 1 en ini
            niv:=lon;
            // si el campo al que lo mueve es más chico que lo afectado lo descarta
            if (inicio=0) or (inicio<=lon) or (qq.fieldbyname('pcclase').AsString='BMS') then begin                  // -----    XXXXX    ->  XXXXX
               if inicio>0 then begin
                  ini:=inicio;                                            //          --XXXXX  ->  --XXX
                  lon:=lon-inicio+1;                                      //          --XX---  ->  --XX-
                  if longitud<lon then
                     lon:=longitud;
               end;
               zy:=zy+1;
               zx:=zx+1;
               //marca:='-->';
               reporta('-->',prog,bib,clase,hcprog,hcbib,hcclase,hcreg,hccampo,
                  qq.fieldbyname('hcprog').AsString, qq.fieldbyname('hcbib').AsString,qq.fieldbyname('hcclase').AsString,
                  qq.fieldbyname('hcreg').AsString,
                  stringreplace(qq.fieldbyname('hccampo').AsString,'''','''''',[rfreplaceall]),
                  qq.fieldbyname('modo').Asstring,qq.fieldbyname('linea').Asinteger,xcampo,niv,ini,lon);
               zx:=mzx;
            end
            else begin
               zx:=zx;
            end;
            qq.Next;
         end;
      end;
   end;
   if hcreg<>'_CONST_' then begin
      if dm.sqlselect(qq,'select * from tsrelavcbl '+
         ' where ocprog='+g_q+prog+g_q+
         ' and hcprog='+g_q+hcprog+g_q+
         ' and hcbib='+g_q+hcbib+g_q+
         ' and hcclase='+g_q+hcclase+g_q+
         ' and hcreg='+g_q+hcreg+g_q+
         ' and hccampo='+g_q+hccampo+g_q+
         ' and modo<>'+g_q+'DOWN'+g_q+
         ' order by linea') then begin
         while not qq.Eof do begin
            if (qq.fieldbyname('pcprog').AsString=acprog) and
               (qq.fieldbyname('pcbib').AsString=acbib) and
               (qq.fieldbyname('pcclase').AsString=acclase) and
               (qq.fieldbyname('pcreg').AsString=acreg) and
               (qq.fieldbyname('pccampo').AsString=accampo) then begin
               qq.Next;
               continue;
            end;
            trae_pic(qq.fieldbyname('pcprog').AsString,
                     qq.fieldbyname('pcbib').AsString,
                     qq.fieldbyname('pcclase').AsString,
                     qq.fieldbyname('pcreg').AsString,
                     qq.fieldbyname('pccampo').AsString,niv,ini,lon);
            niv:=lon;
            // si el campo que se le mueve es más chico que lo afectado lo descarta
            if (inicio=0) or (inicio<=lon) or (qq.fieldbyname('pcclase').AsString='BMS') then begin
               ini:=inicio;                                           // -----   XXXXX  ->  XXXXX
               lon:=lon-inicio+1;                                     // -----   --XXXX ->  --XXX
               if longitud<lon then                                   // -----   --XX-  ->  --XX-
                  lon:=longitud;
               zy:=zy+1;
               zx:=zx+1;
               //marca:='<--';
               reporta('<--',prog,bib,clase,hcprog,hcbib,hcclase,hcreg,hccampo,
                  qq.fieldbyname('pcprog').AsString, qq.fieldbyname('pcbib').AsString,qq.fieldbyname('pcclase').AsString,
                  qq.fieldbyname('pcreg').AsString,
                  stringreplace(qq.fieldbyname('pccampo').AsString,'''','''''',[rfreplaceall]),
                  qq.fieldbyname('modo').Asstring,qq.fieldbyname('linea').Asinteger,xcampo,niv,ini,lon);
               zx:=mzx;
            end
            else begin
               zx:=zx;
            end;
            qq.Next;
         end;
      end;
   end;
   qq.Free;
end;
procedure Tftspropaga.dgSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var k,lin:integer;
  cad:string;
begin
   if trim(yx[arow][acol])='' then exit;
   memo.SelAttributes.Color := clgreen;
   k:=pos(']',yx[arow][acol]);
   if k=-1 then exit;
   cad:=copy(yx[arow][acol],k+2,100);
   lin:=strtoint(copy(cad,1,pos(' ',cad)-1));
   if lin=0 then exit;
   memo.SelStart := memo.Perform( EM_LINEINDEX, lin - 1, 0 );
   memo.Perform( EM_SCROLLCARET, 0, 0 );
   k := memo.Perform( EM_GETFIRSTVISIBLELINE, 0, 0 );
   k := lin - k - 30;
   memo.Perform( EM_LINESCROLL, 0, k );
   memo.SelLength := length( memo.Lines[ lin - 1 ] );
   memo.SelAttributes.Color := clblue;
end;
procedure Tftspropaga.busca_jcl(pcprog,pcbib,pcclase:string; repe:Tstringlist);
var qq:Tadoquery;
   cad:string;
begin
   cad:=pcprog+'_'+pcbib+'_'+pcclase;
   if repe.indexof(cad)>-1 then
      exit;
   repe.add(cad);
   qq:=Tadoquery.Create(self);
   qq.Connection:=dm.ADOConnection1;
   if dm.sqlselect(qq,'select distinct pcprog,pcbib,pcclase,hcprog,hcbib,hcclase,ocprog,ocbib,occlase,orden '+
      ' from tsrela '+
      ' where hcprog='+g_q+pcprog+g_q+
      ' and   hcbib='+g_q+pcbib+g_q+
      ' and   hcclase='+g_q+pcclase+g_q+
      ' and   pcclase in ('+g_q+'STE'+g_q+','+g_q+'CTC'+g_q+','+g_q+'CBL'+g_q+','+g_q+'CCT'+g_q+')'+
      ' order by 1,2,3') then begin
      while not qq.Eof do begin
         if (qq.fieldbyname('pcclase').AsString='STE') or
            (qq.fieldbyname('pcclase').AsString='CCT') then begin
            jcls.add(g_q+qq.fieldbyname('pcprog').AsString+g_q+','+
                    g_q+qq.fieldbyname('pcbib').AsString+g_q+','+
                    g_q+qq.fieldbyname('pcclase').AsString+g_q+','+
                    g_q+qq.fieldbyname('hcprog').AsString+g_q+','+
                    g_q+qq.fieldbyname('hcbib').AsString+g_q+','+
                    g_q+qq.fieldbyname('hcclase').AsString+g_q+','+
                    g_q+qq.fieldbyname('ocprog').AsString+g_q+','+
                    g_q+qq.fieldbyname('ocbib').AsString+g_q+','+
                    g_q+qq.fieldbyname('occlase').AsString+g_q);
         end
         else begin
            busca_jcl(qq.fieldbyname('pcprog').AsString,
                     qq.fieldbyname('pcbib').AsString,
                     qq.fieldbyname('pcclase').AsString,
                     repe);
         end;
         qq.Next;
      end;
   end;
   qq.Free;
end;

procedure Tftspropaga.alta_base(afectados:Tstringlist; cprog,cbib,cclase:string);
var i,j:integer;
    m,jc,repe:Tstringlist;
    acprog,acbib,acclase,acreg,accampo:string; // para control de campos
    bprog,bbib,bclase:string;                  // para control de JCL
    tsrela,campo,demas,owner,paso,logico:string;
begin
   dm.sqldelete('delete tsafecta '+
               ' where ocprog='+g_q+cprog+g_q+
               ' and   ocbib='+g_q+cbib+g_q+
               ' and   occlase='+g_q+cclase+g_q+
               ' and   acprog='+g_q+rcprog+g_q+
               ' and   acbib='+g_q+rcbib+g_q+
               ' and   acclase='+g_q+rcclase+g_q+
               ' and   acreg='+g_q+rcreg+g_q+
               ' and   accampo='+g_q+rccampo+g_q);
   if afectados.count<2 then // si trae sólo uno, es el campo que buscó afectacion
      exit;
   m:=Tstringlist.Create;
   jc:=Tstringlist.Create;
   repe:=Tstringlist.Create;
   demas:=g_q+'ASIGNA'+g_q+','+
          dm.datedb(formatdatetime('YYYYMMDD',now),'YYYYMMDD')+','+
          g_q+'COBOL'+g_q;
   owner:=g_q+cprog+g_q+','+
          g_q+cbib+g_q+','+
          g_q+cclase+g_q;
   jcls.Clear;
   busca_jcl(cprog,cbib,cclase,repe);
   if jcls.Count=0 then begin
            jcls.add(g_q+'SCRATCH'+g_q+','+
                    g_q+'SCRATCH'+g_q+','+
                    g_q+'STE'+g_q+','+
                    g_q+cprog+g_q+','+
                    g_q+cbib+g_q+','+
                    g_q+cclase+g_q+','+
                    g_q+'SCRATCH'+g_q+','+
                    g_q+'SCRATCH'+g_q+','+
                    g_q+'JOB'+g_q);
   end;
   {
   if dm.sqlselect(dm.q1,'select distinct pcprog,pcbib,pcclase,hcprog,hcbib,hcclase,orden from tsrela '+
               ' where hcprog='+g_q+cprog+g_q+
               ' and   hcbib='+g_q+cbib+g_q+
               ' and   hcclase='+g_q+cclase+g_q+
               ' order by 1,2,3') then begin
      while not dm.q1.Eof do begin
         tsrela:=g_q+dm.q1.fieldbyname('pcprog').AsString+g_q+','+
                 g_q+dm.q1.fieldbyname('pcbib').AsString+g_q+','+
                 g_q+dm.q1.fieldbyname('pcclase').AsString+g_q+','+
                 g_q+dm.q1.fieldbyname('hcprog').AsString+g_q+','+
                 g_q+dm.q1.fieldbyname('hcbib').AsString+g_q+','+
                 g_q+dm.q1.fieldbyname('hcclase').AsString+g_q;
         busca_jcl(dm.q1.fieldbyname('pcprog').AsString,
                   dm.q1.fieldbyname('pcbib').AsString,
                   dm.q1.fieldbyname('pcclase').AsString,
                   dm.q1.fieldbyname('ocprog').AsString,
                   dm.q1.fieldbyname('ocbib').AsString,
                   dm.q1.fieldbyname('occlase').AsString,
                   tsrela,'');
         dm.q1.Next;
      end;
   end;
   }
   while i<afectados.Count do begin
   //for i:=0 to afectados.Count-1 do begin
      m.CommaText:=afectados[i];
      if m[3]='_CONST_' then begin
         inc(i);
         continue;
      end;
      if (m[3]<>'_CWA_') and (commarea.IndexOf(m[4])>-1) then begin
         afectados.Add(cprog+','+cbib+','+cclase+',_CWA_,'+m[4]+',COB,WARNING');
         if dm.sqlselect(dm.q1,'select hcprog,hcbib from tsrela '+
            ' where pcprog='+g_q+cprog+g_q+
            ' and   pcbib='+g_q+cbib+g_q+
            ' and   pcclase='+g_q+cclase+g_q+
            ' and   hcclase='+g_q+'CBL'+g_q+
            ' order by hcbib,hcclase') then begin
            while not dm.q1.Eof do begin
               if dm.sqlselect(dm.q2,'select hcprog from tsrela '+
                  ' where pcprog='+g_q+dm.q1.fieldbyname('hcprog').AsString+g_q+
                  ' and   pcbib='+g_q+dm.q1.fieldbyname('hcbib').AsString+g_q+
                  ' and   pcclase='+g_q+'CBL'+g_q+
                  ' and   hcprog='+g_q+'CICS'+g_q+
                  ' and   hcclase='+g_q+'UTI'+g_q+
                  ' and   pcbib='+g_q+dm.q1.fieldbyname('hcbib').AsString+g_q) then begin
                  afectados.Add(dm.q1.fieldbyname('hcprog').AsString+','+
                                dm.q1.fieldbyname('hcbib').AsString+','+
                                'CBL,DFHCOMMAREA,DFHCOMMAREA,COB,WARNING');
               end;
               dm.q1.Next;
            end;
         end;
      end;
      logico:=m[0];  // cuando sea tipo FIL tendrá el nombre logico del archivo
      for j:=0 to jcls.count-1 do begin
         jc.CommaText:=jcls[j];
         if m[2]='FIL' then begin              // Obtiene nombre real del archivo
            if dm.sqlselect(dm.q1,'select hcprog from tsrela '+
               ' where pcprog='+jc[0]+
               ' and   pcbib='+jc[1]+
               ' and   pcclase='+jc[2]+
               ' and   hcclase='+g_q+'FIL'+g_q+
               ' and   externo='+g_q+logico+g_q) then begin
               m[0]:=dm.q1.fieldbyname('hcprog').AsString;
            end;
         end
         else begin
            logico:='';
         end;
         campo:=g_q+m[0]+g_q+','+
                g_q+m[1]+g_q+','+
                g_q+m[2]+g_q+','+
                g_q+m[3]+g_q+','+
                g_q+m[4]+g_q;
         if dm.sqlselect(dm.q1,'select * from tsmaestra '+
            ' where cprog='+g_q+m[0]+g_q+
            ' and   cbib='+g_q+m[1]+g_q+
            ' and   cclase='+g_q+m[2]+g_q+
            ' and   creg='+g_q+m[3]+g_q+
            ' and   ccampo='+g_q+m[4]+g_q)=false then begin
            dm.sqlinsert('insert into tsmaestra (CPROG,CBIB,CCLASE,CREG,CCAMPO,ESTADO,FECHA) '+
               ' values('+campo+','+
               g_q+m[6]+g_q+','+
               dm.datedb(formatdatetime('YYYYMMDD',now),'YYYYMMDD')+')');
         end;
      //for j:=0 to jcls.count-1 do begin
         dm.sqlinsert('insert into tsafecta ('+
            'CPROG,CBIB,CCLASE,CREG,CCAMPO,'+
            'PCPROG,PCBIB,PCCLASE,HCPROG,HCBIB,HCCLASE,TCPROG,TCBIB,TCCLASE,'+
            'MODO,FECHA,UTILERIA,ESTADO,'+
            'OCPROG,OCBIB,OCCLASE,logico,'+
            'acprog,acbib,acclase,acreg,accampo) values('+
            campo+','+
            jcls[j]+','+
            demas+','+
            g_q+m[6]+g_q
            +','+
            owner+','+
            g_q+logico+g_q+','+
            g_q+rcprog+g_q+','+
            g_q+rcbib+g_q+','+
            g_q+rcclase+g_q+','+
            g_q+rcreg+g_q+','+
            g_q+rccampo+g_q+')');
      end;
      inc(i);
   end;
   m.Free;
   jc.Free;
   repe.Free;
   dm.sqldelete('delete tsmaestra '+
         ' where (cprog,cbib,cclase,creg,ccampo)  not in '+
         '       (select distinct cprog,cbib,cclase,creg,ccampo from tsafecta)');
end;
procedure Tftspropaga.busca_coboles(cprog:string; cbib:string; cclase:string);
var qq:Tadoquery;
begin
   memo.Lines.Add(cprog+'-'+cbib+'-'+cclase);
   if cclase='CBL' then
      lst.Items.Add(cbib+','+cprog);
   if (cclase<>'CBL') and (cclase<>'STE') and (cclase<>'CTC') and (cclase<>'JCL') and (cclase<>'JOB') and (cclase<>'CCT') then
      exit;
   qq:=Tadoquery.Create(self);
   qq.Connection:=dm.ADOConnection1;
   if dm.sqlselect(qq,'select distinct hcprog,hcbib,hcclase '+
      ' from tsrela '+
      ' where pcprog='+g_q+cprog+g_q+
      ' and   pcbib='+g_q+cbib+g_q+
      ' and   pcclase='+g_q+cclase+g_q+
      ' order by 1,2,3') then begin
      while not qq.Eof do begin
         busca_coboles(qq.fieldbyname('hcprog').AsString,
                       qq.fieldbyname('hcbib').AsString,
                       qq.fieldbyname('hcclase').AsString);
         qq.Next;
      end;
   end;
   qq.Free;
end;
procedure Tftspropaga.expande(cblbib,cblprog:string);    //FALTA SISTEMA JCR
Var
   lwClase : String;
begin
   arch.Clear;
   tex.clear;
   cam.clear;
   dg.ColCount:=1;
   dg.RowCount:=1;
   setlength(yx,1);
   setlength(yx[0],1);
   yx[0][0]:='--';
   zx:=0;
   zy:=0;
   label5.Caption:=cblbib+' - '+cblprog;

   lwClase := '';
   if dm.sqlselect( dm.q5, 'select cclase from tsprog ' +
      ' where cprog=' + g_q + cblprog + g_q +
      ' and   cbib=' + g_q + cblbib + g_q + ' group by cclase') then
      lwClase := dm.q5.fieldbyname( 'cclase' ).AsString;

   dm.trae_fuente( ' ', cblprog,cblbib,lwClase, memo );
   memo.PlainText:=true;
   // RGM para acelerar el proceso      trae_copys(copylib,memo.Lines);
   deletefile(g_tmpdir+'\mintras.txt');
   deletefile (g_tmpdir+'\mintras2.txt');
   memo.Lines.SaveToFile(g_tmpdir+'\mintras.txt');
   if b_trae_utilerias then begin
      dm.get_utileria( 'INSERTA_COPY', g_tmpdir + '\inserta_copy.dir' );
      dm.get_utileria( 'RGMLANG', g_tmpdir + '\htainserta_copy.exe' );
      b_trae_utilerias:=false;
   end;
   // RGM para acelerar el proceso      SetEnvironmentVariable( pchar( 'COPYLIB' ), pchar( g_tmpdir ));
   SetEnvironmentVariable( pchar( 'COPYLIB' ), pchar( dm.pathbib(cmbcopylib.Text, cmbclase.Text) ));
   dm.ejecuta_espera(g_tmpdir+'\htainserta_copy.exe '+g_tmpdir+'\mintras.txt '+
      g_tmpdir+'\mintras2.txt '+g_tmpdir+'\inserta_copy.dir >'+
      g_tmpdir+'\inserta_copy.res',SW_HIDE);
   memo.Lines.Clear;
   memo.Lines.LoadFromFile(g_tmpdir+'\mintras2.txt');
   commarea.LoadFromFile(g_tmpdir+'\CWACOMM_mintras.txt');
end;
procedure Tftspropaga.procesa_tab(cblbib,cblprog:string);
var i,j:integer;
    tempo:string;
    nivel,inicio,longitud:integer;
begin
   tempo:='-*-';
   {
   b_online:=dm.sqlselect(dm.q3,'select hcprog from tsrela '+
      ' where pcprog='+g_q+cblprog+g_q+
      ' and   pcbib='+g_q+cblbib+g_q+
      ' and   pcclase='+g_q+'CBL'+g_q+
      ' and   hcprog='+g_q+'CICS'+g_q+
      ' and   hcbib='+g_q+'SYSTEM'+g_q+
      ' and   hcclase='+g_q+'UTI'+g_q);
   }
   b_online:=true;
   adotsmaestra.First;
   while not adotsmaestra.Eof do begin
      rcclase:=adotsmaestra.fieldbyname('CLASE').AsString;
      rcbib:=adotsmaestra.fieldbyname('BIB').AsString;
      rcprog:=adotsmaestra.fieldbyname('COMPO').AsString;
      rcreg:=adotsmaestra.fieldbyname('REGISTRO').AsString;
      rccampo:=adotsmaestra.fieldbyname('CAMPO').AsString;
      trae_pic(rcprog,rcbib,rcclase,rcreg,rccampo,nivel,inicio,longitud);
      zx:=0;
      afectados.Clear;
      reporta(tempo,cblprog,cblbib,'CBL',
         rcprog,rcbib,rcclase,rcreg,rccampo,
         rcprog,rcbib,rcclase,rcreg,rccampo,
         ' ',0,'',
         nivel,inicio,longitud);
      afectados.Sort;
      //afectados.SaveToFile(g_tmpdir+'\afectados.csv');
      alta_base(afectados,cblprog,cblbib,'CBL');
      adotsmaestra.Next;
   end;
   //ShellExecute( 0, 'open', pchar( g_tmpdir+'\mintras2.txt' ), nil, PChar( g_tmpdir ), SW_SHOW );
end;

procedure Tftspropaga.bunicoClick(Sender: TObject);
var pp:string;
begin
   if (lst.ItemIndex=-1) or (adotsmaestra.RecordCount=0) then exit;
   pp:=lst.Items[lst.itemindex];
   expande(cmbbib.Text,pp);
   if rgclase.Items[rgclase.ItemIndex]='TAB' then begin
      procesa_tab(cmbbib.text,pp);
   end;
   ado2.Connection:=dm.ADOConnection1;
   ado2.Close;
   ado2.SQL.Clear;
   ado2.SQL.Add('select cclase,cprog,creg REGISTRO,ccampo CAMPO,estado from tsmaestra '+
      ' where cprog='+g_q+lst.Items[lst.itemindex]+g_q+
      '   and cbib='+g_q+cmbbib.Text+g_q+
      '   and cclase='+g_q+'CBL'+g_q+
      ' order by 1,2,3,4');
   ado2.Open;
   dbg2.columns[0].Width:=30;
   dbg2.columns[1].Width:=50;
   dbg2.columns[2].Width:=100;
   dbg2.columns[3].Width:=100;
   dbg2.columns[4].Width:=80;

end;

procedure Tftspropaga.bvariosClick(Sender: TObject);
var i:integer;
   pp:string;
begin
   if (lst.ItemIndex=-1) or (adotsmaestra.RecordCount=0) then exit;
   for i:=lst.ItemIndex to lst.Count-1 do begin
      lst.ItemIndex:=i;
      pp:=lst.Items[lst.itemindex];
      expande(cmbbib.Text,pp);
      if rgclase.Items[rgclase.ItemIndex]='TAB' then begin
         procesa_tab(cmbbib.text,pp);
      end;
   end;
end;
procedure Tftspropaga.paso1(cprog,cbib,cclase:string);
var qq:Tadoquery;
begin
   qq:=Tadoquery.Create(self);
   qq.Connection:=dm.ADOConnection1;
   if dm.sqlselect(qq,'select * from tsrela '+
      ' where hcclase='+g_q+cclase+g_q+
      ' and hcbib='+g_q+cbib+g_q+
      ' and hcprog = '+g_q+cprog+g_q+
      ' and pcclase = '+g_q+'STE'+g_q+
      ' and externo is not NULL' )then begin
      while not qq.Eof do begin
         externo:=qq.fieldbyname('externo').AsString;
         paso2(qq.FieldByName('pcprog').AsString,
               qq.FieldByName('pcbib').AsString,
               qq.FieldByName('pcclase').AsString);
         paso3(qq.FieldByName('pcprog').AsString,
               qq.FieldByName('pcbib').AsString,
               qq.FieldByName('pcclase').AsString);
         qq.Next;
      end;
   end;
   qq.Free;
end;
procedure Tftspropaga.paso2(cprog,cbib,cclase:string);
var qq:Tadoquery;
begin
   qq:=Tadoquery.Create(self);
   qq.Connection:=dm.ADOConnection1;
   if dm.sqlselect(qq,'select * from tsrela '+
      ' where pcprog='+g_q+cprog+g_q+
      ' and pcbib='+g_q+cbib+g_q+
      ' and pcclase='+g_q+cclase+g_q+
      ' and hcclase='+g_q+'CTC'+g_q) then begin
      while not qq.Eof do begin
         paso3(qq.FieldByName('hcprog').AsString,
               qq.FieldByName('hcbib').AsString,
               qq.FieldByName('hcclase').AsString);
         qq.Next;
      end;
   end;
   qq.Free;
end;

procedure Tftspropaga.paso3(cprog,cbib,cclase:string);
begin
   if dm.sqlselect(dm.q1,'select * from tsrela '+
      ' where pcprog='+g_q+cprog+g_q+
      ' and pcbib='+g_q+cbib+g_q+
      ' and pcclase='+g_q+cclase+g_q+
      ' and hcprog='+g_q+fil_prog+g_q+
      ' and hcbib='+g_q+fil_bib+g_q+
      ' and hcclase='+g_q+'CBL'+g_q) then begin
      fil_logico:=externo;
      lee_fd(fil_logico,'DISK','FIL',fil_logico,fil_logico);
   end;
end;
procedure Tftspropaga.lee_fd(cprog,cbib,cclase,creg,ccampo:string);
begin
   if dm.sqlselect(dm.q1,'select * from tsrelavcbl '+
      ' where pcprog='+g_q+cprog+g_q+
      ' and pcbib='+g_q+cbib+g_q+
      ' and pcclase='+g_q+cclase+g_q+
      ' and pcreg='+g_q+creg+g_q+
      ' and pccampo='+g_q+ccampo+g_q+
      ' and hcreg='+g_q+'FILE'+g_q) then begin
      lee_registro(dm.q1.FieldByName('hcprog').AsString,
                   dm.q1.FieldByName('hcbib').AsString,
                   dm.q1.FieldByName('hcclase').AsString,
                   dm.q1.FieldByName('hcreg').AsString,
                   dm.q1.FieldByName('hccampo').AsString);
   end;
end;
procedure Tftspropaga.lee_registro(cprog,cbib,cclase,creg,ccampo:string);
begin
   if dm.sqlselect(dm.q1,'select * from tsrelavcbl '+
      ' where pcprog='+g_q+cprog+g_q+
      ' and pcbib='+g_q+cbib+g_q+
      ' and pcclase='+g_q+cclase+g_q+
      ' and pcreg='+g_q+creg+g_q+
      ' and pccampo='+g_q+ccampo+g_q) then begin
      lee_campo(dm.q1.FieldByName('hcprog').AsString,
                dm.q1.FieldByName('hcbib').AsString,
                dm.q1.FieldByName('hcclase').AsString,
                dm.q1.FieldByName('hcreg').AsString,
                dm.q1.FieldByName('hccampo').AsString);
   end;
end;
procedure Tftspropaga.lee_campo(cprog,cbib,cclase,creg,ccampo:string);
begin
   if dm.sqlselect(dm.q1,'select * from tsvarcbl '+
      ' where cprog='+g_q+cprog+g_q+
      ' and cbib='+g_q+cbib+g_q+
      ' and cclase='+g_q+cclase+g_q+
      ' and creg='+g_q+creg+g_q+
      ' and inicial='+g_q+inttostr(fil_inicio)+g_q) then begin
      while not dm.q1.Eof do begin
         fil_reg:=creg;
         fil_campo:=dm.q1.fieldbyname('ccampo').asstring;
         if dm.q1.fieldbyname('creg').asstring<>dm.q1.fieldbyname('ccampo').asstring then
            exit;
         dm.q1.Next;
      end;
   end;
end;

procedure Tftspropaga.cmbbibChange(Sender: TObject);
var lista:Tstringlist;
begin
   lista:=Tstringlist.Create;
   lst.Clear;
   adotsmaestra.First;
   while not adotsmaestra.Eof do begin
      if dm.sqlselect(dm.q1,'select distinct hcprog dato'+
         ' from tsrelavcbl '+
         ' where pcprog='+g_q+adotsmaestra.fieldbyname('COMPO').AsString+g_q+
         ' and   pcbib='+g_q+adotsmaestra.fieldbyname('BIB').AsString+g_q+
         ' and   pcclase='+g_q+adotsmaestra.fieldbyname('CLASE').AsString+g_q+
         ' and   pcreg='+g_q+adotsmaestra.fieldbyname('REGISTRO').AsString+g_q+
         ' and   pccampo='+g_q+adotsmaestra.fieldbyname('CAMPO').AsString+g_q+
         ' and   hcclase='+g_q+'CBL'+g_q+
         ' and   hcbib='+g_q+cmbbib.text+g_q+
         ' order by 1') then begin
         while not dm.q1.Eof do begin
            if lista.IndexOf(dm.q1.fieldbyname('dato').AsString)=-1 then
               lista.Add(dm.q1.fieldbyname('dato').AsString);
            dm.q1.Next;
         end;
      end;
      if dm.sqlselect(dm.q1,'select distinct pcprog dato'+
         ' from tsrelavcbl '+
         ' where hcprog='+g_q+adotsmaestra.fieldbyname('COMPO').AsString+g_q+
         ' and   hcbib='+g_q+adotsmaestra.fieldbyname('BIB').AsString+g_q+
         ' and   hcclase='+g_q+adotsmaestra.fieldbyname('CLASE').AsString+g_q+
         ' and   hcreg='+g_q+adotsmaestra.fieldbyname('REGISTRO').AsString+g_q+
         ' and   hccampo='+g_q+adotsmaestra.fieldbyname('CAMPO').AsString+g_q+
         ' and   pcclase='+g_q+'CBL'+g_q+
         ' and   pcbib='+g_q+cmbbib.text+g_q+
         ' order by 1') then begin
         while not dm.q1.Eof do begin
            if lista.IndexOf(dm.q1.fieldbyname('dato').AsString)=-1 then
               lista.Add(dm.q1.fieldbyname('dato').AsString);
            dm.q1.Next;
         end;
      end;
      adotsmaestra.Next;
   end;
   lblregistros.Caption:=inttostr(lst.Items.Count)+' Registros';
   lista.Sort;
   lst.Items.AddStrings(lista);
   lista.Free;
end;

procedure Tftspropaga.Button1Click(Sender: TObject);
var ejebat:string;
begin
   ejebat:='fte'+formatdatetime('YYYYMMDDHHnnss',now)+'.txt';
   memo.Lines.SaveToFile(ejebat);
   ShellExecute(0,'open',PChar(ejebat),'','',SW_SHOW);
end;

procedure Tftspropaga.btodoClick(Sender: TObject);    // procesa todas las bibliotecas
var i:integer;     
begin
   cmbbib.ItemIndex:=-1;
   for i:=0 to cmbbib.Items.Count-1 do begin
      cmbbib.ItemIndex:=i;
      cmbbibchange(sender);
      if lst.Items.Count>0 then begin
         lst.Itemindex:=0;
         bvariosclick(sender);
      end;
   end;

end;

end.
