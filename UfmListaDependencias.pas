unit UfmListaDependencias;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Printers,
   Dialogs, ufmSVSLista, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
   cxEdit, DB, cxDBData, dxPSGlbl, dxPSUtl, dxPSEngn, dxPrnPg, dxBkgnd, dxWrap, dxPrnDev,
   dxPSCompsProvider, dxPSFillPatterns, dxPSEdgePatterns, StdCtrls, ExtCtrls, cxGridTableView,
   ImgList, dxPSCore, dxPScxGridLnk, dxBarDBNav, dxmdaset, dxBar, cxGridLevel, cxClasses,
   cxControls, cxGridCustomView, cxGridCustomTableView, cxGridDBTableView, cxGrid, cxPC,
   cxEditRepositoryItems, ADODB, StrUtils, HTML_HELP, dxStatusBar, Buttons,
   cxSplitter;

{type
   Txx = record
      nivel: integer;
      claseo: string;
      bibo: string;
      nombreo: string;
      clasep: string;
      bibp: string;
      nombrep: string;
      clase: string;
      bib: string;
      nombre: string;
      modo: string;
      organizacion: string;
      externo: string;
      coment: string;
      existe: boolean;
      uso: integer;
      sistema: string;
   end;}
type
   Ttotal = record
      clase: string;
      total: integer;
   end;

type
   TfmListaDependencias = class( TfmSVSLista )
    PanelLista: TPanel;
    panelFantasma: TPanel;
    Image1: TImage;
    Panel5: TPanel;
    Label3: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    lbltotal: TLabel;
    Label4: TLabel;
    cmbclase: TComboBox;
    cmblibreria: TComboBox;
    cmbSistema: TComboBox;
    cmbmascara: TEdit;
    bejecuta: TBitBtn;
    BitBtn2: TBitBtn;
    TabDatosLista: TdxMemData;
    DataLista: TDataSource;
    listaComp: TcxGrid;
    cxGridDBTableViewLista: TcxGridDBTableView;
    cxGridLevelLista: TcxGridLevel;
    Splitter1: TcxSplitter;
      procedure FormCreate( Sender: TObject );
      procedure cmbclaseChange( Sender: TObject );
      procedure cmblibreriaChange( Sender: TObject );
//      procedure bClick( Sender: TObject );
      procedure lstcomponenteClick( sClase,sBib,sProg,sSistema: string );
      procedure lstcomponenteClick_ETP( sClase,sBib,sProg,sSistema: string );     //ALK para ETP's
      procedure lstcomponenteClickSistema( sClase,sBib,sProg,sSistema: string );
      procedure cmbmascaraChange( Sender: TObject );
      procedure Acercade1Click( Sender: TObject );
      procedure Salir1Click( Sender: TObject );
      procedure webBeforeNavigate2( Sender: TObject; const pDisp: IDispatch;
         var URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
         var Cancel: WordBool );
      function ArmarOpciones( b1: Tstringlist ): integer;
      procedure FormClose( Sender: TObject; var Action: TCloseAction );
      procedure webProgressChange( Sender: TObject; Progress,
         ProgressMax: Integer );
      procedure FormDeactivate( Sender: TObject );
      procedure FormActivate( Sender: TObject );
      procedure grdDatosDBTableView1DblClick( Sender: TObject );
      procedure dxBarButton1Click( Sender: TObject );
      procedure dxBarButton2Click( Sender: TObject );
      procedure dxBarButton3Click( Sender: TObject );
      procedure grdDatosDBTableView1FocusedRecordChanged(
         Sender: TcxCustomGridTableView; APrevFocusedRecord,
         AFocusedRecord: TcxCustomGridRecord;
         ANewItemRecordFocusingChanged: Boolean );
      procedure cmbSistemaChange( Sender: TObject );
    procedure bejecutaClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure cxGridDBTableViewListaDblClick(Sender: TObject);
   private
      { Private declarations }
      continua : integer;   // ALk out of memory
      erClase: TcxEditRepository; //framirez
      edClaseTypeImageCombo: TcxEditRepositoryImageComboBoxItem; //framirez
      imClaseTypes: TImageList; //framirez
      tt: array of Ttotal;
      bitmap: Tbitmap;
      lin, iy: integer;
      dgClase, dgLibreria, dgcomponente, dgModo, dgOrganizacion, dgExterno,
         dgComentario, dgExiste, dgusadopor, dgtotal: string;
      //b_impresion: boolean;
      Opciones: Tstringlist;
      sPriSistema: string;
      qconsulta: Tadoquery;
      oculta: integer;  //para indicar cuando aparece o desaparece panel fantasma
      sin_control: boolean;  // para indicar cuando quitar los controles  ALK
      aClases: array of string;
      //  ---  variables para nueva forma de capturar datos (archivo)   ALK  ----
      F: TextFile;
      contador_registros : integer;
      //  -----------------------------------------------------------------------
      procedure CreaWeb( );
      //procedure CreaArchivo( clase: string; bib: string; nombre: string );
      procedure leecompos( compo: string; bib: string; clase: string; sistema: string; g_nivel: integer );
      function agrega_compo( qq: Tadoquery ; g_nivel:integer ): boolean;
      procedure panel_fantasma(visible:boolean);
      procedure llena_combos_vacios(sParClase, sParBib, sParProg, sParSistema:String);
   public
      { Public declarations }
      titulo, error: string;
      repetido : TStringList;
      //archivo_selects:TStringList;    //registro de las consultas que se realizan
      procedure llenacombos(lista:TStringList);
      procedure arma3( clase: string; bib: string; nombre: string; sistema: string );
      procedure sin_controles(boton:integer);
   end;

var
   fmListaDependencias: TfmListaDependencias;
   Wprog, Wbib, Wclase, Wsistema: String;
   //x: array of Txx;
   //x1: array of Txx;
   f_top: integer;
   f_left: integer;
   WnomLogo: string;
   Wfecha: string;
   W_nomcomponente: string;
   v_compo: string;
   v_bib: string;
   v_clase: string;
   v_sistema: string;
   clases: Tstringlist;
   clasesexiste: Tstringlist;
   xx: Tstringlist;
   loc1, loc2: Tstringlist;
   excluyemenu: Tstringlist;
   Wciclado: String;
   aPriClases: array of string;
procedure PR_LISTADependencias;
//procedure lstcomparch2( clase: string; bib: string; nombre: string );
//procedure lstcomparch01( clase: string; bib: string; nombre: string );

implementation

uses ptsdm, facerca, ptsgral, ptsmain, uListaRutinas, uConstantes,parbol;

{$R *.dfm}

procedure PR_LISTADependencias;
begin
   gral.PubMuestraProgresBar( True );
   try
      {FmListaDependencias.cmbsistema.ItemIndex := FmListaDependencias.cmbsistema.Items.IndexOf( '' );
      FmListaDependencias.cmbsistemaChange( FmListaDependencias.cmbsistema );
      FmListaDependencias.cmbclase.ItemIndex := FmListaDependencias.cmbclase.Items.IndexOf( '' );
      FmListaDependencias.cmbclaseChange( FmListaDependencias.cmbclase );
      FmListaDependencias.cmblibreria.ItemIndex := FmListaDependencias.cmblibreria.Items.IndexOf( '' );
      FmListaDependencias.cmblibreriaChange( FmListaDependencias.cmblibreria );
      //FmListaDependencias.cmbmascara.ItemIndex := FmListaDependencias.cmbmascara.Items.IndexOf( '%' );
      FmListaDependencias.cmbmascaraChange( FmListaDependencias.cmbmascara );
      FmListaDependencias.lstcomponente.ItemIndex := FmListaDependencias.lstcomponente.Items.IndexOf( '' );
      FmListaDependencias.lstcomponenteClick( FmListaDependencias.lstcomponentef );     }
      FmListaDependencias.Show;
   finally
      gral.PubMuestraProgresBar( False );
   end;
end;

//prueba alk
procedure TFmListaDependencias.llenacombos(lista:TStringList);
begin
   cmbclase.Clear;
   cmblibreria.Clear;
   cmbmascara.Clear;
   cmbSistema.Clear;

   cmbclase.Items.Add(lista[0]);
   cmblibreria.Items.Add(lista[1]);
   cmbmascara.Text:=lista[2];   //cmbmascara.Items.Add(lista[2]);
   cmbSistema.Items.Add(lista[3]);

   cmbclase.ItemIndex:=cmbclase.Items.IndexOf(lista[0]);
   cmblibreria.ItemIndex:=cmblibreria.Items.IndexOf(lista[1]);
   //cmbmascara.ItemIndex:=cmbmascara.Items.IndexOf(lista[2]);
   cmbSistema.ItemIndex:=cmbSistema.Items.IndexOf(lista[3]);
end;

procedure TFmListaDependencias.arma3( clase: string; bib: string; nombre: string; sistema: string );
begin
   inherited;
   gral.PubMuestraProgresBar( True );
   bgral := clase + ' ' + bib + ' ' + nombre + ' ' + sistema;

   repetido.Clear;
   try
      caption := titulo;
      panel_fantasma(true);
      llena_combos_vacios(clase, bib, nombre, sistema);

      if nombre = 'SCRATCH' then
         abort;
      W_nomcomponente := nombre;

      if clase = 'EMPRESA' then exit;  // no debe de generar lista ni mandar errores

      if clase = 'SISTEMA' then begin
         lstcomponenteClickSistema( clase, bib, nombre, sistema );
      end
      else begin
         if (clase = 'ETP') or (clase = 'CTM') then begin
            cmbsistema.ItemIndex := cmbSistema.Items.IndexOf( sistema );
            cmbclase.ItemIndex := cmbclase.Items.IndexOf( clase );
            cmblibreria.ItemIndex := cmblibreria.Items.IndexOf( bib );
            cmbmascara.Text := nombre;
            lstcomponenteClick_ETP( clase, bib, nombre, sistema );     //ALK para ETP's

         end
         else begin
            cmbsistema.ItemIndex := cmbSistema.Items.IndexOf( sistema );
            cmbclase.ItemIndex := cmbclase.Items.IndexOf( clase );
            cmblibreria.ItemIndex := cmblibreria.Items.IndexOf( bib );
            cmbmascara.Text := nombre;
            lstcomponenteClick( clase, bib, nombre, sistema );
         end;
      end;
   finally
      gral.PubMuestraProgresBar( False );
      //archivo_selects.SaveToFile(g_tmpdir+'\ALK_'+stringreplace( trim( Caption ), ' ', '_', [ rfReplaceAll ] )+'.txt');
      //archivo_selects.Clear;
   end;
end;

procedure TfmListaDependencias.Acercade1Click( Sender: TObject );
begin
   inherited;

   PR_ACERCA;
end;

function TfmListaDependencias.agrega_compo( qq: Tadoquery ; g_nivel:integer): boolean;
var
   cc, cadena,existe,organizacion: string;
   n: integer;
begin
   inherited;
   try
      // ----- validar que no exista el dato  RGM ---------
      cc := v_compo + '|' + v_bib + '|' + v_clase + '|' +
            qq.FieldByName( 'ocprog' ).AsString + '|' +
            qq.FieldByName( 'ocbib' ).AsString + '|' +
            qq.FieldByName( 'occlase' ).AsString + '|' +
            qq.FieldByName( 'pcprog' ).AsString + '|' +
            qq.FieldByName( 'pcbib' ).AsString + '|' +
            qq.FieldByName( 'pcclase' ).AsString + '|' +
            qq.FieldByName( 'hcprog' ).AsString + '|' +
            qq.FieldByName( 'hcbib' ).AsString + '|' +
            qq.FieldByName( 'hcclase' ).AsString;
      if(xx.indexof(cc)>-1) then begin
         agrega_compo:=false;
         exit;
      end;
      xx.Add( cc );
      // --------------------------------------------------
      if not AnsiMatchStr( qq.FieldByName( 'hcclase' ).AsString, aClases ) then begin
         SetLength( aClases, Length( aClases ) + 1 );
         aClases[ Length( aClases ) - 1 ] := qq.FieldByName( 'hcclase' ).AsString;
      end;

      if dm.sqlselect( dm.q2, 'select * from tsprog ' +
            ' where cprog=' + g_q + qq.FieldByName( 'hcprog' ).AsString + g_q +
            ' and   cbib=' + g_q + qq.FieldByName( 'hcbib' ).AsString + g_q +
            ' and   cclase=' + g_q + qq.FieldByName( 'hcclase' ).AsString + g_q ) then
            existe := 'true'       // existe
      else
            existe := 'false';     // existe

      if qq.FieldByName( 'hcclase' ).AsString = 'FIL' then begin
         n := loc1.IndexOf( qq.FieldByName( 'externo' ).AsString );
         if n > -1 then
            organizacion := loc2[ n ];     // organizacion
      end
      else
         organizacion:=qq.FieldByName( 'organizacion' ).AsString;

      cadena:= '"' + IntToStr( g_nivel ) + '",' +  // nivel
            '"' + qq.FieldByName( 'hcclase' ).AsString + '",' +   //clase
            '"' + qq.FieldByName( 'hcbib' ).AsString + '",' +     // biblioteca
            '"' + StringReplace( qq.FieldByName( 'hcprog' ).AsString + trim( Wciclado ), '"', '', [ rfReplaceAll ] ) + '",' + //nombre
            '"' + qq.FieldByName( 'modo' ).AsString + '",' +    //modo
            '"' + organizacion + '",' +       // organizacion
            '"' + qq.FieldByName( 'externo' ).AsString + '",' + //externo
            '"' + qq.FieldByName( 'coment' ).AsString + '",' +   // comentario
            '"' + existe + '",' +          //existe
            '"' + qq.FieldByName( 'sistema' ).AsString + '"';    // sistema

      // --- agregar a un archivo los datos ----------------------
      AssignFile( F, g_tmpdir+'\dependencias.txt' );
      if FileExists( g_tmpdir+'\dependencias.txt' ) then
        Append( F )
      else
        Rewrite( F );
      WriteLn( F, cadena );  // agregar la cadena formada.
      CloseFile( F );

      contador_registros:=contador_registros+1;
      agrega_compo := true;
      // ---------------------------------------------------------

      // --- se cambia esto por agregarlo a un archivo para evitar error de out of memory.  ALK  ----------
      {k := length( x );
      setlength( x, k + 1 );
      mensaje := 'x=' + inttostr( k ) + '  ' + cc;
      x[ k ].nivel := g_nivel;
      x[ k ].nombreo := qq.FieldByName( 'ocprog' ).AsString;
      x[ k ].bibo := qq.FieldByName( 'ocbib' ).AsString;
      x[ k ].claseo := qq.FieldByName( 'occlase' ).AsString;
      x[ k ].nombrep := qq.FieldByName( 'pcprog' ).AsString;
      x[ k ].bibp := qq.FieldByName( 'pcbib' ).AsString;
      x[ k ].clasep := qq.FieldByName( 'pcclase' ).AsString;
      x[ k ].nombre := qq.FieldByName( 'hcprog' ).AsString + trim( Wciclado );
      x[ k ].bib := qq.FieldByName( 'hcbib' ).AsString;
      x[ k ].clase := qq.FieldByName( 'hcclase' ).AsString;
      x[ k ].modo := qq.FieldByName( 'modo' ).AsString;
      x[ k ].organizacion := qq.FieldByName( 'organizacion' ).AsString;
      x[ k ].externo := qq.FieldByName( 'externo' ).AsString;
      x[ k ].coment := qq.FieldByName( 'coment' ).AsString;
      if clasesexiste.IndexOf( x[ k ].clase ) > -1 then
         x[ k ].existe := dm.sqlselect( dm.q2, 'select * from tsprog ' +
            ' where cprog=' + g_q + qq.FieldByName( 'hcprog' ).AsString + g_q +
            ' and   cbib=' + g_q + qq.FieldByName( 'hcbib' ).AsString + g_q +
            ' and   cclase=' + g_q + qq.FieldByName( 'hcclase' ).AsString + g_q );
      x[ k ].sistema := qq.FieldByName( 'sistema' ).AsString;
      if qq.FieldByName( 'hcclase' ).AsString = 'FIL' then begin
         n := loc1.IndexOf( qq.FieldByName( 'externo' ).AsString );
         if n > -1 then
            x[ k ].organizacion := loc2[ n ];
      end;
      agrega_compo := true;}
   except
      continua:=1;
      agrega_compo:=false;
   end;
end;

function TfmListaDependencias.ArmarOpciones( b1: Tstringlist ): integer;
var
   mm: Tstringlist;
begin
   inherited;

   mm := Tstringlist.Create;
   mm.CommaText := bgral;

   if mm.count < 3 then begin
      Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
         pchar( dm.xlng( 'Lista opciones ' ) ), MB_OK );
      mm.free;
      exit;
   end;

   gral.EjecutaOpcionB( b1, 'Lista Componentes' );
   mm.free;
end;
{
procedure TfmListaDependencias.bClick( Sender: TObject );
var
   arch: string;
   i: integer;
begin
   inherited;

   gral.BorraIconosTmp( );
   gral.BorraRutinasjs( );
   arch := g_tmpdir + g_tmpdir + '\LD' + W_nomcomponente + '.html';
   g_borrar.Add( arch );
   arch := g_tmpdir + g_tmpdir + '\LD' + W_nomcomponente + 'IMP.html';
   g_borrar.Add( arch );
   close;
end;
}
procedure TfmListaDependencias.cmbclaseChange( Sender: TObject );
var
   sis, cla, cons: string;
begin
   inherited;

   panel_fantasma(false);
   cmblibreria.Clear;
   cmblibreria.Enabled:=false;
   cmbmascara.Clear;
   cmbmascara.Enabled:=false;
   bejecuta.Enabled:=false;

   if cmbclase.Text ='' then exit;

   if cmbSistema.Text <> 'TODOS LOS SISTEMAS' then begin
      sis:=  ' where  sistema = ' + g_q + cmbSistema.Text + g_q;
      if cmbclase.Text <> 'TODAS LAS CLASES' then
         cla:=  ' and hcclase=' + g_q + cmbclase.Text + g_q
      else
         cla:= '';
   end
   else begin
      sis:='';
      if cmbclase.Text <> 'TODAS LAS CLASES' then
         cla:=  ' where hcclase=' + g_q + cmbclase.Text + g_q
      else
         cla:= '';
   end;


   cons:='select distinct hcbib from tsrela ' +
      sis + cla + ' order by hcbib';

{   consulta := 'select distinct hcbib from tsrela ' + //<------- cambio ALK!! cambiado por sugerencia de CArlos
   ' where hcclase=' + g_q + cmbclase.Text + g_q +
      ' and  sistema = ' + g_q + cmbSistema.Text + g_q +
      ' order by hcbib';}

   dm.feed_combo( cmblibreria, cons );
   cmblibreria.Items.Insert(0,'TODAS LAS BIBLIOTECAS');

   cmblibreria.Enabled:=true;
end;

procedure TfmListaDependencias.lstcomponenteClick_ETP( sClase,sBib,sProg,sSistema: string );     //ALK para ETP's
var
   sTitulo: String;
   i, k, a: integer;
   ant: string;
   cons: string;
   g_nivel: Integer;
begin
   inherited;

   g_procesa := true;

   sTitulo := sLISTA_DEPENDENCIAS + ' ' + sClase + ' ' + sBib + ' ' + sProg;

   //SetLength( aGLBTsrela, 0 );
   if FileExists( g_tmpdir+'\dependencias.txt' ) then
      DeleteFile( g_tmpdir+'\dependencias.txt' );

   gral.PubMuestraProgresBar( True );
   screen.Cursor := crsqlwait;
   try
      //setlength( x, 0 );
      xx.Clear;
      loc1.Clear;
      loc2.Clear;
      g_nivel := 0;

      cons:= 'select * from tsrela ' +
         ' where hcprog =' + g_q + sProg + g_q +
         ' and   hcbib =' + g_q + sBib + g_q +
         ' and   hcclase =' + g_q + sClase + g_q;

      if dm.sqlselect( dm.q1, cons ) then begin
         agrega_compo( dm.q1 ,g_nivel);

         leecompos( dm.q1.FieldByName( 'hcprog' ).AsString,
            dm.q1.FieldByName( 'hcbib' ).AsString,
            dm.q1.FieldByName( 'hcclase' ).AsString,
            dm.q1.FieldByName( 'sistema' ).AsString,
            g_nivel+1);

         Wprog := sProg;
         Wbib := sBib;
         Wclase := sClase;
         Wsistema := sSistema;
         bgral := sClase + ' ' + sBib + ' ' + sProg + ' ' + sSistema;

         if contador_registros > 0 then begin
            panel_fantasma(true);
            CreaWeb
         end
         else begin
            panel_fantasma(false);
            if alkDocumentacion = 0 then
               Application.MessageBox( pchar( dm.xlng( 'No existe información procesar.' ) ),
                                       pchar( dm.xlng( 'Lista de Dependencias' ) ), MB_OK );
         end;
      end
      else begin
         panel_fantasma(false);
         Splitter1.Visible:=true;
         Splitter1.AlignSplitter:=salLeft;
         PanelLista.Visible:=true;
         PanelLista.Align:=alLeft;
         if alkDocumentacion = 0 then
            Application.MessageBox( pchar( dm.xlng( 'No existe información procesar.' ) ),
                                    pchar( dm.xlng( 'Lista de Dependencias' ) ), MB_OK );
      end;

      setlength( tt, 0 );
      ant := '';
      K := 0;

      for i := 0 to contador_registros - 1 do begin
         for a := 0 to length( tt ) - 1 do begin
            if ( x[ i ].clase = tt[ a ].clase ) then begin
               ant := x[ i ].clase;
               k := a;
               break;
            end;
         end;

         if ant <> x[ i ].clase then begin
            k := length( tt );
            setlength( tt, k + 1 );
            tt[ k ].clase := x[ i ].clase;
            tt[ k ].total := 0;
            ant := x[ i ].clase;
         end;
         inc( tt[ k ].total );
      end;
   finally
      screen.Cursor := crdefault;
      gral.PubMuestraProgresBar( False );
   end;
end;

// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


procedure TfmListaDependencias.cmblibreriaChange( Sender: TObject );
begin
   inherited;
   panel_fantasma(false);
   cmbmascara.Clear;
   cmbmascara.Enabled:=false;
   bejecuta.Enabled:=false;

   if cmblibreria.Text ='' then exit;

   screen.Cursor := crsqlwait;

   cmbmascara.Enabled:=true;
   //bejecuta.Enabled:=true;
   screen.Cursor := crdefault;
end;

procedure TfmListaDependencias.cmbmascaraChange( Sender: TObject );
begin
   inherited;
   if trim(cmbmascara.Text) <> '' then begin
      bejecuta.Enabled:=true;
      panel_fantasma(false);
   end
   else begin
      bejecuta.Enabled:=false;
   end;
end;

procedure TfmListaDependencias.CreaWeb;
var
   i, j: integer;
   sPass, sLinea: string;
   slDatos: Tstringlist;
   iMiIcon: TIcon;
   AField: TField;
   //aClases: array of string;
begin
   inherited;

   screen.Cursor := crsqlwait;
   try
      stbLista.Panels[ 0 ].Text := ''; //limpia count de registros
      slDatos := Tstringlist.create;
      slDatos.Delimiter := ',';
      slDatos.Add( 'nivel:Integer:0,' +
         'clase:String:20,bib:String:250,nombre:String:250,modo:String:20,' +
         'organizacion:String:30,externo:String:50,coment:String:200,' +
         'existe:Boolean:0,sistema:String:200' );

      tabLista.Caption := sLISTA_DEPENDENCIAS + ' ' + Wclase + ' ' + Wbib + ' ' + Wprog; //framirez

      // --------- Traer los datos del archivo para cargar tabla ---------
      AssignFile( F, g_tmpdir+'\dependencias.txt' );
      Reset( F );

      while not Eof( F ) do begin
         ReadLn( F, sLinea );
         //Memo.Lines.Add( sLinea );
         slDatos.Add( sLinea );
      end;

      CloseFile( F );

      // -----------------------------------------------------------------
      {for i := 0 to length( x ) - 1 do begin
         if x[ i ].existe then
            sPass := 'true'
         else
            sPass := 'false';

         slDatos.Add( '"' + IntToStr( x[ i ].nivel ) + '",' +
            '"' + x[ i ].clase + '",' +
            '"' + x[ i ].bib + '",' +
            //'"' + x[ i ].nombre + '",' +
            '"' + StringReplace( x[ i ].nombre, '"', '', [ rfReplaceAll ] ) + '",' + //aqui JCR
            '"' + x[ i ].modo + '",' +
            '"' + x[ i ].organizacion + '",' +
            '"' + x[ i ].externo + '",' +
            '"' + x[ i ].coment + '",' +
            '"' + sPass + '",' +
            '"' + x[ i ].sistema + '"' );
      end;}

      GlbCreateImageRepository( erClase, imClaseTypes, edClaseTypeImageCombo, g_tmpdir, aClases, false );

      //SetLength( x, 0 );

      if tabDatos.Active then
         tabDatos.Active := False;

      GlbQuitarFiltrosGrid( grdDatosDBTableView1 );

      if bGlbPoblarTablaMem( slDatos, tabDatos ) then begin
         tabDatos.ReadOnly := True;

         GlbHabilitarOpcionesMenu( mnuPrincipal, tabDatos.RecordCount > 0 );
         GlbCrearCamposGrid( grdDatosDBTableView1 );

         for i := 0 to grdDatosDBTableView1.ColumnCount - 1 do begin
            if grdDatosDBTableView1.Columns[ i ].Caption = 'Nivel' then
               grdDatosDBTableView1.Columns[ i ].ApplyBestFit;

            if grdDatosDBTableView1.Columns[ i ].Caption = 'Clase' then begin
               grdDatosDBTableView1.Columns[ i ].RepositoryItem := edClaseTypeImageCombo;
               grdDatosDBTableView1.Columns[ i ].ApplyBestFit;
            end;
            if ( grdDatosDBTableView1.Columns[ i ].DataBinding.FieldName = 'sistema' ) then
               grdDatosDBTableView1.Columns[ i ].Visible := True;

         end;
         grdDatosDBTableView1.ApplyBestFit( );

         //necesario para la busqueda
         //en este caso usar grEspejo para apoyarse en las busquedas y llenar slPublista
         GlbCrearCamposGrid( grdEspejoDBTableView1 );
         GlbCargarLista( grdEspejo, grdEspejoDBTableView1, slPubLista );
         //fin necesario para la busqueda

         stbLista.Panels[ 0 ].Text := IntToStr( tabDatos.RecordCount ) + ' Registros';

         if Visible = True then
            GlbFocusPrimerItemGrid( grdDatos, grdDatosDBTableView1 );
      end;

   finally
      screen.Cursor := crdefault;
   end;
end;

procedure TfmListaDependencias.FormActivate( Sender: TObject );
begin
   inherited;
   iHelpContext := IDH_TOPIC_T02800;
end;

procedure TfmListaDependencias.FormClose( Sender: TObject;
   var Action: TCloseAction );
var
   arch: string;
   i: integer;
begin
   inherited;
//   setlength( x, 0 );
   xx.Clear;

   bitmap.Free;
   edClaseTypeImageCombo.Free;
   imClaseTypes.Free;
   erClase.Free;
   repetido.Free;
   if FormStyle = fsMDIChild then
      dm.PubEliminarVentanaActiva( Caption );  //quitar nombre de lista de abiertos
   {gral.borra_elemento(Caption,1);     //borrar elemento del arreglo de productos
   farbol.borra_elemento_a(Caption,1);     //borrar elemento del arreglo de productos
   }
   //archivo_selects.Free;
end;

procedure TfmListaDependencias.FormCreate( Sender: TObject );
var
   j, i: integer;
   Wuser, ProdClase, lwLista, lwInSQL, lwSale: string;
   m: tStringlist;
begin
   inherited;
   sin_control:=true;  // para ocultar los controles   ALK
   
   //SetLength( aGLBTsrela, 0 ); //para controlar los repetidos, futuro corto ajustar rutinas de taladreo
   repetido:=TStringList.Create;
   SetLength( aClases, 0 );

   if g_language = 'ENGLISH' then begin
      //cxPageControl1.Pages[ 0 ].Caption := 'List';
      //cxPageControl1.Pages[ 0 ].Visible := false;
      //groupbox1.Caption := 'Select';
      label3.Caption := 'Class';
      label1.Caption := 'Library';
      label2.Caption := 'Component';
      dgClase := 'Class';
      dgLibreria := 'Library';
      dgcomponente := 'Component';
      dgModo := 'Mode';
      dgOrganizacion := 'Organization';
      dgExterno := 'External';
      dgComentario := 'Comment';
      dgExiste := 'Exists';
      dgtotal := 'Total';
   end
   else begin
      dgClase := 'Clase';
      dgLibreria := 'Libreria';
      dgcomponente := 'Componente';
      dgModo := 'Modo';
      dgOrganizacion := 'Organización';
      dgExterno := 'Externo';
      dgComentario := 'Comentario';
      dgExiste := 'Existe';
      dgtotal := 'Total';
   end;

   {dm.feed_combo( cmbclase, 'select unique pcclase from tsrela , tsclase where cclase = pcclase and estadoactual =' +
      g_q + 'ACTIVO' + g_q + ' and hcbib <> ' + g_q + 'BD' + g_q + ' order by pcclase' );
    }
   clases := Tstringlist.Create;
   clasesexiste := Tstringlist.Create;
   xx := Tstringlist.Create;
   loc1 := Tstringlist.Create;
   loc2 := Tstringlist.Create;
   bitmap := Tbitmap.Create;
   //archivo_selects:=Tstringlist.Create;

   {if dm.sqlselect( dm.q1, 'select unique hcclase from tsrela , tsclase where cclase = hcclase and estadoactual =' +
      g_q + 'ACTIVO' + g_q + ' order by hcclase' ) then begin

      while not dm.q1.Eof do begin
         clases.Add( dm.q1.fieldbyname( 'hcclase' ).AsString );
         dm.q1.Next;
      end;
   end;
         }
   //=====================================

   Wuser := 'ADMIN'; //Temporal  JCR
   error:='';  //alk para error en consulta

   if dm.sqlselect( dm.q1, 'select * from parametro where clave=' +
      g_q + 'CLASESXPRODUCTO' + g_q ) then
      ProdClase := dm.q1.fieldbyname( 'dato' ).AsString;
   lwSale := 'FALSE';

   while lwSale = 'FALSE' do begin
      if ProdClase <> 'TRUE' then begin
         clasesexiste.AddStrings( clases );
         {         if dm.sqlselect( dm.q1, 'select distinct hcclase from tsrela ' +
                     ' where hcclase in (select cclase from tsclase where objeto=' + g_q + 'FISICO' + g_q +
                     ' and estadoactual=' + g_q + 'ACTIVO' + g_q + ')' +
                     ' order by hcclase' ) then begin}
         if dm.sqlselect( dm.q1, 'select distinct hcclase from tsrela ' +
            ' where hcclase in (select cclase from tsclase where estadoactual=' + g_q + 'ACTIVO' + g_q + ')' +
            ' order by hcclase' ) then begin
            i := 1;
            while not dm.q1.Eof do begin
               SetLength( aPriClases, i );
               aPriClases[ i - 1 ] := dm.q1.fieldbyname( 'hcclase' ).AsString;
               i := i + 1;
               dm.q1.Next;
            end;
         end
         else begin
            MessageDlg(PChar('Sin informacion en tsproductos para ' + g_producto),
            mtInformation,[mbOk],0);
            error:='Sin informacion en tsproductos';
            exit;
         end;

         lwSale := 'TRUE';
      end
      else begin
         if dm.sqlselect( dm.q1, 'select * from tsproductos  where  ccapacidad = ' + g_q + g_producto + g_q +
            ' and cuser = ' + g_q + Wuser + g_q ) then begin
            lwLista := dm.q1.fieldbyname( 'cclaseprod' ).AsString;
            m := Tstringlist.Create;
            m.CommaText := lwLista;

            SetLength( aPriClases, m.Count );

            for i := 0 to m.Count - 1 do
               aPriClases[ i ] := m[ i ]; // arreglo de clases

            for j := 0 to m.count - 1 do begin
               lwInSQL := trim( lwInSQL ) + ' ' + g_q + trim( m[ j ] ) + g_q + ' ';
            end;
            clasesexiste.AddStrings( m );
            clases.AddStrings( m );
            m.Free;
            lwInSQL := Trim( lwInSQL );

            if lwInSQL = '' then begin
               ProdClase := 'FALSE';
               CONTINUE;
            end;

            lwInSQL := stringreplace( lwInSQL, ' ', ',', [ rfreplaceall ] );

            if dm.sqlselect( dm.q2, 'select distinct hcclase from tsrela ' +
               ' where hcclase in (' + lwInSQL + ')' + ' order by hcclase' ) then begin
            end;
            lwSale := 'TRUE';
         end
         else begin
            lwSale := 'TRUE';
            MessageDlg(PChar('Sin informacion en tsproductos para ' + g_producto),
            mtInformation,[mbOk],0);
            error:='Sin informacion en tsproductos';
            exit;
         end;
      end;
   end;
   //=====================================

   excluyemenu := Tstringlist.Create;

   if dm.sqlselect( dm.q1, 'select dato from parametro where clave=' + g_q + 'EXCLUYEMENU' + g_q ) then begin
      while not dm.q1.Eof do begin
         excluyemenu.Add( dm.q1.fieldbyname( 'dato' ).AsString );
         dm.q1.Next;
      end;
   end;

   Wfecha := formatdatetime( 'YYYYMMDDHHMMSSZZZZ', now );
   gral.CargaRutinasjs( );
   WnomLogo := 'LD' + Wfecha;
   gral.CargaLogo( WnomLogo );
   gral.CargaIconosBasicos( );
   gral.CargaIconosClases( );

   imClaseTypes := TImageList.Create( Self );
   erClase := TcxEditRepository.Create( Self );
   edClaseTypeImageCombo := TcxEditRepositoryImageComboBoxItem.Create( erClase );
   edClaseTypeImageCombo.Properties.Images := imClaseTypes;

    //  -----------------   Llenar el combo de sistema  --------------------------
    if dm.sqlselect( DM.qmodify, 'select csistema from tssistema where estadoactual = ' + g_q + 'ACTIVO' + g_q ) then begin
      cmbSistema.Items.Add('TODOS LOS SISTEMAS');
      while not DM.qmodify.Eof do begin
         cmbSistema.Items.Add(dm.qmodify.fieldbyname( 'csistema' ).AsString);
         DM.qmodify.Next;
      end;
   end;

   panel_fantasma(false);

   contador_registros:=0;
end;

procedure TfmListaDependencias.FormDeactivate( Sender: TObject );
begin
   inherited;

   gral.PopGral.Items.Clear;
   SetLength( aClases, 0 );
end;

procedure TfmListaDependencias.leecompos( compo, bib, clase, sistema: string; g_nivel : integer );
var
   qq: Tadoquery;
   nuevo, bexiste, bRepetido: boolean;
   cc, sClase, sSistema, cadena,cons: String;
   i, ii, jj, Indicex, Indicey, Indicez, Wsale, i1, g_nivel0: integer;
begin
   inherited;
   cadena:=compo+'|'+bib+'|'+clase;

   bRepetido := validaRepetido( cadena, repetido );   //bGlbRepetidoTsrela( compo, bib, clase );
   //   bRepetido := false;

   continua:=0;   // para detenerlo si hay un out of memory ALK

   if not bRepetido then begin

      {try
         GlbRegistraArregloTsrela( compo, bib, clase );
      except
         on E: exception do begin
            alkErrorGral:=E.Message;   // prueba documentacion ALK
            continua:=1;   // para detenerlo si hay un out of memory ALK
         end;
      end;  }

      qq := Tadoquery.Create( self );
      try
         qq.Connection := dm.ADOConnection1;
         cons:= 'select * from tsrela ' +
            ' where pcprog=' + g_q + compo + g_q +
            ' and   pcbib=' + g_q + bib + g_q +
            ' and   pcclase=' + g_q + clase + g_q;
         //archivo_selects.Add(cons);
         if dm.sqlselect( qq, cons ) then begin
            //' and   sistema=' + g_q + sistema + g_q ) then begin
            while ((not qq.Eof) and (continua = 0) ) do begin
                  bexiste := false;
                     nuevo := false;

                  ii := -1;
                  for i := 0 to length( aPriClases ) - 1 do begin
                     sClase := ( qq.fieldbyname( 'hcclase' ).AsString );
                     if AnsiMatchStr( sClase, aPriClases[ i ] ) then begin
                        ii := i;
                        Break;
                     end;
                  end;
                  IF ii >= 0 then begin
                     cc := v_compo + '|' + v_bib + '|' + v_clase + '|' +
                        qq.FieldByName( 'ocprog' ).AsString + '|' +
                        qq.FieldByName( 'ocbib' ).AsString + '|' +
                        qq.FieldByName( 'occlase' ).AsString + '|' +
                        qq.FieldByName( 'pcprog' ).AsString + '|' +
                        qq.FieldByName( 'pcbib' ).AsString + '|' +
                        qq.FieldByName( 'pcclase' ).AsString + '|' +
                        qq.FieldByName( 'hcprog' ).AsString + '|' +
                        qq.FieldByName( 'hcbib' ).AsString + '|' +
                        qq.FieldByName( 'hcclase' ).AsString;

                     if xx.IndexOf( cc ) > -1 then
                        bexiste := True
                     else
                        bexiste := False;

                     if clases.IndexOf( qq.FieldByName( 'hcclase' ).AsString ) > -1 then begin
                        //g_nivel := g_nivel + 1;
                        if g_nivel = 1 then begin
                           v_clase := qq.FieldByName( 'hcclase' ).AsString;
                           v_bib := qq.FieldByName( 'hcbib' ).AsString;
                           v_compo := qq.FieldByName( 'hcprog' ).AsString;
                           v_sistema := qq.FieldByName( 'sistema' ).AsString;
                        end;

                        continua:=1;
                        try                        //ALK out of memory
                           //continua:=1;
                           continua:=0;
                           if bexiste then
                              Wciclado := '(CICLADO)'
                           else
                              Wciclado := '';

                           nuevo := agrega_compo( qq ,g_nivel);
                        except
                           on E: exception do begin
                              Application.MessageBox( pchar( dm.xlng( 'Fallo al generar el producto ' + chr( 13 ) +
                                                      'Por favor vuelva a intentarlo' ) ),
                                                      pchar( dm.xlng( 'AVISO' ) ), MB_ICONEXCLAMATION );
                              continua:=1;
                              exit;
                           end;
                        end;
                     end
                     else
                        nuevo := true;
                     if not bexiste then begin
                     {   Wciclado := '(CICLADO)';
                     end
                     else begin}
                        if qq.FieldByName( 'hcclase' ).AsString = 'LOC' then begin
                           loc1.Insert( 0, uppercase( qq.fieldbyname( 'externo' ).AsString ) );
                           loc2.insert( 0, qq.fieldbyname( 'organizacion' ).AsString );
                        end;
                        if nuevo and ( excluyemenu.IndexOf( qq.fieldbyname( 'hcprog' ).AsString ) = -1 ) then begin
                           Wciclado := '';
                           if ( qq.FieldByName( 'coment' ).AsString <> 'LIBRARY' ) then
                              leecompos( qq.FieldByName( 'hcprog' ).AsString,
                                 qq.FieldByName( 'hcbib' ).AsString,
                                 qq.FieldByName( 'hcclase' ).AsString,
                                 qq.FieldByName( 'sistema' ).AsString,
                                 g_nivel+1 )
                           else begin
                              qq.Next;
                              Continue;
                           end;
                        end;
                     end;
                  end;
                  qq.Next;

            end;
         end;
      finally
         qq.Free;
         //xx.SaveToFile(g_tmpdir + '\arc_list_dep.txt');
         //g_borrar.Add(g_tmpdir + '\arc_list_dep.txt');
      end;
   end;
end;

procedure TfmListaDependencias.lstcomponenteClick( sClase,sBib,sProg,sSistema: string );
var
   sTitulo: String;
   //sClase, sBib, sProg, sSistema: String;
   i, k, a: integer;
   ant, cons: string;
   g_nivel: Integer;
begin
   inherited;
   g_procesa := true;
   sTitulo := sLISTA_DEPENDENCIAS + ' ' + sClase + ' ' + sBib + ' ' + sProg;

   //SetLength( aGLBTsrela, 0 );
   if FileExists( g_tmpdir+'\dependencias.txt' ) then
      DeleteFile( g_tmpdir+'\dependencias.txt' );

   gral.PubMuestraProgresBar( True );
   screen.Cursor := crsqlwait;
   try
      //setlength( x, 0 );
      xx.Clear;
      loc1.Clear;
      loc2.Clear;
      g_nivel := 0;

      cons:= 'select * from tsrela ' +
         ' where hcprog =' + g_q + sProg + g_q +
         ' and   hcbib =' + g_q + sBib + g_q +
         ' and   hcclase =' + g_q + sClase + g_q;
      //archivo_selects.Add(cons);
      if dm.sqlselect( dm.q1, cons ) then begin

         agrega_compo( dm.q1 , g_nivel);

         leecompos( dm.q1.FieldByName( 'hcprog' ).AsString,
            dm.q1.FieldByName( 'hcbib' ).AsString,
            dm.q1.FieldByName( 'hcclase' ).AsString,
            dm.q1.FieldByName( 'sistema' ).AsString,
            g_nivel+1);

         Wprog := sProg;
         Wbib := sBib;
         Wclase := sClase;
         Wsistema := sSistema;
         bgral := sClase + ' ' + sBib + ' ' + sProg + ' ' + sSistema;

         if contador_registros > 0 then begin
            panel_fantasma(true);
            CreaWeb
         end
         else begin
            panel_fantasma(false);
            if alkDocumentacion = 0 then
               Application.MessageBox( pchar( dm.xlng( 'No existe información procesar.' ) ),
                                       pchar( dm.xlng( 'Lista de Dependencias' ) ), MB_OK );
         end;
      end
      else begin
         panel_fantasma(false);
         Splitter1.Visible:=true;
         Splitter1.AlignSplitter:=salLeft;
         PanelLista.Visible:=true;
         PanelLista.Align:=alLeft;
         if alkDocumentacion = 0 then
            Application.MessageBox( pchar( dm.xlng( 'No existe información procesar.' ) ),
                                    pchar( dm.xlng( 'Lista de Dependencias' ) ), MB_OK );
      end;

      setlength( tt, 0 );
      ant := '';
      K := 0;

      for i := 0 to length( x ) - 1 do begin
         for a := 0 to length( tt ) - 1 do begin
            if ( x[ i ].clase = tt[ a ].clase ) then begin
               ant := x[ i ].clase;
               k := a;
               break;
            end;
         end;

         if ant <> x[ i ].clase then begin
            k := length( tt );
            setlength( tt, k + 1 );
            tt[ k ].clase := x[ i ].clase;
            tt[ k ].total := 0;
            ant := x[ i ].clase;
         end;
         inc( tt[ k ].total );
      end;
   finally
      screen.Cursor := crdefault;
      gral.PubMuestraProgresBar( False );
   end;
end;

procedure TfmListaDependencias.lstcomponenteClickSistema( sClase,sBib,sProg,sSistema: string );
var
   i, k, j: integer;
   ant,consultaDS, consulta2,cc, cadena: string;
   g_nivel: Integer;
begin
   inherited;

   if sSistema = '' then
      sSistema := sProg;

   //SetLength( aGLBTsrela, 0 );
   if FileExists( g_tmpdir+'\dependencias.txt' ) then
      DeleteFile( g_tmpdir+'\dependencias.txt' );
      
   screen.Cursor := crsqlwait;
   //setlength( x, 0 );
   xx.Clear;
   loc1.Clear;
   loc2.Clear;
   g_nivel:=0;

   //agregar como nivel 0 al sistema
   cadena:= '"' + IntToStr( g_nivel ) + '",' +  // nivel
            '"' + 'SISTEMA' + '",' +   //clase
            '"' + ' ' + '",' +   //biblioteca
            '"' + StringReplace( sSistema, '"', '', [ rfReplaceAll ] ) + '",' + //nombre
            '"' + ' ' + '",' +
            '"' + ' ' + '",' +
            '"' + ' ' + '",' +
            '"' + ' ' + '",' +
            '"' + ' ' + '",' +
            '"' + sSistema + '"';     // sistema
   AssignFile( F, g_tmpdir+'\dependencias.txt' );
   Rewrite( F );
   WriteLn( F, cadena );
   CloseFile( F );
   {j:= length( x );
   setlength( x, j + 1 );
   x[ j ].nivel := g_nivel;
   x[ j ].nombre := sSistema;
   x[ j ].clase := 'SISTEMA'; }
   g_nivel:=g_nivel+1;

   //Encontrar las clases mas altas como nivel 1
   consultaDS:= 'select distinct hcclase,hcbib,hcprog from tsrela'  +          //Para obtener los componentes mas altos
         ' where pcclase = ' + g_q + 'CLA' + g_q + ' and sistema=' + g_q + sSistema + g_q +
         ' minus'  +
         ' select distinct hcclase,hcbib,hcprog from tsrela' +
         ' where pcclase <> ' + g_q + 'CLA' + g_q + ' and sistema=' + g_q + sSistema + g_q +
         ' order by 1,2,3';
   if dm.sqlselect( dm.q3,  consultaDS ) then begin
      while not dm.q3.Eof do begin
         consulta2:= 'select * from tsrela ' +
            ' where hcprog =' + g_q + dm.q3.FieldByName( 'hcprog' ).AsString + g_q +
            ' and   hcbib =' + g_q + dm.q3.FieldByName( 'hcbib' ).AsString + g_q +
            ' and   hcclase =' + g_q + dm.q3.FieldByName( 'hcclase' ).AsString + g_q;
         if dm.sqlselect( dm.q1, consulta2 ) then
            agrega_compo( dm.q1 ,g_nivel);
            g_nivel:=g_nivel+1;

         consulta2:= 'select * from tsrela ' +
            ' where pcprog =' + g_q + dm.q3.FieldByName( 'hcprog' ).AsString + g_q +
            ' and   pcbib =' + g_q + dm.q3.FieldByName( 'hcbib' ).AsString + g_q +
            ' and   pcclase =' + g_q + dm.q3.FieldByName( 'hcclase' ).AsString + g_q;
         if dm.sqlselect( dm.q1, consulta2 ) then begin
            while not dm.q1.Eof do begin
               try
                  agrega_compo( dm.q1 ,g_nivel);
                  leecompos( dm.q1.FieldByName( 'hcprog' ).AsString,
                             dm.q1.FieldByName( 'hcbib' ).AsString,
                             dm.q1.FieldByName( 'hcclase' ).AsString,
                             dm.q1.FieldByName( 'sistema' ).AsString,
                             g_nivel+1 );
                  dm.q1.Next;
               except
                  on E: exception do begin
                     if contador_registros > 0 then begin
                        panel_fantasma(true);
                        CreaWeb;
                     end
                     else begin
                        panel_fantasma(false);
                        if alkDocumentacion = 0 then
                           Application.MessageBox( 'No existe información.', 'Aviso', MB_OK );
                     end;
                     exit;
                  end;
               end;
            end;
         end;
         g_nivel:=g_nivel-1;
         dm.q3.Next;
      end;
      if contador_registros > 0 then begin
         panel_fantasma(true);
         CreaWeb;
      end
      else begin
         panel_fantasma(false);
         if alkDocumentacion = 0 then
            Application.MessageBox( pchar( dm.xlng( 'No existe información procesar.' ) ),
                     pchar( dm.xlng( 'Lista de Dependencias' ) ), MB_OK );
      end;
   end
   else begin
      panel_fantasma(false);
      Splitter1.Visible:=true;
      Splitter1.AlignSplitter:=salLeft;
      PanelLista.Visible:=true;
      PanelLista.Align:=alLeft;
      if alkDocumentacion = 0 then
         Application.MessageBox( pchar( dm.xlng( 'No existe información procesar.' ) ),
                  pchar( dm.xlng( 'Lista de Dependencias' ) ), MB_OK );
   end;


   setlength( tt, 0 );
   ant := '';
   K := 0;
   for i := 0 to length( x ) - 1 do begin
      if ant <> x[ i ].clase then begin
         k := length( tt );
         setlength( tt, k + 1 );
         tt[ k ].clase := x[ i ].clase;
         tt[ k ].total := 0;
         ant := x[ i ].clase;
      end;
      inc( tt[ k ].total );
   end;
   screen.Cursor := crdefault;
end;

procedure TfmListaDependencias.Salir1Click( Sender: TObject );
var
   arch: string;
begin
   inherited;

   gral.BorraIconosTmp( );
   gral.BorraRutinasjs( );
   arch := g_tmpdir + '\LD' + W_nomcomponente + '.html';
   g_borrar.Add( arch );
   arch := g_tmpdir + '\LD' + W_nomcomponente + 'IMP.html';
   g_borrar.Add( arch );
   close;
end;

procedure TfmListaDependencias.webBeforeNavigate2( Sender: TObject;
   const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
   Headers: OleVariant; var Cancel: WordBool );
var
   p, l: integer;
   b1: string;
   x, y: integer;
begin
   inherited;

   p := pos( '#lin', URL );
   if p > 0 then begin
      screen.Cursor := crsqlwait;
      l := Length( URL );
      b1 := copy( URL, p + 4, l - 4 );
      b1 := trim( b1 );
   end;
   if b1 = '' then
      exit;
   bgral := stringreplace( trim( b1 ), '|', ' ', [ rfReplaceAll ] );
   bgral := stringreplace( trim( b1 ), '(CICLADO)', '', [ rfReplaceAll ] );
   b1 := stringreplace( trim( b1 ), '(CICLADO)', '', [ rfReplaceAll ] );
   Opciones := gral.ArmarMenuConceptualWeb( b1, 'lista_componentes' );
   y := ArmarOpciones( Opciones );
   gral.PopGral.Popup( g_X, g_Y );
   screen.Cursor := crdefault;
end;

procedure TfmListaDependencias.webProgressChange( Sender: TObject; Progress,
   ProgressMax: Integer );
begin
   inherited;

   gral.PubAvanzaProgresBar;
end;

procedure TfmListaDependencias.grdDatosDBTableView1DblClick(
   Sender: TObject );
var
   sComponente: string;
   p, l: integer;
   x, y: integer;

begin
   inherited;
   if grdDatosDBTableView1.ColumnCount = 0 then  //si no tiene informacion, que se salga
      exit;
   if grdDatosDBTableView1.Columns[ 2 ].EditValue='SISTEMA' then   //si es el sistema, que salga
      exit;

   screen.Cursor := crsqlwait;

   try
      sComponente := Trim( grdDatosDBTableView1.Columns[ 4 ].EditValue ) + '|' +
         Trim( grdDatosDBTableView1.Columns[ 3 ].EditValue ) + '|' +
         Trim( grdDatosDBTableView1.Columns[ 2 ].EditValue ) + '|' +
         Trim( grdDatosDBTableView1.Columns[ 10 ].EditValue );       //comp,lib,cla,sis

      if sComponente = '' then
         exit;

      bgral := stringreplace( trim( sComponente ), '|', ' ', [ rfReplaceAll ] );
      Opciones := gral.ArmarMenuConceptualWeb( sComponente, 'lista_componentes' );
      y := ArmarOpciones( Opciones );
      gral.PopGral.Popup( g_X, g_Y );
      sComponente := '';
   finally
      screen.Cursor := crdefault;
   end;
end;

procedure TfmListaDependencias.dxBarButton1Click( Sender: TObject );
begin
   inherited;

   grdDatosDBTableView1.ViewData.Expand( true );
end;

procedure TfmListaDependencias.dxBarButton2Click( Sender: TObject );
begin
   inherited;

   grdDatosDBTableView1.ViewData.Collapse( true );
end;

procedure TfmListaDependencias.dxBarButton3Click( Sender: TObject );
begin
   inherited;

   grdDatosDBTableView1.ApplyBestFit( );
end;

procedure TfmListaDependencias.grdDatosDBTableView1FocusedRecordChanged(
   Sender: TcxCustomGridTableView; APrevFocusedRecord,
   AFocusedRecord: TcxCustomGridRecord;
   ANewItemRecordFocusingChanged: Boolean );
begin
   inherited;

   gral.PopGral.Items.Clear;
end;

procedure TfmListaDependencias.cmbSistemaChange( Sender: TObject );
var
   sSQLClases: string;
begin
   inherited;
   panel_fantasma(false);
   cmblibreria.Clear;
   cmblibreria.Enabled:=false;
   cmbclase.Clear;
   cmbclase.Enabled:=false;
   cmbmascara.Clear;
   cmbmascara.Enabled:=false;
   bejecuta.Enabled:=false;
   BitBtn2.Enabled:=true;

   if cmbSistema.Text ='' then exit;

   //========================================================
   if cmbSistema.Text <> 'TODOS LOS SISTEMAS' then
      sPriSistema := ' and sistema = ' + g_q + cmbSistema.Text + g_q
   else
      sPriSistema := '';
   //========================================================

   cmbClase.Clear;
   sSQLClases := 'select unique hcclase from tsrela r , tsclase c where cclase = '
         + ' hcclase and estadoactual = ' + g_q + 'ACTIVO' + g_q
         //+ ' and  objeto = ' + g_q + 'FISICO' + g_q
         //+ ' and tipo = ' + g_q + 'ANALIZABLE' + g_q
         + ' and hcbib <> ' + g_q + 'BD' + g_q
         + sPriSistema + ' order by hcclase';

   dm.feed_combo( cmbclase, sSQLClases );
   cmbclase.Items.Insert(0,'TODAS LAS CLASES');

   cmbClase.Enabled:=true;
end;

procedure TfmListaDependencias.bejecutaClick(Sender: TObject);
var
   i: integer;
   sPass, cons: string;
   sis, cla, bib, masc : string;
   slDatos: Tstringlist;
begin
   inherited;
   gral.PubMuestraProgresBar( TRUE );
   slDatos := Tstringlist.create;
   slDatos.Delimiter := ',';
   slDatos.Add('Nombre:String:20,Biblioteca:String:250,Clase:String:250,sistema:String:50' );

   {if oculta = 1 then
      panel_fantasma(true)
   else
      panel_fantasma(false);  }

   try
      screen.Cursor := crsqlwait;

      qconsulta := Tadoquery.Create( nil );
      qconsulta.Connection := dm.ADOConnection1;

      // ---------  ALK para expandir consultas ------------
      if cmbclase.Text <> 'TODAS LAS CLASES' then
         cla:=  ' where hcclase=' + g_q + cmbclase.Text + g_q
      else
         cla:= '';

      if cmblibreria.Text <> 'TODAS LAS BIBLIOTECAS' then begin
         if cla = '' then
            bib:=  ' where  hcbib=' + g_q + cmblibreria.Text + g_q
         else
            bib:=  ' and   hcbib=' + g_q + cmblibreria.Text + g_q;
      end
      else
         bib:= '';

      if cmbSistema.Text <> 'TODOS LOS SISTEMAS' then begin
         if (cla = '') and (bib = '') then
            sis:=  ' where sistema=' + g_q + cmbSistema.Text + g_q
         else
            sis:=  ' and sistema=' + g_q + cmbSistema.Text + g_q;
      end
      else
         sis:='';
      // ---------------------------------------------------


      if ( cmbmascara.Text = '%' ) or (cmbmascara.Text = '*') or
         ( cmbmascara.Text = '' ) then begin
         cons:= 'select distinct hcprog, hcbib, hcclase, sistema' +
                ' from tsrela ' + cla + bib + sis +
                ' order by hcprog ';

         if dm.sqlselect( qconsulta, cons ) then begin
            while not qconsulta.Eof do begin
               slDatos.Add( '"' + qconsulta.fieldbyname( 'hcprog' ).AsString  + '",' +
                      '"' + qconsulta.fieldbyname( 'hcbib' ).AsString  + '",' +
                      '"' + qconsulta.fieldbyname( 'hcclase' ).AsString  + '",' +
                      '"' + qconsulta.fieldbyname( 'sistema' ).AsString  + '"');
               qconsulta.Next;
            end;
         end
         else begin
            panel_fantasma(false);
            ShowMessage( 'No existe información procesar.' );
            exit;
         end;
      end
      else begin
         if (cla = '') and (bib = '') and (sis ='') then
            masc:= ' where hcprog like ' + g_q + stringreplace( cmbmascara.Text, '*', '%', [  rfreplaceall] ) + g_q
         else
            masc:= ' and hcprog like ' + g_q + stringreplace( cmbmascara.Text, '*', '%', [  rfreplaceall] ) + g_q;

         cons:= 'select distinct hcprog, hcbib, hcclase, sistema' +
                ' from tsrela ' + cla + bib + sis + masc + ' order by hcprog ';

         if dm.sqlselect( qconsulta, cons ) then begin
            while not qconsulta.Eof do begin
               slDatos.Add( '"' + qconsulta.fieldbyname( 'hcprog' ).AsString  + '",' +
                      '"' + qconsulta.fieldbyname( 'hcbib' ).AsString  + '",' +
                      '"' + qconsulta.fieldbyname( 'hcclase' ).AsString  + '",' +
                      '"' + qconsulta.fieldbyname( 'sistema' ).AsString  + '"');
               qconsulta.Next;
            end;
         end
         else begin
            panel_fantasma(false);
            ShowMessage( 'No existe información procesar.' );
            exit;
         end;
      end;

      Splitter1.Visible:=true;
      Splitter1.AlignSplitter:=salLeft;
      PanelLista.Visible:=true;
      PanelLista.Align:=alLeft;


      GlbQuitarFiltrosGrid( cxGridDBTableViewLista );
      if bGlbPoblarTablaMem( slDatos, TabDatosLista ) then begin
         TabDatosLista.ReadOnly := True;

         GlbHabilitarOpcionesMenu( mnuPrincipal, TabDatosLista.RecordCount > 0 );
         GlbCrearCamposGrid( cxGridDBTableViewLista );

         cxGridDBTableViewLista.ApplyBestFit( );
         //GlbFocusPrimerItemGrid( listaComp, cxGridDBTableViewLista );
      end;

   finally
      screen.Cursor := crdefault;
      gral.PubMuestraProgresBar( False );
   end;
end;

procedure TfmListaDependencias.BitBtn2Click(Sender: TObject);
begin
   panel_fantasma(false);
   BitBtn2.Enabled:=false;

   cmblibreria.Clear;
   cmblibreria.Enabled:=false;

   cmbclase.Clear;
   cmbclase.Enabled:=false;

   cmbmascara.Clear;
   cmbmascara.Enabled:=false;

   cmbsistema.Clear;
   if dm.sqlselect( DM.qmodify, 'select csistema from tssistema where estadoactual = ' + g_q + 'ACTIVO' + g_q ) then begin
      //cmbSistema.Items.Add('-Todos los sistemas -');
      cmbSistema.Items.Add('TODOS LOS SISTEMAS');
      while not DM.qmodify.Eof do begin
         cmbSistema.Items.Add(dm.qmodify.fieldbyname( 'csistema' ).AsString);
         DM.qmodify.Next;
      end;
   end;
   cmbsistema.Focused;

   bejecuta.Enabled:=false;
end;

procedure TfmListaDependencias.FormResize(Sender: TObject);
var
   tam : integer;
begin
   tam := 180;

   cmbsistema.width:=panel5.Width-tam;
   if cmbsistema.width < 350 then
      cmbsistema.width:=350;

   cmbclase.width:=panel5.Width-tam;
   if cmbclase.width < 350 then
      cmbclase.width:=350;

   cmblibreria.width:=panel5.Width-tam;
   if cmblibreria.width < 350 then
      cmblibreria.width:=350;
end;

procedure TfmListaDependencias.cxGridDBTableViewListaDblClick(
  Sender: TObject);
var
   sClase, sBib, sProg, sSistema, sTitulo: String;
begin
   inherited;
   screen.Cursor := crsqlwait;
   try
      sSistema := Trim( cxGridDBTableViewLista.Columns[ 4 ].EditValue );
      sClase := Trim( cxGridDBTableViewLista.Columns[ 3 ].EditValue );
      sBib := Trim( cxGridDBTableViewLista.Columns[ 2 ].EditValue );
      sProg := Trim( cxGridDBTableViewLista.Columns[ 1 ].EditValue );

      sTitulo := sLISTA_DEPENDENCIAS + ' ' + sClase + ' ' + sBib + ' ' + sProg;

      if TabDatosLista.Active then
         TabDatosLista.Active := False;

      if sClase = 'SISTEMA' then
         lstcomponenteClickSistema( sClase, sBib, sProg, sSistema )
      else begin
         if (sClase = 'ETP') or (sClase = 'CTM') then
            lstcomponenteClick_ETP( sClase, sBib, sProg, sSistema )     //ALK para ETP's
         else
            lstcomponenteClick( sClase, sBib, sProg, sSistema );
      end;
      //arma3( sClase, sBib, sProg, sSistema);

      bejecutaClick(self);
   finally
      screen.Cursor := crdefault;
   end;
end;

procedure TfmListaDependencias.llena_combos_vacios(sParClase, sParBib, sParProg, sParSistema:String);
var
   cons:String;
   slDatos : Tstringlist;
begin
   cmblibreria.Enabled:=true;
   cmbclase.Enabled:=true;
   cmbmascara.Enabled:=true;
   cmbsistema.Enabled:=true;
   bejecuta.Enabled:=true;

   Splitter1.Visible:=false;
   PanelLista.Visible:=false;

   cmblibreria.Clear;
   cmbclase.Clear;
   cmbmascara.Clear;
   cmbsistema.Clear;
   if dm.sqlselect( DM.qmodify, 'select csistema from tssistema where estadoactual = ' + g_q + 'ACTIVO' + g_q ) then begin
      cmbSistema.Items.Add('TODOS LOS SISTEMAS');
      while not DM.qmodify.Eof do begin
         cmbSistema.Items.Add(dm.qmodify.fieldbyname( 'csistema' ).AsString);
         DM.qmodify.Next;
      end;
   end;
   cmbsistema.ItemIndex:=cmbsistema.Items.IndexOf(sParSistema);

   cons := 'select unique hcclase from tsrela r , tsclase c where cclase = '
      + ' hcclase and estadoactual = ' + g_q + 'ACTIVO' + g_q
      //+ ' and tipo = ' + g_q + 'ANALIZABLE' + g_q
      + ' and hcbib <> ' + g_q + 'BD' + g_q
      + sPriSistema + ' order by hcclase';
   dm.feed_combo( cmbclase, cons );
   cmbclase.Items.Insert(0,'TODAS LAS CLASES');
   cmbclase.ItemIndex:= cmbclase.Items.IndexOf(sParClase);

   dm.feed_combo( cmblibreria, 'select distinct hcbib from tsrela ' +
      ' where hcclase=' + g_q + cmbclase.Text + g_q +
      ' and  sistema = ' + g_q + cmbSistema.Text + g_q +
      ' order by hcbib' );
   cmblibreria.Items.Insert(0,'TODAS LAS BIBLIOTECAS');
   cmblibreria.ItemIndex:= cmblibreria.Items.IndexOf(sParBib);

   cmbmascara.Text:=sParProg;

   slDatos := Tstringlist.create;
   slDatos.Delimiter := ',';
   slDatos.Add('Nombre:String:20,Biblioteca:String:250,Clase:String:250,sistema:String:50' );
   slDatos.Add('"' + sParProg + '",' +
               '"' + sParBib + '",' +
               '"' + sParClase + '",' +
               '"' + sParSistema + '"');

   if bGlbPoblarTablaMem( slDatos, TabDatosLista ) then begin
      TabDatosLista.ReadOnly := True;

      GlbHabilitarOpcionesMenu( mnuPrincipal, TabDatosLista.RecordCount > 0 );
      GlbCrearCamposGrid( cxGridDBTableViewLista );

      cxGridDBTableViewLista.ApplyBestFit( );
      //GlbFocusPrimerItemGrid( listaComp, cxGridDBTableViewLista );
   end;
end;

procedure TfmListaDependencias.panel_fantasma(visible:boolean);
begin
   // ------------  Procedimiento para mostrar resultados ----------------   ALK
   panelFantasma.Visible:=not visible;   // para dejar ver lo de abajo   ALK
   stbLista.Visible:=visible;   // para ver la barra de estado   ALK
   tabLista.Visible:=visible;

   if sin_control then begin
      Splitter1.Visible:=false;
      PanelLista.Visible:=false;
   end
   else begin
      Splitter1.Visible:=visible;
      Splitter1.AlignSplitter:=salLeft;
      PanelLista.Visible:=visible;
      PanelLista.Align:=alLeft;
   end;

   panelFantasma.Height := 600;

   if gral.bPubVentanaMaximizada = FALSE then
      Height := 600;
   // --------------------------------------------------------------------
end;

procedure TfmListaDependencias.sin_controles(boton:integer);
begin
   if boton=1 then begin      // para quitar controles  ALK  (menu emergente)
      sin_control:=true;

      panelFantasma.Visible:=true;   // para no dejar ver lo de abajo   ALK
      panelFantasma.Height := 600;   // al iniciar, debe de tener el panel fantasma

      stbLista.Visible:=true;   // para ver la barra de estado   ALK
      Splitter1.Visible:=false;   // splitter - separador
      PanelLista.Visible:=false;  // para ver tabla de la izquierda
      Panel5.Visible:=false;     // controles
      //tabLista.Visible:=true;   // tabla principal (lista de componentes)
   end
   else begin    // para presentar controles ALK     (menu de mineria)
      sin_control:=false;

      stbLista.Visible:=true;   // para ver la barra de estado   ALK
      {Splitter1.Visible:=true;   // splitter - separador
      Splitter1.AlignSplitter:=salLeft;
      PanelLista.Visible:=true;  // para ver tabla de la izquierda
      PanelLista.Align:=alLeft;}
      Panel5.Visible:=true;     // controles
      //tabLista.Visible:=true;   // tabla principal (lista de componentes)

      panelFantasma.Visible:=true;   // para no dejar ver lo de abajo   ALK
      panelFantasma.Height := 600;   // al iniciar, debe de tener el panel fantasma
   end;

   if gral.bPubVentanaMaximizada = FALSE then
      Height := 600;
   // --------------------------------------------------------------------
end;


end.

