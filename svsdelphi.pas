unit svsdelphi;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, Grids, DBGrids, extctrls, stdctrls;
type Tliga=record
   origen:string;
   direccion:string;
   destino:string;
   etiqueta:string;
end;
type Treg=record
   objecto:string;
   tipo:string;
   propiedad:string;
   valor:string;
end;
type
  Tfsvsdelphi = class(TForm)
    ittable: TImage;
    idatasource: TImage;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    nombreforma:string;
    formawidth,formaheight:integer;
    yexterno:integer;
    rr:array of Treg;
    lg:array of Tliga;
    padre:Twincontrol;
    dbgrid:Tdbgrid;
    panel:Tpanel;
    clabel:TLabel;
    cshape:TShape;
    cedit:Tedit;
    ccheckbox:Tcheckbox;
    cbutton:TButton;
    cimage:Timage;
   procedure liga(origen:string; direccion:string; destino:string; etiqueta:string);
   function p_caption(objeto:string):string;
   function x_align(valor:string):Talign;
   function x_caption(valor:string):string;
   procedure crea_tipo(tipo:string; nombre:string);
  public
    { Public declarations }
   procedure arma_pantalla(forma:string);
  end;

var
  fsvsdelphi: Tfsvsdelphi;
  procedure PR_PANTALLA;

implementation

uses ptsdm, ptsgral;

{$R *.dfm}
procedure PR_PANTALLA;
begin
   Application.CreateForm( Tfsvsdelphi, fsvsdelphi );
   if gral.bPubVentanaMaximizada = FALSE then begin
      fsvsdelphi.Width  := g_Width;
      fsvsdelphi.Height := g_Height;
   end;
end;

procedure Tfsvsdelphi.liga(origen:string; direccion:string; destino:string; etiqueta:string);
var k:integer;
begin
   k:=length(lg);
   setlength(lg,k+1);
   lg[k].origen:=origen;
   lg[k].direccion:=direccion;
   lg[k].destino:=destino;
   lg[k].etiqueta:=etiqueta;
end;
function Tfsvsdelphi.p_caption(objeto:string):string;
var i:integer;
begin
   for i:=0 to length(rr)-1 do
      if (rr[i].objecto=objeto) and (rr[i].propiedad='Caption') then begin
         p_caption:=copy(rr[i].valor,2,length(rr[i].valor)-2);
         exit;
      end;
   p_caption:='';
end;
function Tfsvsdelphi.x_align(valor:string):Talign;
begin
//   x_align:=alNone;
//   exit;
   if valor='alNone' then x_align:=alNone else
   if valor='alTop' then x_align:=alTop else
   if valor='alBottom' then x_align:=alBottom else
   if valor='alLeft' then x_align:=alLeft else
   if valor='alRight' then x_align:=alRight else
   if valor='alClient' then x_align:=alClient else
   if valor='alCustom' then x_align:=alCustom;
end;
function Tfsvsdelphi.x_caption(valor:string):string;
begin
   x_caption:=copy(valor,2,length(valor)-2);
end;
procedure Tfsvsdelphi.crea_tipo(tipo:string; nombre:string);
begin
   if tipo='TDBGrid' then begin
      dbgrid:=TDBGrid.create(padre);
      dbgrid.Parent:=padre;
      dbgrid.Name:=nombre;
      dbgrid.Visible:=true;
      padre:=dbgrid;
   end else
   if tipo='TPanel' then begin
      panel:=TPanel.create(padre);
      panel.Parent:=padre;
      panel.Name:=nombre;
      panel.Caption:='';
      panel.Visible:=true;
      padre:=panel;
//      if nombre='Panel2' then abort;

   end else
   if tipo='TShape' then begin
      cshape:=TShape.create(padre);
      cshape.Parent:=padre;
      cshape.Name:=nombre;
      cshape.Visible:=true;
//      padre:=cshape;
   end else
   if tipo='TLabel' then begin
      clabel:=TLabel.create(padre);
      clabel.Parent:=padre;
      clabel.Name:=nombre;
      clabel.Visible:=true;
//      padre:=clabel;
   end else
   if tipo='TEdit' then begin
      cedit:=TEdit.create(padre);
      cedit.Parent:=padre;
      cedit.Name:=nombre;
      cedit.Visible:=true;
//      padre:=cedit;
   end else
   if tipo='TCheckBox' then begin
      ccheckbox:=TCheckBox.create(padre);
      ccheckbox.Parent:=padre;
      ccheckbox.Name:=nombre;
      ccheckbox.Visible:=true;
//      padre:=cedit;
   end else
   if tipo='TButton' then begin
      cbutton:=TButton.create(padre);
      cbutton.Parent:=padre;
      cbutton.Name:=nombre;
      cbutton.Visible:=true;
//      padre:=cedit;
   end else
   if tipo='TTable' then begin
      cimage:=Timage.create(fsvsdelphi);
      cimage.Parent:=fsvsdelphi;
      cimage.Name:=nombre;
      cimage.Visible:=true;
      cimage.AutoSize:=true;
      cimage.Picture.bitmap:=ittable.Picture.bitmap;
      cimage.ShowHint:=true;
      cimage.Left:=formawidth+10;
      cimage.Top:=yexterno;
      yexterno:=yexterno+50;
   end else
   if tipo='TDataSource' then begin
      cimage:=Timage.create(fsvsdelphi);
      cimage.Parent:=fsvsdelphi;
      cimage.Name:=nombre;
      cimage.Visible:=true;
      cimage.AutoSize:=true;
      cimage.Picture.bitmap:=idatasource.Picture.bitmap;
      cimage.ShowHint:=true;
      cimage.Left:=formawidth+10;
      cimage.Top:=yexterno;
      yexterno:=yexterno+50;
   end else
   if tipo='TPopupMenu' then begin
   end else
   if tipo='TMenuItem' then begin
   end else
   if tipo<>'end' then
      Application.MessageBox(pchar('Tipo no definido'),
                             pchar('SVSDelphi '), MB_OK );
end;
procedure Tfsvsdelphi.arma_pantalla(forma:string);
var
   ff,t:Tstringlist;
   i,j,k:integer;
   nom,tipo:string;
begin
   for i:=componentcount-1 downto 0 do begin
      if components[i] is Timage then begin
         if (uppercase((components[i] as Timage).Name)='ITTABLE') or
            (uppercase((components[i] as Timage).Name)='IDATASOURCE') then continue;
         components[i].Free;
      end;
   end;
   if fileexists(forma)=false then exit;
   ff:=Tstringlist.Create;
   ff.LoadFromFile(forma);
   t:=Tstringlist.Create;
   setlength(rr,0);
   for i:=0 to ff.Count-1 do begin
      t.CommaText:=trim(ff[i]);
      if t[0]='object' then begin
         nom:=t[1];
         delete(nom,length(nom),1);
         tipo:=t[2];
         continue;
      end;
      if t[0]='end' then begin
         k:=length(rr);
         setlength(rr,k+1);
         rr[k].tipo:='end';
         rr[k].objecto:=tipo;
         continue;
      end;
      k:=length(rr);
      setlength(rr,k+1);
      rr[k].objecto:=nom;
      rr[k].tipo:=tipo;
      ff[i]:=trim(ff[i]);
      j:=pos(' = ',ff[i]);
      rr[k].propiedad:=copy(ff[i],1,j-1);
      rr[k].valor:=copy(ff[i],j+3,500);
   end;
   tipo:=rr[0].tipo;
   padre:=fsvsdelphi;
   nom:='';
   for i:=0 to length(rr)-1 do begin
      if tipo<>rr[i].tipo then begin
         tipo:=rr[i].tipo;
         crea_tipo(tipo, rr[i].objecto);
      end;
      if tipo=rr[0].tipo then begin
         if rr[i].propiedad='Caption' then caption:=x_caption(rr[i].valor) else
         if rr[i].propiedad='Width' then Width:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Height' then Height:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Width' then formawidth:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Height' then formaheight:=strtoint(rr[i].valor);
      end else
      if tipo='end' then begin
         if (rr[i].objecto<>'TLabel') and
            (rr[i].objecto<>'TEdit') and
            (rr[i].objecto<>'TCheckBox') and
            (rr[i].objecto<>'TButton') and
            (rr[i].objecto<>'TTable') and
            (rr[i].objecto<>'TDataSource') and
            (rr[i].objecto<>'TPopupMenu') and
            (rr[i].objecto<>'TMenuItem') and
            (rr[i].objecto<>'TShape') then
            padre:=padre.Parent
            else
               if rr[i-1].objecto=rr[i].objecto then
                  if padre<>nil then
                     padre:=padre.Parent;
      end else
      if tipo='TDBGrid' then begin
         if rr[i].propiedad='Left' then dbgrid.Left:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Top' then dbgrid.Top:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Width' then dbgrid.Width:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Height' then dbgrid.Height:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Align' then dbgrid.Align:=x_align(rr[i].valor) else
         if rr[i].propiedad='TabOrder' then dbgrid.TabOrder:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Datasource' then liga(rr[i].objecto,'->',rr[i].valor,rr[i].propiedad) else
         if copy(rr[i].propiedad,1,2)='On' then liga(rr[i].objecto,'->',rr[i].valor,rr[i].propiedad);
      end else
      if tipo='TPanel' then begin
         if rr[i].propiedad='Left' then panel.Left:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Top' then panel.Top:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Width' then panel.Width:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Height' then panel.Height:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Align' then panel.Align:=x_align(rr[i].valor) else
         if copy(rr[i].propiedad,1,2)='On' then liga(rr[i].objecto,'->',rr[i].valor,rr[i].propiedad);
      end else
      if tipo='TLabel' then begin
         if rr[i].propiedad='Left' then clabel.Left:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Top' then clabel.Top:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Width' then clabel.Width:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Height' then clabel.Height:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Caption' then clabel.caption:=x_caption(rr[i].valor) else
         if rr[i].propiedad='WordWrap' then clabel.wordwrap:=(rr[i].valor='True') else
         if rr[i].propiedad='AutoSize' then clabel.AutoSize:=(rr[i].valor='True') else
         if copy(rr[i].propiedad,1,2)='On' then liga(rr[i].objecto,'->',rr[i].valor,rr[i].propiedad);
      end else
      if tipo='TCheckBox' then begin
         if rr[i].propiedad='Left' then ccheckbox.Left:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Top' then ccheckbox.Top:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Width' then ccheckbox.Width:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Height' then ccheckbox.Height:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Caption' then ccheckbox.caption:=x_caption(rr[i].valor) else
         if rr[i].propiedad='WordWrap' then ccheckbox.wordwrap:=(rr[i].valor='True') else
         if rr[i].propiedad='TabOrder' then ccheckbox.TabOrder:=strtoint(rr[i].valor) else
         if copy(rr[i].propiedad,1,2)='On' then liga(rr[i].objecto,'->',rr[i].valor,rr[i].propiedad);
      end else
      if tipo='TEdit' then begin
         if rr[i].propiedad='Left' then cedit.Left:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Top' then cedit.Top:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Width' then cedit.Width:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Height' then cedit.Height:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Text' then cedit.text:=x_caption(rr[i].valor) else
         if rr[i].propiedad='TabOrder' then cedit.TabOrder:=strtoint(rr[i].valor) else
         if copy(rr[i].propiedad,1,2)='On' then liga(rr[i].objecto,'->',rr[i].valor,rr[i].propiedad);
      end else
      if tipo='TButton' then begin
//   dbgrid.sendtoback;
         if rr[i].propiedad='Left' then cbutton.Left:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Top' then cbutton.Top:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Width' then cbutton.Width:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Height' then cbutton.Height:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Caption' then cbutton.caption:=x_caption(rr[i].valor) else
         if rr[i].propiedad='TabOrder' then cbutton.TabOrder:=strtoint(rr[i].valor) else
         if copy(rr[i].propiedad,1,2)='On' then liga(rr[i].objecto,'->',rr[i].valor,rr[i].propiedad);
      end else
      if tipo='TShape' then begin
         if rr[i].propiedad='Left' then cshape.Left:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Top' then cshape.Top:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Width' then cshape.Width:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Height' then cshape.Height:=strtoint(rr[i].valor) else
         if copy(rr[i].propiedad,1,2)='On' then liga(rr[i].objecto,'->',rr[i].valor,rr[i].propiedad);
      end else
      if tipo='TTable' then begin
         if rr[i].propiedad='DatabaseName' then cimage.Hint:=x_caption(rr[i].valor)+'/'+cimage.Hint else
         if rr[i].propiedad='TableName' then cimage.Hint:=cimage.Hint+'/'+x_caption(rr[i].valor) else
         if rr[i].propiedad='Left' then cimage.Left:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Top' then cimage.Top:=strtoint(rr[i].valor) else
         if copy(rr[i].propiedad,1,2)='On' then liga(rr[i].objecto,'->',rr[i].valor,rr[i].propiedad);
      end else
      if tipo='TDataSource' then begin
         if rr[i].propiedad='DataSet' then liga(rr[i].objecto,'->',rr[i].valor,rr[i].propiedad) else
         if rr[i].propiedad='Left' then cimage.Left:=strtoint(rr[i].valor) else
         if rr[i].propiedad='Top' then cimage.Top:=strtoint(rr[i].valor) else
         if copy(rr[i].propiedad,1,2)='On' then liga(rr[i].objecto,'->',rr[i].valor,rr[i].propiedad);

      end;


   end;
   ff.free;
   t.free;
//   caption:=p_caption(rr[0].objecto);
end;


procedure Tfsvsdelphi.FormActivate(Sender: TObject);
begin
   g_producto := 'MENÚ CONTEXTUAL-VISTA PREVIA';
end;

end.
