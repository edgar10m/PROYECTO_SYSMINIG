unit ptsrecibe;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, FileCtrl, ExtCtrls, ComCtrls, StdCtrls, Buttons, DB,
   ADODB, Grids, DBGrids, Menus, shellapi, dateutils, ImgList, dxBar,HTML_HELP, htmlhlp;
type
   TMyRec = record
      ruta: string;
   end;
type
   TtvRec = record
      ocprog: string;
      ocbib: string;
      occlase: string;
      pnombre: string;
      pbiblioteca: string;
      pclase: string;
      hnombre: string;
      hbiblioteca: string;
      hclase: string;
      hijo_falso: boolean;
      registros: integer;
      sistema: string;
      orden: string;
      lineainicio:integer;
      lineafinal:integer;
   end;

type
   Tftsrecibe = class( TForm )
      DataSource1: TDataSource;
      tsprog: TADOQuery;
      tsversion: TADOQuery;
      DataSource2: TDataSource;
      poparchivo: TPopupMenu;
      N1: TMenuItem;
      ImageList1: TImageList;
    mnuPrincipal: TdxBarManager;
    mnuCargaUtileria: TdxBarButton;
    mnuTodasLasLibrerias: TdxBarButton;
    mnuAyuda: TdxBarButton;
    ScrollBox1: TScrollBox;
    groupbox2: TGroupBox;
    Label2: TLabel;
    Label5: TLabel;
    Label1: TLabel;
    Label6: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    pie: TLabel;
    barbol: TSpeedButton;
    txtsufijo: TEdit;
    cmbsistema: TComboBox;
    cmbclase: TComboBox;
    cmbbiblioteca: TComboBox;
    barchivo: TBitBtn;
    bseltodo: TBitBtn;
    chkversion: TCheckBox;
    cmboficina: TComboBox;
    rgnombre: TRadioGroup;
    chkexiste: TCheckBox;
    chkanaliza: TCheckBox;
    blog: TButton;
    chkruta: TCheckBox;
    chkparams: TCheckBox;
    yextra: TGroupBox;
    chkextra: TCheckBox;
    txtextra: TEdit;
    chktodas: TCheckBox;
    chkextension: TCheckBox;
    chkverifica: TCheckBox;
    chkproduccion: TCheckBox;
    chknombre_version: TCheckBox;
    txtreemplaza1: TEdit;
    txtreemplaza2: TEdit;
    chkreemplaza: TCheckBox;
    chkcopys: TCheckBox;
    GroupBox3: TGroupBox;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    rxfuente: TMemo;
    rxfc: TMemo;
    barra: TProgressBar;
    tv: TTreeView;
    grbRecepcion: TGroupBox;
    split: TSplitter;
    dir: TDirectoryListBox;
    archivo: TFileListBox;
    ydrive: TPanel;
    Drive: TDriveComboBox;
    lbxarchivo: TListBox;
    Splitter6: TSplitter;
    GroupBoxVersiones: TGroupBox;
    gtsversion: TDBGrid;
    GroupBoxComponentes: TGroupBox;
    gtsprog: TDBGrid;
    Splitter3: TSplitter;
      procedure FormCreate( Sender: TObject );
      procedure cmboficinaChange( Sender: TObject );
      procedure cmbsistemaChange( Sender: TObject );
      procedure bseltodoClick( Sender: TObject );
      procedure txtsufijoChange( Sender: TObject );
      procedure barchivoClick( Sender: TObject );
      procedure archivoClick( Sender: TObject );
      procedure gtsprogCellClick( Column: TColumn );
      procedure comparafuente( Sender: TObject );
      procedure cmbclaseClick( Sender: TObject );
      procedure poparchivoPopup ( Sender: TObject );
      procedure poparchivoPopgral;
      procedure eliminacomponente( Sender: TObject );
      procedure eliminabiblioteca( Sender: TObject );
      procedure bsalirClick( Sender: TObject );
      procedure blogClick( Sender: TObject );
      procedure Splitter6Moved( Sender: TObject );
      procedure chkrutaClick( Sender: TObject );
      procedure dirMouseDown( Sender: TObject; Button: TMouseButton;
         Shift: TShiftState; X, Y: Integer );
      procedure butileriaClick( Sender: TObject );
      procedure chkextraClick( Sender: TObject );
      procedure chktodasClick( Sender: TObject );
    procedure mnuCargaUtileriaClick(Sender: TObject);
    procedure mnuTodasLasLibreriasClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    function FormHelp(Command: Word; Data: Integer;
      var CallHelp: Boolean): Boolean;
    procedure mnuAyudaClick(Sender: TObject);
    procedure grbRecepcionClick(Sender: TObject);
    procedure rgnombreClick(Sender: TObject);
    procedure DriveClick(Sender: TObject);
    procedure cmbsistemaClick(Sender: TObject);
    procedure cmbbibliotecaClick(Sender: TObject);
    procedure txtsufijoClick(Sender: TObject);
    procedure txtextraClick(Sender: TObject);
    procedure chkexisteClick(Sender: TObject);
    procedure chkversionClick(Sender: TObject);
    procedure chkanalizaClick(Sender: TObject);
    procedure chkextensionClick(Sender: TObject);
    procedure chkverificaClick(Sender: TObject);
    procedure chkparamsClick(Sender: TObject);
    procedure rxfcClick(Sender: TObject);
    procedure rxfuenteClick(Sender: TObject);
    procedure gtsversionCellClick(Column: TColumn);
    procedure dirClick(Sender: TObject);
    procedure cmboficinaClick(Sender: TObject);
    procedure chkproduccionClick(Sender: TObject);
    procedure gtsprogDblClick(Sender: TObject);
    procedure chknombre_versionClick(Sender: TObject);
    procedure chkreemplazaClick(Sender: TObject);
    procedure barbolClick(Sender: TObject);
    procedure tvExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure rxfuenteDblClick(Sender: TObject);
    procedure lbxarchivoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
   private
      { Private declarations }
      herramienta: string;
      archivo_master: string;
      bib_dir: string;
      bib_base: string;
      cla_tipo: string;
      reg: ^Tmyrec;
      nodo_actual: Ttreenode;
      b_todos: boolean;
      b_mostro_letrero:boolean;
      ant_clase: string;
      b_dobleclick:boolean;
      nombre_version:string;
      hubo_procesados:boolean;
      este:string;
      function volumen_default(clase,bib,prog:string):string;
      procedure volumen_macro_cobol(clase, bib, prog:string);
      procedure volumen_cobol_macro(clase, bib, prog:string);
      function nombre_componente( nombre: string ): string;
      procedure habilita;
      procedure abre_cierra_tsversion;
      procedure AddDirectories( cPath: string; lista: Tlistbox; mascara: string );
      procedure tsparams_job_jcl( job: string; bib: string; clase: string;
         jcl: string; jbib: string; jclase: string );
      procedure tsparams_job( job: string; bib: string; copiado: string );
      procedure tsparams_jcl( jcl: string; bib: string );
      function verifica_archivo(k:integer; nombre:string; mensaje:string):boolean;
      function verifica_clase:boolean;
      procedure actualiza_scratch_parcial;
      procedure actualiza_lineas_final(cprog, cbib, cclase:string );
      procedure crea_nodo(nodo:TTreenode; clase,bib,prog:string);

   public
      { Public declarations }
   end;

var
   ftsrecibe: Tftsrecibe;

procedure PR_RECIBE;

implementation
uses
   ptsdm, ptsutileria, ptsgral, ptsmain, ptsrec,ptscomun,uConstantes;
{$R *.dfm}

procedure PR_RECIBE;
begin
   gral.PubMuestraProgresBar( True );
   Application.CreateForm( Tftsrecibe, ftsrecibe );
   {try
      ftsrecibe.Showmodal;
   finally
      ftsrecibe.Free;
   end;}

   {if gral.bPubVentanaActiva( ftsrecibe.Caption ) then
      Exit;}

   ftsrecibe.FormStyle := fsMDIChild;

   if gral.bPubVentanaMaximizada = FALSE then begin
      ftsrecibe.Width := g_Width;
      ftsrecibe.Height := g_Height;
   end;

   ftsrecibe.Show;

   dm.PubRegistraVentanaActiva( ftsrecibe.Caption );

   gral.PubMuestraProgresBar( False );
end;

procedure Tftsrecibe.FormCreate( Sender: TObject );
begin
    if HookID <> 0 then
      UnHookWindowsHookEx( HookID );
   if g_language = 'ENGLISH' then begin
      caption := 'Receiving Components';
      grbrecepcion.Caption := 'Reception';
      groupbox2.Caption := 'Operation';
      groupbox3.Caption := 'Result';
      label7.Caption := 'Office';
      label5.Caption := 'Application';
      label1.Caption := 'Class';
      label6.Caption := 'Library';
      label2.Caption := 'Mask';
      label4.Caption := 'Process';
      bseltodo.Caption := 'Select All';
      chkexiste.Caption := 'Ignores existing';
      chkversion.Caption := 'Check versions';
      chkanaliza.Caption := 'Analizes source';
      rgnombre.Caption := 'Component name';
      rgnombre.Items[ 0 ] := 'Current';
      rgnombre.Items[ 1 ] := 'lowercase';
      rgnombre.Items[ 2 ] := 'UPPERCASE';
            //butileria.Caption := 'Load Utility';
   end;
   dm.feed_combo( cmboficina, 'select coficina from tsoficina order by coficina' );
   dm.feed_combo( cmbclase, 'select cclase from tsclase where objeto=' + g_q + 'FISICO' + g_q +
      ' and estadoactual='+g_q+'ACTIVO'+g_q+
      ' order by cclase' );
   //dm.feed_combo( cmbclase, 'select unique hcclase from tsrela , tsclase where hcclase = cclase and objeto =' + g_q + 'FISICO' + g_q +
   //   ' order by hcclase' );
   dm.feed_combo( cmbbiblioteca, 'select cbib from tsbib order by cbib' );
   if  dm.capacidad( 'Menu Principal Carga Utileria' ) then  begin
      mnuCargaUtileria.Visible :=  ivAlways;
      mnuTodasLasLibrerias.Visible := ivAlways;
   end else begin
      mnuCargaUtileria.Visible :=  ivNever;
      mnuTodasLasLibrerias.Visible := ivNever;
   end;
   //mnuPrincipal.Visible := dm.capacidad( 'Menu Principal Carga Utileria' );
   tsprog.Connection := dm.ADOConnection1;
   tsversion.Connection := dm.ADOConnection1;
   b_todos := false;
   actualiza_scratch_parcial;
end;

function Tftsrecibe.volumen_default(clase,bib,prog:string):string;
var volumen:string;
    k:integer;
begin
   volumen:='';                                      // Busca el volumen default
   if dm.sqlselect(dm.q2,'select * from tsrela '+
      ' where ocprog='+g_q+prog+g_q+
      ' and   ocbib='+g_q+bib+g_q+
      ' and   occlase='+g_q+clase+g_q+
      ' and   pcprog='+g_q+clase+g_q+
      ' and   pcclase='+g_q+'CLA'+g_q) then begin
      k:=pos('VOLUME=',dm.q2.fieldbyname('atributos').AsString);
      if k>0 then begin
         volumen:=copy(dm.q2.fieldbyname('atributos').AsString,k+7,1000);
         k:=pos('{}',volumen);
         if k>0 then
            volumen:=copy(volumen,1,k-1);
         k:=pos('.',volumen);
         if k>0 then
            volumen:=copy(volumen,1,k-1);
      end;
   end;
   volumen_default:=volumen;
end;

procedure Tftsrecibe.volumen_macro_cobol(clase, bib, prog:string);
var volumen:string;
   k:integer;
   lista,archivos,externos:Tstringlist;
   procedure procesa_macro_cobol(hcclase,hcbib,hcprog:string; lista:Tstringlist);
   var qq:Tadoquery;
      k:integer;
   begin
      qq:=Tadoquery.Create(self);
      qq.Connection := dm.ADOConnection1;
      lista.Add(clase+'_'+bib+'_'+prog);
      if dm.sqlselect(qq,'select * from tsrela '+
         ' where pcprog='+g_q+hcprog+g_q+
         ' and   pcbib='+g_q+hcbib+g_q+
         ' and   pcclase='+g_q+hcclase+g_q) then begin
         while not qq.Eof do begin
            if lista.IndexOf(qq.fieldbyname('hcclase').AsString+'_'+
                             qq.fieldbyname('hcbib').AsString+'_'+
                             qq.fieldbyname('hcprog').AsString)>-1 then begin
               qq.Next;
               continue;
            end;
            // agrega registro con el ASSIGN de la macro TANDEM
            if (hcclase='CBL') and (qq.FieldByName('hcclase').AsString='FIL') then begin
               k:=externos.IndexOf(qq.fieldbyname('externo').AsString);
               if k>-1 then begin
                  if archivos[k]<>qq.fieldbyname('hcprog').AsString then begin
                     dm.sqlinsert('insert into tsrela '+
                        ' (pcprog,pcbib,pcclase,hcprog,hcbib,hcclase,modo,organizacion,'+
                        '  externo,coment,orden,ocprog,ocbib,occlase,sistema,atributos,'+
                        '  lineainicio,lineafinal,ambito,icprog,icbib,icclase,polimorfismo) '+
                        ' values('+
                        g_q+qq.fieldbyname('pcprog').AsString+g_q+','+
                        g_q+qq.fieldbyname('pcbib').AsString+g_q+','+
                        g_q+qq.fieldbyname('pcclase').AsString+g_q+','+
                        g_q+archivos[k]+g_q+','+
                        g_q+qq.fieldbyname('hcbib').AsString+g_q+','+
                        g_q+qq.fieldbyname('hcclase').AsString+g_q+','+
                        g_q+qq.fieldbyname('modo').AsString+g_q+','+
                        g_q+qq.fieldbyname('organizacion').AsString+g_q+','+
                        g_q+qq.fieldbyname('externo').AsString+g_q+','+
                        g_q+qq.fieldbyname('coment').AsString+g_q+','+
                        g_q+qq.fieldbyname('orden').AsString+g_q+','+
                        g_q+prog+g_q+','+
                        g_q+bib+g_q+','+
                        g_q+clase+g_q+','+
                        g_q+qq.fieldbyname('sistema').AsString+g_q+','+
                        g_q+qq.fieldbyname('atributos').AsString+g_q+','+
                        qq.fieldbyname('lineainicio').AsString+','+
                        qq.fieldbyname('lineafinal').AsString+','+
                        g_q+qq.fieldbyname('ambito').AsString+g_q+','+
                        g_q+qq.fieldbyname('icprog').AsString+g_q+','+
                        g_q+qq.fieldbyname('icbib').AsString+g_q+','+
                        g_q+qq.fieldbyname('icclase').AsString+g_q+','+
                        g_q+qq.fieldbyname('polimorfismo').AsString+g_q+')');
                  end;
               end
               else begin         // reemplaza el $VOLUMEN$ por el default de la macro TANDEM
                  if pos('$VOLUMEN$',qq.fieldbyname('hcprog').AsString)>0 then begin
                     dm.sqlinsert('insert into tsrela '+
                        ' (pcprog,pcbib,pcclase,hcprog,hcbib,hcclase,modo,organizacion,'+
                        '  externo,coment,orden,ocprog,ocbib,occlase,sistema,atributos,'+
                        '  lineainicio,lineafinal,ambito,icprog,icbib,icclase,polimorfismo) '+
                        ' values('+
                        g_q+qq.fieldbyname('pcprog').AsString+g_q+','+
                        g_q+qq.fieldbyname('pcbib').AsString+g_q+','+
                        g_q+qq.fieldbyname('pcclase').AsString+g_q+','+
                        g_q+stringreplace(qq.fieldbyname('hcprog').AsString,'$VOLUMEN$',volumen,[])+g_q+','+
                        g_q+qq.fieldbyname('hcbib').AsString+g_q+','+
                        g_q+qq.fieldbyname('hcclase').AsString+g_q+','+
                        g_q+qq.fieldbyname('modo').AsString+g_q+','+
                        g_q+qq.fieldbyname('organizacion').AsString+g_q+','+
                        g_q+qq.fieldbyname('externo').AsString+g_q+','+
                        g_q+qq.fieldbyname('coment').AsString+g_q+','+
                        g_q+qq.fieldbyname('orden').AsString+g_q+','+
                        g_q+prog+g_q+','+
                        g_q+bib+g_q+','+
                        g_q+clase+g_q+','+
                        g_q+qq.fieldbyname('sistema').AsString+g_q+','+
                        g_q+qq.fieldbyname('atributos').AsString+g_q+','+
                        qq.fieldbyname('lineainicio').AsString+','+
                        qq.fieldbyname('lineafinal').AsString+','+
                        g_q+qq.fieldbyname('ambito').AsString+g_q+','+
                        g_q+qq.fieldbyname('icprog').AsString+g_q+','+
                        g_q+qq.fieldbyname('icbib').AsString+g_q+','+
                        g_q+qq.fieldbyname('icclase').AsString+g_q+','+
                        g_q+qq.fieldbyname('polimorfismo').AsString+g_q+')');
                  end;
               end;
            end;
            procesa_macro_cobol(qq.fieldbyname('hcclase').AsString,
                                qq.fieldbyname('hcbib').AsString,
                                qq.fieldbyname('hcprog').AsString,lista);
            qq.Next;
         end;
      end;
      qq.Free;
   end;
begin
   if (clase<>'TMC') and (clase<>'TMP') then exit;
   volumen:=volumen_default(clase,bib,prog);
   archivos:=Tstringlist.Create;                     // Busca ASSIGNS de la macro
   externos:=Tstringlist.Create;
   if dm.sqlselect(dm.q1,'select * from tsrela '+
      ' where ocprog='+g_q+prog+g_q+
      ' and   ocbib='+g_q+bib+g_q+
      ' and   occlase='+g_q+clase+g_q+
      ' and   pcprog='+g_q+prog+g_q+
      ' and   pcbib='+g_q+bib+g_q+
      ' and   pcclase='+g_q+clase+g_q+
      ' and   hcclase='+g_q+'FIL'+g_q+
      ' and   externo is not null ') then begin
      while not dm.q1.Eof do begin
         archivos.Add(dm.q1.fieldbyname('hcprog').AsString);
         externos.Add(dm.q1.fieldbyname('externo').AsString);
         dm.q1.Next;
      end;
   end;
   lista:=Tstringlist.Create;
   procesa_macro_cobol(clase,bib,prog,lista);
   archivos.free;
   externos.free;
   lista.free;
end;
procedure Tftsrecibe.volumen_cobol_macro(clase, bib, prog:string);
begin
end;

procedure Tftsrecibe.actualiza_scratch_parcial;
var
   tablas,coma:string;
begin
   //exit;
      if dm.sqlselect(dm.q2,'select distinct pcprog,pcbib,pcclase,sistema from tsrela '+
         ' where pcbib<>'+g_q+'SCRATCH'+g_q+
         ' and   pcbib like '+g_q+'%SCRATCH%'+g_q) then begin
         while not dm.q2.Eof do begin
            if dm.sqlselect( dm.q1, 'select distinct hcbib,sistema from tsrela ' + // busca nombre de componente y mismo tipo
               ' where hcprog=' + g_q + dm.q2.fieldbyname('pcprog').AsString + g_q +
               ' and   hcbib like ' + g_q + stringreplace(dm.q2.fieldbyname('pcbib').AsString,'SCRATCH','%',[rfreplaceall]) + g_q +
               ' and   hcclase=' + g_q + dm.q2.fieldbyname('pcclase').AsString + g_q ) then begin
               while not dm.q1.Eof do begin
                  if pos('SCRATCH',dm.q1.fieldbyname('hcbib').AsString)=0 then begin
                     dm.sqlupdate('update tsrela set pcbib='+g_q+dm.q1.fieldbyname('hcbib').AsString+g_q+
                        ' where pcprog='+g_q+dm.q2.fieldbyname('pcprog').AsString+g_q+
                        ' and   pcbib='+g_q+dm.q2.fieldbyname('pcbib').AsString+g_q+
                        ' and   pcclase='+g_q+dm.q2.fieldbyname('pcclase').AsString+g_q);
                     if dm.q2.FieldByName('sistema').AsString=dm.q1.FieldByName('sistema').AsString then
                        break;
                  end;
                  dm.q1.Next;
               end;
            end;
            dm.q2.Next;
         end;
      end;

      if dm.sqlselect(dm.q2,'select * from tsrela '+    // Resuelve para campos TFF
         ' where hcclase='+g_q+'TFF'+g_q+
         ' and   hcbib<>'+g_q+'SCRATCH'+g_q+
         ' and   hcbib like '+g_q+'%SCRATCH%'+g_q) then begin
         while not dm.q2.Eof do begin
            if dm.sqlselect(dm.q1,'select hcbib,hcprog from tsrela '+    // busca tablas usadas en el mismo query
               ' where pcprog='+g_q+dm.q2.fieldbyname('pcprog').AsString+g_q+
               ' and   pcbib='+g_q+dm.q2.fieldbyname('pcbib').AsString+g_q+
               ' and   pcclase='+g_q+dm.q2.fieldbyname('pcclase').AsString+g_q+
               ' and   hcclase in ('+g_q+'TAB'+g_q+','+g_q+'INS'+g_q+','+g_q+'UPD'+g_q+','+g_q+'DEL'+g_q+')') then begin
               coma:='(';
               tablas:='';
               while not dm.q1.Eof do begin
                  tablas:=tablas+coma+g_q+dm.q1.fieldbyname('hcbib').AsString+'.'+dm.q1.fieldbyname('hcprog').AsString+g_q;
                  coma:=',';
                  dm.q1.Next;
               end;
               tablas:=tablas+')';
               if dm.sqlselect(dm.q1,'select hcbib from tsrela '+  // Encuentra la bib (tabla) que corresponde
                  ' where hcprog='+g_q+dm.q2.fieldbyname('hcprog').AsString+g_q+
                  ' and   hcbib in '+tablas+
                  ' and   hcclase in ('+g_q+'TFF'+g_q+','+g_q+'TFL'+g_q+')') then begin
                  while not dm.q1.Eof do begin
                     if pos('SCRATCH',dm.q1.fieldbyname('hcbib').AsString)=0 then begin
                        dm.sqlupdate('update tsrela set hcbib='+g_q+dm.q1.fieldbyname('hcbib').AsString+g_q+
                           ' where hcprog='+g_q+dm.q2.fieldbyname('hcprog').AsString+g_q+
                           ' and   hcbib='+g_q+dm.q2.fieldbyname('hcbib').AsString+g_q+
                           ' and   hcclase='+g_q+dm.q2.fieldbyname('hcclase').AsString+g_q);
                        break;
                     end;
                     dm.q1.Next;
                  end;
               end;
            end;
            dm.q2.Next;
         end;
      end;

      if dm.sqlselect(dm.q2,'select distinct hcprog,hcbib,hcclase,sistema from tsrela '+
         ' where hcbib<>'+g_q+'SCRATCH'+g_q+
         ' and   hcbib like '+g_q+'%SCRATCH%'+g_q) then begin
         while not dm.q2.Eof do begin
            if dm.sqlselect( dm.q1, 'select distinct hcbib,sistema from tsrela ' + // busca nombre de componente y mismo tipo
               ' where hcprog=' + g_q + dm.q2.fieldbyname('hcprog').AsString + g_q +
               ' and   hcbib like ' + g_q + stringreplace(dm.q2.fieldbyname('hcbib').AsString,'SCRATCH','%',[rfreplaceall]) + g_q +
               ' and   hcclase=' + g_q + dm.q2.fieldbyname('hcclase').AsString + g_q ) then begin
               while not dm.q1.Eof do begin
                  if pos('SCRATCH',dm.q1.fieldbyname('hcbib').AsString)=0 then begin
                     dm.sqlupdate('update tsrela set hcbib='+g_q+dm.q1.fieldbyname('hcbib').AsString+g_q+
                        ' where hcprog='+g_q+dm.q2.fieldbyname('hcprog').AsString+g_q+
                        ' and   hcbib='+g_q+dm.q2.fieldbyname('hcbib').AsString+g_q+
                        ' and   hcclase='+g_q+dm.q2.fieldbyname('hcclase').AsString+g_q);
                     if dm.q2.FieldByName('sistema').AsString=dm.q1.FieldByName('sistema').AsString then
                        break;
                  end;
                  dm.q1.Next;
               end;
            end;
            dm.q2.Next;
         end;
      end;
end;

procedure Tftsrecibe.habilita;
begin
   barchivo.Enabled := ( cmboficina.Text <> '' ) and ( cmbsistema.Text <> '' ) and
      ( cmbclase.Text <> '' ) and ( cmbbiblioteca.Text <> '' ) and
      ( ( ( chkruta.Checked = false ) and ( archivo.SelCount > 0 ) ) or
      ( ( chkruta.Checked = true ) and ( lbxarchivo.SelCount > 0 ) ) );
   if trim( cmbbiblioteca.Text ) = '' then
      chktodasclick( self );
end;

procedure Tftsrecibe.cmboficinaChange( Sender: TObject );
begin
   dm.feed_combo( cmbsistema, 'select csistema from tssistema where coficina=' + g_q +
                  cmboficina.Text + g_q +' and estadoactual = '+g_q + 'ACTIVO' + g_q +
                  ' order by csistema' );
   habilita;
   iHelpContext := IDH_TOPIC_T01706;
end;

procedure Tftsrecibe.cmbsistemaChange( Sender: TObject );
begin
   if (sender as Tcombobox).Name<>'cmbbiblioteca' then
      chktodasClick( sender );
   if ptsrec.trae_configuracion(cmbsistema,cmbclase,cmbbiblioteca,chkruta,chkextra,chkexiste,chkanaliza,chkextension,
      chkproduccion,chkversion,chkverifica,chknombre_version,chkparams,chkcopys,txtextra,txtsufijo,rgnombre,yextra,dir,
      chkreemplaza,txtreemplaza1,txtreemplaza2,
      bib_dir,bib_base,cla_tipo) then begin
      tsprog.Close;
      tsprog.SQL.Clear;
      tsprog.SQL.Add( 'select cprog,cbib,cclase,sistema,fecha,cbibbin,cblob,magic,analizado,descripcion ' +
         ' from tsprog ' +
         ' where cclase=' + g_q + cmbclase.Text + g_q +
         ' and   cbib=' + g_q + cmbbiblioteca.Text + g_q +
         ' and   sistema=' + g_q + cmbsistema.Text + g_q +
         ' order by cprog ' );
      tsprog.open;
   end;
   habilita;
   if chkproduccion.Checked then
      barchivo.Enabled:=true;
   iHelpContext := IDH_TOPIC_T01704;

   //alkSistema:=cmbsistema.Text;
end;

procedure Tftsrecibe.bseltodoClick( Sender: TObject );
begin

   if chkruta.Checked then begin
      lbxarchivo.SelectAll;
      pie.Caption := inttostr( lbxarchivo.SelCount ) + ' archivos seleccionados';
   end
   else begin
      archivo.SelectAll;
      pie.Caption := inttostr( archivo.SelCount ) + ' archivos seleccionados';
   end;
   habilita;
   iHelpContext := IDH_TOPIC_T01713;

end;

procedure Tftsrecibe.txtsufijoChange( Sender: TObject );
begin
   archivo.Mask := txtsufijo.Text;
end;
// procesa el nombre del archivo fisico y le da el nombre correspondiente dentro del sistema donde pertenece
function Tftsrecibe.nombre_componente( nombre: string ): string;
var
   nom: string;
begin
   iHelpContext := IDH_TOPIC_T01701;
   if copy( nombre, 1, 5 ) = 'ROOT\' then
      nombre := '\' + copy( nombre, 6, 500 );
   if chkextension.Checked = false then begin
      if chkruta.Checked then
         nom := changefileext( nombre, '' )
      else
         nom := changefileext( extractfilename( nombre ), '' );
   end
   else begin
      if chkruta.Checked then
         nom := nombre
      else
         nom := extractfilename( nombre );
   end;
   case rgnombre.ItemIndex of
      0: begin
         iHelpContext := IDH_TOPIC_T01726;
         end;
      1: begin
         nom := lowercase( nom );
         iHelpContext := IDH_TOPIC_T01731;
         end;
      2: begin
         nom := uppercase( nom );
         iHelpContext := IDH_TOPIC_T01728;
         end;
   end;
   nombre_version:='';
   if chknombre_version.Checked then begin
      nombre_version:=nom;
      while pos('_',nombre_version)>0 do
         nombre_version:=copy(nombre_version,pos('_',nombre_version)+1,500);
      if nombre_version=nom then
         nombre_version:=''
      else
         nom:=copy(nom,1,length(nom)-length(nombre_version)-1);
   end;   
   nombre_componente := nom;
end;


procedure Tftsrecibe.tsparams_job_jcl( job: string; bib: string; clase: string;
   jcl: string; jbib: string; jclase: string );
var
   dato, par, par2: string;
begin
   if dm.sqlselect( dm.q2, 'select * from tsrela ' + // busca hijos del JCL con parametros
      ' where ocprog=' + g_q + jcl + g_q +
      ' and   ocbib=' + g_q + jbib + g_q +
      ' and   occlase=' + g_q + jclase + g_q +
      ' and   hcprog like ' + g_q + '%&%' + g_q ) then begin
      while not dm.q2.Eof do begin
         dato := dm.q2.fieldbyname( 'hcprog' ).AsString;
         while pos( '&', dato ) > 0 do begin // reemplaza parametros
            par := copy( dato, pos( '&', dato ), 500 );
            if pos( '.', par ) > 0 then // a veces el parametro no termina con punto
               par := copy( par, 1, pos( '.', par ) );
            par2 := stringreplace( copy( par, 2, 500 ), '.', '', [ ] );
            if dm.sqlselect( dm.q3, 'select valor from tsparams ' +
               ' where cprog=' + g_q + job + g_q +
               ' and   cbib=' + g_q + bib + g_q +
               ' and   cclase=' + g_q + clase + g_q +
               ' and   param=' + g_q + par2 + g_q ) then begin
               dato := stringreplace( dato, par, dm.q3.fieldbyname( 'valor' ).AsString, [ rfreplaceall ] );
            end
            else begin
               dato := '';
            end;
         end; // inserta copia de registro con propietario JOB
         if trim( dato ) <> '' then begin
            dm.sqlinsert( 'insert into tsrela (pcprog,pcbib,pcclase,hcprog,hcbib,hcclase,' +
               'modo,organizacion,externo,coment,orden,ocprog,ocbib,occlase,sistema) values(' +
               g_q + dm.q2.fieldbyname( 'pcprog' ).AsString + g_q + ',' +
               g_q + dm.q2.fieldbyname( 'pcbib' ).AsString + g_q + ',' +
               g_q + dm.q2.fieldbyname( 'pcclase' ).AsString + g_q + ',' +
               g_q + dato + g_q + ',' +
               g_q + dm.q2.fieldbyname( 'hcbib' ).AsString + g_q + ',' +
               g_q + dm.q2.fieldbyname( 'hcclase' ).AsString + g_q + ',' +
               g_q + dm.q2.fieldbyname( 'modo' ).AsString + g_q + ',' +
               g_q + dm.q2.fieldbyname( 'organizacion' ).AsString + g_q + ',' +
               g_q + dm.q2.fieldbyname( 'externo' ).AsString + g_q + ',' +
               g_q + dm.q2.fieldbyname( 'coment' ).AsString + g_q + ',' +
               g_q + dm.q2.fieldbyname( 'orden' ).AsString + g_q + ',' +
               g_q + job + g_q + ',' +
               g_q + bib + g_q + ',' +
               g_q + clase + g_q + ',' +
               g_q + dm.q2.fieldbyname( 'sistema' ).AsString + g_q + ')' );
         end;
         dm.q2.Next;
      end;
   end;
end;

procedure Tftsrecibe.tsparams_job( job: string; bib: string; copiado: string );
var
   directivas, analizador, nuevo, salida, valor: string;
   lista, pp: Tstringlist;
   i: integer;
begin
   directivas := g_tmpdir + '\hta452345'; // ejecuta herramienta para extraer parámetros
   if fileexists( directivas ) = false then
      dm.get_utileria( 'PARAMS.DIR', directivas );
   analizador := g_tmpdir + '\hta3214444.exe';
   if fileexists( analizador ) = false then
      dm.get_utileria( 'RGMLANG', analizador );
   nuevo := g_tmpdir + '\nada1234';
   salida := g_tmpdir + '\nada4444';
   g_borrar.Add( directivas );
   g_borrar.Add( analizador );
   g_borrar.Add( nuevo );
   g_borrar.Add( salida );
   dm.ejecuta_espera( analizador + ' "' + copiado + '" ' + nuevo + ' ' + directivas + ' >' + salida, SW_HIDE );
   lista := Tstringlist.Create;
   pp := Tstringlist.Create;
   lista.LoadFromFile( salida );
   dm.sqldelete( 'delete tsparams ' + // borra parametros anteriores
      ' where cprog=' + g_q + job + g_q +
      ' and cbib=' + g_q + bib + g_q +
      ' and cclase=' + g_q + 'JOB' + g_q );
   for i := 0 to lista.Count - 1 do begin // alta nuevos parametros
      pp.CommaText := lista[ i ];
      if pp.Count <> 5 then
         continue;
      dm.sqlinsert( 'insert into tsparams (cprog,cbib,cclase,param,valor) values(' +
         g_q + job + g_q + ',' +
         g_q + bib + g_q + ',' +
         g_q + 'JOB' + g_q + ',' +
         g_q + pp[ 3 ] + g_q + ',' +
         g_q + stringreplace( pp[ 4 ], '''', '', [ rfreplaceall ] ) + g_q + ')' );
   end;
   if dm.sqlselect( dm.q1, 'select * from tsrela ' + // busca JCLs llamados por el JOB
      ' where ocprog=' + g_q + job + g_q +
      ' and   ocbib=' + g_q + bib + g_q +
      ' and   occlase=' + g_q + 'JOB' + g_q +
      ' and   hcclase=' + g_q + 'JCL' + g_q ) then begin
      while not dm.q1.Eof do begin
         tsparams_job_jcl( job, bib, 'JOB', dm.q1.fieldbyname( 'hcprog' ).AsString,
            dm.q1.fieldbyname( 'hcbib' ).AsString, dm.q1.fieldbyname( 'hcclase' ).AsString );
         dm.q1.Next;
      end;
   end;
end;

procedure Tftsrecibe.tsparams_jcl( jcl: string; bib: string );
begin
   // revisa si los JOB que lo llaman usan parametros
   if dm.sqlselect( dm.q1, 'select distinct ocprog,ocbib,occlase from tsrela,tsparams ' +
      ' where ocprog=cprog ' +
      ' and   hcprog=' + g_q + jcl + g_q +
      ' and   hcbib=' + g_q + bib + g_q +
      ' and   hcclase=' + g_q + 'JCL' + g_q +
      ' and   occlase=' + g_q + 'JOB' + g_q ) then begin
      // reprocesa los JOB en su manejo de parametros
      while not dm.q1.Eof do begin
         dm.sqldelete( 'delete tsrela ' + // borra registros adoptados anteriores
            ' where ocprog=' + g_q + dm.q1.fieldbyname( 'ocprog' ).AsString + g_q +
            ' and   ocbib=' + g_q + dm.q1.fieldbyname( 'ocbib' ).AsString + g_q +
            ' and   occlase=' + g_q + dm.q1.fieldbyname( 'occlase' ).AsString + g_q +
            ' and   (pcprog,pcbib,pcclase) in ' +
            '       (select distinct pcprog,pcbib,pcclase from tsrela ' +
            '           where ocprog=' + g_q + jcl + g_q +
            '           and   ocbib=' + g_q + bib + g_q +
            '           and   occlase=' + g_q + 'JCL' + g_q + ')' );
         tsparams_job_jcl( dm.q1.fieldbyname( 'ocprog' ).AsString,
            dm.q1.fieldbyname( 'ocbib' ).AsString,
            dm.q1.fieldbyname( 'occlase' ).AsString, jcl, bib, 'JCL' );
         dm.q1.Next;
      end;
   end;
end;

function Tftsrecibe.verifica_archivo(k:integer; nombre:string; mensaje:string):boolean;
var j:integer;
   bok:array of boolean;
   ext,nuevo,mensaje2:string;
begin
   if fileexists(nombre)=false then begin
      showmessage('ERROR... no existe el archivo '+nombre);
      abort;
   end;
   rxfuente.Lines.LoadFromFile( nombre );
   setlength(bok,k);
   for j:=0 to k-1 do
      bok[j]:=false;
   for j:=0 to rxfuente.Lines.Count-1 do begin
      if cmbclase.Text='COS' then begin     // Tarjetas COSORT
         if pos('/INFILE',uppercase(rxfuente.Lines[j]))>0 then
            bok[0]:=true;
         if pos('/OUTFILE',uppercase(rxfuente.Lines[j]))>0 then
            bok[1]:=true;
      end;
   end;
   for j:=0 to k-1 do begin
      if bok[j]=false then begin
         while true do begin
            case application.MessageBox(pchar('Componente '+nombre+chr(13)+
               mensaje+chr(13)+'Desea cambiar la extensión del componente?'),
               'Confirme',MB_YESNOCANCEL) of
               IDYES: begin
                  ext:=extractfileext(nombre);
                  if trim(ext)='' then
                     ext:='.';
                  ext:=inputbox('Capture','Nueva extensión',ext);
                  if copy(ext,1,1)<>'.' then
                     ext:='.'+ext;
                  nuevo:=changefileext(nombre,ext);
                  if fileexists(nuevo) then begin
                     showmessage('El archivo '+nuevo+' ya existe');
                  end
                  else begin
                     renamefile(nombre,nuevo);
                     verifica_archivo:=false;
                     exit;
                  end;
               end;
               IDCANCEL: begin
                  ftsrecibe.Enabled := true;
                  screen.Cursor := crdefault;
                  abort;
               end;
               IDNO: begin
                  verifica_archivo:=true;
                  exit;
               end;
            end;
         end;
      end;
   end;
   verifica_archivo:=true;
   exit;
end;
function Tftsrecibe.verifica_clase:boolean;
var i,k:integer;
   nombre:string;
   b_cambios:boolean;
   mensaje:string;
begin
   b_cambios:=false;
   if cmbclase.Text='COS' then begin     // Tarjetas COSORT
      k:=2;
      mensaje:='No tiene comandos /INFILE o /OUTFILE';
   end;
   if lbxarchivo.Visible then begin
      for i:=0 to lbxarchivo.Items.Count-1 do begin
         if lbxarchivo.selected[i] then begin
            nombre := lbxarchivo.Items[i];
            if trim( nombre ) = '' then
               continue;
            nombre:=dir.Directory + '\' + nombre;
            if verifica_archivo(k,nombre,mensaje)=false then
               b_cambios:=true;
         end;
      end;
   end
   else begin
      for i := 0 to archivo.Items.Count - 1 do begin
         if archivo.Selected[ i ] then begin
            nombre:=archivo.Directory+'\'+archivo.Items[i];
            if verifica_archivo(k,nombre,mensaje)=false then
               b_cambios:=true;
         end;
      end;
   end;
   verifica_clase:=b_cambios;
end;
procedure Tftsrecibe.actualiza_lineas_final(cprog, cbib, cclase:string );
var final:integer;
begin
   final:=999999;
   if dm.sqlselect(dm.q1,'select lineas_total from tsproperty '+
      ' where cprog='+g_q+cprog+g_q+
      ' and   cbib='+g_q+cbib+g_q+
      ' and   cclase='+g_q+cclase+g_q) then
     final:=dm.q1.fieldbyname('lineas_total').AsInteger;
   if dm.sqlselect(dm.q1,'select * from tsrela '+
      ' where ocprog='+g_q+cprog+g_q+
      ' and   ocbib='+g_q+cbib+g_q+
      ' and   occlase='+g_q+cclase+g_q+
      ' and   lineafinal=999999'+
      ' order by orden desc') then begin
      while not dm.q1.Eof do begin
         dm.sqlupdate('update tsrela set lineafinal='+inttostr(final)+
            ' where ocprog='+g_q+cprog+g_q+
            ' and   ocbib='+g_q+cbib+g_q+
            ' and   occlase='+g_q+cclase+g_q+
            ' and   pcprog='+g_q+dm.q1.fieldbyname('pcprog').AsString+g_q+
            ' and   pcbib='+g_q+dm.q1.fieldbyname('pcbib').AsString+g_q+
            ' and   pcclase='+g_q+dm.q1.fieldbyname('pcclase').AsString+g_q+
            ' and   hcprog='+g_q+dm.q1.fieldbyname('hcprog').AsString+g_q+
            ' and   hcbib='+g_q+dm.q1.fieldbyname('hcbib').AsString+g_q+
            ' and   hcclase='+g_q+dm.q1.fieldbyname('hcclase').AsString+g_q+
            ' and   orden='+g_q+dm.q1.fieldbyname('orden').AsString+g_q+
            ' and   lineafinal=999999');
         final:=dm.q1.fieldbyname('lineainicio').AsInteger-1;
         dm.q1.Next;
      end;
   end;
end;

procedure Tftsrecibe.barchivoClick( Sender: TObject );
var compos:Tstringlist;
   i:integer;
   inicio,fin:Tdatetime;
   verdad,mens:string;
begin
   iHelpContext := IDH_TOPIC_T01715;
   if barchivo.Enabled = false then
      exit;
   deletefile(g_tmpdir+'\OBSERVACIONES.csv');

   compos := Tstringlist.Create;
   if chkproduccion.Checked then begin
      if b_dobleclick then
         compos.Add(archivo_master)
      else begin
         if b_mostro_letrero=false then
            if application.MessageBox(pchar('Si desea procesar sólo un componente seleccionelo en la ventana inferior derecha dándole doble click.'+chr(13)+
               'Se procesará toda la biblioteca, está de acuerdo?'),'Confirme',MB_YESNO)=IDNO then exit;

         if b_todos then
            b_mostro_letrero:=true;

         if dm.sqlselect(dm.q1,'select cprog from tsprog '+
            ' where cbib='+g_q+cmbbiblioteca.Text+g_q+
            ' and cclase='+g_q+cmbclase.Text+g_q+
            ' order by cprog') then begin
            while not dm.q1.Eof do begin
               compos.Add(dm.q1.fieldbyname('cprog').AsString);
               dm.q1.Next;
            end;
         end;
      end;
   end
   else
   if chkruta.Checked then begin
      for i := 0 to lbxarchivo.Items.Count - 1 do begin
         if lbxarchivo.Selected[ i ] then
            compos.Add( lbxarchivo.Items[ i ] );
      end
   end
   else begin
      for i := 0 to archivo.Items.Count - 1 do begin       //multiple seleccion 
         if archivo.Selected[ i ] then
            compos.Add( archivo.Items[ i ] );
      end;
   end;

   if compos.Count = 0 then begin
      barchivo.Enabled := false;
      exit;
   end;

   //screen.Cursor := crsqlwait;
   screen.Cursor := crNo;     // alk para cambiar el cursor
   gral.PubMuestraProgresBar( true );     // alk para barra de espera


   inicio := now;
   b_dobleclick:=false;
   ptsrec.checa_case_sensitive(cmbsistema.Text);
   if ptsrec.recibeclick( compos,'ptsrecibe',
      cmboficina.text,cmbsistema.text,cmbclase.text,
      cmbbiblioteca.text,txtsufijo.text,txtextra.text,
      chktodas.checked,chkruta.checked,chkextra.checked,chkexiste.checked,
      chkversion.checked,chkanaliza.checked,chkextension.checked,
      chkproduccion.checked,chkverifica.checked,chknombre_version.checked,
      yextra.Visible,chkparams.checked,chkcopys.checked,
      rgnombre.ItemIndex,
      dir.directory,
      cla_tipo,
      herramienta,
      barra,
      rxfc.Lines,
      txtreemplaza1.text,txtreemplaza2.text)=false then begin
      showmessage('Hubo componentes inconsistentes, favor de seleccionar otra vez');
      if chkruta.Checked then begin
         lbxarchivo.Visible := true;
         lbxarchivo.Items.Clear;
         if ( length( dir.Directory ) = 3 ) and ( copy( dir.Directory, 2, 2 ) = ':\' ) then
            exit;
         Adddirectories( dir.Directory, lbxarchivo, txtsufijo.Text );
      end
      else begin
         archivo.mask:='*.nada';
         archivo.Mask := txtsufijo.Text;
      end;
      exit;
   end;

   if fileexists(g_tmpdir+'\OBSERVACIONES.csv') then begin
      mens:=g_tmpdir+'\OBSERVACIONES'+formatdatetime('YYMMDDHHMMSS',now)+'.csv';
      copyfile(pchar(g_tmpdir+'\OBSERVACIONES.csv'),pchar(mens),false);
      shellexecute( Handle, nil, pchar(mens),nil, nil, SW_SHOW );
   end;

   ptsrec.regresa_case_sensitive;
   fin := now;
   if chkproduccion.Checked=false then begin
      dm.sqldelete( 'delete from parametro ' + // guarda ultimo directorio de donde se cargó
         ' where clave=' + g_q + 'dir_' + cmbsistema.Text + '_' + cmbclase.Text + '_' + cmbbiblioteca.Text + g_q );
      dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' +
         g_q + 'dir_' + cmbsistema.Text + '_' + cmbclase.Text + '_' + cmbbiblioteca.Text + g_q + ',1,' +
         g_q + dir.Directory + g_q + ')' );
      dm.sqldelete( 'delete from parametro ' + // guarda ultima máscara
         ' where clave=' + g_q + 'mask_' + cmbsistema.Text + '_' + cmbclase.Text + '_' + cmbbiblioteca.Text + g_q );
      if trim( txtsufijo.Text ) <> '' then
         dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' +
            g_q + 'mask_' + cmbsistema.Text + '_' + cmbclase.Text + '_' + cmbbiblioteca.Text + g_q + ',1,' +
            g_q + txtsufijo.Text + g_q + ')' );
   end;
   if chkextra.Visible then begin
      if chkextra.Checked then
         verdad := 'TRUE'
      else
         verdad := 'FALSE';
      dm.sqldelete('delete parametro '+
         ' where clave='+g_q+'chkextra_' + cmbsistema.Text + '_' + cmbclase.Text + '_' + cmbbiblioteca.Text + g_q +
         ' and secuencia=1');
      dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' +
         g_q + 'chkextra_' + cmbsistema.Text + '_' + cmbclase.Text + '_' + cmbbiblioteca.Text + g_q + ',1,' +
         g_q + verdad + g_q + ')' );
   end;
   if (chkruta.Visible) and (chkproduccion.Checked=false) then begin
      if chkruta.Checked then
         verdad := 'TRUE'
      else
         verdad := 'FALSE';
      dm.sqldelete('delete parametro '+
         ' where clave='+g_q+ 'chkruta_' + cmbsistema.Text + '_' + cmbclase.Text + '_' + cmbbiblioteca.Text + g_q +
         ' and secuencia=1');
      dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' +
         g_q + 'chkruta_' + cmbsistema.Text + '_' + cmbclase.Text + '_' + cmbbiblioteca.Text + g_q + ',1,' +
         g_q + verdad + g_q + ')' );
   end;
   if (chkextension.Visible) and (chkproduccion.Checked=false) then begin
      if chkextension.Checked then
         verdad := 'TRUE'
      else
         verdad := 'FALSE';
      dm.sqldelete('delete parametro '+
         ' where clave='+g_q+ 'chkextension_' + cmbsistema.Text + '_' + cmbclase.Text + '_' + cmbbiblioteca.Text + g_q +
         ' and secuencia=1');
      dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' +
         g_q + 'chkextension_' + cmbsistema.Text + '_' + cmbclase.Text + '_' + cmbbiblioteca.Text + g_q + ',1,' +
         g_q + verdad + g_q + ')' );
   end;
   if (chknombre_version.Visible) and (chkproduccion.Checked=false) then begin
      if chknombre_version.Checked then
         verdad := 'TRUE'
      else
         verdad := 'FALSE';
      dm.sqldelete('delete parametro '+
         ' where clave='+g_q+ 'chknombre_version_' + cmbsistema.Text + '_' + cmbclase.Text + '_' + cmbbiblioteca.Text + g_q +
         ' and secuencia=1');
      dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' +
         g_q + 'chknombre_version_' + cmbsistema.Text + '_' + cmbclase.Text + '_' + cmbbiblioteca.Text + g_q + ',1,' +
         g_q + verdad + g_q + ')' );
   end;
   if (chkcopys.Visible) and (chkproduccion.Checked=false) then begin
      if chkcopys.Checked then
         verdad := 'TRUE'
      else
         verdad := 'FALSE';
      dm.sqldelete('delete parametro '+
         ' where clave='+g_q+ 'chkcopys_' + cmbsistema.Text + '_' + cmbclase.Text + '_' + cmbbiblioteca.Text + g_q +
         ' and secuencia=1');
      dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' +
         g_q + 'chkcopys_' + cmbsistema.Text + '_' + cmbclase.Text + '_' + cmbbiblioteca.Text + g_q + ',1,' +
         g_q + verdad + g_q + ')' );
   end;
   if (chkreemplaza.Visible) and (chkproduccion.Checked=false) then begin
      dm.sqldelete('delete parametro '+
         ' where clave='+g_q+ 'chkreemplaza_' + cmbsistema.Text + '_' + cmbclase.Text + '_' + cmbbiblioteca.Text + g_q);
      if (chkreemplaza.Checked) and (txtreemplaza1.text<>'') then begin
         dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' +
            g_q + 'chkreemplaza_' + cmbsistema.Text + '_' + cmbclase.Text + '_' + cmbbiblioteca.Text + g_q + ',1,' +
            g_q + txtreemplaza1.Text + g_q + ')' );
         dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' +
            g_q + 'chkreemplaza_' + cmbsistema.Text + '_' + cmbclase.Text + '_' + cmbbiblioteca.Text + g_q + ',2,' +
            g_q + txtreemplaza2.Text + g_q + ')' );
      end;
   end;
   if (rgnombre.Visible) and (chkproduccion.Checked=false) then begin
      dm.sqldelete('delete parametro '+
         ' where clave='+g_q+ 'rgnombre_' + cmbsistema.Text + '_' + cmbclase.Text + '_' + cmbbiblioteca.Text + g_q);
      dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' +
         g_q + 'rgnombre_' + cmbsistema.Text + '_' + cmbclase.Text + '_' + cmbbiblioteca.Text + g_q + ','+
         inttostr(rgnombre.ItemIndex)+',' +
         g_q + '' + g_q + ')' );
   end;

   barra.Visible := false;
   tsprog.close;
   tsprog.Open;
   abre_cierra_tsversion;
   ftsrecibe.Enabled := true;

   //screen.Cursor := crdefault;

   screen.Cursor := crdefault;
   gral.PubMuestraProgresBar( False );


   if compos.Count > 0 then begin
      i := secondsbetween( fin, inicio );
      mens := dm.xlng( inttostr( compos.Count ) + ' archivos procesados en ' +
         inttostr( i div 3600 ) + ' Hrs ' +
         inttostr( ( i mod 3600 ) div 60 ) + ' Min ' +
         inttostr( ( i mod 3600 ) mod 60 ) + ' Seg ' );
      if dm.sqlselect(dm.q1,'select count(*) cuenta from tsversion '+
         ' where cblob>'+g_q+formatdatetime('YYYYMMDDHHNN', inicio)+g_q) then
         mens:=mens+'('+dm.q1.fieldbyname('cuenta').AsString+' efectivos)';
      g_log.add( formatdatetime( 'YYYYMMDD-HHNNSS', now )+ '|' + 'ftsrecibe.barchivoClick|' +
         cmboficina.Text + '|' + cmbsistema.Text + '|' + cmbclase.Text + '|' +
         cmbbiblioteca.Text + '|' + dir.Directory + '|' + mens );
      if b_todos = false then begin
         Application.MessageBox( pchar( dm.xlng( mens ) ),
            pchar( dm.xlng( 'Procesar archivos ' ) ), MB_OK );
      end;
      hubo_procesados:=true;
   end;
   {
   if ( compos.Count > 0 ) and ( b_todos = false ) then
      gral.LimpiaInventario;
   }
   compos.free;

   gtsversion.Visible:=true;
   gtsprog.Visible:=true;
end;

procedure Tftsrecibe.abre_cierra_tsversion;
begin
   tsversion.Close;
   tsversion.SQL.Clear;
   tsversion.SQL.Add( 'select cprog,cbib,cclase,fecha,cuser,tsversion.cblob,magic from tsversion ' +
      ' where cprog=' + g_q + nombre_componente( archivo_master ) + g_q +
      ' and   cbib=' + g_q + cmbbiblioteca.Text + g_q +
      ' and   cclase=' + g_q + cmbclase.Text + g_q +
      ' order by fecha desc' );
   tsversion.Open;
end;

procedure Tftsrecibe.archivoClick( Sender: TObject );
var
   nombre: string;
begin
   if sender is Tfilelistbox then begin
      if trim( archivo.FileName ) = '' then
         exit;
      rxfuente.Lines.LoadFromFile( archivo.FileName );
      habilita;
      iHelpContext := IDH_TOPIC_T01727;
      archivo_master := archivo.FileName;
      pie.Caption := inttostr( archivo.SelCount ) + ' archivos seleccionados';
   end;
   if sender is Tlistbox then begin
      nombre := lbxarchivo.Items[ lbxarchivo.itemindex ];
      if trim( nombre ) = '' then
         exit;
      rxfuente.Lines.LoadFromFile( dir.Directory + '\' + nombre );
      habilita;
      nombre := stringreplace( nombre, '/', '.', [ rfreplaceall ] );
      nombre := stringreplace( nombre, '\', '.', [ rfreplaceall ] );
      archivo_master := nombre;
      pie.Caption := inttostr( lbxarchivo.SelCount ) + ' archivos seleccionados';
   end;
   if barchivo.Enabled or ( sender is TDBGRID ) then begin
      abre_cierra_tsversion;
   end;
   iHelpContext := IDH_TOPIC_T01727;

end;

procedure Tftsrecibe.gtsprogCellClick( Column: TColumn );
begin
   iHelpContext := IDH_TOPIC_T01723;
   archivo_master := tsprog.fieldbyname( 'cprog' ).AsString;
   archivoclick( gtsprog );
   //poparchivopopgral;
end;

procedure Tftsrecibe.comparafuente( Sender: TObject );
var
   ite: Tmenuitem;
   hta, versio, tempo, coma: string;
begin
   ite := sender as Tmenuitem;
   hta := g_tmpdir + '\svshtacom' + formatdatetime( 'YYMMDDHHNNSS', now ) + '.exe';
   dm.get_utileria( 'COMPARACION DE FUENTES', hta );
   //tempo := stringreplace( ite.Caption, ':', '', [ rfreplaceall ] );
   //tempo := stringreplace( tempo, ' ', '', [ rfreplaceall ] );
   //tempo := stringreplace( tempo, '/', '', [ rfreplaceall ] );
   //tempo := stringreplace( tempo, '&', '', [ rfreplaceall ] );
   tempo:=ite.hint;
   versio := dm.pathbib( cmbbiblioteca.Text, cmbclase.Text ) + '\versiones\' + ptscomun.cprog2bfile(nombre_componente( archivo_master) ) + '.' + tempo;
   tempo := g_tmpdir + '\svs' + tempo;
   copyfile( pchar( versio ), pchar( tempo ), false );
   g_borrar.Add( tempo );
   if archivo_master <> archivo.FileName then begin // determina si se archivo o biblioteca
      coma := g_tmpdir + '\' + ptscomun.cprog2bfile(nombre_componente(archivo_master)) + '_prd';
      //copyfile( pchar( bib_dir + '\' + archivo_master ), pchar( coma ), false );
      copyfile( pchar( bib_dir + '\' + cmbclase.Text + '\' +ptscomun.cprog2bfile(nombre_componente(archivo_master)) ), pchar( coma ), false );
      g_borrar.Add( coma );
      coma := coma + ' ' + tempo;
   end
   else
      coma := '"' + archivo.FileName + '" ' + tempo;
   if ShellExecute( Handle, nil, pchar( hta ), pchar( coma ), nil, SW_SHOW ) <= 32 then
      Application.MessageBox( pchar( dm.xlng( 'No puede ejecutar la comparacion' ) ),
                              pchar( dm.xlng( 'Error' ) ), MB_ICONEXCLAMATION );
end;

procedure Tftsrecibe.eliminacomponente( Sender: TObject );
var
   clase, bib, nombre, blo: string;
begin
   clase := tsprog.fieldbyname( 'cclase' ).AsString;
   bib := tsprog.fieldbyname( 'cbib' ).AsString;
   nombre := tsprog.fieldbyname( 'cprog' ).AsString;
   blo := tsprog.fieldbyname( 'cblob' ).AsString;

   dm.sqldelete( 'delete tsrela ' +
      ' where ocprog=' + g_q + nombre + g_q +
      ' and   ocbib=' + g_q + bib + g_q +
      ' and   occlase=' + g_q + clase + g_q );
   dm.sqldelete( 'delete from tsprog ' +
      ' where cprog=' + g_q + nombre + g_q +
      ' and   cbib=' + g_q + bib + g_q +
      ' and   cclase=' + g_q + clase + g_q );
   dm.sqldelete( 'delete from tsattribute ' +
      ' where cprog=' + g_q + nombre + g_q +
      ' and   cbib=' + g_q + bib + g_q +
      ' and   cclase=' + g_q + clase + g_q );
   dm.sqlupdate( 'update tsrela set hcbib=' + g_q + 'SCRATCH' + g_q +
      ' where hcprog=' + g_q + nombre + g_q +
      ' and   hcbib=' + g_q + bib + g_q +
      ' and   hcclase=' + g_q + clase + g_q );
   tsprog.close;
   tsprog.Open;
   hubo_procesados:=true;
end;
procedure Tftsrecibe.eliminabiblioteca( Sender: TObject );
begin
   if application.MessageBox('Desea eliminar TODOS los elementos de la biblioteca?','Confirme',MB_YESNO)=IDNO then
      exit;
   tsprog.First;
   while tsprog.RecordCount>0 do
      eliminacomponente(sender);
end;
procedure Tftsrecibe.cmbclaseClick( Sender: TObject );
begin

   chkanaliza.Enabled := false;
   if dm.sqlselect( dm.q1, 'select * from tsclase ' +
      ' where cclase=' + g_q + cmbclase.Text + g_q ) then begin
      chkanaliza.Enabled := ( dm.q1.fieldbyname( 'tipo' ).asstring = 'ANALIZABLE' );
      herramienta := dm.q1.fieldbyname( 'analizador' ).asstring;
   end;

   if trim( txtsufijo.Text ) = '' then
      txtsufijo.Text := '*.' + cmbclase.Text;
   chkanaliza.Checked := chkanaliza.Enabled;
   iHelpContext := IDH_TOPIC_T01708;
end;

procedure Tftsrecibe.poparchivoPopup( Sender: TObject );
var
   ite: Tmenuitem;
   dbg: Tdbgrid;
   fil: Tfilelistbox;
begin
   if tsprog.Active = false then
      exit;
   if poparchivo.PopupComponent is Tfilelistbox then begin
      fil := ( poparchivo.PopupComponent as Tfilelistbox );
      fil.OnClick( archivo );
   end;
   if poparchivo.PopupComponent is TDBGrid then begin
      dbg := ( poparchivo.PopupComponent as TDBGrid );
      dbg.OnCellClick( dbg.Columns[ 0 ] );
   end;
   poparchivo.Items.Clear;
   ite := Tmenuitem.Create( self );
   ite.Caption := dm.xlng( '[' + archivo_master + '] Compara con:' );
   poparchivo.Items.Add( ite );
   ite := Tmenuitem.Create( self );
   ite.Caption := '-';
   poparchivo.Items.Add( ite );
   tsversion.First;
   while not tsversion.Eof do begin
      ite := Tmenuitem.Create( self );
      ite.Caption := formatdatetime( 'YYYY/MM/DD HH:NN:SS', tsversion.fieldbyname( 'fecha' ).asdatetime );
      ite.Hint := tsversion.fieldbyname( 'cblob' ).AsString;
      ite.OnClick := comparafuente;
      poparchivo.Items.Add( ite );
      tsversion.Next;
   end;
   tsversion.First;
   ite := Tmenuitem.Create( self );
   ite.Caption := '-';
   poparchivo.Items.Add( ite );
   if poparchivo.PopupComponent is TDBGrid then begin
      if tsprog.RecordCount = 0 then
         exit;

      ite := Tmenuitem.Create( self );
      ite.Caption := dm.xlng( 'ELIMINAR' );
      ite.Hint := dm.xlng( 'Elimina el componente de la Base de Conocimiento' );
      ite.OnClick := eliminacomponente;
      poparchivo.Items.Add( ite );

      ite := Tmenuitem.Create( self );
      ite.Caption := dm.xlng( 'ELIMINAR BIBLIOTECA' );
      ite.Hint := dm.xlng( 'Elimina TODOS los componentes de la biblioteca' );
      ite.OnClick := eliminabiblioteca;
      poparchivo.Items.Add( ite );

   end;
end;

procedure Tftsrecibe.poparchivopopgral;
var
   ite: Tmenuitem;
   dbg: Tdbgrid;
   fil: Tfilelistbox;
begin
   if tsprog.Active = false then
      exit;
   if gral.popgral.PopupComponent is Tfilelistbox then begin
      fil := ( gral.popgral.PopupComponent as Tfilelistbox );
      fil.OnClick( archivo );
   end;
   if gral.popgral.PopupComponent is TDBGrid then begin
      dbg := ( gral.popgral.PopupComponent as TDBGrid );
      dbg.OnCellClick( dbg.Columns[ 0 ] );
   end;
   gral.popgral.Items.Clear;
   ite := Tmenuitem.Create( self );
   ite.Caption := dm.xlng( '[' + archivo_master + '] Compara con:' );
   gral.popgral.Items.Add( ite );
   ite := Tmenuitem.Create( self );
   ite.Caption := '-';
   gral.popgral.Items.Add( ite );
   tsversion.First;
   while not tsversion.Eof do begin
      ite := Tmenuitem.Create( self );
      ite.Caption := formatdatetime( 'YYYY/MM/DD HH:NN:SS', tsversion.fieldbyname( 'fecha' ).asdatetime );
      ite.Hint := tsversion.fieldbyname( 'cblob' ).AsString;
      ite.OnClick := comparafuente;
      gral.popgral.Items.Add( ite );
      tsversion.Next;
   end;
   tsversion.First;
   ite := Tmenuitem.Create( self );
   ite.Caption := '-';
   gral.popgral.Items.Add( ite );
   if gral.popgral.PopupComponent is TDBGrid then begin
      if tsprog.RecordCount = 0 then
         exit;

      ite := Tmenuitem.Create( self );
      ite.Caption := dm.xlng( 'ELIMINAR' );
      ite.Hint := dm.xlng( 'Elimina el componente de la Base de Conocimiento' );
      ite.OnClick := eliminacomponente;
      gral.popgral.Items.Add( ite );
   end;
end;



procedure Tftsrecibe.bsalirClick( Sender: TObject );
begin
   close;
end;

procedure Tftsrecibe.blogClick( Sender: TObject );
begin
   rxfuente.Clear;
   rxfuente.Lines.AddStrings( g_log );
   tv.Visible:=false;
   rxfuente.Visible:=true;
   g_log.SaveToFile( g_tmpdir + '\Recepcion' + formatdatetime( 'YYYYMMDD-HHNNSS', now ) + '.txt' );
   g_log.Clear;
   iHelpContext := HTML_HELP.IDH_TOPIC_T01730;
end;

procedure Tftsrecibe.Splitter6Moved( Sender: TObject );
begin
   cmbbiblioteca.Width := groupbox2.Width - 20;
end;

procedure Tftsrecibe.chkrutaClick( Sender: TObject );
begin
   iHelpContext := IDH_TOPIC_T01703;
   if chkruta.Checked then begin
      lbxarchivo.Visible := true;
      lbxarchivo.Items.Clear;
      if ( length( dir.Directory ) = 3 ) and ( copy( dir.Directory, 2, 2 ) = ':\' ) then
         exit; // si está en Raiz "c:\"
      Adddirectories( dir.Directory, lbxarchivo, txtsufijo.Text );
   end
   else begin
      lbxarchivo.Visible := false;
   end;
end;

procedure Tftsrecibe.AddDirectories( cPath: string; lista: Tlistbox; mascara: string );
var
   sr, fl: TSearchRec;
   dirattrs, FileAttrs: Integer;
begin
   FileAttrs := faArchive;
   if FindFirst( cPath + '\' + mascara, FileAttrs, fl ) = 0 then begin
      repeat
         if ( ( fl.Attr and faArchive ) <> 0 ) then begin
            if cPath = dir.Directory then
               lista.Items.Add( fl.Name )
            else
               lista.Items.Add( copy( cPath, length( dir.Directory ) + 2, 500 ) + '\' + fl.Name );
         end;
      until FindNext( fl ) <> 0;
      FindClose( fl );
   end;
   //dirAttrs := faDirectory;
   dirAttrs := faAnyfile;
   if FindFirst( cPath + '\*.*', dirAttrs, sr ) = 0 then begin
      repeat
         // if ( ( sr.Attr and faDirectory ) = sr.Attr ) and ( copy( sr.Name, 1, 1 ) <> '.' ) then begin
         if ( (sr.Attr AND faDirectory) = faDirectory) and ( copy( sr.Name, 1, 1 ) <> '.' ) then begin
            AddDirectories( cPath + '\' + sr.Name, lista, mascara );
         end;
      until FindNext( sr ) <> 0;
      FindClose( sr );
   end;
end;

procedure Tftsrecibe.dirMouseDown( Sender: TObject; Button: TMouseButton;
   Shift: TShiftState; X, Y: Integer );
begin
   if chkruta.Checked then begin
      lbxarchivo.Visible := true;
      lbxarchivo.Items.Clear;
      if ( length( dir.Directory ) = 3 ) and ( copy( dir.Directory, 2, 2 ) = ':\' ) then
         exit;
      Adddirectories( dir.Directory, lbxarchivo, txtsufijo.Text );
   end;
end;

procedure Tftsrecibe.butileriaClick( Sender: TObject );
begin
   PR_UTILERIA;
end;

procedure Tftsrecibe.chkextraClick( Sender: TObject );
begin
   txtextra.Enabled := chkextra.Checked;
   iHelpContext := IDH_TOPIC_T01718;
end;

procedure Tftsrecibe.chktodasClick( Sender: TObject );
begin
   iHelpContext := IDH_TOPIC_T01709;
   if ( chktodas.Checked = false ) and ( trim( cmbbiblioteca.Text ) = '' ) and ( trim( cmbclase.Text ) <> '') and ( trim( cmbsistema.Text ) <> '' ) then
      dm.feed_combo( cmbbiblioteca, 'select distinct cbib from tsprog '+
         ' where cclase=' + g_q + cmbclase.Text + g_q +
         ' and sistema='+g_q+cmbsistema.Text+g_q+
         ' order  by cbib' )
   else
      dm.feed_combo( cmbbiblioteca, 'select cbib from tsbib order by cbib' );
end;

procedure Tftsrecibe.mnuCargaUtileriaClick(Sender: TObject);
begin
   PR_UTILERIA;
end;

procedure Tftsrecibe.mnuTodasLasLibreriasClick(Sender: TObject);
var
   i: integer;
begin
   if application.MessageBox( 'Procesará todas las librerias listadas, correcto?', 'Confirme', MB_YESNO ) = IDNO then
      exit;
   b_todos := true;
   b_mostro_letrero:=false;
   for i := 0 to cmbbiblioteca.Items.Count - 1 do begin
      cmbbiblioteca.ItemIndex := i;
      cmbsistemachange( cmbbiblioteca );
      bseltodoClick( Sender );
      if barchivo.Enabled then
         barchivoclick( sender );
   end;
   b_todos := false;
end;



function Tftsrecibe.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
 {  try
      HtmlHelp(Application.Handle,
            PChar(Format('%s::/T%5.5d.htm',
           //[Application.HelpFile,ActiveControl.HelpContext])),HH_DISPLAY_TOPIC, 0);
           [Application.HelpFile,iHelpContext ])),HH_DISPLAY_TOPIC, 0);
      CallHelp := False;
   except
      Application.MessageBox( 'No existe ayuda para la pantalla ó campo seleccionado','Ayuda ' , MB_OK );
   end;
   }
end;

procedure Tftsrecibe.mnuAyudaClick(Sender: TObject);
begin

   try
      HtmlHelp(Application.Handle,
            PChar(Format('%s::/T%5.5d.htm',
           //[Application.HelpFile,ActiveControl.HelpContext])),HH_DISPLAY_TOPIC, 0);
           [ Application.HelpFile,iHelpContext ])),HH_DISPLAY_TOPIC, 0);
   except
      Application.MessageBox( 'No existe ayuda para la pantalla ó campo seleccionado','Ayuda ' , MB_OK );
   end;
   iHelpContext := HTML_HELP.IDH_TOPIC_T01700;
end;

procedure Tftsrecibe.grbRecepcionClick(Sender: TObject);
begin
   iHelpContext := IDH_TOPIC_T01701;
end;

procedure Tftsrecibe.rgnombreClick(Sender: TObject);
begin
   iHelpContext := HTML_HELP.IDH_TOPIC_T01728;
end;

procedure Tftsrecibe.DriveClick(Sender: TObject);
begin
   iHelpContext := IDH_TOPIC_T01702;
end;

procedure Tftsrecibe.cmbsistemaClick(Sender: TObject);
begin
   iHelpContext := IDH_TOPIC_T01704;
   alkSistema:=cmbsistema.Text;
end;

procedure Tftsrecibe.cmbbibliotecaClick(Sender: TObject);
begin
   iHelpContext := IDH_TOPIC_T01705;
end;

procedure Tftsrecibe.txtsufijoClick(Sender: TObject);
begin
iHelpContext := IDH_TOPIC_T01712;
end;

procedure Tftsrecibe.txtextraClick(Sender: TObject);
begin
   iHelpContext := IDH_TOPIC_T01720;
end;

procedure Tftsrecibe.chkexisteClick(Sender: TObject);
begin
   iHelpContext := IDH_TOPIC_T01721;
end;

procedure Tftsrecibe.chkversionClick(Sender: TObject);
begin
iHelpContext := IDH_TOPIC_T01722;
end;

procedure Tftsrecibe.chkanalizaClick(Sender: TObject);
begin
   iHelpContext := IDH_TOPIC_T01724;
end;

procedure Tftsrecibe.chkextensionClick(Sender: TObject);
begin
   iHelpContext := IDH_TOPIC_T01725;
end;

procedure Tftsrecibe.chkverificaClick(Sender: TObject);
begin
   iHelpContext := IDH_TOPIC_T01707;
end;

procedure Tftsrecibe.chkparamsClick(Sender: TObject);
begin
   iHelpContext := IDH_TOPIC_T01707;
end;

procedure Tftsrecibe.rxfcClick(Sender: TObject);
begin
   iHelpContext := IDH_TOPIC_T01710;
end;

procedure Tftsrecibe.rxfuenteClick(Sender: TObject);
begin
   iHelpContext := IDH_TOPIC_T01714;
end;

procedure Tftsrecibe.gtsversionCellClick(Column: TColumn);
begin
   iHelpContext := IDH_TOPIC_T01727;

end;

procedure Tftsrecibe.dirClick(Sender: TObject);
begin
   iHelpContext := IDH_TOPIC_T01711;

end;

procedure Tftsrecibe.cmboficinaClick(Sender: TObject);
begin
   iHelpContext := IDH_TOPIC_T01706;
end;


procedure Tftsrecibe.chkproduccionClick(Sender: TObject);
var i:integer;
begin
   for i:=0 to componentcount-1 do begin
      if components[i] is Tcheckbox then begin
         if (components[i] as Tcheckbox).Visible then
            (components[i] as Tcheckbox).Enabled:=not chkproduccion.Checked;
      end;
   end;
   if chkproduccion.Checked then
      chknombre_version.Checked:=false;
   grbrecepcion.Visible:=not chkproduccion.Checked;
   chkproduccion.Enabled:=true;
   barchivo.Enabled:=true;
end;

procedure Tftsrecibe.gtsprogDblClick(Sender: TObject);
begin
   archivo_master := tsprog.fieldbyname( 'cprog' ).AsString;
   if chkproduccion.Checked then begin
      b_dobleclick:=true;
      barchivoclick(self);
   end;
end;

procedure Tftsrecibe.chknombre_versionClick(Sender: TObject);
begin
   iHelpContext := IDH_TOPIC_T01707;
end;

procedure Tftsrecibe.chkreemplazaClick(Sender: TObject);
begin
   if chkreemplaza.checked=false then begin
      txtreemplaza1.text:='';
      txtreemplaza2.text:='';
   end;
end;

procedure Tftsrecibe.crea_nodo(nodo:TTreenode; clase,bib,prog:string);
var   reg,reg2: ^Ttvrec;
   tp,th:Ttreenode;
   dato:string;
begin
   dato:=clase+' '+lowercase(bib)+' '+prog;
   if nodo=nil then begin
      tp := tv.Items.AddFirst( nil, dato );
      new( reg );
      reg.occlase:=clase;
      reg.ocbib:=bib;
      reg.ocprog:=prog;
      reg.hclase := clase;
      reg.hbiblioteca:=bib;
      reg.hnombre:=prog;
      tp.Data := reg;
      tp.ImageIndex := dm.lclases.IndexOf( reg.hclase );
      tp.SelectedIndex := 0; //dm.lclases.IndexOf( reg.hclase );
   end
   else begin
      tp := nodo;
      tp.Text:=dato;
      reg:=tp.Data;
   end;

   th:=tp.Parent;
   while th<>nil do begin
      if tp.Text=th.Text then begin
         tp.Text:=tp.Text+' (ciclado)';
         exit;
      end;
      th:=th.Parent;
   end;

   if dm.sqlselect(dm.q1,'select distinct hcclase,hcbib,hcprog,orden from tsrela '+
      ' where pcprog='+g_q+prog+g_q+
      ' and   pcbib='+g_q+bib+g_q+
      ' and   pcclase='+g_q+clase+g_q+
      ' order by orden') then begin
      while not dm.q1.Eof do begin
         th:=tv.Items.AddChild( tp, 'hijo' );
         new( reg );
         reg.hclase := dm.q1.fieldbyname('hcclase').AsString;
         reg.hbiblioteca:=dm.q1.fieldbyname('hcbib').AsString;
         reg.hnombre:=dm.q1.fieldbyname('hcprog').AsString;
         th.Data := reg;
         th.ImageIndex := dm.lclases.IndexOf( reg.hclase );
         th.SelectedIndex := 0; //dm.lclases.IndexOf( reg.hclase );
         dm.q1.Next;
      end;
   end;
end;
procedure Tftsrecibe.barbolClick(Sender: TObject);
var i:integer;
begin
   if chkproduccion.Checked then begin
      if tsprog.RecNo<1 then exit;
      este:=tsprog.fieldbyname('cprog').AsString;
   end
   else
   if chkruta.Checked then begin
      if lbxarchivo.SelCount<>1 then exit;
      este:=lbxarchivo.Items[lbxarchivo.ItemIndex];
      este:=nombre_componente(este);
   end
   else begin
      if archivo.SelCount<>1 then exit;
      este:=archivo.items[archivo.itemindex];
      este:=nombre_componente(este);
   end;
   //tv.Items.Free;
   if tv.Items.Count>0 then begin
      for i:=0 to tv.Items.Count-1 do
         freemem(tv.Items[i].Data);
      tv.Items[0].Delete;
   end;
   tv.Visible:=true;
   rxfuente.Visible:=false;
   crea_nodo(nil,cmbclase.Text,cmbbiblioteca.Text,este);

end;

procedure Tftsrecibe.tvExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
var tt:Ttreenode;
   reg: ^Ttvrec;
begin
   tt:=node.getFirstChild;
   while tt<>nil do begin
      if tt.Text='hijo' then begin
         reg:=tt.Data;
         crea_nodo(tt,reg.hclase,reg.hbiblioteca,reg.hnombre);
      end;
      tt:=node.GetNextChild(tt);
   end;
end;

procedure Tftsrecibe.rxfuenteDblClick(Sender: TObject);
begin
   rxfuente.Lines.SaveToFile(g_tmpdir+'\temporal.txt');
   shellexecute( Handle, nil, pchar(g_tmpdir+'\temporal.txt'),nil, nil, SW_SHOW );
   g_borrar.Add(g_tmpdir+'\temporal.txt');
end;

procedure Tftsrecibe.lbxarchivoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   With VertScrollbar do
      if Key = VK_NEXT then
         Position := Position + 10
      else if Key = VK_PRIOR then
         Position := Position - 10
      else
         Position := Position;
end;

procedure Tftsrecibe.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   gral.PubMuestraProgresBar( True );

   if hubo_procesados then
      gral.LimpiaInventario;

       //limpia la tabla tsproductos, para que si se dio de alta una clase nueva se actualize la información.
       // Esta forma es temporal en lo que termino la rutina de mantenimiento.
           dm.sqldelete( 'delete from tsproductos' );
           gral.CapacidadXProducto;

       actualiza_scratch_parcial;
       HookID := SetWindowsHookEx( WH_MOUSE, MouseProc, 0, GetCurrentThreadId( ) );

   if FormStyle = fsMDIChild then
      dm.PubEliminarVentanaActiva( ftsrecibe.Caption );  //quitar nombre de lista de abiertos

   gral.PubMuestraProgresBar( False );

   ftsrecibe.Destroy;
end;

procedure Tftsrecibe.FormDestroy(Sender: TObject);
begin
   {if hubo_procesados then
      gral.LimpiaInventario;

       //limpia la tabla tsproductos, para que si se dio de alta una clase nueva se actualize la información.
       // Esta forma es temporal en lo que termino la rutina de mantenimiento.
           dm.sqldelete( 'delete from tsproductos' );
           gral.CapacidadXProducto;
       //

       actualiza_scratch_parcial;
       HookID := SetWindowsHookEx( WH_MOUSE, MouseProc, 0, GetCurrentThreadId( ) );}
end;

end.

