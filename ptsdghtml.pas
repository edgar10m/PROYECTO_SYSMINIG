unit ptsdghtml;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, StdCtrls, ComCtrls, ExtCtrls, OleCtrls, SHDocVw, shellapi, strutils;
type
   Trutinas = record
      tipo: string;
      nombre: string;
      px: integer;
      py: integer;
      sx: integer;
      ix: string;
   end;
type
   Tftsdghtml = class( TForm )
      web1: TWebBrowser;
      rich: TRichEdit;
      split1: TSplitter;
      procedure web1BeforeNavigate2( Sender: TObject; const pDisp: IDispatch;
         var URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
         var Cancel: WordBool );
      procedure web1DocumentComplete( Sender: TObject; const pDisp: IDispatch;
         var URL: OleVariant );
      procedure FormClose( Sender: TObject; var Action: TCloseAction );
      procedure FormDestroy(Sender: TObject);
      procedure web1ProgressChange(Sender: TObject; Progress,
      ProgressMax: Integer);
    procedure FormCreate(Sender: TObject);

   private
      { Private declarations }
      ht, fuentes, mas, menos, pals, selec: Tstringlist;
      b_string: boolean;
      arch: string;
      g_cadenas: string;
      rr: array of Trutinas;
      function colores( tipo: string ): string;
   public
      { Public declarations }
      guias: string;
      texto: string;
      titulo: string;
      procedure arma( guias: string; texto: string );
   end;

var
    ftsdghtml: Tftsdghtml;
    procedure PR_DGHTML( guias: string; texto: string );

implementation
uses ptsdm, ptsvmlx, ptsgral;
{$R *.dfm}

procedure PR_DGHTML( guias: string; texto: string );
begin
   ftsdghtml.guias := guias;
   ftsdghtml.texto := texto;
   Application.CreateForm( Tftsdghtml, ftsdghtml );
   try
      ftsdghtml.Showmodal;
   finally
      ftsdghtml.Free;
   end;
end;

function Tftsdghtml.colores( tipo: string ): string;
var
   col: string;
begin
   col := 'silver';
   if tipo = '' then
      col := 'yellow'
   else if tipo = 'class' then
      col := '#81BEF7'
   else if tipo = 'function' then
      col := 'yellow'
   else if tipo = 'if' then
      col := 'lime'
   else if tipo = 'else' then
      col := 'red'
   else if tipo = 'try' then
      col := '#E3CEF6'
   else if tipo = 'catch' then
      col := '#F7BE81'
   else if tipo = 'while' then
      col := '#F2F5A9'
   else if tipo = 'switch' then
      col := '#F5A9F2'
   else if tipo = 'public' then
      col := 'Fuchsia'
   else if tipo = 'private' then
      col := '#01DFD7'
   else if tipo = 'protected' then
      col := '#F17777'
   else if tipo = 'for' then
      col := 'aqua';
   colores := col;
end;

procedure Tftsdghtml.arma( guias: string; texto: string );
var
   i, k, sx, px, py, ancho, alto, an, al, dd, x1, y1, y2: integer;
   x, mm: Tstringlist;
   col, anterior, fecha: string;
begin
   caption := titulo;
   ht := Tstringlist.Create;
   mm := Tstringlist.Create;
   rich.Lines.LoadFromFile( texto );
   mm.LoadFromFile( guias );
   vmlinicio( ht );
   //vmlcaja( 0, 0, 2200, 250, 'none', 'white', 'Sys-Mining', '10', ht, 'false' );
   //vmlcirculo( 0, 100, 150, 150, '#BE81F7', '#BE81F7', ' ', '6', ht, 'false' );
   //vmlcirculo( 112, 12, 100, 100, '#D0A9F5', '#D0A9F5', ' ', '6', ht, 'false' );
   //vmlcirculo( 238, 0, 50, 50, '#E3CEF6', '#E3CEF6', ' ', '6', ht, 'false' );
   //   arma;
   x := Tstringlist.Create;
   px := 100;
   py := 300;
   ancho := 800;
   alto := 300;
   an := ancho div 2;
   al := alto div 2;
   dd := 50;
   x1 := 0;
   for i := 0 to mm.Count - 1 do begin
      x.CommaText := mm[ i ];
      if x.Count <> 4 then begin
         Application.MessageBox( pchar( dm.xlng( 'Linea inconsistente [' + x.commatext + ']' ) ),
            pchar( dm.xlng( 'Diagrama de flujo ' ) ), MB_OK );
      end;
      if ( x[ 1 ] = 'function' ) or ( x[ 1 ] = 'public' ) or ( x[ 1 ] = 'private' ) or ( x[ 1 ] = 'protected' ) then begin
         k := length( rr );
         setlength( rr, k + 1 );
         rr[ k ].tipo := 'rutina';
         rr[ k ].nombre := x[ 2 ];
         rr[ k ].px := px;
         rr[ k ].py := py;
         rr[ k ].sx := 0;
         rr[ k ].ix := x[ 0 ];
      end
      else begin
         if x[ 3 ] = 'ejecuta' then begin
            k := length( rr );
            setlength( rr, k + 1 );
            rr[ k ].tipo := 'ejecuta';
            rr[ k ].nombre := x[ 2 ];
            rr[ k ].px := px;
            rr[ k ].py := py;
            rr[ k ].sx := 0;
            rr[ k ].ix := x[ 0 ];
         end;
      end;
      if x[ 3 ] = 'end' then begin
         px := px - ancho - dd;
         if anterior = 'end' then begin
            py := py - alto - dd;
            vmlcirculo( px + an - 50, py + al - 50, 100, 100, colores( x[ 1 ] ), 'black', '__', '8', ht );
            vmlflecha( px + ancho + an + dd - 50, py + al, px + an + 50, py + al, 'black', ht );
         end
         else begin
            if x1 <> 0 then begin
               vmlflecha( x1, y1, x1, y2, 'black', ht );
            end;
            vmlcirculo( px + an - 50, py + al - 50, 100, 100, colores( x[ 1 ] ), 'black', '__', '8', ht );
            vmllinea( px + ancho + an + dd, py, px + ancho + an + dd, py + al, 'black', ht );
            vmlflecha( px + ancho + an + dd, py + al, px + an + 50, py + al, 'black', ht );
         end;
         x1 := px + an;
         y1 := py + al + 50;
         y2 := py + alto + dd;
         py := py + alto + dd;
         anterior := x[ 3 ];
         continue;
      end
      else begin
         if anterior = 'end' then begin
            vmlflecha( x1, y1, x1, y2, 'black', ht );
         end;
      end;
      if x[ 3 ] = 'begin' then begin
         vmlcajalink( px, py, ancho, alto, colores( x[ 1 ] ), 'black', x[ 1 ] + ' ' + x[ 2 ], '8', '#lin' + x[ 0 ], ht );
         vmllinea( px + ancho, py + al, px + ancho + an + dd, py + al, 'black', ht );
         vmlflecha( px + ancho + an + dd, py + al, px + ancho + an + dd, py + alto + dd, 'black', ht );
         px := px + ancho + dd;
         py := py + alto + dd;
         anterior := x[ 3 ];
         continue;
      end;
      vmlcajalink( px, py, ancho, alto, colores( x[ 1 ] ), 'black', x[ 1 ] + ' ' + x[ 2 ], '8', '#lin' + x[ 0 ], ht );
      vmlflecha( px + an, py + alto, px + an, py + alto + dd, 'black', ht );
      py := py + alto + dd;
   end;
   px := 1;
   for i := 0 to length( rr ) - 1 do begin // Enlaza llamados a rutinas
      if rr[ i ].tipo = 'ejecuta' then begin
         for k := 0 to length( rr ) - 1 do begin
            if ( rr[ k ].tipo = 'rutina' ) and ( rr[ k ].nombre = rr[ i ].nombre ) then begin
               if rr[ k ].sx = 0 then begin
                  rr[ k ].sx := px;
                  px := px + 50;
               end;
               sx := rr[ k ].sx;
               vmllinea( rr[ i ].px, rr[ i ].py + al, sx, rr[ i ].py + al, 'blue', ht );
               vmllinea( sx, rr[ i ].py + al, sx, rr[ k ].py + al, 'blue', ht );
               vmlflecha( sx, rr[ k ].py + al, rr[ k ].px, rr[ k ].py + al, 'blue', ht );
               vmlcirculo( rr[ i ].px - 200, rr[ i ].py + 50, 200, 200, 'yellow', 'black', '<A HREF="#lin' + rr[ k ].ix + '">*</A>', '8', ht );
               break;
            end;
         end;
      end;
   end;
   vmlfin( ht );
   fecha := g_tmpdir + '\' + formatdatetime( 'YYYYMMDDhhnnss', now ) + 'salida.htm';
   ht.SaveToFile( fecha );
   web1.Navigate( fecha );
   g_borrar.Add( fecha );
   ht.Free;
   x.Free;
   mm.Free;
end;

procedure Tftsdghtml.web1BeforeNavigate2( Sender: TObject;
   const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
   Headers: OleVariant; var Cancel: WordBool );
var
   k, m: integer;
begin
   k := pos( '#lin', URL );
   if k > 0 then begin
      k := strtoint( copy( URL, k + 4, 100 ) );
      rich.SelAttributes.Color := clblack;
      Rich.SelStart := Rich.Perform( EM_LINEINDEX, k - 1, 0 );
      rich.Perform( EM_SCROLLCARET, 0, 0 );
      m := rich.Perform( EM_GETFIRSTVISIBLELINE, 0, 0 );
      m := k - m - 30;
      rich.Perform( EM_LINESCROLL, 0, m );
      rich.SelLength := length( rich.Lines[ k - 1 ] );
      rich.SelAttributes.Color := clblue;
      rich.SelAttributes.Style := [ fsbold ];
      cancel := true;
   end;
end;

procedure Tftsdghtml.web1DocumentComplete( Sender: TObject;
   const pDisp: IDispatch; var URL: OleVariant );
begin
   web1.Refresh;
   gral.PubMuestraProgresBar( False );
end;

procedure Tftsdghtml.FormClose( Sender: TObject; var Action: TCloseAction );
begin
   if FormStyle = fsMDIChild then
      Action := caFree;
end;

procedure Tftsdghtml.FormDestroy(Sender: TObject);
begin
   dm.PubEliminarVentanaActiva( Caption );

   if gral.iPubVentanasActivas in [ 0, 1 ] then  
      gral.PubExpandeMenuVentanas( False );
end;

procedure Tftsdghtml.web1ProgressChange(Sender: TObject; Progress,
  ProgressMax: Integer);
begin
   gral.PubAvanzaProgresBar; 
end;
procedure Tftsdghtml.FormCreate(Sender: TObject);
begin
  if gral.iPubVentanasActivas > 0 then  
      gral.PubExpandeMenuVentanas( True );
end;

end.

