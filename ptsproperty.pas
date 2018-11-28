unit ptsproperty;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, StdCtrls, ExtCtrls, Grids, ValEdit, HTML_HELP;

type
   Tftsproperty = class( TForm )
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
      procedure arma( compo: string; bib: string; clase: string; sistema: string );
   end;

var
   ftsproperty: Tftsproperty;

implementation
uses ptsdm, parbol, ptsgral;
{$R *.dfm}

procedure Tftsproperty.arma( compo: string; bib: string; clase: string; sistema: string );
var
   i: integer;
   slTitulo: string;
   consulta : String;  //alk

   // ------- ALK para mandar al usuario comentario del resultado de complejidad McCabe ----------
   function mccabe(valor : String):String;
   var
      cons : String;
   begin
      cons:='select EVALUACION_RIESGO from ts_riesgo where ' +
            valor + ' between valor_minimo and valor_maximo';
      if dm.sqlselect(dm.q2,cons) then
         Result:= dm.q2.FieldByName( 'EVALUACION_RIESGO' ).AsString
      else
         Result:= 'Fuera de rango';
   end;

begin
   caption := titulo;
   slTitulo := '';

   // Para los primeros datos que se refieren a las lineas
   consulta:= 'select * from tsproperty ' +
      ' where cprog=' + g_q + compo + g_q +
      ' and   cbib=' + g_q + bib + g_q +
      ' and   cclase=' + g_q + clase + g_q;
   if dm.sqlselect( dm.q1, consulta ) then begin
      for i := 0 to dm.q1.FieldCount - 1 do begin
         if ( dm.q1.Fields[ i ].FieldName = 'CPROG' ) or
            ( dm.q1.Fields[ i ].FieldName = 'CBIB' ) or
            ( dm.q1.Fields[ i ].FieldName = 'CCLASE' ) then
            continue;
         if dm.q1.Fields[ i ].FieldName = 'LINEAS_TOTAL' then
            slTitulo := 'Total líneas '
         else
            if dm.q1.Fields[ i ].FieldName = 'LINEAS_BLANCO' then
               slTitulo := 'Líneas en blanco '
            else
               if dm.q1.Fields[ i ].FieldName = 'LINEAS_COMENTARIO' then
                  slTitulo := 'Líneas de comentario '
               else
                  if dm.q1.Fields[ i ].FieldName = 'LINEAS_EFECTIVAS' then
                     slTitulo := 'Líneas efectivas '
                  {else
                     if dm.q1.Fields[ i ].FieldName = 'NUM_COMANDOS' then
                        slTitulo := 'Número de comandos '; }
                  else
                     slTitulo :='';

         //vle.InsertRow( dm.q1.Fields[ i ].FieldName, dm.q1.Fields[ i ].AsString, true );
         if slTitulo <> '' then
            vle.InsertRow( slTitulo, dm.q1.Fields[ i ].AsString, true );
      end;
   end;

   // Para añadir datos de la tabla de Carlos ts_estad_complej  de complejidad
   //Validar primero que exista la tabla, de lo contrario mandara error.
   //----------- Cmplejidad Halstead ----------------------------
   consulta:= 'select * from ts_estad_complej ' +
      ' where cprog=' + g_q + compo + g_q +
      ' and   cbib=' + g_q + bib + g_q +
      ' and   cclase=' + g_q + clase + g_q;
   if dm.sqlSelectBFile( dm.q1, consulta ) then begin
      for i := 0 to dm.q1.FieldCount - 1 do begin
         slTitulo := '';
         // aqui se le pone el titulo con respecto al nombre de la columna
         if ( dm.q1.Fields[ i ].FieldName = 'CPROG' ) or
            ( dm.q1.Fields[ i ].FieldName = 'CBIB' ) or
            ( dm.q1.Fields[ i ].FieldName = 'SISTEMA' ) or
            ( dm.q1.Fields[ i ].FieldName = 'CCLASE' ) then
            continue;

         if dm.q1.Fields[ i ].FieldName = 'VOCABULARIO' then
            slTitulo := 'Vocabulario ';
         if dm.q1.Fields[ i ].FieldName = 'LONGITUD' then
            slTitulo := 'Longitud ';
         if dm.q1.Fields[ i ].FieldName = 'DURACION' then
            slTitulo := 'Duración ';
         if dm.q1.Fields[ i ].FieldName = 'VOLUMEN' then
            slTitulo := 'Volumen ';
         if dm.q1.Fields[ i ].FieldName = 'DIFICULTAD' then
            slTitulo := 'Dificultad ';
         if dm.q1.Fields[ i ].FieldName = 'ESFUERZO' then
            slTitulo := 'Esfuerzo ';
         if dm.q1.Fields[ i ].FieldName = 'TIEMPO' then
            slTitulo := 'Tiempo ';
         if dm.q1.Fields[ i ].FieldName = 'ERRORES' then
            slTitulo := 'Errores ';

         //Complejidad McCabe
         if dm.q1.Fields[ i ].FieldName = 'N_NODOS' then
            slTitulo := 'Nodos ';
         if dm.q1.Fields[ i ].FieldName = 'N_ARISTAS' then
            slTitulo := 'Aristas ';
         if dm.q1.Fields[ i ].FieldName = 'N_RESULTADO' then
            slTitulo := 'Resultado McCabe ';


         if slTitulo <> '' then begin
            if slTitulo = 'Vocabulario ' then
               vle.InsertRow( '-- COMPLEJIDAD HALSTEAD --',' ', true );
            if slTitulo = 'Nodos ' then
               vle.InsertRow( '-- COMPLEJIDAD McCABE --',' ', true );

            if slTitulo = 'Resultado McCabe ' then begin
               vle.InsertRow( slTitulo, mccabe(dm.q1.Fields[ i ].AsString), true );
            end
            else
               vle.InsertRow( slTitulo, dm.q1.Fields[ i ].AsString, true );
         end;
      end;
   end;


   // Para los primeros datos que se refieren a los programas que contiene
   consulta:= 'select hcclase,descripcion,count(*) cuenta from tsrela,tsclase ' +
      ' where hcclase=cclase ' +
      ' and   pcprog=' + g_q + compo + g_q +
      ' and   pcbib=' + g_q + bib + g_q +
      ' and   pcclase=' + g_q + clase + g_q +
      ' group by hcclase,descripcion ' +
      ' order by hcclase';
   if dm.sqlselect( dm.q1, consulta ) then begin
      while not dm.q1.Eof do begin
         vle.InsertRow( dm.q1.fieldbyname( 'hcclase' ).AsString + ' - ' +
            dm.q1.fieldbyname( 'descripcion' ).AsString,
            dm.q1.fieldbyname( 'cuenta' ).AsString, true );
         dm.q1.Next;
      end;
   end;
end;

procedure Tftsproperty.bokClick( Sender: TObject );
begin
   close;
end;

procedure Tftsproperty.FormClose( Sender: TObject;
   var Action: TCloseAction );
begin
   if FormStyle = fsMDIChild then
      Action := caFree;
end;

procedure Tftsproperty.FormDestroy(Sender: TObject);
begin
    dm.PubEliminarVentanaActiva( Caption );

   if gral.iPubVentanasActivas in [ 0, 1 ] then  
      gral.PubExpandeMenuVentanas( False );
end;
procedure Tftsproperty.FormCreate(Sender: TObject);
begin
  if gral.iPubVentanasActivas > 0 then  
      gral.PubExpandeMenuVentanas( True );
end;

procedure Tftsproperty.FormActivate(Sender: TObject);
begin
   iHelpContext:=IDH_TOPIC_T02900;
end;

end.

