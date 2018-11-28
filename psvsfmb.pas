unit psvsfmb;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  Tfsvsfmb = class(TForm)
    bmostrar: TBitBtn;
    procedure bmostrarClick(Sender: TObject);
  private
    { Private declarations }
    xx:Tstringlist;
   procedure arma(forma:string);
   function  ncolor(nombre:string):Tcolor;
  public
    { Public declarations }
  end;

var
  fsvsfmb: Tfsvsfmb;
   procedure PR_FMB(forma:string);

implementation

{$R *.dfm}
procedure PR_FMB(forma:string);
begin
   Application.CreateForm( Tfsvsfmb, fsvsfmb );
   fsvsfmb.arma(forma);
   try
      fsvsfmb.Show;
   finally
      fsvsfmb.Free;
   end;
end;

function Tfsvsfmb.ncolor(nombre:string):Tcolor;
begin
   if nombre='black' then ncolor:=clblack else
   if nombre='white' then ncolor:=clwhite else
   if nombre='red' then ncolor:=clred else
   if nombre='darkblue' then ncolor:=clblue else
   if nombre='gray20' then ncolor:=clgray else
   if nombre='darkgreen' then ncolor:=clgreen else
   if nombre='' then   ncolor:=clnone else
                       ncolor:=clyellow;
end;
procedure Tfsvsfmb.arma(forma:string);
var i,xtop,xleft,xwidth,xheight,xprompt_font_size,
   xprompt_attachment_offset:integer;
   xforeground_color,xbackground_color,xprompt_foreground_color:Tcolor;
  a,aa,b,nivel1,nivel2,xname,xprompt_font_name,xprompt,xcanvas,
     xitem_type,xprompt_alignment,xvisible,xprompt_attachment_edge,xlabel,xenabled,
     xgraphics_type,xframe_title:string;
  lab:Tlabel;
  edi:Tedit;
  but:Tbutton;
  gro:Tgroupbox;
  sha:Tshape;
  b_pinta:boolean;
begin
   xx:=Tstringlist.Create;
   xx.LoadFromFile(forma);
   b_pinta:=true;
   for i:=0 to xx.Count-1 do begin
      a:=trimright(copy(xx[i],2,50));
      b:=trim(copy(xx[i],53,200));
      if (copy(a,1,1)='*') or (copy(a,1,1)='-') then begin
         nivel1:=a;
         continue;
      end;
      if nivel1='* Windows' then begin
         if a='  * Title' then caption:=b else
         if a='  * Font Name' then font.Name:=b else
         if a='  * Font Size' then font.Size:=strtoint(b) else
         if a='  - X Position' then left:=strtoint(b) else
         if a='  - Y Position' then top:=strtoint(b) else
         if a='  * Width' then begin
            width:=strtoint(b);
            bmostrar.Left:=10;
         end
         else
         if a='  * Height' then begin
            height:=strtoint(b)+70;
            bmostrar.Top:=height-90;
         end;
         continue;
      end;
//      if nivel1='* Blocks' then begin
      if nivel1<>'' then begin
         aa:=trim(copy(a,7,100));
         if aa='Name' then xname:=b else
         if aa='Item Type' then xitem_type:=b else
         if aa='Enabled' then xenabled:=b else
         if aa='Label' then xlabel:=b else
         if aa='Visible' then xvisible:=b else
         if aa='Canvas' then xcanvas:=b else
         if aa='X Position' then xLeft:=strtoint(b) else
         if aa='Y Position' then xtop:=strtoint(b) else
         if aa='Width' then      xwidth:=strtoint(b) else
         if aa='Height' then     xheight:=strtoint(b) else
         if aa='Foreground Color' then xforeground_color:=ncolor(b) else
         if aa='Background Color' then xbackground_color:=ncolor(b) else
         if aa='Prompt Foreground Color' then xprompt_foreground_color:=ncolor(b) else
         if aa='Prompt' then xprompt:=b else
         if aa='Prompt Attachment Edge' then xprompt_attachment_edge:=b else
         if aa='Prompt Alignment' then xprompt_alignment:=b else
         if aa='Prompt Attachment Offset' then xprompt_attachment_offset:=strtoint(b) else
         if aa='Prompt Font Name' then xprompt_font_name:=b else
         if aa='Prompt Font Size' then xprompt_font_size:=strtoint(b) else
         if aa='Graphics Type' then
         xgraphics_type:=b
         else
         if aa='Frame Title' then xFrame_Title:=b else
         if aa='--------' then begin
            if (xitem_type='Text Item') or
               (xitem_type='Display Item') or
               (xitem_type='OLE Container') or
               (xitem_type='Sound') or
               (xitem_type='Image') then begin
               edi:=Tedit.Create(fsvsfmb);
               edi.Parent:=fsvsfmb;
               edi.Visible:=((xvisible='Yes') and (xcanvas<>''));
               edi.Top:=xtop;
               edi.Left:=xleft;
               edi.Width:=xwidth;
               edi.Height:=xheight;
               edi.Text:=xname;
               edi.Enabled:=(xenabled='Yes');
               if xbackground_color<>clnone then edi.Color:=xbackground_color;
               if xforeground_color<>clnone then edi.Font.Color:=xforeground_color;
               if xprompt<>'' then begin
                  lab:=Tlabel.Create(fsvsfmb);
                  lab.Parent:=fsvsfmb;
                  lab.Caption:=xprompt;
                  lab.Visible:=edi.visible;
                  if xprompt_foreground_color<>clnone then lab.Font.Color:=xprompt_foreground_color;
                  if xprompt_attachment_edge='Start' then begin
                     lab.Top:=edi.Top;
                     lab.Left:=edi.Left-lab.Width-xprompt_attachment_offset-10;
                  end else
                  if xprompt_attachment_edge='End' then begin
                     lab.Top:=edi.Top;
                     lab.Left:=edi.Left+lab.Width+xprompt_attachment_offset+10;
                  end else
                  if xprompt_attachment_edge='Top' then begin
                     lab.Top:=edi.Top-lab.Height-xprompt_attachment_offset;
                     lab.Left:=edi.Left;
                     lab.AutoSize:=false;
                     lab.Width:=edi.Width;
                     if xprompt_alignment='Center' then lab.Alignment:=tacenter else
                     if xprompt_alignment='Start' then lab.Alignment:=taleftjustify else
                        lab.Alignment:=tarightjustify;
                  end else
                  if xprompt_attachment_edge='Bottom' then begin
                     lab.Top:=edi.Top+edi.Height+xprompt_attachment_offset;
                     lab.Left:=edi.Left;
                     lab.AutoSize:=false;
                     lab.Width:=edi.Width;
                     if xprompt_alignment='Center' then lab.Alignment:=tacenter else
                     if xprompt_alignment='Start' then lab.Alignment:=taleftjustify else
                        lab.Alignment:=tarightjustify;
                  end;
               end;
            end;
            if xitem_type='Push Button' then begin
               but:=Tbutton.Create(fsvsfmb);
               but.Parent:=fsvsfmb;
               but.Visible:=((xvisible='Yes') and (xcanvas<>''));
               but.Top:=xtop;
               but.Left:=xleft;
               but.Width:=xwidth;
               but.Height:=xheight;
               but.Caption:=xlabel;
               but.Enabled:=(xenabled='Yes');
               if xforeground_color<>clnone then but.Font.Color:=xforeground_color;
            end;
            if xgraphics_type='Frame' then begin
               {
               gro:=Tgroupbox.Create(fsvsfmb);
               gro.Parent:=fsvsfmb;
               gro.Visible:=true;
               gro.Top:=xtop;
               gro.Left:=xleft;
               gro.Width:=xwidth;
               gro.Height:=xheight;
               gro.Caption:=xframe_title;
               gro.SendToBack;
               }
               sha:=Tshape.Create(fsvsfmb);
               sha.parent:=fsvsfmb;
               sha.Visible:=true;
               sha.Top:=xtop;
               sha.Left:=xleft;
               sha.Width:=xwidth;
               sha.Height:=1;
               sha:=Tshape.Create(fsvsfmb);
               sha.parent:=fsvsfmb;
               sha.Visible:=true;
               sha.Top:=xtop;
               sha.Left:=xleft;
               sha.Width:=1;
               sha.Height:=xheight;
               sha:=Tshape.Create(fsvsfmb);
               sha.parent:=fsvsfmb;
               sha.Visible:=true;
               sha.Top:=xtop+xheight;
               sha.Left:=xleft;
               sha.Width:=xwidth;
               sha.Height:=1;
               sha:=Tshape.Create(fsvsfmb);
               sha.parent:=fsvsfmb;
               sha.Visible:=true;
               sha.Top:=xtop;
               sha.Left:=xleft+xwidth;
               sha.Width:=1;
               sha.Height:=xheight;
               lab:=Tlabel.Create(fsvsfmb);
               lab.Parent:=fsvsfmb;
               lab.Caption:='   '+xframe_title+'   ';
               lab.Visible:=true;
               lab.Top:=xtop-7;
               lab.Left:=xleft+10;
            end;
            xgraphics_type:='';
            xitem_type:='';
         end;
      end;
   end;
   for i:=0 to componentcount-1 do begin
      if components[i] is Tlabel then
         (components[i] as Tlabel).BringToFront;
   end;
end;
procedure Tfsvsfmb.bmostrarClick(Sender: TObject);
var i:integer;
   edi:Tedit;
   lab:Tlabel;
   but:Tbutton;
begin
   if bmostrar.Caption='Mostrar Objetos Ocultos' then begin
      bmostrar.Caption:='Ocultar Objetos';
      for i:=0 to componentcount-1 do begin
         if components[i] is Tedit then begin
            edi:=(components[i] as Tedit);
            if edi.Visible=false then begin
               edi.Tag:=9;
               edi.Visible:=true;
            end;
         end else
         if components[i] is Tlabel then begin
            lab:=(components[i] as Tlabel);
            if lab.Visible=false then begin
               lab.Tag:=9;
               lab.Visible:=true;
            end;
         end else
         if components[i] is Tbutton then begin
            but:=(components[i] as Tbutton);
            if but.Visible=false then begin
               but.Tag:=9;
               but.Visible:=true;
            end;
         end;
      end;
   end
   else begin
      bmostrar.Caption:='Mostrar Objetos Ocultos';
      for i:=0 to componentcount-1 do begin
         if components[i].Tag=9 then begin
            if components[i] is Tedit then begin
               edi:=(components[i] as Tedit);
               edi.Visible:=false;
            end else
            if components[i] is Tlabel then begin
               lab:=(components[i] as Tlabel);
               lab.Visible:=false;
            end else
            if components[i] is Tbutton then begin
               but:=(components[i] as Tbutton);
               but.Visible:=false;
            end;
         end;
      end;
   end
end;

end.
