unit ptsattribute;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, StdCtrls, ExtCtrls, Grids, ValEdit;

type
   Tftsattribute = class( TForm )
      vle: TValueListEditor;
      procedure bokClick( Sender: TObject );
      procedure FormClose( Sender: TObject; var Action: TCloseAction );
      procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
   private
      { Private declarations }
   public
      { Public declarations }
      titulo: string;
      procedure arma_alfa( ocprog: string; ocbib: string; occlase: string;
                           pcprog: string; pcbib: string; pcclase: string;
                           hcprog: string; hcbib: string; hcclase: string;
                           orden:string;   sistema:string);
      procedure arma( compo: string; bib: string; clase: string );
   end;

var
   ftsattribute: Tftsattribute;

implementation
uses ptsdm, parbol, ptsgral;
{$R *.dfm}

procedure Tftsattribute.arma_alfa( ocprog: string; ocbib: string; occlase: string;
                                   pcprog: string; pcbib: string; pcclase: string;
                                   hcprog: string; hcbib: string; hcclase: string;
                                   orden:string;   sistema:string);
var
   i: integer;
   x, att: string;
begin
   //caption := g_version_tit + '  -  Atributos ' + compo;
   caption := titulo;
   if pcclase<>'CLA' then begin
      if dm.sqlselect( dm.q1, 'select * from tsrela ' +
         ' where ocprog=' + g_q + hcprog + g_q +
         ' and   ocbib=' + g_q + hcbib + g_q +
         ' and   occlase=' + g_q + hcclase + g_q+
         ' and   pcprog=' + g_q + hcclase + g_q +
         ' and   pcbib=' + g_q + sistema + g_q +
         ' and   pcclase=' + g_q + 'CLA' + g_q+
         ' and   hcprog=' + g_q + hcprog + g_q +
         ' and   hcbib=' + g_q + hcbib + g_q +
         ' and   hcclase=' + g_q + hcclase + g_q+
         ' and   orden=' + g_q + '0001' + g_q+
         ' and   sistema=' + g_q + sistema + g_q+
         ' and   atributos is not null') then begin
         x := dm.q1.fieldbyname( 'atributos' ).AsString;
         while trim( x ) <> '' do begin
            i := pos( '{}', x );
            if i > 0 then begin
               att := copy( x, 1, i - 1 );
               vle.InsertRow( copy( att, 1, pos( '=', att ) - 1 ),
               copy( att, pos( '=', att ) + 1, 10000 ), true );
               x := copy( x, i + 2, 10000 );
            end;
         end;
      end;
   end;
   if dm.sqlselect( dm.q1, 'select * from tsrela ' +
      ' where ocprog=' + g_q + ocprog + g_q +
      ' and   ocbib=' + g_q + ocbib + g_q +
      ' and   occlase=' + g_q + occlase + g_q+
      ' and   pcprog=' + g_q + pcprog + g_q +
      ' and   pcbib=' + g_q + pcbib + g_q +
      ' and   pcclase=' + g_q + pcclase + g_q+
      ' and   hcprog=' + g_q + hcprog + g_q +
      ' and   hcbib=' + g_q + hcbib + g_q +
      ' and   hcclase=' + g_q + hcclase + g_q+
      ' and   sistema=' + g_q + sistema + g_q+
      ' and   orden=' + g_q + orden + g_q+
      ' and   atributos is not null') then begin
      x := dm.q1.fieldbyname( 'atributos' ).AsString;
      while trim( x ) <> '' do begin
         i := pos( '{}', x );
         if i > 0 then begin
            att := copy( x, 1, i - 1 );
            vle.InsertRow( copy( att, 1, pos( '=', att ) - 1 ),
            copy( att, pos( '=', att ) + 1, 10000 ), true );
            x := copy( x, i + 2, 10000 );
         end;
      end;
   end;
   //arma( hcprog,hcbib,hcclase);
end;
procedure Tftsattribute.arma( compo: string; bib: string; clase: string );
var
   i: integer;
   x, att: string;
begin
   //caption := g_version_tit + '  -  Atributos ' + compo;
   caption := titulo;
   if dm.sqlselect( dm.q1, 'select * from tsattribute ' +
      ' where cprog=' + g_q + compo + g_q +
      ' and   cbib=' + g_q + bib + g_q +
      ' and   cclase=' + g_q + clase + g_q ) then begin
      x := dm.q1.fieldbyname( 'atributos' ).AsString;
      while trim( x ) <> '' do begin
         i := pos( '{}', x );
         if i > 0 then begin
            att := copy( x, 1, i - 1 );
            vle.InsertRow( copy( att, 1, pos( '=', att ) - 1 ),
            copy( att, pos( '=', att ) + 1, 10000 ), true );
            x := copy( x, i + 2, 10000 );
         end;
      end;
   end;
   {
   if dm.sqlselect( dm.q1, 'select hcclase,descripcion,count(*) cuenta from tsrela,tsclase ' +
      ' where hcclase=cclase ' +
      ' and   pcprog=' + g_q + compo + g_q +
      ' and   pcbib=' + g_q + bib + g_q +
      ' and   pcclase=' + g_q + clase + g_q +
      ' group by hcclase,descripcion ' +
      ' order by hcclase' ) then begin
      while not dm.q1.Eof do begin
         vle.InsertRow( dm.q1.fieldbyname( 'hcclase' ).AsString + ' - ' +
            dm.q1.fieldbyname( 'descripcion' ).AsString,
            dm.q1.fieldbyname( 'cuenta' ).AsString, true );
         dm.q1.Next;
      end;
   end;
   }
end;

procedure Tftsattribute.bokClick( Sender: TObject );
begin
   close;
end;

procedure Tftsattribute.FormClose( Sender: TObject;
   var Action: TCloseAction );
begin
   if FormStyle = fsMDIChild then
      Action := caFree;
end;

procedure Tftsattribute.FormDestroy(Sender: TObject);
begin
    dm.PubEliminarVentanaActiva( Caption );

   if gral.iPubVentanasActivas in [ 0, 1 ] then  
      gral.PubExpandeMenuVentanas( False );
end;

procedure Tftsattribute.FormCreate(Sender: TObject);
begin
  if gral.iPubVentanasActivas > 0 then  
      gral.PubExpandeMenuVentanas( True );
end;

procedure Tftsattribute.FormActivate(Sender: TObject);
begin
      g_producto := 'MENÚ CONTEXTUAL-ATRIBUTOS';
end;

end.

