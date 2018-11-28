unit ptsmining;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, {dxNavBarCollns, cxClasses, dxNavBarBase,} ExtCtrls,{ dxNavBar, }
  OleCtrls, SHDocVw, StdCtrls, Menus, dxNavBarCollns, shellapi,
  dxNavBarBase, dxNavBar, cxClasses;

type
  Tftsmining = class(TForm)
    OpenDialog1: TOpenDialog;
    MainMenu1: TMainMenu;
    Operacion1: TMenuItem;
    BasedeConocimiento1: TMenuItem;
    mrecepcion1: TMenuItem;
    Reportes1: TMenuItem;
    mInventario1: TMenuItem;
    mlistacompo1: TMenuItem;
    mUsoTablas1: TMenuItem;
    gCatalogos1: TMenuItem;
    mBibliotecas1: TMenuItem;
    Salida1: TMenuItem;
    dxNavBar1: TdxNavBar;
    goperacion: TdxNavBarGroup;
    greportes: TdxNavBarGroup;
    gcatalogos: TdxNavBarGroup;
    gsalida: TdxNavBarGroup;
    msalir: TdxNavBarItem;
    mbibliotecas: TdxNavBarItem;
    mrecepcion: TdxNavBarItem;
    marbol: TdxNavBarItem;
    mlistacompo: TdxNavBarItem;
    minventario: TdxNavBarItem;
    musotablas: TdxNavBarItem;
    mreporteador: TdxNavBarItem;
    msearch: TdxNavBarItem;
    mReporteador1: TMenuItem;
    Ayuda1: TMenuItem;
    Acercade1: TMenuItem;
    mbusca: TdxNavBarItem;
    mprocesos: TdxNavBarItem;
    grcasosuso: TdxNavBarGroup;
    mcasosusomostrar: TdxNavBarItem;
    procedure msalirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mbibliotecasClick(Sender: TObject);
    procedure mrecepcionClick(Sender: TObject);
    procedure marbolClick(Sender: TObject);
    procedure mlistacompoClick(Sender: TObject);
    procedure minventarioClick(Sender: TObject);
    procedure musotablasClick(Sender: TObject);
    procedure mreporteadorClick(Sender: TObject);
    procedure msearchClick(Sender: TObject);
    procedure Acercade1Click(Sender: TObject);
    procedure mbuscaClick(Sender: TObject);
    procedure mprocesosClick(Sender: TObject);
    procedure mcasosusomostrarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ftsmining: Tftsmining;
   procedure PR_MINING;

implementation

uses ptsdm,pcatalog,ptsrecibe,parbol,ptstablas,ptsinventario,ptslistacompo,
     ptssearch, facerca, ptsbusca, mgca7, ptsgral ;

{$R *.dfm}
procedure PR_MINING;
begin
   g_Wforma:='mining';
   g_Wforma_Aux:='';
   Application.CreateForm( Tftsmining, ftsmining );
   try
      ftsmining.Showmodal;
   finally
      ftsmining.Free;
   end;
end;

procedure Tftsmining.msalirClick(Sender: TObject);
begin
   close;
end;

procedure Tftsmining.FormCreate(Sender: TObject);
begin
   if g_language='ENGLISH' then begin
      goperacion.Caption:='Operation';
      greportes.Caption:='Reports';
      gcatalogos.Caption:='Catalogs';
      gsalida.Caption:='Exit';
      msalir.Caption:='Exit';
      mbibliotecas.Caption:='Libraries';
      mrecepcion.Caption:='Receiving Components';
      marbol.Caption:='Knowledge Base';
      mlistacompo.Caption:='List of Components';
      minventario.Caption:='Inventory';
      musotablas.Caption:='Tables Usage';
      mreporteador.Caption:='Report Generator';
      //casos uso
      mainmenu1.free;
   end;
   //if dm.sqlselect(dm.q1,'select * from parametro where clave='+g_q+'WEB-INICIO'+g_q) then
      //webbrowser1.Navigate(dm.q1.fieldbyname('dato').AsString);
   mrecepcion.Visible:=dm.capacidad('Mining - Recepcion Componentes');
   minventario.Visible:=dm.capacidad('Mining - Inventario');
   mreporteador.Visible:=dm.capacidad('Mining - Reporteador');
   gcatalogos.Visible:=dm.capacidad('Mining - Catalogos');
   grcasosuso.Visible:=dm.capacidad('Mining - Casos de Uso');
   mbusca.visible:=dm.capacidad('Mining - Busca');
   mprocesos.visible:=dm.capacidad('Mining - Procesos Negocio');
   mcasosusomostrar.visible:=dm.capacidad('Mining - Casos Uso');
   mrecepcion1.Visible:=mrecepcion.Visible;
   minventario1.Visible:=minventario.Visible;
   mreporteador1.Visible:=mreporteador.Visible;
   gcatalogos1.Visible:=gcatalogos.Visible;
   g_Wforma:='mining';
end;

procedure Tftsmining.mbibliotecasClick(Sender: TObject);
begin
   PR_CATALOG(mbibliotecas.Caption,'select '+
      'cbib             vk__Biblioteca, '+
      'descripcion      v___Descripcion, '+
      'ip               v___Direccion_IP, '+
      'path             v___Path, '+
      'dirprod          v___Directorio_Produccion '+
      'from tsbib '+
      'where cbib='+g_q+'$1$'+g_q+
      ' and (ip not in ('+g_q+'OFICINA'+g_q+','+g_q+'SISTEMA'+g_q+') or ip'+g_is_null+')',
      'insert into tsbib (cbib,descripcion,ip,path,dirprod) values('+
      g_q+'$1$'+g_q+','+
      g_q+'$2$'+g_q+','+
      g_q+'$3$'+g_q+','+
      g_q+'$4$'+g_q+','+
      g_q+'$5$'+g_q+')',
      'update tsbib set '+
      'descripcion='+g_q+'$2$'+g_q+','+
      'ip='+g_q+'$3$'+g_q+','+
      'path='+g_q+'$4$'+g_q+','+
      'dirprod='+g_q+'$5$'+g_q+' '+
      'where cbib='+g_q+'$1$'+g_q,
      'delete tsbib '+
      'where cbib='+g_q+'$1$'+g_q,0);
   (fcatalog.pan.FindComponent('SELE_DIRECTORIO_PRODUCCION') as tedit).CharCase:=ecnormal;
   fcatalog.regla('$1$','<>','','',dm.xlng('La Clave de Biblioteca no debe quedar vacia'));
   fcatalog.regla('$2$','<>','','',dm.xlng('La Descripcion no debe quedar vacia'));
      try
      fcatalog.Showmodal;
   finally
      fcatalog.Free;
   end;
   //dm.bfile_directorio;
end;

procedure Tftsmining.mrecepcionClick(Sender: TObject);
begin
   PR_RECIBE;
end;

procedure Tftsmining.marbolClick(Sender: TObject);
var antes:Twindowstate;
begin
   antes:=windowstate;
   //windowstate:=wsminimized;
   g_Wforma:='arbol';
   PR_ARBOL;
   g_Wforma:='mining';
   windowstate:=antes;
end;

procedure Tftsmining.mlistacompoClick(Sender: TObject);

begin
   screen.Cursor:=crsqlwait;
   g_Wforma:='mining';
   g_Wforma_aux:='lista_compo';
   ftslistacompo:=Tftslistacompo.Create(ftsmining);
   ftslistacompo.Parent:= ftsmining;
   ftslistacompo.Width:= g_Width;
   ftslistacompo.Height:= g_Height;
   //ftslistacompo.Constraints.MaxWidth:= g_MaxWidth;
   ftslistacompo.BorderIcons:=BorderIcons - [biMinimize];
   PR_LISTACOMPO;
   g_Wforma_aux:='';
   screen.Cursor:=crdefault;
end;

procedure Tftsmining.minventarioClick(Sender: TObject);
begin
   screen.Cursor:=crsqlwait;
   g_Wforma:='mining';
   g_Wforma_aux:='inventario';
   ftsinventario:=Tftsinventario.Create(ftsmining);
   ftsinventario.Parent:=ftsmining;
   ftsinventario.Width:= g_Width;
   ftsinventario.Height:= g_Height;
   //ftsinventario.Constraints.MaxWidth:= g_MaxWidth;
   ftsinventario.BorderIcons:=BorderIcons - [biMinimize];
   PR_INVENTARIO;
   g_Wforma_aux:='';
   screen.Cursor:=crdefault;
end;

procedure Tftsmining.musotablasClick(Sender: TObject);
var    ftstablas: Tftstablas;
begin
   g_Wforma:='mining';
   g_Wforma_aux:='tablas';
   screen.Cursor:=crsqlwait;
   ftstablas:=Tftstablas.Create(ftsmining);
   ftstablas.Parent:=ftsmining;
   ftstablas.Width:= g_Width;
   ftstablas.Height:= g_Height;
   //ftstablas.Constraints.MaxWidth:= g_MaxWidth;
   ftstablas.BorderIcons:=BorderIcons - [biMinimize];
   ftstablas.Visible:=true;
   if g_language='ENGLISH' then
      ftstablas.Caption:=g_version_tit+' CRUD Reference '
   else
      ftstablas.Caption:=g_version_tit+' Matriz CRUD ';
   ftstablas.tipo:='TAB';
   ftstablas.prepara('');
   ftstablas.arma('');
   ftstablas.Show;
//   ftstablas.web.Navigate(g_tmpdir+'\MatrizCRUD.html');
   g_Wforma_aux:='';
   screen.Cursor:=crdefault;
end;

procedure Tftsmining.mreporteadorClick(Sender: TObject);
var ndir,repsysview:string;
begin
   ndir:=g_ruta+'\Reportes';
   if directoryexists(ndir)=false then begin
      if forcedirectories(ndir)=false then begin
         Application.MessageBox(pchar(dm.xlng('ERROR... No puede crear directorio '+ndir)),
                                pchar(dm.xlng('Reporteador ')), MB_OK );
         exit;
      end;
   end;
   if fileexists(ndir+'\MENU.db')=false then begin
      dm.get_utileria('MENU.DB',ndir+'\MENU.db');
      g_borrar.Delete(g_borrar.Count-1);
   end;
   if fileexists(ndir+'\MENU.MB')=false then begin
      dm.get_utileria('MENU.MB',ndir+'\MENU.MB');
      g_borrar.Delete(g_borrar.Count-1);
   end;
   if fileexists(ndir+'\Default.svs')=false then begin
      dm.get_utileria('DEFAULT.SVS',ndir+'\Default.svs');
      g_borrar.Delete(g_borrar.Count-1);
   end;
   chdir(ndir);
   repsysview:=ndir+'\hta'+formatdatetime('YYYYMMDDHHNNSS',now)+'.exe';
   dm.get_utileria('REPSYSVIEW',repsysview);
   ShellExecute( 0, 'open', pchar(repsysview),
   pchar(g_odbc+' '+g_user_procesa+' '+g_pass), //fercar momentaneo hasta modificar reporteador
   //pchar(g_odbc2+' '+g_user_procesa+' '+g_pass), //fercar
   PChar( g_ruta + '\Reportes' ), SW_SHOW );
   chdir(g_ruta);
end;

procedure Tftsmining.msearchClick(Sender: TObject);
begin
   PR_SEARCH;
end;

procedure Tftsmining.Acercade1Click(Sender: TObject);
begin
   PR_ACERCA;
end;
procedure Tftsmining.mprocesosClick(Sender: TObject);
begin
   PR_CA7;

end;

procedure Tftsmining.mbuscaClick(Sender: TObject);
Var  ftsbusca: Tftsbusca;
begin
   PR_BUSCA;
   ftsbusca:=Tftsbusca.Create(Self);
   Windows.SetParent(ftsbusca.Handle, ftsmining.Handle);
   ftsbusca.BringToFront;
   //ftsbusca:=Tftsbusca.Create(nil);
   //ftsbusca.Parent:=ftsmining;
   //ftsbusca.Visible:=true;
   //ftsbusca.Showmodal;
   //ftsbusca.Free;
end;

procedure Tftsmining.mcasosusomostrarClick(Sender: TObject);
var ndir,CasoUsoSysView:string;
begin
   gral.CreaTablas();
   ndir:=g_ruta+'\Reportes';
   if directoryexists(ndir)=false then begin
      if forcedirectories(ndir)=false then begin
         Application.MessageBox(pchar(dm.xlng('ERROR... No puede crear directorio '+ndir)),
                                pchar(dm.xlng('Reporteador/Casos de uso ')), MB_OK );
         exit;
      end;
   end;
   chdir(ndir);
   CasoUsoSysView:=ndir+'\hta'+formatdatetime('YYYYMMDDHHNNSS',now)+'.exe';
   dm.get_utileria('CUSYSVIEW',CasoUsoSysView);
   ShellExecute( 0, 'open', pchar(CasoUsoSysView),
      pchar(g_odbc+' '+g_user_procesa+' '+g_pass),
      PChar( g_ruta + '\Reportes' ), SW_SHOW );
   chdir(g_ruta);
end;

end.
