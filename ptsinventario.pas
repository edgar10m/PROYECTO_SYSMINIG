unit ptsinventario;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, Grids, ComCtrls, ADODB, DB, DBGrids, StdCtrls, ExtCtrls, printers,
   OleCtrls, pbarra, OleServer, ComObj, shellapi, ExcelXP, Menus, Buttons,
   SHDocVw, ImgList, dxBar, HTML_HELP, htmlhlp, Excel97, uConstantes;

type
   Ttot = record
      sistema: string;
      columna: integer;
      total: array of integer;
   end;
type
   Tgroup = record
      sistema: string;
      clase: string;
      total: integer;
   end;
type
   Tftsinventario = class( TForm )
      tab: TTabControl;
      dg: TDrawGrid;
      Splitter1: TSplitter;
      DBGrid1: TDBGrid;
      query: TADOQuery;
      DataSource1: TDataSource;
      ytitulo: TPanel;
      PrintDialog1: TPrintDialog;
      ImageList1: TImageList;
      Web: TWebBrowser;
      Splitter3: TSplitter;
      ImpWeb: TBitBtn;
      ExcelApplication1: TExcelApplication;
      ver_componente: TMemo;
      mnuPrincipal: TdxBarManager;
      mnuImprimir: TdxBarButton;
      mnuExportar: TdxBarButton;
    cmbsistema: TComboBox;
      procedure FormCreate( Sender: TObject );
      procedure dgDrawCell( Sender: TObject; ACol, ARow: Integer; Rect: TRect;
         State: TGridDrawState );
      procedure tabChange( Sender: TObject );
      procedure dgClick( Sender: TObject );
      procedure dgMouseDown( Sender: TObject; Button: TMouseButton;
         Shift: TShiftState; X, Y: Integer );
      procedure AnalisisdeImpacto1Click( Sender: TObject );
      procedure bClick( Sender: TObject );
      procedure bimprimirClick( Sender: TObject );
      procedure WebBeforeNavigate2( Sender: TObject; const pDisp: IDispatch;
         var URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
         var Cancel: WordBool );
      procedure ImpWebClick( Sender: TObject );
      procedure BExcelClick( Sender: TObject );
      procedure VistadelComponente1Click( Sender: TObject );
      procedure WebDocumentComplete( Sender: TObject; const pDisp: IDispatch;
         var URL: OleVariant );
      function ArmarOpciones( b1: Tstringlist ): Integer;
      procedure analisisdeimpacto( Sender: TObject );
      procedure diagramaproceso( Sender: TObject );
      procedure formadelphipreview( Sender: TObject );
      procedure panelpreview( Sender: TObject );
      procedure naturalmapapreview( Sender: TObject );
      procedure diagramanatural( Sender: TObject );
      procedure referenciascruzadas( Sender: TObject );
      procedure reglasnegocio( Sender: TObject );
      procedure versionado( Sender: TObject );
      procedure fmbvistapantalla( Sender: TObject );
      procedure bmspreview( Sender: TObject );
      procedure diagramacbl( Sender: TObject );
      procedure dghtml( Sender: TObject );
      procedure diagramarpg( Sender: TObject );
      procedure tablacrud( Sender: TObject );
      procedure adabascrud( Sender: TObject );
      procedure diagramajcl( Sender: TObject );
      procedure diagramaase( Sender: TObject );
      procedure listacomponentes( Sender: TObject );
      procedure propiedades( Sender: TObject );
      procedure atributos( Sender: TObject );
      procedure VerFuente( Sender: TObject );
      procedure DBGrid1CellClick( Column: TColumn );
      procedure FormClose( Sender: TObject; var Action: TCloseAction );
      procedure FormDestroy( Sender: TObject );
      procedure WebProgressChange( Sender: TObject; Progress,
         ProgressMax: Integer );
      procedure mnuImprimirClick( Sender: TObject );
      procedure mnuExportarClick( Sender: TObject );
      procedure FormDeactivate( Sender: TObject );
      function FormHelp( Command: Word; Data: Integer;
         var CallHelp: Boolean ): Boolean;
      procedure FormKeyDown( Sender: TObject; var Key: Word;
         Shift: TShiftState );
   private
      { Private declarations }
      tt: array of Ttot;
      cla: Tstringlist;
      stitulo: Tstringlist;
      shiftclases: integer;
      bitmap: Tbitmap;
      lin: integer;
      iy: integer;
      tidentificados, texistentes, tfaltantes, tsinuso, tsinusoexistent, tactivos: string;
      SisComp, AntSisComp: string;
      pagina: integer;
      vaux3: integer;
      Xtitulo, Xtexto: string;
      tt_existentes, tt_existentesW1, tt_identificados, tt_faltantes,
         tt_faltantesW1, tt_sin_uso, tt_activos, tt_W1: string;
      tg: array of Tgroup;
      b_impresion: boolean;
      Opciones: Tstringlist;
      NombreProceso: string;
      WnomLogo: string;
      Wfecha: string;
      Wtipop: string; //Existentes, Faltantes, Sin Uso, Activos e Identificados.
      Yfecha, Nfecha: string; //
      procedure subsistemas( oficina: string; sistema: string; columna: integer );
      procedure pinta( Rect: TRect; columna: integer; texto: string );
      procedure totaliza;
      procedure consulta( sistema: string; tipo: string );
      function tsrela_cla( sistema: string; tipo: string ): string;
      procedure query_cuenta( query: string );
      procedure titulos( tipo: integer );
      procedure totales;
      procedure creaweb;
      procedure Crea_Web;
      procedure WebPreviewPrint( web: TWebBrowser );
      procedure Grabaarchivo( clave: string; archivo: string );
      function TraeArchivo( clave: string; archivo: string; archivo1: string ): boolean;
   public
      { Public declarations }
      titulo: string;
   end;

var

   ftsinventario: Tftsinventario;

procedure PR_INVENTARIO;

implementation
uses ptsdm, ptsmain, ptsgral; //ptsimpacto - quitar hasta que se ajuste con ufmAnalisiImpacto
{$R *.dfm}

procedure PR_INVENTARIO;
begin
   ftsinventario.Show;   
end;

function Tftsinventario.tsrela_cla( sistema: string; tipo: string ): string;
begin
   tsrela_cla := ' select distinct hcclase clase,hcbib libreria,hcprog componente from tsrela ' +
      ' where pcprog=' + g_q + tipo + g_q +
      '   and pcbib=' + g_q + sistema + g_q +
      '   and pcclase=' + g_q + 'CLA' + g_q;
end;

procedure Tftsinventario.query_cuenta( query: string );
var
   i, j, k: integer;
begin
   setlength( tg, 0 );
   if dm.sqlselect( dm.q1, query ) then
   begin
      while not dm.q1.Eof do
      begin
         k := length( tg );
         setlength( tg, k + 1 );
         tg[ k ].sistema := dm.q1.fieldbyname( 'sistema' ).AsString;
         tg[ k ].clase := dm.q1.Fields[ 1 ].AsString;
         tg[ k ].total := dm.q1.fieldbyname( 'total' ).AsInteger;
         dm.q1.Next;
      end;
   end;
   for i := 0 to length( tt ) - 2 do
   begin
      if tt[ i ].columna > 1 then
      begin
         for j := 0 to cla.Count - 1 do
         begin
            tt[ i ].total[ j ] := 0;
            for k := 0 to length( tg ) - 1 do
            begin
               if ( tg[ k ].clase = cla[ j ] ) and ( tg[ k ].sistema = tt[ i ].sistema ) then
               begin
                  tt[ i ].total[ j ] := tg[ k ].total;
                  break;
               end;
            end;
         end;
      end;
   end;
end;

procedure Tftsinventario.totaliza;
var
   i, j, k: integer;
   arch: string;
begin
   i := 0;
   screen.cursor := crsqlwait;
   AntSisComp := '';
   mnuImprimir.Visible := ivNever;
   mnuExportar.Visible := ivNever;
   dg.Refresh;

   if tab.Tabs[ tab.TabIndex ] = tidentificados then
      query_cuenta( tt_identificados )
   else if tab.Tabs[ tab.TabIndex ] = texistentes then
      query_cuenta( tt_existentes )
   else if tab.Tabs[ tab.TabIndex ] = tfaltantes then
      query_cuenta( tt_faltantes )
   else if tab.Tabs[ tab.TabIndex ] = tsinuso then
      query_cuenta( tt_sin_uso )
   else if tab.Tabs[ tab.TabIndex ] = tactivos then
      query_cuenta( tt_activos )
   else
      Application.MessageBox( pchar( dm.xlng( 'Opción inconsistente en el titulo de los TAB' ) ),
         pchar( dm.xlng( 'Inventario de Componentes' ) ), MB_OK );
   Wtipop := tab.Tabs[ tab.TabIndex ];

   //___________________________________________________________________________

   //Valida: si existen los archivos html ya no genera nada y lo manda directo  a la pantalla.
   Nfecha := formatdatetime( 'YYYYMMDD', now );
   if TraeArchivo( 'Invent' + Wtipop, g_tmpdir + '\Invent' + Wtipop + '.html', g_tmpdir + '\InventIMP' + Wtipop + '.html' ) = TRUE then
   begin
      screen.Cursor := crsqlwait;
      TraeArchivo( 'InventIMP' + Wtipop, g_tmpdir + '\Invent' + Wtipop + '.html', g_tmpdir + '\InventIMP' + Wtipop + '.html' );
      arch := g_tmpdir + '\Invent' + Wtipop + '.html';
      g_borrar.Add( arch );
      arch := g_tmpdir + '\InventIMP' + Wtipop + '.html';
      g_borrar.Add( arch );
      web.Navigate( g_tmpdir + '\Invent' + Wtipop + '.html' );
      screen.Cursor := crdefault;
      exit
   end;
   //___________________________________________________________________________

   k := length( tt ) - 1;
   for j := 0 to high( tt[ i ].total ) do
      tt[ k ].total[ j ] := 0;
   for j := 0 to high( tt[ k ].total ) do
      for i := 1 to length( tt ) - 2 do
         tt[ k ].total[ j ] := tt[ k ].total[ j ] + tt[ i ].total[ j ];
   dg.Refresh;
   Crea_Web;
   screen.cursor := crdefault;
end;

procedure Tftsinventario.consulta( sistema: string; tipo: string );
var
   descripcion, TipoObjeto, nquery, nselect, nselect0, nselect1, nwhere, nwhere1, nfrom, nanexo, nanexo1, nanexo2, nanexo3: string;
   x1, x2, c1: integer;

begin
   if dm.sqlselect( dm.q1, 'select * from tsclase where cclase=' + g_q + tipo + g_q ) then
   begin
      descripcion := dm.q1.fieldbyname( 'descripcion' ).AsString;
      TipoObjeto := dm.q1.fieldbyname( 'objeto' ).AsString;
   end;
   ytitulo.Caption := tab.Tabs[ tab.TabIndex ] + ' - ' + sistema + ' - ' + tipo + '(' + descripcion + ') Tipo Objeto - ' + TipoObjeto;
   Xtitulo := sistema + ' - ' + tipo + ' - ' + descripcion;
   query.Close;
   query.SQL.Clear;

   nselect := 'select x.sistema,x.hcclase CLASE,x.hcbib LIBRERIA ,x.hcprog COMPONENTE, ' +
      '  nvl((select lineas_total ' +
      '        from tsproperty t ' +
      '       where x.hcclase = t.cclase ' +
      '         and  x.hcbib   = t.cbib ' +
      '         and  x.hcprog  = t.cprog ),0) LINEAS_TOTAL, ' +
      ' nvl((select lineas_efectivas  ' +
      '        from tsproperty t  ' +
      '       where x.hcclase = t.cclase ' +
      '         and  x.hcbib   = t.cbib ' +
      '         and  x.hcprog  = t.cprog ),0) LINEAS_EFECTIVAS, ' +
      ' nvl((select lineas_blanco  ' +
      '        from tsproperty t ' +
      '       where x.hcclase = t.cclase  ' +
      '         and  x.hcbib   = t.cbib  ' +
      '         and  x.hcprog  = t.cprog ),0) LINEAS_BLANCO,  ' +
      ' nvl((select lineas_comentario  ' +
      '        from tsproperty t  ' +
      '       where x.hcclase = t.cclase  ' +
      '         and  x.hcbib   = t.cbib  ' +
      '         and  x.hcprog  = t.cprog ),0) LINEAS_COMENTARIO ';
   ;
   nselect1 := 'select x.sistema,x.cclase CLASE,x.cbib LIBRERIA ,x.cprog COMPONENTE, ' +
      '  nvl((select lineas_total ' +
      '        from tsproperty t ' +
      '       where x.cclase = t.cclase ' +
      '         and  x.cbib   = t.cbib ' +
      '         and  x.cprog  = t.cprog ),0) LINEAS_TOTAL, ' +
      ' nvl((select lineas_efectivas  ' +
      '        from tsproperty t  ' +
      '       where x.cclase = t.cclase ' +
      '         and  x.cbib   = t.cbib ' +
      '         and  x.cprog  = t.cprog ),0) LINEAS_EFECTIVAS, ' +
      ' nvl((select lineas_blanco  ' +
      '        from tsproperty t ' +
      '       where x.cclase = t.cclase  ' +
      '         and  x.cbib   = t.cbib  ' +
      '         and  x.cprog  = t.cprog ),0) LINEAS_BLANCO,  ' +
      ' nvl((select lineas_comentario  ' +
      '        from tsproperty t  ' +
      '       where x.cclase = t.cclase  ' +
      '         and  x.cbib   = t.cbib  ' +
      '         and  x.cprog  = t.cprog ),0) LINEAS_COMENTARIO ';

   if tab.Tabs[ tab.TabIndex ] = texistentes then
   begin
      nfrom := ' from   ((select distinct sistema,hcclase,hcbib,hcprog from tsrela  ' +
         ' where (sistema,hcclase,hcbib,hcprog)  in (select sistema,cclase,cbib,cprog from tsprog)) ' +
         ' union ' +
         ' select distinct sistema,hcclase, hcbib, hcprog from tsrela ' +
         ' where pcbib <> ' + g_q + 'SCRATCH' + g_q + ' and hcclase in (select distinct cclase from tsclase ' +
         ' where objeto = ' + g_q + 'VIRTUAL' + g_q + ' and estadoactual= ' + g_q + 'ACTIVO' + g_q + ')) x ';
   end;

   if tab.Tabs[ tab.TabIndex ] = tactivos then
   begin
      nfrom := '  from  ' +
         //' ( select distinct sistema,cclase,cbib,cprog from tsprog ' +
         //' intersect  ' +   //devuelve los registros comunes de las consultas SELECT
         //'   select sistema,hcclase,hcbib,hcprog from tsrela  where pcclase<> ' + g_q + 'CLA' + g_q + ' and hcbib <> ' + g_q + 'SCRATCH' + g_q + ' ) x ';
         ' (  select distinct sistema,hcclase,hcbib,hcprog from tsrela ' +
         ' where ((pcclase,pcbib,pcprog) in (select cclase,cbib,cprog from tsprog)) ' +
         ' and pcclase <> '+ g_q + 'CLA' + g_q + '  and hcbib <> ' + g_q + 'SCRATCH' + g_q + ' ) x ' ;



   end;

   if tab.Tabs[ tab.TabIndex ] = tsinuso then
   begin
      nfrom := '  from  ' +
         //' ( select distinct sistema,cclase,cbib,cprog from tsprog ' +
         //' minus  ' +   //para devolver todas las filas de la primera instrucción SQL SELECT que no se devuelve en la segunda instrucción SELECT
         //'   select sistema,hcclase,hcbib,hcprog from tsrela  where pcclase<> ' + g_q + 'CLA' + g_q + ' and hcbib <> ' + g_q + 'SCRATCH' + g_q + ' ) x ';
         ' (  select distinct hcclase,hcbib,hcprog from tsrela ' +
         ' where ((pcclase,pcbib,pcprog) not in (select cclase,cbib,cprog from tsprog)) ' +
         //' and pcclase <> '+ g_q + 'CLA' + g_q +
         '  and hcbib <> ' + g_q + 'SCRATCH' + g_q + ' ) x ' ;

   end;

   if tab.Tabs[ tab.TabIndex ] = tidentificados then
   begin
      nfrom := ' from (select distinct sistema,hcclase,hcbib,hcprog from tsrela ) x ';
   end;

   if tab.Tabs[ tab.TabIndex ] = tfaltantes then
   begin
      nfrom := ' from (select distinct sistema,hcclase,hcprog,hcbib from tsrela  where  ' +
         ' ( (hcclase,hcprog,hcbib) not in (select cclase,cprog,cbib from tsprog)) ' +
         '  and ((sistema = hsistema) or (sistema = ''))  '+
         '  and hcclase not in( select cclase from  tsclase where objeto = ' + g_q + 'VIRTUAL' + g_q +
         '  and estadoactual = ' + g_q + 'ACTIVO' + g_q + ')) x ';
   end;

   nwhere := ' where x.sistema = ' + g_q + sistema + g_q +
      '   and x.hcclase = ' + g_q + tipo + g_q +
      ' order by 3,2 ';

   nwhere1 := ' where x.sistema = ' + g_q + sistema + g_q +
      '    and x.cclase = ' + g_q + tipo + g_q +
      ' order by 3,2 ';

   //if ( tab.Tabs[ tab.TabIndex ] = tsinuso )
      //or ( tab.Tabs[ tab.TabIndex ] = tactivos ) then
      //nquery := nselect1 + ' ' + nfrom + ' ' + nwhere1
   //else
      nquery := nselect + ' ' + nfrom + ' ' + nwhere;

   query.SQL.Add( nquery );

   PR_BARRA;
   query.Open;

   for c1 := 1 to dbgrid1.FieldCount - 1 do
   begin
      if c1 = 2 then
         dbgrid1.Columns[ c1 ].Width := 400
      else
         dbgrid1.Columns[ c1 ].Width := 150;
   end;

   {   b1 := 'nombre' + ' biblioteca ' + tipo;
      pop.Items.Clear;
      opciones := gral.ArmarMenuConceptualWeb( b1, 'Inventario_de_Componentes' );
      ArmarOpciones( opciones );
   }

end;

procedure Tftsinventario.subsistemas( oficina: string; sistema: string; columna: integer );
var
   qq: TADOQuery;
   k: integer;
begin
   qq := TADOQuery.Create( self );
   qq.Connection := dm.ADOConnection1;
   if dm.sqlselect( qq, 'select * from tssistema ' + // Subsistemas
      ' where coficina=' + g_q + oficina + g_q +
      ' and cdepende=' + g_q + sistema + g_q +
      ' and estadoactual=' + g_q + 'ACTIVO' + g_q +
      ' order by csistema' ) then
   begin
      while not qq.Eof do
      begin
         k := length( tt );
         setlength( tt, k + 1 );
         tt[ k ].sistema := qq.fieldbyname( 'csistema' ).AsString;
         tt[ k ].columna := columna;
         if dg.ColCount < columna + 1 then
         begin
            dg.ColCount := columna + 1;
            stitulo.Add( ' ' );
            vaux3 := vaux3 + 1;
         end;
         setlength( tt[ k ].total, length( tt[ 0 ].total ) );
         subsistemas( qq.fieldbyname( 'coficina' ).AsString,
            qq.fieldbyname( 'csistema' ).AsString, columna + 1 );
         qq.Next;
      end;
   end;
   qq.free;
end;

procedure Tftsinventario.FormCreate( Sender: TObject );
var
   k, j: integer;
   Wuser, ProdClase, lwLista, lwInSQL, lwSale: String;
   m: tStringlist;
begin
   mnuPrincipal.Style := gral.iPubEstiloActivo;
   caption := titulo;
   if g_language = 'ENGLISH' then
   begin
      //caption := 'Inventory';
      tidentificados := 'IDENTIFIED';
      texistentes := 'EXIST';
      tfaltantes := 'MISSING';
      tsinuso := 'UNUSED';
      tactivos := 'ACTIVE';
      //analisisdeimpacto1.Caption := 'Impact Analysis';
      //bimprimir.Caption := 'Print';
      //bsalir.Hint := 'Exit';
   end
   else
   begin
      tidentificados := 'IDENTIFICADOS';
      texistentes := 'EXISTENTES';
      tfaltantes := 'FALTANTES';
      tsinuso := 'SIN USO';
      tactivos := 'ACTIVOS';
   end;

   tab.Tabs[ 0 ] := texistentes;
   tab.tabs[ 1 ] := tfaltantes;
   tab.Tabs[ 2 ] := tsinuso;
   tab.Tabs[ 3 ] := tactivos;
   tab.Tabs[ 4 ] := tidentificados;
   cla := Tstringlist.Create;
   stitulo := Tstringlist.Create;
   bitmap := Tbitmap.Create;
   dg.ColCount := 3;
   setlength( tt, 1 );
   tt[ 0 ].sistema := g_empresa;
   tt[ 0 ].columna := 0;
   stitulo.Add( 'Empresa' );
   stitulo.Add( 'Oficina' );
   stitulo.Add( 'Sistemas' );
   vaux3 := 0;
   gral.CargaRutinasjs( );
   Wfecha := formatdatetime( 'YYYYMMDDHHNNSSZZZZ', now );
   WnomLogo := 'IN' + g_usuario;
   gral.CargaLogo( WnomLogo );
   //Wuser := g_user;

   // identifica clases

   Wuser := 'ADMIN'; //Temporal  JCR
   if dm.sqlselect( dm.q1, 'select * from parametro where clave=' +
      g_q + 'CLASESXPRODUCTO' + g_q ) then
      ProdClase := dm.q1.fieldbyname( 'dato' ).AsString;
   lwSale := 'FALSE';
   while lwSale = 'FALSE' do
   begin
      if ProdClase <> 'TRUE' then
      begin
         if dm.sqlselect( dm.q1, 'select distinct hcclase from tsrela ' +
            ' where hcclase in (select cclase from tsclase where objeto=' + g_q + 'FISICO' + g_q +
            ' and estadoactual=' + g_q + 'ACTIVO' + g_q + ')' +
            ' order by hcclase' ) then
         begin
            setlength( tt[ 0 ].total, dm.q1.RecordCount );
            while not dm.q1.Eof do
            begin
               cla.Add( dm.q1.fieldbyname( 'hcclase' ).AsString );
               dm.q1.Next;
            end;
         end;
         lwSale := 'TRUE';
      end
      else begin
         if dm.sqlselect( dm.q1, 'select * from tsproductos  where  ccapacidad = ' + g_q + g_producto + g_q +
            ' and cuser = ' + g_q + Wuser + g_q ) then
         begin
            lwLista := dm.q1.fieldbyname( 'cclaseprod' ).AsString;
            m := Tstringlist.Create;
            m.CommaText := lwLista;
            for j := 0 to m.count - 1 do
            begin
               lwInSQL := trim( lwInSQL ) + ' ' + g_q + trim( m[ j ] ) + g_q + ' ';
            end;
            m.Free;
            lwInSQL := Trim( lwInSQL );
            if lwInSQL = '' then
            begin
               ProdClase := 'FALSE';
               CONTINUE;
            end;
            lwInSQL := stringreplace( lwInSQL, ' ', ',', [ rfreplaceall ] );
            if dm.sqlselect( dm.q2, 'select distinct hcclase from tsrela ' +
               ' where hcclase in (' + lwInSQL + ')' + ' order by hcclase' ) then
            begin
               setlength( tt[ 0 ].total, dm.q2.RecordCount );
               while not dm.q2.Eof do
               begin
                  cla.Add( dm.q2.fieldbyname( 'hcclase' ).AsString );
                  dm.q2.Next;
               end;
            end;
            lwSale := 'TRUE';
         end;
      end;
   end;

   if dm.sqlselect( dm.q1, 'select * from tsoficina order by coficina' ) then
   begin // Oficinas
      while not dm.q1.Eof do
      begin
         k := length( tt );
         setlength( tt, k + 1 );
         tt[ k ].sistema := dm.q1.fieldbyname( 'coficina' ).AsString;
         tt[ k ].columna := 1;
         setlength( tt[ k ].total, length( tt[ 0 ].total ) );
         if dm.sqlselect( dm.q2, 'select * from tssistema ' + // Sistemas
            ' where coficina=' + g_q + dm.q1.fieldbyname( 'coficina' ).AsString + g_q +
            ' and cdepende' + g_is_null +
            ' and estadoactual=' + g_q + 'ACTIVO' + g_q +
            ' order by csistema' ) then
         begin
            while not dm.q2.Eof do
            begin
               k := length( tt );
               setlength( tt, k + 1 );
               tt[ k ].sistema := dm.q2.fieldbyname( 'csistema' ).AsString;
               tt[ k ].columna := 2;
               setlength( tt[ k ].total, length( tt[ 0 ].total ) );
               subsistemas( dm.q1.fieldbyname( 'coficina' ).AsString,
                  dm.q2.fieldbyname( 'csistema' ).AsString, 3 );
               dm.q2.Next;
            end;
         end;
         dm.q1.Next;
      end;
   end;
   dg.RowCount := length( tt ) + 2;
   shiftclases := dg.ColCount;
   dg.ColCount := dg.ColCount + cla.Count;
   dg.FixedCols := shiftclases;
   stitulo.AddStrings( cla );
   k := length( tt );
   setlength( tt, k + 1 );
   tt[ k ].sistema := '-- Totales';
   tt[ k ].columna := 2;
   setlength( tt[ k ].total, length( tt[ 0 ].total ) );
   {
      tt_existentes := 'select sistema,cclase,count(*) total from tsprog ' +
         ' group by sistema,cclase order by 1,2';

      tt_identificados := 'select sistema,hcclase,count(*) total from ' +
         ' (select distinct sistema,hcclase,hcbib,hcprog from tsrela) ' +
         '    group by sistema,hcclase order by 1,2';

      tt_faltantes := 'select sistema,hcclase,count(*) total from ' +
         '(select distinct sistema,hcclase,hcprog from tsrela ' +
         ' where (hcprog,hcbib,hcclase) not in (select cprog,cbib,cclase from tsprog))' +
         ' group by sistema,hcclase ' + ' order by 1,2';

      tt_faltantesW1 := 'select sistema,hcclase,count(*) total from tsrela' +
         ' group by sistema,hcclase ' +
         ' order by 1,2';

      tt_sin_uso := 'select sistema,cclase,count(*) total from ' +
         ' (select sistema,cclase,cbib,cprog from tsprog ' +
         '  minus ' +
         '  select distinct sistema,hcclase,hcbib,hcprog from tsrela ' +
         '    where pcclase<>' + g_q + 'CLA' + g_q + ') group by sistema,cclase order by 1,2';

      tt_activos := 'select sistema,cclase,count(*) total from ' +
         ' (select sistema,cclase,cbib,cprog from tsprog ' +
         '  intersect ' +
         '  select distinct sistema,hcclase,hcbib,hcprog from tsrela ' +
         '    where pcclase<>' + g_q + 'CLA' + g_q + ') group by sistema,cclase order by 1,2';
    }
   //------------------  ADAPTACIONES PARA LAS CLASES FISICAS y VIRTUALES.

   tt_W1 := 'select sistema,hcclase,count(*) total from tsrela' +
      ' group by sistema,hcclase ' +
      ' order by 1,2';

   tt_identificados := 'select sistema,hcclase,count(*) total from ' +
      ' (select distinct sistema,hcclase,hcbib,hcprog from tsrela) ' +
      '    group by sistema,hcclase order by 1,2';

   tt_existentes := 'select sistema,hcclase,count(*) total from ' +
      ' ((select distinct sistema,hcclase,hcbib,hcprog from tsrela  ' +
      ' where (sistema,hcclase,hcbib,hcprog)  in (select sistema,cclase,cbib,cprog from tsprog)) ' +
      ' union ' +
      ' select distinct sistema,hcclase, hcbib, hcprog from tsrela ' +
      ' where pcbib <> ' + g_q + 'SCRATCH' + g_q + ' and hcclase in (select distinct cclase from tsclase ' +
      ' where objeto = ' + g_q + 'VIRTUAL' + g_q + ' and estadoactual= ' + g_q + 'ACTIVO' + g_q + ')) ' +
      ' group by sistema,hcclase  order by 1,2';

   tt_faltantes := 'select sistema,hcclase,count(*) total from ' +
      ' (select distinct sistema,hcclase,hcprog,hcbib from tsrela  where  ' +
      ' ( (hcclase,hcprog, hcbib) not in (select cclase,cprog, cbib from tsprog)) ' +
      '  and ((sistema = hsistema) or (sistema = '')) ' +
      '  and hcclase not in( select cclase from  tsclase where objeto = ' + g_q + 'VIRTUAL' + g_q +
      '  and estadoactual = ' + g_q + 'ACTIVO' + g_q + '))' +
      ' group by sistema,hcclase ' + ' order by 1,2';

   tt_faltantesW1 := 'select sistema,hcclase,count(*) total from tsrela' +
      ' group by sistema,hcclase ' +
      ' order by 1,2';

   tt_sin_uso := ' select sistema,hcclase, count(*) total from  ' +
     // ' (  select distinct sistema,cclase,cbib,cprog from tsprog  ' +
     // ' minus  ' +       //para devolver todas las filas de la primera instrucción SQL SELECT que no se devuelve en la segunda instrucción SELECT
     // ' select sistema,hcclase,hcbib,hcprog from tsrela  where pcclase<> ' + g_q + 'CLA' + g_q + ' and hcbib <> ' + g_q + 'SCRATCH' + g_q +
         ' (  select distinct sistema,hcclase,hcbib,hcprog from tsrela ' +
         ' where ((pcclase,pcbib,pcprog) not in (select cclase,cbib,cprog from tsprog)) ' +
         //' and pcclase <> '+ g_q + 'CLA' + g_q +
         '  and hcbib <> ' + g_q + 'SCRATCH' + g_q +
      '  ) group by sistema,hcclase order by 1,2';

   tt_activos := ' select sistema,hcclase, count(*) total from  ' +
      //' (  select distinct sistema,cclase,cbib,cprog from tsprog  ' +
      //' intersect  ' +  //devuelve los registros comunes de las consultas SELECT
      //' select sistema,hcclase,hcbib,hcprog from tsrela  where pcclase<> ' + g_q + 'CLA' + g_q + ' and hcbib <> ' + g_q + 'SCRATCH' + g_q +
         ' (  select distinct sistema,hcclase,hcbib,hcprog from tsrela ' +
         ' where ((pcclase,pcbib,pcprog) in (select cclase,cbib,cprog from tsprog)) ' +
         ' and pcclase <> '+ g_q + 'CLA' + g_q + '  and hcbib <> ' + g_q + 'SCRATCH' + g_q +
      '  ) group by sistema,hcclase order by 1,2';
   //------------------

   mnuImprimir.Visible := ivNever;
   mnuExportar.Visible := ivNever;
   dg.Refresh;
   totaliza;

   if gral.iPubVentanasActivas in [ 0, 1 ] then
      gral.PubExpandeMenuVentanas( False );
end;

procedure Tftsinventario.pinta( Rect: TRect; columna: integer; texto: string );
begin
   if dg.canvas.Textwidth( texto ) > dg.ColWidths[ columna ] then
      dg.ColWidths[ columna ] := dg.canvas.Textwidth( texto );
   dg.canvas.TextRect( rect, rect.left, rect.Top, texto );
end;

procedure Tftsinventario.dgDrawCell( Sender: TObject; ACol, ARow: Integer;
   Rect: TRect; State: TGridDrawState );
var
   texto: string;
begin
   if arow = 0 then
   begin
      pinta( rect, acol, stitulo[ acol ] );
      exit;
   end;
   if acol = tt[ arow - 1 ].columna then
   begin
      pinta( rect, acol, tt[ arow - 1 ].sistema );
      exit;
   end;
   if acol > shiftclases - 1 then
   begin
      if tt[ arow - 1 ].columna > 1 then
      begin
         dg.Canvas.brush.color := $00E6E6E6; //$00E7D3D7;
         if tt[ arow - 1 ].total[ acol - shiftclases ] > 0 then
            texto := inttostr( tt[ arow - 1 ].total[ acol - shiftclases ] )
         else
            texto := ' ';
         pinta( rect, acol, texto );
         dg.Canvas.brush.color := clwindow;
      end;
      exit;
   end;
end;

procedure Tftsinventario.tabChange( Sender: TObject );
begin
   dg.Refresh;
   ytitulo.Caption := '';
   mnuImprimir.Visible := ivNever;
   mnuExportar.Visible := ivNever;
   totaliza;
end;

procedure Tftsinventario.dgClick( Sender: TObject );
begin
   if ( dg.col < shiftclases ) or ( dg.Row < 0 ) then
      exit;
   if tt[ dg.Row - 1 ].columna > 1 then
      consulta( tt[ dg.row - 1 ].sistema, cla[ dg.Col - shiftclases ] );
end;

procedure Tftsinventario.dgMouseDown( Sender: TObject; Button: TMouseButton;
   Shift: TShiftState; X, Y: Integer );
var
   xx, yy: integer;
begin
   dg.MouseToCell( x, y, xx, yy );
   if ( xx < 0 ) or ( yy < 0 ) then
      exit;
   dg.Col := xx;
   dg.Row := yy;
end;

procedure Tftsinventario.AnalisisdeImpacto1Click( Sender: TObject );
begin
   {screen.Cursor := crsqlwait;
   PR_IMPACTO( query.FieldByName( 'componente' ).AsString,
      query.FieldByName( 'libreria' ).AsString,
      query.FieldByName( 'clase' ).AsString );
   screen.Cursor := crdefault;}
end;

procedure Tftsinventario.bClick( Sender: TObject );
begin
   gral.BorraRutinasjs( );
   gral.BorraLogo( WnomLogo + g_ext );
   close;
end;

procedure Tftsinventario.titulos( tipo: integer );
var
   mitad, ancho: integer;
   ARect: TRect;
   texto: string;
begin
   mitad := printer.PageWidth div 2;
   ARect := Rect( 0, 0, ftsmain.imglogo.Picture.Bitmap.Width * 5, ftsmain.imglogo.Picture.bitmap.Height * 5 );
   printer.Canvas.StretchDraw( arect, ftsmain.imglogo.Picture.bitmap );
   texto := dm.xlng( 'Pagina: ' + inttostr( pagina ) );
   ancho := printer.canvas.TextWidth( texto );
   printer.canvas.TextOut( printer.PageWidth - ancho, 50, texto );
   inc( pagina );
   printer.canvas.Font.Size := 16;
   printer.canvas.Font.Style := [ fsbold ];
   ancho := printer.canvas.TextWidth( g_empresa );
   printer.Canvas.TextOut( mitad - ( ancho div 2 ), 50, g_empresa );
   printer.canvas.Font.Size := 8;
   printer.canvas.Font.Style := [ ];
   if tipo = 1 then
      texto := dm.xlng( 'INVENTARIO DE ' + ytitulo.Caption )
   else
      texto := dm.xlng( 'INVENTARIO DE ' + tab.Tabs[ tab.TabIndex ] );
   ancho := printer.canvas.TextWidth( texto );
   printer.Canvas.Rectangle( mitad - ( ancho div 2 ) - 5, 280, mitad + ( ancho div 2 ) + 5, 395 );
   printer.Canvas.TextOut( mitad - ( ancho div 2 ), 290, texto );
   texto := formatdatetime( 'YYYY/MM/DD', now );
   ancho := printer.canvas.TextWidth( texto );
   printer.canvas.textout( printer.PageWidth - ancho, 290, texto );
   if tipo = 1 then
   begin
      printer.canvas.textout( 300, 400, dm.xlng( 'Clase' ) );
      printer.canvas.textout( 500, 400, dm.xlng( 'Libreria' ) );
      printer.canvas.textout( 1000, 400, dm.xlng( 'Componente' ) );
   end;
   printer.canvas.textout( 50, printer.PageHeight - 100, 'svw-ftsinventario-1' );
   texto := dm.xlng( 'SysViewSoftSCM' );
   ancho := printer.canvas.TextWidth( texto );
   printer.Canvas.textout( printer.PageWidth - ancho, printer.PageHeight - 100, texto );
end;

procedure Tftsinventario.totales;
begin

   iy := iy + 200;
   printer.canvas.Rectangle( 500 + 350, iy, 500 + 600, iy + 100 );
   printer.canvas.textout( 500 + 450, iy + 5, inttostr( query.RecordCount ) );
end;

procedure Tftsinventario.bimprimirClick( Sender: TObject );
var
   i: integer;
begin
   if PrintDialog1.Execute then
   begin
      pagina := 1;
      printer.Orientation := poPortrait;
      printer.BeginDoc;
      lin := 0;
      query.First;
      i := 0;
      while not query.Eof do
      begin
         if lin mod 50 = 0 then
         begin // Totales
            if i > 0 then
            begin
               totales;
               printer.NewPage;
            end;
            inc( i );
            titulos( 1 );
         end;
         iy := 100 * ( lin mod 50 ) + 500;
         bitmap.canvas.Brush.color := clwhite;
         bitmap.Canvas.FillRect( rect( 0, 0, 100, 100 ) );
         dm.imgclases.GetBitmap( dm.lclases.IndexOf( query.fieldbyname( 'clase' ).asstring ), bitmap );
         printer.Canvas.StretchDraw( rect( 100, iy, 200, iy + 100 ), bitmap );
         printer.Canvas.TextOut( 300, iy, query.fieldbyname( 'clase' ).asstring );
         printer.Canvas.TextOut( 500, iy, query.fieldbyname( 'libreria' ).asstring );
         printer.Canvas.TextOut( 1000, iy, query.fieldbyname( 'componente' ).asstring );
         printer.canvas.MoveTo( 100, iy );
         printer.Canvas.Lineto( printer.PageWidth - 2, iy );
         lin := lin + 1;
         query.Next;
      end;
      totales;
      printer.EndDoc;
      query.First;
   end;
end;

procedure Tftsinventario.creaweb;
var
   i, j, ii, vm, tocol, total_h: integer;
   xcolor, descripcion, TipoObjeto, texto, SisDespues, arch: string;
   x, x1: Tstringlist;
begin
   vm := 0;
   for i := 0 to high( tt ) do
   begin
      if tt[ i ].columna > vm then
         vm := tt[ i ].columna;
   end;

   x := Tstringlist.create;
   x1 := Tstringlist.create;
   x.Add( '<HTML>' );
   x1.Add( '<HTML>' );
   x.Add( '<HEAD>' );
   x1.Add( '<HEAD>' );
   x.Add( '<TITLE>SysViewSoft</TITLE>' );
   x1.Add( '<TITLE>SysViewSoft</TITLE>' );
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
   ///x.ADD( '<script src="jquery.js"></script>' );
   ///x.ADD( '<script src="jquery.fixer.js"></script>' );
   ///x.ADD( '<script>' );
   ///x.ADD( '$(document).ready(function() {' );
   ///x.ADD( '$("table").fixer({fixedrows:1,fixedcols:' + IntToStr( vm + 1 ) +
      ///',width:1300,height:400,scrollbarwidth:13});' );
   ///x.ADD( '});' );
   ///x.ADD( '</script>' );
   // SCROLL DE LA TABLA

   x.Add( '</HEAD>' );
   x1.Add( '<TITLE>SysViewSoft</TITLE>' );
   x.Add( '<BODY  Text="#000000" link="#000000" alink= "#FF0000" vlink= "#000000">' );
   x1.Add( '<BODY Text="#000000" link="#000000">' );

   x.Add( '<div ALIGN=MIDDLE ><img width="100" height="30" src="' + g_tmpdir + '\' + WnomLogo + g_ext + '" ALIGN=right>' );
   x1.Add( '<div ALIGN=MIDDLE ><img width="100" height="30" src="' + g_tmpdir + '\' + WnomLogo + g_ext + '" ALIGN=right>' );

   x.Add( '<font size=1>' + '<b>' + g_empresa + '</b>' + '<font>' );
   x1.Add( '<font size=1>' + '<b>' + g_empresa + '</b>' + '<font>' );
   texto := dm.xlng( 'INVENTARIO DE COMPONENTES: ' + tab.Tabs[ tab.TabIndex ] );
   Xtexto := texto;
   x.Add( '<p><font size=1 >' + '<b>' + texto + '</b>' + '</font></p>' );
   x1.Add( '<p><font size=1 >' + '<b>' + texto + '</b>' + '</font></p>' );

   x.Add( '<TABLE id="tabla_inventario" cellspacing="1" BORDER="3">' );
   x1.Add( '<TABLE id="tabla_inventario" cellspacing="1" BORDER="3">' );
   x.Add( '<TR>' );
   x1.Add( '<TR>' );
   tocol := -1;
   for i := 0 to 2 do
   begin
      x.add( '<TH bgcolor="#A9D0F5" NOWRAP><FONT FACE="verdana" size="2">' + stitulo[ i ] + '</font></TH>' );
      x1.add( '<TH bgcolor="#A9D0F5" NOWRAP><FONT FACE="verdana" size="2">' + stitulo[ i ] + '</font></TH>' );
      tocol := tocol + 1;
   end;

   if vaux3 > 0 then
   begin
      while tocol < vm do
      begin
         x.add( '<TH bgcolor="#A9D0F5">&nbsp;</TH>' );
         x1.add( '<TH bgcolor="#A9D0F5">&nbsp;</TH>' );
         tocol := tocol + 1;
      end;
   end;

   i := vm + 1;
   while i < dg.ColCount do
   begin
      if dm.sqlselect( dm.q1, 'select * from tsclase where cclase=' + g_q + stitulo[ i ] + g_q ) then
      begin
         descripcion := dm.q1.fieldbyname( 'descripcion' ).AsString;
         TipoObjeto := dm.q1.fieldbyname( 'objeto' ).AsString;
      end;
      x.add( '<TH bgcolor="#A9D0F5" NOWRAP><FONT FACE="verdana" size="2"><A style="color:#000000" HREF=#enc' +
         stitulo[ i ] + ' TITLE="' + descripcion + ' - ' + TipoObjeto + '">' + stitulo[ i ] + '</A></font></TH>' );
      x1.add( '<TH bgcolor="#A9D0F5" NOWRAP><FONT FACE="verdana" size="2"><A style="color:#000000" HREF=#enc' +
         stitulo[ i ] + ' TITLE="' + descripcion + ' - ' + TipoObjeto + '">' + stitulo[ i ] + '</A></font></TH>' );
      tocol := tocol + 1;
      i := i + 1;
   end;
   x.add( '<TH bgcolor="#A9D0F5" NOWRAP><FONT FACE="verdana" size="2">Totales</A></font></TH>' );
   x1.add( '<TH bgcolor="#A9D0F5" NOWRAP><FONT FACE="verdana" size="2">Totales</A></font></TH>' );
   tocol := tocol + 1;
   for i := 0 to high( tt ) do
   begin
      total_h := 0;
      tocol := 0;
      x.add( '</TR>' );
      x1.add( '</TR>' );
      x.add( '<TR>' );
      x1.add( '<TR>' );
      for ii := 0 to tt[ i ].columna - 1 do
      begin
         if tt[ i ].columna > 0 then
         begin
            if tt[ i ].sistema = '-- Totales' then
            begin
               x.add( '<TD bgcolor="#A9D0F5"> &nbsp;</TD>' );
               x1.add( '<TD bgcolor="#A9D0F5"> &nbsp;</TD>' );
               tocol := tocol + 1;
            end
            else
            begin
               x.add( '<TD> &nbsp;</TD>' );
               x1.add( '<TD> &nbsp;</TD>' );
               tocol := tocol + 1;
            end;
         end;
      end;
      if tt[ i ].sistema = '-- Totales' then
      begin
         x.add( '<TD bgcolor="#A9D0F5" NOWRAP><FONT FACE="verdana" size="1">' + tt[ i ].sistema + '</font></TD>' );
         x1.add( '<TD bgcolor="#A9D0F5" NOWRAP><FONT FACE="verdana" size="1">' + tt[ i ].sistema + '</font></TD>' );
         xcolor := '"#A9D0F5"';
         tocol := tocol + 1;
      end
      else
      begin
         x.add( '<TD NOWRAP><FONT FACE="verdana" size="1">' + tt[ i ].sistema + '</font></TD>' );
         x1.add( '<TD NOWRAP><FONT FACE="verdana" size="1">' + tt[ i ].sistema + '</font></TD>' );
         xcolor := '"#A9D0F5"';
         tocol := tocol + 1;
      end;

      for ii := tocol to vm do
      begin
         if trim( tt[ i ].sistema ) = '-- Totales' then
         begin
            x.add( '<TD bgcolor=' + xcolor + '>&nbsp;</TD>' );
            x1.add( '<TD bgcolor=' + xcolor + '>&nbsp;</TD>' );
            tocol := tocol + 1;
         end
         else
         begin
            x.add( '<TD>&nbsp;</TD>' );
            x1.add( '<TD>&nbsp;</TD>' );
            tocol := tocol + 1;
         end;
      end;

      for j := 0 to high( tt[ i ].total ) do
      begin
         if inttostr( tt[ i ].total[ j ] ) = '0' then
         begin
            if trim( tt[ i ].sistema ) = '-- Totales' then
            begin
               x.add( '<TD bgcolor=' + xcolor + '>&nbsp;</TD>' );
               x1.add( '<TD bgcolor=' + xcolor + '>&nbsp;</TD>' );
               tocol := tocol + 1;
            end
            else
            begin
               x.add( '<TD>&nbsp;</TD>' );
               x1.add( '<TD>&nbsp;</TD>' );
               tocol := tocol + 1;
            end
         end
         else
         begin
            total_h := total_h + ( tt[ i ].total[ j ] );
            if trim( tt[ i ].sistema ) = '-- Totales' then
            begin
               x.add( '<TD bgcolor=' + xcolor + ' ALIGN=right><FONT FACE="verdana" size="1">' +
                  inttostr( tt[ i ].total[ j ] ) + '</font></TD>' );
               x1.add( '<TD bgcolor=' + xcolor + ' ALIGN=right><FONT FACE="verdana" size="1">' +
                  inttostr( tt[ i ].total[ j ] ) + '</font></TD>' );
               tocol := tocol + 1;
            end
            else
            begin
               SisDespues := StringReplace( tt[ i ].sistema, ' ', '¿', [ rfReplaceAll ] );
               x.add( '<TD ALIGN=right><FONT FACE="verdana" size="1" ><A HREF=#lin' +
                  SisDespues + '|' + stitulo[ j + 3 + vaux3 ] + '>' + inttostr( tt[ i ].total[ j ] ) + '</A></font></TD>' );
               x1.add( '<TD ALIGN=right><FONT FACE="verdana" size="1"><A HREF=#lin' +
                  SisDespues + '|' + stitulo[ j + 3 + vaux3 ] + '>' + inttostr( tt[ i ].total[ j ] ) + '</A></font></TD>' );
               tocol := tocol + 1;
            end;
         end;
      end;
      if inttostr( total_h ) = '0' then
      begin
         x.add( '<TD bgcolor="#A9D0F5">&nbsp;</TD>' );
         x1.add( '<TD bgcolor="#A9D0F5">&nbsp;</TD>' );
      end
      else
      begin
         x.add( '<TD bgcolor="#A9D0F5"  ALIGN=right><FONT FACE="verdana" size="1">' + inttostr( total_h ) + '</font></TD>' );
         x1.add( '<TD bgcolor="#A9D0F5" ALIGN=right><FONT FACE="verdana" size="1">' + inttostr( total_h ) + '</font></TD>' );
      end;
   end;
   for ii := tocol to vm do
   begin
      x.add( '<TD>&nbsp;</TD>' );
      x1.add( '<TD>&nbsp;</TD>' );
   end;
   x.Add( '</TR>' );
   x1.Add( '</TR>' );
   x.Add( '</TABLE>' );
   x1.Add( '</TABLE>' );
   x.Add( '<script language="JavaScript" type="text/javascript">' );
   x.Add( 'ResaltarFila("tabla_inventario");' );
   x.Add( '</script>' );
   x.ADD( '</div>' );
   x1.ADD( '</div>' );
   x.Add( '</BODY>' );
   x1.Add( '</BODY>' );
   x.Add( '</HTML>' );
   x.Add( '</HTML>' );
   x.savetofile( g_tmpdir + '\Invent' + Wtipop + '.html' );
   arch := g_tmpdir + '\Invent' + Wtipop + '.html';
   g_borrar.Add( arch );
   x1.savetofile( g_tmpdir + '\InventIMP' + Wtipop + '.html' );
   arch := g_tmpdir + '\InventIMP' + Wtipop + '.html';
   g_borrar.Add( arch );
   GrabaArchivo( 'Invent' + Wtipop, g_tmpdir + '\Invent' + Wtipop + '.html' );
   GrabaArchivo( 'InventIMP' + Wtipop, g_tmpdir + '\InventIMP' + Wtipop + '.html' );
   x.free;
   x1.free
end;

procedure Tftsinventario.Crea_Web;
var
   arch: string;
begin
   screen.Cursor := crsqlwait;
   if TraeArchivo( 'Invent' + Wtipop, g_tmpdir + '\Invent' + Wtipop + '.html', g_tmpdir + '\InventIMP' + Wtipop + '.html' ) = FALSE then
      creaweb
   else
   begin
      TraeArchivo( 'InventIMP' + Wtipop, g_tmpdir + '\Invent' + Wtipop + '.html', g_tmpdir + '\InventIMP' + Wtipop + '.html' );
      arch := g_tmpdir + '\Invent' + Wtipop + '.html';
      g_borrar.Add( arch );
      arch := g_tmpdir + '\InventIMP' + Wtipop + '.html';
      g_borrar.Add( arch );
   end;

   web.Navigate( g_tmpdir + '\Invent' + Wtipop + '.html' );
   screen.Cursor := crdefault;
end;

procedure Tftsinventario.WebBeforeNavigate2( Sender: TObject;
   const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
   Headers: OleVariant; var Cancel: WordBool );
var
   j, k: integer;
   b1, b2, b3: string;
begin
   k := pos( '#lin', URL );
   if k > 0 then
   begin
      screen.Cursor := crsqlwait;
      b1 := copy( URL, K + 4, 100 );
      b1 := trim( b1 );
      b1 := StringReplace( b1, '¿', ' ', [ rfReplaceAll ] );
      j := pos( '|', b1 );
      b2 := trim( copy( b1, 1, j - 1 ) );
      b3 := trim( copy( b1, j + 1, 100 ) );
      SisComp := trim( b2 ) + trim( b3 );
      if SisComp <> AntSisComp then
      begin
         AntSisComp := trim( b2 ) + trim( b3 );
         consulta( b2, b3 );
         mnuImprimir.Visible := ivAlways;
         mnuExportar.Visible := ivAlways;
      end;
      cancel := true;
   end;
   screen.Cursor := crdefault;
end;

procedure Tftsinventario.ImpWebClick( Sender: TObject );
begin
   b_impresion := true;
   Web.Navigate( g_tmpdir + '\InventIMP' + Wtipop + '.html' );
end;

procedure Tftsinventario.WebPreviewPrint( web: TWebBrowser );
var
   vin, Vout: OleVariant;
begin
   web.ControlInterface.ExecWB( OLECMDID_PRINTPREVIEW, OLECMDEXECOPT_DONTPROMPTUSER, vin, Vout );
end;

procedure Tftsinventario.BExcelClick( Sender: TObject );
var
   i: integer;
   Libro: _WORKBOOK;
   Hoja: _WORKSHEET;
   num_campos: integer;
begin
   dbgrid1.Visible := false;
   num_campos := query.FieldCount;
   i := 5;
   Libro := ExcelApplication1.Workbooks.Add( Null, 0 );
   Hoja := Libro.Sheets[ 1 ] as _WORKSHEET;
   screen.Cursor := crsqlwait;
   Hoja.Cells.Item[ 2, 1 ] := trim( g_empresa );
   Hoja.Cells.Item[ 2, 1 ].font.size := 16;
   Hoja.Cells.Item[ 3, 1 ] := trim( Xtexto );
   Hoja.Cells.Item[ 3, 1 ].font.size := 14;
   Hoja.Cells.Item[ 4, 1 ] := trim( Xtitulo );
   Hoja.Cells.Item[ 4, 1 ].font.size := 12;
   Hoja.Cells.Item[ i, 1 ] := ' ';
   Hoja.Cells.Item[ i, 2 ] := 'Clase';
   Hoja.Cells.Item[ i, 3 ] := 'Libreria';
   Hoja.Cells.Item[ i, 4 ] := 'Componente';
   if num_campos > 3 then
   begin
      Hoja.Cells.Item[ i, 5 ] := 'Lineas_Total';
      Hoja.Cells.Item[ i, 6 ] := 'Lineas_Efectivas';
      Hoja.Cells.Item[ i, 7 ] := 'Lineas_Blanco';
      Hoja.Cells.Item[ i, 8 ] := 'Lineas_Comentario';
      Hoja.Cells.Item[ i, 5 ].Font.Bold := True;
      Hoja.Cells.Item[ i, 6 ].Font.Bold := True;
      Hoja.Cells.Item[ i, 7 ].Font.Bold := True;
      Hoja.Cells.Item[ i, 8 ].Font.Bold := True;
   end;
   Hoja.Cells.Item[ 2, 1 ].Font.Bold := True;
   Hoja.Cells.Item[ 3, 1 ].Font.Bold := True;
   Hoja.Cells.Item[ 4, 1 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 2 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 3 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 4 ].Font.Bold := True;
   query.First;
   i := i + 1;
   while not query.Eof do
   begin
      i := i + 1;
      Hoja.Cells.Item[ i, 1 ] := ' ';
      Hoja.Cells.Item[ i, 2 ] := query.fieldbyname( 'clase' ).asstring;
      Hoja.Cells.Item[ i, 3 ] := query.fieldbyname( 'libreria' ).asstring;
      Hoja.Cells.Item[ i, 4 ] := query.fieldbyname( 'componente' ).asstring;
      if num_campos > 3 then
      begin
         Hoja.Cells.Item[ i, 5 ] := query.fieldbyname( 'lineas_total' ).asstring;
         Hoja.Cells.Item[ i, 6 ] := query.fieldbyname( 'lineas_efectivas' ).asstring;
         Hoja.Cells.Item[ i, 7 ] := query.fieldbyname( 'lineas_blanco' ).asstring;
         Hoja.Cells.Item[ i, 8 ] := query.fieldbyname( 'lineas_comentario' ).asstring;
      end;

      query.Next;
   end;
   query.First;
   dbgrid1.Visible := true;
   screen.Cursor := crdefault;
   ExcelApplication1.Visible[ 1 ] := true;
end;

procedure Tftsinventario.VistadelComponente1Click( Sender: TObject );
var
   arch: string;
begin
   if dm.trae_fuente( query.FieldByName( 'sistema' ).AsString, query.FieldByName( 'componente' ).AsString,
      query.FieldByName( 'libreria' ).AsString, query.FieldByName( 'clase' ).AsString, ver_componente ) then
   begin
      if pos( chr( 13 ) + chr( 10 ), ver_componente.Text ) = 0 then // corrige cuando el fuente no tiene CR
         ver_componente.Text := stringreplace( ver_componente.Text, chr( 10 ), chr( 13 ) + chr( 10 ), [ rfreplaceall ] );
      arch := trim( query.FieldByName( 'componente' ).AsString );
      bGlbQuitaCaracteres( arch );
      //arch := g_tmpdir + '\' + trim( query.FieldByName( 'componente' ).AsString ) + '.txt';
      arch := g_tmpdir + '\' + arch + '.txt';
      ver_componente.Lines.SaveToFile( arch );
      ShellExecute( 0, 'open', pchar( arch ), nil, PChar( g_tmpdir ), SW_SHOW );
      g_borrar.Add( arch );
   end
   else
   begin
      Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe' ) ),
         pchar( dm.xlng( 'Vista de componentes' ) ), MB_OK );
      exit;
   end;
end;

procedure Tftsinventario.WebDocumentComplete( Sender: TObject;
   const pDisp: IDispatch; var URL: OleVariant );
begin
   screen.Cursor := crdefault;
   try
      if b_impresion then
      begin
         WebPreviewPrint( web );
         Web.Navigate( g_tmpdir + '\Invent' + Wtipop + '.html' );
         b_impresion := false;
      end;
   finally
      gral.PubMuestraProgresBar( False ); //fercar3
   end;
end;

function Tftsinventario.ArmarOpciones( b1: Tstringlist ): Integer;
var
   p, j: integer;
   b2: Tstringlist;
   t, NomProg: string;
   Rect: TRect;
   Control: TWinControl;
   Index: Integer;
   State: TOwnerDrawState;
   tt: Tmenuitem;
   jj, proceso, nombre_proc,
      ttitulo: string;
   mm: Tstringlist;
   l, k, k1, k2: integer;
   ks: string;
begin
   mm := Tstringlist.Create;
   mm.CommaText := bgral;
   if mm.count < 3 then
   begin
      Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
         pchar( dm.xlng( 'Lista opciones ' ) ), MB_OK );
      mm.free;
      exit;
   end;
   //titulo:=Nombre_proc+'  '+mm[0]+' '+mm[1]+' '+mm[2];
   gral.EjecutaOpcionB( b1, 'Inventario de Componentes' );
   mm.free;
end;

{function Tftsinventario.ArmarOpciones(b1:Tstringlist):Integer;
var
   p, j, k: integer;
   b2: Tstringlist;
   t, NomProg: string;
   tt: Tmenuitem;
begin
   bgral := query.fieldbyname( 'clase' ).asstring + ' ' + query.fieldbyname( 'libreria' ).asstring + ' ' +
      query.fieldbyname( 'componente' ).asstring;
   p := b1.Count;
   b2 := Tstringlist.Create;
   for j := 0 to p - 1 do begin
      b2.CommaText := b1[ j ];
      tt := Tmenuitem.Create( pop );
      tt.Caption := stringreplace( b2[ 0 ], '|', ' ', [ rfReplaceAll ] );
      NombreProceso := stringreplace( b2[ 1 ], '|', ' ', [ rfReplaceAll ] );
      pop.Items.Add( tt );
      k := pop.Items.Count - 1;
      if Nombreproceso = 'formadelphi_preview' then begin
         pop.Items[ k ].OnClick := formadelphipreview;
         continue;
      end;
      if Nombreproceso = 'panel_preview' then begin
         pop.Items[ k ].OnClick := panelpreview;
         continue;
      end;
      if Nombreproceso = 'natural_mapa_preview' then begin
         pop.Items[ k ].OnClick := naturalmapapreview;
         continue;
      end;
      if Nombreproceso = 'diagramanatural' then begin
         pop.Items[ k ].OnClick := diagramanatural;
         continue;
      end;
      if Nombreproceso = 'analisis_impacto' then begin
         pop.Items[ k ].OnClick := analisisdeimpacto;
         continue;
      end;
      if Nombreproceso = 'diagramaproceso' then begin
         pop.Items[ k ].OnClick := diagramaproceso;
         continue;
      end;
      if Nombreproceso = 'referencias_cruzadas' then begin
         pop.Items[ k ].OnClick := referenciascruzadas;
         continue;
      end;
      if Nombreproceso = 'reglas_negocio' then begin
         pop.Items[ k ].OnClick := reglasnegocio;
         continue;
      end;
      if Nombreproceso = 'versionado' then begin
         pop.Items[ k ].OnClick := versionado;
         continue;
      end;
      if Nombreproceso = 'fmb_vista_pantalla' then begin
         pop.Items[ k ].OnClick := fmbvistapantalla;
         continue;
      end;
      if Nombreproceso = 'bms_preview' then begin
         pop.Items[ k ].OnClick := bmspreview;
         continue;
      end;
      if Nombreproceso = 'diagramacbl' then begin
         pop.Items[ k ].OnClick := diagramacbl;
         continue;
      end;
      if Nombreproceso = 'dghtml' then begin
         pop.Items[ k ].OnClick := dghtml;
         continue;
      end;
      if Nombreproceso = 'diagramarpg' then begin
         pop.Items[ k ].OnClick := diagramarpg;
         continue;
      end;
      if Nombreproceso = 'tabla_crud' then begin
         pop.Items[ k ].OnClick := tablacrud;
         continue;
      end;
      if Nombreproceso = 'adabas_crud' then begin
         pop.Items[ k ].OnClick := adabascrud;
         continue;
      end;
      if Nombreproceso = 'diagramajcl' then begin
         pop.Items[ k ].OnClick := diagramajcl;
         continue;
      end;
      if Nombreproceso = 'diagramaase' then begin
         pop.Items[ k ].OnClick := diagramaase;
         continue;
      end;
      if Nombreproceso = 'lista_componentes' then begin
         pop.Items[ k ].OnClick := listacomponentes;
         continue;
      end;
      if Nombreproceso = 'propiedades' then begin
         pop.Items[ k ].OnClick := propiedades;
         continue;
      end;
      if Nombreproceso = 'atributos' then begin
         pop.Items[ k ].OnClick := atributos;
         continue;
      end;
      if Nombreproceso = 'Ver_Fuente' then begin
         pop.Items[ k ].OnClick := VerFuente;
         continue;
      end;
   end;
   b2.Free;
end;
}

procedure Tftsinventario.analisisdeimpacto( Sender: TObject );
begin
   {g_Wforma_Aux:='inventario';
   gral.analisis_impacto(Sender);
   g_Wforma_Aux:='';}
end;

procedure Tftsinventario.diagramaproceso( Sender: TObject );
begin
   gral.diagramaproceso( Sender );
   {   gral.diagramaproceso(query.fieldbyname('componente').asstring+' '+
      query.fieldbyname('libreria').asstring+' '+query.fieldbyname('clase').asstring,
      'Inventario de Componentes');
      }
end;

procedure Tftsinventario.formadelphipreview( Sender: TObject );
begin
   //   gral.formadelphi_preview(bgral,'Inventario de Componentes');
   gral.formadelphi_preview( Sender );
end;

procedure Tftsinventario.panelpreview( Sender: TObject );
begin
   //    gral.panel_preview(bgral,'Inventario de Componentes');
   gral.panel_preview( Sender );
end;

procedure Tftsinventario.naturalmapapreview( Sender: TObject );
begin
   //    gral.natural_mapa_preview(bgral,'Inventario de Componentes');
   gral.natural_mapa_preview( Sender );
end;

procedure Tftsinventario.diagramanatural( Sender: TObject );
begin
   //    gral.diagramanatural(bgral,'Inventario de Componentes');
   gral.diagramanatural( Sender );
end;

procedure Tftsinventario.referenciascruzadas( Sender: TObject );
begin
   g_Wforma_Aux := 'inventario';
   gral.referencias_cruzadas( Sender );
   {    gral.referencias_cruzadas(query.fieldbyname('componente').asstring+' '+
       query.fieldbyname('libreria').asstring+' '+query.fieldbyname('clase').asstring,'Inventario de Componentes');
   }
   g_Wforma_Aux := '';
end;

procedure Tftsinventario.reglasnegocio( Sender: TObject );
begin
   //gral.reglas_negocio(Sender);
   gral.Documentacion( Sender );
   {    gral.reglas_negocio(query.fieldbyname('componente').asstring+' '+
      query.fieldbyname('libreria').asstring+' '+query.fieldbyname('clase').asstring,'Inventario de Componentes');
   }
end;

procedure Tftsinventario.versionado( Sender: TObject );
begin
   gral.versionado( Sender );
   {    gral.versionado(query.fieldbyname('componente').asstring+' '+
      query.fieldbyname('libreria').asstring+' '+query.fieldbyname('clase').asstring,'Inventario de Componentes');
   }
end;

procedure Tftsinventario.fmbvistapantalla( Sender: TObject );
begin
   //    gral.fmb_vista_pantalla(bgral,'Inventario de Componentes');
   gral.fmb_vista_pantalla( Sender );
end;

procedure Tftsinventario.bmspreview( Sender: TObject );
begin
   gral.bms_preview( Sender );
   {    gral.bms_preview(query.fieldbyname('componente').asstring+' '+
      query.fieldbyname('libreria').asstring+' '+query.fieldbyname('clase').asstring,'Inventario de Componentes');
   }
end;

procedure Tftsinventario.diagramacbl( Sender: TObject );
begin
   gral.diagramacbl( Sender );
   {    gral.diagramacbl(query.fieldbyname('componente').asstring+' '+
      query.fieldbyname('libreria').asstring+' '+query.fieldbyname('clase').asstring,
      'Inventario de Componentes');
   }
end;

procedure Tftsinventario.dghtml( Sender: TObject );
begin
   //    gral.dghtml(bgral,'Inventario de Componentes');
   gral.dghtml( Sender );
end;

procedure Tftsinventario.diagramarpg( Sender: TObject );
begin
   //    gral.diagramarpg(bgral,'Inventario de Componentes');
   gral.diagramarpg( Sender );
end;

procedure Tftsinventario.tablacrud( Sender: TObject );
begin
   g_Wforma_Aux := 'inventario';
   gral.tabla_crud( Sender );
   {    gral.tabla_crud(query.fieldbyname('componente').asstring+' '+
      query.fieldbyname('libreria').asstring+' '+query.fieldbyname('clase').asstring,
      'Inventario de Componentes');
      g_Wforma_Aux:='';
      }
end;

procedure Tftsinventario.adabascrud( Sender: TObject );
begin
   //    gral.adabas_crud(bgral,'Inventario de Componentes');
   gral.adabas_crud( Sender );
end;

procedure Tftsinventario.diagramajcl( Sender: TObject );
begin
   gral.diagramajcl( Sender );
   {    gral.diagramajcl(query.fieldbyname('componente').asstring+' '+
      query.fieldbyname('libreria').asstring+' '+query.fieldbyname('clase').asstring,'Inventario de Componentes');
   }
end;

procedure Tftsinventario.diagramaase( Sender: TObject );
begin
   gral.diagramaase( Sender );
   {    gral.diagramaase(query.fieldbyname('componente').asstring+' '+
      query.fieldbyname('libreria').asstring+' '+query.fieldbyname('clase').asstring,'Inventario de Componentes');
   }
end;

procedure Tftsinventario.listacomponentes( Sender: TObject );
begin
   g_Wforma_Aux := 'inventario';
   gral.lista_componentes( Sender );
   {   gral.lista_componentes(query.fieldbyname('clase').asstring+' '+
      query.fieldbyname('libreria').asstring+' '+query.fieldbyname('componente').asstring,'Inventario de Componentes');
   }
   g_Wforma_Aux := '';
end;

procedure Tftsinventario.propiedades( Sender: TObject );
begin
   gral.propiedades( Sender );
   {    gral.propiedades(query.fieldbyname('componente').asstring+' '+
      query.fieldbyname('libreria').asstring+' '+query.fieldbyname('clase').asstring,'Inventario de Componentes');
   }
end;

procedure Tftsinventario.atributos( Sender: TObject );
begin
   gral.atributos( Sender );
   {    gral.atributos(query.fieldbyname('componente').asstring+' '+
       query.fieldbyname('libreria').asstring+' '+query.fieldbyname('clase').asstring,'Inventario de Componentes');
}end;

procedure Tftsinventario.VerFuente( Sender: TObject );
begin
   gral.Ver_Fuente( Sender );
   {   gral.atributos(query.fieldbyname('componente').asstring+' '+
      query.fieldbyname('libreria').asstring+' '+query.fieldbyname('clase').asstring,'Inventario de Componentes');
   }
end;

procedure Tftsinventario.GrabaArchivo( clave: string; archivo: string );
var
   blo, magic: string;
begin
   if dm.sqlselect( dm.q1, 'select * from tsutileria ' +
      ' where cutileria=' + g_q + clave + g_q +
      ' and descripcion=' + g_q + 'Inventario de componentes(' + Wtipop + ')' + g_q ) = false then
   begin
      if dm.sqlinsert( 'insert into tsutileria (cutileria,descripcion) values(' +
         g_q + clave + g_q + ',' + g_q + 'Inventario de componentes(' + Wtipop + ')' + g_q + ')' ) = false then
      begin
         Application.MessageBox( pchar( dm.xlng( 'No puede dar de alta en utilerias, el inventario actualizado' ) ),
            pchar( dm.xlng( 'Inventario de componentes' ) ), MB_OK );
         exit;
      end;
   end;
   blo := dm.file2blob( archivo, magic );
   if dm.sqlselect( dm.q1, 'select * from tsutileria ' +
      ' where cutileria=' + g_q + clave + g_q +
      ' and cblob is not null' ) then
   begin
      if dm.sqldelete( 'delete tsblob ' +
         ' where cblob=' + g_q + dm.q1.fieldbyname( 'cblob' ).AsString + g_q ) = false then
      begin
         Application.MessageBox( pchar( dm.xlng( 'No puede actualizar el inventario' ) ),
            pchar( dm.xlng( 'Inventario de componentes' ) ), MB_OK );
         exit;
      end;
   end;
   if dm.sqlupdate( 'update tsutileria set cblob=' + g_q + blo + g_q + ',' +
      ' magic=' + g_q + magic + g_q + ',' +
      ' fecha=' + dm.datedb( formatdatetime( 'YYYY/MM/DD HH:NN:SS', now ), 'YYYY/MM/DD HH24:MI:SS' ) +
      ' where cutileria=' + g_q + clave + g_q ) = false then
   begin
      Application.MessageBox( pchar( dm.xlng( 'No puede actualizar el inventario (BLOB) ' ) ),
         pchar( dm.xlng( 'Inventario de componentes' ) ), MB_OK );
      exit;
   end;
end;

function Tftsinventario.TraeArchivo( clave: string; archivo: string; archivo1: string ): boolean;
var
   nblob, Varch1, Varch2: string;
begin
   if dm.sqlselect( dm.q1, 'select * from tsutileria ' +
      ' where cutileria=' + g_q + clave + g_q +
      ' and cblob is not null' ) then
   begin
      Yfecha := formatdatetime( 'YYYYMMDD', dm.q1.fieldbyname( 'fecha' ).asdatetime );
      if strtoint( Nfecha ) - strtoint( Yfecha ) > 0 then
      begin
         gral.LimpiaInventario;
         TraeArchivo := FALSE;
         exit;
      end
      else
      begin
         { Varch1 := copy(clave,7,20);
            Varch2 := copy(clave,1,9);
            If Varch2 = 'InventIMP' then
               exit;
            case application.MessageBox(pchar(' Inventario de '+trim(Varch1)+
               ', ya fue creado, desea regenerarlo?'),
               'Confirme',MB_YESNO) of
               IDYES: begin
                    gral.LimpiaInventario;
                    TraeArchivo := FALSE;
                    exit;
               end;
               IDNO: begin
                    TraeArchivo := TRUE;
               end;
            end;
         }
      end;
      nblob := dm.q1.fieldbyname( 'cblob' ).AsString;
      dm.blob2file( nblob, archivo );
      g_borrar.Add( archivo );
      TraeArchivo := TRUE;
   end
   else
   begin
      TraeArchivo := FALSE;
   end;
end;

procedure Tftsinventario.DBGrid1CellClick( Column: TColumn );
var
   b1: string;
   Y: integer;
begin
   b1 := query.fieldbyname( 'componente' ).asstring + ' ' + query.fieldbyname( 'libreria' ).asstring + ' ' +
      query.fieldbyname( 'clase' ).asstring;
   if b1 = '' then
      exit;
   bgral := stringreplace( trim( b1 ), '|', ' ', [ rfReplaceAll ] );
   Opciones := gral.ArmarMenuConceptualWeb( b1, 'inventario' );
   Y := ArmarOpciones( Opciones );
   gral.PopGral.Popup( g_X, g_Y );
   b1 := '';
   screen.Cursor := crdefault;
end;

procedure Tftsinventario.FormClose( Sender: TObject;
   var Action: TCloseAction );
begin
   if FormStyle = fsMDIChild then
      Action := caFree;
   gral.BorraRutinasjs( );
   gral.BorraLogo( WnomLogo + g_ext );
end;

procedure Tftsinventario.FormDestroy( Sender: TObject );
begin
   dm.PubEliminarVentanaActiva( Caption );

   if gral.iPubVentanasActivas in [ 0, 1 ] then
      gral.PubExpandeMenuVentanas( False );
end;

procedure Tftsinventario.WebProgressChange( Sender: TObject; Progress,
   ProgressMax: Integer );
begin
   ytitulo.Caption := '';
   mnuImprimir.Visible := ivNever;
   mnuExportar.Visible := ivNever;
   dg.Refresh;
   gral.PubAvanzaProgresBar; //fercar3

end;

procedure Tftsinventario.mnuImprimirClick( Sender: TObject );
var
   i: integer;
begin
   if PrintDialog1.Execute then
   begin
      pagina := 1;
      printer.Orientation := poPortrait;
      printer.BeginDoc;
      lin := 0;
      query.First;
      i := 0;
      while not query.Eof do
      begin
         if lin mod 50 = 0 then
         begin // Totales
            if i > 0 then
            begin
               totales;
               printer.NewPage;
            end;
            inc( i );
            titulos( 1 );
         end;
         iy := 100 * ( lin mod 50 ) + 500;
         bitmap.canvas.Brush.color := clwhite;
         bitmap.Canvas.FillRect( rect( 0, 0, 100, 100 ) );
         dm.imgclases.GetBitmap( dm.lclases.IndexOf( query.fieldbyname( 'clase' ).asstring ), bitmap );
         printer.Canvas.StretchDraw( rect( 100, iy, 200, iy + 100 ), bitmap );
         printer.Canvas.TextOut( 300, iy, query.fieldbyname( 'clase' ).asstring );
         printer.Canvas.TextOut( 500, iy, query.fieldbyname( 'libreria' ).asstring );
         printer.Canvas.TextOut( 1000, iy, query.fieldbyname( 'componente' ).asstring );
         printer.canvas.MoveTo( 100, iy );
         printer.Canvas.Lineto( printer.PageWidth - 2, iy );
         lin := lin + 1;
         query.Next;
      end;
      totales;
      printer.EndDoc;
      query.First;
   end;
end;

procedure Tftsinventario.mnuExportarClick( Sender: TObject );
var
   i: integer;
   Libro: _WORKBOOK;
   Hoja: _WORKSHEET;
   num_campos: integer;
begin
   dbgrid1.Visible := false;
   num_campos := query.FieldCount;
   i := 5;
   Libro := ExcelApplication1.Workbooks.Add( Null, 0 );
   Hoja := Libro.Sheets[ 1 ] as _WORKSHEET;
   screen.Cursor := crsqlwait;
   Hoja.Cells.Item[ 2, 1 ] := trim( g_empresa );
   Hoja.Cells.Item[ 2, 1 ].font.size := 16;
   Hoja.Cells.Item[ 3, 1 ] := trim( Xtexto );
   Hoja.Cells.Item[ 3, 1 ].font.size := 14;
   Hoja.Cells.Item[ 4, 1 ] := trim( Xtitulo );
   Hoja.Cells.Item[ 4, 1 ].font.size := 12;
   Hoja.Cells.Item[ i, 1 ] := ' ';
   Hoja.Cells.Item[ i, 2 ] := 'Clase';
   Hoja.Cells.Item[ i, 3 ] := 'Libreria';
   Hoja.Cells.Item[ i, 4 ] := 'Componente';
   if num_campos > 3 then
   begin
      Hoja.Cells.Item[ i, 5 ] := 'Lineas_Total';
      Hoja.Cells.Item[ i, 6 ] := 'Lineas_Efectivas';
      Hoja.Cells.Item[ i, 7 ] := 'Lineas_Blanco';
      Hoja.Cells.Item[ i, 8 ] := 'Lineas_Comentario';
      Hoja.Cells.Item[ i, 5 ].Font.Bold := True;
      Hoja.Cells.Item[ i, 6 ].Font.Bold := True;
      Hoja.Cells.Item[ i, 7 ].Font.Bold := True;
      Hoja.Cells.Item[ i, 8 ].Font.Bold := True;
   end;
   Hoja.Cells.Item[ 2, 1 ].Font.Bold := True;
   Hoja.Cells.Item[ 3, 1 ].Font.Bold := True;
   Hoja.Cells.Item[ 4, 1 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 2 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 3 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 4 ].Font.Bold := True;
   query.First;
   i := i + 1;
   while not query.Eof do
   begin
      i := i + 1;
      Hoja.Cells.Item[ i, 1 ] := ' ';
      Hoja.Cells.Item[ i, 2 ] := query.fieldbyname( 'clase' ).asstring;
      Hoja.Cells.Item[ i, 3 ] := query.fieldbyname( 'libreria' ).asstring;
      Hoja.Cells.Item[ i, 4 ] := query.fieldbyname( 'componente' ).asstring;
      if num_campos > 3 then
      begin
         Hoja.Cells.Item[ i, 5 ] := query.fieldbyname( 'lineas_total' ).asstring;
         Hoja.Cells.Item[ i, 6 ] := query.fieldbyname( 'lineas_efectivas' ).asstring;
         Hoja.Cells.Item[ i, 7 ] := query.fieldbyname( 'lineas_blanco' ).asstring;
         Hoja.Cells.Item[ i, 8 ] := query.fieldbyname( 'lineas_comentario' ).asstring;
      end;

      query.Next;
   end;
   query.First;
   dbgrid1.Visible := true;
   screen.Cursor := crdefault;
   ExcelApplication1.Visible[ 1 ] := true;
end;

procedure Tftsinventario.FormDeactivate( Sender: TObject );
begin
   gral.PopGral.Items.Clear;
end;

function Tftsinventario.FormHelp( Command: Word; Data: Integer;
   var CallHelp: Boolean ): Boolean;
begin
   PR_BARRA;
   try
      HtmlHelp( Application.Handle,
         PChar( Format( '%s::/T%5.5d.htm',
         //[Application.HelpFile,ActiveControl.HelpContext])),HH_DISPLAY_TOPIC, 0);
         [ Application.HelpFile, IDH_TOPIC_T01400 ] ) ), HH_DISPLAY_TOPIC, 0 );
      CallHelp := False;
   except
      Application.MessageBox( 'No existe ayuda para la pantalla ó campo seleccionado', 'Ayuda ', MB_OK );
   end;
end;

procedure Tftsinventario.FormKeyDown( Sender: TObject; var Key: Word;
   Shift: TShiftState );
begin
   //iHelpContext:=ActiveControl.HelpContext;
   iHelpContext := HTML_HELP.IDH_TOPIC_T01400;
end;

end.

