unit ptsinventario;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ComCtrls,ADODB, DB, DBGrids, StdCtrls, Buttons, ExtCtrls,
  Menus,printers, ImgList, OleCtrls, SHDocVw, jpeg, pbarra, OleServer,
  ExcelXP, ComObj, shellapi ;

type Ttot=record
   sistema:string;
   columna:integer;
   total:array of integer;
end;
type Tgroup=record
   sistema:string;
   clase:string;
   total:integer;
end;
type
  Tftsinventario = class(TForm)
    tab: TTabControl;
    dg: TDrawGrid;
    Splitter1: TSplitter;
    Panel1: TPanel;
    bimprimir: TBitBtn;
    DBGrid1: TDBGrid;
    query: TADOQuery;
    DataSource1: TDataSource;
    pop: TPopupMenu;
    AnalisisdeImpacto1: TMenuItem;
    ytitulo: TPanel;
    PrintDialog1: TPrintDialog;
    ImageList1: TImageList;
    //bimprime: TBitBtn;
    Web: TWebBrowser;
    Splitter3: TSplitter;
    ImpWeb: TBitBtn;
    ExcelApplication1: TExcelApplication;
    BExcel: TBitBtn;
    VistadelComponente1: TMenuItem;
    ver_componente: TMemo;
    Panel2: TPanel;
    bsalir: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure dgDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure tabChange(Sender: TObject);
    procedure dgClick(Sender: TObject);
    procedure dgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AnalisisdeImpacto1Click(Sender: TObject);
    procedure bClick(Sender: TObject);
    procedure bimprimirClick(Sender: TObject);
 //   procedure bimprimeClick(Sender: TObject);
//    procedure Button1Click(Sender: TObject);
    procedure WebBeforeNavigate2(Sender: TObject; const pDisp: IDispatch;
      var URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
      var Cancel: WordBool);
    procedure ImpWebClick(Sender: TObject);
    procedure BExcelClick(Sender: TObject);
    procedure VistadelComponente1Click(Sender: TObject);
    procedure WebDocumentComplete(Sender: TObject; const pDisp: IDispatch;
      var URL: OleVariant);
    procedure ArmarOpciones(b1:Tstringlist);
    procedure analisisdeimpacto(Sender: TObject);
    procedure diagramaproceso(Sender: TObject);
    procedure formadelphipreview(Sender: TObject);
    procedure panelpreview(Sender: TObject);
    procedure naturalmapapreview(Sender: TObject);
    procedure diagramanatural(Sender: TObject);
    procedure referenciascruzadas(Sender: TObject);
    procedure reglasnegocio(Sender: TObject);
    procedure versionado(Sender: TObject);
    procedure fmbvistapantalla(Sender: TObject);
    procedure bmspreview(Sender: TObject);
    procedure diagramacbl(Sender: TObject);
    procedure dghtml(Sender: TObject);
    procedure diagramarpg(Sender: TObject);
    procedure tablacrud(Sender: TObject);
    procedure adabascrud(Sender: TObject);
    procedure diagramajcl(Sender: TObject);
    procedure diagramaase(Sender: TObject);
    procedure listacomponentes(Sender: TObject);
    procedure propiedades(Sender: TObject);
    procedure atributos(Sender: TObject);
    procedure VerFuente(Sender: TObject);
//    procedure SalirDelMenu(Sender: TObject);
   private
    { Private declarations }
    tt:array of Ttot;
    cla:Tstringlist;
    titulo:Tstringlist;
    shiftclases:integer;
    bitmap:Tbitmap;
    lin:integer;
    iy:integer;
    tidentificados,texistentes,tfaltantes,tsinuso,tactivos:string;
    SisComp,AntSisComp:string;
    pagina:integer;
    //con_registros:Tstringlist;
    vaux3:integer;
    Xtitulo,Xtexto:string;
    tt_existentes,tt_identificados,tt_faltantes,tt_sin_uso,tt_activos:string;
    tg:array of Tgroup;
    b_impresion:boolean;
    Opciones:Tstringlist;
    bgral,NombreProceso:string;
    WnomLogo:string;
    procedure subsistemas(oficina:string; sistema:string; columna:integer);
    procedure pinta(Rect: TRect; columna:integer; texto:string);
    procedure totaliza;
    procedure consulta(sistema:string; tipo:string);
    function  tsrela_cla(sistema:string; tipo:string):string;
    procedure query_cuenta(query:string);
    procedure titulos(tipo:integer);
    procedure totales;
    procedure creaweb;
    procedure Crea_Web;
    procedure WebPreviewPrint(web: TWebBrowser);
  public
    { Public declarations }
  end;

var
  ftsinventario: Tftsinventario;
  procedure PR_INVENTARIO;

implementation
uses ptsdm,ptsimpacto, ptsmain, ptsgral, ptsmining;
{$R *.dfm}
procedure PR_INVENTARIO;
begin
   g_Wforma:='mining';
//  Application.CreateForm( Tftsinventario, ftsinventario );
//   try
//      ftsinventario.ShowModal;     ////
//   finally
//      ftsinventario.Free;
//   end;
   ftsinventario.Show;
end;
function Tftsinventario.tsrela_cla(sistema:string; tipo:string):string;
begin
   tsrela_cla:=' select distinct hcclase clase,hcbib libreria,hcprog componente from tsrela '+
               ' where pcprog='+g_q+tipo+g_q+
               '   and pcbib='+g_q+sistema+g_q+
               '   and pcclase='+g_q+'CLA'+g_q;
end;
procedure Tftsinventario.query_cuenta(query:string);
var i,j,k:integer;
begin
   setlength(tg,0);
   if dm.sqlselect(dm.q1,query) then begin
      while not dm.q1.Eof do begin
         k:=length(tg);
         setlength(tg,k+1);
         tg[k].sistema:=dm.q1.fieldbyname('sistema').AsString;
         tg[k].clase:=dm.q1.Fields[1].AsString;
         tg[k].total:=dm.q1.fieldbyname('total').AsInteger;
         dm.q1.Next;
      end;
   end;
   for i:=0 to length(tt)-2 do begin
      if tt[i].columna>1 then begin
         for j:=0 to cla.Count-1 do begin
            tt[i].total[j]:=0;
            for k:=0 to length(tg)-1 do begin
               if (tg[k].clase=cla[j]) and (tg[k].sistema=tt[i].sistema) then begin
                  tt[i].total[j]:=tg[k].total;
                  break;
               end;
            end;
         end;
      end;
   end;
end;
procedure Tftsinventario.totaliza;
var i,j,k:integer;
begin
   i:=0;
   screen.cursor:=crsqlwait;
   AntSisComp:='';
   if tab.Tabs[tab.TabIndex]=tidentificados then
      query_cuenta(tt_identificados)
   else
   if tab.Tabs[tab.TabIndex]=texistentes then
      query_cuenta(tt_existentes)
   else
   if tab.Tabs[tab.TabIndex]=tfaltantes then
      query_cuenta(tt_faltantes)
   else
   if tab.Tabs[tab.TabIndex]=tsinuso then
      query_cuenta(tt_sin_uso)
   else
   if tab.Tabs[tab.TabIndex]=tactivos then
      query_cuenta(tt_activos)
   else
      Application.MessageBox(pchar(dm.xlng('Opción inconsistente en el titulo de los TAB')),
                             pchar(dm.xlng('Inventario de componentes')), MB_OK );
   k:=length(tt)-1;
   for j:=0 to high(tt[i].total) do
      tt[k].total[j]:=0;
   for j:=0 to high(tt[k].total) do
      for i:=1 to length(tt)-2 do
         tt[k].total[j]:=tt[k].total[j]+tt[i].total[j];

   dg.Refresh;
   Crea_Web;
   screen.cursor:=crdefault;
end;

procedure Tftsinventario.consulta(sistema:string; tipo:string);
var descripcion,nquery,nselect,nselect1,nwhere,b1,nanexo,nanexo1,nanexo2,nanexo3:string;
    x1,x2,c1:integer;
    b2:Tstringlist;
begin
   if dm.sqlselect(dm.q1,'select * from tsclase where cclase='+g_q+tipo+g_q) then begin
     descripcion:=dm.q1.fieldbyname('descripcion').AsString;
   end;
   ytitulo.Caption:=tab.Tabs[tab.TabIndex]+' - '+sistema+' - '+tipo+' - '+descripcion;
   Xtitulo:=sistema+' - '+tipo+' - '+descripcion;
   query.Close;
   query.SQL.Clear;
   if (tab.Tabs[tab.TabIndex]=texistentes) then
      nquery:=tt_existentes
   else
   if tab.Tabs[tab.TabIndex]=tidentificados then
      nquery:=tt_identificados
   else
   if tab.Tabs[tab.TabIndex]=tfaltantes then
      nquery:=tt_faltantes
   else
   if tab.Tabs[tab.TabIndex]=tsinuso then
      nquery:=tt_sin_uso
   else
   if tab.Tabs[tab.TabIndex]=tactivos then
      nquery:=tt_activos
   else
      showmessage(dm.xlng('Opcion inconsistente en el titulo de los TAB'));

   if (tab.Tabs[tab.TabIndex]=texistentes) or
      (tab.Tabs[tab.TabIndex]=tsinuso) or
      (tab.Tabs[tab.TabIndex]=tactivos) then begin
      nselect:='select cclase clase,cbib libreria,cprog componente ';
      nwhere:=' where cclase='+g_q+tipo+g_q;
   end
   else begin
      nselect:='select hcclase clase,hcbib libreria,hcprog componente ';
      nwhere:=' where hcclase='+g_q+tipo+g_q;
   end;
   nanexo2:=' and sistema=';
   nanexo:=' ';
   nanexo1:=' ';
   if (tab.Tabs[tab.TabIndex]=texistentes) or
      (tab.Tabs[tab.TabIndex]=tsinuso) or
      (tab.Tabs[tab.TabIndex]=tactivos) then begin
//      if dm.sqlselect(dm.q1,'select * from tsproperty where cclase ='+g_q+tipo+g_q) then begin
         nselect:='select x.cclase clase,x.cbib libreria,x.cprog componente,'+
                  't.lineas_blanco,t.lineas_total,t.lineas_comentario,t.lineas_efectivas ';
         nselect1:='select x.cclase clase,x.cbib libreria,x.cprog componente,'+
                  '0 lineas_blanco,0 lineas_total,0 lineas_comentario,0 lineas_efectivas ';
         nanexo:=' and t.cprog=x.cprog and t.cbib=x.cbib and t.cclase=x.cclase ';
         nanexo1:=' x , tsproperty t ';
         nanexo2:=' and x.sistema=';
         nwhere:=' where x.cclase='+g_q+tipo+g_q;
         nanexo3:=' and x.cprog not in (select t.cprog from tsproperty t where t.cprog=x.cprog and t.cbib=x.cbib and t.cclase=x.cclase)';
 //      end;
   end else begin
//      if dm.sqlselect(dm.q1,'select * from tsproperty where cclase='+g_q+tipo+g_q) then begin
//        if tab.Tabs[tab.TabIndex]<>'FALTANTES' then  begin
            nselect:='select x.hcclase clase,x.hcbib libreria,x.hcprog componente,'+
               't.lineas_blanco,t.lineas_total,t.lineas_comentario,t.lineas_efectivas';
            nselect1:='select x.hcclase clase,x.hcbib libreria,x.hcprog componente,'+
               ' 0 lineas_blanco,0 lineas_total,0 lineas_comentario,0 lineas_efectivas';
            nanexo:=' and x.hcprog=t.cprog and x.hcbib=t.cbib and x.hcclase=t.cclase ';
            nanexo1:=' x , tsproperty t ';
            nanexo2:=' and x.sistema=';
            nwhere:=' where x.hcclase='+g_q+tipo+g_q;
            nanexo3:=' and x.hcprog not in (select t.cprog from tsproperty t where t.cprog=x.hcprog and t.cbib=x.hcbib and t.cclase=x.hcclase)';
//         end;
//      end;
   end;

   x1:=pos(' from ',nquery);
   x2:=pos(' group by ',nquery);
   nquery:=nselect+copy(nquery,x1,x2-x1)+nanexo1+nwhere+
   nanexo2+g_q+sistema+g_q+nanexo+' UNION ALL '+nselect1+copy(nquery,x1,x2-x1)+' x '+nwhere+nanexo2+g_q+sistema+g_q+nanexo3+' order by 3,2 ';
   query.SQL.Add(nquery);

   PR_BARRA;
   query.Open;

   for c1:=1 to dbgrid1.FieldCount-1 do begin
      if c1 = 2 then
         dbgrid1.Columns[c1].Width:=400
      else
         dbgrid1.Columns[c1].Width:=150;
   end;

   b1:='nombre'+' biblioteca '+tipo;
   pop.Items.Clear;
   opciones:=gral.ArmarMenuConceptualWeb(b1,'Inventario_de_Componentes');
   ArmarOpciones(opciones);
   bimprimir.Visible:=true;
   BExcel.Visible:=true;
end;
{
procedure Tftsinventario.consulta(sistema:string; tipo:string);
var descripcion,nquery,nselect,nwhere,b1:string;
    x1,x2:integer;
    b2:Tstringlist;
begin
   if dm.sqlselect(dm.q1,'select * from tsclase where cclase='+g_q+tipo+g_q) then begin
     descripcion:=dm.q1.fieldbyname('descripcion').AsString;
   end;
   ytitulo.Caption:=tab.Tabs[tab.TabIndex]+' - '+sistema+' - '+tipo+' - '+descripcion;
   Xtitulo:=sistema+' - '+tipo+' - '+descripcion;
   query.Close;
   query.SQL.Clear;
   if (tab.Tabs[tab.TabIndex]=texistentes) then
      nquery:=tt_existentes
   else
   if tab.Tabs[tab.TabIndex]=tidentificados then
      nquery:=tt_identificados
   else
   if tab.Tabs[tab.TabIndex]=tfaltantes then
      nquery:=tt_faltantes
   else
   if tab.Tabs[tab.TabIndex]=tsinuso then
      nquery:=tt_sin_uso
   else
   if tab.Tabs[tab.TabIndex]=tactivos then
      nquery:=tt_activos
   else
      Application.MessageBox(pchar(dm.xlng('Opción inconsistente en el titulo de los TAB')),
                             pchar(dm.xlng('Consulta')), MB_OK );
   if (tab.Tabs[tab.TabIndex]=texistentes) or
      (tab.Tabs[tab.TabIndex]=tsinuso) or
      (tab.Tabs[tab.TabIndex]=tactivos) then begin
      nselect:='select cclase clase,cbib libreria,cprog componente ';
      nwhere:=' where cclase='+g_q+tipo+g_q;
   end
   else begin
      nselect:='select hcclase clase,hcbib libreria,hcprog componente ';
      nwhere:=' where hcclase='+g_q+tipo+g_q;
   end;

   x1:=pos(' from ',nquery);
   x2:=pos(' group by ',nquery);
   nquery:=nselect+copy(nquery,x1,x2-x1)+nwhere+
      ' and sistema='+g_q+sistema+g_q+' order by 3,2';
   query.SQL.Add(nquery);
   PR_BARRA;
   query.Open;
   dbgrid1.Columns[1].Width:=100;
   dbgrid1.Columns[2].Width:=500;
   b1:='nombre'+' biblioteca '+tipo;
   pop.Items.Clear;
   opciones:=gral.ArmarMenuConceptualWeb(b1,'Inventario_de_Componentes');
   ArmarOpciones(opciones);
   bimprimir.Visible:=true;
   BExcel.Visible:=true;
end;
}
procedure Tftsinventario.subsistemas(oficina:string; sistema:string; columna:integer);
var qq:TADOQuery;
   k:integer;
begin
   qq:=TADOQuery.Create(self);
   qq.Connection:=dm.ADOConnection1;
   if dm.sqlselect(qq,'select * from tssistema '+      // Subsistemas
      ' where coficina='+g_q+oficina+g_q+
      ' and cdepende='+g_q+sistema+g_q+
      ' and estadoactual='+g_q+'ACTIVO'+g_q+
      ' order by csistema') then begin
      while not qq.Eof do begin
         //if con_registros.IndexOf(qq.fieldbyname('csistema').AsString)>-1 then begin
            k:=length(tt);
            setlength(tt,k+1);
            tt[k].sistema:=qq.fieldbyname('csistema').AsString;
            tt[k].columna:=columna;
            if dg.ColCount<columna+1 then begin
               dg.ColCount:=columna+1;
               titulo.Add(' ');
               vaux3:=vaux3+1;
            end;
            setlength(tt[k].total,length(tt[0].total));
         {
         end
         else begin
            k:=length(tt);
            setlength(tt,k+1);
            tt[k].sistema:=qq.fieldbyname('csistema').AsString;
            tt[k].columna:=columna;
            setlength(tt[k].total,length(tt[0].total));
         end;
         }
         subsistemas(qq.fieldbyname('coficina').AsString,
                     qq.fieldbyname('csistema').AsString,columna+1);
         qq.Next;
      end;
   end;
   qq.free;
end;
procedure Tftsinventario.FormCreate(Sender: TObject);
var k:integer;
begin

   if g_language='ENGLISH' then begin
      caption:='Inventory';
      tidentificados:='IDENTIFIED';
      texistentes:='EXIST';
      tfaltantes:='MISSING';
      tsinuso:='UNUSED';
      tactivos:='ACTIVE';
      analisisdeimpacto1.Caption:='Impact Analysis';
      bimprimir.Caption:='Print';
      bsalir.Hint:='Exit';
   end
   else begin
      tidentificados:='IDENTIFICADOS';
      texistentes:='EXISTENTES';
      tfaltantes:='FALTANTES';
      tsinuso:='SIN USO';
      tactivos:='ACTIVOS';
  end;

   tab.Tabs[0]:=texistentes;
   tab.tabs[1]:=tfaltantes;
   tab.Tabs[2]:=tsinuso;
   tab.Tabs[3]:=tactivos;
   tab.Tabs[4]:=tidentificados;
   cla:=Tstringlist.Create;
   titulo:=Tstringlist.Create;
   bitmap:=Tbitmap.Create;
   dg.ColCount:=3;
   setlength(tt,1);
   tt[0].sistema:=g_empresa;
   tt[0].columna:=0;
   titulo.Add('Empresa');
   titulo.Add('Oficina');
   titulo.Add('Sistemas');
   vaux3:= 0;
//   ftsinventario.left:=g_left;
//   ftsinventario.top:=g_top;
//   ftsinventario.Width:= g_Width;
//   ftsinventario.Height:= g_Height;
   gral.CargaRutinasjs();
   WnomLogo:='IN'+formatdatetime('YYYYMMDDHHNNSSZZZZ ',now);
   gral.CargaLogo(WnomLogo);
   //aqui se tarda 8 segundos corregir leyendo sistemas activos
   {
   con_registros:=Tstringlist.Create;
   if dm.sqlselect(dm.q1,'select distinct sistema from tsrela order by sistema') then begin
      while not dm.q1.Eof do begin
         con_registros.Add(dm.q1.fieldbyname('sistema').AsString);
         dm.q1.Next;
      end;
   end;
   }
   // identifica clases
   if dm.sqlselect(dm.q1,'select distinct hcclase from tsrela '+
//      ' where hcclase in (select cclase from tsclase where tipo='+g_q+'ANALIZABLE'+g_q+')'+
      ' where hcclase in (select cclase from tsclase where objeto='+g_q+'FISICO'+g_q+
      ' and estadoactual='+g_q+'ACTIVO'+g_q+')'+
      ' order by hcclase') then begin
      setlength(tt[0].total,dm.q1.RecordCount);
      while not dm.q1.Eof do begin
         cla.Add(dm.q1.fieldbyname('hcclase').AsString);
         dm.q1.Next;
      end;
   end;
   if dm.sqlselect(dm.q1,'select * from tsoficina order by coficina') then begin // Oficinas
      while not dm.q1.Eof do begin
         k:=length(tt);
         setlength(tt,k+1);
         tt[k].sistema:=dm.q1.fieldbyname('coficina').AsString;
         tt[k].columna:=1;
         setlength(tt[k].total,length(tt[0].total));
         if dm.sqlselect(dm.q2,'select * from tssistema '+           // Sistemas
            ' where coficina='+g_q+dm.q1.fieldbyname('coficina').AsString+g_q+
            ' and cdepende'+g_is_null+
            ' and estadoactual='+g_q+'ACTIVO'+g_q+
            ' order by csistema') then begin
            while not dm.q2.Eof do begin
               k:=length(tt);
               setlength(tt,k+1);
               tt[k].sistema:=dm.q2.fieldbyname('csistema').AsString;
               tt[k].columna:=2;
               setlength(tt[k].total,length(tt[0].total));
               subsistemas(dm.q1.fieldbyname('coficina').AsString,
                           dm.q2.fieldbyname('csistema').AsString,3);
               dm.q2.Next;
            end;
         end;
         dm.q1.Next;
      end;
   end;
   dg.RowCount:=length(tt)+2;
   shiftclases:=dg.ColCount;
   dg.ColCount:=dg.ColCount+cla.Count;
   dg.FixedCols:=shiftclases;
   titulo.AddStrings(cla);
   k:=length(tt);
   setlength(tt,k+1);
   tt[k].sistema:='-- Totales';
   tt[k].columna:=2;
   setlength(tt[k].total,length(tt[0].total));
   tt_existentes:='select sistema,cclase,count(*) total from tsprog '+
      ' group by sistema,cclase order by 1,2';
   tt_identificados:='select sistema,hcclase,count(*) total from '+
      ' (select distinct sistema,hcclase,hcbib,hcprog from tsrela) '+
      '    group by sistema,hcclase order by 1,2';

   tt_faltantes:='select sistema,hcclase,count(*) total from tsrela '+
      ' where (hcprog,hcbib,hcclase) not in (select cprog,cbib,cclase from tsprog)'+
      ' group by sistema,hcclase '+
      ' order by 1,2';

{  tt_faltantes:='select sistema,hcclase,count(*) total from '+
      ' (select distinct sistema,hcclase,hcbib,hcprog from tsrela '+
      '  minus '+
      '  select sistema,cclase,cbib,cprog from tsprog) group by sistema,hcclase order by 1,2';
}
   tt_sin_uso:='select sistema,cclase,count(*) total from '+
      ' (select sistema,cclase,cbib,cprog from tsprog '+
      '  minus '+
      '  select distinct sistema,hcclase,hcbib,hcprog from tsrela '+
      '    where pcclase<>'+g_q+'CLA'+g_q+') group by sistema,cclase order by 1,2';
   tt_activos:='select sistema,cclase,count(*) total from '+
      ' (select sistema,cclase,cbib,cprog from tsprog '+
      '  intersect '+
      '  select distinct sistema,hcclase,hcbib,hcprog from tsrela '+
      '    where pcclase<>'+g_q+'CLA'+g_q+') group by sistema,cclase order by 1,2';
   totaliza;


end;
procedure Tftsinventario.pinta(Rect: TRect; columna:integer; texto:string);
begin
   if dg.canvas.Textwidth(texto)>dg.ColWidths[columna] then
      dg.ColWidths[columna]:=dg.canvas.Textwidth(texto);
   dg.canvas.TextRect( rect, rect.left, rect.Top, texto);
end;

procedure Tftsinventario.dgDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
  var texto:string;
begin
   if arow=0 then begin
      pinta(rect,acol,titulo[acol]);
      exit;
   end;
   if acol=tt[arow-1].columna then begin
      pinta(rect,acol,tt[arow-1].sistema);
      exit;
   end;
   if acol>shiftclases-1 then begin
      if tt[arow-1].columna>1 then begin
         dg.Canvas.brush.color := $00E6E6E6; //$00E7D3D7;
         if tt[arow-1].total[acol-shiftclases]>0 then
            texto:=inttostr(tt[arow-1].total[acol-shiftclases])
         else
            texto:=' ';
         pinta(rect,acol,texto);
         dg.Canvas.brush.color := clwindow;
      end;
      exit;
   end;
end;

procedure Tftsinventario.tabChange(Sender: TObject);
begin
   totaliza;
end;

procedure Tftsinventario.dgClick(Sender: TObject);
begin
   if (dg.col<shiftclases) or (dg.Row<0) then exit;
   if tt[dg.Row-1].columna>1 then
      consulta(tt[dg.row-1].sistema,cla[dg.Col-shiftclases]);
end;

procedure Tftsinventario.dgMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var xx,yy:integer;
begin
   dg.MouseToCell(x,y,xx,yy);
   if (xx<0) or (yy<0) then exit;
   dg.Col:=xx;
   dg.Row:=yy;
end;

procedure Tftsinventario.AnalisisdeImpacto1Click(Sender: TObject);
begin
   screen.Cursor:=crsqlwait;
   PR_IMPACTO(query.FieldByName('componente').AsString,
              query.FieldByName('libreria').AsString,
              query.FieldByName('clase').AsString);
   screen.Cursor:=crdefault;
end;

procedure Tftsinventario.bClick(Sender: TObject);
   var
      arch : string;

begin
   gral.BorraRutinasjs();
   gral.BorraLogo(WnomLogo);
   arch:=g_tmpdir+'\inventario.html';
   g_borrar.Add(arch);
   arch:=g_tmpdir+'\inventarioIMP.html';
   g_borrar.Add(arch);
   close;
end;
procedure Tftsinventario.titulos(tipo:integer);
var
   mitad, ancho: integer;
   ARect: TRect;
   texto:string;
begin
   mitad := printer.PageWidth div 2;
//   bitmap.LoadFromFile( dm.nombre_grafico( g_ruta + 'sistema\logo1' ) );
   ARect := Rect( 0, 0, ftsmain.imglogo.Picture.Bitmap.Width * 5, ftsmain.imglogo.Picture.bitmap.Height * 5 );
   printer.Canvas.StretchDraw( arect, ftsmain.imglogo.Picture.bitmap );
   texto:=dm.xlng('Pagina: ' + inttostr( pagina));
   ancho := printer.canvas.TextWidth(texto);
   printer.canvas.TextOut( printer.PageWidth-ancho, 50,texto);
   inc(pagina);
   printer.canvas.Font.Size := 16;
   printer.canvas.Font.Style := [ fsbold ];
   ancho := printer.canvas.TextWidth( g_empresa );
   printer.Canvas.TextOut( mitad - ( ancho div 2 ), 50, g_empresa );
   printer.canvas.Font.Size := 8;
   printer.canvas.Font.Style := [ ];
   if tipo=1 then
      texto:=dm.xlng('Inventario de '+ytitulo.Caption)
   else
      texto:=dm.xlng('Inventario de '+tab.Tabs[tab.TabIndex]);
   ancho := printer.canvas.TextWidth(texto);
   printer.Canvas.Rectangle(mitad - ( ancho div 2 )-5,280,mitad+(ancho div 2)+5,395);
   printer.Canvas.TextOut( mitad - ( ancho div 2 ), 290,texto);
   texto:=formatdatetime( 'YYYY/MM/DD', now );
   ancho := printer.canvas.TextWidth(texto);
   printer.canvas.textout( printer.PageWidth-ancho, 290, texto );
   if tipo=1 then begin
      printer.canvas.textout( 300, 400, dm.xlng('Clase') );
      printer.canvas.textout( 500, 400, dm.xlng('Libreria') );
      printer.canvas.textout( 1000, 400, dm.xlng('Componente') );
   end;
   printer.canvas.textout( 50, printer.PageHeight-100, 'svw-ftsinventario-1' );
   texto:=dm.xlng('SysViewSoftSCM');
   ancho := printer.canvas.TextWidth(texto);
   printer.Canvas.textout( printer.PageWidth-ancho, printer.PageHeight-100,texto  );
end;

procedure Tftsinventario.totales;
begin

   iy := iy + 200;
   printer.canvas.Rectangle( 500 + 350, iy, 500 + 600, iy + 100 );
   printer.canvas.textout( 500 + 450, iy + 5, inttostr( query.RecordCount ) );
end;

procedure Tftsinventario.bimprimirClick(Sender: TObject);
var
   i: integer;
begin
   if PrintDialog1.Execute then begin
      pagina:=1;
      printer.Orientation:=poPortrait;
      printer.BeginDoc;
      lin := 0;
      query.First;
      i:=0;
      while not query.Eof do begin
         if lin mod 50 = 0 then begin // Totales
            if i > 0 then begin
               totales;
               printer.NewPage;
            end;
            inc(i);
            titulos(1);
         end;
         iy := 100 * ( lin mod 50 ) + 500;
         bitmap.canvas.Brush.color := clwhite;
         bitmap.Canvas.FillRect( rect( 0, 0, 100, 100 ) );
         dm.imgclases.GetBitmap( dm.lclases.IndexOf( query.fieldbyname('clase').asstring ), bitmap );
         printer.Canvas.StretchDraw( rect( 100, iy, 200, iy + 100 ), bitmap );
         printer.Canvas.TextOut( 300, iy, query.fieldbyname('clase').asstring);
         printer.Canvas.TextOut( 500, iy, query.fieldbyname('libreria').asstring );
         printer.Canvas.TextOut( 1000, iy, query.fieldbyname('componente').asstring );
         printer.canvas.MoveTo( 100, iy );
         printer.Canvas.Lineto( printer.PageWidth-2, iy );
         lin := lin + 1;
         query.Next;
      end;
      totales;
      printer.EndDoc;
      query.First;
   end;
end;

{procedure Tftsinventario.bimprimeClick(Sender: TObject);
var
   i,j,lin: integer;
begin
   if PrintDialog1.Execute=false then exit;
   pagina:=1;
   printer.Orientation:=poLandscape;
   printer.BeginDoc;
   titulos(2);
   lin := 5;
   for i:=0 to 2 do
      printer.Canvas.TextOut(i*500,lin*100,titulo[i]);
   for i:=3 to dg.ColCount-1 do
      printer.Canvas.TextOut(i*250+1400,lin*100,titulo[i]);
   inc(lin);
   for i:=0 to high(tt) do begin
      if lin>55 then begin
         printer.NewPage;
         titulos(2);
         lin:=5;
      end;
      printer.Canvas.TextOut(tt[i].columna*500,lin*100,tt[i].sistema);
      for j:=0 to high(tt[i].total) do
         printer.Canvas.TextOut(2150+j*250,lin*100,inttostr(tt[i].total[j]));
      inc(lin);
   end;
   printer.EndDoc;
end;
}
procedure Tftsinventario.creaweb;
var
   i,j,ii,vm,tocol,total_h: integer;
   xcolor,descripcion,texto,SisDespues: string;
   x,x1:Tstringlist;
begin
   vm:=0;
   for i:=0 to high(tt) do begin
      if tt[i].columna > vm then
         vm:=tt[i].columna;
   end;

   x:=Tstringlist.create;
   x1:=Tstringlist.create;
   x.Add('<HTML>');
   x1.Add('<HTML>');
   x.Add('<HEAD>');
   x1.Add('<HEAD>');
   x.Add('<TITLE>SysViewSoft</TITLE>');
   x1.Add('<TITLE>SysViewSoft</TITLE>');

   // PARA RESALTAR LA LINEA.
   x.ADD('<script language="JavaScript" type="text/javascript">');
   x.ADD(' function ResaltarFila(id_tabla){');
   x.ADD('  if (id_tabla == undefined)');
   x.ADD('var filas = document.getElementsByTagName("tr");');
   x.ADD('  else{');
   x.ADD('var tabla = document.getElementById(id_tabla);');
   x.ADD('var filas = tabla.getElementsByTagName("tr");');
   x.ADD('}');
   x.ADD('for(var i in filas) { ');
   x.ADD('filas[i].onmouseover = function() { ');
   x.ADD('this.className = "resaltar";');
   x.ADD('}');
   x.ADD('filas[i].onmouseout = function() { ');
   x.ADD('this.className = null; ');
   x.ADD('  }');
   x.ADD(' }');
   x.ADD('}');
   x.ADD('</script>');

   x.ADD('<style type="text/css">');
   x.ADD('tr.resaltar {');
   x.ADD('background-color: #F5F5F5;');
   x.ADD('}');
   x.ADD('</style>');

  // FIN RESALTAR LA LINEA

   // SCROLL DE LA TABLA
   x.ADD('<script src="jquery.js"></script>');
   x.ADD('<script src="jquery.fixer.js"></script>');
   x.ADD('<script>');
   x.ADD('$(document).ready(function() {');
   x.ADD('$("table").fixer({fixedrows:1,fixedcols:'+IntToStr(vm+1)+
   ',width:1300,height:400,scrollbarwidth:13});');
   x.ADD('});');
   x.ADD('</script>');
   // SCROLL DE LA TABLA

   x.Add('</HEAD>');
   x1.Add('<TITLE>SysViewSoft</TITLE>');
   x.Add('<BODY bgcolor="#E6E6E6" Text="#000000" link="#000000" alink= "#FF0000" vlink= "#000000">');
   x1.Add('<BODY bgcolor="#E6E6E6" Text="#000000" link="#000000">');
   x.Add('<div ALIGN=MIDDLE ><img width="100" height="30" src="'+WnomLogo+'.png" ALIGN=right>');
   x1.Add('<div ALIGN=MIDDLE ><img width="100" height="30" src="'+WnomLogo+'.png" ALIGN=right>');
   x.Add(g_empresa);
   x1.Add(g_empresa);
   texto:=dm.xlng('Inventario de componentes: '+tab.Tabs[tab.TabIndex]);
   Xtexto:=texto;
   x.Add('<p>'+texto+'</p>');
   x1.Add('<p>'+texto+'</p>');
   x.Add('<TABLE id="tabla_inventario" cellspacing="1" BORDER="3">');
   x1.Add('<TABLE id="tabla_inventario" cellspacing="1" BORDER="3">');
   x.Add('<TR>');
   x1.Add('<TR>');
   tocol:=-1;
//   vaux2:=0;
   for i:=0 to 2 do begin
      x.add('<TH bgcolor="#BCA9F5" NOWRAP><FONT FACE="verdana" size="2">'+titulo[i]+'</font></TH>');
      x1.add('<TH bgcolor="#BCA9F5" NOWRAP><FONT FACE="verdana" size="2">'+titulo[i]+'</font></TH>');
      tocol:=tocol+1;
//      vaux2:=vaux2+1;
   end;

   if vaux3 > 0 then begin
      while tocol < vm do begin
         x.add('<TH bgcolor="#BCA9F5">&nbsp;</TH>');
         x1.add('<TH bgcolor="#BCA9F5">&nbsp;</TH>');
         tocol:=tocol+1;
      end;
   end;

   i:=vm+1;
   while i < dg.ColCount do begin
      if dm.sqlselect(dm.q1,'select * from tsclase where cclase='+g_q+titulo[i]+g_q) then begin
         descripcion:=dm.q1.fieldbyname('descripcion').AsString;
      end;
      x.add('<TH bgcolor="#BCA9F5" NOWRAP><FONT FACE="verdana" size="2"><A style="color:#000000" HREF=#enc'+
      titulo[i]+' TITLE="'+descripcion+'">'+titulo[i]+'</A></font></TH>');
      x1.add('<TH bgcolor="#BCA9F5" NOWRAP><FONT FACE="verdana" size="2"><A style="color:#000000" HREF=#enc'+
      titulo[i]+' TITLE="'+descripcion+'">'+titulo[i]+'</A></font></TH>');
      tocol:=tocol+1;
      i:=i+1;
   end;
   x.add('<TH bgcolor="#BCA9F5" NOWRAP><FONT FACE="verdana" size="2">Totales</A></font></TH>');
   x1.add('<TH bgcolor="#BCA9F5" NOWRAP><FONT FACE="verdana" size="2">Totales</A></font></TH>');
   tocol:=tocol+1;
   for i:=0 to high(tt) do begin
      total_h := 0;
      tocol:=0;
      x.add('</TR>');
      x1.add('</TR>');
      x.add('<TR>');
      x1.add('<TR>');
      for ii:=0 to tt[i].columna-1 do begin
         if tt[i].columna > 0 then begin
            if tt[i].sistema = '-- Totales' then begin
               x.add( '<TD bgcolor="#BCA9F5"> &nbsp;</TD>');
               x1.add('<TD bgcolor="#BCA9F5"> &nbsp;</TD>');
               tocol:=tocol+1;
            end
            else begin
               x.add('<TD> &nbsp;</TD>');
               x1.add('<TD> &nbsp;</TD>');
               tocol:=tocol+1;
            end;
         end;
      end;
      if  tt[i].sistema = '-- Totales' then  begin
         x.add( '<TD bgcolor="#BCA9F5" NOWRAP><FONT FACE="verdana" size="1">'+tt[i].sistema+'</font></TD>');
         x1.add('<TD bgcolor="#BCA9F5" NOWRAP><FONT FACE="verdana" size="1">'+tt[i].sistema+'</font></TD>');
         xcolor:='"#BCA9F5"';
         tocol:=tocol+1;
      end
      else begin
         x.add('<TD NOWRAP><FONT FACE="verdana" size="1">'+tt[i].sistema+'</font></TD>');
         x1.add('<TD NOWRAP><FONT FACE="verdana" size="1">'+tt[i].sistema+'</font></TD>');
         xcolor:='"#E6E6E6"';
         tocol:=tocol+1;
      end;

      for  ii:=tocol to vm do begin
         if trim(tt[i].sistema) = '-- Totales' then begin
            x.add('<TD bgcolor='+xcolor+'>&nbsp;</TD>');
            x1.add('<TD bgcolor='+xcolor+'>&nbsp;</TD>');
            tocol:=tocol+1;
         end
         else begin
            x.add('<TD>&nbsp;</TD>');
            x1.add('<TD>&nbsp;</TD>');
            tocol:=tocol+1;
         end;
      end;

      for j:=0 to high(tt[i].total) do begin
     //    vaux1:=vaux1+1;
         if  inttostr(tt[i].total[j]) = '0' then begin
            if trim(tt[i].sistema) = '-- Totales' then begin
               x.add('<TD bgcolor='+xcolor+'>&nbsp;</TD>');
               x1.add('<TD bgcolor='+xcolor+'>&nbsp;</TD>');
               tocol:=tocol+1;
            end
            else begin
               x.add('<TD>&nbsp;</TD>');
               x1.add('<TD>&nbsp;</TD>');
               tocol:=tocol+1;
            end
         end
         else begin
            total_h:= total_h+(tt[i].total[j]);
            if trim(tt[i].sistema) = '-- Totales' then begin
               x.add('<TD bgcolor='+xcolor+' ALIGN=right><FONT FACE="verdana" size="1">'+
               inttostr(tt[i].total[j])+'</font></TD>');
               x1.add('<TD bgcolor='+xcolor+' ALIGN=right><FONT FACE="verdana" size="1">'+
               inttostr(tt[i].total[j])+'</font></TD>');
               tocol:=tocol+1;
            end
            else begin
               SisDespues := StringReplace(tt[i].sistema,' ','¿',[rfReplaceAll]);
               x.add('<TD ALIGN=right><FONT FACE="verdana" size="1" ><A HREF=#lin'+
               SisDespues+'|'+titulo[j+3+vaux3]+'>'+inttostr(tt[i].total[j])+'</A></font></TD>');
               x1.add('<TD ALIGN=right><FONT FACE="verdana" size="1"><A HREF=#lin'+
               SisDespues+'|'+titulo[j+3+vaux3]+'>'+inttostr(tt[i].total[j])+'</A></font></TD>');
               tocol:=tocol+1;
				end;
         end;
      end;
      if inttostr(total_h) = '0' then begin
         x.add('<TD bgcolor="#BCA9F5">&nbsp;</TD>');
         x1.add('<TD bgcolor="#BCA9F5">&nbsp;</TD>');
      end
      else begin
         x.add('<TD bgcolor="#BCA9F5"  ALIGN=right><FONT FACE="verdana" size="1">'+inttostr(total_h)+'</font></TD>');
         x1.add('<TD bgcolor="#BCA9F5" ALIGN=right><FONT FACE="verdana" size="1">'+inttostr(total_h)+'</font></TD>');
      end;
   end;
   for ii:=tocol to vm do begin
      x.add('<TD>&nbsp;</TD>');
      x1.add('<TD>&nbsp;</TD>');
   end;
   x.Add('</TR>');
   x1.Add('</TR>');
   x.Add('</TABLE>');
   x1.Add('</TABLE>');
   x.Add('<script language="JavaScript" type="text/javascript">');
   x.Add('ResaltarFila("tabla_inventario");');
   x.Add('</script>');
   x.ADD('</div>');
   x1.ADD('</div>');
   x.Add('</BODY>');
   x1.Add('</BODY>');
   x.Add('</HTML>');
   x.Add('</HTML>');
   x.savetofile(g_tmpdir+'\Inventario.html');
   x1.savetofile(g_tmpdir+'\InventarioIMP.html');
   x.free;
   x1.free

end;

procedure Tftsinventario.Crea_Web;
begin
   screen.Cursor:=crsqlwait;
   creaweb;
   web.Navigate(g_tmpdir+'\Inventario.html');
   screen.Cursor:=crdefault;
end;

procedure Tftsinventario.WebBeforeNavigate2(Sender: TObject;
  const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
  var j,k:integer; b1,b2,b3:string;
begin
   k:=pos('#lin',URL);
   if k>0 then begin
      screen.Cursor:=crsqlwait;
      b1:=copy(URL,K+4,100);
      b1:=trim(b1);
      b1 := StringReplace(b1, '¿', ' ',[rfReplaceAll]);
      j:=pos('|',b1);
      b2:=trim(copy(b1,1,j-1));
      b3:=trim(copy(b1,j+1,100));
      SisComp := trim(b2)+trim(b3);
      if SisComp <> AntSisComp then begin
         AntSisComp := trim(b2)+trim(b3);
         consulta(b2,b3);
      end;
      cancel:=true;
   end;
   screen.Cursor:=crdefault;
end;
procedure Tftsinventario.ImpWebClick(Sender: TObject);
begin
   b_impresion:=true;
   Web.Navigate(g_tmpdir+'\InventarioIMP.html');

   //PR_BARRA;
   {
   WebPreviewPrint(web);
   Web.Navigate(g_tmpdir+'\Inventario.html');
   }
end;

procedure Tftsinventario.WebPreviewPrint(web: TWebBrowser);
var
vin, Vout: OleVariant;
begin
web.ControlInterface.ExecWB (OLECMDID_PRINTPREVIEW, OLECMDEXECOPT_DONTPROMPTUSER, vin, Vout);
end;

procedure Tftsinventario.BExcelClick(Sender: TObject);
var i :integer;
    Libro : _WORKBOOK;
    Hoja : _WORKSHEET;
    num_campos,nc:integer;
begin
   dbgrid1.Visible:=false;
   num_campos:=query.FieldCount;
   i:=5;
   Libro := ExcelApplication1.Workbooks.Add(Null, 0);
   Hoja := Libro.Sheets[1] as _WORKSHEET;
   screen.Cursor:=crsqlwait;
   Hoja.Cells.Item[2,1]:=trim(g_empresa);
   Hoja.Cells.Item[2,1].font.size:=16;
   Hoja.Cells.Item[3,1]:=trim(Xtexto);
   Hoja.Cells.Item[3,1].font.size:=14;
   Hoja.Cells.Item[4,1]:=trim(Xtitulo);
   Hoja.Cells.Item[4,1].font.size:=12;
   Hoja.Cells.Item[i,1]:=' ';
   Hoja.Cells.Item[i,2]:='Clase';
   Hoja.Cells.Item[i,3]:='Libreria';
   Hoja.Cells.Item[i,4]:='Componente';
   if num_campos > 3 then begin
      Hoja.Cells.Item[i,5]:='Lineas_Blanco';
      Hoja.Cells.Item[i,6]:='Lineas_Total';
      Hoja.Cells.Item[i,7]:='Lineas_Comentario';
      Hoja.Cells.Item[i,8]:='Lineas_Efectivas';
      Hoja.Cells.Item[i,5].Font.Bold:=True;
      Hoja.Cells.Item[i,6].Font.Bold:=True;
      Hoja.Cells.Item[i,7].Font.Bold:=True;
      Hoja.Cells.Item[i,8].Font.Bold:=True;
   end;
   Hoja.Cells.Item[2,1].Font.Bold:=True;
   Hoja.Cells.Item[3,1].Font.Bold:=True;
   Hoja.Cells.Item[4,1].Font.Bold:=True;
   Hoja.Cells.Item[i,2].Font.Bold:=True;
   Hoja.Cells.Item[i,3].Font.Bold:=True;
   Hoja.Cells.Item[i,4].Font.Bold:=True;
   query.First;
   i:=i+1;
   while not query.Eof do begin
        i:=i+1;
        Hoja.Cells.Item[i,1]:= ' ';
        Hoja.Cells.Item[i,2]:= query.fieldbyname('clase').asstring;
        Hoja.Cells.Item[i,3]:= query.fieldbyname('libreria').asstring ;
        Hoja.Cells.Item[i,4]:= query.fieldbyname('componente').asstring ;
        if num_campos > 3 then begin
            Hoja.Cells.Item[i,5]:=query.fieldbyname('lineas_blanco').asstring;
            Hoja.Cells.Item[i,6]:=query.fieldbyname('lineas_total').asstring;
            Hoja.Cells.Item[i,7]:=query.fieldbyname('lineas_comentario').asstring;
            Hoja.Cells.Item[i,8]:=query.fieldbyname('lineas_efectivas').asstring;
        end;

        query.Next;
   end;
   query.First;
   dbgrid1.Visible:=true;
   screen.Cursor:=crdefault;
   ExcelApplication1.Visible[1]:=true;
end;

procedure Tftsinventario.VistadelComponente1Click(Sender: TObject);
   var arch:string;
begin
   if dm.trae_fuente(query.FieldByName('componente').AsString,
                     query.FieldByName('libreria').AsString,ver_componente)then begin
      if pos(chr(13)+chr(10),ver_componente.Text)=0 then  // corrige cuando el fuente no tiene CR
         ver_componente.Text:=stringreplace(ver_componente.Text,chr(10),chr(13)+chr(10),[rfreplaceall]);
      arch:=g_tmpdir+'\'+trim(query.FieldByName('componente').AsString)+'.txt';
      ver_componente.Lines.SaveToFile(arch);
      ShellExecute(0, 'open', pchar(arch),nil,PChar( g_tmpdir ), SW_SHOW);
      g_borrar.Add(arch);
   end else begin
      Application.MessageBox(pchar(dm.xlng('Archivo fuente no existe')),
                             pchar(dm.xlng('Vista de componentes')), MB_OK );
      exit;
   end;
end;

procedure Tftsinventario.WebDocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
   screen.Cursor:=crdefault;
   if b_impresion then begin
      WebPreviewPrint(web);
      Web.Navigate(g_tmpdir+'\Inventario.html');
      b_impresion:=false;
   end;
end;

procedure Tftsinventario.ArmarOpciones(b1:Tstringlist);
 var p,j,k:integer;
     b2:Tstringlist;
     t,NomProg:string;
     tt:Tmenuitem;
begin
   bgral:= query.fieldbyname('clase').asstring+' '+query.fieldbyname('libreria').asstring+' '+
           query.fieldbyname('componente').asstring;
   p:=b1.Count;
   b2:=Tstringlist.Create;
  for j:=0 to p-1 do begin
      b2.CommaText:=b1[j];
      tt:=Tmenuitem.Create(pop);
      tt.Caption:=stringreplace(b2[0],'|',' ',[rfReplaceAll]);
      NombreProceso:=stringreplace(b2[1],'|',' ',[rfReplaceAll]);
      pop.Items.Add(tt);
      k:= pop.Items.Count-1;
      if Nombreproceso= 'formadelphi_preview'  then begin pop.Items[k].OnClick:=formadelphipreview;  continue; end;
      if Nombreproceso= 'panel_preview'        then begin pop.Items[k].OnClick:=panelpreview;        continue; end;
      if Nombreproceso= 'natural_mapa_preview' then begin pop.Items[k].OnClick:=naturalmapapreview;  continue; end;
      if Nombreproceso= 'diagramanatural'      then begin pop.Items[k].OnClick:=diagramanatural;     continue; end;
      if Nombreproceso= 'analisis_impacto'     then begin pop.Items[k].OnClick:=analisisdeimpacto;   continue; end;
      if Nombreproceso= 'diagramaproceso'      then begin pop.Items[k].OnClick:=diagramaproceso  ;   continue; end;
      if Nombreproceso= 'referencias_cruzadas' then begin pop.Items[k].OnClick:=referenciascruzadas; continue; end;
      if Nombreproceso= 'reglas_negocio'       then begin pop.Items[k].OnClick:=reglasnegocio;       continue; end;
      if Nombreproceso= 'versionado'           then begin pop.Items[k].OnClick:=versionado;          continue; end;
      if Nombreproceso= 'fmb_vista_pantalla'   then begin pop.Items[k].OnClick:=fmbvistapantalla;    continue; end;
      if Nombreproceso= 'bms_preview'          then begin pop.Items[k].OnClick:=bmspreview;          continue; end;
      if Nombreproceso= 'diagramacbl'          then begin pop.Items[k].OnClick:=diagramacbl;         continue; end;
      if Nombreproceso= 'dghtml'               then begin pop.Items[k].OnClick:=dghtml;              continue; end;
      if Nombreproceso= 'diagramarpg'          then begin pop.Items[k].OnClick:=diagramarpg;         continue; end;
      if Nombreproceso= 'tabla_crud'           then begin pop.Items[k].OnClick:=tablacrud;           continue; end;
      if Nombreproceso= 'adabas_crud'          then begin pop.Items[k].OnClick:=adabascrud;          continue; end;
      if Nombreproceso= 'diagramajcl'          then begin pop.Items[k].OnClick:=diagramajcl;         continue; end;
      if Nombreproceso= 'diagramaase'          then begin pop.Items[k].OnClick:=diagramaase;         continue; end;
      if Nombreproceso= 'lista_componentes'    then begin pop.Items[k].OnClick:=listacomponentes;    continue; end;
      if Nombreproceso= 'propiedades'          then begin pop.Items[k].OnClick:=propiedades;         continue; end;
      if Nombreproceso= 'atributos'            then begin pop.Items[k].OnClick:=atributos;           continue; end;
      if Nombreproceso= 'Ver_Fuente'           then begin pop.Items[k].OnClick:=VerFuente;           continue; end;
//      if Nombreproceso= 'SalirDelMenu'         then begin pop.Items[k].OnClick:=SalirDelMenu;        continue; end;
   end;
   b2.Free;
end;

procedure Tftsinventario.analisisdeimpacto(Sender: TObject);
begin
   gral.analisis_impacto(query.fieldbyname('componente').asstring+' '+
   query.fieldbyname('libreria').asstring+' '+query.fieldbyname('clase').asstring,
   'Inventario de Componentes');
end;
procedure Tftsinventario.diagramaproceso(Sender: TObject);
begin
   gral.diagramaproceso(query.fieldbyname('componente').asstring+' '+
   query.fieldbyname('libreria').asstring+' '+query.fieldbyname('clase').asstring,
   'Inventario de Componentes');
end;

procedure Tftsinventario.formadelphipreview(Sender: TObject);
begin
   gral.formadelphi_preview(bgral,'Inventario de Componentes');
end;
procedure Tftsinventario.panelpreview(Sender: TObject);
begin
    gral.panel_preview(bgral,'Inventario de Componentes');
end;
procedure Tftsinventario.naturalmapapreview(Sender: TObject);
begin
    gral.natural_mapa_preview(bgral,'Inventario de Componentes');
end;
procedure Tftsinventario.diagramanatural(Sender: TObject);
begin
    gral.diagramanatural(bgral,'Inventario de Componentes');
end;
procedure Tftsinventario.referenciascruzadas(Sender: TObject);
begin
    gral.referencias_cruzadas(query.fieldbyname('componente').asstring+' '+
    query.fieldbyname('libreria').asstring+' '+query.fieldbyname('clase').asstring,'Inventario de Componentes');
end;
procedure Tftsinventario.reglasnegocio(Sender: TObject);
begin
    gral.reglas_negocio(query.fieldbyname('componente').asstring+' '+
   query.fieldbyname('libreria').asstring+' '+query.fieldbyname('clase').asstring,'Inventario de Componentes');
end;
procedure Tftsinventario.versionado(Sender: TObject);
begin
    gral.versionado(query.fieldbyname('componente').asstring+' '+
   query.fieldbyname('libreria').asstring+' '+query.fieldbyname('clase').asstring,'Inventario de Componentes');
end;
procedure Tftsinventario.fmbvistapantalla(Sender: TObject);
begin
    gral.fmb_vista_pantalla(bgral,'Inventario de Componentes');
end;
procedure Tftsinventario.bmspreview(Sender: TObject);
begin
    gral.bms_preview(query.fieldbyname('componente').asstring+' '+
   query.fieldbyname('libreria').asstring+' '+query.fieldbyname('clase').asstring,'Inventario de Componentes');
end;
procedure Tftsinventario.diagramacbl(Sender: TObject);
begin
    gral.diagramacbl(query.fieldbyname('componente').asstring+' '+
   query.fieldbyname('libreria').asstring+' '+query.fieldbyname('clase').asstring,
   'Inventario de Componentes');
end;
procedure Tftsinventario.dghtml(Sender: TObject);
begin
    gral.dghtml(bgral,'Inventario de Componentes');
end;
procedure Tftsinventario.diagramarpg(Sender: TObject);
begin
    gral.diagramarpg(bgral,'Inventario de Componentes');
end;
procedure Tftsinventario.tablacrud(Sender: TObject);
begin
    gral.tabla_crud(bgral,'Inventario de Componentes');
end;
procedure Tftsinventario.adabascrud(Sender: TObject);
begin
    gral.adabas_crud(bgral,'Inventario de Componentes');
end;
procedure Tftsinventario.diagramajcl(Sender: TObject);
begin
    gral.diagramajcl(query.fieldbyname('componente').asstring+' '+
   query.fieldbyname('libreria').asstring+' '+query.fieldbyname('clase').asstring,'Inventario de Componentes');
end;
procedure Tftsinventario.diagramaase(Sender: TObject);
begin
    gral.diagramaase(query.fieldbyname('componente').asstring+' '+
   query.fieldbyname('libreria').asstring+' '+query.fieldbyname('clase').asstring,'Inventario de Componentes');
end;
procedure Tftsinventario.listacomponentes(Sender: TObject);
begin
    gral.lista_componentes(query.fieldbyname('clase').asstring+' '+
   query.fieldbyname('libreria').asstring+' '+query.fieldbyname('componente').asstring,'Inventario de Componentes');
end;
procedure Tftsinventario.propiedades(Sender: TObject);
begin
    gral.propiedades(query.fieldbyname('componente').asstring+' '+
   query.fieldbyname('libreria').asstring+' '+query.fieldbyname('clase').asstring,'Inventario de Componentes');
end;
procedure Tftsinventario.atributos(Sender: TObject);
begin
    gral.atributos(query.fieldbyname('componente').asstring+' '+
    query.fieldbyname('libreria').asstring+' '+query.fieldbyname('clase').asstring,'Inventario de Componentes');
end;

procedure Tftsinventario.VerFuente(Sender: TObject);
begin
    gral.Ver_Fuente(query.fieldbyname('componente').asstring+' '+
   query.fieldbyname('libreria').asstring+' '+query.fieldbyname('clase').asstring,'Inventario de Componentes');
end;
{procedure Tftsinventario.SalirDelMenu(Sender: TObject);
begin
    gral.SalirDelMenu(bgral,'Inventario de Componentes');
end;
}
end.
