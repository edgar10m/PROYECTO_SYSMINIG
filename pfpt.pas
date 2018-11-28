unit pfpt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls,  OleCtrls, SHDocVw, StdCtrls, Menus, dxNavBarCollns, 
  dxNavBarBase, dxNavBar, dxGDIPlusClasses, cxClasses;

type
  Tffpt = class(TForm)
    ytitulo: TPanel;
    imglogo: TImage;
    WebBrowser1: TWebBrowser;
    MainMenu1: TMainMenu;
    Procesos1: TMenuItem;
    UmbralesdeMedicion1: TMenuItem;
    EvaluaMetricas1: TMenuItem;
    Catalogos1: TMenuItem;
    Categorias1: TMenuItem;
    ClavesAPA1: TMenuItem;
    ControlConsecutivos1: TMenuItem;
    Entornos1: TMenuItem;
    Proyectos1: TMenuItem;
    Salida1: TMenuItem;
    Salir1: TMenuItem;
    dxNavBar2: TdxNavBar;
    gmodulos: TdxNavBarGroup;
    gcatalogos: TdxNavBarGroup;
    gsalida: TdxNavBarGroup;
    msalir: TdxNavBarItem;
    mcargaff: TdxNavBarItem;
    mapa: TdxNavBarItem;
    mumbral: TdxNavBarItem;
    mcategoria: TdxNavBarItem;
    mcontrol: TdxNavBarItem;
    mentorno: TdxNavBarItem;
    mproyecto: TdxNavBarItem;
    mentidades: TdxNavBarItem;
    mcatprog: TdxNavBarItem;
    procedure msalirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mcargaffClick(Sender: TObject);
    procedure mapaClick(Sender: TObject);
    procedure mcategoriaClick(Sender: TObject);
    procedure mumbralClick(Sender: TObject);
    procedure mcontrolClick(Sender: TObject);
    procedure mentornoClick(Sender: TObject);
    procedure mproyectoClick(Sender: TObject);
    procedure mentidadesClick(Sender: TObject);
    procedure mcatprogClick(Sender: TObject);
  private
    { Private declarations }
    combo:Tcombobox;
  public
    { Public declarations }
  end;

var
  ffpt: Tffpt;
   procedure PR_FPT;

implementation
uses ptsdm,pfptcarga, pcatalog;
{$R *.dfm}
procedure PR_FPT;
begin
   Application.CreateForm( Tffpt, ffpt );
   try
      ffpt.Showmodal;
   finally
      ffpt.Free;
   end;
end;

procedure Tffpt.msalirClick(Sender: TObject);
begin
   close;
end;

procedure Tffpt.FormCreate(Sender: TObject);
begin
   if dm.sqlselect(dm.q1,'select * from parametro where clave='+g_q+'WEB-INICIO'+g_q) then
      webbrowser1.Navigate(dm.q1.fieldbyname('dato').AsString);

end;

procedure Tffpt.mcargaffClick(Sender: TObject);
begin
   PR_FPTCARGA;
end;

procedure Tffpt.mapaClick(Sender: TObject);
begin
   PR_CATALOG(mapa.Caption,'select '+
      'capa       vk__Clave_APA, '+
      'descripcion        v___Descripcion '+
      'from fptapa '+
      'where capa='+g_q+'$1$'+g_q,
      'insert into fptapa (capa,descripcion) values('+
      g_q+'$1$'+g_q+','+
      g_q+'$2$'+g_q+')',
      'update fptapa set '+
      'descripcion='+g_q+'$2$'+g_q+' '+
      'where capa='+g_q+'$1$'+g_q,
      'delete fptapa where capa='+g_q+'$1$'+g_q,0);
   fcatalog.regla('$1$','<>','','',dm.xlng('La Clave no debe quedar vacia'));
   fcatalog.regla('$2$','<>','','',dm.xlng('La Descripcion no debe quedar vacia'));
   try
      fcatalog.Showmodal;
   finally
      fcatalog.Free;
   end;

end;

procedure Tffpt.mcategoriaClick(Sender: TObject);
begin
   PR_CATALOG(mcategoria.Caption,'select '+
      'ccategoria       vk__Categoria, '+
      'descripcion      v___Descripcion '+
      'from fptcategoria '+
      'where ccategoria='+g_q+'$1$'+g_q,
      'insert into fptcategoria (ccategoria,descripcion) values('+
      g_q+'$1$'+g_q+','+
      g_q+'$2$'+g_q+')',
      'update fptcategoria set '+
      'descripcion='+g_q+'$2$'+g_q+' '+
      'where ccategoria='+g_q+'$1$'+g_q,
      'delete fptcategoria where ccategoria='+g_q+'$1$'+g_q,0);
   fcatalog.regla('$1$','<>','','',dm.xlng('La Categoría no debe quedar vacia'));
   fcatalog.regla('$2$','<>','','',dm.xlng('La Descripción no debe quedar vacia'));
   try
      fcatalog.Showmodal;
   finally
      fcatalog.Free;
   end;

end;

procedure Tffpt.mumbralClick(Sender: TObject);
begin
   PR_CATALOG(mumbral.Caption,'select '+
      ' capa        vkc_Clave_APA,'+
      ' concepto    vk__Concepto,  '+
      ' subconcepto vk__Subconcepto, '+
      ' ccategoria  vkc_Categoria,'+
      ' cclase      vkc_Tipo_componente,'+
      ' cbib        vkc_Biblioteca,'+
      ' cprog       vk__Componente,'+
      ' minimo      v__nUmbral_Minimo,'+
      ' maximo      v__nUmbral_Maximo, '+
      ' medida      v_c_Unidad_Medida '+
      ' from fptumbral '+
      ' where capa='+g_q+'$1$'+g_q+
      ' and  concepto='+g_q+'$2$'+g_q+
      ' and  subconcepto='+g_q+'$3$'+g_q+
      ' and  ccategoria='+g_q+'$4$'+g_q+
      ' and  cprog='+g_q+'$7$'+g_q+
      ' and  cbib='+g_q+'$6$'+g_q+
      ' and  cclase='+g_q+'$5$'+g_q,
      'insert into fptumbral (capa,concepto,subconcepto,ccategoria,'+
      '   cclase,cbib,cprog,minimo,maximo,medida) values('+
      g_q+'$1$'+g_q+','+
      g_q+'$2$'+g_q+','+
      g_q+'$3$'+g_q+','+
      g_q+'$4$'+g_q+','+
      g_q+'$5$'+g_q+','+
      g_q+'$6$'+g_q+','+
      g_q+'$7$'+g_q+','+
      '$8$'+','+
      '$9$'+','+
      g_q+'$10$'+g_q+')',
      'update fptumbral set '+
      'minimo='+'$8$'+','+
      'maximo='+'$9$'+' '+
      'medida='+'$10$'+' '+
      'where capa='+g_q+'$1$'+g_q+
      ' and  concepto='+g_q+'$2$'+g_q+
      ' and  subconcepto='+g_q+'$3$'+g_q+
      ' and  ccategoria='+g_q+'$4$'+g_q+
      ' and  cprog='+g_q+'$7$'+g_q+
      ' and  cbib='+g_q+'$6$'+g_q+
      ' and  cclase='+g_q+'$5$'+g_q,
      'delete fptumbral '+
      'where capa='+g_q+'$1$'+g_q+
      ' and  concepto='+g_q+'$2$'+g_q+
      ' and  subconcepto='+g_q+'$3$'+g_q+
      ' and  ccategoria='+g_q+'$4$'+g_q+
      ' and  cprog='+g_q+'$7$'+g_q+
      ' and  cbib='+g_q+'$6$'+g_q+
      ' and  cclase='+g_q+'$5$'+g_q,0);
      (fcatalog.pan.FindComponent('SELE_UMBRAL_MINIMO') as tedit).Width:=50;
   (fcatalog.pan.FindComponent('SELE_UMBRAL_MAXIMO') as tedit).Width:=50;
      fcatalog.regla('$1$','<>','','',dm.xlng('La Clave de Analisis de Performance no debe quedar vacia'));
   fcatalog.regla('$2$','<>','','',dm.xlng('El Concepto no debe quedar vacio'));
   fcatalog.regla('$3$','<>','','',dm.xlng('El Subconcepto no debe quedar vacio'));
   fcatalog.regla('$4$','<>','','',dm.xlng('La Categoría no debe quedar vacia'));
   fcatalog.regla('$5$','<>','','',dm.xlng('El Minimo no debe quedar vacio'));
   fcatalog.regla('$6$','<>','','',dm.xlng('El Maximo no debe quedar vacio'));
   dm.feed_combo(fcatalog.pan.FindComponent('SELE_CLAVE_APA') as tcombobox,
      'select capa from fptapa order by 1');
   dm.feed_combo(fcatalog.pan.FindComponent('SELE_CATEGORIA') as tcombobox,
      'select ccategoria from fptcategoria order by 1');
   dm.feed_combo(fcatalog.pan.FindComponent('SELE_TIPO_COMPONENTE') as tcombobox,
      'select cclase from tsclase order by 1');
   (fcatalog.pan.FindComponent('SELE_TIPO_COMPONENTE') as tcombobox).Items.Insert(0,'-todos-');
   dm.feed_combo(fcatalog.pan.FindComponent('SELE_BIBLIOTECA') as tcombobox,
      'select cbib from tsbib order by 1');
   (fcatalog.pan.FindComponent('SELE_BIBLIOTECA') as tcombobox).Items.Insert(0,'-todos-');
   fcatalog.inicial('SELE_CATEGORIA','GENERAL');
   fcatalog.inicial('SELE_BIBLIOTECA','-todos-');
   fcatalog.inicial('SELE_TIPO_COMPONENTE','-todos-');
   fcatalog.inicial('SELE_COMPONENTE','-todos-');
   combo:=(fcatalog.pan.FindComponent('SELE_UNIDAD_MEDIDA') as tcombobox);
   combo.Items.Add('K');
   combo.Items.Add('MIN');
   combo.Items.Add('SEGCPU');
   combo.Items.Add('UNIDAD');
   combo.Items.Add('%');
   try
      fcatalog.Showmodal;
   finally
      fcatalog.Free;
   end;

end;

procedure Tffpt.mcontrolClick(Sender: TObject);
begin
   PR_CATALOG(mcontrol.Caption,
      'select'+
      ' registro      vk__Tipo_de_Folio,'+
      ' folio         v__nNumero_de_Folio'+
      ' from fptcontrol'+
      ' where registro='+g_q+'$1$'+g_q,
      'insert into fptcontrol (registro,folio) values('+
      g_q+'$1$'+g_q+','+
      '$2$'+')',
      'update fptcontrol set '+
      ' folio='+'$2$'+
      ' where registro='+g_q+'$1$'+g_q,
      'delete fptcontrol where registro='+g_q+'$1$'+g_q,0);
   fcatalog.regla('$1$','<>','','',dm.xlng('El Tipo de Folio no debe quedar vacio'));
   fcatalog.regla('$2$','<>','','',dm.xlng('El Numero de Folio no debe quedar vacio'));
   try
      fcatalog.Showmodal;
   finally
      fcatalog.Free;
   end;

end;

procedure Tffpt.mentornoClick(Sender: TObject);
begin
   PR_CATALOG(mentorno.Caption,'select '+
      'centorno       vk__Entorno, '+
      'descripcion      v___Descripcion '+
      'from fptentorno '+
      'where centorno='+g_q+'$1$'+g_q,
      'insert into fptentorno (centorno,descripcion) values('+
      g_q+'$1$'+g_q+','+
      g_q+'$2$'+g_q+')',
      'update fptentorno set '+
      'descripcion='+g_q+'$2$'+g_q+' '+
      'where centorno='+g_q+'$1$'+g_q,
      'delete fptentorno where centorno='+g_q+'$1$'+g_q,0);
   fcatalog.regla('$1$','<>','','',dm.xlng('El Entorno no debe quedar vacio'));
   fcatalog.regla('$2$','<>','','',dm.xlng('La Descripcion no debe quedar vacia'));
   try
      fcatalog.Showmodal;
   finally
      fcatalog.Free;
   end;
end;

procedure Tffpt.mproyectoClick(Sender: TObject);
begin
   PR_CATALOG(mproyecto.Caption,'select '+
      'cproyecto       vk__Proyecto, '+
      'descripcion      v___Descripcion '+
      'from fptproyecto '+
      'where cproyecto='+g_q+'$1$'+g_q,
      'insert into fptproyecto (cproyecto,descripcion) values('+
      g_q+'$1$'+g_q+','+
      g_q+'$2$'+g_q+')',
      'update fptproyecto set '+
      'descripcion='+g_q+'$2$'+g_q+' '+
      'where cproyecto='+g_q+'$1$'+g_q,
      'delete fptproyecto where cproyecto='+g_q+'$1$'+g_q,0);
   fcatalog.regla('$1$','<>','','',dm.xlng('El Proyecto no debe quedar vacio'));
   fcatalog.regla('$2$','<>','','',dm.xlng('La Descripcion no debe quedar vacia'));
   try
      fcatalog.Showmodal;
   finally
      fcatalog.Free;
   end;

end;

procedure Tffpt.mentidadesClick(Sender: TObject);
begin
   PR_CATALOG(mentidades.Caption,'select '+
      'centidad       vk__Entidad, '+
      'descripcion      v___Descripcion '+
      'from fptentidad '+
      'where centidad='+g_q+'$1$'+g_q,
      'insert into fptentidad (centidad,descripcion) values('+
      g_q+'$1$'+g_q+','+
      g_q+'$2$'+g_q+')',
      'update fptentidad set '+
      'descripcion='+g_q+'$2$'+g_q+' '+
      'where centidad='+g_q+'$1$'+g_q,
      'delete fptentidad where centidad='+g_q+'$1$'+g_q,0);
   fcatalog.regla('$1$','<>','','',dm.xlng('La Entidad no debe quedar vacia'));
   fcatalog.regla('$2$','<>','','',dm.xlng('La Descripcion no debe quedar vacia'));
   try
      fcatalog.Showmodal;
   finally
      fcatalog.Free;
   end;
end;

procedure Tffpt.mcatprogClick(Sender: TObject);
begin
   PR_CATALOG(mcatprog.Caption,'select '+
      'ccategoria       vkc_Categoria, '+
      'cclase      vkc_Clase, '+
      'cbib      vkc_Biblioteca, '+
      'cprog      vk__Programa '+
      'from fptcatprog '+
      'where ccategoria='+g_q+'$1$'+g_q+
      '  and cprog='+g_q+'$4$'+g_q+
      '  and cbib='+g_q+'$3$'+g_q+
      '  and cclase='+g_q+'$2$'+g_q,
      'insert into fptcatprog (ccategoria,cprog,cbib,cclase) values('+
      g_q+'$1$'+g_q+','+
      g_q+'$4$'+g_q+','+
      g_q+'$3$'+g_q+','+
      g_q+'$2$'+g_q+')',
      'update fptcatprog set '+
      'cprog='+g_q+'$4$'+g_q+' '+
      'where ccategoria='+g_q+'$1$'+g_q+
      '  and cprog='+g_q+'$4$'+g_q+
      '  and cbib='+g_q+'$3$'+g_q+
      '  and cclase='+g_q+'$2$'+g_q,
      'delete fptentidad '+
      'where ccategoria='+g_q+'$1$'+g_q+
      '  and cprog='+g_q+'$4$'+g_q+
      '  and cbib='+g_q+'$3$'+g_q+
      '  and cclase='+g_q+'$2$'+g_q,0);
   dm.feed_combo(fcatalog.pan.FindComponent('SELE_CATEGORIA') as tcombobox,
      'select ccategoria from fptcategoria order by ccategoria');
   dm.feed_combo(fcatalog.pan.FindComponent('SELE_CLASE') as tcombobox,
      'select cclase from tsclase order by cclase');
   dm.feed_combo(fcatalog.pan.FindComponent('SELE_BIBLIOTECA') as tcombobox,
      'select cbib from tsbib order by cbib');
   fcatalog.inicial('SELE_CATEGORIA','CRITICO');
   fcatalog.inicial('SELE_BIBLIOTECA',g_pais+'SRC');
   fcatalog.inicial('SELE_CLASE','CBL');
   fcatalog.regla('$4$','<>','','',dm.xlng('El Programa no debe quedar vacio'));
   try
      fcatalog.Showmodal;
   finally
      fcatalog.Free;
   end;
end;

end.
