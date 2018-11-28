unit mgfrclp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls, ImgList, ComCtrls, ExtDlgs, shellapi;

type
  Tfrclp = class(TFrame)
    lab: TLabel;
    bot: TSpeedButton;
    imgs: TImageList;
    img: TImage;
    OpenPictureDialog1: TOpenPictureDialog;
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
    xx:array of Tfrclp;
    texto:Trichedit;
    procedure xtipo(n,x,y:integer);
    procedure ocultar;
    function mostrar(ntop:integer):integer;
    function ultimotop:integer;
  end;

implementation
uses mgflrpg,ptsdm;
{$R *.dfm}
procedure Tfrclp.xtipo(n,x,y:integer);
var    rg:Tregistro;
       i:integer;
begin
   nn:=n;
   rg:=(parent as Tfmgflrpg).rg[n];
   nom:=rg.nombre;
   lab.Caption:=stringreplace(nom,'-','- ',[rfreplaceall]);
   ptipo:=rg.tipo;
   if ptipo='INI' then begin
      imgs.GetBitmap(0,img.Picture.Bitmap);
   end
   else if ptipo='SEC' then begin
      imgs.GetBitmap(1,img.Picture.Bitmap);
   end
   else if ptipo='LAB' then begin
      imgs.GetBitmap(2,img.Picture.Bitmap);
   end
   else if (ptipo='CND') and (rg.nombre='IF') then begin
      imgs.GetBitmap(3,img.Picture.Bitmap);
      lab.Caption:=stringreplace(trim(copy((parent as Tfmgflrpg).fte[rg.fteini-1],8,65)),'-','- ',[rfreplaceall]);
      lab.Font.Size:=6;
   end
   else if (ptipo='CND') and (rg.nombre='ELSE') then begin
      imgs.GetBitmap(4,img.Picture.Bitmap);
   end
   else if (ptipo='CND') and (rg.nombre='END-IF') then begin
      imgs.GetBitmap(5,img.Picture.Bitmap);
   end
   else if ptipo='PVY' then begin
      imgs.GetBitmap(6,img.Picture.Bitmap);
      lab.Caption:=stringreplace(trim(copy((parent as Tfmgflrpg).fte[rg.fteini-1],8,65)),'-','- ',[rfreplaceall]);
      lab.Font.Size:=6;
   end
   else if ptipo='EPE' then begin
      imgs.GetBitmap(7,img.Picture.Bitmap);
   end
   else if (ptipo='CND') and (rg.nombre='EVALUATE') then begin
      imgs.GetBitmap(8,img.Picture.Bitmap);
      lab.Caption:=stringreplace(trim(copy((parent as Tfmgflrpg).fte[rg.fteini-1],8,65)),'-','- ',[rfreplaceall]);
      lab.Font.Size:=6;
   end
   else if (ptipo='CND') and (rg.nombre='WHEN') then begin
      imgs.GetBitmap(9,img.Picture.Bitmap);
      lab.Caption:=stringreplace(trim(copy((parent as Tfmgflrpg).fte[rg.fteini-1],8,65)),'-','- ',[rfreplaceall]);
      lab.Font.Size:=6;
   end
   else if (ptipo='CND') and (rg.nombre='END-EVALUATE') then begin
      imgs.GetBitmap(10,img.Picture.Bitmap);
   end
   else if ptipo='PTH' then begin
      imgs.GetBitmap(11,img.Picture.Bitmap);
      lab.Caption:='PERFORM THRU';
   end
   else if ptipo='CAL' then begin
      imgs.GetBitmap(12,img.Picture.Bitmap);
   end
   else if ptipo='CIC' then begin
      imgs.GetBitmap(13,img.Picture.Bitmap);
   end
   else if ptipo='END' then begin
      imgs.GetBitmap(14,img.Picture.Bitmap);
   end
   else if ptipo='INP' then begin
      imgs.GetBitmap(15,img.Picture.Bitmap);
   end
   else if ptipo='OUT' then begin
      imgs.GetBitmap(16,img.Picture.Bitmap);
   end
   else if ptipo='I-O' then begin
      imgs.GetBitmap(17,img.Picture.Bitmap);
   end
   else if ptipo='EXT' then begin
      imgs.GetBitmap(18,img.Picture.Bitmap);
   end
   else if ptipo='REA' then begin
      imgs.GetBitmap(19,img.Picture.Bitmap);
   end
   else if ptipo='WRI' then begin
      imgs.GetBitmap(20,img.Picture.Bitmap);
   end
   else if ptipo='REW' then begin
      imgs.GetBitmap(21,img.Picture.Bitmap);
   end
   else if ptipo='DEL' then begin
      imgs.GetBitmap(22,img.Picture.Bitmap);
   end
   else if ptipo='CLO' then begin
      imgs.GetBitmap(23,img.Picture.Bitmap);
   end
   else if ptipo='SOR' then begin
      imgs.GetBitmap(24,img.Picture.Bitmap);
   end
   else if ptipo='CCA' then begin
      imgs.GetBitmap(25,img.Picture.Bitmap);
   end
   else if ptipo='CXC' then begin
      imgs.GetBitmap(26,img.Picture.Bitmap);
   end
   else if ptipo='SQL' then begin
      imgs.GetBitmap(27,img.Picture.Bitmap);
   end
   else if ptipo='SEL' then begin
      imgs.GetBitmap(28,img.Picture.Bitmap);
   end
   else if ptipo='SIN' then begin
      imgs.GetBitmap(29,img.Picture.Bitmap);
   end
   else if ptipo='SUP' then begin
      imgs.GetBitmap(30,img.Picture.Bitmap);
   end
   else if ptipo='SDL' then begin
      imgs.GetBitmap(31,img.Picture.Bitmap);
   end
   else if ptipo='SOP' then begin
      imgs.GetBitmap(32,img.Picture.Bitmap);
   end
   else if ptipo='SFE' then begin
      imgs.GetBitmap(33,img.Picture.Bitmap);
   end
   else if ptipo='SCL' then begin
      imgs.GetBitmap(34,img.Picture.Bitmap);
   end
   else if (ptipo='CND') and (rg.nombre='SEARCH') then begin
      imgs.GetBitmap(35,img.Picture.Bitmap);
   end
   else if (ptipo='CND') and (rg.nombre='AT-END') then begin
      imgs.GetBitmap(36,img.Picture.Bitmap);
   end
   else if (ptipo='CND') and (rg.nombre='SWHEN') then begin
      imgs.GetBitmap(37,img.Picture.Bitmap);
   end
   else if (ptipo='CND') and (rg.nombre='END-SEARCH') then begin
      imgs.GetBitmap(38,img.Picture.Bitmap);
   end
   else if (ptipo='FUN') then begin
      imgs.GetBitmap(39,img.Picture.Bitmap);
   end
   else if (ptipo='EFU') then begin
      imgs.GetBitmap(40,img.Picture.Bitmap);
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
         if (trim(copy((parent as Tfmgflrpg).fte[i],7,1))='') and (trim(copy((parent as Tfmgflrpg).fte[i],8,65))<>'') then begin
            if hint<>'' then
               hint:=hint+chr(10);
            hint:=hint+copy((parent as Tfmgflrpg).fte[i],7,66);
         end;
      showhint:=true;
   end;
   px:=x;
   py:=y;
   if rg.parini=rg.parfin then
      bot.Visible:=false;
end;

procedure Tfrclp.ocultar;
var i,k:integer;
begin
   if (length(xx)=0) or (bot.Caption='+') then exit;
   k:=xx[0].Top;
   for i:=0 to length(xx)-1 do begin
      xx[i].ocultar;
      xx[i].Visible:=false;
      if xx[i].texto<>nil then begin
         xx[i].texto.Free;
         xx[i].texto:=nil;
      end;
   end;
   (parent as Tfmgflrpg).desplaza(k,-30*length(xx));
end;
function Tfrclp.mostrar(ntop:integer):integer;
var i:integer;
begin
   if bot.Caption='-' then begin
      (parent as Tfmgflrpg).desplaza(ntop-1,30*length(xx));
      for i:=0 to length(xx)-1 do begin
         xx[i].Top:=ntop;
         ntop:=xx[i].mostrar(ntop+30);
         xx[i].Visible:=true;
      end;
   end;
   mostrar:=ntop;
end;
procedure Tfrclp.botClick(Sender: TObject);
var i,j,k,ini,fin,posy:integer;
    rg:Tregistro;
begin
   (parent as Tfmgflrpg).Enabled:=false;
   if bot.Caption='+' then begin
      rg:=(parent as Tfmgflrpg).rg[nn];
      posy:=top+30;
      if b_creados=false then begin
         i:=rg.parini+1;
         while i<=rg.parfin do begin
            if ((parent as Tfmgflrpg).rg[i].nombre<>'DOT') and
               ((parent as Tfmgflrpg).rg[i].nombre<>'END-IF') and
               ((parent as Tfmgflrpg).rg[i].tipo<>'EPE') and
               ((parent as Tfmgflrpg).rg[i].tipo<>'ECI') then begin
               if (parent as Tfmgflrpg).rg[i].ftefin<(parent as Tfmgflrpg).rg[i].fteini then begin
                  i:=i+1;
                  continue;
               end;
               k:=length(xx);
               setlength(xx,k+1);
               (parent as Tfmgflrpg).Crea(i,left+90,posy,xx[k]);
               posy:=posy+30;
            end;
            if (parent as Tfmgflrpg).rg[i].tipo='PTH' then
               i:=i+1
            else
               i:=(parent as Tfmgflrpg).rg[i].parfin+1;
         end;
         b_creados:=true;
         bot.Caption:='-';
      end
      else begin
         bot.Caption:='-';
         mostrar(top+30);
      end;
   end else
   if bot.Caption='-' then begin
      ocultar;
      bot.Caption:='+';
   end;
   (parent as Tfmgflrpg).Invalidate;
   (parent as Tfmgflrpg).Enabled:=true;
end;
function Tfrclp.ultimotop:integer;
var k:integer;
begin
   k:=length(xx);
   if k>0 then
      ultimotop:=xx[k-1].Top
   else
      ultimotop:=0;
end;
procedure Tfrclp.labClick(Sender: TObject);
var i,k,m:integer;
    rg:Tregistro;
    strcall:Tstringlist;
    nom2,nom3:string;
begin
   if (ptipo='PER') or (ptipo='LAB') or (ptipo='SEC') or (ptipo='FUN') then begin
      (parent as Tfmgflrpg).rutina(nom,nn);
      {
      fmgcodigo.BringToFront;
      fmgcodigo.WindowState:=wsnormal;
      if (fmgcodigo.Top<fmgflrpg.VertScrollBar.Position) or
         (fmgcodigo.Top>fmgflrpg.VertScrollBar.Position+fmgflrpg.Height) then begin
         fmgcodigo.Top:=fmgflrpg.VertScrollBar.Position;
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
         rg:=(parent as Tfmgflrpg).rg[nn];
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
            fmgcodigo.re[k].Lines.Add((parent as Tfmgflrpg).fte[i]);
         i:=rg.fteini-2;
         while i>-1 do begin
            if (trim(copy((parent as Tfmgflrpg).fte[i],7,1))='') and (trim(copy((parent as Tfmgflrpg).fte[i],8,65))<>'') then break;
            fmgcodigo.re[k].Lines.Insert(0,(parent as Tfmgflrpg).fte[i]);
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
         rg:=(parent as Tfmgflrpg).rg[nn];
         texto:=Trichedit.create((parent as Tfmgflrpg));
         texto.Visible:=false;
         texto.Parent:=(parent as Tfmgflrpg);
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
            if (trim(copy((parent as Tfmgflrpg).fte[i],7,1))='') and (trim(copy((parent as Tfmgflrpg).fte[i],8,65))<>'') then begin
               texto.Lines.Add(copy((parent as Tfmgflrpg).fte[i],7,66));
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
      (parent as Tfmgflrpg).Invalidate;
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

procedure Tfrclp.imgDblClick(Sender: TObject);
begin
   if openpicturedialog1.Execute then
      img.Picture.LoadFromFile(openpicturedialog1.FileName);
end;

end.

