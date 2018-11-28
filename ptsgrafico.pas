unit ptsgrafico;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,types, ExtCtrls, Menus,JPEG, printers;
type Tobjimg=record
   nimage:integer;
   x:integer;
   y:integer;
end;
type Tobj=class
   public
      nombre:string; // nombre del objeto
      caption:string; // etiqueta que desplegará el objeto
      clase:string;
      bib:string;
      prog:string;
      subclase:array of string;
      subbib:array of string;
      subprog:array of string;
      x:integer;    // posición X
      y:integer;    // posición Y
      width:integer;  // Ancho
      height:integer; // Alto
      color:Tcolor;
      work:integer;
      tag:integer;
      visible : boolean;
      font:Tfont;
      enlace:array of integer;  //numero de enlaces que tiene (links)
      imgs:array of Tobjimg;
      padre:integer;
      constructor create(nom:string; xx,yy,ww,hh:integer); overload;   // constructor nombre(unico), x, y, ancho, alto
//      constructor create(nom:string; xx,yy,ww,hh:integer; var maxx,maxy:integer); overload;  // constructor del objeto Tobj
      procedure ajusta_alto(canvas:Tcanvas; bancho:boolean=false);   //puede o no ajustar el texto en la forma
      procedure add_image(nimage,xx,yy:integer);
      procedure pinta(canvas:Tcanvas; xx,yy:integer);
end;
type Tenlace = class
   public
      desde:Tobj;
      hasta:Tobj;
      direccion:string;
      tag:integer;
      constructor create(m,de,ha:integer;dir:string); overload;   //  m?, desde, hasta, direccionDeEnlace(< , > , ^ , v)
end;

type
  Tfgrafico = class(TForm)
    Image1: TImage;
    MainMenu1: TMainMenu;
    Archivo1: TMenuItem;
    Guardar1: TMenuItem;
    Guardarcomo1: TMenuItem;
    Convertira1: TMenuItem;
    ExportaraVML1: TMenuItem;
    Salir1: TMenuItem;
    Organizar1: TMenuItem;
    ModularMayoresEnlaces1: TMenuItem;
    Configuracin1: TMenuItem;
    PermitirMover1: TMenuItem;
    ExportaraJPG1: TMenuItem;
    Enlaces1: TMenuItem;
    Central1: TMenuItem;
    LadoMedio1: TMenuItem;
    SistemasPrioridad1: TMenuItem;
    opdown1: TMenuItem;
    Ver1: TMenuItem;
    GuasdeImpresin1: TMenuItem;
    Imprimir1: TMenuItem;
    procedure FormPaint(Sender: TObject);
    procedure Salir1Click(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ExportaraJPG1Click(Sender: TObject);
    procedure Central1Click(Sender: TObject);
    procedure LadoMedio1Click(Sender: TObject);
    procedure ModularMayoresEnlaces1Click(Sender: TObject);
    procedure SistemasPrioridad1Click(Sender: TObject);
    procedure PermitirMover1Click(Sender: TObject);
    procedure opdown1Click(Sender: TObject);
    procedure GuasdeImpresin1Click(Sender: TObject);
    procedure Imprimir1Click(Sender: TObject);
  private
    { Private declarations }
   wkfont:Tfont;
   procedure menu_option(sender:Tobject);
   procedure acomoda_x(obj:Tobj);
   procedure procesa_renglon(lis:array of integer; ant_apux:integer);
   procedure sistemas_prioridad;
  public
    { Public declarations }
    margenobjx,margenobjy:integer;
   mousedx,mousedy:integer;   // diferencia entre punto de mouse y origen de objeto
   mouseobj:Tobj;

   idx:array of array of array of Tobj;
   objs:array of Tobj;
   enlaces:array of Tenlace;
   maxx,maxy:integer;
   bguias:boolean;
   images:array of Timage;
   function crea_objeto(nom:string; xx,yy,ww,hh:integer):Tobj;       //nombre y posiciones
   function enlaza(de,ha,dir:string):Tenlace;                        // obj origen, obj destino, direccion
   procedure ubica_enmedio(obj:Tobj);                     //calcula la distancia media entre cada enlace
   procedure acomoda(obj:Tobj; comprime:boolean=true);     // va junto con ubica_enmedio, evita que los objetos se encimen
   procedure mueve_a(obj:Tobj; x,y:integer);       // cambia de posicion al objeto
   procedure dibuja(canvas:Tcanvas; xx,yy,ww,hh:integer);
   procedure dibuja_enlaces(canvas:Tcanvas; xx,yy:integer);   //pinta los enlaces (al ejecutarse antes, deja los enlaces por debajo de los objetos)
   function get_object(x,y:integer):Tobj;
   procedure asigna_a_mapa(obj:Tobj);  //interno
   procedure borra_de_mapa(obj:Tobj);  //interno
   procedure estructuras;
   function nueva_imagen(img:Timage):integer;
  end;

var
  fgrafico: Tfgrafico;

implementation
{$R *.dfm}
constructor Tobj.create(nom:string; xx,yy,ww,hh:integer);   // constructor del objeto Tobj
begin
   self.nombre:=nom;
   self.x:=xx;
   self.y:=yy;
   self.width:=ww;
   self.height:=hh;
   self.color:=clred;
   self.visible:=true;
end;
procedure Tobj.ajusta_alto(canvas:Tcanvas; bancho:boolean=false);   //revisa el texto, si tiene tabulador aumenta la altura del objeto
var alto:integer;
    texto1,texto2,tabu:string;
begin
   if trim(caption)='' then exit;
   tabu:=' ';
   tabu[1]:=chr(9);
   texto1:=caption;
   alto:=height;
   while pos(tabu,texto1)>0 do begin
      texto2:=copy(texto1,1,pos(tabu,texto1)-1);
      alto:=alto+canvas.TextHeight(texto2);
      if bancho then
         if width<canvas.TextWidth(texto2)+10 then
            width:=canvas.TextWidth(texto2)+10;
      texto1:=copy(texto1,pos(tabu,texto1)+1,1000);
   end;
   if bancho then
      if width<canvas.TextWidth(texto1)+10 then
         width:=canvas.TextWidth(texto1)+10;
   height:=alto;
end;
procedure Tobj.add_image(nimage,xx,yy:integer);
var k:integer;
begin
   k:=length(imgs);
   setlength(imgs,k+1);
   imgs[k].nimage:=nimage;
   imgs[k].x:=xx;
   imgs[k].y:=yy;
end;
procedure Tobj.pinta(canvas:Tcanvas; xx,yy:integer);      //canvas, Posicion scroll bar x, pos scroll y  // propiedad del scroll bar
var rect:Trect;
   caption_x,caption_y:integer;
    texto1,texto2,tabu:string;
    fnt:Tfont;
begin
   if visible = false then exit; // invisibilidad objetos

   rect.Left:=x-xx;
   rect.Top:=y-yy;
   rect.Right:=x-xx+width-1;
   rect.Bottom:=y-yy+height-1;
   canvas.Brush.Color:=color;
   canvas.FillRect(rect);
   if trim(caption)<>'' then begin
      fnt:=Tfont.Create;
      fnt.Assign(canvas.Font);
      canvas.Font.Assign(font);
      tabu:=' ';
      tabu[1]:=chr(9);
      if pos(tabu,caption)>0 then begin
         texto1:=caption;
         caption_y:=rect.Top+15;
         while pos(tabu,texto1)>0 do begin
            texto2:=copy(texto1,1,pos(tabu,texto1)-1);
            texto1:=copy(texto1,pos(tabu,texto1)+1,1000);
            caption_x:=rect.Left+5;
            canvas.TextOut(caption_x,caption_y,texto2);
            caption_y:=caption_y+canvas.TextHeight(texto2);
         end;
         texto2:=texto1;
         caption_x:=rect.Left+5;
         canvas.TextOut(caption_x,caption_y,texto2);
      end
      else
      if canvas.TextWidth(caption)>width then begin
         texto1:=caption;
         caption_y:=rect.Top+1;
         caption_x:=rect.Left+1;
         while pos(' ',texto1)>0 do begin
            texto2:=copy(texto1,1,pos(' ',texto1)-1);
            texto1:=copy(texto1,pos(' ',texto1)+1,1000);
            if caption_x+canvas.TextWidth(texto2)>rect.Left+width then begin
               caption_y:=caption_y+canvas.TextHeight(texto2);
               caption_x:=rect.Left+1;
            end;
            canvas.TextOut(caption_x,caption_y,texto2);
            caption_x:=caption_x+canvas.Textwidth(texto2)+1;
         end;
         texto2:=texto1;
         if caption_x+canvas.TextWidth(texto2)>rect.Left+width then begin
            caption_y:=caption_y+canvas.TextHeight(texto2);
            caption_x:=rect.Left+1;
         end;
         canvas.TextOut(caption_x,caption_y,texto2);

      end
      else begin
         caption_x:=rect.Left+(width-canvas.TextWidth(caption)) div 2;
         caption_y:=rect.Top+(height-canvas.TextHeight(caption)) div 2;
         canvas.TextOut(caption_x,caption_y,caption);
      end;
      canvas.Font.Assign(fnt);
      fnt.Free;
   end;
end;

constructor Tenlace.create(m,de,ha:integer;dir:string); // constructor de enlaces
var k:integer;
begin
   self.desde:=fgrafico.objs[de];
   self.hasta:=fgrafico.objs[ha];
   self.direccion:=dir;
   self.tag:=m;
   k:=length(fgrafico.objs[de].enlace);
   setlength(fgrafico.objs[de].enlace,k+1);
   fgrafico.objs[de].enlace[k]:=m;
   k:=length(fgrafico.objs[ha].enlace);
   setlength(fgrafico.objs[ha].enlace,k+1);
   fgrafico.objs[ha].enlace[k]:=m;
end;
procedure Tfgrafico.asigna_a_mapa(obj:Tobj);  //interno
var k,x,y,x1,x2,y1,y2:integer;
begin
   x1:=obj.x div 1000;
   x2:=(obj.x+obj.width) div 1000;
   y1:=obj.y div 1000;
   y2:=(obj.y+obj.height) div 1000;
   k:=length(idx);
   if k<x2+1 then
      setlength(idx,x2+1);
   x:=x2;
   y:=length(idx[x]);
   if y<y2+1 then
      setlength(idx[x],y2+1);
   for x:=x1 to x2 do begin
      for y:=y1 to y2 do begin
         k:=length(idx[x][y]);
         setlength(idx[x][y],k+1);
         idx[x][y][k]:=obj;
      end;
   end;
end;
procedure Tfgrafico.borra_de_mapa(obj:Tobj);  //interno
var k,x,y,z,x1,x2,y1,y2:integer;
begin
   x1:=obj.x div 1000;
   x2:=(obj.x+obj.width) div 1000;
   y1:=obj.y div 1000;
   y2:=(obj.y+obj.height) div 1000;
   for x:=x1 to x2 do begin
      for y:=y1 to y2 do begin
         k:=length(idx[x][y]);
         for z:=0 to k-1 do begin
            if idx[x][y][z]=obj then begin
               idx[x][y][z]:=idx[x][y][k-1];
               setlength(idx[x][y],k-1);
               break;
            end;
         end;
      end;
   end;
end;
function Tfgrafico.crea_objeto(nom:string; xx,yy,ww,hh:integer):Tobj;
var  k:integer;
begin
   k:=length(objs);
   setlength(objs,k+1);
   objs[k]:=Tobj.create(nom,xx,yy,ww,hh);
   objs[k].tag:=k;
   if maxx<xx+ww then maxx:=xx+ww;
   if maxy<yy+hh then maxy:=yy+hh;
   asigna_a_mapa(objs[k]);
   crea_objeto:=objs[k];
end;
function Tfgrafico.enlaza(de,ha,dir:string):Tenlace;
var  k:integer;
    d,a,i:integer;
begin
   d:=-1;
   a:=-1;
   for i:=0 to length(objs)-1 do begin
      if (d=-1) and (objs[i].nombre=de) then begin
         d:=i;
         if a<>-1 then break;
      end;
      if (a=-1) and (objs[i].nombre=ha) then begin
         a:=i;
         if d<>-1 then break;
      end;
   end;
   if d=-1 then begin
      enlaza:=nil;
      exit;
   end;
   if a=-1 then begin
      enlaza:=nil;
      exit;
   end;
   k:=length(enlaces);
   setlength(enlaces,k+1);
   enlaces[k]:=Tenlace.create(k,d,a,dir);
   enlaza:=enlaces[k];
end;

procedure Tfgrafico.ubica_enmedio(obj:Tobj);
var i,j,n,x,y:integer;
begin
   x:=0;
   y:=0;
   n:=0;
   for j:=0 to length(obj.enlace)-1 do begin
      i:=obj.enlace[j];
      if enlaces[i].desde.tag=obj.tag then begin
         inc(n);
         x:=x+enlaces[i].hasta.x+(enlaces[i].hasta.width div 2);
         y:=y+enlaces[i].hasta.y+(enlaces[i].hasta.height div 2);
      end
      else
      if enlaces[i].hasta.tag=obj.tag then begin
         inc(n);
         x:=x+enlaces[i].desde.x+(enlaces[i].desde.width div 2);
         y:=y+enlaces[i].desde.y+(enlaces[i].desde.height div 2);
      end;
   end;
   obj.x:=x div n;
   obj.x:=obj.x - (obj.width div 2);
   obj.y:=y div n;
   obj.y:=obj.y - (obj.height div 2);
end;

procedure Tfgrafico.acomoda(obj:Tobj; comprime:boolean=true);
var i,j,x2,y2,derecha,abajo:integer;
    bb:Tobj;
begin
{ recodificar------------------------
   //if obj.tag=68 then
   //   showmessage(obj.caption);
   for i:=0 to 3 do begin
      if obj.mapax[i]=-1 then continue;
      j:=0;
      while j<length(fgrafico.mapa.map[obj.mapax[i]][obj.mapay[i]]) do begin
      //for j:=0 to length(mapa.map[obj.mapax[i]][obj.mapay[i]])-1 do begin
         bb:=mapa.map[obj.mapax[i]][obj.mapay[i]][j];
         if bb=nil then begin
            inc(j);
            continue;
         end;
         if bb.tag=obj.tag then begin
            inc(j);
            continue;
         end;
         x2:=bb.x+bb.width-1+margenobjx;
         y2:=bb.y+bb.height-1+margenobjy;
         if (obj.x>=bb.x) and (obj.x<=x2) then begin
            if ((obj.y>=bb.y) and (obj.y<=y2)) or
               ((obj.y<=bb.y) and (obj.y+obj.height>=bb.y)) then begin // obj está dentro de bb, debe moverse a la derecha o hacia abajo
               derecha:=x2-obj.x;
               abajo:=y2-obj.y;
               if derecha<abajo then
                  obj.x:=x2+30
               else
                  obj.y:=y2+30;
               mapa.asigna_a_mapa(obj);
               acomoda(obj,false);
               if comprime then
                  mapa.comprime_mapa;
               exit;
            end
         end
         else begin
            x2:=obj.x+obj.width-1;
            y2:=obj.y+obj.height-1;
            if (bb.x>=obj.x) and (bb.x<=x2) then begin
               if ((bb.y>=obj.y) and (bb.y<=y2)) or
                  ((bb.y<=obj.y) and (bb.y+bb.height>=obj.y)) then begin // bb está dentro de obj, debe moverse a la derecha o hacia abajo
                  derecha:=x2-bb.x;
                  abajo:=y2-bb.y;
                  if derecha<abajo then
                     bb.x:=x2+30
                  else
                     bb.y:=y2+30;
                  mapa.asigna_a_mapa(bb);
                  acomoda(bb,false);
               end;
            end;
         end;
         inc(j);
      end;
   end;
   if maxx<obj.x+obj.width then
      maxx:=obj.x+obj.width;
   if maxy<obj.y+obj.height then
      maxy:=obj.y+obj.height;
   if comprime then
      mapa.comprime_mapa;
      }
end;

procedure Tfgrafico.estructuras;
var i,j,k:integer;
   sal:Tstringlist;
   obj:Tobj;
   sino:string;
begin
{ recodificar. Sirve para ver valores en arreglo
   sal:=Tstringlist.Create;
   for i:=0 to 99 do begin
      for j:=0 to 99 do begin
         for k:=0 to length(mapa.map[i][j])-1 do begin
            obj:=mapa.map[i][j][k];
            if obj=nil then continue;
            if obj.visible then sino:='Y'
            else                sino:='N';
            sal.Add(inttostr(i)+','+inttostr(j)+','+inttostr(obj.tag)+','+sino+',"'+obj.nombre+'",'+
               inttostr(obj.x)+','+inttostr(obj.y)+','+
               inttostr(obj.width)+','+inttostr(obj.height)+','+
               inttostr(obj.mapax[0])+','+inttostr(obj.mapay[0])+','+
               inttostr(obj.mapax[1])+','+inttostr(obj.mapay[1])+','+
               inttostr(obj.mapax[2])+','+inttostr(obj.mapay[2])+','+
               inttostr(obj.mapax[3])+','+inttostr(obj.mapay[3]));
         end;
      end;
   end;
   sal.SaveToFile('salida.csv');
   sal.Free;
   }
end;

procedure Tfgrafico.dibuja_enlaces(canvas:Tcanvas; xx,yy:integer);
var i,x1,x2,y1,y2:integer;
   ob1,ob2:Tobj;
begin
   if central1.Checked then begin
      for i:=0 to length(enlaces)-1 do begin
         ob1:=enlaces[i].desde;
         ob2:=enlaces[i].hasta;
         x1:=ob1.x-xx+(ob1.width div 2);
         y1:=ob1.y-yy+(ob1.height div 2);
         x2:=ob2.x-xx+(ob2.width div 2);
         y2:=ob2.y-yy+(ob2.height div 2);
         canvas.MoveTo(x1,y1);
         canvas.LineTo(x2,y2);
      end;
      exit;
   end;
   if ladomedio1.Checked then begin
      for i:=0 to length(enlaces)-1 do begin
         ob1:=enlaces[i].desde;
         ob2:=enlaces[i].hasta;
         x1:=ob1.x-xx+(ob1.width div 2);
         y1:=ob1.y-yy+(ob1.height div 2);
         x2:=ob2.x-xx+(ob2.width div 2);
         y2:=ob2.y-yy+(ob2.height div 2);
         if abs(x2-x1)>=abs(y2-y1) then begin
            if x2>x1 then begin
               canvas.MoveTo(ob1.x+ob1.width-1-xx,y1);
               canvas.LineTo(ob1.x+ob1.width+9-xx,y1);
               canvas.LineTo(ob2.x-10-xx,y2);
               canvas.LineTo(ob2.x-xx,y2);
            end
            else begin
               canvas.MoveTo(ob1.x-xx,y1);
               canvas.LineTo(ob1.x-10-xx,y1);
               canvas.LineTo(ob2.x+ob2.width+9-xx,y2);
               canvas.LineTo(ob2.x+ob2.width-1-xx,y2);
            end;
         end
         else begin
            if y2>y1 then begin
               canvas.MoveTo(x1,ob1.y+ob1.height-1-yy);
               canvas.LineTo(x1,ob1.y+ob1.height+9-yy);
               canvas.LineTo(x2,ob2.y-10-yy);
               canvas.LineTo(x2,ob2.y-yy);
            end
            else begin
               canvas.MoveTo(x1,ob1.y-yy);
               canvas.LineTo(x1,ob1.y-10-yy);
               canvas.LineTo(x2,ob2.y+ob2.height+9-yy);
               canvas.LineTo(x2,ob2.y+ob2.height-1-yy);
            end;
         end;
      end;
      exit;
   end;
   if opdown1.Checked then begin
      for i:=0 to length(enlaces)-1 do begin
         ob1:=enlaces[i].desde;
         ob2:=enlaces[i].hasta;
         x1:=ob1.x-xx+(ob1.width div 2);
         y1:=ob1.y-yy+(ob1.height div 2);
         x2:=ob2.x-xx+(ob2.width div 2);
         y2:=ob2.y-yy+(ob2.height div 2);
         if y2>y1 then begin
            canvas.MoveTo(x1,ob1.y+ob1.height-1-yy);
            canvas.LineTo(x1,ob1.y+ob1.height+9-yy);
            canvas.LineTo(x2,ob2.y-10-yy);
            canvas.LineTo(x2,ob2.y-yy);
         end
         else begin
            canvas.MoveTo(x1,ob1.y-yy);
            canvas.LineTo(x1,ob1.y-10-yy);
            canvas.LineTo(x2,ob2.y+ob2.height+9-yy);
            canvas.LineTo(x2,ob2.y+ob2.height-1-yy);
         end;
      end;
      exit;
   end;
end;
procedure Tfgrafico.FormPaint(Sender: TObject);
begin
   image1.Left:=maxx-horzscrollbar.Position;
   image1.Top:=maxy-vertscrollbar.Position;
end;

procedure Tfgrafico.Salir1Click(Sender: TObject);
begin
   Close;
end;
function Tfgrafico.get_object(x,y:integer):Tobj;
var i,j,k,mx,my,x1,x2,y1,y2:integer;
   obj:Tobj;
begin
   mx:=x div 1000;
   if mx>=length(idx) then begin
      get_object:=nil;
      exit;
   end;
   my:=y div 1000;
   if my>=length(idx[mx]) then begin
      get_object:=nil;
      exit;
   end;
   for i:=length(idx[mx][my])-1 downto 0 do begin
      obj:=idx[mx][my][i];
      if (x>=obj.x) and (x<obj.x+obj.width) and
         (y>=obj.y) and (y<obj.y+obj.height) then begin
         get_object:=obj;
         exit;
      end;
   end;
   get_object:=nil;
end;

procedure Tfgrafico.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   estructuras;
   mouseobj:=get_object(x+horzscrollbar.Position,y+VertScrollBar.Position);

   if mouseobj = nil then exit;
   if mouseobj.visible = false then begin
      mouseobj:=nil;
      exit;
   end;

   mousedx:=x-mouseobj.x;
   mousedy:=y-mouseobj.y;
   if button=mbright then exit;
   if permitirmover1.Checked=false then exit;
   screen.Cursor:=crdrag;
end;

procedure Tfgrafico.mueve_a(obj:Tobj; x,y:integer);
begin
   obj.x:=x;
   obj.y:=y;
   if maxx<obj.x+obj.width then
      maxx:=obj.x+obj.width;
   if maxy<obj.y+obj.height then
      maxy:=obj.y+obj.height;
   asigna_a_mapa(obj);
end;

procedure Tfgrafico.FormMouseUp(Sender: TObject; Button: TMouseButton;  //donde solto el boton
  Shift: TShiftState; X, Y: Integer);
begin
   if mouseobj=nil then exit;   // si no trae ningun objeto
   if permitirmover1.Checked=false then exit;       //si no esta permitido mover los objetos se sale

   mueve_a(mouseobj,x-mousedx,y-mousedy);
   screen.Cursor:=crdefault;
   //mouseobj:=nil;
   refresh;
end;

procedure Tfgrafico.ExportaraJPG1Click(Sender: TObject);
var img:Tjpegimage;
    bmp:Tbitmap;
begin
   bmp:=Tbitmap.Create;
   img:=Tjpegimage.Create;
   bmp.Width:=maxx;
   bmp.Height:=maxy;
   dibuja_enlaces(bmp.Canvas,0,0);
   dibuja(bmp.Canvas,0,0,maxx,maxy);
   img.Assign(bmp);
   img.SaveToFile('salida.jpg');
   img.Free;
   bmp.Free;
end;

procedure Tfgrafico.acomoda_x(obj:Tobj);
var i,dx:integer;
   enla:Tenlace;
   ob:Tobj;
begin
   dx:=0;
   for i:=0 to length(obj.enlace)-1 do begin
      enla:=enlaces[obj.enlace[i]];
      if enla.desde.tag<>obj.tag then
         dx:=dx+enla.desde.x
      else
         dx:=dx+enla.hasta.x;
   end;
   dx:=dx div length(obj.enlace);
   mueve_a(obj,dx,obj.y);
   acomoda(obj);
end;

procedure Tfgrafico.procesa_renglon(lis:array of integer; ant_apux:integer);   //le da formato al diagrama acomodando por renglones los objetos mas cercanos
var i,j,k,apux,apuy:integer;
   obx,ob:Tobj;
   enla:Tenlace;
   lista:array of integer;
begin
   if length(lis)=0 then exit;
   apuy:=maxy+200;
   apux:=50;
   for i:=0 to length(lis)-1 do begin
      obx:=objs[lis[i]];
      for j:=0 to length(obx.enlace)-1 do begin
         enla:=enlaces[obx.enlace[j]];
         if enla.desde.tag<>obx.tag then
            ob:=enla.desde
         else
            ob:=enla.hasta;
         if ob.work>0 then continue;
         mueve_a(ob,apux,apuy);
         ob.work:=1;
         k:=length(lista);
         setlength(lista,k+1);
         lista[k]:=ob.tag;
         apux:=ob.x+ob.Width+50;
      end;
   end;
   if ant_apux<maxx then begin          // centra el renglón
      ant_apux:=(maxx-ant_apux) div 2;
      for i:=0 to length(lis)-1 do begin
         ob:=objs[lis[i]];
         mueve_a(ob,ob.x+ant_apux,ob.y);
      end;
   end;
   {
   for i:=0 to length(lis)-1 do
      if objs[lis[i]].clase='SIS' then
         acomoda_x(objs[lis[i]]);
   }
   procesa_renglon(lista,apux);
   setlength(lista,0);
end;

procedure Tfgrafico.sistemas_prioridad;   // otro metodo para acomodar diagrama
var
   i,j,maxi,maxsis,apux,apuy:integer;
   ob:Tobj;
   enla:Tenlace;
   encuentra:boolean;
   lista:array of integer;
begin
   maxx:=0;
   maxy:=0;
   for i:=0 to length(objs)-1 do
      objs[i].work:=0;
   while true do begin
      maxsis:=-1;
      maxi:=0;
      for i:=0 to length(objs)-1 do begin   // busca sistema con mayores enlaces
         if objs[i].work>0 then continue;
         if maxi<length(objs[i].enlace) then begin
            maxi:=length(objs[i].enlace);
            maxsis:=i;
         end;
      end;
      if maxsis=-1 then break;
      mueve_a(objs[maxsis], 200,fgrafico.maxy+200);
      objs[maxsis].work:=1;
      setlength(lista,1);
      lista[0]:=maxsis;
      procesa_renglon(lista,0);
      setlength(lista,0);
   end;
   for i:=0 to length(objs)-1 do
      if objs[i].clase='SIS' then
         acomoda_x(objs[i]);
end;

procedure Tfgrafico.menu_option(sender:Tobject);
var bchecked:boolean;
    padre:Tmenuitem;
    i:integer;
begin
   bchecked:=(sender as Tmenuitem).Checked;
   padre:=(sender as Tmenuitem).Parent;
   if (padre.items[0]=sender) and bchecked then exit;
   for i:=0 to padre.Count-1 do
      padre.items[i].Checked:=false;
   (sender as Tmenuitem).Checked:=not bchecked;
end;

procedure Tfgrafico.Central1Click(Sender: TObject);
begin
   menu_option(sender);
   refresh;
end;

procedure Tfgrafico.LadoMedio1Click(Sender: TObject);
begin
   menu_option(sender);
   refresh;
end;

procedure Tfgrafico.ModularMayoresEnlaces1Click(Sender: TObject);
begin
   menu_option(sender);
   refresh;
end;

procedure Tfgrafico.SistemasPrioridad1Click(Sender: TObject);
begin
   menu_option(sender);
   if sistemasprioridad1.Checked then
      sistemas_prioridad;
   refresh;
end;

procedure Tfgrafico.PermitirMover1Click(Sender: TObject);
begin
   permitirmover1.Checked:=not permitirmover1.Checked;
end;

procedure Tfgrafico.opdown1Click(Sender: TObject);
begin
   menu_option(sender);
   refresh;
end;

procedure Tfgrafico.GuasdeImpresin1Click(Sender: TObject);
begin
   GuasdeImpresin1.Checked:=not GuasdeImpresin1.Checked;
   bguias:=GuasdeImpresin1.Checked;
   refresh;
end;

procedure Tfgrafico.Imprimir1Click(Sender: TObject);
begin
  // printer.Canvas.
end;
function Tfgrafico.nueva_imagen(img:Timage):integer;
var k:integer;
begin
   k:=length(images);
   setlength(images,k+1);
   images[k]:=Timage.create(self);
   images[k].Width:=img.Width;
   images[k].Height:=img.Height;
   images[k].Picture.Assign(img.Picture.Bitmap);
   nueva_imagen:=k;
end;
procedure Tfgrafico.dibuja(canvas:Tcanvas; xx,yy,ww,hh:integer);    //ajusta con el Scroll bar
var i,j:integer;
   pen:Tpen;
begin
   if bguias then begin
      pen:=Tpen.Create;
      pen.Assign(canvas.Pen);
      canvas.Pen.Style:=psDot;
      canvas.Pen.Width:=1;
      for i:=0 to 100 do begin
         canvas.TextOut(i*100-xx,0,inttostr(i*100));
         canvas.MoveTo(i*100-xx,0);
         canvas.LineTo(i*100-xx,10000);
      end;
      for i:=0 to 100 do begin
         canvas.TextOut(0,i*100-yy,inttostr(i*100));
         canvas.MoveTo(0,i*100-yy);
         canvas.LineTo(10000,i*100-yy);
      end;
      canvas.pen.Assign(Pen);
      pen.Free;
   end;
   for i:=0 to length(objs)-1 do begin
      if objs[i].visible=false then continue;
      objs[i].pinta(canvas,xx,yy);
      for j:=0 to length(objs[i].imgs)-1 do begin
         canvas.Draw(objs[i].x-xx+objs[i].imgs[j].x,
            objs[i].y-yy+objs[i].imgs[j].y,images[objs[i].imgs[j].nimage].Picture.Graphic);
      end;
   end;
end;

end.
