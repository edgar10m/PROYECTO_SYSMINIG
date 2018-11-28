unit ptscomm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids,ADODb, ComCtrls;
type
   Tafe=record
      programa:string;
      campo:string;
      ini:integer;
      fin:integer;
   end;
   Tref=record
      programa:Tstringlist;
      campo:string;
      ini:integer;
      fin:integer;
   end;
type
  Tftscomm = class(TForm)
    Panel1: TPanel;
    dg: TDrawGrid;
    Splitter1: TSplitter;
    DrawGrid1: TDrawGrid;
    cmbbib: TComboBox;
    mas1: TEdit;
    mas2: TEdit;
    mas3: TEdit;
    mas4: TEdit;
    mas5: TEdit;
    mas6: TEdit;
    bejecuta: TButton;
    chksolo: TCheckBox;
    chkcampo: TCheckBox;
    pb: TProgressBar;
    brelacionados: TButton;
    breporte: TButton;
    SaveDialog1: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure bejecutaClick(Sender: TObject);
    procedure dgDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure breporteClick(Sender: TObject);
  private
    { Private declarations }
    cc:array of Tstringlist;
    yx:array of array of string;
    zx,zy:integer;
    zcola:integer;    // posicion de la ultima cola que se procesa
    zcomarea:string;  // cola procesando
    b_relacionados:boolean;
    xafe:array of Tafe;
    Xref:array of array of Tref;
    procedure alimenta_graficos;
    procedure quita_registros(k:integer);
    procedure procesa_pointers(cbib,cprog,creg,ccampo:string; k:integer);
    procedure procesa_variables(cbib,cprog,creg,ccampo:string; k:integer);
    procedure procesa_registros(cbib,cprog,comar:string; k:integer);
    procedure procesa_colas(cbib,cprog:string; k:integer);
    procedure procesa_mascara(mascara:string; color:string='L');
  public
    { Public declarations }
  end;

var
  ftscomm: Tftscomm;
procedure PR_COMM;

implementation
uses ptsdm;
{$R *.dfm}
procedure PR_COMM;
begin
   Application.CreateForm( Tftscomm, ftscomm );
   try
      ftscomm.Show;
   finally
   end;
end;

procedure Tftscomm.FormCreate(Sender: TObject);
begin
   dm.feed_combo(cmbbib,'select distinct cbib from tsprog where cclase='+g_q+'CBL'+g_q+' order by cbib');
   setlength(yx,1);
   setlength(yx[0],1);
   yx[0][0]:='';
end;
procedure Tftscomm.alimenta_graficos;
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
   if dg.RowCount>1 then
      dg.FixedRows:=1;
   dg.repaint;
end;
procedure Tftscomm.quita_registros(k:integer);
var i:integer;
begin
   i:=0;
   while i<cc[k].Count-1 do begin
      if (copy(cc[k][i],1,2)='Y.') and
         ((copy(cc[k][i+1],1,2)='Y.') or (copy(cc[k][i+1],1,2)='S.')) then
         cc[k].Delete(i)
      else
         inc(i);
   end;
   i:=cc[k].count-1;
   if copy(cc[k][i],1,2)='Y.' then
      cc[k].Delete(i);
end;
procedure Tftscomm.procesa_pointers(cbib,cprog,creg,ccampo:string; k:integer);
var qq:Tadoquery;
   campo:string;
begin
   qq:=Tadoquery.Create(nil);
   qq.Connection:=dm.ADOConnection1;
   if dm.sqlselect(qq,'select * from tsvarcbl '+
      ' where cprog='+g_q+cprog+g_q+
      ' and   cbib='+g_q+cbib+g_q+
      ' and   cclase='+g_q+'CBL'+g_q+
      ' and   ccampo='+g_q+ccampo+'-PTR'+g_q+
      ' and   usage='+g_q+'POINTER'+g_q) then begin
      if dm.sqlselect(qq,'select * from tsvarcbl '+
         ' where cprog='+g_q+cprog+g_q+
         ' and   cbib='+g_q+cbib+g_q+
         ' and   cclase='+g_q+'CBL'+g_q+
         ' and   creg='+g_q+qq.fieldbyname('creg').AsString+g_q+
         ' and   ccampo<>'+g_q+ccampo+'-PTR'+g_q+
         ' and   ccampo<>creg '+
         ' and   usage='+g_q+'POINTER'+g_q) then begin
         campo:=qq.fieldbyname('ccampo').AsString;
         if copy(campo,length(campo)-3,4)='-PTR' then begin
            campo:=copy(campo,1,length(campo)-4);
            if dm.sqlselect(qq,'select * from tsvarcbl '+
               ' where cprog='+g_q+cprog+g_q+
               ' and   cbib='+g_q+cbib+g_q+
               ' and   cclase='+g_q+'CBL'+g_q+
               ' and   ccampo='+g_q+campo+g_q) then begin
               procesa_variables(cbib,cprog,qq.fieldbyname('creg').AsString,campo,k);
            end;
         end;
      end;
   end;
   qq.Free;
end;
procedure Tftscomm.procesa_variables(cbib,cprog,creg,ccampo:string; k:integer);
var qq:Tadoquery;
   i,j,n,primero,nivel,ini,fin:integer;
   color:string;
   b_afectado:boolean;
begin
   if copy(creg,1,1)='_' then exit;

   for i:=zcola+1 to cc[k].Count-1 do begin
      if copy(cc[k][i],1,2)='Y.' then begin
         if pos(' '+ccampo,cc[k][i])>0 then
            exit;
      end;
   end;
   qq:=Tadoquery.Create(nil);
   qq.Connection:=dm.ADOConnection1;
   b_afectado:=false;
   if dm.sqlselect(qq,'select * from tsvarcbl '+
            ' where cprog='+g_q+cprog+g_q+
            ' and   cbib='+g_q+cbib+g_q+
            ' and   cclase='+g_q+'CBL'+g_q+
            ' and   creg='+g_q+creg+g_q+
 //           ' and   ccampo='+g_q+ccampo+g_q+
            ' order by linea') then begin
      primero:=0;
      while not qq.Eof do begin
         color:='I';
         if (primero>0) and (qq.fieldbyname('nivel').AsInteger<=nivel) then
            break;
         if qq.fieldbyname('ccampo').AsString=ccampo then begin
            color:='Y';
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
                  color:='F';
                  b_afectado:=true;
                  if (b_relacionados) and (k=0) and (zcomarea='300') then begin  // registra afectados primera comarea
                     n:=length(xafe);
                     setlength(xafe,n+1);
                     xafe[n].programa:=cprog;
                     xafe[n].campo:=qq.fieldbyname('ccampo').AsString;
                     xafe[n].ini:=ini;
                     xafe[n].fin:=fin;
                  end;
               end;
            end;
            if (b_relacionados) and (k>0) and (zcomarea='300') and (color='I') then begin  // rastrea campos equivalentes comarea
               for j:=0 to length(xafe)-1 do begin
                  if ((ini>=xafe[j].ini) and (ini<=xafe[j].fin)) or
                     ((fin>=xafe[j].ini) and (fin<=xafe[j].fin)) or
                     ((ini<xafe[j].ini) and (fin>xafe[j].fin)) then begin
                     color:='P';
                     xref[k-1][j].programa.Add('['+inttostr(ini)+'-'+inttostr(fin)+'] '+
                        format('%02d',[qq.fieldbyname('nivel').AsInteger])+' '+
                        qq.fieldbyname('ccampo').AsString);
                     xref[k-1][j].campo:=qq.fieldbyname('ccampo').AsString;
                     xref[k-1][j].ini:=ini;
                     xref[k-1][j].fin:=fin;
                     break;
                  end;
               end;
            end;
            if chkcampo.Checked then begin
               if (color='F') or (color='Y') or (color='P') then begin
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
      {
      if (chksolo.Checked) and (b_afectado=false) then begin  // quita registros sin afectacion
         cc[k].Delete(cc[k].Count-1);
      end;
      }
   end;
   if dm.sqlselect(qq,'select * from tsrelavcbl '+
      ' where pcprog='+g_q+cprog+g_q+
      ' and   pcbib='+g_q+cbib+g_q+
      ' and   pcclase='+g_q+'CBL'+g_q+
      ' and   pcreg='+g_q+creg+g_q+
      ' and   pccampo='+g_q+ccampo+g_q+
      ' and   modo='+g_q+'MOVE'+g_q+
      ' and   pcprog=ocprog ') then begin
      while not qq.Eof do begin
         procesa_variables(qq.fieldbyname('hcbib').AsString,
                   qq.fieldbyname('hcprog').AsString,
                   qq.fieldbyname('hcreg').AsString,
                   qq.fieldbyname('hccampo').AsString,k);
         qq.Next;
      end;
   end;
   if dm.sqlselect(qq,'select * from tsrelavcbl '+
      ' where hcprog='+g_q+cprog+g_q+
      ' and   hcbib='+g_q+cbib+g_q+
      ' and   hcclase='+g_q+'CBL'+g_q+
      ' and   hcreg='+g_q+creg+g_q+
      ' and   hccampo='+g_q+ccampo+g_q+
      ' and   modo='+g_q+'MOVE'+g_q+
      ' and   hcprog=ocprog ') then begin
      while not qq.Eof do begin
         procesa_variables(qq.fieldbyname('pcbib').AsString,
                   qq.fieldbyname('pcprog').AsString,
                   qq.fieldbyname('pcreg').AsString,
                   qq.fieldbyname('pccampo').AsString,k);
         qq.Next;
      end;
   end;
   qq.free;
end;
procedure Tftscomm.procesa_registros(cbib,cprog,comar:string; k:integer);
var   qq:Tadoquery;
begin
   qq:=Tadoquery.Create(self);
   qq.Connection:=dm.ADOConnection1;
   if comar='300' then begin
      if dm.sqlselect(qq,'select * from tsvarcbl '+
                  ' where cprog='+g_q+cprog+g_q+
                  ' and   cbib='+g_q+cbib+g_q+
                  ' and   cclase='+g_q+'CBL'+g_q+
                  //' and   creg='+g_q+reg+g_q+
                  //' and   creg<>ccampo '+
                  ' and   longitud=300') then begin
         while not qq.Eof do begin
            //cc[k].Add('Y.'+qq.fieldbyname('ccampo').AsString);
            procesa_variables(qq.fieldbyname('cbib').AsString,
                      qq.fieldbyname('cprog').AsString,
                      qq.fieldbyname('creg').AsString,
                      qq.fieldbyname('ccampo').AsString,k);
            qq.Next;
         end;
      end;
   end
   else
   if comar='DFHCOMMAREA' then begin
      if dm.sqlselect(qq,'select distinct ocprog,ocbib,occlase,pcreg,pccampo from tsrelavcbl '+
         ' where ocprog='+g_q+cprog+g_q+
         ' and   ocbib='+g_q+cbib+g_q+
         ' and   occlase='+g_q+'CBL'+g_q+
         ' and   pcclase='+g_q+'CBL'+g_q+
         ' and   hcclase='+g_q+'CBL'+g_q+
         ' and   pcprog<>hcprog '+
         ' and   modo='+g_q+'MOVE'+g_q+
         ' order by pcreg,pccampo') then begin
         while not qq.Eof do begin
            procesa_variables(qq.fieldbyname('ocbib').AsString,
                      qq.fieldbyname('ocprog').AsString,
                      qq.fieldbyname('pcreg').AsString,
                      qq.fieldbyname('pccampo').AsString,k);
            qq.Next;
         end;
      end;
      if dm.sqlselect(qq,'select distinct ocprog,ocbib,occlase,hcreg,hccampo from tsrelavcbl '+
         ' where ocprog='+g_q+cprog+g_q+
         ' and   ocbib='+g_q+cbib+g_q+
         ' and   occlase='+g_q+'CBL'+g_q+
         ' and   pccampo='+g_q+comar+g_q+
         ' and   modo='+g_q+'MOVE'+g_q+
         ' order by hcreg,hccampo') then begin
         while not qq.Eof do begin
            procesa_variables(qq.fieldbyname('ocbib').AsString,
                      qq.fieldbyname('ocprog').AsString,
                      qq.fieldbyname('hcreg').AsString,
                      qq.fieldbyname('hccampo').AsString,k);
            qq.Next;
         end;
      end;
      if dm.sqlselect(qq,'select distinct ocprog,ocbib,occlase,pcreg,pccampo from tsrelavcbl '+
         ' where ocprog='+g_q+cprog+g_q+
         ' and   ocbib='+g_q+cbib+g_q+
         ' and   occlase='+g_q+'CBL'+g_q+
         ' and   hccampo='+g_q+comar+g_q+
         ' and   modo='+g_q+'MOVE'+g_q+
         ' order by pcreg,pccampo') then begin
         while not qq.Eof do begin
            procesa_variables(qq.fieldbyname('ocbib').AsString,
                      qq.fieldbyname('ocprog').AsString,
                      qq.fieldbyname('pcreg').AsString,
                      qq.fieldbyname('pccampo').AsString,k);
            qq.Next;
         end;
      end;
   end
   else begin
      if dm.sqlselect(qq,'select distinct ocprog,ocbib,occlase,hcreg,hccampo from tsrelavcbl '+
         ' where ocprog='+g_q+cprog+g_q+
         ' and   ocbib='+g_q+cbib+g_q+
         ' and   occlase='+g_q+'CBL'+g_q+
         ' and   pcreg in ('+g_q+'_TSQUEUE_'+g_q+','+g_q+'_TDQUEUE_'+g_q+')'+
         ' and   pccampo='+g_q+comar+g_q+
         ' and   modo='+g_q+'MOVE'+g_q+
         ' order by hcreg,hccampo') then begin
         while not qq.Eof do begin
            procesa_variables(qq.fieldbyname('ocbib').AsString,
                      qq.fieldbyname('ocprog').AsString,
                      qq.fieldbyname('hcreg').AsString,
                      qq.fieldbyname('hccampo').AsString,k);
            procesa_pointers(qq.fieldbyname('ocbib').AsString,
                      qq.fieldbyname('ocprog').AsString,
                      qq.fieldbyname('hcreg').AsString,
                      qq.fieldbyname('hccampo').AsString,k);
            qq.Next;
         end;
      end;
      if dm.sqlselect(dm.q1,'select distinct ocprog,ocbib,occlase,pcreg,pccampo from tsrelavcbl '+
         ' where ocprog='+g_q+cprog+g_q+
         ' and   ocbib='+g_q+cbib+g_q+
         ' and   occlase='+g_q+'CBL'+g_q+
         ' and   hcreg in ('+g_q+'_TSQUEUE_'+g_q+','+g_q+'_TDQUEUE_'+g_q+')'+
         ' and   hccampo='+g_q+comar+g_q+
         ' and   modo='+g_q+'MOVE'+g_q+
         ' order by pcreg,pccampo') then begin
         while not qq.Eof do begin
            procesa_variables(qq.fieldbyname('ocbib').AsString,
                      qq.fieldbyname('ocprog').AsString,
                      qq.fieldbyname('pcreg').AsString,
                      qq.fieldbyname('pccampo').AsString,k);
            procesa_pointers(qq.fieldbyname('ocbib').AsString,
                      qq.fieldbyname('ocprog').AsString,
                      qq.fieldbyname('pcreg').AsString,
                      qq.fieldbyname('pccampo').AsString,k);
            qq.Next;
         end;
      end;
   end;
   qq.Free;
end;
procedure Tftscomm.procesa_colas(cbib,cprog:string; k:integer);
var quer:string;
   qq:Tadoquery;
begin
   qq:=Tadoquery.Create(self);
   qq.Connection:=dm.ADOConnection1;
   quer:='select '+g_q+'DFHCOMMAREA'+g_q+' COMMAREA from dual '+
      {
      'select distinct hccampo COMMAREA from tsrelavcbl '+
      ' where ocprog='+g_q+cprog+g_q+
      ' and   ocbib='+g_q+cbib+g_q+
      ' and   occlase='+g_q+'CBL'+g_q+
      ' and   pcclase='+g_q+'CBL'+g_q+
      ' and   hcclase='+g_q+'CBL'+g_q+
      ' and   pcprog<>hcprog '+
      ' and   modo='+g_q+'MOVE'+g_q+
      }
      ' union '+
      ' select distinct hccampo from tsrelavcbl '+
      '    where ocprog='+g_q+cprog+g_q+
      '    and   ocbib='+g_q+cbib+g_q+
      '    and   occlase='+g_q+'CBL'+g_q+
      '    and    ((hcreg='+g_q+'_TSQUEUE_'+g_q+') or (hcreg='+g_q+'_TDQUEUE_'+g_q+'))'+
      '  union '+
      '  select distinct pccampo from tsrelavcbl '+
      '    where ocprog='+g_q+cprog+g_q+
      '    and   ocbib='+g_q+cbib+g_q+
      '    and   occlase='+g_q+'CBL'+g_q+
      '    and    ((pcreg='+g_q+'_TSQUEUE_'+g_q+') or (pcreg='+g_q+'_TDQUEUE_'+g_q+'))'+
      '  union '+
      '  select '+g_q+'300'+g_q+' from dual '+
      '  order by 1 '+
      ' ';
   if dm.sqlselect(qq,quer) then begin
      while not qq.Eof do begin
         cc[k].Add('S.'+qq.fieldbyname('COMMAREA').AsString);
         zcomarea:=qq.fieldbyname('COMMAREA').AsString;
         zcola:=cc[k].Count-1;
         procesa_registros(cbib,cprog,
            stringreplace(qq.fieldbyname('COMMAREA').AsString,'''','''''',[rfreplaceall]),
            k);
         qq.Next;
      end;
   end;
   qq.Free;
end;
procedure Tftscomm.procesa_mascara(mascara:string; color:string='L');
var i,k:integer;
   b_repetido:boolean;
begin
   mascara:=stringreplace(mascara,'*','%',[rfreplaceall]);
   if dm.sqlselect(dm.q1,'select * from tsprog '+
      ' where cbib='+g_q+cmbbib.Text+g_q+
      ' and   cprog like '+g_q+mascara+g_q+
      ' and   cclase='+g_q+'CBL'+g_q+
      ' order by cprog') then begin
      while not dm.q1.Eof do begin
         k:=length(cc);
         b_repetido:=false;
         for i:=0 to k-1 do begin
            if dm.q1.FieldByName('cprog').asstring=cc[i][0] then begin
               b_repetido:=true;
               break;
            end;
         end;
         if b_repetido=false then begin
            setlength(cc,k+1);
            cc[k]:=Tstringlist.Create;
            cc[k].Add(color+'.'+dm.q1.FieldByName('cprog').asstring);
         end;
         dm.q1.Next;
      end;
   end;
end;

procedure Tftscomm.bejecutaClick(Sender: TObject);
var i,j:integer;
   mas:Tedit;
begin
   pb.Visible:=true;
   screen.Cursor:=crHourGlass;
   for i:=0 to length(cc)-1 do begin
      cc[i].Free;
   end;
   dg.colcount:=1;
   dg.rowcount:=1;
   setlength(cc,0);
   setlength(xafe,0);
   setlength(xref,0);
   if (trim(mas1.Text)='') and
      (trim(mas2.Text)='') and
      (trim(mas3.Text)='') and
      (trim(mas4.Text)='') and
      (trim(mas5.Text)='') and
      (trim(mas6.Text)='') then exit;
   for i:=0 to componentcount-1 do begin
      if components[i] is tedit then begin
         mas:=(components[i] as tedit);
         if trim(mas.Text)='' then
            continue;
         procesa_mascara(mas.Text);
      end;
   end;
   b_relacionados:=false;
   breporte.Visible:=false;
   if (sender as Tbutton).Name='brelacionados' then begin // Procesa programas relacionedos
      breporte.Visible:=true;
      b_relacionados:=true;
      j:=length(cc)-1;
      for i:=0 to j do begin
         if dm.sqlselect(dm.q2,'select pcprog from tsrela '+
            ' where hcprog='+g_q+copy(cc[i][0],3,100)+g_q+
            ' and   hcbib='+g_q+cmbbib.Text+g_q+
            ' and   hcclase='+g_q+'CBL'+g_q+
            ' and   pcclase='+g_q+'CBL'+g_q+
            ' order by 1') then begin
            while not dm.q2.Eof do begin
               procesa_mascara(dm.q2.fieldbyname('pcprog').AsString,'A');
               dm.q2.Next;
            end;
         end;
         if dm.sqlselect(dm.q2,'select hcprog from tsrela '+
            ' where pcprog='+g_q+copy(cc[i][0],3,100)+g_q+
            ' and   pcbib='+g_q+cmbbib.Text+g_q+
            ' and   pcclase='+g_q+'CBL'+g_q+
            ' and   hcclase='+g_q+'CBL'+g_q+
            ' order by 1') then begin
            while not dm.q2.Eof do begin
               procesa_mascara(dm.q2.fieldbyname('hcprog').AsString,'C');
               dm.q2.Next;
            end;
         end;
      end;
   end;
   pb.Max:=length(cc);
   pb.step:=1;
   setlength(xref,length(cc));
   for i:=0 to length(cc)-1 do begin
      setlength(xref[i],50);
      for j:=0 to 49 do
         xref[i][j].programa:=Tstringlist.Create;
   end;
   for i:=0 to length(cc)-1 do begin
      pb.StepIt;
      procesa_colas(cmbbib.Text,copy(cc[i][0],3,100),i);
      if chksolo.Checked then
         quita_registros(i);
   end;
   alimenta_graficos;
   screen.Cursor:=crdefault;
   pb.Visible:=false;
end;

procedure Tftscomm.dgDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var texto:string;
begin
   if trim(yx[acol][arow])='' then exit;
   texto:=yx[acol][arow];
   if copy(texto,1,1)='I' then begin
      dg.Canvas.Brush.Color:=clsilver;
      dg.Canvas.FillRect(rect);
   end;
   if copy(texto,1,1)='Y' then begin
      dg.Canvas.Brush.Color:=clyellow;
      dg.Canvas.FillRect(rect);
   end;
   if copy(texto,1,1)='A' then begin
      dg.Canvas.Brush.Color:=claqua;
      dg.Canvas.FillRect(rect);
   end;
   if copy(texto,1,1)='F' then begin
      dg.Canvas.Brush.Color:=clfuchsia;
      dg.Canvas.FillRect(rect);
   end;
   if copy(texto,1,1)='C' then begin
      dg.Canvas.Brush.Color:=clcream;
      dg.Canvas.FillRect(rect);
   end;
   if copy(texto,1,1)='P' then begin
      dg.Canvas.Brush.Color:=clpurple;
      dg.Canvas.FillRect(rect);
   end;
   if copy(texto,1,1)='L' then begin
      dg.Canvas.Brush.Color:=cllime;
      dg.Canvas.FillRect(rect);
   end;
   if copy(texto,1,1)='S' then begin
      dg.Canvas.Brush.Color:=clskyblue;
      dg.Canvas.FillRect(rect);
   end;
   dg.Canvas.TextOut(rect.Left,rect.Top,copy(texto,3,100));

end;

procedure Tftscomm.breporteClick(Sender: TObject);
var i,j,h:integer;
   rep:Tstringlist;
   dato:string;
   b_hijos:boolean;
begin
   savedialog1.FileName:=cc[0][0]+'.csv';
   if savedialog1.Execute=false then exit;
   rep:=Tstringlist.Create;
   rep.add('PROGRAMA_BASE');
   dato:=cc[0][0]+',';
   for j:=0 to length(xafe)-1 do
      dato:=dato+'"['+inttostr(xafe[j].ini)+'-'+inttostr(xafe[j].fin)+']  '+xafe[j].campo+'",';
   rep.add(dato);
   dato:='';
   for i:=1 to length(cc)-1 do begin
//      while b_hijos do begin
      for h:=0 to 50 do begin
         b_hijos:=false;
         dato:=cc[i][0]+',';
         for j:=0 to length(xref[i-1])-1 do begin
            if xref[i-1][j].programa.Count>h then begin
               b_hijos:=true;
               dato:=dato+'"'+xref[i-1][j].programa[h]+'",';
            end
            else
               dato:=dato+',';
         end;
         if b_hijos=false then
            break;
         rep.Add(dato);
      end;
   end;
   rep.SaveToFile(savedialog1.FileName);
   rep.Free;
end;

end.
