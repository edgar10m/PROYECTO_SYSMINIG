unit ptsgrafsis;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ptsgrafico, ExtCtrls, StdCtrls, Menus;
type
   Tinter=record
      clase:string;
      bib:string;
      prog:string;
      sis:string;
   end;

type
  Tfgrafsis = class(Tfgrafico)
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    nsistemas:integer;     // numero de sistemas   procedure interfases;
    sistemas:Tstringlist;
    interfase:array of Tinter;
    procedure interfases;
    procedure acomoda_interfase;
  public
    { Public declarations }
  end;
const
   ancho_obj=150;
   alto_obj=40;

var
  fgrafsis: Tfgrafsis;
   procedure PR_GRAFSIS;

implementation
uses ptsdm,ptsgral;
{$R *.dfm}
procedure PR_GRAFSIS;
begin
   Application.CreateForm( Tfgrafsis, fgrafsis );
   try
      fgrafsis.Showmodal;
   finally
      fgrafsis.Free;
   end;
end;
procedure Tfgrafsis.acomoda_interfase;
var i,k:integer;
    titulo,nombre:string;
    obj:Tobj;
begin
   if length(interfase) >0 then begin
      titulo:=interfase[0].clase+' '+interfase[0].bib+' '+interfase[0].prog;
      nombre:=interfase[0].clase+'_'+interfase[0].bib+'_'+interfase[0].prog;
      obj:=crea_objeto(nombre,0,0,ancho_obj,alto_obj);
      obj.clase:=interfase[0].clase;
      obj.bib:=interfase[0].bib;
      obj.prog:=interfase[0].prog;
      i:=1;
      while i<length(interfase)-1 do begin
         if interfase[i].sis=interfase[0].sis then begin
            titulo:=titulo+chr(9)+interfase[i].clase+' '+interfase[i].bib+' '+interfase[i].prog;
            k:=length(obj.subclase);
            setlength(obj.subclase,k+1);
            setlength(obj.subbib,k+1);
            setlength(obj.subprog,k+1);
            obj.subclase[k]:=interfase[i].clase;
            obj.subbib[k]:=interfase[i].bib;
            obj.subprog[k]:=interfase[i].prog;
            for k:=i to length(interfase)-2 do
               interfase[k]:=interfase[k+1];
            setlength(interfase,length(interfase)-1);
         end
         else
            inc(i);
      end;
      obj.caption:=titulo;
      obj.color:=cllime;
      obj.ajusta_alto(canvas,true);
      for k:=1 to length(interfase[0].sis) do begin
         if interfase[0].sis[k]='1' then
            enlaza(sistemas[k-1],nombre,'>');
      end;
      ubica_enmedio(obj);
      //estructuras;
      acomoda(obj);
      for k:=0 to length(interfase)-2 do
         interfase[k]:=interfase[k+1];
      setlength(interfase,length(interfase)-1);
   end;
end;
procedure Tfgrafsis.interfases;
var i,k:integer;
   titulo:string;
   nombre:string;
   obj:Tobj;
begin
   if dm.sqlselect(dm.q1,'select hcclase ,hcbib  ,hcprog,count(*) '+
      ' from '+
      '   (select distinct hcclase ,hcbib  ,hcprog ,sistema from tsrela '+
      '      order by 1,2,3,4)'+
      ' group by hcclase ,hcbib  ,hcprog '+
      ' having count(*)>1 '+
      ' order by count(*) , hcclase ,hcbib  ,hcprog') then begin
      setlength(interfase,dm.q1.RecordCount);
      k:=0;
      while not dm.q1.Eof do begin
         interfase[k].clase:=dm.q1.fieldbyname('hcclase').AsString;
         interfase[k].bib:=dm.q1.fieldbyname('hcbib').AsString;
         interfase[k].prog:=dm.q1.fieldbyname('hcprog').AsString;
         interfase[k].sis:='';
         for i:=0 to nsistemas-1 do interfase[k].sis:=interfase[k].sis+'0';
         if dm.sqlselect(dm.q2,'select distinct sistema from tsrela '+
            ' where hcprog='+g_q+dm.q1.fieldbyname('hcprog').AsString+g_q+
            ' and hcbib='+g_q+dm.q1.fieldbyname('hcbib').AsString+g_q+
            ' and hcclase='+g_q+dm.q1.fieldbyname('hcclase').AsString+g_q+
            ' order by sistema') then begin
            while not dm.q2.Eof do begin
               i:=sistemas.IndexOf(dm.q2.fieldbyname('sistema').AsString);
               interfase[k].sis[i+1]:='1';
               dm.q2.Next;
            end;
         end;
         inc(k);
         dm.q1.Next;
      end;
   end;
      estructuras;
   while length(interfase)>0 do
      acomoda_interfase;
end;

procedure Tfgrafsis.FormCreate(Sender: TObject);
var
   n:integer;              // contador de sistema
   x,y:integer;            // posiciones para el siguiente sistema
   maxx:integer;           // guarda ancho máximo
   obj:Tobj;
begin
   inherited;
   sistemas:=Tstringlist.create;
   mapa:=Tmapa.create(500,500);
   margenobjx:=40;
   margenobjy:=40;
   if dm.sqlselect(dm.q1,'select distinct csistema from tssistema '+
      ' where estadoactual='+g_q+'ACTIVO'+g_q+
      ' order by csistema')=false then begin
      application.MessageBox('No tiene sistemas activos','Aviso',MB_OK);
      close;
   end;
   nsistemas:=dm.q1.RecordCount;
   maxx:=width-100;
   n:=0;
   while not dm.q1.Eof do begin
      sistemas.Add(dm.q1.fieldbyname('csistema').AsString);
      inc(n);
      if n=1 then begin
         x:=(width div 2)-(ancho_obj div 2);
         y:=150;
      end
      else begin
         if n mod 2 = 0 then begin
            if n=nsistemas then
               x:=(width div 2)-(ancho_obj div 2)
            else begin
               x:=(width div 4)-(ancho_obj div 2);
               if x>maxx then
                  maxx:=x;
            end;
            y:=(n div 2) *250 +350;
         end
         else begin
            x:=(width div 4) * 3-(ancho_obj div 2);
            y:=(n div 2) *250 +350;
            maxx:=x;
         end;
      end;
      obj:=crea_objeto(dm.q1.fieldbyname('csistema').AsString,x,y,ancho_obj,alto_obj*5);
      obj.caption:=dm.q1.fieldbyname('csistema').AsString;
      obj.clase:='SISTEMA';
      obj.bib:='SYSTEM';
      obj.prog:=dm.q1.fieldbyname('csistema').AsString;
      dm.q1.Next;
   end;
   interfases;
end;

procedure Tfgrafsis.FormPaint(Sender: TObject);
begin
  inherited;
   dibuja_enlaces(canvas,horzscrollbar.position,vertscrollbar.Position);
   mapa.dibuja(canvas,horzscrollbar.Position,vertscrollbar.Position,width,height);
end;

procedure Tfgrafsis.Button1Click(Sender: TObject);
begin
  inherited;
   acomoda_interfase;
end;

procedure Tfgrafsis.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var bgral:string;
   opciones:Tstringlist;
   ancho_menu:integer;
begin
  inherited;
   if mouseobj=nil then exit;
   if button=mbright then begin
      bgral:=mouseobj.prog+ '|' + mouseobj.bib + '|' + mouseobj.clase + '|' + 'SISTEMAX';
      Opciones := gral.ArmarMenuConceptualWeb( bgral, 'diagrama_sistemas_interfaces' );
      gral.EjecutaOpcionB( opciones, 'Diagrama Sistemas Interfaces' );
      gral.PopGral.Popup( X+left+horzscrollbar.Position, Y+top+vertscrollbar.Position+65 );
   end;
end;

end.
