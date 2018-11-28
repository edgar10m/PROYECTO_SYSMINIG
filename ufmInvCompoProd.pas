unit ufmInvCompo;

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
   ADODB, ExtCtrls, Grids, Buttons, cxSplitter;

type
   TGrid = record
      clase: string;
      cantidad: array of integer;
   end;

type
   TfmInvCompo = class( TfmSVSLista )
      tab: TTabControl;
      ImageList2: TImageList;
      query: TADOQuery;
      DataSource1: TDataSource;
      Panel1: TPanel;
      grdDatos2: TcxGrid;
      grdDatos2DBTableView1: TcxGridDBTableView;
      grdDatos2Level1: TcxGridLevel;
      ytitulo: TPanel;
      stbLista2: TdxStatusBar;
      dxComponentPrinterLink2: TdxGridReportLink;
      cxSplitter1: TcxSplitter;
      mnuSistema: TdxBarCombo;
      function ArmarOpciones( b1: Tstringlist ): Integer;
      procedure FormCreate( Sender: TObject );
      procedure FormClose( Sender: TObject; var Action: TCloseAction );
      procedure FormDeactivate( Sender: TObject );
      procedure tabChange( Sender: TObject );
      procedure grdDatosDBTableView1DblClick( Sender: TObject );
      procedure grdDatos2DBTableView1DblClick( Sender: TObject );
      procedure grdDatosEnter( Sender: TObject );
      procedure grdDatos2Enter( Sender: TObject );
      procedure mnuImprimirClick( Sender: TObject );
      procedure mnuVistaPreliminarClick( Sender: TObject );
      procedure mnuPaginaConfClick( Sender: TObject );
      procedure mnuExportarExcelClick( Sender: TObject );
      procedure mnuExportarTextoDelimitadoClick( Sender: TObject );
      procedure grdDatosDBTableView1FocusedRecordChanged(
         Sender: TcxCustomGridTableView; APrevFocusedRecord,
         AFocusedRecord: TcxCustomGridRecord;
         ANewItemRecordFocusingChanged: Boolean );
      procedure mnuSistemaChange( Sender: TObject );
      procedure mnuSistemaClick( Sender: TObject );
   private
      { Private declarations }
      tidentificados, texistentes, tfaltantes, tsinuso, tactivos: string; // , tsinusoexistent, Xtexto,tt_existentesW1
      SisComp, AntSisComp: string;
      Xtitulo: string;
      tt_existentes, tt_identificados, tt_faltantes,
         tt_faltantesW1, tt_sin_uso, tt_activos, tt_W1: string;
      Opciones: Tstringlist;
      WnomLogo: string;
      Wfecha: string;
      Yfecha, Nfecha: string; //

      aPriClases: array of string;
      aPriSistemas: array of string;
      aGblPriSistemas: array of string;
      aPriGrid: array of TGrid;
      nGridFoco: Integer;
      sSistema, sSistema1: string;

      sPriOpcion: String;

      procedure subsistemas( oficina: string; sistema: string; columna: integer );
      procedure totaliza;
      procedure consulta( sistema: string; tipo: string );
      procedure creaweb;
      procedure query_cuenta( query: string );
   public
      { Public declarations }
      titulo: string;
      procedure TabInicio;

   end;

var
   fmInvCompo: TfmInvCompo;

implementation

uses ptsdm, ptsgral, pbarra, uListaRutinas, uConstantes;

{$R *.dfm}

type
   TcxGridColumnHeaderViewInfoAccess = class( TcxGridColumnHeaderViewInfo );

procedure TfmInvCompo.creaweb;
var
   i, j: integer;
   sPass: string;
   slDatos: Tstringlist;
   nTotal: Integer;
begin
   sPass := '';
   gral.PubMuestraProgresBar( True );
   screen.Cursor := crsqlwait;

   try
      slDatos := Tstringlist.create;
      slDatos.Delimiter := ',';

      sPass := sPass + 'Clase:String:200,';

      for i := 0 to Length( aPriSistemas ) - 1 do
         sPass := sPass + aPriSistemas[ i ] + ':Integer:0,';

      sPass := sPass + 'Total:Integer:0';

      slDatos.Add( sPass );
      sPass := '';
      nTotal := 0;

      for i := 0 to Length( aPriGrid ) - 1 do begin
         if dm.sqlselect( dm.q2, 'Select cclase, descripcion from tsclase where cclase =' + g_q + aPriGrid[ i ].clase + g_q ) then begin
            sPass := sPass + '"' + dm.q2.fieldbyname( 'cclase' ).AsString + ' - ' +
               UpperCase( dm.q2.fieldbyname( 'descripcion' ).AsString ) + '",';
         end;

         for j := 0 to Length( aPriSistemas ) - 1 do begin
            sPass := sPass + '"' + IntToStr( aPriGrid[ i ].cantidad[ j ] ) + '",';
            nTotal := nTotal + ( aPriGrid[ i ].cantidad[ j ] );
         end;

         sPass := sPass + '"' + IntToStr( nTotal ) + '"';
         slDatos.Add( sPass );
         sPass := '';
         nTotal := 0;
      end;
      {
        if tabDatos.Active then //fercar
          tabDatos.Active := False;
       }

      tabDatos.Fields.Clear;

      GlbQuitarFiltrosGrid( grdDatosDBTableView1 );
      if bGlbPoblarTablaMem( slDatos, tabDatos ) then begin
         tabDatos.ReadOnly := True;
         GlbHabilitarOpcionesMenu( mnuPrincipal, tabDatos.RecordCount > 0 );
         mnuSistema.Enabled := True;

         GlbCrearCamposGrid( grdDatosDBTableView1 );

         grdDatosDBTableView1.ApplyBestFit( );
         //         lbltotal.Caption := 'Total: ' + inttostr( grdDatosDBTableView1.DataController.RecordCount );

         //         bPriCambio := true;

                  //necesario para la busqueda //fercar
                  //en este caso usar grEspejo para apoyarse en las busquedas y llenar slPublista
         GlbCrearCamposGrid( grdEspejoDBTableView1 );
         GlbCargarLista( grdEspejo, grdEspejoDBTableView1, slPubLista );
         //fin necesario para la busqueda

         for i := 2 to grdDatosDBTableView1.ColumnCount - 1 do
            GlbTotalCol( grdDatosDBTableView1, i, i, true );

         stbLista.Panels[ 0 ].Text := IntToStr( tabDatos.RecordCount ) + ' Registros';

         if Visible = True then
            GlbFocusPrimerItemGrid( grdDatos, grdDatosDBTableView1 );
      end;
   finally
      SetLength( aPriGrid, 0 );
      aPriGrid := nil;

      SetLength( aPriGrid, Length( aPriClases ) );

      for i := 0 to Length( aPriGrid ) - 1 do
         SetLength( aPriGrid[ i ].cantidad, Length( aPriSistemas ) );

      for i := 0 to length( aPriSistemas ) - 1 do
         aPriGrid[ i ].clase := aPriClases[ i ];

      for i := 0 to length( aPriClases ) - 1 do
         aPriGrid[ i ].clase := aPriClases[ i ];

      gral.PubMuestraProgresBar( false );
      screen.Cursor := crdefault;
   end;
end;

procedure TfmInvCompo.FormCreate( Sender: TObject );
var
   j, i: integer;
   Wuser, ProdClase, lwLista, lwInSQL, lwSale: string;
   m: tStringlist;
begin
   inherited;

   screen.cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );

   try
      caption := titulo;

      if g_language = 'ENGLISH' then begin
         tidentificados := 'IDENTIFIED';
         texistentes := 'EXIST';
         tfaltantes := 'MISSING';
         tsinuso := 'UNUSED';
         tactivos := 'ACTIVE';
      end
      else begin
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

      tab.TabIndex := -1;

      gral.CargaRutinasjs( );
      Wfecha := formatdatetime( 'YYYYMMDDHHNNSSZZZZ', now );
      WnomLogo := 'IN' + g_usuario;
      gral.CargaLogo( WnomLogo );

      Wuser := 'ADMIN'; //Temporal  JCR

      if dm.sqlselect( dm.q1, 'select * from parametro where clave=' +
         g_q + 'CLASESXPRODUCTO' + g_q ) then
         ProdClase := dm.q1.fieldbyname( 'dato' ).AsString;
      lwSale := 'FALSE';

      while lwSale = 'FALSE' do begin
         if ProdClase <> 'TRUE' then begin
            if dm.sqlselect( dm.q1, 'select distinct hcclase from tsrela ' +
               ' where hcclase in (select cclase from tsclase where objeto=' + g_q + 'FISICO' + g_q +
               ' and estadoactual=' + g_q + 'ACTIVO' + g_q + ')' +
               ' order by hcclase' ) then begin
               i := 1;
               while not dm.q1.Eof do begin
                  SetLength( aPriClases, i );
                  aPriClases[ i - 1 ] := dm.q1.fieldbyname( 'hcclase' ).AsString;
                  i := i + 1;
                  dm.q1.Next;
               end;
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
            end;
         end;
      end;


      {

              if dm.sqlselect(dm.q1, 'select * from tsoficina order by coficina') then begin // Oficinas
                if dm.sqlselect(dm.q2, 'select * from tssistema ' + // Sistemas
                  ' where coficina=' + g_q + dm.q1.fieldbyname('coficina').AsString + g_q +
                  ' and cdepende' + g_is_null +
                  ' and estadoactual=' + g_q + 'ACTIVO' + g_q +

                  ' order by csistema') then begin

                  SetLength(aPriSistemas, dm.q2.RecordCount);
                  SetLength(aPriGrid, Length(aPriClases));

                  for i := 0 to Length(aPriGrid) - 1 do
                    SetLength(aPriGrid[i].cantidad, Length(aPriSistemas));

                  for i := 0 to length(aPriClases) - 1 do
                    aPriGrid[i].clase := aPriClases[i];

                  i := 0;
                  while not dm.q2.Eof do begin
                    aPriSistemas[i] := dm.q2.fieldbyname('csistema').AsString; //arreglo sistemas
                    Inc(i);
                    subsistemas(dm.q1.fieldbyname('coficina').AsString,
                      dm.q2.fieldbyname('csistema').AsString, 3);
                    dm.q2.Next;
                  end;
                end;

                dm.q1.Next;
              end;

             //------------------  ADAPTACIONES PARA LAS CLASES FISICAS y VIRTUALES.

              tt_W1 := 'select hcclase,sistema,count(*) total from tsrela' +
                ' group by hcclase, sistema ' +
                ' order by 1,2';

              tt_identificados := 'select hcclase,sistema,count(*) total from  ' +
                ' (select distinct hcclase,sistema,hcbib,hcprog from tsrela  ' +
                ' where  sistema in( select csistema from tssistema where estadoactual = ' + g_q + 'ACTIVO' + g_q + ')) ' +
                '       group by hcclase, sistema order by 1,2 ';

              tt_existentes := ' select hcclase,sistema,count(*) total from TSRELA where lineafinal> 0 ' +
                ' and sistema in( select csistema from tssistema where estadoactual = ' + g_q + 'ACTIVO' + g_q +
                ' )group by hcclase,sistema  union ' +
                ' select cclase,sistema,count(*) from tsprog  where sistema in ' +
                ' ( select csistema from tssistema where estadoactual = ' + g_q + 'ACTIVO' + g_q + ')' +
                ' group by cclase ,sistema order by 1,2';

              tt_activos := ' select hcclase,sistema ,count(*) total from ' +
                ' (  select distinct hcclase,sistema,hcbib,hcprog from tsrela' +
                ' where ((((pcclase,pcbib,pcprog) in (select cclase,cbib,cprog from tsprog))' +
                '  or ((hcprog = ocprog) and (hcbib= ocbib)) )' +
                ' and pcclase <> ' + g_q + 'CLA' + g_q + ' and hcbib <> ' + g_q + 'SCRATCH' + g_q +
                ' and sistema in( select csistema from tssistema where estadoactual = ' + g_q + 'ACTIVO' + g_q + ') ' +
                ')) group by sistema,hcclase order by 1,2';

               tt_faltantes := 'select  hcclase,sistema,count(*) total '+
                  ' from (select distinct hcclase,sistema,hcbib,hcprog from tsrela where (sistema,hcclase,hcbib,hcprog) not in ' +
                  ' (select distinct sistema,hcclase,hcbib,hcprog from TSRELA where lineafinal> 0 ' +
                  '  union  ' +
                  ' select sistema,cclase,cbib,cprog from tsprog ))'+
                  ' where sistema in( select csistema from tssistema where estadoactual ='  + g_q +'ACTIVO'+g_q+
                   ') group by hcclase,sistema' ;

              tt_faltantesW1 := 'select hcclase,sistema,count(*) total from tsrela ' +
                ' group by hcclase,sistema ' +
                ' order by 1,2';

               tt_sin_uso := '  select hcclase, sistema, count(*) total from  ' +
                ' (  select distinct hcclase,sistema,hcbib,hcprog from tsrela ' +
                ' where (((((hcclase,hcbib,hcprog) not  in (select cclase,cbib,cprog from tsprog)) ' +
                '             and ((pcclase,pcbib,pcprog) not  in (select cclase,cbib,cprog from tsprog)) )' +
                ' and pcclase <> ' + g_q + 'CLA' + g_q + '  and hcbib <> ' + g_q + 'SCRATCH' + g_q + ' ) ' +
                ' and  ((hcprog <> ocprog) and (hcbib<> ocbib))) ' +
                ' and sistema in( select csistema from tssistema where estadoactual = ' + g_q + 'ACTIVO' + g_q + ' ) ' +
                ' )   group by sistema,hcclase order by 1,2';
       }
          //---------------------------------------------------------------------------------------------------
   finally
      gral.PubMuestraProgresBar( false );
      screen.Cursor := crdefault;
   end;
end;

procedure TfmInvCompo.query_cuenta( query: string );
var
   i, ii, jj: integer;
   sClase: string;
begin
   screen.cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );

   try
      if dm.sqlselect( dm.q1, query ) then begin
         while not dm.q1.Eof do begin
            ii := -1;
            jj := -1;
            //sSistema := (dm.q1.fieldbyname('sistema').AsString);

            for i := 0 to length( aPriClases ) - 1 do begin
               /////if (tab.TabIndex = 2) then //or (tab.TabIndex = 3) then
                  /////sClase := (dm.q1.fieldbyname( 'cclase' ).AsString)
               /////else
               sClase := ( dm.q1.fieldbyname( 'hcclase' ).AsString );

               if AnsiMatchStr( sClase, aPriClases[ i ] ) then begin
                  ii := i;
                  Break;
               end;
            end;

            //            if ii = -1 then
            //               Application.MessageBox( pchar( 'No se encontro la clase '+sClase+' en TSPRODUCTOS' ),
            //               pchar( sLISTA_INV_COMPO ), MB_OK )
            //            else

            if ii > -1 then
               for i := 0 to length( aPriSistemas ) - 1 do

                  if AnsiMatchStr( sSistema1, aPriSistemas[ i ] ) then
                     jj := i;

            if ( ii >= 0 ) and ( jj >= 0 ) then
               aPriGrid[ ii ].cantidad[ jj ] := ( dm.q1.fieldbyname( 'total' ).AsInteger );

            dm.q1.Next;
         end;
      end;
   finally
      gral.PubMuestraProgresBar( false );
      screen.Cursor := crdefault;
   end;
end;

procedure TfmInvCompo.subsistemas( oficina, sistema: string;
   columna: integer );
var
   qq: TADOQuery;
begin
   screen.cursor := crsqlwait;
   try
      qq := TADOQuery.Create( self );
      qq.Connection := dm.ADOConnection1;

      if dm.sqlselect( qq, 'select * from tssistema ' + // Subsistemas
         ' where coficina=' + g_q + oficina + g_q +
         ' and cdepende=' + g_q + sistema + g_q +
         ' and estadoactual=' + g_q + 'ACTIVO' + g_q +
         ' order by csistema' ) then begin
         while not qq.Eof do begin
            subsistemas( qq.fieldbyname( 'coficina' ).AsString,
               qq.fieldbyname( 'csistema' ).AsString, columna + 1 );
            qq.Next;
         end;
      end;
   finally
      qq.free;
      screen.Cursor := crdefault;
   end;
end;

procedure TfmInvCompo.totaliza;
var
   i: integer;
   vSistema: string;
   sComando: String;
begin
   screen.cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try
      AntSisComp := '';

      if dm.sqlselect( dm.q1, 'select * from tsoficina order by coficina' ) then begin // Oficinas
         if dm.sqlselect( dm.q2, 'select * from tssistema ' + // Sistemas
            ' where coficina=' + g_q + dm.q1.fieldbyname( 'coficina' ).AsString + g_q +
            ' and cdepende' + g_is_null +
            ' and estadoactual=' + g_q + 'ACTIVO' + g_q +

            ' order by csistema' ) then begin

            SetLength( aPriGrid, Length( aPriClases ) );

            if mnuSistema.ItemIndex < 0 then begin ///temporal JCR
               SetLength( aPriSistemas, mnuSistema.Items.Count - 1 );
               for i := 0 to mnuSistema.Items.Count - 1 do begin
                  if i = 0 then

                  else
                     aPriSistemas[ i - 1 ] := mnuSistema.items[ i ];
               end;
            end
            else begin
               SetLength( aPriSistemas, 1 );
               aPriSistemas[ 0 ] := mnuSistema.items[ mnuSistema.ItemIndex ];
            end;

            for i := 0 to Length( aPriGrid ) - 1 do
               SetLength( aPriGrid[ i ].cantidad, Length( aPriSistemas ) );

            for i := 0 to length( aPriClases ) - 1 do
               aPriGrid[ i ].clase := aPriClases[ i ];

            i := 0;
            {   while not dm.q2.Eof do begin
                 aPriSistemas[i] := dm.q2.fieldbyname('csistema').AsString; //arreglo sistemas
                 Inc(i);
                 subsistemas(dm.q1.fieldbyname('coficina').AsString,
                   dm.q2.fieldbyname('csistema').AsString, 3);
                 dm.q2.Next;
               end;
             }

         end;

         dm.q1.Next;
      end;

      //------------------  ADAPTACIONES PARA LAS CLASES FISICAS y VIRTUALES.

      if sSistema <> '' then
         vSistema := sSistema
      else begin
         mnuSistema.SetFocus;
         exit;
      end;
  {
       if sSistema <> '' then begin
         if mnuSistema.ItemIndex < 0 then begin
            sComando := ' EXECUTE INVENTARIO_TOTAL' ;
            dm.sqlselect( dm.q1,sComando );
         end
         else
           scomando := ' EXECUTE GENERA_INVENTARIO (' +  sSistema + ', ' + g_q + 'DESCRIPCION' + g_q + ')' ;
           dm.sqlselect( dm.q1,sComando);

      end;
   }
      //dm.qmodify.ExecSQL;


           tt_W1 := 'select hcclase,sistema,count(*) total from tsrela' +
              ' group by hcclase, sistema ' +
              ' order by 1,2';

           tt_identificados := 'select hcclase,sistema,count(*) total from  ' +
              ' (select distinct hcclase,sistema,hcbib,hcprog from tsrela where sistema in( ' + sSistema + ' )) ' +
              '       group by hcclase, sistema order by 1,2 ';

           tt_existentes := ' select hcclase,sistema,count(*) total from TSRELA where lineafinal> 0 ' +
              ' and sistema in( ' + sSistema +
              ' )group by hcclase,sistema  union ' +
              ' select cclase,sistema,count(*) from tsprog  where sistema in ' +
              ' ( ' + sSistema + ')' +
              ' group by cclase ,sistema order by 1,2';

           tt_activos := ' select hcclase,sistema ,count(*) total from ' +
              ' (  select distinct hcclase,sistema,hcbib,hcprog from tsrela' +
              ' where ((((pcclase,pcbib,pcprog) in (select cclase,cbib,cprog from tsprog))' +
              '  or ((hcprog = ocprog) and (hcbib= ocbib)) )' +
              ' and pcclase <> ' + g_q + 'CLA' + g_q + ' and hcbib <> ' + g_q + 'SCRATCH' + g_q +
              ' and sistema in( ' + sSistema + ') ' +
              ')) group by sistema,hcclase order by 1,2';

           tt_faltantes := 'select  hcclase,sistema,count(*) total ' +
              ' from (select distinct hcclase,sistema,hcbib,hcprog from tsrela where (sistema,hcclase,hcbib,hcprog) not in ' +
              ' (select distinct sistema,hcclase,hcbib,hcprog from TSRELA where lineafinal> 0 ' +
              '  union  ' +
              ' select sistema,cclase,cbib,cprog from tsprog ))' +
              ' where sistema in( ' + sSistema + ') group by hcclase,sistema';

           tt_faltantesW1 := 'select hcclase,sistema,count(*) total from tsrela ' +
              ' group by hcclase,sistema ' +
              ' order by 1,2';

           tt_sin_uso := '  select hcclase, sistema, count(*) total from  ' +
              ' (  select distinct hcclase,sistema,hcbib,hcprog from tsrela ' +
              ' where (((((hcclase,hcbib,hcprog) not  in (select cclase,cbib,cprog from tsprog)) ' +
              '             and ((pcclase,pcbib,pcprog) not  in (select cclase,cbib,cprog from tsprog)) )' +
              ' and pcclase <> ' + g_q + 'CLA' + g_q + '  and hcbib <> ' + g_q + 'SCRATCH' + g_q + ' ) ' +
              ' and  ((hcprog <> ocprog) and (hcbib<> ocbib))) ' +
              ' and sistema in( ' + sSistema + ' ) ' +
              ' )   group by sistema,hcclase order by 1,2';


           //---------------------------------------------------------------------------------------------------

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
            pchar( dm.xlng( sLISTA_INV_COMPO ) ), MB_OK );



   finally
      gral.PubMuestraProgresBar( false );
      creaweb;
      screen.Cursor := crdefault;
   end;
end;

procedure TfmInvCompo.FormClose( Sender: TObject; var Action: TCloseAction );
begin
   inherited;

   gral.BorraRutinasjs( );
   gral.BorraLogo( WnomLogo + g_ext );
end;

procedure TfmInvCompo.FormDeactivate( Sender: TObject );
begin
   inherited;

   gral.PopGral.Items.Clear;

end;

procedure TfmInvCompo.tabChange( Sender: TObject );
   function bExisteSistema( pSistema: string ): Boolean;
   var
      i: integer;
   begin
      bExisteSistema := False;
      if pSistema = '' then begin
         bExisteSistema := False;
      end
      else begin
         for i := 0 to length( aGblPriSistemas ) - 1 do begin
            if AnsiMatchStr( pSistema, aGblPriSistemas[ i ] ) then begin
               bExisteSistema := True;
               exit;
            end;
         end;
      end;
   end;

begin
   try
      if not bExisteSistema( mnuSistema.Text ) then begin
         Application.MessageBox( 'Sistema incorrecto', 'Aviso', MB_OK );
         Exit;
      end;

      if Trim( mnuSistema.Text ) = '- Selecconar Sistema -' then begin
         Application.MessageBox( 'Seleccione un Sistema', 'Aviso', MB_OK );
         Exit;
      end;

      if Trim( mnuSistema.Text ) = '' then begin
         Application.MessageBox( 'Seleccione un Sistema', 'Aviso', MB_OK );
         Exit;
      end;

      ytitulo.Caption := '';
      totaliza;

      sPriOpcion := tab.Tabs.Strings[ tab.TabIndex ];
      stbLista.Panels[ 1 ].Text := 'Sistema: ' + mnuSistema.Text + ' - ' + tab.Tabs.Strings[ tab.TabIndex ];
   finally
      tab.TabIndex := -1;
   end;
end;

procedure TfmInvCompo.consulta( sistema, tipo: string );
var
   descripcion, TipoObjeto, nquery, nselect, nselect1, nselect2, nwhere, nwhere1, nwhere2, nwhere3, nfrom: string;
   i: Integer;
begin
   screen.cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );

   try
      if dm.sqlselect( dm.q1, 'select * from tsclase where cclase=' + g_q + tipo + g_q ) then begin
         descripcion := dm.q1.fieldbyname( 'descripcion' ).AsString;
         TipoObjeto := dm.q1.fieldbyname( 'objeto' ).AsString;
      end;

      //ytitulo.Caption := tab.Tabs[ tab.TabIndex ] + ' - ' + sistema + ' - ' + tipo + '(' + descripcion + ') Tipo Objeto - ' + TipoObjeto;
      ytitulo.Caption := sPriOpcion + ' - ' + sistema + ' - ' + tipo + '(' + descripcion + ') Tipo Objeto - ' + TipoObjeto;
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
         '         and  x.hcprog  = t.cprog ),0) LINEAS_COMENTARIO , x.hsistema OTRO_SISTEMA ';

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
         '         and  x.cprog  = t.cprog ),0) LINEAS_COMENTARIO , x.hsistema OTRO_SISTEMA';

      nselect2 := 'select x.sistema,x.hcclase CLASE,x.hcbib LIBRERIA ,x.hcprog COMPONENTE,  ' +
         ' x.hsistema OTRO_SISTEMA';

      //if tab.Tabs[ tab.TabIndex ] = texistentes then begin
      if sPriOpcion = texistentes then begin
         nfrom := ' from  ( select sistema,hcclase,hcbib,hcprog,hsistema  from TSRELA where lineafinal> 0 ' +
            ' and sistema in( ' + sSistema + ' ) union ' +
            ' select sistema,cclase,cbib,cprog,sistema from tsprog  where sistema in ' +
            ' ( ' + sSistema + ' )) x';
      end;

      if sPriOpcion = tactivos then begin
         nfrom := '  from (  select distinct hcclase,sistema,hcbib,hcprog,hsistema from tsrela' +
            ' where ((((pcclase,pcbib,pcprog) in (select cclase,cbib,cprog from tsprog))' +
            '  or ((hcprog = ocprog) and (hcbib= ocbib)) )' +
            ' and pcclase <> ' + g_q + 'CLA' + g_q + ' and hcbib <> ' + g_q + 'SCRATCH' + g_q +
            ' and sistema in( ' + sSistema + ' ))' +
            ') x ';
      end;

      if sPriOpcion = tsinuso then begin
         nfrom := '  from  ' +
            ' (  select distinct hcclase,sistema,hcbib,hcprog,hsistema from tsrela ' +
            ' where (((((hcclase,hcbib,hcprog) not  in (select cclase,cbib,cprog from tsprog)) ' +
            '             and ((pcclase,pcbib,pcprog) not  in (select cclase,cbib,cprog from tsprog)) )' +
            ' and pcclase <> ' + g_q + 'CLA' + g_q + '  and hcbib <> ' + g_q + 'SCRATCH' + g_q + ' ) ' +
            ' and  ((hcprog <> ocprog) and (hcbib<> ocbib))) ' +
            ' and sistema in( ' + sSistema + ' ) ' + ' )  x ';
      end;

      if sPriOpcion = tidentificados then begin
         nfrom := ' from  ' +
            ' (select distinct hcclase,sistema,hcbib,hcprog,hsistema from tsrela  ' +
            ' where  sistema in( ' + sSistema + ' ) ' + ') x ';
      end;

      if sPriOpcion = tfaltantes then begin
         nfrom :=
            ' from ( select distinct sistema,hcclase,hcbib,hcprog,hsistema from tsrela where ' +
            ' (sistema,hcclase,hcbib,hcprog) not in ' +
            ' (select distinct sistema,hcclase,hcbib,hcprog from TSRELA where lineafinal> 0 ' +
            ' and  sistema in( ' + sSistema + ' )' +
            '  union  select sistema,cclase,cbib,cprog from tsprog where sistema ' +
            ' in( ' + sSistema + '  ))) x';
      end;

      nwhere := ' where x.sistema = ' + g_q + sistema + g_q +
         '   and x.hcclase = ' + g_q + tipo + g_q +
         ' order by 3,2 ';

      nwhere1 := ' where x.sistema = ' + g_q + sistema + g_q +
         '    and x.cclase = ' + g_q + tipo + g_q +
         ' order by 3,2 ';

      nwhere2 := ' where x.sistema = ' + g_q + sistema + g_q +
         '    and x.hcclase = ' + g_q + tipo + g_q +
         '    and ((x.sistema = hsistema) or (x.hsistema IS Null) or (x.hsistema = ' + g_q + ' ' + g_q + ')) ' +
         ' order by 3,2 ';

      /////if ( tab.Tabs[ tab.TabIndex ] = tsinuso ) then /////or   ( tab.Tabs[ tab.TabIndex ] = tactivos ) then
          /////nquery := nselect1 + ' ' +  nfrom + ' ' + nwhere1
       /////else

      if ( sPriOpcion = texistentes ) then
         nquery := nselect + ' ' + nfrom + ' ' + nwhere2
      else if ( sPriOpcion = tfaltantes ) then
         nquery := nselect2 + ' ' + nfrom + ' ' + nwhere
      else
         nquery := nselect + ' ' + nfrom + ' ' + nwhere;

      query.SQL.Add( nquery );

      PR_BARRA;

      query.Open;

      GlbCrearCamposGrid( grdDatos2DBTableView1 );

      with grdDatos2DBTableView1 do // Cambiar  al validar que algun componentes es de otro sistema
         for i := 0 to grdDatos2DBTableView1.ColumnCount - 1 do
            if ( Columns[ i ].DataBinding.FieldName = 'OTRO_SISTEMA' ) then
               Columns[ i ].Visible := True;

      grdDatos2DBTableView1.ApplyBestFit( );
      stbLista2.Panels[ 0 ].Text := IntToStr( query.RecordCount ) + ' Registros';

      if Visible = True then
         GlbFocusPrimerItemGrid( grdDatos2, grdDatos2DBTableView1 );
   finally
      gral.PubMuestraProgresBar( false );
      screen.Cursor := crdefault;
   end;
end;

procedure TfmInvCompo.grdDatosDBTableView1DblClick( Sender: TObject );
var
   lsClase: string;
   lsSistema: string;
   sDescripcion: String;
   i: integer;
begin
   inherited;

   screen.cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );

   try
      {      if ( grdDatosDBTableView1.Controller.FocusedColumn.Index < 2 ) or
               ( grdDatosDBTableView1.Controller.FocusedColumn.Index >=
               grdDatosDBTableView1.ColumnCount - 1 )
               then
               exit;
      }
            //lsClase := aPriClases[ grdDatosDBTableView1.Controller.FocusedRecord.Index ];

      if ( grdDatosDBTableView1.Controller.FocusedColumn.Index = grdDatosDBTableView1.ColumnCount - 1 )
         or ( grdDatosDBTableView1.Controller.FocusedColumn.Index = 0 ) Then
         Exit;

      sDescripcion := tabDatos.FieldByName( 'clase' ).AsString;
      lsClase := Trim( Copy( sDescripcion, 1, pos( '-', sDescripcion ) - 1 ) );

      //      sSistema := aPriSistemas[ 0 ]; //juanita provisional
      lsSistema := aPriSistemas[ ( grdDatosDBTableView1.Controller.FocusedColumn.Index ) - 1 ];
      SisComp := trim( lsSistema ) + trim( lsClase );

      if SisComp <> AntSisComp then begin
         AntSisComp := trim( lsSistema ) + trim( lsClase );

         GlbQuitarFiltrosGrid( grdDatos2DBTableView1 );
         consulta( lsSistema, lsClase );
      end;
   finally
      gral.PubMuestraProgresBar( false );
      screen.Cursor := crdefault;
   end;
end;

procedure TfmInvCompo.grdDatos2DBTableView1DblClick( Sender: TObject );
var
   b1: string;
begin
   inherited;

   screen.cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );

   try
      b1 := query.fieldbyname( 'componente' ).asstring + ' ' + query.fieldbyname( 'libreria' ).asstring + ' ' +
         query.fieldbyname( 'clase' ).asstring + ' ' + query.fieldbyname( 'sistema' ).asstring;

      if b1 = '' then
         exit;

      bgral := stringreplace( trim( b1 ), '|', ' ', [ rfReplaceAll ] );
      Opciones := gral.ArmarMenuConceptualWeb( b1, 'inventario' );
      ArmarOpciones( Opciones );
      gral.PopGral.Popup( g_X, g_Y );
      b1 := '';
   finally
      gral.PubMuestraProgresBar( True );
      screen.Cursor := crdefault;
   end;
end;

function TfmInvCompo.ArmarOpciones( b1: Tstringlist ): Integer;
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
            pchar( dm.xlng( 'Lista opciones ' ) ), MB_OK );
         mm.free;
         exit;
      end;

      gral.EjecutaOpcionB( b1, sLISTA_INV_COMPO );
   finally
      mm.free;
      gral.PubMuestraProgresBar( True );
      screen.Cursor := crdefault;
   end;
end;

procedure TfmInvCompo.TabInicio;
var
   i: integer;
begin
   if dm.sqlselect( dm.q1, 'Select * from tssistema where estadoactual = ' + g_q + 'ACTIVO' + g_q ) then begin
      mnuSistema.Items.Clear;
      // mnuSistema.Items.Add( '- Todos los sistemas -' ); //temporal JCR

      while not dm.q1.Eof do begin
         mnuSistema.Items.Add( dm.q1.fields[ 0 ].asstring );
         dm.q1.Next;
      end;
      SetLength( aGblPriSistemas, mnuSistema.Items.Count );
      for i := 0 to mnuSistema.Items.Count - 1 do begin
         aGblPriSistemas[ i ] := mnuSistema.items[ i ];
      end;

   end;

   GlbHabilitarOpcionesMenu( mnuPrincipal, mnuSistema.Items.Count > 0 );

   //totaliza;
end;

procedure TfmInvCompo.grdDatosEnter( Sender: TObject );
begin
   inherited;

   nGridFoco := 1;
end;

procedure TfmInvCompo.grdDatos2Enter( Sender: TObject );
begin
   inherited;

   nGridFoco := 2;
end;

procedure TfmInvCompo.mnuImprimirClick( Sender: TObject );
begin
   if nGridFoco = 2 then begin
      grdDatos2Level1.Caption := ytitulo.Caption;
      dxComponentPrinterLink2.Component := grdDatos2;
      dxComponentPrinterLink2.PrinterPage.PageHeader.CenterTitle.Clear;
      dxComponentPrinterLink2.PrinterPage.PageHeader.CenterTitle.Add( Caption );
      dxComponentPrinterLink2.PrinterPage.PageFooter.LeftTitle.Clear;
      dxComponentPrinterLink2.PrinterPage.PageFooter.LeftTitle.Add( g_usuario ); //fercar
      dxComponentPrinterLink2.Print( True, nil );
      grdDatos2Level1.Caption := '';
      exit;
   end;

   inherited;

end;

procedure TfmInvCompo.mnuVistaPreliminarClick( Sender: TObject );
begin
   if nGridFoco = 2 then begin
      grdDatos2Level1.Caption := ytitulo.Caption;
      dxComponentPrinterLink2.Component := grdDatos2;
      dxComponentPrinterLink2.PrinterPage.PageHeader.CenterTitle.Clear;
      dxComponentPrinterLink2.PrinterPage.PageHeader.CenterTitle.Add( Caption );
      dxComponentPrinterLink2.PrinterPage.PageFooter.LeftTitle.Clear;
      dxComponentPrinterLink2.PrinterPage.PageFooter.LeftTitle.Add( g_usuario ); //fercar
      dxComponentPrinterLink2.Preview( True );
      grdDatos2Level1.Caption := '';
      exit;
   end;

   inherited;

end;

procedure TfmInvCompo.mnuPaginaConfClick( Sender: TObject );
begin
   if nGridFoco = 2 then begin
      dxComponentPrinterLink2.PageSetup;
      exit;
   end;

   inherited;

end;

procedure TfmInvCompo.mnuExportarExcelClick( Sender: TObject );
var
   sNombreArchivo, sCaption: string;
begin
   if nGridFoco = 2 then begin
      sCaption := ytitulo.Caption;

      bGlbQuitaCaracteres( sCaption );
      sNombreArchivo := sGlbExportarListaDialogo( exExcel, grdDatos2, sCaption );

      if sNombreArchivo = '' then
         Exit;

      ExportGrid4ToExcel( sNombreArchivo, grdDatos2, True, True, True, 'xls' );

      if ShellExecute( Handle, nil, pchar( sNombreArchivo ), nil, nil, SW_SHOW ) <= 32 then
         Application.MessageBox( pchar( dm.xlng( 'No puede ejecutar ' + sNombreArchivo ) ),
            pchar( dm.xlng( 'Error' ) ), MB_ICONEXCLAMATION );

      exit;
   end;

   inherited;

end;

procedure TfmInvCompo.mnuExportarTextoDelimitadoClick( Sender: TObject );
var
   sNombreArchivo, sCaption: string;
begin
   if nGridFoco = 2 then begin
      sCaption := ytitulo.Caption;

      bGlbQuitaCaracteres( sCaption );
      sNombreArchivo := sGlbExportarListaDialogo( exTexto, grdDatos2, sCaption );

      if sNombreArchivo = '' then
         Exit;

      ExportGrid4ToText( sNombreArchivo, grdDatos2, True, True, ',', '"', '"' );

      if ShellExecute( Handle, nil, pchar( sNombreArchivo ), nil, nil, SW_SHOW ) <= 32 then
         Application.MessageBox( pchar( dm.xlng( 'No puede ejecutar ' + sNombreArchivo ) ),
            pchar( dm.xlng( 'Error' ) ), MB_ICONEXCLAMATION );

      exit;
   end;

   inherited;

end;

procedure TfmInvCompo.grdDatosDBTableView1FocusedRecordChanged(
   Sender: TcxCustomGridTableView; APrevFocusedRecord,
   AFocusedRecord: TcxCustomGridRecord;
   ANewItemRecordFocusingChanged: Boolean );
begin
   inherited;

   query.Close;
end;

procedure TfmInvCompo.mnuSistemaChange( Sender: TObject );
var
   n, i: integer;
   c, cc: string;
begin
   inherited;
   //if mnuSistema.ItemIndex < 1 then begin  //Temporal JCR
   if mnuSistema.ItemIndex < 0 then begin
      for n := 1 to mnuSistema.Items.Count - 1 do begin
         c := mnuSistema.items[ n ];
         if n = 1 then
            cc := c
         else
            cc := cc + '?' + c;
      end;
      cc := stringreplace( cc, '?', g_q + ',' + g_q, [ rfreplaceall ] );
      sSistema := g_q + cc + g_q;
   end
   else begin
      sSistema := g_q + mnuSistema.Text + g_q;
      sSistema1 := mnuSistema.Text;
   end;

end;

procedure TfmInvCompo.mnuSistemaClick( Sender: TObject );
begin
   inherited;

   If mnuSistema.text = '' then
      Application.MessageBox( 'Seleccionar Sistema ', 'Aviso', MB_OK );

end;

end.

