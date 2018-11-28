unit mgca7;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, StdCtrls;
type
   Tobj=record
      nivel:integer;
      job:string;
      fecha1:integer;
      fecha2:integer;
      hora1:integer;
      hora2:integer;
      d1:integer;
      d2:integer;
      dura:integer;
      padre:integer;
      hermano:integer;
      hijo:integer;
      barra:Tshape;
      existe:boolean;
      linea:Tshape;
      existe_linea:boolean;
   end;
type
  Tfmgca7 = class(TForm)
    MainMenu1: TMainMenu;
    Ver1: TMenuItem;
    Cadena1: TMenuItem;
    Proceso1: TMenuItem;
    Archivo1: TMenuItem;
    Abrir1: TMenuItem;
    OpenDialog1: TOpenDialog;
    Zoom1: TMenuItem;
    N2001: TMenuItem;
    N501: TMenuItem;
    pop: TPopupMenu;
    Dayfile1: TMenuItem;
    Componentes1: TMenuItem;
    Dependencias1: TMenuItem;
    Propiedades1: TMenuItem;
    mreporte: TMenuItem;
    Memo1: TMemo;
    n1001: TMenuItem;
    procedure Abrir1Click(Sender: TObject);
    procedure Cadena1Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure N2001Click(Sender: TObject);
    procedure N501Click(Sender: TObject);
    procedure barraMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mreporteClick(Sender: TObject);
    procedure Componentes1Click(Sender: TObject);
    procedure n1001Click(Sender: TObject);
  private
    { Private declarations }
    pp:array of Tobj;
    hora_menor:integer;
    yy:integer;
    g_dia:Tdatetime;
    g_hora:integer;
    g_zoom:integer;
    b_pinta:boolean;
    z_barra:integer;
    procedure ver_todo;
    procedure pinta(n:integer);
    procedure pinta_hijos(n:integer);
    procedure crea_linea(x1,y1,x2,y2:integer; nom:string;var b:Tshape);
  public
    { Public declarations }
  end;

var
  fmgca7: Tfmgca7;
  procedure PR_CA7;

implementation
uses ptslistacompo;

{$R *.dfm}
procedure PR_CA7;
begin
   Application.CreateForm(Tfmgca7, fmgca7);
   try
     fmgca7.ShowModal;
   finally
     fmgca7.Free;
   end;
end;

procedure Tfmgca7.Abrir1Click(Sender: TObject);
var lin:Tstringlist;
    i,j,k:integer;
    nivel,job,fecha1,fecha2,hora1,hora2:string;
begin
   //if opendialog1.Execute=false then exit;
   g_zoom:=100;
   lin:=Tstringlist.Create;
   //lin.LoadFromFile(opendialog1.FileName);
   lin.AddStrings(memo1.Lines);
   k:=0;
   hora_menor:=05500*24*60;
   for i:=0 to lin.Count-1 do begin
      if copy(lin[i],42,1)<>'/' then continue;
      setlength(pp,k+1);
      if lin[i][2]='*' then pp[k].nivel:=0
      else pp[k].nivel:=strtoint(copy(lin[i],2,3));
      pp[k].job:=copy(lin[i],6,20);
      pp[k].job:=trim(pp[k].job);
      pp[k].job:=stringreplace(pp[k].job,'.','',[rfreplaceall]);
//      pp[k].job:=stringreplace(pp[k].job,'$','_',[rfreplaceall]);
      pp[k].fecha1:=strtoint(copy(lin[i],37,5));
      pp[k].fecha2:=strtoint(copy(lin[i],48,5));
      pp[k].hora1:=strtoint(copy(lin[i],43,4));
      pp[k].hora2:=strtoint(copy(lin[i],54,4));
      pp[k].d1:=pp[k].fecha1 * 24 *60+(pp[k].hora1 div 100)*60+(pp[k].hora1 mod 100);
      pp[k].d2:=pp[k].fecha2 * 24 *60+(pp[k].hora2 div 100)*60+(pp[k].hora2 mod 100);
      pp[k].dura:=pp[k].d2-pp[k].d1;
      pp[k].existe:=false;
      if pp[k].nivel=0 then begin     // raiz
         pp[k].padre:=-1;
         pp[k].hermano:=-1;
         pp[k].hijo:=-1;
      end
      else begin
         if pp[k-1].nivel=pp[k].nivel then begin// hermano
            pp[k].padre:=pp[k-1].padre;
            pp[k].hermano:=-1;
            pp[k].hijo:=-1;
            pp[k-1].hermano:=k;
         end
         else begin // hijo
            j:=k-1;
            while pp[j].nivel>pp[k].nivel-1 do j:=j-1;
            pp[k].padre:=j;
            pp[k].hermano:=-1;
            pp[k].hijo:=-1;
            pp[k-1].hijo:=k;
         end
      end;
      if pp[k].d1<hora_menor then hora_menor:=pp[k].d1;
      inc(k);
   end;
   k:=hora_menor div 60 div 24;
   j:=k div 1000 +2000;
   g_dia:=encodedate(j-1,12,31)+k mod 1000;
//   k:=hora_menor - (k*60*24);
   g_hora:=hora_menor div 60 *60;
   lin.Free;
end;
procedure Tfmgca7.crea_linea(x1,y1,x2,y2:integer; nom:string;var b:Tshape);
var q:integer;
begin
   if x1>x2 then begin
      q:=x1;
      x1:=x2;
      x2:=q;
   end;
   if y1>y2 then begin
      q:=y1;
      y1:=y2;
      y2:=q;
   end;
   b:=Tshape.Create(fmgca7);
   b.Parent:=fmgca7;
   b.Visible:=true;
   b.Tag:=-1;
   b.Left:=x1;
   b.Top:=y1;
   b.Height:=y2-y1+1;
   b.Width:=x2-x1+2;
   b.Hint:=nom;
   b.ShowHint:=true;
end;
procedure Tfmgca7.pinta(n:integer);
var b,p:Tshape;
begin
   if pp[n].existe then
      pp[n].barra.Top:=yy
   else begin
      pp[n].barra:=Tshape.Create(fmgca7);
      b:=pp[n].barra;
      b.Parent:=fmgca7;
      b.Visible:=true;
      b.Tag:=n;
//      b.Left:=pp[n].d1-hora_menor+10;
      b.Left:=pp[n].d1-g_hora;
      b.Height:=9;
      b.Width:=pp[n].dura;
      b.Top:=yy;
      if (pp[n].padre<>-1) then begin     // checa espacio para nombre del JOB
         p:=pp[pp[n].padre].barra;
         if p.top=b.Top then begin
            if (b.Left<p.Left+60) or
               (b.Left<p.Left+p.Width) then begin
               yy:=yy+20;
               b.Top:=yy;
            end;
         end;
         if p.top<>b.Top then begin
//            crea_linea(p.Left+p.Width,p.Top+5,p.Left+p.Width+5,p.Top+5,p.Hint);
            if pp[pp[n].padre].existe_linea then
               pp[pp[n].padre].linea.Height:=b.Top-p.Top
            else begin
               crea_linea(p.Left+p.Width+5,p.Top+5,p.Left+p.Width+5,b.Top+5,p.Hint,pp[pp[n].padre].linea);
               pp[pp[n].padre].existe_linea:=true;
//            crea_linea(p.Left+p.Width+5,b.Top+5,b.Left-1,b.Top+5,p.Hint);
            end;
         end;
      end;
      b.Shape:=stRectangle;
      b.Brush.Color:=clgreen;
      b.Hint:=pp[n].job+'('+inttostr(pp[n].fecha1)+':'+inttostr(pp[n].hora1)+
                        '--'+inttostr(pp[n].fecha2)+':'+inttostr(pp[n].hora2)+')'+
                        '['+inttostr(pp[n].dura)+']';
      b.ShowHint:=true;
      b.OnMouseDown:=barraMouseDown;
      b.Tag:=n;
      pp[n].existe:=true;
   end;
end;
procedure Tfmgca7.pinta_hijos(n:integer);
begin
   if pp[n].hijo=-1 then exit;
   n:=pp[n].hijo;
   if pp[n].nivel<pp[n-1].nivel then begin
      yy:=yy+20;
   end;
   pinta(n);
   pinta_hijos(n);
   while pp[n].hermano<>-1 do begin
      yy:=yy+20;
      n:=pp[n].hermano;
      pinta(n);
      pinta_hijos(n);
   end;
end;
procedure Tfmgca7.ver_todo;
var i:integer;
begin
   yy:=20;
   for i:=0 to length(pp)-1 do begin
      if pp[i].nivel=0 then begin
         pinta(i);
         pinta_hijos(i);
         yy:=yy+20;
      end;
   end;
   b_pinta:=true;
   refresh;
end;
procedure Tfmgca7.Cadena1Click(Sender: TObject);
begin
   ver_todo;
end;

procedure Tfmgca7.FormPaint(Sender: TObject);
var i:integer;
    b,lin:Tshape;
begin
   if b_pinta=false then exit;
   fmgca7.Canvas.Font.Name:='Arial';
   fmgca7.Canvas.Font.Color:=clred;
   fmgca7.Canvas.Font.Size:=8;
   canvas.Brush.Color:=clyellow;
   canvas.Pen.Color:=clgray;
   i:=0;
   while i<width do begin
      canvas.Rectangle(i,0,i+60*g_zoom div 100,height);
      i:=i+120*g_zoom div 100;
   end;
   canvas.Brush.Style:=bsclear;
   canvas.Pen.Color:=clblack;
   for i:=0 to length(pp)-1 do begin
      b:=pp[i].barra;
      if pp[i].existe then begin
         fmgca7.Canvas.TextOut(b.Left,b.Top-12,pp[i].job);
      end;
      if pp[i].existe_linea then begin
         lin:=pp[i].linea;
         canvas.MoveTo(b.Left+b.Width,b.Top+5);
         canvas.LineTo(lin.Left,lin.Top);
      end;
      if pp[i].padre<>-1 then begin
         if pp[pp[i].padre].existe_linea then begin
            lin:=pp[pp[i].padre].linea;
            canvas.MoveTo(b.Left,b.Top+5);
            canvas.LineTo(lin.Left,b.Top+5);
         end
         else begin
            lin:=pp[pp[i].padre].barra;
            canvas.MoveTo(b.Left,b.Top+5);
            canvas.LineTo(lin.Left+lin.Width,b.Top+5);
         end;
      end;
   end;
end;

procedure Tfmgca7.FormCreate(Sender: TObject);
begin
   b_pinta:=false;
   abrir1click(sender);
   cadena1click(sender);
end;

procedure Tfmgca7.N2001Click(Sender: TObject);
var i:integer;
    b,lin:Tshape;
begin
   for i:=0 to length(pp)-1 do begin
      if pp[i].existe then begin
         b:=pp[i].barra;
         b.Left:=pp[i].d1-g_hora;
         b.left:=b.left*g_zoom*2 div 100;
         b.Width:=pp[i].dura*g_zoom*2 div 100;
         if pp[i].existe_linea then begin
            lin:=pp[i].linea;
            lin.left:=b.left+b.width+5;
         end;
      end;
   end;
   g_zoom:=g_zoom*2;
   refresh;
end;

procedure Tfmgca7.N501Click(Sender: TObject);
var i:integer;
    b,lin:Tshape;
begin
   if g_zoom=1 then exit;
   for i:=0 to length(pp)-1 do begin
      if pp[i].existe then begin
         b:=pp[i].barra;
         b.Left:=pp[i].d1-g_hora;
         b.left:=b.left*g_zoom div 2 div 100;
         b.Width:=pp[i].dura*g_zoom div 2 div 100;
         if pp[i].existe_linea then begin
            lin:=pp[i].linea;
            lin.left:=b.left+b.Width +5;
         end;
      end;
   end;
   g_zoom:=g_zoom div 2;
   refresh;
end;

procedure Tfmgca7.barraMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   z_barra:=(sender as tshape).Tag;
   if button=mbright then
      pop.Popup(x+(sender as Tshape).left,y+(sender as Tshape).top);
end;

procedure Tfmgca7.mreporteClick(Sender: TObject);
begin
   memo1.Visible:=not memo1.Visible;
end;

procedure Tfmgca7.Componentes1Click(Sender: TObject);
begin
   PR_LISTA('JOB','COBJCL',pp[z_barra].job);
end;

procedure Tfmgca7.n1001Click(Sender: TObject);
var i:integer;
    b,lin:Tshape;
begin
   for i:=0 to length(pp)-1 do begin
      if pp[i].existe then begin
         b:=pp[i].barra;
         b.Left:=pp[i].d1-g_hora;
         b.left:=b.left*g_zoom*2 div 100;
         b.Width:=pp[i].dura*g_zoom*2 div 100;
         if pp[i].existe_linea then begin
            lin:=pp[i].linea;
            lin.left:=b.left+b.width+5;
         end;
      end;
   end;
   //g_zoom:=g_zoom*2;
   refresh;
end;

end.
