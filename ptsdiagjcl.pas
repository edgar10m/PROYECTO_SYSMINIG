unit ptsdiagjcl;
                   
interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ADODB, StdCtrls,
   Menus, ExtCtrls, ShellAPI, HTML_HELP, ExtDlgs, dxBar, ComCtrls, atDiagram, DB, dxmdaset,
   cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage, cxEdit, cxDBData,
   cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridLevel, cxClasses, cxControls,
   cxGridCustomView, cxGrid, dxBarExtItems, DgrCombo, DgrSelectors, ShlObj, DiagramActns;

type
   Tftsdiagjcl = class( TForm )
      SavePictureDialog1: TSavePictureDialog;
      PopupMenu1: TPopupMenu;
      GuardarComo2: TMenuItem;
      VistaAerea1: TMenuItem;
      PageControl1: TPageControl;
      TabSheet1: TTabSheet;
      TabSheet2: TTabSheet;
      ScrollBox1: TScrollBox;
      img: TImage;
      tabComponente: TdxMemData;
      tabComponentePrograma: TStringField;
      tabComponenteBiblioteca: TStringField;
      tabComponenteClase: TStringField;
      tabComponenteRenglon: TIntegerField;
      tabComponenteColumna: TIntegerField;
      tabComponenteNFisicoBlock: TStringField;
      tabComponenteNLogicoBlock: TStringField;
      tabComponenteLigaBlockOrigen: TStringField;
      tabComponenteLigaBlockDestino: TStringField;
      tabComponenteTipoBlock: TStringField;
      tabComponenteTexto: TStringField;
      TabSheet3: TTabSheet;
      DataSource1: TDataSource;
      cxGrid1DBTableView1: TcxGridDBTableView;
      cxGrid1Level1: TcxGridLevel;
      cxGrid1: TcxGrid;
      tabComponenteTipoBlockOrigen: TStringField;
      tabComponenteTipoBlockDestino: TStringField;
      cxGrid1DBTableView1RecId: TcxGridDBColumn;
      cxGrid1DBTableView1Programa: TcxGridDBColumn;
      cxGrid1DBTableView1Biblioteca: TcxGridDBColumn;
      cxGrid1DBTableView1Clase: TcxGridDBColumn;
      cxGrid1DBTableView1Renglon: TcxGridDBColumn;
      cxGrid1DBTableView1Columna: TcxGridDBColumn;
      cxGrid1DBTableView1NFisicoBlock: TcxGridDBColumn;
      cxGrid1DBTableView1NLogicoBlock: TcxGridDBColumn;
      cxGrid1DBTableView1TipoBlock: TcxGridDBColumn;
      cxGrid1DBTableView1LigaBlockOrigen: TcxGridDBColumn;
      cxGrid1DBTableView1LigaBlockDestino: TcxGridDBColumn;
      cxGrid1DBTableView1TipoBlockOrigen: TcxGridDBColumn;
      cxGrid1DBTableView1TipoBlockDestino: TcxGridDBColumn;
      cxGrid1DBTableView1Texto: TcxGridDBColumn;
      DgrColorSelector: TDgrColorSelector;
      DgrGradientDirectionSelector: TDgrGradientDirectionSelector;
      DgrBrushStyleSelector: TDgrBrushStyleSelector;
      DgrShadowSelector: TDgrShadowSelector;
      DgrPenStyleSelector: TDgrPenStyleSelector;
      DgrPenColorSelector: TDgrPenColorSelector;
      DgrTransparencySelector: TDgrTransparencySelector;
      DgrPenWidthSelector: TDgrPenWidthSelector;
      DgrTextColorSelector: TDgrTextColorSelector;
      DgrFontSelector: TDgrFontSelector;
      DgrFontSizeSelector: TDgrFontSizeSelector;
      SaveDialog: TSaveDialog;
      atDiagramJCL: TatDiagram;
      mnuPrincipal: TdxBarManager;
      mnuArchivo: TdxBarSubItem;
      mnuGuardar: TdxBarButton;
      mnuImprimir: TdxBarButton;
      mnuVistaPreliminar: TdxBarButton;
      mnuPaginaConf: TdxBarButton;
      mnuEdicion: TdxBarSubItem;
      mnuDeshacer: TdxBarButton;
      mnuRehacer: TdxBarButton;
      mnuObjetoColor: TdxBarControlContainerItem;
      mnuGradiente: TdxBarControlContainerItem;
      mnuTransparencia: TdxBarControlContainerItem;
      mnuCepillarEstilo: TdxBarControlContainerItem;
      mnuSombra: TdxBarControlContainerItem;
      mnuLineaEstilo: TdxBarControlContainerItem;
      mnuLineaColor: TdxBarControlContainerItem;
      mnuLineaAncho: TdxBarControlContainerItem;
      mnuTextoColor: TdxBarControlContainerItem;
      mnuFontTipo: TdxBarControlContainerItem;
      mnuFontTamanio: TdxBarControlContainerItem;
      mnuBold: TdxBarButton;
      mnuItalic: TdxBarButton;
      mnuUnderline: TdxBarButton;
      mnuStrikeOut: TdxBarButton;
      mnuVer: TdxBarSubItem;
      mnuVerReglaIzquierda: TdxBarButton;
      mnuVerReglaSuperior: TdxBarButton;
      mnuVerCuadricula: TdxBarButton;
      mnuNodosAutomaticos: TdxBarButton;
      mnuZoom: TdxBarCombo;
      mnuBarraEdicion: TdxBarButton;
      mnuTextoBuscar: TdxBarCombo;
      mnuBuscar: TdxBarButton;
      mnuBuscarAnterior: TdxBarButton;
      mnuBuscarSiguiente: TdxBarButton;
      mnuExportar: TdxBarSubItem;
      mnuExportarExcel: TdxBarButton;
      mnuExportarWMF: TdxBarButton;
      mnuAyuda: TdxBarButton;
      mnuSeleccionarTodo: TdxBarButton;
      mnuBarraBusqueda: TdxBarButton;
      mnuBarraAlineacion: TdxBarButton;
      mnuSalir: TdxBarButton;
      mnuCopyImg: TdxBarButton;
      mnuAlinearBordesIzquierdo: TdxBarButton;
      mnuAlinearBordesDerechos: TdxBarButton;
      mnuAlinearCentrosHorizontales: TdxBarButton;
      mnuAlinearBordesSuperiores: TdxBarButton;
      mnuAlinearBordesInferiores: TdxBarButton;
      mnuAlinearCentrosVerticales: TdxBarButton;
      mnuHacerMismoAncho: TdxBarButton;
      mnuHacerMismaAltura: TdxBarButton;
      mnuHacerMismoTamano: TdxBarButton;
      mnuEspacioIgualHorizontal: TdxBarButton;
      mnuIncrementarEspacioHorizontal: TdxBarButton;
      mnuDisminuirEspacioHorizontal: TdxBarButton;
      mnuEspacioIgualVertical: TdxBarButton;
      mnuIncrementarEspacioVertical: TdxBarButton;
      mnuDisminuirEspacioVertical: TdxBarButton;
      mnuCopiarBusqueda: TdxBarButton;
    dxBarSubItem1: TdxBarSubItem;
    dxBarButton1: TdxBarButton;
      procedure Aumentar1Click( Sender: TObject );
      procedure Guardarcomo1Click( Sender: TObject );
      procedure FormClose( Sender: TObject; var Action: TCloseAction );
      procedure FormDestroy( Sender: TObject );
      procedure FormCreate( Sender: TObject );
      procedure FormActivate( Sender: TObject );
      procedure mnuGuardarClick( Sender: TObject );
      procedure mnuImprimirClick( Sender: TObject );
      procedure mnuVistaPreliminarClick( Sender: TObject );
      procedure mnuPaginaConfClick( Sender: TObject );
      procedure mnuDeshacerClick( Sender: TObject );
      procedure mnuRehacerClick( Sender: TObject );
      procedure mnuZoomChange( Sender: TObject );
      procedure mnuVerReglaIzquierdaClick( Sender: TObject );
      procedure mnuVerReglaSuperiorClick( Sender: TObject );
      procedure mnuVerCuadriculaClick( Sender: TObject );
      procedure mnuBoldClick( Sender: TObject );
      procedure mnuItalicClick( Sender: TObject );
      procedure mnuUnderlineClick( Sender: TObject );
      procedure mnuStrikeOutClick( Sender: TObject );
      procedure mnuNodosAutomaticosClick( Sender: TObject );
      procedure mnuConsultaClick( Sender: TObject );
      procedure mnuGuardarPictureClick( Sender: TObject );
      procedure mnuExportarExcelClick( Sender: TObject );
      procedure atDiagramJCLDControlDblClick( Sender: TObject;
         ADControl: TDiagramControl );
      function ArmarOpciones( b1: Tstringlist ): integer;
      function ArmarOpcionesGpoComp( b1: Tstringlist ): integer;
      procedure mnuBuscarClick( Sender: TObject );
      procedure mnuBuscarAnteriorClick( Sender: TObject );
      procedure mnuBuscarSiguienteClick( Sender: TObject );
      procedure mnuTextoBuscarExit( Sender: TObject );
      procedure FormKeyDown( Sender: TObject; var Key: Word;
         Shift: TShiftState );
      procedure atDiagramJCLSelectDControl( Sender: TObject;
         ADControl: TDiagramControl );
      procedure mnuExportarWMFClick( Sender: TObject );
      procedure atDiagramJCLMouseUp( Sender: TObject; Button: TMouseButton;
         Shift: TShiftState; X, Y: Integer );
      procedure mnuSalirClick( Sender: TObject );
      procedure mnuCopyImgClick( Sender: TObject );
      procedure mnuSeleccionarTodoClick( Sender: TObject );
      procedure mnuBarraEdicionClick( Sender: TObject );
      procedure mnuBarraBusquedaClick( Sender: TObject );
      procedure mnuBarraAlineacionClick( Sender: TObject );
      procedure mnuAlinearBordesIzquierdoClick( Sender: TObject );
      procedure mnuAlinearBordesDerechosClick( Sender: TObject );
      procedure mnuAlinearCentrosHorizontalesClick( Sender: TObject );
      procedure mnuAlinearBordesSuperioresClick( Sender: TObject );
      procedure mnuAlinearBordesInferioresClick( Sender: TObject );
      procedure mnuAlinearCentrosVerticalesClick( Sender: TObject );
      procedure mnuHacerMismoAnchoClick( Sender: TObject );
      procedure mnuHacerMismaAlturaClick( Sender: TObject );
      procedure mnuHacerMismoTamanoClick( Sender: TObject );
      procedure mnuEspacioIgualHorizontalClick( Sender: TObject );
      procedure mnuIncrementarEspacioHorizontalClick( Sender: TObject );
      procedure mnuDisminuirEspacioHorizontalClick( Sender: TObject );
      procedure mnuEspacioIgualVerticalClick( Sender: TObject );
      procedure mnuIncrementarEspacioVerticalClick( Sender: TObject );
      procedure mnuDisminuirEspacioVerticalClick( Sender: TObject );
      procedure mnuCopiarBusquedaClick( Sender: TObject );
    procedure mnuTextoBuscarEnter(Sender: TObject);
    procedure dxBarButton1Click(Sender: TObject);
   private
      { Private declarations }
      //imgview: Tftsimgview;
      excluyemenu: Tstringlist;
      b_impresion: boolean;
      Opciones: Tstringlist;
      //slPriBuscar: TStringList;
      sPriTextoBuscar: String;
      //iPriAntSigBuscar: Integer;
      //PriDiagramAlign: TDiagramAlign;
      sistema_alk:string;
      contenido_diagrama : TStringList;
      procedure PriMostrarBarraEdicion( bParMostrar: Boolean );
      procedure PriAlinear( ParAlineacion: TBlocksAlignment );
   public
      { Public declarations }
      titulo: string;
      dgryy: tStringlist;
      slPubJCL: TStringList;

      slPriBuscar: TStringList;
      PriDiagramAlign: TDiagramAlign;
      iPriAntSigBuscar: Integer;

      procedure inicializa_doc;   // para hacer la inicializacion que se hace desde formcreate   ALK
      procedure limpia_memdata;    //para limpiar el registro de los bloques   ALK
      procedure arma_diagrama( programa: string; bib: string; clase: string; sistema: string );
      procedure arma_diagrama_Visio; //( programa: string; bib: string; clase: string );
      procedure diagrama_jcl( programa: string; bib: string; clase: string; sistema: string );
   end;

implementation
uses
   ptsdm, ptsdiagramas, parbol, ptsgral, uDiagramaRutinas, ClipBrd, uConstantes;

{$R *.dfm}

procedure Tftsdiagjcl.arma_diagrama( programa: string; bib: string; clase: string; sistema: string );
var
   qq:Tadoquery;
   i: Integer;
   pr, bi, cl, ex, mo: string;
   dato : String;  // ALK
begin
   qq:=Tadoquery.Create(self);
   qq.Connection:=dm.ADOConnection1;
   sistema_alk:=sistema;
   {
   //obtiene datos de Tsrela y los deposita en aGLBTsrela
   dm.TaladrarTsrela( DrillDown, Sistema, programa, bib, clase, not bREGISTRA_REPETIDOS );

   for i := 0 to Length( aGLBTsrela ) - 1 do begin
      pr := aGLBTsrela[ i ].sHCPROG;
      bi := aGLBTsrela[ i ].sHCBIB;
      cl := aGLBTsrela[ i ].sHCCLASE;
      ex := aGLBTsrela[ i ].sEXTERNO;
      mo := aGLBTsrela[ i ].sMODO;

      grafica_registro( pr, bi, cl, ex, mo );
   end;
   }
   if dm.sqlselect(qq,'select hcprog,hcbib,hcclase,externo,modo from tsrela '+
      ' where pcprog='+g_q+programa+g_q+
      ' and   pcbib='+g_q+bib+g_q+
      ' and   pcclase='+g_q+clase+g_q+
      ' order by orden,hcprog,hcbib,hcclase') then begin
      while not qq.eof do begin
         //----- comprobar que el registro no exista ----    ALK
         dato:= qq.fieldbyname('hcprog').asstring + '|' +
            qq.fieldbyname('hcbib').asstring+ '|' +
            qq.fieldbyname('hcclase').asstring+ '|' +
            qq.fieldbyname('externo').asstring+ '|' +
            qq.fieldbyname('modo').asstring;

         if contenido_diagrama.IndexOf(dato)=-1 then  //si no encuentra el dato
            contenido_diagrama.Add(dato)
         else
            exit;
         // --------------------------------------------
         grafica_registro(qq.fieldbyname('hcprog').asstring,
            qq.fieldbyname('hcbib').asstring,
            qq.fieldbyname('hcclase').asstring,
            qq.fieldbyname('externo').asstring,
            qq.fieldbyname('modo').asstring);
         arma_diagrama(qq.fieldbyname('hcprog').asstring,
            qq.fieldbyname('hcbib').asstring,
            qq.fieldbyname('hcclase').asstring,
            sistema);
         qq.next;
      end;
   end;
   qq.Free;
end;

{procedure Tftsdiagjcl.arma_diagrama( programa: string; bib: string; clase: string );
var
   qq: TADOquery;
   pr, bi, cl, ex, mo: string;
begin
   qq := TADOquery.Create( nil );
   qq.Connection := dm.ADOConnection1;

   if dm.sqlselect( qq, 'select * from tsrela ' +
      ' where pcprog=' + g_q + programa + g_q +
      ' and   pcbib=' + g_q + bib + g_q +
      ' and   pcclase=' + g_q + clase + g_q +
      ' order by orden' ) then begin
      while not qq.Eof do begin
         pr := qq.FieldByName( 'hcprog' ).AsString;
         bi := qq.FieldByName( 'hcbib' ).AsString;
         cl := qq.FieldByName( 'hcclase' ).AsString;
         ex := qq.fieldbyname( 'externo' ).AsString;
         mo := qq.fieldbyname( 'modo' ).AsString;
         grafica_registro( pr, bi, cl, ex, mo );
         arma_diagrama( pr, bi, cl );
         qq.Next;
      end;
   end;

   qq.Free;
end;}

procedure Tftsdiagjcl.arma_diagrama_Visio;
var
   sTipoBlock: String;
   sNombreFisicoBlock, sNombreLogicoBlock: String;
   iColumna, iRenglon: Integer;
   iColV, iRenV: Integer;
   iAncho: Integer;
   iAlto: Integer;
   sTexto: String;
   sClase: String;
   clColor: TColor;

   sBlockOrigen, sBlockDestino: String;
   sTipoBlockOrigen, sTipoBlockDestino: String;
   sTipoProceso: String;

begin
   GlbNuevoDiagrama( atDiagramJCL );

   with tabComponente do begin
      if not Active then begin
         Application.MessageBox(
            'No esta activa la opción para generar el Diagrama Visio',
            'Diagrama de Flujo', MB_OK );
         Exit;
      end;

      GlbBlockFlow( atDiagramJCL, 'TextBlock', 'SUBTITULO', 10, 15, 600, 20, clNone, clBlack, Titulo );

      //grafica las lineas
      First;
      while not Eof do begin
         sTipoBlock := UpperCase( FindField( 'TipoBlock' ).AsString );

         if sTipoBlock <> 'LINK' then begin
            sNombreFisicoBlock := FindField( 'NFisicoBlock' ).AsString;
            sNombreLogicoBlock := FindField( 'NLogicoBlock' ).AsString;
            iColumna := FindField( 'Columna' ).AsInteger;
            iRenglon := FindField( 'Renglon' ).AsInteger;
            sTexto := FindField( 'Texto' ).AsString;
            sClase := FindField( 'Clase' ).AsString;

           { if FindField( 'NLogicoBlock' ).DataSize > 30 then begin
               iAncho := 120;
               iAlto := 50;
               iRenglon:= iRenglon + 30;
               iColumna := iColumna + 40;
            end
            else begin   }
               iAncho := 90;
               iAlto := 40;
            //end;

            clColor := clNone;

            if sTipoBlock = 'FLOWTERMINALBLOCK' then begin
               clColor := 16764057;

               if FindField( 'RecID' ).AsInteger = 1 then
                  clColor := 16751052;

               if sNombreLogicoBlock = 'FIN_99' then
                  clColor := 16751052;
            end;

            if sTipoBlock = 'DFDPROCESSBLOCK' then
               clColor := 13434828;

            if ( sTipoBlock = 'DATABASEBLOCK' ) and ( sClase = 'FIL' ) then
               clColor := $87CEFA;

            if ( sTipoBlock = 'DATABASEBLOCK' ) and ( sClase <> 'FIL' ) then
               clColor := $DB7093;

            if sTipoBlock = 'FLOWDOCUMENTBLOCK' then
               clColor := $40E0D0;


            GlbBlockFlow( atDiagramJCL, sTipoBlock,
               sNombreFisicoBlock,   //no se debe repetir
               iColumna, iRenglon, iAncho, iAlto, clColor, clBlack,
               sTexto );

               
            If ( FindField( 'Renglon' ).AsInteger <> 0 ) then begin
               iRenV := Round( iRenglon / 10 ) + 1;
               iColV := Round( iColumna / 10 );
               iColV := Trunc( iColV / 10 ) + 1;
               dgryy.add( 'D' + ' ' + stringreplace( trim( sNombreLogicoBlock ), '_', '|', [ rfReplaceAll ] ) + ' ' + inttostr( iColV ) +
                  ' ' + inttostr( iRenV ) + ' ' + colortostring( clColor ) + ' ' + stringreplace( trim( sTexto ), ' ', '|', [ rfReplaceAll ] ) );
            end;
         end;
         Next;
      end;

      //grafica las lineas
      First;
      while not Eof do begin
         sTipoBlock := UpperCase( FindField( 'TipoBlock' ).AsString );

         if sTipoBlock = 'LINK' then begin
            sBlockOrigen := FindField( 'LigaBlockOrigen' ).AsString;
            sBlockDestino := FindField( 'LigaBlockDestino' ).AsString;
            sTipoBlockOrigen := UpperCase( FindField( 'TipoBlockOrigen' ).AsString );
            sTipoBlockDestino := UpperCase( FindField( 'TipoBlockDestino' ).AsString );
            sTipoProceso := UpperCase( FindField( 'Texto' ).AsString );

            if ( sBlockOrigen <> '' ) and ( sBlockDestino <> '' ) then begin
               if sTipoProceso = 'ENTRADA' then
                  GlbLinkPoints( atDiagramJCL, sBlockOrigen, sBlockDestino, 3, 2, asLineArrow, psSolid ) //fercar tipo linea
               else if sTipoProceso = 'SALIDA' then begin
                  if sTipoBlockDestino = 'FLOWDOCUMENTBLOCK' then
                     GlbLinkPoints( atDiagramJCL, sBlockOrigen, sBlockDestino, 3, 1, asLineArrow, psSolid ) //fercar tipo linea )
                  else
                     GlbLinkPoints( atDiagramJCL, sBlockOrigen, sBlockDestino, 3, 2, asLineArrow, psSolid ); //fercar tipo linea );
               end
               else
                  GlbLinkPoints( atDiagramJCL, sBlockOrigen, sBlockDestino, 1, 0, asLineArrow, psSolid ); //fercar tipo linea

               {if sTipoBlockDestino = 'FLOWDOCUMENTBLOCK' then
                  GlbLinkPoints( atDiagramJCL, sBlockOrigen, sBlockDestino, 3, 1 )
               else if sTipoBlockOrigen = 'DATABASEBLOCK' then
                  GlbLinkPoints( atDiagramJCL, sBlockOrigen, sBlockDestino, 3, 2 )
               else
                  GlbLinkPoints( atDiagramJCL, sBlockOrigen, sBlockDestino, 1, 0 );}
            end;
         end;

         Next;
      end;
   end;
end;

procedure Tftsdiagjcl.diagrama_jcl( programa: string; bib: string; clase: string; sistema: string );
var
   nomjpg, nomdot, nomtxt: string;
   archivo_lista: String; //usado para generar archivo excel - en su momento quitar
   misdocumentos,titulo,ejecuta_gv,salida: String;   //para diagrama grapviz    ALK
begin
   sistema_alk:=sistema;
   //caption := g_version_tit + '  -  Diagrama de Flujo  ' + clase + ' ' + bib + ' ' + programa;
   //caption := titulo;
   //imgview := Tftsimgview.Create( self );
   //imgview.Parent := self;
   dgryy := Tstringlist.create;
   tabMemData_jcl := tabComponente; //fercar diagramas jcl
   iNombre_jcl := 0; //fercar diagramas jcl
   bgral := clase + '|' + bib + '|' + programa;

   contenido_diagrama := TStringList.Create;    // inicializar el que va a contener los datos del diagrama para evitar repetidos

   inicia_jcl( programa, bib, clase, sistema );
   arma_diagrama( programa, bib, clase, sistema );
   corte;

   bGlbQuitaCaracteres( programa );
   nomdot := g_ruta + 'tmp\' + programa + '.dot';
   //nomjpg := g_ruta + 'tmp\' + programa + '.jpg';
   ///nomtxt := g_ruta + 'tmp\' + programa + '.txt';
   ///g_control := nomtxt;

   //usado para generar archivo excel - en su momento quitar
   {archivo_lista := stringreplace( programa, '/', '.', [ rfreplaceall ] );
   archivo_lista := stringreplace( archivo_lista, '*', 'x', [ rfreplaceall ] );
   archivo_lista := stringreplace( archivo_lista, '#', 'g', [ rfreplaceall ] );
   archivo_lista := stringreplace( archivo_lista, '?', 'i', [ rfreplaceall ] );
   archivo_lista := g_tmpdir + '\Diagrama de Flujo ' + clase + bib + archivo_lista;}

   archivo_lista := Clase + Bib + Programa;
   bGlbQuitaCaracteres( archivo_lista );
   archivo_lista := g_tmpdir + '\Diagrama de Flujo ' + archivo_lista;

   //fin usado para generar archivo ...

   termina_jcl( nomdot );

   // ------------------  Graphviz ------------------------------
   {dm.ejecuta_espera('"' + dm.get_variable( 'PROGRAMFILES' ) + '\' + g_graphviz + '\bin\dot.exe" ' +
      ' -Tjpg -o' + nomjpg + ' ' + nomdot, SW_HIDE );
   img.Picture.LoadFromFile( nomjpg );
   imgview.img.Picture.LoadFromFile( nomjpg );
   imgview.Top := 0;
   imgview.left := 0;
   g_borrar.Add( nomjpg );      }

   //      ______   ALK   ______

   {if indica_doc_a <> 1 then begin            //si no viene de documentacion
      misdocumentos := GlbObtenerRutaMisDocumentos;
      misdocumentos := misdocumentos + '\Informes';    //carpeta que contiene los diagramad
      titulo:= clase + '_' + bib + '_' + programa;
      bGlbQuitaCaracteres( titulo );
      titulo:=titulo + '.pdf';
      salida:=misdocumentos + '\'+ titulo;     //archivo de salida

      ejecuta_gv:= 'dot.exe -Tpdf -o"' + salida + '" ' + nomdot;

      if dm.ejecuta_espera( ejecuta_gv, SW_HIDE ) then
         ShellExecute( 0, 'open', pchar( titulo ), nil, PChar( misdocumentos ), SW_SHOW )
      else
         Application.MessageBox( PChar( 'No se pudo generar diagrama de flujo' ),
                     PChar( 'Graphviz (DgrFlujo)' ), MB_ICONEXCLAMATION );
   end;        }
   // -----------------------------------------------------------


   g_borrar.Add( nomdot );

   arma_diagrama_Visio; //arma diagrama jcl

   mnuVerReglaIzquierda.ImageIndex := 39;
   mnuVerReglaSuperior.ImageIndex := 39;
   mnuVerCuadricula.ImageIndex := 39;

   atDiagramJCL.ClearUndoStack;

   ///dgryy.SaveToFile( nomtxt );
   ///g_borrar.Add( nomtxt );
   dgryy.SaveToFile( archivo_lista );
   g_borrar.Add( archivo_lista );
   g_control := stringreplace( archivo_lista, g_tmpdir + '\Diagrama de Flujo ', '', [ rfreplaceall ] );

   dgryy.Free;
   contenido_diagrama.Free;
end;

procedure Tftsdiagjcl.Aumentar1Click( Sender: TObject );
begin
   //imgview.Show;
end;

procedure Tftsdiagjcl.Guardarcomo1Click( Sender: TObject );
begin
   if savepicturedialog1.Execute = false then
      exit;
   img.Picture.SaveToFile( savepicturedialog1.FileName );
   g_borrar.add( savepicturedialog1.FileName );
end;

procedure Tftsdiagjcl.FormClose( Sender: TObject; var Action: TCloseAction );
begin
   //dm.PubEliminarVentanaActiva(Caption);  //quitar nombre de lista de abiertos
   {gral.borra_elemento(Caption,11);     //borrar elemento del arreglo de productos
   farbol.borra_elemento_a(Caption,11);     //borrar elemento del arreglo de productos
   }
   if FormStyle = fsMDIChild then
      Action := caFree;
end;

procedure Tftsdiagjcl.FormDestroy( Sender: TObject );
begin
   if FormStyle = fsMDIChild then
      dm.PubEliminarVentanaActiva( Caption );

   if gral.iPubVentanasActivas in [ 0, 1 ] then
      gral.PubExpandeMenuVentanas( False );

   //slPubJCL.Free;
   if PriDiagramAlign <> nil then begin
      slPriBuscar.Free;
      PriDiagramAlign.Free;
   end;
end;

procedure Tftsdiagjcl.FormCreate( Sender: TObject );
begin
   mnuPrincipal.Style := gral.iPubEstiloActivo;

   if gral.iPubVentanasActivas > 0 then
      gral.PubExpandeMenuVentanas( True );

   //Barra edicion
   PriMostrarBarraEdicion( False );
   //Barra Busqueda
   mnuPrincipal.Bars[ 2 ].Visible := False;
   //Barra Alineacion
   mnuPrincipal.Bars[ 3 ].Visible := False;

   inicializa_doc;    //alk
end;

procedure Tftsdiagjcl.inicializa_doc;   // para hacer la inicializacion que se hace desde formcreate   alk
begin
   iPriAntSigBuscar := 0;
   slPriBuscar := Tstringlist.Create;
   PriDiagramAlign := TDiagramAlign.Create( Self );
   if atDiagramJCL = nil then begin
      atDiagramJCL:= TatDiagram.Create(TabSheet2);
      atDiagramJCL.Parent:=TabSheet2;
      atDiagramJCL.Align:=alClient;
   end;
   PriDiagramAlign.Diagram := atDiagramJCL;
end;

procedure Tftsdiagjcl.limpia_memdata;    //para limpiar el registro de los bloques   ALK
var
   z : integer;
begin
   tabComponente.Active:=false;
   {for z:=0 to tabComponente.ComponentCount -1 do
      tabComponente.Components[z].Free;}
end;

procedure Tftsdiagjcl.FormActivate( Sender: TObject );
var
   l_control: string;
begin
   g_producto := 'MENÚ CONTEXTUAL-DIAGRAMA DE FLUJO JCL';
   l_control := stringreplace( caption, 'Diagrama de Flujo ', '', [ rfreplaceall ] );
   g_control := stringreplace( l_control, ' ', '|', [ rfreplaceall ] );

   if g_clase = 'JCL' then
      iHelpContext := IDH_TOPIC_T02904
   else
      iHelpContext := IDH_TOPIC_T02905;
end;

procedure Tftsdiagjcl.mnuGuardarClick( Sender: TObject );
var
   nombre: string;
begin
   with SaveDialog do begin
      DefaultExt := '.dgr';
      Filter := 'Diagramas (*.dgr)|*.dgr';
   end;

   nombre := stringreplace( trim( caption ), 'Diagrama de Flujo ', '', [ rfReplaceAll ] );
   nombre := stringreplace( trim( nombre ), ' ', '_', [ rfReplaceAll ] );
   saveDialog.FileName := nombre;
   if SaveDialog.Execute then
      atDiagramJCL.SaveToFile( SaveDialog.FileName );
end;

procedure Tftsdiagjcl.mnuImprimirClick( Sender: TObject );
begin
   atDiagramJCL.Print( True );
end;

procedure Tftsdiagjcl.mnuVistaPreliminarClick( Sender: TObject );
begin
   atDiagramJCL.Preview;
end;

procedure Tftsdiagjcl.mnuPaginaConfClick( Sender: TObject );
begin
   atDiagramJCL.PageSetupDlg;
end;

procedure Tftsdiagjcl.mnuDeshacerClick( Sender: TObject );
var
   sNextRedo: String;
begin
   atDiagramJCL.Undo;

   sNextRedo := atDiagramJCL.NextRedoAction;
   mnuRehacer.Enabled := sNextRedo <> '';
end;

procedure Tftsdiagjcl.mnuRehacerClick( Sender: TObject );
var
   sNextUndo: String;
begin
   atDiagramJCL.Redo;

   sNextUndo := atDiagramJCL.NextUndoAction;
   mnuDeshacer.Enabled := sNextUndo <> '';
end;

procedure Tftsdiagjcl.mnuZoomChange( Sender: TObject );
var
   sZoom: String;
begin
   if Trim( mnuZoom.Text ) = '' then
      Exit;

   sZoom := StringReplace( mnuZoom.Text, '%', '', [ ] );

   atDiagramJCL.Zoom := StrToInt( sZoom );
end;

procedure Tftsdiagjcl.mnuVerReglaIzquierdaClick( Sender: TObject );
begin
   if atDiagramJCL.LeftRuler.Visible = True then begin
      atDiagramJCL.LeftRuler.Visible := False;
      mnuVerReglaIzquierda.ImageIndex := -1;
   end
   else begin
      atDiagramJCL.LeftRuler.Visible := True;
      mnuVerReglaIzquierda.ImageIndex := 39;
   end;
end;

procedure Tftsdiagjcl.mnuVerReglaSuperiorClick( Sender: TObject );
begin
   if atDiagramJCL.TopRuler.Visible = True then begin
      atDiagramJCL.TopRuler.Visible := False;
      mnuVerReglaSuperior.ImageIndex := -1;
   end
   else begin
      atDiagramJCL.TopRuler.Visible := True;
      mnuVerReglaSuperior.ImageIndex := 39;
   end;
end;

procedure Tftsdiagjcl.mnuVerCuadriculaClick( Sender: TObject );
begin
   if atDiagramJCL.SnapGrid.Visible = True then begin
      atDiagramJCL.SnapGrid.Visible := False;
      mnuVerCuadricula.ImageIndex := -1;
   end
   else begin
      atDiagramJCL.SnapGrid.Visible := True;
      mnuVerCuadricula.ImageIndex := 39;
   end;
end;

procedure Tftsdiagjcl.mnuBoldClick( Sender: TObject );
var
   i: Integer;
   dcControl: TDiagramControl;
begin
   for i := 0 to atDiagramJCL.SelectedCount( ) - 1 do begin
      dcControl := atDiagramJCL.Selecteds[ i ];

      if fsBold in dcControl.Font.Style then
         dcControl.Font.Style := dcControl.Font.Style - [ fsBold ]
      else
         dcControl.Font.Style := dcControl.Font.Style + [ fsBold ];
   end;
end;

procedure Tftsdiagjcl.mnuItalicClick( Sender: TObject );
var
   i: Integer;
   dcControl: TDiagramControl;
begin
   for i := 0 to atDiagramJCL.SelectedCount( ) - 1 do begin
      dcControl := atDiagramJCL.Selecteds[ i ];

      if fsItalic in dcControl.Font.Style then
         dcControl.Font.Style := dcControl.Font.Style - [ fsItalic ]
      else
         dcControl.Font.Style := dcControl.Font.Style + [ fsItalic ];
   end;
end;

procedure Tftsdiagjcl.mnuUnderlineClick( Sender: TObject );
var
   i: Integer;
   dcControl: TDiagramControl;
begin
   for i := 0 to atDiagramJCL.SelectedCount( ) - 1 do begin
      dcControl := atDiagramJCL.Selecteds[ i ];

      if fsUnderline in dcControl.Font.Style then
         dcControl.Font.Style := dcControl.Font.Style - [ fsUnderline ]
      else
         dcControl.Font.Style := dcControl.Font.Style + [ fsUnderline ];
   end;
end;

procedure Tftsdiagjcl.mnuStrikeOutClick( Sender: TObject );
var
   i: Integer;
   dcControl: TDiagramControl;
begin
   for i := 0 to atDiagramJCL.SelectedCount( ) - 1 do begin
      dcControl := atDiagramJCL.Selecteds[ i ];

      if fsStrikeOut in dcControl.Font.Style then
         dcControl.Font.Style := dcControl.Font.Style - [ fsStrikeOut ]
      else
         dcControl.Font.Style := dcControl.Font.Style + [ fsStrikeOut ];
   end;
end;

procedure Tftsdiagjcl.mnuNodosAutomaticosClick( Sender: TObject );
begin
   if atDiagramJCL.AutomaticNodes = True then begin
      atDiagramJCL.AutomaticNodes := False;
      mnuNodosAutomaticos.ImageIndex := -1;
   end
   else begin
      atDiagramJCL.AutomaticNodes := True;
      mnuNodosAutomaticos.ImageIndex := 39;
   end;
end;

procedure Tftsdiagjcl.mnuConsultaClick( Sender: TObject );
begin
   //imgview.Show;
end;

procedure Tftsdiagjcl.mnuGuardarPictureClick( Sender: TObject );
begin
   if savepicturedialog1.Execute = false then
      exit;

   img.Picture.SaveToFile( savepicturedialog1.FileName );
   g_borrar.add( savepicturedialog1.FileName );
end;

procedure Tftsdiagjcl.mnuExportarExcelClick( Sender: TObject );
begin
   gral.exportaJCL( sender );
   //tabComponente.DelimiterChar := '|';
   //tabComponente.SaveToTextFile( 'c:\dfd2.txt' );
end;

procedure Tftsdiagjcl.atDiagramJCLDControlDblClick( Sender: TObject;
   ADControl: TDiagramControl );
var
   y, z, x: Integer;
   sNombre: String;
   slGpoCmp, slGpo2Cmp, slGpo3Cmp: Tstringlist;
   obtiene_datos : TStringList;
   cons, prog, bib, cla :string;
   indica: integer;                 // 0 trae datos,  1 datos tomados del nombre, 2 no contiene datos(no enviar)
begin
   screen.Cursor := crsqlwait;
   slGpoCmp := Tstringlist.create;
   slGpo2Cmp := Tstringlist.create;
   slGpo3Cmp := Tstringlist.create;
   obtiene_datos := TStringList.create;

   indica:=0;    // 0 para dar por hecho que trae datos
   try
      if tabComponente.Locate( 'NFisicoBlock', ADControl.Name, [ ] ) then begin
         sNombre := tabComponente.FindField( 'NLogicoBlock' ).AsString;
         slGpoCmp.CommaText := tabComponente.FindField( 'Texto' ).AsString;

         //ALK si no tiene nombre, clase o biblioteca, tomarlo del nombre (si lo contiene _ )
         if (tabComponente.FindField( 'Programa' ).AsString = '') or
            (tabComponente.FindField( 'Biblioteca' ).AsString = '') or
            (tabComponente.FindField( 'Clase' ).AsString = '') then begin
            indica:=2;   // no contiene los datos, no enviar a la funcion de opciones
            obtiene_datos.Delimiter:='_';
            obtiene_datos.DelimitedText:=tabComponente.FindField( 'Texto' ).AsString;
            if obtiene_datos.Count >2 then begin
               prog := obtiene_datos[2];
               bib := obtiene_datos[1];
               cla := obtiene_datos[0];
               indica:=1;  // contiene los datos tomados del nombre
            end;
         end;
         //____________________________________________________________________________________

         if ( tabComponente.FindField( 'Clase' ).AsString = 'CBL' ) or
            ( tabComponente.FindField( 'Clase' ).AsString = 'REP' ) then begin
            if slGpoCmp.Count > 1 then begin
               {   slGpo3Cmp.Clear;
                  for z := 0 to slGpoCmp.Count - 1 do begin

                     slGpo2Cmp.CommaText := slGpoCmp[ z ];

                     for x := 0 to slGpo2Cmp.count - 1 do begin
                        if tabComponente.FindField( 'Clase' ).AsString = 'REP' then begin
                           slGpo3Cmp.Add( 'REP' + '|' + 'SPOOL' + '|' + slGpo2Cmp[ x ] );
                        end
                        else begin
                           slGpo3Cmp.Add( stringreplace( slGpo2Cmp[ x ], '_', '|', [ rfReplaceAll ] ) );
                        end;
                     end;

                  end;

                  Opciones := gral.ArmarMenuGpoCompWeb( slGpo3Cmp, 'diagramajcl' );
                  y := ArmarOpcionesGpoComp( Opciones );
                  gral.PopGral00.Popup( g_X, g_Y );
               }
            end
            else begin
               if tabComponente.FindField( 'Clase' ).AsString = 'REP' then begin
                  slGpo2Cmp.CommaText := slGpoCmp[ 0 ];
                  bgral := slGpo2Cmp[ 0 ] + '|' + 'SPOOL' + '|' + 'REP' + '|' + sistema_alk;
               end
               else begin
                  if indica=0 then
                     bgral := tabComponente.FindField( 'Programa' ).AsString + '|' +
                        tabComponente.FindField( 'Biblioteca' ).AsString + '|' +
                        tabComponente.FindField( 'Clase' ).AsString + '|' +
                        sistema_alk   //obtener sistema de consulta
                        //tabComponente.FindField( 'Sistema' ).AsString;          // le agrego el sistema para que funcione en los productos ALK
                  else
                     if indica=1 then
                        bgral:=prog + '|' + bib + '|' + cla + '|' + sistema_alk;
               end;
               Opciones := gral.ArmarMenuConceptualWeb( bgral, 'diagramajcl' );
               y := ArmarOpciones( Opciones );
               gral.PopGral.Popup( g_X, g_Y );

            end;
         end
         else begin
            if indica=0 then
               bgral := tabComponente.FindField( 'Programa' ).AsString + '|' +
                  tabComponente.FindField( 'Biblioteca' ).AsString + '|' +
                  tabComponente.FindField( 'Clase' ).AsString + '|' +
                  sistema_alk   //obtener sistema de consulta
                  //tabComponente.FindField( 'Sistema' ).AsString;          // le agrego el sistema para que funcione en los productos ALK
            else
               if indica=1 then
                  bgral:=prog + '|' + bib + '|' + cla + '|' + sistema_alk;

            if (prog <> 'PROCESO') and (bib <> 'DE') and (cla <> 'FIN') then begin  //para comprobar que no es el bloque de fin de proceso
               if indica < 4 then begin    // si contiene datos para llenar menu
                  Opciones := gral.ArmarMenuConceptualWeb( bgral, 'diagramajcl' );
                  y := ArmarOpciones( Opciones );
                  gral.PopGral.Popup( g_X, g_Y );
               end;
            end;

         end;
      end;
   finally
      screen.Cursor := crdefault;
      obtiene_datos.Free;
   end;
   slGpo3Cmp.Free;
   slGpo2Cmp.Free;
   slGpoCmp.Free;

end;

function Tftsdiagjcl.ArmarOpciones( b1: Tstringlist ): integer;
begin
   gral.EjecutaOpcionB( b1, 'Diagrama de Flujo' );
end;

function Tftsdiagjcl.ArmarOpcionesGpoComp( b1: Tstringlist ): integer;
begin
   gral.EjecutaOpcionGpoComp( b1, 'Diagrama de Flujo' );
end;

procedure Tftsdiagjcl.mnuBuscarClick( Sender: TObject );
begin
   if not mnuPrincipal.Bars[ 2 ].Visible then begin
      mnuPrincipal.Bars[ 2 ].Visible := True;
      mnuBarraBusqueda.ImageIndex := 39;
   end;

   mnuTextoBuscar.SetFocus( True );
end;

procedure Tftsdiagjcl.mnuBuscarAnteriorClick( Sender: TObject );
var
   sNombreFisico: String;
   slNFisicoBlock: TStringList;
   dcControl: TDiagramControl;
begin
   if slPriBuscar.Count = 0 then
      Exit;

   slNFisicoBlock := Tstringlist.Create;
   try
      if iPriAntSigBuscar > 0 then
         iPriAntSigBuscar := iPriAntSigBuscar - 1;

      slNFisicoBlock.CommaText := slPriBuscar[ iPriAntSigBuscar ];
      sNombreFisico := slNFisicoBlock[ 0 ];

      if atDiagramJCL.Zoom <> 100 then
         if mnuZoom.ItemIndex = 3 then
            mnuZoomChange( Sender )
         else
            mnuZoom.ItemIndex := 3;

      atDiagramJCL.UnselectAll;
      dcControl := atDiagramJCL.FindDControl( sNombreFisico );
      dcControl.Selected := True;

      atDiagramJCL.HorzScrollBar.Position := StrToInt( slNFisicoBlock[ 4 ] ) - 20;
      atDiagramJCL.VertScrollBar.Position := StrToInt( slNFisicoBlock[ 5 ] ) - 20;
   finally
      slNFisicoBlock.Free;
   end;

end;

procedure Tftsdiagjcl.mnuBuscarSiguienteClick( Sender: TObject );
var
   sNombreFisico: String;
   slNFisicoBlock: TStringList;
   dcControl: TDiagramControl;
begin
   if slPriBuscar.Count = 0 then
      Exit;

   slNFisicoBlock := Tstringlist.Create;
   try
      if iPriAntSigBuscar < slPriBuscar.Count - 1 then
         inc( iPriAntSigBuscar );

      slNFisicoBlock.CommaText := slPriBuscar[ iPriAntSigBuscar ];
      sNombreFisico := slNFisicoBlock[ 0 ];

      if atDiagramJCL.Zoom <> 100 then
         if mnuZoom.ItemIndex = 3 then
            mnuZoomChange( Sender )
         else
            mnuZoom.ItemIndex := 3;

      atDiagramJCL.UnselectAll;
      dcControl := atDiagramJCL.FindDControl( sNombreFisico );
      dcControl.Selected := True;

      atDiagramJCL.HorzScrollBar.Position := StrToInt( slNFisicoBlock[ 4 ] ) - 20;
      atDiagramJCL.VertScrollBar.Position := StrToInt( slNFisicoBlock[ 5 ] ) - 20;
   finally
      slNFisicoBlock.Free;
   end;
end;

procedure Tftsdiagjcl.mnuTextoBuscarExit( Sender: TObject );
var
   i: Integer;
   sNombreFisico: String;
   slNFisicoBlock: TStringList;
   dcControl: TDiagramControl;
   sCadena: String;
begin
   if Trim( mnuTextoBuscar.Text ) = '' then
      Exit;

   Screen.Cursor := crSqlWait;
   try
      if UpperCase( sPriTextoBuscar ) <> UpperCase( mnuTextoBuscar.Text ) then begin
         sPriTextoBuscar := mnuTextoBuscar.Text;
         slPriBuscar.Clear;
         iPriAntSigBuscar := 0;

         with tabComponente do begin
            First;
            while not Eof do begin
               if UpperCase( FindField( 'TipoBlock' ).AsString ) <> 'LINK' then begin
                  sCadena := UpperCase( FindField( 'Programa' ).AsString + ' ' +
                     FindField( 'Biblioteca' ).AsString + ' ' +
                     FindField( 'Clase' ).AsString + ' ' +
                     FindField( 'Texto' ).AsString );

                  if pos( UpperCase( mnuTextoBuscar.Text ), sCadena ) > 0 then
                     slPriBuscar.Add(
                        FindField( 'NFisicoBlock' ).AsString + ',' +
                        FindField( 'Programa' ).AsString + ',' +
                        FindField( 'Biblioteca' ).AsString + ',' +
                        FindField( 'Clase' ).AsString + ',' +
                        FindField( 'Columna' ).AsString + ',' +
                        FindField( 'Renglon' ).AsString + ',' +
                        FindField( 'Texto' ).AsString );
               end;

               Next;
            end;
         end;

         if slPriBuscar.Count > 0 then begin
            slNFisicoBlock := Tstringlist.Create;
            try
               slNFisicoBlock.CommaText := slPriBuscar[ iPriAntSigBuscar ];
               sNombreFisico := slNFisicoBlock[ 0 ];

               if atDiagramJCL.Zoom <> 100 then
                  if mnuZoom.ItemIndex = 3 then
                     mnuZoomChange( Sender )
                  else
                     mnuZoom.ItemIndex := 3;

               atDiagramJCL.UnselectAll;
               dcControl := atDiagramJCL.FindDControl( sNombreFisico );
               dcControl.Selected := True;

               atDiagramJCL.HorzScrollBar.Position := StrToInt( slNFisicoBlock[ 4 ] ) - 20;
               atDiagramJCL.VertScrollBar.Position := StrToInt( slNFisicoBlock[ 5 ] ) - 20;
            finally
               slNFisicoBlock.Free;
            end;
         end;
      end;
   finally
      Screen.Cursor := crDefault;
      mnuBuscarAnterior.Enabled := True;
      mnuBuscarSiguiente.Enabled := True;
   end;
end;

procedure Tftsdiagjcl.FormKeyDown( Sender: TObject; var Key: Word;
   Shift: TShiftState );
var
   sNombreFisico: String;
   slNFisicoBlock: TStringList;
   dcControl: TDiagramControl;
begin
   if ( ssCtrl in Shift ) and ( Key = VK_HOME ) then begin
      Screen.Cursor := crSqlWait;
      try
         if atDiagramJCL.Zoom <> 100 then
            if mnuZoom.ItemIndex = 3 then
               mnuZoomChange( Sender )
            else
               mnuZoom.ItemIndex := 3;

         atDiagramJCL.UnselectAll;
         dcControl := atDiagramJCL.FindDControl( 'SUBTITULO' );
         dcControl.Selected := True;

         atDiagramJCL.HorzScrollBar.Position := 1;
         atDiagramJCL.VertScrollBar.Position := 1;

         iPriAntSigBuscar := -1;
      finally
         Screen.Cursor := crDefault;
      end;
   end;

   if ( ssCtrl in Shift ) and ( Key = VK_END ) then begin
      slNFisicoBlock := Tstringlist.Create;
      Screen.Cursor := crSqlWait;
      try
         //slNFisicoBlock.CommaText := slPubJCL[ slPubJCL.count - 1 ];
         //sNombreFisico := slNFisicoBlock[ 0 ];

         if tabComponente.Locate( 'NLogicoBlock', 'FIN_99', [ ] ) then begin
            sNombreFisico := tabComponente.FindField( 'NFisicoBlock' ).AsString;

            if atDiagramJCL.Zoom <> 100 then
               if mnuZoom.ItemIndex = 3 then
                  mnuZoomChange( Sender )
               else
                  mnuZoom.ItemIndex := 3;

            atDiagramJCL.UnselectAll;
            dcControl := atDiagramJCL.FindDControl( sNombreFisico );
            dcControl.Selected := True;

            atDiagramJCL.HorzScrollBar.Position := tabComponente.FindField( 'Columna' ).AsInteger - 20;
            atDiagramJCL.VertScrollBar.Position := tabComponente.FindField( 'Renglon' ).AsInteger - 20;

            iPriAntSigBuscar := slPriBuscar.Count - 1;
         end;
      finally
         Screen.Cursor := crDefault;
         slNFisicoBlock.Free;
      end;
   end;
end;

procedure Tftsdiagjcl.atDiagramJCLSelectDControl( Sender: TObject;
   ADControl: TDiagramControl );
begin
   GlbNoSelecLink( atDiagramJCL, ADControl );
end;

procedure Tftsdiagjcl.mnuExportarWMFClick( Sender: TObject );

   function ObtenerMisDocumentos: String;
   var
      bLongBool: Bool;
      sPath: array[ 0..Max_Path ] of Char;
   begin
      bLongBool := ShGetSpecialFolderPath( 0, sPath, CSIDL_Personal, False );

      if not bLongBool then
         Result := 'C:'
      else
         Result := sPath;
   end;

var
   sNombreArchivo: String;
   sRutaMisDocumentos: String;

begin
   sNombreArchivo := Caption + '.wmf';
   sRutaMisDocumentos := ObtenerMisDocumentos;

   with SaveDialog do begin
      InitialDir := sRutaMisDocumentos; //g_tmpdir;
      DefaultExt := '.wmf';
      FileName := sNombreArchivo;
      Filter := 'Formato de imagen WMF(*.wmf)|*.wmf';

      if Execute then
         GlbExportarDgr_A_WMF( atDiagramJCL, FileName );
   end;
end;

procedure Tftsdiagjcl.atDiagramJCLMouseUp( Sender: TObject;
   Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
var
   i: Integer;
   sClassName: String;
   dcControl: TDiagramControl;
begin
   if atDiagramJCL.SelectedLinkCount <> 1 then
      Exit;

   dcControl := atDiagramJCL.Selecteds[ 0 ];
   sClassName := UpperCase( dcControl.ClassName );

   if sClassName = 'TDIAGRAMSIDELINE' then
      with ( dcControl as TDiagramSideLine ) do
         if ( SourceLinkPoint.AnchorIndex < 0 ) or
            ( TargetLinkPoint.AnchorIndex < 0 ) then
            atDiagramJCL.Undo;

   if sClassName = 'TDIAGRAMLINE' then
      with ( dcControl as TDiagramLine ) do
         if ( SourceLinkPoint.AnchorIndex < 0 ) or
            ( TargetLinkPoint.AnchorIndex < 0 ) then
            atDiagramJCL.Undo;
end;

procedure Tftsdiagjcl.mnuSalirClick( Sender: TObject );
begin
   Close;
end;

procedure Tftsdiagjcl.mnuCopyImgClick( Sender: TObject );
begin
   atDiagramJCL.CopyBitmapToClipboard;
end;

procedure Tftsdiagjcl.mnuSeleccionarTodoClick( Sender: TObject );
var
   i: Integer;
   iTotalLink: Integer;
begin
   atDiagramJCL.SelectAll;

   //Quita la seleccion de lineas
   iTotalLink := atDiagramJCL.LinkCount;

   if iTotalLink = 0 then
      Exit;

   for i := 0 to iTotalLink - 1 do
      atDiagramJCL.Links[ i ].Selected := False;
end;

procedure Tftsdiagjcl.mnuBarraEdicionClick( Sender: TObject );
begin
   if mnuPrincipal.Bars[ 1 ].Visible then
      PriMostrarBarraEdicion( False )
   else
      PriMostrarBarraEdicion( True );
end;

procedure Tftsdiagjcl.mnuBarraBusquedaClick( Sender: TObject );
begin
   if mnuPrincipal.Bars[ 2 ].Visible then begin
      mnuPrincipal.Bars[ 2 ].Visible := False;
      mnuBarraBusqueda.ImageIndex := -1;
   end
   else begin
      mnuPrincipal.Bars[ 2 ].Visible := True;
      mnuBarraBusqueda.ImageIndex := 39;
      mnuTextoBuscar.SetFocus( True );
   end;
end;

procedure Tftsdiagjcl.mnuBarraAlineacionClick( Sender: TObject );
begin
   if mnuPrincipal.Bars[ 3 ].Visible then begin
      mnuPrincipal.Bars[ 3 ].Visible := False;
      mnuBarraAlineacion.ImageIndex := -1;
   end
   else begin
      mnuPrincipal.Bars[ 3 ].Visible := True;
      mnuBarraAlineacion.ImageIndex := 39;
   end;
end;

procedure Tftsdiagjcl.PriMostrarBarraEdicion( bParMostrar: Boolean );
begin
   mnuPrincipal.Bars[ 1 ].Visible := bParMostrar;

   if bParMostrar then
      mnuBarraEdicion.ImageIndex := 39
   else
      mnuBarraEdicion.ImageIndex := -1;

   DgrColorSelector.Visible := bParMostrar;
   DgrGradientDirectionSelector.Visible := bParMostrar;
   DgrBrushStyleSelector.Visible := bParMostrar;
   DgrShadowSelector.Visible := bParMostrar;
   DgrPenStyleSelector.Visible := bParMostrar;
   DgrPenColorSelector.Visible := bParMostrar;
   DgrTransparencySelector.Visible := bParMostrar;
   DgrPenWidthSelector.Visible := bParMostrar;
   DgrTextColorSelector.Visible := bParMostrar;
   DgrFontSelector.Visible := bParMostrar;
   DgrFontSizeSelector.Visible := bParMostrar;
end;

procedure Tftsdiagjcl.PriAlinear( ParAlineacion: TBlocksAlignment );
begin
   with PriDiagramAlign do begin
      BlockAlignment := ParAlineacion;
      Execute;
   end;
end;

procedure Tftsdiagjcl.mnuAlinearBordesIzquierdoClick( Sender: TObject );
begin
   PriAlinear( baLeft );
end;

procedure Tftsdiagjcl.mnuAlinearBordesDerechosClick( Sender: TObject );
begin
   PriAlinear( baRight );
end;

procedure Tftsdiagjcl.mnuAlinearCentrosHorizontalesClick( Sender: TObject );
begin
   PriAlinear( baHorzCenter );
end;

procedure Tftsdiagjcl.mnuAlinearBordesSuperioresClick( Sender: TObject );
begin
   PriAlinear( baTop );
end;

procedure Tftsdiagjcl.mnuAlinearBordesInferioresClick( Sender: TObject );
begin
   PriAlinear( baBottom );
end;

procedure Tftsdiagjcl.mnuAlinearCentrosVerticalesClick( Sender: TObject );
begin
   PriAlinear( baVertCenter );
end;

procedure Tftsdiagjcl.mnuHacerMismoAnchoClick( Sender: TObject );
begin
   PriAlinear( baSameWidth );
end;

procedure Tftsdiagjcl.mnuHacerMismaAlturaClick( Sender: TObject );
begin
   PriAlinear( baSameHeight );
end;

procedure Tftsdiagjcl.mnuHacerMismoTamanoClick( Sender: TObject );
begin
   PriAlinear( baSameSize );
end;

procedure Tftsdiagjcl.mnuEspacioIgualHorizontalClick( Sender: TObject );
begin
   PriAlinear( baSameSpaceHorz );
end;

procedure Tftsdiagjcl.mnuIncrementarEspacioHorizontalClick(
   Sender: TObject );
begin
   PriAlinear( baIncHorzSpace );
end;

procedure Tftsdiagjcl.mnuDisminuirEspacioHorizontalClick( Sender: TObject );
begin
   PriAlinear( baDecHorzSpace );
end;

procedure Tftsdiagjcl.mnuEspacioIgualVerticalClick( Sender: TObject );
begin
   PriAlinear( baSameSpaceVert );
end;

procedure Tftsdiagjcl.mnuIncrementarEspacioVerticalClick( Sender: TObject );
begin
   PriAlinear( baIncrVertSpace );
end;

procedure Tftsdiagjcl.mnuDisminuirEspacioVerticalClick( Sender: TObject );
begin
   PriAlinear( baDecVertSpace );
end;

procedure Tftsdiagjcl.mnuCopiarBusquedaClick( Sender: TObject );
var
   i: Integer;
   dcControl: TDiagramControl;
   sCadena: String;
begin
   if atDiagramJCL.SelectedCount( ) < 1 then begin
      Application.MessageBox( 'Seleccione un Block.', 'Aviso', MB_OK );
      Exit;
   end;

   if atDiagramJCL.SelectedCount( ) > 1 then begin
      Application.MessageBox( 'Para esta acción NO debe seleccionar más de un Block.', 'Aviso', MB_OK );
      Exit;
   end;

   for i := 0 to atDiagramJCL.SelectedCount( ) - 1 do
      dcControl := atDiagramJCL.Selecteds[ i ];

   Clipboard.AsText := dcControl.TextCells.Items[ 0 ].Text;
   sCadena := Clipboard.AsText;

   mnuTextoBuscar.Text := Trim( sCadena );
end;

procedure Tftsdiagjcl.mnuTextoBuscarEnter(Sender: TObject);
begin
   mnuBuscarAnterior.Enabled := False;
   mnuBuscarSiguiente.Enabled := False;
end;

procedure Tftsdiagjcl.dxBarButton1Click(Sender: TObject);
   function ObtenerMisDocumentos: String;
   var
      bLongBool: Bool;
      sPath: array[ 0..Max_Path ] of Char;
   begin
      bLongBool := ShGetSpecialFolderPath( 0, sPath, CSIDL_Personal, False );

      if not bLongBool then
         Result := 'C:'
      else
         Result := sPath;
   end;
var
   sNombreArchivo: String;
   sRutaMisDocumentos: String;
   nomWMF,nomPDF:String;
begin
   nomWMF:= g_tmpdir+'\'+Caption + '.wmf';

   sNombreArchivo := Caption + '.pdf';
   sRutaMisDocumentos := ObtenerMisDocumentos;

   with SaveDialog do begin
      InitialDir := sRutaMisDocumentos; //g_tmpdir;
      DefaultExt := '.pdf';
      FileName := sNombreArchivo;
      Filter := 'PDF(*.pdf)';

      if Execute then
         GlbExportarDgr_A_WMF( atDiagramJCL, nomWMF );
         //GlbExportarDgr_A_PDF( nomWMF,FileName);
         dm.ExportAsPdf( nomWMF,FileName);
   end;
end;

end.

