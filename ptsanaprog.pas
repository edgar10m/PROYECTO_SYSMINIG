unit ptsanaprog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, StdCtrls, Buttons, Grids, DBGrids, ExtCtrls, ComCtrls,
  Menus, shellapi;

type
  Tftsanaprog = class(TForm)
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
    bdir: TBitBtn;
    txtmascara: TEdit;
    cmbsistema: TComboBox;
    cmbclase: TComboBox;
    cmbbib: TComboBox;
    barchivo: TBitBtn;
    bcompara: TBitBtn;
    GroupBox4: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    fuente: TMemo;
    mresultado: TMemo;
    Splitter3: TSplitter;
    ttsprog: TADOQuery;
    DataSource1: TDataSource;
    cmbcopylib: TComboBox;
    Label7: TLabel;
    butileria: TBitBtn;
    Memo1: TMemo;
    Splitter4: TSplitter;
    pop: TPopupMenu;
    Fuente1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure cmbsistemaChange(Sender: TObject);
    procedure cmbclaseChange(Sender: TObject);
    procedure cmbbibChange(Sender: TObject);
    procedure bdirClick(Sender: TObject);
    procedure barchivoClick(Sender: TObject);
    procedure butileriaClick(Sender: TObject);
    procedure Fuente1Click(Sender: TObject);
    procedure fuenteMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure bcomparaClick(Sender: TObject);
  private
    { Private declarations }
    mm:Tstringlist;
    g_modomsj:word;
   fmensaje:textfile;
   b_noprocesa:boolean;
      procedure procesa_mapas( tipo: string; bib: string; nombre: string );
      function fnpicture(x,display:string):integer;
      procedure analiza_cbl( sistema: string; tipo: string; bib: string; nombre: string );
      procedure analiza_bms( sistema: string; tipo: string; bib: string; nombre: string );
      procedure trae_utilerias( tipo: string );
      procedure smensaje(mensaje:string);
  public
    { Public declarations }
  end;

var
  ftsanaprog: Tftsanaprog;

procedure PR_ANAPROG;

implementation
uses ptsdm,ptspropaga, ptsutileria;

{$R *.DFM}

procedure PR_ANAPROG;
begin
   Application.CreateForm( Tftsanaprog, ftsanaprog );
   try
      ftsanaprog.Showmodal;
   finally
      ftsanaprog.Free;
   end;
end;

procedure Tftsanaprog.FormCreate(Sender: TObject);
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
   mm:=Tstringlist.Create;
end;

procedure Tftsanaprog.smensaje(mensaje:string);
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

procedure Tftsanaprog.cmbsistemaChange(Sender: TObject);
begin
   dm.feed_combo( cmbclase, 'select distinct cclase from tsprog ' +
      ' where sistema=' + g_q + cmbsistema.text + g_q +
      ' order by cclase' );
   cmbbib.clear;
   barchivo.enabled := false;
   bdir.enabled := false;
   ttsprog.Close;
end;

procedure Tftsanaprog.cmbclaseChange(Sender: TObject);
var
   lista: Tstringlist;
   bib: string;
begin
   dm.feed_combo( cmbbib, 'select distinct cbib from tsprog ' +
      ' where sistema=' + g_q + cmbsistema.text + g_q +
      ' and   cclase=' + g_q + cmbclase.text + g_q +
      ' order by cbib' );
   barchivo.enabled := false;
   bdir.enabled := false;
   ttsprog.Close;
end;

procedure Tftsanaprog.cmbbibChange(Sender: TObject);
begin
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
      bdir.Enabled := false;
      bcompara.Enabled := false;
   end
   else
      ttsprog.First;
   bdir.Enabled := ( ( cmbclase.Text <> '' ) and
      ( trim( cmbsistema.text ) <> '' ) and
      ( trim( cmbbib.text ) <> '' ) );
   barchivo.Enabled := ( ( dbg.SelectedField <> nil ) and
      ( cmbclase.Text <> '' ) and
      ( trim( cmbsistema.text ) <> '' ) and
      ( trim( cmbbib.text ) <> '' ) );
   bcompara.Enabled := barchivo.Enabled;

end;

procedure Tftsanaprog.bdirClick(Sender: TObject);
begin
   screen.Cursor := crsqlwait;
   trae_utilerias( cmbclase.Text );
   b_noprocesa:=true;
   //Ttsprog.First;
   while not ttsprog.Eof do begin
      barchivoclick(sender);
      ttsprog.next;
   end;
   b_noprocesa:=false;
   screen.Cursor := crdefault;
end;

procedure Tftsanaprog.barchivoClick(Sender: TObject);
begin
   trae_utilerias( cmbclase.Text );
   if cmbclase.Text = 'CBL' then
      analiza_cbl( cmbsistema.Text, cmbclase.text, cmbbib.Text, ttsprog.fieldbyname( 'componente' ).AsString )
   else
   if cmbclase.Text = 'BMS' then
      analiza_bms( cmbsistema.Text, cmbclase.text, cmbbib.Text, ttsprog.fieldbyname( 'componente' ).AsString )
   else begin
      application.MessageBox( 'Tipo de componente no implementado', 'ERROR', MB_OK );
      exit;
   end;
end;
function  Tftsanaprog.fnpicture(x,display:string):integer;
var i,m,lon:integer;
   b_par:boolean;
begin
   lon:=0;
   b_par:=false;
   for i:=1 to length(x) do begin
      if x[i]='(' then begin
         b_par:=true;
         m:=0;
         continue;
      end;
      if b_par then begin
         if x[i]=')' then begin
            lon:=lon-1+m;
            b_par:=false;
            continue;
         end;
         m:=m*10+ord(x[i])-48;
         continue;
      end;
      if (i=1) and (x[i]='S') then
         continue;
      if x[i]='V' then
         continue;
      lon:=lon+1;
   end;
   if (display='COMP-1') or (display='COMPUTATIONAL-1') then
      lon:=4
   else
   if (display='COMP-2') or (display='COMPUTATIONAL-2') then
      lon:=8
   else
   if (display='COMP-3') or (display='COMPUTATIONAL-3') then  begin
      if copy(x,1,1)='S' then
         lon:=(lon+2) div 2
      else
         lon:=(lon+1) div 2;
   end
   else
   if (copy(display,1,4)='COMP') or (display='BINARY') then begin
      if lon>9 then
         lon:=8
      else
      if lon>4 then
         lon:=4
      else
         lon:=2;
   end;
   fnpicture:=lon;
end;
procedure Tftsanaprog.analiza_bms( sistema: string; tipo: string; bib: string; nombre: string );
var archivo,texto:string;
   i:integer;
begin
   SetCurrentDir( g_tmpdir );
   dm.trae_fuente( sistema, nombre, bib, tipo, fuente );
   archivo:=g_tmpdir+'\'+nombre;
   fuente.Lines.SaveToFile(archivo);
   dm.ejecuta_espera(g_tmpdir+'\htaanaliza.exe '+archivo+' '+
      g_tmpdir+'\mintras3.txt '+g_tmpdir+'\process.dir '+g_tmpdir+'\reserved >'+
      g_tmpdir+'\tsrelavcbl.data',SW_HIDE);
   deletefile(archivo);
   memo1.Lines.LoadFromFile(g_tmpdir+'\tsrelavcbl.data');
   dm.sqldelete('delete tsrelavcbl where ocprog='+g_q+nombre+g_q+
      ' and ocbib='+g_q+bib+g_q+
      ' and occlase='+g_q+tipo+g_q);
   for i:=0 to memo1.Lines.Count-1 do begin
      if trim(memo1.Lines[i])='' then
         continue;
      texto :=  stringreplace( memo1.Lines[i], '$SISTEMA$', cmbsistema.Text, [ rfreplaceall ] );
      texto := stringreplace( texto, '$CLASE$', cmbclase.Text, [ rfreplaceall ] );
      texto := stringreplace( texto, '$BIBLIOTECA$', cmbbib.Text, [ rfreplaceall ] );
      mm.Delimiter:=',';
      mm.DelimitedText:=stringreplace(texto,'''','''''',[rfreplaceall]);
      if mm.Count<>16 then begin
         smensaje(tipo+'-'+bib+'-'+nombre+' resultado inconsistente:'+memo1.Lines[i]);
         continue;
      end;
      if dm.sqlinsert('insert into tsrelavcbl (PCCLASE,PCBIB,PCPROG,PCREG,PCCAMPO,'+
                                              'HCCLASE,HCBIB,HCPROG,HCREG,HCCAMPO,'+
                                              'MODO,LINEA,TEXTO,'+
                                              'OCCLASE,OCBIB,OCPROG)'+
                                       'values('+g_q+mm[0]+g_q+','+
                                                 g_q+mm[1]+g_q+','+
                                                 g_q+mm[2]+g_q+','+
                                                 g_q+mm[3]+g_q+','+
                                                 g_q+mm[4]+g_q+','+
                                                 g_q+mm[5]+g_q+','+
                                                 g_q+mm[6]+g_q+','+
                                                 g_q+mm[7]+g_q+','+
                                                 g_q+mm[8]+g_q+','+
                                                 g_q+mm[9]+g_q+','+
                                                 g_q+mm[10]+g_q+','+
                                                     mm[11]+','+
                                                 g_q+mm[12]+g_q+','+
                                                 g_q+mm[13]+g_q+','+
                                                 g_q+mm[14]+g_q+','+
                                                 g_q+mm[15]+g_q+')')=false then begin
         smensaje('insert into tsrelavcbl (PCCLASE,PCBIB,PCPROG,PCREG,PCCAMPO,'+
                                              'HCCLASE,HCBIB,HCPROG,HCREG,HCCAMPO,'+
                                              'MODO,LINEA,TEXTO,'+
                                              'OCCLASE,OCBIB,OCPROG)'+
                                       'values('+g_q+mm[0]+g_q+','+
                                                 g_q+mm[1]+g_q+','+
                                                 g_q+mm[2]+g_q+','+
                                                 g_q+mm[3]+g_q+','+
                                                 g_q+mm[4]+g_q+','+
                                                 g_q+mm[5]+g_q+','+
                                                 g_q+mm[6]+g_q+','+
                                                 g_q+mm[7]+g_q+','+
                                                 g_q+mm[8]+g_q+','+
                                                 g_q+mm[9]+g_q+','+
                                                 g_q+mm[10]+g_q+','+
                                                     mm[11]+','+
                                                 g_q+mm[12]+g_q+','+
                                                 g_q+mm[13]+g_q+','+
                                                 g_q+mm[14]+g_q+','+
                                                 g_q+mm[15]+g_q+')');
      end;
   end;
   mresultado.Lines.LoadFromFile(g_tmpdir+'\tsvarcbl.data');
   dm.sqldelete('delete tsvarcbl where cprog='+g_q+nombre+g_q+
      ' and cbib='+g_q+bib+g_q+
      ' and cclase='+g_q+tipo+g_q);
   for i:=0 to mresultado.Lines.Count-1 do begin
      texto :=  stringreplace( mresultado.Lines[i], '$SISTEMA$', cmbsistema.Text, [ rfreplaceall ] );
      texto := stringreplace( texto, '$CLASE$', cmbclase.Text, [ rfreplaceall ] );
      texto := stringreplace( texto, '$BIBLIOTECA$', cmbbib.Text, [ rfreplaceall ] );
      mm.CommaText:=stringreplace(texto,'''','''''',[rfreplaceall]);
      if trim(mresultado.Lines[i])='' then
         continue;
      if mm.Count<>13 then begin
         smensaje(tipo+'-'+bib+'-'+nombre+' resultado inconsistente2:'+mresultado.Lines[i]);
         continue;
      end;
      if dm.sqlselect(dm.q1,'select * from tsvarcbl '+
                    ' where cprog='+g_q+mm[2]+g_q+
                    ' and   cbib='+g_q+mm[1]+g_q+
                    ' and   cclase='+g_q+mm[0]+g_q+
                    ' and   creg='+g_q+mm[3]+g_q+
                    ' and   ccampo='+g_q+mm[4]+g_q)=false then begin
         dm.sqlinsert('insert into tsvarcbl   (cclase,cbib,cprog,creg,ccampo,nivel,picture,usage,value,linea,longitud,inicial,occurs,texto)'+
                                      ' values('+g_q+mm[0]+g_q+','+
                                                 g_q+mm[1]+g_q+','+
                                                 g_q+mm[2]+g_q+','+
                                                 g_q+mm[3]+g_q+','+
                                                 g_q+mm[4]+g_q+','+
                                                 g_q+mm[5]+g_q+','+
                                                 g_q+mm[6]+g_q+','+
                                                 g_q+mm[7]+g_q+','+
                                                 g_q+mm[8]+g_q+','+
                                                     mm[9]+','+
                                                 mm[10]+','+
                                                 mm[11]+','+
                                                 '1,'+
                                                 g_q+mm[12]+g_q+')');
      end;
   end;
end;

procedure Tftsanaprog.procesa_mapas( tipo: string; bib: string; nombre: string );
var mapa,campo:string;
   consec,occurs,i:integer;
begin
   if dm.sqlselect(dm.q1,'select * from tsrela '+
      ' where pcprog='+g_q+nombre+g_q+
      ' and   pcbib='+g_q+bib+g_q+
      ' and   pcclase='+g_q+tipo+g_q+
      ' and   hcclase='+g_q+'BMS'+g_q) then begin
      while not dm.q1.Eof do begin
         mapa:=dm.q1.fieldbyname('hcprog').AsString;
         consec:=1001;
         occurs:=1;
         if dm.sqlselect(dm.q2,'select * from tsvarcbl '+
            ' where cprog='+g_q+nombre+g_q+
            ' and   cbib='+g_q+bib+g_q+
            ' and   cclase='+g_q+tipo+g_q+
            ' and   creg='+g_q+mapa+'I'+g_q+
            ' order by linea') then begin
            while not dm.q2.Eof do begin
               if dm.q2.FieldByName('occurs').AsInteger>1 then
                  occurs:=dm.q2.FieldByName('occurs').AsInteger;
               if (dm.q2.FieldByName('nivel').AsInteger>1) and
                  (copy(dm.q2.FieldByName('usage').AsString,1,4)='COMP') then begin
                  if dm.sqlselect(dm.q3,'select * from tsvarcbl '+
                     ' where cprog='+g_q+dm.q2.fieldbyname('cprog').AsString+g_q+
                     ' and   cbib='+g_q+dm.q2.fieldbyname('cbib').AsString+g_q+
                     ' and   cclase='+g_q+dm.q2.fieldbyname('cclase').AsString+g_q+
                     ' and   creg like '+g_q+mapa+'%'+g_q+
                     ' and   inicial='+inttostr(dm.q2.fieldbyname('inicial').asinteger+3)) then begin
                     while not dm.q3.Eof do begin
                        for i:=0 to occurs-1 do begin
                           dm.sqlinsert('insert into tsrelavcbl '+
                              '(pcprog,pcbib,pcclase,pcreg,pccampo,'+
                              ' hcprog,hcbib,hcclase,hcreg,hccampo,'+
                              ' ocprog,ocbib,occlase,'+
                              ' linea,modo,texto) '+
                              ' values ('+
                              g_q+mapa+g_q+','+
                              g_q+dm.q1.fieldbyname('hcbib').AsString+g_q+','+
                              g_q+dm.q1.fieldbyname('hcclase').AsString+g_q+','+
                              g_q+mapa+g_q+','+
                              g_q+'CAMPO_'+inttostr(consec+i)+g_q+','+
                              g_q+dm.q3.fieldbyname('cprog').AsString+g_q+','+
                              g_q+dm.q3.fieldbyname('cbib').AsString+g_q+','+
                              g_q+dm.q3.fieldbyname('cclase').AsString+g_q+','+
                              g_q+dm.q3.fieldbyname('creg').AsString+g_q+','+
                              g_q+dm.q3.fieldbyname('ccampo').AsString+g_q+','+
                              g_q+dm.q3.fieldbyname('cprog').AsString+g_q+','+
                              g_q+dm.q3.fieldbyname('cbib').AsString+g_q+','+
                              g_q+dm.q3.fieldbyname('cclase').AsString+g_q+','+
                              g_q+dm.q3.fieldbyname('linea').AsString+g_q+','+
                              g_q+'MOVE'+g_q+','+
                              g_q+dm.q3.fieldbyname('texto').AsString+g_q+')');
                           end;
                        dm.q3.Next;
                     end;
                  end;
                  consec:=consec+occurs;
                  occurs:=1;
               end;
               dm.q2.Next;
            end;
         end;
         dm.q1.Next;
      end;
   end;
{
                 campo:=dm.q2.fieldbyname('ccampo').AsString;
                  campo:=copy(campo,1,length(campo)-1);
                  dm.sqlinsert('insert into tsrelavcbl '+
                     '(pcprog,pcbib,pcclase,pcreg,pccampo,'+
                     ' hcprog,hcbib,hcclase,hcreg,hccampo,'+
                     ' ocprog,ocbib,occlase,'+
                     ' linea,modo,texto) '+
                     '(select '+
                     g_q+mapa+g_q+','+
                     g_q+dm.q1.fieldbyname('hcbib').AsString+g_q+','+
                     g_q+dm.q1.fieldbyname('hcclase').AsString+g_q+','+
                     g_q+mapa+g_q+','+
                     g_q+'CAMPO_'+inttostr(consec)+g_q+','+
                     ' cprog,cbib,cclase,creg,ccampo,'+
                     ' cprog,cbib,cclase,'+
                     'linea,'+g_q+'MOVE'+g_q+',texto '+
                     ' from tsvarcbl '+
                     ' where cprog='+g_q+nombre+g_q+
                     ' and   cbib='+g_q+bib+g_q+
                     ' and   cclase='+g_q+tipo+g_q+
                     ' and   creg='+g_q+mapa+'I'+g_q+
                     ' and   ccampo='+g_q+campo+'I'+g_q+')');
                  dm.sqlinsert('insert into tsrelavcbl '+
                     '(pcprog,pcbib,pcclase,pcreg,pccampo,'+
                     ' hcprog,hcbib,hcclase,hcreg,hccampo,'+
                     ' ocprog,ocbib,occlase,'+
                     ' linea,modo,texto) '+
                     '(select cprog,cbib,cclase,creg,ccampo,'+
                     g_q+mapa+g_q+','+
                     g_q+dm.q1.fieldbyname('hcbib').AsString+g_q+','+
                     g_q+dm.q1.fieldbyname('hcclase').AsString+g_q+','+
                     g_q+mapa+g_q+','+
                     g_q+'CAMPO_'+inttostr(consec)+g_q+','+
                     ' cprog,cbib,cclase,'+
                     'linea,'+g_q+'MOVE'+g_q+',texto '+
                     ' from tsvarcbl '+
                     ' where cprog='+g_q+nombre+g_q+
                     ' and   cbib='+g_q+bib+g_q+
                     ' and   cclase='+g_q+tipo+g_q+
                     ' and   creg='+g_q+mapa+'O'+g_q+
                     ' and   ccampo='+g_q+campo+'O'+g_q+')');
                  inc(consec);
               end;
               dm.q2.Next;
            end;
         end;
         dm.q1.Next;
      end;
   end;
}
end;
procedure Tftsanaprog.analiza_cbl( sistema: string; tipo: string; bib: string; nombre: string );
type  Tnn=record
   ini:integer;
   lon:integer;
   nivel:integer;
   occurs:integer;
   upd:string;
   end;
   Tff=record
   registro:string;
   longitud:string;
   end;
var i,j,k:integer;
   longi,ini,pic,nivel:integer;
   nn:array of Tnn;
   nfile:array of Tff;
   texto:string;
procedure corte;
begin
         k:=length(nn)-1;
         while k>-1 do begin
            if (strtoint(mm[5])<=nn[k].nivel) or
               (strtoint(mm[5])=77) then begin
               nn[k].lon:=ini-nn[k].ini;
               dm.sqlupdate('update tsvarcbl set longitud='+inttostr(nn[k].lon)+nn[k].upd);
               ini:=ini - nn[k].lon + (nn[k].lon * nn[k].occurs);
               setlength(nn,k);
               k:=length(nn)-1;
            end
            else begin
               break;
            end;
         end;
end;
begin
   SetCurrentDir( g_tmpdir );

   dm.trae_fuente( sistema, nombre, bib, tipo, fuente );
   {
   if trim(cmbcopylib.Text)<>'' then begin
      ftspropaga.trae_copys(cmbcopylib.Text,fuente.Lines);
   }
   fuente.Lines.SaveToFile(g_tmpdir+'\mintras.txt');
//   dm.get_utileria( 'INSERTA_COPY', g_tmpdir + '\inserta_copy.dir' );
//   SetEnvironmentVariable( pchar( 'COPYLIB' ), pchar( g_tmpdir ));

   SetEnvironmentVariable( pchar( 'COPYLIB' ), pchar( dm.pathbib('COPYLIB','CPY' )));
   SetEnvironmentVariable( pchar( 'ZTIPO' ), pchar( cmbclase.text ));
   SetEnvironmentVariable( pchar( 'ZBIBLIOTECAZ' ), pchar( cmbbib.text+'\'+cmbclase.text ));
   dm.ejecuta_espera(g_tmpdir+'\htaanaliza.exe '+g_tmpdir+'\mintras.txt '+
      g_tmpdir+'\'+nombre+' '+g_tmpdir+'\inserta_copy.dir >'+
      g_tmpdir+'\inserta_copy.res',SW_HIDE);
   //SetEnvironmentVariable( pchar( 'COPYLIB' ), pchar( cmbcopylib.Text ));
   dm.ejecuta_espera(g_tmpdir+'\htaanaliza.exe '+g_tmpdir+'\'+nombre+' '+
      g_tmpdir+'\mintras3.txt '+g_tmpdir+'\process.dir '+g_tmpdir+'\reserved >'+
      g_tmpdir+'\tsrelavcbl.data',SW_HIDE);
   fuente.Lines.LoadFromFile(g_tmpdir+'\'+nombre);
   deletefile(g_tmpdir+'\'+nombre);
   memo1.Lines.LoadFromFile(g_tmpdir+'\tsrelavcbl.data');
   dm.sqldelete('delete tsrelavcbl where ocprog='+g_q+nombre+g_q+
      ' and ocbib='+g_q+bib+g_q+
      ' and occlase='+g_q+tipo+g_q);
   for i:=0 to memo1.Lines.Count-1 do begin
      if trim(memo1.Lines[i])='' then
         continue;
         texto :=  stringreplace( memo1.Lines[i], '$SISTEMA$', cmbsistema.Text, [ rfreplaceall ] );
         texto := stringreplace( texto, '$CLASE$', cmbclase.Text, [ rfreplaceall ] );
         texto := stringreplace( texto, '$BIBLIOTECA$', cmbbib.Text, [ rfreplaceall ] );
      //mm.CommaText:=stringreplace(memo1.Lines[i],'''','''''',[rfreplaceall]);
      mm.Delimiter:=',';
      mm.DelimitedText:=stringreplace(texto,'''','''''',[rfreplaceall]);

      if mm.Count<>16 then begin
         //showmessage('resultado inconsistente:'+chr(13)+memo1.Lines[i]);
         //abort;
         smensaje(tipo+'-'+bib+'-'+nombre+' resultado inconsistente:'+memo1.Lines[i]);
         continue;
      end;
      if (mm[3]='FILE') then begin
         if (mm[9]<>'0') then begin
            k:=length(nfile);
            setlength(nfile,k+1);
            nfile[k].registro:=mm[8];
            nfile[k].longitud:=mm[9];
         end;
         mm[9]:=mm[8];
      end;
      if dm.sqlinsert('insert into tsrelavcbl (PCCLASE,PCBIB,PCPROG,PCREG,PCCAMPO,'+
                                              'HCCLASE,HCBIB,HCPROG,HCREG,HCCAMPO,'+
                                              'MODO,LINEA,TEXTO,'+
                                              'OCCLASE,OCBIB,OCPROG)'+
                                       'values('+g_q+mm[0]+g_q+','+
                                                 g_q+mm[1]+g_q+','+
                                                 g_q+mm[2]+g_q+','+
                                                 g_q+mm[3]+g_q+','+
                                                 g_q+mm[4]+g_q+','+
                                                 g_q+mm[5]+g_q+','+
                                                 g_q+mm[6]+g_q+','+
                                                 g_q+mm[7]+g_q+','+
                                                 g_q+mm[8]+g_q+','+
                                                 g_q+mm[9]+g_q+','+
                                                 g_q+mm[10]+g_q+','+
                                                     mm[11]+','+
                                                 g_q+mm[12]+g_q+','+
                                                 g_q+mm[13]+g_q+','+
                                                 g_q+mm[14]+g_q+','+
                                                 g_q+mm[15]+g_q+')')=false then begin
         smensaje('insert into tsrelavcbl (PCCLASE,PCBIB,PCPROG,PCREG,PCCAMPO,'+
                                              'HCCLASE,HCBIB,HCPROG,HCREG,HCCAMPO,'+
                                              'MODO,LINEA,TEXTO,'+
                                              'OCCLASE,OCBIB,OCPROG)'+
                                       'values('+g_q+mm[0]+g_q+','+
                                                 g_q+mm[1]+g_q+','+
                                                 g_q+mm[2]+g_q+','+
                                                 g_q+mm[3]+g_q+','+
                                                 g_q+mm[4]+g_q+','+
                                                 g_q+mm[5]+g_q+','+
                                                 g_q+mm[6]+g_q+','+
                                                 g_q+mm[7]+g_q+','+
                                                 g_q+mm[8]+g_q+','+
                                                 g_q+mm[9]+g_q+','+
                                                 g_q+mm[10]+g_q+','+
                                                     mm[11]+','+
                                                 g_q+mm[12]+g_q+','+
                                                 g_q+mm[13]+g_q+','+
                                                 g_q+mm[14]+g_q+','+
                                                 g_q+mm[15]+g_q+')');
         //showmessage('no puede insertar tsrelavcbl:'+chr(13)+memo1.Lines[i]);
         //abort;
      end;
   end;
   mresultado.Lines.LoadFromFile(g_tmpdir+'\tsvarcbl.data');
   dm.sqldelete('delete tsvarcbl where cprog='+g_q+nombre+g_q+
      ' and cbib='+g_q+bib+g_q+
      ' and cclase='+g_q+tipo+g_q);
   for i:=0 to mresultado.Lines.Count-1 do begin
      mm.CommaText:=stringreplace(mresultado.Lines[i],'''','''''',[rfreplaceall]);
      if trim(mresultado.Lines[i])='' then
         continue;
      if mm.Count<>13 then begin
         //showmessage('resultado inconsistente:'+chr(13)+mresultado.Lines[i]);
         //abort;
         smensaje(tipo+'-'+bib+'-'+nombre+' resultado inconsistente2:'+mresultado.Lines[i]);
         continue;
      end;
      //---------------- Longitud y posicion inicial -------------------------
      if ((strtoint(mm[5])<nivel) and (nivel<>88)) or
         (strtoint(mm[5])=77) then begin
         corte;
      end;
      nivel:=strtoint(mm[5]);
      if trim(mm[11])<>'' then begin     // es un REDEFINES, reposiciona ini
         if nivel=1 then begin
            if dm.sqlselect(dm.q1,'select inicial from tsvarcbl '+
                    ' where cprog='+g_q+mm[2]+g_q+
                    ' and   cbib='+g_q+mm[1]+g_q+
                    ' and   cclase='+g_q+mm[0]+g_q+
                    ' and   creg='+g_q+mm[11]+g_q+
                    ' and   ccampo='+g_q+mm[11]+g_q) then begin
               ini:=dm.q1.fieldbyname('inicial').AsInteger;
            end;
         end
         else begin
            if dm.sqlselect(dm.q1,'select inicial from tsvarcbl '+
                    ' where cprog='+g_q+mm[2]+g_q+
                    ' and   cbib='+g_q+mm[1]+g_q+
                    ' and   cclase='+g_q+mm[0]+g_q+
                    ' and   creg='+g_q+mm[3]+g_q+
                    ' and   ccampo='+g_q+mm[11]+g_q) then begin
               ini:=dm.q1.fieldbyname('inicial').AsInteger;
            end;
         end;
      end;
      if nivel=1 then begin   // nivel=1
         longi:=0;
         ini:=1;
      end;
      if nivel=88 then begin
         ini:=ini-longi;
      end
      else begin
         if trim(mm[6])='' then begin
            longi:=0;
            k:=length(nn);
            setlength(nn,k+1);
            nn[k].ini:=ini;
            nn[k].lon:=0;
            nn[k].nivel:=nivel;
            nn[k].occurs:=strtoint(mm[10]);
            nn[k].upd:=' where cprog='+g_q+mm[2]+g_q+
                       ' and   cbib='+g_q+mm[1]+g_q+
                       ' and   cclase='+g_q+mm[0]+g_q+
                       ' and   creg='+g_q+mm[3]+g_q+
                       ' and   ccampo='+g_q+mm[4]+g_q;
         end
         else begin
            longi:=fnpicture(mm[6],mm[7]);
         end;
      end;
      if dm.sqlselect(dm.q1,'select * from tsvarcbl '+
                    ' where cprog='+g_q+mm[2]+g_q+
                    ' and   cbib='+g_q+mm[1]+g_q+
                    ' and   cclase='+g_q+mm[0]+g_q+
                    ' and   creg='+g_q+mm[3]+g_q+
                    ' and   ccampo='+g_q+mm[4]+g_q)=false then begin
         dm.sqlinsert('insert into tsvarcbl   (cclase,cbib,cprog,creg,ccampo,nivel,picture,usage,value,linea,longitud,inicial,occurs,texto)'+
                                      ' values('+g_q+mm[0]+g_q+','+
                                                 g_q+mm[1]+g_q+','+
                                                 g_q+mm[2]+g_q+','+
                                                 g_q+mm[3]+g_q+','+
                                                 g_q+mm[4]+g_q+','+
                                                 g_q+mm[5]+g_q+','+
                                                 g_q+mm[6]+g_q+','+
                                                 g_q+mm[7]+g_q+','+
                                                 g_q+mm[8]+g_q+','+
                                                     mm[9]+','+
                                                 inttostr(longi)+','+
                                                 inttostr(ini)+','+
                                                     mm[10]+','+
                                                 g_q+mm[12]+g_q+')');
      end;
      ini:=ini+longi*strtoint(mm[10]);
   end;
   mm[5]:='77';
   corte;
   for k:=0 to length(nfile)-1 do begin
      dm.sqlupdate('update tsvarcbl set longitud='+nfile[k].longitud+
         ' where cprog='+g_q+nombre+g_q+
         ' and   cbib='+g_q+bib+g_q+
         ' and   cclase='+g_q+tipo+g_q+
         ' and   creg='+g_q+nfile[k].registro+g_q+
         ' and   ccampo='+g_q+nfile[k].registro+g_q);
   end;
   setlength(nfile,0);
   setlength(nn,0);
   procesa_mapas(tipo,bib,nombre);
end;
procedure Tftsanaprog.trae_utilerias( tipo: string );
begin
   if b_noprocesa then exit;
   if tipo = 'CBL' then begin
      dm.get_utileria( 'INSERTA_COPY', g_tmpdir + '\inserta_copy.dir' );
      dm.get_utileria( 'RESERVADAS CBL', g_tmpdir + '\reserved' );
      dm.get_utileria( 'ANALIZA CBL', g_tmpdir + '\process.dir' );
      dm.get_utileria( 'RGMLANG', g_tmpdir + '\htaanaliza.exe' );
   end
   else
   if tipo = 'BMS' then begin
      dm.get_utileria( 'ANALIZA BMS', g_tmpdir + '\process.dir' );
      dm.get_utileria( 'RGMLANG', g_tmpdir + '\htaanaliza.exe' );
   end;
end;

procedure Tftsanaprog.butileriaClick(Sender: TObject);
begin
   PR_UTILERIA;

end;

procedure Tftsanaprog.Fuente1Click(Sender: TObject);
var ejebat:string;
begin
   ejebat:='fte'+formatdatetime('YYYYMMDDHHnnss',now)+'.txt';
   fuente.Lines.SaveToFile(ejebat);
   ShellExecute(0,'open',PChar(ejebat),'','',SW_SHOW);
end;

procedure Tftsanaprog.fuenteMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   if button=mbright then
      pop.Popup(mouse.CursorPos.X,mouse.CursorPos.y);
end;

procedure Tftsanaprog.bcomparaClick(Sender: TObject);
var ejebat:string;
begin
   ejebat:='fte'+formatdatetime('YYYYMMDDHHnnss',now)+'.txt';
   fuente.Lines.SaveToFile(ejebat);
   ShellExecute(0,'open',PChar(ejebat),'','',SW_SHOW);
end;

end.
