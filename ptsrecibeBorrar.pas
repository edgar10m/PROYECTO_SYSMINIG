unit ptsrecibe;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FileCtrl, ExtCtrls, ComCtrls, StdCtrls, Buttons, DB,
  ADODB, Grids, DBGrids, Menus, shellapi, dateutils, ImgList;
type
   TMyRec = record
      ruta: string;
   end;

type
  Tftsrecibe = class(TForm)
    grbRecepcion: TGroupBox;
    dir: TDirectoryListBox;
    archivo: TFileListBox;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label5: TLabel;
    Label1: TLabel;
    Label6: TLabel;
    Label4: TLabel;
    txtsufijo: TEdit;
    cmbsistema: TComboBox;
    cmbclase: TComboBox;
    cmbbiblioteca: TComboBox;
    barchivo: TBitBtn;
    bseltodo: TBitBtn;
    chkversion: TCheckBox;
    GroupBox3: TGroupBox;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    ydrive: TPanel;
    Drive: TDriveComboBox;
    split: TSplitter;
    cmboficina: TComboBox;
    Label7: TLabel;
    rgnombre: TRadioGroup;
    Splitter5: TSplitter;
    chkexiste: TCheckBox;
    DataSource1: TDataSource;
    gtsprog: TDBGrid;
    tsprog: TADOQuery;
    tsversion: TADOQuery;
    DataSource2: TDataSource;
    gtsversion: TDBGrid;
    rxfuente: TMemo;
    poparchivo: TPopupMenu;
    N1: TMenuItem;
    chkanaliza: TCheckBox;
    rxfc: TMemo;
    barra: TProgressBar;
    Panel2: TPanel;
    pie: TLabel;
    chkgoogle: TCheckBox;
    blog: TButton;
    Splitter6: TSplitter;
    chkruta: TCheckBox;
    ImageList1: TImageList;
    lbxarchivo: TListBox;
    chkparams: TCheckBox;
    Panel1: TPanel;
    bsalir: TBitBtn;
    butileria: TButton;
    yextra: TGroupBox;
    chkextra: TCheckBox;
    txtextra: TEdit;
    chktodas: TCheckBox;
    btodo: TButton;
    chkextension: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure cmboficinaChange(Sender: TObject);
    procedure cmbsistemaChange(Sender: TObject);
    procedure bseltodoClick(Sender: TObject);
    procedure txtsufijoChange(Sender: TObject);
    procedure barchivoClick(Sender: TObject);
    procedure archivoClick(Sender: TObject);
    procedure gtsprogCellClick(Column: TColumn);
    procedure gtsversionCellClick(Column: TColumn);
    procedure comparafuente(Sender: TObject);
    procedure cmbclaseClick(Sender: TObject);
    procedure poparchivoPopup(Sender: TObject);
    procedure eliminacomponente(Sender: TObject);
    procedure bsalirClick(Sender: TObject);
    procedure blogClick(Sender: TObject);
    procedure Splitter6Moved(Sender: TObject);
    procedure chkrutaClick(Sender: TObject);
    procedure dirMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure butileriaClick(Sender: TObject);
    procedure chkextraClick(Sender: TObject);
    procedure chktodasClick(Sender: TObject);
    procedure btodoClick(Sender: TObject);
  private
    { Private declarations }
     herramienta:string;
     archivo_master:string;
     bib_dir:string;
     bib_base:string;
     cla_tipo:string;
     reg:^Tmyrec;
     nodo_actual: Ttreenode;
     b_todos:boolean;
     ant_clase:string;
     function nombre_componente(nombre:string):string;
     procedure procesa_busqueda(clase:string; bib:string; nombre:string; archivo:string);
     procedure habilita;
     procedure abre_cierra_tsversion;
     procedure AddDirectories(cPath: string; lista:Tlistbox; mascara:string);
     procedure tsparams_job_jcl(job:string;bib:string;clase:string;
                                jcl:string; jbib:string; jclase:string);
     procedure tsparams_job(job:string; bib:string; copiado:string);
     procedure tsparams_jcl(jcl:string; bib:string);
  public
    { Public declarations }
  end;

var
  ftsrecibe: Tftsrecibe;
  procedure PR_RECIBE;

implementation
uses ptsdm,ptsutileria;
{$R *.dfm}
procedure PR_RECIBE;
begin
   Application.CreateForm( Tftsrecibe, ftsrecibe );
   try
      ftsrecibe.Showmodal;
   finally
      ftsrecibe.Free;
   end;
end;

procedure Tftsrecibe.FormCreate(Sender: TObject);
begin
   if g_language='ENGLISH' then begin
      caption:='Receiving Components';
      grbrecepcion.Caption:='Reception';
      groupbox2.Caption:='Operation';
      groupbox3.Caption:='Result';
      label7.Caption:='Office';
      label5.Caption:='Application';
      label1.Caption:='Class';
      label6.Caption:='Library';
      label2.Caption:='Mask';
      label4.Caption:='Process';
      bseltodo.Caption:='Select All';
      chkexiste.Caption:='Ignores existing';
      chkversion.Caption:='Check versions';
      chkanaliza.Caption:='Analizes source';
      chkgoogle.Caption:='Search active';
      rgnombre.Caption:='Component name';
      rgnombre.Items[0]:='Current';
      rgnombre.Items[1]:='lowercase';
      rgnombre.Items[2]:='UPPERCASE';
      butileria.Caption:='Load Utility';
   end;
   dm.feed_combo(cmboficina,'select coficina from tsoficina order by coficina');
   dm.feed_combo(cmbclase,'select cclase from tsclase where objeto='+g_q+'FISICO'+g_q+
      ' order by cclase');
   dm.feed_combo(cmbbiblioteca,'select cbib from tsbib order by cbib');
   butileria.Visible:=dm.capacidad('Menu Principal Carga Utileria');

   tsprog.Connection:=dm.ADOConnection1;
   tsversion.Connection:=dm.ADOConnection1;
   b_todos:=false;
end;
procedure Tftsrecibe.habilita;
begin
   barchivo.Enabled:=(cmboficina.Text<>'') and (cmbsistema.Text<>'') and
      (cmbclase.Text<>'') and (cmbbiblioteca.Text<>'') and
      (((chkruta.Checked=false) and (archivo.SelCount>0)) or
       ((chkruta.Checked=true) and (lbxarchivo.SelCount>0)));
   if trim(cmbbiblioteca.Text)='' then
      chktodasclick(self);

end;
procedure Tftsrecibe.cmboficinaChange(Sender: TObject);
begin
   dm.feed_combo(cmbsistema,'select csistema from tssistema where coficina='+g_q+cmboficina.Text+g_q+
      ' order by csistema');
   habilita;
end;

procedure Tftsrecibe.cmbsistemaChange(Sender: TObject);
begin
   if ant_clase<>cmbclase.Text then begin
      chktodasClick(sender);
      ant_clase:=cmbclase.text;
   end;
   if (cmbsistema.Text<>'') and (cmbclase.Text<>'') and (cmbbiblioteca.Text<>'') then begin
      if dm.sqlselect(dm.q1,'select * from parametro '+
         ' where clave='+g_q+'dir_'+cmbsistema.Text+'_'+cmbclase.Text+'_'+cmbbiblioteca.Text+g_q) then begin
         if directoryexists(dm.q1.fieldbyname('dato').AsString) then begin
            dir.Directory:=dm.q1.fieldbyname('dato').AsString;
         end;
      end;
      if dm.sqlselect(dm.q1,'select * from parametro '+
         ' where clave='+g_q+'mask_'+cmbsistema.Text+'_'+cmbclase.Text+'_'+cmbbiblioteca.Text+g_q) then begin
         txtsufijo.Text:=dm.q1.fieldbyname('dato').AsString;
      end;
      if dm.sqlselect(dm.q1,'select * from parametro '+
         ' where clave='+g_q+'chkextra_'+cmbsistema.Text+'_'+cmbclase.Text+'_'+cmbbiblioteca.Text+g_q) then begin
         chkextra.Checked:=(dm.q1.fieldbyname('dato').AsString='TRUE');
      end;
      if dm.sqlselect(dm.q1,'select * from parametro '+
         ' where clave='+g_q+'chkruta_'+cmbsistema.Text+'_'+cmbclase.Text+'_'+cmbbiblioteca.Text+g_q) then begin
         chkruta.Checked:=(dm.q1.fieldbyname('dato').AsString='TRUE');
      end;
      if dm.sqlselect(dm.q1,'select * from parametro '+
         ' where clave='+g_q+'chkextension_'+cmbsistema.Text+'_'+cmbclase.Text+'_'+cmbbiblioteca.Text+g_q) then begin
         chkextension.Checked:=(dm.q1.fieldbyname('dato').AsString='TRUE');
      end;
      tsprog.Close;
      tsprog.SQL.Clear;
      {
      tsprog.SQL.Add('select cprog,cbib,cclase,fecha,cbibbin,cblob,magic,analizado,descripcion '+
         ' from tsprog,tsrela '+
         ' where pcprog='+g_q+cmbclase.Text+g_q+
         ' and   pcbib='+g_q+cmbsistema.Text+g_q+
         ' and   hcbib='+g_q+cmbbiblioteca.Text+g_q+
         ' and   cprog=hcprog '+
         ' and   cbib=hcbib '+
         ' order by cprog ');
      }
      tsprog.SQL.Add('select cprog,cbib,cclase,sistema,fecha,cbibbin,cblob,magic,analizado,descripcion '+
         ' from tsprog '+
         ' where cclase='+g_q+cmbclase.Text+g_q+
         ' and   cbib='+g_q+cmbbiblioteca.Text+g_q+
         ' and   sistema='+g_q+cmbsistema.Text+g_q+
         ' order by cprog ');
      tsprog.open;
      if dm.sqlselect(dm.q1,'select * from tsbib where cbib='+g_q+cmbbiblioteca.Text+g_q) then begin
         bib_dir:=dm.q1.fieldbyname('path').AsString;
         bib_base:=dm.q1.fieldbyname('dirprod').AsString;
      end;
      if dm.sqlselect(dm.q1,'select * from tsclase where cclase='+g_q+cmbclase.Text+g_q) then begin
         cla_tipo:=dm.q1.fieldbyname('tipo').AsString;
         if (cmbclase.Text='TDC') then begin
            if (rgnombre.ItemIndex<>0) then begin
               Application.MessageBox(pchar(dm.xlng('Para esta clase se recomienda manejar el nombre'+chr(13)+
                  'del componente en modo "ACTUAL" (Cuadro inferior)')),
                                      pchar(dm.xlng('Recepción de componentes')), MB_OK );
            end;
         end
         else begin
            if dm.q1.FieldByName('estructura').asstring='PATH BASE' then begin
               chkruta.Checked:=true;
               chkruta.OnClick(sender);
               if rgnombre.ItemIndex<>0 then begin
                  Application.MessageBox(pchar(dm.xlng('Para esta clase se recomienda manejar el nombre'+chr(13)+
                     'del componente en modo "Actual" (Cuadro inferior)')),
                                         pchar(dm.xlng('Recepción de componentes')), MB_OK );
                  rgnombre.ItemIndex:=0;
               end;
            end
            else begin
               chkruta.Checked:=false;
               chkruta.OnClick(sender);
               if rgnombre.ItemIndex<>2 then begin
                  Application.MessageBox(pchar(dm.xlng('Para esta clase se recomienda manejar el nombre'+chr(13)+
                     'del componente en modo "MAYUSCULAS" (Cuadro inferior)')),
                                         pchar(dm.xlng('Recepción de componentes')), MB_OK );
               end;
            end;
         end;
      end;
      if (cmbclase.Text='JOB') or (cmbclase.text='JCL') then begin
         chkparams.Checked:=true;
         chkparams.Visible:=true;
      end
      else begin
         chkparams.Checked:=false;
         chkparams.Visible:=false;
      end;
      if (cmbclase.Text='CBL') or (cmbclase.Text='CPY')  then begin
         yextra.Visible:=true;
         if dm.sqlselect(dm.q1,'select * from parametro '+
            ' where clave='+g_q+'EXTRA_MINING_'+cmbclase.Text+g_q) then
            txtextra.Text:=dm.q1.fieldbyname('dato').AsString;
      end
      else begin
         yextra.Visible:=false;
      end;
   end;
   habilita;
end;

procedure Tftsrecibe.bseltodoClick(Sender: TObject);
begin
   if chkruta.Checked then begin
      lbxarchivo.SelectAll;
      pie.Caption:=inttostr(lbxarchivo.SelCount)+' archivos seleccionados';
   end
   else begin
      archivo.SelectAll;
      pie.Caption:=inttostr(archivo.SelCount)+' archivos seleccionados';
   end;
   habilita;
end;

procedure Tftsrecibe.txtsufijoChange(Sender: TObject);
begin
   archivo.Mask:=txtsufijo.Text;
end;
function Tftsrecibe.nombre_componente(nombre:string):string;
var nom:string;
begin
   if copy(nombre,1,5)='ROOT\' then
      nombre:='.'+copy(nombre,6,500);
   if chkextension.Checked=false then begin
      if chkruta.Checked then
         nom:=changefileext(nombre,'')
      else
         nom:=changefileext(extractfilename(nombre),'');
   end
   else begin
      if chkruta.Checked then
         nom:=nombre
      else
         nom:=extractfilename(nombre);
   end;
   case rgnombre.ItemIndex of
   1: nom:=lowercase(nom);
   2: nom:=uppercase(nom);
   end;
   nombre_componente:=nom;
end;
procedure Tftsrecibe.procesa_busqueda(clase:string; bib:string; nombre:string; archivo:string);
var
  F: Textfile;
  pal,anterior:string;
  n:integer;
begin
   dm.sqldelete('delete tssearch '+
      ' where cprog='+g_q+nombre+g_q+
      ' and   cbib='+g_q+bib+g_q+
      ' and   cclase='+g_q+clase+g_q);
   dm.ejecuta_espera(
      g_tmpdir+'\hta12345.exe '+archivo+' '+
      g_tmpdir+'\source.new '+g_tmpdir+'\dir12345.dir |sort >'+
      g_tmpdir+'\'+nombre+'.goo',SW_HIDE);
   AssignFile(F, g_tmpdir+'\'+nombre+'.goo');
   FileMode := 0;  {Set file access to read only }
   n:=0;
   Reset(F);
   while not EOF(F) do begin
      readln(F,pal);
      pal:=trim(pal);
      if pal=g_q then continue;
      if pal=anterior then
         inc(n)
      else begin
         if trim(anterior)<>'' then begin
            if dm.sqlinsert('insert into tssearch (cword,cprog,cbib,cclase,cuenta) values('+
               g_q+anterior+g_q+','+
               g_q+nombre+g_q+','+
               g_q+bib+g_q+','+
               g_q+clase+g_q+','+
               inttostr(n)+')')=false then begin
               Application.MessageBox(pchar(dm.xlng('ERROR... no puede dar de alta registro en TSSEARCH')),
                              pchar(dm.xlng('Procesar busqueda ')), MB_OK );
               abort;
            end;
         end;
         n:=1;
         anterior:=pal;
      end;
   end;
   if trim(anterior)<>'' then begin
      if dm.sqlinsert('insert into tssearch (cword,cprog,cbib,cclase,cuenta) values('+
         g_q+anterior+g_q+','+
         g_q+nombre+g_q+','+
         g_q+bib+g_q+','+
         g_q+clase+g_q+','+
         inttostr(n)+')')=false then begin
         Application.MessageBox(pchar(dm.xlng('ERROR... no puede dar de alta registro en TSSEARCH')),
                                 pchar(dm.xlng('Procesa busqueda ')), MB_OK );
         abort;
      end;
   end;
   CloseFile(F);
   deletefile(g_tmpdir+'\'+nombre+'.goo');
end;
procedure Tftsrecibe.tsparams_job_jcl(job:string;bib:string;clase:string;
      jcl:string; jbib:string; jclase:string);
var dato,par,par2:string;
begin
   if dm.sqlselect(dm.q2,'select * from tsrela '+ // busca hijos del JCL con parametros
      ' where ocprog='+g_q+jcl+g_q+
      ' and   ocbib='+g_q+jbib+g_q+
      ' and   occlase='+g_q+jclase+g_q+
      ' and   hcprog like '+g_q+'%&%'+g_q) then begin
      while not dm.q2.Eof do begin
         dato:=dm.q2.fieldbyname('hcprog').AsString;
         while pos('&',dato)>0 do begin             // reemplaza parametros
            par:=copy(dato,pos('&',dato),500);
            if pos('.',par)>0 then                  // a veces el parametro no termina con punto
               par:=copy(par,1,pos('.',par));
            par2:=stringreplace(copy(par,2,500),'.','',[]);
            if dm.sqlselect(dm.q3,'select valor from tsparams '+
               ' where cprog='+g_q+job+g_q+
               ' and   cbib='+g_q+bib+g_q+
               ' and   cclase='+g_q+clase+g_q+
               ' and   param='+g_q+par2+g_q) then begin
               dato:=stringreplace(dato,par,dm.q3.fieldbyname('valor').AsString,[rfreplaceall]);
            end
            else begin
               dato:='';
            end;
         end;                          // inserta copia de registro con propietario JOB
         if trim(dato)<>'' then begin
            dm.sqlinsert('insert into tsrela (pcprog,pcbib,pcclase,hcprog,hcbib,hcclase,'+
               'modo,organizacion,externo,coment,orden,ocprog,ocbib,occlase,sistema) values('+
               g_q+dm.q2.fieldbyname('pcprog').AsString+g_q+','+
               g_q+dm.q2.fieldbyname('pcbib').AsString+g_q+','+
               g_q+dm.q2.fieldbyname('pcclase').AsString+g_q+','+
               g_q+dato+g_q+','+
               g_q+dm.q2.fieldbyname('hcbib').AsString+g_q+','+
               g_q+dm.q2.fieldbyname('hcclase').AsString+g_q+','+
               g_q+dm.q2.fieldbyname('modo').AsString+g_q+','+
               g_q+dm.q2.fieldbyname('organizacion').AsString+g_q+','+
               g_q+dm.q2.fieldbyname('externo').AsString+g_q+','+
               g_q+dm.q2.fieldbyname('coment').AsString+g_q+','+
               g_q+dm.q2.fieldbyname('orden').AsString+g_q+','+
               g_q+job+g_q+','+
               g_q+bib+g_q+','+
               g_q+clase+g_q+','+
               g_q+dm.q2.fieldbyname('sistema').AsString+g_q+')');
         end;
         dm.q2.Next;
      end;
   end;
end;
procedure Tftsrecibe.tsparams_job(job:string; bib:string; copiado:string);
var directivas,analizador,nuevo,salida,valor:string;
   lista,pp:Tstringlist;
   i:integer;
begin
   directivas:=g_tmpdir+'\hta452345';          // ejecuta herramienta para extraer parámetros
   if fileexists(directivas)=false then
      dm.get_utileria('PARAMS.DIR',directivas);
   analizador:=g_tmpdir+'\hta3214444.exe';
   if fileexists(analizador)=false then
      dm.get_utileria('RGMLANG',analizador);
   nuevo:=g_tmpdir+'\nada1234';
   salida:=g_tmpdir+'\nada4444';
   g_borrar.Add(directivas);
   g_borrar.Add(analizador);
   g_borrar.Add(nuevo);
   g_borrar.Add(salida);
   dm.ejecuta_espera(analizador+' '+copiado+' '+nuevo+' '+directivas+' >'+salida,SW_HIDE);
   lista:=Tstringlist.Create;
   pp:=Tstringlist.Create;
   lista.LoadFromFile(salida);
   dm.sqldelete('delete tsparams '+      // borra parametros anteriores
      ' where cprog='+g_q+job+g_q+
      ' and cbib='+g_q+bib+g_q+
      ' and cclase='+g_q+'JOB'+g_q);
   for i:=0 to lista.Count-1 do begin    // alta nuevos parametros
      pp.CommaText:=lista[i];
      if pp.Count<>5 then continue;
      dm.sqlinsert('insert into tsparams (cprog,cbib,cclase,param,valor) values('+
         g_q+job+g_q+','+
         g_q+bib+g_q+','+
         g_q+'JOB'+g_q+','+
         g_q+pp[3]+g_q+','+
         g_q+stringreplace(pp[4],'''','',[rfreplaceall])+g_q+')');
   end;
   if dm.sqlselect(dm.q1,'select * from tsrela '+    // busca JCLs llamados por el JOB
      ' where ocprog='+g_q+job+g_q+
      ' and   ocbib='+g_q+bib+g_q+
      ' and   occlase='+g_q+'JOB'+g_q+
      ' and   hcclase='+g_q+'JCL'+g_q) then begin
      while not dm.q1.Eof do begin
         tsparams_job_jcl(job,bib,'JOB',dm.q1.fieldbyname('hcprog').AsString,
            dm.q1.fieldbyname('hcbib').AsString,dm.q1.fieldbyname('hcclase').AsString);
         dm.q1.Next;
      end;
   end;

end;
procedure Tftsrecibe.tsparams_jcl(jcl:string; bib:string);
begin
   // revisa si los JOB que lo llaman usan parametros
   if dm.sqlselect(dm.q1,'select distinct ocprog,ocbib,occlase from tsrela,tsparams '+
      ' where ocprog=cprog '+
      ' and   hcprog='+g_q+jcl+g_q+
      ' and   hcbib='+g_q+bib+g_q+
      ' and   hcclase='+g_q+'JCL'+g_q+
      ' and   occlase='+g_q+'JOB'+g_q) then begin
      // reprocesa los JOB en su manejo de parametros
      while not dm.q1.Eof do begin
         dm.sqldelete('delete tsrela '+   // borra registros adoptados anteriores
            ' where ocprog='+g_q+dm.q1.fieldbyname('ocprog').AsString+g_q+
            ' and   ocbib='+g_q+dm.q1.fieldbyname('ocbib').AsString+g_q+
            ' and   occlase='+g_q+dm.q1.fieldbyname('occlase').AsString+g_q+
            ' and   (pcprog,pcbib,pcclase) in '+
            '       (select distinct pcprog,pcbib,pcclase from tsrela '+
            '           where ocprog='+g_q+jcl+g_q+
            '           and   ocbib='+g_q+bib+g_q+
            '           and   occlase='+g_q+'JCL'+g_q+')');
         tsparams_job_jcl(dm.q1.fieldbyname('ocprog').AsString,
            dm.q1.fieldbyname('ocbib').AsString,
            dm.q1.fieldbyname('occlase').AsString,jcl,bib,'JCL');
         dm.q1.Next;
      end;
   end;
end;
procedure Tftsrecibe.barchivoClick(Sender: TObject);
var i:integer;
   anterior,este,magic,nblob,fecha,idversion:string;
   analizador,reservadas,directivas,qcomponente,copiado:string;
   fmbanalizador:string;
   inicio,fin:Tdatetime;
   dire:Tstringlist;
   colini,colfin,mens:string;
   compos:Tstringlist;
   extrapars:string;
   b_extra:boolean;
   verdad:string;
   basenombre:string; // para shell UNIX
begin
   if barchivo.Enabled=false then exit;
   g_sistema_actual:=cmbsistema.Text;
   extrapars:='';
   if trim(dm.pathbib(cmbbiblioteca.Text))='' then begin
      Application.MessageBox(pchar(dm.xlng('ERROR... no tiene definido PATH en catálogo de bibliotecas')),
                             pchar(dm.xlng('Procesa archivos ')), MB_OK );
      abort;
   end;
   if directoryexists(dm.pathbib(cmbbiblioteca.Text))=false then begin
      try
         mkdir(dm.pathbib(cmbbiblioteca.Text));
         mkdir(dm.pathbib(cmbbiblioteca.Text)+'\versiones');
      except
         Application.MessageBox(pchar(dm.xlng('ERROR... No puede crear directorio '+dm.pathbib(cmbbiblioteca.Text))),
                                pchar(dm.xlng('Procesa archivos ')), MB_OK );
         abort;
      end;
   end;
   if directoryexists(dm.pathbib(cmbbiblioteca.Text)+'\versiones')=false then begin
      try
         mkdir(dm.pathbib(cmbbiblioteca.Text)+'\versiones');
      except
         Application.MessageBox(pchar(dm.xlng('ERROR... No puede crear directorio '+dm.pathbib(cmbbiblioteca.Text))),
                                pchar(dm.xlng('Procesa archivos ')), MB_OK );
         abort;
      end;
   end;
   if directoryexists(dm.pathbib(cmbbiblioteca.Text))=false then begin
      Application.MessageBox(pchar(dm.xlng('ERROR... no existe el directorio '+dm.pathbib(cmbbiblioteca.Text))),
                             pchar(dm.xlng('Procesa archivos ')), MB_OK );
      abort;
   end;
   if directoryexists(dm.pathbib(cmbbiblioteca.Text)+'\versiones')=false then begin
      Application.MessageBox(pchar(dm.xlng('ERROR... no existe el directorio '+dm.pathbib(cmbbiblioteca.Text)+'\versiones')),
                             pchar(dm.xlng('Procesa archivos ')), MB_OK );
      abort;
   end;
   compos:=Tstringlist.Create;
   if chkruta.Checked then begin
      for i:=0 to lbxarchivo.Items.Count-1 do begin
         if lbxarchivo.Selected[i] then
            compos.Add(lbxarchivo.Items[i]);
      end
   end
   else begin
      for i:=0 to archivo.Items.Count-1 do begin
         if archivo.Selected[i] then
            compos.Add(archivo.Items[i]);
      end;
   end;
   if compos.Count=0 then begin
      barchivo.Enabled:=false;
      exit;
   end;
   anterior:='';
   if chkextension.Checked=false then begin
      for i:=0 to compos.Count-1 do begin  // checa que no haya 2 iguales con diferente extensión
         este:=nombre_componente(compos[i]);
         if este=anterior then begin
            g_log.Add(dm.xlng('ERROR... el componente aparece más de una vez ['+anterior+']'));
            g_log.Add(dm.xlng('No se dio de alta ningún componente'));
            Application.MessageBox(pchar(dm.xlng('ERROR... el componente aparece más de una vez ['+anterior+']')),
                                   pchar(dm.xlng('Procesa archivos ')), MB_OK );
            Application.MessageBox(pchar(dm.xlng('No se dio de alta ningún componente')),
                                   pchar(dm.xlng('Procesa archivos ')), MB_OK );
            exit;
         end;
         anterior:=este;
      end;
   end;
   if cmbclase.Text='JOB' then begin        // para procesar TSPARAMS
      deletefile(g_tmpdir+'\hta452345');
      deletefile(g_tmpdir+'\hta3214444.exe');
   end;
   if (chkanaliza.Checked) and (cla_tipo='ANALIZABLE') then begin
      fmbanalizador:=g_tmpdir+'\fmb321432.exe';
      if cmbclase.Text='FMB' then begin    // Formas ORACLE DEVELOPER 2000
         dm.get_utileria('SVSFMB',fmbanalizador);
      end;
      analizador:=g_tmpdir+'\hta321432.exe';
      dm.get_utileria(herramienta,analizador);
      g_borrar.Add(g_tmpdir+'\source.new');
      if herramienta='RGMLANG' then begin
         directivas:=g_tmpdir+'\hta321432.dir';
         dm.get_utileria('DIRECTIVAS '+cmbclase.Text,directivas);
         SetEnvironmentVariable(pchar('ZTIPO'),pchar(cmbclase.Text));
      end;
      reservadas:=g_tmpdir+'\reserved';
      dm.get_utileria('RESERVADAS '+cmbclase.Text,reservadas);
   end;
   {
   if chkgoogle.Checked then begin   // Search
      dm.get_utileria('RGMLANG',g_tmpdir+'\hta12345.exe');
      colini:='07';
      colfin:='72';
      if (cmbclase.Text='CTC') or
         (cmbclase.Text='JCL') or
         (cmbclase.Text='JOB') then
         colini:='01';
      dire:=Tstringlist.Create;
    //  dire.Add('ENVIRE    BC'+colini+'EC'+colfin+'JB'+colini+'JE'+colfin+'SL¿CL+*/:.,;()=¬´{[]''"-_WH000M101M2SVS****M301M4SVS\\');
      dire.Add('TAG       vVAR\\');
      dire.Add('SHOW      +VAR\\');
      dire.SaveToFile(g_tmpdir+'\dir12345.dir');
      dire.free;
      g_borrar.Add(g_tmpdir+'\hta12345.exe');
      g_borrar.Add(g_tmpdir+'\dir12345.dir');

      // Si la tabla TSSEARCH no existe, la crea
//      if dm.sqlselect(dm.q1,'select count(*) total from tssearch')=false then begin
      if dm.verifica_base('TSSEARCH')=false then begin
         if dm.sqlinsert('create table tssearch ('+
            ' cword        varchar(80) NOT NULL,'+
            ' cprog        varchar(30) NOT NULL,'+
            ' cbib        varchar(30)  NOT NULL,'+
            ' cclase      varchar(10)  NOT NULL,'+
            ' cuenta       integer      NOT NULL)')=false then begin
            g_log.Add('ftsrecibe.barchivoClick|ERROR... no puede crear TSSEARCH');
            showmessage('ERROR... no puede crear TSSEARCH');
            abort;
         end;
         dm.sqlinsert('create index idx_tssearch_cword on tssearch(cword)');
         dm.sqlinsert('create index idx_tssearch_componente on tssearch(cprog,cbib,cclase)');
      end;
   end;
   }
//   ftsrecibe.Enabled:=false;
   screen.Cursor:=crsqlwait;
   barra.Max:=compos.Count;
   barra.Position:=0;
   barra.Step:=1;
   barra.Visible:=true;
   inicio:=now;
   b_extra:=false;
   for i:=0 to compos.Count-1 do begin
         rxfc.Text:='';
         basenombre:=extractfilepath(nombre_componente(compos[i]));
         este:=nombre_componente(compos[i]);
         este:=stringreplace(este,'/','.',[rfreplaceall]);
         este:=stringreplace(este,'\','.',[rfreplaceall]);
         if (cmbclase.Text='JXM') or (cmbclase.Text='TLD') then begin  // JAVA para web.xml y anexas
            este:=stringreplace(cmbsistema.Text+'_'+este,' ','.',[rfreplaceall]);
         end;
         if chkexiste.Checked then begin
            if dm.sqlselect(dm.q1,'select * from tsprog '+
               ' where cprog='+g_q+este+g_q+
               ' and   cbib='+g_q+cmbbiblioteca.Text+g_q) then continue;
         end;
         magic:=dm.filemagic(dir.Directory+'\'+compos[i]);
//NBLOB         nblob:=dm.file2blob(dir.Directory+'\'+archivo.Items[i], magic);
         nblob:='1';


         if chkversion.Checked then begin
            // Checa que no esté en otra biblioteca u otro sistema
            if dm.sqlselect(dm.q1,'select * from tsprog '+
               ' where cprog='+g_q+este+g_q+
               ' and   magic='+g_q+magic+g_q+
               ' and   (cbib<>'+g_q+cmbbiblioteca.Text+g_q+
               '    or  sistema<>'+g_q+cmbsistema.Text+g_q+')'+
               ' order by cclase,cbib') then begin
               anterior:='';
               while not dm.q1.Eof do begin
                  anterior:=anterior+char(13)+'Sistema:'+dm.q1.fieldbyname('sistema').AsString+' '+
                     ' Clase:'+dm.q1.fieldbyname('cclase').AsString+' '+
                     ' Libreria:'+dm.q1.fieldbyname('cbib').AsString+' '+formatdatetime('YYYY-MM-DD HH:NN:SS',
                     dm.q1.fieldbyname('fecha').Asdatetime);
                  dm.q1.Next;
               end;
               case application.MessageBox(pchar(dm.xlng('El componente '+este+' es idéntico a: '+anterior+
                  char(13)+'Desea darlo de alta?')),pchar(dm.xlng('Confirmar')),MB_YESNOCANCEL) of
                  IDNO: begin
                     // NBLOB faltaba dm.sqldelete('delete from tsblob where cblob='+g_q+nblob+g_q);
                     continue;
                  end;
                  IDCANCEL: begin
                     ftsrecibe.Enabled:=true;
                     screen.Cursor:=crdefault;
                     exit;
                  end;
               end;
            end;
            // Checa que no se trate de versiones anteriores
            if dm.sqlselect(dm.q1,'select * from tsversion '+
               ' where cprog='+g_q+este+g_q+
               ' and   cbib='+g_q+cmbbiblioteca.Text+g_q+
               ' and   cclase='+g_q+cmbclase.Text+g_q+
               ' and   magic='+g_q+magic+g_q+
               ' order by fecha desc') then begin
               anterior:='';
               while not dm.q1.Eof do begin
                  anterior:=anterior+char(13)+formatdatetime('YYYY-MM-DD HH:NN:SS',
                     dm.q1.fieldbyname('fecha').Asdatetime);
                  dm.q1.Next;
               end;
               case application.MessageBox(pchar(dm.xlng('El componente '+este+' es igual a las versiones '+anterior+
                  char(13)+'Desea darla de alta?')),pchar(dm.xlng('Confirmar')),MB_YESNOCANCEL) of
                  IDNO: begin
                     // NBLOB faltaba dm.sqldelete('delete from tsblob where cblob='+g_q+nblob+g_q);
                     continue;
                  end;
                  IDCANCEL: begin
                     ftsrecibe.Enabled:=true;
                     screen.Cursor:=crdefault;
                     exit;
                  end;
               end;
            end;
         end;
         fecha:=dm.datedb(formatdatetime('YYYY/MM/DD HH:NN:SS',now),'YYYY/MM/DD HH24:MI:SS');
         if dm.sqlselect(dm.q1,'select * from tsprog '+
            ' where cprog='+g_q+este+g_q+
            ' and   cbib='+g_q+cmbbiblioteca.Text+g_q+
            ' and   cclase='+g_q+cmbclase.Text+g_q) then begin
            if dm.sqlupdate('update tsprog set '+
               ' fecha='+fecha+','+
               ' cblob='+g_q+nblob+g_q+','+
               ' magic='+g_q+magic+g_q+','+
               ' sistema='+g_q+cmbsistema.Text+g_q+
               ' where cprog='+g_q+este+g_q+
               ' and   cbib='+g_q+cmbbiblioteca.Text+g_q+
               ' and   cclase='+g_q+cmbclase.Text+g_q)=false then begin
               Application.MessageBox(pchar(dm.xlng('ERROR... no puede actualizar registro a tsprog')),
                                      pchar(dm.xlng('Procesa archivos ')), MB_OK );
               ftsrecibe.Enabled:=true;
               screen.Cursor:=crdefault;
               exit;
            end;
         end
         else begin
            if dm.sqlinsert('insert into tsprog (cprog,cbib,cclase,fecha,cblob,magic,sistema) values ('+
               g_q+este+g_q+','+
               g_q+cmbbiblioteca.Text+g_q+','+
               g_q+cmbclase.Text+g_q+','+
               fecha+','+
               g_q+nblob+g_q+','+
               g_q+magic+g_q+','+
               g_q+cmbsistema.Text+g_q+')')=false then begin
               g_log.Add(dm.xlng('ftsrecibe.barchivoClick|'+cmbclase.Text+'|'+
                  cmbbiblioteca.Text+'|'+este+
                  '|ERROR... no puede agregar registro a tsprog'));
               Application.MessageBox(pchar(dm.xlng('ERROR... no puede agregar registro a tsprog')),
                                      pchar(dm.xlng('Procesa archivos ')), MB_OK );
               ftsrecibe.Enabled:=true;
               screen.Cursor:=crdefault;
               exit;
            end;
         end;
         idversion:=formatdatetime('YYYYMMDDHHNNSS',inicio);
         if dm.sqlinsert('insert into tsversion (cprog,cbib,cclase,fecha,cuser,cblob,magic) values ('+
            g_q+este+g_q+','+
            g_q+cmbbiblioteca.Text+g_q+','+
            g_q+cmbclase.Text+g_q+','+
            fecha+','+
            g_q+g_usuario+g_q+','+
            g_q+idversion+g_q+','+
            g_q+magic+g_q+')')=false then begin
            g_log.Add(dm.xlng('ftsrecibe.barchivoClick|'+cmbclase.Text+'|'+
               cmbbiblioteca.Text+'|'+este+
               '|ERROR... no puede agregar registro a tsversion'));
            Application.MessageBox(pchar(dm.xlng('ERROR... no puede agregar registro a tsversion')),
                                   pchar(dm.xlng('Procesa archivos ')), MB_OK );
            ftsrecibe.Enabled:=true;
            screen.Cursor:=crdefault;
            exit;
         end;
         try
            copyfile(pchar(dir.Directory+'\'+compos[i]),
                     pchar(dm.pathbib(cmbbiblioteca.Text)+'\'+este),
                     false);
         except
            g_log.Add(dm.xlng('ftsrecibe.barchivoClick|'+cmbclase.Text+'|'+
               cmbbiblioteca.Text+'|'+este+
               '|ERROR... no puede integrar a '+
               dm.pathbib(cmbbiblioteca.Text)+'\'+este));
            Application.MessageBox(pchar(dm.xlng('ERROR... no puede integrar a '+dm.pathbib(cmbbiblioteca.Text)+'\'+este)),
                                   pchar(dm.xlng('Procesa archivos ')), MB_OK );
            abort;
         end;
         try
            copyfile(pchar(dir.Directory+'\'+compos[i]),
                     pchar(dm.pathbib(cmbbiblioteca.Text)+'\versiones\'+este+'.'+idversion),
                     true);
         except
            g_log.Add(dm.xlng('ftsrecibe.barchivoClick|'+cmbclase.Text+'|'+
               cmbbiblioteca.Text+'|'+este+
               '|ERROR... no puede integrar a '+
               dm.pathbib(cmbbiblioteca.Text)+'\versiones\'+este+'.'+idversion));
            Application.MessageBox(pchar(dm.xlng('ERROR... no puede integrar a '+
                                   dm.pathbib(cmbbiblioteca.Text)+'\versiones\'+este+'.'+idversion)),
                                   pchar(dm.xlng('Procesa archivos ')), MB_OK );
            abort;
         end;
//NBLOB
         {
         if dm.sqlselect(dm.q1,'select * from tsrela '+
            ' where pcprog='+g_q+cmbclase.Text+g_q+
            ' and   pcbib='+g_q+cmbsistema.Text+g_q+
            ' and   pcclase='+g_q+'CLA'+g_q+
            ' and   hcprog='+g_q+este+g_q+
            ' and   hcbib='+g_q+cmbbiblioteca.Text+g_q+
            ' and   hcclase='+g_q+cmbclase.Text+g_q+
            ' and   orden='+g_q+'0001'+g_q)=false then begin
            if dm.sqlinsert('insert into tsrela (pcprog,pcbib,pcclase,hcprog,hcbib,hcclase,orden) values ('+
               g_q+cmbclase.Text+g_q+','+
               g_q+cmbsistema.Text+g_q+','+
               g_q+'CLA'+g_q+','+
               g_q+este+g_q+','+
               g_q+cmbbiblioteca.Text+g_q+','+
               g_q+cmbclase.Text+g_q+','+
               g_q+'0001'+g_q+')')=false then begin
               showmessage('ERROR... no puede agregar registro a tsrela');
               ftsrecibe.Enabled:=true;
               screen.Cursor:=crdefault;
               exit;
            end;
         end;
         }
         dm.sqldelete('delete tsrela where ocprog='+g_q+este+g_q+
            ' and ocbib='+g_q+cmbbiblioteca.Text+g_q+
            ' and occlase='+g_q+cmbclase.Text+g_q);
         //OWNER------ el siguiente select ya no se necesita, pero se deja por las versiones anteriores
         if dm.sqlselect(dm.q1,'select * from tsrela '+
            ' where pcprog='+g_q+cmbclase.Text+g_q+
            ' and   pcbib='+g_q+cmbsistema.Text+g_q+
            ' and   pcclase='+g_q+'CLA'+g_q+
            ' and   hcprog='+g_q+este+g_q+
            ' and   hcbib='+g_q+cmbbiblioteca.Text+g_q+
            ' and   hcclase='+g_q+cmbclase.Text+g_q+
            ' and   orden='+g_q+'0001'+g_q)=false then begin
         //OWNER------//
            dm.sqlinsert('insert into tsrela (pcprog,pcbib,pcclase,hcprog,hcbib,'+
               'hcclase,coment,orden,sistema,ocprog,ocbib,occlase) values ('+
               g_q+cmbclase.Text+g_q+','+
               g_q+cmbsistema.Text+g_q+','+
               g_q+'CLA'+g_q+','+
               g_q+este+g_q+','+
               g_q+cmbbiblioteca.Text+g_q+','+
               g_q+cmbclase.Text+g_q+','+
               g_q+g_q+','+        // si ypath no es visible, debe estar vacia "dbase"
               g_q+'0001'+g_q+','+
               g_q+g_sistema_actual+g_q+','+
               g_q+este+g_q+','+
               g_q+cmbbiblioteca.Text+g_q+','+
               g_q+cmbclase.Text+g_q+')');
         end;
         dm.sqlupdate('update tsrela set hcbib='+g_q+cmbbiblioteca.Text+g_q+  // actualiza componentes SCRATCH
            ' where hcprog='+g_q+este+g_q+
            ' and   hcbib='+g_q+'SCRATCH'+g_q+
            ' and   hcclase='+g_q+cmbclase.Text+g_q);
         dm.sqlupdate('update tsrela set hcbib='+g_q+cmbbiblioteca.Text+g_q+  // actualiza componentes SCRATCH y clase XXX
            ', hcclase='+g_q+cmbclase.Text+g_q+
            ' where hcprog='+g_q+este+g_q+
            ' and   hcbib='+g_q+'SCRATCH'+g_q+
            ' and   hcclase='+g_q+'XXX'+g_q);
         copiado:=g_tmpdir+'\'+este;
         if fileexists(copiado) then
            dm.ejecuta_espera('attrib -r '+copiado,SW_HIDE);
         //--- Analiza --------------------------------------------
         if (chkanaliza.Checked) and (cla_tipo='ANALIZABLE') then begin
            chdir(g_tmpdir);
            if (yextra.Visible) and (chkextra.Checked) and (b_extra=false) then begin
               extrapars:='';
               if application.MessageBox(
                  pchar('Procesará con los parámetros extra:['+txtextra.Text+'] Correcto?'),
                  'Confirme',MB_OKCANCEL)=IDCANCEL then exit;
               b_extra:=true;
               dm.sqldelete('delete parametro '+
                  ' where clave='+g_q+'EXTRA_MINING_'+cmbclase.Text+g_q);
               dm.sqlinsert('insert into parametro (CLAVE,SECUENCIA,DATO,DESCRIPCION) '+
                  ' values('+g_q+'EXTRA_MINING_'+cmbclase.Text+g_q+',1,'+
                  g_q+trim(txtextra.Text)+g_q+','+
                  g_q+'PARAMETROS EXTRA PARA LA MINERIA (CASO TANDEM)'+g_q+')');
               extrapars:=txtextra.Text;
            end;
            //>>>>>>>> aqui cambiar diagonales por puntos RGM
            if herramienta='RGMLANG' then begin
               if cmbclase.Text='FMB' then   // FORMA ORACLE DEVELOPER 2000
                  dm.ejecuta_espera(fmbanalizador+' '+
                     dir.Directory+'\'+compos[i]+' '+copiado,SW_HIDE)
               else begin
                  copyfile(pchar(dir.Directory+'\'+compos[i]),
                           pchar(copiado),false);
               end;
               g_borrar.Add(copiado);
               dm.ejecuta_espera(analizador+' '+
                  copiado+' '+g_tmpdir+'\source.new '+
                  directivas+' '+reservadas+' '+
                  basenombre+' >'+g_tmpdir+'\nada.txt',SW_HIDE);
            end
            else
               dm.ejecuta_espera(analizador+' '+
                  cmbclase.Text+' "'+dir.Directory+'\'+compos[i]+'" '+cmboficina.Text+
                  ' '+cmbbiblioteca.Text+' '+este+' '+'321432'+' '+extrapars+' >'+g_tmpdir+'\nada.txt',SW_HIDE);
            rxfc.Lines.LoadFromFile(g_tmpdir+'\nada.txt');
            g_borrar.Add(g_tmpdir+'\nada.txt');
            if (chkruta.checked=false) and (cmbclase.text<>'TDC') and (cmbclase.text<>'STP') then begin  // TANDEM C
               rxfc.Text:=uppercase(rxfc.Text);
            end;
            {
            dm.RunDosInMemo(analizador+' '+cmbclase.Text+' '+archivo.FileName+
               ' '+cmboficina.Text+' '+cmbbiblioteca.Text+' '+este+' '+analizablob,mm);
            }
            if pos('ERROR...',rxfc.Text)>0 then begin
 //rgm2009              showmessage(copy(rxfc.Text,pos('ERROR...',rxfc.Text),100));
               g_log.add('ftsrecibe.barchivoClick|'+
                  cmboficina.Text+'|'+cmbsistema.Text+'|'+cmbclase.Text+'|'+
                  cmbbiblioteca.Text+'|'+este+'|'+
                  copy(rxfc.Text,pos('ERROR...',rxfc.Text),100));
               barra.StepIt;
               continue;
            end;
            //OWNER------ lo siguiente ya no se necesita, pero se deja por las versiones anteriores
            if dm.sqlselect(dm.q1,'select * from tsrela '+
               ' where pcprog='+g_q+este+g_q+
               ' and   pcbib='+g_q+cmbbiblioteca.Text+g_q+
               ' and   pcclase='+g_q+cmbclase.Text+g_q+
               ' and   hcclase in '+
               '('+g_q+'STE'+g_q+                        // borra pasos de JCLs y JOBs
               ','+g_q+'ETP'+g_q+                        //       Entry Points
               ','+g_q+'DFX'+g_q+                        //       objetos forma Delphi
               ','+g_q+'DFY'+g_q+')') then begin         //       rutinas prog Delphi
               while not dm.q1.Eof do begin
                  dm.sqldelete('delete from tsrela '+
                     ' where pcprog='+g_q+dm.q1.fieldbyname('hcprog').AsString+g_q+
                     ' and   pcbib='+g_q+dm.q1.fieldbyname('hcbib').AsString+g_q+
                     ' and   pcclase='+g_q+dm.q1.fieldbyname('hcclase').AsString+g_q);
                  dm.q1.Next;
               end;
            end;
            dm.sqldelete('delete from tsrela '+
               ' where pcprog='+g_q+este+g_q+
               ' and   pcbib='+g_q+cmbbiblioteca.Text+g_q+
               ' and   pcclase='+g_q+cmbclase.Text+g_q);
            //OWNER------//
            if dm.analiza_componente(cmbclase.Text, cmbbiblioteca.Text,este,rxfc.Lines) then begin
            // rxfc.Lines.Clear;
                  dm.sqlupdate('update tsprog set analizado='+g_q+idversion+g_q+
               ' where cprog='+g_q+este+g_q+
               ' and cbib='+g_q+cmbbiblioteca.Text+g_q);
            end
            else begin
               g_log.add('ftsrecibe.barchivoClick|'+
                  cmboficina.Text+'|'+cmbsistema.Text+'|'+cmbclase.Text+'|'+
                  cmbbiblioteca.Text+'|'+este+'|'+'ERROR... analiza_componente');
               barra.StepIt;
               continue;
            end;
            dm.alta_resumen(este,cmbbiblioteca.Text,cmbclase.Text);
            dm.alta_atributo(este,cmbbiblioteca.Text,cmbclase.Text);
            if dm.sqlselect(dm.q1,'select distinct hcbib,hcprog from tsrela where ocprog='+g_q+este+g_q+  // actualiza componentes SCRATCH y clase ETP
               ' and ocbib='+g_q+cmbbiblioteca.Text+g_q+                                                 // checa contra hijos porque la rutina puede no tener hijos
               ' and occlase='+g_q+cmbclase.Text+g_q+
               ' and hcclase='+g_q+'ETP'+g_q+
               ' and hcbib<>'+g_q+'SCRATCH'+g_q) then begin
               while not dm.q1.Eof do begin
                  dm.sqlupdate('update tsrela set hcbib='+g_q+dm.q1.fieldbyname('hcbib').AsString+g_q+
                     ' where hcclase='+g_q+'ETP'+g_q+
                     ' and   hcbib='+g_q+'SCRATCH'+g_q+
                     ' and   hcprog='+g_q+dm.q1.fieldbyname('hcprog').AsString+g_q);
                  dm.q1.Next;
               end;
            end;
            if dm.sqlselect(dm.q1,'select * from tsrela where ocprog='+g_q+este+g_q+  // actualiza componentes SCRATCH y clase ETP
               ' and ocbib='+g_q+cmbbiblioteca.Text+g_q+
               ' and occlase='+g_q+cmbclase.Text+g_q+
               ' and pcclase='+g_q+'BFR'+g_q+
               ' and organizacion='+g_q+'BFR'+g_q) then begin
               while not dm.q1.Eof do begin
                  dm.sqlupdate('update tsrela set hcbib='+g_q+dm.q1.fieldbyname('pcbib').AsString+g_q+','+
                     ' hcprog='+g_q+dm.q1.fieldbyname('pcprog').AsString+g_q+
                     ' where hcclase='+g_q+'BFR'+g_q+
                     ' and   hcbib='+g_q+'SCRATCH'+g_q+
                     ' and   hcprog='+g_q+dm.q1.fieldbyname('hcprog').AsString+g_q);
                  dm.q1.Next;
               end;
            end;            
         end;
         if chkparams.Checked then begin
            copyfile(pchar(dir.Directory+'\'+compos[i]),pchar(copiado),false);
            if cmbclase.Text='JOB' then begin
               tsparams_job(este,cmbbiblioteca.Text,copiado);
            end;
            if cmbclase.Text='JCL' then begin
               tsparams_jcl(este,cmbbiblioteca.Text);
            end;
         end;
         if chkgoogle.Checked then begin   // Search de palabras
            procesa_busqueda(cmbclase.Text, cmbbiblioteca.Text,este,
               dir.Directory+'\'+compos[i]);
         end;
         barra.StepIt;
   end;
   fin:=now;
   dm.sqldelete('delete from parametro '+ // guarda ultimo directorio de donde se cargó
      ' where clave='+g_q+'dir_'+cmbsistema.Text+'_'+cmbclase.Text+'_'+cmbbiblioteca.Text+g_q);
   dm.sqlinsert('insert into parametro (clave,secuencia,dato) values('+
      g_q+'dir_'+cmbsistema.Text+'_'+cmbclase.Text+'_'+cmbbiblioteca.Text+g_q+',1,'+
      g_q+dir.Directory+g_q+')');
   dm.sqldelete('delete from parametro '+ // guarda ultimo directorio de donde se cargó
      ' where clave='+g_q+'mask_'+cmbsistema.Text+'_'+cmbclase.Text+'_'+cmbbiblioteca.Text+g_q);
   if trim(txtsufijo.Text)<>'' then
      dm.sqlinsert('insert into parametro (clave,secuencia,dato) values('+
         g_q+'mask_'+cmbsistema.Text+'_'+cmbclase.Text+'_'+cmbbiblioteca.Text+g_q+',1,'+
         g_q+txtsufijo.Text+g_q+')');
   if chkextra.Visible then begin
      if chkextra.Checked then verdad:='TRUE'
      else                     verdad:='FALSE';
      dm.sqlinsert('insert into parametro (clave,secuencia,dato) values('+
         g_q+'chkextra_'+cmbsistema.Text+'_'+cmbclase.Text+'_'+cmbbiblioteca.Text+g_q+',1,'+
         g_q+verdad+g_q+')');
   end;
   if chkruta.Visible then begin
      if chkruta.Checked then verdad:='TRUE'
      else                     verdad:='FALSE';
      dm.sqlinsert('insert into parametro (clave,secuencia,dato) values('+
         g_q+'chkruta_'+cmbsistema.Text+'_'+cmbclase.Text+'_'+cmbbiblioteca.Text+g_q+',1,'+
         g_q+verdad+g_q+')');
   end;
   if chkextension.Visible then begin
      if chkextension.Checked then verdad:='TRUE'
      else                     verdad:='FALSE';
      dm.sqlinsert('insert into parametro (clave,secuencia,dato) values('+
         g_q+'chkextension_'+cmbsistema.Text+'_'+cmbclase.Text+'_'+cmbbiblioteca.Text+g_q+',1,'+
         g_q+verdad+g_q+')');
   end;
   {
   if chkruta.checked then begin
      dm.sqldelete('delete from parametro '+ // guarda ultimo directorio de donde se cargó
         ' where clave='+g_q+'nodo_'+cmbclase.Text+'_'+cmbbiblioteca.Text+g_q);
      dm.sqlinsert('insert into parametro (clave,secuencia,dato) values('+
         g_q+'nodo_'+cmbclase.Text+'_'+cmbbiblioteca.Text+g_q+',1,'+
         g_q+dir.Directory+g_q+')');
   end;
   }
   barra.Visible:=false;
   tsprog.close;
   tsprog.Open;
   abre_cierra_tsversion;
   ftsrecibe.Enabled:=true;
   screen.Cursor:=crdefault;
   deletefile(reservadas);
   deletefile(analizador);
   deletefile(g_ruta+'nada.txt');
   deletefile(g_ruta+'source.new');
   if (compos.Count>1) and (b_todos=false) then begin
      i:=secondsbetween(fin,inicio);
      mens:=dm.xlng(inttostr(compos.Count)+' archivos procesados en '+
         inttostr(i div 3600)+' Hrs '+
         inttostr((i mod 3600) div 60)+' Min '+
         inttostr((i mod 3600) mod 60)+' Seg ');
      g_log.add('ftsrecibe.barchivoClick|'+
         cmboficina.Text+'|'+cmbsistema.Text+'|'+cmbclase.Text+'|'+
         cmbbiblioteca.Text+'|'+dir.Directory+'|'+mens);
      Application.MessageBox(pchar(dm.xlng(mens)),
                             pchar(dm.xlng('Procesar archivos ')), MB_OK );
   end;

   compos.Free;
end;
procedure Tftsrecibe.abre_cierra_tsversion;
begin
   tsversion.Close;
   tsversion.SQL.Clear;
   tsversion.SQL.Add('select cprog,cbib,cclase,fecha,cuser,tsversion.cblob,magic from tsversion '+
      ' where cprog='+g_q+nombre_componente(archivo_master)+g_q+
      ' and   cbib='+g_q+cmbbiblioteca.Text+g_q+
      ' and   cclase='+g_q+cmbclase.Text+g_q+
      ' order by fecha desc');
   tsversion.Open;
end;
procedure Tftsrecibe.archivoClick(Sender: TObject);
var nombre:string;
begin
   if sender is Tfilelistbox then begin
      if trim(archivo.FileName)='' then exit;
      rxfuente.Lines.LoadFromFile(archivo.FileName);
      habilita;
      archivo_master:=archivo.FileName;
      pie.Caption:=inttostr(archivo.SelCount)+' archivos seleccionados';
   end;
   if sender is Tlistbox then begin
      nombre:=lbxarchivo.Items[lbxarchivo.itemindex];
      if trim(nombre)='' then exit;
      rxfuente.Lines.LoadFromFile(dir.Directory+'\'+nombre);
      habilita;
      nombre:=stringreplace(nombre,'/','.',[rfreplaceall]);
      nombre:=stringreplace(nombre,'\','.',[rfreplaceall]);
      archivo_master:=nombre;
      pie.Caption:=inttostr(lbxarchivo.SelCount)+' archivos seleccionados';
   end;
   if barchivo.Enabled or (sender is TDBGRID) then begin
      abre_cierra_tsversion;
   end;
end;

procedure Tftsrecibe.gtsprogCellClick(Column: TColumn);
begin
//   dm.blob2memo(tsprog.fieldbyname('cblob').AsString,rxfuente);
   archivo_master:=tsprog.fieldbyname('cprog').AsString;
   archivoclick(gtsprog);
end;

procedure Tftsrecibe.gtsversionCellClick(Column: TColumn);
begin
//   dm.blob2memo(tsversion.fieldbyname('cblob').AsString,rxfuente);
end;
procedure Tftsrecibe.comparafuente(Sender: TObject);
var ite:Tmenuitem;
    hta,versio,tempo,coma:string;
begin
   ite:=sender as Tmenuitem;
   hta:=g_tmpdir+'\svshtacom'+formatdatetime('YYMMDDHHNNSS',now)+'.exe';
   dm.get_utileria('COMPARACION DE FUENTES',hta);
   tempo:=stringreplace(ite.Caption,':','',[rfreplaceall]);
   tempo:=stringreplace(tempo,' ','',[rfreplaceall]);
   tempo:=stringreplace(tempo,'/','',[rfreplaceall]);
   tempo:=stringreplace(tempo,'&','',[rfreplaceall]);
   versio:=dm.pathbib(cmbbiblioteca.Text)+'\versiones\'+nombre_componente(archivo_master)+'.'+tempo;
   tempo:=g_tmpdir+'\svs'+tempo;
   copyfile(pchar(versio),pchar(tempo),false);
   g_borrar.Add(tempo);
   if archivo_master<>archivo.FileName then begin   // determina si se archivo o biblioteca
      coma:=g_tmpdir+'\'+archivo_master+'_prd';
      copyfile(pchar(bib_dir+'\'+archivo_master),pchar(coma),false);
      g_borrar.Add(coma);
      coma:=coma+' '+tempo;
   end
   else
      coma:='"'+archivo.FileName+'" '+tempo;
   if ShellExecute(Handle, nil,pchar(hta),pchar(coma), nil, SW_SHOW) <= 32 then
      Application.MessageBox(pchar(dm.xlng('No puede ejecutar la comparacion')),
         pchar(dm.xlng('Error')), MB_ICONEXCLAMATION);
end;
procedure Tftsrecibe.eliminacomponente(Sender: TObject);
var clase,bib,nombre,blo:string;
begin
   clase:=tsprog.fieldbyname('cclase').AsString;
   bib:=tsprog.fieldbyname('cbib').AsString;
   nombre:=tsprog.fieldbyname('cprog').AsString;
   blo:=tsprog.fieldbyname('cblob').AsString;
   // NBLOB faltaba dm.sqldelete('delete from tsblob where cblob='+g_q+blo+g_q);
   {    Ya no es necesario, por el uso de OWNER
   if dm.sqlselect(dm.q1,'select * from tsrela '+  // borra pasos de JCLs y JOBs
      ' where pcprog='+g_q+nombre+g_q+
      ' and   pcbib='+g_q+bib+g_q+
      ' and   pcclase='+g_q+clase+g_q+
      ' and   hcclase='+g_q+'STE'+g_q) then begin
      while not dm.q1.Eof do begin
         dm.sqldelete('delete from tsrela '+
            ' where pcprog='+g_q+dm.q1.fieldbyname('hcprog').AsString+g_q+
            ' and   pcbib='+g_q+dm.q1.fieldbyname('hcbib').AsString+g_q+
            ' and   pcclase='+g_q+dm.q1.fieldbyname('hcclase').AsString+g_q);
         dm.q1.Next;
      end;
   end;
   dm.sqldelete('delete tsrela '+
      ' where pcprog='+g_q+nombre+g_q+
      ' and   pcbib='+g_q+bib+g_q+
      ' and   pcclase='+g_q+clase+g_q);
   dm.sqldelete('delete tsrela '+
      ' where pcprog='+g_q+cmbclase.Text+g_q+
      ' and   pcbib='+g_q+cmbsistema.Text+g_q+
      ' and   pcclase='+g_q+'CLA'+g_q+
      ' and   hcprog='+g_q+nombre+g_q+
      ' and   hcbib='+g_q+bib+g_q+
      ' and   hcclase='+g_q+clase+g_q+
      ' and   orden='+g_q+'0001'+g_q);
   }
   dm.sqldelete('delete tsrela '+
      ' where ocprog='+g_q+nombre+g_q+
      ' and   ocbib='+g_q+bib+g_q+
      ' and   occlase='+g_q+clase+g_q);
   dm.sqldelete('delete from tsprog '+
      ' where cprog='+g_q+nombre+g_q+
      ' and   cbib='+g_q+bib+g_q+
      ' and   cclase='+g_q+clase+g_q);
   dm.sqlupdate('update tsrela set hcbib='+g_q+'SCRATCH'+g_q+
      ' where hcprog='+g_q+nombre+g_q+
      ' and   hcbib='+g_q+bib+g_q+
      ' and   hcclase='+g_q+clase+g_q);
   tsprog.close;
   tsprog.Open;
end;
procedure Tftsrecibe.cmbclaseClick(Sender: TObject);
begin
   chkanaliza.Enabled:=false;
   if dm.sqlselect(dm.q1,'select * from tsclase '+
      ' where cclase='+g_q+cmbclase.Text+g_q) then begin
      chkanaliza.Enabled:=(dm.q1.fieldbyname('tipo').asstring='ANALIZABLE');
      herramienta:=dm.q1.fieldbyname('analizador').asstring;
   end;
   {
   if dm.sqlselect(dm.q1,'select * from parametro '+
      ' where clave='+g_q+'dir_'+cmbclase.Text+'_'+cmbbiblioteca.Text+g_q) then begin
      if directoryexists(dm.q1.fieldbyname('dato').AsString) then begin
         dir.Directory:=dm.q1.fieldbyname('dato').AsString;
      end;
   end;
   }
   if trim(txtsufijo.Text)='' then
      txtsufijo.Text:='*.'+cmbclase.Text;
   chkanaliza.Checked:=chkanaliza.Enabled;
end;

procedure Tftsrecibe.poparchivoPopup(Sender: TObject);
var ite:Tmenuitem;
   dbg:Tdbgrid;
   fil:Tfilelistbox;
begin
   if tsprog.Active=false then exit;
   if poparchivo.PopupComponent is Tfilelistbox then begin
      fil:=(poparchivo.PopupComponent as Tfilelistbox);
      fil.OnClick(archivo);
   end;
   if poparchivo.PopupComponent is TDBGrid then begin
      dbg:=(poparchivo.PopupComponent as TDBGrid);
      dbg.OnCellClick(dbg.Columns[0]);
   end;
   poparchivo.Items.Clear;
   ite:=Tmenuitem.Create(self);
   ite.Caption:=dm.xlng('['+archivo_master+'] Compara con:');
   poparchivo.Items.Add(ite);
   ite:=Tmenuitem.Create(self);
   ite.Caption:='-';
   poparchivo.Items.Add(ite);
   tsversion.First;
   while not tsversion.Eof do begin
      ite:=Tmenuitem.Create(self);
      ite.Caption:=formatdatetime('YYYY/MM/DD HH:NN:SS',tsversion.fieldbyname('fecha').asdatetime);
      ite.Hint:=tsversion.fieldbyname('cblob').AsString;
      ite.OnClick:=comparafuente;
      poparchivo.Items.Add(ite);
      tsversion.Next;
   end;
   tsversion.First;
   ite:=Tmenuitem.Create(self);
   ite.Caption:='-';
   poparchivo.Items.Add(ite);
   if poparchivo.PopupComponent is TDBGrid then begin
      if tsprog.RecordCount=0 then
         exit;
      ite:=Tmenuitem.Create(self);
      ite.Caption:=dm.xlng('ELIMINAR');
      ite.Hint:=dm.xlng('Elimina el componente de la Base de Conocimiento');
      ite.OnClick:=eliminacomponente;
      poparchivo.Items.Add(ite);
   end;
end;

procedure Tftsrecibe.bsalirClick(Sender: TObject);
begin
   close;
end;

procedure Tftsrecibe.blogClick(Sender: TObject);
begin
   rxfuente.Clear;
   rxfuente.Lines.AddStrings(g_log);
end;

procedure Tftsrecibe.Splitter6Moved(Sender: TObject);
begin
   cmbbiblioteca.Width:=groupbox2.Width-20;
end;

procedure Tftsrecibe.chkrutaClick(Sender: TObject);
begin
   if chkruta.Checked then begin
      lbxarchivo.Visible:=true;
      lbxarchivo.Items.Clear;
      if (length(dir.Directory)=3) and (copy(dir.Directory,2,2)=':\') then exit;  // si está en Raiz "c:\"
      Adddirectories(dir.Directory,lbxarchivo,txtsufijo.Text);
   end
   else begin
      lbxarchivo.Visible:=false;
   end;
end;

procedure Tftsrecibe.AddDirectories(cPath: string; lista:Tlistbox; mascara:string);
var   sr,fl: TSearchRec;
   dirattrs,FileAttrs: Integer;
begin
   FileAttrs := faArchive;
   if FindFirst(cPath+'\'+mascara, FileAttrs, fl) = 0 then begin
      repeat
         // if ((fl.Attr and faArchive) = fl.Attr) then begin
         if ((fl.Attr and faArchive)<>0) then begin
            if cPath=dir.Directory then
               lista.Items.Add(fl.Name)
            else
               lista.Items.Add(copy(cPath,length(dir.Directory)+2,500)+'\'+fl.Name);
         end;
      until FindNext(fl) <> 0;
      FindClose(fl);
   end;
   dirAttrs := faDirectory;
   if FindFirst(cPath+'\*.*', dirAttrs, sr) = 0 then begin
      repeat
         if ((sr.Attr and faDirectory) = sr.Attr) and (copy(sr.Name,1,1) <> '.') then begin
            AddDirectories(cPath+'\'+sr.Name, lista, mascara);
         end;
      until FindNext(sr) <> 0;
      FindClose(sr);
   end;
end;
procedure Tftsrecibe.dirMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   if chkruta.Checked then begin
      lbxarchivo.Visible:=true;
      lbxarchivo.Items.Clear;
      if (length(dir.Directory)=3) and (copy(dir.Directory,2,2)=':\') then exit;
      Adddirectories(dir.Directory,lbxarchivo,txtsufijo.Text);
   end;     
end;

procedure Tftsrecibe.butileriaClick(Sender: TObject);
begin
   PR_UTILERIA;
end;

procedure Tftsrecibe.chkextraClick(Sender: TObject);
begin
   txtextra.Enabled:=chkextra.Checked;
end;

procedure Tftsrecibe.chktodasClick(Sender: TObject);
begin
   if (chktodas.Checked=false) and (trim(cmbbiblioteca.Text)='') and (trim(cmbclase.Text)<>'') then
      dm.feed_combo(cmbbiblioteca,'select distinct cbib from tsprog where cclase='+g_q+cmbclase.Text+g_q+' order  by cbib')
   else
      dm.feed_combo(cmbbiblioteca,'select cbib from tsbib order by cbib');
end;

procedure Tftsrecibe.btodoClick(Sender: TObject);
var i:integer;
begin
   if application.MessageBox('Procesará todas las librerias listadas, correcto?','Confirme',MB_YESNO)=IDNO then exit;
   b_todos:=true;
   for i:=0 to cmbbiblioteca.Items.Count-1 do begin
      cmbbiblioteca.ItemIndex:=i;
      cmbsistemachange(sender);
      bseltodoClick(Sender);
      if barchivo.Enabled then
         barchivoclick(sender);
   end;
   b_todos:=false;
end;

end.
