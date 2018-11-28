unit ptsrefcruz;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, Buttons, ExtCtrls, ComCtrls, StdCtrls, Menus, shellapi, OleCtrls,
   SHDocVw, ComObj, ImgList, OleServer, ExcelXP, dxBar, HTML_HELP, Excel97;

type
   Tftsrefcruz = class( TForm )
      mm: TMemo;
      lv: TListView;
      Splitter1: TSplitter;          
      pop: TPopupMenu;
      Notepad1: TMenuItem;
      Web1: TWebBrowser;
      jquery_fixer: TMemo;
      jquery: TMemo;
      ImageList1: TImageList;
      ExcelApplication1: TExcelApplication;
      SaveDialog1: TSaveDialog;
    mnuPrincipal: TdxBarManager;
    mnuImprimir: TdxBarButton;
    mnuExportar: TdxBarButton;
      procedure bsalirClick( Sender: TObject );
      procedure lvMouseDown( Sender: TObject; Button: TMouseButton;
         Shift: TShiftState; X, Y: Integer );
      procedure lvColumnClick( Sender: TObject; Column: TListColumn );
      procedure Notepad1Click( Sender: TObject );
      procedure sqlParaWeb( clase: string; bib: string; nombre: string );
      procedure LlenaArreglos( clase: string; bib: string; nombre: string );
      procedure CreaHtml( clase: string; bib: string; nombre: string );
      procedure Web1BeforeNavigate2( Sender: TObject; const pDisp: IDispatch;
         var URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
         var Cancel: WordBool );
      procedure exportarClick( Sender: TObject );
      procedure ImprimirClick( Sender: TObject );
      procedure Web1DocumentComplete( Sender: TObject; const pDisp: IDispatch;
         var URL: OleVariant );
      function TipoNumeroAcceso( b1: string; b2: string ): string;
      procedure FormClose( Sender: TObject; var Action: TCloseAction );
    procedure FormDestroy(Sender: TObject);
    procedure Web1ProgressChange(Sender: TObject; Progress,
      ProgressMax: Integer);
    procedure mnuImprimirClick(Sender: TObject);
    procedure mnuExportarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
   private
      { Private declarations }
      nom: string;
      Opciones: Tstringlist;
   public
      { Public declarations }
      clase, bib, nombre: string;
      Vector: array of array of String;
      Vector1: array of array of String;
      VecX, VecY, VecT: integer;
      b_impresion: boolean;
      T_nombre: string;
      Primera_vez: Integer;
      maxcol: integer;
      Wfin_vector: integer;
      WnomLogo: string;
      titulo: string;
      procedure arma( clase: string; bib: string; nombre: string );
      procedure CreaWeb1RC( clase: string; bib: string; nombre: string );
      procedure Web1PreviewPrint( web1: TWebBrowser );
      function ArmarOpciones(b1:Tstringlist):integer;
   end;
var
   ftsrefcruz: Tftsrefcruz;

implementation
uses ptsdm, ptsvmlx, ptsvmlimp, ptsgral, parbol;
{$R *.dfm}

procedure Tftsrefcruz.arma( clase: string; bib: string; nombre: string );
begin
   caption := titulo;
   gral.CargaRutinasjs( );
   WnomLogo := 'RC' + formatdatetime( 'YYYYMMDDHHNNSSZZZZ', now );
   gral.CargaLogo( WnomLogo );
   gral.CargaIconosBasicos( );
   T_nombre := trim( clase ) + '_' + trim( bib ) + '_' + trim( nombre );
   Vector1 := nil;
   Vector := nil;
   if dm.sqlselect( dm.q1, 'select * from parametro where clave=' + g_q + 'REFERENCIAS CRUZADAS MAX COLUMNS' + g_q ) then begin
      maxcol := dm.q1.fieldbyname( 'secuencia' ).AsInteger;
   end
   else begin
      maxcol := 300;
   end;
   gral.CargaIconosClases( );
   CreaWeb1RC( clase, bib, nombre );
end;

procedure Tftsrefcruz.bsalirClick( Sender: TObject );
var
   arch: string;
begin
   gral.BorraLogo( WnomLogo + g_ext );
   gral.BorraRutinasjs( );
   gral.BorraIconosTmp( );
   gral.BorraIconosBasicos( );
   arch := g_tmpdir + '\ReferenciasCruzadas.html';
   g_borrar.Add( arch );
   arch := g_tmpdir + '\ReferenciasCruzadasIMP.html';
   g_borrar.Add( arch );
   // Limpia Vector1
   Vector1 := nil;
   close;
end;

procedure Tftsrefcruz.lvMouseDown( Sender: TObject; Button: TMouseButton;
   Shift: TShiftState; X, Y: Integer );
var
   ls: Tlistitem;
   m: Tstringlist;
begin
   ls := lv.GetItemAt( x, y );
   if ls = nil then
      exit;
   if ls.Caption <> '' then begin
      m := Tstringlist.Create;
      m.CommaText := ls.Caption;
      if m.count < 3 then begin
         Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
            pchar( dm.xlng( 'Referencias Cruzadas ' ) ), MB_OK );
         m.free;
         exit;
      end;
      nom := m[ 2 ];
      dm.trae_fuente( m[ 2 ], m[ 1 ], m[ 0 ], mm );
      m.Free;
   end;
end;

procedure Tftsrefcruz.lvColumnClick( Sender: TObject; Column: TListColumn );
var
   m: Tstringlist;
begin
   if column.Caption = '' then
      exit;
   m := Tstringlist.Create;
   m.CommaText := column.Caption;
   if m.count < 3 then begin
      Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
         pchar( dm.xlng( 'Referencias Cruzadas' ) ), MB_OK );
      m.free;
      exit;
   end;
   nom := m[ 2 ];
   dm.trae_fuente( m[ 2 ], m[ 1 ], m[ 0 ], mm );
   m.Free;
end;

procedure Tftsrefcruz.Notepad1Click( Sender: TObject );
begin
   mm.Lines.SaveToFile( g_tmpdir + '\' + nom + '.txt' );
   ShellExecute( Handle, 'open', pchar( g_tmpdir + '\' + nom + '.txt' ), nil, nil, SW_SHOW );
end;

procedure Tftsrefcruz.sqlParaWeb( clase: string; bib: string; nombre: string );
var
   nom: string;
   maxcol: integer;
   Vx, Vy, Vyy: Integer;
   hclase: string;
begin
   if dm.sqlselect( dm.q1, 'select * from parametro where clave=' + g_q + 'REFERENCIAS CRUZADAS MAX COLUMNS' + g_q ) then
      maxcol := dm.q1.fieldbyname( 'secuencia' ).AsInteger
   else
      maxcol := 300;

   Primera_vez := 0;
   VecX := 0;
   VecY := 0;
   VecT := 0;
   g_procesa := TRUE;
   if dm.sqlselect( dm.q1, 'select hcprog,hcbib,hcclase,orden from tsrela ' +
      ' where pcprog=' + g_q + nombre + g_q +
      ' and pcbib=' + g_q + bib + g_q +
      ' and pcclase=' + g_q + clase + g_q +
      ' and hcclase<>' + g_q + 'STE' + g_q +
      ' union ' +
      ' select hcprog,hcbib,hcclase,orden from tsrela ' +
      ' where (pcprog,pcbib,pcclase) in ' +
      '   (select hcprog,hcbib,hcclase from tsrela ' +
      '    where pcprog=' + g_q + nombre + g_q +
      '    and pcbib=' + g_q + bib + g_q +
      '    and pcclase=' + g_q + clase + g_q +
      '    and hcclase=' + g_q + 'STE' + g_q + ')' +
      ' order by orden' ) then begin
      VecY := dm.q1.RecordCount;
      VecT := VecY;
      if VecY > 0 then begin
         Vyy := 1;
         for Vy := 0 to VecY - 1 do begin
            hclase := dm.q1.fieldbyname( 'hcclase' ).AsString;
            if ( hclase = 'LOC' ) or
               ( hclase = 'REP' ) or
               ( hclase = 'UTI' ) then begin
               VecT := VecT - 1;
               dm.q1.Next;
               continue;
            end;
            if dm.sqlselect( dm.q2, 'select pcprog,pcbib,pcclase from tsrela ' +
               ' where hcprog=' + g_q + dm.q1.fieldbyname( 'hcprog' ).AsString + g_q +
               ' and hcbib=' + g_q + dm.q1.fieldbyname( 'hcbib' ).AsString + g_q +
               ' and hcclase=' + g_q + dm.q1.fieldbyname( 'hcclase' ).AsString + g_q +
               ' and pcclase<>' + g_q + 'CLA' + g_q +
               ' and pcclase<>' + g_q + 'STE' + g_q +
               ' union ' +
               ' select pcprog,pcbib,pcclase from tsrela ' +
               ' where (hcprog,hcbib,hcclase) in ' +
               '   (select pcprog,pcbib,pcclase from tsrela ' +
               '    where hcprog=' + g_q + dm.q1.fieldbyname( 'hcprog' ).AsString + g_q +
               '    and hcbib=' + g_q + dm.q1.fieldbyname( 'hcbib' ).AsString + g_q +
               '    and hcclase=' + g_q + dm.q1.fieldbyname( 'hcclase' ).AsString + g_q +
               '    and pcclase=' + g_q + 'STE' + g_q + ')' ) then begin
               VecX := maxcol + 1000; //dm.q2.RecordCount;
               if Primera_vez = 0 then begin
                  SetLength( Vector, VecY + 1, VecX );
                  Vector[ 0, 1 ] := 'FIN';
                  Primera_vez := 1;
               end;
               Vx := 0;
               Vector[ Vyy, Vx ] := ( dm.q1.fieldbyname( 'hcclase' ).AsString + ' ' +
                  dm.q1.fieldbyname( 'hcbib' ).AsString + ' ' +
                  dm.q1.fieldbyname( 'hcprog' ).AsString ) + '(' +
                  inttostr( dm.q2.RecordCount ) + ')';
               for Vx := 1 to VecX - 1 do begin
                  if dm.q2.Eof then begin
                     Vector[ Vyy, Vx ] := 'FIN';
                     break;
                  end
                  else begin
                     nom := ( dm.q2.fieldbyname( 'pcclase' ).AsString + ' '
                        + dm.q2.fieldbyname( 'pcbib' ).AsString + ' '
                        + dm.q2.fieldbyname( 'pcprog' ).AsString );
                     Vector[ Vyy, Vx ] := nom;
                     nom := ' ';
                     dm.q2.Next
                  end;
               end;
            end;
            Vyy := Vyy + 1;
            dm.q1.Next;
         end;
      end; // Si existen regitros..ejecuto
   end;
   if VecT < 1 Then begin
      g_procesa := FALSE;
   end;
end;

procedure Tftsrefcruz.LlenaArreglos( clase: string; bib: string; nombre: string );
var
   nom: string;
   k: integer;
   Vx, Vy, Vxx: Integer;
begin
   VecY := High( vector );
   VecX := High( vector[ VecY ] );
   VecY := VecY + 1;

   SetLength( Vector1, VecY, VecX );

   for Vy := 0 to VecY - 1 do begin
      vector1[ Vy, 0 ] := vector[ Vy, 0 ];
   end;
   for Vx := 0 to VecX - 1 do begin
      vector1[ 0, Vx ] := vector[ 0, Vx ];
   end;

   for Vy := 1 to VecY - 1 do begin
      for Vx := 1 to VecX - 1 do begin
         if vector[ Vy, Vx ] = '' then begin
            continue;
         end
         else begin
            k := 0;
            for Vxx := 1 to VecX - 1 do begin
               if vector[ Vy, Vx ] = vector[ 0, Vxx ] then begin
                  vector1[ Vy, Vxx ] := vector[ Vy, Vx ];
                  k := 1;
                  break;
               end;
               if vector[ 0, Vxx ] = 'FIN' then begin
                  K := 0;
                  break;
               end;
            end;
            if k = 0 Then begin
               nom := vector[ Vy, Vx ];
               vector1[ 0, Vxx ] := vector[ Vy, Vx ];
               vector1[ Vy, Vxx ] := vector[ Vy, Vx ];
               vector[ 0, Vxx ] := vector[ Vy, Vx ];
               if Vxx < Vecx - 2 then //revisar bien esto
                  Vxx := Vxx + 1;
               vector1[ 0, Vxx ] := 'FIN';
               vector1[ Vy, Vxx ] := 'FIN';
               vector[ 0, Vxx ] := 'FIN';
            end;
         end;
      end;
   end;
   if ( Vxx > 300 ) or ( vy > 300 ) then
      Application.MessageBox( pchar( dm.xlng( 'El número de columnas y/o renglones excede el límite desplegable,' +
         '  para ver completa la información, ejecutar Exportar, en la siguiente pantalla' ) ),
         pchar( dm.xlng( 'Referencias Cruzadas ' ) ), MB_OK );
   Vector := nil;
end;

procedure Tftsrefcruz.CreaHtml( clase: string; bib: string; nombre: string );
var
   x, x1, x3: Tstringlist;
   nom, nom1, nom2, icono, b1, b2, b3, texto0: string;
   ii, i, c1: integer;
   VecXX: Integer;
begin
   texto0 := '';
   // Inicio arma HTML
   x := TStringlist.create;
   x1 := TStringlist.create;
   x.Add( '<HTML>' );
   x1.Add( '<HTML>' );
   x.Add( '<HEAD>' );
   x1.Add( '<HEAD>' );
   x.Add( '<TITLE>   -     </TITLE>' );
   x1.Add( '<TITLE>  -     </TITLE>' );
   // PARA RESALTAR LA LINEA.
   x.ADD( '<script language="JavaScript" type="text/javascript">' );
   x1.ADD( '<script language="JavaScript" type="text/javascript">' );
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
   x.ADD( 'function A(t)' );
   x1.ADD( 'function A(t)' );
   x.ADD( '{' );
   x1.ADD( '{' );
   x.ADD( 'for(var q=0;q<t.length;q++) {document.write(t.charAt(q)+"<br>");}' );
   x1.ADD( 'for(var q=0;q<t.length;q++) {document.write(t.charAt(q)+"<br>");}' );
   x.ADD( 'document.close();' );
   x1.ADD( 'document.close();' );
   x.ADD( '}' );
   x1.ADD( '}' );
   x.ADD( '</script>' );
   x1.ADD( '</script>' );
   x.ADD( '<style type="text/css">' );
   x.ADD( 'tr.resaltar {' );
   x.ADD( 'background-color: #E6E6E6;' );
   x.ADD( '}' );
   x.ADD( '</style>' );
   // FIN RESALTAR LA LINEA
   // SCROLL DE LA TABLA
//   x.ADD( '<script src="jquery.js"></script>' );
//   x.ADD( '<script src="jquery.fixer.js"></script>' );
//   x.ADD( '<script>' );
//   x.ADD( ' $(document).ready(function() {' );
//   x.ADD( ' $("table").fixer({fixedrows:1,fixedcols:1,width:1200,height:700,scrollbarwidth:15});' );
//   x.ADD( '});' );
//   x.ADD( '</script>' );
   // FIN SCROLL DE LA TABLA
   x.Add( '</HEAD>' );
   x1.Add( '</HEAD>' );
   x.Add( '<BODY Text="#000000" link="#000000" alink= "#FF0000" vlink= "#000000"' );
   x1.Add( '<BODY Text="#000000" link="#000000" alink= "#FF0000" vlink= "#000000"' );

   x.Add( '<div ALIGN=MIDDLE ><img width="100" height="30" src="' + trim( WnomLogo ) + g_ext + '" ALIGN=right>' );
   x1.Add( '<div ALIGN=MIDDLE ><img width="100" height="30" src="' + trim( WnomLogo ) + g_ext + '" ALIGN=right>' );

   x.Add( '<font size=1>'+'<b>'+g_empresa+'</b>'+'<font>' );
   x1.Add( '<font size=1>'+'<b>'+g_empresa+'</b>'+'<font>' );

   //x.Add( '<p><font size=1 ><b>'+'Referencias Cruzadas' + ' - ' + trim( clase ) + ' ' + trim( bib ) + ' ' + trim( nombre ) +'</b></font></p>' );
   //x.Add( '<p><font size=0 ><b>'+'*'+'</b></font></p>' );
   x.Add( '<p><font size=1 ><b>'+'Referencias Cruzadas' + ' - ' + trim( clase ) + ' ' + trim( bib ) + ' ' + trim( nombre ) +'</b></font></p>' );
   x1.Add( '<p><font size=1 ><b>'+'Referencias Cruzadas' + ' - ' + trim( clase ) + ' ' + trim( bib ) + ' ' + trim( nombre ) +'</b></font></p>' );

   x.Add( '<TABLE id="tabla_refcruz" cellspacing="1" BORDER="1">' );
   x1.Add( '<TABLE id="tabla_refcruz" cellspacing="1" BORDER="1">' );
   x.Add( '<TR>' );
   x1.Add( '<TR>' );
   ii := 0;
   Wfin_Vector := 0;
   for i := 0 to maxcol - 1 do begin
      if Vector1[ ii, i ] = 'FIN' then begin
         VecXX := i - 1;
         Wfin_vector := 1;
         break;
      end;
      if i = 0 then begin
//         x.add( '<TH bgcolor="#4169E1">&nbsp;</TH>' );
//         x1.add( '<TH bgcolor="#4169E1">&nbsp;</TH>' );
         x.add( '<TH bgcolor="#A9D0F5">&nbsp;</TH>' );
         x1.add( '<TH bgcolor="#A9D0F5">&nbsp;</TH>' );
      end
      else begin
         nom := Vector1[ ii, i ];
         nom1 := gral.TextoFracc( nom, 1, 60 );
         c1 := Length( nom1 );
         if c1 > 60 then begin //igualar con la longitud  que se fracciono
//            x.add( '<TH height="60" width="30" valign="top" bgcolor="#4169E1">' +
            x.add( '<TH height="60" width="30" valign="top" bgcolor="#A9D0F5">' +
               '<FONT FACE="VERDANA" size="1" Text="#000000"><A style="color:#000000" HREF=#lin' +
               stringreplace( trim( Vector1[ ii, i ] ), ' ', '¿', [ rfReplaceAll ] ) +
               ' TITLE="' + trim( Vector1[ ii, i ] ) + '">' +
               trim( stringreplace( nom1, '?', ' ', [ rfReplaceAll ] ) ) + '</A></font></TH>' );
//            x1.add( '<TH width="50" valign="top" bgcolor="#4169E1">' +
            x1.add( '<TH width="50" valign="top" bgcolor="#A9D0F5">' +
               '<FONT FACE="VERDANA" size="1" Text="#000000"><A style="color:#000000" HREF=#lin' +
               trim( stringreplace( Vector1[ ii, i ], ' ', '¿', [ rfReplaceAll ] ) ) +
               ' TITLE="' + trim( Vector1[ ii, i ] ) + '">' +
               trim( stringreplace( trim( nom1 ), '?', ' ', [ rfReplaceAll ] ) ) + '</A></font></TH>' );
         end
         else begin
//            x.add( '<TH width="20" valign="top" bgcolor="#4169E1">' +
            x.add( '<TH width="20" valign="top" bgcolor="#A9D0F5">' +
               '<FONT FACE="VERDANA" size="1" Text="#000000"><A style="color:#000000" HREF=#lin' +
               trim( stringreplace( Vector1[ ii, i ], ' ', '¿', [ rfReplaceAll ] ) ) +
               ' TITLE="' + trim( Vector1[ ii, i ] ) + '">' +
               stringreplace( trim( nom1 ), '?', ' ', [ rfReplaceAll ] ) + '</A></font></TH>' );
//            x1.add( '<TH width="20" valign="top" bgcolor="#4169E1">' +
            x1.add( '<TH width="20" valign="top" bgcolor="#A9D0F5">' +
               '<FONT FACE="VERDANA" size="1" Text="#000000"><A style="color:#000000" HREF=#lin' +
               trim( stringreplace( Vector1[ ii, i ], ' ', '¿', [ rfReplaceAll ] ) ) +
               ' TITLE="' + trim( Vector1[ ii, i ] ) + '">' +
               trim( stringreplace( trim( nom1 ), '?', ' ', [ rfReplaceAll ] ) ) + '</A></font></TH>' );
         end;
      end;
      VecXX := i - 1;
   end;
   x.add( '</TR>' );
   x1.add( '</TR>' );
   for ii := 0 to VecY - 1 do begin
      x.Add( '<TR>' );
      x1.Add( '<TR>' );
      for i := 0 to VecXX do begin
         nom := Vector1[ ii, i ];
         icono := copy( nom, 1, 3 );
         if ( icono = 'INS' )
            or ( icono = 'DEL' )
            or ( icono = 'UPD' ) then
            break;
         if ( nom = '' )
            or ( nom = 'FIN' ) then begin
            if i = 0 then
               break
            else begin
               x.add( '<TD>&nbsp;</TD>' );
               x1.add( '<TD>&nbsp;</TD>' );
            end;
         end
         else begin
            if i = 0 then begin
               icono := g_tmpdir + '\ICONO_' + trim( icono ) + '.ico';
               nom := Vector1[ ii, i ];
               nom1 := gral.TextoFracc( nom, 1, 60 );
               nom1 := stringreplace( nom1, '?', ' ', [ rfReplaceAll ] );
               nom1 := trim( nom1 );
               c1 := Length( nom1 );
               if c1 > 60 then begin //igualar con la longitud  que se fracciono
//                  x.add( '<TD width="40" valign="top" bgcolor="#4169E1">' +
                  x.add( '<TD width="40" valign="top">' +
                     '<FONT FACE="VERDANA" size="1"><IMG width="18" height="18" SRC="' +
                     icono + '">' + nom1 + '</font></TD>' );
                  x1.add( '<TD width="40" valign="top">' +
                     '<FONT FACE="VERDANA" size="1"><IMG width="18" height="18" SRC="' +
                     icono + '">' + nom1 + '</font></TD>' );
               end
               else begin
//                  x.add( '<TD bgcolor="#4169E1" valign="top"><FONT FACE="VERDANA" size="1"><IMG width="18"' +
                  x.add( '<TD valign="top"><FONT FACE="VERDANA" size="1"><IMG width="18"' +
                     ' height="18" SRC="' + icono + '">' + nom1 + '</font></TD>' );
                  x1.add( '<TD valign="top"><FONT FACE="VERDANA" size="1"><IMG width="18" height="18" SRC="' +
                     icono + '">' + nom1 + '</font></TD>' );
               end;
            end
            else begin
               b1 := Vector1[ ii, 0 ];
               b2 := Vector1[ ii, i ];
               nom1 := '';
               b3 := copy( b1, 1, 3 );
               if b3 = 'TAB' then begin
                  nom1 := TipoNumeroAcceso( b1, b2 );
                  x3 := Tstringlist.Create;
                  x3.CommaText := nom1;
                  if x3.count < 2 then begin
                     nom1 := ' ';
                     nom2 := ' ';
                  end
                  else begin
                     nom1 := trim( stringreplace( x3[ 0 ], '?', ' ', [ rfReplaceAll ] ) );
                     nom2 := trim( stringreplace( x3[ 1 ], '?', '', [ rfReplaceAll ] ) );
                  end;
                  texto0 := 'S=Select, I=Insert, U=Upadate, D=Delete';
               end;
               if ( nom1 = '' ) or ( b3 <> 'TAB' ) then begin
                  x.add( '<TD ALIGN=center><IMG width="18" height="18" SRC="' + g_tmpdir + '\ICONO_TICK.ico"></TD>' );
                  x1.add( '<TD ALIGN=center><IMG width="18" height="18" SRC="' + g_tmpdir + '\ICONO_TICK.ico"></TD>' );
               end
               else begin
                  x.add( '<TD ALIGN=center><FONT FACE="GEORGIA" size="1" Text="#245209"><A style="color:#245209" ' +
                     'HREF=#nopCBL¿COBSRC¿RSSBT003 TITLE="Tipo/Número Accesos --> ' + nom1 + '"><script>A("' +
                     nom2 + '");</script></A></font></TD>' );
                  x1.add( '<TD ALIGN=center><FONT FACE="GEORGIA" size="1" Text="#245209"><A style="color:#245209">' +
                     '<script>A("' + nom2 + '");</script></font></TD>' );
               end;
            end;
         end;
      end;
      x.Add( '</TR>' );
      x1.Add( '</TR>' );
   end;
   x.Add( '</TABLE>' );
   x1.Add( '</TABLE>' );
   x1.Add( '<p> </p>' );
   x1.Add( texto0 );
   // Inicio Texto vertical--- solo encabezados TR TH
   x.Add( '<style type="text/css">' );
   x1.Add( '<style type="text/css">' );
   x.Add( 'table#tabla_refcruz TR TH {' );
   x1.Add( 'table#tabla_refcruz TR TH {' );
   x.Add( '/*Firefox*/' );
   x1.Add( '/*Firefox*/' );
   x.Add( '-moz-transform: rotate(-90deg);' );
   x1.Add( '-moz-transform: rotate(-90deg);' );
   x.Add( '/*Safari*/' );
   x1.Add( '/*Safari*/' );
   x.Add( '-webkit-transform: rotate(-90deg);' );
   x1.Add( '-webkit-transform: rotate(-90deg);' );
   x.Add( '/*Opera*/' );
   x1.Add( '/*Opera*/' );
   x.Add( '-o-transform: rotate(-90deg);' );
   x1.Add( '-o-transform: rotate(-90deg);' );
   x.Add( '/*IE*/' );
   x1.Add( '/*IE*/' );
   x.Add( 'writing-mode: tb-rl;' );
   x1.Add( 'writing-mode: tb-rl;' );
   x.Add( 'filter: fliph flipv;' );
   x1.Add( 'filter: fliph flipv;' );
   x.Add( '}' );
   x1.Add( '}' );
   x.Add( '</style>' );
   x1.Add( '</style>' );
   // Fin  Texto vertical--- solo encabezados TR TH
   // Inicio Resalta Fila
   x.Add( '<script language="JavaScript" type="text/javascript">' );
   x.Add( 'ResaltarFila("tabla_refcruz");' );
   x.Add( '</script>' );
   // Fin Resalta Fila
   x.Add( '</div>' );
   x1.Add( '</div>' );
   x.Add( '</BODY>' );
   x1.Add( '</BODY>' );
   x.Add( '</HTML>' );
   x1.Add( '</HTML>' );
   x.savetofile( g_tmpdir + '\ReferenciasCruzadas.html' );
   g_borrar.Add( g_tmpdir + '\ReferenciasCruzadas.html' );
   x1.savetofile( g_tmpdir + '\ReferenciasCruzadasIMP.html' );
   g_borrar.Add( g_tmpdir + '\ReferenciasCruzadasIMP.html' );
   x.free;
   x1.free;
   x3.free;
   // Fin arma HTML
end;

procedure Tftsrefcruz.CreaWeb1RC( clase: string; bib: string; nombre: string );
begin
   screen.Cursor := crsqlwait;
   sqlParaWeb( clase, bib, nombre );
   if g_procesa then begin
      if Primera_vez = 1 then begin

         LlenaArreglos( clase, bib, nombre );
         if Length(vector1)<> 0 then begin
              mnuExportar.Visible := ivAlways;
              mnuImprimir.visible := ivAlways;
              CreaHtml( clase, bib, nombre );
            try
               web1.Navigate( g_tmpdir + '\ReferenciasCruzadas.html' );
            except
               screen.Cursor := crdefault;
               exit;
            end;
         end else begin
            Application.MessageBox( pchar( dm.xlng( 'No existe información a procesar.' ) ),
               pchar( dm.xlng( 'Referencias Cruzadas' ) ), MB_OK );
            abort;   
         end;
      end;
   end;
end;

procedure Tftsrefcruz.Web1BeforeNavigate2( Sender: TObject;
   const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
   Headers: OleVariant; var Cancel: WordBool );
var
   j, k, l: integer;
   b1, b2: string;
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
   b1 := trim( stringreplace( b1, '¿', ' ', [ rfReplaceAll ] ) );
   m := Tstringlist.Create;
   m.CommaText := b1;
   if m.count < 3 then begin
      Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
         pchar( dm.xlng( 'Referencias Cruzadas ' ) ), MB_OK );
      m.free;
      screen.Cursor := crdefault;
      exit;
   end;
   nom := m[ 2 ];
   dm.trae_fuente( m[ 2 ], m[ 1 ], m[ 0 ], mm );
   if pos( chr( 13 ) + chr( 10 ), mm.Text ) = 0 then // corrige cuando el fuente no tiene CR
      mm.Text := stringreplace( mm.Text, chr( 10 ), chr( 13 ) + chr( 10 ), [ rfreplaceall ] );
   //---------------
   bgral := m[ 2 ] + ' ' + m[ 1 ] + ' ' + m[ 0 ];
   Opciones := gral.ArmarMenuConceptualWeb( bgral, 'referencias_cruzadas' );
   y:=ArmarOpciones(Opciones);
   gral.PopGral.Popup(g_X, g_Y);
   //---------------
   m.Free;
   screen.Cursor := crdefault;
end;

function Tftsrefcruz.ArmarOpciones(b1:Tstringlist):integer;
begin
   gral.EjecutaOpcionB (b1,'Lista Componentes');
end;

procedure Tftsrefcruz.exportarClick( Sender: TObject );
var
   l, c, i, ii, VecXX, x: integer;
   nomb, clase, nom1, nom2, b1, b2, b3: string;
   x3: Tstringlist;
   Libro: _WORKBOOK;
   Hoja: _WORKSHEET;
begin
   x := 0;
   l := 5;
   screen.Cursor := crsqlwait;
   Libro := ExcelApplication1.Workbooks.Add( Null, 0 );
   Hoja := Libro.Sheets[ 1 ] as _WORKSHEET;
   Hoja.Cells.Item[ 2, 1 ] := trim( g_empresa );
   Hoja.Cells.Item[ 2, 1 ].font.size := 12;
   Hoja.Cells.Item[ 2, 1 ].Font.Bold := True;
   Hoja.Cells.Item[ 3, 1 ] := 'Referencias Cruzadas: ' + T_nombre;
   Hoja.Cells.Item[ 3, 1 ].font.size := 10;
   Hoja.Cells.Item[ 3, 1 ].Font.Bold := True;
   l := l + 1;
   c := 0;
   ii := 0;
   for i := 0 to VecX - 1 do begin
      c := c + 1;
      if Vector1[ ii, i ] = 'FIN' then begin
         VecXX := i - 1;
         break;
      end;
      if i = 0 then begin
         Hoja.Cells.Item[ l, c ] := ' ';
         Hoja.Cells.Item[ l, c ].ColumnWidth := 40;
      end
      else begin
         Hoja.Cells.Item[ l, c ] := trim( Vector1[ ii, i ] );
         Hoja.Cells.Item[ l, c ].Font.Bold := True;
         Hoja.Cells.Item[ l, c ].ColumnWidth := 5;
         Hoja.Cells.Item[ l, c ].VerticalAlignment := xlBottom;
         Hoja.Cells.Item[ l, c ].WrapText := True;
         Hoja.Cells.Item[ l, c ].Orientation := 90;
         Hoja.Cells.Item[ l, c ].Font.Name := '"Verdana"';
         Hoja.Cells.Item[ l, c ].Font.Size := 8;
      end;
   end;
   l := l + 1;
   c := 0;
   for ii := 1 to VecY - 1 do begin
      l := l + 1;
      c := 0;
      for i := 0 to VecXX do begin
         nomb := Vector1[ ii, i ];
         clase := copy( nomb, 1, 3 );
         if ( clase = 'INS' )
            or ( clase = 'DEL' )
            or ( clase = 'UPD' ) then begin
            l := l - 1;
            break;
         end;
         c := c + 1;
         if ( nomb = '' )
            or ( nomb = 'FIN' ) then begin
            Hoja.Cells.Item[ l, c ] := ' ';
         end
         else begin
            if i = 0 then begin
               Hoja.Cells.Item[ l, c ] := nomb
            end
            else begin
               b1 := Vector1[ ii, 0 ];
               b2 := Vector1[ ii, i ];
               nom1 := '';
               b3 := copy( b1, 1, 3 );
               if b3 = 'TAB' then begin
                  x := 1;
                  nom1 := TipoNumeroAcceso( b1, b2 );
                  x3 := Tstringlist.Create;
                  x3.CommaText := nom1;
                  if x3.Count < 2 then begin
                     nom1 := '';
                     nom2 := '';
                  end
                  else begin
                     nom1 := trim( stringreplace( x3[ 0 ], '?', ' ', [ rfReplaceAll ] ) );
                     nom2 := trim( stringreplace( x3[ 1 ], '?', '  ', [ rfReplaceAll ] ) );
                  end;
                  Hoja.Cells.Item[ l, c ].HorizontalAlignment := xlcenter;
                  Hoja.Cells.Item[ l, c ] := nom2;
               end
               else begin
                  Hoja.Cells.Item[ l, c ].HorizontalAlignment := xlcenter;
                  Hoja.Cells.Item[ l, c ] := 'X';
               end;
            end;
            Hoja.Cells.Item[ l, c ].Font.Bold := True;
            Hoja.Cells.Item[ l, c ].WrapText := True;
            Hoja.Cells.Item[ l, c ].Font.Name := '"Verdana"';
            Hoja.Cells.Item[ l, c ].Font.Size := 8;
         end;
      end;
   end;
   if x <> 0 then
      Hoja.Cells.Item[ l + 1, 1 ] := 'S=Select, I=Insert, D=Delete, U=Upadte';

   ExcelApplication1.Visible[ 1 ] := true;
   x3.free;
   screen.Cursor := crdefault;
end;

procedure Tftsrefcruz.ImprimirClick( Sender: TObject );
begin
   b_impresion := true;
   Web1.Navigate( g_tmpdir + '\ReferenciasCruzadasIMP.html' );
end;

procedure Tftsrefcruz.Web1DocumentComplete( Sender: TObject;
   const pDisp: IDispatch; var URL: OleVariant );
begin
   screen.Cursor := crsqlwait;
   try
      if b_impresion then begin
         Web1PreviewPrint( web1 );
         Web1.Navigate( g_tmpdir + '\ReferenciasCruzadas.html' );
         b_impresion := false;
      end;
      gral.PubMuestraProgresBar( False );
   finally
      screen.Cursor := crdefault;
   end;
end;

procedure Tftsrefcruz.Web1PreviewPrint( web1: TWebBrowser );
var
   vin, Vout: OleVariant;
begin
   web1.controlinterface.ExecWB( OLECMDID_PRINTPREVIEW, OLECMDEXECOPT_DONTPROMPTUSER, vin, Vout );
end;

function Tftsrefcruz.TipoNumeroAcceso( b1: string; b2: string ): string;
var
   tipo, tipo0, tipo1, filtro, tabla, programa, a1, a2: string;
   m1, m2: Tstringlist;
begin
   if b1 = '' then
      exit;
   if b2 = '' then
      exit;
   b1 := StringReplace( b1, '(', ' (', [ rfReplaceAll ] );
   m1 := Tstringlist.Create;
   m1.CommaText := b1;
   m2 := Tstringlist.Create;
   m2.CommaText := b2;
   if m1.Count > 2 then
      tabla := m1[ 2 ];
   if m2.Count > 2 then
      programa := m2[ 2 ];
   if m1[ 0 ] = 'TAB' then
      filtro := '  hcclase in (' + g_q + 'TAB' + g_q + ',' + g_q + 'INS' + g_q + ',' +
         g_q + 'DEL' + g_q + ',' + g_q + 'UPD' + g_q + ') '
   else begin
      filtro := '  hcclase in (' + g_q + 'NVW' + g_q + ',' + g_q + 'NIN' + g_q + ',' +
         g_q + 'NDL' + g_q + ',' + g_q + 'NUP' + g_q + ') ';
   end;
   tipo := '';
   if dm.sqlselect( dm.q3,
      ' select  hcclase, count(*) total  from tsrela ' +
      ' where hcprog=' + g_q + tabla + g_q + ' and pcprog=' + g_q + programa + g_q + ' and ' + filtro +
      ' and pcclase<>' + g_q + 'CLA' + g_q +
      ' group by hcclase order by hcclase' ) then begin
      tipo := ' ';
      while not dm.q3.Eof do begin
         a1 := copy( dm.q3.fieldbyname( 'hcclase' ).AsString, 1, 1 );
         if dm.q3.fieldbyname( 'hcclase' ).AsString = 'TAB' then
            a2 := 'SEL'
         else
            a2 := dm.q3.fieldbyname( 'hcclase' ).AsString;
         if a1 = 'T' then
            a1 := 'S';
         tipo0 := tipo0 + trim( a2 ) + '/' + trim( dm.q3.fieldbyname( 'total' ).AsString ) + '?';
         tipo1 := trim( tipo1 ) + a1 + '?';
         dm.q3.Next;
      end;
   end;
   m1.free;
   m2.free;
   tipo := trim( tipo0 ) + ' ' + trim( tipo1 );
   TipoNumeroAcceso := tipo;
end;

procedure Tftsrefcruz.FormClose( Sender: TObject; var Action: TCloseAction );
var
   arch: string;
begin
   if FormStyle = fsMDIChild then
      Action := caFree;

   gral.BorraLogo( WnomLogo + g_ext );
   gral.BorraRutinasjs( );
   gral.BorraIconosTmp( );
   gral.BorraIconosBasicos( );
   arch := g_tmpdir + '\ReferenciasCruzadas.html';
   g_borrar.Add( arch );
   arch := g_tmpdir + '\ReferenciasCruzadasIMP.html';
   g_borrar.Add( arch );
   // Limpia Vector1
   Vector1 := nil;
end;

procedure Tftsrefcruz.FormDestroy(Sender: TObject);
begin
    dm.PubEliminarVentanaActiva( Caption );

   if gral.iPubVentanasActivas in [ 0, 1 ] then  
      gral.PubExpandeMenuVentanas( False );
end;

procedure Tftsrefcruz.Web1ProgressChange(Sender: TObject; Progress,
  ProgressMax: Integer);
begin
   gral.PubAvanzaProgresBar;  
end;

procedure Tftsrefcruz.mnuImprimirClick(Sender: TObject);
begin
   b_impresion := true;
   Web1.Navigate( g_tmpdir + '\ReferenciasCruzadasIMP.html' );
end;

procedure Tftsrefcruz.mnuExportarClick(Sender: TObject);
var
   l, c, i, ii, VecXX, x: integer;
   nomb, clase, nom1, nom2, b1, b2, b3: string;
   x3: Tstringlist;
   Libro: _WORKBOOK;
   Hoja: _WORKSHEET;
begin
   x := 0;
   l := 5;
   screen.Cursor := crsqlwait;
   Libro := ExcelApplication1.Workbooks.Add( Null, 0 );
   Hoja := Libro.Sheets[ 1 ] as _WORKSHEET;
   Hoja.Cells.Item[ 2, 1 ] := trim( g_empresa );
   Hoja.Cells.Item[ 2, 1 ].font.size := 10;
   Hoja.Cells.Item[ 2, 1 ].Font.Bold := True;
   Hoja.Cells.Item[ 3, 1 ] := 'Referencias Cruzadas: ' + T_nombre;
   Hoja.Cells.Item[ 3, 1 ].font.size := 9;
   Hoja.Cells.Item[ 3, 1 ].Font.Bold := True;
   l := l + 1;
   c := 0;
   ii := 0;
   for i := 0 to VecX - 1 do begin
      c := c + 1;
      if Vector1[ ii, i ] = 'FIN' then begin
         VecXX := i - 1;
         break;
      end;
      if i = 0 then begin
         Hoja.Cells.Item[ l, c ] := ' ';
         Hoja.Cells.Item[ l, c ].ColumnWidth := 40;
      end
      else begin
         Hoja.Cells.Item[ l, c ] := trim( Vector1[ ii, i ] );
         Hoja.Cells.Item[ l, c ].Font.Bold := True;
         Hoja.Cells.Item[ l, c ].ColumnWidth := 5;
         Hoja.Cells.Item[ l, c ].VerticalAlignment := xlBottom;
         Hoja.Cells.Item[ l, c ].WrapText := True;
         Hoja.Cells.Item[ l, c ].Orientation := 90;
         Hoja.Cells.Item[ l, c ].Font.Name := '"Verdana"';
         Hoja.Cells.Item[ l, c ].Font.Size := 8;
      end;
   end;
   l := l + 1;
   c := 0;
   for ii := 1 to VecY - 1 do begin
      l := l + 1;
      c := 0;
      for i := 0 to VecXX do begin
         nomb := Vector1[ ii, i ];
         clase := copy( nomb, 1, 3 );
         if ( clase = 'INS' )
            or ( clase = 'DEL' )
            or ( clase = 'UPD' ) then begin
            l := l - 1;
            break;
         end;
         c := c + 1;
         if ( nomb = '' )
            or ( nomb = 'FIN' ) then begin
            Hoja.Cells.Item[ l, c ] := ' ';
         end
         else begin
            if i = 0 then begin
               Hoja.Cells.Item[ l, c ] := nomb
            end
            else begin
               b1 := Vector1[ ii, 0 ];
               b2 := Vector1[ ii, i ];
               nom1 := '';
               b3 := copy( b1, 1, 3 );
               if b3 = 'TAB' then begin
                  x := 1;
                  nom1 := TipoNumeroAcceso( b1, b2 );
                  x3 := Tstringlist.Create;
                  x3.CommaText := nom1;
                  if x3.Count < 2 then begin
                     nom1 := '';
                     nom2 := '';
                  end
                  else begin
                     nom1 := trim( stringreplace( x3[ 0 ], '?', ' ', [ rfReplaceAll ] ) );
                     nom2 := trim( stringreplace( x3[ 1 ], '?', '  ', [ rfReplaceAll ] ) );
                  end;
                  Hoja.Cells.Item[ l, c ].HorizontalAlignment := xlcenter;
                  Hoja.Cells.Item[ l, c ] := nom2;
               end
               else begin
                  Hoja.Cells.Item[ l, c ].HorizontalAlignment := xlcenter;
                  Hoja.Cells.Item[ l, c ] := 'X';
               end;
            end;
            Hoja.Cells.Item[ l, c ].Font.Bold := True;
            Hoja.Cells.Item[ l, c ].WrapText := True;
            Hoja.Cells.Item[ l, c ].Font.Name := '"Verdana"';
            Hoja.Cells.Item[ l, c ].Font.Size := 8;
         end;
      end;
   end;
   if x <> 0 then
      Hoja.Cells.Item[ l + 1, 1 ] := 'S=Select, I=Insert, D=Delete, U=Upadte';

   ExcelApplication1.Visible[ 1 ] := true;
   x3.free;
   screen.Cursor := crdefault;
end;

procedure Tftsrefcruz.FormCreate(Sender: TObject);
begin
    mnuPrincipal.Style := gral.iPubEstiloActivo;

  if gral.iPubVentanasActivas > 0 then  
      gral.PubExpandeMenuVentanas( True );    
end;

procedure Tftsrefcruz.FormDeactivate(Sender: TObject);
begin
   gral.PopGral.Items.Clear;
end;

procedure Tftsrefcruz.FormActivate(Sender: TObject);
begin
   iHelpContext:=IDH_TOPIC_T03000;
   G_producto := 'MENÚ CONTEXTUAL-REFERENCIAS CRUZADAS';
end;

end.

