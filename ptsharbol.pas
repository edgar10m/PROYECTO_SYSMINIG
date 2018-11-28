unit ptsharbol;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, OleCtrls, SHDocVw;
type
   TMyRec = record
      abierto:boolean;
      nivel:integer;
      titulo:string;
      pnombre: string;
      pbiblioteca: string;
      pclase: string;
      hnombre: string;
      hbiblioteca: string;
      hclase: string;
      hijo_falso:boolean;
   end;

type
  TForm1 = class(TForm)
    WebBrowser1: TWebBrowser;
    PopupMenu1: TPopupMenu;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    reg:array of TMyRec;
    clase_analizable:Tstringlist;
    clase_fisico:Tstringlist;
    clase_descripcion:Tstringlist;
    sistema_datos:Tstringlist;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses ptsdm,ptsvmlx;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
   if g_language='ENGLISH' then begin
      caption:='Knowledge Base';
   end;
   {
   setlength(reg,2);
   reg[0].abierto:=false;
   reg[0].nivel:=0;
   reg[0].titulo:=g_empresa;
   reg[0].clase:='
   }
end;
{
procedure Tform1.alimenta_arreglos;
begin
   if g_language='ENGLISH' then begin
      caption:='Knowledge Base';
   end;
   clase_fisico:=tstringlist.Create;     // Arma arreglo de fisicos
   clase_descripcion:=tstringlist.Create;
   if dm.sqlselect(dm.q1,'select cclase,descripcion from tsclase '+
      ' where objeto='+g_q+'FISICO'+g_q+
      ' order by cclase') then begin
      while not dm.q1.Eof do begin
         clase_fisico.Add(dm.q1.fieldbyname('cclase').AsString);
         clase_descripcion.Add(dm.q1.fieldbyname('descripcion').AsString);
         dm.q1.Next;
      end;
   end;
   clase_analizable:=tstringlist.Create;     // Arma arreglo de analizables
   if dm.sqlselect(dm.q1,'select cclase,descripcion from tsclase '+
      ' where tipo='+g_q+'ANALIZABLE'+g_q+
      ' order by cclase') then begin
      while not dm.q1.Eof do begin
         clase_analizable.Add(dm.q1.fieldbyname('cclase').AsString);
         dm.q1.Next;
      end;
   end;
   sistema_datos:=Tstringlist.create;
   if dm.sqlselect(dm.q1,'select sistema,count(*) total from tsprog '+
      ' group by sistema order by sistema') then begin
      while not dm.q1.Eof do begin
         sistema_datos.Add(dm.q1.fieldbyname('sistema').AsString);
         dm.q1.Next;
      end;
   end;
   if dm.capacidad('Base Conocimiento - Arbol Principal') then begin
      if dm.sqlselect(dm.q1,'select * from tsoficina order by coficina') then begin // Oficinas
         tp:=tv.Items.AddFirst(nil,g_empresa);
         new(reg);
         reg.hnombre:=g_empresa;
         reg.hclase:='EMPRESA';
         reg.hijo_falso:=false;
         tp.Data:=reg;
         tp.ImageIndex:=dm.lclases.IndexOf(reg.hclase);
         tp.SelectedIndex:=0;
         while not dm.q1.Eof do begin
            tt:=tv.Items.AddChild(tp,dm.q1.fieldbyname('coficina').AsString+' - '+
               dm.q1.fieldbyname('descripcion').AsString);
            new(reg);
            reg.pnombre:=g_empresa;
            reg.pclase:='EMPRESA';
            reg.hnombre:=dm.q1.fieldbyname('coficina').AsString;
            reg.hclase:='OFICINA';
            reg.hijo_falso:=false;
            tt.Data:=reg;
            tt.ImageIndex:=dm.lclases.IndexOf(reg.hclase);
            tt.SelectedIndex:=0;
            if dm.sqlselect(dm.q2,'select * from tssistema '+           // Sistemas
               ' where coficina='+g_q+dm.q1.fieldbyname('coficina').AsString+g_q+
               ' and cdepende'+g_is_null+
               ' and estadoactual='+g_q+'ACTIVO'+g_q+
               ' order by csistema') then begin
               while not dm.q2.Eof do begin
                  ts:=tv.Items.AddChild(tt,dm.q2.fieldbyname('csistema').AsString+' - '+
                     dm.q2.fieldbyname('descripcion').AsString);
                  new(reg);
                  reg.pnombre:=dm.q2.fieldbyname('coficina').AsString;
                  reg.pclase:='OFICINA';
                  reg.hnombre:=dm.q2.fieldbyname('csistema').AsString;
                  reg.hclase:='SISTEMA';
                  reg.hijo_falso:=false;
                  ts.Data:=reg;
                  ts.ImageIndex:=dm.lclases.IndexOf(reg.hclase);
                  ts.SelectedIndex:=0;
                  subsistemas(ts,dm.q2.fieldbyname('coficina').AsString,dm.q2.fieldbyname('csistema').AsString);
                  nivel_clases(ts,dm.q2);
                  dm.q2.Next;
               end;
            end;
            dm.q1.Next;
         end;
      end;
   end;
end;
}
end.
