unit UfmRefCruz;

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
   cxLookAndFeelPainters, StrUtils, HTML_HELP, cxTimeEdit, dxStatusBar;

type
   estruc_hijos = record
      id : integer;
      comp : string;
      bib : string;
      cla : string;
end;

type
   ref_cruz = record
      id : integer;
      o_comp : string;
      o_bib : string;
      o_cla : string;
      h_comp : string;
      h_bib : string;
      h_cla : string;
end;


type
   TfmRefCruz = class( TfmSVSLista )
      mm: TMemo;
      ImageList2: TImageList;
      dxBarButton4: TdxBarButton;
      mnuHeaderHeight: TdxBarSpinEdit;
      cxStyle12: TcxStyle;
      procedure bsalirClick( Sender: TObject );
      procedure Notepad1Click( Sender: TObject );
//      procedure sqlParaWeb( clase: string; bib: string; nombre: string; sistema: string );
      procedure sqlParaWeb_alk( clase: string; bib: string; nombre: string; sistema: string );  //con la consulta sugerida por carlos   ALK
      //procedure LlenaArreglos( clase: string; bib: string; nombre: string; sistema: string );
      //procedure CreaGrid( Sender: TObject );
      function TipoNumeroAcceso( b1: string; b2: string ): string;
      procedure FormClose( Sender: TObject; var Action: TCloseAction );
      procedure Web1ProgressChange( Sender: TObject; Progress,
         ProgressMax: Integer );
      procedure FormCreate( Sender: TObject );
      procedure FormDeactivate( Sender: TObject );
      procedure FormActivate( Sender: TObject );
      procedure grdDatosDBTableView1CustomDrawColumnHeader(
         Sender: TcxGridTableView; ACanvas: TcxCanvas;
         AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean );
      procedure grdDatosDBTableView1DblClick( Sender: TObject );
      procedure grdDatosDBTableView1FocusedRecordChanged(
         Sender: TcxCustomGridTableView; APrevFocusedRecord,
         AFocusedRecord: TcxCustomGridRecord;
         ANewItemRecordFocusingChanged: Boolean );
      procedure mnuHeaderHeightChange( Sender: TObject );
      procedure grdDatosClick( Sender: TObject );
   private
      { Private declarations }
      nom: string;
      Opciones: Tstringlist;
      erClase: TcxEditRepository; //framirez
      edClaseTypeImageCombo: TcxEditRepositoryImageComboBoxItem; //framirez
      imClaseTypes: TImageList; //framirez
      procedure CreaGrid;
      procedure CreaGrid_alk;  //para formar la tabla   alk
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
      pSistema: string;
      procedure arma( clase: string; bib: string; nombre: string; sistema: string );
      procedure arma_doc( clase: string; bib: string; nombre: string; sistema: string );
      procedure CreaWeb1RC( clase: string; bib: string; nombre: string; sistema: string );
      function ArmarOpciones( b1: Tstringlist ): integer;
   end;
var
   ftsrefcruz: TfmRefCruz;

implementation

uses
   ptsdm, ptsvmlx, ptsgral, parbol, uListaRutinas, uConstantes;

{$R *.dfm}

type
   TcxGridColumnHeaderViewInfoAccess = class( TcxGridColumnHeaderViewInfo );

procedure CreateField( AMemData: TDataSet; AFieldName: string; AFieldType: TFieldType );
begin
   if ( AMemData = nil ) or ( AFieldName = '' ) then
      Exit;
   with AMemData.FieldDefs.AddFieldDef do begin
      Name := AFieldName;
      DataType := AFieldType;
      CreateField( AMemData );
   end;
   AMemData.FieldByName( AFieldName ).DisplayWidth := 20;
end;

procedure TfmRefCruz.arma( clase: string; bib: string; nombre: string; sistema: string );
begin
   inherited;

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
   pSistema := sistema;
   CreaWeb1RC( clase, bib, nombre, sistema );
end;

procedure TfmRefCruz.bsalirClick( Sender: TObject );
var
   arch: string;
begin
   inherited;

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

procedure TfmRefCruz.Notepad1Click( Sender: TObject );
begin
   inherited;

   mm.Lines.SaveToFile( g_tmpdir + '\' + nom + '.txt' );
   ShellExecute( Handle, 'open', pchar( g_tmpdir + '\' + nom + '.txt' ), nil, nil, SW_SHOW );
end;

procedure TfmRefCruz.sqlParaWeb_alk( clase: string; bib: string; nombre: string; sistema: string );
var
   consulta1, consulta2,cons : string;
   h_prog, h_bib, h_clase : string;
   h_prog_l, h_bib_l, h_clase_l : TStringList;
   guarda_hijos : array of estruc_hijos;
   referencias : array of ref_cruz;
   f, c, f_total, c_total, cont, existe: integer;
   lim_c, lim_f,virtual : integer;
   nom_col : string;

   procedure limpia_vector;
   var
      i,cont_aux: integer;
   begin
      cont_aux:=0;
      for i:=f_total downto 1 do begin
         if (vector[i,0] = '') and           //si es un renglon vacio
            (vector[i,1] = '') and
            (vector[i,2] = '') then
            cont_aux:=cont_aux+1;
      end;
      f_total:=f_total-cont_aux;
      SetLength( Vector, f_total+1, c_total+3 );   //nuevo tamaño de la matriz ya sin renglones vacios
   end;
begin
   lim_c:=100;   //limite en columnas
   lim_f:=500;   //limite en filas

   virtual:=0;   //va a indicar cuando una clase es virtual para modificar la consulta

   if clase='SISTEMA' then
      consulta1:= 'select distinct hcprog, hcbib, hcclase from tsrela' +
                  ' where sistema=' + g_q + nombre + g_q
   else begin
      //Revisando si la clase es virtual o fisica
      cons:='select * from tsprog' +
                  ' where cbib=' + g_q + trim(bib) + g_q +
                  ' and cclase=' + g_q + trim(clase) + g_q +
                  ' and cprog=' + g_q + trim(nombre) + g_q +
                  ' and sistema=' + g_q + trim(sistema) + g_q;

      if dm.sqlselect( dm.q1, cons ) then begin    //si es un componente fisico aplica la gral
         consulta1:='select distinct hcprog, hcbib, hcclase from tsrela'+
                    ' where ocprog=' + g_q + nombre + g_q +
                    ' and ocbib=' + g_q + bib + g_q +
                    ' and occlase=' + g_q + clase + g_q +
                    ' and sistema=' + g_q + sistema + g_q;
         virtual:=0;
      end
      else begin
         consulta1:='select distinct hcprog, hcbib, hcclase from tsrela'+
                    ' where pcprog=' + g_q + nombre + g_q +
                    ' and pcbib=' + g_q + bib + g_q +
                    ' and pcclase=' + g_q + clase + g_q +
                    ' and sistema=' + g_q + sistema + g_q;
         virtual:=1;
     end;
   end;

   c_total := 0;
   if dm.sqlselect(dm.q1, consulta1) then begin       //si tiene hijos el owner (componenete que pasa en argumentos)
      h_prog_l := TStringList.Create;
      h_bib_l := TStringList.Create;
      h_clase_l := TStringList.Create;

      h_prog_l.Sorted:=true;
      h_bib_l.Sorted:=true;
      h_clase_l.Sorted:=true;

      SetLength(guarda_hijos,dm.q1.RecordCount);
      while not dm.q1.Eof do begin
         // para añadir a la consulta2
         h_prog := g_q + dm.q1.fieldbyname( 'hcprog' ).AsString + g_q;
         h_bib :=  g_q + dm.q1.fieldbyname( 'hcbib' ).AsString + g_q;
         h_clase:=  g_q + dm.q1.fieldbyname( 'hcclase' ).AsString + g_q;

         h_prog_l.Add(h_prog);
         h_bib_l.Add(h_bib);
         h_clase_l.Add(h_clase);

         //guarda en la estructura para tenerlos ordenados y pasarlos a columnas de grid
         guarda_hijos[c_total].id:=c_total+1;  //lugar en la tabla
         guarda_hijos[c_total].comp:= dm.q1.fieldbyname( 'hcprog' ).AsString;
         guarda_hijos[c_total].bib:= dm.q1.fieldbyname( 'hcbib' ).AsString;
         guarda_hijos[c_total].cla:= dm.q1.fieldbyname( 'hcclase' ).AsString;

         c_total := c_total+1;
         dm.q1.Next;
      end;

      if clase='SISTEMA' then
         consulta2:= 'select distinct ocprog,ocbib,occlase,hcprog,hcbib,hcclase from tsrela' +
                    ' where sistema =' + g_q + nombre + g_q + 'and pcclase <> ' + g_q + 'CLA' + g_q +
                    ' and (hcprog,hcbib,hcclase) in' +
                    ' (select distinct hcprog, hcbib, hcclase from tsrela' +
                    ' where sistema =' + g_q + nombre + g_q + ' and (hcprog,hcbib,hcclase) in' +
                    ' (select distinct hcprog, hcbib, hcclase from tsrela' +
                    ' where sistema=' + g_q + nombre + g_q + '))' +
                    ' order by ocprog,ocbib,occlase'
      else
         // realizar consulta para referencias cruzadas (renglones)
         if virtual = 0 then
            consulta2:='select distinct ocprog,ocbib,occlase,hcprog,hcbib,hcclase from tsrela' +
                    ' where sistema =' + g_q + sistema + g_q + 'and pcclase <> ' + g_q + 'CLA' + g_q +
                    ' and (hcprog,hcbib,hcclase) in' +
                    ' (select distinct hcprog, hcbib, hcclase from tsrela' +
                    ' where sistema =' + g_q + sistema + g_q + 'and (hcprog,hcbib,hcclase) in' +
                    ' (select distinct hcprog, hcbib, hcclase from tsrela' +
                    ' where ocprog=' + g_q + nombre + g_q +
                    ' and ocbib=' + g_q + bib + g_q +
                    ' and occlase=' + g_q + clase + g_q +
                    ' and sistema=' + g_q + sistema + g_q + '))' +
                    ' order by ocprog,ocbib,occlase'
         else
            consulta2:='select distinct ocprog,ocbib,occlase,hcprog,hcbib,hcclase from tsrela' +
                    ' where sistema =' + g_q + sistema + g_q + 'and pcclase <> ' + g_q + 'CLA' + g_q +
                    ' and (hcprog,hcbib,hcclase) in' +
                    ' (select distinct hcprog, hcbib, hcclase from tsrela' +
                    ' where sistema =' + g_q + sistema + g_q + 'and (hcprog,hcbib,hcclase) in' +
                    ' (select distinct hcprog, hcbib, hcclase from tsrela' +
                    ' where pcprog=' + g_q + nombre + g_q +
                    ' and pcbib=' + g_q + bib + g_q +
                    ' and pcclase=' + g_q + clase + g_q +
                    ' and sistema=' + g_q + sistema + g_q + '))' +
                    ' order by ocprog,ocbib,occlase';

      if dm.sqlselect(dm.q2, consulta2) then begin
         f_total:= dm.q2.RecordCount;   //total de filas a agregar  (+1)   Total de columnas (+3)

         {if c_total>100 then   //para el limite de 100 de las columnas
            c_total:=100; }

         SetLength( Vector, f_total+1, c_total+3 );    //tamaño total de la matriz (arreglo, renglones, columnas)
         // ----- añadir hijos al grid como COLUMNAS -------------
         //Columna 0, los titulos para los componentes hijos
         Vector[0,0]:='clase';
         Vector[0,1]:='Libreria';
         Vector[0,2]:='Componente';

         c:=3;  //para saber que columna le toca

         for cont:=0 to length(guarda_hijos)-1 do begin  //recorrer las columnas agregando los componentes hijos
            {if cont > lim_c then   // para controlar el limite de columnas
               break;     }

            nom_col:= guarda_hijos[cont].cla + '_' +
                      guarda_hijos[cont].bib + '_' +
                      guarda_hijos[cont].comp;

            existe:=0;
            for f:=3 to c_total+2 do begin
               if Vector[0,f] = nom_col then
                  existe:=1;
               break;
            end;

            if existe <> 1 then
               Vector[0,c]:= nom_col;
               
            c:=c+1;
         end;
         //------------------------------------------------------------

         SetLength(referencias, f_total);  //va a contener los elementos de la consulta

         cont:=0;  // como contador para el arreglo
         c:=1;  //va a llevar el control de la FILA
         //  ciclo para recorrer el resultado de la consulta de las refencias y llegar RENGLONES
         while not dm.q2.Eof do begin
            referencias[cont].id:=cont;
            referencias[cont].h_comp:=dm.q2.fieldbyname( 'hcprog' ).AsString;
            referencias[cont].h_bib:=dm.q2.fieldbyname( 'hcbib' ).AsString;
            referencias[cont].h_cla:=dm.q2.fieldbyname( 'hcclase' ).AsString;
            referencias[cont].o_comp:=dm.q2.fieldbyname( 'ocprog' ).AsString;
            referencias[cont].o_bib:=dm.q2.fieldbyname( 'ocbib' ).AsString;
            referencias[cont].o_cla:=dm.q2.fieldbyname( 'occlase' ).AsString;

            existe:=0;  //doy por hecho que no existe el elemento en la matriz
            for f:=1 to f_total+1 do begin        //ciclo para buscar el elemento en la matriz
               if Vector[f,0] = '' then
                  break;
               if (Vector[f,0] = dm.q2.fieldbyname( 'occlase' ).AsString)  and
                  (Vector[f,1] = dm.q2.fieldbyname( 'ocbib' ).AsString) and
                  (Vector[f,2] = dm.q2.fieldbyname( 'ocprog' ).AsString) then begin    //si ya esta el elemento indicarlo
                  existe:=1;
                  break;
               end;
            end;

            //agregar la referencia como renglon
            if existe <> 1 then begin
               if (dm.q2.fieldbyname( 'occlase' ).AsString <> '') and
                  (dm.q2.fieldbyname( 'ocbib' ).AsString <> '') and
                  (dm.q2.fieldbyname( 'ocprog' ).AsString <> '') then begin    //si no es un renglon vacio
                  Vector[c,0] := dm.q2.fieldbyname( 'occlase' ).AsString;
                  Vector[c,1] := dm.q2.fieldbyname( 'ocbib' ).AsString;
                  Vector[c,2] := dm.q2.fieldbyname( 'ocprog' ).AsString;
                  c:=c+1;
               end;
            end;

            cont:=cont+1;
            dm.q2.Next;
         end;

         limpia_vector; //para quitar los renglones vacios

         f_total:=c;    // Contiene el numero total de FILAS en la matriz
         //  Colocar las X donde corresponde
         for cont:=0 to length(referencias)-1 do begin   //recorrer el arreglo que contiene los datos de las referencias
            nom_col:=referencias[cont].h_cla + '_' +
                     referencias[cont].h_bib + '_' +
                     referencias[cont].h_comp;
            existe:=0;
            for f:=1 to f_total-1 do begin   //recorrer las filas   (+1)
               if (Vector[f,0] = referencias[cont].o_cla)  and
                  (Vector[f,1] = referencias[cont].o_bib) and
                  (Vector[f,2] = referencias[cont].o_comp) then begin       //recorriendo filas
                  for c:=3 to c_total+2 do begin  //recorrer las columnas para buscar al hijo
                     if Vector[0,c] = nom_col then begin   //si encuentra el elemento owner, le pone una X
                        Vector[f,c]:='X';
                        existe:=1;
                        break;
                     end;
                  end;

                  if existe = 1 then      //si ya encontro al hijo y puso la X sale del ciclo para la sig fila
                     break;
               end;
            end;
         end;
         g_procesa := TRUE;  //indicar que esta activa la tabla aunque tenga solo los hijos (columnas)

      end
      else begin    //si no tiene referencias añadir por lo menos los hijos como columnas
         // ----- añadir hijos al grid como COLUMNAS -------------
         {SetLength( Vector, 1, c_total+3 );    //tamaño total de la matriz (arreglo, renglones, columnas)
         //Columna 0, los titulos para los componentes hijos
         Vector[0,0]:='clase';
         Vector[0,1]:='Libreria';
         Vector[0,2]:='Componente';

         c:=3;  //para saber que columna le toca
         for cont:=0 to length(guarda_hijos)-1 do begin  //recorrer las columnas agregando los componentes hijos
            Vector[0,c]:= guarda_hijos[cont].cla + '_' +
                          guarda_hijos[cont].bib + '_' +
                          guarda_hijos[cont].comp;
            c:=c+1;
         end;      }
         //------------------------------------------------------------
         g_procesa := FALSE;  //indicar que esta no activa la tabla
      end;
   end
   else begin
      g_procesa := FALSE;   //si no tiene hijos, lo indico
   end;
   h_prog_l.Free;
   h_bib_l.Free;
   h_clase_l.Free;

   f:=0; c:=0; f_total:=0; c_total:=0; cont:=0; existe:=0;
   ZeroMemory(@referencias, SizeOf(referencias));  //vaciar el arreglo referencias
   ZeroMemory(@guarda_hijos, SizeOf(guarda_hijos));  //vaciar el arreglo hijos
end;

procedure TfmRefCruz.CreaGrid_alk;
var
   renglon:String;
   grid, columnas : TStringList;
   tam_f, tam_c, cont_f, cont_c, ultimo: integer;
begin
   grid:=TStringList.Create;
   columnas:=TStringList.Create;
   tam_f := High( Vector );
   tam_c := High( Vector[ tam_f ] );

   //agregar los nombres de las columnas
   //columnas.Add('clase:String:20,Libreria:String:250,Componente:String:250');
   renglon:='clase:String:20,Libreria:String:250,Componente:String:250,';
   for cont_c:=3 to tam_c do begin
      if Pos('_',Vector[0,cont_c]) = 4 then
         renglon:=trim(renglon) +
                  StringReplace( trim(Vector[0,cont_c]), ',', '', [ rfReplaceAll ] ) +   //cambio para error en traslado de titulos    ALK
                  ':String:10,'
      else
         break;
      {renglon:=Vector[0,cont_c] + ':String:10';
      columnas.Add(renglon);  }
   end;
   ultimo:=LastDelimiter( ',', renglon );
   renglon := Copy(renglon,1,ultimo);

   renglon := Copy(renglon,1,length(renglon)-1);   //para no tomar la ultima coma

   //grid.Add(columnas.CommaText);
   grid.Add(renglon);

   renglon:='';
   //agregar el contenido
   for cont_f:=1 to tam_f do begin    //recorrer las filas
      for cont_c:=0 to tam_c do begin      //recorrer la columna
         renglon:=renglon+ '"' +Vector[cont_f,cont_c] + '",';
      end;
      renglon := Copy(renglon,1,length(renglon)-1);   //para no tomar la ultima coma
      grid.Add(renglon);
      renglon:='';
   end;
   //poblar tabla
   GlbQuitarFiltrosGrid( grdDatosDBTableView1 );

   if bGlbPoblarTablaMem(grid,tabDatos) then begin
      GlbCrearCamposGrid( grdDatosDBTableView1 );
      GlbHabilitarOpcionesMenu( mnuPrincipal, tabDatos.RecordCount > 0 );
   end
   else
      if FormStyle = fsMDIChild then
         Application.MessageBox( pchar( dm.xlng( 'No se pudo llenar el Grid.' ) ),
                  pchar( dm.xlng( sLISTA_REF_CRUZADAS ) ), MB_OK );

   columnas.Free;
   grid.Free;
end;

{
procedure TfmRefCruz.sqlParaWeb( clase: string; bib: string; nombre: string; sistema: string );
var
   nom: string;
   maxcol: integer;
   Vx, Vy, Vyy: Integer;
   hclase: string;
   cons:string;
   h_cla,h_prog,h_bib:string;
begin
   inherited;

   if dm.sqlselect( dm.q1, 'select * from parametro where clave=' + g_q + 'REFERENCIAS CRUZADAS MAX COLUMNS' + g_q ) then
      maxcol := dm.q1.fieldbyname( 'secuencia' ).AsInteger
   else
      maxcol := 300;

   Primera_vez := 0;
   VecX := 0;
   VecY := 0;
   VecT := 0;
   g_procesa := TRUE;

   //consulta para las filas

   if clase = 'CLA' then     //si es un nodo de clase
      cons:= 'select cprog,cbib,cclase,sistema from tsprog' +  //la misma consulta que se usa para el arbol en los nodos
             ' where cclase='+ g_q + trim(nombre) + g_q+
             ' and sistema=' + g_q + trim(sistema) + g_q +
             ' order by cclase,cbib,cprog'
   else       //si es un componente
      cons:= 'select distinct hcprog,hcbib,hcclase,orden from tsrela'+
             ' where ocprog=' + g_q + trim(nombre) + g_q +
             ' and ocbib=' + g_q + trim(bib) + g_q +
             ' and occlase=' + g_q + trim(clase) + g_q;

   if dm.sqlselect( dm.q1, cons ) then begin
      VecY := dm.q1.RecordCount;
      VecT := VecY;

      if VecY > 0 then begin
         Vyy := 1;

         for Vy := 0 to VecY - 1 do begin     //arreglo para recorrer la consulta 1

            if clase = 'CLA' then begin    //si es un nodo de clase
               h_cla :=  dm.q1.fieldbyname( 'cclase' ).AsString;
               h_prog :=  dm.q1.fieldbyname( 'cprog' ).AsString;
               h_bib :=  dm.q1.fieldbyname( 'cbib' ).AsString;
            end
            else begin       //si es un componente
               h_cla :=  dm.q1.fieldbyname( 'hcclase' ).AsString;
               h_prog :=  dm.q1.fieldbyname( 'hcprog' ).AsString;
               h_bib :=  dm.q1.fieldbyname( 'hcbib' ).AsString;
            end;

            //Consulta para las columnas
            cons:= 'select distinct ocprog,ocbib,occlase,orden from tsrela' +
                   ' where hcprog=' + g_q + h_prog + g_q +
                   ' and hcbib=' + g_q + h_bib + g_q +
                   ' and hcclase=' + g_q + h_cla + g_q;

            if dm.sqlselect( dm.q2, cons ) then begin
               VecX := maxcol + 1000; //dm.q2.RecordCount;

               if Primera_vez = 0 then begin             //solo para ponerle fin al primer renglon y longitud a la matriz
                  SetLength( Vector, VecY + 1, VecX );
                  Vector[ 0, 1 ] := 'FIN';
                  Primera_vez := 1;
               end;

               Vx := 0;      // indica primera columna (nombre del componenete correspondiente a consulta 1)
               Vector[ Vyy, Vx ] :=( h_cla + ' ' + h_bib + ' ' +
                  StringReplace(h_prog,'"','',[rfReplaceAll]) ) +        //aqui juanita
                  '(' + inttostr( dm.q2.RecordCount ) + ')';       //nombre del componenete correspondiente a consulta 1 y numero de registros obtenidos en consulta 2


               for Vx := 1 to VecX - 1 do begin        //recorre consulta 2
                  if dm.q2.Eof then begin
                     Vector[ Vyy, Vx ] := 'FIN';
                     break;
                  end
                  else begin
                     nom := ( dm.q2.fieldbyname( 'occlase' ).AsString + ' '
                        + dm.q2.fieldbyname( 'ocbib' ).AsString + ' '
                        + dm.q2.fieldbyname( 'ocprog' ).AsString );
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

procedure TfmRefCruz.LlenaArreglos( clase: string; bib: string; nombre: string; sistema: string );
var
   nom: string;
   k: integer;
   Vx, Vy, Vxx: Integer;
begin
   inherited;

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
         if (vector[ Vy, Vx ] = '') or  (vector[ Vy, Vx ]= null) then begin
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

   if ( Vxx < 1 ) or ( vy < 1 ) then begin
      if FormStyle = fsMDIChild then
         Application.MessageBox( pchar( dm.xlng( 'No existe información.' ) ),
            pchar( dm.xlng( sLISTA_REF_CRUZADAS ) ), MB_OK );

      Vector := nil;
      Abort;
   end;

   Vector := nil;
end;                      }

procedure TfmRefCruz.CreaWeb1RC( clase: string; bib: string; nombre: string; sistema: string );
begin
   inherited;

   screen.Cursor := crsqlwait;
//   sqlParaWeb( clase, bib, nombre, sistema );
   sqlParaWeb_alk( clase, bib, nombre, sistema );

   if g_procesa then begin
      if Length( Vector ) <> 0 then begin
         mnuExportar.Visible := ivAlways;
         mnuImprimir.visible := ivAlways;
         CreaGrid_alk;
      end
      else begin
         if FormStyle = fsMDIChild then
            Application.MessageBox( pchar( dm.xlng( 'No existe información.' ) ),
                                    pchar( dm.xlng( sLISTA_REF_CRUZADAS ) ), MB_OK );
         Exit;
      end;
   end;
end;

procedure TfmRefCruz.arma_doc( clase: string; bib: string; nombre: string; sistema: string );
begin
   //Vector := nil;
   SetLength( Vector, 0, 0 );

   pSistema := sistema;
   sqlParaWeb_alk( clase, bib, nombre, sistema );
   if Length( Vector ) <> 0 then 
      CreaGrid_alk
   else begin
      if FormStyle = fsMDIChild then
         Application.MessageBox( pchar( dm.xlng( 'No existe información.' ) ),
                 pchar( dm.xlng( sLISTA_REF_CRUZADAS ) ), MB_OK );

      Abort;
   end;
end;

function TfmRefCruz.ArmarOpciones( b1: Tstringlist ): integer;
begin
   inherited;

   gral.EjecutaOpcionB( b1, 'Lista Componentes' );
end;

function TfmRefCruz.TipoNumeroAcceso( b1: string; b2: string ): string;
var
   tipo, tipo0, tipo1, filtro, tabla, programa, a1, a2: string;
   m1, m2: Tstringlist;
begin
   inherited;

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

procedure TfmRefCruz.FormClose( Sender: TObject; var Action: TCloseAction );
var
   arch: string;
begin
   inherited;

   edClaseTypeImageCombo.Free;
   imClaseTypes.Free;
   erClase.Free;

   gral.BorraLogo( WnomLogo + g_ext );
   gral.BorraRutinasjs( );
   gral.BorraIconosTmp( );
   gral.BorraIconosBasicos( );
   arch := g_tmpdir + '\ReferenciasCruzadas.html';
   g_borrar.Add( arch );
   arch := g_tmpdir + '\ReferenciasCruzadasIMP.html';
   g_borrar.Add( arch );
   //Limpia Vector1
   Vector1 := nil;
   if FormStyle = fsMDIChild then 
      dm.PubEliminarVentanaActiva( Caption );  //para quitarlo de la lista de abiertos
end;

procedure TfmRefCruz.Web1ProgressChange( Sender: TObject; Progress,
   ProgressMax: Integer );
begin
   inherited;

   gral.PubAvanzaProgresBar;
end;

procedure TfmRefCruz.FormCreate( Sender: TObject );
begin
   inherited;

   imClaseTypes := TImageList.Create( Self );
   erClase := TcxEditRepository.Create( Self );
   edClaseTypeImageCombo := TcxEditRepositoryImageComboBoxItem.Create( erClase );
   edClaseTypeImageCombo.Properties.Images := imClaseTypes;

   grdDatosDBTableView1.DataController.CreateAllItems;
end;

procedure TfmRefCruz.FormDeactivate( Sender: TObject );
begin
   inherited;

   gral.PopGral.Items.Clear;
end;

procedure TfmRefCruz.FormActivate( Sender: TObject );
begin
   inherited;

   iHelpContext := IDH_TOPIC_T03000;
   G_producto := 'MENÚ CONTEXTUAL-REFERENCIAS CRUZADAS';
end;

procedure TfmRefCruz.CreaGrid;
var
   l, c, i, j, ii, VecXX, x: integer;
   nomb, clase, nom1, nom2, b1, b2, b3, sPass, sPass2: string;
   sPaso, sLibreria, sComponente: String;
   x3: Tstringlist;
//   x4: Tstringlist;
   slDatos: Tstringlist;
//   AField: TField;
   aClases: array of string;
//   s: string;
//   aComponente: array of string;


   procedure AgruparDuplicados( var slParDatos: TStringList );
   var
      i, j: Integer;
      copia, nueva: TStringList;

      function bExisteDatos(sParTipo, sParLibreria, sParComponente: String ): Boolean;
      var
         i: Integer;
         slPaso: TStringList;
      begin
         Result := False;
         slPaso := Tstringlist.create;
         try
            for i := 0 to nueva.Count - 1 do begin
               slPaso.CommaText := nueva[ i ];    //toma cada registro y lo separa para compararlos
               if ( slPaso[ 0 ] = sParTipo ) and
                  ( slPaso[ 1 ] = sParLibreria ) and
                  ( slPaso[ 2 ] = sParComponente ) then begin
                  Result := True;
                  Break;
               end;
               slPaso.Clear;
            end;
         finally
            slPaso.Free;
         end;
      end;

      procedure bCombinaDatos(repetido: TStringList );
      var
         i,j: Integer;
         slPaso: TStringList;
      begin
         slPaso := Tstringlist.create;
         try
            for i := 0 to nueva.Count - 1 do begin
               slPaso.CommaText := nueva[ i ];    //toma cada registro y lo separa para compararlos
               if ( slPaso[ 0 ] = repetido[ 0 ] ) and
                  ( slPaso[ 1 ] = repetido[ 1 ] ) and
                  ( slPaso[ 2 ] = repetido[ 2 ] ) then begin
                  for j:=3 to slPaso.Count - 1 do begin
                     if  slPaso[ j ] = 'FIN' then
                        Break;
                     //si esta repetida, tomar los datos y combinarlos

                  end;
                  Break;
               end;
               slPaso.Clear;
            end;
         finally
            slPaso.Free;
         end;
      end;

   begin
      copia := Tstringlist.create;
      nueva := Tstringlist.create;
      try
         for i := 0 to slParDatos.Count - 1 do begin
            copia.CommaText := slParDatos[ i ];   //toma renglon separado por columnas
            if bExisteDatos( copia[ 0 ], copia[ 1 ], copia[ 2 ] ) then    //si existe lo guarda para modificarlo al final

            else    //comprueba que no exista ya en la lista lo agrega
               nueva.Add( slParDatos[ i ] );
         end;

      finally
         copia.Free;
         nueva.Free;
      end;
   end;

begin
   inherited;

   screen.Cursor := crsqlwait;
   try
      stbLista.Panels[ 0 ].Text := ''; //limpia count de registros
      tabLista.Caption := self.Caption;
      x := 0;
      l := 5;
      l := l + 1;
      c := 0;
      ii := 0;
      slDatos := Tstringlist.Create;
      slDatos.Delimiter := ',';

      for i := 0 to VecX - 1 do begin
         c := c + 1;

         if Vector1[ ii, i ] = 'FIN' then begin
            VecXX := i - 1;
            break;
         end;

         if i = 0 then
            sPass := 'clase:String:20,Libreria:String:250,Componente:String:250,'
         else begin
            sPass2 := trim( Vector1[ ii, i ] );
            sPass2 := trim( StringReplace( sPass2, ' ', '_', [ rfreplaceall ] ) );
            sPass2 := trim( StringReplace( sPass2, ',', '_', [ rfreplaceall ] ) );
            sPass := sPass + sPass2 + ':String:10,';
         end;
      end;

      slDatos.add( Copy( sPass, 1, Length( sPass ) - 1 ) );

      l := l + 1;
      c := 0;
      sPass := '';

      for ii := 1 to VecY - 1 do begin
         l := l + 1;
         c := 0;

         for i := 0 to VecXX do begin
            nomb := Vector1[ ii, i ];

            clase := Copy( nomb, 1, Pos( ' ', nomb ) );
            sPaso := Copy( nomb, Pos( ' ', nomb ) + 1, Length( nomb ) );
            sLibreria := Copy( sPaso, 1, Pos( ' ', sPaso ) - 1 );
            sPaso := Copy( sPaso, Pos( ' ', sPaso ) + 1, Length( nomb ) );
            sComponente := '"'+sPaso+'"';

            if ( clase = 'INS' ) or ( clase = 'DEL' ) or ( clase = 'UPD' ) then begin
               l := l - 1;
               break;
            end;

            c := c + 1;

            if ( nomb = '' ) or ( nomb = 'FIN' ) then begin
               if ( nomb = '' ) then
                  sPass := sPass + '"",'
               else
                  sPass := sPass + '"",';
            end
            else begin
               if i = 0 then begin
                  clase := Copy( nomb, 1, Pos( ' ', nomb ) - 1 ) + '",';
                  sPaso := Copy( nomb, Pos( ' ', nomb ) + 1, Length( nomb ) );
                  sLibreria := Copy( sPaso, 1, Pos( ' ', sPaso ) - 1 ) + ',';
                  sPaso := Copy( sPaso, Pos( ' ', sPaso ) + 1, Length( nomb ) );
                  sComponente := '"'+sPaso+'"'+ ',';
                  sPass := sPass + '"' + clase + sLibreria + sComponente;
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

                     sPass := sPass + '"' + nom2 + '",';
                  end
                  else begin
                     sPass := sPass + '"' + '  X' + '",';
                  end;
               end;
            end;
         end;

         slDatos.add( Copy( sPass, 1, Length( sPass ) - 1 ) );


         clase := trim( copy( sPass, 2, 4 ) );

         for i := 1 to slDatos.Count - 1 do begin
            sPass := copy( slDatos[ i ], 2, 3 );

            if not AnsiMatchStr( sPass, aClases ) then begin
               SetLength( aClases, Length( aClases ) + 1 );
               aClases[ Length( aClases ) - 1 ] := trim( sPass );
            end;
         end;
         sPass := '';
      end;

      GlbCreateImageRepository( erClase, imClaseTypes, edClaseTypeImageCombo, g_tmpdir, aClases, false );

      if slDatos.Count < 1 then begin
         if FormStyle = fsMDIChild then
            Application.MessageBox( pchar( dm.xlng( 'No existe información' ) ),
               pchar( dm.xlng( 'Versionado ' ) ), MB_OK );

         Screen.Cursor := crdefault;
         Exit;
      end;

   ///ESTO ESPERA UN POCO  AgruparDuplicados( slDatos );  LO TERMINO

     if tabDatos.Active then
        tabDatos.Active := False;

      GlbQuitarFiltrosGrid( grdDatosDBTableView1 );
      if bGlbPoblarTablaMem( slDatos, tabDatos ) then begin
         tabDatos.ReadOnly := True;

         GlbHabilitarOpcionesMenu( mnuPrincipal, tabDatos.RecordCount > 0 );
         GlbCrearCamposGrid( grdDatosDBTableView1 );

         j := 0;
         for i := 0 to grdDatosDBTableView1.ColumnCount - 1 do begin
            if j < Length( grdDatosDBTableView1.Columns[ i ].Caption ) then
               j := Length( grdDatosDBTableView1.Columns[ i ].Caption );
         end;

          mnuHeaderHeight.Text := IntToStr( 250 );

         for i := 1 to 2 do begin
            grdDatosDBTableView1.Columns[ i ].ApplyBestFit;
            grdDatosDBTableView1.Columns[ i ].HeaderAlignmentVert := vaCenter;
         end;

         for i := 0 to grdDatosDBTableView1.ColumnCount - 1 do begin
            if grdDatosDBTableView1.Columns[ i ].Caption = 'clase' then begin
               grdDatosDBTableView1.Columns[ i ].RepositoryItem := edClaseTypeImageCombo;
            end;
         end;

         //necesario para la busqueda //fercar
         //en este caso usar grEspejo para apoyarse en las busquedas y llenar slPublista
         GlbCrearCamposGrid( grdEspejoDBTableView1 );
         GlbCargarLista( grdEspejo, grdEspejoDBTableView1, slPubLista );
         //fin necesario para la busqueda

         stbLista.Panels[ 0 ].Text := IntToStr( tabDatos.RecordCount ) + ' Registros';

         if Visible = True then
            GlbFocusPrimerItemGrid( grdDatos, grdDatosDBTableView1 );
      end;
   finally
      screen.Cursor := crdefault;
      x3.free;
   end;
end;

procedure TfmRefCruz.grdDatosDBTableView1CustomDrawColumnHeader(
   Sender: TcxGridTableView; ACanvas: TcxCanvas;
   AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean );
var
   Size: TSize;
   OldFont, LogFont: TLogFont;
   ARect: TRect;
   AFilterRect: TRect;
   I: Integer;
   AButtonState: TcxButtonState;
begin
   inherited;

   screen.Cursor := crsqlwait;
   try
      with AViewInfo do begin
         GetObject( ACanvas.Font.Handle, SizeOf( OldFont ), @OldFont );
         LogFont := OldFont;

         with LogFont do begin
            lfEscapement := 900;
            lfOrientation := lfEscapement;
            lfOutPrecision := OUT_TT_ONLY_PRECIS;
         end;

         ACanvas.Font.Handle := CreateFontIndirect( LogFont );
         GetTextExtentPoint32( ACanvas.Handle, PChar( Text ), Length( Text ), Size );
         ARect := Bounds;
         {
                  if (Column.Caption = 'Clase') or
                     (Column.Caption = 'clase') or
                     (Column.Caption = 'Libreria') or
                     (Column.Caption = 'Componente') then begin
                     ACanvas.Font.Handle := CreateFontIndirect(OldFont);
                     Exit;
                  end;
         }
         with TcxGridColumnHeaderViewInfoAccess( AviewInfo ) do
            for I := 0 to AreaViewInfoCount - 1 do
               if AreaViewInfos[ I ] is TcxGridColumnHeaderFilterButtonViewInfo then begin
                  AFilterRect := TcxGridColumnHeaderFilterButtonViewInfo( AreaViewInfos[ I ] ).Bounds;

                  if TcxGridColumnHeaderFilterButtonViewInfo( AreaViewInfos[ I ] ).DropDownWindow.Visible then
                     AButtonState := cxbsPressed
                  else
                     AButtonState := cxbsNormal;

                  Break;
               end;

         Sender.Painter.LookAndFeelPainter.DrawHeader( ACanvas, Bounds, ARect,
            [ ], cxBordersAll, cxbsNormal, taCenter, vaCenter, true, False,
            '', Params.Font, clBlack, clNone );

         {
                  Sender.Painter.LookAndFeelPainter.DrawHeader(ACanvas, Bounds, ARect,
                     Neighbors, Borders, cxbsNormal, taCenter, vaCenter, true, False,
                     '', ACanvas.Font, clNone, clNone);

         }

         with ARect do begin
            Left := ( Left + AFilterRect.Left - Size.cy ) div 2;
            Right := Left + Size.cy;
            Bottom := ( Bottom + Top + Size.cx ) div 2; // << center vertical alignment
            Top := Bottom - Size.cx;
         end;

         ACanvas.Canvas.TextRect( ARect, ARect.Left, ARect.Bottom, Column.Caption );
         Sender.Painter.LookAndFeelPainter.DrawFilterDropDownButton( ACanvas, AFilterRect, AButtonState, AViewInfo.Column.Filtered );
         ADone := True;
      end;
   finally
      screen.Cursor := crdefault;
   end;
end;

procedure TfmRefCruz.grdDatosDBTableView1DblClick( Sender: TObject );
var
//   j, k, l: integer;
   b1: string;
//   b2: string;
   m: Tstringlist;
//   x: integer;
   y: integer;
   nCol,nRen: integer;
   cap : string;
begin
   inherited;

   screen.Cursor := crsqlwait;
   nCol := grdDatosDBTableView1.Controller.FocusedColumnIndex;
   nren := grdDatosDBTableView1.Controller.FocusedItemIndex;

   cap:=grdDatosDBTableView1.Columns[nren].Name;
   //   if nCol < 3 then Exit;
   try
      if (nCol > 2) and (nRen > 1) then
         exit;

      if nCol < 3 then begin
         b1 := trim( grdDatosDBTableView1.Columns[ 1 ].EditValue ) + ' ' +
            trim( grdDatosDBTableView1.Columns[ 2 ].EditValue ) + ' ' +
            trim( grdDatosDBTableView1.Columns[ 3 ].EditValue ) + ' ' +
            pSistema;

         //b1 := copy( b1, 1, Pos( '(', b1 ) - 1 )+ ' ' + pSistema;
      end
      else
         b1 := Vector1[ 0, nCol - 2 ]+ ' ' + pSistema;

      m := Tstringlist.Create;
      m.CommaText := b1;    //clase, biblioteca, nombre, sistema

      if m.count < 3 then begin
         Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
            pchar( dm.xlng( sLISTA_REF_CRUZADAS ) ), MB_OK );

         exit;
      end;

      nom := m[ 2 ];
      dm.trae_fuente( m[ 3 ], m[ 2 ], m[ 1 ], m[ 0 ], mm );

      if pos( chr( 13 ) + chr( 10 ), mm.Text ) = 0 then // corrige cuando el fuente no tiene CR
         mm.Text := stringreplace( mm.Text, chr( 10 ), chr( 13 ) + chr( 10 ), [ rfreplaceall ] );

      //---------------
      //bgral := m[ 3 ] + ' ' + m[ 2 ] + ' ' + m[ 1 ] + ' ' + m[ 0 ];
      bgral := m[ 2 ] + ' ' + m[ 1 ] + ' ' + m[ 0 ] + ' ' + m[ 3 ];   //Bre
      Opciones := gral.ArmarMenuConceptualWeb( bgral, 'referencias_cruzadas' );
      y := ArmarOpciones( Opciones );
      gral.PopGral.Popup( g_X, g_Y );
      //---------------
   finally
      m.Free;
      screen.Cursor := crdefault;
   end;
end;

procedure TfmRefCruz.grdDatosDBTableView1FocusedRecordChanged(
   Sender: TcxCustomGridTableView; APrevFocusedRecord,
   AFocusedRecord: TcxCustomGridRecord;
   ANewItemRecordFocusingChanged: Boolean );
begin
   inherited;

   gral.PopGral.Items.Clear;
end;

procedure TfmRefCruz.mnuHeaderHeightChange( Sender: TObject );
begin
   inherited;

   grdDatosDBTableView1.OptionsView.HeaderHeight := StrToInt( mnuHeaderHeight.Text );
   grdDatos.Refresh;
end;

procedure TfmRefCruz.grdDatosClick( Sender: TObject );
begin
   inherited;

   if grdDatosDBTableView1.DataController.RecordCount < 1 then
      if FormStyle = fsMDIChild then
         Application.MessageBox( pchar( dm.xlng( 'No existe información.' ) ),
            pchar( dm.xlng( sLISTA_REF_CRUZADAS ) ), MB_OK );
end;

end.


