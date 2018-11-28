unit ptscaducidad;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Buttons, Menus, dxBar;
type Tusrol=record
   rol:string;
   r_nom:string;
   cuser:string;
   u_nom:string;
   fecha_caducidad:string;
end;
type
  Tftscaducidad = class(TForm)
    lv: TListView;
    passw_fecha: TPanel;
    pw: TEdit;
    fechcad: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    lbltit: TLabel;
    aceptar: TBitBtn;
    salir: TBitBtn;
    Label3: TLabel;
    Cambia_pass: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    npw: TEdit;
    npw2: TEdit;
    npaceptar: TBitBtn;
    np_salir: TBitBtn;
    mnuAdmin: TdxBarManager;
    mnuCambiaPassw: TdxBarButton;
    mnucaducidad: TdxBarButton;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure consulta_sql;
    procedure salirClick(Sender: TObject);
    procedure aceptarClick(Sender: TObject);
    procedure pwExit(Sender: TObject);
    procedure npwExit(Sender: TObject);
    procedure npaceptarClick(Sender: TObject);
    procedure np_salirClick(Sender: TObject);
    procedure mnuCambiaPasswClick(Sender: TObject);
    procedure mnucaducidadClick(Sender: TObject);
    procedure fechcadExit(Sender: TObject);

  private
   rr:array of Tusrol;
   n:integer;
   function bValidaPass: Boolean;
   function bValidaFecha: Boolean;
    { Private declarations }
  public
   WWpass:string;
   ww:integer;
    { Public declarations }
  end;

var
  ftscaducidad: Tftscaducidad;
  procedure CADUCIDAD;
implementation

uses ptsdm, ptsgral;

{$R *.dfm}

procedure CADUCIDAD;
begin
   Application.CreateForm( Tftscaducidad, ftscaducidad );
   try
      ftscaducidad.Show;
   finally
      //ftscaducidad.Free;
   end;
end;

procedure Tftscaducidad.FormCreate;
   var  k:integer;
begin
   if gral.bPubVentanaMaximizada = FALSE then begin
      ftscaducidad.Width:= g_Width;
      ftscaducidad.Height:= g_Height;
   end;
   //ftscaducidad.Constraints.MaxWidth:= g_MaxWidth;
   ftscaducidad.BorderIcons:=BorderIcons - [biMinimize];
   g_Wforma_Aux:='caducidad SysMining';
   lv.Columns[0].Width:=1;
   lv.Columns[1].Width:=90;
   lv.Columns[2].Width:=100;
   lv.Columns[3].Width:=90;
   lv.Columns[4].Width:=200;
   lv.Columns[5].Width:=150;
   ftscaducidad.Caption:='Caducidad';
   ftscaducidad.Visible:=true;
   ftscaducidad.consulta_sql;
   ftscaducidad.Show;
   screen.Cursor:=crdefault;
   g_Wforma_Aux:='';
end;

procedure Tftscaducidad.Consulta_sql;
var ite:Tlistitem;
      k1,k,i:integer;
      Wfech_cad:string;
begin
   ww:=0;
   lv.items.Clear;
   n:=0;
   setlength(rr,0);

   if dm.sqlselect(dm.q1,'select crol,descripcion from tsroles where crol <> '+g_q+'SVS'+g_q) then begin
      while not dm.q1.Eof do begin
       Wfech_cad:='';
       if dm.sqlselect(dm.q2,'select * from parametro where clave = '+
                       g_q+'ROL_'+dm.q1.FieldByName('crol').AsString+g_q+' and secuencia=1') then begin
         Wfech_cad:=dm.q2.FieldByName('dato').AsString;
         Wfech_cad:=dm.desencripta(Wfech_cad);
       end else begin
         Wfech_cad:=formatdatetime('YYYYMMDD',now);
         dm.sqlinsert('insert into parametro (CLAVE,SECUENCIA,DATO,DESCRIPCION) '+
                  ' values('+g_q+'ROL_'+dm.q1.FieldByName('crol').AsString+g_q+',1,'+g_q+dm.encripta(formatdatetime('YYYYMMDD',now))+g_q+','+
                  g_q+'Fecha de caducidad '+g_q+')');
       end;

       dm.sqlselect(dm.q2,'select tru.cuser,tu.nombre,tu.paterno,tu.materno '+
                          ' from tsroluser tru, tsuser tu  where tru.crol='+
                          g_q+dm.q1.FieldByName('crol').AsString+g_q+' and tu.cuser=tru.cuser');
       while not dm.q2.Eof do begin
            k:=length(rr);
            setlength(rr,k+1);

            rr[k].rol:=dm.q1.FieldByName('crol').AsString;
            rr[k].r_nom:=dm.q1.FieldByName('descripcion').AsString;
            rr[k].cuser:=dm.q2.FieldByName('cuser').AsString;
            rr[k].u_nom:=dm.q2.FieldByName('nombre').AsString+' '+
                      dm.q2.FieldByName('paterno').AsString+' '+
                      dm.q2.FieldByName('materno').AsString;
            rr[k].fecha_caducidad:=Wfech_cad;
            dm.q2.Next;
        end;
        dm.q1.Next;
      end;
   end;

   k:=length(rr);
   n:=0;
   for i:=0 to k-1 do begin
      ite:=lv.Items.Add;
      ite.Caption:='';
      ite.SubItems.Add(rr[i].rol);
      ite.SubItems.Add(rr[i].r_nom);
      ite.SubItems.Add(rr[i].cuser);
      ite.SubItems.Add(rr[i].u_nom);
      ite.SubItems.Add(rr[i].fecha_caducidad);
      n:=n+1;
      if n mod 1000=0 then break;
   end;
end;

procedure Tftscaducidad.BitBtn1Click(Sender: TObject);
begin
   close;
end;

procedure Tftscaducidad.salirClick(Sender: TObject);
begin
     pw.Clear;
     fechcad.Clear;
     passw_fecha.Visible:=false;
     //consulta_sql;
end;

function Tftscaducidad.bValidaPass: Boolean;
begin
   if pw.text <> WWpass then begin
      Application.MessageBox(PChar('Password invalido'),PChar('Actualizar fecha caducidad '),MB_OK );
      WW:=WW+1;
      pw.SetFocus;
   end else  begin
      ww:=0;
   end;
end;

function Tftscaducidad.bValidaFecha: Boolean;
begin
   if fechCad.text = ' ' then begin
      Application.MessageBox(PChar('Fecha Invalida'),PChar('Actualizar fecha caducidad '),MB_OK );
      fechCad.SetFocus;
   end;
end;

procedure Tftscaducidad.aceptarClick(Sender: TObject);
var     Wfec_cad:string;
begin
   if Trim( pw.Text )= '' then begin
      Application.MessageBox(PChar('Password invalido'),
                             PChar('Teclee el Password'),MB_OK );
      Exit;
   end;

   if Trim( fechCad.Text )= '' then begin
      Application.MessageBox(PChar('Fecha Invalida'),
                             PChar('Actualiza fecha caducidad '),MB_OK );
      Exit;
   end;

   if ww > 0 then begin
      Application.MessageBox(PChar('Password invalido'),
                             PChar('Actualiza fecha caducidad '),MB_OK );
   end else begin
      Wfec_cad:=fechcad.text;
      Wfec_cad:=dm.encripta(Wfec_cad);
         if dm.sqlupdate('update parametro '+
            ' set dato='+g_q+Wfec_cad+g_q+
            ' where clave='+g_q+'ROL_'+lv.Selected.SubItems[0]+g_q+
            ' and secuencia = 1')=false then
            dm.aborta('ERROR... no puede actualizar la fecha de caducidad');
      pw.Clear;
      fechcad.Clear;
      passw_fecha.Visible:=false;
      consulta_sql;
   end;
end;

procedure Tftscaducidad.pwExit(Sender: TObject);

begin
   if Trim( pw.Text ) = '' then  begin
      Application.MessageBox(PChar('Es necesario teclear el password '),PChar('Actualizar fecha caducidad'),MB_OK );
      Exit;
   end;
   bValidaPass;

   {if pw.text <> WWpass then begin
      Application.MessageBox(PChar('Password invalido'),PChar('Actualizar fecha caducidad Sys-Mining'),MB_OK );
      WW:=WW+1;
      pw.SetFocus;
   end else  begin
      ww:=0;
   end;}
end;

procedure Tftscaducidad.fechcadExit(Sender: TObject);
begin
    if Trim( fechCad.Text ) = '' then  begin
      Application.MessageBox(PChar('Es necesario teclear una fecha valida '),PChar('Actualizar fecha caducidad'),MB_OK );
      Exit;
    end;
    bValidaFecha;
end;

procedure Tftscaducidad.npwExit(Sender: TObject);
begin
   if npw.text <> WWpass then begin
      Application.MessageBox(PChar('Password invalido'),PChar('Actualizar password para cambiar fecha caducidad '),MB_OK );
      WW:=WW+1
   end else  begin
      ww:=0;
   end;

end;

procedure Tftscaducidad.npaceptarClick(Sender: TObject);
var     Wnvo_pass:string;
begin
   if ww > 0 then begin
      Application.MessageBox(PChar('Password invalido'),
                             PChar('Actualiza password para cambiar fecha caducidad '),MB_OK );
   end else begin
      Wnvo_pass:=npw2.text;
      Wnvo_pass:=dm.encripta(Wnvo_pass);
         if dm.sqlupdate('update parametro '+
            ' set dato='+g_q+Wnvo_pass+g_q+
            ' where clave='+g_q+'PASSW_CAD'+g_q+
            ' and secuencia = 1')=false then
            dm.aborta('ERROR... no puede actualizar password');
      npw.Clear;
      npw2.Clear;
      cambia_pass.Visible:=false;
      consulta_sql;
   end;

end;

procedure Tftscaducidad.np_salirClick(Sender: TObject);
begin
     npw.Clear;
     npw2.Clear;
     cambia_pass.Visible:=false;
     consulta_sql;
end;

procedure Tftscaducidad.mnuCambiaPasswClick(Sender: TObject);
   var Wpass:string;
       i,ii:integer;
begin
   cambia_pass.Left:=152;
   cambia_pass.top:=128;
   cambia_pass.Visible:=TRUE ;
   npw.SetFocus;

   dm.sqlselect(dm.q2,'select dato from parametro where clave  = '+g_q+'PASSW_CAD'+g_q+' and secuencia=1');
   WWpass:=dm.q2.FieldByName('dato').AsString;
   WWpass:=dm.desencripta(WWpass);
end;

procedure Tftscaducidad.mnucaducidadClick(Sender: TObject);
var Wpass,WWfecha:string;
    Wfec_cad:string;
    i:integer;
begin
   if g_usuario <> 'SVS' then begin
      Application.MessageBox(PChar('Usuario '+g_usuario+', no autorizado para cambiar fecha caducidad'),
                             PChar('Actualizar fecha caducidad  '),MB_OK );
      exit;
   end else begin
      dm.sqlselect(dm.q2,'select PASSWORD from tsuser where cuser = '+g_q+'SVS'+g_q);
      WWpass:=dm.q2.FieldByName('PASSWORD').AsString;
  end;
  if lv.ItemIndex < 0 then begin
     Application.MessageBox(PChar('Es necesario seleccionar un registro '),PChar('Actualizar fecha caducidad'),MB_OK );
     exit;
  end;

  passw_fecha.Visible:=TRUE ;
  passw_fecha.SetFocus;

   lbltit.Caption:='Actualizar fecha caducidad : '+' Rol - '+
                      lv.Selected.SubItems[0];

   // si el registro del password para cambiar la fecha de caducidad no existe, crea el registro y el password es SVS.
   // este de puede cambiar, más adelante.
   if dm.sqlselect(dm.q2,'select * from parametro where clave = '+g_q+'PASSW_CAD'+g_q+
                         ' and secuencia=1') = FALSE then begin
      dm.sqlinsert('insert into parametro (CLAVE,SECUENCIA,DATO,DESCRIPCION) '+
                  ' values('+g_q+'PASSW_CAD'+g_q+',1,'+g_q+WWpass+g_q+','+
                  g_q+'Password para cambiar fecha de caducidad'+g_q+')');
   end else
      WWpass:=dm.q2.FieldByName('dato').AsString;
   WWpass:=dm.desencripta(WWpass);

   // si el registro de la fecha de caducidad del ROL no existe, lo da de alta con fecha de caducidad del dia
   if dm.sqlselect(dm.q2,'select * from parametro where clave = '+g_q+'ROL_'+lv.Selected.SubItems[0]+g_q+
                   ' and secuencia = 1') = FALSE then begin
      WWfecha:=dm.encripta(formatdatetime('YYYYMMDD',now));
      dm.sqlinsert('insert into parametro (CLAVE,SECUENCIA,DATO,DESCRIPCION) '+
                  ' values('+g_q+'ROL_'+lv.Selected.SubItems[0]+g_q+',1,'+g_q+WWfecha+g_q+','+
                  g_q+'Fecha de caducidad '+g_q+')')
   end else
   WWfecha:=dm.q2.FieldByName('dato').AsString;
   WWfecha:=dm.desencripta(WWfecha);

   dm.sqlselect(dm.q2,'select dato from parametro where clave  = '+g_q+'PASSW_CAD'+g_q+' and secuencia=1');
   WWpass:=dm.q2.FieldByName('dato').AsString;
   WWpass:=dm.desencripta(WWpass);
   pw.SetFocus;
end;
end.
