unit ptsimpacto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Buttons, ExtCtrls, ADODB, ComCtrls;
type Tcomp=record
   clase:string;
   bib:string;
   compo:string;
end;
type
  Tftsimpacto = class(TForm)
    dg: TDrawGrid;
    Panel1: TPanel;
    Panel4: TPanel;
    bsalir: TSpeedButton;
    bimprimir: TBitBtn;
    Splitter1: TSplitter;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    dgt: TDrawGrid;
    procedure bsalirClick(Sender: TObject);
    procedure dgDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure dgtDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure dgSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
  private
    { Private declarations }
   x:array of Tcomp;
   z:array of Tcomp;
   xx: array of array of integer;
   zz: array of array of string;
   b_fin:boolean;
   max_rows:integer;
   bitmap:Tbitmap;
   procedure expande(compo:string; bib:string; clase:string; columna:integer);
  public
    { Public declarations }
//    compo,bib,clase:string;
    componente:string;
    procedure arma(compo:string; bib:string; clase:string);
  end;

//var
   procedure PR_IMPACTO(prog:string; bib:string; clase:string);

implementation
uses ptsdm;
{$R *.dfm}

procedure PR_IMPACTO(prog:string; bib:string; clase:string);
begin
{
   Application.CreateForm( Tftsimpacto, ftsimpacto );
   ftsimpacto.arma(prog,bib,clase);
   try
      ftsimpacto.Show;
   finally
//      ftsimpacto.Free;
   end;
}
end;

procedure Tftsimpacto.expande(compo:string; bib:string; clase:string; columna:integer);
var qq:TADOQuery;
   i,k,m,y,rr:integer;
   b_repetido:boolean;
   b_segundos:boolean;
begin
   qq:=Tadoquery.Create(self);
   qq.Connection:=dm.ADOConnection1;
   if dm.sqlselect(qq,'select distinct pcprog,pcbib,pcclase from tsrela '+
      ' where hcprog='+g_q+compo+g_q+
      ' and   hcbib='+g_q+bib+g_q+
      ' and   hcclase='+g_q+clase+g_q+
      ' and   pcclase<>'+g_q+'CLA'+g_q+
      ' order by pcclase,pcbib,pcprog')  then begin
      // Agrega columnas si rebasa las existentes
      if columna>dg.ColCount-1 then begin
         k:=dg.ColCount;
         dg.ColCount:=k+1;
         setlength(xx,k+1);
         setlength(xx[k],dg.rowCount);
      end;
      b_segundos:=false;
      while not qq.Eof do begin
         m:=length(x);
         setlength(x,m+1);
         x[m].compo:=qq.fieldbyname('pcprog').AsString;
         x[m].bib:=qq.fieldbyname('pcbib').AsString;
         x[m].clase:=qq.fieldbyname('pcclase').AsString;
         xx[columna][dg.rowCount-1]:=m;
         if b_segundos then begin
            i:=dg.RowCount-2;
            while (i>-1) and (xx[columna][i]=0) do begin
               xx[columna][i]:=-1;
               i:=i-1;
            end;
         end;
         b_segundos:=true;
         // checa repetidos para que no se cicle
         b_repetido:=false;
         y:=dg.rowCount-1;
         for i:=columna-2 downto 0 do begin
            while xx[i][y]=0 do y:=y-1;
            rr:=xx[i][y];
            if (x[rr].compo=qq.fieldbyname('pcprog').AsString) and
               (x[rr].bib=qq.fieldbyname('pcbib').AsString) and
               (x[rr].clase=qq.fieldbyname('pcclase').AsString) then begin
               b_repetido:=true;
               break;
            end;
         end;
         if b_repetido=false then
            expande(x[m].compo, x[m].bib, x[m].clase,columna+1);
         if b_fin then exit;
         qq.Next;
         if not qq.Eof then begin
            y:=dg.RowCount;
            if dg.RowCount>max_rows then begin
               if application.MessageBox(pchar('Rebasó de '+inttostr(max_rows)+' renglones, desea continuar?'),
                  'Confirmar',MB_YESNO)=IDYES then
                  max_rows:=max_rows+1000
               else begin
                  showmessage('Proceso interrumpido, rebasa de '+inttostr(max_rows)+' renglones');
                  b_fin:=true;
                  exit;
               end;
            end;
            dg.RowCount:=y+1;
            for i:=0 to length(xx)-1 do
               setlength(xx[i],y+1);
         end;
      end;
   end;
   qq.Free;
end;
procedure Tftsimpacto.arma(compo:string; bib:string; clase:string);
var i,j,k,m:integer;
   b_append:boolean;
   cla:string;
begin
   screen.Cursor:=crSQLWait;
   caption:=caption+' '+clase+' '+bib+' '+compo;
   setlength(xx,1);
   setlength(xx[0],1);
   xx[0][0]:=1;
   setlength(x,2);
   x[1].compo:=compo;
   x[1].bib:=bib;
   x[1].clase:=clase;
   max_rows:=1000;
   expande(compo,bib,clase,1);
   for i:=1 to length(x)-1 do begin // Arma resumen
      b_append:=true;
      for j:=0 to length(z)-1 do begin
         if (x[i].clase=z[j].clase) and
            (x[i].bib=z[j].bib) and
            (x[i].compo=z[j].compo) then begin
            b_append:=false;
            break;
         end;
         if x[i].clase+' '+x[i].bib+' '+x[i].compo<
            z[j].clase+' '+z[j].bib+' '+z[j].compo then begin
            setlength(z,length(z)+1);
            for k:=length(z)-1 downto j+1 do
               z[k]:=z[k-1];
            z[j]:=x[i];
            b_append:=false;
            break;
         end;
      end;
      if b_append then begin
         setlength(z,length(z)+1);
         z[length(z)-1]:=x[i];
      end;
   end;
   dgt.RowCount:=2;
   dgt.ColCount:=1;
   setlength(zz,0);
   j:=0;
   k:=0;
   for i:=0 to length(z)-1 do begin
      if z[i].clase<>cla then begin
         cla:=z[i].clase;
         k:=length(zz);
         if k>0 then
            zz[k-1][1]:=inttostr(j);
         setlength(zz,k+1);
         setlength(zz[k],2);
         zz[k][0]:=z[i].clase;
         j:=0;
         dgt.ColCount:=length(zz);
      end;
      m:=length(zz[k]);
      setlength(zz[k],m+1);
      zz[k][m]:=z[i].clase+' '+z[i].bib+' '+z[i].compo;
      if length(zz[k])>dgt.rowcount then
         dgt.RowCount:=length(zz[k]);
      inc(j);
   end;
   if k>0 then
      zz[k][1]:=inttostr(j);
   screen.Cursor:=crDefault;
end;
procedure Tftsimpacto.bsalirClick(Sender: TObject);
begin
   close;
end;

procedure Tftsimpacto.dgDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var k,ancho:integer;
   texto:string;
begin
   if xx[acol][arow]=0 then exit;
   if xx[acol][arow]=-1 then begin
      dg.Canvas.Brush.Color:=clyellow;
      bitmap.Canvas.FillRect(bitmap.Canvas.ClipRect);
      dg.Canvas.Draw(rect.left,rect.top,bitmap);
      exit;
   end;
   if length(xx)>1 then
      if xx[1][arow]>0 then
         dg.Canvas.brush.color :=$00E7D3D7
      else
         dg.Canvas.Brush.Color:=clwindow;
   k:=xx[acol][arow];
   texto:=x[k].clase+' '+x[k].bib+' '+x[k].compo;
   ancho:=dg.Canvas.TextWidth(texto);
   if dg.ColWidths[acol]< ancho+19 then
      dg.ColWidths[acol]:=ancho+19;
   bitmap.Canvas.FillRect(bitmap.Canvas.ClipRect);
   dm.imgclases.GetBitmap( dm.lclases.IndexOf(x[k].clase), bitmap );
   dg.Canvas.TextRect(rect,rect.left+17, rect.Top,texto);
   dg.Canvas.Draw(rect.left,rect.top,bitmap);
end;

procedure Tftsimpacto.FormCreate(Sender: TObject);
begin
   if g_language='ENGLISH' then begin
      caption:='Impact Analysis';
      pagecontrol1.Pages[0].Caption:='SUMMARY';
      bimprimir.Caption:='Print';
      bsalir.Hint:='Exit';
   end;
   setlength(xx,1);
   setlength(xx[0],1);
   bitmap:=Tbitmap.Create;
end;

procedure Tftsimpacto.dgtDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var  texto:string;
      ancho:integer;
begin
   if acol<0 then exit;
   if acol>length(zz)-1 then exit;
   if arow>length(zz[acol])-1 then exit;
   bitmap.Canvas.FillRect(bitmap.Canvas.ClipRect);
   if arow=0 then begin
      texto:=zz[acol][0];
      if dm.sqlselect(dm.q1,'select * from tsclase '+
         ' where cclase='+g_q+texto+g_q) then
         texto:=dm.q1.fieldbyname('descripcion').AsString;
      dm.imgclases.GetBitmap( dm.lclases.IndexOf(zz[acol][0]), bitmap );
      dgt.Canvas.TextRect(rect,rect.left+17, rect.Top,texto);
      dgt.Canvas.Draw(rect.left,rect.top,bitmap);
      exit;
   end;
   texto:=zz[acol][arow];
   ancho:=dgt.Canvas.TextWidth(texto);
   if dgt.ColWidths[acol]< ancho then
      dgt.ColWidths[acol]:=ancho;
   dgt.Canvas.TextRect(rect,rect.left, rect.Top,zz[acol][arow]);
end;

procedure Tftsimpacto.dgSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var k,col,ren:integer;
begin
   if acol>=length(xx) then componente:=''
   else
   if arow>=length(xx[acol]) then componente:=''
   else
   if xx[acol][arow]<1 then componente:=''
   else begin
      k:=xx[acol][arow];
      componente:=x[k].clase+' '+x[k].bib+' '+x[k].compo;
   end;
   dg.BeginDrag(true);
end;

end.
