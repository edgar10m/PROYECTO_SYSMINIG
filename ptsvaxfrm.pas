unit ptsvaxfrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,stdctrls, Menus, extctrls, jpeg, ExtDlgs;

type
  Tftsvaxfrm = class(TForm)
    PopupMenu1: TPopupMenu;
    Exportar1: TMenuItem;
    SavePictureDialog1: TSavePictureDialog;
    procedure FormPaint(Sender: TObject);
    procedure Exportar1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure crea(archivo:string);
    procedure exporta_jpg(archivo:string);
  end;
const factorx=10;
      factory=20;

var
  ftsvaxfrm: Tftsvaxfrm;
  Procedure PR_VAXFRM(archivo:string);

implementation
uses uconstantes;
{$R *.dfm}
Procedure PR_VAXFRM(archivo:string);
begin
   Application.CreateForm( Tftsvaxfrm, ftsvaxfrm );
   ftsvaxfrm.crea(archivo);
   try
      ftsvaxfrm.Showmodal;
   finally
      ftsvaxfrm.Free;
   end;
end;
procedure Tftsvaxfrm.crea(archivo:string);
var lis:Tstringlist;
   i,j,k,m:integer;
   forma:string;
   renglon,columna:integer;
   paso:string;
   texto:string;
   lab:Tlabel;
   nombre:string;
   valor:string;
   b_readonly,b_rule:boolean;
   longitud:integer;
   campo:TEdit;
begin
   if fileexists(archivo)=false then begin
      showmessage('Archivo '+archivo+' no existe');
      abort;
   end;
   lis:=Tstringlist.Create;
   lis.LoadFromFile(archivo);
   for i:=0 to lis.Count-1 do begin
      j:=pos('FORM NAME=',lis[i]);
      if(j>0) and (forma='') then begin
         forma:=stringreplace(trim(copy(lis[i],j+10,100)),'''','',[rfreplaceall]);
         caption:=forma;
         continue;
      end;
      j:=pos('TEXT (',lis[i]);
      if(j>0) then begin
         texto:=copy(lis[i],j+6,100);
         j:=pos(',',texto);
         renglon:=strtoint(trim(copy(texto,1,j-1)));
         texto:=copy(texto,j+1,100);
         j:=pos(')',texto);
         columna:=strtoint(trim(copy(texto,1,j-1)));
         texto:=trim(copy(texto,j+1,100));
         j:=1;
         k:=0;
         while texto[j] in ['0'..'9'] do begin
            k:=k*10+ord(texto[j])-48;
            inc(j);
         end;
         if k>0 then begin
            paso:='';
            if (texto[j]='''') and (texto[j+2]='''') then begin
               for m:=1 to k do
                  paso:=paso+copy(texto,j+1,1);
            end;
            texto:=copy(texto,j+3,150);
            if texto[1]='&' then begin
               texto:=paso+stringreplace(trim(copy(texto,2,150)),'''','',[rfreplaceall]);
            end
            else
               texto:=paso;
         end
         else
            texto:=stringreplace(trim(copy(texto,j+1,100)),'''','',[rfreplaceall]);
         continue;
      end;
      j:=pos('&''',lis[i]);
      if j>0 then begin
         texto:=texto+stringreplace(trim(copy(lis[i],j+2,100)),'''','',[rfreplaceall]);
         continue;
      end;
      j:=pos('FIELD NAME=',lis[i]);
      if j>0 then begin
         paso:=copy(lis[i],j+11,100);
         j:=pos('(',paso);
         nombre:=stringreplace(trim(copy(paso,1,j-1)),'''','',[rfreplaceall]);
         paso:=copy(paso,j+1,100);
         j:=pos(',',paso);
         renglon:=strtoint(trim(copy(paso,1,j-1)));
         paso:=copy(paso,j+1,100);
         j:=pos(')',paso);
         columna:=strtoint(trim(copy(paso,1,j-1)));
         continue;
      end;
      j:=pos('PICTURE=',lis[i]);
      if j>0 then begin
         paso:=copy(lis[i],j+8,100);
         longitud:=0;
         j:=pos('''',paso);
         if j>1 then
            longitud:=strtoint(trim(copy(paso,1,j-1)));
         paso:=stringreplace(trim(copy(paso,j+1,100)),'''','',[rfreplaceall]);
         if longitud=0 then begin
            valor:=paso;
            longitud:=length(valor);
         end
         else begin
            for j:=1 to longitud do
               valor:=valor+paso;
         end;
         continue;
      end;
      if pos(' DISPLAY_ONLY',lis[i])>0 then
         b_readonly:=true;
      if pos(' CHARACTER_SET=RULE',lis[i])>0 then
         b_rule:=true;
      if pos(';',lis[i])>0 then begin
         if texto<>'' then begin
            lab:=Tlabel.Create(self);
            lab.Parent:=self;
            lab.Visible:=true;
            lab.Caption:=texto;
            lab.Top:=renglon*factory;
            lab.Left:=columna*factorx;
            lab.Font.Name:='Courier New';
            lab.Font.Size:=13;
            if b_rule then
               lab.Visible:=false;
            texto:='';
            b_rule:=false;
            continue;
         end;
         if nombre<>'' then begin
            campo:=TEdit.Create(self);
            campo.Parent:=self;
            campo.Visible:=true;
            bGlbQuitaCaracteres( nombre );
            campo.Name:=nombre;
            campo.Width:=longitud*factorx+5;
            campo.Text:=valor;
            campo.Top:=renglon*factory;
            campo.Left:=columna*factorx;
            campo.Font.Name:='Courier New';
            campo.Font.Size:=8;
            campo.Enabled:=not b_readonly;
            nombre:='';
            valor:='';
            b_readonly:=false;
            continue;
         end;
      end;
   end;
   lis.free;
end;


procedure Tftsvaxfrm.FormPaint(Sender: TObject);
var i,j,x,y,mx,my:integer;
   lab:Tlabel;
   ed:Tedit;
begin
   my:=factory div 2;
   mx:=factorx div 2;
   canvas.Font.Name:='Courier New';
   canvas.Font.Size:=13;
   for i:=0 to ComponentCount-1 do begin
      if components[i] is Tlabel then begin
         lab:=components[i] as Tlabel;
         if lab.Visible then continue;
         y:=lab.Top;
         for j:=1 to length(lab.Caption) do begin
            x:=lab.Left+(j-1)*factorx;
            if lab.Caption[j]='q' then begin
               canvas.MoveTo(x,y+my);
               canvas.LineTo(x+factorx,y+my);
            end else
            if lab.Caption[j]='x' then begin
               canvas.MoveTo(x+mx,y);
               canvas.LineTo(x+mx,y+factory);
            end else
            if lab.Caption[j]='l' then begin
               canvas.MoveTo(x+factorx,y+my);
               canvas.LineTo(x+mx,y+my);
               canvas.LineTo(x+mx,y+factory);
            end else
            if lab.Caption[j]='k' then begin
               canvas.MoveTo(x,y+my);
               canvas.LineTo(x+mx,y+my);
               canvas.LineTo(x+mx,y+factory);
            end else
            if lab.Caption[j]='m' then begin
               canvas.MoveTo(x+factorx,y+my);
               canvas.LineTo(x+mx,y+my);
               canvas.LineTo(x+mx,y-1);
            end else
            if lab.Caption[j]='j' then begin
               canvas.MoveTo(x,y+my);
               canvas.LineTo(x+mx,y+my);
               canvas.LineTo(x+mx,y-1);
            end else
            if lab.Caption[j]='w' then begin
               canvas.MoveTo(x,y+my);
               canvas.LineTo(x+factorx,y+my);
               canvas.MoveTo(x+mx,y+my);
               canvas.LineTo(x+mx,y+factory);
            end else
            if lab.Caption[j]='v' then begin
               canvas.MoveTo(x,y+my);
               canvas.LineTo(x+factorx,y+my);
               canvas.MoveTo(x+mx,y+my);
               canvas.LineTo(x+mx,y-1);
            end else
            if lab.Caption[j]='t' then begin
               canvas.MoveTo(x+mx,y);
               canvas.LineTo(x+mx,y+factory);
               canvas.MoveTo(x+mx,y+my);
               canvas.LineTo(x+factorx,y+my);
            end else
            if lab.Caption[j]='u' then begin
               canvas.MoveTo(x+mx,y);
               canvas.LineTo(x+mx,y+factory);
               canvas.MoveTo(x+mx,y+my);
               canvas.LineTo(x-1,y+my);
            end else
            if lab.Caption[j]='n' then begin
               canvas.MoveTo(x+mx,y);
               canvas.LineTo(x+mx,y+factory);
               canvas.MoveTo(x,y+my);
               canvas.LineTo(x+factorx,y+my);
            end
            else begin
               canvas.TextOut(x,y,copy(lab.Caption,j,1));
            end;
         end;
      {
      end
      else
      if components[i] is TEdit then begin
         ed:=components[i] as TEdit;
         canvas.TextOut(ed.Left,ed.Top,ed.Text);
      }
      end;
   end;
end;
procedure Tftsvaxfrm.exporta_jpg(archivo:string);
var img:Tjpegimage;
    bmp:Tbitmap;
    i:integer;
begin
   bmp:=Tbitmap.Create;
   img:=Tjpegimage.Create;
   bmp.Width:=width;
   bmp.Height:=height;
   PaintTo(bmp.Canvas,0,0);
   img.Assign(bmp);
   img.SaveToFile(archivo);
   img.Free;
   bmp.Free;
end;
procedure Tftsvaxfrm.Exportar1Click(Sender: TObject);
begin
   if savepicturedialog1.Execute=false then exit;
   exporta_jpg(savepicturedialog1.FileName);
end;

procedure Tftsvaxfrm.FormCreate(Sender: TObject);
begin
   width:=82*factorx;
   height:=25*factory;
end;

procedure Tftsvaxfrm.FormClose(Sender: TObject; var Action: TCloseAction);
var i:integer;
begin
   for i:=componentcount-1 downto 0 do begin
      if (components[i] is Tlabel) or
         (components[i] is TEdit) then
         components[i].Free;
   end;
end;

procedure Tftsvaxfrm.FormDblClick(Sender: TObject);
begin
   popupmenu1.Popup(mouse.CursorPos.X,mouse.CursorPos.Y);
end;

end.
