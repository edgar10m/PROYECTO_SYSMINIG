unit ptsbms;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, StdCtrls, dxBar;

type
   Tftsbms = class( TForm )
    mnuPrincipal: TdxBarManager;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
   private
      { Private declarations }
      function entre( x: string; inicio: string; final: string ): string;
   public
      { Public declarations }
      titulo: string;
      procedure arma( archivo: string );
   end;

var
   ftsbms: Tftsbms;
procedure PR_BMS( archivo: string );

implementation

uses ptsdm, parbol, ptsgral; //, ptsmining;

{$R *.dfm}

procedure PR_BMS( archivo: string );
begin
   Application.CreateForm( Tftsbms, ftsbms );
   ftsbms.arma( archivo );
   ftsbms.Show;
end;

function Tftsbms.entre( x: string; inicio: string; final: string ): string;
var
   i: integer;
begin
   if pos( inicio, x ) = 0 then begin
      entre := '';
      exit;
   end;
   i := pos( inicio, x ) + length( inicio );
   x := copy( x, i, 1000 );
   i := pos( final, x );
   if i > 0 then
      entre := copy( x, 1, i - 1 )
   else
      entre := trimright( x );
end;

procedure Tftsbms.arma( archivo: string );
var
   lis: Tstringlist;
   x, xx: string;
   i, sy, sx, nlabel: integer;
   edi: Tedit;
   lab: Tlabel;
   comando: string;
   pc: integer;
begin
   caption := titulo;
   if fileexists( archivo ) = false then
      exit;
   lis := Tstringlist.Create;
   lis.LoadFromFile( archivo );
   sy := 20;
   sx := 8;
   x := '';
   for i := 0 to lis.Count - 1 do begin
      if copy( lis[ i ], 1, 1 ) = '*' then
         continue;
      if trim( copy( lis[ i ], 72, 1 ) ) <> '' then begin // tiene continuación
         if x <> '' then begin // la anterior tenia continuacion
            xx := trimright( copy( lis[ i ], 1, 71 ) );
            if copy( xx, length( xx ), 1 ) = ',' then begin // tiene coma al final
               x := x + trim( xx );
               continue;
            end
            else begin // probablemente es un string
               x := x + trimleft( copy( lis[ i ], 1, 71 ) );
               continue;
            end;
         end
         else begin
            x := trimright( copy( lis[ i ], 1, 71 ) );
            if copy( x, length( x ), 1 ) = ',' then begin // tiene coma al final
               continue;
            end
            else begin // probablemente es un string
               x := copy( lis[ i ], 1, 71 );
               continue;
            end;
         end;
      end
      else begin
         if x <> '' then begin // la anterior tenia continuacion
            x := x + trim( copy( lis[ i ], 1, 71 ) );
         end
         else begin
            x := x + trimright( copy( lis[ i ], 1, 71 ) );
         end;
      end;
      comando := trim( copy( x, 9, 8 ) );
      pc := pos( ' ', comando );
      if ( pc > 0 ) then
         comando := copy( comando, 1, pc - 1 );
      if comando = 'DFHMSD' then begin
         if entre( x, 'TYPE=', ',' ) <> 'FINAL' then
            caption := trim( copy( x, 1, 8 ) );
         x := '';
         continue;
      end;
      if comando = 'DFHMDI' then begin
         xx := entre( x, 'SIZE=(', ')' );
         height := strtoint( copy( xx, 1, pos( ',', xx ) - 1 ) ) * sy + 100;
         width := strtoint( copy( xx, pos( ',', xx ) + 1, 100 ) ) * sx + 25;
         x := '';
         continue;
      end;
      if comando = 'DFHMDF' then begin
         xx := trim( copy( x, 1, 8 ) );
         if xx = '' then begin // constante
            lab := Tlabel.Create( self );
            lab.Parent := self;
            inc( nlabel );
            lab.Name := 'label_' + inttostr( nlabel );
            xx := entre( x, 'POS=(', ')' );
            lab.Top := strtoint( copy( xx, 1, pos( ',', xx ) - 1 ) ) * sy;
            lab.Left := strtoint( copy( xx, pos( ',', xx ) + 1, 100 ) ) * sx;
            lab.Width := strtoint( entre( x, 'LENGTH=', ',' ) ) * sx;
            lab.Caption := stringreplace( entre( x, 'INITIAL=''', ''',' ), '''''', '''', [ rfreplaceall ] );
            lab.Visible := true;
         end
         else begin // Campo variable
            edi := Tedit.Create( self );
            edi.Parent := self;
            edi.Name := stringreplace( trim( copy( x, 1, 8 ) ), '-', '_', [ rfreplaceall ] );
            edi.ReadOnly := true;
            edi.Hint := edi.Name;
            edi.ShowHint := true;
            xx := entre( x, 'POS=(', ')' );
            edi.Top := strtoint( copy( xx, 1, pos( ',', xx ) - 1 ) ) * sy;
            edi.Left := strtoint( copy( xx, pos( ',', xx ) + 1, 100 ) ) * sx;
            edi.Width := strtoint( entre( x, 'LENGTH=', ',' ) ) * sx + ( sx div 2 );
            edi.Height := sy;
            //edi.text:=stringreplace(entre(x,'INITIAL=''',''','),'''''','''',[rfreplaceall]);
            edi.Text := edi.Name;
            xx := entre( x, 'ATTRB=(', ')' );
            if xx = '' then
               xx := entre( x, 'ATTRB=', ',' );
            edi.Enabled := ( pos( 'UNPROT', xx ) > 0 );
            if edi.Enabled = false then
               edi.Color := clyellow;
            edi.Visible := true;
         end;
         x := '';
         continue;
      end;
      x := '';
   end;
   lis.Free;
end;

procedure Tftsbms.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   if FormStyle = fsMDIChild then
      Action := caFree;
end;

procedure Tftsbms.FormDestroy(Sender: TObject);
begin
  dm.PubEliminarVentanaActiva( Caption );

  if gral.iPubVentanasActivas > 0 then  
      gral.PubExpandeMenuVentanas( True );
end;

procedure Tftsbms.FormCreate(Sender: TObject);
begin
  mnuPrincipal.Style := gral.iPubEstiloActivo;

  if gral.iPubVentanasActivas > 0 then  
      gral.PubExpandeMenuVentanas( True );
end;

end.

