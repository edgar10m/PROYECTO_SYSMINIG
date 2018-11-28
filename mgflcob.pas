unit mgflcob;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, mgfrcob, Grids, mgcodigo, StdCtrls, ComCtrls, IdBaseComponent,
   IdComponent, IdTCPConnection, IdTCPClient, IdFTP, Menus, dxBar, htmlhlp, HTML_HELP, pbarra,
  ExtDlgs, ImgList, ExtCtrls,shellapi;
type
   Tregistro = record
      tipo: string;
      seccion: string;
      etiqueta: string;
      fteini: integer;
      ftefin: integer;
      parini: integer;
      parfin: integer;
      nombre: string;
      nombrethru: string;
   end;
type
   Tfmgflcob = class( TForm )
      ColorDialog1: TColorDialog;
      IdFTP1: TIdFTP;
      ventanas1: TPopupMenu;
      mnuPrincipal: TdxBarManager;
    mnuAyuda: TdxBarButton;
    imgs: TImageList;
    OpenPictureDialog1: TOpenPictureDialog;
    dxBarButton1: TdxBarButton;
    SaveDialog1: TSaveDialog;
    lblsysviewsoft: TLabel;
      procedure FormPaint( Sender: TObject );
      procedure FormDragOver( Sender, Source: TObject; X, Y: Integer;
         State: TDragState; var Accept: Boolean );
      procedure FormDragDrop( Sender, Source: TObject; X, Y: Integer );
      procedure FormDblClick( Sender: TObject );
      procedure ventana1click( Sender: TObject );
      procedure FormClose( Sender: TObject; var Action: TCloseAction );
      procedure FormDestroy(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure FormActivate(Sender: TObject);
      procedure FormDeactivate(Sender: TObject);
      function  bPubVentanaActiva( sParCaption: String ): Boolean;
    procedure mnuAyudaClick(Sender: TObject);
    procedure dxBarButton1Click(Sender: TObject);

   private
      { Private declarations }
      q: Tfrcob;
      nn: integer;
      kcics: integer;
      nodotext: string;
      fmgcodigo: array of Tfmgcodigo;
      max_y:integer;
      procedure agrega_bloques;
   public
      { Public declarations }
      fte, par: Tstringlist;
      pp, sec, lab, cnd: array of Tstringlist;
      rg: array of Tregistro;
      b_codigo: boolean;
      titulo: string;
      bc,ec,ignore:integer;
      procedure pinta( canva: Tcanvas );
      procedure desplaza( y, z: integer );
      procedure Crea( n, x, y: integer; var q: Tfrcob );
      procedure arma( nombre_prog: string; archivo: string; nodotext: string );
      procedure rutina( nombre: string; nn: integer );
   end;
var
   fmgflcob: Tfmgflcob;

implementation
uses ptsdm, ptsgral,parbol;
{$R *.dfm}

procedure Tfmgflcob.rutina( nombre: string; nn: integer );
var
   i, k, ini,ki : integer;
   ventana: Tmenuitem;
begin
   if rg[ nn ].ftefin - rg[ nn ].fteini >20000 then
      if application.MessageBox(pchar('El código tiene '+inttostr(rg[ nn ].ftefin - rg[ nn ].fteini+1)+' lineas. Desea desplegarlo?'),
         'Confirme',MB_YESNO)=IDNO then exit;

//   for i := 0 to ventanas1.items.Count - 1 do begin
   for i := 0 to gral.PopGral.items.Count -1 do begin       // si ya existe la ventana, la reacomoda y despliega
//    ventana := ( ventanas1.Items[ i ] as Tmenuitem );
      ventana := ( gral.popgral.Items[ i ] as Tmenuitem );
      if copy( ventana.Caption, pos( '_', ventana.Caption ) + 1, 100 ) = nombre then begin
         fmgcodigo[ ventana.Tag ].WindowState := wsnormal;
         fmgcodigo[ ventana.Tag ].Top := mouse.CursorPos.Y - top - 100;
         fmgcodigo[ ventana.Tag ].show;
         exit;
      end;
   end;
   k := length( fmgcodigo );
   if bPubVentanaActiva(nombre) = FALSE then begin
      setlength( fmgcodigo, k + 1 );
      fmgcodigo[ k ] := Tfmgcodigo.create( self );
      fmgcodigo[ k ].parent := self;
      fmgcodigo[ k ].Caption := nombre;
      fmgcodigo[ k ].Top := mouse.CursorPos.Y - top - 100;
      fmgcodigo[ k ].visible := true;

      gral.PopGral.Items.clear;
      for ki := 0 to k do begin
         ventana := Tmenuitem.Create( self );
         ventana.Caption := inttostr( ki ) + '_' + fmgcodigo[ ki ].Caption;
         ventana.Tag := ki;
         ventana.OnClick := ventana1click;
         gral.PopGral.Items.Add( ventana );
      end;
   end;

    ini := 0;
   try
      for i := rg[ nn ].fteini - 1 to rg[ nn ].ftefin - 1 do begin
         fmgcodigo[ k ].memo1.Lines.Add( fte[ i ] );
         {
         if rg[ nn ].ftefin- rg[ nn ].fteini <20000 then begin
            if copy( fte[ i ], ignore, 1 ) <> ' ' then begin
               fmgcodigo[ k ].memo1.SelStart := ini;
               fmgcodigo[ k ].memo1.SelLength := length( fte[ i ] );
               fmgcodigo[ k ].memo1.SelAttributes.Color := clgray;
            end;
         end;
         ini := ini + length( fte[ i ] ) + 2;
         }
      end;
      i := rg[ nn ].fteini - 2;
      while i > -1 do begin
         if ( trim( copy( fte[ i ], ignore, 1 ) ) = '' ) and ( trim( copy( fte[ i ], bc, ec-bc+1 ) ) <> '' ) then
            break;
         fmgcodigo[ k ].memo1.Lines.Insert( 0, fte[ i ] );
         {
         fmgcodigo[ k ].memo1.SelStart := 0;
         fmgcodigo[ k ].memo1.SelLength := length( fte[ i ] );
         fmgcodigo[ k ].memo1.SelAttributes.Color := clgray;
         }
         i := i - 1;
      end;
      fmgcodigo[ k ].show;
   except
      exit
   end;
end;

function Tfmgflcob.bPubVentanaActiva( sParCaption: String ): Boolean;
var
   i,k: Integer;
   bPriExisteFrm: Boolean;
begin
   //buscar si existe una ventana activa de acuerdo al caption de la forma a buscar
   bPriExisteFrm := False;
   k := length( fmgcodigo );

      for i := 0 to k -1 do begin
         if UpperCase( fmgcodigo[ i ].Caption ) = UpperCase( sParCaption ) then begin
            bPriExisteFrm := True;
            fmgcodigo[ i ].BringToFront;
            Break;
         end;
      end;

   bPubVentanaActiva := bPriExisteFrm;
end;

procedure Tfmgflcob.ventana1click( Sender: TObject );
begin
   fmgcodigo[ ( sender as Tmenuitem ).Tag ].WindowState := wsnormal;
   fmgcodigo[ ( sender as Tmenuitem ).Tag ].Top := mouse.CursorPos.Y - top - 100;
   fmgcodigo[ ( sender as Tmenuitem ).Tag ].show;
   fmgcodigo[ ( sender as Tmenuitem ).Tag ].bringtofront;
   fmgcodigo[ ( sender as Tmenuitem ).Tag ].Memo1.SetFocus;
end;
procedure Tfmgflcob.agrega_bloques;
var i,inicio_bloque,k2,m,contador_lab:integer;
   function inserta_bloque:boolean;
   var j:integer;
   begin
      if inicio_bloque>0 then begin       // insertará Bloque
         setlength(rg,length(rg)+1);
         for j:=0 to inicio_bloque-1 do begin  // corrige apuntadores de registros menores a inicio_bloque
            if rg[j].parfin>=inicio_bloque then
               inc(rg[j].parfin);
         end;
         for j:=length(rg)-1 downto inicio_bloque+1 do begin   // recorre los rg posteriores ajustando apuntadores
            rg[j].tipo:=rg[j-1].tipo;
            rg[j].seccion:=rg[j-1].seccion;
            rg[j].etiqueta:=rg[j-1].etiqueta;
            rg[j].fteini:=rg[j-1].fteini;
            rg[j].ftefin:=rg[j-1].ftefin;
            rg[j].parini:=rg[j-1].parini+1;
            rg[j].parfin:=rg[j-1].parfin;
            rg[j].nombre:=rg[j-1].nombre;
            rg[j].nombrethru:=rg[j-1].nombrethru;
            //if rg[j].parfin>=inicio_bloque+1 then
            if rg[j].parfin>=inicio_bloque then
               inc(rg[j].parfin);
         end;
         j:=inicio_bloque;
         rg[j].tipo:='BLQ';
         rg[j].etiqueta:='Bloque '+inttostr((contador_lab-1) div 50+1);
         rg[j].fteini:=1;
         rg[j].ftefin:=1;
         rg[j].parfin:=i;
         rg[j].nombre:=rg[j].etiqueta;
         rg[j].nombrethru:='';
         inserta_bloque:=true;
         exit;
      end;
      inserta_bloque:=false;
   end;
begin
   inicio_bloque:=0;
   contador_lab:=0;
   i:=0;
   while i < length(rg)-1 do begin
      if rg[i].tipo='SEC' then begin
         if contador_lab>50 then
            if inserta_bloque then
               inc(i);
         inicio_bloque:=0;
         contador_lab:=0;
      end;
      if rg[i].tipo='LAB' then begin
         if contador_lab mod 50 =0 then begin
            if inserta_bloque then
               inc(i);
            inicio_bloque:=i;
         end;
         inc(contador_lab);
      end;
      inc(i);
   end;
   if contador_lab>50 then
      inserta_bloque;
end;
procedure Tfmgflcob.arma( nombre_prog: string; archivo: string; nodotext: string );
var
   i, j, k, m: integer;
   kcnd, ksec, klab, kperf, keval, ksearch, kfun: array of integer;
   final: string;
   sep: Tstringlist;
   b_lab, b_else: boolean;
begin
   {
      nombre_prog:=paramstr(1);
      directiva:=paramstr(2);
      g_ruta:=paramstr(3);
      nodotext:=paramstr(4);
   }
   final := nombre_prog;
   while pos( '\', final ) > 0 do
      final := copy( final, pos( '\', final ) + 1, 500 );
   //caption := final;
   caption := titulo;
   fte := Tstringlist.Create;
   par := Tstringlist.Create;
   fte.LoadFromFile( nombre_prog );
   par.LoadFromFile( archivo );
   if copy(par[0],1,8)='ERROR...' then begin
      showmessage(par[0]);
      exit;
   end;
   kcics := -1;
   sep := Tstringlist.Create;
   setlength( rg, par.Count );
   for i := 0 to par.Count - 1 do begin
      final := inttostr( par.count );
      sep.CommaText := par[ i ];
      rg[ i ].tipo := sep[ 0 ];
      if sep.Count > 2 then
         rg[ i ].seccion := sep[ 2 ];
      if sep.Count > 1 then
         rg[ i ].fteini := strtoint( sep[ 1 ] );
      if sep.Count > 1 then
         rg[ i ].ftefin := strtoint( sep[ 1 ] );
      rg[ i ].parini := i;
      rg[ i ].parfin := i;
      if sep.Count > 3 then
         rg[ i ].etiqueta := sep[ 3 ]
      else
         rg[ i ].etiqueta := rg[ i ].seccion;
      if sep.Count > 4 then
         rg[ i ].nombre := sep[ 4 ]
      else
         rg[ i ].nombre := rg[ i ].etiqueta;
      if sep.Count > 5 then
         rg[ i ].nombrethru := sep[ 5 ]
      else
         rg[ i ].nombrethru := rg[ i ].nombre;
      {
            if rg[i].tipo='PER' then begin
               for j:=1 to length(rg[i].nombre) do
                  if (rg[i].nombre[j]>'9') or (rg[i].nombre[j]<'0') then  break;
               if j>length(rg[i].nombre) then
                  rg[i].tipo:='PVY';
            end;
      }
      if rg[ i ].tipo = 'INI' then begin
         rg[ i ].parfin := par.Count - 1;
         rg[ i ].ftefin := fte.Count;
      end
      else if rg[ i ].tipo = 'SEC' then begin
         rg[ i ].parfin := par.Count - 1;
         rg[ i ].ftefin := fte.Count;
         k := length( ksec );
         setlength( ksec, k + 1 );
         ksec[ k ] := i; // Cierra Section anterior
         if k > 0 then begin
            j := ksec[ k - 1 ];
            rg[ j ].parfin := i - 1;
            rg[ j ].ftefin := rg[ i ].fteini - 1;
         end;
         if b_lab then begin
            k := length( klab ); // Cierra el fin de etiqueta anterior
            if k > 0 then begin
               j := klab[ k - 1 ];
               rg[ j ].parfin := i - 1;
               rg[ j ].ftefin := rg[ i ].fteini - 1;
            end;
         end;
         b_lab := false;
      end
      else if rg[ i ].tipo = 'LAB' then begin
         rg[ i ].parfin := par.Count - 1;
         rg[ i ].ftefin := fte.Count;
         k := length( klab );
         setlength( klab, k + 1 );
         klab[ k ] := i;
         if b_lab then begin
            if k > 0 then begin
               j := klab[ k - 1 ];
               rg[ j ].parfin := i - 1;
               rg[ j ].ftefin := rg[ i ].fteini - 1;
            end;
         end;
         b_lab := true;
      end
      else if rg[ i ].tipo = 'CND' then begin
         k := length( kcnd );
         if uppercase( rg[ i ].nombre ) = 'IF' then begin
            setlength( kcnd, k + 1 );
            kcnd[ k ] := i;
            b_else := false;
         end;
         if uppercase( rg[ i ].nombre ) = 'ELSE' then begin
            if k = 0 then begin
               Application.MessageBox( pchar( dm.xlng( 'Error... ELSE sin IF' ) ),
                  pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
            end
            else begin
               j := kcnd[ k - 1 ];
               while uppercase( rg[ j ].nombre ) = 'ELSE' do begin
                  rg[ j ].parfin := i - 1;
                  if rg[ j ].fteini > rg[ i ].fteini - 1 then
                     rg[ j ].ftefin := rg[ i ].fteini
                  else
                     rg[ j ].ftefin := rg[ i ].fteini - 1;
                  if k = 0 then begin
                     Application.MessageBox( pchar( dm.xlng( 'Error... ELSE sin IF' ) ),
                        pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
                     break;
                  end;
                  if k > 0 then begin
                     setlength( kcnd, k - 1 );
                     k := k - 1;
                     j := kcnd[ k - 1 ];
                  end;
               end;
               //               if (b_else) and (k>1) then begin
               //                  j:=kcnd[k-1];
               //                  rg[j].parfin:=i-1;
               //                  rg[j].ftefin:=rg[i].fteini-1;
               //                  setlength(kcnd,k-1);
               //                  k:=k-1;
               //               end;
               //               j:=kcnd[k-1];
               rg[ j ].parfin := i - 1;
               if rg[ j ].fteini > rg[ i ].fteini - 1 then
                  rg[ j ].ftefin := rg[ i ].fteini
               else
                  rg[ j ].ftefin := rg[ i ].fteini - 1;
            end;
            if k > 0 then begin
               kcnd[ k - 1 ] := i;
               b_else := true;
            end;
         end;
         if uppercase( rg[ i ].nombre ) = 'END-IF' then begin
            if k = 0 then begin
               Application.MessageBox( pchar( dm.xlng( 'Error... END-IF sin IF' ) ),
                  pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
            end
            else begin
               j := kcnd[ k - 1 ];
               rg[ j ].parfin := i - 1;
               if rg[ j ].fteini > rg[ i ].fteini - 1 then
                  rg[ j ].ftefin := rg[ i ].fteini
               else
                  rg[ j ].ftefin := rg[ i ].fteini - 1;
            end;
            if k > 0 then begin
               setlength( kcnd, k - 1 );
               b_else := false;
            end;
         end;
         if rg[ i ].nombre = 'DOT' then begin
            if k > 0 then begin
               for m := 0 to k - 1 do begin
                  j := kcnd[ m ];
                  rg[ j ].parfin := i;
                  rg[ j ].ftefin := rg[ i ].fteini;
               end;
            end;
            setlength( kcnd, 0 );
            b_else := false;
         end;
         if rg[ i ].nombre = 'EVALUATE' then begin
            k := length( keval );
            setlength( keval, k + 1 );
            keval[ k ] := i;
         end;
         if rg[ i ].nombre = 'WHEN' then begin
            k := length( keval );
            if k = 0 then begin
               Application.MessageBox( pchar( dm.xlng( 'Error... WHEN sin EVALUATE' ) ),
                  pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
            end
            else begin
               j := keval[ k - 1 ];
               rg[ j ].parfin := i - 1;
               rg[ j ].ftefin := rg[ i ].fteini - 1;
               keval[ k - 1 ] := i;
            end;
            keval[ k - 1 ] := i;
         end;
         if rg[ i ].nombre = 'END-EVALUATE' then begin
            k := length( keval );
            if k = 0 then begin
               Application.MessageBox( pchar( dm.xlng( 'Error... END-EVALUATE sin EVALUATE' ) ),
                  pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
            end
            else begin
               j := keval[ k - 1 ];
               rg[ j ].parfin := i - 1;
               rg[ j ].ftefin := rg[ i ].fteini - 1;
            end;
            setlength( keval, k - 1 );
         end;
         if rg[ i ].nombre = 'SEARCH' then begin
            k := length( ksearch );
            setlength( ksearch, k + 1 );
            ksearch[ k ] := i;
         end;
         if rg[ i ].nombre = 'SWHEN' then begin
            k := length( ksearch );
            if k = 0 then begin
               Application.MessageBox( pchar( dm.xlng( 'Error... WHEN sin SEARCH' ) ),
                  pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
            end
            else begin
               j := ksearch[ k - 1 ];
               rg[ j ].parfin := i - 1;
               rg[ j ].ftefin := rg[ i ].fteini - 1;
               ksearch[ k - 1 ] := i;
            end;
            ksearch[ k - 1 ] := i;
         end;
         if rg[ i ].nombre = 'AT-END' then begin
            k := length( ksearch );
            if k = 0 then begin
               Application.MessageBox( pchar( dm.xlng( 'Error... AT END sin SEARCH' ) ),
                  pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
            end
            else begin
               j := ksearch[ k - 1 ];
               rg[ j ].parfin := i - 1;
               rg[ j ].ftefin := rg[ i ].fteini - 1;
               ksearch[ k - 1 ] := i;
            end;
            ksearch[ k - 1 ] := i;
         end;
         if rg[ i ].nombre = 'END-SEARCH' then begin
            k := length( ksearch );
            if k = 0 then begin
               Application.MessageBox( pchar( dm.xlng( 'Error... END-EVALUATE sin EVALUATE' ) ),
                  pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
            end
            else begin
               j := ksearch[ k - 1 ];
               rg[ j ].parfin := i - 1;
               rg[ j ].ftefin := rg[ i ].fteini - 1;
            end;
            setlength( ksearch, k - 1 );
         end;
      end
      else if rg[ i ].tipo = 'PVY' then begin
         k := length( kperf );
         setlength( kperf, k + 1 );
         kperf[ k ] := i;
      end
      else if rg[ i ].tipo = 'EPE' then begin
         k := length( kperf );
         if k = 0 then begin
            Application.MessageBox( pchar( dm.xlng( 'Error... END-PERFORM sin PERFORM' ) ),
               pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
         end
         else begin
            j := kperf[ k - 1 ];
            rg[ j ].parfin := i - 1;
            rg[ j ].ftefin := rg[ i ].fteini - 1;
         end;
         setlength( kperf, k - 1 );
      end
      else if rg[ i ].tipo = 'FUN' then begin
         k := length( kfun );
         setlength( kfun, k + 1 );
         kfun[ k ] := i;
      end
      else if rg[ i ].tipo = 'EFU' then begin
         k := length( kfun );
         if k = 0 then begin
            Application.MessageBox( pchar( dm.xlng( 'Error... END-FUNCION sin FUNCION' ) ),
               pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
         end
         else begin
            j := kfun[ k - 1 ];
            rg[ j ].parfin := i - 1;
            rg[ j ].ftefin := strtoint( sep[ 1 ] );
         end;
         setlength( kfun, k - 1 );
      end
      else if rg[ i ].tipo = 'CIC' then begin
         kcics := i;
      end
      else if rg[ i ].tipo = 'ECI' then begin
         if kcics = -1 then begin
            Application.MessageBox( pchar( dm.xlng( 'Error... END-EXEC sin EXEC CICS' ) ),
               pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
         end
         else begin
            rg[ kcics ].parfin := i;
            rg[ kcics ].ftefin := rg[ i ].fteini;
         end;
         kcics := -1;
      end
      else if ( rg[ i ].tipo = 'SQL' ) or
         ( rg[ i ].tipo = 'SEL' ) or
         ( rg[ i ].tipo = 'SIN' ) or
         ( rg[ i ].tipo = 'SUP' ) or
         ( rg[ i ].tipo = 'SDL' ) or
         ( rg[ i ].tipo = 'SOP' ) or
         ( rg[ i ].tipo = 'SFE' ) or
         ( rg[ i ].tipo = 'SCL' ) then begin
         for j := rg[ i ].fteini - 1 downto 0 do begin
            if pos( ' EXEC', uppercase( fte[ j ] ) ) > 0 then begin
               rg[ i ].fteini := j + 1;
               break;
            end;
         end;
         for j := rg[ i ].fteini - 1 to fte.Count - 1 do begin
            if pos( 'END-EXEC', uppercase( fte[ j ] ) ) > 0 then begin
               rg[ i ].ftefin := j + 1;
               break;
            end;
         end;
      end;
   end;
   k := length( ksec );
   //   ksec[k]:=i;                 // Cierra Section anterior
   if k > 0 then begin
      j := ksec[ k - 1 ];
      rg[ j ].parfin := i - 1;
      rg[ j ].ftefin := rg[ i - 1 ].ftefin;
   end;
   k := length( klab ); // Cierra el fin de etiqueta anterior
   if k > 0 then begin
      j := klab[ k - 1 ];
      rg[ j ].parfin := i - 1;
      rg[ j ].ftefin := rg[ i - 1 ].ftefin;
   end;
   agrega_bloques;
   {
   sep.Clear;
   {}{
   sg.RowCount := par.Count;
   sg.ColCount := bc;
   }{
   for i := 0 to length(rg)- 1 do begin
   {}{
      sg.Cells[ 0, i ] := rg[ i ].tipo;
      sg.Cells[ 1, i ] := rg[ i ].seccion;
      sg.Cells[ 2, i ] := rg[ i ].etiqueta;
      sg.Cells[ 3, i ] := inttostr( rg[ i ].fteini );
      sg.Cells[ 4, i ] := inttostr( rg[ i ].ftefin );
      sg.Cells[ 5, i ] := inttostr( rg[ i ].parini );
      sg.Cells[ 6, i ] := inttostr( rg[ i ].parfin );
      sg.Cells[ 7, i ] := rg[ i ].nombre;
      }{
      sep.Add(rg[ i ].tipo+','+
      rg[ i ].seccion+','+
       rg[ i ].etiqueta+','+
       inttostr( rg[ i ].fteini )+','+
       inttostr( rg[ i ].ftefin )+','+
       inttostr( rg[ i ].parini )+','+
       inttostr( rg[ i ].parfin )+','+
       rg[ i ].nombre);
   end;

   sep.SaveToFile(nombre_prog+'sep.csv');
   {}
   crea( 0, 0, 0, q );
end;

procedure Tfmgflcob.desplaza( y, z: integer );
var
   i,j: integer;
begin
   if z = 0 then
      exit;
   j:=VertScrollBar.Position;  // para restablecer la posicion
   max_y:=0;
   for i := 0 to componentcount - 1 do begin
      if components[ i ] is Tfrcob then begin
         q := ( components[ i ] as Tfrcob );
         if ( q.Visible ) and ( q.Top > y ) then begin
            q.Top := q.Top + z;
            if q.top>32000 then begin   // corrige limite de forma
               VertScrollBar.Position:=VertScrollBar.Position+30000;
            end;
            if q.Top>max_y then
               max_y:=q.Top;
         end;
      end;
   end;
   lblsysviewsoft.Top:=max_y+1000;
   VertScrollBar.Position:=j;  //  restablecer la posicion
end;

procedure Tfmgflcob.Crea( n, x, y: integer; var q: Tfrcob );
var
   i: integer;
begin
   if rg[ n ].tipo = 'PER' then begin
      for i := 0 to length( rg ) - 1 do begin
         if ( rg[ i ].tipo = 'SEC' ) and ( rg[ i ].seccion = rg[ n ].nombre ) then begin
            n := i;
            break;
         end;
         if ( rg[ i ].tipo = 'LAB' ) and ( rg[ i ].etiqueta = rg[ n ].nombre ) then begin
            n := i;
            break;
         end;
      end;
   end;
   if rg[ n ].tipo = 'PTH' then begin
      for i := 0 to length( rg ) - 1 do begin
         if ( rg[ i ].tipo = 'SEC' ) and ( rg[ i ].seccion = rg[ n ].nombre ) then begin
            rg[ n ].parini := rg[ i ].parini - 1;
            rg[ n ].fteini := rg[ i ].fteini;
         end;
         if ( rg[ i ].tipo = 'LAB' ) and ( rg[ i ].etiqueta = rg[ n ].nombre ) then begin
            rg[ n ].parini := rg[ i ].parini - 1;
            rg[ n ].fteini := rg[ i ].fteini;
         end;
         if ( rg[ i ].tipo = 'SEC' ) and ( rg[ i ].seccion = rg[ n ].nombrethru ) then begin
            rg[ n ].parfin := rg[ i ].parfin;
            rg[ n ].ftefin := rg[ i ].ftefin;
         end;
         if ( rg[ i ].tipo = 'LAB' ) and ( rg[ i ].etiqueta = rg[ n ].nombrethru ) then begin
            rg[ n ].parfin := rg[ i ].parfin;
            rg[ n ].ftefin := rg[ i ].ftefin;
         end;
      end;
   end;
   q := Tfrcob.Create( self );
   q.Visible := false;
   q.Parent := self;
   q.Name := 'q' + inttostr( nn );
   nn := nn + 1;
   q.Left := x;
   q.Top := y;
   q.xtipo( n, x, y );
   desplaza( q.Top - 1, 30 );
   q.bot.Visible := false;
   for i := rg[ n ].parini + 1 to rg[ n ].parfin do
      if ( rg[ i ].nombre <> 'DOT' ) then
         q.bot.Visible := true;
   q.nodotext := nodotext;
   q.Visible := true;
   //   invalidate;
end;

procedure Tfmgflcob.pinta( canva: Tcanvas );
var
   i, j, k, sng, nx, ny: integer;
   flecha: integer;
   q: Tfrcob;
begin
   for i := 0 to componentcount - 1 do begin
      if components[ i ] is Tfrcob then begin
         q := ( components[ i ] as Tfrcob );
         if q.texto <> nil then begin
            Canva.Pen.Width := 1;
            canva.MoveTo( q.left + q.Width, q.top );
            canva.LineTo( q.texto.Left, q.texto.Top + ( q.texto.Height div 2 ) );
         end;
         if ( q.bot.Caption = '+' ) or ( q.Visible = false ) then
            continue;
         Canva.Pen.Width := 2;
         Canva.pen.Color := clblack;
         nx := q.Left + q.Width;
         ny := q.Top + ( q.Height div 2 );
         Canva.MoveTo( nx, ny );
         Canva.LineTo( nx + 10, ny );
         j := length( q.xx ) - 1;
         Canva.LineTo( nx + 10, q.ultimotop );
      end;
   end;
end;

procedure Tfmgflcob.FormPaint( Sender: TObject );
begin
   pinta( canvas );
end;

procedure Tfmgflcob.FormDragOver( Sender, Source: TObject; X, Y: Integer;
   State: TDragState; var Accept: Boolean );
begin
   accept := source is trichedit;
   if source is Trichedit then
      ( source as Trichedit ).Visible := false;
end;

procedure Tfmgflcob.FormDragDrop( Sender, Source: TObject; X, Y: Integer );
begin
   if source is trichedit then begin
      ( source as Trichedit ).Top := y - 25;
      ( source as Trichedit ).left := x - 60;
      ( source as Trichedit ).Visible := true;
      invalidate;
   end;
end;

procedure Tfmgflcob.FormDblClick( Sender: TObject );
begin
//   if colordialog1.Execute then
//      color := colordialog1.Color;
end;

procedure Tfmgflcob.FormClose( Sender: TObject; var Action: TCloseAction );
begin
   if FormStyle = fsMDIChild then
      Action := caFree;

   dm.PubEliminarVentanaActiva(Caption);  //quitar nombre de lista de abiertos
   gral.borra_elemento(Caption,7);     //borrar elemento del arreglo de productos
   farbol.borra_elemento_a(Caption,7);     //borrar elemento del arreglo de productos
end;

procedure Tfmgflcob.FormDestroy(Sender: TObject);
begin
   dm.PubEliminarVentanaActiva( caption );

   if gral.iPubVentanasActivas in [ 0, 1 ] then
      gral.PubExpandeMenuVentanas( False );
end;


procedure Tfmgflcob.FormCreate(Sender: TObject);
begin
   if gral.iPubVentanasActivas > 0 then  
      gral.PubExpandeMenuVentanas( True );
   bc:=8;
   ec:=72;
   ignore:=7;
end;


procedure Tfmgflcob.FormActivate(Sender: TObject);
var
   i,ki,k : integer;
   ventana:tmenuitem;
begin
      g_producto:='MENÚ CONTEXTUAL-DIAGRAMA DE FLUJO  COBOL';
      k := length( fmgcodigo );
      for ki := 0 to k -1  do begin
         ventana := Tmenuitem.Create( self );
         ventana.Caption := inttostr( ki ) + '_' + fmgcodigo[ ki ].Caption;
         ventana.Tag := ki;
         ventana.OnClick := ventana1click;
         gral.PopGral.Items.Add( ventana );
      end;
      iHelpContext := IDH_TOPIC_T02500;
end;

procedure Tfmgflcob.FormDeactivate(Sender: TObject);
begin
  gral.PopGral.Items.Clear;
end;

procedure Tfmgflcob.mnuAyudaClick(Sender: TObject);
  var CallHelp: Boolean;
begin
   try
     PR_BARRA;
     //iHelpContext:=IDH_TOPIC_T02500;
      HtmlHelp(Application.Handle,
            PChar(Format('%s::/T%5.5d.htm',
           //[Application.HelpFile,ActiveControl.HelpContext])),HH_DISPLAY_TOPIC, 0);
           [Application.HelpFile,iHelpContext])),HH_DISPLAY_TOPIC, 0);
   except
      Application.MessageBox( 'No existe ayuda para la pantalla ó campo seleccionado','Ayuda ' , MB_OK );
   end;
end;

procedure Tfmgflcob.dxBarButton1Click(Sender: TObject);
var
   x,n,m:integer;
   linea:string;
   lista,claves,clavesk:Tstringlist;
   f: TextFile;
   contador:integer;
   function trae_nombre(j:integer):string;
   begin
      if rg[j].tipo='LAB' then begin
         trae_nombre:=rg[j].nombre;
      end
      else if (rg[j].tipo='CND') and (rg[j].nombre='DOT') then begin
         trae_nombre:='*';
      end
      else if (rg[j].tipo='CND') and (rg[j].nombre='IF') then begin
         trae_nombre:=stringreplace(trim(copy(fte[rg[j].fteini-1],bc,ec-bc+1)),'-','- ',[rfreplaceall]);
      end
      else if rg[j].tipo='PVY' then begin
         trae_nombre:=stringreplace(trim(copy(fte[rg[j].fteini-1],bc,ec-bc+1)),'-','- ',[rfreplaceall]);
      end
      else if (rg[j].tipo='CND') and (rg[j].nombre='EVALUATE') then begin
         trae_nombre:=stringreplace(trim(copy(fte[rg[j].fteini-1],bc,ec-bc+1)),'-','- ',[rfreplaceall]);
      end
      else if (rg[j].tipo='CND') and (rg[j].nombre='WHEN') then begin
         trae_nombre:=stringreplace(trim(copy(fte[rg[j].fteini-1],bc,ec-bc+1)),'-','- ',[rfreplaceall]);
      end
      else if (rg[j].tipo='SEC') then begin
         trae_nombre:='SECTION '+rg[j].nombre;
      end
      else if (rg[j].tipo='CAL') then begin
         trae_nombre:=stringreplace(trim(copy(fte[rg[j].fteini-1],bc,ec-bc+1)),'-','- ',[rfreplaceall]);
      end
      else if (rg[j].tipo='PTH') then begin
         trae_nombre:=rg[j].nombre+' THRU '+rg[j].nombrethru;
      end
      else if (rg[j].tipo='GOT') then begin
         trae_nombre:='GO TO '+rg[j].nombre;
      end
      else
         trae_nombre:=stringreplace(trim(copy(fte[rg[j].fteini-1],bc,ec-bc+1)),'-','- ',[rfreplaceall]);
         //trae_nombre:=rg[j].nombre;
   end;
   procedure nuevo_elemento(j:integer);
   var tipo:string;
      k,m:integer;
   begin
      tipo:=rg[j].tipo;
      if (tipo='CND') then
         tipo:=rg[j].nombre
      else begin
         k:=clavesk.IndexOf(tipo);
         if k>-1 then
            tipo:=copy(claves[k],7,100);
      end;
      write(f,tipo+',');
      for m:=1 to x do
         write(f,',');
      WriteLn(f,trae_nombre(j));
      inc(contador);
      if contador mod 500000 =0 then begin
         closefile(f);
         AssignFile(f, stringreplace(lowercase(savedialog1.FileName),'.csv','_'+inttostr((contador div 500000)+1000)+'.csv',[]));
         Rewrite(f);
      end;
   end;
   function expande(ini,fin:integer; lst:Tstringlist):integer;
   var j,k,z_rg:integer;
      lista:Tstringlist;
      b_thru:boolean;
   begin
      inc(x);
      j:=ini;
      z_rg:=length(rg);
      lista:=Tstringlist.Create;
      lista.AddStrings(lst);
      while j<=fin do begin
         if rg[j].tipo='BLQ' then begin // ignora los bloques
            inc(j);
            continue;
         end;
         if (j<z_rg-1) and
            (rg[j].tipo='SEC') and
            (rg[j].nombre='MAIN') and
            (rg[j+1].tipo='SEC') then begin
            inc(j);
            continue;
         end;
         if (rg[j].tipo='CND') and
            (rg[j].nombre='DOT') then begin
            x:=x-1;
            nuevo_elemento(j);
            x:=x+1;
            inc(j);
            continue;
         end;
         nuevo_elemento(j);
         {
         if (rg[j].tipo='CND') or
            (rg[j].tipo='INI') or
            (rg[j].tipo='SEC') or
            (rg[j].tipo='LAB') then
         }
         if rg[j].parini<rg[j].parfin then
            j:=expande(rg[j].parini+1,rg[j].parfin,lista)
         else
         if (rg[j].tipo='PER') then begin
            if lista.IndexOf(rg[j].nombre)=-1 then begin
               lista.Add(rg[j].nombre);
               for k:=0 to z_rg-1 do begin         // busca LABEL o SECTION y lo expande
                  if ((rg[k].tipo='LAB') or (rg[k].tipo='SEC')) and (rg[k].nombre=rg[j].nombre) then begin
                     expande(rg[k].parini+1,rg[k].parfin,lista);
                     break;
                  end;
               end;
            end;
            inc(j);
         end
         else
         if (rg[j].tipo='PTH') then begin
            if lista.IndexOf(rg[j].nombre+'_'+rg[j].nombrethru)=-1 then begin
               lista.Add(rg[j].nombre+'_'+rg[j].nombrethru);
               b_thru:=false;
               for k:=0 to z_rg-1 do begin         // busca LABEL o SECTION inicial y final y los expande
                  if (b_thru) and ((rg[k].tipo='LAB') or (rg[k].tipo='SEC')) and (rg[k].nombre=rg[j].nombrethru) then begin
                     inc(x);
                     nuevo_elemento(k);
                     expande(rg[k].parini+1,rg[k].parfin,lista);
                     x:=x-1;
                     break;
                  end;
                  if (b_thru) and ((rg[k].tipo='LAB') or (rg[k].tipo='SEC')) then begin
                     inc(x);
                     nuevo_elemento(k);
                     expande(rg[k].parini+1,rg[k].parfin,lista);
                     x:=x-1;
                     continue;
                  end;
                  if (b_thru=false) and ((rg[k].tipo='LAB') or (rg[k].tipo='SEC')) and (rg[k].nombre=rg[j].nombre) then begin
                     inc(x);
                     nuevo_elemento(k);
                     expande(rg[k].parini+1,rg[k].parfin,lista);
                     b_thru:=true;
                     x:=x-1;
                     continue;
                  end;
               end;
            end;
            inc(j);
         end
         else
            inc(j);
      end;
      lista.Free;
      x:=x-1;
      expande:=fin+1;
   end;
begin
   screen.Cursor:=crsqlwait;
   savedialog1.DefaultExt:='csv';
   savedialog1.Filter := 'CSV files (*.csv)';
   savedialog1.Options:=[ofOverwritePrompt];

//   savedialog1.FileName:=titulo;
   if savedialog1.Execute=false then begin
      screen.Cursor:=crDefault;
      exit;
   end;
   claves:=Tstringlist.Create;
   clavesk:=Tstringlist.Create;
   {
   claves.Add('CAL - CALL rutina_externa');
   claves.Add('CCA - CICS LINK PROGRAM');
   claves.Add('CIC - Comando CICS');
   claves.Add('CLO - CLOSE Archivo');
   claves.Add('COP - COPY');
   claves.Add('CXC - CICS XCTL PROGRAM');
   claves.Add('DEL - DELETE Registro');
   claves.Add('DOT - Final de IF/ELSE/EVALUATE/WHEN/AT END');
   claves.Add('END - STOP RUN/GOBACK/CICS RETURN');
   claves.Add('EPE - Final de PERFORM');
   claves.Add('EXT - OPEN EXTEND Archivo');
   claves.Add('GOT - GO TO Etiqueta');
   claves.Add('I-O - OPEN I-O Archivo');
   claves.Add('INI - Inicio');
   claves.Add('INP - OPEN INPUT Archivo');
   claves.Add('LAB - Etiqueta de Rutina');
   claves.Add('OUT - OPEN OUTPUT Archivo');
   claves.Add('PER - PERFORM Etiqueta1');
   claves.Add('PTH - PERFORM Etiqueta1 THRU Etiqueta2');
   claves.Add('PVY - PERFORM Varying/Until');
   claves.Add('REA - READ Archivo/RETURN Archivo Sort');
   claves.Add('REW - REWRITE Registro');
   claves.Add('SCL - Comando SQL CLOSE');
   claves.Add('SDL - Comando SQL DELETE');
   claves.Add('SEC - SECTION');
   claves.Add('SEL - Comando SQL SELECT');
   claves.Add('SIN - Comando SQL INSERT');
   claves.Add('SOP - Comando SQL OPEN');
   claves.Add('SQL - Final de comando SQL');
   claves.Add('SUP - Comando SQL UPDATE');
   claves.Add('SOR - SORT');
   claves.Add('WRI - WRITE Registro/RELEASE Archivo Sort');
   }
   claves.Add('CAL - CALL');
   claves.Add('CCA - CICS LINK');
   claves.Add('CIC - CICS');
   claves.Add('CLO - CLOSE');
   claves.Add('COP - COPY');
   claves.Add('CXC - CICS XCTL');
   claves.Add('DEL - DELETE');
   claves.Add('DOT - Final de IF/ELSE/EVALUATE/WHEN/AT END');
   claves.Add('END - END');
   claves.Add('EPE - END-PERFORM');
   claves.Add('EXT - OPEN EXTEND');
   claves.Add('GOT - GO TO');
   claves.Add('I-O - OPEN I-O');
   claves.Add('INI - PROGRAM-ID');
   claves.Add('INP - OPEN INPUT');
   claves.Add('LAB - PARAGRAPH');
   claves.Add('OUT - OPEN OUTPUT');
   claves.Add('PER - PERFORM');
   claves.Add('PTH - PERFORM THRU');
   claves.Add('PVY - PERFORM VARYING');
   claves.Add('REA - READ');
   claves.Add('REL - RELEASE');
   claves.Add('RET - RETURN');
   claves.Add('REW - REWRITE');
   claves.Add('SCL - SQL CLOSE');
   claves.Add('SDL - SQL DELETE');
   claves.Add('SEC - SECTION');
   claves.Add('SEL - SQL SELECT');
   claves.Add('SIN - SQL INSERT');
   claves.Add('SOP - SQL OPEN');
   claves.Add('SQL - END-SQL');
   claves.Add('SUP - SQL UPDATE');
   claves.Add('SOR - SORT');
   claves.Add('WRI - WRITE');
   for x:=0 to claves.Count-1 do
      clavesk.Add(copy(claves[x],1,3));
   lista:=Tstringlist.create;
   x:=-1;
   contador:=0;
   AssignFile(f, savedialog1.FileName);
   try
      Rewrite(f);
   except
      application.MessageBox('No puede crear el archivo, verifique que no esté en uso','Error',MB_OK);
      screen.Cursor:=crDefault;
      exit;
   end;
   expande(rg[0].parini,rg[0].parfin,lista);
   lista.Free;
   claves.Free;
   clavesk.Free;
   CloseFile(f);
   screen.Cursor:=crDefault;
   if contador>500000 then
      showmessage('Salida muy grande, se crearon '+inttostr(contador div 500000)+' extensiones');
end;

end.


