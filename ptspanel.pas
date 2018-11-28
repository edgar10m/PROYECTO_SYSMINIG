unit ptspanel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, dxBar;

type
  Tftspanel = class(TForm)
    mnuPrincipal: TdxBarManager;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    panel:string;
    titulo:string;
    sy,sx:integer;
    nlabel:integer;
  public
    { Public declarations }
    procedure arma(archivo:string);
  end;

var

  ftspanel: Tftspanel;
  procedure PR_PANEL(archivo:string);

implementation
uses ptsdm, ptsgral;
{$R *.dfm}

procedure PR_PANEL(archivo:string);
var
   titulo:string;
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );

   try
     // titulo := 'Vista Previa ' + bgral;
      if gral.bPubVentanaActiva( titulo ) then
         Exit;
      Application.CreateForm( Tftspanel, ftspanel );
      if gral.bPubVentanaMaximizada = FALSE then begin
         ftspanel.Width  := g_Width;
         ftspanel.Height := g_Height;
      end;
      ftspanel.arma(archivo);
      titulo := ftspanel.caption;
      ftspanel.Show;
      dm.PubRegistraVentanaActiva( Titulo );
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tftspanel.arma(archivo:string);
var lis:Tstringlist;
   x:string;
   i,j:integer;
   edi:Tedit;
   lab:Tlabel;
   b_edit,b_panel, b_initial_value:boolean;
begin
   if fileexists(archivo)=false then exit;
   lis:=Tstringlist.Create;
   lis.LoadFromFile(archivo);
   sy:=20;
   sx:=8;
   b_panel:=true;
   for i:=0 to lis.Count-1 do begin
      x:=trim(copy(lis[i],1,72));
      if copy(x,1,8)='->PANEL ' then begin
         panel:=trim(copy(x,9,8));
         continue;
      end;
      if copy(x,1,6)='TEXT1 ' then begin
         titulo:=trim(copy(x,7,100));
         delete(titulo,length(titulo),1);
         delete(titulo,1,1);
         caption:='('+panel+') '+titulo;
         continue;
      end;
      if copy(x,1,14)='->FIELD  NAME ' then begin
         edi:=Tedit.Create(ftspanel);
         edi.Parent:=ftspanel;
         edi.Name:=stringreplace(trim(copy(x,15,40)),'-','_',[rfreplaceall]);
         edi.ReadOnly:=true;
         edi.Hint:=edi.Name;
         edi.ShowHint:=true;
         b_edit:=true;
         b_panel:=false;
         continue;
      end;
      if copy(x,1,7)='->FIELD' then begin
         lab:=Tlabel.Create(ftspanel);
         lab.Parent:=ftspanel;
         inc(nlabel);
         lab.Name:='label_'+inttostr(nlabel);
         b_edit:=false;
         b_panel:=false;
         continue;
      end;
      if copy(x,1,6)='TYPE G' then continue;  // Grupo ????
      if copy(x,1,5)='TYPE ' then begin
         if b_edit then begin
            j:=pos('ROW',x);
            edi.Top:=strtoint(trim(copy(x,j+4,5)))*sy-sy;
            j:=pos('COLUMN',x);
            edi.Left:=strtoint(trim(copy(x,j+7,5)))*sx-sx;
            j:=pos('LENGTH',x);
            edi.Width:=strtoint(trim(copy(x,j+7,5)))*sx+sx;
            edi.Visible:=true;
         end
         else begin
            j:=pos('ROW',x);
            lab.Top:=strtoint(trim(copy(x,j+4,5)))*sy-sy;
            j:=pos('COLUMN',x);
            lab.Left:=strtoint(trim(copy(x,j+7,5)))*sx-sx;
            j:=pos('LENGTH',x);
            lab.Width:=strtoint(trim(copy(x,j+7,5)))*sx;
            lab.Font.Name:='Courier';
            lab.Font.Size:=10;
            lab.Visible:=true;
         end;
         continue;
      end;
      if copy(x,1,14)='INITIAL-VALUE ' then begin
         if b_edit then begin
            edi.Text:=copy(x,15,100);
            edi.Text:=copy(edi.Text,2,length(edi.Text)-2);
         end
         else begin
            lab.Caption:=copy(x,15,100);
            lab.Caption:=copy(lab.Caption,2,length(lab.Caption)-2);
         end;
         b_initial_value:=true;
         continue;
      end;
      if (copy(x,1,7)='INFILL ') and b_edit then begin
//         edi.Enabled:=true;
         continue;
      end;
      if (copy(x,1,1)='''') and b_initial_value then begin
         if b_edit then begin
            edi.Text:=edi.Text+copy(x,2,length(x)-2);
         end
         else begin
            lab.caption:=lab.caption+copy(x,2,length(x)-2);
         end;
         continue;
      end;
      b_initial_value:=false;
   end;
   width:=80*sx;
   height:=25*sy;
   lis.Free;
end;

procedure Tftspanel.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   if FormStyle = fsMDIChild then
      Action := caFree;
end;

procedure Tftspanel.FormDestroy(Sender: TObject);
begin
    dm.PubEliminarVentanaActiva( Caption );
    
  if gral.iPubVentanasActivas > 0 then  
      gral.PubExpandeMenuVentanas( True );
end;

procedure Tftspanel.FormCreate(Sender: TObject);
begin
    mnuPrincipal.Style := gral.iPubEstiloActivo;

 if gral.iPubVentanasActivas > 0 then  
      gral.PubExpandeMenuVentanas( True );
end;

end.
