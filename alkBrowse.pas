unit alkBrowse;

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
  TalkFormBrowse = class(TfmSVSLista)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    nombres,campos: TStringList;

    procedure obtiene_nombres(sele:String);
  public
    { Public declarations }
    function arma_tabla (cons:String; titulo:String):boolean;
  end;

var
  alkFormBrowse: TalkFormBrowse;
  procedure PR_ALK_BROWSE;

implementation
  uses ptsdm, ptsgral, uListaRutinas, uConstantes;
{$R *.dfm}

procedure PR_ALK_BROWSE;
begin
   Application.CreateForm( TalkFormBrowse, alkFormBrowse );
end;

function TalkFormBrowse.arma_tabla (cons:String; titulo:String):boolean;
var
   cons2, renglon, titulos, cam, cam2 : String;
   datos_tab : TStringList;
   i,w,c : integer;
begin
   screen.Cursor := crsqlwait;

   datos_tab:=TStringList.Create;

   try
      caption := titulo;

      if tabDatos.Active then
         tabDatos.Active := False;
      GlbQuitarFiltrosGrid( grdDatosDBTableView1 );

      //obtiene_nombres(cons);

      // ---- quitarle el where a la consulta -----
      w:=pos(' WHERE ',uppercase(cons));
      cons2:=copy(cons,1,w);

      if not dm.sqlselect(dm.q1,cons2) then begin
         Application.MessageBox( pchar( dm.xlng( 'No se pudo realizar la consulta' ) ),
                                 pchar( dm.xlng( 'Browse' ) ), MB_OK );
         Result:=false;
         self.Close;
         exit;
      end;

      // ------------ comenzar a procesar los datos para la tabla -----------
      c:=0;

      while not dm.q1.EoF do begin  //toalidad de renglones  (y)
         //campos[]
         renglon:='';
         titulos:='';
         for i:=0 to dm.q1.Fields.Count-1 do begin   // totalidad de columnas (x)    armar el renglon
            if c = 0 then begin          // para obtener los nombres
               cam:= copy(dm.q1.Fields[i].FieldName,5,100);
               cam2:= stringreplace(cam,'_AST','',[rfreplaceall]);
               cam:=stringreplace(cam2,'_',' ',[rfreplaceall]);
               if i = dm.q1.Fields.Count-1 then
                  titulos := titulos + stringreplace(cam,' ','',[rfreplaceall])+ ':String:250'
               else
                  titulos := titulos + stringreplace(cam,' ','',[rfreplaceall])+ ':String:250,';
            end;

            cam:= dm.q1.FieldByName(dm.q1.Fields[i].FieldName).AsString;

            if i = dm.q1.Fields.Count-1 then
               renglon:= renglon + '"'+cam+'"'
            else
               renglon:= renglon + '"'+cam+'",';
         end;
         if titulos <> '' then
            datos_tab.Add(titulos); //titulos
         c:=7;
         datos_tab.Add(renglon);

         dm.q1.Next;
      end;

      //datos_tab.SaveToFile(g_tmpdir+'\alkBorrarDatos.txt');  //alk quitar!!!!!

      if bGlbPoblarTablaMem( datos_tab, tabDatos ) then begin
         tabDatos.ReadOnly := True;
         GlbHabilitarOpcionesMenu( mnuPrincipal, tabDatos.RecordCount > 0 );
         GlbCrearCamposGrid( grdDatosDBTableView1 );
         GlbCrearRecID( grdDatosDBTableView1, True, 'Id' );
         grdDatosDBTableView1.ApplyBestFit( );
         //necesario para la busqueda
         //en este caso usar grEspejo para apoyarse en las busquedas y llenar slPublista
         GlbCrearCamposGrid( grdEspejoDBTableView1 );
         GlbCargarLista( grdEspejo, grdEspejoDBTableView1, slPubLista );
         //fin necesario para la busqueda
         stbLista.Panels[ 0 ].Text := IntToStr( tabDatos.RecordCount ) + ' Registros';

         if Visible = True then
            GlbFocusPrimerItemGrid( grdDatos, grdDatosDBTableView1 );
      end;
   finally
      datos_tab.Free;
      screen.Cursor := crdefault;
   end;
   Result:=true;
end;


procedure TalkFormBrowse.obtiene_nombres(sele:String);
var
   separa : TstringList;
   sel2,cam,cam2:String;
   i , ifrom: integer;
begin
   separa := TstringList.Create;

   ifrom:=pos(' FROM ',uppercase(sele));  // encontrar la posicion del from
   sel2:=copy(trim(sele),7,ifrom-6);  // para aislar los nombres y los campos de la consulta

   //separa.Delimiter:=',';
   separa.DelimitedText:=sel2;
   i:=0;

   while i < separa.Count-1 do begin
      campos.Add(separa[i]);

      //limpiar el titulo de la tabla antes de guardarlo
      cam:= copy(separa[i+1],5,100);
      cam2:= stringreplace(lowercase(cam),'_ast','',[rfreplaceall]);
      cam:=stringreplace(cam2,'_',' ',[rfreplaceall]);
      cam2:=stringreplace(cam2,g_q,'',[rfreplaceall]);
      nombres.Add(cam2);
      i:= i+2;
   end;

   separa.Free;
end;

procedure TalkFormBrowse.FormDestroy(Sender: TObject);
begin
   inherited;
   nombres.Free;
   campos.Free;
end;

procedure TalkFormBrowse.FormCreate(Sender: TObject);
begin
  inherited;
   nombres := TStringList.Create;
   campos := TStringList.Create;
end;

end.
