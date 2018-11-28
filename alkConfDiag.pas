unit alkConfDiag;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ShlObj, ShellApi;

type
  TalkFormConfDiag = class(TForm)
    Label7: TLabel;
    Label1: TLabel;
    rgTipo: TRadioGroup;
    Label2: TLabel;
    rgFormato: TRadioGroup;
    Button1: TButton;
    Label3: TLabel;
    lbruta: TEdit;
    Button2: TButton;
    SaveDialog: TSaveDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure rgTipoClick(Sender: TObject);
    procedure rgFormatoClick(Sender: TObject);
  private
    comp_g, bib_g, cla_g, sis_g, t_diag, directorio, fuente, tipo_cbl : string;
    online_auto, split : integer;
    ruta_entrada,ruta_salida,arch_entrada, lsArchSal,lsArchSal2,lsArchSal3 : string;

    function ObtenerMisDocumentos: String;
  public
    tipo, formato, ruta: string;

    procedure genera_diagrama();
    procedure set_data(com,bibl,clas,sist,tip_diag, dir, fte:String);
    procedure set_data_docauto(com,bibl,clas,sist,tip_diag, fte:String);
  end;

var
  alkFormConfDiag: TalkFormConfDiag;

implementation

uses ptsdm, ptscomun, uconstantes;

{$R *.dfm}

procedure TalkFormConfDiag.set_data(com,bibl,clas,sist,tip_diag, dir, fte:String);
begin
   comp_g:=com;
   bib_g:=bibl;
   cla_g:=clas;
   sis_g:=sist;
   t_diag:=tip_diag;  //flujo - jerarquico
   online_auto:= 1;  // productos (1)
   directorio:= dir;
   fuente:= fte;

   // ----  Preparando carpetas  -------------       arbol-productos
   ruta_entrada:=g_tmpdir + '\';
   ruta_salida:= ruta;   // carpeta de informes en mis documentos
   arch_entrada:= com;

   lsArchSal := fuente + '.sal';
   lsArchSal2 := '';
   lsArchSal3 := '';

   split:=0;   // para indicar que no es split, va a cambiar en caso de que se seleccione

   if t_diag = 'JERARQUICO' then begin
      rgTipo.Items.Clear;
      rgTipo.Items.Add('Horizontal');
      rgTipo.Items.Add('Vertical');
   end;
end;

procedure TalkFormConfDiag.set_data_docauto(com,bibl,clas,sist,tip_diag, fte:String);
var
   slSepara : TStringList;
   arch_aux : string;
   i : integer;
begin
   comp_g:=com;
   bib_g:=bibl;
   cla_g:=clas;
   sis_g:=sist;
   t_diag:=tip_diag;  //flujo - jerarquico
   online_auto:= 2;  // documentacion automatica (2)
   fuente:= fte;

   // ----  Preparando carpetas  -------------       documentacion
   slSepara:=TStringList.Create;
   slSepara.Delimiter:='|';
   slSepara.DelimitedText:=fte;

   directorio:= slSepara[0];
   ruta_entrada:= slSepara[0];  //carpeta de documentacion automatica
   ruta_salida := slSepara[0];
   arch_entrada:=slSepara[1];
   for i:=2 to slSepara.Count-1 do begin
      arch_entrada:=arch_entrada + ' ' + slSepara[i];
      arch_aux:= arch_aux + ' ' + slSepara[i];
   end;

   arch_aux:= stringreplace( trim( arch_aux ), '.txt', '.pdf', [ rfReplaceAll ] );

   lsArchSal := g_tmpdir + '\' + fuente + '.sal';
   lsArchSal2 := sDiagFlujo + ' ' + arch_aux; //de flujo
   lsArchSal3 := sDiagJerarquico + ' ' + arch_aux; //jerarquico
end;

procedure TalkFormConfDiag.Button1Click(Sender: TObject);
begin
   if (ruta = '') and (online_auto = 1) then begin
      ShowMessage('Debe especificar una ruta de salida');
      exit;
   end;
   if (formato = '') and (online_auto = 1) then begin
      ShowMessage('Debe especificar una formato de salida');
      exit;
   end;
   if (tipo = '') and (online_auto = 1) then begin
      ShowMessage('Debe especificar un tipo de archivo');
      exit;
   end;

   // ----- comprobar la variable de entorno graphviz ---------
   if not dm.valida_var_entorno('GRAPHVIZ') then begin
      ShowMessage('No existe la variable de entorno de Graphviz');
      exit;
   end;
   // ---------------------------------------------------------

   genera_diagrama();
end;

procedure TalkFormConfDiag.genera_diagrama();
var
   diagramador, men_error, dir_diagramador, tipo_diag : string;
   instruccion_f, instruccion_j, instruccion_s, ejecutadiagrama :string;
   aux_form : string;
   cobol : TStringList;
begin
   //el fuente en la documentacion viene sucio, entonces lo establezco nuevamente.
   if online_auto = 2 then begin
      ruta:=ruta_salida+arch_entrada;
      fuente:=ruta;
   end;

   //validar que exista la ruta
   if not directoryexists(ExtractFileDir(ruta)) then begin
      if forcedirectories( ExtractFileDir(ruta) ) = false then begin
         Application.MessageBox( pchar( dm.xlng( 'ERROR... No puede crear directorio ' + ExtractFileDir(ruta) ) ),
            pchar( dm.xlng( 'Diagramador' ) ), MB_OK );
         exit;
      end;
   end;

   //validar de que diagrama se trata (clase)
   if cla_g = 'ALG' then begin
      diagramador:= 'gendiagramaalgol';
      men_error:= 'Ejemplo: gendiagramaalgol File_Input FileOutput';
      dir_diagramador:= g_tmpdir+ '\' +diagramador+'.exe';
      ptscomun.get_utileria('DIAGALG', dir_diagramador, true);

      if t_diag = 'FLUJO' then
         tipo_diag := sDIGRA_FLUJO_ALG
      else
         tipo_diag := sDIGRA_JERARQUICO_ALG;
   end;

   if cla_g = 'BSC' then begin
      diagramador:= 'GeneraDiagramaBasic';
      men_error:= 'Ejemplo: GeneraDiagramaBasic File_Input FileOutput';
      dir_diagramador:= g_tmpdir+ '\' +diagramador+'.exe';
      ptscomun.get_utileria('DIAGBSC', dir_diagramador, true);

      if t_diag = 'FLUJO' then
         tipo_diag := sDIGRA_FLUJO_BSC
      else
         tipo_diag := sDIGRA_JERARQUICO_BSC;
   end;

   if cla_g = 'CBL' then begin
      diagramador:= 'GenDiagramaCobol';
      men_error:= 'Ejemplo: GenDiagramaCobol File_Input FileOutput';
      dir_diagramador:= g_tmpdir+ '\' +diagramador+'.exe';
      ptscomun.get_utileria('DIAGCBL', dir_diagramador, true);
      ptscomun.get_utileria('RESERVADAS CBL', g_tmpdir+ '\' + 'reserved.cbl', true);

      if t_diag = 'FLUJO' then
         tipo_diag := sDIGRA_FLUJO_CBL
      else
         tipo_diag := sDIGRA_JERARQUICO_CBL;
   end;

   if cla_g = 'DCL' then begin
      diagramador:= 'GenDiagramaDCE';
      men_error:= 'Ejemplo: GenDiagramaDCE File_Input FileOutput';
      dir_diagramador:= g_tmpdir+ '\' +diagramador+'.exe';
      ptscomun.get_utileria('DIAGDCL', dir_diagramador, true);

      if t_diag = 'FLUJO' then
         tipo_diag := sDIGRA_FLUJO_DCL
      else
         tipo_diag := sDIGRA_FLUJO_DCL;
   end;

   if cla_g = 'OSQ' then begin
      diagramador:= 'GenDiagramaOSQ';
      men_error:= 'Ejemplo: GenDiagramaOSQ File_Input FileOutput';
      dir_diagramador:= g_tmpdir+ '\' +diagramador+'.exe';
      ptscomun.get_utileria('DIAGOSQ', dir_diagramador, true);

      if t_diag = 'FLUJO' then
         tipo_diag := sDIGRA_FLUJO_OSQ
      else
         tipo_diag := sDIGRA_JERARQUICO_OSQ;
   end;

   if cla_g = 'TMC' then begin
      diagramador:= 'gendiagramamacros';
      men_error:= 'Ejemplo: gendiagramamacros File_Input FileOutput';
      dir_diagramador:= g_tmpdir+ '\' +diagramador+'.exe';
      ptscomun.get_utileria('DIAGMACRO', dir_diagramador, true);

      tipo_diag := sDIGRA_FLUJO_TMC;
   end;

   if (cla_g = 'TMP') or (cla_g = 'OBY')  then begin
      diagramador:= 'gendiagramamacros';
      men_error:= 'Ejemplo: gendiagramamacros File_Input FileOutput';
      dir_diagramador:= g_tmpdir+ '\' +diagramador+'.exe';
      ptscomun.get_utileria('DIAGMACRO', dir_diagramador, true);

      tipo_diag := sDIGRA_FLUJO_TMC;
   end;

   if cla_g = 'WFL' then begin
      diagramador:= 'gendiagramawfl';
      men_error:= 'Ejemplo: gendiagramawfl File_Input FileOutput';
      dir_diagramador:= g_tmpdir+ '\' +diagramador+'.exe';
      ptscomun.get_utileria('DIAGWFL', dir_diagramador, true);

      if t_diag = 'FLUJO' then
         tipo_diag := sDIGRA_FLUJO_WFL
      else
         tipo_diag := sDIGRA_JERARQUICO_WFL;
   end;

   // ***** Ajustando ultimos detalles de formato y tipo para interactividad  ****
   if tipo = '' then tipo:= '-array_i300'; // si viene de documentacion - default horizontal
   if formato = '' then formato:= 'pdf';  // si viene vacio o de documentacion - default pdf
   aux_form:= '-T'+ formato;    // auxiliar para poder retomar el simple tipo
   // dejo vacio el nombre cuando viene de productos para poderlo hacer interactivo
   if lsArchSal2='' then lsArchSal2 := ExtractFileName(fuente) + '_f.'+formato; //de flujo
   if lsArchSal3='' then lsArchSal3 := ExtractFileName(fuente) + '_p.'+formato; //jerarquico
   if ruta_salida = '' then ruta_salida:= ExtractFileDir(ruta);


   // ***************  Realizar el proceso  *********************

   // Aqui va el proceso para determinar el tipo de COBOL !!!!!!!!!!!!!!!!!!!
   // ----------------  Todo esto es de cobol!!!  ------------------
   if  cla_g = 'CBL' then begin
      // ---------------  determinar el tipo de cobol  -----------------
      cobol := TStringList.Create;
      ptscomun.da_tipo_cbl(sis_g,cla_g,bib_g,fuente,cobol);

      if cobol.count < 1 then
         cobol.Add('0');

      case StrToInt(cobol[0]) of
         81 : tipo_cbl:='T';  //Tandem
         86 : tipo_cbl:='V';  //vax
         else tipo_cbl:='F';  //fijo
      end;
      cobol.Free;

      // ejecutar el diagramador tomando el fuente dependiendo de donde venga y colocando la salida en temporal
      ejecutadiagrama:=g_tmpdir + '\' +diagramador + ' "' + fuente +'" "' + fuente + '" ' + tipo_cbl;
      // ------------------  Generar diagramas en forma horizontal  ---------------------------------
      //ccomps -x P010_f.dot | dot -Gcharset=latin1 | gvpack  -array_i300 |neato -Tpdf -n2 -o P010_f.pdf
      // ------------------  Generar diagramas en forma vertical --------------------------------------
      //ccomps -x P010_f.dot | dot -Gcharset=latin1 | gvpack  -array_i1 |neato -Tpdf -n2 -o P010_f.pdf
   // -----------------------------------------------------------------------------------
   end
   else begin
      // ------------------  Otros que no sean COBOL  ----------------------
      ejecutadiagrama:=g_tmpdir + '\' +diagramador + ' "' + fuente +'" "' + fuente+ '"';
   end;

   // ejecutar el diagramador tomando el fuente dependiendo de donde venga y colocando la salida en temporal
   instruccion_f:= 'ccomps -x "'+fuente+'_f.dot" | dot -Gcharset=latin1 | gvpack  ' + tipo + ' |neato ' + aux_form + ' -n2 -o '+
                         '"' + ruta_salida +'\'+ lsArchSal2 + '"';
   instruccion_j:= 'ccomps -x "'+fuente+'_p.dot" | dot -Gcharset=latin1 | gvpack  ' + tipo + ' |neato ' + aux_form + ' -n2 -o '+
                            '"' + ruta_salida +'\'+ lsArchSal3 + '"';


   g_borrar.Add(fuente+'_f.dot');
   g_borrar.Add(fuente+'_p.dot');
   g_borrar.Add(fuente+'_paso');

   // ------  Ya teniendo las instrucciones, solo se ejecuta  ---------------
   if dm.ejecuta_espera( ejecutadiagrama, SW_HIDE ) then     //ejecutar el diagramador
      sleep( 100 );

   if t_diag = 'FLUJO' then begin                //ejecutar el diagrama de flujo
      if dm.ejecuta_espera( instruccion_f, SW_HIDE ) then
         sleep( 100 )
      else begin
         if online_auto = 1 then
            Application.MessageBox( PChar( 'No se puede generar diagrama de flujo' ),
                  PChar( 'Diagrama de flujo' ), MB_ICONEXCLAMATION );
      end;

      if split = 1 then begin      // si viene de split
         // ccomps -x -o archEntrada archSalida_s.dot
         instruccion_s:= 'ccomps -x -o "' + ExtractFileDir(ruta)+'\'+comp_g+ '.dot" "' + fuente +'_f.dot"';

         g_borrar.Add(ExtractFileDir(ruta)+'\'+comp_g+ '.dot"');

         if dm.ejecuta_espera( instruccion_s, SW_HIDE ) then
            sleep( 100 )
         else begin
            if online_auto = 1 then
            Application.MessageBox( PChar( 'No se puede generar diagrama de flujo por partes' ),
                                    PChar( 'Diagrama de flujo' ), MB_ICONEXCLAMATION );
         end;
         // --- Proceso para generar los diagramas segun lo que el usuario solicito --------
        //  for /F "usebackq" %i in (` dir /B /TC /OD  "componenete"_* `) do dot -Tjpeg -o %i.jpeg %i
         instruccion_s:= 'for /F "usebackq" %i in (` dir /B /TC /OD  "'+ ExtractFileDir(ruta)+'\'+comp_g +'"?*.dot `) do dot '+ aux_form + ' -o %i.'+ formato + ' %i';

         if dm.ejecuta_espera( instruccion_s, SW_HIDE ) then begin
            sleep( 100 );
            if online_auto = 1 then
               Application.MessageBox( PChar( '¡Listo!' + char(13)+
                                      'Puede encontrar sus documentos en la ruta:'+char(13)+
                                      ExtractFileDir(ruta)),
                                    PChar( 'Diagrama de flujo por partes' ), MB_ICONINFORMATION );
         end
         else begin
            if online_auto = 1 then
            Application.MessageBox( PChar( 'No se pudo generar detalle de diagrama de flujo por partes' ),
                                    PChar( 'Diagrama de flujo por partes' ), MB_ICONEXCLAMATION );
         end;
         // --------------------------------------------------------------------------------
      end
      else begin
         if online_auto = 1 then   //si es del arbol, mostrarlo
            ShellExecute( 0, 'open', pchar( ruta_salida +'\'+ lsArchSal2 ), nil, PChar( ruta_salida ), SW_SHOW );
      end;
   end;

   if t_diag = 'JERARQUICO' then begin             //ejecutar el diagrama jerarquico
      if dm.ejecuta_espera( instruccion_j, SW_HIDE ) then
         sleep( 100 )
      else begin
         if online_auto = 1 then
            Application.MessageBox( PChar( 'No se puede generar diagrama jerarquico' ),
                     PChar( 'Diagrama jerarquico' ), MB_ICONEXCLAMATION );
      end;

      if split = 1 then
         Application.MessageBox( PChar( 'No se puede generar diagrama jerarquico por partes' ),
                     PChar( 'Diagrama jerarquico' ), MB_ICONEXCLAMATION );

      if online_auto = 1 then    //si es del arbol, mostrarlo
         ShellExecute( 0, 'open', pchar( ruta_salida +'\'+ lsArchSal3 ), nil, PChar( ruta_salida ), SW_SHOW );
   end;
   //self.Close;
   close;
end;

procedure TalkFormConfDiag.Button2Click(Sender: TObject);
var
   sNombreArchivo, sRutaMisDocumentos: String;
begin
   if length(formato)< 2 then begin
      ShowMessage('Debe seleccionar un formato');
      exit;
   end;

   sNombreArchivo := comp_g + '.' + formato;
   sRutaMisDocumentos := ObtenerMisDocumentos;

   with SaveDialog do begin
      InitialDir := sRutaMisDocumentos;
      DefaultExt := '.' + formato;
      FileName := sNombreArchivo;
      Filter := 'Todos los archivos(*.*)|*.*';

      if Execute then
         ruta:= FileName
      else
         ruta:= directorio;
   end;

   lbruta.Text := ruta;
end;

procedure TalkFormConfDiag.rgTipoClick(Sender: TObject);
var
   t : integer;
begin
   t:=rgTipo.ItemIndex;
   case t of
      1: tipo:='-array_i1';     // vertical
      2: begin
         tipo:='-array_i500';     //por partes
         split:=1;
      end
      else tipo:='-array_i500';   // default horizontal
   end;
end;

procedure TalkFormConfDiag.rgFormatoClick(Sender: TObject);
var
   f : integer;
begin
   f:=rgFormato.ItemIndex;
   case f of        // falta la '-T'
      0: formato:='jpg';     // jpg
      else formato:='pdf';   // default pdf
   end;
end;

function TalkFormConfDiag.ObtenerMisDocumentos: String;
var
   bLongBool: Bool;
   sPath: array[ 0..Max_Path ] of Char;
begin
   bLongBool := ShGetSpecialFolderPath( 0, sPath, CSIDL_Personal, False );

   if not bLongBool then
      Result := 'C:'
   else
      Result := sPath;
end;

end.
