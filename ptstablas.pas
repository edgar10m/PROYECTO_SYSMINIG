unit ptstablas;

interface                                                           

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
   ExtCtrls, ComCtrls, Buttons, strutils, shellapi, Menus, ADOdb, OleCtrls, SHDocVw, ExcelXP,
   ComObj, OleServer, ImgList, dxBar, HTML_HELP, Excel97 ;

type
   Tftstablas = class( TForm )
      lv: TListView;
      Panel1: TPanel;
      SaveDialog1: TSaveDialog;
      Splitter1: TSplitter;
      lvindice: TListView;
      Splitter2: TSplitter;
      cmbtabla: TEdit;
      lbltotal: TLabel;
      bmas: TButton;
      PopupMenu1: TPopupMenu;
      Editarcopia1: TMenuItem;
      textorich: TRichEdit;
      texto: TMemo;
      web: TWebBrowser;
      ExcelApplication1: TExcelApplication;
      StaticText1: TStaticText;
    mnuPrincipal: TdxBarManager;
    mnuImprimir: TdxBarButton;
    mnuExportar: TdxBarButton;
      procedure bexportarClick( Sender: TObject );
      procedure FormCreate( Sender: TObject );
      procedure bsalirClick( Sender: TObject );
      procedure lvClick( Sender: TObject );
      procedure lvindiceClick( Sender: TObject );
      procedure textoDblClick( Sender: TObject );
      procedure textoClick( Sender: TObject );
      procedure cmbtablaKeyPress( Sender: TObject; var Key: Char );
      procedure cmbtablaExit( Sender: TObject );
      procedure cmbtablaClick( Sender: TObject );
      procedure bmasClick( Sender: TObject );
      procedure creaweb( );
      procedure crea_web( );
      procedure webBeforeNavigate2( Sender: TObject; const pDisp: IDispatch;
         var URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
         var Cancel: WordBool );
      procedure webDocumentComplete( Sender: TObject; const pDisp: IDispatch;
         var URL: OleVariant );
      procedure ImpWebClick( Sender: TObject );
      procedure WebPreviewPrint( web: TWebBrowser );
      procedure FormClose( Sender: TObject; var Action: TCloseAction );
    procedure FormDestroy(Sender: TObject);
    procedure webProgressChange(Sender: TObject; Progress,
      ProgressMax: Integer);
    procedure mnuImprimirClick(Sender: TObject);
    procedure mnuExportarClick(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormActivate(Sender: TObject);

   private
      { Private declarations }
      filtro: string;
      cuenta: integer;
      fisicos: Tstringlist;
      xtabla, xclase, xbib, xprogra: string;
      mil: integer;
      it: Tlistitem;
      b_impresion: boolean;
      Opciones: Tstringlist;
      xfisicos: Tstringlist;
      WnomLogo: string;
      procedure agrega( tabla: string; clase: string; bib: string; progra: string; modo: string ); // it:Tlistitem);
      procedure agrega_fisico( tabla: string; clase: string; bib: string; progra: string; modo: string );
      procedure lee;
   public
      { Public declarations }
      tipo: string;
      Wtabla: string;
      titulo: String;
      function ArmarOpciones(b1:Tstringlist):Integer;
      procedure arma( tablas: string );
      procedure prepara( tablas: string );
   end;
var
   ftstablas: Tftstablas;

implementation
uses ptsdm, isvsserver1, ptsgral, parbol;
{$R *.dfm}

procedure Tftstablas.bexportarClick( Sender: TObject );
var
   i, ii, j: integer;
   Libro: _WORKBOOK;
   Hoja: _WORKSHEET;
begin
   j := 5;
   Libro := ExcelApplication1.Workbooks.Add( Null, 0 );
   Hoja := Libro.Sheets[ 1 ] as _WORKSHEET;
   Hoja.Cells.Item[ 2, 1 ] := trim( g_empresa );
   Hoja.Cells.Item[ 2, 1 ].font.size := 10;
   Hoja.Cells.Item[ 3, 1 ] := 'Matriz CRUD : ' + lv.items[ 0 ].caption;
   Hoja.Cells.Item[ 3, 1 ].font.size := 9;
   Hoja.Cells.Item[ 2, 1 ].Font.Bold := True;
   Hoja.Cells.Item[ 3, 1 ].Font.Bold := True;
   Hoja.Cells.Item[ 4, 1 ].Font.Bold := True;

   for ii := 0 to lv.Columns.Count - 1 do begin
      Hoja.Cells.Item[ j, ii + 1 ] := lv.columns[ ii ].caption;
      Hoja.Cells.Item[ j, ii + 1 ].Font.Bold := True;
   end;

   j := j + 1;

   for i := 0 to lv.items.Count - 1 do begin
      Hoja.Cells.Item[ j, 1 ] := lv.items[ i ].caption;
      Hoja.Cells.Item[ j, 1 ].Font.Bold := True;

      for ii := 1 to lv.items.item[ i ].subitems.Count do begin
         Hoja.Cells.Item[ j, ii + 1 ] := lv.items.item[ i ].subitems[ ii - 1 ];
      end;
      j := j + 1;
   end;
   ExcelApplication1.Visible[ 1 ] := true;
end;

procedure Tftstablas.prepara( tablas: string );
begin
   if (tipo = 'TAB') or (tipo = 'SEL')  then
      filtro := '  hcclase in (' + g_q + 'TAB' + g_q + ',' + g_q + 'INS' + g_q + ',' +  g_q + 'SEL' + g_q + ',' +
         g_q + 'DEL' + g_q + ',' + g_q + 'UPD' + g_q + ') '
   else begin
      filtro := '  hcclase in (' + g_q + 'NVW' + g_q + ',' + g_q + 'NIN' + g_q + ',' +  g_q + 'SEL' + g_q + ',' +
         g_q + 'NDL' + g_q + ',' + g_q + 'NUP' + g_q + ') ';
      caption := 'Uso de las Dataview';
      lv.Columns[ 0 ].Caption := 'Dataview';
      lv.Columns[ 4 ].Caption := 'Read';
      lv.Columns[ 5 ].Caption := 'Store';
      lv.Columns[ 6 ].Caption := 'Update';
      lv.Columns[ 7 ].Caption := 'Delete';
   end;
   cmbtabla.Text := tablas;
end;

procedure Tftstablas.FormCreate( Sender: TObject );
var
   lwInSQL : string;
   prodclase,lwSale, Wuser, lwLista : String;
   m : tstringlist;
   j : Integer;
begin
   mnuPrincipal.Style := gral.iPubEstiloActivo;
   caption := titulo;
   if g_language = 'ENGLISH' then begin
      caption := 'Table Usage';
      lv.Column[ 0 ].Caption := 'Table';
      lv.Column[ 1 ].Caption := 'Class';
      lv.Column[ 2 ].Caption := 'Library';
      lv.Column[ 3 ].Caption := 'Component';
      //bimprimir.Caption := 'Print';
      //bexportar.Caption := 'Export';
      //bsalir.Hint := 'Exit';
   end;
   gral.CargaRutinasjs( );
   WnomLogo := 'CR' + formatdatetime( 'YYYYMMDDHHNNSSZZZZ', now );
   gral.CargaLogo( WnomLogo );
   gral.CargaIconosBasicos( );

   //htt.WSDLLocation := g_ruta + 'IsvsServer.xml';
   fisicos := Tstringlist.Create;
{   if dm.sqlselect( dm.q1, 'select * from tsclase where objeto=' + g_q + 'FISICO' + g_q +
      ' order by cclase' ) then begin
      while not dm.q1.Eof do begin
         fisicos.Add( dm.q1.fieldbyname( 'cclase' ).AsString );
         dm.q1.Next;
      end;
   end;
}
  Wuser := 'ADMIN'; //Temporal  JCR
  if dm.sqlselect( dm.q1, 'select * from parametro where clave=' +
      g_q + 'CLASESXPRODUCTO' + g_q ) then
      ProdClase := dm.q1.fieldbyname( 'dato' ).AsString;

   lwSale := 'FALSE';
   while  lwSale = 'FALSE' do begin
      if ProdClase <> 'TRUE' then begin
         if dm.sqlselect( dm.q1, 'select cclase from tsclase ' +
            ' where objeto=' + g_q + 'FISICO' + g_q +
            ' order by cclase' ) then begin
            while not dm.q1.Eof do begin
               fisicos.Add( dm.q1.fieldbyname( 'cclase' ).AsString );
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
                  if dm.sqlselect( dm.q1, 'select cclase from tsclase ' +
                  ' where cclase = '+g_q+dm.q2.fieldbyname( 'hcclase' ).AsString+g_q+
                  ' order by cclase' ) then begin
                     fisicos.Add( dm.q1.fieldbyname( 'cclase' ).AsString );
                  end;
                  dm.q2.Next;
               end;
            end;
            lwSale := 'TRUE';
         end;
      end;
   end;

  xfisicos := Tstringlist.Create; // para controlar el loop en agrega_fisicos

  if gral.iPubVentanasActivas > 0 then  
      gral.PubExpandeMenuVentanas( True );
end;

procedure Tftstablas.agrega( tabla: string; clase: string; bib: string;
   progra: string; modo: string );
begin
   if ( tabla <> xtabla ) or
      ( clase <> xclase ) or
      ( bib <> xbib ) or
      ( progra <> xprogra ) then begin
      if mil > 1000 then begin
         lbltotal.Caption := 'Total  ' + inttostr( dm.q1.RecordCount ) + '  (1 - ' + inttostr( cuenta ) + ')';
         bmas.Visible := true;
         exit;
      end;
      it := lv.Items.Add;
      it.Caption := tabla;
      it.SubItems.Add( clase );
      it.SubItems.Add( bib );
      it.SubItems.Add( progra );
      it.SubItems.Add( ' ' );
      it.SubItems.Add( ' ' );
      it.SubItems.Add( ' ' );
      it.SubItems.Add( ' ' );
      xtabla := tabla;
      xclase := clase;
      xbib := bib;
      xprogra := progra;
   end;
   if ( modo = 'TAB' ) or ( modo = 'NVW' ) or ( modo = 'SEL' )then
      it.SubItems[ 3 ] := 'X'
   else if ( modo = 'INS' ) or ( modo = 'NIN' ) then
      it.SubItems[ 4 ] := 'X'
   else if ( modo = 'UPD' ) or ( modo = 'NUP' ) then
      it.SubItems[ 5 ] := 'X'
   else if ( modo = 'DEL' ) or ( modo = 'NDL' ) then
      it.SubItems[ 6 ] := 'X';
   inc( mil );
   inc( cuenta );
end;

procedure Tftstablas.agrega_fisico( tabla: string; clase: string; bib: string;
   progra: string; modo: string );
var
   hcprog, pcclase, pcbib, pcprog: string;
   //    it:Tlistitem;
   qq: Tadoquery;
begin
   if xfisicos.IndexOf( clase + '+' + bib + '+' + progra ) > -1 then
      exit;
   xfisicos.Add( clase + '+' + bib + '+' + progra );
   if fisicos.IndexOf( clase ) = -1 then begin
      qq := Tadoquery.Create( self );
      qq.Connection := dm.ADOConnection1;
      if dm.sqlselect( qq,
         ' select distinct hcprog,hcclase,pcclase,pcbib,pcprog from tsrela ' +
         ' where hcprog=' + g_q + progra + g_q +
         ' and   hcbib=' + g_q + bib + g_q +
         ' and   hcclase=' + g_q + clase + g_q +
         ' and   pcclase<>' + g_q + 'CLA' + g_q + // porque se metio TAB como FISICO
         ' order by hcprog,pcclase,pcbib,pcprog,hcclase' ) then begin
         while not qq.Eof do begin
            agrega_fisico( tabla, qq.fieldbyname( 'pcclase' ).AsString,
               qq.fieldbyname( 'pcbib' ).AsString,
               qq.fieldbyname( 'pcprog' ).AsString, modo );
            qq.Next;
         end;
      end;
      qq.Free;
      exit;
   end;
    agrega( tabla, clase, bib, progra, modo );
end;

procedure Tftstablas.lee;
var
   tabla, clase, bib, progra, modo: string;
begin
   tabla := '';
   mil := 0;
   repeat begin
         tabla := uppercase( dm.q1.FieldByName( 'hcprog' ).AsString );
         clase := dm.q1.FieldByName( 'pcclase' ).AsString;
         bib := dm.q1.FieldByName( 'pcbib' ).AsString;
         progra := dm.q1.FieldByName( 'pcprog' ).AsString;
         modo := dm.q1.FieldByName( 'hcclase' ).AsString;
         xfisicos.Clear;
         agrega_fisico( tabla, clase, bib, progra, modo );
         dm.q1.Next;
      end
   until dm.q1.Eof;
   lbltotal.Caption := 'Total  ' + inttostr( dm.q1.RecordCount );
   bmas.Visible := false;
end;

procedure Tftstablas.arma( tablas: string );
var
   seleccion: string;
begin
   caption := titulo;
   if trim( tablas ) = '' then
      exit;
   lv.Items.Clear;
   tablas := stringreplace( tablas, '*', '%', [ rfreplaceall ] );
   if pos( '%', tablas ) > 0 then
      seleccion := ' where hcprog like ' + g_q + tablas + g_q
   else
      seleccion := ' where hcprog=' + g_q + tablas + g_q;
   if dm.sqlselect( dm.q1,
      ' select distinct hcprog,hcclase,pcclase,pcbib,pcprog from tsrela ' +
      seleccion + ' and ' + filtro +
      ' and pcclase<>' + g_q + 'CLA' + g_q + // porque se metio TAB como FISICO
      ' order by hcprog,pcclase,pcbib,pcprog,hcclase' ) then begin
      cuenta := 0;
      lee;
   end;
   crea_web( );
end;

procedure Tftstablas.bsalirClick( Sender: TObject );
var
   arch: string;
begin
   gral.BorraIconosBasicos( );
   gral.BorraRutinasjs( );
   gral.BorraLogo( WnomLogo + g_ext );
   arch := g_tmpdir + '\MatrizCRUD.html';
   g_borrar.Add( arch );
   arch := g_tmpdir + '\MatrizCRUDIMP.html';
   g_borrar.Add( arch );
   close;
end;

procedure Tftstablas.lvClick( Sender: TObject );
var
   ite, nitem: Tlistitem;
   i, ini: integer;
   linea: string;
begin
   if lv.ItemIndex = -1 then
      exit;
   for i := 0 to lv.Items.Count - 1 do
      lv.Items[ i ].Checked := lv.Items[ i ].Selected;
   screen.cursor := crsqlwait;
   ite := lv.Items[ lv.itemindex ];
   if ite.SubItems[ 0 ] = 'ETP' then begin
      if dm.sqlselect( dm.q1, 'select * from tsrela ' +
         ' where hcprog=' + g_q + ite.SubItems[ 2 ] + g_q +
         ' and   hcbib=' + g_q + ite.SubItems[ 1 ] + g_q +
         ' and   hcclase=' + g_q + 'ETP' + g_q +
         ' and   pcclase<>' + g_q + 'ETP' + g_q ) then begin
         dm.trae_fuente( dm.q1.fieldbyname( 'pcprog' ).AsString,
            dm.q1.fieldbyname( 'pcbib' ).AsString,
            dm.q1.fieldbyname( 'pcclase' ).AsString, texto );
      end
      else begin
         Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe' ) ),
            pchar( dm.xlng( 'Busca archivo fuente ' ) ), MB_OK );
         abort;
      end;
   end
   else
      dm.trae_fuente( ite.SubItems[ 2 ], ite.SubItems[ 1 ], ite.SubItems[ 0 ], texto );

   lvindice.Items.Clear;
   if pos( chr( 13 ) + chr( 10 ), texto.Text ) = 0 then // corrige cuando el fuente no tiene CR
      texto.Text := stringreplace( texto.Text, chr( 10 ), chr( 13 ) + chr( 10 ), [ rfreplaceall ] );
   for i := 0 to texto.Lines.Count - 1 do begin
      linea := texto.Lines[ i ];

      while pos( uppercase( ite.Caption ), uppercase( linea ) ) > 0 do begin
         nitem := lvindice.Items.Add;
         nitem.Caption := inttostr( i + 1 );
         nitem.SubItems.Add( texto.Lines[ i ] );
         linea := copy( linea, pos( uppercase( ite.Caption ), uppercase( linea ) ) + length( ite.Caption ), 500 );
      end;
   end;
   screen.cursor := crdefault;
end;

procedure Tftstablas.lvindiceClick( Sender: TObject );
var
   i, y: integer;
begin
   if ( lvindice.ItemIndex = -1 ) then
      exit;
   texto.SetFocus;
   texto.SelStart := 0;
   y := 0;
   for i := 0 to lvindice.Itemindex do begin
      y := posex( Wtabla, texto.Lines.text, y + 1 );
   end;
   texto.SelStart := y - 1;
   texto.SelLength := length( Wtabla );
end;

procedure Tftstablas.textoDblClick( Sender: TObject );
var
   arch: string;
begin
   if trim( texto.Text ) = '' then
      exit;
   screen.Cursor := crsqlwait;
   if pos( chr( 13 ) + chr( 10 ), texto.Text ) = 0 then // corrige cuando el fuente no tiene CR
      texto.Text := stringreplace( texto.Text, chr( 10 ), chr( 13 ) + chr( 10 ), [ rfreplaceall ] );
   arch := g_tmpdir + '\f' + formatdatetime( 'YYYYMMDDhhnnss', now ) + '.txt';
   texto.Lines.SaveToFile( arch );
   ShellExecute( 0, 'open', pchar( arch ), nil, PChar( g_tmpdir ), SW_SHOW );
   g_borrar.Add( arch );
   arch := g_tmpdir + '\ICONO_TICK.ico';
   g_borrar.Add( arch );
   screen.Cursor := crdefault;
end;

procedure Tftstablas.textoClick( Sender: TObject );
begin
   texto.setfocus;
end;

procedure Tftstablas.cmbtablaKeyPress( Sender: TObject; var Key: Char );
begin
   if Key = #13 then begin
      Key := #0; { eat enter key }
      Perform( WM_NEXTDLGCTL, 0, 0 ); { move to next control }
   end
end;

procedure Tftstablas.cmbtablaExit( Sender: TObject );
begin
   if cmbtabla.Text = '' then
      exit
   else
      arma( cmbtabla.Text );
end;

procedure Tftstablas.cmbtablaClick( Sender: TObject );
begin
   cmbtabla.SetFocus;
end;

procedure Tftstablas.bmasClick( Sender: TObject );
begin
   screen.Cursor := crsqlwait;
   if dm.procrunning( 'Notepad.exe' ) then
      Application.MessageBox( pchar( dm.xlng( 'Ejecutando!!!!' ) ),
         pchar( dm.xlng( 'Tablas CRUD' ) ), MB_OK )
   else
      Application.MessageBox( pchar( dm.xlng( 'No esta Ejecutando!!!!' ) ),
         pchar( dm.xlng( 'Tablas CRUD' ) ), MB_OK );

   SwitchDesktop( CreateDesktop( 'ClubDelphi', nil, nil, 0, MAXIMUM_ALLOWED, nil ) );
   Sleep( 12000 );
   SwitchDesktop( OpenDesktop( 'Default', 0, False, DESKTOP_SWITCHDESKTOP ) );
   screen.Cursor := crdefault;
   exit;
   lee;
end;

procedure Tftstablas.creaweb;
var
   i, j, ii: integer;
   texto: string;
   x, x1: Tstringlist;
begin
   x := Tstringlist.create;
   x1 := Tstringlist.create;
   x.Add( '<HTML>' );
   x1.Add( '<HTML>' );
   x.Add( '<HEAD>' );
   x1.Add( '<HEAD>' );
   x.Add( '<TITLE>Sys-Mining</TITLE>' );
   x1.Add( '<TITLE>Sys-Mining</TITLE>' );

   // PARA RESALTAR LA LINEA.
   x.ADD( '<script language="JavaScript" type="text/javascript">' );
   x.ADD( ' function ResaltarFila(id_tabla){' );
   x.ADD( '  if (id_tabla == undefined)' );
   x.ADD( 'var filas = document.getElementsByTagName("tr");' );
   x.ADD( '  else{' );
   x.ADD( 'var tabla = document.getElementById(id_tabla);' );
   x.ADD( 'var filas = tabla.getElementsByTagName("tr");' );
   x.ADD( '}' );
   x.ADD( 'for(var i in filas) { ' );
   x.ADD( 'filas[i].onmouseover = function() { ' );
   x.ADD( 'this.className = "resaltar";' );
   x.ADD( '}' );
   x.ADD( 'filas[i].onmouseout = function() { ' );
   x.ADD( 'this.className = null; ' );
   x.ADD( '  }' );
   x.ADD( ' }' );
   x.ADD( '}' );
   x.ADD( '</script>' );

   x.ADD( '<style type="text/css">' );
   x.ADD( 'tr.resaltar {' );
   x.ADD( 'background-color: #E6E6E6;' );
   x.ADD( '}' );
   x.ADD( '</style>' );

   // FIN RESALTAR LA LINEA
   // SCROLL DE LA TABLA
   x.Add( '</HEAD>' );
   x1.Add( '<TITLE>SysViewSoft</TITLE>' );
   x.Add( '<BODY  Text="#000000" link="#000000" alink= "#FF0000" vlink= "#000000">' );
   x1.Add( '<BODY Text="#000000" link="#000000">' );
   x.Add( '<div ALIGN=MIDDLE ><img width="100" height="30"src="' + trim( WnomLogo ) + g_ext + '" ALIGN=right>' );
   x1.Add( '<div ALIGN=MIDDLE ><img width="100" height="30"src="' + trim( WnomLogo ) + g_ext + '" ALIGN=right>' );


   x.Add( '<font size=1>'+'<b>'+g_empresa+'</b>'+'<font>' );
   x1.Add( '<font size=1>'+'<b>'+g_empresa+'</b>'+'<font>' );
   texto := dm.xlng( 'MATRIZ CRUD: ' );

   //x.Add( '<p><font size=1 >' +'<b>'+ '*'+'</b>' + '</font></p>' );
   x.Add( '<p><font size=1 >' + '<b>'+ texto+'</b>'  + '</font></p>' );
   x1.Add( '<p><font size=1 >' + '<b>'+ texto+'</b>'  + '</font></p>' );

   x.Add( '<TABLE id="tabla_MAtrizCRUD" cellspacing="1" BORDER="3">' );
   x1.Add( '<TABLE id="tabla_MatrizCRUD" cellspacing="1" BORDER="3">' );
   x.Add( '<TR>' );
   x1.Add( '<TR>' );

   for i := 0 to lv.Columns.Count - 1 do begin
      x.add( '<TH bgcolor="#A9D0F5" NOWRAP><FONT  FACE="verdana" size="2">' + lv.columns[ i ].caption + '</font></TH>' );
      x1.add( '<TH bgcolor="#A9D0F5" NOWRAP><FONT FACE="verdana" size="2">' + lv.columns[ i ].caption + '</font></TH>' );
   end;
   x.add( '</TR>' );
   x1.add( '</TR>' );
   x.add( '<TR>' );
   x1.add( '<TR>' );

   for i := 0 to lv.items.Count - 1 do begin
      texto := trim( lv.items.item[ i ].caption );
      if texto = '' then begin
         x.add( '<TD bgcolor="#A9D0F5">&nbsp;</TD>' );
         x1.add( '<TD bgcolor="#A9D0F5">&nbsp;</TD>' );
      end
      else begin
         //x.add( '<TD bgcolor="#4169E1" NOWRAP><FONT FACE="verdana" size="1">' +
         x.add( '<TD NOWRAP><FONT FACE="verdana" size="1">' +
            lv.items.item[ i ].caption + '</font></TD>' );
         x1.add( '<TD NOWRAP><FONT FACE="verdana" size="1">' +
            lv.items.item[ i ].caption + '</font></TD>' );
      end;
      for ii := 0 to lv.items.item[ i ].subitems.Count - 1 do begin
         texto := trim( lv.items.item[ i ].subitems[ ii ] );
         if texto <> '' then begin
            if ii = 2 then begin
               x.add( '<TD ALIGN=left><FONT FACE="verdana" size="1" ><A HREF=#lin' +
                  lv.items.item[ i ].caption + '|' +
                  lv.items.item[ i ].subitems[ ii - 2 ] + '|' +
                  lv.items.item[ i ].subitems[ ii - 1 ] + '|' +
                  lv.items.item[ i ].subitems[ ii ] +
                  '>' + lv.items.item[ i ].subitems[ ii ] + '</A></font></TD>' );
               x1.add( '<TD ALIGN=center><FONT FACE="verdana" size="1">' + lv.items.item[ i ].subitems[ ii ] + '</font></TD>' );
            end
            else begin
               if lv.items.item[ i ].subitems[ ii ] = 'X' then begin
                  x.add( '<TD ALIGN=center><IMG width="18" height="18" SRC="' + g_tmpdir + '\ICONO_TICK.ico"></TD>' );
                  x1.add( '<TD ALIGN=center><IMG width="18" height="18" SRC="' + g_tmpdir + '\ICONO_TICK.ico"></TD>' );
               end
               else begin
                  x.add( '<TD ALIGN=center><FONT FACE="verdana" size="1" >' + lv.items.item[ i ].subitems[ ii ] + '</font></TD>' );
                  x1.add( '<TD align=center><FONT FACE="verdana" size="1">' + lv.items.item[ i ].subitems[ ii ] + '</font></TD>' );
               end;
            end;
         end
         else begin
            x.add( '<TD>&nbsp;</TD>' );
            x1.add( '<TD>&nbsp;</TD>' );
         end;
      end;
      x.Add( '</TR>' );
      x1.Add( '</TR>' );
   end;
   x.Add( '</TABLE>' );
   x1.Add( '</TABLE>' );
   x.Add( '<script language="JavaScript" type="text/javascript">' );
   x.Add( 'ResaltarFila("tabla_MatrizCRUD");' );
   x.Add( '</script>' );
   x.ADD( '</div>' );
   x1.ADD( '</div>' );
   x.Add( '</BODY>' );
   x1.Add( '</BODY>' );
   x.Add( '</HTML>' );
   x1.Add( '</HTML>' );
   x.savetofile( g_tmpdir + '\MatrizCRUD.html' );
   g_borrar.Add( g_tmpdir + '\MatrizCRUD.html' );
   x1.savetofile( g_tmpdir + '\MatrizCRUDIMP.html' );
   g_borrar.Add( g_tmpdir + '\MatrizCRUDIMP.html' );
   x.free;
   x1.free;
end;

procedure Tftstablas.Crea_Web;
begin
   if lv.Items.Count <> 0 then  begin
      screen.Cursor := crsqlwait;
      mnuExportar.Visible := ivAlways;
      mnuImprimir.visible := ivAlways;
      CreaWeb;
      try
         web.Navigate( g_tmpdir + '\MatrizCRUD.html' );
      except
         exit;
      end;
      screen.Cursor := crdefault;
   end else begin
      Application.MessageBox( pchar( dm.xlng( 'No existe información a procesar.' ) ),
      pchar( dm.xlng( 'Matriz CRUD' ) ), MB_OK );
   end;
end;

procedure Tftstablas.webBeforeNavigate2( Sender: TObject;
   const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
   Headers: OleVariant; var Cancel: WordBool );
var
   nitem: Tlistitem;
   i: integer;
   linea: string;
   k, l: integer;
   b1: string;
   m: Tstringlist;
   x, y: integer;
begin
   k := pos( '#lin', URL );
   if k > 0 then begin
      screen.Cursor := crsqlwait;
      l := Length( URL );
      b1 := copy( URL, K + 4, l - 4 );
      b1 := trim( b1 );
   end;
   if b1 = '' then
      exit;
   b1 := stringreplace( trim( b1 ), '|', ' ', [ rfReplaceAll ] );
   m := Tstringlist.Create;
   m.CommaText := b1;
   if m.count < 3 then begin
      Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
         pchar( dm.xlng( 'Matríz CRUD ' ) ), MB_OK );
      m.free;
      exit;
   end;
   if m[ 1 ] = 'ETP' then begin
      if dm.sqlselect( dm.q1, 'select * from tsrela ' +
         ' where hcprog=' + g_q + m[ 3 ] + g_q +
         ' and   hcbib=' + g_q + m[ 2 ] + g_q +
         ' and   hcclase=' + g_q + 'ETP' + g_q +
         ' and   pcclase<>' + g_q + 'ETP' + g_q ) then begin
         dm.trae_fuente( dm.q1.fieldbyname( 'pcprog' ).AsString,
            dm.q1.fieldbyname( 'pcbib' ).AsString,
            dm.q1.fieldbyname( 'pcclase' ).AsString, texto );
      end
      else begin
         Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe' ) ),
            pchar( dm.xlng( 'Matriz CRUD ' ) ), MB_OK );
         abort;
      end;
   end
   else
      dm.trae_fuente( m[ 3 ], m[ 2 ],  m[ 1 ], texto );
   if pos( chr( 13 ) + chr( 10 ), texto.Text ) = 0 then // corrige cuando el fuente no tiene CR
      texto.Text := stringreplace( texto.Text, chr( 10 ), chr( 13 ) + chr( 10 ), [ rfreplaceall ] );
   lvindice.Items.Clear;
   for i := 0 to texto.Lines.Count - 1 do begin
      linea := texto.Lines[ i ];
      while pos( uppercase( m[ 0 ] ), uppercase( linea ) ) > 0 do begin
         nitem := lvindice.Items.Add;
         nitem.Caption := inttostr( i + 1 );
         nitem.SubItems.Add( texto.Lines[ i ] );
         linea := copy( linea, pos( uppercase( m[ 0 ] ), uppercase( linea ) ) + length( m[ 0 ] ), 500 );
      end;
   end;

   //---------------
   screen.Cursor:=crdefault;
   //bgral:=m[0]+' '+m[1]+' '+m[2];
   Opciones:=gral.ArmarMenuConceptualWeb(m[3]+' '+m[2]+' '+m[1],'tabla_crud');
   y:=ArmarOpciones(Opciones);
   gral.PopGral.Popup(g_X, g_Y);
   //---------------

   Wtabla := m[ 0 ];
   m.Free;
   screen.cursor := crdefault;
end;
function Tftstablas.ArmarOpciones(b1:Tstringlist):Integer;

begin
  gral.EjecutaOpcionB (b1,'Matriz CRUD');
end;
{procedure Tftstablas.ArmarOpciones( b1: Tstringlist; x, y: integer );
var
   p, j: integer;
   b2: Tstringlist;
   t, NomProg: string;
   Rect: TRect;
   Control: TWinControl;
   Index: Integer;
   State: TOwnerDrawState;
begin
   NomProg := gral.GetModName( );
   ListOpciones.clear;
   p := b1.Count;
   b2 := Tstringlist.Create;
   for j := 0 to p - 1 do begin
      b2.CommaText := b1[ j ];
      t := '  ' + stringreplace( b2[ 0 ], '|', ' ', [ rfReplaceAll ] );
      ListOpciones.Items.add( t );
   end;
   web.SetFocus;
   ListOpciones.Visible := true;
   b2.Free;
end;
}
procedure Tftstablas.ImpWebClick( Sender: TObject );
begin
   b_impresion := true;
   Web.Navigate( g_tmpdir + '\MatrizCRUDIMP.html' );
end;

procedure Tftstablas.WebPreviewPrint( web: TWebBrowser );
var
   vin, Vout: OleVariant;
begin
   web.ControlInterface.ExecWB( OLECMDID_PRINTPREVIEW, OLECMDEXECOPT_DONTPROMPTUSER, vin, Vout );
end;

procedure Tftstablas.webDocumentComplete( Sender: TObject;
   const pDisp: IDispatch; var URL: OleVariant );
begin
   screen.Cursor := crdefault;
   try
      if b_impresion then begin
         WebPreviewPrint( web );
         Web.Navigate( g_tmpdir + '\MatrizCRUD.html' );
         b_impresion := false;
      end;
   finally
      gral.PubMuestraProgresBar( False );  
   end;
end;


procedure Tftstablas.FormClose( Sender: TObject; var Action: TCloseAction );
var
   arch: string;
begin
   if FormStyle = fsMDIChild then
      Action := caFree;

   gral.BorraIconosBasicos( );
   gral.BorraRutinasjs( );
   gral.BorraLogo( WnomLogo + g_ext );
   arch := g_tmpdir + '\MatrizCRUD.html';
   g_borrar.Add( arch );
   arch := g_tmpdir + '\MatrizCRUDIMP.html';
   g_borrar.Add( arch );
end;

procedure Tftstablas.FormDestroy(Sender: TObject);
begin
      dm.PubEliminarVentanaActiva( Caption );

   if gral.iPubVentanasActivas in [ 0, 1 ] then  
      gral.PubExpandeMenuVentanas( False );
end;

procedure Tftstablas.webProgressChange(Sender: TObject; Progress,
  ProgressMax: Integer);
begin
   gral.PubAvanzaProgresBar;
end;

procedure Tftstablas.mnuImprimirClick(Sender: TObject);
begin
   b_impresion := true;
   Web.Navigate( g_tmpdir + '\MatrizCRUDIMP.html' );
end;

procedure Tftstablas.mnuExportarClick(Sender: TObject);
var
   i, ii, j: integer;
   Libro: _WORKBOOK;
   Hoja: _WORKSHEET;
begin
   j := 5;
   Libro := ExcelApplication1.Workbooks.Add( Null, 0 );
   Hoja := Libro.Sheets[ 1 ] as _WORKSHEET;
   Hoja.Cells.Item[ 2, 1 ] := trim( g_empresa );
   Hoja.Cells.Item[ 2, 1 ].font.size := 10;
   Hoja.Cells.Item[ 3, 1 ] := 'Matriz CRUD : ' + lv.items[ 0 ].caption;
   Hoja.Cells.Item[ 3, 1 ].font.size := 9;
   Hoja.Cells.Item[ 2, 1 ].Font.Bold := True;
   Hoja.Cells.Item[ 3, 1 ].Font.Bold := True;
   Hoja.Cells.Item[ 4, 1 ].Font.Bold := True;

   for ii := 0 to lv.Columns.Count - 1 do begin
      Hoja.Cells.Item[ j, ii + 1 ] := lv.columns[ ii ].caption;
      Hoja.Cells.Item[ j, ii + 1 ].Font.Bold := True;
   end;

   j := j + 1;

   for i := 0 to lv.items.Count - 1 do begin
      Hoja.Cells.Item[ j, 1 ] := lv.items[ i ].caption;
      Hoja.Cells.Item[ j, 1 ].Font.Bold := True;

      for ii := 1 to lv.items.item[ i ].subitems.Count do begin
         Hoja.Cells.Item[ j, ii + 1 ] := lv.items.item[ i ].subitems[ ii - 1 ];
      end;
      j := j + 1;
   end;
   ExcelApplication1.Visible[ 1 ] := true;
end;

procedure Tftstablas.FormDeactivate(Sender: TObject);
begin
   gral.PopGral.Items.Clear;
end;
{
function Tftstablas.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
   try
      HtmlHelp(Application.Handle,
            PChar(Format('%s::/T%5.5d.htm',
           //[Application.HelpFile,ActiveControl.HelpContext])),HH_DISPLAY_TOPIC, 0);
            [Application.HelpFile,iHelpContext ])),HH_DISPLAY_TOPIC, 0);
      CallHelp := False;
   except
      Application.MessageBox( 'No existe ayuda para la pantalla ó campo seleccionado','Ayuda ' , MB_OK );
   end;
end;

procedure Tftstablas.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
      //iHelpContext:=ActiveControl.HelpContext;
      iHelpContext:=HTML_HELP.IDH_TOPIC_T01600;
end;
}

procedure Tftstablas.FormActivate(Sender: TObject);
begin
   iHelpContext:=HTML_HELP.IDH_TOPIC_T01600;
   g_producto := 'MENÚ CONTEXTUAL-MATRIZ CRUD';

end;

end.


