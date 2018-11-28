unit ptsrecibm;

interface

uses
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   ComCtrls, StdCtrls, Buttons, ExtCtrls, FileCtrl, Db, DBTables,
   ImgList, Menus, Grids, ValEdit, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdFTP;

type
   Tcampo=record
      nivel:integer;
      campo:string;
      pic:string;
      inicio:integer;
      tamano:integer;
      occurs:integer;
      redefines:string;
   end;
type
   arbol = record
      tipo: string;
      nombre: string;
      ptipo: string;
      pnombre: string;
   end;
type
   Tfmgrecibm = class( TForm )
      PageControl1: TPageControl;
      TabSheet1: TTabSheet;
      grbRecepcion: TGroupBox;
      GroupBox3: TGroupBox;
      Label8: TLabel;
      Label7: TLabel;
      Panel1: TPanel;
      Panel6: TPanel;
      Button1: TButton;
    pop: TPopupMenu;
    Splitter4: TSplitter;
    lvibm: TListView;
    Panel2: TPanel;
    cmblibreria: TComboBox;
    Label3: TLabel;
    Label9: TLabel;
    lblselec: TLabel;
    lblitems: TLabel;
    Label2: TLabel;
    txtsufijo: TEdit;
    barchivo: TBitBtn;
    GroupBox1: TGroupBox;
    memo: TRichEdit;
    vl: TValueListEditor;
    Panel3: TPanel;
    cmbfile: TComboBox;
    BitBtn1: TBitBtn;
    Splitter1: TSplitter;
    SpeedButton1: TSpeedButton;
    txtgo: TEdit;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    lblsize: TLabel;
    pb: TProgressBar;
    ftpibm: TIdFTP;
      procedure barchivoClick( Sender: TObject );
      procedure Button1Click( Sender: TObject );
    procedure lvibmClick(Sender: TObject);
    procedure cmblibreriaChange(Sender: TObject);
    procedure cmblibreriaClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure vlDragOver(Sender, Source: TObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure memoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure vlDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure txtgoKeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure ftpibmWork(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
   private
    { Private declarations }
      nd: array of arbol;
      opcion: array of Tmenuitem;
      b_archivo:boolean;
      b_cambia:boolean;
      rutaibm:string;
      cc:array of Tcampo;
      maximo:integer;
      b_abierto:boolean;
      iFileHandle: Integer;
      local:string;
      procedure muestra_registro(filename:string; n:integer);
      procedure totaliza(k:integer);
      function  fnpicture(x,display:string):integer;
      procedure prepara_fd(memo:Trichedit);
      procedure obten_palabras( linea: string; var lista: Tstringlist; append:boolean=false );
      procedure muestra_ibm( lv: Tlistview; directorio: string; mascara: string );
      function agrega_al_menu( titulo: string ): integer;
      procedure cuenta_check;
//     procedure analiza_compo(tipo:string; nombre:string);
   public
    { Public declarations }
   end;

var
   b_nuevos: boolean;
   work_dir: string;
   fmgrecibm: Tfmgrecibm;
function PR_RECIBEHOST: boolean;

implementation
uses ptsdm, mgdlgibm;
{$R *.DFM}

function PR_RECIBEHOST: boolean;
begin
   Application.CreateForm( Tfmgrecibm, fmgrecibm );
   if PR_DLGIBM(fmgrecibm.ftpibm) = false then begin
      fmgrecibm.Free;
      exit;
   end;
   try
      fmgrecibm.Showmodal;
   finally
      fmgrecibm.Free;
   end;
end;
procedure Tfmgrecibm.barchivoClick( Sender: TObject );
var lib:string;
begin
   if trim(cmblibreria.Text)='' then exit;
   try
      ftpibm.ChangeDir(cmblibreria.Text);
   except
      showmessage('ERROR... Esa ruta no es accesible');
      exit;
   end;
   lib:=stringreplace(cmblibreria.Text,'''','',[rfreplaceall]);
   lib:=''''+lib+'''';
   muestra_ibm(lvibm,lib,txtsufijo.Text);
   lblitems.Caption:=inttostr(lvibm.Items.Count);
   lblselec.Caption:='0';
   if cmblibreria.Items.IndexOf(cmblibreria.Text)>-1 then
      cmblibreria.Items.Delete(cmblibreria.Items.IndexOf(cmblibreria.Text));
   cmblibreria.Items.Insert(0,cmblibreria.Text);
end;

procedure Tfmgrecibm.Button1Click( Sender: TObject );
begin
   Close;
end;

function Tfmgrecibm.agrega_al_menu( titulo: string ): integer;
var
   k: integer;

begin
   k := length( opcion );
   setlength( opcion, k + 1 );
   opcion[ k ] := Tmenuitem.Create( pop );
   opcion[ k ].Caption := titulo;
   pop.Items.Add( opcion[ k ] );
   agrega_al_menu := k;
end;

procedure Tfmgrecibm.cuenta_check;
var i,m:integer;
begin
   m:=0;
   for i:=0 to lvibm.Items.Count-1 do
      if lvibm.Items[i].Checked then inc(m);
   lblselec.Caption:=inttostr(m);
end;
procedure Tfmgrecibm.lvibmClick(Sender: TObject);
var
   modu,local: string;
   k:integer;
begin
   cuenta_check;
   if lvibm.ItemIndex = -1 then
      exit;
   modu := lvibm.Items[ lvibm.itemindex ].Caption;
   local:=g_tmpdir+'\'+modu;
   ftpibm.Get(modu,local,true);
   k:=pos('.',modu);
   if k>0 then modu:=copy(modu,1,k-1);
   modu := lowercase(modu);
   memo.Lines.LoadFromFile(local);
end;

procedure Tfmgrecibm.cmblibreriaChange(Sender: TObject);
begin
   barchivo.Enabled:=(trim(cmblibreria.Text)<>'');
end;
procedure Tfmgrecibm.muestra_ibm( lv: Tlistview; directorio: string; mascara: string );
var
   lista, lista1: Tstringlist;
   i: integer;

begin
   try
      ftpibm.ChangeDir( directorio );
   except
      application.MessageBox( pchar( 'No puede accesar al directorio ' + directorio ),
         'ERROR...', MB_OK );
      abort;
   end;
   lista := Tstringlist.Create;
   lista1 := Tstringlist.Create;
   ftpibm.List( lista, mascara, true );
   lv.Clear;
   lv.Items.Count := 0;
   lv.Column[ 0 ].Width := 160;
   lv.Column[ 1 ].Width := 100;
   lv.Column[ 2 ].Width := 100;
   lv.Column[ 3 ].Width := 90;
   for i := 0 to lista.Count - 1 do
   begin
      obten_palabras( lista[ i ], lista1 );
      if lista1.Count > 8 then
      begin
         lv.Items.Add;
         lv.Items[ lv.Items.Count - 1 ].Caption := lista1[ 0 ];
         lv.Items[ lv.Items.Count - 1 ].SubItems.Add( lista1[ 3 ] + ' ' + lista1[ 4 ] );
         lv.Items[ lv.Items.Count - 1 ].SubItems.Add( lista1[ 5 ] );
         lv.Items[ lv.Items.Count - 1 ].SubItems.Add( lista1[ 8 ] );
      end
      else begin
         lv.Items.Add;
         lv.Items[ lv.Items.Count - 1 ].Caption := lista1[ 0 ];
      end;
   end;
   lista.Free;
   lista1.Free;
end;

procedure Tfmgrecibm.cmblibreriaClick(Sender: TObject);
begin
   b_cambia:=true;
   Perform(WM_NEXTDLGCTL, 0, 0);
end;

procedure Tfmgrecibm.Button2Click(Sender: TObject);
var i:integer;
begin
   {
   for i:=0 to lvibm.Items.Count-1 do
      lvibm.Items[i].Checked:=true;
   cuenta_check;
   }
end;

procedure Tfmgrecibm.Button3Click(Sender: TObject);
var i:integer;
begin
   {
   for i:=0 to lvibm.Items.Count-1 do
      lvibm.Items[i].Checked:=false;
   cuenta_check;
   }
end;
procedure Tfmgrecibm.muestra_registro(filename:string; n:integer);
var i:integer;
  iBytesRead: Integer;
  Buffer: PChar;
begin
   if b_abierto=false then begin
      iFileHandle := FileOpen(FileName, fmOpenRead);
      b_abierto:=true;
   end;
   try
      FileSeek(iFileHandle,n*maximo,0);
      Buffer := PChar(AllocMem(maximo + 1));
      iBytesRead := FileRead(iFileHandle, Buffer^, maximo);
      if iBytesRead=0 then exit;
      for i := 0 to length(cc)-1 do begin
         vl.Cells[1,i+1]:='['+copy(buffer,cc[i].inicio,cc[i].tamano)+']';
      end;
   finally
      FreeMem(Buffer);
   end;
   txtgo.Text:=inttostr(n);
end;

procedure Tfmgrecibm.BitBtn1Click(Sender: TObject);
var arch:string;
begin
   if b_abierto then begin
      FileClose(iFileHandle);
      b_abierto:=false;
   end;
   if trim(cmbfile.Text)='' then exit;
   arch:=stringreplace(cmbfile.Text,'''','',[rfreplaceall]);
   arch:=''''+arch+'''';
   local:=g_tmpdir+'\'+arch;
   //pb.Max:=ftpibm.Size(arch);
   //lblsize.Caption:=ftpibm.Size(arch);
   lblsize.Caption:=inttostr(ftpibm.Size(arch));
   ftpibm.Get(arch,local,true);
   if cmbfile.Items.IndexOf(cmbfile.Text)>-1 then
      cmbfile.Items.Delete(cmbfile.Items.IndexOf(cmbfile.Text));
   cmbfile.Items.Insert(0,cmbfile.Text);
   muestra_registro(local,0);

end;
function  Tfmgrecibm.fnpicture(x,display:string):integer;
var i,m,lon:integer;
   b_par:boolean;
begin
   lon:=0;
   b_par:=false;
   for i:=1 to length(x) do begin
      if x[i]='(' then begin
         b_par:=true;
         m:=0;
         continue;
      end;
      if b_par then begin
         if x[i]=')' then begin
            lon:=lon-1+m;
            b_par:=false;
            continue;
         end;
         m:=m*10+ord(x[i])-48;
         continue;
      end;
      if (i=1) and (x[i]='S') then
         continue;
      if x[i]='V' then
         continue;
      lon:=lon+1;
   end;
   if (display='COMP-1') or (display='COMPUTATIONAL-1') then
      lon:=4
   else
   if (display='COMP-2') or (display='COMPUTATIONAL-2') then
      lon:=8
   else
   if (display='COMP-3') or (display='COMPUTATIONAL-3') then  begin
      if copy(x,1,1)='S' then
         lon:=(lon+2) div 2
      else
         lon:=(lon+1) div 2;
   end
   else
   if (copy(display,1,4)='COMP') or (display='BINARY') then begin
      if lon>9 then
         lon:=8
      else
      if lon>4 then
         lon:=4
      else
         lon:=2;
   end;
   fnpicture:=lon;
end;

procedure Tfmgrecibm.totaliza(k:integer);
var i,j,tot:integer;
begin
   tot:=0;
   j:=cc[k+1].nivel;
   for i:=k+1 to length(cc)-1 do begin
      if (cc[i].nivel=j) and (cc[i].redefines<>'') then
         break;
      if cc[i].nivel=j then begin
         if cc[i].tamano=0 then
            totaliza(i);
         tot:=tot+cc[i].tamano;
      end;
      if cc[i].nivel<=cc[k].nivel then
         break;
   end;
   cc[k].tamano:=tot;
end;
procedure Tfmgrecibm.obten_palabras( linea: string; var lista: Tstringlist; append:boolean=false );
var
   k: integer;
   nlinea:string;
begin
   if append=false then
      lista.Clear;
   linea := trim( linea );
   nlinea:='';
   while nlinea<>linea do begin
      nlinea:=linea;
      linea:=stringreplace(nlinea,'  ',' ',[Rfreplaceall]);
   end;
   nlinea:=stringreplace(linea,' ',',',[rfreplaceall]);
   nlinea:=stringreplace(linea,'.',',.',[rfreplaceall]);
   if append then
      lista.CommaText:=lista.CommaText+','+nlinea
   else
      lista.CommaText:=nlinea;
end;
procedure Tfmgrecibm.prepara_fd(memo:Trichedit);
var i,j,k,n,m,nivel,nivel_master,ini:integer;
   pal:Tstringlist;
   b_inicia:boolean;
   pic,display:string;
begin
   i:=memo.Perform(EM_LINEFROMCHAR,memo.SelStart,0) ;
   pal:=tstringlist.Create;
   b_inicia:=true;
   ini:=1;
   setlength(cc,0);
   while i<memo.lines.count do begin
      while (trim(memo.Lines[i])='') or (copy(memo.lines[i],7,1)<>' ') do begin
         inc(i);
         if i>=memo.Lines.Count then
            break;
         continue;
      end;
      if i>=memo.Lines.Count then
         break;
      obten_palabras(copy(memo.Lines[i],8,65),pal);
      inc(i);
      while pal[pal.Count-1]<>'.' do begin
         if i>=memo.Lines.Count then
            break;
         while (trim(memo.Lines[i])='') or (copy(memo.lines[i],7,1)<>' ') do begin
            inc(i);
            continue;
         end;
         obten_palabras(copy(memo.Lines[i],8,65),pal,true);
         inc(i);
      end;
      if i>=memo.Lines.Count then
         break;
      if b_inicia then begin
         try
            nivel:=strtoint(pal[0]);
         except
            nivel:=0;
         end;
         if nivel=77 then
            break;
         if nivel=88 then begin
            inc(i);
            continue;
         end;
         if nivel>0 then begin
            if nivel_master=0 then
               nivel_master:=nivel
            else
               if nivel<=nivel_master then begin  // corte
                  for m:=0 to length(cc)-1 do
                     if cc[m].tamano=0 then
                        totaliza(m);
                  break;
               end;
            k:=length(cc);
            setlength(cc,k+1);
            cc[k].nivel:=nivel;
         end
         else begin   // no trae nivel, brinca
            inc(i);
            continue;
         end;
         cc[k].campo:=pal[1];
         cc[k].inicio:=ini;
         cc[k].occurs:=1;
         n:=2;
         b_inicia:=false;
      end;
      for j:=n to pal.Count-1 do begin
         if pal[j]='.' then begin
            cc[k].tamano:=fnpicture(cc[k].pic,display);
            ini:=ini+(cc[k].tamano*cc[k].occurs);
            if ini-1 > maximo then
               maximo:=ini-1;
            b_inicia:=true;
            break;
         end;
         if (pal[j]='PIC') or (pal[j]='PICTURE') then begin
            cc[k].pic:=pal[j+1];
         end;
         if (pal[j]='DISPLAY') or
            (pal[j]='BINARY') or
            (copy(pal[j],1,4)='COMP') then
            display:=pal[j];
         if pal[j]='OCCURS' then
            cc[k].occurs:=strtoint(pal[j+1]);
         if pal[j]='REDEFINES' then begin
            for m:=0 to k-1 do begin
               if pal[j+1]=cc[m].campo then begin
                  ini:=cc[m].inicio;
                  cc[k].inicio:=cc[m].inicio;
                  cc[k].redefines:=pal[j+1];
                  break;
               end;
            end;
         end;
      end;
   end;
   for i:=0 to length(cc)-1 do begin
      vl.InsertRow('['+inttostr(cc[i].inicio)+'-'+inttostr(cc[i].inicio+cc[i].tamano-1)+']  '+
         inttostr(cc[i].nivel)+' '+cc[i].campo+'   '+cc[i].pic,'',true);
   end;
   memo.DragMode:=dmmanual;
end;

procedure Tfmgrecibm.vlDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
   accept:=source is Trichedit;

end;

procedure Tfmgrecibm.memoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   if memo.SelLength>0 then
      memo.DragMode:=dmautomatic;
end;

procedure Tfmgrecibm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   if b_abierto then begin
      FileClose(iFileHandle);
      b_abierto:=false;
   end;
   cmblibreria.Items.SaveToFile(g_tmpdir+'\fgmrecibm_libreria');
   cmbfile.Items.SaveToFile(g_tmpdir+'\fgmrecibm_file');
end;

procedure Tfmgrecibm.FormCreate(Sender: TObject);
begin
   if fileexists(g_tmpdir+'\fgmrecibm_libreria') then
      cmblibreria.Items.LoadFromFile(g_tmpdir+'\fgmrecibm_libreria');
   if fileexists(g_tmpdir+'\fgmrecibm_file') then
      cmbfile.Items.LoadFromFile(g_tmpdir+'\fgmrecibm_file');
end;

procedure Tfmgrecibm.vlDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
   prepara_fd( memo);

end;

procedure Tfmgrecibm.txtgoKeyPress(Sender: TObject; var Key: Char);
begin
   if ((key>'9') or (key<'0')) and (key<>chr(8)) then key:=chr(0);
end;

procedure Tfmgrecibm.SpeedButton3Click(Sender: TObject);
begin
   if trim(txtgo.Text)='' then exit;
   muestra_registro(local,strtoint(txtgo.Text));
end;

procedure Tfmgrecibm.SpeedButton1Click(Sender: TObject);
begin
   if trim(txtgo.Text)='' then exit;
   if strtoint(txtgo.Text)>0 then
      muestra_registro(local,strtoint(txtgo.Text)-1);
end;

procedure Tfmgrecibm.SpeedButton2Click(Sender: TObject);
begin
   if trim(txtgo.Text)='' then exit;
   muestra_registro(local,strtoint(txtgo.Text)+1);

end;

procedure Tfmgrecibm.ftpibmWork(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCount: Integer);
begin
   pb.Position:=aworkcount;
end;

end.
