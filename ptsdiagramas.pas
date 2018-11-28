unit ptsdiagramas;

interface
uses classes, sysutils, dxmdaset; //fercar diagramas jcl

type
   Tpaso = record
      programa: string;
      bib: string;
      clase: string;
   end;
type
   Ttab = record
      tipo: string;
      nombre: string;
      local: string;
      organizacion: string;
      c, r, u, d: boolean;
      entrada: boolean;
      salida: boolean;
   end;
type
   Tfil = record
      tipo: string;
      nombre: string;
   end;
var
   pp: array of Tpaso;
   ff: array of Ttab;
   fil: array of Tfil;
   paso, paso_anterior: string;
   def_jcl: string;
   def_paso: string;
   def_tabla: string;
   def_archivo: string;
   def_cbl: string;
   def_reporte: string;
   rep: Tstringlist;
   spools: Tstringlist;

   iRenglon, iColumna: Integer;

   tabMemData_jcl: TdxMemData; //fercar diagramas jcl
   iNombre_jcl: Integer; //fercar diagramas jcl

procedure inicia_jcl( programa: string; bib: string; clase: string; sistema: string );
procedure corte;
procedure grafica_registro( pr: string; bi: string; cl: string; ex: string; mo: string );
procedure termina_jcl( archivo: string );
procedure GlbRegistraComponente_jcl(
   sParPrograma, sParBiblioteca, sParClase: String;
   iParColumna, iParRenglon: Integer;
   sParNFisicoBlock, sParNLogicoBlock: String;
   sParTipoBlock: String;
   sParLigaBlockOrigen, sParLigaBlockDestino: String;
   sParTexto: String );

implementation

procedure inicia_jcl( programa: string; bib: string; clase: string; sistema: string );
begin
   setlength( pp, 0 );
   setlength( ff, 0 );
   setlength( fil, 0 );

   {FlowTerminalBlock - def_jcl
   DFDProcessBlock - def_cbl
   DatabaseBlock - def_tabla
   DatabaseBlock - def_archivo
   FlowDocumentBlock - def_reporte}

   def_jcl := 'shape=hexagon,style=filled,color=".7 .3 1.0"';
   def_paso := 'shape=hexagon,style=filled,color=".3 .3 1.0"';
   def_tabla := 'shape=invtrapezium,style=filled,color=".1 .3 1.0"';
   def_archivo := 'shape=rectangle,style=filled,color=".6 .3 1.0"';
   def_cbl := 'shape=parallelogram,style=filled,color=".4 .3 1.0"';
   def_reporte := 'shape=trapezium,style=filled,color=".5 .3 1.0"';

   rep := Tstringlist.Create;
   spools := Tstringlist.Create;
   rep.Add( 'digraph ' + clase + bib + programa + ' {' );
   paso_anterior := clase + '_' + bib + '_' + programa;
   //rep.Add( '   ' + paso_anterior + ' [' + def_jcl + ',label="SysViewSoft Information Mapping\n' + programa + '",fontsize=8];' );
   rep.Add( '   ' + paso_anterior + ' [' + def_jcl + ',label="' + programa + '",fontsize=8];' );

   iRenglon := 0;

   GlbRegistraComponente_jcl( //fercar diagramas jcl
      programa, bib, clase, 0, 0,
      'JCL_', paso_anterior, 'FlowTerminalBlock', '', '', programa );
end;

procedure corte;
var
   i, j, k, m: integer;
   paso, lab, lab2: string;
begin
   if length( pp ) > 0 then begin
      paso := paso_anterior + '_1';
      lab := '  ' + paso + ' [' + def_cbl + ',label="';

      lab2 := '';
      for i := 0 to length( pp ) - 1 do begin
         lab  := lab  + pp[ i ].clase + '_' + pp[ i ].bib + '_' + pp[ i ].programa + '\n';
         lab2 := lab2 + pp[ i ].clase + '_' + pp[ i ].bib + '_' + pp[ i ].programa + '\n';
      end;

      lab := lab + '",fontsize=8];';
      setlength( pp, 0 );
      rep.Add( lab );

      GlbRegistraComponente_jcl( //fercar diagramas jcl
         '', '', 'CBL', 0, 0,
         'JCL_', paso, 'DFDProcessBlock', '', '',
         stringreplace( lab2, '\n', ' ', [ rfreplaceall ] ) );

      rep.Add( '   ' + paso_anterior + ' -> ' + paso + ' [style=bold,color=red]' );

      GlbRegistraComponente_jcl( //fercar diagramas jcl
         '', '', '', 0, 0,
         'JCL_', '', 'Link', paso_anterior, paso,
         'PROCESO' );

      paso_anterior := paso;
   end;
   if length( ff ) > 0 then begin
      for i := 0 to length( ff ) - 1 do begin
         // Checa si ya se creó el objeto
         paso := stringreplace( ff[ i ].tipo + '_' + ff[ i ].nombre, '.', '_', [ rfreplaceall ] );
         paso := stringreplace( paso, '&', '', [ rfreplaceall ] );
         m := -1;
         for j := 0 to length( fil ) - 1 do begin
            if ( fil[ j ].tipo = ff[ i ].tipo ) and
               ( fil[ j ].nombre = ff[ i ].nombre ) then begin
               m := j;
               break;
            end;
         end;
         if m = -1 then begin
            k := length( fil );
            setlength( fil, k + 1 );
            fil[ k ].tipo := ff[ i ].tipo;
            fil[ k ].nombre := ff[ i ].nombre;
            if fil[ k ].tipo = 'BD' then begin
               rep.Add( '   ' + paso + ' [' + def_tabla + ',label="' + fil[ k ].tipo + ' ' + fil[ k ].nombre + '",fontsize=8];' );

               GlbRegistraComponente_jcl( //fercar diagramas jcl

                  //'', '', 'TAB', 0, 0,
                  fil[ k ].nombre, 'BD', 'TAB', 0, 0,
                  'JCL_', paso, 'DatabaseBlock', '', '',
                  fil[ k ].tipo + ' ' + fil[ k ].nombre );
            end
            else begin
               rep.Add( '   ' + paso + ' [' + def_archivo + ',label="' + fil[ k ].tipo + ' ' + fil[ k ].nombre + '",fontsize=8];' );

               GlbRegistraComponente_jcl( //fercar diagramas jcl
                  fil[ k ].nombre , 'DISK', 'FIL', 0, 0,
                  //'', 'DISK', 'FIL', 0, 0,
                  'JCL_', paso, 'DatabaseBlock', '', '',
                  fil[ k ].tipo + ' ' + fil[ k ].nombre );
            end;
         end;
         // Crea la liga
         if ff[ i ].r or ff[ i ].u then begin
            rep.Add( '   ' + paso + ' -> ' + paso_anterior );

            GlbRegistraComponente_jcl( //fercar diagramas jcl
               '', '', '', 0, 0,
               'JCL_', '', 'Link', paso, paso_anterior,
               'ENTRADA' );
         end;

         if ff[ i ].c or ff[ i ].d or ff[ i ].u then begin
            rep.Add( '   ' + paso_anterior + ' -> ' + paso );

            GlbRegistraComponente_jcl( //fercar diagramas jcl
               '', '', '', 0, 0,
               'JCL_', '', 'Link', paso_anterior, paso,
               'SALIDA' );
         end;
      end;
      setlength( ff, 0 );
   end;
   if spools.Count > 0 then begin
      paso := paso_anterior + '_listados';
      lab := '  ' + paso + ' [' + def_reporte + ',label="';

      lab2 := '';
      for i := 0 to spools.Count - 2 do begin
         lab := lab + spools[ i ] + '\n';
         lab2 := lab2 + spools[ i ] + '\n';
      end;

      lab := lab + spools[ spools.count - 1 ] + '",fontsize=8];';
      lab2 := lab2 + spools[ spools.count - 1 ];

      rep.Add( lab );

      GlbRegistraComponente_jcl( //fercar diagramas jcl
         '', 'SPOOL', 'REP', 0, 0,
         'JCL_', paso, 'FlowDocumentBlock', '', '',
         stringreplace( lab2, '\n', ' ', [ rfreplaceall ] ) );

      rep.Add( '   ' + paso_anterior + ' -> ' + paso );

      GlbRegistraComponente_jcl( //fercar diagramas jcl
         '', '', '', 0, 0,
         'JCL_', '', 'Link', paso_anterior, paso,
         'SALIDA' );

      spools.Clear;
   end;
end;

procedure grafica_registro( pr: string; bi: string; cl: string; ex: string; mo: string );
var
   j, k, m: integer;
begin
   // Si es paso
   if cl = 'STE' then begin
      corte;
      paso := cl + '_' + bi + '_' + pr;
      rep.Add( '  ' + paso + ' [' + def_jcl + ',label="' + pr + '",fontsize=8];' );

      GlbRegistraComponente_jcl( //fercar diagramas jcl
         pr, bi, cl, 0, 0,
         'JCL_2', paso, 'FlowTerminalBlock', '', '',
         pr );

      rep.Add( '   ' + paso_anterior + ' -> ' + paso + ' [style=bold,color=red]' );

      GlbRegistraComponente_jcl( //fercar diagramas jcl    hacer las uniones
         '', '', '', 0, 0,
         'JCL_', '', 'Link', paso_anterior, paso,
         'PROCESO' );

      paso_anterior := paso;
   end;
   // Si es programa
   if ( cl = 'CBL' ) or
      ( cl = 'ASE' ) or
      ( cl = 'REX' ) or
      ( cl = 'UTI' ) then begin
      // checa si ya está dado de alta
      k := length( pp );
      m := -1;
      for j := 0 to k - 1 do begin
         if ( pp[ j ].programa = pr ) and
            ( pp[ j ].bib = bi ) and
            ( pp[ j ].clase = cl ) then begin
            m := j;
            break;
         end;
      end;
      if m = -1 then begin
         // Agrega el nuevo programa
         setlength( pp, k + 1 );
         pp[ k ].programa := pr;
         pp[ k ].bib := bi;
         pp[ k ].clase := cl;
      end;
   end;
   // Si es BD
   if ( cl = 'TAB' ) or
      ( cl = 'INS' ) or
      ( cl = 'UPD' ) or
      ( cl = 'DEL' ) then begin
      k := length( ff );
      m := -1;
      for j := 0 to k - 1 do begin
         if ( ff[ j ].tipo = 'BD' ) and
            ( ff[ j ].nombre = pr ) then begin
            if cl = 'INS' then
               ff[ j ].c := true;
            if cl = 'TAB' then
               ff[ j ].r := true;
            if cl = 'UPD' then
               ff[ j ].u := true;
            if cl = 'DEL' then
               ff[ j ].d := true;
            m := j;
            break;
         end;
      end;
      if m = -1 then begin
         setlength( ff, k + 1 );
         ff[ k ].tipo := 'BD';
         ff[ k ].nombre := pr;
         if cl = 'INS' then
            ff[ k ].c := true;
         if cl = 'TAB' then
            ff[ k ].r := true;
         if cl = 'UPD' then
            ff[ k ].u := true;
         if cl = 'DEL' then
            ff[ k ].d := true;
      end;
   end;
   // Si es Archivo
   if cl = 'FIL' then begin
      k := length( ff );
      setlength( ff, k + 1 );
      ff[ k ].tipo := 'FIL';
      ff[ k ].nombre := pr;
      ff[ k ].local := ex;
      if mo = 'NEW' then
         ff[ k ].c := true
      else
         ff[ k ].r := true;
   end;
   // Si esta definido en un programa
   if cl = 'LOC' then begin
      k := length( ff );
      for j := 0 to k - 1 do begin
         if ff[ j ].local = ex then begin
            if mo = 'O' then
               ff[ j ].c := true;
            if mo = 'A' then begin
               ff[ j ].c := true;
               ff[ j ].u := true;
            end;
            if mo = 'I' then
               ff[ j ].r := true;
            if mo = 'U' then begin
               ff[ j ].u := true;
               ff[ j ].d := true;
            end;
            break;
         end;
      end;
   end;
   // Si es un reporte
   if cl = 'REP' then begin
      spools.Add( ex );
   end;
end;

procedure termina_jcl( archivo: string );
begin
   //rep.Add( '   FIN_99 [' + def_jcl + ',label="FIN DE PROCESO\nSysViewSoft Information Mapping",fontsize=8];' );
   rep.Add( '   FIN_99 [' + def_jcl + ',label="FIN DE PROCESO",fontsize=8];' );

   GlbRegistraComponente_jcl( //fercar diagramas jcl
      '', '', 'JCL', 0, 0,
      'JCL_', 'FIN_99', 'FlowTerminalBlock', '', '', 'FIN DE PROCESO' );

   rep.Add( '   ' + paso_anterior + ' -> FIN_99' );
   rep.Add( '}' );

   GlbRegistraComponente_jcl( //fercar diagramas jcl
      '', '', '', 0, 0,
      'JCL_', '', 'Link', paso_anterior, 'FIN_99',
      'PROCESO' );

   rep.SaveToFile( archivo );
   rep.free;
   spools.free;
end;

procedure GlbRegistraComponente_jcl(
   sParPrograma, sParBiblioteca, sParClase: String;
   iParColumna, iParRenglon: Integer;
   sParNFisicoBlock, sParNLogicoBlock: String;
   sParTipoBlock: String;
   sParLigaBlockOrigen, sParLigaBlockDestino: String;
   sParTexto: String );
var
   sNombreBlock_jcl: String;
   iColIzquierda, iColCentro, iColDerecha: Integer;
   iIncrementoRenglon: Integer;
   sTipoBlock, sTipoBlockOrigen, sTipoBlockDestino: String;
begin
   iColIzquierda := 40;
   iColCentro := 180;
   iColDerecha := 320;
   iIncrementoRenglon := 65;

   sTipoBlockOrigen := '';
   sTipoBlockDestino := '';

   sTipoBlock := UpperCase( sParTipoBlock );

   with tabMemData_jcl do begin
      if not Active then
         Active := True;

      inc( iNombre_jcl );
      sNombreBlock_jcl := 'DFJCL_' + IntToStr( iNombre_jcl );

      if sTipoBlock <> 'LINK' then begin
         iColumna := iColIzquierda; //default

         if sTipoBlock = 'FLOWTERMINALBLOCK' then begin
            iColumna := iColCentro;
            iRenglon := iRenglon + iIncrementoRenglon;
         end;
         if sTipoBlock = 'DFDPROCESSBLOCK' then begin
            iColumna := iColCentro;
            iRenglon := iRenglon + iIncrementoRenglon;
         end;
         if ( sTipoBlock = 'DATABASEBLOCK' ) and
            ( sParClase = 'FIL' ) then begin
            iColumna := iColIzquierda;
            iRenglon := iRenglon + iIncrementoRenglon - 20;
         end;
         if ( sTipoBlock = 'DATABASEBLOCK' ) and
            ( sParClase <> 'FIL' ) then begin
            iColumna := iColIzquierda;
            iRenglon := iRenglon + iIncrementoRenglon - 20;
         end;
         if sTipoBlock = 'FLOWDOCUMENTBLOCK' then begin
            iColumna := iColDerecha;
            iRenglon := iRenglon + iIncrementoRenglon - 20;
         end;
      end;

      if sTipoBlock = 'LINK' then begin
         if Locate( 'NLogicoBlock', sParLigaBlockOrigen, [ ] ) then begin
            sParLigaBlockOrigen := FindField( 'NFisicoBlock' ).AsString;
            sTipoBlockOrigen := UpperCase( FindField( 'TipoBlock' ).AsString );

            if ( ( sParTexto = 'ENTRADA' ) or ( sParTexto = 'SALIDA' ) ) and
               ( sTipoBlockOrigen = 'DATABASEBLOCK' ) then begin
               if sParTexto = 'ENTRADA' then
                  iColumna := iColIzquierda;

               if sParTexto = 'SALIDA' then
                  iColumna := iColDerecha;

               if FindField( 'Columna' ).AsInteger <> 320 then
                  if iColumna <> FindField( 'Columna' ).AsInteger then begin
                     Edit;
                     FindField( 'Columna' ).AsInteger := iColumna;
                     Post;
                  end;
            end;
         end
         else
            sParLigaBlockOrigen := '';

         if Locate( 'NLogicoBlock', sParLigaBlockDestino, [ ] ) then begin
            sParLigaBlockDestino := FindField( 'NFisicoBlock' ).AsString;
            sTipoBlockDestino := UpperCase( FindField( 'TipoBlock' ).AsString );

            if ( ( sParTexto = 'ENTRADA' ) or ( sParTexto = 'SALIDA' ) ) and
               ( sTipoBlockDestino = 'DATABASEBLOCK' ) then begin
               if sParTexto = 'ENTRADA' then
                  iColumna := iColIzquierda;

               if sParTexto = 'SALIDA' then
                  iColumna := iColDerecha;

               if iColumna <> FindField( 'Columna' ).AsInteger then begin
                  Edit;
                  FindField( 'Columna' ).AsInteger := iColumna;
                  Post;
               end;
            end;
         end
         else
            sParLigaBlockDestino := '';
      end;

      Append;
      FindField( 'Clase' ).AsString := sParClase;
      FindField( 'Biblioteca' ).AsString := sParBiblioteca;
      FindField( 'Programa' ).AsString := sParPrograma;

      FindField( 'Renglon' ).AsInteger := iRenglon;
      FindField( 'Columna' ).AsInteger := iColumna;

      if sTipoBlock = 'LINK' then begin
         FindField( 'Renglon' ).AsInteger := 0;
         FindField( 'Columna' ).AsInteger := 0;
      end;

      FindField( 'NFisicoBlock' ).AsString := sNombreBlock_jcl;
      FindField( 'NLogicoBlock' ).AsString := sParNLogicoBlock;
      FindField( 'LigaBlockOrigen' ).AsString := sParLigaBlockOrigen;
      FindField( 'LigaBlockDestino' ).AsString := sParLigaBlockDestino;
      FindField( 'TipoBlock' ).AsString := sParTipoBlock;
      FindField( 'TipoBlockOrigen' ).AsString := sTipoBlockOrigen;
      FindField( 'TipoBlockDestino' ).AsString := sTipoBlockDestino;
      FindField( 'Texto' ).AsString := sParTexto;
      Post;
   end;
end;

end.

