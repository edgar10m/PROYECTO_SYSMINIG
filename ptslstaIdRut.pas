unit ptsListaIdentada;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls, Grids, ADODB, printers,
   OleServer, ComObj, ExcelXP, Menus, OleCtrls, SHDocVw, dxBar, HTML_HELP,
  Excel97;

type
   Txx = record
      nivel : integer;
      clase: string;
      bib: string;
      nombre: string;
      modo: string;
      organizacion: string;
      externo: string;
      coment: string;
      existe: boolean;
      uso: integer;
   end;
type
   Ttotal = record
      clase: string;
      total: integer;
   end;
   private
      { Private declarations }
      clases: Tstringlist;
      clasesexiste: Tstringlist;
      xx: Tstringlist;
      loc1, loc2: Tstringlist;
      tt: array of Ttotal;
      bitmap: Tbitmap;
      lin, iy: integer;
      dgClase, dgLibreria, dgcomponente, dgModo, dgOrganizacion, dgExterno,
         dgComentario, dgExiste, dgusadopor, dgtotal: string;
      excluyemenu: Tstringlist;
      b_impresion: boolean;
      Opciones: Tstringlist;
      g_nivel: Integer;
      procedure leecompos( compo: string; bib: string; clase: string );
      function agrega_compo( qq: Tadoquery ): boolean;

   public
      { Public declarations }
      titulo: string;
      procedure arma( clase: string; bib: string; nombre: string );
   end;

var
   Wprog, Wbib, Wclase: String;
   x: array of Txx;
   f_top: integer;
   f_left: integer;
   WnomLogo: string;
   Wfecha: string;
   W_nomcomponente: string;


implementation
uses ptsdm, ptsmain, ptsgral, QRCtrls;
{$R *.dfm}


procedure TftsListaIdentada.arma( clase: string; bib: string; nombre: string );
begin
   gral.PubMuestraProgresBar( True );
   bgral := clase+' '+bib+' '+nombre;
   try
      if nombre = 'SCRATCH' then
         abort;
          lstcomponenteClick( lstcomponente );
      end;
   finally
      gral.PubMuestraProgresBar( False );
   end;
end;

procedure TftsListaIdentada.FormCreate( Sender: TObject );
begin

   clases := Tstringlist.Create;
   clasesexiste := Tstringlist.Create;
   xx := Tstringlist.Create;
   loc1 := Tstringlist.Create;
   loc2 := Tstringlist.Create;
   bitmap := Tbitmap.Create;


/////   if dm.sqlselect( dm.q1, 'select unique hcclase from tsrela , tsclase where cclase = hcclase and estadoactual =' +
/////        g_q + 'ACTIVO' + g_q + ' and hcbib <> '+g_q+'BD'+g_q+' order by hcclase') then begin

   if dm.sqlselect( dm.q1, 'select unique hcclase from tsrela , tsclase where cclase = hcclase and estadoactual =' +
        g_q + 'ACTIVO' + g_q + ' order by hcclase') then begin


      while not dm.q1.Eof do begin
         clases.Add( dm.q1.fieldbyname( 'hcclase' ).AsString );
         dm.q1.Next;
      end;
   end;

   clasesexiste.AddStrings( clases );
{
   clases.Add( 'FIL' );
   clases.Add( 'TAB' );
   clases.Add( 'INS' );
   clases.Add( 'DEL' );
   clases.Add( 'UPD' );
   clases.Add( 'UTI' );
   clases.Add( 'STE' );
   clases.Add( 'PNL' ); // panel de IDEAL
   clases.Add( 'DVW' ); // Dataview de IDEAL-DATACOM
 }
   excluyemenu := Tstringlist.Create;
   if dm.sqlselect( dm.q1, 'select dato from parametro where clave=' + g_q + 'EXCLUYEMENU' + g_q ) then begin
      while not dm.q1.Eof do begin
         excluyemenu.Add( dm.q1.fieldbyname( 'dato' ).AsString );
         dm.q1.Next;
      end;
   end;
   Wfecha := formatdatetime( 'YYYYMMDDHHMMSSZZZZ', now );

end;


function TftsListaIdentada.agrega_compo( qq: Tadoquery ): boolean;
var
   cc, mensaje: string;
   i, k, n: integer;
begin
   cc := qq.FieldByName( 'hcprog' ).AsString + '|' +
      qq.FieldByName( 'hcbib' ).AsString + '|' +
      qq.FieldByName( 'hcclase' ).AsString;
   xx.Add( cc );
   k := length( x );
   setlength( x, k + 1 );
   mensaje := 'x='+inttostr(k);
   g_log.Add( mensaje );
   g_log.SaveToFile( g_tmpdir + '\sysviewlog');
   x[ k ].nivel :=  g_nivel;
   x[ k ].nombre := qq.FieldByName( 'hcprog' ).AsString;
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
   if qq.FieldByName( 'hcclase' ).AsString = 'FIL' then begin
      n := loc1.IndexOf( qq.FieldByName( 'externo' ).AsString );
      if n > -1 then
         x[ k ].organizacion := loc2[ n ];
   end;

   agrega_compo := true;
end;

procedure TftsListaIdentada.leecompos( compo: string; bib: string; clase: string );
var
   qq: Tadoquery;
   nuevo: boolean;
begin
   qq := Tadoquery.Create( self );
   qq.Connection := dm.ADOConnection1;

   if dm.sqlselect( qq, 'select * from tsrela ' +
      ' where pcprog=' + g_q + compo + g_q +
      ' and   pcbib=' + g_q + bib + g_q +
      ' and   pcclase=' + g_q + clase + g_q ) then begin
       while not qq.Eof do begin
         if clases.IndexOf( qq.FieldByName( 'hcclase' ).AsString ) > -1 then  begin
           g_nivel := g_nivel + 1 ;
           nuevo := agrega_compo( qq );

         end else begin
            nuevo := true;
         end;

         if nuevo and ( excluyemenu.IndexOf( qq.fieldbyname( 'hcprog' ).AsString ) = -1 ) then begin

          leecompos( qq.FieldByName( 'hcprog' ).AsString,
               qq.FieldByName( 'hcbib' ).AsString,
               qq.FieldByName( 'hcclase' ).AsString );
         end;
         if qq.FieldByName( 'hcclase' ).AsString = 'LOC' then begin
            loc1.Insert( 0, uppercase( qq.fieldbyname( 'externo' ).AsString ) );
            loc2.insert( 0, qq.fieldbyname( 'organizacion' ).AsString );
         end;
         qq.Next;
      end;

   end;
   g_nivel := g_nivel -1 ;

   if g_nivel < 0 then
      g_nivel := 1;

   qq.Free;
end;


procedure TftsListaIdentada.lstcomponenteClick( Sender: TObject );
var
   i, k: integer;
   ant: string;
begin
   g_procesa := true;
   if lstcomponente.ItemIndex = -1 then begin
      g_procesa := false;
      exit;
   end;
   gral.PubMuestraProgresBar( True );
   screen.Cursor := crsqlwait;
   try
      setlength( x, 0 );
      xx.Clear;
      loc1.Clear;
      loc2.Clear;
      if dm.sqlselect( dm.q1, 'select * from tsrela ' +
         ' where hcprog=' + g_q + lstcomponente.Items[ lstcomponente.itemindex ] + g_q +
         ' and   hcbib=' + g_q + cmblibreria.Text + g_q +
         ' and   hcclase=' + g_q + cmbclase.Text + g_q ) then begin
         agrega_compo( dm.q1 );
         leecompos( dm.q1.FieldByName( 'hcprog' ).AsString,
            dm.q1.FieldByName( 'hcbib' ).AsString,
            dm.q1.FieldByName( 'hcclase' ).AsString );

         Wprog := lstcomponente.Items[ lstcomponente.itemindex ];
         Wbib := cmblibreria.Text;
         Wclase := cmbclase.Text;
         bgral:= cmbclase.Text+' '+cmblibreria.Text+' '+lstcomponente.Items[ lstcomponente.itemindex ];

         CreaWeb;
      end;
   finally
      screen.Cursor := crdefault;
      gral.PubMuestraProgresBar( False );
   end;

end;

procedure TftsListaIdentada.lstcomponenteClickSistema( sistema: string );
var
   i, k: integer;
   ant: string;
begin
   screen.Cursor := crsqlwait;
   setlength( x, 0 );
   xx.Clear;
   loc1.Clear;
   loc2.Clear;
   if dm.sqlselect( dm.q1, 'select * from tsrela ' +
      ' where sistema =' + g_q + sistema + g_q ) then begin
      agrega_compo( dm.q1 );
      leecompos( dm.q1.FieldByName( 'pcprog' ).AsString,
         dm.q1.FieldByName( 'pcbib' ).AsString,
         dm.q1.FieldByName( 'pcclase' ).AsString );
      CreaWeb;
   end;
   dgt.RowCount := 1;
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
         dgt.RowCount := dgt.RowCount + 1;
      end;
      inc( tt[ k ].total );
   end;
   screen.Cursor := crdefault;
end;

procedure TftsListaIdentada.bexportarClick( Sender: TObject );
var
   i: integer;
   lis: Tstringlist;
   exis, salida: string;
begin
   salida := cmbclase.Text + '_' + cmblibreria.Text + '_' + lstcomponente.Items[ lstcomponente.itemindex ] +
      formatdatetime( 'YYYYMMDDHHMISS', now ) + '.csv';
   savedialog1.FileName := salida;
   if savedialog1.Execute = false then
      exit;
   if fileexists( savedialog1.FileName ) then begin
      if application.MessageBox( 'El archivo existe, desea reemplazarlo?',
         'Confirme', MB_YESNO ) = IDNO then
         exit;
   end;
   lis := Tstringlist.Create;
   for i := 0 to length( x ) - 1 do begin
      if x[ i ].existe then
         exis := '1'
      else
         exis := '0';
      lis.Add(
         inttostr(x[ i ].nivel) + ',' +
         x[ i ].clase + ',' +
         x[ i ].bib + ',' +
         x[ i ].nombre + ',' +
         x[ i ].modo + ',' +
         x[ i ].organizacion + ',' +
         x[ i ].externo + ',' +
         x[ i ].coment + ',' +
         exis + ',' +
         inttostr( x[ i ].uso ) );
   end;
   lis.SaveToFile( savedialog1.FileName );
   lis.Free;
end;

procedure TftsListaIdentada.bexportarExcelClick( Sender: TObject );
var
   i, ii: integer;
   exis, salida: string;
   Libro: _WORKBOOK;
   Hoja: _WORKSHEET;

begin
   i := 5;
   Libro := ExcelApplication1.Workbooks.Add( Null, 0 );
   Hoja := Libro.Sheets[ 1 ] as _WORKSHEET;

   Hoja.Cells.Item[ 1, 2 ] := g_empresa;
   Hoja.Cells.Item[ 1, 2 ].font.size := 8;
   Hoja.Cells.Item[ 2, 2 ] := 'Lista de Componentes:'+bgral;
   Hoja.Cells.Item[ 2, 2 ].font.size := 8;
   Hoja.Cells.Item[ i, 1 ] := ' ';
   Hoja.Cells.Item[ i, 2 ] := 'Nivel';
   Hoja.Cells.Item[ i, 3 ] := 'Clase';
   Hoja.Cells.Item[ i, 4 ] := 'Libreria';
   Hoja.Cells.Item[ i, 4 ] := 'Componente';
   Hoja.Cells.Item[ i, 5 ] := 'Modo';
   Hoja.Cells.Item[ i, 7 ] := 'Organización';
   Hoja.Cells.Item[ i, 8 ] := 'Externo';
   Hoja.Cells.Item[ i, 9 ] := 'Comentario';
   Hoja.Cells.Item[ i, 10 ] := 'Existe';
   //Hoja.Cells.Item[ i, 10 ] := 'Usado Por';
   Hoja.Cells.Item[ 2, 2 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 1 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 2 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 3 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 4 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 5 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 6 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 7 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 8 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 9 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 10 ].Font.Bold := True;
   salida := ' ';
   i := i + 1;
   while salida = ' ' Do begin
      for ii := 0 to length( x ) - 1 do begin
         if x[ ii ].existe then
            exis := '1'
         else
            exis := '0';
         i := i + 1;
         Hoja.Cells.Item[ i, 1 ] := ' ';
         Hoja.Cells.Item[ i, 2 ] := x[ ii ].nivel;
         Hoja.Cells.Item[ i, 3 ] := x[ ii ].clase;
         Hoja.Cells.Item[ i, 3 ] := x[ ii ].bib;
         Hoja.Cells.Item[ i, 5 ] := x[ ii ].nombre;
         Hoja.Cells.Item[ i, 6 ] := x[ ii ].modo;
         Hoja.Cells.Item[ i, 7 ] := x[ ii ].organizacion;
         Hoja.Cells.Item[ i, 8 ] := x[ ii ].externo;
         Hoja.Cells.Item[ i, 9 ] := x[ ii ].coment;
         Hoja.Cells.Item[ i, 10 ] := exis;
         //Hoja.Cells.Item[ i, 10 ] := inttostr( x[ ii ].uso );
      end;
      salida := 'salir';
   end; //while
   ExcelApplication1.Visible[ 1 ] := true;
end;

procedure TftsListaIdentada.webProgressChange(Sender: TObject; Progress,
  ProgressMax: Integer);
begin
   gral.PubAvanzaProgresBar;  
end;

procedure TftsListaIdentada.mnuExportaClick(Sender: TObject);
var
   i, ii: integer;
   exis, salida: string;
   Libro: _WORKBOOK;
   Hoja: _WORKSHEET;

begin
   i := 5;
   Libro := ExcelApplication1.Workbooks.Add( Null, 0 );
   Hoja := Libro.Sheets[ 1 ] as _WORKSHEET;

   Hoja.Cells.Item[ 1, 2 ] := g_empresa;
   Hoja.Cells.Item[ 1, 2 ].font.size := 10;
   Hoja.Cells.Item[ 2, 2 ] := 'Lista de Componentes : '+ bgral;
   Hoja.Cells.Item[ 2, 2 ].font.size := 10;
   Hoja.Cells.Item[ i, 1 ] := ' ';
   Hoja.Cells.Item[ i, 2 ] := 'Nivel';
   Hoja.Cells.Item[ i, 3 ] := 'Clase';
   Hoja.Cells.Item[ i, 4 ] := 'Libreria';
   Hoja.Cells.Item[ i, 5 ] := 'Componente';
   Hoja.Cells.Item[ i, 6 ] := 'Modo';
   Hoja.Cells.Item[ i, 7 ] := 'Organización';
   Hoja.Cells.Item[ i, 8 ] := 'Externo';
   Hoja.Cells.Item[ i, 9 ] := 'Comentario';
   Hoja.Cells.Item[ i, 10 ] := 'Existe';
   //Hoja.Cells.Item[ i, 10 ] := 'Usado Por';
   Hoja.Cells.Item[ 1, 2 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 1 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 2 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 3 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 4 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 5 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 6 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 7 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 8 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 9 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 10 ].Font.Bold := True;
   salida := ' ';
   i := i + 1;
   while salida = ' ' Do begin
      for ii := 0 to length( x ) - 1 do begin
         if x[ ii ].existe then
            exis := '1'
         else
            exis := '0';
         i := i + 1;
         Hoja.Cells.Item[ i, 1 ] := ' ';
         Hoja.Cells.Item[ i, 2 ] := x[ ii ].nivel;
         Hoja.Cells.Item[ i, 3 ] := x[ ii ].clase;
         Hoja.Cells.Item[ i, 4 ] := x[ ii ].bib;
         Hoja.Cells.Item[ i, 5 ] := x[ ii ].nombre;
         Hoja.Cells.Item[ i, 6 ] := x[ ii ].modo;
         Hoja.Cells.Item[ i, 7 ] := x[ ii ].organizacion;
         Hoja.Cells.Item[ i, 8 ] := x[ ii ].externo;
         Hoja.Cells.Item[ i, 9 ] := x[ ii ].coment;
         Hoja.Cells.Item[ i, 10 ] := exis;
      end;
      salida := 'salir';
   end; //while
   ExcelApplication1.Visible[ 1 ] := true;
end;

end.

