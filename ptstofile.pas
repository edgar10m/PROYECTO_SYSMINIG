unit ptstofile;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ADODB;
type
   Tdata=record
      ocprog:string;
      ocbib:string;
      occlase:string;
      pcprog:string;
      pcbib:string;
      pcclase:string;
      pcreg:string;
      pccampo:string;
      hcprog:string;
      hcbib:string;
      hcclase:string;
      hcreg:string;
      hccampo:string;
      sistema:string;
      lineainicio:integer;
      lineafinal:integer;
   end;
type
  Tftstofile = class(TForm)
    Panel1: TPanel;
    txtarchivo: TEdit;
    barchivo: TButton;
    cmbarchivo: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    cmbsistema: TComboBox;
    tv: TTreeView;
    Splitter1: TSplitter;
    memo: TRichEdit;
    cmbclase: TComboBox;
    cmbbib: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    procedure barchivoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmbsistemaChange(Sender: TObject);
    procedure cmbarchivoChange(Sender: TObject);
    procedure tvExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure cmbbibChange(Sender: TObject);
    procedure tvMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
   nodo_actual,nodo_antes:Ttreenode;
   procedure Posiciona(lwLinea: Integer );
   procedure agrega_cobol(q1:TadoQuery; nodo:Ttreenode;clase,bib,prog:string);
   procedure crea_nodo(nodo:TTreenode; clase,bib,prog:string);
  public
    { Public declarations }
  end;

var
  ftstofile: Tftstofile;
   procedure PR_TOFILE;

implementation
uses ptsdm, ptsgral;
{$R *.dfm}
procedure PR_TOFILE;
begin
   Application.CreateForm( Tftstofile, ftstofile );
   try
      ftstofile.Showmodal;
   finally
      ftstofile.Free;
   end;
end;

procedure Tftstofile.barchivoClick(Sender: TObject);
begin
   if trim(txtarchivo.Text)='' then exit;
   dm.feed_combo(cmbarchivo,'select distinct hcprog from tsrela '+
      ' where hcprog like '+g_q+stringreplace(trim(txtarchivo.text),'*','%',[rfreplaceall])+g_q+
      ' and   hcclase='+g_q+'FIL'+g_q+
      ' and   sistema='+g_q+cmbsistema.Text+g_q+
      ' order by hcprog');
   if cmbarchivo.Items.Count=0 then begin
      showmessage('No se encontraron coincidencias');
      exit;
   end;
   cmbarchivo.Enabled:=true;
end;

procedure Tftstofile.FormCreate(Sender: TObject);
begin
   dm.feed_combo(cmbsistema,'select csistema from tssistema '+
      ' where estadoactual='+g_q+'ACTIVO'+g_q+
      ' order by csistema');
end;

procedure Tftstofile.cmbsistemaChange(Sender: TObject);
begin
   if (trim(cmbsistema.Text)='') or
      (trim(cmbclase.Text)='') then exit;
   dm.feed_combo(cmbbib,'select distinct hcbib from tsrela '+
      ' where hcclase='+g_q+cmbclase.Text+g_q+
      ' and   sistema='+g_q+cmbsistema.Text+g_q+
      ' order by hcbib');
   txtarchivo.Enabled:=true;
   barchivo.Enabled:=true;
   cmbarchivo.Items.Clear;
   cmbarchivo.Enabled:=false;
end;
procedure Tftstofile.agrega_cobol(q1:TadoQuery;nodo:Ttreenode;clase,bib,prog:string);
var cc,bb,pp:string;
   reg:^Tdata;
   th:Ttreenode;
begin
   if (q1.fieldbyname('pcclase').AsString='STE') and
      ((q1.fieldbyname('occlase').AsString='JOB') or
       (q1.fieldbyname('occlase').AsString='JCL')) then begin
      cc:=' where pcprog='+g_q+q1.fieldbyname('pcprog').AsString+g_q+
         ' and   pcbib='+g_q+q1.fieldbyname('pcbib').AsString+g_q+
         ' and   pcclase='+g_q+q1.fieldbyname('pcclase').AsString+g_q;
   end
   else begin
      cc:=' where pcprog='+g_q+q1.fieldbyname('ocprog').AsString+g_q+
         ' and   pcbib='+g_q+q1.fieldbyname('ocbib').AsString+g_q+
         ' and   pcclase='+g_q+q1.fieldbyname('occlase').AsString+g_q;
   end;
   if dm.sqlselect(dm.q2,'select * from tsrela '+
      cc+
      ' and hcclase in ('+g_q+'CBL'+g_q+','+g_q+'SCB'+g_q+')') then begin
      while not dm.q2.Eof do begin
         if dm.sqlselect(dm.q3,'select * from tsrela '+
            ' where pcprog='+g_q+dm.q2.fieldbyname('hcprog').AsString+g_q+
            ' and   pcbib='+g_q+dm.q2.fieldbyname('hcbib').AsString+g_q+
            ' and   pcclase='+g_q+dm.q2.fieldbyname('hcclase').AsString+g_q+
            ' and   hcclase='+g_q+clase+g_q+
            ' and   hcprog='+g_q+prog+g_q) then begin
            th:=tv.Items.AddChild( nodo, 'hijo' );
            new( reg );
            reg.ocprog:=dm.q3.fieldbyname('ocprog').AsString;
            reg.ocbib:=dm.q3.fieldbyname('ocbib').AsString;
            reg.occlase:=dm.q3.fieldbyname('occlase').AsString;
            reg.pcprog:=dm.q3.fieldbyname('pcprog').AsString;
            reg.pcbib:=dm.q3.fieldbyname('pcbib').AsString;
            reg.pcclase:=dm.q3.fieldbyname('pcclase').AsString;
            reg.hcprog:=dm.q3.fieldbyname('hcprog').AsString;
            reg.hcbib:=dm.q3.fieldbyname('hcbib').AsString;
            reg.hcclase:=dm.q3.fieldbyname('hcclase').AsString;
            reg.sistema:=dm.q3.fieldbyname('sistema').AsString;
            reg.lineainicio:=dm.q3.fieldbyname('lineainicio').AsInteger;
            reg.lineafinal:=dm.q3.fieldbyname('lineafinal').AsInteger;
            th.Data := reg;
            th.ImageIndex := dm.lclases.IndexOf( reg.hcclase );
            th.SelectedIndex := 0; //dm.lclases.IndexOf( reg.hclase );
         end;
         dm.q2.Next;
      end;
   end;
end;
procedure Tftstofile.crea_nodo(nodo:TTreenode; clase,bib,prog:string);
var   reg: ^Tdata;
   tp,th:Ttreenode;
   dato:string;
begin
   if nodo=nil then begin
      dato:=clase+' '+lowercase(bib)+' '+prog;
      tp := tv.Items.AddFirst( nil, dato );
      new( reg );
      reg.occlase:=clase;
      reg.ocbib:=bib;
      reg.ocprog:=prog;
      reg.hcclase := clase;
      reg.hcbib:=bib;
      reg.hcprog:=prog;
      reg.sistema:=cmbsistema.Text;
      tp.Data := reg;
      tp.ImageIndex := dm.lclases.IndexOf( reg.hcclase );
      tp.SelectedIndex := 0; //dm.lclases.IndexOf( reg.hclase );
   end
   else begin
      tp := nodo;
      reg:=tp.Data;
      dato:=clase+' '+lowercase(bib)+' '+prog+':'+reg.pcreg+'.'+reg.pccampo;
      tp.Text:=dato;
   end;

   th:=tp.Parent;
   while th<>nil do begin
      if tp.Text=th.Text then begin
         tp.Text:=tp.Text+' (ciclado)';
         exit;
      end;
      th:=th.Parent;
   end;
   if dm.sqlselect(dm.q1,'select * from tsrela '+
      ' where hcprog='+g_q+prog+g_q+
      ' and   ((hcbib='+g_q+bib+g_q+') or ('+g_q+g_q+'='+g_q+bib+g_q+'))'+
      ' and   hcclase='+g_q+clase+g_q+
      ' order by orden') then begin
      while not dm.q1.Eof do begin
         if clase='LOC' then
            agrega_cobol(dm.q1,nodo,clase,bib,prog);
         if clase='CLA' then begin
            dm.q1.Next;
            continue;
         end;
         th:=tv.Items.AddChild( tp, 'hijo' );
         new( reg );
         reg.ocprog:=dm.q1.fieldbyname('ocprog').AsString;
         reg.ocbib:=dm.q1.fieldbyname('ocbib').AsString;
         reg.occlase:=dm.q1.fieldbyname('occlase').AsString;
         reg.pcprog:=dm.q1.fieldbyname('pcprog').AsString;
         reg.pcbib:=dm.q1.fieldbyname('pcbib').AsString;
         reg.pcclase:=dm.q1.fieldbyname('pcclase').AsString;
         reg.hcprog:=dm.q1.fieldbyname('hcprog').AsString;
         reg.hcbib:=dm.q1.fieldbyname('hcbib').AsString;
         reg.hcclase:=dm.q1.fieldbyname('hcclase').AsString;
         reg.sistema:=dm.q1.fieldbyname('sistema').AsString;
         reg.lineainicio:=dm.q1.fieldbyname('lineainicio').AsInteger;
         reg.lineafinal:=dm.q1.fieldbyname('lineafinal').AsInteger;
         th.Data := reg;
         th.ImageIndex := dm.lclases.IndexOf( reg.hcclase );
         th.SelectedIndex := 0; //dm.lclases.IndexOf( reg.hclase );
         dm.q1.Next;
      end;
   end;
end;

procedure Tftstofile.cmbarchivoChange(Sender: TObject);
var nn,hh:Ttreenode;
    reg,reg2: ^Tdata;
    i:integer;
begin
   if trim(cmbarchivo.Text)='' then exit;
   if tv.Items.Count>0 then begin
      for i:=0 to tv.Items.Count-1 do
         freemem(tv.Items[i].Data);
      tv.Items[0].Delete;
   end;
   crea_nodo(nil,cmbclase.Text,cmbbib.Text,cmbarchivo.text);





   {
   tv.Items.Clear;
   nn:=tv.Items.Add(nil,cmbarchivo.Text);
   new(reg);
   reg.ocprog:=cmbarchivo.Text;
   reg.occlase:='FIL';
   reg.pcprog:=cmbarchivo.Text;
   reg.pcclase:='FIL';
   nn.Data:=reg;
   if dm.sqlselect(dm.q1,'select * from tsrela '+
      ' where hcprog='+g_q+cmbarchivo.Text+g_q+
      ' and   hcclase='+g_q+'FIL'+g_q+
      ' order by pcclase,pcprog') then begin
      while not dm.q1.Eof do begin
         new(reg2);
         reg2.ocprog:=dm.q1.fieldbyname('ocprog').AsString;
         reg2.ocbib:=dm.q1.fieldbyname('ocbib').AsString;
         reg2.occlase:=dm.q1.fieldbyname('occlase').AsString;
         reg2.pcprog:=dm.q1.fieldbyname('pcprog').AsString;
         reg2.pcbib:=dm.q1.fieldbyname('pcbib').AsString;
         reg2.pcclase:=dm.q1.fieldbyname('pcclase').AsString;
         reg2.hcprog:=dm.q1.fieldbyname('hcprog').AsString;
         reg2.hcbib:=dm.q1.fieldbyname('hcbib').AsString;
         reg2.hcclase:=dm.q1.fieldbyname('hcclase').AsString;
         hh:=tv.Items.AddChild(nn,reg2.pcclase+' '+reg2.pcprog);
         hh.Data:=reg2;
         dm.q1.Next;
      end;
   end;
   }
end;

procedure Tftstofile.tvExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
var tt:Ttreenode;
   reg: ^Tdata;
begin
   tt:=node.getFirstChild;
   while tt<>nil do begin
      if tt.Text='hijo' then begin
         reg:=tt.Data;
         crea_nodo(tt,reg.pcclase,reg.pcbib,reg.pcprog);
      end;
      tt:=node.GetNextChild(tt);
   end;

end;

procedure Tftstofile.cmbbibChange(Sender: TObject);
begin
   if trim(cmbbib.Text)='' then exit;
   txtarchivo.Enabled:=true;
   barchivo.Enabled:=true;
   cmbarchivo.Items.Clear;
   cmbarchivo.Enabled:=false;
end;
procedure Tftstofile.Posiciona(lwLinea: Integer );
var
   linea, m: integer;
begin
   memo.SelStart := memo.Perform( EM_LINEINDEX, lwLinea - 1, 0 );
   memo.Perform( EM_SCROLLCARET, 0, 0 );
   m := memo.Perform( EM_GETFIRSTVISIBLELINE, 0, 0 );
   m := lwLinea - m - 30;
   memo.Perform( EM_LINESCROLL, 0, m );
   memo.SelLength := length( memo.Lines[ lwLinea - 1 ] );
   memo.SelAttributes.Color := clblue;
end;

procedure Tftstofile.tvMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
   HT: THitTests;
   reg: ^Tdata;
   k, lwLinIni, lwLinFin: integer;
   i: integer;
   lis,clases_listas:TStringList;
begin
   screen.Cursor := crsqlwait;
   clases_listas:=TStringList.Create;
   clases_listas:= gral.clases_p_listas;
   HT := tv.GetHitTestInfoAt( X, Y );
   if not ( htOnItem in HT ) then
      exit;
   nodo_actual := tv.GetNodeAt( X, Y );
   nodo_actual.Selected := true;
   if nodo_actual = nodo_antes then begin
      screen.Cursor := crdefault;
      exit;
   end
   else begin
      //popupArbol.Items.Clear;
      nodo_antes := nodo_actual;
   end;
   reg := nodo_actual.Data;
   dm.trae_fuente( reg.sistema, reg.ocprog, reg.ocbib, reg.occlase, memo );
   if (reg.lineainicio>0) and
      (reg.lineafinal>0) then begin
      lis:=tstringlist.Create;
      for i:=reg.lineainicio-1 to reg.lineafinal-1 do
         lis.Add(memo.Lines[i]);
      memo.Lines.Clear;
      memo.Lines.AddStrings(lis);
      lis.Free;
   end
   else begin
      if reg.lineainicio>0 then
         posiciona(reg.lineainicio);
   end;
   screen.Cursor := crdefault;
end;

end.
