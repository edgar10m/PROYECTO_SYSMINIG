unit ptsmapanat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, strutils, dxBar;
type
   Tvars=record
      nivel:string;
      campo:string;
      pic:integer;
   end;
type
  Tftsmapanat = class(TForm)
    mnuPrincipal: TdxBarManager;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
   x:string;
    sy,sx:integer;
    nlabel:integer;
    vv:array of Tvars;


   lis:Tstringlist;
   i,k,px,py,m:integer;
   edi:Tedit;
   lab:Tlabel;
   b_screen,b_define_data:boolean;
   paso:string;

  public
    { Public declarations }
    titulo : string;
    function getw:string;
    procedure procesa;
    procedure arma(archivo:string);
  end;

implementation

uses ptsdm, ptsgral,parbol;

{$R *.dfm}
function Tftsmapanat.getw:string;
var j:integer;
   b_string:boolean;
   tempo:string;
begin
   b_string:=false;
   if copy(x,1,1)='''' then begin
      delete(x,1,1);
      j:=pos('''',x);
      b_string:=true;
   end
   else
      j:=pos(' ',x);
   if j>0 then begin
      tempo:=copy(x,1,j-1);
      x:=trim(copy(x,j+1,100));
   end
   else begin
      tempo:=x;
      x:='';
   end;
   if b_string then
      getw:=''''+tempo+''''
   else
      getw:=tempo;
end;
procedure Tftsmapanat.procesa;
var n:integer;
begin
            if copy(paso,1,1)='''' then begin      // String
               lab:=Tlabel.Create(self);
               lab.Parent:=self;
               inc(nlabel);
               lab.Name:='label_'+inttostr(nlabel);
               lab.Top:=py*sy;
               lab.Left:=px*sx;
               lab.Caption:=stringreplace(paso,'''','',[rfreplaceall]);
               paso:=getw;
               if (copy(paso,1,1)='(') and (copy(paso,2,1)>='0') and (copy(paso,2,1)<='9') then begin
                  m:=strtoint(copy(paso,2,length(paso)-2));
                  paso:=lab.Caption;
                  for n:=0 to m-2 do
                     lab.Caption:=lab.Caption+paso;
               end;
               lab.Font.Name:='Courier';
               lab.Font.Size:=10;
               lab.Visible:=true;
            end
            else begin                            // Variable
               edi:=Tedit.Create(self);
               edi.Parent:=self;
               inc(nlabel);
               edi.Name:=stringreplace(stringreplace(stringreplace(stringreplace(paso,
                  '-','_',[rfreplaceall]),
                  '.','_',[rfreplaceall]),
                  '#','_',[rfreplaceall]),
                  '*','x_',[rfreplaceall])+inttostr(nlabel);
               edi.Text:=paso;
               edi.ReadOnly:=true;
               edi.Hint:=edi.text;
               edi.ShowHint:=true;
               edi.Top:=py*sy;
               edi.Left:=px*sx;
               edi.Height:=sy;
               px:=px+length(paso);
               m:=1;
               for n:=0 to k-1 do begin
                  if vv[n].campo=edi.Text then begin
                     m:=vv[n].pic;
                     break;
                  end;
               end;
               paso:=getw;
               while paso<>'' do begin
                  if copy(paso,1,1)='(' then
                     delete(paso,1,1);
                  if copy(paso,1,3)='AL=' then begin
                     delete(paso,1,3);
                     m:=strtoint(paso);
                  end;
                  paso:=getw;
               end;
               edi.Width:=m*sx;
               if m=1 then
                  edi.width:=edi.Width+sx div 2;
               edi.Visible:=true;
            end;
end;
procedure Tftsmapanat.arma(archivo:string);
var i,nn:integer;
begin
   if fileexists(archivo)=false then exit;
   //caption:=uppercase(extractfilename(archivo));
   caption := titulo;
   lis:=Tstringlist.Create;
   lis.LoadFromFile(archivo);
   sy:=20;
   sx:=8;
   for i:=0 to lis.Count-1 do begin
      x:=trim(copy(lis[i],1,72));
      if b_define_data then begin
         if x='END-DEFINE' then begin
            b_define_data:=false;
            continue;
         end;
         setlength(vv,k+1);
         vv[k].nivel:=getw;
         vv[k].campo:=getw;
         paso:=getw;
         paso:=copy(paso,2,length(paso)-2);
         if copy(paso,1,1)='D' then begin
            m:=0;
            paso:='8';
         end
         else begin
            if copy(paso,1,1)='C' then begin
               m:=0;
               paso:='1';
            end
            else begin
               if copy(paso,1,1)='L' then begin
                  m:=0;
                  paso:='1';
               end
               else begin
                  if copy(paso,1,1)='N' then
                     m:=1
                  else
                     m:=0;
                  delete(paso,1,1);
                  nn:=pos('.',paso);
                  if nn>0 then
                     delete(paso,nn,100);
                  nn:=pos('/',paso);
                  if nn>0 then
                     delete(paso,nn,100);
               end;
            end;
         end;
         vv[k].pic:=strtoint(paso)+m;
         inc(k);
         continue;
      end;
      if b_screen then begin
         paso:=getw;
         if paso=')' then
            continue;
         if copy(paso,4,1)='T' then begin
            px:=strtoint(copy(paso,1,3))-1;
            paso:=getw;
            procesa;
         end
         else
         if rightstr(paso,1)='X' then begin
            delete(paso,length(paso),1);
            px:=px+strtoint(paso);
            paso:=getw;
            procesa;
         end;

         if paso='/' then
            inc(py);
         continue;
      end;
      if x='DEFINE DATA PARAMETER' then begin
         b_define_data:=true;
         k:=0;
         continue;
      end;
      paso:=getw;
      if paso='FORMAT' then begin
         paso:=getw;
         while paso<>'' do begin
            if copy(paso,1,3)='PS=' then
               height:=strtoint(copy(paso,4,10))*sy+(3*sy)
            else
            if copy(paso,1,3)='LS=' then
               width:=strtoint(copy(paso,4,10))*sx+(2*sx);
            paso:=getw;
            visible:=true;
            top:=100;
            left:=100;
         end;
         continue;
      end;
      if paso='INPUT' then begin
         b_screen:=true;
         py:=1;
         continue;
      end;
   end;
   lis.Free;
end;

procedure Tftsmapanat.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   dm.PubEliminarVentanaActiva(Caption);  //para quitarlo de la lista de abiertos

   {gral.borra_elemento(Caption,9);     //borrar elemento del arreglo de productos
   farbol.borra_elemento_a(Caption,9);     //borrar elemento del arreglo de productos
   }
   if FormStyle = fsMDIChild then
      Action := caFree;
end;

procedure Tftsmapanat.FormDestroy(Sender: TObject);
begin
    dm.PubEliminarVentanaActiva( Caption );

   if gral.iPubVentanasActivas in [ 0, 1 ] then  
      gral.PubExpandeMenuVentanas( False );
end;

procedure Tftsmapanat.FormCreate(Sender: TObject);
begin
    mnuPrincipal.Style := gral.iPubEstiloActivo;

  if gral.iPubVentanasActivas > 0 then  
      gral.PubExpandeMenuVentanas( True );
end;

end.
