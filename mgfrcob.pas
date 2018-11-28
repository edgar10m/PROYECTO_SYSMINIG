unit mgfrcob;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls, ImgList, ComCtrls, ExtDlgs, shellapi;

type
  Tfrcob = class(TFrame)
    lab: TLabel;
    bot: TSpeedButton;
    img: TImage;
    procedure botClick(Sender: TObject);
    procedure labClick(Sender: TObject);
    procedure imgDblClick(Sender: TObject);
  private
    { Private declarations }
    nom:string;
    nn:integer;
    b_creados:boolean;
  public
    { Public declarations }
    px,py:integer;
    ptipo:string;
    nodotext:string;
    xx:array of Tfrcob;
    texto:Trichedit;
    procedure xtipo(n,x,y:integer);
    function ocultar(b_desplaza:boolean):integer;
    function mostrar(ntop:integer):integer;
    function ultimotop:integer;
  end;

implementation
uses mgflcob,ptsdm;
{$R *.dfm}
procedure Tfrcob.xtipo(n,x,y:integer);
var    rg:Tregistro;
       i:integer;
begin
   nn:=n;
   rg:=(parent as Tfmgflcob).rg[n];
   nom:=rg.nombre;
   lab.Caption:=stringreplace(nom,'-','- ',[rfreplaceall]);
   ptipo:=rg.tipo;
   if ptipo='INI' then begin
      (parent as Tfmgflcob).imgs.GetBitmap(0,img.Picture.Bitmap);
   end
   else if ptipo='SEC' then begin
      (parent as Tfmgflcob).imgs.GetBitmap(1,img.Picture.Bitmap);
   end
   else if ptipo='LAB' then begin
      (parent as Tfmgflcob).imgs.GetBitmap(2,img.Picture.Bitmap);
   end
   else if (ptipo='CND') and (rg.nombre='IF') then begin
      (parent as Tfmgflcob).imgs.GetBitmap(3,img.Picture.Bitmap);
      lab.Caption:=stringreplace(trim(copy((parent as Tfmgflcob).fte[rg.fteini-1],8,65)),'-','- ',[rfreplaceall]);
      lab.Font.Size:=6;
   end
   else if (ptipo='CND') and (rg.nombre='ELSE') then begin
      (parent as Tfmgflcob).imgs.GetBitmap(4,img.Picture.Bitmap);
   end
   else if (ptipo='CND') and (rg.nombre='END-IF') then begin
      (parent as Tfmgflcob).imgs.GetBitmap(5,img.Picture.Bitmap);
   end
   else if ptipo='PVY' then begin
      (parent as Tfmgflcob).imgs.GetBitmap(6,img.Picture.Bitmap);
      lab.Caption:=stringreplace(trim(copy((parent as Tfmgflcob).fte[rg.fteini-1],8,65)),'-','- ',[rfreplaceall]);
      lab.Font.Size:=6;
   end
   else if ptipo='EPE' then begin
      (parent as Tfmgflcob).imgs.GetBitmap(7,img.Picture.Bitmap);
   end
   else if (ptipo='CND') and (rg.nombre='EVALUATE') then begin
      (parent as Tfmgflcob).imgs.GetBitmap(8,img.Picture.Bitmap);
      lab.Caption:=stringreplace(trim(copy((parent as Tfmgflcob).fte[rg.fteini-1],8,65)),'-','- ',[rfreplaceall]);
      lab.Font.Size:=6;
   end
   else if (ptipo='CND') and (rg.nombre='WHEN') then begin
      (parent as Tfmgflcob).imgs.GetBitmap(9,img.Picture.Bitmap);
      lab.Caption:=stringreplace(trim(copy((parent as Tfmgflcob).fte[rg.fteini-1],8,65)),'-','- ',[rfreplaceall]);
      lab.Font.Size:=6;
   end
   else if (ptipo='CND') and (rg.nombre='END-EVALUATE') then begin
      (parent as Tfmgflcob).imgs.GetBitmap(10,img.Picture.Bitmap);
   end
   else if ptipo='PTH' then begin
      (parent as Tfmgflcob).imgs.GetBitmap(11,img.Picture.Bitmap);
      lab.Caption:='PERFORM THRU';
   end
   else if ptipo='CAL' then begin
      (parent as Tfmgflcob).imgs.GetBitmap(12,img.Picture.Bitmap);
   end
   else if ptipo='CIC' then begin
      (parent as Tfmgflcob).imgs.GetBitmap(13,img.Picture.Bitmap);
   end
   else if ptipo='END' then begin
      (parent as Tfmgflcob).imgs.GetBitmap(14,img.Picture.Bitmap);
   end
   else if ptipo='INP' then begin
      (parent as Tfmgflcob).imgs.GetBitmap(15,img.Picture.Bitmap);
   end
   else if ptipo='OUT' then begin
      (parent as Tfmgflcob).imgs.GetBitmap(16,img.Picture.Bitmap);
   end
   else if ptipo='I-O' then begin
      (parent as Tfmgflcob).imgs.GetBitmap(17,img.Picture.Bitmap);
   end
   else if ptipo='EXT' then begin
      (parent as Tfmgflcob).imgs.GetBitmap(18,img.Picture.Bitmap);
   end
   else if ptipo='REA' then begin
      (parent as Tfmgflcob).imgs.GetBitmap(19,img.Picture.Bitmap);
   end
   else if ptipo='WRI' then begin
      (parent as Tfmgflcob).imgs.GetBitmap(20,img.Picture.Bitmap);
   end
   else if ptipo='REW' then begin
      (parent as Tfmgflcob).imgs.GetBitmap(21,img.Picture.Bitmap);
   end
   else if ptipo='DEL' then begin
      (parent as Tfmgflcob).imgs.GetBitmap(22,img.Picture.Bitmap);
   end
   else if ptipo='CLO' then begin
      (parent as Tfmgflcob).imgs.GetBitmap(23,img.Picture.Bitmap);
   end
   else if ptipo='SOR' then begin
      (parent as Tfmgflcob).imgs.GetBitmap(24,img.Picture.Bitmap);
   end
   else if ptipo='CCA' then begin
      (parent as Tfmgflcob).imgs.GetBitmap(25,img.Picture.Bitmap);
   end
   else if ptipo='CXC' then begin
      (parent as Tfmgflcob).imgs.GetBitmap(26,img.Picture.Bitmap);
   end
   else if ptipo='SQL' then begin
      (parent as Tfmgflcob).imgs.GetBitmap(27,img.Picture.Bitmap);
   end
   else if ptipo='SEL' then begin
      (parent as Tfmgflcob).imgs.GetBitmap(28,img.Picture.Bitmap);
   end
   else if ptipo='SIN' then begin
      (parent as Tfmgflcob).imgs.GetBitmap(29,img.Picture.Bitmap);
   end
   else if ptipo='SUP' then begin
      (parent as Tfmgflcob).imgs.GetBitmap(30,img.Picture.Bitmap);
   end
   else if ptipo='SDL' then begin
      (parent as Tfmgflcob).imgs.GetBitmap(31,img.Picture.Bitmap);
   end
   else if ptipo='SOP' then begin
      (parent as Tfmgflcob).imgs.GetBitmap(32,img.Picture.Bitmap);
   end
   else if ptipo='SFE' then begin
      (parent as Tfmgflcob).imgs.GetBitmap(33,img.Picture.Bitmap);
   end
   else if ptipo='SCL' then begin
      (parent as Tfmgflcob).imgs.GetBitmap(34,img.Picture.Bitmap);
   end
   else if (ptipo='CND') and (rg.nombre='SEARCH') then begin
      (parent as Tfmgflcob).imgs.GetBitmap(35,img.Picture.Bitmap);
   end
   else if (ptipo='CND') and (rg.nombre='AT-END') then begin
      (parent as Tfmgflcob).imgs.GetBitmap(36,img.Picture.Bitmap);
   end
   else if (ptipo='CND') and (rg.nombre='SWHEN') then begin
      (parent as Tfmgflcob).imgs.GetBitmap(37,img.Picture.Bitmap);
   end
   else if (ptipo='CND') and (rg.nombre='END-SEARCH') then begin
      (parent as Tfmgflcob).imgs.GetBitmap(38,img.Picture.Bitmap);
   end
   else if (ptipo='FUN') then begin
      (parent as Tfmgflcob).imgs.GetBitmap(39,img.Picture.Bitmap);
   end
   else if (ptipo='EFU') then begin
      (parent as Tfmgflcob).imgs.GetBitmap(40,img.Picture.Bitmap);
   end
   else if (ptipo='GOT') then begin
      (parent as Tfmgflcob).imgs.GetBitmap(41,img.Picture.Bitmap);
   end;
   if ((ptipo='CND') and (uppercase(rg.nombre)='IF')) or      // Documenta el Hint
      ((ptipo='CND') and (uppercase(rg.nombre)='ELSE')) or
      ((ptipo='CND') and (uppercase(rg.nombre)='WHEN')) or
      ((ptipo='CND') and (uppercase(rg.nombre)='AT-END')) or
      ((ptipo='CND') and (uppercase(rg.nombre)='SWHEN')) or
      (ptipo='SQL') or
      (ptipo='SEL') or
      (ptipo='SIN') or
      (ptipo='SUP') or
      (ptipo='SDL') or
      (ptipo='CIC') then begin
      for i:=rg.fteini-1 to rg.ftefin-1 do
         if (trim(copy((parent as Tfmgflcob).fte[i],7,1))='') and (trim(copy((parent as Tfmgflcob).fte[i],8,65))<>'') then begin
            if hint<>'' then
               hint:=hint+chr(10);
            hint:=hint+copy((parent as Tfmgflcob).fte[i],7,66);
         end;
      showhint:=true;
   end;
   px:=x;
   py:=y;
   if rg.parini=rg.parfin then
      bot.Visible:=false;
end;

function Tfrcob.ocultar(b_desplaza:boolean):integer;
var i,k,n:integer;
begin
   n:=0;
   if (length(xx)=0) or (bot.Caption='+') then begin
      ocultar:=n;
      exit;
   end;
   k:=xx[0].Top;
   for i:=0 to length(xx)-1 do begin
      n:=n+xx[i].ocultar(false)+1;
      xx[i].Visible:=false;
      if xx[i].texto<>nil then begin
         xx[i].texto.Free;
         xx[i].texto:=nil;
      end;
   end;
   if b_desplaza then
      (parent as Tfmgflcob).desplaza(k,-30*n);
   ocultar:=n;
end;
function Tfrcob.mostrar(ntop:integer):integer;
var i:integer;
begin
   if bot.Caption='-' then begin
      (parent as Tfmgflcob).desplaza(ntop-1,30*length(xx));
      for i:=0 to length(xx)-1 do begin
         xx[i].Top:=ntop;
         ntop:=xx[i].mostrar(ntop+30);
         xx[i].Visible:=true;
      end;
   end;
   mostrar:=ntop;
end;
procedure Tfrcob.botClick(Sender: TObject);
var i,j,k,ini,fin,posy:integer;
    rg:Tregistro;
   procedure alta;
   begin
      k:=length(xx);
      setlength(xx,k+1);
      (parent as Tfmgflcob).Crea(i,left+90,posy,xx[k]);
      posy:=posy+30;
      if posy>32000 then begin   // corrige limite de forma
         (parent as Tfmgflcob).VertScrollBar.Position:=(parent as Tfmgflcob).VertScrollBar.Position+30000;
         posy:=posy-30000;
      end;
   end;
begin
   screen.Cursor:=crsqlwait;
   (parent as Tfmgflcob).Enabled:=false;
   if bot.Caption='+' then begin
      rg:=(parent as Tfmgflcob).rg[nn];
      posy:=top+30;
      if b_creados=false then begin
         j:=(parent as Tfmgflcob).VertScrollBar.Position;  // para restablecer la posicion
         i:=rg.parini+1;
         while i<=rg.parfin do begin
            if rg.tipo='BLQ' then begin    // bloques de etiquetas
               if (parent as Tfmgflcob).rg[i].tipo<>'LAB' then
                  i:=i+1
               else begin
                  alta;
                  i:=(parent as Tfmgflcob).rg[i].parfin+1;
               end;
               continue;
            end;
            if ((parent as Tfmgflcob).rg[i].nombre<>'DOT') and
               ((parent as Tfmgflcob).rg[i].nombre<>'END-IF') and
               ((parent as Tfmgflcob).rg[i].tipo<>'EPE') and
               ((parent as Tfmgflcob).rg[i].tipo<>'ECI') then begin
               if (parent as Tfmgflcob).rg[i].ftefin<(parent as Tfmgflcob).rg[i].fteini then begin
                  i:=i+1;
                  continue;
               end;
               alta;
               {
               k:=length(xx);
               setlength(xx,k+1);
               (parent as Tfmgflcob).Crea(i,left+90,posy,xx[k]);
               posy:=posy+30;
               if posy>32000 then begin   // corrige limite de forma
                  (parent as Tfmgflcob).VertScrollBar.Position:=(parent as Tfmgflcob).VertScrollBar.Position+30000;
                  posy:=posy-30000;
               end;
               }
            end;
            if (parent as Tfmgflcob).rg[i].tipo='PTH' then
               i:=i+1
            else
               i:=(parent as Tfmgflcob).rg[i].parfin+1;
         end;
         b_creados:=true;
         bot.Caption:='-';
         (parent as Tfmgflcob).VertScrollBar.Position:=j;    // restablece la posicion
      end
      else begin
         bot.Caption:='-';
         mostrar(top+30);
      end;
   end else
   if bot.Caption='-' then begin
      ocultar(true);
      bot.Caption:='+';
   end;
   (parent as Tfmgflcob).Invalidate;
   (parent as Tfmgflcob).Enabled:=true;
   screen.Cursor:=crdefault;
end;
function Tfrcob.ultimotop:integer;
var k:integer;
begin
   k:=length(xx);
   if k>0 then
      ultimotop:=xx[k-1].Top
   else
      ultimotop:=0;
end;
procedure Tfrcob.labClick(Sender: TObject);
var i,k,m:integer;
    rg:Tregistro;
    strcall:Tstringlist;
    nom2,nom3:string;
begin
   if (ptipo='PER') or (ptipo='LAB') or (ptipo='SEC') or (ptipo='FUN') then begin
      (parent as Tfmgflcob).rutina(nom,nn);
      {
      fmgcodigo.BringToFront;
      fmgcodigo.WindowState:=wsnormal;
      if (fmgcodigo.Top<fmgflcob.VertScrollBar.Position) or
         (fmgcodigo.Top>fmgflcob.VertScrollBar.Position+fmgflcob.Height) then begin
         fmgcodigo.Top:=fmgflcob.VertScrollBar.Position;
      end;
      fmgcodigo.Caption:=nom;
      m:=fmgcodigo.nom.IndexOf(nom);
      k:=fmgcodigo.lb.Items.IndexOf(nom);
      if k>-1 then begin
         fmgcodigo.Re[m].BringToFront;
         fmgcodigo.lb.Items.Delete(k);
         fmgcodigo.lb.Items.Insert(0,nom);
         fmgcodigo.Show;
      end
      else begin
         rg:=(parent as Tfmgflcob).rg[nn];
         k:=length(fmgcodigo.re);
         setlength(fmgcodigo.re,k+1);
         fmgcodigo.re[k]:=Trichedit.create(fmgcodigo);
         fmgcodigo.re[k].Parent:=fmgcodigo;
         fmgcodigo.re[k].Visible:=true;
         fmgcodigo.re[k].Font.Name:='Courier New';
         fmgcodigo.re[k].Font.Size:=8;
         fmgcodigo.re[k].WordWrap:=false;
         fmgcodigo.re[k].Left:=500;
         fmgcodigo.re[k].Align:=AlClient;
         fmgcodigo.re[k].ScrollBars:=ssBoth;
         for i:=rg.fteini-1 to rg.ftefin-1 do
            fmgcodigo.re[k].Lines.Add((parent as Tfmgflcob).fte[i]);
         i:=rg.fteini-2;
         while i>-1 do begin
            if (trim(copy((parent as Tfmgflcob).fte[i],7,1))='') and (trim(copy((parent as Tfmgflcob).fte[i],8,65))<>'') then break;
            fmgcodigo.re[k].Lines.Insert(0,(parent as Tfmgflcob).fte[i]);
            i:=i-1;
         end;
         fmgcodigo.re[k].BringToFront;
         fmgcodigo.nom.Add(nom);
         fmgcodigo.lb.Items.Insert(0,nom);
         fmgcodigo.Show;
         fmgcodigo.re[k].SetFocus;
         fmgcodigo.re[k].SelStart:=0;
         fmgcodigo.re[k].SelLength:=1;
      end;
      }
   end else
   if ((ptipo='CND') and (uppercase(nom)='IF')) or
      ((ptipo='CND') and (uppercase(nom)='ELSE')) or
      ((ptipo='CND') and (uppercase(nom)='WHEN')) or
      ((ptipo='CND') and (uppercase(nom)='AT-END')) or
      ((ptipo='CND') and (uppercase(nom)='SWHEN')) or
      (ptipo='PVY') or
      (ptipo='SQL') or
      (ptipo='SEL') or
      (ptipo='SIN') or
      (ptipo='SUP') or
      (ptipo='SDL') or
      (ptipo='SOP') or
      (ptipo='SFE') or
      (ptipo='SCL') or
      (ptipo='CIC') then begin
      if texto=nil then begin
         rg:=(parent as Tfmgflcob).rg[nn];
         texto:=Trichedit.create((parent as Tfmgflcob));
         texto.Visible:=false;
         texto.Parent:=(parent as Tfmgflcob);
         texto.Font.Name:='Courier New';
         texto.Font.Size:=6;
         texto.Color:=clyellow;
         texto.WordWrap:=false;
         texto.Left:=left+width+150;
         texto.Height:=1;
         texto.Width:=330;
         texto.DragMode:=dmAutomatic;
         texto.ScrollBars:=ssVertical;
         for i:=rg.fteini-1 to rg.ftefin-1 do
            if (trim(copy((parent as Tfmgflcob).fte[i],7,1))='') and (trim(copy((parent as Tfmgflcob).fte[i],8,65))<>'') then begin
               texto.Lines.Add(copy((parent as Tfmgflcob).fte[i],7,66));
               texto.Height:=texto.Height+10;
            end;
         texto.top:=top-(texto.Height div 2);
         texto.Visible:=true;
//         texto.SetFocus;
//         texto.SelStart:=0;
//         texto.SelLength:=1;
      end
      else begin
         texto.Free;
         texto:=nil;
      end;
      (parent as Tfmgflcob).Invalidate;
   end else
   if (ptipo='CAL') or
      (ptipo='CCA') or
      (ptipo='CXC') then begin
      nom2:=stringreplace(nom,'''','',[rfreplaceall]);
      nom2:=stringreplace(nom2,'"','',[rfreplaceall]);
      nom2:=lowercase(nom2);
      if nom=nom2 then exit;   // Es una variable con el nombre del programa
      nom3:=nodotext;
      while pos('_',nom3)>0 do nom3:=copy(nom3,pos('_',nom3)+1,500);
      strcall:=Tstringlist.Create;
      strcall.Add(stringreplace(nodotext,'_'+nom3,'_'+nom2,[]));
      strcall.SaveToFile(g_ruta+'tmp\svsflcob.next');
      strcall.Free;
   end;
end;

procedure Tfrcob.imgDblClick(Sender: TObject);
begin
   if (parent as Tfmgflcob).openpicturedialog1.Execute then
      img.Picture.LoadFromFile((parent as Tfmgflcob).openpicturedialog1.FileName);
end;

end.

