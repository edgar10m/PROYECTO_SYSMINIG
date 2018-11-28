unit ptsadminctrusu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, DB, ADODB, StdCtrls, Buttons, ExtCtrls, Menus, dxBar, HTML_HELP, htmlhlp;

type
  Tftsadminctrusu = class(TForm)
    lv: TListView;
    PopupMenu1: TPopupMenu;
    ClaveUsuario1: TMenuItem;
    fecha_entrada: TMenuItem;
    fecha_salida: TMenuItem;
    ControlTiempo1: TMenuItem;
    NombreUsuario1: TMenuItem;
    mnuPrincipal: TdxBarManager;
    mnuAyuda: TdxBarButton;
    procedure Consulta;
    procedure Consulta_sql;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lvColumnClick(Sender: TObject; Column: TListColumn);
    procedure ClaveUsuario1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure fecha_entradaClick(Sender: TObject);
    procedure fecha_salidaClick(Sender: TObject);
    procedure ControlTiempo1Click(Sender: TObject);
    procedure NombreUsuario1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mnuAyudaClick(Sender: TObject);
  private
    n:integer;
    { Private declarations }
  public
    { Public declarations }
    p_columna:string;
    p_columna_ant:string;
    p_orden:string;
    Wselect:string;
    Wcuando:string;
    rol_usuario, rol_descripcion : Tstringlist;
  end;

var
  ftsadminctrusu : Tftsadminctrusu;
  procedure CONTROLUSUARIOS;
implementation

uses ptsdm, ptsgral ;
{$R *.dfm}

procedure CONTROLUSUARIOS;
begin
   Application.CreateForm( Tftsadminctrusu, ftsadminctrusu );
   try
      ftsadminctrusu.Show;
   finally
      //ftsadminctrusu.Free;
   end;
end;

procedure Tftsadminctrusu.FormCreate;
begin
   if gral.bPubVentanaMaximizada = FALSE then begin
     ftsadminctrusu.Width:= g_Width;
     ftsadminctrusu.Height:= g_Height;
   end;
   //ftsadminctrusu.Constraints.MaxWidth:= g_MaxWidth;
   ftsadminctrusu.BorderIcons:=BorderIcons - [biMinimize];
   g_Wforma_Aux:='monitorea_usuarios';
   Wcuando:=' where cuser <> '+g_q+'SVS'+g_q+' ';
   p_columna:='cuser';
   p_columna_ant:='cuser';
   p_orden:='desc';
   Wselect:='select cuser, to_char(fecha_entrada,'+g_q+'YYYY/MM/DD HH24:MI.SS'+g_q+
            ') fecha_entrada ,to_char(fecha_salida,'+g_q+'YYYY/MM/DD HH24:MI.SS'+g_q+
            ') fecha_salida, to_char(control_tiempo,'+g_q+'YYYY/MM/DD HH24:MI.SS'+g_q+
            ')control_tiempo from tslogon ';

   rol_usuario:=tstringlist.Create;     // Arma arreglo de rol usuario
   rol_descripcion:=tstringlist.Create;
   if dm.sqlselect(dm.q1,'select * from tsroluser order by cuser') then begin
      while not dm.q1.Eof do begin
         rol_usuario.Add(dm.q1.fieldbyname('cuser').AsString);
         rol_descripcion.Add(dm.q1.fieldbyname('crol').AsString);
         dm.q1.Next;
      end;
   end;
   lv.Columns[0].Width:=90;
   lv.Columns[1].Width:=100;
   lv.Columns[2].Width:=150;
   lv.Columns[3].Width:=150;
   lv.Columns[4].Width:=150;
   ftsadminctrusu.Caption:='Monitoreo de usuarios';
   ftsadminctrusu.Visible:=true;
   ftsadminctrusu.consulta_sql;
   ftsadminctrusu.Show;
   screen.Cursor:=crdefault;
   g_Wforma_Aux:='';
end;

procedure Tftsadminctrusu.Consulta;
begin
   g_Wforma_Aux:='';
end;

procedure Tftsadminctrusu.Consulta_sql;
var ite:Tlistitem;
    Wrol:string;
begin
   lv.items.Clear;
   n:=0;
   if p_columna='' then p_columna:='cuser';
   dm.sqlselect(dm.q1,Wselect+' '+Wcuando+' order by '+p_columna+' '+p_orden);
   while not dm.q1.Eof do begin
      Wrol:=rol_descripcion[rol_usuario.IndexOf(dm.q1.fieldbyname('cuser').AsString)];
      ite:=lv.Items.Add;
      ite.Caption:=Wrol;
      ite.SubItems.Add(dm.q1.fieldbyname('cuser').AsString);
      ite.SubItems.Add(dm.q1.fieldbyname('fecha_entrada').AsString);
      ite.SubItems.Add(dm.q1.fieldbyname('fecha_salida').AsString);
      ite.SubItems.Add(dm.q1.fieldbyname('control_tiempo').AsString);
      dm.q1.Next;
      n:=n+1;
      if n mod 1000=0 then break;
   end;
   Wcuando:=''
end;
procedure Tftsadminctrusu.BitBtn1Click(Sender: TObject);
begin
    rol_usuario.Free;
    rol_descripcion.Free;
    close;
end;

procedure Tftsadminctrusu.lvColumnClick(Sender: TObject; Column: TListColumn);
begin
   if column.Caption <> 'Crol' then begin
      p_columna_ant := p_columna;
      p_columna:=column.Caption;
      if p_columna_ant <> p_columna then
         p_orden :=  'desc'
      else
         p_orden:= 'asc' ;
      Consulta_sql;
  end;
end;
procedure Tftsadminctrusu.ClaveUsuario1Click(Sender: TObject);
var  usuario :string;
begin
   if lv.SelCount=0 then exit;
   usuario:=lv.Selected.SubItems[0];
   Wcuando:= ' where (cuser = '+g_q+usuario+g_q+') and (cuser <> '+g_q+'SVS'+g_q+')';
   p_orden:='asc';
   p_columna:='cuser';
   Consulta_sql;
end;
procedure Tftsadminctrusu.PopupMenu1Popup(Sender: TObject);
begin
   if lv.SelCount=0 then abort;
end;

procedure Tftsadminctrusu.fecha_entradaClick(Sender: TObject);
var   fe :string;
begin
   if lv.SelCount=0 then exit;
   fe:=copy(lv.Selected.SubItems[1],1,10);
   Wcuando:= ' where to_char(fecha_entrada,'+g_q+'yyyy/mm/dd'+g_q+') = '+g_q+fe+g_q;
   p_orden:='desc';
   p_columna:='fecha_entrada';
   Consulta_sql;
end;

procedure Tftsadminctrusu.fecha_salidaClick(Sender: TObject);
var   fs :string;
begin
   if lv.SelCount=0 then exit;
   fs:=copy(lv.Selected.SubItems[2],1,10);
   Wcuando:= ' where to_char(fecha_salida,'+g_q+'yyyy/mm/dd'+g_q+') = '+g_q+fs+g_q;
   p_orden:='desc';
   p_columna:='fecha_salida';
   Consulta_sql;
end;
procedure Tftsadminctrusu.ControlTiempo1Click(Sender: TObject);
var   ct :string;
begin
   if lv.SelCount=0 then exit;
   if lv.Selected.SubItems[3]='' then
      Wcuando:= ' where control_tiempo IS NULL'
   else begin
      ct:=copy(lv.Selected.SubItems[3],1,10);
      Wcuando:= ' where to_char(control_tiempo,'+g_q+'yyyy/mm/dd'+g_q+') = '+g_q+ct+g_q;
   end;
   p_orden:='desc';
   p_columna:='control_tiempo';
   Consulta_sql;
end;
procedure Tftsadminctrusu.NombreUsuario1Click(Sender: TObject);
 var Wnombre:string;
begin
   if lv.SelCount=0 then exit;
   dm.sqlselect(dm.q2,'select nombre,paterno,materno from tsuser where cuser='+g_q+lv.Selected.SubItems[0]+g_q);
   Wnombre:= dm.q2.fieldbyname('nombre').AsString+' '+dm.q2.fieldbyname('paterno').AsString+' '+
             dm.q2.fieldbyname('materno').AsString;
   Application.MessageBox(PChar(Wnombre),PChar('Nombre del usuario: '+lv.Selected.SubItems[0]),MB_OK );
end;
procedure Tftsadminctrusu.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    rol_usuario.Free;
    rol_descripcion.Free;
end;

procedure Tftsadminctrusu.mnuAyudaClick(Sender: TObject);
begin
   try
      HtmlHelp(Application.Handle,
            PChar(Format('%s::/T%5.5d.htm',
           //[Application.HelpFile,ActiveControl.HelpContext])),HH_DISPLAY_TOPIC, 0);
           [ Application.HelpFile,HTML_HELP.IDH_TOPIC_T02101 ])),HH_DISPLAY_TOPIC, 0);
   except
      Application.MessageBox( 'No existe ayuda para la pantalla ó campo seleccionado','Ayuda ' , MB_OK );
   end;

end;

end.

