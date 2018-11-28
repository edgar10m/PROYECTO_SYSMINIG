unit ptscomarea;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls, ADODB, DB, DBGrids, Menus;
type
   Tlinea = record
      origenx:integer;
      origeny:integer;
      destino_indice:integer;
      destinox:integer;
      destinoy:integer;
      ancho:integer;
      color:integer;
      tipo_flecha:string;
   end;
   Tvv = record
      clase:string;
      bib:string;
      prog:string;
      left:integer;
      top:integer;
      ancho:integer;
      alto:integer;
      texto_left:integer;
      texto_top:integer;
      color:integer;
      texto:string;
      font_size:integer;
      lineas:array of Tlinea;
   end;
   Trepe = record
      clase:string;
      bib:string;
      prog:string;
   end;
type
  Tftscomarea = class(TForm)
    Panel1: TPanel;
    dg: TDrawGrid;
    dbg: TDBGrid;
    DataSource1: TDataSource;
    ADO1: TADOQuery;
    Panel2: TPanel;
    lst: TListBox;
    Label1: TLabel;
    lnk: TListBox;
    cmbbib: TComboBox;
    bunico: TButton;
    pop: TPopupMenu;
    Rastrea1: TMenuItem;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    dd: TDrawGrid;
    bmapa: TButton;
    bexporta: TButton;
    SaveDialog1: TSaveDialog;
    chkqueue: TCheckBox;
    chk300: TCheckBox;
    chksolo: TCheckBox;
    chkcampo: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure cmbbibChange(Sender: TObject);
    procedure bunicoClick(Sender: TObject);
    procedure lstClick(Sender: TObject);
    procedure dgDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure dbgCellClick(Column: TColumn);
    procedure dgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure dgSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Rastrea1Click(Sender: TObject);
    procedure bmapaClick(Sender: TObject);
    procedure ddDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure bexportaClick(Sender: TObject);
    procedure lnkClick(Sender: TObject);
    procedure chksoloClick(Sender: TObject);
    procedure chkcampoClick(Sender: TObject);
  private
    { Private declarations }
    cc:array of Tstringlist;
    yx:array of array of string;
    zx,zy:integer;
    //________________________________________________________________________
    //  MAPA
    vv:array of Tvv;
    ww:array of Tlinea;
    bb:array of array of integer;
    maxx,maxy:integer;
    b_ado1_abierto:boolean;
    procedure variables(cprog,cbib,cclase,creg,ccampo,sentido,colorea:string);
    procedure alimenta_graficos;
    procedure inifin(paso:string; var aa:integer; var bb:integer);
    //----------------------- MAPA ---------------------------------------------
    procedure ajusta_vv(x,y,k:integer);
    procedure repetido_vv(x,y:integer;tipo,bib,prog:string;repe:array of Trepe);
    procedure campos_vv(x,y:integer;campo:string;color:integer;repe:array of Trepe);
    procedure variables_vv(x:integer;var y:integer;prog,bib,tipo,reg,campo:string;color:integer;repe:array of Trepe);
    procedure variables_vv_larga(x:integer;var y:integer;prog,bib,tipo,reg,campo:string;color:integer;repe:array of Trepe);
    procedure procesa_colas(x,y:integer;tipo,bib,prog,subp,comar:string;repe:array of Trepe);
    procedure colas_vv(x,y:integer;tipo,bib,prog,subp:string;repe:array of Trepe);
    procedure subprogramas(x,y:integer;tipo,bib,prog:string;repe:array of Trepe);
    procedure procesa_vv(x,y:integer;tipo,bib,prog:string;repe:array of Trepe);

  public
    { Public declarations }
  end;

var
  ftscomarea: Tftscomarea;
procedure PR_COMAREA;

implementation
uses ptsdm;
{$R *.dfm}
procedure PR_COMAREA;
begin
   Application.CreateForm( Tftscomarea, ftscomarea );
   try
      ftscomarea.Showmodal;
   finally
      ftscomarea.Free;
   end;
end;


procedure Tftscomarea.FormCreate(Sender: TObject);
begin
   dm.feed_combo(cmbbib,'select distinct cbib from tsprog where cclase='+g_q+'CBL'+g_q+' order by 1');
   setlength(yx,1);
   setlength(yx[0],1);
end;

procedure Tftscomarea.cmbbibChange(Sender: TObject);
begin
   if dm.sqlselect(dm.q1,'select cprog from tsprog '+
      ' where cbib='+g_q+cmbbib.Text+g_q+
      ' order by 1') then begin
      while not dm.q1.Eof do begin
         lst.Items.Add(dm.q1.fieldbyname('cprog').AsString);
         dm.q1.Next;
      end;
   end;
end;
procedure Tftscomarea.variables(cprog,cbib,cclase,creg,ccampo,sentido,colorea:string);
var qq:Tadoquery;
   i,k,primero,nivel,ini,fin:integer;
   color:string;
   b_afectado:boolean;
begin
   qq:=Tadoquery.Create(nil);
   qq.Connection:=dm.ADOConnection1;
   b_afectado:=false;
   if dm.sqlselect(qq,'select * from tsvarcbl '+
            ' where cprog='+g_q+cprog+g_q+
            ' and   cbib='+g_q+cbib+g_q+
            ' and   cclase='+g_q+cclase+g_q+
            ' and   creg='+g_q+creg+g_q+
 //           ' and   ccampo='+g_q+ccampo+g_q+
            ' order by linea') then begin
      k:=length(cc);
      setlength(cc,k+1);
      cc[k]:=Tstringlist.Create;
      if sentido='IZQ' then begin
         for i:=k downto 1 do begin
            cc[i].AddStrings(cc[i-1]);
            cc[i-1].Clear;
         end;
         k:=0;
      end;
      cc[k].Add('7.'+cprog);
      primero:=0;
      while not qq.Eof do begin
         color:=colorea;
         if (primero>0) and (qq.fieldbyname('nivel').AsInteger<=nivel) then
            break;
         if qq.fieldbyname('ccampo').AsString=ccampo then begin
            color:='S';
            primero:=qq.fieldbyname('inicial').AsInteger;
            nivel:=qq.fieldbyname('nivel').AsInteger;
         end;
         if primero>0 then begin
            ini:=qq.fieldbyname('inicial').AsInteger-primero+1;
            fin:=ini+qq.fieldbyname('longitud').AsInteger-1;
            if qq.fieldbyname('longitud').AsInteger=9 then begin            // AFECTADOS
               if dm.sqlselect(dm.q1,'select * from tsmaestra '+
                  ' where cprog='+g_q+qq.fieldbyname('cprog').AsString+g_q+
                  ' and   cbib='+g_q+qq.fieldbyname('cbib').AsString+g_q+
                  ' and   cclase='+g_q+qq.fieldbyname('cclase').AsString+g_q+
                  ' and   creg='+g_q+qq.fieldbyname('creg').AsString+g_q+
                  ' and   ccampo='+g_q+qq.fieldbyname('ccampo').AsString+g_q+
                  ' and   estado='+g_q+'AFECTADO'+g_q) then begin
                  color:='5';
                  b_afectado:=true;
               end;
            end;
            if chkcampo.Checked then begin
               if (color='5') or (color='S') then begin
                  cc[k].Add(color+'.['+inttostr(ini)+'-'+inttostr(fin)+'] '+
                     format('%02d',[qq.fieldbyname('nivel').AsInteger])+' '+
                     qq.fieldbyname('ccampo').AsString);
               end;
            end
            else begin
               cc[k].Add(color+'.['+inttostr(ini)+'-'+inttostr(fin)+'] '+
                  format('%02d',[qq.fieldbyname('nivel').AsInteger])+' '+
                  qq.fieldbyname('ccampo').AsString);
            end;
         end;
         qq.Next;
      end;
      if (chksolo.Checked) and (b_afectado=false) then begin
         for i:=k to length(cc)-2 do begin
            cc[i].Clear;
            cc[i].AddStrings(cc[i+1]);
         end;
         cc[length(cc)-1].free;
         setlength(cc,length(cc)-1);
      end;
   end;
   qq.free;
end;
procedure Tftscomarea.alimenta_graficos;
var i,j,k,maxy:integer;
begin
   k:=length(yx);
   for i:=0 to k-1 do begin
      setlength(yx[i],0);
   end;
   setlength(yx,0);
   setlength(yx,length(cc));
   maxy:=0;
   for i:=0 to length(cc)-1 do begin
      if maxy<cc[i].Count then
         maxy:=cc[i].Count;
   end;
   for i:=0 to length(cc)-1 do begin
      setlength(yx[i],maxy);
      for j:=0 to maxy-1 do begin
         if j<cc[i].Count then
            yx[i][j]:=cc[i][j]
         else
            yx[i][j]:='';
      end;
   end;
   dg.ColCount:=length(cc);
   dg.RowCount:=maxy;
//   for i:=0 to length(yx)-1 do
//      setlength(yx[i],maxy);
   if length(yx)=0 then begin
      dg.colcount:=1;
      setlength(yx,1);
   end;
   if maxy=0 then begin
      dg.RowCount:=1;
      setlength(yx[0],1);
   end;
   dg.repaint;
end;
{
procedure Tftscomarea.arma(campo1,tipo,campo2:string);
var cprog:string;
   i,k:integer;
begin
   for i:=0 to length(cc)-1 do
      cc[i].Free;
   setlength(cc,0);
   cprog:=lst.Items[lst.itemindex];
   if dm.sqlselect(dm.q1,'select * from tsrelavcbl '+
      ' where ocprog='+g_q+cprog+g_q+
      ' and   ocbib='+g_q+cmbbib.Text+g_q+
      ' and   occlase='+g_q+'CBL'+g_q+
      ' and   pcprog='+g_q+cprog+g_q+
      ' and   hcprog='+g_q+lnk.Items[lnk.itemindex]+g_q+
//      ' and   texto='+g_q+'LINK'+g_q+
      ' and   modo='+g_q+'MOVE'+g_q) then begin
      while not dm.q1.Eof do begin
         variables(dm.q1.fieldbyname('pcprog').AsString,
                   dm.q1.fieldbyname('pcbib').AsString,
                   dm.q1.fieldbyname('pcclase').AsString,
                   dm.q1.fieldbyname('pcreg').AsString,
                   dm.q1.fieldbyname('pccampo').AsString,
                   'IZQ');
         k:=length(cc);
         setlength(cc,k+1);
         cc[k]:=Tstringlist.Create;
         cc[k].add(dm.q1.fieldbyname('texto').AsString+' >>> '+dm.q1.fieldbyname('hcprog').AsString);
         variables(dm.q1.fieldbyname('hcprog').AsString,
                   dm.q1.fieldbyname('hcbib').AsString,
                   dm.q1.fieldbyname('hcclase').AsString,
                   dm.q1.fieldbyname('hcreg').AsString,
                   dm.q1.fieldbyname('hccampo').AsString,
                   'DER');
         dm.q1.Next;
      end;
   end;
   alimenta_graficos;
end;
}
procedure Tftscomarea.bunicoClick(Sender: TObject);
var quer:string;
begin
   if (lst.ItemIndex=-1) or (lnk.ItemIndex=-1) then exit;
   ado1.Close;
   ado1.SQL.Clear;
   {
   quer:=      'select distinct pccampo campo1,hccampo campo2,pcprog prog1,pcbib bib1,pcclase clase1,pcreg reg1,hcprog prog2,hcbib bib2,hcclase clase2,hcreg reg2 from tsrelavcbl '+
      ' where ocprog='+g_q+lst.Items[lst.itemindex]+g_q+
      ' and   ocbib='+g_q+cmbbib.Text+g_q+
      ' and   occlase='+g_q+'CBL'+g_q+
      ' and   pcprog='+g_q+lst.Items[lst.itemindex]+g_q+
      ' and   hcprog='+g_q+lnk.Items[lnk.itemindex]+g_q+
//      ' and   texto='+g_q+'LINK'+g_q+
      ' and   modo='+g_q+'MOVE'+g_q+
      ' union '+
      ' select distinct pccampo campo1,hccampo campo2,pcprog prog1,pcbib bib1,pcclase clase1,pcreg reg1,hcprog prog2,hcbib bib2,hcclase clase2,hcreg reg2 from tsrelavcbl '+
      ' where   ((pcprog='+g_q+lst.Items[lst.itemindex]+g_q+') or (hcprog='+g_q+lnk.Items[lnk.itemindex]+g_q+'))'+
      ' and    ((hcreg='+g_q+'_TSQUEUE_'+g_q+') or (hcreg='+g_q+'_TDQUEUE_'+g_q+'))'+
      ' union '+
      ' select distinct hccampo campo1,pccampo campo2,hcprog prog1,hcbib bib1,hcclase clase1,hcreg reg1,pcprog prog2,pcbib bib2,pcclase clase2,pcreg reg2 from tsrelavcbl '+
      ' where   ((hcprog='+g_q+lst.Items[lst.itemindex]+g_q+') or (pcprog='+g_q+lnk.Items[lnk.itemindex]+g_q+'))'+
      ' and    ((pcreg='+g_q+'_TSQUEUE_'+g_q+') or (pcreg='+g_q+'_TDQUEUE_'+g_q+'))'+
      ' order by 1,2';
   }
   quer:='select distinct hccampo COMMAREA from tsrelavcbl '+
      ' where ocprog='+g_q+lst.Items[lst.itemindex]+g_q+
      ' and   ocbib='+g_q+cmbbib.Text+g_q+
      ' and   occlase='+g_q+'CBL'+g_q+
      ' and   pcprog='+g_q+lst.Items[lst.itemindex]+g_q+
      ' and   hcprog='+g_q+lnk.Items[lnk.itemindex]+g_q+
      ' and   modo='+g_q+'MOVE'+g_q+
      ' union '+
//      ' (select distinct hccampo from tsrelavcbl '+
      ' select distinct hccampo from tsrelavcbl '+
      '    where ocprog='+g_q+lst.Items[lst.itemindex]+g_q+
      '    and   ocbib='+g_q+cmbbib.Text+g_q+
      '    and   occlase='+g_q+'CBL'+g_q+
      '    and    ((hcreg='+g_q+'_TSQUEUE_'+g_q+') or (hcreg='+g_q+'_TDQUEUE_'+g_q+'))'+
//      '  intersect '+
      '  union '+
      '  select distinct pccampo from tsrelavcbl '+
      '    where ocprog='+g_q+lst.Items[lst.itemindex]+g_q+
      '    and   ocbib='+g_q+cmbbib.Text+g_q+
      '    and   occlase='+g_q+'CBL'+g_q+
      '    and    ((pcreg='+g_q+'_TSQUEUE_'+g_q+') or (pcreg='+g_q+'_TDQUEUE_'+g_q+'))'+
      '  union '+
      '  select distinct hccampo from tsrelavcbl '+
      '    where ocprog='+g_q+lnk.Items[lnk.itemindex]+g_q+
      '    and   ocbib='+g_q+cmbbib.Text+g_q+
      '    and   occlase='+g_q+'CBL'+g_q+
      '    and    ((hcreg='+g_q+'_TSQUEUE_'+g_q+') or (hcreg='+g_q+'_TDQUEUE_'+g_q+'))'+
      '  union '+
      '  select distinct pccampo from tsrelavcbl '+
      '    where ocprog='+g_q+lnk.Items[lnk.itemindex]+g_q+
      '    and   ocbib='+g_q+cmbbib.Text+g_q+
      '    and   occlase='+g_q+'CBL'+g_q+
      '    and    ((pcreg='+g_q+'_TSQUEUE_'+g_q+') or (pcreg='+g_q+'_TDQUEUE_'+g_q+'))'+
      '  union '+
      '  select '+g_q+'300'+g_q+' from dual '+
      ' ';

   ado1.SQL.Add(quer);
   ado1.Open;
   b_ado1_abierto:=true;
   {
   dbg.Columns[0].Width:=150;
   dbg.Columns[1].Width:=150;
   dbg.Columns[2].Width:=150;
   }
end;

procedure Tftscomarea.lstClick(Sender: TObject);
begin
   if lst.ItemIndex=-1 then exit;
   if dm.sqlselect(dm.q1,'select * from tsrela '+
      ' where pcprog='+g_q+lst.Items[lst.itemindex]+g_q+
      ' and   pcbib='+g_q+cmbbib.Text+g_q+
      ' and   pcclase='+g_q+'CBL'+g_q+
      ' and   pcbib=hcbib '+
      ' and   hcclase='+g_q+'CBL'+g_q+
      ' order by hcbib,hcprog') then begin
      lnk.Items.Clear;
      while not dm.q1.Eof do begin
         lnk.Items.Add(dm.q1.fieldbyname('hcprog').AsString);
         dm.q1.next;
      end;
   end;
end;

procedure Tftscomarea.dgDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var texto:string;
begin
   if trim(yx[acol][arow])='' then exit;
   texto:=yx[acol][arow];
   if copy(texto,1,1)='1' then begin
      dg.Canvas.Brush.Color:=clskyblue;
      dg.Canvas.FillRect(rect);
   end;
   if copy(texto,1,1)='2' then begin
      dg.Canvas.Brush.Color:=clyellow;
      dg.Canvas.FillRect(rect);
   end;
   if copy(texto,1,1)='3' then begin
      dg.Canvas.Brush.Color:=clgreen;
      dg.Canvas.FillRect(rect);
   end;
   if copy(texto,1,1)='4' then begin
      dg.Canvas.Brush.Color:=clfuchsia;
      dg.Canvas.FillRect(rect);
   end;
   if copy(texto,1,1)='5' then begin
      dg.Canvas.Brush.Color:=clred;
      dg.Canvas.FillRect(rect);
   end;
   if copy(texto,1,1)='7' then begin
      dg.Canvas.Brush.Color:=clmoneygreen;
      dg.Canvas.FillRect(rect);
   end;
   if copy(texto,1,1)='A' then begin
      dg.Canvas.Brush.Color:=clblue;
      dg.Canvas.FillRect(rect);
   end;
   if copy(texto,1,1)='S' then begin
      dg.Canvas.Brush.Color:=clsilver;
      dg.Canvas.FillRect(rect);
   end;
   dg.Canvas.TextOut(rect.Left,rect.Top,copy(texto,1,100));

end;

procedure Tftscomarea.dbgCellClick(Column: TColumn);
var i,k:integer;
   comar,prog,bib,tipo:string;
begin
   if b_ado1_abierto=false then exit;
   for i:=0 to length(cc)-1 do
      cc[i].Free;
   setlength(cc,0);
   k:=length(cc);
   setlength(cc,k+1);
   cc[k]:=Tstringlist.Create;
   cc[k].add('3. >>> '+ado1.fieldbyname('COMMAREA').AsString);
   comar:=stringreplace(ado1.fieldbyname('COMMAREA').AsString,'''','''''',[rfreplaceall]);
   if comar='300' then begin
      prog:=lst.Items[lst.itemindex];
      bib:=cmbbib.Text;
      tipo:='CBL';
      if dm.sqlselect(dm.q1,'select * from tsvarcbl '+
                  ' where cprog='+g_q+prog+g_q+
                  ' and   cbib='+g_q+bib+g_q+
                  ' and   cclase='+g_q+tipo+g_q+
                  //' and   creg='+g_q+reg+g_q+
                  //' and   creg<>ccampo '+
                  ' and   longitud=300') then begin
         while not dm.q1.Eof do begin
               variables(dm.q1.fieldbyname('cprog').AsString,
                         dm.q1.fieldbyname('cbib').AsString,
                         dm.q1.fieldbyname('cclase').AsString,
                         dm.q1.fieldbyname('creg').AsString,
                         dm.q1.fieldbyname('ccampo').AsString,
                         'IZQ','1');
               dm.q1.Next;
         end;
      end;
      prog:=lnk.Items[lnk.itemindex];
      if dm.sqlselect(dm.q1,'select * from tsvarcbl '+
                  ' where cprog='+g_q+prog+g_q+
                  ' and   cbib='+g_q+bib+g_q+
                  ' and   cclase='+g_q+tipo+g_q+
                  //' and   creg='+g_q+reg+g_q+
                  //' and   creg<>ccampo '+
                  ' and   longitud=300') then begin
         while not dm.q1.Eof do begin
               variables(dm.q1.fieldbyname('cprog').AsString,
                         dm.q1.fieldbyname('cbib').AsString,
                         dm.q1.fieldbyname('cclase').AsString,
                         dm.q1.fieldbyname('creg').AsString,
                         dm.q1.fieldbyname('ccampo').AsString,
                         'DER','2');
               dm.q1.Next;
         end;
      end;
   end
   else
   if comar='DFHCOMMAREA' then begin
      if dm.sqlselect(dm.q1,'select distinct ocprog,ocbib,occlase,pcreg,pccampo from tsrelavcbl '+
         ' where ocprog='+g_q+lst.Items[lst.itemindex]+g_q+
         ' and   ocbib='+g_q+cmbbib.Text+g_q+
         ' and   occlase='+g_q+'CBL'+g_q+
         ' and   pcprog='+g_q+lst.Items[lst.itemindex]+g_q+
         ' and   hcprog='+g_q+lnk.Items[lnk.itemindex]+g_q+
//      ' and   texto='+g_q+'LINK'+g_q+
         ' and   modo='+g_q+'MOVE'+g_q+
         ' order by pcreg,pccampo') then begin
         while not dm.q1.Eof do begin
            variables(dm.q1.fieldbyname('ocprog').AsString,
                      dm.q1.fieldbyname('ocbib').AsString,
                      dm.q1.fieldbyname('occlase').AsString,
                      dm.q1.fieldbyname('pcreg').AsString,
                      dm.q1.fieldbyname('pccampo').AsString,
                      'IZQ','1');
            dm.q1.Next;
         end;
      end;
      if dm.sqlselect(dm.q1,'select distinct ocprog,ocbib,occlase,hcreg,hccampo from tsrelavcbl '+
         ' where ocprog='+g_q+lnk.Items[lnk.itemindex]+g_q+
         ' and   ocbib='+g_q+cmbbib.Text+g_q+
         ' and   occlase='+g_q+'CBL'+g_q+
         ' and   pccampo='+g_q+comar+g_q+
         ' and   modo='+g_q+'MOVE'+g_q+
         ' order by hcreg,hccampo') then begin
         while not dm.q1.Eof do begin
            variables(dm.q1.fieldbyname('ocprog').AsString,
                      dm.q1.fieldbyname('ocbib').AsString,
                      dm.q1.fieldbyname('occlase').AsString,
                      dm.q1.fieldbyname('hcreg').AsString,
                      dm.q1.fieldbyname('hccampo').AsString,
                     'DER','2');
            dm.q1.Next;
         end;
      end;
      if dm.sqlselect(dm.q1,'select distinct ocprog,ocbib,occlase,pcreg,pccampo from tsrelavcbl '+
         ' where ocprog='+g_q+lnk.Items[lnk.itemindex]+g_q+
         ' and   ocbib='+g_q+cmbbib.Text+g_q+
         ' and   occlase='+g_q+'CBL'+g_q+
         ' and   hccampo='+g_q+comar+g_q+
         ' and   modo='+g_q+'MOVE'+g_q+
         ' order by pcreg,pccampo') then begin
         while not dm.q1.Eof do begin
            variables(dm.q1.fieldbyname('ocprog').AsString,
                      dm.q1.fieldbyname('ocbib').AsString,
                      dm.q1.fieldbyname('occlase').AsString,
                      dm.q1.fieldbyname('pcreg').AsString,
                      dm.q1.fieldbyname('pccampo').AsString,
                     'DER','1');
            dm.q1.Next;
         end;
      end;
   end
   else begin
      if dm.sqlselect(dm.q1,'select distinct ocprog,ocbib,occlase,hcreg,hccampo from tsrelavcbl '+
         ' where ocprog='+g_q+lst.Items[lst.itemindex]+g_q+
         ' and   ocbib='+g_q+cmbbib.Text+g_q+
         ' and   occlase='+g_q+'CBL'+g_q+
         ' and   pcreg in ('+g_q+'_TSQUEUE_'+g_q+','+g_q+'_TDQUEUE_'+g_q+')'+
         ' and   pccampo='+g_q+comar+g_q+
         ' and   modo='+g_q+'MOVE'+g_q+
         ' order by hcreg,hccampo') then begin
         while not dm.q1.Eof do begin
            variables(dm.q1.fieldbyname('ocprog').AsString,
                      dm.q1.fieldbyname('ocbib').AsString,
                      dm.q1.fieldbyname('occlase').AsString,
                      dm.q1.fieldbyname('hcreg').AsString,
                      dm.q1.fieldbyname('hccampo').AsString,
                     'IZQ','2');
            dm.q1.Next;
         end;
      end;
      if dm.sqlselect(dm.q1,'select distinct ocprog,ocbib,occlase,pcreg,pccampo from tsrelavcbl '+
         ' where ocprog='+g_q+lst.Items[lst.itemindex]+g_q+
         ' and   ocbib='+g_q+cmbbib.Text+g_q+
         ' and   occlase='+g_q+'CBL'+g_q+
         ' and   hcreg in ('+g_q+'_TSQUEUE_'+g_q+','+g_q+'_TDQUEUE_'+g_q+')'+
         ' and   hccampo='+g_q+comar+g_q+
         ' and   modo='+g_q+'MOVE'+g_q+
         ' order by pcreg,pccampo') then begin
         while not dm.q1.Eof do begin
            variables(dm.q1.fieldbyname('ocprog').AsString,
                      dm.q1.fieldbyname('ocbib').AsString,
                      dm.q1.fieldbyname('occlase').AsString,
                      dm.q1.fieldbyname('pcreg').AsString,
                      dm.q1.fieldbyname('pccampo').AsString,
                     'IZQ','1');
            dm.q1.Next;
         end;
      end;
      if dm.sqlselect(dm.q1,'select distinct ocprog,ocbib,occlase,hcreg,hccampo from tsrelavcbl '+
         ' where ocprog='+g_q+lnk.Items[lnk.itemindex]+g_q+
         ' and   ocbib='+g_q+cmbbib.Text+g_q+
         ' and   occlase='+g_q+'CBL'+g_q+
         ' and   pcreg in ('+g_q+'_TSQUEUE_'+g_q+','+g_q+'_TDQUEUE_'+g_q+')'+
         ' and   pccampo='+g_q+comar+g_q+
         ' and   modo='+g_q+'MOVE'+g_q+
         ' order by hcreg,hccampo') then begin
         while not dm.q1.Eof do begin
            variables(dm.q1.fieldbyname('ocprog').AsString,
                      dm.q1.fieldbyname('ocbib').AsString,
                      dm.q1.fieldbyname('occlase').AsString,
                      dm.q1.fieldbyname('hcreg').AsString,
                      dm.q1.fieldbyname('hccampo').AsString,
                     'DER','2');
            dm.q1.Next;
         end;
      end;
      if dm.sqlselect(dm.q1,'select distinct ocprog,ocbib,occlase,pcreg,pccampo from tsrelavcbl '+
         ' where ocprog='+g_q+lnk.Items[lnk.itemindex]+g_q+
         ' and   ocbib='+g_q+cmbbib.Text+g_q+
         ' and   occlase='+g_q+'CBL'+g_q+
         ' and   hcreg in ('+g_q+'_TSQUEUE_'+g_q+','+g_q+'_TDQUEUE_'+g_q+')'+
         ' and   hccampo='+g_q+comar+g_q+
         ' and   modo='+g_q+'MOVE'+g_q+
         ' order by pcreg,pccampo') then begin
         while not dm.q1.Eof do begin
            variables(dm.q1.fieldbyname('ocprog').AsString,
                      dm.q1.fieldbyname('ocbib').AsString,
                      dm.q1.fieldbyname('occlase').AsString,
                      dm.q1.fieldbyname('pcreg').AsString,
                      dm.q1.fieldbyname('pccampo').AsString,
                     'DER','1');
            dm.q1.Next;
         end;
      end;
   end;
   alimenta_graficos;
end;

procedure Tftscomarea.dgMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   if trim(yx[zx][zy])<>'' then
      pop.Popup(x+ftscomarea.Left+dg.LeftCol,y+ftscomarea.Top+dg.top);
end;

procedure Tftscomarea.dgSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
   zx:=acol;
   zy:=arow;
end;
procedure Tftscomarea.inifin(paso:string; var aa:integer; var bb:integer);
begin
   if pos('[',paso)=0 then begin
      aa:=0;
      bb:=0;
      exit;
   end;
   paso:=copy(paso,4,pos(']',paso)-4);
   aa:=strtoint(copy(paso,1,pos('-',paso)-1));
   bb:=strtoint(copy(paso,pos('-',paso)+1,100));
end;
procedure Tftscomarea.Rastrea1Click(Sender: TObject);
var a1,a2,b1,b2,i,j:integer;
   paso:string;
begin
   //cc[zx][zy]:='5'+copy(cc[zx][zy],2,100);
   yx[zx][zy]:='5'+copy(yx[zx][zy],2,100);
   inifin(yx[zx][zy],a1,a2);
   for i:=0 to length(yx)-1 do begin
      for j:=0 to length(yx[i])-1 do begin
         if trim(yx[i][j])<>'' then begin
            inifin(yx[i][j],b1,b2);
            if (b1=a1) and (b2=a2) then begin
               cc[i][j]:='5'+copy(cc[i][j],2,100);
               yx[i][j]:='5'+copy(yx[i][j],2,100);
            end
            else
            if (b1>=a1) and (b1<=a2) then begin
               cc[i][j]:='4'+copy(cc[i][j],2,100);
               yx[i][j]:='4'+copy(yx[i][j],2,100);
            end
            else
            if (b2>=a1) and (b2<=a2) then begin
               cc[i][j]:='4'+copy(cc[i][j],2,100);
               yx[i][j]:='4'+copy(yx[i][j],2,100);
            end
            else
            if (b1>=a1) and (b2<=a2) then begin
               cc[i][j]:='4'+copy(cc[i][j],2,100);
               yx[i][j]:='4'+copy(yx[i][j],2,100);
            end;
         end
         else
            break;
      end;
   end;

   invalidate;
end;
//--------------------------- MAPA ---------------------------------------------
procedure Tftscomarea.ajusta_vv(x,y,k:integer);
var i:integer;
begin
{   if maxx<x+vv[k].ancho then begin
      maxx:=x+vv[k].ancho;
      dd.ColCount:=maxx+1;
   end;
   if maxy<y+vv[k].alto then begin
      maxy:=y+vv[k].alto;
      dd.RowCount:=maxy+1;
   end;
}
   if maxx<=x then begin
      maxx:=x;
      setlength(bb,maxx+10);
      for i:=0 to maxx+9 do
         setlength(bb[i],maxy+5);
      dd.ColCount:=maxx+5;
   end;
   if maxy<=y then begin
      maxy:=y;
      setlength(bb,maxx+10);
      for i:=0 to maxx+9 do
         setlength(bb[i],maxy+5);
      dd.RowCount:=maxy+5;
   end;
   bb[x][y]:=k+1;
   {
   bb[x+vv[k].ancho-1][y]:=k+1;
   bb[x][y+vv[k].alto-1]:=k+1;
   bb[x+vv[k].ancho-1][y+vv[k].alto-1]:=k+1;
   }
end;

procedure Tftscomarea.repetido_vv(x,y:integer;tipo,bib,prog:string;repe:array of Trepe);
var i,k,r:integer;
begin
   k:=length(vv);
   setlength(vv,k+1);
   vv[k].clase:=tipo;
   vv[k].bib:=bib;
   vv[k].prog:=prog;
   vv[k].left:=x;
   vv[k].top:=y;
   vv[k].ancho:=2;
   vv[k].alto:=1;
   vv[k].texto_left:=10;
   vv[k].texto_top:=0;
   vv[k].color:=cllime;
   vv[k].texto:=prog;
   vv[k].font_size:=6;
   ajusta_vv(x,y,k);
end;
procedure Tftscomarea.campos_vv(x,y:integer;campo:string;color:integer;repe:array of Trepe);
var k,ny:integer;
begin
   k:=length(vv);
   setlength(vv,k+1);
   //vv[k].clase:=tipo;
   //vv[k].bib:=bib;
   //vv[k].prog:=prog;
   vv[k].left:=x;
   vv[k].top:=y;
   vv[k].ancho:=2;
   vv[k].alto:=1;
   vv[k].texto_left:=10;
   vv[k].texto_top:=0;
   vv[k].color:=color;
   vv[k].texto:=campo;
   vv[k].font_size:=6;
   ajusta_vv(x,y,k);
end;
procedure Tftscomarea.variables_vv(x:integer;var y:integer;prog,bib,tipo,reg,campo:string;color:integer;repe:array of Trepe);
var k,primero,nivel,ini,fin:integer;
    qq:Tadoquery;
    b_alta:boolean;
   procedure alta;
   begin
      if b_alta then exit;
      k:=length(vv);
      setlength(vv,k+1);
      //vv[k].clase:=tipo;
      //vv[k].bib:=bib;
      //vv[k].prog:=prog;
      vv[k].left:=x;
      vv[k].top:=y;
      vv[k].ancho:=2;
      vv[k].alto:=1;
      vv[k].texto_left:=10;
      vv[k].texto_top:=0;
      vv[k].color:=color;
      vv[k].texto:=reg;
      vv[k].font_size:=6;
      ajusta_vv(x,y,k);
      b_alta:=true;
   end;
begin
   {
   if b_alta then begin    // Da de alta el registro sin importar la validación
      b_alta:=false;
      alta;
   end;
   }
   qq:=Tadoquery.Create(nil);
   qq.Connection:=dm.ADOConnection1;
   if dm.sqlselect(qq,'select * from tsmaestra '+
            ' where cprog='+g_q+prog+g_q+
            ' and   cbib='+g_q+bib+g_q+
            ' and   cclase='+g_q+tipo+g_q+
            ' and   creg='+g_q+reg+g_q) then begin
      alta;
      if dm.sqlselect(qq,'select * from tsvarcbl '+
               ' where cprog='+g_q+prog+g_q+
               ' and   cbib='+g_q+bib+g_q+
               ' and   cclase='+g_q+tipo+g_q+
               ' and   creg='+g_q+reg+g_q+
    //           ' and   ccampo='+g_q+ccampo+g_q+
               ' order by linea') then begin
         primero:=0;
         while not qq.Eof do begin
            if (primero>0) and (qq.fieldbyname('nivel').AsInteger<=nivel) then
               break;
            if qq.fieldbyname('ccampo').AsString=campo then begin
               primero:=qq.fieldbyname('inicial').AsInteger;
               nivel:=qq.fieldbyname('nivel').AsInteger;
            end;
            if primero>0 then begin
               ini:=qq.fieldbyname('inicial').AsInteger-primero+1;
               fin:=ini+qq.fieldbyname('longitud').AsInteger-1;
               if qq.fieldbyname('longitud').AsInteger=9 then begin            // AFECTADOS
                  if dm.sqlselect(dm.q1,'select * from tsmaestra '+
                     ' where cprog='+g_q+qq.fieldbyname('cprog').AsString+g_q+
                     ' and   cbib='+g_q+qq.fieldbyname('cbib').AsString+g_q+
                     ' and   cclase='+g_q+qq.fieldbyname('cclase').AsString+g_q+
                     ' and   creg='+g_q+qq.fieldbyname('creg').AsString+g_q+
                     ' and   ccampo='+g_q+qq.fieldbyname('ccampo').AsString+g_q+
                     ' and   estado='+g_q+'AFECTADO'+g_q) then begin
                     y:=y+1;
                     campos_vv(x,y,'['+inttostr(ini)+'-'+inttostr(fin)+'] '+
                        format('%02d',[qq.fieldbyname('nivel').AsInteger])+' '+
                        qq.fieldbyname('ccampo').AsString,clred,repe);
                  end;
               end;
            end;
            qq.Next;
         end;
      end;
   end;
   if b_alta=false then
      y:=y-1;
   qq.free;
end;
procedure Tftscomarea.variables_vv_larga(x:integer;var y:integer;prog,bib,tipo,reg,campo:string;color:integer;repe:array of Trepe);
var k,primero,nivel,ini,fin:integer;
    qq:Tadoquery;
begin
   qq:=Tadoquery.Create(nil);
   qq.Connection:=dm.ADOConnection1;
   k:=length(vv);
   setlength(vv,k+1);
   //vv[k].clase:=tipo;
   //vv[k].bib:=bib;
   //vv[k].prog:=prog;
   vv[k].left:=x;
   vv[k].top:=y;
   vv[k].ancho:=2;
   vv[k].alto:=1;
   vv[k].texto_left:=10;
   vv[k].texto_top:=0;
   vv[k].color:=color;
   vv[k].texto:=reg;
   vv[k].font_size:=6;
   ajusta_vv(x,y,k);
   if dm.sqlselect(qq,'select * from tsvarcbl '+
            ' where cprog='+g_q+prog+g_q+
            ' and   cbib='+g_q+bib+g_q+
            ' and   cclase='+g_q+tipo+g_q+
            ' and   creg='+g_q+reg+g_q+
 //           ' and   ccampo='+g_q+ccampo+g_q+
            ' order by linea') then begin
      primero:=0;
      while not qq.Eof do begin
         if (primero>0) and (qq.fieldbyname('nivel').AsInteger<=nivel) then
            break;
         if qq.fieldbyname('ccampo').AsString=campo then begin
            primero:=qq.fieldbyname('inicial').AsInteger;
            nivel:=qq.fieldbyname('nivel').AsInteger;
         end;
         if primero>0 then begin
            ini:=qq.fieldbyname('inicial').AsInteger-primero+1;
            fin:=ini+qq.fieldbyname('longitud').AsInteger-1;
            if qq.fieldbyname('longitud').AsInteger=9 then begin            // AFECTADOS
               if dm.sqlselect(dm.q1,'select * from tsmaestra '+
                  ' where cprog='+g_q+qq.fieldbyname('cprog').AsString+g_q+
                  ' and   cbib='+g_q+qq.fieldbyname('cbib').AsString+g_q+
                  ' and   cclase='+g_q+qq.fieldbyname('cclase').AsString+g_q+
                  ' and   creg='+g_q+qq.fieldbyname('creg').AsString+g_q+
                  ' and   ccampo='+g_q+qq.fieldbyname('ccampo').AsString+g_q+
                  ' and   estado='+g_q+'AFECTADO'+g_q) then begin
                  y:=y+1;
                  campos_vv(x,y,'['+inttostr(ini)+'-'+inttostr(fin)+'] '+
                     format('%02d',[qq.fieldbyname('nivel').AsInteger])+' '+
                     qq.fieldbyname('ccampo').AsString,clred,repe);
               end;
            end;
         end;
         qq.Next;
      end;
   end;
   qq.free;
end;
procedure Tftscomarea.procesa_colas(x,y:integer;tipo,bib,prog,subp,comar:string;repe:array of Trepe);
var k,yderecha,yizquierda:integer;
    qq:Tadoquery;
begin
   qq:=Tadoquery.Create(nil);
   qq.Connection:=dm.ADOConnection1;
   k:=length(vv);
   setlength(vv,k+1);
   vv[k].clase:=tipo;
   vv[k].bib:=bib;
   vv[k].prog:=prog;
   vv[k].left:=x;
   vv[k].top:=y;
   vv[k].ancho:=2;
   vv[k].alto:=1;
   vv[k].texto_left:=10;
   vv[k].texto_top:=0;
   vv[k].color:=clskyblue;
   vv[k].texto:=comar;
   vv[k].font_size:=6;
   ajusta_vv(x,y,k);
   yderecha:=y;
   yizquierda:=y;
   comar:=stringreplace(comar,'''','''''',[rfreplaceall]);
 if chkqueue.checked then begin
   if comar='DFHCOMMAREA' then begin
      if dm.sqlselect(qq,'select distinct ocprog,ocbib,occlase,pcreg,pccampo from tsrelavcbl '+
         ' where ocprog='+g_q+prog+g_q+
         ' and   ocbib='+g_q+bib+g_q+
         ' and   occlase='+g_q+tipo+g_q+
         ' and   pcprog='+g_q+prog+g_q+
         ' and   hcprog='+g_q+subp+g_q+
//      ' and   texto='+g_q+'LINK'+g_q+
         ' and   modo='+g_q+'MOVE'+g_q+
         ' order by pcreg,pccampo') then begin
         while not qq.Eof do begin
            variables_vv(x-1,yizquierda,qq.fieldbyname('ocprog').AsString,
                      qq.fieldbyname('ocbib').AsString,
                      qq.fieldbyname('occlase').AsString,
                      qq.fieldbyname('pcreg').AsString,
                      qq.fieldbyname('pccampo').AsString,clgray,repe);
            yizquierda:=yizquierda+1;
            qq.Next;
         end;
      end;
      if dm.sqlselect(qq,'select distinct ocprog,ocbib,occlase,hcreg,hccampo from tsrelavcbl '+
         ' where ocprog='+g_q+subp+g_q+
         ' and   ocbib='+g_q+bib+g_q+
         ' and   occlase='+g_q+tipo+g_q+
         ' and   pccampo='+g_q+comar+g_q+
         ' and   modo='+g_q+'MOVE'+g_q+
         ' order by hcreg,hccampo') then begin
         while not qq.Eof do begin
            variables_vv(x+1,yderecha,qq.fieldbyname('ocprog').AsString,
                      qq.fieldbyname('ocbib').AsString,
                      qq.fieldbyname('occlase').AsString,
                      qq.fieldbyname('hcreg').AsString,
                      qq.fieldbyname('hccampo').AsString,clyellow,repe);
            yderecha:=yderecha+1;
            qq.Next;
         end;
      end;
      if dm.sqlselect(qq,'select distinct ocprog,ocbib,occlase,pcreg,pccampo from tsrelavcbl '+
         ' where ocprog='+g_q+subp+g_q+
         ' and   ocbib='+g_q+bib+g_q+
         ' and   occlase='+g_q+tipo+g_q+
         ' and   hccampo='+g_q+comar+g_q+
         ' and   modo='+g_q+'MOVE'+g_q+
         ' order by pcreg,pccampo') then begin
         while not qq.Eof do begin
            variables_vv(x+1,yderecha,qq.fieldbyname('ocprog').AsString,
                      qq.fieldbyname('ocbib').AsString,
                      qq.fieldbyname('occlase').AsString,
                      qq.fieldbyname('pcreg').AsString,
                      qq.fieldbyname('pccampo').AsString,clgray,repe);
            yderecha:=yderecha+1;
            qq.Next;
         end;
      end;
   end
   else begin
      if dm.sqlselect(qq,'select distinct ocprog,ocbib,occlase,pcreg,pccampo from tsrelavcbl '+
         ' where ocprog='+g_q+prog+g_q+
         ' and   ocbib='+g_q+bib+g_q+
         ' and   occlase='+g_q+tipo+g_q+
         ' and   hcreg in ('+g_q+'_TSQUEUE_'+g_q+','+g_q+'_TDQUEUE_'+g_q+')'+
         ' and   hccampo='+g_q+comar+g_q+
         ' and   modo='+g_q+'MOVE'+g_q+
         ' order by pcreg,pccampo') then begin
         while not qq.Eof do begin
            variables_vv(x-1,yizquierda,qq.fieldbyname('ocprog').AsString,
                      qq.fieldbyname('ocbib').AsString,
                      qq.fieldbyname('occlase').AsString,
                      qq.fieldbyname('pcreg').AsString,
                      qq.fieldbyname('pccampo').AsString,clgray,repe);
            yizquierda:=yizquierda+1;
            qq.Next;
         end;
      end;
      if dm.sqlselect(qq,'select distinct ocprog,ocbib,occlase,hcreg,hccampo from tsrelavcbl '+
         ' where ocprog='+g_q+prog+g_q+
         ' and   ocbib='+g_q+bib+g_q+
         ' and   occlase='+g_q+tipo+g_q+
         ' and   pcreg in ('+g_q+'_TSQUEUE_'+g_q+','+g_q+'_TDQUEUE_'+g_q+')'+
         ' and   pccampo='+g_q+comar+g_q+
         ' and   modo='+g_q+'MOVE'+g_q+
         ' order by hcreg,hccampo') then begin
         while not qq.Eof do begin
            variables_vv(x-1,yizquierda,qq.fieldbyname('ocprog').AsString,
                      qq.fieldbyname('ocbib').AsString,
                      qq.fieldbyname('occlase').AsString,
                      qq.fieldbyname('hcreg').AsString,
                      qq.fieldbyname('hccampo').AsString,clyellow,repe);
            yizquierda:=yizquierda+1;
            qq.Next;
         end;
      end;
      if dm.sqlselect(qq,'select distinct ocprog,ocbib,occlase,hcreg,hccampo from tsrelavcbl '+
         ' where ocprog='+g_q+subp+g_q+
         ' and   ocbib='+g_q+bib+g_q+
         ' and   occlase='+g_q+tipo+g_q+
         ' and   pcreg in ('+g_q+'_TSQUEUE_'+g_q+','+g_q+'_TDQUEUE_'+g_q+')'+
         ' and   pccampo='+g_q+comar+g_q+
         ' and   modo='+g_q+'MOVE'+g_q+
         ' order by hcreg,hccampo') then begin
         while not qq.Eof do begin
            variables_vv(x+1,yderecha,qq.fieldbyname('ocprog').AsString,
                      qq.fieldbyname('ocbib').AsString,
                      qq.fieldbyname('occlase').AsString,
                      qq.fieldbyname('hcreg').AsString,
                      qq.fieldbyname('hccampo').AsString,clyellow,repe);
            yderecha:=yderecha+1;
            qq.Next;
         end;
      end;
      if dm.sqlselect(qq,'select distinct ocprog,ocbib,occlase,pcreg,pccampo from tsrelavcbl '+
         ' where ocprog='+g_q+subp+g_q+
         ' and   ocbib='+g_q+bib+g_q+
         ' and   occlase='+g_q+tipo+g_q+
         ' and   hcreg in ('+g_q+'_TSQUEUE_'+g_q+','+g_q+'_TDQUEUE_'+g_q+')'+
         ' and   hccampo='+g_q+comar+g_q+
         ' and   modo='+g_q+'MOVE'+g_q+
         ' order by pcreg,pccampo') then begin
         while not qq.Eof do begin
            variables_vv(x+1,yderecha,qq.fieldbyname('ocprog').AsString,
                      qq.fieldbyname('ocbib').AsString,
                      qq.fieldbyname('occlase').AsString,
                      qq.fieldbyname('pcreg').AsString,
                      qq.fieldbyname('pccampo').AsString,clgray,repe);
            yderecha:=yderecha+1;
            qq.Next;
         end;
      end;
   end;
 end;
 if chk300.checked then begin
   if dm.sqlselect(qq,'select * from tsvarcbl '+
               ' where cprog='+g_q+prog+g_q+
               ' and   cbib='+g_q+bib+g_q+
               ' and   cclase='+g_q+tipo+g_q+
               //' and   creg='+g_q+reg+g_q+
               //' and   creg<>ccampo '+
               ' and   longitud=300') then begin
      while not qq.Eof do begin
            variables_vv(x-1,yizquierda,qq.fieldbyname('cprog').AsString,
                      qq.fieldbyname('cbib').AsString,
                      qq.fieldbyname('cclase').AsString,
                      qq.fieldbyname('creg').AsString,
                      qq.fieldbyname('ccampo').AsString,clsilver,repe);
            yizquierda:=yizquierda+1;
            qq.Next;
      end;
   end;
   if dm.sqlselect(qq,'select * from tsvarcbl '+
               ' where cprog='+g_q+subp+g_q+
               ' and   cbib='+g_q+bib+g_q+
               ' and   cclase='+g_q+tipo+g_q+
               //' and   creg='+g_q+reg+g_q+
               //' and   creg<>ccampo '+
               ' and   longitud=300') then begin
      while not qq.Eof do begin
            variables_vv(x+1,yderecha,qq.fieldbyname('cprog').AsString,
                      qq.fieldbyname('cbib').AsString,
                      qq.fieldbyname('cclase').AsString,
                      qq.fieldbyname('creg').AsString,
                      qq.fieldbyname('ccampo').AsString,clsilver,repe);
            yderecha:=yderecha+1;
            qq.Next;
      end;
   end;
 end;
   qq.free;
end;

procedure Tftscomarea.colas_vv(x,y:integer;tipo,bib,prog,subp:string;repe:array of Trepe);
var i,k:integer;
    qq:Tadoquery;
    quer:string;
begin
   qq:=Tadoquery.Create(nil);
   qq.Connection:=dm.ADOConnection1;
   quer:='select distinct hccampo COMMAREA from tsrelavcbl '+
      ' where ocprog='+g_q+prog+g_q+
      ' and   ocbib='+g_q+bib+g_q+
      ' and   occlase='+g_q+tipo+g_q+
      ' and   pcprog='+g_q+prog+g_q+
      ' and   hcprog='+g_q+subp+g_q+
      ' and   modo='+g_q+'MOVE'+g_q+
      ' union '+
      ' select distinct hccampo from tsrelavcbl '+
      '    where ocprog='+g_q+prog+g_q+
      '    and   ocbib='+g_q+bib+g_q+
      '    and   occlase='+g_q+tipo+g_q+
      '    and    ((hcreg='+g_q+'_TSQUEUE_'+g_q+') or (hcreg='+g_q+'_TDQUEUE_'+g_q+'))'+
      '  union '+
      '  select distinct pccampo from tsrelavcbl '+
      '    where ocprog='+g_q+prog+g_q+
      '    and   ocbib='+g_q+bib+g_q+
      '    and   occlase='+g_q+tipo+g_q+
      '    and    ((pcreg='+g_q+'_TSQUEUE_'+g_q+') or (pcreg='+g_q+'_TDQUEUE_'+g_q+'))'+
      '  union '+
      '  select distinct hccampo from tsrelavcbl '+
      '    where ocprog='+g_q+subp+g_q+
      '    and   ocbib='+g_q+bib+g_q+
      '    and   occlase='+g_q+tipo+g_q+
      '    and    ((hcreg='+g_q+'_TSQUEUE_'+g_q+') or (hcreg='+g_q+'_TDQUEUE_'+g_q+'))'+
      '  union '+
      '  select distinct pccampo from tsrelavcbl '+
      '    where ocprog='+g_q+subp+g_q+
      '    and   ocbib='+g_q+bib+g_q+
      '    and   occlase='+g_q+tipo+g_q+
      '    and    ((pcreg='+g_q+'_TSQUEUE_'+g_q+') or (pcreg='+g_q+'_TDQUEUE_'+g_q+'))'+
      ' ';
   if dm.sqlselect(qq,quer) then begin
      if chk300.Checked then begin
         procesa_colas(x,y,tipo,bib,prog,subp,'300',repe);
         y:=maxy+1;
      end
      else begin
      while not qq.Eof do begin
         procesa_colas(x,y,tipo,bib,prog,subp,qq.fieldbyname('COMMAREA').AsString,repe);
         y:=maxy+1;
         qq.Next;
      end;
      end;
   end;
   qq.free;
end;

procedure Tftscomarea.subprogramas(x,y:integer;tipo,bib,prog:string;repe:array of Trepe);
var i,k:integer;
    qq:Tadoquery;
begin
   qq:=Tadoquery.Create(nil);
   qq.Connection:=dm.ADOConnection1;
   dd.ColWidths[x-3]:=120;
   dd.ColWidths[x-1]:=120;
   if dm.sqlselect(qq,'select * from tsrela '+
      ' where pcprog='+g_q+prog+g_q+
      ' and   pcbib='+g_q+bib+g_q+
      ' and   pcclase='+g_q+tipo+g_q+
      ' and   hcclase='+g_q+'CBL'+g_q+
      ' order by hcbib,hcprog') then begin
      while not qq.Eof do begin
         colas_vv(x-2,y,tipo,bib,prog,qq.fieldbyname('hcprog').AsString,repe);
         procesa_vv(x,y,tipo,bib,qq.fieldbyname('hcprog').AsString,repe);
         y:=maxy+1;
         qq.next;
      end;
   end;
   qq.free;
end;
procedure Tftscomarea.procesa_vv(x,y:integer;tipo,bib,prog:string;repe:array of Trepe);
var i,k,r:integer;
begin
   k:=length(vv);
   for i:=0 to k-1 do begin
      if (vv[i].clase=tipo) and
         (vv[i].bib=bib) and
         (vv[i].prog=prog) then begin
         repetido_vv(x,y,tipo,bib,prog,repe);
         exit;
      end;
   end;
   setlength(vv,k+1);
   vv[k].clase:=tipo;
   vv[k].bib:=bib;
   vv[k].prog:=prog;
   vv[k].left:=x;
   vv[k].top:=y;
   vv[k].ancho:=2;
   vv[k].alto:=1;
   vv[k].texto_left:=10;
   vv[k].texto_top:=0;
   vv[k].color:=clmoneygreen;
   vv[k].texto:=prog;
   vv[k].font_size:=7;
   ajusta_vv(x,y,k);
   subprogramas(x+4,y,tipo,bib,prog,repe);
end;

procedure Tftscomarea.bmapaClick(Sender: TObject);
var     repe:array of Trepe;
begin
  // if lst.ItemIndex=-1 then exit;
   setlength(vv,0);
   setlength(ww,0);
   setlength(bb,0);
   maxx:=0;
   maxy:=0;
//   procesa_vv(0,0,'CBL','COBONL','SOMAS04P',repe);
   procesa_vv(0,0,'CBL',cmbbib.Text,lst.Items[lst.ItemIndex],repe);
   bexporta.Visible:=true;
//   procesa_vv(maxx+1,maxy+1,'CBL',cmbbib.Text,lst.Items[lst.ItemIndex],repe);
end;

procedure Tftscomarea.ddDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var k,delta:integer;
      rec:Trect;
begin
   if length(vv)=0 then exit;
   if bb[acol][arow]=0 then exit;
   k:=bb[acol][arow]-1;
   delta:=dd.DefaultColWidth;
   dd.Canvas.Brush.Color:=vv[k].color;
   //rec.Left:=vv[k].left*delta;
   //rec.Top:=vv[k].top*delta;
   rec.Left:=rect.Left;
   rec.Top:=rect.Top;
   rec.Right:=(vv[k].left+vv[k].ancho)*delta;
   rec.Bottom:=(vv[k].top+vv[k].alto)*delta;
   dd.Canvas.FillRect(rect);
   dd.Canvas.Font.Size:=vv[k].font_size;
   //dd.Canvas.TextOut(vv[k].left*delta,(vv[k].top+vv[k].texto_top)*delta,vv[k].texto);
   dd.Canvas.TextOut(rect.Left,rect.Top,vv[k].texto);
end;

procedure Tftscomarea.bexportaClick(Sender: TObject);
var sal:Tstringlist;
   i,j:integer;
   paso:string;
begin
   if savedialog1.Execute=false then exit;
   sal:=Tstringlist.Create;
   for i:=0 to length(bb[0])-1 do begin
      paso:='';
      for j:=0 to length(bb)-1 do begin
         if bb[i][j]=0 then
            paso:=paso+','
         else
            paso:=paso+vv[bb[j][i]-1].texto;
      end;
      sal.Add(paso);
   end;
   sal.SaveToFile(savedialog1.FileName);
   sal.Free;
end;

procedure Tftscomarea.lnkClick(Sender: TObject);
begin
   if (lst.ItemIndex=-1) or (lnk.ItemIndex=-1) then exit;
   bunicoclick(sender);
end;

procedure Tftscomarea.chksoloClick(Sender: TObject);
begin
   dbgcellclick(dbg.Columns[0]);
end;

procedure Tftscomarea.chkcampoClick(Sender: TObject);
begin
   dbgcellclick(dbg.Columns[0]);
end;

end.
