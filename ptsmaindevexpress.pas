unit ptsmain;

interface

uses
  Windows,bde, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables,  OleCtrls, SHDocVw, dxNavBarCollns,
  cxClasses, dxNavBarBase, ExtCtrls, dxNavBar, StdCtrls, jpeg;

type
  Tftsmain = class(TForm)
    dxNavBar1: TdxNavBar;
    gmodulos: TdxNavBarGroup;
    mmining: TdxNavBarItem;
    WebBrowser1: TWebBrowser;
    gcatalogos: TdxNavBarGroup;
    musuarios: TdxNavBarItem;
    mroles: TdxNavBarItem;
    mparametros: TdxNavBarItem;
    mcampass: TdxNavBarItem;
    mcapacidades: TdxNavBarItem;
    mrol_usuario: TdxNavBarItem;
    gsalida: TdxNavBarGroup;
    msalir: TdxNavBarItem;
    mclases: TdxNavBarItem;
    ytitulo: TPanel;
    imglogo: TImage;
    msistemas: TdxNavBarItem;
    moficinas: TdxNavBarItem;
    gutilerias: TdxNavBarGroup;
    mutileria: TdxNavBarItem;
    maltautileria: TdxNavBarItem;
    mfpt: TdxNavBarItem;
    procedure FormCreate(Sender: TObject);
    procedure musuariosClick(Sender: TObject);
    procedure mrolesClick(Sender: TObject);
    procedure mparametrosClick(Sender: TObject);
    procedure mcampassClick(Sender: TObject);
    procedure mcapacidadesClick(Sender: TObject);
    procedure mrol_usuarioClick(Sender: TObject);
    procedure msalirClick(Sender: TObject);
    procedure mminingClick(Sender: TObject);
    procedure mclasesClick(Sender: TObject);
    procedure msistemasClick(Sender: TObject);
    procedure moficinasClick(Sender: TObject);
    procedure mutileriaClick(Sender: TObject);
    procedure maltautileriaClick(Sender: TObject);
    procedure mfptClick(Sender: TObject);
  private
    { Private declarations }
   procedure detecta_base;
   procedure detecta_usuarios;
   procedure icono_clases;
  public
    { Public declarations }
  end;

var
  ftsmain: Tftsmain;

implementation

{$R *.dfm}
uses
   ptsdm,podbcno,pcreabas,mgserial,pcatalog,plogin,ppasswrd, //ptsmining,
   ptsutileria,pfpt;

function detecta_instancia:boolean;
var   PrevInstance: hWnd;
begin
   PrevInstance := FindWindow( 'TApplication', g_appname );
   if PrevInstance <> 0 then begin
      if IsIconic( PrevInstance ) then
         ShowWindow( PrevInstance, sw_Restore )
      else
         BringWindowToTop( PrevInstance );
      detecta_instancia:=true;
   end
   else
      detecta_instancia:=false;
end;
procedure ShowDatabaseDesc(DBName: string);
var
  dbDes: DBDesc;
  session : TSession;
begin
   session := TSession.Create(nil);
   session.SessionName := 'session1';
   session.Active := True;
   Check(DbiGetDatabaseDesc(PChar(DBName), @dbDes));
   if copy(dbdes.szDbType,1,24)='Adaptive Server Anywhere' then begin
      g_database:='SYBASE';
      g_q:='''';
      g_is_null:='=''''';
   end
   else
   if copy(dbdes.szDbType,1,6)='Oracle' then begin
      g_database:='ORACLE';
      g_q:='''';
      g_is_null:=' IS NULL';
   end
   else begin
      showmessage('ERROR... Driver '+dbdes.szDbType+' no soportado');
      application.Terminate;
      abort;
   end;
   session.Active := False;
   session.Free;
end;
procedure Tftsmain.detecta_base;
//var xbde:Tbdeitems;
begin
   ShowDatabaseDesc('sysviewsoftscm');     // Con BDE
{ con RXTOOLS
   xbde:=Tbdeitems.Create(self);
   xbde.Active:=true;
   xbde.FindFirst;
   while (xbde.Eof=false) and (xbde.FieldByName('name').AsString<>'sysviewsoftscm') do
      xbde.Next;
   if xbde.Eof then begin
      showmessage('ERROR... no encuentra el ODBC');
      application.Terminate;
      abort;
   end;
   if copy(xbde.FieldByName('dbtype').AsString,1,24)='Adaptive Server Anywhere' then begin
      g_database:='SYBASE';
      g_q:='''';
      g_is_null:='=''''';
   end
   else
   if copy(xbde.FieldByName('dbtype').AsString,1,6)='Oracle' then begin
      g_database:='ORACLE';
      g_q:='''';
      g_is_null:=' IS NULL';
   end
   else begin
      showmessage('ERROR... Driver '+xbde.FieldByName('dbtype').AsString+' no soportado');
      application.Terminate;
      abort;
   end;
   xbde.active:=false;
   xbde.free;
   }
end;

procedure Tftsmain.detecta_usuarios;
var pass:string;
begin
   try
      { BDE
      Application.Title := g_appname;
      dm.databasedb.Params.Add( 'USER NAME=SYSVIEW11' );
      dm.databasedb.Params.add( 'PASSWORD=SYSVIEWHELPDESK' );
      dm.databasedb.Connected := true;
      }
      dm.ADOConnection1.Connected:=false;
      dm.ADOConnection1.Connected:=true;
   except
      PR_ODBCNO;
      application.Terminate;
      abort;
   end;
   if dm.sqlselect( dm.q1, 'select * from sysview12.shdbase' ) then begin
      pass := dm.desencripta( dm.q1.fieldbyname( 'base1' ).asstring );
      { BDE
      dm.databasedb.Connected := false;
      dm.databasedb.Params.Clear;
      dm.databasedb.Params.Add( 'USER NAME=SYSVIEW12' );
      dm.databasedb.Params.add( 'PASSWORD=' + copy( pass, 3, 50 ) );
      dm.databasedb.Connected := true;
      }
      dm.ADOConnection1.Connected:=false;
      dm.ADOConnection1.ConnectionString:=
         stringreplace(dm.ADOConnection1.ConnectionString,'sysview11','sysview12',[]);
      dm.ADOConnection1.ConnectionString:=
         stringreplace(dm.ADOConnection1.ConnectionString,'SYSVIEWHELPDESK',copy( pass, 3, 50 ),[]);
      dm.ADOConnection1.Connected:=true;
      if dm.sqlselect( dm.q1, 'select * from shdbase' ) = false then begin
         application.MessageBox( 'Error en el password de base de la aplicación', 'ERROR', MB_OK );
         exit;
      end;
   end
   else begin
      if application.MessageBox( 'ERROR... no tiene acceso a la tabla SHDBASE, desea crear la Base de Datos?', 'ERROR', MB_YESNO )=IDYES then begin
         verifica_llave;
         PR_CREABASE;
      end;
      application.Terminate;
      abort;
   end;
   verifica_llave;
end;
procedure Tftsmain.icono_clases;
var icono:Ticon;
begin
   dm.lclases:=Tstringlist.Create;
   dm.lclases.Add('SELEC');
   if dm.sqlselect(dm.q1,'select * from parametro where clave like '+g_q+'ICONO_%'+g_q)then begin
      icono:=Ticon.Create;
      icono.Width:=16;
      icono.Height:=16;
      while not dm.q1.Eof do begin
         dm.lclases.Add(copy(dm.q1.fieldbyname('clave').AsString,7,100));
         dm.blob2file(dm.q1.fieldbyname('dato').AsString,g_ruta+'ICONO_TEMPORAL');
//         image2.Picture.Bitmap.LoadFromFile(g_ruta+'ICONO_TEMPORAL');
//         dm.imgclases.Add(image2.Picture.Bitmap,nil);
         icono.LoadFromFile(g_ruta+'ICONO_TEMPORAL');
         dm.imgclases.AddIcon(icono);
         dm.q1.Next;
      end;
      deletefile(g_ruta+'ICONO_TEMPORAL');
   end;
end;
procedure Tftsmain.FormCreate(Sender: TObject);
var mensaje:string;
begin
   GetMem(g_windir, 144);
   GetWindowsDirectory(g_windir,144);
   if dm.GetIPFromHost(g_hostname, g_ipaddress, mensaje)=false then begin
      showmessage(mensaje);
      application.Terminate;
      abort;
   end;
//   dm.databasedb.Connected:=true;
   if detecta_instancia then begin
      application.Terminate;
      abort;
   end;
   detecta_base;
   detecta_usuarios;
   if dm.sqlselect(dm.q1,'select * from parametro where clave='+g_q+'WEB-INICIO'+g_q) then
      webbrowser1.Navigate(dm.q1.fieldbyname('dato').AsString);
   dm.revisa_version;
   icono_clases;
   PR_LOGIN;
   if trim(g_usuario)='' then begin
      application.Terminate;
      abort;
   end;
   if dm.sqlselect(dm.q1,'select * from parametro where clave='+g_q+'VERSIONSHD'+g_q) then
      caption:=dm.q1.fieldbyname('dato').AsString+' - '+g_usuario;
   if dm.sqlselect(dm.q1,'select * from parametro where clave='+g_q+'EMPRESA-NOMBRE-1'+g_q) then
      ytitulo.Caption:=dm.q1.fieldbyname('dato').AsString;
   g_empresa:=dm.q1.fieldbyname('dato').AsString;
   mparametros.Visible:=dm.capacidad('Menu Principal Parametros');
   mroles.Visible:=dm.capacidad('Menu Principal Roles');
   musuarios.Visible:=dm.capacidad('Menu Principal Usuarios');
   mcapacidades.Visible:=dm.capacidad('Menu Principal Capacidades');
   mrol_usuario.Visible:=dm.capacidad('Menu Principal Asigna Rol a Usuario');
   mmining.Visible:=dm.capacidad('Menu Principal Application Mining');
end;

procedure Tftsmain.musuariosClick(Sender: TObject);
begin
   PR_CATALOG('Catálogo de Usuarios','select '+
      'cuser    vk__Clave_de_Usuario, '+
      'nombre   v___Nombre, '+
      'paterno  v___Apellido_Paterno, '+
      'materno  v___Apellido_Materno, '+
      'password n___Password '+
      'from tsuser '+
      'where cuser='+g_q+'$1$'+g_q,
      'insert into tsuser (cuser,nombre,paterno,materno,password) values('+
      g_q+'$1$'+g_q+','+
      g_q+'$2$'+g_q+','+
      g_q+'$3$'+g_q+','+
      g_q+'$4$'+g_q+','+
      g_q+'$5$'+g_q+')',
      'update tsuser set '+
      'nombre='+g_q+'$2$'+g_q+','+
      'paterno='+g_q+'$3$'+g_q+','+
      'materno='+g_q+'$4$'+g_q+','+
      'password='+g_q+'$5$'+g_q+','+
      'where cuser='+g_q+'$1$'+g_q,
      'delete tsuser where cuser='+g_q+'$1$'+g_q,0);
   (fcatalog.pan.FindComponent('SELE_PASSWORD') as Tedit).PasswordChar:='*';
   fcatalog.regla('$1$','<>','','','La Clave de Usuario no debe quedar vacia');
   fcatalog.regla('$2$','<>','','','El Nombre no debe quedar vacio');
   fcatalog.regla('$5$','<>','','','El Password no debe quedar vacio');
   fcatalog.inicial('SELE_PASSWORD','12345');
   try
      fcatalog.Showmodal;
   finally
      fcatalog.Free;
   end;

end;

procedure Tftsmain.mrolesClick(Sender: TObject);
begin
   PR_CATALOG('Catálogo de Roles','select '+
      'crol          vk__Clave_de_Rol, '+
      'descripcion   v___Descripcion, '+
      'mineria       v_c_Capacidad_Mineria '+
      'from tsroles '+
      'where crol='+g_q+'$1$'+g_q,
      'insert into tsroles (crol,descripcion,mineria) values('+
      g_q+'$1$'+g_q+','+
      g_q+'$2$'+g_q+','+
      g_q+'$3$'+g_q+')',
      'update tsroles set '+
      'descripcion='+g_q+'$2$'+g_q+','+
      'mineria='+g_q+'$3$'+g_q+' '+
      'where crol='+g_q+'$1$'+g_q,
      'delete tsroles where crol='+g_q+'$1$'+g_q,0);
   (fcatalog.pan.FindComponent('SELE_CAPACIDAD_MINERIA') as tcombobox).Items.CommaText:='0,1';
   fcatalog.regla('$1$','<>','','','La Clave de Rol no debe quedar vacia');
   fcatalog.regla('$2$','<>','','','La descripcion no debe quedar vacia');
   fcatalog.inicial('SELE_CAPACIDAD_MINERIA','0');
   try
      fcatalog.Showmodal;
   finally
      fcatalog.Free;
   end;
end;

procedure Tftsmain.mparametrosClick(Sender: TObject);
begin
   PR_CATALOG('Catálogo de Parámetros','select '+
      'clave       vk__Clave_de_Parametro, '+
      'secuencia   v__nSecuencia, '+
      'dato        v___Dato '+
      'from parametro '+
      'where clave='+g_q+'$1$'+g_q,
      'insert into parametro (clave,secuencia,dato) values('+
      g_q+'$1$'+g_q+','+
      '$2$'+','+
      g_q+'$3$'+g_q+')',
      'update parametro set '+
      'secuencia='+'$2$'+','+
      'dato='+g_q+'$3$'+g_q+' '+
      'where clave='+g_q+'$1$'+g_q,
      'delete parametro where clave='+g_q+'$1$'+g_q,0);
   (fcatalog.pan.FindComponent('SELE_DATO') as tedit).CharCase:=ecnormal;
   fcatalog.regla('$1$','<>','','','La Clave no debe quedar vacia');
   fcatalog.regla('$3$','<>','','','El Dato no debe quedar vacio');
   fcatalog.inicial('SELE_SECUENCIA','0');
   try
      fcatalog.Showmodal;
   finally
      fcatalog.Free;
   end;

end;

procedure Tftsmain.mcampassClick(Sender: TObject);
begin
   PR_PASSWORD;
end;

procedure Tftsmain.mcapacidadesClick(Sender: TObject);
begin
   PR_CATALOG('Catálogo de Capacidades','select '+
      'ccapacidad       vk__Clave_de_Capacidad, '+
      'crol             vkc_Rol, '+
      'cuser            vkc_Usuario '+
      'from tscapacidad '+
      'where ccapacidad='+g_q+'$1$'+g_q+
      ' and crol='+g_q+'$2$'+g_q+
      ' and cuser='+g_q+'$3$'+g_q,
      'insert into tscapacidad (ccapacidad,crol,cuser) values('+
      g_q+'$1$'+g_q+','+
      g_q+'$2$'+g_q+','+
      g_q+'$3$'+g_q+')',
      'update tscapacidad set '+
      'crol='+g_q+'$2$'+g_q+','+
      'cuser='+g_q+'$3$'+g_q+' '+
      'where ccapacidad='+g_q+'$1$'+g_q+
      ' and crol='+g_q+'$2$'+g_q+
      ' and cuser='+g_q+'$3$'+g_q,
      'delete tscapacidad where ccapacidad='+g_q+'$1$'+g_q+
      ' and crol='+g_q+'$2$'+g_q+
      ' and cuser='+g_q+'$3$'+g_q,0);
   dm.feed_combo(fcatalog.pan.FindComponent('SELE_USUARIO') as tcombobox,'select cuser from tsuser order by 1');
   dm.feed_combo(fcatalog.pan.FindComponent('SELE_ROL') as tcombobox,'select crol from tsroles order by 1');
   (fcatalog.pan.FindComponent('SELE_CLAVE_DE_CAPACIDAD') as tedit).CharCase:=ecnormal;
   fcatalog.regla('$1$','<>','','','La Clave no debe quedar vacia');
   try
      fcatalog.Showmodal;
   finally
      fcatalog.Free;
   end;
end;

procedure Tftsmain.mrol_usuarioClick(Sender: TObject);
begin
   PR_CATALOG('Asigna Rol a Usuario','select '+
      'crol             vkc_Rol, '+
      'cuser            vkc_Usuario '+
      'from tsroluser '+
      'where crol='+g_q+'$1$'+g_q+
      ' and  cuser='+g_q+'$2$'+g_q,
      'insert into tsroluser (crol,cuser) values('+
      g_q+'$1$'+g_q+','+
      g_q+'$2$'+g_q+')',
      'update tsroluser set '+
      'crol='+g_q+'$1$'+g_q+','+
      'cuser='+g_q+'$2$'+g_q+' '+
      'where crol='+g_q+'$1$'+g_q+
      ' and  cuser='+g_q+'$2$'+g_q,
      'delete tsroluser '+
      'where crol='+g_q+'$1$'+g_q+
      ' and  cuser='+g_q+'$2$'+g_q,0);
   dm.feed_combo(fcatalog.pan.FindComponent('SELE_USUARIO') as tcombobox,'select cuser from tsuser order by 1');
   dm.feed_combo(fcatalog.pan.FindComponent('SELE_ROL') as tcombobox,'select crol from tsroles order by 1');
   fcatalog.regla('$1$','<>','','','El Rol no debe quedar vacio');
   fcatalog.regla('$2$','<>','','','El Usuario no debe quedar vacio');
   try
      fcatalog.Showmodal;
   finally
      fcatalog.Free;
   end;
end;

procedure Tftsmain.msalirClick(Sender: TObject);
begin
   Close;
end;

procedure Tftsmain.mminingClick(Sender: TObject);
begin
   PR_MINING;
end;

procedure Tftsmain.mclasesClick(Sender: TObject);
begin
   PR_CATALOG('Catálogo de Clases','select '+
      'cclase             vk__Clase, '+
      'tipo               v_c_Tipo, '+
      'descripcion        v___Descripcion, '+
      'analizador         v_c_Herramienta_de_Analisis '+
      'from tsclase '+
      'where cclase='+g_q+'$1$'+g_q,
      'insert into tsclase (cclase,tipo,descripcion,analizador) values('+
      g_q+'$1$'+g_q+','+
      g_q+'$2$'+g_q+','+
      g_q+'$3$'+g_q+','+
      g_q+'$4$'+g_q+')',
      'update tsclase set '+
      'tipo='+g_q+'$2$'+g_q+','+
      'descripcion='+g_q+'$3$'+g_q+','+
      'analizador='+g_q+'$4$'+g_q+' '+
      'where cclase='+g_q+'$1$'+g_q,
      'delete tsclase '+
      'where  cclase='+g_q+'$1$'+g_q,0);
   (fcatalog.pan.FindComponent('SELE_TIPO') as tcombobox).Items.Add('ANALIZABLE');
   (fcatalog.pan.FindComponent('SELE_TIPO') as tcombobox).Items.Add('NO ANALIZABLE');
   fcatalog.inicial('SELE_HERRAMIENTA_DE_ANALISIS',
      'select cutileria from tsutileria order by 1','SQL');
   dm.feed_combo(fcatalog.pan.FindComponent('SELE_HERRAMIENTA_DE_ANALISIS') as tcombobox,
      'select cutileria from tsutileria order by 1');
   fcatalog.regla('$1$','<>','','','La Clase no debe quedar vacia');
   fcatalog.regla('$2$','<>','','','El tipo no debe quedar vacio');
   fcatalog.regla('$3$','<>','','','La Descripcion no debe quedar vacia');
   try
      fcatalog.Showmodal;
   finally
      fcatalog.Free;
   end;


end;
procedure Tftsmain.msistemasClick(Sender: TObject);
begin
   PR_CATALOG('Catálogo de Sistemas','select '+
      'csistema              vk__Sistema, '+
      'coficina              v_c_Oficina, '+
      'descripcion           v___Descripcion, '+
      'cdepende              v_c_Sistema_Padre '+
      'from tssistema '+
      'where csistema='+g_q+'$1$'+g_q,
      'insert into tssistema (csistema,coficina,descripcion,cdepende) values('+
      g_q+'$1$'+g_q+','+
      g_q+'$2$'+g_q+','+
      g_q+'$3$'+g_q+','+
      g_q+'$4$'+g_q+')',
      'update tssistema set '+
      ' coficina='+g_q+'$2$'+g_q+','+
      ' descripcion='+g_q+'$3$'+g_q+','+
      ' cdepende='+g_q+'$4$'+g_q+
      ' where csistema='+g_q+'$1$'+g_q,
      'delete tssistema '+
      'where csistema='+g_q+'$1$'+g_q,0);
   dm.feed_combo(fcatalog.pan.FindComponent('SELE_OFICINA') as tcombobox,
      'select coficina from tsoficina order by 1');
   {
   dm.feed_combo(fcatalog.pan.FindComponent('SELE_SISTEMA_PADRE') as tcombobox,
      'select csistema from tssistema order by 1');
   (fcatalog.pan.FindComponent('SELE_SISTEMA_PADRE') as tcombobox).Items.Insert(0,'');
   fcatalog.inicial('SELE_SISTEMA_PADRE','select '+g_q+''+g_q+' from dual union '+
      'select csistema from tssistema order by 1','SQL');
   }
   fcatalog.regla('$1$','<>','','','El Sistema no debe quedar vacio');
   fcatalog.regla('$2$','<>','','','La Oficina no debe quedar vacia');
   fcatalog.regla('$3$','<>','','','La Descripcion no debe quedar vacia');
   fcatalog.regla('$1$','<>','$4$','','El sistema padre no puede ser el mismo');
   fcatalog.xonexit('SELE_OFICINA','feed_combo',
      'SELE_SISTEMA_PADRE,select csistema from tssistema where coficina='+g_q+'$2$'+g_q+
      ' and csistema<>'+g_q+'$1$'+g_q+
      ' union select '+g_q+g_q+' from tssistema '+
      ' order by 1');
   try
      fcatalog.Showmodal;
   finally
      fcatalog.Free;
   end;

end;

procedure Tftsmain.moficinasClick(Sender: TObject);
begin
   PR_CATALOG('Catálogo de Oficinas','select '+
      'coficina           vk__Oficina, '+
      'descripcion        v___Descripcion, '+
      'direccion          v___Direccion '+
      'from tsoficina '+
      'where coficina='+g_q+'$1$'+g_q,
      'insert into tsoficina (coficina,descripcion,direccion) values('+
      g_q+'$1$'+g_q+','+
      g_q+'$2$'+g_q+','+
      g_q+'$3$'+g_q+')',
      'update tsoficina set '+
      ' descripcion='+g_q+'$2$'+g_q+','+
      ' direccion='+g_q+'$3$'+g_q+
      ' where coficina='+g_q+'$1$'+g_q,
      ' delete tsoficina '+
      ' where coficina='+g_q+'$1$'+g_q,0);
   fcatalog.regla('$1$','<>','','','La Oficina no debe quedar vacia');
   fcatalog.regla('$2$','<>','','','La Descripcion no debe quedar vacia');
   try
      fcatalog.Showmodal;
   finally
      fcatalog.Free;
   end;
end;

procedure Tftsmain.mutileriaClick(Sender: TObject);
begin
   PR_UTILERIA;
end;

procedure Tftsmain.maltautileriaClick(Sender: TObject);
begin
   PR_CATALOG('Catálogo de Utilerias','select '+
      'cutileria           vk__Utileria, '+
      'descripcion         v___Descripcion '+
      'from tsutileria '+
      'where cutileria='+g_q+'$1$'+g_q,
      'insert into tsutileria (cutileria,descripcion) values('+
      g_q+'$1$'+g_q+','+
      g_q+'$2$'+g_q+')',
      'update tsutileria set '+
      'descripcion='+g_q+'$2$'+g_q+
      ' where cutileria='+g_q+'$1$'+g_q,
      'delete tsutileria '+
      'where cutileria='+g_q+'$1$'+g_q,0);
   fcatalog.regla('$1$','<>','','','La Utileria no debe quedar vacia');
   fcatalog.regla('$2$','<>','','','La Descripcion no debe quedar vacia');
   try
      fcatalog.Showmodal;
   finally
      fcatalog.Free;
   end;

end;

procedure Tftsmain.mfptClick(Sender: TObject);
begin
   PR_FPT;
end;

end.
