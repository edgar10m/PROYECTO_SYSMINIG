unit pcreabas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus;

type
  TFcreabas = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    txtbase: TEdit;
    Label2: TLabel;
    txtadmin: TEdit;
    txtconfirmar: TEdit;
    Label4: TLabel;
    GroupBox2: TGroupBox;
    CheckBox1: TCheckBox;
    bok: TButton;
    bcancel: TButton;
    procedure bokClick(Sender: TObject);
    procedure bcancelClick(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
    sPriUser11: String;
  end;

var
  Fcreabas: TFcreabas;
  
procedure PR_CREABASE;

implementation

uses ptsdm,ptsgral;

{$R *.dfm}
procedure PR_CREABASE;
begin
   Application.CreateForm( TFcreabas, Fcreabas );
   try
      Fcreabas.Showmodal;
   finally
      Fcreabas.Free;
   end;
end;

procedure TFcreabas.bokClick(Sender: TObject);
begin
   try
      { BDE
      dm.databasedb.Connected := false;
      dm.databasedb.Params.Clear;
      dm.databasedb.Params.Add( 'USER NAME=SYSVIEW12' );
      dm.databasedb.Params.add( 'PASSWORD=' + txtbase.Text );
      dm.databasedb.Connected := true;
      }
      dm.ADOConnection1.Connected:=false;
      dm.ADOConnection1.ConnectionString:=
         stringreplace(dm.ADOConnection1.ConnectionString,g_user_entrada,g_user_procesa,[]);
      if pos('assword=',dm.ADOConnection1.ConnectionString)>0 then
         dm.ADOConnection1.ConnectionString:=
         stringreplace(dm.ADOConnection1.ConnectionString,'SYSVIEWHELPDESK',txtbase.Text,[])
      else
         dm.ADOConnection1.ConnectionString:=
         dm.ADOConnection1.ConnectionString+';password='+txtbase.Text+';';
      dm.ADOConnection1.Connected:=true;
   except
      dm.aborta('ERROR... Password de Base inválido');
   end;
   {
   dm.sqldelete('drop table tsutileria');
   dm.sqldelete('drop table tssistema');
   dm.sqldelete('drop table tsoficina');
   dm.sqldelete('drop table tsversion');
   dm.sqldelete('drop table tsblob');
   dm.sqldelete('drop table tsrela');
   dm.sqldelete('drop table tsprog');
   dm.sqldelete('drop table tsbib');
   dm.sqldelete('drop table tsclase');
   dm.sqldelete('drop table parametro');
   dm.sqldelete('drop table tscapacidad');
   dm.sqldelete('drop table tsroluser');
   dm.sqldelete('drop table tsroles');
   dm.sqldelete('drop table tsuser');
   dm.sqldelete('drop table tsdocum');

   dm.sqldelete('drop table fptapa');
   dm.sqldelete('drop table fptcategoria');
   dm.sqldelete('drop table fptmetrica');
   dm.sqldelete('drop table fptumbral');
   }
   if dm.sqlinsert('create table shdbase (base1 varchar(80))') = false then
      dm.aborta('ERROR... no puede crear shdbase');
   if dm.sqlinsert('insert into shdbase (base1) values('+g_q+dm.encripta('85'+txtbase.text)+g_q+')')=false then
      dm.aborta('ERROR... no puede insertar en shdbase');
   if dm.sqlinsert('grant select on shdbase to '+g_user_entrada)=false then
      dm.aborta('ERROR... no puede dar grant a shdbase');
   if dm.sqlinsert('create table tsroles (crol    varchar(20),'+
                                         'descripcion varchar(100),'+
                                         'mineria     varchar(1),'+
                                         'primary key (crol))')=false then
      dm.aborta('ERROR... no puede crear tabla tsroles');
   if dm.sqlinsert('insert into tsroles (crol,descripcion,mineria) values('+
      g_q+'ADMIN'+g_q+','+
      g_q+'ADMINISTRADOR'+g_q+','+
      g_q+'1'+g_q+')')=false then
      dm.aborta('ERROR... no puede insertar rol de administrador');
   if dm.sqlinsert('insert into tsroles (crol,descripcion,mineria) values('+
      g_q+'SVS'+g_q+','+
      g_q+'INSTALADOR'+g_q+','+
      g_q+'1'+g_q+')')=false then
      dm.aborta('ERROR... no puede insertar rol de instalador');
   if dm.sqlinsert('insert into tsroles (crol,descripcion,mineria) values('+
      g_q+'CONSULTA'+g_q+','+
      g_q+'CONSULTA'+g_q+','+
      g_q+'0'+g_q+')')=false then
      dm.aborta('ERROR... no puede insertar rol de CONSULTA');
   if dm.sqlinsert('create table tsuser (cuser    varchar(50) NOT NULL,'+
                                         'nombre   varchar(50) NOT NULL,'+
                                         'paterno  varchar(30),'+
                                         'materno  varchar(30),'+
                                         'password varchar(30) NOT NULL,'+
                                         'primary key (cuser))')=false then
      dm.aborta('ERROR... no puede crear tabla tsuser');
   if dm.sqlinsert('insert into tsuser (cuser,nombre,password) values('+
      g_q+'ADMIN'+g_q+','+
      g_q+'ADMINISTRADOR'+g_q+','+
      g_q+dm.encripta(txtadmin.Text)+g_q+')')=false then
      dm.aborta('ERROR... no puede crear usuario ADMIN');

   if dm.sqlinsert('insert into tsuser (cuser,nombre,password) values('+
      g_q+'SVS'+g_q+','+
      g_q+'INSTALADOR'+g_q+','+
      g_q+dm.encripta(txtadmin.Text)+g_q+')')=false then
      dm.aborta('ERROR... no puede crear usuario SVS');

   if dm.sqlinsert('insert into parametro (clave,secuencia,dato,descripcion) values('+
      g_q+'ROL_ADMIN'+g_q+',1,'+
      g_q+dm.encripta(formatdatetime('YYYYMMDD',now+3650))+g_q+','+
      g_q+'Fecha de caducidad Sys-Mining'+g_q+')')=false then
      dm.aborta('ERROR... no puede dar de alta ROL_ en parametro');

   if dm.sqlinsert('insert into parametro (clave,secuencia,dato,descripcion) values('+
      g_q+'ROL_SVS'+g_q+',1,'+
      g_q+dm.encripta(formatdatetime('YYYYMMDD',now+3650))+g_q+','+
      g_q+'Fecha de caducidad Sys-Mining'+g_q+')')=false then
      dm.aborta('ERROR... no puede dar de alta ROL_ en parametro');

   if dm.sqlinsert('create table tsroluser (cuser    varchar(50) NOT NULL,'+
                                         '  crol     varchar(20) NOT NULL)')=false then
      dm.aborta('ERROR... no puede crear tabla tsroluser');
   if dm.sqlinsert('alter table tsroluser add (constraint tsroluser_crol_fk foreign key (crol) '+
      'references tsroles (crol) '+
      'on delete set null)')=false then
      dm.aborta('ERROR... no puede crear constraint tsroluser_crol_fk');
   if dm.sqlinsert('alter table tsroluser add (constraint tsroluser_cuser_fk foreign key (cuser) '+
      'references tsuser (cuser) '+
      'on delete set null)')=false then
      dm.aborta('ERROR... no puede crear constraint tsroluser_cuser_fk');
   if dm.sqlinsert('insert into tsroluser (cuser, crol) values('+
      g_q+'ADMIN'+g_q+','+
      g_q+'ADMIN'+g_q+')')=false then
      dm.aborta('ERROR... no puede crear rol de admin');
   if dm.sqlinsert('insert into tsroluser (cuser, crol) values('+
      g_q+'SVS'+g_q+','+
      g_q+'SVS'+g_q+')')=false then
      dm.aborta('ERROR... no puede crear rol de SVS');
   if dm.sqlinsert('create table tscapacidad (ccapacidad varchar(50) NOT NULL,'+
                                         '  cuser    varchar(50)         NULL,'+
                                         '  crol     varchar(20)         NULL)')=false then
      dm.aborta('ERROR... no puede crear tabla tscapacidad');
   if dm.sqlinsert('alter table tscapacidad add (constraint tscapacidad_crol_fk foreign key (crol) '+
      'references tsroles (crol) '+
      'on delete set null)')=false then
      dm.aborta('ERROR... no puede crear constraint tsroluser_crol_fk');
   if dm.sqlinsert('alter table tscapacidad add (constraint tscapacidad_cuser_fk foreign key (cuser) '+
      'references tsuser (cuser) '+
      'on delete set null)')=false then
      dm.aborta('ERROR... no puede crear constraint tsroluser_cuser_fk');
   if dm.sqlinsert('insert into tscapacidad (ccapacidad, crol) values('+
      g_q+'cambio de password (todos)'+g_q+','+
      g_q+'ADMIN'+g_q+')')=false then
      dm.aborta('ERROR... no puede crear Capacidad de admin');
   if dm.sqlinsert('insert into tscapacidad (ccapacidad, crol) values('+
      g_q+'Menu Principal Parametros'+g_q+','+
      g_q+'ADMIN'+g_q+')')=false then
      dm.aborta('ERROR... no puede crear Capacidad de admin');
   if dm.sqlinsert('insert into tscapacidad (ccapacidad, crol) values('+
      g_q+'Menu Principal Roles'+g_q+','+
      g_q+'ADMIN'+g_q+')')=false then
      dm.aborta('ERROR... no puede crear Capacidad de admin');
   if dm.sqlinsert('insert into tscapacidad (ccapacidad, crol) values('+
      g_q+'Menu Principal Usuarios'+g_q+','+
      g_q+'ADMIN'+g_q+')')=false then
      dm.aborta('ERROR... no puede crear Capacidad de admin');
   if dm.sqlinsert('insert into tscapacidad (ccapacidad, crol) values('+
      g_q+'Menu Principal Capacidades'+g_q+','+
      g_q+'ADMIN'+g_q+')')=false then
      dm.aborta('ERROR... no puede crear Capacidad de admin');
   if dm.sqlinsert('insert into tscapacidad (ccapacidad, crol) values('+
      g_q+'Menu Principal Asigna Rol a Usuario'+g_q+','+
      g_q+'ADMIN'+g_q+')')=false then
      dm.aborta('ERROR... no puede crear Capacidad de admin');
   if dm.sqlinsert('insert into tscapacidad (ccapacidad, crol) values('+
      g_q+'Menu Principal Sys-Mining'+g_q+','+
      g_q+'ADMIN'+g_q+')')=false then
      dm.aborta('ERROR... no puede crear Capacidad de admin');
{   if dm.sqlinsert('insert into tscapacidad (ccapacidad, crol) values('+
      g_q+'Administracion Caducidad'+g_q+','+
      g_q+'ADMIN'+g_q+')')=false then
      dm.aborta('ERROR... no puede crear Caducidad de admin');
}
   if dm.sqlinsert('insert into tscapacidad (ccapacidad, crol) values('+
      g_q+'Administracion Monitoreo'+g_q+','+
      g_q+'ADMIN'+g_q+')')=false then
      dm.aborta('ERROR... no puede crear Monitoreo de admin');
   if dm.sqlinsert('insert into tscapacidad (ccapacidad, crol) values('+
      g_q+'Mining - Inventario'+g_q+','+
      g_q+'ADMIN'+g_q+')')=false then
      dm.aborta('ERROR... no puede crear Monitoreo de admin');
   if dm.sqlinsert('insert into tscapacidad (ccapacidad, crol) values('+
      g_q+'cambio de password (todos)'+g_q+','+
      g_q+'SVS'+g_q+')')=false then
      dm.aborta('ERROR... no puede crear Capacidad de SVS');
   if dm.sqlinsert('insert into tscapacidad (ccapacidad, crol) values('+
      g_q+'Menu Principal Parametros'+g_q+','+
      g_q+'SVS'+g_q+')')=false then
      dm.aborta('ERROR... no puede crear Capacidad de SVS');
   if dm.sqlinsert('insert into tscapacidad (ccapacidad, crol) values('+
      g_q+'Menu Principal Roles'+g_q+','+
      g_q+'SVS'+g_q+')')=false then
      dm.aborta('ERROR... no puede crear Capacidad de SVS');
   if dm.sqlinsert('insert into tscapacidad (ccapacidad, crol) values('+
      g_q+'Menu Principal Usuarios'+g_q+','+
      g_q+'SVS'+g_q+')')=false then
      dm.aborta('ERROR... no puede crear Capacidad de SVS');
   if dm.sqlinsert('insert into tscapacidad (ccapacidad, crol) values('+
      g_q+'Menu Principal Capacidades'+g_q+','+
      g_q+'SVS'+g_q+')')=false then
      dm.aborta('ERROR... no puede crear Capacidad de SVS');
   if dm.sqlinsert('insert into tscapacidad (ccapacidad, crol) values('+
      g_q+'Menu Principal Asigna Rol a Usuario'+g_q+','+
      g_q+'SVS'+g_q+')')=false then
      dm.aborta('ERROR... no puede crear Capacidad de SVS');
   if dm.sqlinsert('insert into tscapacidad (ccapacidad, crol) values('+
      g_q+'Menu Principal Sys-Mining'+g_q+','+
      g_q+'SVS'+g_q+')')=false then
      dm.aborta('ERROR... no puede crear Capacidad de SVS');
   if dm.sqlinsert('insert into tscapacidad (ccapacidad, crol) values('+
      g_q+'Administracion Caducidad'+g_q+','+
      g_q+'SVS'+g_q+')')=false then
      dm.aborta('ERROR... no puede crear Caducidad de SVS');
   if dm.sqlinsert('insert into tscapacidad (ccapacidad, crol) values('+
      g_q+'Administracion Monitoreo'+g_q+','+
      g_q+'SVS'+g_q+')')=false then
      dm.aborta('ERROR... no puede crear Monitoreo de SVS');
   if dm.sqlinsert('insert into tscapacidad (ccapacidad, crol) values('+
      g_q+'Mining - Inventario'+g_q+','+
      g_q+'SVS'+g_q+')')=false then
      dm.aborta('ERROR... no puede crear Monitoreo de SVS');
//
   if dm.sqlinsert('create table parametro (clave    varchar(20) NOT NULL,'+
                                         'secuencia  integer         NULL,'+
                                         'dato       varchar(200)    NULL) ')=false then
      dm.aborta('ERROR... no puede crear tabla parametro');
   if dm.sqlinsert('insert into parametro (clave,secuencia,dato) values('+
      g_q+'VERSIONSHD'+g_q+','+
      '200811290'+','+
//      g_q+'SysViewSoft Software Configuration Management 5.00.00'+g_q+')')=false then
      g_q+'Sys-Mining 6.0.1'+g_q+')')=false then
      dm.aborta('ERROR... no puede crear version');
   if dm.sqlinsert('insert into parametro (clave,secuencia,dato) values('+
      g_q+'WEB-INICIO'+g_q+','+
      '1'+','+
      g_q+'www.sysviewsoft.com'+g_q+')')=false then
      dm.aborta('ERROR... no puede crear web-inicio');
   if dm.sqlinsert('insert into parametro (clave,secuencia,dato) values('+
      g_q+'EMPRESA-NOMBRE-1'+g_q+','+
      '1'+','+
      g_q+'SysViewSoft S.A. de C.V.'+g_q+')')=false then
      dm.aborta('ERROR... no puede crear Nombre empresa 1');
   if dm.sqlinsert('insert into parametro (clave,secuencia,dato) values('+
      g_q+'EMPRESA-NOMBRE-2'+g_q+','+
      '1'+','+
      g_q+''+g_q+')')=false then
      dm.aborta('ERROR... no puede crear Nombre empresa 2');
   if dm.sqlinsert('create table tsblob (cblob    varchar(25)      NOT NULL,'+
                                         'path    varchar(300)         NULL,'+
                                         'blo     blob             NOT NULL,'+
                                         'primary key (cblob))')=false then
      dm.aborta('ERROR... no puede crear tabla tsblob');
   if dm.sqlinsert('create table tsbib (cbib    varchar(30)      NOT NULL,'+
                                         'descripcion   varchar(200) NULL,'+
                                         'ip  varchar(200)           NULL,'+
                                         'path  varchar(200)         NULL,'+
                                         'primary key (cbib)) ')=false then
      dm.aborta('ERROR... no puede crear tabla tsbib');
   if dm.sqlinsert('create table tsclase (cclase    varchar(10)      NOT NULL,'+
                                         'tipo          varchar(20)  NOT NULL,'+
                                         'descripcion   varchar(200)     NULL,'+
                                         'analizador    varchar(50)     NULL,'+
                                         'primary key (cclase))')=false then
      dm.aborta('ERROR... no puede crear tabla tsclase');
   {
   if dm.sqlinsert('insert into tsclase (cclase,descripcion) values('+
      g_q+'MOD'+g_q+','+g_q+'SISTEMA'+g_q+')')=false then
      dm.aborta('ERROR... no puede insertar la clase MOD (SISTEMA)');
   }
   if dm.sqlinsert('insert into tsclase (cclase,tipo,descripcion) values('+
      g_q+'CLA'+g_q+','+g_q+'NO ANALIZABLE'+g_q+','+g_q+'CLASES'+g_q+')')=false then
      dm.aborta('ERROR... no puede insertar la clase CLA (CLASES)');
   if dm.sqlinsert('insert into tsclase (cclase,tipo,descripcion) values('+
      g_q+'LOC'+g_q+','+g_q+'NO ANALIZABLE'+g_q+','+g_q+'ARCHIVO LOCAL'+g_q+')')=false then
      dm.aborta('ERROR... no puede insertar la clase LOC (ARCHIVO LOCAL)');
   if dm.sqlinsert('insert into tsclase (cclase,tipo,descripcion,analizador) values('+
      g_q+'CBL'+g_q+','+g_q+'ANALIZABLE'+g_q+','+g_q+'PROGRAMA COBOL'+g_q+','+
      g_q+'RGMIBM'+g_q+')')=false then
      dm.aborta('ERROR... no puede insertar la clase CBL (PROGRAMA COBOL)');

   if dm.sqlinsert('create table tsprog (cprog        varchar(50) NOT NULL,'+
                                         'cbib        varchar(30) NOT NULL,'+
                                         'cclase      varchar(10) NOT NULL,'+
                                         'fecha       date        NOT NULL,'+
                                         'cbibbin     varchar(30)     NULL,'+
                                         'descripcion varchar(200)    NULL,'+
                                         'analizado   varchar(25)     NULL,'+
                                         'cblob       varchar(25)     NULL,'+
                                         'magic       varchar(30)     NULL,'+
                                         'primary key (cprog,cbib)) ')=false then
      dm.aborta('ERROR... no puede crear tabla tsprog');
   if dm.sqlinsert('alter table tsprog add (constraint tsprog_cclase_fk foreign key (cclase) '+
      'references tsclase (cclase) '+
      'on delete set null)')=false then
      dm.aborta('ERROR... no puede crear constraint tsprog_cclase_fk');
   if dm.sqlinsert('alter table tsprog add (constraint tsprog_cbib_fk foreign key (cbib) '+
      'references tsbib (cbib) '+
      'on delete set null)')=false then
      dm.aborta('ERROR... no puede crear constraint tsprog_cbib_fk');
   if dm.sqlinsert('create table tsversion (cprog        varchar(50) NOT NULL,'+
                                         'cbib        varchar(30) NOT NULL,'+
                                         'cclase      varchar(10) NOT NULL,'+
                                         'fecha       date        NOT NULL,'+
                                         'cuser       varchar(30) NOT NULL,'+
                                         'cblob       varchar(25)     NULL,'+
                                         'magic       varchar(30)     NULL) ')=false then
      dm.aborta('ERROR... no puede crear tabla tsversion');
   if dm.sqlinsert('create index idx_tsversion_cprog on tsversion(cprog,cbib,cclase)')=false then
      dm.aborta('ERROR... no puede crear index tsversion - cprog,cbib,cclase');
   if dm.sqlinsert('create table tsparams (cprog        varchar(250) NOT NULL,'+
                                         'cbib        varchar(250) NOT NULL,'+
                                         'cclase      varchar(10)  NOT NULL,'+
                                         'param       varchar(30)  NOT NULL,'+
                                         'valor       varchar(200)    NULL,'+
                                         'primary key (cprog,cbib,cclase)) ')=false then
      dm.aborta('ERROR... no puede crear tabla tsparams');

   if dm.sqlinsert('create table tsoficina (coficina  varchar(30) NOT NULL,'+
                                         'descripcion varchar(200)    NULL,'+
                                         'direccion   varchar(200)     NULL) ')=false then
      dm.aborta('ERROR... no puede crear tabla tsoficina');
   if dm.sqlinsert('alter table tsoficina add primary key (coficina)')=false then
      dm.aborta('ERROR... no puede crear primary key tsoficina - coficina');
   if dm.sqlinsert('create table tssistema (csistema  varchar(30) NOT NULL,'+
                                         'coficina    varchar(30) NOT NULL,'+
                                         'descripcion varchar(200)    NULL,'+
                                         'cdepende    varchar(30)     NULL) ')=false then
      dm.aborta('ERROR... no puede crear tabla tssistema');
   if dm.sqlinsert('alter table tssistema add primary key (csistema)')=false then
      dm.aborta('ERROR... no puede crear primary key tssistema - csistema');
   if dm.sqlinsert('alter table tssistema add (constraint tssistema_coficina_fk foreign key (coficina) '+
      'references tsoficina (coficina) '+
      'on delete set null)')=false then
      dm.aborta('ERROR... no puede crear constraint tssistema_coficina_fk');

   if dm.sqlinsert('create table tsrela (pcprog        varchar(30) NOT NULL,'+
                                         'pcbib        varchar(30) NOT NULL,'+
                                         'pcclase      varchar(10) NOT NULL,'+
                                         'hcprog        varchar(30) NOT NULL,'+
                                         'hcbib        varchar(30) NOT NULL,'+
                                         'hcclase      varchar(10) NOT NULL,'+
                                         'modo         varchar(10)     NULL,'+
                                         'organizacion varchar(10)     NULL,'+
                                         'externo      varchar(50)     NULL,'+
                                         'coment       varchar(200)    NULL,'+
                                         'orden        varchar(10)     NULL,'+
                    'primary key (pcprog,pcbib,pcclase,hcprog,hcbib,hcclase)) ')=false then
      dm.aborta('ERROR... no puede crear tabla tsrela');
   if dm.sqlinsert('create index idx_tsrela_hijo on tsrela(hcprog,hcbib,hcclase)')=false then
      dm.aborta('ERROR... no puede crear index tsrela - hcprog,hcbib,hcclase');
   {
   if dm.sqlinsert('alter table tsrela add (constraint tsrela_pcprog_pcbib_fk foreign key (pcprog,pcbib) '+
      'references tsprog (cprog,cbib) '+
      'on delete set null)')=false then
      dm.aborta('ERROR... no puede crear constraint tsrela_pcprog_pcbib_fk');
   if dm.sqlinsert('alter table tsrela add (constraint tsrela_hcprog_hcbib_fk foreign key (hcprog,hcbib) '+
      'references tsprog (cprog,cbib) '+
      'on delete set null)')=false then
      dm.aborta('ERROR... no puede crear constraint tsrela_hcprog_hcbib_fk');
   }
   if dm.sqlinsert('alter table tsrela add (constraint tsrela_pcclase_fk foreign key (pcclase) '+
      'references tsclase (cclase) '+
      'on delete set null)')=false then
      dm.aborta('ERROR... no puede crear constraint tsrela_pcclase_fk');
   if dm.sqlinsert('alter table tsrela add (constraint tsrela_hcclase_fk foreign key (hcclase) '+
      'references tsclase (cclase) '+
      'on delete set null)')=false then
      dm.aborta('ERROR... no puede crear constraint tsrela_hcclase_fk');
   if dm.sqlinsert('create table tsutileria (cutileria  varchar(50) NOT NULL,'+
                                          'descripcion varchar(200)    NULL,'+
                                          'magic       varchar(30)     NULL,'+
                                         'cblob        varchar(25)     NULL) ')=false then
      dm.aborta('ERROR... no puede crear tabla tsutileria');
   if dm.sqlinsert('alter table tsutileria add primary key (cutileria)')=false then
      dm.aborta('ERROR... no puede crear primary key tsutileria - cutileria');
   close;
end;

procedure TFcreabas.bcancelClick(Sender: TObject);
begin
   close;
end;

end.
