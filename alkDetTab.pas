unit alkDetTab;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ufmSVSLista, cxGraphics, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, dxPSGlbl, dxPSUtl, dxPSEngn,
  dxPrnPg, dxBkgnd, dxWrap, dxPrnDev, dxPSCompsProvider, dxPSFillPatterns,
  dxPSEdgePatterns, cxGridTableView, ImgList, dxPSCore, dxPScxGridLnk,
  dxBarDBNav, dxmdaset, dxBar, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridDBTableView, cxGrid,
  StdCtrls, dxStatusBar;

type
  TalkFormDetTab = class(TfmSVSLista)
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure grdDatosDBTableView1DblClick(Sender: TObject);
  private
    { Private declarations }
    function separa_datos(datos : String):String;
    procedure datos_bd(var dato : TStringList);
    function ArmarOpciones( b1: Tstringlist ): integer;
  public
    { Public declarations }
    function arma_tabla (datos : TStringList; titulo:String):boolean;
  end;

var
  alkFormDetTab: TalkFormDetTab;

implementation
   uses ptsdm, ptsgral, parbol, uListaRutinas, uConstantes;
{$R *.dfm}

function TalkFormDetTab.arma_tabla (datos : TStringList; titulo:String):boolean;
var
   comp,bib,cla,sis : String;
   cons, cons2, cons3, com, renglon, desc : String;
   {coment, }datos_tab : TStringList;
   //i: integer;
begin
   comp:=datos[0];
   bib:=datos[1];
   //cla:=datos[2];
   cla:='TAB';   // ya que para las clases UPD, INS, DEL, SEL no hay informacion.
   sis:=datos[3];

   cons:='select pcprog, hcprog,hcbib, coment from tsrela'+
         ' where hcclase=' + g_q + 'TFL' + g_q +
         ' and pcprog=' + g_q + comp + g_q +
         ' and pcbib=' + g_q + bib + g_q +
         ' and pcclase=' + g_q + cla + g_q +
         ' and sistema='+ g_q + sis + g_q;

   cons2:='select pcprog, pcclase from tsrela where' +
          ' pcclase=' + g_q + 'TSP' + g_q +
          ' and hcprog=' + g_q + comp + g_q +
          ' and hcbib=' + g_q + bib + g_q +
          ' and hcclase=' + g_q + cla + g_q +
          ' and sistema='+ g_q + sis + g_q;        // para table space

   cons3:='select descripcion from tsprog where' +
          ' cprog=' + g_q + comp + g_q +
          ' and cbib=' + g_q + bib + g_q +
          ' and cclase=' + g_q + cla + g_q +
          ' and sistema=' + g_q + sis + g_q;  // para descripcion

   screen.Cursor := crsqlwait;

   //coment:=TStringList.Create;
   datos_tab:=TStringList.Create;

   try
      caption := titulo;

      if tabDatos.Active then //fercar
         tabDatos.Active := False;
      GlbQuitarFiltrosGrid( grdDatosDBTableView1 );

      if not dm.sqlselect(dm.q1,cons) then begin
         Application.MessageBox( pchar( dm.xlng( 'No existe información a procesar. TFL' ) ),
            pchar( dm.xlng( 'Detalle de Tabla' ) ), MB_OK );
         Result:=false;
         //datos_tab.Free;
         self.Close;
         exit;
      end; 

      {if not dm.sqlselect(dm.q2,cons2) then begin
         Application.MessageBox( pchar( dm.xlng( 'No existe información a procesar. TSP' ) ),
            pchar( dm.xlng( 'Detalle de Tabla' ) ), MB_OK );
         //Result:=false;
         //datos_tab.Free;
         //self.Close;
         //exit;
      end;}

      if dm.sqlselect(dm.q3,cons3) then
         desc:= dm.q3.FieldByName('descripcion').AsString
      else
         desc:='';


      // -- Para que el tablespace aparezca solo una vez en el titulo
      //RGMtabLista.Caption:=dm.q2.FieldByName('pcprog').AsString+' '+comp+' '+bib+' '+cla+' '+sis;
      tabLista.Caption:=comp+' '+bib+' '+cla+' '+sis;

      // ------------ comenzar a procesar los datos para la tabla -----------
      datos_tab.Add(//'Table_Space:String:250,'+
            'Tabla:String:250,'+
            'Campo:String:250,'+
            'Biblioteca:String:250,'+
            'Descripcion:String:350,'+
            'Tipo:String:100,' +
            'Longitud:String:20,'+
            'Null:String:50,' +
            'PrimaryKey:Boolean:0,' +
            'Extra:String:250'); //titulos

      while not dm.q1.EoF do begin
         renglon:= //'"'+dm.q2.FieldByName('pcprog').AsString+'"'+','+    //TableSpace
                   '"'+dm.q1.FieldByName('pcprog').AsString+'"'+','+    //Tabla
                   '"'+dm.q1.FieldByName('hcprog').AsString+'"'+','+    //Campo
                   '"'+dm.q1.FieldByName('hcbib').AsString+'"'+','+     //biblioteca campo
                   '"'+trim(desc)+'"'+',';     //descripcion

         // -- para separar para coment ---
         com:=separa_datos(dm.q1.fieldbyname( 'coment' ).AsString);     //coment separado

         renglon:=renglon+trim(com);
         datos_tab.Add(renglon);

         dm.q1.Next;
      end;

      //datos_tab.SaveToFile(g_tmpdir+'\alkBorrarDatos.txt');  //alk quitar!!!!!

      if bGlbPoblarTablaMem( datos_tab, tabDatos ) then begin
         tabDatos.ReadOnly := True;
         GlbHabilitarOpcionesMenu( mnuPrincipal, tabDatos.RecordCount > 0 );
         GlbCrearCamposGrid( grdDatosDBTableView1 );
         GlbCrearRecID( grdDatosDBTableView1, True, 'Campo_id' );
         grdDatosDBTableView1.ApplyBestFit( );
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
      //coment.Free;
      datos_tab.Free;
      screen.Cursor := crdefault;
   end;
   Result:=true;
end;

function TalkFormDetTab.separa_datos(datos : String):String;
var
   por_separar: TStringList;
   tipo_dato : TStringList;
   columnas, aux, long, dat : String;
   i, j, null, bandera, indice, pk, par_op, par_cl : integer;
begin
   columnas:='';
   tipo_dato:=TStringList.Create;
   por_separar:=TStringList.Create;
   aux:='';
   long:='';
   null := 0;
   pk := 0;

   dat:=StringReplace(trim(datos),' ','|',[rfReplaceAll, rfIgnoreCase]);
   por_separar.Delimiter:='|';
   por_separar.DelimitedText:=trim(dat); // aqui se tiene todo el contenido, al final solo van a quedar los detalles
   //ShowMessage(por_separar.Text);

   try
      datos_bd(tipo_dato);  //cargar los tipos de datos en el arreglo

      // -- primero localizar el tipo de dato --
      bandera:=0;
      for j:=0 to por_separar.Count-1 do begin // recorrer los datos para saber cual quitar (tipo de dato)
         for i:=0 to tipo_dato.Count-1 do begin  // recorrer la lista para localizar el tipo de dato
            if compareStr(tipo_dato[i],por_separar[j]) = 0 then begin  //si se encuentra el tipo de dato en algun campo del arreglo de datos //devuelve 0 si son iguales
               columnas:='"' + trim(por_separar[j])+'"'+',';  // añadir el tipo de dato en posicion 0
               por_separar.Delete(j);  //borra el tipo de dato de los datos
               bandera:=1;
               break;
            end;
         end;
         if bandera <> 0 then
            break;
      end;

      // ---- si hay un dato que no se tiene en la lista, avisa ---
      if (bandera = 0) and (por_separar.Count = 1) then begin
         {Application.MessageBox( pchar( dm.xlng( 'Tipo de dato desconocido:' + chr( 13 ) +
                                datos) ), pchar( dm.xlng( 'Detalle de Tabla' ) ), MB_OK );}
         columnas:='"' + trim(por_separar[0])+'"'+',';  // añadir el tipo de dato en posicion 0
         por_separar.Delete(0);
         //Result:=columnas;
         //exit;
      end;

      // -- localizar la longitud del dato si la tiene --
      if por_separar.IndexOf('(') <> -1 then begin
         indice:= por_separar.IndexOf('(');
         columnas:=trim(columnas) + '"';
         for i:=indice to por_separar.IndexOf(')') do
            columnas:=trim(columnas) + trim(por_separar[i]);  // añadir longitud aunque sea mas de 1 caracter en posicion 1

         columnas:=trim(columnas) +'"'+',';

         while indice <> por_separar.IndexOf(')') do
            por_separar.Delete(indice);    // quitar la longitud de los datos
         if por_separar.IndexOf(')') <> -1 then
            por_separar.Delete(por_separar.IndexOf(')'));
      end
      else begin    // si no se encuentra '(' por separado, buscar dentro de los datos
         long:='';
         par_op:=-1;
         par_cl:=-1;

         for i:=0 to por_separar.Count -1 do begin       // obtener los indices
            if AnsiPos( '(', por_separar[i] ) <> 0 then
               par_op := i;
            if AnsiPos( ')', por_separar[i] ) <> 0 then
               par_cl:= i;
         end;
         if (par_cl <> -1) and (par_op <> -1) then
            for i:=par_cl downto par_op do begin    // copiar todo lo que este dentro de los parentesis
               long:= por_separar[i] + long;
               por_separar.Delete(i);
            end;
            
         columnas:=trim(columnas) + '"'+trim(long)+'"'+',';  // si no tiene longitud añadir nada en la columna
      end;

      // -- si es nulo o no --
      if por_separar.IndexOf('NULL') <> -1 then begin // si encuentra nulo, buscar el not
         null:=null+1;
         if por_separar.IndexOf('NOT') <> -1 then  // si encuentra not
            null:=null+1;
         // ---- si es null = 1
         // ---- si es not null = 2
         // ---- si no lo indica = 0
         case null of
            0: columnas:=columnas + '"' +'DEFAULT'+'"'+',';  // si no null nada en posicion 2
            1: begin
               columnas:=columnas + '"' +'NULL'+'"'+',';  // si es null en posicion 2
               por_separar.Delete(por_separar.IndexOf('NULL'));
            end;
            2: begin
               columnas:=columnas + '"' +'NOT NULL'+'"'+',';  // si es not null en posicion 2
               por_separar.Delete(por_separar.IndexOf('NULL'));
               por_separar.Delete(por_separar.IndexOf('NOT'));
            end;
         end;
      end
      else
         columnas:=columnas + '"' +'DEFAULT'+'"'+',';

      //-- si trae primary key --
      if por_separar.IndexOf('PRIMARY') <> -1 then begin // si encuentra primary, buscar el key
         pk:=pk+1;
         if por_separar.IndexOf('KEY') <> -1 then  // si encuentra not
            pk:=pk+1;
         // ---- no es primary key = 1
         // ---- si es primary key = 2
         // ---- si no lo indica = 0
         case pk of
            0: columnas:=columnas + '"' +'false'+'"'+',';  // si no pk nada en posicion 2
            1: begin
               columnas:=columnas + '"' +'false'+'"'+',';  // si no pk en posicion 2
               por_separar.Delete(por_separar.IndexOf('NULL'));
            end;
            2: begin
               columnas:=columnas + '"' +'true'+'"'+',';  // si es primary key
               por_separar.Delete(por_separar.IndexOf('PRIMARY'));
               por_separar.Delete(por_separar.IndexOf('KEY'));
            end;
         end;
      end
      else
         columnas:=columnas + '"' +'false'+'"'+',';  // si no lo especifica

      // -- demas información --
      if trim(por_separar.CommaText) <> '' then
         columnas:=columnas + '"' + trim(por_separar.Text) +'"'
      else
         columnas:=columnas + '"' + '---' + '"';

      // ------- devolver los datos separados --------
      Result:=columnas;
   finally
      tipo_dato.Free;
      por_separar.Free;
   end;
end;

procedure TalkFormDetTab.datos_bd(var dato : TStringList);  //tipos de datos BD
begin
   dato.Add('BFILE');
   dato.Add('BLOB');
   dato.Add('CHAR');
   dato.Add('CLOB');
   dato.Add('DATE');
   dato.Add('DATETIME');
   dato.Add('DECIMAL');
   dato.Add('DOUBLE');
   dato.Add('FLOAT');
   dato.Add('INT');
   dato.Add('INTEGER');
   dato.Add('LONG');
   dato.Add('NCHAR');
   dato.Add('NLOB');
   dato.Add('NUMBER');
   dato.Add('NVARCHAR2');
   dato.Add('RAW');
   dato.Add('SHORT');
   dato.Add('SMALLINT');
   dato.Add('TIME');
   dato.Add('VARCHAR');
   dato.Add('VARCHAR2');
   //dato.Add('');
end;

procedure TalkFormDetTab.FormCreate(Sender: TObject);
begin
  inherited;
   caption:= sDETALLE_TABLA;
end;

procedure TalkFormDetTab.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
   screen.Cursor := crsqlwait;
   try
      if FormStyle = fsMDIChild then
         dm.PubEliminarVentanaActiva( Caption );
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;


function TalkFormDetTab.ArmarOpciones( b1: Tstringlist ): integer;
var
   mm: Tstringlist;
begin
   inherited;
   mm := Tstringlist.Create;
   mm.CommaText := bgral;
   if mm.count < 3 then begin
      Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
         pchar( dm.xlng( 'Lista opciones ' ) ), MB_OK );
      mm.free;
      exit;
   end;
   gral.EjecutaOpcionB( b1, 'Lista Componentes' );
   mm.free;
end;


procedure TalkFormDetTab.grdDatosDBTableView1DblClick(Sender: TObject);
var
   sComponente: string;
   y: integer;
   separado : Tstringlist;
   Opciones: Tstringlist;
begin
   inherited;
   Opciones:=TStringList.Create;
   separado:=TStringList.Create;
   separado.CommaText:=tabLista.Caption;  //comp+' '+bib+' '+cla+' '+sis;
   screen.Cursor := crsqlwait;
   try
      {sComponente := Trim( grdDatosDBTableView1.Columns[ 2 ].EditValue ) + '|' +
         Trim( grdDatosDBTableView1.Columns[ 3 ].EditValue ) + '|' +
         Trim( grdDatosDBTableView1.Columns[ 4 ].EditValue ) + '|' +
         Trim( grdDatosDBTableView1.Columns[ 5 ].EditValue );  }

      sComponente:= Trim( grdDatosDBTableView1.Columns[ 3 ].EditValue )+ '|' +     //componente
                    Trim( grdDatosDBTableView1.Columns[ 4 ].EditValue ) +'|' +     //biblioteca
                    'TFL'+ '|' +                                                   //clase
                    separado[3];                                                   //sistema

      if sComponente = '' then
         exit;

      bgral := stringreplace( trim( sComponente ), '|', ' ', [ rfReplaceAll ] );
      Opciones := gral.ArmarMenuConceptualWeb( sComponente, 'lista_componentes' );
      y := ArmarOpciones( Opciones );
      gral.PopGral.Popup( g_X, g_Y );
      sComponente := '';
   finally
      separado.Free;
      Opciones.Free;
      screen.Cursor := crdefault;
   end;
end;

end.

