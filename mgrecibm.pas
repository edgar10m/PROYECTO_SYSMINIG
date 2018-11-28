unit mgrecibm;

interface

uses
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   ComCtrls, StdCtrls, Buttons, ExtCtrls, FileCtrl, RxRichEd, Db, DBTables,
   ImgList, Menus;

type
   arbol = record
      tipo: string;
      nombre: string;
      ptipo: string;
      pnombre: string;
   end;
type
   Tfmgrecibm = class( TForm )
      PageControl1: TPageControl;
      TabSheet1: TTabSheet;
      grbRecepcion: TGroupBox;
      GroupBox2: TGroupBox;
      GroupBox3: TGroupBox;
      Label2: TLabel;
      txtsufijo: TEdit;
      Label5: TLabel;
      txtsistema: TComboBox;
      Label1: TLabel;
      cmbt: TComboBox;
      Label6: TLabel;
      txtbiblioteca: TComboBox;
      Label4: TLabel;
      barchivo: TBitBtn;
      rxfc: TRxRichEdit;
      rxfuente: TRxRichEdit;
      lvux: TListView;
      lvver: TListView;
      Label8: TLabel;
      Label7: TLabel;
      Splitter1: TSplitter;
      Splitter2: TSplitter;
      Splitter3: TSplitter;
      Panel1: TPanel;
      Panel6: TPanel;
      Button1: TButton;
    pop: TPopupMenu;
    Splitter4: TSplitter;
    lvibm: TListView;
    Panel2: TPanel;
    cmblibreria: TComboBox;
    rghost: TRadioGroup;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label3: TLabel;
    Label9: TLabel;
    lblselec: TLabel;
    lblitems: TLabel;
      procedure FormCreate( Sender: TObject );
      procedure cmbtChange( Sender: TObject );
      procedure barchivoClick( Sender: TObject );
      procedure txtsistemaChange( Sender: TObject );
      procedure txtbibliotecaChange( Sender: TObject );
      procedure txtbibliotecaKeyPress( Sender: TObject; var Key: Char );
      procedure archivoDblClick( Sender: TObject );
      procedure lvuxClick( Sender: TObject );
      procedure Button1Click( Sender: TObject );
      procedure comparaunix(sender: Tobject);
    procedure popPopup(Sender: TObject);
    procedure lvuxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lvibmClick(Sender: TObject);
    procedure lvibmMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lvibmExit(Sender: TObject);
    procedure cmblibreriaChange(Sender: TObject);
    procedure cmblibreriaExit(Sender: TObject);
    procedure cmblibreriaClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
   private
    { Private declarations }
      nd: array of arbol;
      opcion: array of Tmenuitem;
      b_archivo:boolean;
      b_cambia:boolean;
      rutaibm:string;
      function integra: boolean;
      function agrega_al_menu( titulo: string ): integer;
      procedure cuenta_check;
//     procedure analiza_compo(tipo:string; nombre:string);
   public
    { Public declarations }
   end;

var
   b_nuevos: boolean;
   work_dir: string;
   fmgrecibm: Tfmgrecibm;
function PR_RECIBEHOST: boolean;

implementation
uses dm1, fconsole, mgdlg, mgdlgibm;
{$R *.DFM}

function PR_RECIBEHOST: boolean;
begin
   if PR_DLG = false then
      exit;
   if PR_DLGIBM = false then
      exit;

   Application.CreateForm( Tfmgrecibm, fmgrecibm );
   try
      b_nuevos := false;
      //dm.posforma( fmgrecibm ); //fca
      fmgrecibm.Showmodal;
      PR_RECIBEHOST := b_nuevos;

   finally
      fmgrecibm.Free;
   end;
end;
procedure Tfmgrecibm.FormCreate( Sender: TObject );
begin
   dm.feed_combo( txtsistema, 'select distinct re_padre_nombre from msvrela' +
      ' where re_padre_tipo=' + g_q + 'MOD' + g_q +
      ' order by re_padre_nombre' );
   if txtsistema.Items.Count = 1 then
      txtsistema.ItemIndex := 0;
end;
procedure Tfmgrecibm.cmbtChange( Sender: TObject );
var
   lista: Tstringlist;
   bib: string;
   i: integer;
begin
   txtbiblioteca.Enabled := ( trim( cmbt.text ) <> '' );
   if txtbiblioteca.Enabled then   begin
      txtbiblioteca.Items.Clear;
      if dm.sqlselect( dm.q1, 'select * from msvrela ' +
         ' where re_padre_tipo=' + g_q + 'MOD' + g_q +
         ' and re_padre_nombre=' + g_q + txtsistema.text + g_q +
         ' and re_hijo_tipo=' + g_q + 'CLA' + g_q +
         ' and re_coment=' + g_q + cmbt.Text + g_q ) then      begin
         if dm.sqlselect( dm.q2, 'select * from msvrela ' +
            ' where re_padre_tipo=' + g_q + 'CLA' + g_q +
            ' and re_padre_nombre=' + g_q + dm.q1.fieldbyname( 're_hijo_nombre' ).asstring + g_q +
            ' and re_hijo_tipo=' + g_q + cmbt.text + g_q +
            ' order by re_hijo_nombre' ) then         begin
            bib := '';
            lista := Tstringlist.Create;
            while not dm.q2.eof do
            begin
               dm.divide_string( dm.q2.fieldbyname( 're_hijo_nombre' ).asstring, '_', lista );
               if lista.Count > 1 then               begin
                  if bib <> lista[ 1 ] then                  begin
                     txtbiblioteca.Items.Add( uppercase( lista[ 1 ] ) );
                     bib := lista[ 1 ];
                  end;
               end;
               dm.q2.next;
            end;
            lista.Destroy;
         end;
      end;
      if txtbiblioteca.Items.Count = 1 then
         txtbiblioteca.ItemIndex := 0;
      dm.feed_combo( cmblibreria, 'select dato from parametro ' +
         ' where clave=' + g_q + copy( 'FYT' + cmbt.text + txtsistema.text, 1, 20 ) + g_q +
         ' order by secuencia desc');
      if dm.sqlselect(dm.q1,'select * from parametro '+
         ' where clave='+g_q+copy('FZT'+cmbt.Text+txtsistema.Text,1,20)+g_q)   then begin
         txtsufijo.Text:=dm.q1.fieldbyname( 'dato' ).asstring;
      end;

      if txtbiblioteca.Text = 'PGMLIB' then
         bib := 'pgmfte'
      else
         bib := lowercase( txtbiblioteca.Text );

      work_dir := g_dirftp + '/originales/' + lowercase( txtsistema.Text ) + '/' + bib;

      dm.muestra_unix( lvux, work_dir, '*.*' );
   end;
   barchivo.Enabled := ( ( cmbt.Text <> '' ) and
      ( trim( txtsistema.text ) <> '' ) and
      ( trim( txtbiblioteca.text ) <> '' ) );
end;

function Tfmgrecibm.integra: boolean;
var
   modulo, bib, // directorio fisico
      bibb, // segunda parte del nombre en sysview
      sufijo, // sufijo para el archivo temporal unix en la comparacion
      sufijoori, // sufijo con el que entregan los componentes
      mux, // nombre del archivo temporal que viene de Unix
      mpc, // nombre con path del archivo en PC
      fechahora, mensaje, rux // ruta en Unix donde quedara el archivo
      : string;
   b_nuevo: boolean;
   i,m: integer;
   paso: Tstringlist;
begin
 createdir( g_ruta + 'tmp' );
 chdir( g_ruta + 'tmp' );
 for m:=0 to lvibm.Items.Count-1 do begin
   if lvibm.Items[m].Checked=false then continue;
   mpc := lvibm.Items[m].Caption;
   dm.ftpibm.Get(mpc,mpc,true);
   modulo := lowercase( lvibm.Items[m].Caption );
   i:=pos('.',modulo);
   if i>0 then modulo:=copy(modulo,1,i-1);
   if cmbt.Text = 'ASE' then   begin
      bib := 'asefte';
      bibb := 'aselib';
      sufijo := 'ase';
      sufijoori := 'ase';
   end
   else
      if cmbt.Text = 'CBL' then      begin
         bib := 'pgmfte';
         bibb := 'pgmlib';
         sufijo := 'cbl';
         sufijoori := 'pgm';
      end
      else
         if cmbt.Text = 'CPY' then         begin
            bib := 'ddl';
            bibb := 'ddl';
            sufijo := '';
            sufijoori := 'cpy';
         end
         else
            if cmbt.Text = 'JOB' then            begin
               bib := 'proclib';
               bibb := 'proclib';
               sufijo := 'dis';
               sufijoori := 'dis';
            end
            else
               if cmbt.Text = 'JCL' then               begin
                  bib := 'proclib';
                  bibb := 'proclib';
                  sufijo := 'pro';
                  sufijoori := 'pro';
               end
         else
            if cmbt.Text = 'SVD' then            begin
               bib := 'proclib';
               bibb := 'proclib';
               sufijo := 'dis';
               sufijoori := 'dis';
            end
            else
               if cmbt.Text = 'SVP' then               begin
                  bib := 'proclib';
                  bibb := 'proclib';
                  sufijo := 'pro';
                  sufijoori := 'pro';
               end
               else
                  if cmbt.Text = 'NAT' then                  begin
                     bib := 'natfte';
                     bibb := 'natlib';
                     sufijo := 'nat';
                     sufijoori := 'nat';
                  end;
   mux := modulo + '.ux';
   rux := g_dirftp + '/originales/' + lowercase( txtsistema.Text ) + '/' + bib;
   if dm.direxistsunix( g_dirftp + '/originales/' +
       lowercase( txtsistema.Text ), bib ) = false then   begin // crea directorio en unix
      dm.ftp.MakeDir( g_dirftp + '/originales/' + lowercase( txtsistema.Text ) + '/' + bib );
      dm.ftp.MakeDir( g_dirftp + '/originales/' + lowercase( txtsistema.Text ) + '/' + bib +'/respaldos');
   end;
   b_nuevo := not dm.fileexistsunix( rux, modulo + '.' + sufijoori );
   if b_nuevo then   begin
      mensaje := '(' + modulo + ') Nuevo Módulo' + chr( 13 ) + 'Desea integrar?';
      rxfc.Lines.Clear;
      rxfc.Lines.Add( '********************************' );
      rxfc.Lines.Add( 'Nuevo Módulo:' );
      rxfc.Lines.Add( modulo );
      rxfc.Lines.Add( '********************************' );
   end
   else   begin
      mensaje := '(' + modulo + ') Diferente Versión' + chr( 13 ) + 'Desea integrar?';
      dm.ftp.Get( rux + '/' + modulo + '.' + sufijoori, mux, true );
      dm.ejecuta_espera( g_ruta + '\sistema\command.com /C ' +
         ' fc "' + mux + '" "' + mpc + '" >' + modulo + '.fc', sw_hide );
      rxfc.Lines.LoadFromFile( modulo + '.fc' );
   end;
   integra := false;
   if ( rxfc.Lines.Count > 3 ) then   begin
      if application.MessageBox( pchar( mensaje ), 'Aviso', MB_YESNO ) = IDYES then      begin
         // verifica que no sea una versión anterior
         paso := tstringlist.Create;
         for i := 0 to lvver.Items.Count - 1 do         begin
            dm.ftp.Get( rux + '/respaldos/' + lvver.Items[ i ].Caption, 'version_anterior', true );
            dm.ejecuta_espera( g_ruta + 'sistema\command.com /C ' +
               ' fc version_anterior' + ' ' + mpc + ' >ver_ant.fc', sw_hide );
            paso.LoadFromFile( 'ver_ant.fc' );
            if paso.Count < 4 then begin
               if application.MessageBox( pchar( 'Peligro: ' + chr( 13 ) +
                  ' El archivo ' + mpc +
                  ' es igual a la versión ' + lvver.Items[ i ].Caption +
                  ' Desea integrar el archivo?' ), 'Peligro', MB_YESNO ) = IDNO then
                  exit;
            end;
         end;
         paso.Free;
         fechahora := formatdatetime( 'YYYYMMDDHHMMSS', now );
         if b_nuevo = false then begin
            if dm.direxistsunix(rux, 'respaldos' ) = false then begin
               dm.ftp.MakeDir( rux + '/respaldos' );
            end;
            dm.ftp.put( mux, rux + '/respaldos/' + modulo + '.' + fechahora );
            dm.ftp.Delete( rux + '/' + modulo + '.' + sufijoori );
         end;
         dm.ftp.Put( mpc, rux + '/' + modulo + '.' + sufijoori );
         if directoryexists( g_ruta + 'originales\' + lowercase( txtsistema.Text ) + '\' + bib )=false then
            mkdir( g_ruta + 'originales\' + lowercase( txtsistema.Text ) + '\' + bib );
         copyfile( pchar( mpc ), pchar( g_ruta + 'originales\' + lowercase( txtsistema.Text ) + '\' + bib + '\' + modulo + '.' + sufijoori ), false );
         dm.sqlinsert( 'insert into mgrecep (sistema,tipo,nombre,ambiente,ruta,fecha,hora) ' +
            ' values(' + g_q + txtsistema.Text + g_q +
            ' ,' + g_q + cmbt.Text + g_q +
            ' ,' + g_q + lowercase( txtsistema.text ) + '_' + bibb + '_' + modulo + g_q +
            ' ,' + g_q + 'PC' + g_q +
            ' ,' + g_q + mpc + g_q +
            ' ,' + g_q + copy( fechahora, 1, 8 ) + g_q +
            ' ,' + g_q + copy( fechahora, 9, 6 ) + g_q + ')' );
         integra := true;
      end;
   end;
 end;
 chdir( g_ruta );
end;

procedure Tfmgrecibm.barchivoClick( Sender: TObject );
var i:integer;
begin
   if integra then   begin
      dm.muestra_unix( lvux, work_dir, '*.*' );
      dm.sqldelete( 'delete from parametro ' +
         ' where clave=' + g_q + copy( 'FYT' + cmbt.text + txtsistema.text, 1, 20 ) + g_q );
      i:=cmblibreria.Items.IndexOf(cmblibreria.Text);
      if i>-1 then cmblibreria.Items.Delete(i);
      cmblibreria.Items.Insert(0,cmblibreria.Text);
      for i:=1 to cmblibreria.Items.Count do
         dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values' +
            '(' + g_q + copy( 'FYT' + cmbt.text + txtsistema.text, 1, 20 ) + g_q +
            ','+inttostr(i)+',' + g_q + cmblibreria.Text+ g_q + ')' );
      dm.sqldelete( 'delete from parametro ' +
         ' where clave=' + g_q + copy( 'FZT' + cmbt.text + txtsistema.text, 1, 20 ) + g_q );
      dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values' +
         '(' + g_q + copy( 'FZT' + cmbt.text + txtsistema.text, 1, 20 ) + g_q +
         ',1,' + g_q + txtsufijo.Text+ g_q + ')' );
//   analiza_compo(cmbt.text,archivo.FileName);
   end;
end;

procedure Tfmgrecibm.txtsistemaChange( Sender: TObject );
var
   fecha, tipo, dir, hora: string;
   tot: integer;
begin
   cmbt.Enabled := ( trim( txtsistema.text ) <> '' );
   if cmbt.Enabled then
   begin
      dm.feed_combo( cmbt, 'select distinct re_coment from msvrela ' +
         ' where re_padre_tipo=' + g_q + 'MOD' + g_q +
         ' and re_padre_nombre=' + g_q + txtsistema.text + g_q +
         ' order by re_coment' );
      if cmbt.items.Count = 1 then
         cmbt.ItemIndex := 0;
      // checa ultimas entregas
      rxfc.Lines.Clear;
      rxfc.Lines.Add( '  Resumen de últimas recepciones' );
      if dm.sqlselect( dm.q1, 'select * from mgrecep ' +
         ' where sistema=' + g_q + trim( txtsistema.Text ) + g_q +
         ' order by fecha desc,hora desc' ) then
      begin
         fecha := dm.q1.fieldbyname( 'fecha' ).asstring;
         tipo := dm.q1.fieldbyname( 'tipo' ).asstring;
         dir := extractfilepath( dm.q1.fieldbyname( 'ruta' ).asstring );
         hora := copy( dm.q1.fieldbyname( 'hora' ).asstring, 1, 4 );
         tot := 0;
         while not dm.q1.Eof do
         begin
            if ( fecha <> dm.q1.fieldbyname( 'fecha' ).asstring ) or
               ( tipo <> dm.q1.fieldbyname( 'tipo' ).asstring ) or
               ( dir <> extractfilepath( dm.q1.fieldbyname( 'ruta' ).asstring ) ) then
            begin
               rxfc.Lines.Add( fecha + ' ' + hora + dm.lpad( ' ', 5, tipo ) +
                  dm.lpad( ' ', 5, inttostr( tot ) ) + '  ' + dir );
               fecha := dm.q1.fieldbyname( 'fecha' ).asstring;
               tipo := dm.q1.fieldbyname( 'tipo' ).asstring;
               dir := extractfilepath( dm.q1.fieldbyname( 'ruta' ).asstring );
               hora := copy( dm.q1.fieldbyname( 'hora' ).asstring, 1, 4 );
               tot := 0;
            end;
            tot := tot + 1;
            dm.q1.Next;
         end;
         rxfc.Lines.Add( fecha + ' ' + hora + dm.lpad( ' ', 5, tipo ) +
            dm.lpad( ' ', 5, inttostr( tot ) ) + '  ' + dir );
      end;
   end;
{   barchivo.Enabled := ( ( archivo.ItemIndex > -1 ) and
      ( cmbt.Text <> '' ) and
      ( trim( txtsistema.text ) <> '' ) and
      ( trim( txtbiblioteca.text ) <> '' ) );
   }
end;

procedure Tfmgrecibm.txtbibliotecaChange( Sender: TObject );
begin
{   barchivo.Enabled := ( ( archivo.ItemIndex > -1 ) and
      ( cmbt.Text <> '' ) and
      ( trim( txtsistema.text ) <> '' ) and
      ( trim( txtbiblioteca.text ) <> '' ) );
      }
end;

procedure Tfmgrecibm.txtbibliotecaKeyPress( Sender: TObject;
   var Key: Char );
begin
   key := dm.mayusculas( key );
end;

procedure Tfmgrecibm.archivoDblClick( Sender: TObject );
begin
   if barchivo.Enabled then
      barchivoclick( sender );
end;


procedure Tfmgrecibm.lvuxClick( Sender: TObject );
var
   modu: string;
begin
   if lvux.ItemIndex = -1 then
      exit;
   modu := copy( lvux.Items[ lvux.itemindex ].Caption,
      1, pos( '.', lvux.Items[ lvux.itemindex ].Caption ) - 1 );
   if dm.direxistsunix( work_dir, 'respaldos' ) then
   begin
      dm.muestra_unix( lvver, work_dir + '/respaldos', modu + '.*' );
   end
   else begin
      dm.ftp.MakeDir( work_dir+'/respaldos' );
   end;
end;

procedure Tfmgrecibm.Button1Click( Sender: TObject );
begin
   Close;
end;

procedure Tfmgrecibm.comparaunix( sender:Tobject);
var nuevo,produ,respa:string;
begin
   createdir( g_ruta + 'tmp' );
   chdir( g_ruta + 'tmp' );
   nuevo:=stringreplace(pop.Items[0].Caption,'&','',[rfreplaceall]);
   if pop.tag=0 then begin
      nuevo:=lvux.Selected.Caption;
      dm.ftp.Get( work_dir+'/'+nuevo, nuevo, true );
   end;
   respa:=stringreplace((sender as Tmenuitem).Caption,'&','',[rfreplaceall]);
   try
      dm.ftp.Get( work_dir+'/respaldos/'+respa, respa, true );
   except
      dm.ftp.Get( work_dir+'/'+respa, respa, true );
   end;
   dm.ejecuta_espera( g_ruta + 'sistema\examdiff.exe "' +
      nuevo+ '" "'+respa+'"',SW_MAXIMIZE);
end;
function Tfmgrecibm.agrega_al_menu( titulo: string ): integer;
var
   k: integer;

begin
   k := length( opcion );
   setlength( opcion, k + 1 );
   opcion[ k ] := Tmenuitem.Create( pop );
   opcion[ k ].Caption := titulo;
   pop.Items.Add( opcion[ k ] );
   agrega_al_menu := k;
end;

procedure Tfmgrecibm.popPopup(Sender: TObject);
var i,k:integer;
begin
   for i := pop.Items.Count - 1 downto 0 do begin
      pop.Items.Delete( i );
      opcion[ i ].Destroy;
   end;
   setlength(opcion,0);
   if b_archivo then begin
      if lvibm.ItemIndex=-1 then exit;
      lvibmclick(sender);
      agrega_al_menu(lvibm.ItemFocused.Caption);
      agrega_al_menu('-');
      if dm.fileexistsunix(work_dir,lowercase(lvibm.ItemFocused.Caption)) then begin
         k:=agrega_al_menu(lowercase(lvibm.ItemFocused.Caption));
         pop.items[k].onclick := comparaunix;
      end;
      pop.Tag:=1;
      b_archivo:=false;
   end
   else begin
      if lvux.ItemIndex=-1 then exit;
      lvuxclick(sender);
      agrega_al_menu('Compara '+lvux.Selected.Caption+' con:');
      agrega_al_menu('-');
      pop.Tag:=0;
   end;
   for i:=0 to lvver.Items.Count-1 do begin
      k:=agrega_al_menu(lvver.Items[ i ].Caption);
      pop.items[ k ].onclick := comparaunix;
   end;
end;

procedure Tfmgrecibm.lvuxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   b_archivo:=false;
end;
procedure Tfmgrecibm.cuenta_check;
var i,m:integer;
begin
   m:=0;
   for i:=0 to lvibm.Items.Count-1 do
      if lvibm.Items[i].Checked then inc(m);
   lblselec.Caption:=inttostr(m);
end;
procedure Tfmgrecibm.lvibmClick(Sender: TObject);
var
   modu: string;
   k:integer;
begin
   cuenta_check;
   if lvibm.ItemIndex = -1 then
      exit;
   modu := lvibm.Items[ lvibm.itemindex ].Caption;
   dm.ftpibm.Get(modu,modu,true);
   k:=pos('.',modu);
   if k>0 then modu:=copy(modu,1,k-1);
   modu := lowercase(modu);
   if dm.direxistsunix( work_dir, 'respaldos' ) then   begin
      dm.muestra_unix( lvver, work_dir + '/respaldos', modu + '.*' );
   end
   else begin
      dm.ftp.MakeDir( work_dir+'/respaldos' );
   end;
end;

procedure Tfmgrecibm.lvibmMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   b_archivo:=true;
end;

procedure Tfmgrecibm.lvibmExit(Sender: TObject);
begin
   b_archivo:=false;
end;

procedure Tfmgrecibm.cmblibreriaChange(Sender: TObject);
begin
   b_cambia:=true;
end;

procedure Tfmgrecibm.cmblibreriaExit(Sender: TObject);
begin
   if b_cambia=false then exit;
   b_cambia:=false;
   if trim(cmblibreria.Text)='' then exit;
   try
      dm.ftpibm.ChangeDir(cmblibreria.Text);
   except
      showmessage('ERROR... Esa ruta no es accesible');
      exit;
   end;
   if rghost.Items[rghost.ItemIndex]='Unix' then begin
      dm.muestra_unix(lvibm,cmblibreria.Text,txtsufijo.Text,1);
   end
   else begin
      dm.muestra_ibm(lvibm,cmblibreria.Text,txtsufijo.Text);
   end;
   lblitems.Caption:=inttostr(lvibm.Items.Count);
   lblselec.Caption:='0';
end;

procedure Tfmgrecibm.cmblibreriaClick(Sender: TObject);
begin
   b_cambia:=true;
   Perform(WM_NEXTDLGCTL, 0, 0);
end;

procedure Tfmgrecibm.Button2Click(Sender: TObject);
var i:integer;
begin
   for i:=0 to lvibm.Items.Count-1 do
      lvibm.Items[i].Checked:=true;
   cuenta_check;
end;

procedure Tfmgrecibm.Button3Click(Sender: TObject);
var i:integer;
begin
   for i:=0 to lvibm.Items.Count-1 do
      lvibm.Items[i].Checked:=false;
   cuenta_check;
end;

procedure Tfmgrecibm.Button4Click(Sender: TObject);
var i,j:integer;
    f1,f2:string;
begin
   for i:=0 to lvibm.Items.Count-1 do begin
      for j:=0 to lvux.Items.Count-1 do begin
         if lvux.Items[j].Caption>lvibm.Items[i].Caption then begin
            lvibm.Items[i].Checked:=true;
            break;
         end;
         if lvux.Items[j].Caption=lvibm.Items[i].Caption then begin
            break;
         end;
      end;
      if j>=lvux.Items.Count then begin
         lvibm.Items[i].Checked:=true;
         continue;
      end;
      if rghost.Items[rghost.ItemIndex]='Unix' then begin
         f1:=dm.fecha_unix(lvibm.Items[i].SubItems[0]);
         f2:=dm.fecha_unix(lvux.Items[j].SubItems[0]);
      end;
      if f1>f2 then lvibm.Items[i].Checked:=true;
   end;
   cuenta_check;
end;

end.
