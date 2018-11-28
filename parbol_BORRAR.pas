unit parbol;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ImgList, ADODB, ExtCtrls, Menus, StdCtrls, ExtDlgs, shellapi,svsdelphi, 
  InvokeRegistry, Rio, SOAPHTTPClient,
  ptsconscom,ptsimpacto,ptsrefcruz,ptsdocumenta,ptsdiagjcl,mgflcob,mgflrpg,ptstablas,
  ptsmapanat,Grids,ptsproperty,ptsbusca,ptsdghtml,ptsversionado,ptsbms,ptslistacompo,
  jpeg, dxGDIPlusClasses;
type
   TMyRec = record
      pnombre: string;
      pbiblioteca: string;
      pclase: string;
      hnombre: string;
      hbiblioteca: string;             
      hclase: string;
      hijo_falso:boolean;
   end;

type
  Tfarbol = class(TForm)
    Splitter1: TSplitter;
    ScrollBox1: TScrollBox;
    Pop: TPopupMenu;
    Memo: TMemo;
    OpenPictureDialog1: TOpenPictureDialog;
    popmemo: TPopupMenu;
    Notepad1: TMenuItem;
    tv: TTreeView;
    MainMenu1: TMainMenu;
    Consulta: TMenuItem;
    mbusqueda1: TMenuItem;                                               
    htt: THTTPRIO;
    Ayuda1: TMenuItem;
    Acercade1: TMenuItem;
    Salir1: TMenuItem;
    Ventanas1: TMenuItem;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure tvMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tvExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure cambia_icono(Sender: TObject);
    procedure tabla_crud(Sender: TObject);
    procedure adabas_crud(Sender: TObject);
    procedure panel_preview(Sender: TObject);
    procedure formadelphi_preview(Sender: TObject);
    procedure natural_mapa_preview(Sender: TObject);
    procedure analisis_impacto(Sender: TObject);
    procedure propiedades(Sender: TObject);
    procedure lista_componentes(Sender: TObject);
    procedure Notepad1Click(Sender: TObject);
    procedure popmemoPopup(Sender: TObject);
    procedure reglas_negocio(Sender: TObject);
    procedure versionado(Sender: TObject);
    procedure fmb_vista_pantalla(Sender: TObject);
    procedure nuevo_proyecto(Sender: TObject);
    procedure metricas_codepro(Sender: TObject);
    procedure dependencias_codepro(Sender: TObject);
      procedure diagramacbl( Sender: Tobject );
      procedure diagramacblx( nodotext:string );
      procedure diagramacbly( nodotext:string );
      procedure diagramajava( Sender: Tobject );
      procedure diagramajavax( nodotext:string );
      procedure diagramajavay( nodotext:string );
      procedure dghtmlx( nodotext:string );
      procedure dghtmly( nodotext:string );
      procedure diagramarpg( Sender: Tobject );
      procedure diagramarpgx( nodotext:string );
      procedure diagramarpgy( nodotext:string );
      procedure diagramanatural( Sender: Tobject );
      procedure diagramanaturalx( nodotext:string );
      procedure referencias_cruzadas( Sender: Tobject );
      procedure comparaconvertido( Sender: Tobject );
      procedure convertirgenexus( Sender: Tobject );
      procedure convertircblunix( Sender: Tobject );
      procedure convertirnatural( Sender: Tobject );
      procedure convertirngl( Sender: Tobject );
      procedure comparanatural_cobol( Sender: Tobject );
      procedure convertirnat_panta( Sender: Tobject );
      procedure comparanatural_cics( Sender: Tobject );
      procedure convertirnat_ddm( Sender: Tobject );
      procedure comparanatural_ddm( Sender: Tobject );
      procedure convertirnat_fdt( Sender: Tobject );
      procedure comparanatural_fdt( Sender: Tobject );
      procedure convertirnat_nmp( Sender: Tobject );
      procedure comparanatural_nmp( Sender: Tobject );
    procedure ConsultaComponente2Click(Sender: TObject);
      procedure diagramajcl( Sender: Tobject );
      procedure diagramaase( Sender: Tobject );
      procedure formavb_preview(sender: Tobject);
      procedure bms_preview(Sender: TObject);
      procedure conviertease2cob( sender: Tobject );
    procedure mbusqueda1Click(Sender: TObject);
    procedure Acercade1Click(Sender: TObject);
    procedure Salir1Click(Sender: TObject);
    procedure ventana1Click(Sender: TObject);
    procedure tvDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure tvDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure borrar_item(Sender: TObject);
    procedure dghtml( sender: Tobject );
    procedure WtvExpanding(Node: TTreeNode);
  private
    { Private declarations }
    nodo_actual: Ttreenode;
    fmb_nombre_pantalla:string;
    ftsproperty: array of Tftsproperty;
    ftsimpacto: array of Tftsimpacto;
    ftsbms: array of Tftsbms;
    ftsrefcruz: array of Tftsrefcruz;
    ftsdocumenta: array of Tftsdocumenta;
    ftsversionado: array of Tftsversionado;
    ftsdiagjcl: array of Tftsdiagjcl;
    fmgflcob: array of Tfmgflcob;
    fmgflrpg: array of Tfmgflrpg;
    ftstablas: array of Tftstablas;
    ftsmapanat: array of Tftsmapanat;
    ftsbusca:array of Tftsbusca;
    ftsdghtml:array of Tftsdghtml;
    ftslistacompo: array of Tftslistacompo;
    clase_analizable:Tstringlist;
    clase_fisico:Tstringlist;
    clase_descripcion:Tstringlist;
    sistema_datos:Tstringlist;
    procedure nivel_clases(padre:Ttreenode; qq:TADOquery);
    procedure subsistemas(padre:Ttreenode; oficina:string; sistema:string);
    procedure expande(nodo:Ttreenode; nombre:string; bib:string;
                  clase:string; veces:integer);
    function  agrega_al_menu( titulo: string ): integer;
    procedure aisla_rutina_delphi(nombre:string);
    procedure aisla_rutina_Visual_Basic(nombre:string);
    procedure rut_dghtml(nombre:string;bib:string;clase:string; fuente:string; salida:string);
    procedure rut_svsflcob(nombre:string;bib:string;clase:string; fuente:string; salida:string);
    procedure rut_svsflrpg(nombre:string;bib:string;clase:string; fuente:string; salida:string);
  public
    { Public declarations }
    ftsconscom: Tftsconscom;
    b_conscom:boolean;
    nodo_proyecto: Ttreenode;
    memo_componente:string;
    x1,y1:Integer;
    procedure agrega_componente(nombre:string; bib:string; clase:string; nodo:Ttreenode=nil;
   pnombre:string=''; pbib:string=''; pclase:string='');
    function alta_a_proyecto(nombre:string; bib:string; clase:string; proyecto:string):boolean;
  end;

var
  farbol: Tfarbol;
   procedure PR_ARBOL;

implementation
uses ptsdm,psvsfmb,
   ptspanel,  // ptssearch, ----pendiente de quitar
   isvsserver1,facerca,ptsgral,ptsbfr;
{$R *.dfm}
procedure PR_ARBOL;
begin
   g_Wforma:='arbol';
   screen.Cursor:=crsqlwait;
   Application.CreateForm( Tfarbol, farbol );
   try
      PR_PANTALLA;
      farbol.Image1.Visible:=true;
      farbol.Label1.Visible:=true;
      farbol.Label2.Visible:=true;
      farbol.Memo.Visible:=false;
      screen.Cursor:=crdefault;
      farbol.Showmodal;
   finally
      farbol.Free;
      fsvsdelphi.Close;
      fsvsdelphi.Free;
   end;
end;
procedure tfarbol.nivel_clases(padre:Ttreenode; qq:TADOquery);
var tcla,nodo:Ttreenode;
    reg:^Tmyrec;
    nombre:string;
begin
   if dm.sqlselect(dm.q4,'select pcprog, count(*) total from tsrela '+   // Clases
                        ' where pcclase='+g_q+'CLA'+g_q+
                        ' and   pcbib='+g_q+qq.fieldbyname('csistema').AsString+g_q+
                        ' group by pcprog '+
                        ' order by pcprog') then begin
      while not dm.q4.Eof do begin
         nombre:='';
         if dm.sqlselect(dm.q5,'select descripcion from tsclase '+
            ' where cclase='+g_q+dm.q4.fieldbyname('pcprog').AsString+g_q) then
            nombre:=dm.q5.fieldbyname('descripcion').asstring;
         tcla:=tv.Items.AddChild(padre,dm.q4.fieldbyname('pcprog').AsString+' - '+nombre+' ['+
                   dm.q4.fieldbyname('total').AsString+']');
         new(reg);
         reg.pnombre:=qq.fieldbyname('csistema').AsString;
         reg.pclase:='SISTEMA';
         reg.hnombre:=dm.q4.fieldbyname('pcprog').AsString;
         reg.hbiblioteca:=qq.fieldbyname('csistema').AsString;
         reg.hclase:='CLA';
         reg.hijo_falso:=false;
         if (dm.q4.FieldByName('total').AsInteger>0) and
            (dm.q4.FieldByName('total').AsInteger<500) then begin
            reg.hijo_falso:=true;
            nodo:=tv.Items.AddChild(tcla,'hijo falso');
         end;
         tcla.Data:=reg;
         tcla.ImageIndex:=dm.lclases.IndexOf(reg.hclase);
         tcla.SelectedIndex:=0;
         dm.q4.Next;
      end;
   end;
end;
procedure Tfarbol.subsistemas(padre:Ttreenode; oficina:string; sistema:string);
var qq:TADOQuery;
    ss:Ttreenode;
    reg:^Tmyrec;
begin
   qq:=TADOQuery.Create(self);
   qq.Connection:=dm.ADOConnection1;
   if dm.sqlselect(qq,
      'select * from tssistema '+      // Subsistemas
      ' where coficina='+g_q+oficina+g_q+
      ' and cdepende='+g_q+sistema+g_q+
      ' and estadoactual='+g_q+'ACTIVO'+g_q+
      ' order by csistema') then begin
      while not qq.Eof do begin
         ss:=tv.Items.AddChild(padre,qq.fieldbyname('csistema').AsString+' - '+
            qq.fieldbyname('descripcion').AsString);
         new(reg);
         reg.pnombre:=qq.fieldbyname('cdepende').AsString;
         reg.pclase:='SISTEMA';
         reg.hnombre:=qq.fieldbyname('csistema').AsString;
         reg.hclase:='SISTEMA';
         reg.hijo_falso:=false;
         ss.Data:=reg;
         ss.ImageIndex:=dm.lclases.IndexOf(reg.hclase);
         ss.SelectedIndex:=0;
         subsistemas(ss,oficina,qq.fieldbyname('csistema').AsString);
         if sistema_datos.IndexOf(qq.fieldbyname('csistema').AsString)>-1 then
            nivel_clases(ss,qq);
         qq.Next;
      end;
   end;
   qq.free;
end;
procedure Tfarbol.reglas_negocio(Sender: TObject);
Var    reg:^Tmyrec;
   k:integer;
   ventana:Tmenuitem;
   titulo:string;
begin
   reg:=nodo_actual.data;
   titulo:='Documentación '+reg.hclase+' '+reg.hbiblioteca+' '+reg.hnombre;
   for k:=0 to ventanas1.Count-1 do begin
      ventana:=ventanas1.Items[k];
      if ventana.Hint=titulo then begin
         ventana1click(ventana);
         exit;
      end;
   end;
   k:=length(ftsdocumenta);
   setlength(ftsdocumenta,k+1);
   ftsdocumenta[k]:=Tftsdocumenta.create(farbol);
   ftsdocumenta[k].left:= g_left;
   ftsdocumenta[k].top:=g_top;
   ftsdocumenta[k].Width:= g_Width;
   ftsdocumenta[k].Height:= g_Height;
   ftsdocumenta[k].parent:=farbol;
   ftsdocumenta[k].visible:=true;
   ventana:=Tmenuitem.Create(self);
   ventana.Caption:=titulo;
   ventana.hint:=titulo;
   ventana.Tag:=k+2000;
   ventana.OnClick:=ventana1click;
   ventanas1.Add(ventana);
   ftsdocumenta[k].arma(reg.hnombre,reg.hbiblioteca,reg.hclase);
   ftsdocumenta[k].show;
end;
procedure Tfarbol.versionado(Sender: TObject);
Var    reg:^Tmyrec;
   k:integer;
   ventana:Tmenuitem;
   titulo:string;
begin
   reg:=nodo_actual.data;
   titulo:='Versiones '+reg.hclase+' '+reg.hbiblioteca+' '+reg.hnombre;
   for k:=0 to ventanas1.Count-1 do begin
      ventana:=ventanas1.Items[k];
      if ventana.Hint=titulo then begin
         ventana1click(ventana);
         exit;
      end;
   end;
   k:=length(ftsversionado);
   setlength(ftsversionado,k+1);
   ftsversionado[k]:=Tftsversionado.create(farbol);
   ftsversionado[k].parent:=farbol;
   ftsversionado[k].left:= g_left;
   ftsversionado[k].top:=g_top;
   ftsversionado[k].Width:= g_Width;
   ftsversionado[k].Height:= g_Height;
   ftsversionado[k].visible:=true;
   ventana:=Tmenuitem.Create(self);
   ventana.Caption:=titulo;
   ventana.hint:=titulo;
   ventana.Tag:=k+11000;
   ventana.OnClick:=ventana1click;
   ventanas1.Add(ventana);
   ftsversionado[k].arma(reg.hnombre,reg.hbiblioteca,reg.hclase);
   ftsversionado[k].show;
end;
procedure Tfarbol.bms_preview(Sender: TObject);
Var    reg:^Tmyrec;
   k:integer;
   ventana:Tmenuitem;
   titulo,panta:string;
begin
   reg:=nodo_actual.data;
   titulo:='BMS '+reg.hclase+' '+reg.hbiblioteca+' '+reg.hnombre;
   for k:=0 to ventanas1.Count-1 do begin
      ventana:=ventanas1.Items[k];
      if ventana.Hint=titulo then begin
         ventana1click(ventana);
         exit;
      end;
   end;
   panta:=g_tmpdir+'\bms_'+reg.hnombre;
   memo.Lines.SaveToFile(panta);
   g_borrar.Add(panta);
   k:=length(ftsbms);
   setlength(ftsbms,k+1);
   ftsbms[k]:=Tftsbms.create(farbol);
   ftsbms[k].parent:=farbol;
   ftsbms[k].left:= g_left;
   ftsbms[k].top:=g_top;
   ftsbms[k].Width:= g_Width;
   ftsbms[k].Height:= g_Height;
   ftsbms[k].visible:=true;
   ventana:=Tmenuitem.Create(self);
   ventana.Caption:=titulo;
   ventana.hint:=titulo;
   ventana.Tag:=k+12000;
   ftsbms[k].show;
   ventana.OnClick:=ventana1click;
   ventanas1.Add(ventana);
   ftsbms[k].arma(panta);
   ftsbms[k].Invalidate;
end;
procedure Tfarbol.FormCreate(Sender: TObject);
var tp,tt,ts:Ttreenode;
    reg:^Tmyrec;
    proyecto_ant:string;
begin
   if g_language='ENGLISH' then begin
      caption:='Knowledge Base';
   end;
   htt.WSDLLocation:=g_ruta+'IsvsServer.xml';
   clase_fisico:=tstringlist.Create;     // Arma arreglo de fisicos
   clase_descripcion:=tstringlist.Create;
   if dm.sqlselect(dm.q1,'select cclase,descripcion from tsclase '+
      ' where objeto='+g_q+'FISICO'+g_q+
      ' order by cclase') then begin
      while not dm.q1.Eof do begin
         clase_fisico.Add(dm.q1.fieldbyname('cclase').AsString);
         clase_descripcion.Add(dm.q1.fieldbyname('descripcion').AsString);
         dm.q1.Next;
      end;
   end;
   clase_analizable:=tstringlist.Create;     // Arma arreglo de analizables
   if dm.sqlselect(dm.q1,'select cclase,descripcion from tsclase '+
      ' where tipo='+g_q+'ANALIZABLE'+g_q+
      ' order by cclase') then begin
      while not dm.q1.Eof do begin
         clase_analizable.Add(dm.q1.fieldbyname('cclase').AsString);
         dm.q1.Next;
      end;
   end;
   sistema_datos:=Tstringlist.create;
   if dm.sqlselect(dm.q1,'select sistema,count(*) total from tsprog '+
      ' group by sistema order by sistema') then begin
      while not dm.q1.Eof do begin
         sistema_datos.Add(dm.q1.fieldbyname('sistema').AsString);
         dm.q1.Next;
      end;
   end;
//   Application.CreateForm( Tftsconscom, ftsconscom );
   if dm.capacidad('Base Conocimiento - Arbol Principal') then begin
      if dm.sqlselect(dm.q1,'select * from tsoficina order by coficina') then begin // Oficinas
         tp:=tv.Items.AddFirst(nil,g_empresa);
         new(reg);
         reg.hnombre:=g_empresa;
         reg.hclase:='EMPRESA';
         reg.hijo_falso:=false;
         tp.Data:=reg;
         tp.ImageIndex:=dm.lclases.IndexOf(reg.hclase);
         tp.SelectedIndex:=0;
         while not dm.q1.Eof do begin
            tt:=tv.Items.AddChild(tp,dm.q1.fieldbyname('coficina').AsString+' - '+
               dm.q1.fieldbyname('descripcion').AsString);
            new(reg);
            reg.pnombre:=g_empresa;
            reg.pclase:='EMPRESA';
            reg.hnombre:=dm.q1.fieldbyname('coficina').AsString;
            reg.hclase:='OFICINA';
            reg.hijo_falso:=false;
            tt.Data:=reg;
            tt.ImageIndex:=dm.lclases.IndexOf(reg.hclase);
            tt.SelectedIndex:=0;
            if dm.sqlselect(dm.q2,'select * from tssistema '+           // Sistemas
               ' where coficina='+g_q+dm.q1.fieldbyname('coficina').AsString+g_q+
               ' and cdepende'+g_is_null+
               ' and estadoactual='+g_q+'ACTIVO'+g_q+
               ' order by csistema') then begin
               while not dm.q2.Eof do begin
                  ts:=tv.Items.AddChild(tt,dm.q2.fieldbyname('csistema').AsString+' - '+
                     dm.q2.fieldbyname('descripcion').AsString);
                  new(reg);
                  reg.pnombre:=dm.q2.fieldbyname('coficina').AsString;
                  reg.pclase:='OFICINA';
                  reg.hnombre:=dm.q2.fieldbyname('csistema').AsString;
                  reg.hclase:='SISTEMA';
                  reg.hijo_falso:=false;
                  ts.Data:=reg;
                  ts.ImageIndex:=dm.lclases.IndexOf(reg.hclase);
                  ts.SelectedIndex:=0;
                  subsistemas(ts,dm.q2.fieldbyname('coficina').AsString,dm.q2.fieldbyname('csistema').AsString);
                  nivel_clases(ts,dm.q2);
                  dm.q2.Next;
               end;
            end;
            dm.q1.Next;
         end;
      end;
   end;
   mbusqueda1.Visible:=dm.capacidad('Base Conocimiento - Busqueda');

   nodo_proyecto:=tv.Items.Add(nil,'Mis Proyectos');
         new(reg);
         reg.hnombre:=g_usuario;
         reg.hclase:='USER';
         reg.hijo_falso:=false;
         nodo_proyecto.Data:=reg;
         nodo_proyecto.ImageIndex:=dm.lclases.IndexOf(reg.hclase);
         nodo_proyecto.SelectedIndex:=0;
   if dm.sqlselect(dm.q1,'select * from tsuserpro '+
      ' where cuser='+g_q+g_usuario+g_q+
      ' order by cproyecto,cclase,cbib,cprog') then begin
      while not dm.q1.Eof do begin
         if dm.q1.FieldByName('cproyecto').AsString<>proyecto_ant then begin
            proyecto_ant:=dm.q1.FieldByName('cproyecto').AsString;
            tt:=tv.Items.AddChild(nodo_proyecto,proyecto_ant);
            new(reg);
            reg.hnombre:=proyecto_ant;
            reg.hclase:='USERPRO';
            reg.hijo_falso:=false;
            tt.Data:=reg;
            tt.ImageIndex:=dm.lclases.IndexOf(reg.hclase);
            tt.SelectedIndex:=0;
         end;
         if dm.q1.fieldbyname('cprog').AsString<>'.' then begin
            agrega_componente(dm.q1.fieldbyname('cprog').AsString,
               dm.q1.fieldbyname('cbib').AsString,
               dm.q1.fieldbyname('cclase').AsString,tt,
               proyecto_ant,'','USERPRO');
         end;
         dm.q1.Next;
      end;
   end;

end;
function Tfarbol.agrega_al_menu( titulo: string ): integer;
var   tt:Tmenuitem;
      k:integer;
begin
   tt:=Tmenuitem.Create(pop);
   tt.Caption:=titulo;
   pop.Items.Add(tt);
   k:= pop.Items.Count-1;
   pop.Items[k].Tag:=nodo_actual.AbsoluteIndex;
   agrega_al_menu:=k;
end;
procedure Tfarbol.fmb_vista_pantalla(Sender: TObject);
begin
   PR_FMB(fmb_nombre_pantalla);
end;
procedure Tfarbol.cambia_icono;
var clave,magic,clase:string;
   reg:^Tmyrec;
   i,k:integer;
   icono:Ticon;
begin
   if openpicturedialog1.Execute=false then exit;
   clave:=dm.file2blob(openpicturedialog1.FileName,magic);
   reg:=nodo_actual.Data;
   dm.sqldelete('delete from parametro where clave='+g_q+'ICONO_'+reg.hclase+g_q);
   dm.sqlinsert('insert into parametro (clave,secuencia,dato) values('+
      g_q+'ICONO_'+reg.hclase+g_q+',1,'+
      g_q+clave+g_q+')');
   k:=dm.lclases.IndexOf(reg.hclase);
   icono:=Ticon.Create;
   icono.Width:=16;
   icono.Width:=16;
   icono.LoadFromFile(openpicturedialog1.FileName);
   if k>-1 then begin
      dm.imgclases.Delete(k);
      dm.imgclases.InsertIcon(k,icono);
   end
   else begin
      dm.lclases.Add(reg.hclase);
      dm.imgclases.AddIcon(icono);
      clase:=reg.hclase;
      for i:=0 to tv.Items.Count-1 do begin
         reg:=tv.Items[i].Data;
         if reg<>nil then
            if reg.hclase=clase then
               tv.Items[i].ImageIndex:=dm.lclases.Count-1;
      end;
   end;
end;
procedure Tfarbol.panel_preview;
var   reg:^Tmyrec;
      panta:string;
begin
   reg:=nodo_actual.Data;
   panta:=g_tmpdir+'\panel_'+reg.hnombre;
   memo.Lines.SaveToFile(panta);
   //PR_PANEL(dm.pathbib(panta));
   PR_PANEL(panta);
   deletefile(panta);
end;
procedure Tfarbol.formadelphi_preview;
var   reg:^Tmyrec;
      panta:string;
begin
   reg:=nodo_actual.Data;
   panta:=g_tmpdir+'\delphi_'+reg.hnombre;
   memo.Lines.SaveToFile(panta);
   fsvsdelphi.Close;
   PR_PANTALLA;
   fsvsdelphi.arma_pantalla(panta);
   fsvsdelphi.Show;
   deletefile(panta);
end;
procedure Tfarbol.formavb_preview;
var   reg:^Tmyrec;
      panta:string;
begin
   reg:=nodo_actual.Data;
   panta:=g_tmpdir+'\bfr_'+reg.hnombre;
   memo.Lines.SaveToFile(panta);
   fsvsdelphi.Close;
   PR_BFR(panta);;
   deletefile(panta);
end;
procedure Tfarbol.natural_mapa_preview;
var   reg:^Tmyrec;
   titulo,archivo:string;
   fte:Tstringlist;
   k:integer;
   ventana:Tmenuitem;
begin
   reg:=nodo_actual.data;
   titulo:='Mapa Natural '+reg.hclase+' '+reg.hbiblioteca+' '+reg.hnombre;
   for k:=0 to ventanas1.Count-1 do begin
      ventana:=ventanas1.Items[k];
      if ventana.Hint=titulo then begin
         ventana1click(ventana);
         exit;
      end;
   end;
   k:=length(ftsmapanat);
   setlength(ftsmapanat,k+1);
   ftsmapanat[k]:=Tftsmapanat.Create(farbol);
   ftsmapanat[k].Parent:=farbol;
   ftsmapanat[k].Visible:=true;
   ftsmapanat[k].left:=g_left;
   ftsmapanat[k].top:=g_top;
   ftsmapanat[k].Width:= g_Width;
   ftsmapanat[k].Height:= g_Height;
   ftsmapanat[k].Show;
   ftsmapanat[k].Tag:=k;
   ventana:=Tmenuitem.Create(self);
   ventana.Caption:=titulo;
   ventana.Hint:=titulo;
   ventana.Tag:=k+6000;
   ventana.OnClick:=ventana1click;
   ventanas1.Add(ventana);
   archivo:=g_tmpdir+'\'+reg.hnombre;
   memo.Lines.SaveToFile(archivo);
   {
   if dm.capacidad('Acceso local') then begin
      if fileexists(dm.pathbib(reg.hbiblioteca)+'\'+reg.hnombre) then begin
         copyfile(pchar(dm.pathbib(reg.hbiblioteca)+'\'+reg.hnombre),pchar(archivo),false);
      end;
   end
   else begin
      fte:=Tstringlist.Create;
      fte.Text:=(htt as isvsserver).GetTxt('svsget,'+reg.hclase+','+reg.hbiblioteca+','+reg.hnombre);
      if copy(fte.Text,1,7)='<ERROR>' then begin
         showmessage(fte.Text);
         fte.Free;
         exit;
      end;
      fte.SaveToFile(archivo);
      fte.free;
   end;
   }
   g_borrar.Add(archivo);
   ftsmapanat[k].arma(archivo);
end;
procedure Tfarbol.ventana1click(Sender: TObject);
var ite:Tmenuitem;
begin
   ite:=(sender as Tmenuitem);
  if ite.Tag>=13000 then begin     // Lista Componentes
      ftslistacompo[ite.Tag-13000].WindowState:=wsnormal;
      ftslistacompo[ite.Tag-13000].show;
      ftslistacompo[ite.Tag-13000].Invalidate;
   end
   else
   if ite.Tag>=12000 then begin     // BMS
      ftsbms[ite.Tag-12000].WindowState:=wsnormal;
      ftsbms[ite.Tag-12000].show;
      ftsbms[ite.Tag-12000].Invalidate;
   end
   else
   if ite.Tag>=11000 then begin     // Versiones
      ftsversionado[ite.Tag-11000].WindowState:=wsnormal;
      ftsversionado[ite.Tag-11000].show;
      ftsversionado[ite.Tag-11000].Invalidate;
   end
   else
   if ite.Tag>=10000 then begin      // Diagramas Html
      ftsdghtml[ite.Tag-10000].WindowState:=wsnormal;
      ftsdghtml[ite.Tag-10000].show;
      ftsdghtml[ite.Tag-10000].Invalidate;
   end
   else
   if ite.Tag>=9000 then begin      // Diagramas RPG
      fmgflrpg[ite.Tag-9000].WindowState:=wsnormal;
      fmgflrpg[ite.Tag-9000].show;
      fmgflrpg[ite.Tag-9000].Invalidate;
   end
   else
   if ite.Tag>=8000 then begin      // Busqueda
      ftsbusca[ite.Tag-8000].WindowState:=wsnormal;
      ftsbusca[ite.Tag-8000].show;
      ftsbusca[ite.Tag-8000].Invalidate;
   end
   else
   if ite.Tag>=7000 then begin      // Mapa Natural
      ftsproperty[ite.Tag-7000].WindowState:=wsnormal;
      ftsproperty[ite.Tag-7000].show;
      ftsproperty[ite.Tag-7000].Invalidate;
   end
   else
   if ite.Tag>=6000 then begin      // Mapa Natural
      ftsmapanat[ite.Tag-6000].WindowState:=wsnormal;
      ftsmapanat[ite.Tag-6000].show;
      ftsmapanat[ite.Tag-6000].Invalidate;
   end
   else
   if ite.Tag>=5000 then begin      // Tablas CRUD
      ftstablas[ite.Tag-5000].WindowState:=wsnormal;
      ftstablas[ite.Tag-5000].show;
      ftstablas[ite.Tag-5000].Invalidate;
   end
   else
   if ite.Tag>=4000 then begin      // Diagramas COBOL
      fmgflcob[ite.Tag-4000].WindowState:=wsnormal;
      fmgflcob[ite.Tag-4000].show;
      fmgflcob[ite.Tag-4000].Invalidate;
   end
   else
   if ite.Tag>=3000 then begin      // Diagrama JCL
      ftsdiagjcl[ite.Tag-3000].WindowState:=wsnormal;
      ftsdiagjcl[ite.Tag-3000].show;
      ftsdiagjcl[ite.Tag-3000].Invalidate;
   end
   else
   if ite.Tag>=2000 then begin     // Documentación
      ftsdocumenta[ite.Tag-2000].WindowState:=wsnormal;
      ftsdocumenta[ite.Tag-2000].show;
      ftsdocumenta[ite.Tag-2000].Invalidate;
   end
   else
   if ite.Tag>=1000 then begin     // Referencias Cruzadas
      ftsrefcruz[ite.Tag-1000].WindowState:=wsnormal;
      ftsrefcruz[ite.Tag-1000].show;
      ftsrefcruz[ite.Tag-1000].Invalidate;
   end
   else begin                                        // Analisis de Impacto
      ftsimpacto[ite.Tag].WindowState:=wsnormal;
      ftsimpacto[ite.Tag].show;
      ftsimpacto[ite.Tag].Invalidate;
   end;
end;
procedure Tfarbol.analisis_impacto;
var   reg:^Tmyrec;
   k:integer;
   ventana:Tmenuitem;
   titulo:string;
begin
   reg:=nodo_actual.data;
   titulo:='Impacto '+reg.hclase+' '+reg.hbiblioteca+' '+reg.hnombre;
   for k:=0 to ventanas1.Count-1 do begin
      ventana:=ventanas1.Items[k];
      if ventana.Hint=titulo then begin
         ventana1click(ventana);
         exit;
      end;
   end;
   screen.Cursor:=crsqlwait;
   k:=length(ftsimpacto);
   setlength(ftsimpacto,k+1);
   ftsimpacto[k]:=Tftsimpacto.Create(farbol);
   ftsimpacto[k].Parent:=farbol;
   ftsimpacto[k].Visible:=false;
   ftsimpacto[k].Tag:=k;
   ftsimpacto[k].left:=g_left;
   ftsimpacto[k].top:=g_top;
   ftsimpacto[k].Width:= g_Width;
   ftsimpacto[k].Height:= g_Height;
   ventana:=Tmenuitem.Create(self);
   ventana.Caption:=titulo;
   ventana.Hint:=titulo;
   ventana.Tag:=k;
   ventana.OnClick:=ventana1click;
   ventanas1.Add(ventana);
   ftsimpacto[k].arma(reg.hnombre,reg.hbiblioteca,reg.hclase);
   ftsimpacto[k].Visible:=true;
   ftsimpacto[k].Show;
   screen.Cursor:=crdefault;
end;
procedure Tfarbol.lista_componentes;
{var   reg:^Tmyrec;
   k:integer;
   ventana:Tmenuitem;
   titulo:string;
begin
   reg:=nodo_actual.data;
   PR_LISTA(reg.hclase,reg.hbiblioteca,reg.hnombre);
end;
}
var
   reg:^Tmyrec;
   k:integer;
   ventana:Tmenuitem;
   titulo:string;
begin
   reg:=nodo_actual.data;
   titulo:='Lista de Componentes '+reg.hclase+' '+reg.hbiblioteca+' '+reg.hnombre;
   for k:=0 to ventanas1.Count-1 do begin
      ventana:=ventanas1.Items[k];
      if ventana.Hint=titulo then begin
         ventana1click(ventana);
         exit;
      end;
   end;
   k:=length(ftslistacompo);
   setlength(ftslistacompo,k+1);
   ftslistacompo[k]:=Tftslistacompo.create(farbol);
   ftslistacompo[k].parent:=farbol;
   ftslistacompo[k].left:= g_left;
   ftslistacompo[k].top:=g_top;
   ftslistacompo[k].Width:= g_Width;
   ftslistacompo[k].Height:= g_Height;
   ftslistacompo[k].Visible:=false;
   ventana:=Tmenuitem.Create(self);
   ventana.Caption:=titulo;
   ventana.hint:=titulo;
   ventana.Tag:=k+13000;
   ventana.OnClick:=ventana1click;
   ventanas1.Add(ventana);
   ftslistacompo[k].arma(reg.hclase,reg.hbiblioteca,reg.hnombre);
   ftslistacompo[k].web.Navigate(g_tmpdir+'\ListaComponentes.html');

end;

procedure Tfarbol.propiedades;
var   reg:^Tmyrec;
   k:integer;
   ventana:Tmenuitem;
   titulo:string;
begin
   reg:=nodo_actual.data;
   titulo:='Propiedades '+reg.hclase+' '+reg.hbiblioteca+' '+reg.hnombre;
   for k:=0 to ventanas1.Count-1 do begin
      ventana:=ventanas1.Items[k];
      if ventana.Hint=titulo then begin
         ventana1click(ventana);
         exit;
      end;
   end;
   k:=length(ftsproperty);
   setlength(ftsproperty,k+1);
   ftsproperty[k]:=Tftsproperty.Create(farbol);
   ftsproperty[k].Parent:=farbol;
   ftsproperty[k].Visible:=false;
   ftsproperty[k].Tag:=k;
   ventana:=Tmenuitem.Create(self);
   ventana.Caption:=titulo;
   ventana.Hint:=titulo;
   ventana.Tag:=k+7000;
   ventana.OnClick:=ventana1click;
   ventanas1.Add(ventana);
   ftsproperty[k].arma(reg.hnombre,reg.hbiblioteca,reg.hclase);
   ftsproperty[k].Visible:=true;
   ftsproperty[k].Show;
end;
procedure Tfarbol.aisla_rutina_delphi(nombre:string);
var i:integer;
begin
   nombre:='.'+copy(nombre,pos('_',nombre)+1,500);
   while (pos(nombre,uppercase(memo.Lines[0]))<1) and
         (memo.Lines.Count>0) do memo.Lines.delete(0);
   i:=1;
   while (pos('PROCEDURE',uppercase(memo.Lines[i]))<1) and
         (pos('FUNCTION',uppercase(memo.Lines[i]))<1) and
         (i<memo.Lines.Count-2) do inc(i);
   while i<memo.Lines.Count do memo.Lines.Delete(i);
end;

procedure Tfarbol.aisla_rutina_Visual_Basic(nombre:string);
var i,w1:integer;
    w2:string;
    W:Tstringlist;
begin
//   nombre:=copy(nombre,pos('_',nombre)+1,500);
   i:=0;
   W:=Tstringlist.create;
//   nombre:=Uppercase(nombre);
   w1:=0;
   while  w1=0 do begin
      w2:=uppercase(memo.Lines[i]);
      if (pos(nombre,w2)>0) then begin
         if (pos('PRIVATE ',uppercase(memo.Lines[i]))>0) or
            (pos('DECLARE ',uppercase(memo.Lines[i]))>0) or
            (pos('PUBLIC ',uppercase(memo.Lines[i]))>0) or
            (pos('FUNCTION ',uppercase(memo.Lines[i]))>0) or
            (pos('SUB ',uppercase(memo.Lines[i]))>0) then begin
            W.add(memo.Lines[i]);
            i:=i+1;
            w1:=1;
         end;
      end;
      i:=i+1;
   end;
   while
         (pos('PRIVATE ',uppercase(memo.Lines[i]))<1) and
         (pos('DECLARE ',uppercase(memo.Lines[i]))<1) and
         (pos('PUBLIC ',uppercase(memo.Lines[i]))<1) and
         (pos('FUNCTION ',uppercase(memo.Lines[i]))<1) and
         (pos('SUB ',uppercase(memo.Lines[i]))<1) and
         (i<memo.Lines.Count-2) do begin
         if (pos(' EXIT ',uppercase(memo.Lines[i]))<1) then
            W.add(memo.Lines[i]);
         i:=i+1;
 //         inc(i);
   end;
 W.savetofile(nombre+'.txt');
  W2:=g_q+g_tmpdir+'\'+nombre+g_q;
  memo.Lines.LoadFromFile(nombre+'.txt');
  memo_componente:='';
  memo.Visible:=true;
  try
    deletefile(nombre+'.txt');
  except
  end;
  W.Free;
end;

procedure Tfarbol.diagramacbl( sender: Tobject );
begin
   screen.Cursor:=crsqlwait;
   if dm.capacidad('Acceso local') then begin
      diagramacblx(nodo_actual.Text);
   end
   else begin
      diagramacbly(nodo_actual.Text);
   end;
   screen.Cursor:=crdefault;
end;
procedure Tfarbol.dghtml( sender: Tobject );
begin
   screen.Cursor:=crsqlwait;
   if dm.capacidad('Acceso local') then begin
      dghtmlx(nodo_actual.Text);
   end
   else begin
      dghtmly(nodo_actual.Text);
   end;
   screen.Cursor:=crdefault;
end;
procedure Tfarbol.diagramajava( sender: Tobject );
begin
   screen.Cursor:=crsqlwait;
   if dm.capacidad('Acceso local') then begin
      diagramajavax(nodo_actual.Text);
   end
   else begin
      diagramajavay(nodo_actual.Text);
   end;
   screen.Cursor:=crdefault;
end;
procedure Tfarbol.diagramarpg( sender: Tobject );
begin
   screen.Cursor:=crsqlwait;
   if dm.capacidad('Acceso local') then begin
      diagramarpgx(nodo_actual.Text);
   end
   else begin
      diagramarpgy(nodo_actual.Text); // no está implementado con webserver
   end;
   screen.Cursor:=crdefault;
end;
procedure Tfarbol.rut_dghtml(nombre:string;bib:string;clase:string; fuente:string; salida:string);
var   reg:^Tmyrec; k:integer;
   ventana:Tmenuitem;
   titulo:string;
begin
   reg:=nodo_actual.data;
   titulo:='Diagrama de Flujo '+clase+' '+bib+' '+nombre;
   for k:=0 to ventanas1.Count-1 do begin
      ventana:=ventanas1.Items[k];
      if ventana.Hint=titulo then begin
         ventana1click(ventana);
         exit;
      end;
   end;
   k:=length(ftsdghtml);
   setlength(ftsdghtml,k+1);
   ftsdghtml[k]:=Tftsdghtml.create(farbol);
   ftsdghtml[k].left:= g_left;
   ftsdghtml[k].top:=g_top;
   ftsdghtml[k].Width:= g_Width;
   ftsdghtml[k].Height:= g_Height;
   ftsdghtml[k].parent:=farbol;
   ftsdghtml[k].visible:=true;
   ventana:=Tmenuitem.Create(self);
   ventana.Caption:=titulo;
   ventana.Hint:=titulo;
   ventana.Tag:=k+10000;
   ventana.OnClick:=ventana1click;
   ventanas1.Add(ventana);
   ftsdghtml[k].arma(salida,fuente);
   ftsdghtml[k].Caption:=titulo;
   ftsdghtml[k].show;
end;
procedure Tfarbol.rut_svsflcob(nombre:string;bib:string;clase:string; fuente:string; salida:string);
var   reg:^Tmyrec; k:integer;
   ventana:Tmenuitem;
   titulo:string;
begin
   reg:=nodo_actual.data;
   titulo:='Cobol '+clase+' '+bib+' '+nombre;
   for k:=0 to ventanas1.Count-1 do begin
      ventana:=ventanas1.Items[k];
      if ventana.Hint=titulo then begin
         ventana1click(ventana);
         exit;
      end;
   end;
   k:=length(fmgflcob);
   setlength(fmgflcob,k+1);
   fmgflcob[k]:=Tfmgflcob.create(farbol);
   fmgflcob[k].left:= g_left;
   fmgflcob[k].top:=g_top;
   fmgflcob[k].Width:= g_Width;
   fmgflcob[k].Height:= g_Height;
   fmgflcob[k].parent:=farbol;
   fmgflcob[k].visible:=true;
   ventana:=Tmenuitem.Create(self);
   ventana.Caption:=titulo;
   ventana.Hint:=titulo;
   ventana.Tag:=k+4000;
   ventana.OnClick:=ventana1click;
   ventanas1.Add(ventana);
   fmgflcob[k].arma(fuente,salida,nombre);
   fmgflcob[k].show;
end;
procedure Tfarbol.rut_svsflrpg(nombre:string;bib:string;clase:string; fuente:string; salida:string);
var   reg:^Tmyrec; k:integer;
   ventana:Tmenuitem;
   titulo:string;
begin
   reg:=nodo_actual.data;
   titulo:='RPG '+clase+' '+bib+' '+nombre;
   for k:=0 to ventanas1.Count-1 do begin
      ventana:=ventanas1.Items[k];
      if ventana.Hint=titulo then begin
         ventana1click(ventana);
         exit;
      end;
   end;
   k:=length(fmgflrpg);
   setlength(fmgflrpg,k+1);
   fmgflrpg[k]:=Tfmgflrpg.create(farbol);
   fmgflrpg[k].left:= g_left;
   fmgflrpg[k].top:=g_top;
   fmgflrpg[k].Width:= g_Width;
   fmgflrpg[k].Height:= g_Height;
   fmgflrpg[k].parent:=farbol;
   fmgflrpg[k].visible:=true;
   ventana:=Tmenuitem.Create(self);
   ventana.Caption:=titulo;
   ventana.Hint:=titulo;
   ventana.Tag:=k+9000;
   ventana.OnClick:=ventana1click;
   ventanas1.Add(ventana);
   fmgflrpg[k].arma(fuente,salida,nombre);
   fmgflrpg[k].show;
end;
procedure Tfarbol.diagramacblx( nodotext:string );
var   reg:^Tmyrec;
   svsflcob, mux,directivas,reservadas,rgmlang,salida,hora: string;
   fte,cop:Tstringlist;
   i,k:integer;
   ff:string;
begin                                        
   reg:=nodo_actual.Data;
   if reg.hbiblioteca = 'SCRATCH' then begin
      Application.Title := 'Diagrama de flujo';
      showmessage('Fuente no existe');
      Application.Title := g_appname;
      exit;
   end;
   fte:=Tstringlist.Create;
   if memo_componente=reg.hnombre+'_'+reg.hbiblioteca then begin
      fte.AddStrings(memo.Lines);
   end
   else begin
      if dm.trae_fuente(reg.hnombre,reg.hbiblioteca,fte)=false then begin
         Application.Title := 'Diagrama de flujo';
         showmessage('Fuente no existe');
         Application.Title := g_appname;
         fte.Free;
         exit;
      end;
   end;
//   fte.LoadFromFile(dm.xblobname(reg.hbiblioteca,reg.hnombre));
   if dm.sqlselect(dm.q1,'select distinct hcbib from tsrela '+
      ' where pcprog='+g_q+reg.hnombre+g_q+
      ' and   pcbib='+g_q+reg.hbiblioteca+g_q+
      ' and   pcclase='+g_q+reg.hclase+g_q+
      ' and   hcclase='+g_q+'CPY'+g_q) then begin
      for i:=0 to fte.Count-1 do begin
         if length(fte[i])<8 then continue;
         if fte[i][7]<>' ' then continue;
         ff:=copy(fte[i],7,66);
         k:=pos(' COPY ',uppercase(ff));
         if k=0 then continue;
         ff:=trim(copy(ff,k+6,100));
         k:=pos(' ',ff);
         if k>0 then
            ff:=copy(ff,1,k-1);
         if length(ff)=0 then
            continue;
         if ff[length(ff)]='.' then
            delete(ff,length(ff),1);
         ff:=stringreplace(stringreplace(ff,'''','',[rfreplaceall]),'"','',[rfreplaceall]);
         ff:=lowercase(ff);
         while(pos('/',ff)>0) do ff:=copy(ff,pos('/',ff)+1,100);
         cop:=Tstringlist.Create;
         dm.trae_fuente(uppercase(ff),dm.q1.fieldbyname('hcbib').AsString,cop);
//         if fileexists(dm.xblobname(dm.q1.fieldbyname('hcbib').AsString,ff)) then
//            cop.LoadFromFile(dm.xblobname(dm.q1.fieldbyname('hcbib').AsString,ff));
         for k:=cop.Count-1 downto 0 do
            fte.Insert(i+1,cop[k]);
         fte[i]:=copy(fte[i],1,6)+'*'+copy(fte[i],8,100);
         cop.Free;
      end;
   end;
   mux:=g_tmpdir+'\fte'+reg.hnombre+'.src';
   fte.SaveToFile(mux);
   g_borrar.Add(mux);
   salida:=g_tmpdir+'\sal.sal';
   deletefile(salida);
   hora:=formatdatetime('YYYYMMDDhhnnss',now);
   rgmlang:=g_tmpdir+'\hta'+hora+'.exe';
   directivas:=g_tmpdir+'\hta'+hora+'.dir';
   reservadas:=g_tmpdir+'\hta'+hora+'.res';
   ff:=g_tmpdir+'\hta'+hora+'.tmp';
   dm.get_utileria('RGMLANG',rgmlang);
   dm.get_utileria('COBOLFLOW',directivas);
   for i:=0 to fte.Count-1 do begin         // checa si es tandem y adapta las directivas
      if (copy(fte[i],1,5)='?ENV ') or
         (copy(fte[i],1,5)='?SQL ') or
         (copy(fte[i],1,6)='?SAVE ') or
         (copy(fte[i],1,9)='?INSPECT ') or
         (copy(fte[i],1,9)='?SYMBOLS ') or
         (copy(fte[i],1,10)='?OPTIMIZE ') then begin
         fte.LoadFromFile(directivas);
         fte[0]:=stringreplace(fte[0],'BC08EC72JB08JE72SL''','BC02EC138JB02JE138SL"',[]);
         fte[1]:='IGNORE    07*\07/\07$\07?\01*\01/\01$\01?\\';
         fte.SaveToFile(directivas);
         break;
      end;
   end;
   dm.get_utileria('RESERVADAS CBL',reservadas);
   dm.ejecuta_espera( rgmlang +' '+
                      mux+' '+
                      ff +' '+
                      directivas+' '+
                      reservadas, SW_HIDE );
   g_borrar.Add(rgmlang);
   g_borrar.Add(directivas);
   g_borrar.Add(reservadas);
   g_borrar.Add(ff);
//   copyfile('sal.sal',pchar(salida),false);
   fte.LoadFromFile('sal.sal');
   fte.SaveToFile(salida);
   fte.Free;
//   deletefile('sal.sal');
   if fileexists(salida)=false then begin
      showmessage('ERROR... no pudo analizar '+nodotext);
      exit;
   end;
   g_borrar.Add(salida);
   rut_svsflcob(reg.hnombre,reg.hbiblioteca,reg.hclase,mux,salida);
   {
   svsflcob:=g_tmpdir+'\hta'+formatdatetime('hhmmss',now)+'.exe';
   dm.get_utileria('SVSFLCOB',svsflcob);
   g_borrar.Add(svsflcob);
   if ShellExecute( 0, 'open', pchar(svsflcob),pchar(mux+' '+
            g_tmpdir+'\sal.sal '+g_tmpdir+' '+nodotext),PChar( g_tmpdir), SW_SHOW )<=32 then begin
      Application.MessageBox( 'No se pudo ejecutar la aplicación',
            'Error', MB_ICONEXCLAMATION );
   end;
   }
end;
procedure Tfarbol.diagramacbly( nodotext:string );
var   reg:^Tmyrec;
   svsflcob, mux: string;
   fte:Tstringlist;
   ff:string;
begin
   reg:=nodo_actual.Data;
   ff:=g_tmpdir+'\sal.sal';
   mux:=g_tmpdir+'\tmp_'+reg.hnombre;
   fte:=Tstringlist.Create;
   fte.Text:=(htt as isvsserver).GetTxt('svsget,'+reg.hclase+','+reg.hbiblioteca+','+reg.hnombre);
   if copy(fte.Text,1,7)='<ERROR>' then begin
      showmessage(fte.Text);
      fte.Free;
      exit;
   end;
   fte.SaveToFile(mux);
   fte.Text:=(htt as isvsserver).GetTxt('svscobolflow,'+reg.hclase+','+reg.hbiblioteca+','+reg.hnombre);
   if copy(fte.Text,1,7)='<ERROR>' then begin
      showmessage(fte.Text);
      fte.Free;
      exit;
   end;
   fte.SaveToFile(ff);
   fte.Free;
   rut_svsflcob(reg.hnombre,reg.hbiblioteca,reg.hclase,mux,ff);
   {
   if ShellExecute( 0, 'open', pchar('svsflcob'),pchar(mux+
            ' '+ff+' '+g_tmpdir+' '+nodotext),PChar( g_ruta), SW_SHOW )<=32 then begin
      Application.MessageBox( 'No se pudo ejecutar la aplicación diagrama cobol',
            'Error', MB_ICONEXCLAMATION );
   end;
   sleep(10000); // para dar tiempo a que levante SVSFLCOB
   }
   deletefile(mux);
   deletefile(ff);
end;
procedure Tfarbol.diagramarpgx( nodotext:string );
var   reg:^Tmyrec;
   svsflcob, mux,directivas,reservadas,rgmlang,salida,hora: string;
   fte,cop:Tstringlist;
   i,k:integer;
   ff:string;
begin
   reg:=nodo_actual.Data;
   fte:=Tstringlist.Create;
   if memo_componente=reg.hnombre+'_'+reg.hbiblioteca then begin
      fte.AddStrings(memo.Lines);
   end
   else begin
      if dm.trae_fuente(reg.hnombre,reg.hbiblioteca,fte)=false then begin
         Application.Title := 'Diagrama de flujo';
         showmessage('Fuente no existe');
         Application.Title := g_appname;
         fte.Free;
         exit;
      end;
   end;

   mux:=g_tmpdir+'\fte'+reg.hnombre+'.src';
   fte.SaveToFile(mux);
   g_borrar.Add(mux);
   salida:=g_tmpdir+'\sal.sal';
   deletefile(salida);
   hora:=formatdatetime('YYYYMMDDhhnnss',now);
   rgmlang:=g_tmpdir+'\hta'+hora+'.exe';
   directivas:=g_tmpdir+'\hta'+hora+'.dir';
   reservadas:=g_tmpdir+'\hta'+hora+'.res';
   ff:=g_tmpdir+'\hta'+hora+'.tmp';
   dm.get_utileria('RGMLANG',rgmlang);
   dm.get_utileria('RPGFLOW',directivas);
   dm.get_utileria('RESERVADAS RPG',reservadas);
   dm.ejecuta_espera( rgmlang +' '+
                      mux+' '+
                      ff +' '+
                      directivas+' '+
                      reservadas, SW_HIDE );
   g_borrar.Add(rgmlang);
   g_borrar.Add(directivas);
   g_borrar.Add(reservadas);
   g_borrar.Add(ff);
//   copyfile('sal.sal',pchar(salida),false);
   fte.LoadFromFile('sal.sal');
   fte.SaveToFile(salida);
   fte.Free;
//   deletefile('sal.sal');
   if fileexists(salida)=false then begin
      showmessage('ERROR... no pudo analizar '+nodotext);
      exit;
   end;
   g_borrar.Add(salida);
   rut_svsflrpg(reg.hnombre,reg.hbiblioteca,reg.hclase,mux,salida);
end;
procedure Tfarbol.diagramarpgy( nodotext:string );
var   reg:^Tmyrec;
   svsflcob, mux: string;
   fte:Tstringlist;
   ff:string;
begin
   reg:=nodo_actual.Data;
   ff:=g_tmpdir+'\sal.sal';
   mux:=g_tmpdir+'\tmp_'+reg.hnombre;
   fte:=Tstringlist.Create;
   fte.Text:=(htt as isvsserver).GetTxt('svsget,'+reg.hclase+','+reg.hbiblioteca+','+reg.hnombre);
   if copy(fte.Text,1,7)='<ERROR>' then begin
      showmessage(fte.Text);
      fte.Free;
      exit;
   end;
   fte.SaveToFile(mux);
   fte.Text:=(htt as isvsserver).GetTxt('svscobolflow,'+reg.hclase+','+reg.hbiblioteca+','+reg.hnombre);
   if copy(fte.Text,1,7)='<ERROR>' then begin
      showmessage(fte.Text);
      fte.Free;
      exit;
   end;
   fte.SaveToFile(ff);
   fte.Free;
   rut_svsflcob(reg.hnombre,reg.hbiblioteca,reg.hclase,mux,ff);
   deletefile(mux);
   deletefile(ff);
end;
procedure Tfarbol.dghtmlx( nodotext:string );
var   reg:^Tmyrec;
   svsflcob, mux,directivas,reservadas,rgmlang,salida,hora: string;
   fte,cop:Tstringlist;
   i,k:integer;
   ff:string;
begin
   screen.Cursor:=crsqlwait;
   reg:=nodo_actual.Data;
   fte:=Tstringlist.Create;
   if memo_componente=reg.hnombre+'_'+reg.hbiblioteca then begin
      fte.AddStrings(memo.Lines);
   end
   else begin
      if dm.trae_fuente(reg.hnombre,reg.hbiblioteca,fte)=false then begin
         Application.Title := 'Diagrama de flujo';
         showmessage('Fuente no existe');
         Application.Title := g_appname;
         fte.Free;
         exit;
      end;
   end;
   mux:=g_tmpdir+'\fte'+reg.hnombre+'.src';
   {
   majusta.Lines.Clear;             // Para ajustar las lineas y no rebasen de 250 caracteres
   majusta.Lines.AddStrings(fte);
   fte.Clear;
   fte.AddStrings(majusta.Lines);
   }
   fte.SaveToFile(mux);
   //majusta.Lines.SaveToFile(mux);
   g_borrar.Add(mux);
   salida:=g_tmpdir+'\sal.sal';
   deletefile(salida);
   hora:=formatdatetime('YYYYMMDDhhnnss',now);
   rgmlang:=g_tmpdir+'\hta'+hora+'.exe';
   directivas:=g_tmpdir+'\hta'+hora+'.dir';
   reservadas:=g_tmpdir+'\hta'+hora+'.res';
   ff:=g_tmpdir+'\hta'+hora+'.tmp';
   dm.get_utileria('RGMLANG',rgmlang);
   dm.get_utileria('JAV_DGHTML',directivas);
   dm.get_utileria('RESERVADAS JAV',reservadas);
   dm.ejecuta_espera( rgmlang +' '+
                      mux+' '+
                      ff +' '+
                      directivas+' '+
                      //reservadas, SW_SHOW );
                      reservadas+' >'+salida, SW_HIDE );
   g_borrar.Add(rgmlang);
   g_borrar.Add(directivas);
   g_borrar.Add(reservadas);
   g_borrar.Add(ff);
   fte.LoadFromFile(salida);
   fte.SaveToFile(salida);
   fte.Free;
   if fileexists(salida)=false then begin
      showmessage('ERROR... no pudo analizar '+nodotext);
      exit;
   end;
   g_borrar.Add(salida);
   //rut_svsflcob(reg.hnombre,reg.hbiblioteca,reg.hclase,mux,salida);
   rut_dghtml(reg.hnombre,reg.hbiblioteca,reg.hclase,mux,salida);
   screen.Cursor:=crdefault;
   //PR_DGHTML(salida,mux);
end;
procedure Tfarbol.dghtmly( nodotext:string );
var   reg:^Tmyrec;
   svsflcob, mux: string;
   fte:Tstringlist;
   ff:string;
begin
   showmessage('No implementado en modo web service');
   exit;
end;

procedure Tfarbol.diagramajavax( nodotext:string );
var   reg:^Tmyrec;
   svsflcob, mux,directivas,reservadas,rgmlang,salida,hora: string;
   fte,cop:Tstringlist;
   i,k:integer;
   ff:string;
begin
   reg:=nodo_actual.Data;
   fte:=Tstringlist.Create;
   if memo_componente=reg.hnombre+'_'+reg.hbiblioteca then begin
      fte.AddStrings(memo.Lines);
   end
   else begin
      if dm.trae_fuente(reg.hnombre,reg.hbiblioteca,fte)=false then begin
         Application.Title := 'Diagrama de flujo';
         showmessage('Fuente no existe');
         Application.Title := g_appname;
         fte.Free;
         exit;
      end;
   end;
   mux:=g_tmpdir+'\fte'+reg.hnombre+'.src';
   fte.SaveToFile(mux);
   g_borrar.Add(mux);
   salida:=g_tmpdir+'\sal.sal';
   deletefile(salida);
   hora:=formatdatetime('YYYYMMDDhhnnss',now);
   rgmlang:=g_tmpdir+'\hta'+hora+'.exe';
   directivas:=g_tmpdir+'\hta'+hora+'.dir';
   reservadas:=g_tmpdir+'\hta'+hora+'.res';
   ff:=g_tmpdir+'\hta'+hora+'.tmp';
   dm.get_utileria('RGMLANG',rgmlang);
   dm.get_utileria('JAVAFLOW',directivas);
   dm.get_utileria('RESERVADAS JAV',reservadas);
   dm.ejecuta_espera( rgmlang +' '+
                      mux+' '+
                      ff +' '+
                      directivas+' '+
                      reservadas, SW_HIDE );
   g_borrar.Add(rgmlang);
   g_borrar.Add(directivas);
   g_borrar.Add(reservadas);
   g_borrar.Add(ff);
   fte.LoadFromFile('sal.sal');
   fte.SaveToFile(salida);
   fte.Free;
   if fileexists(salida)=false then begin
      showmessage('ERROR... no pudo analizar '+nodotext);
      exit;
   end;
   g_borrar.Add(salida);
   rut_svsflcob(reg.hnombre,reg.hbiblioteca,reg.hclase,mux,salida);
end;
procedure Tfarbol.diagramajavay( nodotext:string );
var   reg:^Tmyrec;
   svsflcob, mux: string;
   fte:Tstringlist;
   ff:string;
begin
   showmessage('No implementado en modo web service');
   exit;
   reg:=nodo_actual.Data;
   ff:=g_tmpdir+'\sal.sal';
   mux:=g_tmpdir+'\tmp_'+reg.hnombre;
   fte:=Tstringlist.Create;
   fte.Text:=(htt as isvsserver).GetTxt('svsget,'+reg.hclase+','+reg.hbiblioteca+','+reg.hnombre);
   if copy(fte.Text,1,7)='<ERROR>' then begin
      showmessage(fte.Text);
      fte.Free;
      exit;
   end;
   fte.SaveToFile(mux);
   fte.Text:=(htt as isvsserver).GetTxt('svscobolflow,'+reg.hclase+','+reg.hbiblioteca+','+reg.hnombre);
   if copy(fte.Text,1,7)='<ERROR>' then begin
      showmessage(fte.Text);
      fte.Free;
      exit;
   end;
   fte.SaveToFile(ff);
   fte.Free;
   rut_svsflcob(reg.hnombre,reg.hbiblioteca,reg.hclase,mux,ff);
   deletefile(mux);
   deletefile(ff);
end;
procedure Tfarbol.diagramanatural( sender: Tobject );
begin
   diagramanaturalx(nodo_actual.Text);
end;
procedure Tfarbol.diagramanaturalx( nodotext:string );
var   reg:^Tmyrec;
   datos, mux: string;
   fte,cop:Tstringlist;
   i,k:integer;
   ff,filedot:string;
begin
   screen.Cursor:=crsqlwait;
   reg:=nodo_actual.Data;
   chdir( g_ruta );
   fte:=Tstringlist.Create;
   mux:='fte'+reg.hnombre+'.src';
   copyfile(pchar(dm.xblobname(reg.hbiblioteca,reg.hnombre)),pchar(mux),false);
   g_borrar.Add(mux);
   dm.get_utileria('RGMLANG','hta'+mux+'.exe');
   dm.get_utileria('DIRECTIVAS NATURALFLOW','hta'+mux+'.dir');
   dm.get_utileria('RESERVADAS NATURALFLOW','hta'+mux+'.res');
   filedot:=reg.hnombre+'.dot';
   dm.ejecuta_espera( 'hta'+mux+'.exe ' +
                      mux+
                      ' nada ' +
                      ' hta'+mux+'.dir'+
                      ' hta'+mux+'.res > '+filedot, SW_HIDE );
   g_borrar.Add('hta'+mux+'.exe');
   g_borrar.Add('hta'+mux+'.dir');
   g_borrar.Add('hta'+mux+'.res');
   g_borrar.Add(filedot);
   g_borrar.Add('nada');
   if fileexists(filedot)=false then begin
      showmessage('ERROR... no pudo analizar '+nodotext);
      exit;
   end;
   fte.LoadFromFile(filedot);
   datos:=fte.commatext;
   datos:=stringreplace(datos,'º','\n',[rfreplaceall]);
   fte.commatext:=datos;
   fte.SaveToFile(filedot);
   fte.Free;
   {
   if ShellExecute( 0, 'open', pchar(filedot),nil,PChar( g_ruta), SW_SHOW )<=32 then begin
      Application.MessageBox( 'No se pudo ejecutar la aplicación',
            'Error', MB_ICONEXCLAMATION );
   end;
   }
   if ShellExecute( 0, nil,pchar(dm.get_variable('PROGRAMFILES')+'\'+g_graphviz+'\bin\dotty.exe'), pchar(filedot),PChar( g_ruta), SW_SHOW )<=32 then begin
      Application.MessageBox( 'No se pudo ejecutar la aplicación',
            'Error', MB_ICONEXCLAMATION );
   end;
   screen.Cursor:=crdefault;
end;
procedure Tfarbol.diagramaase( sender: Tobject );
var   reg:^Tmyrec;
   datos, mux,ncob: string;
   fte,cop:Tstringlist;
   i,k:integer;
   ff,filedot:string;
begin
   screen.Cursor:=crsqlwait;
   reg:=nodo_actual.Data;
   chdir( g_tmpdir );
   fte:=Tstringlist.Create;
   mux:=reg.hnombre+'.ase';
   ncob:=reg.hnombre+'.cbl';
   copyfile(pchar(dm.xblobname(reg.hbiblioteca,reg.hnombre)),pchar(mux),false);
   g_borrar.Add(mux);
   g_borrar.Add(ncob);
   dm.get_utileria('RGMASE2COB','hta'+mux+'.exe');
   filedot:=reg.hnombre+'.dot';
   dm.ejecuta_espera( 'hta'+mux+'.exe ' +
                      mux+' '+ncob, SW_HIDE );
   g_borrar.Add('hta'+mux+'.exe');
   g_borrar.Add(filedot);
   g_borrar.Add('nada');
   if fileexists(filedot)=false then begin
      showmessage('ERROR... no pudo analizar '+reg.hnombre);
      exit;
   end;
   if ShellExecute( 0, nil,pchar(dm.get_variable('PROGRAMFILES')+'\'+g_graphviz+'\bin\dotty.exe'), pchar(filedot),PChar( g_tmpdir), SW_SHOW )<=32 then begin
      Application.MessageBox( 'No se pudo ejecutar la aplicación',
            'Error', MB_ICONEXCLAMATION );
   end;
   screen.Cursor:=crdefault;
end;
procedure Tfarbol.conviertease2cob( sender: Tobject );
var   reg:^Tmyrec;
   datos, mux,ncob,utile: string;
   fte,cop:Tstringlist;
   i,k:integer;
   ff,filedot:string;
begin
   screen.Cursor:=crsqlwait;
   reg:=nodo_actual.Data;
   chdir( g_tmpdir );
   fte:=Tstringlist.Create;
   mux:=reg.hnombre+'.ase';
   ncob:=reg.hnombre+'.cbl';
   copyfile(pchar(dm.xblobname(reg.hbiblioteca,reg.hnombre)),pchar(mux),false);
   g_borrar.Add(mux);
   g_borrar.Add(ncob);
   utile:='hta'+mux+'.exe';
   dm.get_utileria('RGMASE2COB',utile);
   filedot:=reg.hnombre+'.dot';
   dm.ejecuta_espera( utile+' ' +
                      mux+' '+ncob, SW_SHOW );
   g_borrar.Add(utile);
   g_borrar.Add(filedot);
   g_borrar.Add('nada');
   if fileexists(filedot)=false then begin
      showmessage('ERROR... no pudo analizar '+reg.hnombre);
      exit;
   end;
   dm.get_utileria('COMPARACION DE FUENTES',utile);
   if ShellExecute( 0, nil,pchar(utile), pchar(mux+' '+ncob),PChar( g_tmpdir), SW_SHOW )<=32 then begin
      Application.MessageBox( 'No se pudo ejecutar la aplicación',
            'Error', MB_ICONEXCLAMATION );
   end;
   screen.Cursor:=crdefault;
end;
procedure Tfarbol.referencias_cruzadas( Sender: Tobject );
var   reg:^Tmyrec;
   k:integer;
   ventana:Tmenuitem;
   titulo:string;
begin
   reg:=nodo_actual.data;
   titulo:='Referencias '+reg.hclase+' '+reg.hbiblioteca+' '+reg.hnombre;
   for k:=0 to ventanas1.Count-1 do begin
      ventana:=ventanas1.Items[k];
      if ventana.Hint=titulo then begin
         ventana1click(ventana);
         exit;
      end;
   end;
   screen.Cursor:=crsqlwait;
   k:=length(ftsrefcruz);
   setlength(ftsrefcruz,k+1);
   ftsrefcruz[k]:=Tftsrefcruz.Create(farbol);
   ftsrefcruz[k].Parent:=farbol;
   ftsrefcruz[k].left:= g_left;
   ftsrefcruz[k].top:=g_top;
   ftsrefcruz[k].Width:= g_Width;
   ftsrefcruz[k].Height:= g_Height;
   ftsrefcruz[k].Visible:=false;
   ventana:=Tmenuitem.Create(self);
   ventana.Caption:=titulo;
   ventana.Hint:=titulo;
   ventana.Tag:=k+1000;
   ventana.OnClick:=ventana1click;
   ventanas1.Add(ventana);
   ftsrefcruz[k].arma(reg.hclase,reg.hbiblioteca,reg.hnombre);
   if g_procesa then begin  //  Esto es para que no muestre la pantalla, si no tiene información.
     ftsrefcruz[k].Visible:=true;
     ftsrefcruz[k].WindowState:=wsnormal;
     if g_language='ENGLISH' then
        ftsrefcruz[k].Caption:='Cross Reference - '+reg.hclase+' '+
        reg.hbiblioteca+' '+reg.hnombre
     else
        ftsrefcruz[k].Caption:='Referencias Cruzadas - '+reg.hclase+' '+
        reg.hbiblioteca+' '+reg.hnombre;
   end else  begin
     showmessage('No Hay Información para Referencias Cruzadas');
     ventanas1.Remove(ventana);
   end;
   screen.Cursor:=crdefault;
end;
procedure Tfarbol.convertirgenexus( Sender: Tobject );  // SOLO DEMO
var   reg:^Tmyrec;
    examdiff,fuente,convertido:string;
begin
   screen.Cursor:=crsqlwait;
   reg:=nodo_actual.Data;
   examdiff:=g_ruta+'cobol2gx.bat';
//   dm.get_utileria('COMPARACION DE FUENTES',examdiff);
//   g_borrar.Add(examdiff);
   fuente:=dm.xblobname(reg.hbiblioteca,reg.hnombre);
   if pos('COBOLGX',fuente)=0 then begin
      showmessage('Libreria no catalogada para conversion');
      screen.Cursor:=crdefault;
      exit;
   end;
   convertido:=stringreplace(fuente,'COBOLGX','CNVCBL',[]);
   if ShellExecute(Handle, nil,pchar(examdiff),pchar(fuente+' '+convertido),
      nil, SW_SHOW) <= 32 then
      Application.MessageBox(pchar(dm.xlng('No puede ejecutar la conversion')),
            pchar(dm.xlng('Error')), MB_ICONEXCLAMATION);
   screen.Cursor:=crdefault;

end;
procedure Tfarbol.comparaconvertido( Sender: Tobject );
var   reg:^Tmyrec;
    examdiff,fuente,convertido:string;
begin
   screen.Cursor:=crsqlwait;
   reg:=nodo_actual.Data;
   examdiff:='hta'+formatdatetime('hhmmss',now)+'.exe';
   dm.get_utileria('COMPARACION DE FUENTES',examdiff);
   g_borrar.Add(examdiff);
   fuente:=dm.xblobname(reg.hbiblioteca,reg.hnombre);
   if pos('COBOLGX',fuente)=0 then begin
      showmessage('Libreria no catalogada para conversion');
      screen.Cursor:=crdefault;
      exit;
   end;
   convertido:=stringreplace(fuente,'COBOLGX','CNVCBL',[]);
   if ShellExecute(Handle, nil,pchar(examdiff),pchar(fuente+' '+convertido),
      nil, SW_SHOW) <= 32 then
      Application.MessageBox(pchar(dm.xlng('No puede ejecutar la comparacion')),
            pchar(dm.xlng('Error')), MB_ICONEXCLAMATION);
   screen.Cursor:=crdefault;

end;
procedure Tfarbol.convertircblunix( Sender: Tobject );
var   reg:^Tmyrec;
    rgmlang,directivas,reservadas,fuente,convertido,utile:string;
begin
   reg:=nodo_actual.Data;
   rgmlang:=g_tmpdir+'\hta15.exe';
   dm.get_utileria('RGMLANG',rgmlang);
   g_borrar.Add(rgmlang);
   directivas:=g_tmpdir+'\dircbl.dir';
   dm.get_utileria('DIRECTIVAS CNVCBLUNX',directivas);
   g_borrar.Add(directivas);
   reservadas:=g_tmpdir+'\dirnat.res';
   dm.get_utileria('RESERVADAS CNVCBLUNX',reservadas);
   g_borrar.Add(reservadas);
   fuente:=dm.xblobname(reg.hbiblioteca,reg.hnombre);
   convertido:=g_tmpdir+'\'+reg.hnombre;
   dm.ejecuta_espera(rgmlang+' '+fuente+' '+convertido+' '+directivas+' '+reservadas,
      SW_SHOW);
   utile:=g_tmpdir+'\hta16.exe';
   dm.get_utileria('COMPARACION DE FUENTES',utile);
   if ShellExecute( 0, nil,pchar(utile), pchar(fuente+' '+convertido),PChar( g_tmpdir), SW_SHOW )<=32 then begin
      Application.MessageBox( 'No se pudo ejecutar la aplicación',
            'Error', MB_ICONEXCLAMATION );
   end;

end;
procedure Tfarbol.convertirnatural( Sender: Tobject );
var   reg:^Tmyrec;
    rgmlang,directivas,reservadas,fuente,convertido:string;
begin
   reg:=nodo_actual.Data;
   {
   rgmlang:=g_tmpdir+'\hta11.exe';
   dm.get_utileria('RGMLANG2',rgmlang);
   g_borrar.Add(rgmlang);
   directivas:=g_tmpdir+'\dirnat.dir';
   dm.get_utileria('DIRECTIVAS CNVNATCOB',directivas);
   g_borrar.Add(directivas);
   reservadas:=g_tmpdir+'\dirnat.res';
   dm.get_utileria('RESERVADAS CNVNATCOB',reservadas);
   g_borrar.Add(reservadas);
   fuente:=dm.xblobname(reg.hbiblioteca,reg.hnombre);
   convertido:=g_tmpdir+'\'+reg.hnombre;
   if ShellExecute(Handle, nil,pchar(rgmlang),
      pchar(fuente+' '+convertido+' '+directivas+' '+reservadas),
      nil, SW_SHOW) <= 32 then
      Application.MessageBox(pchar(dm.xlng('No puede ejecutar la conversion')),
            pchar(dm.xlng('Error')), MB_ICONEXCLAMATION);
   }
   if ShellExecute(Handle, nil,pchar(g_ruta+'\nat2cob\cnv.bat'),
      pchar(reg.hnombre+' '+reg.hbiblioteca),
      nil, SW_SHOW) <= 32 then
      Application.MessageBox(pchar(dm.xlng('No puede ejecutar la conversion')),
            pchar(dm.xlng('Error')), MB_ICONEXCLAMATION);

end;
procedure Tfarbol.convertirngl( Sender: Tobject );
var   reg:^Tmyrec;
    rgmlang,directivas,directivas2,fuente,convertido,examdiff:string;
begin
   screen.Cursor:=crsqlwait;
   reg:=nodo_actual.Data;
   rgmlang:=g_tmpdir+'\hta11.exe';
   dm.get_utileria('RGMLANG',rgmlang);
   g_borrar.Add(rgmlang);
   directivas:=g_tmpdir+'\dirngl1.dir';
   dm.get_utileria('DIRECTIVAS RGMCNVNATNGLVSAM',directivas);
   g_borrar.Add(directivas);
   directivas2:=g_tmpdir+'\dirnat2.dir';
   dm.get_utileria('DIRECTIVAS RGMCNVNATNGLVSAM2',directivas2);
   g_borrar.Add(directivas2);
   fuente:=dm.xblobname(reg.hbiblioteca,reg.hnombre);
   convertido:=g_tmpdir+'\'+reg.hnombre;
   dm.ejecuta_espera(rgmlang+' ' +fuente+' nada '+directivas, SW_SHOW );
   dm.ejecuta_espera(rgmlang+' nada '+convertido+' '+directivas2, SW_SHOW );
   examdiff:=g_tmpdir+'\hta'+formatdatetime('hhmmss',now)+'.exe';
   dm.get_utileria('COMPARACION DE FUENTES',examdiff);
   g_borrar.Add(examdiff);
   if ShellExecute(Handle, nil,pchar(examdiff),pchar(fuente+' '+convertido),
      nil, SW_SHOW) <= 32 then
      Application.MessageBox(pchar(dm.xlng('No puede ejecutar la comparacion')),
            pchar(dm.xlng('Error')), MB_ICONEXCLAMATION);
   screen.Cursor:=crdefault;

end;
procedure Tfarbol.comparanatural_cobol( Sender: Tobject );
var   reg:^Tmyrec;
    examdiff,fuente,convertido:string;
begin
   screen.Cursor:=crsqlwait;
   reg:=nodo_actual.Data;
   examdiff:='hta'+formatdatetime('hhmmss',now)+'.exe';
   dm.get_utileria('COMPARACION DE FUENTES',examdiff);
   g_borrar.Add(examdiff);
   fuente:=dm.xblobname(reg.hbiblioteca,reg.hnombre);
   convertido:=g_ruta+'\nat2cob\'+reg.hnombre+'.cob';
   if ShellExecute(Handle, nil,pchar(examdiff),pchar(fuente+' '+convertido),
      nil, SW_SHOW) <= 32 then
      Application.MessageBox(pchar(dm.xlng('No puede ejecutar la comparacion')),
            pchar(dm.xlng('Error')), MB_ICONEXCLAMATION);
   screen.Cursor:=crdefault;

end;
procedure Tfarbol.convertirnat_panta( Sender: Tobject );
var   reg:^Tmyrec;
    rgmlang,directivas,reservadas,fuente,convertido:string;
begin
   screen.Cursor:=crsqlwait;
   reg:=nodo_actual.Data;
   rgmlang:=g_tmpdir+'\hta11.exe';
   dm.get_utileria('RGMLANG',rgmlang);
   g_borrar.Add(rgmlang);
   directivas:=g_tmpdir+'\dirnat.dir';
   dm.get_utileria('DIRECTIVAS CNVNATCOB',directivas);
   g_borrar.Add(directivas);
   reservadas:=g_tmpdir+'\natural_cnv.res';
   dm.get_utileria('RESERVADAS CNVNATCOB',reservadas);
   g_borrar.Add(reservadas);
   fuente:=dm.xblobname(reg.hbiblioteca,reg.hnombre);
   convertido:=g_tmpdir+'\'+reg.hnombre;
   if ShellExecute(Handle, nil,pchar(rgmlang),
      pchar(fuente+' '+convertido+' '+directivas+' '+reservadas),
      nil, SW_SHOW) <= 32 then
      Application.MessageBox(pchar(dm.xlng('No puede ejecutar la conversion')),
            pchar(dm.xlng('Error')), MB_ICONEXCLAMATION);
   screen.Cursor:=crdefault;

end;
procedure Tfarbol.convertirnat_ddm( Sender: Tobject );
var   reg:^Tmyrec;
    rgmlang,directivas,reservadas,fuente,convertido:string;
begin
   screen.Cursor:=crsqlwait;
   reg:=nodo_actual.Data;
   rgmlang:=g_tmpdir+'\hta11.exe';
   dm.get_utileria('RGMLANG',rgmlang);
   g_borrar.Add(rgmlang);
   directivas:=g_tmpdir+'\dirnat.dir';
   dm.get_utileria('DIRECTIVAS CNVNATDDM',directivas);
   g_borrar.Add(directivas);
   fuente:=dm.xblobname(reg.hbiblioteca,reg.hnombre);
   convertido:=g_tmpdir+'\'+reg.hnombre;
   dm.ejecuta_espera(rgmlang+' ' +fuente+' nada '+directivas+' > '+convertido, SW_HIDE );
   screen.Cursor:=crdefault;
end;

procedure Tfarbol.comparanatural_cics( Sender: Tobject );
var   reg:^Tmyrec;
    examdiff,fuente,convertido:string;
begin
   screen.Cursor:=crsqlwait;
   reg:=nodo_actual.Data;
   examdiff:='hta'+formatdatetime('hhmmss',now)+'.exe';
   dm.get_utileria('COMPARACION DE FUENTES',examdiff);
   g_borrar.Add(examdiff);
   fuente:=dm.xblobname(reg.hbiblioteca,reg.hnombre);
   convertido:=g_tmpdir+'\'+reg.hnombre;
   if ShellExecute(Handle, nil,pchar(examdiff),pchar(fuente+' '+convertido),
      nil, SW_SHOW) <= 32 then
      Application.MessageBox(pchar(dm.xlng('No puede ejecutar la comparacion')),
            pchar(dm.xlng('Error')), MB_ICONEXCLAMATION);
   screen.Cursor:=crdefault;

end;
procedure Tfarbol.comparanatural_ddm( Sender: Tobject );
var   reg:^Tmyrec;
    examdiff,fuente,convertido:string;
begin
   screen.Cursor:=crsqlwait;
   reg:=nodo_actual.Data;
   examdiff:='hta'+formatdatetime('hhmmss',now)+'.exe';
   dm.get_utileria('COMPARACION DE FUENTES',examdiff);
   g_borrar.Add(examdiff);
   fuente:=dm.xblobname(reg.hbiblioteca,reg.hnombre);
   convertido:=g_tmpdir+'\'+reg.hnombre;
   if ShellExecute(Handle, nil,pchar(examdiff),pchar(fuente+' '+convertido),
      nil, SW_SHOW) <= 32 then
      Application.MessageBox(pchar(dm.xlng('No puede ejecutar la comparacion')),
            pchar(dm.xlng('Error')), MB_ICONEXCLAMATION);
   screen.Cursor:=crdefault;

end;
procedure Tfarbol.convertirnat_fdt( Sender: Tobject );
var   reg:^Tmyrec;
    rgmlang,directivas,reservadas,fuente,convertido:string;
begin
   screen.Cursor:=crsqlwait;
   reg:=nodo_actual.Data;
   rgmlang:=g_tmpdir+'\hta11.exe';
   dm.get_utileria('RGMLANG',rgmlang);
   g_borrar.Add(rgmlang);
   directivas:=g_tmpdir+'\dirnat.dir';
   dm.get_utileria('DIRECTIVAS CNVNATFPT',directivas);
   g_borrar.Add(directivas);
   fuente:=dm.xblobname(reg.hbiblioteca,reg.hnombre);
   convertido:=g_tmpdir+'\'+reg.hnombre;
   dm.ejecuta_espera(rgmlang+' ' +fuente+' nada '+directivas+' > '+convertido, SW_HIDE );
   screen.Cursor:=crdefault;
end;

procedure Tfarbol.comparanatural_fdt( Sender: Tobject );
var   reg:^Tmyrec;
    examdiff,fuente,convertido:string;
begin
   screen.Cursor:=crsqlwait;
   reg:=nodo_actual.Data;
   examdiff:='hta'+formatdatetime('hhmmss',now)+'.exe';
   dm.get_utileria('COMPARACION DE FUENTES',examdiff);
   g_borrar.Add(examdiff);
   fuente:=dm.xblobname(reg.hbiblioteca,reg.hnombre);
   convertido:=g_tmpdir+'\'+reg.hnombre;
   if ShellExecute(Handle, nil,pchar(examdiff),pchar(fuente+' '+convertido),
      nil, SW_SHOW) <= 32 then
      Application.MessageBox(pchar(dm.xlng('No puede ejecutar la comparacion')),
            pchar(dm.xlng('Error')), MB_ICONEXCLAMATION);
   screen.Cursor:=crdefault;

end;
procedure Tfarbol.convertirnat_nmp( Sender: Tobject );
var   reg:^Tmyrec;
    rgmlang,directivas,reservadas,fuente,convertido:string;
    xa,xb:Tstringlist;
    i:integer;
begin
   screen.Cursor:=crsqlwait;
   reg:=nodo_actual.Data;
   rgmlang:=g_tmpdir+'\hta11.exe';
   dm.get_utileria('RGMLANG',rgmlang);
   g_borrar.Add(rgmlang);
   directivas:=g_tmpdir+'\dirnat.dir';
   dm.get_utileria('DIRECTIVAS CNVNATNMP',directivas);
   g_borrar.Add(directivas);
   fuente:=dm.xblobname(reg.hbiblioteca,reg.hnombre);
   convertido:=g_tmpdir+'\'+reg.hnombre;
   dm.ejecuta_espera(rgmlang+' ' +fuente+' '+convertido+' '+directivas+' > '+convertido+'.cpy', SW_HIDE );
   dm.ejecuta_espera(rgmlang+' ' +fuente+' '+convertido+' '+directivas+' > '+convertido+'.cpy', SW_HIDE );
   xa:=Tstringlist.Create;
   xb:=Tstringlist.Create;
   xa.LoadFromFile(convertido+'.cpy');
   i:=0;
   while i<xa.Count do begin
      if copy(xa[i],1,1)='2' then begin
         xb.Add(xa[i]);
         xa.Delete(i);
      end
      else
         inc(i);
   end;
   xa.AddStrings(xb);
   xa.SaveToFile(convertido+'.txt');
   xa.Free;
   xb.Free;
   screen.Cursor:=crdefault;
end;

procedure Tfarbol.comparanatural_nmp( Sender: Tobject );
var   reg:^Tmyrec;
    examdiff,fuente,convertido:string;
begin
   screen.Cursor:=crsqlwait;
   reg:=nodo_actual.Data;
   examdiff:='hta'+formatdatetime('hhmmss',now)+'.exe';
   dm.get_utileria('COMPARACION DE FUENTES',examdiff);
   g_borrar.Add(examdiff);
   fuente:=dm.xblobname(reg.hbiblioteca,reg.hnombre);
   convertido:=g_tmpdir+'\'+reg.hnombre;
   if ShellExecute(Handle, nil,pchar(examdiff),pchar(fuente+' '+convertido),
      nil, SW_SHOW) <= 32 then
      Application.MessageBox(pchar(dm.xlng('No puede ejecutar la comparacion')),
            pchar(dm.xlng('Error')), MB_ICONEXCLAMATION);
   if ShellExecute(Handle, nil,pchar(convertido+'.txt'),nil,
      nil, SW_SHOW) <= 32 then
      Application.MessageBox(pchar(dm.xlng('No puede mostrar el copy')),
            pchar(dm.xlng('Error')), MB_ICONEXCLAMATION);
   screen.Cursor:=crdefault;

end;
procedure Tfarbol.metricas_codepro(Sender: TObject); // sin liberar
var   reg:^Tmyrec;
      archivo:string;
begin
   reg:=nodo_actual.Data;
   archivo:='c:\componentes_source\codepro_metricas\'+reg.hnombre+'.html';
   if ShellExecute( 0, nil,pchar(archivo), nil,nil, SW_SHOW )<=32 then begin
      Application.MessageBox( 'No se pudo ejecutar la aplicación',
            'Error', MB_ICONEXCLAMATION );
   end;
end;
procedure Tfarbol.dependencias_codepro(Sender: TObject); // sin liberar
var   reg:^Tmyrec;
      archivo:string;
begin
   reg:=nodo_actual.Data;
   archivo:='c:\componentes_source\codepro_dependencias\'+reg.hnombre+'.mht';
   if ShellExecute( 0, nil,pchar(archivo), nil,nil, SW_SHOW )<=32 then begin
      Application.MessageBox( 'No se pudo ejecutar la aplicación',
            'Error', MB_ICONEXCLAMATION );
   end;
end;

procedure Tfarbol.tvMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
   HT: THitTests;
   reg:^Tmyrec;
   k:integer;
   panta:Tfsvsdelphi;
begin
   HT:=tv.GetHitTestInfoAt( X, Y );
   if not (htOnItem in HT)  then exit;
   nodo_actual:=tv.GetNodeAt( X, Y );
   nodo_actual.Selected:=true;
   pop.Items.Clear;
   reg:=nodo_actual.Data;
//   if pos('(CICLADO)',reg.hnombre)>0 then exit;
   if reg.hclase='EMPRESA' then begin
      if g_language='ENGLISH' then
         agrega_al_menu('Company : '+nodo_actual.Text)
      else
         agrega_al_menu('Empresa : '+nodo_actual.Text);
      agrega_al_menu('-');
   end
   else
   if reg.hclase='OFICINA' then begin
      if g_language='ENGLISH' then
         agrega_al_menu('Office : '+nodo_actual.Text)
      else
         agrega_al_menu('Oficina : '+nodo_actual.Text);
      agrega_al_menu('-');
   end
   else
   if reg.hclase='SISTEMA' then begin
      if g_language='ENGLISH' then
         agrega_al_menu('Application : '+nodo_actual.Text)
      else
         agrega_al_menu('Sistema : '+nodo_actual.Text);
      agrega_al_menu('-');
      if fileexists('c:\componentes_source\codepro_metricas\'+reg.hnombre+'.html') then begin
         k:=agrega_al_menu('Métricas CODEPRO');
         pop.Items[k].OnClick:=metricas_codepro;
      end;
      if fileexists('c:\componentes_source\codepro_dependencias\'+reg.hnombre+'.mht') then begin
         k:=agrega_al_menu('Dependencias CODEPRO');
         pop.Items[k].OnClick:=dependencias_codepro;
      end;
   end
   else
   if reg.hclase='CLA' then begin
      if g_language='ENGLISH' then
         agrega_al_menu('Class : '+nodo_actual.Text)
      else
         agrega_al_menu('Clase : '+nodo_actual.Text);
      agrega_al_menu('-');
   end
   else
   if reg.hclase='USER' then begin
      if g_language='ENGLISH' then
         agrega_al_menu('My Projects : '+nodo_actual.Text)
      else
         agrega_al_menu('Mis Proyectos : '+nodo_actual.Text);
      agrega_al_menu('-');
      k:=agrega_al_menu('Nuevo Proyecto');
      pop.Items[k].OnClick:=nuevo_proyecto;
   end
   else begin     // Delphi                             
      if reg.hclase='DFX' then begin
      end
      else begin

         if (reg.hclase='ETP') and (reg.pclase='BAS') then begin
            if dm.sqlselect(dm.q1,'select * from tsrela '+
               ' where hcprog='+g_q+reg.hnombre+g_q+
               ' and   hcbib='+g_q+reg.hbiblioteca+g_q+
               ' and   hcclase='+g_q+reg.hclase+g_q+
               ' and   pcclase='+g_q+'BAS'+g_q) then begin
               if dm.sqlselect(dm.q2,'select * from tsprog '+
                  ' where cprog='+g_q+dm.q1.fieldbyname('pcprog').AsString+g_q+
                  ' and   cbib='+g_q+dm.q1.fieldbyname('pcbib').AsString+g_q+
                  ' and   cclase='+g_q+dm.q1.fieldbyname('pcclase').AsString+g_q) then begin
                  memo.Lines.Clear;
                  dm.trae_fuente(dm.q1.fieldbyname('pcprog').AsString,
                                 dm.q1.fieldbyname('pcbib').AsString,memo);
                  if memo.Lines.Count > 0 then begin
                     aisla_rutina_Visual_Basic(reg.hnombre);
                     farbol.Image1.Visible:=false;
                     farbol.Label1.Visible:=false;
                     farbol.Label2.Visible:=false;
                     farbol.Memo.Visible:=true;
                  end else begin
                     farbol.Image1.Visible:=true;
                     farbol.Label1.Visible:=true;
                     farbol.Label2.Visible:=true;
                     farbol.Memo.Visible:=false;
                  end;

               end;
            end;
         end
      else
      if reg.hclase='DFY' then begin
         if dm.sqlselect(dm.q1,'select * from tsrela '+
            ' where hcprog='+g_q+reg.hnombre+g_q+
            ' and   hcbib='+g_q+reg.hbiblioteca+g_q+
            ' and   hcclase='+g_q+reg.hclase+g_q+
            ' and   pcclase='+g_q+'PAS'+g_q) then begin
            if dm.sqlselect(dm.q2,'select * from tsprog '+
               ' where cprog='+g_q+dm.q1.fieldbyname('pcprog').AsString+g_q+
               ' and   cbib='+g_q+dm.q1.fieldbyname('pcbib').AsString+g_q+
               ' and   cclase='+g_q+dm.q1.fieldbyname('pcclase').AsString+g_q) then begin
               dm.blob2memo(dm.q2.fieldbyname('cblob').AsString,memo);
               aisla_rutina_delphi(reg.hnombre);
                  if memo.Lines.Count > 0 then begin
                     farbol.Image1.Visible:=false;
                     farbol.Label1.Visible:=false;
                     farbol.Label2.Visible:=false;
                     farbol.Memo.Visible:=true;
                  end else begin
                     farbol.Image1.Visible:=true;
                     farbol.Label1.Visible:=true;
                     farbol.Label2.Visible:=true;
                     farbol.Memo.Visible:=false;
                  end;
            end;
         end;
      end
      else
      if clase_fisico.IndexOf(reg.hclase)>-1 then begin
         {
            if dm.sqlselect(dm.q2,'select * from tsprog '+
               ' where cprog='+g_q+reg.hnombre+g_q+
               ' and   cbib='+g_q+reg.hbiblioteca+g_q+
               ' and   cclase='+g_q+reg.hclase+g_q) then begin
                dm.blob2memo(dm.q2.fieldbyname('cblob').AsString,memo);
            end;
         }
         if memo_componente<>reg.hnombre+'_'+reg.hbiblioteca then begin
            memo.Lines.Clear;
             dm.trae_fuente(reg.hnombre,reg.hbiblioteca,memo);
//               if pos(chr(13)+chr(10),memo.Text)=0 then begin      // corrige cuando el fuente no tiene CR
//                  memo.Text:=stringreplace(memo.Text,chr(10),chr(13)+chr(10),[rfreplaceall]);
                  farbol.Image1.Visible:=false;
                  farbol.Label1.Visible:=false;
                  farbol.Label2.Visible:=false;
                  farbol.Memo.Visible:=true;
                  if memo.Lines.Count > 0 then begin
                     farbol.Image1.Visible:=false;
                     farbol.Label1.Visible:=false;
                     farbol.Label2.Visible:=false;
                     farbol.Memo.Visible:=true;
                  end else begin
                     farbol.Image1.Visible:=true;
                     farbol.Label1.Visible:=true;
                     farbol.Label2.Visible:=true;
                     farbol.Memo.Visible:=false;
                  end;
                  memo_componente:=reg.hnombre+'_'+reg.hbiblioteca;
//               end;
         end;
         {
         if dm.capacidad('Acceso local') then begin
            dm.trae_fuente(reg.hnombre,reg.hbiblioteca,memo);
//            if fileexists(dm.pathbib(reg.hbiblioteca)+'\'+reg.hnombre) then
//               memo.Lines.LoadFromFile(dm.pathbib(reg.hbiblioteca)+'\'+reg.hnombre);
         end
         else
            memo.Lines.Text:=(htt as IsvsServer).getTxt('svsget,'+reg.hclase+','+reg.hbiblioteca+','+reg.hnombre);
         }
         agrega_al_menu(clase_descripcion[clase_fisico.IndexOf(reg.hclase)]+' - '+nodo_actual.Text);
         agrega_al_menu('-');
      end;
   end;
   end;

   if (reg.hclase='NVW') or
      (reg.hclase='NIN') or
      (reg.hclase='NUP') or
      (reg.hclase='NDL') then begin
      if g_language='ENGLISH' then
         k:=agrega_al_menu('CRUD ADABAS')
      else
         k:=agrega_al_menu('ADABAS CRUD');
      pop.Items[k].OnClick:=adabas_crud;
   end;
   if reg.hclase<>'USERPRO' then begin
      if g_language='ENGLISH' then
         k:=agrega_al_menu('Impact Analysis')
      else
         k:=agrega_al_menu('Analisis de Impacto');
      pop.Items[k].OnClick:=analisis_impacto;
   end;
   if (reg.pclase='USERPRO') or
      (reg.pclase='CONSULTA') or
      ((reg.hclase='USERPRO') and (nodo_actual.HasChildren=false)) then begin
      if g_language='ENGLISH' then
         k:=agrega_al_menu('Delete Item')
      else
         k:=agrega_al_menu('Borrar Item');
      pop.Items[k].OnClick:=borrar_item;
   end;
   if dm.capacidad('Cambio de iconos Arbol') then begin
      if g_language='ENGLISH' then
         k:=agrega_al_menu('Change Icon')
      else
         k:=agrega_al_menu('Cambio de Icono');
      pop.Items[k].OnClick:=cambia_icono;
   end;
{   if reg.hclase='NDM' then begin   // Mapa Natural
      if dm.capacidad('NDM - Convertir a DB2') then begin
         if g_language='ENGLISH' then
            k:=agrega_al_menu('Convert to DB2')
         else
            k:=agrega_al_menu('Convertir a DB2');
         pop.Items[k].OnClick:=convertirnat_ddm;
         if g_language='ENGLISH' then
            k:=agrega_al_menu('Compare with DB2')
         else
            k:=agrega_al_menu('Comparar con DB2');
         pop.Items[k].OnClick:=comparanatural_ddm;
      end;
   end;
   if reg.hclase='NFP' then begin   // FPT Natural
      if dm.capacidad('NFP - Convertir a DB2') then begin
         if g_language='ENGLISH' then
            k:=agrega_al_menu('Convert to DB2')
         else
            k:=agrega_al_menu('Convertir a DB2');
         pop.Items[k].OnClick:=convertirnat_fdt;
         if g_language='ENGLISH' then
            k:=agrega_al_menu('Compare with DB2')
         else
            k:=agrega_al_menu('Comparar con DB2');
         pop.Items[k].OnClick:=comparanatural_fdt;
      end;
   end;
   if (reg.hclase='NGL') or (reg.hclase='NLC') then begin
      if dm.capacidad('NGL - Convertir a Cobol') then begin
         if g_language='ENGLISH' then
            k:=agrega_al_menu('Convert to Cobol')
         else
            k:=agrega_al_menu('Convertir a Cobol');
         pop.Items[k].OnClick:=convertirngl;
      end;
   end;   }
   if (reg.hclase='NAT') or
      (reg.hclase='NSP') or
      (reg.hclase='NSR') or
      (reg.hclase='NHL') then begin
      if g_language='ENGLISH' then
         k:=agrega_al_menu('Flowchart')
      else
         k:=agrega_al_menu('Diagrama de Flujo');
      pop.Items[k].OnClick:=diagramanatural;
{      if dm.capacidad('NAT - Convertir a Cobol') then begin
         if g_language='ENGLISH' then
            k:=agrega_al_menu('Convert to Cobol')
         else
            k:=agrega_al_menu('Convertir a Cobol');
         pop.Items[k].OnClick:=convertirnatural;
         if g_language='ENGLISH' then
            k:=agrega_al_menu('Compare with Cobol Converted')
         else
            k:=agrega_al_menu('Comparar con Convertido Cobol');
         pop.Items[k].OnClick:=comparanatural_cobol;
      end;   }
   end;
   if reg.hclase='CBL' then begin
      if g_language='ENGLISH' then
         k:=agrega_al_menu('Flowchart')
      else
         k:=agrega_al_menu('Diagrama de Flujo');
      pop.Items[k].OnClick:=diagramacbl;
{      if dm.capacidad('CBL - Convertir a GENEXUS') then begin
         if g_language='ENGLISH' then
            k:=agrega_al_menu('Convert to Genexus')
         else
            k:=agrega_al_menu('Convertir a Genexus');
         pop.Items[k].OnClick:=convertirgenexus;
         if g_language='ENGLISH' then
            k:=agrega_al_menu('Compare with Genexus Converted')
         else
            k:=agrega_al_menu('Comparar con Convertido Genexus');
         pop.Items[k].OnClick:=comparaconvertido;
      end;
      if dm.capacidad('CBL - Convertir a UNIX') then begin
         if g_language='ENGLISH' then
            k:=agrega_al_menu('Convert to UNIX')
         else
            k:=agrega_al_menu('Convertir a UNIX');
         pop.Items[k].OnClick:=convertircblunix;
         if g_language='ENGLISH' then
            k:=agrega_al_menu('Compare with Genexus Converted')
         else
            k:=agrega_al_menu('Comparar con Convertido Genexus');
         pop.Items[k].OnClick:=comparaconvertido;
      end; }
   end;
   if reg.hclase='JAV' then begin
      if g_language='ENGLISH' then
         k:=agrega_al_menu('Flowchart')
      else
         k:=agrega_al_menu('Diagrama de Flujo');
//      pop.Items[k].OnClick:=diagramajava;
      pop.Items[k].OnClick:=dghtml;
   end;
   if reg.hclase='CLP' then begin
      if g_language='ENGLISH' then
         k:=agrega_al_menu('Flowchart')
      else
         k:=agrega_al_menu('Diagrama de Flujo');
      pop.Items[k].OnClick:=diagramarpg;
   end;
   if (reg.hclase='JOB') or
      (reg.hclase='JCL') then begin
      if g_language='ENGLISH' then
         k:=agrega_al_menu('Flowchart')
      else
         k:=agrega_al_menu('Diagrama de Flujo');
      pop.Items[k].OnClick:=diagramajcl;
   end;
   if (reg.hclase='ASE') then begin
      if g_language='ENGLISH' then
         k:=agrega_al_menu('Flowchart')
      else
         k:=agrega_al_menu('Diagrama de Flujo');
      pop.Items[k].OnClick:=diagramaase;
{      if g_language='ENGLISH' then
         k:=agrega_al_menu('Convert to Cobol')
      else
         k:=agrega_al_menu('Convertir a Cobol');
      pop.Items[k].OnClick:=conviertease2cob;    }
   end;
   if g_language='ENGLISH' then
      k:=agrega_al_menu('Documentation')
   else
      k:=agrega_al_menu('Documentación');
   pop.Items[k].OnClick:=reglas_negocio;
   if clase_analizable.IndexOf(reg.hclase)>-1 then begin
      if g_language='ENGLISH' then
         k:=agrega_al_menu('Parts List')
      else
         k:=agrega_al_menu('Lista de Componentes');
      pop.Items[k].OnClick:=lista_componentes;
   end;
   if (reg.hclase='TAB') or
      (reg.hclase='INS') or
      (reg.hclase='UPD') or
      (reg.hclase='DEL') then begin
      if g_language='ENGLISH' then
         k:=agrega_al_menu('CRUD Table')
      else
         k:=agrega_al_menu('Matriz CRUD');
      pop.Items[k].OnClick:=tabla_crud;
   end;
   if clase_analizable.IndexOf(reg.hclase)>-1 then begin
      if g_language='ENGLISH' then
         k:=agrega_al_menu('Properties')
      else
         k:=agrega_al_menu('Propiedades');
      pop.Items[k].OnClick:=propiedades;
   end;

   if reg.hbiblioteca <> 'BD' then begin
      if g_language='ENGLISH' then
         k:=agrega_al_menu('Cross Reference')
      else
         k:=agrega_al_menu('Referencias Cruzadas');
      pop.Items[k].OnClick:=referencias_cruzadas;
   end;

   if clase_fisico.IndexOf(reg.hclase)>-1 then begin
      if g_language='ENGLISH' then
         k:=agrega_al_menu('Versions')
      else
         k:=agrega_al_menu('Versiones');
      pop.Items[k].OnClick:=versionado;
   end;
   if reg.hclase='FMB' then begin // Pantalla de SQLFORMS
      if g_language='ENGLISH' then
         k:=agrega_al_menu('Screen View')
      else
         k:=agrega_al_menu('Vista Pantalla');
      pop.Items[k].OnClick:=fmb_vista_pantalla;
      fmb_nombre_pantalla:=dm.pathbib(reg.hbiblioteca)+'\'+reg.hnombre+'.txt';
   end;
   if reg.hclase='DFM' then begin
      if g_language='ENGLISH' then
         k:=agrega_al_menu('Preview')
      else
         k:=agrega_al_menu('Vista Previa');
      pop.Items[k].OnClick:=formadelphi_preview;
   end;
   if reg.hclase='BFR' then begin  // Forma Visual Basic
      if g_language='ENGLISH' then
         k:=agrega_al_menu('Preview')
      else
         k:=agrega_al_menu('Vista Previa');
      pop.Items[k].OnClick:=formavb_preview;
   end;
   if reg.hclase='PNL' then begin     // Panel IDEAL
      if g_language='ENGLISH' then
         k:=agrega_al_menu('Preview')
      else
         k:=agrega_al_menu('Vista Previa');
      pop.Items[k].OnClick:=panel_preview;
   end;
   if reg.hclase='BMS' then begin     // Pantalla CICS
      if g_language='ENGLISH' then
         k:=agrega_al_menu('Preview')
      else
         k:=agrega_al_menu('Vista Previa');
      pop.Items[k].OnClick:=bms_preview;
   end;
   if reg.hclase='NMP' then begin   // Mapa Natural
      if g_language='ENGLISH' then
         k:=agrega_al_menu('Preview')
      else
         k:=agrega_al_menu('Vista Previa');
      pop.Items[k].OnClick:=natural_mapa_preview;
{      if dm.capacidad('NMP - Convertir a CICS BMS') then begin
         if g_language='ENGLISH' then
            k:=agrega_al_menu('Convert to CICS BMS')
         else
            k:=agrega_al_menu('Convertir a CICS BMS');
         pop.Items[k].OnClick:=convertirnat_nmp;
         if g_language='ENGLISH' then
            k:=agrega_al_menu('Compare with CICS BMS')
         else
            k:=agrega_al_menu('Comparar con CICS BMS');
         pop.Items[k].OnClick:=comparanatural_nmp;
      end;     }
   end;
end;
procedure Tfarbol.expande(nodo:Ttreenode; nombre:string; bib:string;
                  clase:string; veces:integer);
var qq,qq2:TADOQuery;
   nodx,nody:Ttreenode;
   reg:^Tmyrec;
   bexiste:boolean;
   descri:string;
begin
   qq:=TADOQuery.Create(self);
   qq.Connection:=dm.q1.Connection;
   qq2:=TADOQuery.Create(self);
   qq2.Connection:=dm.q1.Connection;
   if dm.sqlselect(qq,'select * from tsrela '+
         ' where pcprog='+g_q+nombre+g_q+
         ' and pcbib='+g_q+bib+g_q+
         ' and pcclase='+g_q+clase+g_q+
         ' order by orden,hcclase,hcbib,hcprog') then begin
      while not qq.Eof do begin
         bexiste:=false;                   // Checa que no se cicle el arbol
         if (qq.fieldbyname('hcclase').AsString=clase) and
            (qq.fieldbyname('hcbib').AsString=bib) and
            (qq.fieldbyname('hcprog').AsString=nombre) then
            bexiste:=true
         else begin
            nody:=nodo;
            while nody.Parent<>nil do begin
               nody:=nody.Parent;
               reg:=nody.Data;
               if (reg.pnombre=nombre) and
                  (reg.pbiblioteca=bib) and
                  (reg.pclase=clase) then begin
                  bexiste:=true;
                  break;
               end;
            end;
         end;
         descri:=qq.fieldbyname('hcclase').AsString+' '+
                 qq.fieldbyname('hcbib').AsString+' '+
                 qq.fieldbyname('hcprog').AsString;
         if qq.fieldbyname('coment').Asstring<>'' then
            descri:=descri+' ['+qq.fieldbyname('coment').Asstring+']';
         nodx:=tv.Items.AddChild(nodo,descri);
         reg:=nodo.Data;
         reg.hijo_falso:=false;
         new(reg);
         reg.pnombre:=nombre;
         reg.pbiblioteca:=bib;
         reg.pclase:=clase;
         reg.hnombre:=qq.fieldbyname('hcprog').AsString;
         reg.hbiblioteca:=qq.fieldbyname('hcbib').AsString;
         reg.hclase:=qq.fieldbyname('hcclase').AsString;
         reg.hijo_falso:=false;
         nodx.Data:=reg;
         nodx.ImageIndex:=dm.lclases.IndexOf(reg.hclase);
         nodx.SelectedIndex:=0;
         if bexiste then begin
            nodx.Text:=nodx.Text+' (CICLADO)';
         end
         else begin
            if veces>0 then begin
               expande(nodx,qq.fieldbyname('hcprog').AsString,
                            qq.fieldbyname('hcbib').AsString,
                            qq.fieldbyname('hcclase').AsString,veces-1);
            end
            else begin
               if dm.sqlselect(qq2,'select count(*) total from tsrela '+
                  ' where pcprog='+g_q+qq.fieldbyname('hcprog').AsString+g_q+
                  ' and pcbib='+g_q+qq.fieldbyname('hcbib').AsString+g_q+
                  ' and pcclase='+g_q+qq.fieldbyname('hcclase').AsString+g_q) then begin
                  if (qq2.FieldByName('total').AsInteger>0) and
                     (qq2.FieldByName('total').AsInteger<500) then begin
                     reg.hijo_falso:=true;
                     nody:=tv.Items.AddChild(nodx,'hijo falso');
                  end;
               end;
            end;
         end;
         qq.Next;
      end;
   end;
   qq.free;
   qq2.Free;
end;
procedure Tfarbol.tvExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
var   reg:^Tmyrec;
      Save_Cursor:TCursor;
begin
   reg:=node.Data;
   if reg.hijo_falso then begin
      Save_Cursor := Screen.Cursor;
      Screen.Cursor := crHourGlass;    { Show hourglass cursor }
      try
         node.DeleteChildren;
         expande(node,reg.hnombre,reg.hbiblioteca,reg.hclase,1);
      finally
         Screen.Cursor := Save_Cursor;  { Always restore to normal }
      end;
   end;
end;

procedure Tfarbol.WtvExpanding(Node: TTreeNode);
var   reg:^Tmyrec;
      Save_Cursor:TCursor;
begin
   reg:=node.Data;
//   if reg.hijo_falso then begin
      Save_Cursor := Screen.Cursor;
      Screen.Cursor := crHourGlass;    { Show hourglass cursor }
      try
         node.DeleteChildren;
         expande(node,reg.hnombre,reg.hbiblioteca,reg.hclase,1);
      finally
         Screen.Cursor := Save_Cursor;  { Always restore to normal }
      end;
//   end;
end;


procedure Tfarbol.Notepad1Click(Sender: TObject);
var nombre:string;
begin
   memo.Visible:=true;
   nombre:=g_tmpdir+tv.Selected.Text+'_'+formatdatetime('YYYYMMDDHHnnSS',now)+'.txt';
   memo.Lines.SaveToFile(nombre);
   ShellExecute(Handle, 'open', pchar(nombre), nil, nil, SW_SHOW);
   g_borrar.Add(nombre);
end;

procedure Tfarbol.popmemoPopup(Sender: TObject);
begin
   if tv.Selected=nil then exit;
   inherited;
end;
procedure Tfarbol.tabla_crud(Sender: TObject);
var reg:^Tmyrec;
   k:integer;
   ventana:Tmenuitem;
   titulo:string;
begin
   reg:=nodo_actual.data;
   titulo:='Tabla '+reg.hclase+' '+reg.hbiblioteca+' '+reg.hnombre;
   for k:=0 to ventanas1.Count-1 do begin
      ventana:=ventanas1.Items[k];
      if ventana.Hint=titulo then begin
         ventana1click(ventana);
         exit;
      end;
   end;
   screen.Cursor:=crsqlwait;
   k:=length(ftstablas);
   setlength(ftstablas,k+1);
   ftstablas[k]:=Tftstablas.Create(farbol);
   ftstablas[k].Parent:=farbol;
   ftstablas[k].left:= g_left;
   ftstablas[k].top:=g_top;
   ftstablas[k].Width:= g_Width;
   ftstablas[k].Height:= g_Height;
   ftstablas[k].Visible:=true;
   ventana:=Tmenuitem.Create(self);
   ventana.Caption:=titulo;
   ventana.Hint:=titulo;
   ventana.Tag:=k+5000;
   ventana.OnClick:=ventana1click;
   ventanas1.Add(ventana);
   if g_language='ENGLISH' then
      ftstablas[k].Caption:='CRUD Reference - '+reg.hclase+' '+reg.hbiblioteca+' '+reg.hnombre
   else
      ftstablas[k].Caption:='Matriz CRUD - '+reg.hclase+' '+reg.hbiblioteca+' '+reg.hnombre;
   ftstablas[k].tipo:='TAB';
   ftstablas[k].prepara(reg.hnombre);
   ftstablas[k].arma(reg.hnombre);
   screen.Cursor:=crdefault;
end;
procedure Tfarbol.adabas_crud(Sender: TObject);
var reg:^Tmyrec;
   k:integer;
   ventana:Tmenuitem;
   titulo:string;
begin
   reg:=nodo_actual.data;
   titulo:='Dataview '+reg.hclase+' '+reg.hbiblioteca+' '+reg.hnombre;
   for k:=0 to ventanas1.Count-1 do begin
      ventana:=ventanas1.Items[k];
      if ventana.Hint=titulo then begin
         ventana1click(ventana);
         exit;
      end;
   end;
   screen.Cursor:=crsqlwait;
   k:=length(ftstablas);
   setlength(ftstablas,k+1);
   ftstablas[k]:=Tftstablas.Create(farbol);
   ftstablas[k].Parent:=farbol;
   ftstablas[k].left:=g_left;
   ftstablas[k].top:=g_top;
   ftstablas[k].Width:= g_Width;
   ftstablas[k].Height:= g_Height;
   ftstablas[k].Visible:=true;
   ventana:=Tmenuitem.Create(self);
   ventana.Caption:=titulo;
   ventana.Hint:=titulo;
   ventana.Tag:=k+5000;
   ventana.OnClick:=ventana1click;
   ventanas1.Add(ventana);
   if g_language='ENGLISH' then
      ftstablas[k].Caption:='CRUD Reference - '+reg.hclase+' '+reg.hbiblioteca+' '+reg.hnombre
   else
      ftstablas[k].Caption:='Matriz CRUD - '+reg.hclase+' '+reg.hbiblioteca+' '+reg.hnombre;
   ftstablas[k].tipo:='NVW';
   ftstablas[k].prepara(reg.hnombre);
   ftstablas[k].arma(reg.hnombre);
   screen.Cursor:=crdefault;
end;
procedure Tfarbol.ConsultaComponente2Click(Sender: TObject);
begin
   if ftsconscom=nil then begin
      ftsconscom:=Tftsconscom.Create(farbol);
      ftsconscom.Parent:=farbol;
      ftsconscom.Visible:=true;
      dm.feed_combo(ftsconscom.Cmbproyecto,'select distinct cproyecto '+
         ' from tsuserpro'+
         ' where cuser='+g_q+g_usuario+g_q);
   end
   else
      ftsconscom.WindowState:=wsnormal;
   ftsconscom.Show;
//   ftsconscom.cmbclase.SetFocus;
   ftsconscom.buscar.SetFocus;
end;
procedure Tfarbol.agrega_componente(nombre:string; bib:string; clase:string; nodo:Ttreenode=nil;
   pnombre:string=''; pbib:string=''; pclase:string='');
var
   nodx:Ttreenode;
   reg:^Tmyrec;
begin
   nodx:=tv.Items.Addchild(nodo,clase+' '+bib+' '+nombre);
   new(reg);
   reg.pnombre:=pnombre;
   reg.pbiblioteca:=pbib;
   reg.pclase:=pclase;
   reg.hnombre:=nombre;
   reg.hbiblioteca:=bib;
   reg.hclase:=clase;
   reg.hijo_falso:=false;
   nodx.Data:=reg;
   nodx.ImageIndex:=dm.lclases.IndexOf(reg.hclase);
   nodx.SelectedIndex:=0;
   expande(nodx,nombre,bib,clase,2);
end;
procedure Tfarbol.diagramajcl( sender: Tobject );
var   reg:^Tmyrec;
   k:integer;
   ventana:Tmenuitem;
   titulo:string;
begin
   reg:=nodo_actual.data;
   titulo:='Diagrama '+reg.hclase+' '+reg.hbiblioteca+' '+reg.hnombre;
   for k:=0 to ventanas1.Count-1 do begin
      ventana:=ventanas1.Items[k];
      if ventana.Hint=titulo then begin
         ventana1click(ventana);
         exit;
      end;
   end;
   screen.Cursor:=crsqlwait;
   k:=length(ftsdiagjcl);
   setlength(ftsdiagjcl,k+1);
   ftsdiagjcl[k]:=Tftsdiagjcl.create(farbol);
   ftsdiagjcl[k].parent:=farbol;
   ftsdiagjcl[k].left:=g_left;
   ftsdiagjcl[k].top:=g_top;
   ftsdiagjcl[k].Width:= g_Width;
   ftsdiagjcl[k].Height:= g_Height;
   ftsdiagjcl[k].visible:=true;
   ventana:=Tmenuitem.Create(self);
   ventana.Caption:=titulo;
   ventana.Hint:=titulo;
   ventana.Tag:=k+3000;
   ventana.OnClick:=ventana1click;
   ventanas1.Add(ventana);
   ftsdiagjcl[k].diagrama_jcl(reg.hnombre,reg.hbiblioteca,reg.hclase);
   ftsdiagjcl[k].show;
   screen.Cursor:=crdefault;
end;
procedure Tfarbol.mbusqueda1Click(Sender: TObject);
var k:integer;
   ventana:Tmenuitem;
begin
   k:=length(ftsbusca);
   setlength(ftsbusca,k+1);
   ftsbusca[k]:=Tftsbusca.Create(farbol);
   ftsbusca[k].Parent:=farbol;
   ftsbusca[k].Width:= g_Width;
   ftsbusca[k].Height:= g_Height;
   ftsbusca[k].Visible:=true;
   ftsbusca[k].Show;
   ftsbusca[k].Tag:=k;
   ftsbusca[k].BringToFront;
   ftsbusca[k].combo.SetFocus;
   ventana:=Tmenuitem.Create(self);
   ventana.Caption:='Busqueda';
   ventana.Hint:='Busqueda';
   ventana.Tag:=k+8000;
   ventana.OnClick:=ventana1click;
   ventanas1.Add(ventana);
end;

procedure Tfarbol.Acercade1Click(Sender: TObject);
var i:integer;
begin
   PR_ACERCA;
end;

procedure Tfarbol.Salir1Click(Sender: TObject);
begin
   Close;
end;

procedure Tfarbol.tvDragDrop(Sender, Source: TObject; X, Y: Integer);
var lv:Tlistview;
    compo,clase,bib:string;
    i:integer;
begin
   if source is Tlistview then begin
      lv:=(source as Tlistview);
      if lv.tag=1 then               //  CONSCOM
         ftsconscom.bokClick(Sender)
      else
      if lv.tag=2 then begin         // Matriz CRUD
         for i:=0 to lv.Items.Count-1 do begin
            if lv.Items[i].Selected then begin
               agrega_componente(lv.Items[i].SubItems[2],lv.Items[i].SubItems[1],lv.Items[i].SubItems[0],nil,
                  '','','CONSULTA');
            end;
         end;
      end;
   { para el drawgrid del impacto anterior
   end
   else begin
      if source is Tdrawgrid then begin
         compo:=((source as Tdrawgrid).Parent as Tftsimpacto).componente;
         if trim(compo)='' then exit;
         i:=pos(' ',compo);
         clase:=copy(compo,1,i-1);
         compo:=copy(compo,i+1,200);
         i:=pos(' ',compo);
         bib:=copy(compo,1,i-1);
         compo:=copy(compo,i+1,200);
         agrega_componente(compo,bib,clase,nil,
                  '','','CONSULTA');
      end;
   }
   end;
end;

procedure Tfarbol.tvDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
   accept:=((source is Tlistview) or (source is Tdrawgrid));
end;
procedure Tfarbol.nuevo_proyecto(Sender: TObject);
var
   nodx:Ttreenode;
   reg:^Tmyrec;
   proyecto:string;
begin
   proyecto:=inputbox('Capture','Nombre del Proyecto','');
   if trim(proyecto)='' then exit;
   proyecto:=uppercase(proyecto);
   if dm.sqlselect(dm.q1,'select * from tsuserpro '+
      ' where cuser='+g_q+g_usuario+g_q+
      ' and   cproyecto='+g_q+proyecto+g_q) then begin
      showmessage('ERROR... El proyecto ya existe');
      exit;
   end;
   nodx:=tv.Items.AddChild(nodo_actual,proyecto);
   new(reg);
   reg.pnombre:=g_usuario;
   reg.pbiblioteca:='USER';
   reg.pclase:='';
   reg.hnombre:=proyecto;
   reg.hbiblioteca:='PROYECTO';
   reg.hclase:='USERPRO';
   reg.hijo_falso:=false;
   nodx.Data:=reg;
   nodx.ImageIndex:=dm.lclases.IndexOf(reg.hclase);
   nodx.SelectedIndex:=0;
   dm.sqlinsert('insert into tsuserpro (cuser,cproyecto,cprog,cbib,cclase) values('+
      g_q+g_usuario+g_q+','+
      g_q+proyecto+g_q+','+
      g_q+'.'+g_q+','+
      g_q+'.'+g_q+','+
      g_q+'.'+g_q+')');
   if ftsconscom<>nil then begin
//      dm.feed_combo(ftsconscom.Cmbproyecto,'select distinct cproyecto '+
//         ' from tsuserpro'+
//         ' where cuser='+g_q+g_usuario+g_q);
      ftsconscom.FormActivate(sender);
   end;
end;
function Tfarbol.alta_a_proyecto(nombre:string; bib:string; clase:string; proyecto:string):boolean;
begin
   if dm.sqlselect(dm.q1,'select * from tsuserpro '+
      ' where cuser='+g_q+g_usuario+g_q+
      ' and cproyecto='+g_q+proyecto+g_q+
      ' and cprog='+g_q+nombre+g_q+
      ' and cbib='+g_q+bib+g_q+
      ' and cclase='+g_q+clase+g_q) then begin
      showmessage('Componente '+nombre+' ya está dado de alta en el proyecto');
      alta_a_proyecto:=false;
      exit;
   end;
   dm.sqlinsert('insert into tsuserpro (cuser,cproyecto,cprog,cbib,cclase) values('+
      g_q+g_usuario+g_q+','+
      g_q+proyecto+g_q+','+
      g_q+nombre+g_q+','+
      g_q+bib+g_q+','+
      g_q+clase+g_q+')');
   alta_a_proyecto:=true;
end;
procedure Tfarbol.borrar_item(Sender: TObject);
var   reg:^Tmyrec;
   k:integer;
begin
   screen.Cursor:=crsqlwait;
   reg:=nodo_actual.data;
   if reg.pclase='USERPRO' then begin   // elimina componente de proyecto
      dm.sqldelete('delete tsuserpro '+
         ' where cuser='+g_q+g_usuario+g_q+
         ' and cproyecto='+g_q+reg.pnombre+g_q+
         ' and cprog='+g_q+reg.hnombre+g_q+
         ' and cbib='+g_q+reg.hbiblioteca+g_q+
         ' and cclase='+g_q+reg.hclase+g_q);
   end;
   if reg.hclase='USERPRO' then begin   // elimina proyecto
      dm.sqldelete('delete tsuserpro '+
         ' where cuser='+g_q+g_usuario+g_q+
         ' and cproyecto='+g_q+reg.hnombre+g_q);
      if ftsconscom<>nil then begin
         ftsconscom.FormActivate(sender);
      end;
   end;
   memo.Lines.Clear;
   nodo_actual.Free;
   screen.Cursor:=crdefault;
end;
end.
