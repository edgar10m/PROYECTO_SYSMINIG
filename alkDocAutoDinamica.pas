unit alkDocAutoDinamica;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, ADODB,
  Dialogs, OleServer, Word2000, StrUtils, ptsdm, uConstantes, ShlObj, ShellApi;
//  WordXP;
//  WordXP;

  type
   Txx = record
      nivel: integer;
      clase: string;
      bib: string;
      nombre: string;
      sistema: string;
   end;

type
  TalkFormDocAutoDinam = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cierra_docto;
  private
    { Private declarations }
    clase, biblioteca, sistema, componente, comp_aux, ruta, tipo, fecha : String; // datos generales del componente
    ruta_guardar, sDirSistema, nueva_ruta : String;
    wdGoToLine, wdGoToLast: OleVariant;
    error, borrar_links:Tstringlist;
    x: array of Txx;
    xx, clases, excluyemenu, clasesexiste,filtro_cla, filtro_rep: Tstringlist;
    aPriClases: array of string;
    continua,word_abierto:integer;
    v_compo, v_bib, v_clase, v_sistema, Wciclado: string;
    funciono : boolean;
    Word: TWordApplication;
    function dame_link(comp,cla,bib,sis:String):String;
    function agrega_compo( qq: Tadoquery ; g_nivel:integer ): boolean;
    procedure leecompos( compo, bib, clase, sistema: string; g_nivel : integer );
    procedure llena_clases;
    procedure quita_links;
    function cambia_ruta(ruta:String):String;
    function da_descripcion:String;
  public
    { Public declarations }
    procedure get_datos (cl,b,s,co,r,ti,fe: String);
    procedure crear;
    procedure terminar;
    procedure desde_menu;

    procedure PriInsertaTexto(
       iParSection: Integer; // 1-encabezado, 2-Normal, 3-Pie de pagina
       sParFName: String; iParFBold: Integer; iParFItalic: Integer; iParFSize: Integer; iParAlignment: Integer;
       sParTexto: String ); //word
    procedure PriInsertaHyperLink( ParRange: IDispatch; sParAddres, sParTexto: String );
    procedure PriInsertaArchivo( ParRange: IDispatch;sParAddres: String );
    procedure PriInsertaSaltoPagina;
    procedure sustituye_hiperlink(busca,etiqueta,hiper:string);
    function leer_remplazar(busca,rempl:String):String;   // devuelve el contenido de la etiqueta
    procedure leer_remplazar_todo(busca,rempl:String);   // reemplaza todas las veces qeu encuentra la palabra que se le manda
    function remplaza_valores(old_str : String):String; // para reemplazar las variables.
    procedure remplaza_valores_doc;
    procedure reemplaza_por_titulo;
    function svsicon(archivo:string):boolean;
    function svsword(archivo:string):boolean;
    procedure svsimage(etiq,archivo : string);
    procedure crea_tabla_word;
    procedure sust_etiq;
  end;

var
  alkFormDocAutoDinam: TalkFormDocAutoDinam;

implementation

{$R *.dfm}
procedure TalkFormDocAutoDinam.get_datos (cl,b,s,co,r,ti,fe: String);
begin
   clase:=cl;
   biblioteca:=b;
   sistema:=s;
   componente:=co;
   ruta:=r;   //sPriRutaSalida + sCSISTEMA + '\Diagrama Sistema\' + sTitulo;
   tipo:=ti;
   fecha:=fe;

   clases := Tstringlist.Create;
   clasesexiste := Tstringlist.Create;
   xx := Tstringlist.Create;
end;

procedure TalkFormDocAutoDinam.sust_etiq;
var
   referencia, etiq, link, link_original : String;
   separado : TStringList;
   i:integer;

   procedure haz_cambios (palabra, remplaza : String; t : integer);
   var
      limpio : String;
      componente_original:string;
   begin
      referencia:='';
      referencia:=trim(leer_remplazar(palabra,remplaza));
      while referencia <> '' do begin
         separado := TStringList.Create;

         //obteniendo informacion
         separado.Add(copy(referencia,0,pos('|',referencia)-1));
         separado.Add(copy(referencia,pos('|',referencia)+1,length(referencia)-1));

         // procesar las informacion encontrada
         etiq:= remplaza_valores(separado[0]);
         componente_original:=componente;
         bGlbQuitaCaracteres(componente);
         link_original:= remplaza_valores(separado[1]);
         componente:=componente_original;
         bGlbQuitaCaracteres(limpio);
         //limpio:= copy(extractfilename(remplaza_valores(separado[1])),0,pos('.',extractfilename(remplaza_valores(separado[1])))-1);
         //limpio:= copy(extractfilename(link_original),0,pos('.',extractfilename(link_original))-1);
         limpio:= extractfilename(link_original);
         limpio:= copy(limpio,1,length(limpio)-length(ExtractFileExt(limpio)));
         bGlbQuitaCaracteres(limpio);
         link:= ExtractFilePath(link_original) +
                trim(limpio) +
                trim(ExtractFileExt(separado[1]));
         if (etiq='')or (link='') then begin      // cambiar si se corrije el problema de la basura que deja en el proceso
            referencia:='';
            separado.Free;
            continue;
         end;

         link:=trim(link);

         if (not fileexists(link)) and (t<>5) and (t<>1) then begin  //revisar que exista el archivo o cambiar a que lo muestre en un log de errores
            error.Add('El archivo: '+link+ ' no existe.');    //ShowMessage('El archivo: '+link+ ' no existe.')
            reemplaza_por_titulo;
            word.Selection.Text:=word.Selection.Text+
               '(No hay información del producto para este componente)';
         end
         else begin
            funciono:=TRUE;
            case t of
               1: sustituye_hiperlink(referencia,etiq,link);   // LINK
               2: funciono:=svsicon(link);  // icon
               3: funciono:=svsword(link);  // word
               4: svsimage(etiq,link);  // imagenes
               5: begin
                     nueva_ruta:=link; // para obtener la ruta del documento
                     borrar_links.Add(etiq);
                     reemplaza_por_titulo;
                  end;
            end;
         end;

         //---- agregar a la lista de lo que va a borrar --------
         borrar_links.Add(link_original);

         if not funciono then
            exit;

         separado.Free;
         referencia:='';
         referencia:=trim(leer_remplazar(palabra,''));
      end;
   end;
begin
   funciono:=TRUE;
   
   for i:=0 to 50 do begin // para que revise que no queden etiquetas que sustituir
      // ---- aqui se obtiene la ruta donde se van a almacenar --------
      haz_cambios('<SVSOUTPUT>','', 5);
      if not funciono then
         break;
      // -- aqui se buscan las ETIQUETAS para ser remplazadas --
      haz_cambios('<SVSLINK>','', 1);
      if not funciono then
         break;
      // ---- aqui se colocan los ICONOS  --------
      haz_cambios('<SVSICON>','', 2);
      if not funciono then
         break;
      // ---- aqui se coloca la vista previa --------
      haz_cambios('<SVSWORD>','', 3);
      if not funciono then
         break;
      // ---- aqui se buscan las imagenes para ser remplazadas --------
      haz_cambios('<SVSIMAGE>','<SVSIMAGE>', 4);
      if not funciono then
         break;
   end;
end;

procedure TalkFormDocAutoDinam.crear;
var
   Documento,falso: OleVariant;
   doc_esp,doc_plantilla: String;  // para tener el nombre del nuevo
   archivo :TStringList;// : TextFile;
   i:integer;
begin
  inherited;
   //sDirSistema := sPriRutaSalida + sParSistema + '\';
   ruta_guardar:= ruta + sistema + '\' +clase;   // ruta de la carpeta
   if clase='NEP' then
      sDirSistema:= ruta + sistema + '\PROCESO_NEGOCIO\' + clase + '\'
   else
      if clase='NEG' then
         sDirSistema:= ruta + sistema + '\Sistema\'+clase+'\'
      else
         sDirSistema:= ruta + sistema + '\Componentes\'+clase+'\';

   if (not directoryexists(ruta_guardar)) and (tipo <> '1') then begin
      //cambiar el mensaje por un documento de error, no se pude presentar un mensaje en la documentacion automatica
      Application.MessageBox( PChar( 'No se encuentra el directorio ' + ruta_guardar ),
         pchar( 'Aviso' ), MB_OK );
      Exit;
   end;

   try
      // -- aqui va la funcion que trae el documento de las utilerias --
      if tipo = '1' then begin     // sistema
         doc_plantilla:= g_tmpdir + '\' + 'Plantilla_Word_'+sistema+'.doc';
      end
      else begin                    // componentes
         comp_aux:=componente;
         bGlbQuitaCaracteres(comp_aux);
         doc_plantilla:= g_tmpdir + '\' + 'Plantilla_Word_'+clase+'_'+comp_aux+'.doc';
      end;

      doc_esp:=cambia_ruta(sDirSistema);
      Documento:=doc_esp;

      if FileExists(doc_esp)then begin
         error.Add('**** No se genero: '+ doc_esp + ' por que ya existia. ****');
         word_abierto:=0;
         exit;
      end;

      // -------  preparando el documento, copiarlo y abrirlo  ------------
      //RGMCopyFile(PChar(doc_plantilla),PChar(doc_esp),TRUE);
      //RGMWord.Documents.Open(Documento, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam,
      documento:=doc_plantilla;     // abrir la plantilla
      //copyfile(pchar(doc_plantilla),pchar(doc_plantilla),TRUE);
      Word.Documents.Open(documento, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam,
         EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam);
      documento:=doc_esp;   // cambiar al nombre final para que asi lo guarde
      //Word.Documents.Open(FileName,ConfirmConversions,ReadOnly,AddToRecentFiles,PasswordDocumento,PasswordTemplate,Revert,WritePasswordDocument,...);
      word_abierto:=1;  // para indicar a la funcion final que debe de cerrarlo
      falso:=FALSE;
      Word.DisplayAlerts:=falso;

      // ---- busca si hay que agregar tabla detalle --------
      for i:=0 to 5 do
         crea_tabla_word;

      // ---- llamar a la funcion que realiza las sustitucinoes -------
      try
         nueva_ruta:='';
         sust_etiq;

         if not funciono then
            exit;

         if nueva_ruta <> '' then begin
            doc_esp:=cambia_ruta(nueva_ruta);
            Documento:=doc_esp;
         end;
      except
         {AssignFile(archivo, g_tmpdir + '\LogDocAut_' + fecha + '.txt');
         append(archivo);
         WriteLn(archivo, 'Error en documento: '+doc_esp);
         CloseFile(archivo);}
         archivo:=TStringList.Create;
         if FileExists(g_logdir + '\LogDocAut_' + stringreplace( fecha, '/', ' ', [ rfReplaceAll ] ) + '.txt') then
            archivo.LoadFromFile(g_logdir + '\LogDocAut_' + stringreplace( fecha, '/', ' ', [ rfReplaceAll ] ) + '.txt');
         archivo.Add('Error en documento: ' + doc_esp);
         archivo.SaveToFile(g_logdir + '\LogDocAut_' + stringreplace( fecha, '/', ' ', [ rfReplaceAll ] ) + '.txt');
         archivo.Free;
         exit;
      end;
      // ------------- Reemplazar el resto de las variables ------
      remplaza_valores_doc;

      quita_links;

      //---------------- guardar el documento -------------------------
      Documento:= doc_esp;
      Word.ActiveDocument.SaveAs(
               Documento, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam,
               EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam);
     // ----------------------------------------------------------------
     deletefile(doc_plantilla);
   finally
      //Cerrar documento sin desconectar de Word
      cierra_docto;
   end;
end;

procedure TalkFormDocAutoDinam.terminar;
begin
   if error.Count > 0 then begin
      //Verificar que existe la carpeta donde se guarda
      if forcedirectories( ruta + sistema + '\' ) = false then begin
         application.MessageBox( pchar( dm.xlng( 'AVISO... no puede crear el directorio ' + ruta + sistema ) ),
            pchar( dm.xlng( 'Documentacion de Sistema' ) ), MB_OK );
         Exit;
      end;

      error.SaveToFile(ruta + sistema + '\lista_errores.txt');
   end;
   error.Free;

   if length( aPriClases ) > 0 then
      SetLength( aPriClases, 0 );

   borrar_links.Free;

   filtro_cla.Free;
   filtro_rep.Free;
   clases.Free;
   clasesexiste.Free;
   xx.Free;
end;

procedure TalkFormDocAutoDinam.PriInsertaTexto(
   iParSection: Integer; // 1-encabezado, 2-Normal
   sParFName: String; iParFBold: Integer; iParFItalic: Integer; iParFSize: Integer; iParAlignment: Integer;
   sParTexto: String );
begin
   if iParSection = 1 then begin
      // Encabezado
      Word.Selection.PageSetup.DifferentFirstPageHeaderFooter := -1; //no repite en la primera hoja el encabezado
      with Word.Selection.Sections.Item( 1 ).Headers.Item( 1 ).Range do begin
         Font.Name := sParFName;
         Font.Bold := iParFBold;
         Font.Italic := iParFItalic;
         Font.Size := iParFSize;
         Text := sParTexto;

         Paragraphs.Alignment:= iParAlignment
         {Paragraphs.Item( 1 ).Alignment := iParAlignment;
         Paragraphs.Item( 2 ).Alignment := iParAlignment;}  //cambio ALK
      end;
   end;

   if iParSection = 2 then begin
      with Word.Selection do begin
         Font.Name := sParFName;
         Font.Bold := iParFBold;
         Font.Italic := iParFItalic;
         Font.Size := iParFSize;
         ParagraphFormat.Alignment := iParAlignment;
         //ParagraphFormat.FirstLineIndent := 2;
         TypeText( sParTexto + #13 );
      end;
   end;
end;

procedure TalkFormDocAutoDinam.PriInsertaHyperLink( ParRange: IDispatch; sParAddres, sParTexto: String );
var
   Addres, TextoDisplay: OleVariant;
begin
   Addres := sParAddres;
   TextoDisplay := sParTexto;

   Word.Selection.Hyperlinks.Add(
      ParRange, Addres, EmptyParam, EmptyParam, TextoDisplay, EmptyParam );
end;

procedure TalkFormDocAutoDinam.PriInsertaArchivo( ParRange: IDispatch;sParAddres: String );   //word
var
   verdad,falso: OleVariant;
begin
   verdad := true;
   falso := false;
   //Word.Selection.InsertFile(sParAddres,Range,ConfirmConversions,Link,Attachment);       //  plantilla
   Word.Selection.InsertFile( sParAddres,EmptyParam,EmptyParam,EmptyParam,EmptyParam);       //inserta un documento en otro
end;


procedure TalkFormDocAutoDinam.PriInsertaSaltoPagina;
var
   wdBreakPage: OleVariant;
begin
   wdBreakPage := 7; //wdPageBreak
   Word.Selection.Range.InsertBreak( wdBreakPage );

   try //necesario para el salto de pagina, hasta no saber como hacerlo correctamente
      with Word do
         with Selection do
            with Tables.Add( Range, 1, 1, EmptyParam, EmptyParam ) do begin
               Cell( 1, 1 ).Range.Text := '.';
               Delete;
            end;
   finally
      wdGoToLine := 3;
      wdGoToLast := -1;
      with Word do // va al final del docto
         with Selection do
            goto_( wdGoToLine, wdGoToLast, EmptyParam, EmptyParam );
   end;
end;

procedure TalkFormDocAutoDinam.sustituye_hiperlink(busca,etiqueta,hiper:string);
var
   texto,nuevo,what,which,count:OleVariant;
   ok:boolean;
begin
   // coloca el cursor al principio del documento
   what:=wdGoToLine;
   which:=wdGoToAbsolute;
   count:=1;
   repeat
      Word.Selection.GoTo_(what,which,count,emptyparam);
      // Busca texto y reemplaza con nuevo
      texto:=busca;
      nuevo:=hiper;
      ok:=Word.Selection.Find.Execute(texto,
         emptyparam,emptyparam,emptyparam,emptyparam,emptyparam,
         emptyparam,emptyparam,emptyparam,nuevo,emptyparam,
         emptyparam,emptyparam,emptyparam,emptyparam);
      if ok then
         PriInsertaHyperLink(Word.Selection.Range,hiper,etiqueta);
   until ok=false;
      // Inserta texto después de lo que reemplazó (posición actual del cursor)
      //Word.Selection.InsertAfter(etiqueta);  // no lo inserta en la posicion del cursor, lo inserta al principio
end;

function TalkFormDocAutoDinam.leer_remplazar(busca,rempl:String):String;   // devuelve el contenido de la etiqueta
var
   texto,nuevo,what,which,count,units,extend:OleVariant;
begin
   // coloca el cursor al principio del documento, para que busque desde el principio
   what:=wdGoToLine;
   which:=wdGoToAbsolute;
   count:=1;
   Word.Selection.GoTo_(what,which,count,emptyparam);

   // Busca etiqueta, la elimina y deja el cursor en el párrafo que queremos leer
   texto:=busca;     //'<SVSLINK>';
   nuevo:=rempl;     //'';

   Word.Selection.Find.Execute(texto,
      emptyparam,emptyparam,emptyparam,emptyparam,emptyparam,
      emptyparam,emptyparam,emptyparam,nuevo,emptyparam,
      emptyparam,emptyparam,emptyparam,emptyparam);

   // Selecciona el párrafo completo
   units:=wdParagraph;
   extend:=wdextend;
   Word.Selection.EndOf(units,extend);

   // El contenido del párrafo lo tenemos en wordapp.Selection.Text
   //showmessage(Word.Selection.Text);
   Result:=Word.Selection.Text;
end;

procedure TalkFormDocAutoDinam.leer_remplazar_todo(busca,rempl:String);   // reemplaza todas las veces qeu encuentra la palabra que se le manda
var
   texto,nuevo,what,which,count,units,extend,remplaza:OleVariant;
begin
   // coloca el cursor al principio del documento, para que busque desde el principio
   remplaza:=wdreplaceall;
   what:=wdGoToLine;
   which:=wdGoToAbsolute;
   count:=1;
   Word.Selection.GoTo_(what,which,count,emptyparam);

   // Busca etiqueta, la elimina y deja el cursor en el párrafo que queremos leer
   texto:=busca;     //'<SVSLINK>';
   nuevo:=rempl;     //'';

   Word.Selection.Find.Execute(texto,
      emptyparam,emptyparam,emptyparam,emptyparam,emptyparam,
      emptyparam,emptyparam,emptyparam,nuevo,remplaza,
      emptyparam,emptyparam,emptyparam,emptyparam);

   // Selecciona el párrafo completo
   units:=wdParagraph;
   extend:=wdextend;
   Word.Selection.EndOf(units,extend);
end;

procedure TalkFormDocAutoDinam.reemplaza_por_titulo;
var units,extend:OleVariant;
   titulo:string;
begin
   units:=wdParagraph;
   extend:=wdextend;
   Word.Selection.EndOf(units,extend);
   titulo:=copy(word.selection.text,pos('>',word.selection.text)+1,1000);
   titulo:=copy(titulo,1,pos('|',titulo)-1);
   word.selection.text:=titulo;
end;
function TalkFormDocAutoDinam.svsicon(archivo:string):boolean;
var
   arch,DisplayAsIcon,rango:OleVariant;
   valor:InLineShape;
begin
   DisplayAsIcon:=true;
   arch:=archivo;
   rango:=Word.Selection.Range;
   try
      valor:=Word.ActiveDocument.inlineShapes.AddOLEObject( EmptyParam,arch,
            EmptyParam,DisplayAsIcon,EmptyParam,EmptyParam,EmptyParam,rango);
      arch:=valor.Height;
      reemplaza_por_titulo;
      //showMessage(valor.Application.Caption);
   except
      Result:=false;
      //showMessage(valor.Application.Caption);
      showMessage('buuuuu!! jajajaja');
      exit;
   end;
   Result:=true;
end;

function TalkFormDocAutoDinam.svsword(archivo:string):boolean;
var
   arch,DisplayAsIcon,rango:OleVariant;
   valor:InLineShape;
begin
   DisplayAsIcon:=false;
   arch:=archivo;
   rango:=Word.Selection.Range;
   try
      valor:=Word.ActiveDocument.inlineShapes.AddOLEObject( EmptyParam,arch,
            EmptyParam,DisplayAsIcon,EmptyParam,EmptyParam,EmptyParam,rango);
      arch:=valor.Height;
      reemplaza_por_titulo;
   except
      Result:=false;
      //showMessage(valor.Application.Caption);
      showMessage('buuuuu!! jajajaja');
      exit;
   end;
   Result:=true;
end;

procedure TalkFormDocAutoDinam.svsimage(etiq,archivo : string);
var
   texto,nuevo,what,which,count:OleVariant;
begin
   // coloca el cursor al principio del documento, para que busque desde el principio
   what:=wdGoToLine;
   which:=wdGoToAbsolute;
   count:=1;
   Word.Selection.GoTo_(what,which,count,emptyparam);
   // Busca etiqueta, la elimina y deja el cursor en el párrafo que queremos leer
   texto:='<SVSIMAGE>';
   nuevo:='';

   Word.Selection.Find.Execute(texto,
   emptyparam,emptyparam,emptyparam,emptyparam,emptyparam,
   emptyparam,emptyparam,emptyparam,nuevo,emptyparam,
   emptyparam,emptyparam,emptyparam,emptyparam);

   Word.ActiveDocument.InLineShapes.AddPicture(archivo,EmptyParam,EmptyParam,EmptyParam);
   //reemplaza_por_titulo;
end;

function TalkFormDocAutoDinam.da_descripcion:String;
var
   desc, cons:String;
begin
   cons:='select DESCRIPCION from tsprog' +
         ' where cprog= ' + g_q + componente + g_q +
         ' and cclase=' + g_q + clase + g_q +
         ' and cbib='  + g_q + biblioteca + g_q +
         ' and sistema='+ g_q + sistema + g_q;
   if dm.sqlselect(dm.q4,cons) then
      desc:=dm.q4.FieldByName( 'DESCRIPCION' ).AsString;

   da_descripcion:=desc;
end;

function TalkFormDocAutoDinam.remplaza_valores(old_str : String):String; // para reemplazar las variables.
var
   res : String;
begin
   res:=stringreplace( old_str, '$sistema$', sistema, [ rfreplaceall ] );
   res:=stringreplace( res, '$SISTEMA$', sistema, [ rfreplaceall ] );
   res:=stringreplace( res, '$clase$', clase, [ rfreplaceall ] );
   res:=stringreplace( res, '$CLASE$', clase, [ rfreplaceall ] );
   res:=stringreplace( res, '$biblioteca$', biblioteca, [ rfreplaceall ] );
   res:=stringreplace( res, '$BIBLIOTECA$', biblioteca, [ rfreplaceall ] );
   res:=stringreplace( res, '$componente$', componente, [ rfreplaceall ] );
   res:=stringreplace( res, '$COMPONENTE$', componente, [ rfreplaceall ] );
   res:=stringreplace( res, '$ruta$', ruta, [ rfreplaceall ] );
   res:=stringreplace( res, '$RUTA$', ruta, [ rfreplaceall ] );
   res:=stringreplace( res, '$fecha$', fecha, [ rfreplaceall ] );
   res:=stringreplace( res, '$FECHA$', fecha, [ rfreplaceall ] );
   res:=stringreplace( res, '$empresa$', componente, [ rfreplaceall ] );
   res:=stringreplace( res, '$EMPRESA$', componente, [ rfreplaceall ] );

   res:=stringreplace( res, '$descripcion$', da_descripcion, [ rfreplaceall ] );
   res:=stringreplace( res, '$descripción$', da_descripcion, [ rfreplaceall ] );
   res:=stringreplace( res, '$DESCRIPCION$', da_descripcion, [ rfreplaceall ] );

   //res:=stringreplace( res, '$salto$', ('"'+caracter+'"'), [ rfreplaceall ] );
   //res:=stringreplace( res, '$SALTO$', ('"'+caracter+'"'), [ rfreplaceall ] );
   remplaza_valores:=res;
end;

procedure TalkFormDocAutoDinam.remplaza_valores_doc;
begin
   leer_remplazar_todo('$sistema$', sistema);
   leer_remplazar_todo('$SISTEMA$', sistema);
   leer_remplazar_todo('$clase$', clase);
   leer_remplazar_todo('$CLASE$', clase);
   leer_remplazar_todo('$biblioteca$', biblioteca);
   leer_remplazar_todo('$BIBLIOTECA$', biblioteca);
   leer_remplazar_todo('$componente$', componente);
   leer_remplazar_todo('$COMPONENTE$', componente);
   leer_remplazar_todo('$ruta$', ruta);
   leer_remplazar_todo('$RUTA$', ruta);
   leer_remplazar_todo('$fecha$', fecha);
   leer_remplazar_todo('$FECHA$', fecha);
   leer_remplazar_todo('$descripción$', da_descripcion);
   leer_remplazar_todo('$descripcion$', da_descripcion);
   leer_remplazar_todo('$DESCRIPCION$', da_descripcion);
   leer_remplazar_todo('$empresa$', componente);
   leer_remplazar_todo('$EMPRESA$', componente);
end;

procedure TalkFormDocAutoDinam.FormCreate(Sender: TObject);
begin
   error:=TStringList.Create;
   filtro_cla:=TStringList.Create;
   filtro_rep:=TStringList.Create;
   borrar_links:=TStringList.Create;
   borrar_links.Duplicates:=dupIgnore;

   //abrir y conectar con el servidor Word
   Word := TWordApplication.Create(Self);
   Word.Connect;
   //Word.Visible:=true;
end;

function TalkFormDocAutoDinam.dame_link(comp,cla,bib,sis:String):String;
var
    sLink: String;
begin
   bGlbQuitaCaracteres(comp);
   //bGlbQuitaCaracteres(bib);
   {sLink:='<SVSLINK>Documento Detalle'+
           //'|'+sDirSistema +
           '|'+ruta + sis + '\Componentes\'+cla+'\'+
           'DT_' + sis +'_'+ cla +'_'+bib+'_'+comp+'.doc';}
   sLink:=ruta + sis + '\Componentes\'+cla+'\'+
           'DT_' + sis +'_'+ cla +'_'+bib+'_'+comp+'.doc';

   Result:=sLink
end;

procedure TalkFormDocAutoDinam.crea_tabla_word;
var
   iRenglones,iRenglon,iColumnas: Integer;
   qTSRELA : TAdoQuery;
   g_nivel,k,i: integer;
   DefaultTableBehavior, AutoFitBehavior, o_Rows, rango: OleVariant;
   texto,nuevo,what,which,count,s1,s2:OleVariant;
   ok:boolean;  // para saber si se hace la tabla o no
   repetido:string;
begin
   Word.Selection.GoTo_(what,which,count,emptyparam);
   // Busca etiqueta, la elimina y deja el cursor en el párrafo que queremos leer
   texto:='<SVSTABDEP>';
   nuevo:='';

   ok := Word.Selection.Find.Execute(texto,
   emptyparam,emptyparam,emptyparam,emptyparam,emptyparam,
   emptyparam,emptyparam,emptyparam,nuevo,emptyparam,
   emptyparam,emptyparam,emptyparam,emptyparam);

   if not ok then
      exit;

   qTSRELA := TAdoQuery.Create( Self );
   SetLength( aGLBTsrela, 0 );
   //  -------------  haciendo consulta -------------------------
   try
      qTSRELA.Connection := dm.ADOConnection1;
      k:=length(x)+1;
      setlength( x, k );
      xx.Clear;
      g_nivel := 0;

      if dm.sqlselect( qTSRELA, 'select * from tsrela ' +
            ' where hcprog =' + g_q + componente + g_q +
            ' and   hcbib =' + g_q + biblioteca + g_q +
            ' and   hcclase =' + g_q + clase + g_q ) then begin
         agrega_compo( qTSRELA , g_nivel);

         leecompos( qTSRELA.FieldByName( 'hcprog' ).AsString,
            qTSRELA.FieldByName( 'hcbib' ).AsString,
            qTSRELA.FieldByName( 'hcclase' ).AsString,
            qTSRELA.FieldByName( 'sistema' ).AsString,
            g_nivel+1);
      end
      else begin
         error.Add('No existe informacion para tabla: '+componente+' '+clase+' '+biblioteca);
         Exit;
      end;


      // ---------------- creando tabla  ----------------------------
      iRenglones := 1;
      iColumnas := 5; //comp,cla,bib,sist,link

      DefaultTableBehavior := wdWord9TableBehavior;   //wdWord8TableBehavior;
      AutoFitBehavior := wdAutoFitContent; //wdAutoFitFixed
      try
         with Word do begin
            with Selection do begin
               with Tables.Add( Range, iRenglones, iColumnas + 1, EmptyParam, EmptyParam ) do begin
                  Borders.OutsideLineStyle := 1;

                  // ------------------ Títulos de la tabla ------------------------
                  Columns.Item( 1 ).SetWidth( 50, wdAdjustNone );
                  Columns.Item( 2 ).SetWidth( 90, wdAdjustNone );
                  Columns.Item( 3 ).SetWidth( 50, wdAdjustNone );
                  Columns.Item( 4 ).SetWidth( 90, wdAdjustNone );
                  Columns.Item( 5 ).SetWidth( 70, wdAdjustNone );
                  Columns.Item( 6 ).SetWidth( 100, wdAdjustNone );

                  Cell( 1, 1 ).Range.Text := 'Nivel';
                  Cell( 1, 2 ).Range.Text := 'Componente';
                  Cell( 1, 3 ).Range.Text := 'Clase';
                  Cell( 1, 4 ).Range.Text := 'Biblioteca';
                  Cell( 1, 5 ).Range.Text := 'Sistema';
                  Cell( 1, 6 ).Range.Text := 'Link';

                  //Rows.Item( 1 ).Range.Paragraphs.Alignment := wdAlignParagraphCenter;
                  Rows.Item( 1 ).Range.Font.Color := clBlack;
                  Rows.Item( 1 ).Range.Font.Size := 7;
                  Rows.Item( 1 ).Range.Font.Bold := 0;
                  Rows.Item( 1 ).Range.Font.Italic := 0;

                  // ----------------- Detalle ---------------------
                  o_Rows:=1;

                  iRenglon:=2; // para que empiece en 2

                  s2:='Documento Detalle';
                  for i:=0 to length(x)-1 do begin
                     if (x[i].nombre = '') or (x[i].nivel = 0) then
                        continue;

                     repetido:= IntToStr(x[i].nivel)+'_'+
                                x[i].nombre+'_'+
                                x[i].clase+'_'+
                                x[i].bib+'_'+
                                x[i].sistema;

                     if (filtro_cla.IndexOf(x[i].clase) <> -1) and
                        (filtro_rep.IndexOf(repetido) = -1) then begin
                        iRenglon:=iRenglon+1;

                        s1:= dame_link(x[i].nombre,x[i].clase,x[i].bib,x[i].sistema);

                        Word.Selection.Tables.Item(1).Rows.Item(Word.Selection.Tables.Item(1).Rows.Count).Select;
                        Word.Selection.InsertRowsBelow(o_Rows);
                        Cell( iRenglon, 1 ).Range.Text := IntToStr(x[i].nivel);
                        Cell( iRenglon, 2 ).Range.Text := x[i].nombre;
                        Cell( iRenglon, 3 ).Range.Text := x[i].clase;
                        Cell( iRenglon, 4 ).Range.Text := x[i].bib;
                        Cell( iRenglon, 5 ).Range.Text := x[i].sistema;
                        //Cell( iRenglon, 6 ).Range.Text := dame_link(x[i].nombre,x[i].clase,x[i].bib,x[i].sistema);
                        rango:= Cell( iRenglon, 6 ).Range;
                        Cell( iRenglon, 6 ).Range.Hyperlinks.Add(rango, s1, EmptyParam, EmptyParam, s2, EmptyParam);

                        filtro_rep.Add(repetido);
                     end;
                  end;

                  Rows.Item( 1 ).Shading.BackgroundPatternColor := clSkyBlue;    //color de la celda  (azul cielo)
                  Rows.Item( 1 ).Range.Font.Color := clBlack;   // color de la fuente
                  Rows.Item( 1 ).Range.Font.Size := 8;     // tamaño de la fuente
                  Rows.Item( 1 ).Range.Font.Bold := 1;     //negritas si
                  Rows.Item( 1 ).Range.Font.Italic := 0;    //cursiva no
                  //Columns.Item( 2 ).SetWidth( 90, wdAdjustNone );
               end;
            end;
         end;
      finally
         wdGoToLine := 3;
         wdGoToLast := -1;

         with Word do // va al final del docto
            with Selection do
               goto_( wdGoToLine, wdGoToLast, EmptyParam, EmptyParam );
      end;
   finally
      qTSRELA.Free;
   end;
end;

procedure TalkFormDocAutoDinam.leecompos( compo, bib, clase, sistema: string; g_nivel : integer );
var
   qq: Tadoquery;
   nuevo, bexiste: boolean;
   bRepetido: Boolean;
   cc: String;
   i, ii, jj: integer;
   sClase: string;
begin
   inherited;

   bRepetido := bGlbRepetidoTsrela( compo, bib, clase );

   continua:=0;   // para detenerlo si hay un out of memory ALK

   if not bRepetido then begin
      try
         GlbRegistraArregloTsrela( compo, bib, clase );
      except
         on E: exception do begin
            alkErrorGral:=E.Message;   // prueba documentacion ALK
            continua:=1;   // para detenerlo si hay un out of memory ALK
         end;
      end;

      qq := Tadoquery.Create( self );
      try
         qq.Connection := dm.ADOConnection1;
         if dm.sqlselect( qq, 'select * from tsrela ' +
            ' where pcprog=' + g_q + compo + g_q +
            ' and   pcbib=' + g_q + bib + g_q +
            ' and   pcclase=' + g_q + clase + g_q ) then begin

            llena_clases;

            while ((not qq.Eof) and (continua = 0) ) do begin
                  bexiste := false;
                  nuevo := false;

                  ii := -1;
                  for i := 0 to length( aPriClases ) -1 do begin
                     sClase := ( qq.fieldbyname( 'hcclase' ).AsString );
                     if AnsiMatchStr( sClase, aPriClases[ i ] ) then begin
                        ii := i;
                        Break;
                     end;
                  end;
                  IF ii >= 0 then begin
                     cc := v_compo + '|' + v_bib + '|' + v_clase + '|' +
                        qq.FieldByName( 'ocprog' ).AsString + '|' +
                        qq.FieldByName( 'ocbib' ).AsString + '|' +
                        qq.FieldByName( 'occlase' ).AsString + '|' +
                        qq.FieldByName( 'pcprog' ).AsString + '|' +
                        qq.FieldByName( 'pcbib' ).AsString + '|' +
                        qq.FieldByName( 'pcclase' ).AsString + '|' +
                        qq.FieldByName( 'hcprog' ).AsString + '|' +
                        qq.FieldByName( 'hcbib' ).AsString + '|' +
                        qq.FieldByName( 'hcclase' ).AsString;
                     if xx.IndexOf( cc ) > -1 then
                        bexiste := True
                     else
                        bexiste := False;
                     if clases.IndexOf( qq.FieldByName( 'hcclase' ).AsString ) > -1 then begin
                        if g_nivel = 1 then begin
                           v_clase := qq.FieldByName( 'hcclase' ).AsString;
                           v_bib := qq.FieldByName( 'hcbib' ).AsString;
                           v_compo := qq.FieldByName( 'hcprog' ).AsString;
                           v_sistema := qq.FieldByName( 'sistema' ).AsString;
                        end;
                        continua:=1;

                        try                        //ALK out of memory
                           continua:=0;
                           nuevo := agrega_compo( qq ,g_nivel);
                        except
                           on E: exception do begin
                              Error.Add('Fallo al generar el producto, vuelva a intentarlo');
                              continua:=1;
                              exit;
                           end;
                        end;
                     end
                     else
                        nuevo := true;

                     if bexiste then begin
                        Wciclado := '(CICLADO)';
                     end
                     else begin
                        if nuevo then begin
                           Wciclado := '';
                           if ( qq.FieldByName( 'coment' ).AsString <> 'LIBRARY' ) then
                              leecompos( qq.FieldByName( 'hcprog' ).AsString,
                                 qq.FieldByName( 'hcbib' ).AsString,
                                 qq.FieldByName( 'hcclase' ).AsString,
                                 qq.FieldByName( 'sistema' ).AsString,
                                 g_nivel+1 )
                           else begin
                              qq.Next;
                              Continue;
                           end;
                        end;
                     end;
                  end;
                  qq.Next;
            end;
         end;
      finally
         qq.Free;
      end;
   end;
end;

function TalkFormDocAutoDinam.agrega_compo( qq: Tadoquery ; g_nivel:integer): boolean;
var
   cc, mensaje: string;
   k, n: integer;
begin
   inherited;
   try
   cc := v_compo + '|' + v_bib + '|' + v_clase + '|' +
      qq.FieldByName( 'ocprog' ).AsString + '|' +
      qq.FieldByName( 'ocbib' ).AsString + '|' +
      qq.FieldByName( 'occlase' ).AsString + '|' +
      qq.FieldByName( 'pcprog' ).AsString + '|' +
      qq.FieldByName( 'pcbib' ).AsString + '|' +
      qq.FieldByName( 'pcclase' ).AsString + '|' +
      qq.FieldByName( 'hcprog' ).AsString + '|' +
      qq.FieldByName( 'hcbib' ).AsString + '|' +
      qq.FieldByName( 'hcclase' ).AsString;

   if(xx.indexof(cc)>-1) then begin          //si encuentra el dato, manda falso  RGM
      agrega_compo:=false;
      exit;
   end;

   xx.Add( cc );
   k := length( x );
   setlength( x, k + 1 );
   mensaje := 'x=' + inttostr( k ) + '  ' + cc;
   x[ k ].nivel := g_nivel;
   x[ k ].nombre := qq.FieldByName( 'hcprog' ).AsString;// + trim( Wciclado );
   x[ k ].bib := qq.FieldByName( 'hcbib' ).AsString;
   x[ k ].clase := qq.FieldByName( 'hcclase' ).AsString;
   x[ k ].sistema := qq.FieldByName( 'sistema' ).AsString;

   agrega_compo := true;
   except
      continua:=1;
   end;
end;

procedure TalkFormDocAutoDinam.quita_links;
var
   i:integer;
begin
   for i:=borrar_links.Count-1 downto 0 do
      leer_remplazar_todo(borrar_links[i],' ');

   leer_remplazar_todo('|',' ');
end;

function TalkFormDocAutoDinam.cambia_ruta(ruta:String):String;
var
   path,nombre,sDoc:String;
begin
   if tipo = '1' then begin          
      path:= ExtractFilePath(ruta);
      nombre:= 'DT_' + sistema +'.doc';
      sDoc:=path + nombre;
   end
   else begin
      comp_aux:=componente;
      bGlbQuitaCaracteres(comp_aux);
      bGlbQuitaCaracteres(biblioteca);
      path:= ExtractFilePath(ruta);
      nombre:= 'DT_' + sistema +'_'+ clase +'_'+biblioteca+'_'+comp_aux+'.doc';
      sDoc:=path + nombre;
   end;
   Result:=sDoc;

   //Verificar que existe la carpeta donde se guarda
   if forcedirectories(ExtractFilePath(ruta)) = false then begin
      application.MessageBox( pchar( dm.xlng( 'AVISO... no puede crear el directorio ' + ExtractFilePath(ruta) ) ),
         pchar( dm.xlng( 'Docuementacion de Sistema' ) ), MB_OK );
      Exit;
   end;
end;

procedure TalkFormDocAutoDinam.llena_clases;
var
   i:integer;
begin
   if dm.sqlselect( dm.q1, 'select distinct hcclase from tsrela ' +
            ' where hcclase in (select cclase from tsclase where estadoactual=' + g_q + 'ACTIVO' + g_q + ')' +
            ' order by hcclase' ) then begin
            i := 1;
      while not dm.q1.Eof do begin
         SetLength( aPriClases, i );
         aPriClases[ i - 1 ] := dm.q1.fieldbyname( 'hcclase' ).AsString;
         clases.Add(dm.q1.fieldbyname( 'hcclase' ).AsString);
         i := i + 1;
         dm.q1.Next;
      end;
   end;

   filtro_cla.Add('CBL');
   filtro_cla.Add('CPY');
   filtro_cla.Add('DCL');
   filtro_cla.Add('FIL');
   //filtro_cla.Add('LOC');
   filtro_cla.Add('FDV');
   filtro_cla.Add('INS');
   filtro_cla.Add('TAB');
   filtro_cla.Add('DEL');
   filtro_cla.Add('UPD');
   filtro_cla.Add('BSC');
   filtro_cla.Add('NEP');
end;

// ============ para generar hiperligas desde un documento externo =============
procedure TalkFormDocAutoDinam.desde_menu;
var
   sNombreArchivo,nuevoNombre: string;
   Documento: OleVariant;
begin
   sNombreArchivo := sGlbAbrirDialogo;

   if sNombreArchivo = '' then
      Exit;

   if not FileExists( sNombreArchivo ) then begin
      Application.MessageBox( pChar( 'ERROR... no existe el archivo ' + sNombreArchivo ),
         'Crear Hiperligas', MB_OK );
      Exit;
   end;

   // --- ya teniendo el nombre del documento, lo abro para ejecutar proceso ---
   //---------------------- conectando con Word  -------------------------------
   {Word.Connect;
   Word.Visible:=true;  }

   try
      // -- nombre del documento --
      Documento := sNombreArchivo;

      // -------  preparando el documento, copiarlo y abrirlo  ------------
      Word.Documents.Open(Documento, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam,
         EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam);
      //Word.Documents.Open(FileName,ConfirmConversions,ReadOnly,AddToRecentFiles,PasswordDocumento,PasswordTemplate,Revert,WritePasswordDocument,...);
      word_abierto:=1;

      // ---- llamar a la funcion que realiza las sustitucinoes -------
      nueva_ruta:='';
      sust_etiq;
      if nueva_ruta <> '' then begin
         sNombreArchivo:=nueva_ruta;
      end;

      quita_links;

      //---------------- guardar el documento -------------------------
      nuevoNombre:= ExtractFilePath(sNombreArchivo) +
                    copy(extractfilename(sNombreArchivo),0,pos('.',extractfilename(sNombreArchivo))-1) + '_SVS' +
                    ExtractFileExt(sNombreArchivo);
      Documento := nuevoNombre; //cambiar el nombre a version _SVS
      Word.ActiveDocument.SaveAs(
               Documento, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam,
               EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam);
     // ----------------------------------------------------------------
   finally
      Word.Quit;
      Word.Disconnect;

      if Application.MessageBox( PChar('Archivo creado y guardado en la ruta:'+char(13)+
                                 nuevoNombre+char(13)+ '¿Desea abrirlo?'),
                                 PChar('Crear Hiperligas'), MB_YESNO ) = IDYES then begin
        ShellExecute( 0, 'open', pchar( nuevoNombre ), nil, PChar( ExtractFilePath(sNombreArchivo) ), SW_SHOW );

     end;

      if error.Count > 0 then
         error.SaveToFile(ExtractFilePath(sNombreArchivo) + 'lista_errores.txt');
      error.Free;
      borrar_links.Free;
   end;
end;

procedure TalkFormDocAutoDinam.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   // desconectar de Word
   Word.Quit;
   Word.Disconnect;
   word.Free;
end;

procedure TalkFormDocAutoDinam.cierra_docto;
var
   salva:OleVariant;
   n:Olevariant;
begin
   salva:=False;
   {n:=Word.Documents.Count-1;
   docu:=Word.Documents.Item(n);
   docu.Close(salva,emptyparam,emptyparam);}
   Word.DisplayAlerts:=salva;

   if word_abierto = 1 then
      Word.ActiveDocument.Close(salva,emptyparam,emptyparam);
end;

end.


