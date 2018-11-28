unit ptssearch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, ExtCtrls, strutils, shellapi,
  InvokeRegistry, Rio, SOAPHTTPClient;

type
  Tftssearch = class(TForm)
    Panel2: TPanel;
    Panel4: TPanel;
    bsalir: TSpeedButton;
    lvindice: TListView;
    texto: TMemo;
    lv: TListView;
    Panel1: TPanel;
    cmbsearch: TComboBox;
    bbuscar: TButton;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    htt: THTTPRIO;
    procedure bbuscarClick(Sender: TObject);
    procedure lvClick(Sender: TObject);
    procedure lvindiceClick(Sender: TObject);
    procedure bsalirClick(Sender: TObject);
    procedure textoDblClick(Sender: TObject);
  private
    { Private declarations }
   pand,por,pno,pp:Tstringlist;
   function encuentra(linea:string; var palabra:string):integer;
   function parsea(linea:string):string;
  public
    { Public declarations }
  end;

var
  ftssearch: Tftssearch;
  procedure PR_SEARCH;

implementation
uses ptsdm,isvsserver1;
{$R *.dfm}
procedure PR_SEARCH;
begin
   if dm.verifica_base('TSSEARCH')=false then begin
      showmessage('No hay datos en la tabla de busqueda');
      exit;
   end;

   Application.CreateForm( Tftssearch, ftssearch );
   ftssearch.pno:=Tstringlist.Create;
   ftssearch.pand:=Tstringlist.Create;
   ftssearch.por:=Tstringlist.Create;
   ftssearch.pp:=Tstringlist.Create;
   ftssearch.htt.WSDLLocation:=g_ruta+'IsvsServer.xml';
   ftssearch.Show;
end;
function Tftssearch.parsea(linea:string):string;
var i,j:integer;
   x,w:string;
   m:char;
begin
   x:=trim(stringreplace(linea,g_q,' ',[rfreplaceall]));
   i:=1;
   m:=' ';
   while i<=length(x) do begin
      if x[i]=' ' then begin
         m:=' ';
         inc(i);
         continue;
      end;
      if m=' ' then begin
         m:=x[i];
         inc(i);
         continue;
      end;
      if not (x[i] in ['A'..'Z','0'..'9']) then begin
         if x[i] in ['-','_','.'] then begin
            if m in ['+','-'] then begin
               w:=copy(x,1,i-1)+' '+m+copy(x,i+1,10000);
               x:=w;
               inc(i,2);
            end
            else begin
               w:=copy(x,1,i-1)+' '+copy(x,i+1,10000);
               x:=w;
               inc(i);
            end;
            continue;
         end;
         if m in ['+','-'] then begin
            w:=copy(x,1,i-1)+' '+m+x[i]+' '+m+copy(x,i+1,10000);
            x:=w;
            inc(i,5);
         end
         else begin
            w:=copy(x,1,i-1)+' '+copy(x,i,1)+' '+copy(x,i+1,10000);
            x:=w;
            inc(i,3);
         end;
         continue;
      end;
      inc(i);
   end;
   if copy(x,1,2)='+ ' then
      delete(x,1,2);
   if copy(x,length(x)-1,2)=' +' then
      delete(x,length(x)-1,2);
   x:=stringreplace(x,' + ',' ',[rfreplaceall]);
   parsea:=x;
end;
procedure Tftssearch.bbuscarClick(Sender: TObject);
var sele,pal,lin:string;
   k:integer;
    it:Tlistitem;
begin
   por.Clear;
   pand.Clear;
   pno.Clear;
   pp.Clear;
   texto.Lines.Clear;
   lvindice.Items.Clear;
   cmbsearch.Items.Insert(0,cmbsearch.Text);
   cmbsearch.Text:=parsea(cmbsearch.text);
   lin:=cmbsearch.Text;
   if lin='' then exit;
   while lin<>'' do begin
      k:=pos(' ',lin);
      if k>0 then begin
         pal:=copy(lin,1,k-1);
         lin:=trim(copy(lin,k+1,1000));
      end
      else begin
         pal:=lin;
         lin:='';
      end;
      if length(pal)>1 then begin
         if pal[1]='+' then
            pand.Add(copy(pal,2,100))
         else
            if pal[1]='-' then
               pno.Add(copy(pal,2,100))
            else
               por.Add(pal);
      end
      else
         por.Add(pal);
   end;
   sele:='select cprog,cbib,cclase,sum(cuenta) suma from tssearch  where cword in (';
   pal:='';
   if pand.Count>0 then begin   // Si existe +PALABRA, toma prioridad y se igmoran los OR
      pp.AddStrings(pand);
      for k:=0 to pand.Count-1 do begin
         sele:=sele+pal+g_q+pand[k]+g_q;
         pal:=',';
      end;
      sele:=sele+') and (cprog,cbib,cclase) in (';
      pal:='';
      for k:=0 to pand.Count-1 do begin
         sele:=sele+pal+'select cprog,cbib,cclase from tssearch where cword='+g_q+pand[k]+g_q;
         pal:=' intersect ';
      end;
      sele:=sele+')';
   end
   else begin                   // palabras sin + ni -
      pp.AddStrings(por);
      for k:=0 to por.Count-1 do begin
         sele:=sele+pal+g_q+por[k]+g_q;
         pal:=',';
      end;
      sele:=sele+')';
   end;
   if pno.Count>0 then begin    // palabras con -
      sele:=sele+' and (cprog,cbib,cclase) not in (';
      sele:=sele+'select distinct cprog,cbib,cclase from tssearch ';
      pal:='where ';
      sele:=sele+pal+'cword in ';
      pal:='(';
      for k:=0 to pno.Count-1 do begin
         sele:=sele+pal+g_q+pno[k]+g_q;
         pal:=',';
      end;
      sele:=sele+'))';
   end;
   sele:=sele+' group by cprog,cbib,cclase ';
   lv.Items.Clear;
   if dm.sqlselect(dm.q1,sele) then begin
      while not dm.q1.Eof do begin
         it:=lv.Items.Add;
         it.Caption:=dm.q1.fieldbyname('cclase').AsString;
         it.SubItems.Add(dm.q1.fieldbyname('cbib').AsString);
         it.SubItems.Add(dm.q1.fieldbyname('cprog').AsString);
         it.SubItems.Add(dm.q1.fieldbyname('suma').AsString);
         dm.q1.Next;
      end;
   end;

end;

function Tftssearch.encuentra(linea:string; var palabra:string):integer;
var i,x,k:integer;
begin
   linea:=uppercase(linea);
   k:=10000;
   for i:=0 to pp.Count-1 do begin
      x:=pos(pp[i],linea);
      if (x>0) and (x<k) then begin
         k:=x;
         palabra:=pp[i];
      end;
   end;
   if k<>10000 then
      encuentra:=k
   else
      encuentra:=0;
end;
procedure Tftssearch.lvClick(Sender: TObject);
var ite,nitem:Tlistitem;
   i,k,m,car:integer;
   linea,palabra:string;
begin
   if lv.ItemIndex=-1 then exit;
   car:=0;
   ite:=lv.Items[lv.itemindex];
   if dm.capacidad('Acceso local') then begin
      if fileexists(dm.pathbib(ite.SubItems[0],ite.SubItems[2])+'\'+ite.SubItems[1]) then
         texto.Lines.LoadFromFile(dm.pathbib(ite.SubItems[0],ite.SubItems[2])+'\'+ite.SubItems[1]);
   end
   else begin
      texto.Lines.Text:=(htt as isvsserver).GetTxt('svsget,'+ite.SubItems[0]+','+ite.SubItems[1]+','+ite.SubItems[2]);
      if copy(texto.Lines.Text,1,7)='<ERROR>' then
         texto.Lines.Clear;
   end;
   lvindice.Items.Clear;
   for i:=0 to texto.Lines.Count-1 do begin
      m:=0;
      linea:=texto.Lines[i];
      k:=encuentra(linea,palabra);
      while k>0 do begin
         nitem:=lvindice.Items.Add;
         nitem.Caption:=inttostr(i+1);
         nitem.SubItems.Add(palabra);
         nitem.SubItems.Add(texto.Lines[i]);
         nitem.SubItems.Add(inttostr(car+m+k));
         linea:=copy(linea,k+1,500);
         m:=m+k;
         k:=encuentra(linea,palabra);
      end;
      car:=car+length(texto.Lines[i])+2;
   end;
end;

procedure Tftssearch.lvindiceClick(Sender: TObject);
var i,y:integer;
begin
   if lvindice.ItemIndex=-1 then exit;
   texto.SetFocus;
   texto.SelStart:=0;
   {
   y:=0;
   for i:=0 to lvindice.Itemindex do begin
      y:=posex(lvindice.Items[lvindice.ItemIndex].SubItems[0],texto.Lines.text,y+1);
   end;
   texto.SelStart:=y-1;
   }
   texto.SelStart:=strtoint(lvindice.Items[lvindice.ItemIndex].subitems[2])-1;
   texto.SelLength:=length(lvindice.Items[lvindice.ItemIndex].subitems[0]);
end;

procedure Tftssearch.bsalirClick(Sender: TObject);
begin
   close;
end;

procedure Tftssearch.textoDblClick(Sender: TObject);
var arch:string;
begin
   if trim(texto.Text)='' then exit;
   screen.Cursor:=crsqlwait;
   arch:=g_tmpdir+'\f'+formatdatetime('YYYYMMDDhhnnss',now)+'.txt';
   texto.Lines.SaveToFile(arch);
   ShellExecute( 0, 'open', pchar(arch),nil,PChar( g_tmpdir ), SW_SHOW );
   g_borrar.Add(arch);
   screen.Cursor:=crdefault;
end;

end.
