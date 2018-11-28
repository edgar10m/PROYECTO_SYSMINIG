unit mgflrpg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, mgfrclp, Grids, mgcodigo, StdCtrls, ComCtrls, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdFTP, Menus, dxBar;
type
   Tregistro=record
      tipo:string;
      seccion:string;
      etiqueta:string;
      fteini:integer;
      ftefin:integer;
      parini:integer;
      parfin:integer;
      nombre:string;
      nombrethru:string;
   end;
type
  Tfmgflrpg = class(TForm)
    sg: TStringGrid;
    ColorDialog1: TColorDialog;
    IdFTP1: TIdFTP;
    ventanas1: TPopupMenu;
    mnuPrincipal: TdxBarManager;
    procedure FormPaint(Sender: TObject);
    procedure FormDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FormDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure FormDblClick(Sender: TObject);
   procedure ventana1click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    q:Tfrclp;
    nn:integer;
    kcics:integer;
    nodotext:string;
    fmgcodigo: array of Tfmgcodigo;
  public
    { Public declarations }
     fte,par:Tstringlist;
     pp,sec,lab,cnd:array of Tstringlist;
     rg:array of Tregistro;
     b_codigo:boolean;
     titulo: string;
     procedure pinta(canva:Tcanvas);
     procedure desplaza(y,z:integer);
     procedure Crea(n,x,y:integer;var q:Tfrclp);
     procedure arma(nombre_prog:string; archivo:string; nodotext:string);
     procedure rutina(nombre:string; nn:integer);
  end;

implementation

uses ptsdm, ptsgral,parbol;
{$R *.dfm}
procedure Tfmgflrpg.rutina(nombre:string; nn:integer);
var i,k,ini:integer;
    ventana:Tmenuitem;
begin
   for i:=0 to ventanas1.items.Count-1 do begin
      ventana:=(ventanas1.Items[i] as Tmenuitem);
      if copy(ventana.Caption,pos('_',ventana.Caption)+1,100)=nombre then begin
         fmgcodigo[ventana.Tag].WindowState:=wsnormal;
         fmgcodigo[ventana.Tag].Top:=mouse.CursorPos.Y-top-100;
         fmgcodigo[ventana.Tag].show;
         exit;
      end;
   end;
   k:=length(fmgcodigo);
   setlength(fmgcodigo,k+1);
   fmgcodigo[k]:=Tfmgcodigo.create(self);
   fmgcodigo[k].parent:=self;
   fmgcodigo[k].Caption:=g_version_tit+'  -  '+nombre;
   fmgcodigo[k].Top:=mouse.CursorPos.Y-top-100;
   fmgcodigo[k].visible:=true;
   ventana:=Tmenuitem.Create(self);
   ventana.Caption:=inttostr(k)+'_'+nombre;
   ventana.Tag:=k;
   ventana.OnClick:=ventana1click;
   ventanas1.Items.Add(ventana);
   ini:=0;
   for i:=rg[nn].fteini-1 to rg[nn].ftefin-1 do begin
      fmgcodigo[k].memo1.Lines.Add(fte[i]);
      {
      if copy(fte[i],7,1)<>' ' then begin
         fmgcodigo[k].memo1.SelStart:=ini;
         fmgcodigo[k].memo1.SelLength:=length(fte[i]);
         fmgcodigo[k].memo1.SelAttributes.Color:=clgray;
      end;
      }
      ini:=ini+length(fte[i])+2;
   end;
   i:=rg[nn].fteini-2;
   while i>-1 do begin
      if (trim(copy(fte[i],7,1))='') and (trim(copy(fte[i],8,65))<>'') then break;
      fmgcodigo[k].memo1.Lines.Insert(0,fte[i]);
      {
      fmgcodigo[k].memo1.SelStart:=0;
      fmgcodigo[k].memo1.SelLength:=length(fte[i]);
      fmgcodigo[k].memo1.SelAttributes.Color:=clgray;
      }
      i:=i-1;
   end;
   fmgcodigo[k].show;
end;
procedure Tfmgflrpg.ventana1click(Sender: TObject);
begin
      fmgcodigo[(sender as Tmenuitem).Tag].WindowState:=wsnormal;
      fmgcodigo[(sender as Tmenuitem).Tag].Top:=mouse.CursorPos.Y-top-100;
      fmgcodigo[(sender as Tmenuitem).Tag].show;
end;
procedure Tfmgflrpg.arma(nombre_prog:string; archivo:string; nodotext:string);
var i,j,k,m:integer;
    kcnd,ksec,klab,kperf,keval,ksearch,kfun:array of integer;
    final:string;
    sep:Tstringlist;
    b_lab,b_else:boolean;
begin
{
   nombre_prog:=paramstr(1);
   directiva:=paramstr(2);
   g_ruta:=paramstr(3);
   nodotext:=paramstr(4);
}
   final:=nombre_prog;
   while pos('\',final)>0 do final:=copy(final,pos('\',final)+1,500);
   //caption:=final;
   caption := titulo;
   fte:=Tstringlist.Create;
   par:=Tstringlist.Create;
   fte.LoadFromFile(nombre_prog);
   par.LoadFromFile(archivo);
   kcics:=-1;
   sep:=Tstringlist.Create;
   setlength(rg,par.Count);
   for i:=0 to par.Count-1 do begin
      final:=inttostr(par.count);
      sep.CommaText:=par[i];
      rg[i].tipo:=sep[0];
      if sep.Count>2 then rg[i].seccion:=sep[2];
      if sep.Count>1 then rg[i].fteini:=strtoint(sep[1]);
      if sep.Count>1 then rg[i].ftefin:=strtoint(sep[1]);
      rg[i].parini:=i;
      rg[i].parfin:=i;
      if sep.Count>3 then rg[i].etiqueta:=sep[3]
      else                rg[i].etiqueta:=rg[i].seccion;
      if sep.Count>4 then rg[i].nombre:=sep[4]
      else                rg[i].nombre:=rg[i].etiqueta;
      if sep.Count>5 then rg[i].nombrethru:=sep[5]
      else                rg[i].nombrethru:=rg[i].nombre;
{
      if rg[i].tipo='PER' then begin
         for j:=1 to length(rg[i].nombre) do
            if (rg[i].nombre[j]>'9') or (rg[i].nombre[j]<'0') then  break;
         if j>length(rg[i].nombre) then
            rg[i].tipo:='PVY';
      end;
}
      if rg[i].tipo='INI' then begin
         rg[i].parfin:=par.Count-1;
         rg[i].ftefin:=fte.Count;
      end else
      if rg[i].tipo='SEC' then begin
         rg[i].parfin:=par.Count-1;
         rg[i].ftefin:=fte.Count;
         k:=length(ksec);
         setlength(ksec,k+1);
         ksec[k]:=i;                 // Cierra Section anterior
         if k>0 then begin
            j:=ksec[k-1];
            rg[j].parfin:=i-1;
            rg[j].ftefin:=rg[i].fteini-1;
         end;
         if b_lab then begin
            k:=length(klab);            // Cierra el fin de etiqueta anterior
            if k>0 then begin
               j:=klab[k-1];
               rg[j].parfin:=i-1;
               rg[j].ftefin:=rg[i].fteini-1;
            end;
         end;
         b_lab:=false;
      end else
      if rg[i].tipo='LAB' then begin
         rg[i].parfin:=par.Count-1;
         rg[i].ftefin:=fte.Count;
         k:=length(klab);
         setlength(klab,k+1);
         klab[k]:=i;
         if b_lab then begin
            if k>0 then begin
               j:=klab[k-1];
               rg[j].parfin:=i-1;
               rg[j].ftefin:=rg[i].fteini-1;
            end;
         end;
         b_lab:=true;
      end else
      if rg[i].tipo='CND' then begin
         k:=length(kcnd);
         if uppercase(rg[i].nombre)='IF' then begin
            setlength(kcnd,k+1);
            kcnd[k]:=i;
            b_else:=false;
         end;
         if uppercase(rg[i].nombre)='ELSE' then begin
            if k=0 then begin
               Application.MessageBox(pchar(dm.xlng('Error... ELSE sin IF')),
                                      pchar(dm.xlng('Diagrama de flujo ')), MB_OK );
            end
            else begin
               j:=kcnd[k-1];
               while uppercase(rg[j].nombre)='ELSE' do begin
                  rg[j].parfin:=i-1;
                  if rg[j].fteini>rg[i].fteini-1 then
                     rg[j].ftefin:=rg[i].fteini
                  else
                     rg[j].ftefin:=rg[i].fteini-1;
                  if k=0 then begin
                     Application.MessageBox(pchar(dm.xlng('Error... ELSE sin IF')),
                                            pchar(dm.xlng('Diagrama de flujo ')), MB_OK );
                     break;
                  end;
                  setlength(kcnd,k-1);
                  k:=k-1;
                  j:=kcnd[k-1];
               end;
//               if (b_else) and (k>1) then begin
//                  j:=kcnd[k-1];
//                  rg[j].parfin:=i-1;
//                  rg[j].ftefin:=rg[i].fteini-1;
//                  setlength(kcnd,k-1);
//                  k:=k-1;
//               end;
//               j:=kcnd[k-1];
               rg[j].parfin:=i-1;
               if rg[j].fteini>rg[i].fteini-1 then
                  rg[j].ftefin:=rg[i].fteini
               else
                  rg[j].ftefin:=rg[i].fteini-1;
            end;
            kcnd[k-1]:=i;
            b_else:=true;
         end;
         if uppercase(rg[i].nombre)='END-IF' then begin
            if k=0 then begin
               Application.MessageBox(pchar(dm.xlng('Error... END-IF sin IF')),
                                      pchar(dm.xlng('Diagrama de flujo ')), MB_OK );
            end
            else begin
               j:=kcnd[k-1];
               rg[j].parfin:=i-1;
                  if rg[j].fteini>rg[i].fteini-1 then
                     rg[j].ftefin:=rg[i].fteini
                  else
                     rg[j].ftefin:=rg[i].fteini-1;
            end;
            setlength(kcnd,k-1);
            b_else:=false;
         end;
         if rg[i].nombre='DOT' then begin
            if k>0 then begin
               for m:=0 to k-1 do begin
                  j:=kcnd[m];
                  rg[j].parfin:=i;
                  rg[j].ftefin:=rg[i].fteini;
               end;
            end;
            setlength(kcnd,0);
            b_else:=false;
         end;
         if rg[i].nombre='EVALUATE' then begin
            k:=length(keval);
            setlength(keval,k+1);
            keval[k]:=i;
         end;
         if rg[i].nombre='WHEN' then begin
            k:=length(keval);
            if k=0 then begin
               Application.MessageBox(pchar(dm.xlng('Error... WHEN sin EVALUATE')),
                                      pchar(dm.xlng('Diagrama de flujo ')), MB_OK );
            end
            else begin
               j:=keval[k-1];
               rg[j].parfin:=i-1;
               rg[j].ftefin:=rg[i].fteini-1;
               keval[k-1]:=i;
            end;
            keval[k-1]:=i;
         end;
         if rg[i].nombre='END-EVALUATE' then begin
            k:=length(keval);
            if k=0 then begin
               Application.MessageBox(pchar(dm.xlng('Error... END-EVALUATE sin EVALUATE')),
                                      pchar(dm.xlng('Diagrama de flujo ')), MB_OK );
            end
            else begin
               j:=keval[k-1];
               rg[j].parfin:=i-1;
               rg[j].ftefin:=rg[i].fteini-1;
            end;
            setlength(keval,k-1);
         end;
         if rg[i].nombre='SEARCH' then begin
            k:=length(ksearch);
            setlength(ksearch,k+1);
            ksearch[k]:=i;
         end;
         if rg[i].nombre='SWHEN' then begin
            k:=length(ksearch);
            if k=0 then begin
               Application.MessageBox(pchar(dm.xlng('Error... WHEN sin SEARCH')),
                                      pchar(dm.xlng('Diagrama de flujo ')), MB_OK );
            end
            else begin
               j:=ksearch[k-1];
               rg[j].parfin:=i-1;
               rg[j].ftefin:=rg[i].fteini-1;
               ksearch[k-1]:=i;
            end;
            ksearch[k-1]:=i;
         end;
         if rg[i].nombre='AT-END' then begin
            k:=length(ksearch);
            if k=0 then begin
               Application.MessageBox(pchar(dm.xlng('Error... AT END sin SEARCH')),
                                      pchar(dm.xlng('Diagrama de flujo ')), MB_OK );
            end
            else begin
               j:=ksearch[k-1];
               rg[j].parfin:=i-1;
               rg[j].ftefin:=rg[i].fteini-1;
               ksearch[k-1]:=i;
            end;
            ksearch[k-1]:=i;
         end;
         if rg[i].nombre='END-SEARCH' then begin
            k:=length(ksearch);
            if k=0 then begin
               Application.MessageBox(pchar(dm.xlng('Error... END-EVALUATE sin EVALUATE')),
                                      pchar(dm.xlng('Diagrama de flujo ')), MB_OK );
            end
            else begin
               j:=ksearch[k-1];
               rg[j].parfin:=i-1;
               rg[j].ftefin:=rg[i].fteini-1;
            end;
            setlength(ksearch,k-1);
         end;
      end else
      if (rg[i].tipo='PVY') or (rg[i].tipo='DO') then begin
         k:=length(kperf);
         setlength(kperf,k+1);
         kperf[k]:=i;
      end else
      if (rg[i].tipo='EPE') or (rg[i].tipo='EDO') then begin
         k:=length(kperf);
         if k=0 then begin
            Application.MessageBox(pchar(dm.xlng('Error... END-PERFORM sin PERFORM')),
                                   pchar(dm.xlng('Diagrama de flujo ')), MB_OK );
         end
         else begin
            j:=kperf[k-1];
            rg[j].parfin:=i-1;
            rg[j].ftefin:=rg[i].fteini-1;
         end;
         setlength(kperf,k-1);
      end else
      if rg[i].tipo='FUN' then begin
         k:=length(kfun);
         setlength(kfun,k+1);
         kfun[k]:=i;
      end else
      if rg[i].tipo='EFU' then begin
         k:=length(kfun);
         if k=0 then begin
            Application.MessageBox(pchar(dm.xlng('Error... END-FUNCION sin FUNCION')),
                                   pchar(dm.xlng('Diagrama de flujo ')), MB_OK );
         end
         else begin
            j:=kfun[k-1];
            rg[j].parfin:=i-1;
            rg[j].ftefin:=strtoint(sep[1]);
         end;
         setlength(kfun,k-1);
      end else
      if rg[i].tipo='CIC' then begin
         kcics:=i;
      end else
      if rg[i].tipo='ECI' then begin
         if kcics=-1 then begin
            Application.MessageBox(pchar(dm.xlng('Error... END-EXEC sin EXEC CICS')),
                                   pchar(dm.xlng('Diagrama de flujo ')), MB_OK );
         end
         else begin
            rg[kcics].parfin:=i;
            rg[kcics].ftefin:=rg[i].fteini;
         end;
         kcics:=-1;
      end else
      if (rg[i].tipo='SQL') or
         (rg[i].tipo='SEL') or
         (rg[i].tipo='SIN') or
         (rg[i].tipo='SUP') or
         (rg[i].tipo='SDL') or
         (rg[i].tipo='SOP') or
         (rg[i].tipo='SFE') or
         (rg[i].tipo='SCL') then begin
         for j:=rg[i].fteini-1 downto 0 do begin
            if pos(' EXEC',uppercase(fte[j]))>0 then begin
               rg[i].fteini:=j+1;
               break;
            end;
         end;
         for j:=rg[i].fteini-1 to fte.Count-1 do begin
            if pos('END-EXEC',uppercase(fte[j]))>0 then begin
               rg[i].ftefin:=j+1;
               break;
            end;
         end;
      end;
   end;
   k:=length(ksec);
//   ksec[k]:=i;                 // Cierra Section anterior
   if k>0 then begin
      j:=ksec[k-1];
      rg[j].parfin:=i-1;
      rg[j].ftefin:=rg[i-1].ftefin;
   end;
   k:=length(klab);            // Cierra el fin de etiqueta anterior
   if k>0 then begin
      j:=klab[k-1];
      rg[j].parfin:=i-1;
      rg[j].ftefin:=rg[i-1].ftefin;
   end;

   sg.RowCount:=par.Count;
   sg.ColCount:=8;
   for i:=0 to par.Count-1 do begin
      sg.Cells[0,i]:=rg[i].tipo;
      sg.Cells[1,i]:=rg[i].seccion;
      sg.Cells[2,i]:=rg[i].etiqueta;
      sg.Cells[3,i]:=inttostr(rg[i].fteini);
      sg.Cells[4,i]:=inttostr(rg[i].ftefin);
      sg.Cells[5,i]:=inttostr(rg[i].parini);
      sg.Cells[6,i]:=inttostr(rg[i].parfin);
      sg.Cells[7,i]:=rg[i].nombre;
   end;
   crea(0,0,0,q);
end;
procedure Tfmgflrpg.desplaza(y,z:integer);
var i:integer;
begin
   if z=0 then exit;
   for i:=0 to componentcount-1 do begin
      if components[i] is Tfrclp then begin
         q:=(components[i] as Tfrclp);
         if (q.Visible) and (q.Top>y) then begin
            q.Top:=q.Top+z;
         end;
      end;
   end;
end;

procedure Tfmgflrpg.Crea(n,x,y:integer;var q:Tfrclp);
var i:integer;
begin
   if rg[n].tipo='PER' then begin
      for i:=0 to length(rg)-1 do begin
         if (rg[i].tipo='SEC') and (rg[i].seccion=rg[n].nombre) then begin
            n:=i;
            break;
         end;
         if (rg[i].tipo='LAB') and (rg[i].etiqueta=rg[n].nombre) then begin
            n:=i;
            break;
         end;
      end;
   end;
   if rg[n].tipo='PTH' then begin
      for i:=0 to length(rg)-1 do begin
         if (rg[i].tipo='SEC') and (rg[i].seccion=rg[n].nombre) then begin
            rg[n].parini:=rg[i].parini-1;
            rg[n].fteini:=rg[i].fteini;
         end;
         if (rg[i].tipo='LAB') and (rg[i].etiqueta=rg[n].nombre) then begin
            rg[n].parini:=rg[i].parini-1;
            rg[n].fteini:=rg[i].fteini;
         end;
         if (rg[i].tipo='SEC') and (rg[i].seccion=rg[n].nombrethru) then begin
            rg[n].parfin:=rg[i].parfin;
            rg[n].ftefin:=rg[i].ftefin;
         end;
         if (rg[i].tipo='LAB') and (rg[i].etiqueta=rg[n].nombrethru) then begin
            rg[n].parfin:=rg[i].parfin;
            rg[n].ftefin:=rg[i].ftefin;
         end;
      end;
   end;
   q:=Tfrclp.Create(self);
   q.Visible:=false;
   q.Parent:=self;
   q.Name:='q'+inttostr(nn);
   nn:=nn+1;
   q.Left:=x;
   q.Top:=y;
   q.xtipo(n,x,y);
   desplaza(q.Top-1,30);
   q.bot.Visible:=false;
   for i:=rg[n].parini+1 to rg[n].parfin do
      if (rg[i].nombre<>'DOT') then
         q.bot.Visible:=true;
   q.nodotext:=nodotext;
   q.Visible:=true;
//   invalidate;
end;
procedure Tfmgflrpg.pinta(canva:Tcanvas);
var i,j,k,sng,nx,ny:integer;
    flecha:integer;
    q:Tfrclp;
begin
   for i:=0 to componentcount-1 do begin
      if components[i] is Tfrclp then begin
         q:=(components[i] as Tfrclp);
         if q.texto<>nil then begin
            Canva.Pen.Width:=1;
            canva.MoveTo(q.left+q.Width,q.top);
            canva.LineTo(q.texto.Left,q.texto.Top+(q.texto.Height div 2));
         end;
         if (q.bot.Caption='+') or (q.Visible=false) then continue;
         Canva.Pen.Width:=2;
         Canva.pen.Color:=clblack;
         nx:=q.Left+q.Width;
         ny:=q.Top+(q.Height div 2);
         Canva.MoveTo(nx,ny);
         Canva.LineTo(nx+10,ny);
         j:=length(q.xx)-1;
         Canva.LineTo(nx+10,q.ultimotop);
      end;
   end;
end;

procedure Tfmgflrpg.FormPaint(Sender: TObject);
begin
   pinta(canvas);
end;

procedure Tfmgflrpg.FormDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
   accept:=source is trichedit;
   if source is Trichedit then
      (source as Trichedit).Visible:=false;
end;

procedure Tfmgflrpg.FormDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
   if source is trichedit then begin
      (source as Trichedit).Top:=y-25;
      (source as Trichedit).left:=x-60;
      (source as Trichedit).Visible:=true;
      invalidate;
   end;
end;

procedure Tfmgflrpg.FormDblClick(Sender: TObject);
begin
   if colordialog1.Execute then
      color:=colordialog1.Color;
end;

procedure Tfmgflrpg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   dm.PubEliminarVentanaActiva(Caption);  //para quitarlo de la lista de abiertos

   gral.borra_elemento(Caption,10);     //borrar elemento del arreglo de productos
   farbol.borra_elemento_a(Caption,10);     //borrar elemento del arreglo de productos

   if FormStyle = fsMDIChild then
      Action := caFree;
end;

procedure Tfmgflrpg.FormDestroy(Sender: TObject);
begin
    dm.PubEliminarVentanaActiva( Caption );
end;

procedure Tfmgflrpg.FormCreate(Sender: TObject);
begin
    mnuPrincipal.Style := gral.iPubEstiloActivo;
end;

end.
