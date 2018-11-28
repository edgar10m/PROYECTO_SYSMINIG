unit ptsbusca;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, OleCtrls, SHDocVw,shellapi,strutils,
  Menus,dateutils, Buttons, dxBar, cxStyles, cxCustomData, cxGraphics,
  cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData,
  cxLookAndFeelPainters, cxSplitter, cxMaskEdit, cxDropDownEdit, cxButtons,
  cxLabel, cxContainer, cxTextEdit, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxClasses, cxControls,
  cxGridCustomView, cxGrid, dxNavBarCollns, dxNavBarBase, dxNavBar, cxMemo,
  Grids, DBGrids;
type  Tbib=record
   clase:string;
   bib:string;
   ruta:string;
end;
type
  Tftsbusca = class(TForm)
    mnuPrincipal: TdxBarManager;
    mnuAyuda: TdxBarButton;
    pnlMenu: TPanel;
    pop: TPopupMenu;
    Notepad1: TMenuItem;
    Panel1: TPanel;
    Panel4: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    combo: TComboBox;
    cmbbiblioteca: TComboBox;
    Panel6: TPanel;
    lblquery: TLabel;
    Panel5: TPanel;
    Label4: TLabel;
    ypaginas: TPanel;
    Label2: TLabel;
    lblpaginas: TLabel;
    cmbpagina: TComboBox;
    Bindice: TButton;
    cmbmascara: TComboBox;
    bejecuta: TBitBtn;
    Panel3: TPanel;
    split1: TSplitter;
    web1: TWebBrowser;
    Panel7: TPanel;
    Splitter1: TSplitter;
    rich: TRichEdit;
    Web2: TWebBrowser;
    dtsConsultas: TDataSource;
    BitBtn1: TBitBtn;
    mnuConsultas: TdxBarButton;
    EditaQuery: TMemo;
    grdConsultas: TcxGrid;
    grdConsultasDBTableView1: TcxGridDBTableView;
    grdConsultasDBTableView1ConsultaCaption: TcxGridDBColumn;
    grdConsultasLevel1: TcxGridLevel;
    grdConsultasDBTableView1ConsultaFechaHora: TcxGridDBColumn;
    procedure FormCreate(Sender: TObject);
    procedure comboClick(Sender: TObject);
    procedure web1BeforeNavigate2(Sender: TObject; const pDisp: IDispatch;
      var URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
      var Cancel: WordBool);
    procedure web1DocumentComplete(Sender: TObject; const pDisp: IDispatch;
      var URL: OleVariant);
    procedure Notepad1Click(Sender: TObject);
    procedure Web2BeforeNavigate2(Sender: TObject; const pDisp: IDispatch;
      var URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
      var Cancel: WordBool);
    procedure BindiceClick(Sender: TObject);
    procedure cmbpaginaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bejecutaClick(Sender: TObject);
    procedure cmbbibliotecaChange(Sender: TObject);
    procedure comboChange(Sender: TObject);
    procedure cmbmascaraChange(Sender: TObject);
    function  ArmarOpciones(b1:Tstringlist):integer;
    procedure FormDestroy(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    function  FormHelp(Command: Word; Data: Integer;
    var CallHelp: Boolean): Boolean;
    procedure mnuAyudaClick(Sender: TObject);
    procedure grdConsultasDBTableView1DblClick(Sender: TObject);
    procedure EditaQueryEnter(Sender: TObject);
    procedure cxSplitter1BeforeOpen(Sender: TObject;
      var AllowOpen: Boolean);
    procedure mnuConsultasClick(Sender: TObject);
  private
    { Private declarations }
    bb:array of Tbib;
    //v lisbb:string;
    //V g_tmpdir:string;
    sca,ht,fuentes,mas,menos,pals,selec,lineas:Tstringlist;
    b_string:boolean;
    arch:string;
    g_cadenas:string;
    inicio:Tdatetime;
    b_esperaweb:boolean;
    Wbib,Wpath:string;
    tsindex03:string;
    palabra:string;  // Palabra cuyas paginas se estan mostrando
    paginas:integer;  // numero de paginas que tiene la palabra
    itemsxpagina:integer;
    idxpaginas:integer;  // numero de paginas del indice
    filtros,filtros2,filtrosno:Tstringlist; // Palabras filtradas
    Opciones: Tstringlist;
    salidaW2 : string;
    lClase: String;
    procedure web_indice(pagina:integer=1);
    procedure web_pagina(palabras:string; pagina:integer);
    procedure carga_fuente2(biblioteca:string; fuente:string; clase:string);
    procedure refrescapantalla;
  public
    { Public declarations }
    FechaTSS : string;
    FechaTSI : string;
    SQL_linea : string;
  end;

var
  ftsbusca: Tftsbusca;
  titulo: string;
  sqlClases:Tstringlist;
  procedure PR_BUSCA;

implementation
uses ptsdm, parbol, ptsgral, pbarra, HTML_HELP, HtmlHlp, uConstantes; //ptsmining,
{$R *.dfm}
procedure PR_BUSCA;
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try
      Application.CreateForm( Tftsbusca, ftsbusca );
      titulo := sLISTA_BUSCA_COMPO;
      ftsbusca.Caption := titulo;
      ftsbusca.Show;

      //dm.PubRegistraVentanaActiva( Titulo );
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure sql_clases;
begin
   sqlClases:=Tstringlist.Create;
   if dm.sqlselect(dm.q1,'select * from tsclase where busquedaselect='+g_q+'ACTIVO'+g_q+
                         ' and  estadoactual ='+g_q+'ACTIVO'+g_q+' order by cclase') then begin
      while not dm.q1.Eof do begin
         sqlClases.Add(dm.q1.fieldbyname('cclase').AsString);
         dm.q1.Next;
      end;
   end;
end;

procedure Tftsbusca.FormCreate(Sender: TObject);
var
    ListaLibs:string;
    arch: string;
    x1: Tstringlist;
begin
   if gral.bPubVentanaMaximizada = FALSE then begin
      Width := g_Width;
      Height:= g_Height;
   end;
   itemsxpagina:=1000;
   filtros  :=Tstringlist.Create;
   filtros2 :=Tstringlist.Create;
   filtrosno:=Tstringlist.Create;
   // tsindex03:=g_tmpdir+'\'+'hta'+formatdatetime('YYMMDDSSS',now)+'.exe';
   tsindex03:=g_ruta+'tsindex03.exe';
   if (g_demonio=false) and (g_busca_remoto=false) then begin
      dm.get_utileria('TSINDEX03',tsindex03);
      g_borrar.add(tsindex03);
      if dm.sqlselect(dm.q1,'select fecha from tsutileria where cutileria='+g_q+'TSINDEX03'+g_q) then
         FechaTSI:=dm.q1.fieldbyname('fecha').AsString;
   end;

   x1 := Tstringlist.create;
   x1.Add( '<HTML>' );
   x1.Add( '<HEAD>' );
   x1.Add( '</head>' );
   x1.Add( '<BODY">' );
   x1.Add( '</BODY>' );
   x1.Add( '</html>' );
   x1.savetofile( g_tmpdir + '\BLimpia' + '.html' );
   arch := g_tmpdir + '\BLimpia' + '.html';
   g_borrar.Add( arch );
   x1.free;

 {   if fileexists(g_tmpdir+'\SysMiningAUX00.HTML')=FALSE then begin
         dm.get_utileria('IMAGEN_LUPA',g_tmpdir+'\IMAGEN_LUPA.PNG');
         dm.get_utileria('SYSMININGAUX00',g_tmpdir+'\SYSMININGAUX00.HTML');
         if fileexists(g_tmpdir+'\SysMiningAUX00.HTML')=FALSE then
            abort;
         arch:=g_tmpdir+'\SYSMININGAUX00.HTML';
         g_borrar.Add(arch);
         arch:=g_tmpdir+'\IMAGEN_LUPA.PNG';
         g_borrar.Add(arch);
   end;
  }

   { Se dejará fijo en el servidor
   if (g_demonio) or (g_busca_remoto) then begin  // RGM agregar
      dm.remote_envia(tsindex03,tsindex03);
   end;
   }
   sca:=Tstringlist.Create;
   ht:=Tstringlist.Create;
   fuentes:=Tstringlist.Create;
   mas:=Tstringlist.Create;
   menos:=Tstringlist.Create;
   pals:=Tstringlist.Create;
   lineas:=Tstringlist.Create;
   //web1.Navigate(g_tmpdir+'\BLimpia.HTML');
   //web2.Navigate(g_tmpdir+'\BLimpia.HTML');

   if dm.sqlselect(dm.q2,'select * from parametro where clave='+g_q+'LIBSINFTES'+g_q)=false then  begin
      ListaLibs:='';
   end else begin
      ListaLibs:=' where cbib not in('+g_q+dm.q2.fieldbyname('dato').Asstring+g_q+')';
     //ListaLibs:=' and cbib not in('+g_q+dm.q2.fieldbyname('dato').Asstring+g_q+')';
   end;
//   dm.feed_combo(cmbbiblioteca,'select tc.cclase||'+g_q+' - '+g_q+'||tb.cbib||'+g_q+' - '+g_q+'||t.descripcion from tsbib tb, tsbibcla tc , tsclase t where tc.cbib = tb.cbib and tc.cclase = t.cclase '+ListaLibs+' order by tb.cbib');
     dm.feed_combo(cmbbiblioteca,'select descripcion from tsbib '+ListaLibs+' order by cbib');
//   dm.feed_combo(cmbbiblioteca,'select cbib||'+g_q+' - '+g_q+'||descripcion from tsbib '+ListaLibs+' order by cbib');
//   dm.feed_combo(cmbbiblioteca,'select cbib||'+g_q+' - '+g_q+'||descripcion from tsbib order by cbib');
//   cmbiblioteca.Items.Insert(0,'*');
// ---------------- Crea el directorio tmpdir en oracle
   if dm.sqlselect(dm.q2,'select * from all_directories '+
      ' where directory_name='+g_q+g_oratmpdir+g_q)=false then begin
      if dm.sqlinsert('create directory '+g_oratmpdir+' as '+g_q+g_tmpdir+g_q)=false then begin
         Application.MessageBox(pchar(dm.xlng('ERROR... DM1003 no tiene permiso CREATE ANY DIRECTORY ')),
            pchar(dm.xlng('Validar directorio ')), MB_OK );
         application.Terminate;
         abort;
      end;
   end
   else begin

      if dm.sqlselect(dm.q2,'select * from all_directories '+
         ' where directory_name='+g_q+g_oratmpdir+g_q+' and directory_path <> '+ g_q+g_tmpdir+g_q) then begin
         if dm.sqlinsert('create or replace directory '+g_oratmpdir+' as '+g_q+g_tmpdir+g_q)=false then begin
            Application.MessageBox(pchar(dm.xlng('ERROR... DM1003 no tiene permiso de CREATE OR REPLACE ANY DIRECTORY ')),
               pchar(dm.xlng('Validar directorio ')), MB_OK );
            application.Terminate;
            abort;
         end;
      end;

   end;
   sql_clases;
   if gral.iPubVentanasActivas > 0 then
      gral.PubExpandeMenuVentanas( True );
end;

procedure Tftsbusca.web_indice(pagina:integer=1);
var salida,ndato:string;
    i,j,k,nreg:integer;
begin

   //ypaginas.Visible:=false;
   //salida:=tsindex03+'_1.html';
   //salida:=tsindex03+'1_'+formatdatetime('YYYYMMDDHHNNSS',now)+'.html';   //--
   salida:=g_tmpdir+'\tsindex03'+'1_'+formatdatetime('YYYYMMDDHHNNSS',now)+'.html';   //--
   lineas.Clear;
   lineas.Add('<html>');
   lineas.Add('<body>');
	lineas.Add('<table border="1" cellpadding="5" cellspacing="5" width="100%"');
//	lineas.add('style="background-color:LAVENDER;border:3px dashed black;">');
	lineas.add('style="background-color:clWhite;border:3px black;">');
	lineas.Add('<tr>');
	lineas.Add('<th style="text-align:left"><font face="verdana" size="1">Palabra encontrada</font></th>');
	lineas.Add('<th style="text-align:left">#</th>');
	lineas.Add('</tr>');
   // Primera vez
   if idxpaginas=-1 then begin
      for i:=1 to ht.Count-1 do begin
         if copy(ht[i],1,2)='->' then break;
      end;
      idxpaginas:=(i+98) div 100;
      lblpaginas.Caption:=' de '+inttostr(idxpaginas);
      cmbpagina.Items.Clear;
      for i:=1 to idxpaginas do cmbpagina.Items.Add(inttostr(i));
      if idxpaginas>0 then begin
         cmbpagina.ItemIndex:=pagina-1;
         ypaginas.Visible:=true;
      end;
      bindice.Visible:=false;
   end;

//   for i:=1 to ht.Count-1 do begin
   for i:=1 to 100 do begin
      j:=100*(pagina-1)+i;
      if copy(ht[j],1,2)='->' then break;
      k:=pos(chr(9),ht[j]);
      ndato:=copy(ht[j],1,k-1);
      nreg:=strtoint(copy(ht[j],k+1,500));

      lineas.Add('<tr>');
      lineas.Add('<td width="200"><font face="verdana" size="1"><a href="#ind_'+
                  inttostr(nreg)+'_ind_'+ndato+'">'+ndato+'</a></font></td>'+
                  '<td><font face="verdana" size="1">'+inttostr(nreg)+'</font></td>');
      lineas.Add('</tr>');
   end;
   lineas.Add('</table>');
   lineas.Add('</body>');
   lineas.Add('</html>');
   lineas.SaveToFile(salida);
   //   Application.MessageBox(pchar(salida),
   //         'Ver Ruta', MB_ICONEXCLAMATION);
   web1.Navigate(salida);
   g_borrar.Add(salida);  //--

end;
procedure Tftsbusca.web_pagina(palabras:string; pagina:integer);
var salida:string;
   i,j,k,m:integer;
begin
   //salida:=tsindex03+'_1.html';
   //salida:=tsindex03+'_'+formatdatetime('YYYYMMDDHHNNSS',now)+'.html';   //--
   salida:=g_tmpdir+'\tsindex03'+'_'+formatdatetime('YYYYMMDDHHNNSS',now)+'.html';   //--
   palabras:=stringreplace(palabras,'%20',' ',[rfreplaceall]);
   lineas.Clear;
   lineas.Add('<html>');
   lineas.Add('<body>');
   lineas.Add('<H3><font face="verdana" size="1"><a href="#indice">'+palabras+'</a></font></H3>');
   for i:=1 to ht.Count-1 do begin
      if copy(ht[i],1,2)='->' then begin
         k:=pos(chr(9),ht[i]);
         if palabras=copy(ht[i],3,k-3) then begin
            m:=(pagina-1)*itemsxpagina+i;
            for j:=1 to itemsxpagina do begin
               if j+m>ht.count-1 then break;
               if copy(ht[j+m],1,2)='->' then break;
               lineas.Add('<font face="verdana" size="1"><a href="#'+ht[j+m]+'">'+
                           ht[j+m]+'</a></font><br>');
            end;
            break;
         end;
      end;
   end;
   lineas.Add('</body>');
   lineas.Add('</html>');
   lineas.SaveToFile(salida);
   web1.Navigate(salida);
   g_borrar.Add(salida);  //--
end;
procedure Tftsbusca.comboClick(Sender: TObject);
begin
   combo.SetFocus;
   refrescapantalla;
end;
procedure Tftsbusca.carga_fuente2(biblioteca:string; fuente:string ; clase:string);
var
   buffer:Pchar;
   salida,pal:string;
   i,j,k,m:integer;
   b_mismalinea,b_califica:boolean;
   sBFile: String;
begin
   {if dm.leebfile(fuente,biblioteca,clase,buffer)=false then begin
      Application.MessageBox(pchar(dm.xlng('No existe fuente '+biblioteca+' '+fuente)),
                             pchar(dm.xlng('Búsqueda ')), MB_OK );
      exit;
   end;} // se sustituyo por sPubObtenerBFile

   sBFile := '';
   sBFile := dm.sPubObtenerBFile( fuente, biblioteca, clase );
   if sBFile = '' then begin
      Application.MessageBox(pchar(dm.xlng('No existe fuente '+biblioteca+' '+fuente)),
                             pchar(dm.xlng('Búsqueda ')), MB_OK );
      exit;
   end;

   //salida:=tsindex03+'_lineas.html';
   salida:=g_tmpdir+'\tsindex03'+'_lineas.html';
   //rich.Lines.Text:=buffer;
   rich.Lines.Text:=sBFile;
//   freemem(buffer);
   lineas.Clear;
   lineas.Add('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">');
   lineas.Add('<html xmlns="http://www.w3.org/1999/xhtml" lang="es" xml:lang="es">');
   lineas.Add('<head>');
   lineas.Add('<title height="100">Lineas</title>');
   lineas.Add('<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />');
   lineas.Add('</head>');
   lineas.Add('<body>');
   lineas.Add('<H3><CENTER ><font face="verdana" size="1"><A HREF=$'+fuente+'>'+fuente+'</A></font></CENTER></H3>');

   if ht[0]<>'Lista' then begin
      filtros.Clear;
      filtros.Add(palabra);
   end;
   for i:=0 to rich.Lines.Count-1 do begin
      b_califica:=false;
      for j:=0 to filtros.Count-1 do begin
         pal:=filtros[j];
         b_mismalinea:=((pos('@',pal)>0) or (pos('<',pal)>0));
         filtrosno.Clear;              // palabras que no deben ir en la misma linea
         if pos('<',pal)>0 then begin
            filtrosno.commatext:=stringreplace(copy(pal,pos('<',pal)+1,1000),'<',',',[rfreplaceall]);
            pal:=copy(pal,1,pos('<',pal)-1);
         end;
         if b_mismalinea then begin
            filtros2.commatext:=stringreplace(pal,'@',',',[rfreplaceall]);
            for k:=0 to filtros2.Count-1 do begin
               if pos(filtros2[k],rich.Lines[i])=0 then
                  break;
            end;
            if k=filtros2.Count then begin
               b_califica:=true;
               m:=0;
               for m:=0 to filtrosno.Count-1 do begin
                  if pos(filtrosno[m],rich.Lines[i])>0 then begin
                     b_califica:=false;
                     break;
                  end;
               end;
            end;
         end
         else begin
            if pos(pal,rich.Lines[i])>0 then begin
               b_califica:=true;
            end;
         end;
      end;
      if b_califica then begin
         lineas.Add('<font face="verdana" size="1"><A HREF="#'+inttostr(i)+'">'+inttostr(i+1)+' > '+
            stringreplace(stringreplace(rich.Lines[i],
               '>',' >',[rfreplaceall]),
               '<','< ',[rfreplaceall])+
               '</A></font><BR>');
      end;
   end;
   lineas.Add('</body>');
   lineas.Add('</html>');
   lineas.SaveToFile(salida);
   web2.Navigate(salida);
   salidaW2 := salida;
   g_borrar.Add(salida);
end;

procedure Tftsbusca.web1BeforeNavigate2(Sender: TObject;
  const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
var //b1,texto,comando:string;
   //i,j,k,m,y:integer;
   //buffer:Pchar;
   i,j,k,m:integer;
begin
   if b_esperaweb then begin
      cancel:=true;
      exit;
   end;

   b_esperaweb:=true;
   screen.Cursor:=crHourGlass;
   k:=pos('#',URL);
   m:=pos('_ind_',URL);
   if k>0 then begin
      if copy(URL,k,7)='#indice' then begin
         web_indice;
      end else
      if copy(URL,k,5)='#ind_' then begin
         paginas:=((strtoint(copy(URL,k+5,m-k-5))-1) div itemsxpagina)+1;
         lblpaginas.Caption:=' de '+inttostr(paginas);
         cmbpagina.Items.Clear;
         for i:=1 to paginas do cmbpagina.Items.Add(inttostr(i));
         cmbpagina.ItemIndex:=0;
         ypaginas.Visible:=true;
         bindice.Visible:=true;
         palabra:=copy(URL,m+5,500);
         palabra:=stringreplace(palabra,'%20',' ',[rfreplaceall]);
         web_pagina(palabra,1);
      end else
      if copy(URL,k,4)<>'#ind' then begin // Es un nombre de programa
         web2.Navigate(g_tmpdir+'\BLimpia.HTML');
         //carga_fuente2(copy(cmbbiblioteca.Text,1,pos(' - ',cmbbiblioteca.Text)-1),copy(URL,k+1,500));
        if dm.sqlselect(dm.q1,'select distinct cclase from tsprog '+
          //' where cbib='+g_q+copy(cmbbiblioteca.Text,1,pos(' - ',cmbbiblioteca.Text)-1)+g_q) then begin
          ' where cbib='+g_q+dm.descbib(cmbbiblioteca.Text)+g_q) then begin
          //bgral :=  copy(URL,k+1,500)+' '+ copy(cmbbiblioteca.Text,1,pos(' - ',cmbbiblioteca.Text)-1)+' '+
          bgral :=  copy(URL,k+1,500)+' '+ dm.descbib(cmbbiblioteca.Text)+' '+
                    dm.q1.fieldbyname('cclase').AsString;
          {Opciones := gral.ArmarMenuConceptualWeb( bgral, 'busca_componentes' );
          y:=ArmarOpciones(Opciones);
          gral.PopGral.Popup(g_X, g_Y);
           }

        end;
        //carga_fuente2(copy(cmbbiblioteca.Text,1,pos(' - ',cmbbiblioteca.Text)-1),copy(URL,k+1,500));
        carga_fuente2(dm.descbib(cmbbiblioteca.Text),copy(URL,k+1,500),dm.q1.fieldbyname('cclase').AsString);

      end;

   end;
   screen.Cursor:=crDefault;
end;

procedure Tftsbusca.web1DocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
   if trim(URL)='' then exit;
   try
      //web1.Refresh;
      //web1.Navigate(g_tmpdir+'\BLimpia.HTML');
   finally
    combo.Enabled:=true;
   end;
   b_esperaweb:=false;
end;

procedure Tftsbusca.Notepad1Click(Sender: TObject);
var salida:string;
begin
   salida:=g_tmpdir+'\texto'+formatdatetime('yyyymmddhhnnsszzz',now)+'.txt';
   rich.Lines.SaveToFile(salida);
   if ShellExecute(Handle, nil,pchar(salida),nil,nil,SW_SHOW) <= 32 then
      Application.MessageBox(pchar(dm.xlng('No puede ejecutar notepad')),
            pchar(dm.xlng('Error')), MB_ICONEXCLAMATION);
   sleep(3000);
   deletefile(salida);
end;

procedure Tftsbusca.Web2BeforeNavigate2(Sender: TObject;
  const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
var k,m,y:integer;
begin
   screen.Cursor:=crHourGlass;

   k:=pos('#',URL);
   if k>0 then begin
      k:=strtoint(copy(URL,k+1,100));
      rich.SelAttributes.Color:=clblack;
      Rich.SelStart := Rich.Perform(EM_LINEINDEX, k, 0);
      rich.Perform(EM_SCROLLCARET,0,0);
      m:=rich.Perform(EM_GETFIRSTVISIBLELINE,0,0);
      m:=k-m-10;
      rich.Perform(EM_LINESCROLL,0,m);
      rich.SelLength:=length(rich.Lines[k]);
      rich.SelAttributes.Color:=clblue;
      cancel:=true;
   end;
   k:=pos('$',URL);
   if k>0 then begin
          Opciones := gral.ArmarMenuConceptualWeb( bgral, 'busca_componentes' );
          y:=ArmarOpciones(Opciones);
          gral.PopGral.Popup(g_X, g_Y);
          web2.Navigate(salidaW2);
   end;
   screen.Cursor:=crDefault;
end;

procedure Tftsbusca.BindiceClick(Sender: TObject);
begin
   refrescapantalla;
   idxpaginas:=-1;
   web_indice(cmbpagina.Tag);
end;

procedure Tftsbusca.cmbpaginaClick(Sender: TObject);
begin
   if bindice.Visible then
      web_pagina(palabra,strtoint(cmbpagina.Text))
   else begin
      cmbpagina.Tag:=strtoint(cmbpagina.Text); // aqui se guarda la pagina del indice que se estaba consultando
      web_indice(strtoint(cmbpagina.Text));
   end;
end;

{procedure Tftsbusca.cmbbibliotecaClick(Sender: TObject);
begin
   refrescapantalla;
end;
}
procedure Tftsbusca.refrescapantalla;
begin
   //web1.Visible:=false;
   //web2.Visible:=false;
   web1.Navigate(g_tmpdir+'\BLimpia.HTML');
   web2.Navigate(g_tmpdir+'\BLimpia.HTML');
   bindice.Visible:=FALSE;
   lblpaginas.Caption:=' 0 ';
   cmbpagina.Clear;
   rich.Clear;
   refresh;
end;

procedure Tftsbusca.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   if FormStyle = fsMDIChild then
      Action := caFree;
end;

procedure Tftsbusca.bejecutaClick(Sender: TObject);
 var texto,comando,ruta,salida:string;
   i,j,k:integer;
   buffer:pchar;
   b_menos:boolean;
   buscado,mascara,sqls:string;
   archivocsv: string;
   Wselect : string;

begin
   if (g_demonio=false) and (g_busca_remoto=false) then begin
     if dm.sqlselect(dm.q1,'select fecha from tsutileria where cutileria='+g_q+'TSINDEX03'+g_q) then
         FechaTSS:=dm.q1.fieldbyname('fecha').AsString;
     if FechaTSS <> FechaTSI then begin
         dm.get_utileria('TSINDEX03',tsindex03);
         g_borrar.add(tsindex03);
     end;
   end;
   //salida:=tsindex03+'.html';
   refrescapantalla;
   Application.ProcessMessages;
   inicio:=now;

   texto:=cmbbiblioteca.Text;
   if trim(texto)='' then begin
      application.MessageBox('El campo Bibliotecas - No puede ir en blanco ',pchar(Caption),MB_OK);
      cmbbiblioteca.SetFocus;
      exit;
   end;

   texto:=combo.Text;
   if trim(texto)='' then begin
      application.MessageBox('El campo Busca - Requiere al menos de 3 caracteres',pchar(Caption),MB_OK);
      combo.SetFocus;
      exit;
   end;
   texto:=stringreplace(texto,'''','',[rfreplaceall]);
   texto:=stringreplace(texto,'"','',[rfreplaceall]);
   texto:=stringreplace(texto,':','',[rfreplaceall]);
   texto:=trim(texto);
   if length(texto)<3 then begin
      application.MessageBox('Debe ser mayor a 2 caracteres','Corregir',MB_OK);
      exit;
   end;
   i:=combo.Items.IndexOf(texto);
   if i>-1 then combo.Items.Delete(i);
   combo.Items.Insert(0,texto);
   combo.ItemIndex:=0;
   salida:=g_tmpdir+'\tsindex03_'+g_usuario+'_'+formatdatetime('YYYYMMDDHHNNSS',now);  //--
   refrescapantalla;
   combo.Text:=stringreplace(combo.Text,'%','*',[rfreplaceall]);
   buscado:=combo.Text;
   combo.Enabled:=false;
   screen.Cursor:=crsqlwait;
   deletefile(salida);
   k:=combo.Items.IndexOf(buscado);
   if k>-1 then
      combo.Items.Delete(k);
   combo.Items.Insert(0,buscado);
   combo.ItemIndex:=0;
   cmbmascara.Text:=stringreplace(cmbmascara.Text,' ','',[rfreplaceall]);
   if trim(cmbmascara.Text)='' then
      cmbmascara.Text:='*';
   mascara:=cmbmascara.Text;
   k:=cmbmascara.Items.IndexOf(mascara);
   if k>-1 then
      cmbmascara.Items.Delete(k);

   cmbmascara.Items.Insert(0,mascara);
   cmbmascara.ItemIndex:=0;

   //comando:=tsindex03+' '+dm.pathbib(copy(cmbbiblioteca.text,1,pos(' - ',cmbbiblioteca.text)-1))
   comando:=tsindex03+' '+dm.pathbib(dm.descbib(cmbbiblioteca.Text), lClase)
   +'_indi\busca '+salida+' "'+buscado+'" "'+mascara+'"';
   // Checa si trae SQL
   EditaQuery.Text:=trim(EditaQuery.Text);
   sqls:=EditaQuery.Text;
   if sqls<>'' then begin
      ///i:=cmbquery.Items.IndexOf(sqls);
      ///if i>-1 then cmbquery.Items.Delete(i);
      ///cmbquery.Items.Insert(0,sqls);
      ///cmbquery.ItemIndex:=0;
      if dm.sqlselect(dm.q1,'select distinct cclase from tsprog '+
         //' where cbib='+g_q+copy(cmbbiblioteca.Text,1,pos(' - ',cmbbiblioteca.Text)-1)+g_q) then begin
         ' where cbib='+g_q+dm.descbib(cmbbiblioteca.Text)+g_q) then begin
         comando:=comando+' "'+dm.q1.fieldbyname('cclase').AsString+'"';
      end;
      if (g_demonio=false) and (g_busca_remoto=false) then
         comando:=comando+' "'+sqls+'"'
      else
         comando:=comando+' "'+stringreplace(sqls,'''','''''',[rfreplaceall])+'"';
   end;

   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   if dm.remote_ejecuta_espera(comando,SW_HIDE,salida,buffer)=false then begin
       Application.MessageBox(pchar(dm.xlng('No puede ejecutar comando ['+comando+']')),
                              pchar(dm.xlng(sLISTA_BUSCA_COMPO)), MB_OK );
      screen.Cursor:=crDefault;   //--
      web1.Visible:=true;
      web2.Visible:=true;
      exit;
   end;
   j:=pos(':ErRoR;',buffer);      //--
   //j:=pos('<ERROR>',buffer);    //--
   if j>0 then begin             //--
       Application.MessageBox(pchar(dm.xlng(copy(buffer,j+7,120))),   //--
                              pchar(dm.xlng(sLISTA_BUSCA_COMPO)), MB_OK );
      screen.Cursor:=crDefault;   //--
      web1.Visible:=true;
      web2.Visible:=true;
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
      exit;
   end;

   Wselect := TRIM(EditaQuery.Text );
   if gral.bPubConsultaActiva( Wselect, formatdatetime('YYYY/MM/DD HH:NNSS',now) ) = FALSE then begin
      if Wselect <> '' then
          dm.PubRegistraConsultaActiva( Wselect, formatdatetime('YYYY/MM/DD HH:NNSS',now) );
   end;
   ht.text:=buffer;
   //freemem(buffer);

   if EditaQuery.Text<>'' then begin   // salida del sql
      archivocsv:=g_tmpdir+'\sql'+formatdatetime('YYYYMMDDHHNNSS',now)+'.csv';
      ht.SaveToFile(archivocsv);
      if ShellExecute(Handle, nil,pchar(archivocsv),nil, nil, SW_SHOW) <= 32 then
         Application.MessageBox(pchar(dm.xlng('No puede ejecutar '+archivocsv)),
                                pchar(dm.xlng('Error')), MB_ICONEXCLAMATION)
      else
         refrescapantalla;                          
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
      exit;
   end;


   if ht[0]='Lista' then begin    // con filtros AND, OR, NOT
      filtros.CommaText:=ht[1];
      ht[1]:=ht[1]+chr(9)+inttostr(ht.Count-3);
      ht[2]:='->'+ht[1];
   end;
   for j:=0 to ht.count-1 do begin
      ht[j]:=stringreplace(ht[j],'"','',[rfreplaceall]);
      ht[j]:=stringreplace(ht[j],'=','',[rfreplaceall]);
   end;
   idxpaginas:=-1;
   cmbpagina.Tag:=1;
   if ht.Count<2 then begin
       Application.MessageBox('Cadena no encontrada en componentes','Búsqueda  ', MB_OK );
       refrescapantalla;
   end
   else
      web_indice;
   combo.Enabled:=true;
   web1.Visible:=true;
   web2.Visible:=true;

   g_borrar.Add(salida);
   gral.PubMuestraProgresBar( False );
   screen.Cursor := crdefault;
end;

procedure Tftsbusca.cmbbibliotecaChange(Sender: TObject);
begin
   refrescapantalla;
   lClase := '';
   if dm.sqlselect(dm.q1,'select cclase from tsprog '+
//      ' where cbib='+g_q+copy(cmbbiblioteca.Text,1,pos(' - ',cmbbiblioteca.Text)-1)+g_q) then begin
      ' where cbib='+g_q+dm.descbib(cmbbiblioteca.Text)+g_q) then begin
        lClase := dm.q1.fieldbyname('cclase').AsString;
        if sqlClases.IndexOf(dm.q1.fieldbyname('cclase').AsString)>-1 then begin
         lblquery.Visible := true;
         panel6.Visible   := True;
        end else begin
         lblquery.Visible := false;
         panel6.Visible   := FALSE;
         pnlmenu.Visible  := FALSE;
         EditaQuery.text  := '';
        end;
   end
   else begin
         lblquery.Visible := false;
         panel6.Visible   := FALSE;
         pnlmenu.Visible  := FALSE;
         EditaQuery.text  := '';
   end;
end;

{
procedure Tftsbusca.cmbbibliotecaChange(Sender: TObject);
begin
   refrescapantalla;
   if dm.sqlselect(dm.q1,'select cclase from tsprog '+
      ' where cbib='+g_q+copy(cmbbiblioteca.Text,1,pos(' - ',cmbbiblioteca.Text)-1)+g_q
      //' and cclase in ('+g_q+'CBL'+g_q+','+g_q+'COS'+g_q+','+g_q+'CPY'+g_q+','+g_q+'JCL'+g_q+','+g_q+'JOB'+g_q+
      //','+g_q+'TAB'+g_q+','+g_q+'BMS'+g_q+','+g_q+'COM'+g_q+','+g_q+'REX'+g_q+','+g_q+'CTC'+g_q+
      //','+g_q+'CCT'+g_q+','+g_q+'ASE'+g_q+','+g_q+'CTR'+g_q+','+g_q+'CTM'+g_q
      // +')'
      ) then begin
        if sqlClases.IndexOf(clase)>-1 then begin
      ///
      ///if (dm.q1.fieldbyname('cclase').AsString='CBL') or
         ///(dm.q1.fieldbyname('cclase').AsString='COS') or
         ///(dm.q1.fieldbyname('cclase').AsString='CPY') or    // esta parte se quitara y la condicion se adecuara, cuando las clases las tome de tsclase
         ///(dm.q1.fieldbyname('cclase').AsString='JCL') or    // pendiente desde 22/05/2013, coordinar con Roberto para la Indexación de nvas clases.
         ///(dm.q1.fieldbyname('cclase').AsString='JOB') or then begin
      ///
         lblquery.Visible := true;
         ///cmbquery.Visible := true;
         panel6.Visible   := True;
//         cxSplitter1.Visible := true;     Fercar
//         pnlmenu.Visible  := TRUE;
         ///BtnSQL.Visible   := true;
      end
      else begin
         lblquery.Visible := false;
         ///cmbquery.Visible := false;
         panel6.Visible   := FALSE;
         pnlmenu.Visible  := FALSE;
         EditaQuery.text := '';
         ///BtnSQL.Visible   := false;
         ///cmbquery.ItemIndex := -1;
      end;
   //end;
end;

}

procedure Tftsbusca.comboChange(Sender: TObject);
var
   texto:string;
begin
   texto:=cmbbiblioteca.Text;
   if trim(texto)='' then begin
      application.MessageBox('El campo Bibliotecas - No puede ir en blanco ',pchar(Caption),MB_OK);
      cmbbiblioteca.SetFocus;
   end;
   refrescapantalla;
end;

procedure Tftsbusca.cmbmascaraChange(Sender: TObject);
begin
   refrescapantalla;
end;
function Tftsbusca.ArmarOpciones(b1:Tstringlist):integer;
 var
     mm      : Tstringlist;
begin
   mm:=Tstringlist.Create;
   mm.CommaText:=bgral;
   if mm.count < 3 then begin
      Application.MessageBox(pchar(dm.xlng('Falta Nombre ó biblioteca ó clase')),
                             pchar(dm.xlng(sLISTA_BUSCA_COMPO+' ')), MB_OK );
      mm.free;
      exit;
   end;
   //titulo:=Nombre_proc+'  '+mm[0]+' '+mm[1]+' '+mm[2];
   gral.EjecutaOpcionB (b1,'Busca Componentes');
   mm.free;

end;
procedure Tftsbusca.FormDestroy(Sender: TObject);
begin
   dm.PubEliminarVentanaActiva( Caption );

   if gral.iPubVentanasActivas in [ 0, 1 ] then
      gral.PubExpandeMenuVentanas( False );
end;

procedure Tftsbusca.FormDeactivate(Sender: TObject);
begin
   gral.PopGral.Items.Clear;
end;

function Tftsbusca.FormHelp(Command: Word; Data: Integer;var CallHelp: Boolean): Boolean;
begin
   try
      PR_BARRA;
      HtmlHelp(Application.Handle,
            PChar(Format('%s::/T%5.5d.htm',
           [Application.HelpFile,iHelpContext ])),HH_DISPLAY_TOPIC, 0);
           //[Application.HelpFile,ActiveControl.HelpContext])),HH_DISPLAY_TOPIC, 0);
      CallHelp := False;
   except
      Application.MessageBox( 'No existe ayuda para la pantalla ó campo seleccionado','Ayuda ' , MB_OK );
   end;
end;

procedure Tftsbusca.mnuAyudaClick(Sender: TObject);
  var CallHelp: Boolean;
begin
   CallHelp := False;
   try
     PR_BARRA;
     iHelpContext:=IDH_TOPIC_T01200;
      HtmlHelp(Application.Handle,
            PChar(Format('%s::/T%5.5d.htm',
           //[Application.HelpFile,ActiveControl.HelpContext])),HH_DISPLAY_TOPIC, 0);
           [Application.HelpFile,IDH_TOPIC_T01200])),HH_DISPLAY_TOPIC, 0);
     CallHelp := False;
   except
      Application.MessageBox( 'No existe ayuda para la pantalla ó campo seleccionado','Ayuda ' , MB_OK );
   end;
end;

procedure Tftsbusca.grdConsultasDBTableView1DblClick(Sender: TObject);
var
   sCaptionConsulta: String;
   sCaptionFechaHora: String;
begin
   sCaptionConsulta  := dm.tabConsultas.FindField( 'ConsultaCaption' ).AsString;
   sCaptionFechaHora := dm.tabConsultas.FindField( 'FechaHoraCaption' ).AsString;
   if gral.bPubConsultaActiva( sCaptionConsulta, sCaptionFechaHora) then
      EditaQuery.text := sCaptionConsulta ;

end;
procedure Tftsbusca.EditaQueryEnter(Sender: TObject);
begin
     EditaQuery.SelectAll;
     EditaQuery.Font.Size := 8;
     EditaQuery.Font.Name := 'MS Sans Serif';
end;


procedure Tftsbusca.cxSplitter1BeforeOpen(Sender: TObject;
  var AllowOpen: Boolean);
begin
      pnlmenu.Width := 193;
      pnlmenu.Visible := True;
end;

procedure Tftsbusca.mnuConsultasClick(Sender: TObject);
begin
   if pnlMenu.Visible then
      pnlMenu.Visible := False
   else
      pnlMenu.Visible := True;
end;

end.


