unit ufmBuscaCompo;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, ufmSVSLista, cxStyles, cxCustomData, cxGraphics, cxFilter,
   cxData, cxDataStorage, cxEdit, DB, cxDBData, dxPSGlbl, dxPSUtl, dxPSEngn,
   dxPrnPg, dxBkgnd, dxWrap, dxPrnDev, dxPSCompsProvider, dxPSFillPatterns,
   dxPSEdgePatterns, dxBarExtItems, ComCtrls, cxGridBandedTableView, shellapi,
   StdCtrls, cxGridTableView, ImgList, dxPSCore, dxPScxGridLnk, dxBarDBNav,
   dxmdaset, dxBar, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
   cxGridCustomTableView, cxGridDBTableView, cxGrid, cxPC, cxEditRepositoryItems,
   cxLookAndFeelPainters, StrUtils, HTML_HELP, cxTimeEdit, dxStatusBar, cxExportGrid4Link,
   ADODB, ExtCtrls, Grids, Buttons, cxSplitter, ActnMan, ActnColorMaps,
   ToolWin, ufmSVSListaExcel, OleCtrls, SHDocVw;

type
   Tbib = record
      clase: string;
      bib: string;
      ruta: string;
   end;

type
   Tcomp = record        //guarda los componentes con sus bibliotecas (multibiblioteca ALK)
      compos:string;
      bib:string;
   end;

type
   busqueda = record
      id:integer;       //numero de renglon
      renglon:string;   //contenido del renglon
      busqueda:string;  //palabra que se esta buscando
   end;

type
   TfmBuscaCompo = class( TfmSVSListaExcel )
      pnlMenu: TPanel;
      grdConsultas: TcxGrid;
      grdConsultasDBTableView1: TcxGridDBTableView;
      grdConsultasDBTableView1ConsultaCaption: TcxGridDBColumn;
      grdConsultasDBTableView1ConsultaFechaHora: TcxGridDBColumn;
      grdConsultasLevel1: TcxGridLevel;
      Panel4: TPanel;
      Panel2: TPanel;
      Label1: TLabel;
      Label3: TLabel;
      combo: TComboBox;
      cmbbiblioteca: TComboBox;
      cmbSistema: TComboBox;
      cmbClase: TComboBox;
      BitBtn1: TBitBtn;
      Panel6: TPanel;
      lblquery: TLabel;
      EditaQuery: TMemo;
      Panel5: TPanel;
      Label4: TLabel;
      Label5: TLabel;
      Label6: TLabel;
      ypaginas: TPanel;
      Label2: TLabel;
      lblpaginas: TLabel;
      cmbpagina: TComboBox;
      Bindice: TButton;
      cmbmascara: TComboBox;
      bejecuta: TBitBtn;
      tabBusca: TdxMemData;
      dtsBusca: TDataSource;
      mnuHistoria: TdxBarButton;
    Panel8: TPanel;
    web1: TWebBrowser;
    grdBusca: TcxGrid;
    grdBuscaDBTableView1: TcxGridDBTableView;
    grdBuscaLevel1: TcxGridLevel;
    Panel9: TPanel;
    Panel7: TPanel;
    rich: TRichEdit;
    Web2: TWebBrowser;
    cxSplitter2: TcxSplitter;
    Panel1: TPanel;
    cxSplitter1: TcxSplitter;
    Panel10: TPanel;
    panelFantasma: TPanel;
    Image1: TImage;
    BitBtn2: TBitBtn;
    panelContenedor: TPanel;
      //    procedure BindiceClick(Sender: TObject);
      procedure bejecutaClick( Sender: TObject );
      function ArmarOpciones( b1: Tstringlist ): integer;
      procedure FormCreate( Sender: TObject );
      procedure cmbbibliotecaChange( Sender: TObject );
      procedure cmbmascaraChange( Sender: TObject );
      procedure web1BeforeNavigate2( Sender: TObject; const pDisp: IDispatch;
         var URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
         var Cancel: WordBool );
      procedure web1DocumentComplete( Sender: TObject; const pDisp: IDispatch;
         var URL: OleVariant );
      procedure Web2BeforeNavigate2( Sender: TObject; const pDisp: IDispatch;
         var URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
         var Cancel: WordBool );
      procedure FormDeactivate( Sender: TObject );
      procedure comboClick( Sender: TObject );
      procedure cmbpaginaClick( Sender: TObject );
      procedure comboChange( Sender: TObject );
      function FormHelp( Command: Word; Data: Integer;
         var CallHelp: Boolean ): Boolean;
      procedure EditaQueryEnter( Sender: TObject );
      procedure cxSplitter1BeforeOpen( Sender: TObject;
         var AllowOpen: Boolean );
      procedure mnuHistoriaClick( Sender: TObject );
      procedure grdBuscaDBTableView1DblClick( Sender: TObject );
      procedure FormClose( Sender: TObject; var Action: TCloseAction );
      procedure grdConsultasDBTableView1DblClick( Sender: TObject );
    procedure cmbsistemaChange(Sender: TObject);
    procedure cmbclaseChange(Sender: TObject);
    procedure grdDatosDBTableView1DblClick(Sender: TObject);
    procedure grdBuscaDBTableView1MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Web2NavigateComplete2(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure Panel2Resize(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure EditaQueryChange(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure mnuBuscarSiguienteClick(Sender: TObject);
    procedure mnuTextoBuscarExit(Sender: TObject);
    procedure dxBarDBNavNext1Click(Sender: TObject);
    procedure dxBarDBNavPrev1Click(Sender: TObject);
    procedure dxBarDBNavFirst1Click(Sender: TObject);
    procedure dxBarDBNavLast1Click(Sender: TObject);
    procedure mnuBuscarAnteriorClick(Sender: TObject);
   private
      { Private declarations }
      bb: array of Tbib;
      sca, ht, fuentes, mas, menos, pals, selec, lineas: Tstringlist;
      b_string: boolean;
      arch: string;
      g_cadenas: string;
      inicio: Tdatetime;
      b_esperaweb: boolean;
      Wbib, Wpath: string;
      tsindex03: string;
      palabra: string; // Palabra cuyas paginas se estan mostrando
      paginas: integer; // numero de paginas que tiene la palabra
      itemsxpagina: integer;
      idxpaginas: integer; // numero de paginas del indice
      filtros, filtros2, filtrosno: Tstringlist; // Palabras filtradas
      Opciones: Tstringlist;
      salidaW2: string;
      lClase: String;
      archivocsv: String;
      multibib,bib_1,bib_f: integer;  //alk indicador cuando son todas las bibliotecas
      modo_case:string;
      procedure filtro_combos;
      procedure web_indice( pagina: integer = 1 );
      procedure web_pagina( palabras: string; pagina: integer );
      procedure carga_fuente2( biblioteca: string; fuente: string; clase: string );
      procedure refrescapantalla;
      procedure ordena_combo;
      procedure muestra_un_dato;   // para mostrar el primer resultado si es que no tiene query
      procedure panel_fantasma(visible:boolean);
   public
      { Public declarations }
      titulo: String;
      FechaTSS: string;
      FechaTSI: string;
      SQL_linea: string;
      num_linea : integer;  //alk para saber cual es el numero de linea del primer resultado en Web2

      aBusca: array of busqueda;     // alk para guardar coincidencias de busqueda
      idBusqueda:integer;
   end;

var
   fmBuscaCompo: TfmBuscaCompo;
   sqlClases: Tstringlist;

implementation

uses ptsdm, ptsgral, pbarra, HtmlHlp, uListaRutinas,
   uConstantes, uRutinasExcel,ptscomun;

{$R *.dfm}

{ TfmBuscaCompo }
procedure TfmBuscaCompo.filtro_combos;
var fsistema,fclase:string;
begin
   if cmbsistema.Text<>'' then
      fsistema:=' and pp.sistema='+g_q+copy(cmbsistema.Text,1,pos(' ',cmbsistema.Text)-1)+g_q;
   if cmbclase.Text<>'' then
      fclase:=' and pp.cclase='+g_q+copy(cmbclase.Text,1,pos('-',cmbclase.Text)-2)+g_q;
   if cmbsistema.Text='' then begin
      dm.feed_combo(cmbsistema,'select distinct pp.sistema||'+g_q+' - '+g_q+'||ss.descripcion '+
         ' from tssistema ss,tsprog pp '+
         ' where ss.csistema=pp.sistema '+
         fclase+
         '   and ss.estadoactual='+g_q+'ACTIVO'+g_q+
         ' order by 1');
      cmbsistema.Items.Insert(0,'');
   end;
   if cmbclase.Text='' then begin
      dm.feed_combo(cmbclase,'select distinct pp.cclase||'+g_q+' - '+g_q+'||cc.descripcion '+
         ' from tsprog pp,tsclase cc '+
         ' where pp.cclase=cc.cclase '+
         fsistema+
         ' order by 1');
      cmbclase.Items.Insert(0,'');
   end;
   dm.feed_combo(cmbbiblioteca,'select distinct pp.cbib from tsprog pp '+
      ' where pp.cbib is not null '+
      fsistema+
      fclase+
      ' order by 1');
   ordena_combo;         //alk
end;

// -------------  ALK  -----------------------------
procedure TfmBuscaCompo.ordena_combo;
var
   i:integer;
   items:TStringList;
begin
   items:=TStringList.Create;
   items.CommaText:=cmbbiblioteca.Items.CommaText;

   cmbbiblioteca.Clear;
   cmbbiblioteca.Items.Add('TODAS LAS BIBLIOTECAS');

   for i:=0 to items.Count-1 do
      cmbbiblioteca.Items.Add(items[i]);
end;
// -----------------------------------------------------

procedure sql_clases;
begin
   screen.cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );

   try
      sqlClases := Tstringlist.Create;

      if dm.sqlselect( dm.q1, 'select * from tsclase where busquedaselect=' + g_q + 'ACTIVO' + g_q +
         ' and  estadoactual =' + g_q + 'ACTIVO' + g_q + ' order by cclase' ) then begin
         while not dm.q1.Eof do begin
            sqlClases.Add( dm.q1.fieldbyname( 'cclase' ).AsString );
            dm.q1.Next;
         end;
      end;
   finally
      gral.PubMuestraProgresBar( false );
      screen.Cursor := crdefault;
   end;
end;

function TfmBuscaCompo.ArmarOpciones( b1: Tstringlist ): integer;
var
   mm: Tstringlist;
begin
   screen.cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   mm := Tstringlist.Create;
   mm.CommaText := bgral;

   try
      if mm.count < 3 then begin
         Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
            pchar( dm.xlng( sLISTA_BUSCA_COMPO + ' ' ) ), MB_OK );
         mm.free;
         exit;
      end;

      gral.EjecutaOpcionB( b1, 'Busca Componentes' );
   finally
      mm.free;
      gral.PubMuestraProgresBar( false );
      screen.Cursor := crdefault;
   end;
end;

procedure TfmBuscaCompo.bejecutaClick( Sender: TObject );
var
   texto, comando, ruta, salida: string;
   i, j, k,ii: integer;
   buffer: string ;//pchar;
   b_menos: boolean;
   buscado, mascara, sqls: string;
   sFileExcel: string;
   Wselect: string;
   aCompo: array of string;
   slBusca, slDatos: TStringList;
   todas_bib,bib_combo,buffer_todo: TStringList;
   sPass, sPass2, sCaption: string;
   AItemList: TcxFilterCriteriaItemList;
   param_extra:string;
   consulta,ingresa : string;
   multibibliotecas : array of Tcomp;

   // ------------------------------------- alk ---------------------------------------------------------
   procedure guarda_bib(compos:TStringList;bib:string);
   var
      u,cont : integer;
   begin
      cont:=Length(multibibliotecas);
      SetLength( multibibliotecas, Length( multibibliotecas ) + compos.count );
      for u:=3 to compos.count-1 do begin
         multibibliotecas[cont].compos:=ptscomun.bfile2cprog(compos[u]);
         multibibliotecas[cont].bib:= bib;
         cont:=cont+1;
      end
   end;
   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   function da_bib(compo:string):String;
   var
      k : integer;
   begin
      for k:=0 to Length(multibibliotecas)-1 do
         if compo = multibibliotecas[k].compos then begin
            Result:= multibibliotecas[k].bib;
            break;
         end;
   end;
   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   procedure guarda_compos(inicia:integer; lista:TStringList);
   var
      k : integer;
   begin
      for k:=inicia to lista.count -1 do
         todas_bib.Add(ptscomun.bfile2cprog(lista[k]));
   end;

   procedure guarda_buffer(inicia:integer; lista:TStringList);
   var
      k : integer;
   begin
      for k:=inicia to lista.count -1 do
         buffer_todo.Add(ptscomun.bfile2cprog(lista[k]));
   end;
   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   function procesa_x_bib(biblioteca:String;tipo:integer):boolean;
   var
      a:integer;
      directorio:string;
      sis:string;
   begin
      if biblioteca <> 'FIN' then begin
         //validar que existe el directorio para los indices
         if ( g_demonio = false ) and ( g_busca_remoto = false ) then begin
            directorio:=dm.pathbib( biblioteca, lClase ) +'_indi';
            if DirectoryExists(directorio) = false then begin
               Application.MessageBox( 'No se encuentran los índices.'+ chr( 13 ) +
                                      'Para crearlos, vaya a:'+ chr( 13 ) +
                                      'Menú "Administracion" - "Crea índices"',
                                       'Índices ', MB_OK );
               Result:=false;
               panel_fantasma(false);
               Exit;
            end;
         end;
         comando := tsindex03 + ' ' + dm.pathbib( biblioteca, lClase ) +
               '_indi\busca ' + salida + ' "' + buscado + '" "' + mascara + '"';
         sis:=copy(cmbsistema.Text,1,pos(' - ',cmbsistema.Text)-1);

         param_extra:=' X ';
         consulta:='select * from parametro ' +        // TANDEM agrega parametros para TSINDEX03
            {' where clave=' + g_q + 'chkextra_' +
               copy(cmbsistema.Text,1,pos(' ',cmbsistema.Text)-1) + '_' +
               copy(cmbclase.Text,1,pos(' ',cmbclase.Text)-1) + '_' + biblioteca + g_q+ }
            ' where clave=' + g_q + 'chkextra_' +sis+ '_' +lClase+ '_' + biblioteca + g_q+
            ' and   dato='+g_q+'TRUE'+g_q;

         if dm.sqlselect(dm.q1, consulta) then begin
            if dm.sqlselect(dm.q1, 'select * from parametro ' +
               {' where clave=' + g_q + 'EXTRA_MINING_' + cmbsistema.Text+'_'+ cmbclase.Text +'_'+biblioteca+ g_q) then
               param_extra := dm.q1.fieldbyname('dato').AsString}
               ' where clave=' + g_q + 'EXTRA_MINING_' +sis+'_'+lClase+'_'+biblioteca+ g_q) then
               param_extra :=' "'+ dm.q1.fieldbyname('dato').AsString+'" '

            else
            if dm.sqlselect(dm.q1, 'select * from parametro ' +
               {' where clave=' + g_q + 'EXTRA_MINING_' + copy(cmbclase.Text,1,pos(' ',cmbclase.Text)-1) + g_q) then}
               ' where clave=' + g_q + 'EXTRA_MINING_' +lClase+ g_q) then
               param_extra:=' "'+ dm.q1.fieldbyname('dato').AsString+'" ';
         end;
         comando:=comando+param_extra;

         // Checa si trae SQL
         EditaQuery.Text := trim( EditaQuery.Text );
         sqls := EditaQuery.Text;

         //Limpiar de saltos de linea los querys    ALK
         sqls:=stringreplace( sqls, ''#$D#$A'', ' ', [ rfreplaceall ] );

         // --------------------------  --------------------------
         if sqls <> '' then begin
            Panel1.Visible := false;
            cxPageControl1.Visible := true;

            comando := comando + ' "' + lClase + '"';

            if ( g_demonio = false ) and ( g_busca_remoto = false ) then
               comando := comando + ' "' + sqls + '"'
            else
               comando := comando + ' "' +
                  stringreplace( sqls, '''', '''''', [ rfreplaceall ] ) +
                  '"';
         end
         else begin
            Panel1.Visible := true;
            cxPageControl1.Visible := false;
         end;
         // ------------------------------------------------------------------

         screen.Cursor := crsqlwait;
         gral.PubMuestraProgresBar( True );

         if dm.remote_ejecuta_espera( comando, SW_HIDE, salida, buffer ) = false then begin
            Application.MessageBox( pchar( dm.xlng( 'No puede ejecutar comando [ ' + comando + ' ]' ) ),
               pchar( dm.xlng( sLISTA_BUSCA_COMPO ) ), MB_OK );
            screen.Cursor := crDefault; //--
            gral.PubMuestraProgresBar( False );
            web1.Visible := true;
            web2.Visible := true;
            panel_fantasma(false);
            Result:=false;
            exit;
         end;

         gral.PubMuestraProgresBar( True );
         j := pos( ':ErRoR;', buffer ); //--

         if j > 0 then begin //--
            Application.MessageBox( pchar( dm.xlng( copy( buffer, j + 7, 120 ) ) ), //--
               pchar( dm.xlng( sLISTA_BUSCA_COMPO ) ), MB_OK );
            web1.Visible := true;
            web2.Visible := true;
            panel_fantasma(false);
            Result:=false;
            exit;
         end;

         Wselect := TRIM( EditaQuery.Text );

         if gral.bPubConsultaActiva( Wselect, formatdatetime( 'YYYY/MM/DD HH:NNSS', now ) ) = FALSE then begin
            if Wselect <> '' then
               dm.PubRegistraConsultaActiva( Wselect, formatdatetime( 'YYYY/MM/DD HH:NNSS', now ) );
         end;

         if EditaQuery.Text <> '' then begin // salida del sql
            sFileExcel := '\sql' + formatdatetime( 'YYYYMMDDHHNNSS', now ) + '.csv';

            archivocsv := g_tmpdir + sFileExcel;
            //  ------------  ALK para multibibliotecas con query ---------------
            if multibib=0 then begin
               ht.text := buffer;
               buffer_todo:=TStringList.Create;
               guarda_buffer(0,ht);
               ht.clear;
               ht.text:=buffer_todo.text;
               ht.SaveToFile( archivocsv );   //guardar el archivo
               grdDatosDBTableView1.ClearItems;      //si solo es una biblioteca, limpiar los registros existentes
            end
            else begin
               ht.Clear;
               ht.text := buffer;
               if bib_1 = 1 then begin // si es la primera biblioteca, se guarda con todo y titulos de campos
                  buffer_todo:=TStringList.Create;
                  guarda_buffer(0,ht);
               end
               else            //si no, se guardan solo los datos
                  guarda_buffer(1,ht);   //cambio RGM  los titulos solo vienen en el lugar 0
               ht.Clear;

               if bib_f = 1 then begin
                  ht.text:=buffer_todo.Text;  //unir todo el archivo que se junto de todas las bibliotecas
                  buffer_todo.free;
                  ht.SaveToFile( archivocsv );   //guardar el archivo
               end;
            end;
            //-------------------------------------------------------------

            if (multibib = 0) or (bib_f = 1) then
               if bGlbPoblarGrid( adoConnExcel, g_tmpdir, sFileExcel, tblExcel ) then begin
                  grdDatosDBTableView1.DataController.CreateAllItems;
                  GlbHabilitarOpcionesMenu( mnuPrincipal, tblExcel.RecordCount > 0 );
                  stbLista.Panels[ 0 ].Text := IntToStr( tblExcel.RecordCount ) + ' Registros';

                  panel_fantasma(true);
                  GlbFocusPrimerItemGrid( grdDatos, grdDatosDBTableView1 );
               end;

            gral.PubMuestraProgresBar( False );
            screen.Cursor := crdefault;
            Result:=True;
            exit;
         end
         else begin   //si no tiene query
            ht.text := buffer;
         end;
      end;

      if (tipo = 1) or (tipo = 2) then begin
         //--------------------------------------------------------------------------------
         if ht[ 0 ] = 'Lista' then begin // con filtros AND, OR, NOT
            ht.SaveToFile( g_tmpdir + '\ht' + formatdatetime( 'YYYYMMDDHHNNSS', now ) + '.csv' );

            //------------------------ framirez ------------------------------------------
            slBusca := TStringList.Create;
            slBusca.Delimiter := ',';
            slBusca.Add( 'Localiza:String:200,Componente:String:200,Biblioteca:String:100,Clase:String:10');

            sPass :=  stringreplace( ht[ 1 ], ',', '%', [  rfreplaceall] );
            sPass :=  stringreplace( sPass, '"', '|', [  rfreplaceall] );

            for a := 3 to ht.Count - 1 do begin
               ht[a]:=ptscomun.bfile2cprog(ht[a]);
               if tipo = 2 then
                  ingresa:=sPass + ',"' + ht[ a ] + '",'+ da_bib(ht[ a ]) + ',' + Copy(cmbclase.text,1,3)
               else
                  ingresa:=sPass + ',"' + ht[ a ] + '",'+ biblioteca + ',' + Copy(cmbclase.text,1,3);
               slBusca.Add( ingresa );   //se agrega los renglones con: lo que se busca|compo|bib|clase      ALK
            end;
            //-----------------------------------------------------------------------------

            filtros.CommaText := ht[ 1 ];
            ht[ 1 ] := stringreplace( ht[ 1 ], ',', '%', [  rfreplaceall] ) + chr( 9 ) + inttostr( ht.Count - 3 );
            ht[ 2 ] := '->' + ht[ 1 ];
         end;

         for a := 0 to ht.count - 1 do begin
            ht[ a ] := stringreplace( ht[ a ], '"', '', [ rfreplaceall ] );
            ht[ a ] := stringreplace( ht[ a ], '=', '', [ rfreplaceall ] );
         end;

         idxpaginas := -1;
         cmbpagina.Tag := 1;

         if ht.Count < 2 then begin
            Application.MessageBox( 'Cadena no encontrada en componentes', 'Búsqueda  ', MB_OK );
            refrescapantalla;
         end
         else
            web_indice;

         combo.Enabled := true;
         web1.Visible := true;
         web2.Visible := true;

      //-----------------------------------------------------------
         if tabBusca.Active then
            tabBusca.Active := False;

         if bGlbPoblarTablaMem( slBusca, tabBusca ) then begin
            GlbHabilitarOpcionesMenu( mnuPrincipal, tabBusca.RecordCount > 0 );
            GlbCrearCamposGrid( grdBuscaDBTableView1 );
            grdBuscaDBTableView1.ApplyBestFit( );
            grdBuscaDBTableView1.Columns[ 1 ].GroupIndex;
            grdBuscaDBTableView1.Columns[ 1 ].Visible := false;

            stbLista.Panels[ 0 ].Text := IntToStr( tabBusca.RecordCount ) + ' Registros';
            panel_fantasma(true);
            GlbFocusPrimerItemGrid( grdBusca, grdBuscaDBTableView1 );
         end;
      //--------------------------------------------------------------------
      end;
      Result:=true;
   end;

   //  ---------------------------------------------------------------------------------------------------

begin
   inherited;

   screen.cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );

   try
      if ( g_demonio = false ) and ( g_busca_remoto = false ) then begin
         if dm.sqlselect( dm.q1, 'select fecha from tsutileria where cutileria=' + g_q + 'TSINDEX03' + g_q ) then
            FechaTSS := dm.q1.fieldbyname( 'fecha' ).AsString;

         if FechaTSS <> FechaTSI then begin
            dm.get_utileria( 'TSINDEX03', tsindex03 );    //trae la utileria
            g_borrar.add( tsindex03 );
         end;
      end;

      refrescapantalla;
      Application.ProcessMessages;
      inicio := now;

      if trim( cmbsistema.Text ) = '' then begin     //combo de sistema
         application.MessageBox( 'El campo Sistema - No puede ir en blanco ', pchar( Caption ), MB_OK );
         cmbsistema.SetFocus;
         exit;
      end;

      if trim( cmbclase.Text ) = '' then begin     //combo de clase
         application.MessageBox( 'El campo Clase - No puede ir en blanco ', pchar( Caption ), MB_OK );
         cmbclase.SetFocus;
         exit;
      end;

      texto := cmbbiblioteca.Text;

      if trim( texto ) = '' then begin     //combo de biblioteca
         application.MessageBox( 'El campo Bibliotecas - No puede ir en blanco ', pchar( Caption ), MB_OK );
         cmbbiblioteca.SetFocus;
         exit;
      end;

      texto:=combo.Text;
      if modo_case='MAYUSCULAS' then
         texto := UpperCase( texto );
      if modo_case='MINUSCULAS' then
         texto := LowerCase( texto );

      if trim( texto ) = '' then begin      //combo de busqueda
         application.MessageBox( 'campo Busca - Requiere al menos de 3 caracteres', pchar( Caption ), MB_OK );
         combo.SetFocus;
         exit;
      end;

      texto := stringreplace( texto, '''', '', [ rfreplaceall ] );
      texto := stringreplace( texto, '"', '', [ rfreplaceall ] );
      texto := stringreplace( texto, ':', '', [ rfreplaceall ] );
      texto := trim( texto );

      if length( texto ) < 3 then begin
         application.MessageBox( 'Debe ser mayor a 2 caracteres', 'Corregir', MB_OK );
         exit;
      end;

      // ------------  Procedimiento para mostrar resultados ----------------   ALK
      panel_fantasma(false); // para quitar el panel hasta que se tengan los resultados seguros
      // --------------------------------------------------------------------

      i := combo.Items.IndexOf( texto );

      if i > -1 then
         combo.Items.Delete( i );

      combo.Items.Insert( 0, texto );
      combo.ItemIndex := 0;
      salida := g_tmpdir + '\tsindex03_' + g_usuario + '_' + formatdatetime( 'YYYYMMDDHHNNSS', now ); //--    archivo donde recibe respuesta
      refrescapantalla;
      combo.Text := stringreplace( combo.Text, '%', '*', [ rfreplaceall ] );
      buscado := combo.Text;
      /////combo.Enabled := false;
      screen.Cursor := crsqlwait;
      deletefile( salida );
      k := combo.Items.IndexOf( buscado );

      if k > -1 then
         combo.Items.Delete( k );

      combo.Items.Insert( 0, buscado );
      combo.ItemIndex := 0;
      cmbmascara.Text := stringreplace( cmbmascara.Text, ' ', '', [ rfreplaceall ] );

      if trim( cmbmascara.Text ) = '' then
         cmbmascara.Text := '*';

      mascara := cmbmascara.Text;
      k := cmbmascara.Items.IndexOf( mascara );

      if k > -1 then
         cmbmascara.Items.Delete( k );

      cmbmascara.Items.Insert( 0, mascara );
      cmbmascara.ItemIndex := 0;

      //  ---------------------  ALK para multibibliotecas ---------------
      if multibib = 1 then begin
         grdDatosDBTableView1.ClearItems;  //para limpiar el grid si es que tenia datos anteriores

         bib_combo:=TStringList.Create;     //para tener a la mano las bibliotecas
            bib_combo.CommaText:=cmbbiblioteca.Items.CommaText;

         todas_bib:=TStringList.Create;  //para ir almacenando lo que trae el buffer
         SetLength( multibibliotecas, Length( multibibliotecas ) + 1 );
         for ii:=1 to bib_combo.Count-1 do begin //desde uno para saltar la opcion todas las bibliotecas
            //indicadores para procesar el query (cuando trae)
            bib_f:=0;
            if ii = bib_combo.Count-1 then
               bib_f:=1;   //si es la ultima biblioteca se crea el csv
            if ii = 1 then begin
               bib_1:=1;   //si es la primera biblioteca, lleva titulos
            end
            else begin
               bib_1:=0;
            end;
            //funcion que hace todo el proceso
            if not procesa_x_bib(bib_combo[ii],0) then
               Exit;

            ht.text := buffer;
            guarda_bib(ht,bib_combo[ii]);
            //mandar cada una pero quitarle los 3 primeros campos a partir de la segunda vuelta
            ht.Clear;
            ht.text := buffer;
            if todas_bib.Count = 0 then
               guarda_compos(0,ht)
            else
               guarda_compos(3,ht);
            ht.Clear;
         end;
         ht.text:=todas_bib.Text;
         if EditaQuery.Text = '' then  // para evitar errores cuando se hace el query
            if not procesa_x_bib('FIN',2) then
               exit;
      end
      else begin
         if not procesa_x_bib(cmbbiblioteca.Text,1) then  //si solo eligio una biblioteca, procesar y seguir
            exit;
         ht.text := buffer;
         guarda_bib(ht,cmbbiblioteca.Text);
      end;

      if EditaQuery.Text = '' then  // para evitar errores cuando se hace el query
         //grdBuscaDBTableView1DblClick(SELF);       // BMG
         muestra_un_dato;    //mostrar el primer resultado cuando no tiene query

      if (stbLista.Panels[ 0 ].Text='') or (stbLista.Panels[ 0 ].Text='0 Registros') then begin
         panel_fantasma(false);
         combo.Focused;
         Application.MessageBox( 'Sin resultados', 'Aviso', MB_OK );
      end;

   finally
      g_borrar.Add( salida );
      gral.PubMuestraProgresBar( false );
      screen.Cursor := crdefault;

      // ----------- limpiar busqueda --------------
      SetLength( aBusca, 0 );
      mnuBuscarAnterior.Enabled := False;
      mnuBuscarSiguiente.Enabled := False;
      mnuTextoBuscar.Text:='';
      //--------------------------------------------
   end;
end;

procedure TfmBuscaCompo.carga_fuente2( biblioteca, fuente, clase: string );
var
   buffer: Pchar;
   salida, pal: string;
   i, j, k, m: integer;
   b_mismalinea, b_califica: boolean;
   sBFile: String;
begin
   screen.cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );

   try
      sBFile := '';
      sBFile := dm.sPubObtenerBFile( fuente, biblioteca, clase );

      if sBFile = '' then begin
         Application.MessageBox( pchar( dm.xlng( 'No existe fuente ' + biblioteca + ' ' + fuente ) ),
            pchar( dm.xlng( 'Búsqueda ' ) ), MB_OK );
         exit;
      end;

      salida := g_tmpdir + '\tsindex03' + '_lineas.html';
      rich.Lines.Text := sBFile;

      lineas.Clear;
      lineas.Add( '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' );
      lineas.Add( '<html xmlns="http://www.w3.org/1999/xhtml" lang="es" xml:lang="es">' );
      lineas.Add( '<head>' );
      lineas.Add( '<title height="100">Lineas</title>' );
      lineas.Add( '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />' );
      lineas.Add( '</head>' );
      lineas.Add( '<body>' );
      lineas.Add( '<H3><CENTER ><font face="verdana" size="1"><A HREF=$' + fuente + '>' + fuente + '</A></font></CENTER></H3>' );

      if ht[ 0 ] <> 'Lista' then begin
         filtros.Clear;
         filtros.Add( palabra );
      end;

      for i := 0 to rich.Lines.Count - 1 do begin
         b_califica := false;

         for j := 0 to filtros.Count - 1 do begin
            pal := filtros[ j ];
            b_mismalinea := ( ( pos( '@', pal ) > 0 ) or ( pos( '<', pal ) > 0 ) );
            filtrosno.Clear; // palabras que no deben ir en la misma linea

            if pos( '<', pal ) > 0 then begin
               filtrosno.commatext := stringreplace( copy( pal, pos( '<', pal ) + 1, 1000 ), '<', ',', [ rfreplaceall ] );
               pal := copy( pal, 1, pos( '<', pal ) - 1 );
            end;

            if b_mismalinea then begin
               filtros2.commatext := stringreplace( pal, '@', ',', [ rfreplaceall ] );

               for k := 0 to filtros2.Count - 1 do begin
                  if pos( filtros2[ k ], rich.Lines[ i ] ) = 0 then
                     break;
               end;

               if k = filtros2.Count then begin
                  b_califica := true;
                  m := 0;

                  for m := 0 to filtrosno.Count - 1 do begin
                     if pos( filtrosno[ m ], rich.Lines[ i ] ) > 0 then begin
                        b_califica := false;
                        break;
                     end;
                  end;
               end;
            end
            else begin
               if pos( pal, rich.Lines[ i ] ) > 0 then begin
                  b_califica := true;
               end;
            end;
         end;

         if b_califica then begin
            lineas.Add( '<font face="verdana" size="1"><A HREF="#' + inttostr( i ) +
               '">' + inttostr( i + 1 ) + ' > ' +
               stringreplace( stringreplace( rich.Lines[ i ],
               '>', ' >', [ rfreplaceall ] ),
               '<', '< ', [ rfreplaceall ] ) +
               '</A></font><BR>' );

            if num_linea = 0 then   // si es la primera vez que lo va a mostrar
               num_linea:= i;
         end;
      end;

      lineas.Add( '</body>' );
      lineas.Add( '</html>' );
      lineas.SaveToFile( salida );
      web2.Navigate( salida );
      salidaW2 := salida;
      g_borrar.Add( salida );
   finally
      gral.PubMuestraProgresBar( false );
      screen.Cursor := crdefault;
   end;
end;

procedure TfmBuscaCompo.cmbbibliotecaChange( Sender: TObject );
var
   iPos1 : Integer;
   consulta:string;
begin
   inherited;
   panel_fantasma(false);
   EditaQuery.Text:='';
   EditaQuery.Enabled:=false;
   combo.Clear;
   combo.Enabled:=false;

   // ------ para cancelar la parte del query -----
   lblquery.Visible := false;
   panel6.Visible := FALSE;
   pnlmenu.Visible := FALSE;
   EditaQuery.text := '';
   // ---------------------------------------------

   bejecuta.Enabled:=false;

   if cmbbiblioteca.Text = '' then exit;

   screen.cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );

   try
      refrescapantalla;

      if cmbbiblioteca.Text = 'TODAS LAS BIBLIOTECAS' then begin
         consulta:= 'select cclase from tsprog ' +
                    ' where cclase = ' + g_q + lClase + g_q;
         multibib:=1;        //para indicar que proceso va a hacer
      end
      else begin
         consulta:= 'select cclase from tsprog ' +
      //            ' where cbib=' + g_q + dm.descbib( cmbbiblioteca.Text ) + g_q +
                    ' where cbib=' + g_q + cmbbiblioteca.Text + g_q +
                    ' and  cclase = ' + g_q + lClase + g_q;
         multibib:=0;
         bib_1:=0;
         bib_f:=0;
      end;

      if dm.sqlselect( dm.q1, consulta ) then begin

         lClase := dm.q1.fieldbyname( 'cclase' ).AsString;

         if sqlClases.IndexOf( dm.q1.fieldbyname( 'cclase' ).AsString ) > -1 then begin
            lblquery.Visible := true;
            panel6.Visible := True;
         end
         else begin
            lblquery.Visible := false;
            panel6.Visible := FALSE;
            pnlmenu.Visible := FALSE;
            EditaQuery.text := '';
         end;
      end
      else begin
         lblquery.Visible := false;
         panel6.Visible := FALSE;
         pnlmenu.Visible := FALSE;
         EditaQuery.text := '';
      end;

      combo.Enabled:=true;
      EditaQuery.Enabled:=true;
   finally
      gral.PubMuestraProgresBar( false );
      screen.Cursor := crdefault;
   end;
end;

procedure TfmBuscaCompo.cmbmascaraChange( Sender: TObject );
begin
   inherited;

//   refrescapantalla;
end;

procedure TfmBuscaCompo.cmbpaginaClick( Sender: TObject );
begin
   inherited;

   if bindice.Visible then
      web_pagina( palabra, strtoint( cmbpagina.Text ) )
   else begin
      cmbpagina.Tag := strtoint( cmbpagina.Text ); // aqui se guarda la pagina del indice que se estaba consultando
      web_indice( strtoint( cmbpagina.Text ) );
   end;
end;

procedure TfmBuscaCompo.comboChange( Sender: TObject );
var
   texto: string;
begin
   inherited;

   texto := cmbbiblioteca.Text;
   if trim( texto ) = '' then begin
      application.MessageBox( 'El campo Bibliotecas - No puede ir en blanco ', pchar( Caption ), MB_OK );
      cmbbiblioteca.SetFocus;
   end;

   cmbmascara.Enabled:=true;
   bejecuta.Enabled:=true;
   //refrescapantalla;
end;

procedure TfmBuscaCompo.comboClick( Sender: TObject );
begin
   inherited;

   combo.SetFocus;
   refrescapantalla;
end;

procedure TfmBuscaCompo.cxSplitter1BeforeOpen( Sender: TObject;
   var AllowOpen: Boolean );
begin
   inherited;

   //pnlmenu.Width := 193;
   //pnlmenu.Visible := True;
end;

procedure TfmBuscaCompo.EditaQueryEnter( Sender: TObject );
begin
   inherited;

   EditaQuery.SelectAll;
   EditaQuery.Font.Size := 8;
   EditaQuery.Font.Name := 'MS Sans Serif';
end;

procedure TfmBuscaCompo.FormClose( Sender: TObject;
   var Action: TCloseAction );
begin
   inherited;

   DeleteFile( archivocsv );
end;

procedure TfmBuscaCompo.FormCreate( Sender: TObject );
var
   ListaLibs: string;
   arch: string;
   x1: Tstringlist;
   i: Integer;
begin
   inherited;
   //   mnuBuscar.Visible := ivNever;
   screen.cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );

   try
      for i := 0 to mnuPrincipal.ItemCount - 1 do
         if ( mnuPrincipal.Items[ i ].Name = 'mnuVer' ) or
            ( mnuPrincipal.Items[ i ].Name = 'mnuHistoria' ) then
            mnuPrincipal.Items[ i ].Enabled := true;

      if gral.bPubVentanaMaximizada = FALSE then begin
         Width := g_Width;
         //Height := g_Height;
         Height := 550;    //para ocultar el grid de principio  ALK
      end;

      //cxPageControl1.Visible:=false;   // para desaparecer grid  ALK

      itemsxpagina := 1000;
      filtros := Tstringlist.Create;
      filtros2 := Tstringlist.Create;
      filtrosno := Tstringlist.Create;
      tsindex03 := g_ruta + 'tsindex03.exe';     //Cambiar a tmp  ??????

      if ( g_demonio = false ) and ( g_busca_remoto = false ) then begin
         dm.get_utileria( 'TSINDEX03', tsindex03 );
         g_borrar.add( tsindex03 );

         if dm.sqlselect( dm.q1, 'select fecha from tsutileria where cutileria=' + g_q + 'TSINDEX03' + g_q ) then
            FechaTSI := dm.q1.fieldbyname( 'fecha' ).AsString;
      end;

      x1 := Tstringlist.create;
      x1.Add( '<HTML>' );
      x1.Add( '<HEAD>' );
      x1.Add( '</head>' );
      x1.Add( '<BODY">' );
      x1.Add( '</BODY>' );
      x1.Add( '</html>' );
      x1.savetofile( g_tmpdir + '\BLimpia' + '.html' );
      arch := g_tmpdir + '\BLimpia' + '.html';
      g_borrar.Add( arch );
      x1.free;

      filtro_combos;
      sca := Tstringlist.Create;
      ht := Tstringlist.Create;
      fuentes := Tstringlist.Create;
      mas := Tstringlist.Create;
      menos := Tstringlist.Create;
      pals := Tstringlist.Create;
      lineas := Tstringlist.Create;

      {
      if dm.sqlselect( dm.q2, 'select * from parametro where clave=' + g_q + 'LIBSINFTES' + g_q ) = false then begin
         ListaLibs := '';
      end
      else begin
         ListaLibs := ' where cbib not in(' + g_q + dm.q2.fieldbyname( 'dato' ).Asstring + g_q + ')';
      end;

      dm.feed_combo( cmbbiblioteca, 'select descripcion from tsbib ' + ListaLibs + ' order by cbib' );
      }

      // ---------------- Crea el directorio tmpdir en oracle
      if dm.sqlselect( dm.q2, 'select * from all_directories ' +
         ' where directory_name=' + g_q + g_oratmpdir + g_q ) = false then begin
         if dm.sqlinsert( 'create directory ' + g_oratmpdir + ' as ' + g_q + g_tmpdir + g_q ) = false then begin
            Application.MessageBox( pchar( dm.xlng( 'ERROR... DM1003 no tiene permiso CREATE ANY DIRECTORY ' ) ),
               pchar( dm.xlng( 'Validar directorio ' ) ), MB_OK );
            application.Terminate;
            abort;
         end;
      end
      else begin
         if dm.sqlselect( dm.q2, 'select * from all_directories ' +
            ' where directory_name=' + g_q + g_oratmpdir + g_q + ' and directory_path <> ' + g_q + g_tmpdir + g_q ) then begin
            if dm.sqlinsert( 'create or replace directory ' + g_oratmpdir + ' as ' + g_q + g_tmpdir + g_q ) = false then begin
               Application.MessageBox( pchar( dm.xlng( 'ERROR... DM1003 no tiene permiso de CREATE OR REPLACE ANY DIRECTORY ' ) ),
                  pchar( dm.xlng( 'Validar directorio ' ) ), MB_OK );
               application.Terminate;
               abort;
            end;
         end;
      end;

      sql_clases;

      if gral.iPubVentanasActivas > 0 then
         gral.PubExpandeMenuVentanas( True );
   finally
      gral.PubMuestraProgresBar( false );
      screen.Cursor := crdefault;
      panel_fantasma(false);
   end;
end;

procedure TfmBuscaCompo.FormDeactivate( Sender: TObject );
begin
   inherited;

   gral.PopGral.Items.Clear;
end;

function TfmBuscaCompo.FormHelp( Command: Word; Data: Integer;
   var CallHelp: Boolean ): Boolean;
begin
   inherited;

   try
      PR_BARRA;
      HtmlHelp( Application.Handle, PChar( Format( '%s::/T%5.5d.htm',
         [ Application.HelpFile, iHelpContext ] ) ), HH_DISPLAY_TOPIC, 0 );
      CallHelp := False;
   except
      Application.MessageBox( 'No existe ayuda para la pantalla ó campo seleccionado', 'Ayuda ', MB_OK );
   end;
end;


procedure TfmBuscaCompo.mnuHistoriaClick( Sender: TObject );
begin
   inherited;

   //pnlMenu.Visible := not pnlMenu.Visible;
end;

procedure TfmBuscaCompo.refrescapantalla;
begin
   web1.Navigate( g_tmpdir + '\BLimpia.HTML' );
   web2.Navigate( g_tmpdir + '\BLimpia.HTML' );
   bindice.Visible := FALSE;
   lblpaginas.Caption := ' 0 ';
   cmbpagina.Clear;
   rich.Clear;
   refresh;
end;

procedure TfmBuscaCompo.web_indice( pagina: integer );
var
   salida, ndato: string;
   i, j, k, nreg: integer;
begin
   salida := g_tmpdir + '\tsindex03' + '1_' + formatdatetime( 'YYYYMMDDHHNNSS', now ) + '.html'; //--
   lineas.Clear;
   lineas.Add( '<html>' );
   lineas.Add( '<body>' );
   lineas.Add( '<table border="1" cellpadding="5" cellspacing="5" width="100%"' );
   lineas.add( 'style="background-color:clWhite;border:3px black;">' );
   lineas.Add( '<tr>' );
   lineas.Add( '<th style="text-align:left"><font face="verdana" size="1">Palabra encontrada</font></th>' );
   lineas.Add( '<th style="text-align:left">#</th>' );
   lineas.Add( '</tr>' );

   if idxpaginas = -1 then begin
      for i := 1 to ht.Count - 1 do begin
         if copy( ht[ i ], 1, 2 ) = '->' then
            break;
      end;
      idxpaginas := ( i + 98 ) div 100;
      lblpaginas.Caption := ' de ' + inttostr( idxpaginas );
      cmbpagina.Items.Clear;
      for i := 1 to idxpaginas do
         cmbpagina.Items.Add( inttostr( i ) );
      if idxpaginas > 0 then begin
         cmbpagina.ItemIndex := pagina - 1;
      end;

      bindice.Visible := false;
   end;

   for i := 1 to 100 do begin
      j := 100 * ( pagina - 1 ) + i;
      if copy( ht[ j ], 1, 2 ) = '->' then
         break;
      k := pos( chr( 9 ), ht[ j ] );
      ndato := copy( ht[ j ], 1, k - 1 );
      nreg := strtoint( copy( ht[ j ], k + 1, 500 ) );

      lineas.Add( '<tr>' );
      lineas.Add( '<td width="200"><font face="verdana" size="1"><a href="#ind_' +
         inttostr( nreg ) + '_ind_' + ndato + '">' + ndato + '</a></font></td>' +
         '<td><font face="verdana" size="1">' + inttostr( nreg ) + '</font></td>' );
      lineas.Add( '</tr>' );
   end;

   lineas.Add( '</table>' );
   lineas.Add( '</body>' );
   lineas.Add( '</html>' );
   lineas.SaveToFile( salida );
   web1.Navigate( salida );
   g_borrar.Add( salida ); //--
end;

procedure TfmBuscaCompo.web_pagina( palabras: string; pagina: integer );
var
   salida: string;
   i, j, k, m: integer;
begin
   salida := g_tmpdir + '\tsindex03' + '_' + formatdatetime( 'YYYYMMDDHHNNSS', now ) + '.html'; //--
   palabras := stringreplace( palabras, '%20', ' ', [ rfreplaceall ] );
   lineas.Clear;
   lineas.Add( '<html>' );
   lineas.Add( '<body>' );
   lineas.Add( '<H3><font face="verdana" size="1"><a href="#indice">' + palabras + '</a></font></H3>' );
   for i := 1 to ht.Count - 1 do begin
      if copy( ht[ i ], 1, 2 ) = '->' then begin
         k := pos( chr( 9 ), ht[ i ] );
         if palabras = copy( ht[ i ], 3, k - 3 ) then begin
            m := ( pagina - 1 ) * itemsxpagina + i;
            for j := 1 to itemsxpagina do begin
               if j + m > ht.count - 1 then
                  break;
               if copy( ht[ j + m ], 1, 2 ) = '->' then
                  break;
               lineas.Add( '<font face="verdana" size="1"><a href="#' + ht[ j + m ] + '">' +
                  ht[ j + m ] + '</a></font><br>' );
            end;
            break;
         end;
      end;
   end;
   lineas.Add( '</body>' );
   lineas.Add( '</html>' );
   lineas.SaveToFile( salida );
   web1.Navigate( salida );
   g_borrar.Add( salida ); //--
end;

procedure TfmBuscaCompo.web1BeforeNavigate2( Sender: TObject;
   const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
   Headers: OleVariant; var Cancel: WordBool );
var
   i, j, k, m: integer;
begin
   inherited;

   screen.cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );

   try
      if b_esperaweb then begin
         cancel := true;
         exit;
      end;

      b_esperaweb := true;
      screen.Cursor := crHourGlass;
      k := pos( '#', URL );
      m := pos( '_ind_', URL );

      if k > 0 then begin
         if copy( URL, k, 7 ) = '#indice' then begin
            web_indice;
         end
         else if copy( URL, k, 5 ) = '#ind_' then begin
            paginas := ( ( strtoint( copy( URL, k + 5, m - k - 5 ) ) - 1 ) div itemsxpagina ) + 1;
            lblpaginas.Caption := ' de ' + inttostr( paginas );
            cmbpagina.Items.Clear;

            for i := 1 to paginas do
               cmbpagina.Items.Add( inttostr( i ) );

            cmbpagina.ItemIndex := 0;
            //                   ypaginas.Visible:=true;
            bindice.Visible := true;
            palabra := copy( URL, m + 5, 500 );
            palabra := stringreplace( palabra, '%20', ' ', [ rfreplaceall ] );
            web_pagina( palabra, 1 );
         end
         else if copy( URL, k, 4 ) <> '#ind' then begin // Es un nombre de programa
            web2.Navigate( g_tmpdir + '\BLimpia.HTML' );

            {
            if dm.sqlselect( dm.q1, 'select distinct cclase from tsprog ' +
               ' where cbib=' + g_q + dm.descbib( cmbbiblioteca.Text ) + g_q ) then begin
               bgral := copy( URL, k + 1, 500 ) + ' ' + dm.descbib( cmbbiblioteca.Text ) + ' ' +
                  dm.q1.fieldbyname( 'cclase' ).AsString + ' ' + dm.q1.fieldbyname( 'sistema' ).AsString;
            end;

            carga_fuente2( dm.descbib( cmbbiblioteca.Text ), copy( URL, k + 1, 500 ), dm.q1.fieldbyname( 'cclase' ).AsString );
            }

            if dm.sqlselect( dm.q1, 'select distinct cclase from tsprog ' +
               ' where cbib=' + g_q + cmbbiblioteca.Text + g_q ) then begin
               bgral := copy( URL, k + 1, 500 ) + ' ' + cmbbiblioteca.Text + ' ' +
                  dm.q1.fieldbyname( 'cclase' ).AsString + ' ' + dm.q1.fieldbyname( 'sistema' ).AsString;
            end;

            carga_fuente2(cmbbiblioteca.Text, copy( URL, k + 1, 500 ), dm.q1.fieldbyname( 'cclase' ).AsString );

         end;
      end;
   finally
      gral.PubMuestraProgresBar( false );
      screen.Cursor := crdefault;
   end;
end;

procedure TfmBuscaCompo.web1DocumentComplete( Sender: TObject;
   const pDisp: IDispatch; var URL: OleVariant );
begin
   inherited;

   if trim( URL ) = '' then
      exit;

   combo.Enabled := true;
   b_esperaweb := false;
end;

procedure TfmBuscaCompo.Web2BeforeNavigate2( Sender: TObject;
   const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
   Headers: OleVariant; var Cancel: WordBool );
var
   k, m, y: integer;
begin       
   inherited;

  screen.cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );

   try
      k := pos( '#', URL );

      if k > 0 then begin
         k := strtoint( copy( URL, k + 1, 100 ) );
         rich.SelAttributes.Color := clblack;
         Rich.SelStart := Rich.Perform( EM_LINEINDEX, k, 0 );
         rich.Perform( EM_SCROLLCARET, 0, 0 );
         m := rich.Perform( EM_GETFIRSTVISIBLELINE, 0, 0 );
         m := k - m - 10;
         rich.Perform( EM_LINESCROLL, 0, m );
         rich.SelLength := length( rich.Lines[ k ] );
         rich.SelAttributes.Color := clblue;
         cancel := true;
      end;

      k := pos( '$', URL );

      if k > 0 then begin
         Opciones := gral.ArmarMenuConceptualWeb( bgral, 'busca_componentes' );
         y := ArmarOpciones( Opciones );
         gral.PopGral.Popup( g_X, g_Y );
         web2.Navigate( salidaW2 );
      end;
   finally
      gral.PubMuestraProgresBar( false );
      screen.Cursor := crdefault;
   end;
end;

procedure TfmBuscaCompo.grdConsultasDBTableView1DblClick( Sender: TObject );
var
   sCaptionConsulta: String;
   sCaptionFechaHora: String;
begin
   inherited;
   sCaptionConsulta := dm.tabConsultas.FindField( 'ConsultaCaption' ).AsString;
   sCaptionFechaHora := dm.tabConsultas.FindField( 'FechaHoraCaption' ).AsString;
   if gral.bPubConsultaActiva( sCaptionConsulta, sCaptionFechaHora ) then
      EditaQuery.text := sCaptionConsulta;
end;

procedure TfmBuscaCompo.cmbsistemaChange(Sender: TObject);
begin
   inherited;

   panel_fantasma(false);
   EditaQuery.Text:='';
   EditaQuery.Enabled:=false;
   combo.Clear;
   combo.Enabled:=false;
   cmbbiblioteca.Clear;
   cmbbiblioteca.Enabled:=false;
   cmbclase.Clear;
   cmbclase.Enabled:=false;

   // ------ para cancelar la parte del query -----
   lblquery.Visible := false;
   panel6.Visible := FALSE;
   pnlmenu.Visible := FALSE;
   EditaQuery.text := '';
   // ---------------------------------------------

   bejecuta.Enabled:=false;
   BitBtn2.Enabled:=true;

   
   if cmbsistema.Text = '' then
   exit;

   cmbClase.Clear;
   cmbClase.Enabled:=true;
   filtro_combos;
end;

procedure TfmBuscaCompo.cmbclaseChange(Sender: TObject);
begin
   inherited;
   panel_fantasma(false);
   EditaQuery.Text:='';
   EditaQuery.Enabled:=false;
   combo.Clear;
   combo.Enabled:=false;
   cmbbiblioteca.Clear;
   cmbbiblioteca.Enabled:=false;

   // ------ para cancelar la parte del query -----
   lblquery.Visible := false;
   panel6.Visible := FALSE;
   pnlmenu.Visible := FALSE;
   EditaQuery.text := '';
   // ---------------------------------------------

   bejecuta.Enabled:=false;

   if cmbclase.Text = '' then
      exit;

   cmbbiblioteca.Enabled:=true;
   filtro_combos;
   lclase :=  copy(cmbClase.Text,1, pos('-',cmbClase.Text) - 2);
   if dm.sqlselect(dm.q1,'select modocaracteres from tsclase where cclase='+g_q+lclase+g_q) then
      modo_case:=dm.q1.fieldbyname('modocaracteres').asstring;
end;

procedure TfmBuscaCompo.grdDatosDBTableView1DblClick(Sender: TObject);
var
   sComponente,bib,cons: string;
   y,i,numCom: integer;
   separado, Opciones, bibliotecas: Tstringlist;
begin
   inherited;
   numCom:=-1;

   //buscar la columna con el nombre de $SOURCE para obtener el componente
   for i:=0 to grdDatosDBTableView1.ColumnCount -1 do begin
      if grdDatosDBTableView1.Columns[i].Caption = '$SOURCE' then begin
         numCom:=i;    // numero de columna que contiene los componentes
         break;
      end;
   end;

   if numCom = -1 then begin
      Application.MessageBox( pchar( dm.xlng( 'No se encuentra columna $SOURCE.' ) ),
                             pchar( dm.xlng( 'Sin datos' ) ), MB_OK );
      exit;
   end;

   // si se tienen todos los datos, hacer el menu
   Opciones:=TStringList.Create;
   screen.Cursor := crsqlwait;
   try
      if cmbbiblioteca.Text <> 'TODAS LAS BIBLIOTECAS' then       // cuando se sabe cual es la biblioteca
         sComponente:= Trim( grdDatosDBTableView1.Columns[ numCom ].EditValue )+ '|' +     //componente
                       Trim( cmbbiblioteca.Text ) +'|' +                               //biblioteca
                       copy(cmbclase.Text,1,pos('-',cmbclase.Text)-2)+ '|' +          //clase
                       copy(cmbsistema.Text,1,pos(' ',cmbsistema.Text)-1)            //sistema
      else begin     // cuando tenga todas las bibliotecas
         //verificar cuantas bibliotecas puede tener el componenete
         cons:= 'select distinct pcbib from tsrela where' +
                ' pcclase='+ g_q + copy(cmbclase.Text,1,pos('-',cmbclase.Text)-2) + g_q +
                ' and sistema='+ g_q + copy(cmbsistema.Text,1,pos(' ',cmbsistema.Text)-1) + g_q +
                ' and pcprog='+ g_q + grdDatosDBTableView1.Columns[ numCom ].EditValue + g_q;
         if not dm.sqlselect(dm.q5,cons) then begin
            Application.MessageBox( pchar( dm.xlng( 'No existe información de la biblioteca.' ) ),
                                    pchar( dm.xlng( 'Menú conceptual' ) ), MB_OK );
            exit;
         end;

         if dm.q5.IndexFieldCount > 0 then begin   // si tiene mas de una biblioteca
            try
               bibliotecas:=TStringList.Create;
               while not dm.q5.Eof do begin
                  bibliotecas.add(dm.q5.FieldByName('pcbib').AsString);
                  dm.q5.Next;
               end;

               Application.MessageBox( pchar( dm.xlng('El componente pertenece a las siguientes biblitecas:' + chr( 13 ) +
                                       bibliotecas.Text + chr( 13 ) +
                                       'No se puede determinar la biblioteca.'+ chr( 13 ) +
                                       'Por favor especifique la biblioteca en las opciones '+ chr( 13 ) +
                                       'de búsqueda y ejecute nuevamente.' ) ),
                                       pchar( dm.xlng( 'Multiples bibliotecas' ) ), MB_OK );
               exit;
            finally
               bibliotecas.Free;

            end;
         end
         else   // si solo tiene una biblioteca
            sComponente:= Trim( grdDatosDBTableView1.Columns[ numCom ].EditValue )+ '|' +     //componente
                       dm.q5.FieldByName('pcbib').AsString +'|' +               //biblioteca
                       copy(cmbclase.Text,1,pos('-',cmbclase.Text)-2)+ '|' +          //clase
                       copy(cmbsistema.Text,1,pos(' ',cmbsistema.Text)-1);            //sistema
      end;

      if sComponente = '' then
         exit;

      bgral := stringreplace( trim( sComponente ), '|', ' ', [ rfReplaceAll ] );
      Opciones := gral.ArmarMenuConceptualWeb( sComponente, 'lista_componentes' );
      y := ArmarOpciones( Opciones );
      gral.PopGral.Popup( g_X, g_Y );
      sComponente := '';
   finally
      separado.Free;
      Opciones.Free;
      screen.Cursor := crdefault;
   end;
end;


procedure TfmBuscaCompo.grdBuscaDBTableView1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   if Button <> mbLeft then  // para salirse si es cualquier otro boton que no sea el izquierdo
      Exit;

   muestra_un_dato;
end;

procedure TfmBuscaCompo.muestra_un_dato;
var
   cons : String;
   k,m:integer;
begin
   gral.PubMuestraProgresBar( True );
   screen.Cursor := crsqlwait;

   try
     if grdBuscaDBTableView1.Columns[ 2 ].EditValue = '' then begin  //si no hay uno seleccionado, limpiar los paneles
         ptscomun.CrearArchivoTexto(g_tmpdir + '\BLimpia.HTML','');
         refrescapantalla;
         stbLista.Panels[ 0 ].Text := '';
         exit;
     end;
   except
      exit;
   end;

   num_linea:=0;

   try
      if cmbbiblioteca.Text <> 'TODAS LAS BIBLIOTECAS' then
         cons:= 'select distinct cclase,sistema from tsprog ' +
                ' where cbib=' + g_q + cmbbiblioteca.Text + g_q+
                ' and cclase='+g_q+ lclase +g_q
      else
         cons:= 'select distinct cclase,sistema from tsprog ' +
                ' where '+ //cbib=' + g_q + cmbbiblioteca.Text + g_q+
                {' and }'cclase='+g_q+ lclase +g_q;

      if dm.sqlselect( dm.q1,cons ) then
         bgral := grdBuscaDBTableView1.Columns[ 2 ].EditValue + ' ' +
            grdBuscaDBTableView1.Columns[ 3 ].EditValue + ' ' +
            dm.q1.fieldbyname( 'cclase' ).AsString + ' ' +
            dm.q1.fieldbyname( 'sistema' ).AsString;

      carga_fuente2(grdBuscaDBTableView1.Columns[ 3 ].EditValue,  //bib
         grdBuscaDBTableView1.Columns[ 2 ].EditValue,       //compo
         grdBuscaDBTableView1.Columns[ 4 ].EditValue );        //clase

      //GlbFocusPrimerItemGrid( grdBusca, grdBuscaDBTableView1 );

      if num_linea > 0 then begin
         k := num_linea;
         rich.SelAttributes.Color := clblack;
         Rich.SelStart := Rich.Perform( EM_LINEINDEX, k, 0 );
         rich.Perform( EM_SCROLLCARET, 0, 0 );
         m := rich.Perform( EM_GETFIRSTVISIBLELINE, 0, 0 );
         m := k - m - 10;
         rich.Perform( EM_LINESCROLL, 0, m );
         rich.SelLength := length( rich.Lines[ k ] );
         rich.SelAttributes.Color := clblue;
      end;
   finally
      gral.PubMuestraProgresBar( false );
      screen.Cursor := crdefault;
   end;
end;

procedure TfmBuscaCompo.grdBuscaDBTableView1DblClick( Sender: TObject );
var
   sComponente: string;
   y: integer;
   Opciones: Tstringlist;
begin
   inherited;
   Opciones:=TStringList.Create;
   screen.Cursor := crsqlwait;
   try
      sComponente := Trim( grdBuscaDBTableView1.Columns[ 2 ].EditValue ) + '|' +
         Trim( grdBuscaDBTableView1.Columns[ 3 ].EditValue ) + '|' +
         Trim( grdBuscaDBTableView1.Columns[ 4 ].EditValue ) + '|' +
         copy(cmbsistema.Text,1,pos(' ',cmbsistema.Text)-1);

      if sComponente = '' then
         exit;

      bgral := stringreplace( trim( sComponente ), '|', ' ', [ rfReplaceAll ] );
      Opciones := gral.ArmarMenuConceptualWeb( sComponente, 'lista_componentes' );
      y := ArmarOpciones( Opciones );
      gral.PopGral.Popup( g_X, g_Y );
      sComponente := '';
   finally
      Opciones.Free;
      screen.Cursor := crdefault;
   end;
end;

procedure TfmBuscaCompo.Web2NavigateComplete2(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
   inherited;
   //rich.SetFocus;
   if bejecuta.Enabled then
      bejecuta.SetFocus
   else
      Panel2.SetFocus;
end;

procedure TfmBuscaCompo.Panel2Resize(Sender: TObject);
var
   tam : integer;
begin
   {tam := 180;

   if cmbsistema.width < 350 then
      cmbsistema.width:=350
   else
      cmbsistema.width:=panel2.Width-tam;

   if cmbclase.width < 350 then
      cmbclase.width:=350
   else
      cmbclase.width:=panel2.Width-tam;

   if cmbbiblioteca.width < 350 then
      cmbbiblioteca.width:=350
   else
      cmbbiblioteca.width:=panel2.Width-tam;

   if combo.width < 350 then
      combo.width:=350
   else
      combo.width:=panel2.Width-tam;

   if EditaQuery.width < 350 then
      EditaQuery.width:=350
   else begin
      {if panel2.Width < tam then
         EditaQuery.width:=350
      else
         EditaQuery.width:=panel6.Width-tam;
   end;    }
end;

procedure TfmBuscaCompo.FormResize(Sender: TObject);
var
   tam : integer;
begin
   tam := 180;

   if cmbsistema.width < 350 then
      cmbsistema.width:=350
   else
      cmbsistema.width:=panel2.Width-tam;

   if cmbclase.width < 350 then
      cmbclase.width:=350
   else
      cmbclase.width:=panel2.Width-tam;

   if cmbbiblioteca.width < 350 then
      cmbbiblioteca.width:=350
   else
      cmbbiblioteca.width:=panel2.Width-tam;

   if combo.width < 350 then
      combo.width:=350
   else
      combo.width:=panel2.Width-tam;

   if EditaQuery.width < 350 then
      EditaQuery.width:=350
   else begin
      {if panel2.Width < tam then
         EditaQuery.width:=350
      else}
         EditaQuery.width:=panel6.Width-tam;
   end;
end;

procedure TfmBuscaCompo.panel_fantasma(visible:boolean);
begin
   // ------------  Procedimiento para mostrar resultados ----------------   ALK
   panelFantasma.Visible:=not visible;   // para dejar ver lo de abajo   ALK
   panelFantasma.BringToFront;
   stbLista.Visible:=visible;   // para ver la barra de estado   ALK
   Panel10.Visible:=visible;
   pnlMenu.Visible:=false;
   panelContenedor.Visible:=visible;
   Panel1.Visible:=visible;
   grdBusca.Visible:=visible;

   //if gral.bPubVentanaMaximizada = FALSE then
     // Height := 1000;    //para mostrar el grid de resultados  ALK
   // --------------------------------------------------------------------
end;

procedure TfmBuscaCompo.EditaQueryChange(Sender: TObject);
begin
   bejecuta.Enabled:=true;
end;

procedure TfmBuscaCompo.BitBtn2Click(Sender: TObject);
begin
   panel_fantasma(false);
   EditaQuery.Text:='';
   EditaQuery.Enabled:=false;
   combo.Clear;
   combo.Enabled:=false;
   cmbbiblioteca.Clear;
   cmbbiblioteca.Enabled:=false;
   cmbclase.Clear;
   cmbclase.Enabled:=false;
   cmbsistema.Clear;
   dm.feed_combo(cmbsistema,'select distinct pp.sistema||'+g_q+' - '+g_q+'||ss.descripcion '+
         ' from tssistema ss,tsprog pp '+
         ' where ss.csistema=pp.sistema '+
         ' and ss.estadoactual='+g_q+'ACTIVO'+g_q+
         ' order by 1');
   cmbsistema.Items.Insert(0,'');
   cmbsistema.Focused;

   // ------ para cancelar la parte del query -----
   lblquery.Visible := false;
   panel6.Visible := FALSE;
   pnlmenu.Visible := FALSE;
   EditaQuery.text := '';
   // ---------------------------------------------

   mnuTextoBuscar.Text:='';

   bejecuta.Enabled:=false;
   BitBtn2.Enabled:=false;
end;

procedure TfmBuscaCompo.dxBarDBNavNext1Click(Sender: TObject);
begin
   grdBuscaDBTableView1.DataController.GotoNext;

   // ----------- limpiar busqueda --------------
   SetLength( aBusca, 0 );
   mnuBuscarAnterior.Enabled := False;
   mnuBuscarSiguiente.Enabled := False;
   mnuTextoBuscar.Text:='';
   //--------------------------------------------
end;

procedure TfmBuscaCompo.dxBarDBNavPrev1Click(Sender: TObject);
begin
   grdBuscaDBTableView1.DataController.GotoPrev;

   // ----------- limpiar busqueda --------------
   SetLength( aBusca, 0 );
   mnuBuscarAnterior.Enabled := False;
   mnuBuscarSiguiente.Enabled := False;
   mnuTextoBuscar.Text:='';
   //--------------------------------------------
end;

procedure TfmBuscaCompo.dxBarDBNavFirst1Click(Sender: TObject);
begin
   grdBuscaDBTableView1.DataController.GotoFirst;

   // ----------- limpiar busqueda --------------
   SetLength( aBusca, 0 );
   mnuBuscarAnterior.Enabled := False;
   mnuBuscarSiguiente.Enabled := False;
   mnuTextoBuscar.Text:='';
   //--------------------------------------------
end;

procedure TfmBuscaCompo.dxBarDBNavLast1Click(Sender: TObject);
begin
   grdBuscaDBTableView1.DataController.GotoLast;

   // ----------- limpiar busqueda --------------
   SetLength( aBusca, 0 );
   mnuBuscarAnterior.Enabled := False;
   mnuBuscarSiguiente.Enabled := False;
   mnuTextoBuscar.Text:='';
   //--------------------------------------------
end;

procedure TfmBuscaCompo.mnuTextoBuscarExit(Sender: TObject);
var
   i,j,stop: Integer;
   slRecidRenglon, paraID, paraTabDatos: TStringList;
   sRecId, ArchTemp,dato: String;
begin
   if trim( mnuTextoBuscar.Text ) = '' then
      Exit;

   if grdBuscaDBTableView1.DataController.RecordCount = 0 then begin
      ShowMessage(' Sin registros ');
      mnuBuscarAnterior.Enabled := False;
      mnuBuscarSiguiente.Enabled := False;
      exit;
   end;

   if length(aBusca) <> 0 then
      if uppercase(aBusca[0].busqueda) = uppercase(mnuTextoBuscar.Text) then
         exit
      else
         SetLength( aBusca, 0 );

   gral.PubMuestraProgresBar( True );
   screen.Cursor := crsqlwait;
   try
      // --------------- Para llenar slPubLista -----------------------------------------------
      grdBuscaDBTableView1.DataController.DataSource.DataSet.DisableControls;
      ArchTemp:= g_tmpdir + '\ListBusqBuscaComp.txt';
      try
         ExportGrid4ToText( ArchTemp, grdBusca, True, True, ',', '"', '"' );
         paraID:=TstringList.Create;
         paraTabDatos:=TstringList.Create;
         if fileexists(ArchTemp) then
            paraID.LoadFromFile(ArchTemp)
         else begin
            Application.MessageBox( PChar('Error al abrir archivo: '+ArchTemp), 'Aviso', MB_OK );
            Exit;
         end;

         slPubLista.Clear;
         for j:=0 to paraID.Count-1 do begin
            if j=0 then begin
               dato:= '"RecId",'+paraID[j];
               slPubLista.add(dato);
            end
            else begin
               if paraID[j] <> '"","","","","","","","",""' then begin
                  dato:='"'+inttostr(j)+'",'+paraID[j];
                  slPubLista.add(dato);
               end;
            end;
         end;

         if slPubLista.Count > 1 then
            slPubLista.Delete( 0 ); //elimina titulos de los campos
      finally
         paraID.Free;
         paraTabDatos.Free;
         grdBuscaDBTableView1.DataController.DataSource.DataSet.EnableControls;
         DeleteFile( ArchTemp );
      end;

      // --------------------------------------------------------------------------------------
      grdBuscaDBTableView1.DataController.GotoFirst;
      stop:= 0;
      idBusqueda:=0;  // para indicar que lugar es el que ocupa la primer busqueda
      SetLength( aBusca, 0 );  // para guardar contenido y posicion
      for i := 0 to slPubLista.Count - 1 do
         if pos( UpperCase( mnuTextoBuscar.Text ), UpperCase( slPubLista[ i ] ) ) > 0 then begin
            SetLength( aBusca, length(aBusca) + 1 );
            aBusca[length(aBusca)-1].id:=i+1;   // posicion en la tabla (numero de renglon)
            aBusca[length(aBusca)-1].renglon:=slPubLista[ i ];   // renglon separado por comas...
            aBusca[length(aBusca)-1].busqueda:= mnuTextoBuscar.Text;   //palabra a buscar
            stop:=1;   // para detener el avance del grid
         end else
            if stop = 0 then
               grdBuscaDBTableView1.DataController.GotoNext;
   finally
      gral.PubMuestraProgresBar( false );
      screen.Cursor := crdefault;
   end;
   
   if length(aBusca) > 1 then begin  // si hay mas de un elemento, activar flechas
      mnuBuscarAnterior.Enabled := false;
      mnuBuscarSiguiente.Enabled := True;
   end
   else begin     //si no hay mas de un elemento, no activar flechas
      mnuBuscarAnterior.Enabled := false;
      mnuBuscarSiguiente.Enabled := false;
   end;
end;

procedure TfmBuscaCompo.mnuBuscarAnteriorClick(Sender: TObject);
var
   fila,i,long:integer;
begin
   if idBusqueda - 1 < 0 then begin
      mnuBuscarAnterior.Enabled := False;
      Exit;
   end;

   Screen.Cursor := crSqlWait;
   long:=length(aBusca);     //longitud de aBusca
   try
      fila:=aBusca[idBusqueda].id;  //fila seleccionada
      idBusqueda:=idBusqueda-1;  // anterior registro en aBusca
      for i := fila-1 downto 0 do begin        // partiendo desde la fila seleccionada
         grdBuscaDBTableView1.DataController.GotoPrev;
         if UpperCase( aBusca[idBusqueda].renglon ) = UpperCase( slPubLista[ i - 1 ] ) then begin
            // revisar si se habilitan o deshabilitan botones
            if idBusqueda <= 0 then begin
               mnuBuscarAnterior.Enabled := False;
               mnuBuscarSiguiente.Enabled := True;
            end
            else begin
               mnuBuscarAnterior.Enabled := True;
               mnuBuscarSiguiente.Enabled := True;
            end;
            break;
         end;
      end;
   finally
      Screen.Cursor := crDefault;
   end;
end;

procedure TfmBuscaCompo.mnuBuscarSiguienteClick(Sender: TObject);
var
   fila,i:integer;
begin
   if idBusqueda + 1 >= length(aBusca) then begin
      mnuBuscarSiguiente.Enabled := False;
      Exit;
   end;

   Screen.Cursor := crSqlWait;
   try
      fila:=aBusca[idBusqueda].id;  //fila seleccionada
      idBusqueda:=idBusqueda+1;  // siguiente registro en aBusca
      for i := fila to slPubLista.Count - 1 do begin        // partiendo desde la fila seleccionada
         grdBuscaDBTableView1.DataController.GotoNext;
         if UpperCase( aBusca[idBusqueda].renglon ) = UpperCase( slPubLista[ i ] ) then begin
            // revisar si se habilitan o deshabilitan botones
            if idBusqueda + 1 >= length(aBusca) then begin
               mnuBuscarAnterior.Enabled := True;
               mnuBuscarSiguiente.Enabled := False;
            end
            else begin
               mnuBuscarAnterior.Enabled := True;
               mnuBuscarSiguiente.Enabled := True;
            end;
            break;
         end;
      end;
   finally
      Screen.Cursor := crDefault;
   end;
end;

end.

