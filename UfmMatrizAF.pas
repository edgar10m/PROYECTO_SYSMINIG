unit UfmMatrizAF;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, ufmSVSLista, ComCtrls, StdCtrls, ExtCtrls, StrUtils, ShellApi,
   OleCtrls, SHDocVw, ExcelXP, ComObj, OleServer, DB, ADODB, cxStyles,
   cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage, cxEdit,
   cxDBData, dxPSGlbl, dxPSUtl, dxPSEngn, dxPrnPg, dxBkgnd, dxWrap,
   dxPrnDev, dxPSCompsProvider, dxPSFillPatterns, dxPSEdgePatterns,
   CustomizeDlg, cxGridTableView, ImgList, dxPSCore, dxPScxGridLnk,
   dxBarDBNav, dxmdaset, dxBar, cxGridLevel, cxClasses, cxControls,
   cxGridCustomView, cxGridCustomTableView, cxGridDBTableView, cxGrid, cxPC,
   dxStatusBar, cxSplitter, Buttons;

type
   TfmMatrizAF = class( TfmSVSLista )
      Panel1: TPanel;
      lbltotal: TLabel;
      cmbarchivo: TEdit;
      bmas: TButton;
      StaticText1: TStaticText;
      texto: TMemo;
      lvindice: TListView;
      CustomizeDlg1: TCustomizeDlg;
      SaveDialog1: TSaveDialog;
      textorich: TRichEdit;
      ExcelApplication1: TExcelApplication;
      cxSplitter1: TcxSplitter;
      cxSplitter2: TcxSplitter;
      //lblSistema: TLabel;
      cmbSistema: TComboBox;
    PanelTrasero: TPanel;
    Image1: TImage;
    BitBtn2: TBitBtn;
    btnEjecutar: TBitBtn;
      procedure FormCreate( Sender: TObject );
      procedure bsalirClick( Sender: TObject );
      procedure lvindiceClick( Sender: TObject );
      procedure textoDblClick( Sender: TObject );
      procedure textoClick( Sender: TObject );
      procedure cmbarchivoKeyPress( Sender: TObject; var Key: Char );
      procedure cmbarchivoExit( Sender: TObject );
      procedure cmbarchivoClick( Sender: TObject );
      procedure bmasClick( Sender: TObject );
      procedure FormDeactivate( Sender: TObject );
      procedure grdDatosDBTableView1CellClick( Sender: TcxCustomGridTableView;
         ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
         AShift: TShiftState; var AHandled: Boolean );
      procedure grdDatosDBTableView1FocusedRecordChanged(
         Sender: TcxCustomGridTableView; APrevFocusedRecord,
         AFocusedRecord: TcxCustomGridRecord;
         ANewItemRecordFocusingChanged: Boolean );
      procedure cmbSistemaChange( Sender: TObject );
      procedure cmbSistemaExit( Sender: TObject );
      procedure FormActivate( Sender: TObject );
    procedure btnEjecutarClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure grdDatosDBTableView1DblClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure cmbarchivoChange(Sender: TObject);

   private
      { Private declarations }
      filtro: string;
      cuenta: integer;
      fisicos: Tstringlist;
      xarchivo, xclase, xbib, xprogra: string;
      yclase, ybib, yprogra: string;
      zclase, zbib, zprogra: string;
      bclase, bbib, bprogra: string;
      mmodo, oorganiza: string;
      mil: integer;
      it: Tlistitem;
      Opciones: Tstringlist;
      xfisicos: Tstringlist;
      Warchivos: string;
      Wmodo: string;
      sSistema: string;
      lSistema: string;
      consultas_lista:TStringList;
      procedure panel_fantasma(visible:boolean);
   public
      { Public declarations }
      Warchivo: string;
      G_externo: string;
      tipo: string;
      titulo: String;
      function ArmarOpciones( b1: Tstringlist ): Integer;
      procedure arma( archivos: string; sistemas: string );
      procedure prepara( archivos: string; sistemas: string );
   end;
var
   fmMatrizAF: TfmMatrizAF;

implementation
uses ptsdm, ptsgral, parbol, uListaRutinas, uConstantes,ptspostrec;

{$R *.dfm}

procedure TfmMatrizAF.prepara( archivos: string; sistemas: string );
begin
   inherited;

   if ( tipo = 'FIL' ) then
      filtro := '  hcclase in (' + g_q + 'FIL' + g_q + ') ';

   Warchivos := archivos;
   cmbarchivo.Text := archivos;
   cmbsistema.Text := sistemas;
end;

procedure TfmMatrizAF.FormCreate( Sender: TObject );
begin
   inherited;

   caption := titulo;
   fisicos := Tstringlist.Create;

   if dm.sqlselect( dm.q1, 'select * from tsclase where objeto=' + g_q + 'FISICO' + g_q +
      ' order by cclase' ) then begin
      while not dm.q1.Eof do begin
         fisicos.Add( dm.q1.fieldbyname( 'cclase' ).AsString );
         dm.q1.Next;
      end;
   end;

   xfisicos := Tstringlist.Create; // para controlar el loop en agrega_fisicos

   if dm.sqlselect( DM.qmodify, 'Select * from tssistema where estadoactual = ' + g_q + 'ACTIVO' + g_q ) then begin
      cmbSistema.Items.Clear;
      cmbSistema.Items.Add( 'TODOS LOS SISTEMAS' );

      while not DM.qmodify.Eof do begin
         cmbSistema.Items.Add( DM.qmodify.fields[ 0 ].asstring );
         DM.qmodify.Next;
      end;
   end;
   panel_fantasma(false);
end;
procedure TfmMatrizAF.bsalirClick( Sender: TObject );
begin
   inherited;

   close;
end;
procedure TfmMatrizAF.lvindiceClick( Sender: TObject );
var
   i, y: integer;
begin
   inherited;

   if ( lvindice.ItemIndex = -1 ) then
      exit;

   texto.SetFocus;
   texto.SelStart := 0;
   y := 0;

   for i := 0 to lvindice.Itemindex do begin
      y := posex( Warchivo, texto.Lines.text, y + 1 );
   end;

   texto.SelStart := y - 1;
   texto.SelLength := length( Warchivo );
end;

procedure TfmMatrizAF.textoDblClick( Sender: TObject );
var
   arch: string;
begin
   inherited;

   screen.cursor := crsqlwait;
   try
      if trim( texto.Text ) = '' then
         exit;

      if pos( chr( 13 ) + chr( 10 ), texto.Text ) = 0 then // corrige cuando el fuente no tiene CR
         texto.Text := stringreplace( texto.Text, chr( 10 ), chr( 13 ) + chr( 10 ), [ rfreplaceall ] );

      arch := g_tmpdir + '\f' + formatdatetime( 'YYYYMMDDhhnnss', now ) + '.txt';
      texto.Lines.SaveToFile( arch );
      ShellExecute( 0, 'open', pchar( arch ), nil, PChar( g_tmpdir ), SW_SHOW );
      g_borrar.Add( arch );
   finally
      screen.Cursor := crdefault;
   end;
end;

procedure TfmMatrizAF.textoClick( Sender: TObject );
begin
   inherited;

   texto.setfocus;
end;

procedure TfmMatrizAF.cmbarchivoKeyPress( Sender: TObject; var Key: Char );
begin
   inherited;

   screen.cursor := crsqlwait;
   try
      if trim( cmbarchivo.Text ) = '' then
         cmbarchivo.SetFocus;

      if Key = #13 then begin
         Key := #0; { eat enter key }
         Perform( WM_NEXTDLGCTL, 0, 0 ); { move to next control }
      end;
   finally
      screen.Cursor := crdefault;
   end;
end;

procedure TfmMatrizAF.cmbarchivoExit( Sender: TObject );
begin
   {inherited;
   screen.cursor := crsqlwait;
   try
      if trim( cmbarchivo.Text ) = '' then begin
         Application.MessageBox( pchar( dm.xlng( 'El campo archivo no puede ir en blanco : ' + chr( 13 ) +
            'Ej. ' + chr( 13 ) + '     - El nombre completo del componente'
            + chr( 13 ) + '     - ABC*'
            + chr( 13 ) + '     - * (Puede tardar en mostrar resultados)' ) ),
            pchar( dm.xlng( sMATRIZ_ARCHIVOS_FIS ) ), MB_OK );
         cmbarchivo.SetFocus;
      end
      else
         arma( cmbarchivo.Text, cmbSistema.text );
   finally
      screen.Cursor := crdefault;
   end;   }
end;

procedure TfmMatrizAF.cmbarchivoClick( Sender: TObject );
begin
   inherited;

   screen.Cursor := crsqlwait;
   cmbarchivo.SetFocus;
   screen.Cursor := crdefault;
end;

procedure TfmMatrizAF.bmasClick( Sender: TObject );
begin
   inherited;

   screen.cursor := crsqlwait;
   try
      if trim( cmbArchivo.Text ) = '' then begin
         cmbArchivo.SetFocus;
         exit;
      end;

      if dm.procrunning( 'Notepad.exe' ) then
         Application.MessageBox( pchar( dm.xlng( 'Ejecutando!!!!' ) ),
            pchar( dm.xlng( sMATRIZ_ARCHIVOS_FIS ) ), MB_OK )
      else
         Application.MessageBox( pchar( dm.xlng( 'No esta Ejecutando!!!!' ) ),
            pchar( dm.xlng( sMATRIZ_ARCHIVOS_FIS ) ), MB_OK );

      SwitchDesktop( CreateDesktop( 'ClubDelphi', nil, nil, 0, MAXIMUM_ALLOWED, nil ) );
      Sleep( 12000 );
      SwitchDesktop( OpenDesktop( 'Default', 0, False, DESKTOP_SWITCHDESKTOP ) );
      // lee;   RGM para que compile, pendiente checar que soporte el volumen de datos
      exit;
   finally
      screen.Cursor := crdefault;
   end;
end;
function TfmMatrizAF.ArmarOpciones( b1: Tstringlist ): Integer;
begin
   inherited;

   gral.EjecutaOpcionB( b1, sMATRIZ_ARCHIVOS_FIS );
end;

procedure TfmMatrizAF.FormDeactivate( Sender: TObject );
begin
   inherited;

   gral.PopGral.Items.Clear;
end;

procedure TfmMatrizAF.grdDatosDBTableView1CellClick(
   Sender: TcxCustomGridTableView;
   ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
   AShift: TShiftState; var AHandled: Boolean );
var
   nitem: Tlistitem;
   i: integer;
   linea, a, b: string;
   b1: string;
   m: Tstringlist;
   archivo,sistema,prog,bib,clase,oprog,obib,oclase:string;
begin
   inherited;
   {if ( grdDatosDBTableView1.Controller.FocusedColumnIndex <> 3 ) and
      ( grdDatosDBTableView1.Controller.FocusedColumnIndex <> 7 ) then
      Exit;  }

   screen.Cursor := crsqlwait;
   try
      archivo:=trim(vartostr(grdDatosDBTableView1.Columns[ 5 ].EditValue));
      if varisnull( grdDatosDBTableView1.Columns[ 2 ].EditValue)=false then
         oclase:=trim( grdDatosDBTableView1.Columns[ 2 ].EditValue );
      if varisnull( grdDatosDBTableView1.Columns[ 3 ].EditValue )=false then
         obib:=trim( grdDatosDBTableView1.Columns[ 3 ].EditValue );
      if varisnull( grdDatosDBTableView1.Columns[ 4 ].EditValue )=false then
         oprog:=trim( grdDatosDBTableView1.Columns[ 4 ].EditValue );

      clase:=trim( grdDatosDBTableView1.Columns[ 2 ].EditValue );
      bib:=trim( grdDatosDBTableView1.Columns[ 3 ].EditValue );
      prog:=trim( grdDatosDBTableView1.Columns[ 4 ].EditValue );
      //sistema:=trim( grdDatosDBTableView1.Columns[ 17 ].EditValue );
      sistema:=trim( grdDatosDBTableView1.Columns[ 15 ].EditValue );

      if oprog<>'' then                            // Es virtual, trae el texto del físico
         dm.trae_fuente(sistema,oprog,obib,oclase,texto)
      else
         dm.trae_fuente(sistema,prog,bib,clase,texto);

      if pos( chr( 13 ) + chr( 10 ), texto.Text ) = 0 then // corrige cuando el fuente no tiene CR
         texto.Text := stringreplace( texto.Text, chr( 10 ), chr( 13 ) + chr( 10 ), [ rfreplaceall ] );

      //texto.Lines.SaveToFile('C:\Sysmining_fuentes\SysMining\tmp\texto_memo.txt');   //prueba alk para comprobar que no existe la palabra

      lvindice.Items.Clear;

      for i := 0 to texto.Lines.Count - 1 do begin
         linea := texto.Lines[ i ];

         while pos( uppercase( archivo ), uppercase( linea ) ) > 0 do begin
            nitem := lvindice.Items.Add;
            nitem.Caption := inttostr( i + 1 );
            nitem.SubItems.Add( texto.Lines[ i ] );
            linea := copy( linea, pos( uppercase( archivo ), uppercase( linea ) ) + length( archivo ), 500 );
         end;
      end;

   finally
      Warchivo := archivo;
      //m.Free;
      screen.Cursor := crdefault;
   end;
end;

procedure TfmMatrizAF.grdDatosDBTableView1FocusedRecordChanged(
   Sender: TcxCustomGridTableView; APrevFocusedRecord,
   AFocusedRecord: TcxCustomGridRecord;
   ANewItemRecordFocusingChanged: Boolean );
begin
   inherited;

   gral.PopGral.Items.Clear;
end;

procedure TfmMatrizAF.cmbSistemaChange( Sender: TObject );
var
   n: integer;
   c, cc: string;
begin
   inherited;
   if cmbSistema.ItemIndex < 1 then begin
      for n := 1 to cmbSistema.Items.Count - 1 do begin
         c := cmbSistema.items[ n ];
         if n = 1 then
            cc := c
         else
            cc := cc + '?' + c;
      end;
      cc := stringreplace( cc, '?', g_q + ',' + g_q, [ rfreplaceall ] );
      sSistema := ' sistema in(' + g_q + cc + g_q + ')';
   end
   else
      sSistema := ' sistema = ' + g_q + cmbSistema.Text + g_q;

   //btnEjecutar.Enabled:=true;
   btnEjecutar.Enabled:=false;
   cmbarchivo.Text:='';
   BitBtn2.Enabled:=true;
end;

procedure TfmMatrizAF.cmbSistemaExit( Sender: TObject );
begin
   {inherited;
   gral.PubMuestraProgresBar( True );
   screen.Cursor := crsqlwait;

   try
      if trim( cmbSistema.Text ) = '' then begin
         Application.MessageBox( pchar( dm.xlng( 'El campo Sistema no puede ir en blanco : ' + chr( 13 )
            + chr( 13 ) + '     - Debe elegir un sistema del combo'
            + chr( 13 ) + '     - Si elige - Todos los Sistemas -, '
            + chr( 13 ) + '       el proceso puede tardar varios minutos' ) ),
            pchar( dm.xlng( sMATRIZ_ARCHIVOS_FIS ) ), MB_OK );
         cmbSistema.SetFocus;
      end;
   finally
      gral.PubMuestraProgresBar( false );
      screen.Cursor := crdefault;
   end;  }
end;

procedure TfmMatrizAF.FormActivate( Sender: TObject );
begin
   inherited;
   if dm.sqlselect( DM.qmodify, 'select * from tssistema where estadoactual = ' + g_q + 'ACTIVO' + g_q ) then begin
      cmbSistema.Items.Clear;
      cmbSistema.Items.Add( 'TODOS LOS SISTEMAS' );

      while not DM.qmodify.Eof do begin
         cmbSistema.Items.Add( DM.qmodify.fields[ 0 ].asstring );
         DM.qmodify.Next;
      end;
   end;
end;
//--------------------------------------------------------------------------------------------------------------------
procedure TfmMatrizAF.arma( archivos: string; sistemas: string );
type
   Tdt=record
      archivo:string;
      occlase:string;
      ocbib:string;
      ocprog:string;
      externo:string;
      organizacion:string;
      xinput:string;
      xoutput:string;
      xi_o:string;
      xappend:string;
      xsh:string;
      xnw:string;
      xold:string;
      xmo:string;
      sistema:string;
   end;
var
   n:integer;
   c,cc:string;
   lSistema, seleccion: string;
   SSelect: string;
   repetidos,datos:Tstringlist;
   externo,utileria,organizacion,sql,input,output,i_o,sh,nw,old,mo:string;
   dt:array of Tdt;
   b_nuevo:boolean;
   rep_dcl,repe:Tstringlist;

   procedure procesa_programas(archivo,sistema,prog,bib,clase:string);
   var i,j,k,m:integer;
      paso,arch1,arch2,registro:string;
      xinput,xoutput,xorganizacion,xi_o,xappend,xsh,xnw,xold,xmo:string;
      qq:Tadoquery;
      cons:String;
   begin
      qq:=Tadoquery.Create(self);
      qq.Connection:=dm.ADOConnection1;
      //------- localiza el DCL más alto
      paso:=prog+'?'+bib+'?'+clase;
      if repe.indexof(paso)=-1 then begin
         repe.add(paso);
         cons:=  'select pcprog,pcbib,pcclase from tsrela '+
            ' where hcprog='+g_q+prog+g_q+
            ' and   hcbib='+g_q+bib+g_q+
            ' and   hcclase='+g_q+clase+g_q+
            ' and   ((pcprog<>hcprog) or (pcbib<>hcbib) or (pcclase<>hcclase)) '+
            ' and   pcprog=ocprog '+
            ' and   pcbib=ocbib '+
            ' and   pcclase=occlase';
         consultas_lista.Add(cons);
         if dm.sqlselect(qq,cons) then begin
            while not qq.Eof do begin
               procesa_programas(archivo,sistema,
                  qq.fieldbyname('pcprog').AsString,
                  qq.fieldbyname('pcbib').AsString,
                  qq.fieldbyname('pcclase').AsString);
               qq.Next;
            end;
            qq.Free;
            exit;
         end;
      end;
      paso:=paso+'?'+archivo;
      if rep_dcl.IndexOf(paso)>-1 then begin
         qq.Free;
         exit;
      end;
      rep_dcl.Add(paso);
      qq.free;
      ptspostrec.repetidos.clear;
      setlength(ptspostrec.locs,0);
      ptspostrec.lee_locs(clase,bib,prog,clase,bib,prog,clase,bib,prog);
      //ptspostrec.lista.SaveToFile(g_tmpdir+'\salida.csv');
      for i:=0 to length(ptspostrec.locs)-1 do begin        // busca en locs el archivo
         if ptspostrec.locs[i].hcprog=archivo then begin
            arch1:=ptspostrec.locs[i].prog;
            if arch1[length(arch1)]=':' then
               arch2:=copy(arch1,1,length(arch1)-1)
            else
               arch2:=arch1+':';
            for j:=0 to length(ptspostrec.locs)-1 do begin  // busca los nombres lógicos relacionados que no tengan archivo (coboles)
               if ((ptspostrec.locs[j].prog=arch1) or
                  (ptspostrec.locs[j].prog=arch2)) and
                  (ptspostrec.locs[j].hcprog='') and
                  (
                     (
                        (ptspostrec.locs[i].occlase<>'JOB') and
                        (ptspostrec.locs[i].occlase<>'JCL')
                     )
                     or
                     (
                        (ptspostrec.locs[j].scclase=ptspostrec.locs[i].scclase) and     // se agregaron por los JCLs
                        (ptspostrec.locs[j].scbib=ptspostrec.locs[i].scbib) and
                        (ptspostrec.locs[j].scprog=ptspostrec.locs[i].scprog)
                     )
                  ) then begin

                  xorganizacion:='';
                  xinput:='false';
                  xoutput:='false';
                  xi_o:='false';
                  xappend:='false';
                  xsh:='false';
                  xnw:='false';
                  xold:='false';
                  xmo:='false';
                  if ptspostrec.locs[j].modo='I' then
                     xinput:='true';
                  if ptspostrec.locs[j].modo='O' then
                     xoutput:='true';
                  if ptspostrec.locs[j].modo='U' then
                     xi_o:='true';
                  if ptspostrec.locs[j].modo='A' then
                     xi_o:='true';
                  if locs[j].organizacion='SX' then
                     xorganizacion:='SEQUENTIAL';
                  if locs[j].organizacion='IX' then
                     xorganizacion:='INDEXED';
                  if locs[j].organizacion='RX' then
                     xorganizacion:='RANDOM';
                  b_nuevo:=true;
                  for m:=0 to length(dt)-1 do begin   // Checa que no sea programa repetido
                     if (dt[m].archivo=archivo) and
                        (dt[m].occlase=ptspostrec.locs[j].occlase) and
                        (dt[m].ocbib=ptspostrec.locs[j].ocbib) and
                        (dt[m].ocprog=ptspostrec.locs[j].ocprog) then begin
                        if dt[m].externo='' then
                           dt[m].externo:=ptspostrec.locs[j].externo;
                        if dt[m].organizacion='' then
                           dt[m].organizacion:=xorganizacion;
                        if xinput='true' then
                           dt[m].xinput:='true';
                        if xoutput='true' then
                           dt[m].xoutput:='true';
                        if xi_o='true' then
                           dt[m].xi_o:='true';
                        if xappend='true' then
                           dt[m].xappend:='true';
                        b_nuevo:=false;
                        break;
                     end;
                  end;
                  if b_nuevo then begin
                     k:=length(dt);
                     setlength(dt,k+1);
                     dt[k].archivo:=archivo;
                     dt[k].occlase:=ptspostrec.locs[j].occlase;
                     dt[k].ocbib:=ptspostrec.locs[j].ocbib;
                     dt[k].ocprog:=ptspostrec.locs[j].ocprog;
                     dt[k].externo:=ptspostrec.locs[j].externo;
                     dt[k].organizacion:=xorganizacion;
                     dt[k].xinput:=xinput;
                     dt[k].xoutput:=xoutput;
                     dt[k].xi_o:=xi_o;
                     dt[k].xappend:=xappend;
                     dt[k].xsh:=xsh;
                     dt[k].xnw:=xnw;
                     dt[k].xold:=xold;
                     dt[k].xmo:=xmo;
                     dt[k].sistema:=sistema;
                  end;
               end;
            end;
         end;
      end;
   end;
   // genera DCL-FIL
   procedure procesa_padres(archivo,prog,bib,clase,externo,utileria,organizacion,sql,input,output,i_o,sh,nw,old,mo:string);
   var
      qq:Tadoquery;
      llave,llave_ant,cons:string;
      xexterno,xutileria,xorganizacion,xsql,xinput,xoutput,xi_o,xappend,xsh,xnw,xold,xmo:string;
      oclase,obib,oprog:string;
   begin
      llave_ant:='';
      qq:=Tadoquery.Create(self);
      qq.Connection:=dm.ADOConnection1;
      cons:= 'select distinct occlase,ocbib,ocprog,hcclase,hcbib,hcprog,externo,organizacion,modo,sistema from tsrela ' +
         ' where hcprog='+g_q+prog+g_q+
         ' and   hcbib='+g_q+bib+g_q+
         ' and   hcclase='+g_q+clase+g_q+
         ' and   pcclase<>' + g_q + 'CLA' + g_q +
         ' order by occlase,ocbib,ocprog';
      consultas_lista.add(cons);
      if dm.sqlselect( qq, cons ) then begin
         while not qq.Eof do begin
            llave:=archivo+'<>'+
               qq.FieldByName('ocprog').AsString+'<>'+
               qq.FieldByName('ocbib').AsString+'<>'+
               qq.FieldByName('occlase').AsString;
            if (llave<>llave_ant) then begin
               if (llave_ant<>'') then begin
                  Datos.Add('"'+archivo+'"'+','+
                     '"'+oclase+'"'+','+
                     '"'+obib+'"'+','+
                     '"'+oprog+'"'+','+
                     //'"'+qq.FieldByName('pcclase').AsString+'"'+','+
                     //'"'+qq.FieldByName('pcbib').AsString+'"'+','+
                     //'"'+qq.FieldByName('pcprog').AsString+'"'+','+
                     '"'+xexterno+'"'+','+
                     //'"'+xutileria+'"'+','+
                     //'"'+oclase+'"'+','+
                     //'"'+obib+'"'+','+
                     //'"'+oprog+'"'+','+
                     '"'+xorganizacion+'"'+','+
                     //'"'+xsql+'"'+','+
                     '"'+xinput+'"'+','+
                     '"'+xoutput+'"'+','+
                     '"'+xi_o+'"'+','+
                     '"'+xappend+'"'+','+
                     '"'+xsh+'"'+','+
                     '"'+xnw+'"'+','+
                     '"'+xold+'"'+','+
                     '"'+xmo+'"'+','+
                     '"'+qq.FieldByName('sistema').AsString+'"');
                  repe.Clear;
                  procesa_programas(archivo,qq.FieldByName('sistema').AsString,oprog,obib,oclase);
               end;
               llave_ant:=llave;
               xexterno:='';
               xutileria:='';
               xorganizacion:='';
               xsql:='';
               xinput:='false';
               xoutput:='false';
               xi_o:='false';
               xappend:='false';
               xsh:=sh;
               xnw:=nw;
               xold:=old;
               xmo:=mo;
               oprog:='';
               obib:='';
               oclase:='';
               xutileria:='';
               oprog:=qq.FieldByName('ocprog').AsString;
               obib:=qq.FieldByName('ocbib').AsString;
               oclase:=qq.FieldByName('occlase').AsString;
               if qq.FieldByName('externo').AsString<>'' then
                  xexterno:=qq.FieldByName('externo').AsString;
               if qq.FieldByName('organizacion').AsString='SX' then
                  xorganizacion:='SEQUENTIAL';
               if qq.FieldByName('organizacion').AsString='IX' then
                  xorganizacion:='INDEXED';
               if qq.FieldByName('organizacion').AsString='RX' then
                  xorganizacion:='RANDOM';
            end;
            if qq.FieldByName('modo').AsString='I' then
               xinput:='true';
            if qq.FieldByName('modo').AsString='O' then
               xoutput:='true';
            if qq.FieldByName('modo').AsString='A' then
               xappend:='true';
            if qq.FieldByName('modo').AsString='U' then
               xi_o:='true';
            if qq.FieldByName('modo').AsString='NEW' then
               xnw:='true';
            if qq.FieldByName('modo').AsString='OLD' then
               xold:='true';
            if qq.FieldByName('modo').AsString='SHR' then
               xsh:='true';
            if qq.FieldByName('modo').AsString='MOD' then
               xmo:='true';
            //if (qq.FieldByName('ocprog').AsString<>qq.FieldByName('pcprog').AsString) or
            //   (qq.FieldByName('ocbib').AsString<>qq.FieldByName('pcbib').AsString) or
            //   (qq.FieldByName('occlase').AsString<>qq.FieldByName('pcclase').AsString) then begin
            //end;
            {
            procesa_padres(archivo,
               qq.FieldByName('pcprog').AsString,
               qq.FieldByName('pcbib').AsString,
               qq.FieldByName('pcclase').AsString,
               xexterno,xutileria,xorganizacion,xsql,xinput,xoutput,xi_o,xsh,xnw,xold,xmo);
            }
            qq.Next;
         end;
      end;
      if (llave_ant<>'') then begin
         Datos.Add('"'+archivo+'"'+','+
            '"'+oclase+'"'+','+
            '"'+obib+'"'+','+
            '"'+oprog+'"'+','+
            //'"'+qq.FieldByName('pcclase').AsString+'"'+','+
            //'"'+qq.FieldByName('pcbib').AsString+'"'+','+
            //'"'+qq.FieldByName('pcprog').AsString+'"'+','+
            '"'+xexterno+'"'+','+
            //'"'+xutileria+'"'+','+
            //'"'+oclase+'"'+','+
            //'"'+obib+'"'+','+
            //'"'+oprog+'"'+','+
            '"'+xorganizacion+'"'+','+
            //'"'+xsql+'"'+','+
            '"'+xinput+'"'+','+
            '"'+xoutput+'"'+','+
            '"'+xi_o+'"'+','+
            '"'+xappend+'"'+','+
            '"'+xsh+'"'+','+
            '"'+xnw+'"'+','+
            '"'+xold+'"'+','+
            '"'+xmo+'"'+','+
            '"'+qq.FieldByName('sistema').AsString+'"');
         repe.Clear;
         procesa_programas(archivo,qq.FieldByName('sistema').AsString,oprog,obib,oclase);
      end;
      qq.Free;
   end;

   // ----- Procedimiento para mostrar detalle del primer dato ------
   function muestraPrimerDato ():boolean;
      var
      nitem: Tlistitem;
      i: integer;
      linea, a, b: string;
      b1: string;
      m: Tstringlist;
      archivo,sistema,prog,bib,clase,oprog,obib,oclase:string;
   begin
      inherited;
      screen.Cursor := crsqlwait;
      try
         archivo:=trim(vartostr(grdDatosDBTableView1.Columns[ 5 ].EditValue));
         if varisnull( grdDatosDBTableView1.Columns[ 2 ].EditValue)=false then
            oclase:=trim( grdDatosDBTableView1.Columns[ 2 ].EditValue );
         if varisnull( grdDatosDBTableView1.Columns[ 3 ].EditValue )=false then
            obib:=trim( grdDatosDBTableView1.Columns[ 3 ].EditValue );
         if varisnull( grdDatosDBTableView1.Columns[ 4 ].EditValue )=false then
            oprog:=trim( grdDatosDBTableView1.Columns[ 4 ].EditValue );

         clase:=trim( grdDatosDBTableView1.Columns[ 2 ].EditValue );
         bib:=trim( grdDatosDBTableView1.Columns[ 3 ].EditValue );
         prog:=trim( grdDatosDBTableView1.Columns[ 4 ].EditValue );
//         sistema:=trim( grdDatosDBTableView1.Columns[ 17 ].EditValue );
         sistema:=trim( grdDatosDBTableView1.Columns[ 15 ].EditValue );

         if oprog <> '' then                            // Es virtual, trae el texto del físico
            dm.trae_fuente(sistema,oprog,obib,oclase,texto)
         else
            dm.trae_fuente(sistema,prog,bib,clase,texto);

         if texto.Text='' then begin
            Result:=false;
            exit;
         end;

         if pos( chr( 13 ) + chr( 10 ), texto.Text ) = 0 then // corrige cuando el fuente no tiene CR
            texto.Text := stringreplace( texto.Text, chr( 10 ), chr( 13 ) + chr( 10 ), [ rfreplaceall ] );

         lvindice.Items.Clear;

         for i := 0 to texto.Lines.Count - 1 do begin
            linea := texto.Lines[ i ];

            while pos( uppercase( archivo ), uppercase( linea ) ) > 0 do begin
               nitem := lvindice.Items.Add;
               nitem.Caption := inttostr( i + 1 );
               nitem.SubItems.Add( texto.Lines[ i ] );
               linea := copy( linea, pos( uppercase( archivo ), uppercase( linea ) ) + length( archivo ), 500 );
            end;
         end;
         Result:=true;
      finally
         Warchivo := archivo;
         screen.Cursor := crdefault;
      end;
   end;
   // ---------------------------------------------------------------
begin
   inherited;
   screen.Cursor := crsqlwait;
   setlength(dt,0);
   try
      ptspostrec.lista:=Tstringlist.create;
      ptspostrec.repetidos:=Tstringlist.Create;
      rep_dcl:=Tstringlist.create;
      repe:=Tstringlist.create;
      caption := titulo;
      lSistema := '';
      if ( trim( archivos ) = '' ) or ( trim( sistemas ) = '' ) then
         exit;

      archivos := stringreplace( archivos, '*', '%', [ rfreplaceall ] );

      if sistemas = 'TODOS LOS SISTEMAS' then begin
         for n := 1 to cmbSistema.Items.Count - 1 do begin
            c := cmbSistema.items[ n ];
            if n = 1 then
               cc := c
            else
               cc := cc + '?' + c;
         end;
         cc := stringreplace( cc, '?', g_q + ',' + g_q, [ rfreplaceall ] );
         lSistema := ' and sistema in(' + g_q + cc + g_q + ')';
      end
      else if Trim( sistemas ) <> '' then begin
         lSistema := ' and  sistema = ' + g_q + sistemas + g_q
      end;

      if archivos = '%' then
         //seleccion := ' where '
         sSelect := 'select hcprog,hcbib,hcclase, sistema from tsrela where hcclase = ' + g_q + 'FIL' + g_q +
            lSistema +
            ' group by hcprog,hcbib,hcclase, sistema order by hcprog, sistema'
      else begin
         sSelect := 'select hcprog,hcbib,hcclase, sistema from tsrela where hcclase = ' + g_q + 'FIL' + g_q +
            'and  hcprog like ' + g_q + archivos + g_q +
            lSistema +
            ' group by hcprog,hcbib,hcclase, sistema order by hcprog, sistema';
      end;

      rep_dcl.clear;
      consultas_lista.Add(sSelect);
      if dm.sqlselect( dm.q1, sSelect ) then begin
         screen.Cursor := crsqlwait;
         stbLista.Panels[ 0 ].Text := ''; //limpia count de registros
         Datos := Tstringlist.create;
         Datos.Delimiter := ',';
         repetidos:=Tstringlist.create;
         sql:='false';
         input:='false';
         output:='false';
         i_o:='false';
         sh:='false';
         nw:='false';
         old:='false';
         mo:='false';
         while not DM.q1.Eof do begin
            archivos := dm.q1.FieldByName( 'hcprog' ).AsString;
            Warchivos := archivos;
            {
            if pos( '%', archivos ) > 0 then
               seleccion := ' where hcprog like ' + g_q + archivos + g_q + ' AND '
            else
               seleccion := ' where hcprog=' + g_q + archivos + g_q + ' AND ';
            }
            consultas_lista.add(archivos);
            procesa_padres(dm.q1.FieldByName('hcprog').AsString,  // genera DCL-FIL
               dm.q1.FieldByName('hcprog').AsString,
               dm.q1.FieldByName('hcbib').AsString,
               dm.q1.FieldByName('hcclase').AsString,
               externo,utileria,organizacion,sql,input,output,i_o,sh,nw,old,mo);
            dm.q1.next;
         end;
         for n:=0 to length(dt)-1 do begin
            datos.add('"'+dt[n].archivo+'"'+','+
               '"'+dt[n].occlase+'"'+','+
               '"'+dt[n].ocbib+'"'+','+
               '"'+dt[n].ocprog+'"'+','+
               '"'+dt[n].externo+'"'+','+
               '"'+dt[n].organizacion+'"'+','+
               '"'+dt[n].xinput+'"'+','+
               '"'+dt[n].xoutput+'"'+','+
               '"'+dt[n].xi_o+'"'+','+
               '"'+dt[n].xappend+'"'+','+
               '"'+dt[n].xsh+'"'+','+
               '"'+dt[n].xnw+'"'+','+
               '"'+dt[n].xold+'"'+','+
               '"'+dt[n].xmo+'"'+','+
               '"'+dt[n].sistema+'"');
         end;
         Datos.Insert(0, 'Archivo:String:250,'+
            'Tipo:String:20,'+
            'Libreria:String:250,' +
            'Componente:String:250,'+
            'Logico:String:250,' +
            //'Utileria:String:250,' +
            //'Tipo2:String:20,'+
            //'Libreria2:String:250,' +
            //'Contenedor:String:250,'+
            'Organizacion:String:250,' +
            //'Sql:Boolean:0,' +
            'Input:Boolean:0,'+
            'Output:Boolean:0,'+
            'I_O:Boolean:0,' +
            'Append:Boolean:0,'+
            'Shr:Boolean:0,'+
            'New:Boolean:0,'+
            'Old:Boolean:0,'+
            'Mod:Boolean:0,'+
            'Sistema:String:30' );

         if tabDatos.Active then //fercar
            tabDatos.Active := False;
         GlbQuitarFiltrosGrid( grdDatosDBTableView1 );
         if bGlbPoblarTablaMem( Datos, tabDatos ) then begin
            tabDatos.ReadOnly := True;

            GlbHabilitarOpcionesMenu( mnuPrincipal, tabDatos.RecordCount > 0 );
            GlbCrearCamposGrid( grdDatosDBTableView1 );
            grdDatosDBTableView1.ApplyBestFit( );

            //necesario para la busqueda //fercar
            //en este caso usar grEspejo para apoyarse en las busquedas y llenar slPublista
            GlbCrearCamposGrid( grdEspejoDBTableView1 );
            GlbCargarLista( grdEspejo, grdEspejoDBTableView1, slPubLista );
            //fin necesario para la busqueda

            stbLista.Panels[ 0 ].Text := IntToStr( tabDatos.RecordCount ) + ' Registros';

            if Visible = True then begin
               panel_fantasma(true);
               GlbFocusPrimerItemGrid( grdDatos, grdDatosDBTableView1 );
            end;

         end;

         // ------- Procedimiento para que muestre la informacion del primer dato ----
         if not muestraPrimerDato then  // si no pudo mostrar el primer dato, poner un panel
            if alkDocumentacion <> 1 then
               showMessage('Seleccione para obtener informacion');  //cambiar!!!
         // --------------------------------------------------------------------------
         Datos.free;
         repetidos.free;
      end
      else begin
         Application.MessageBox( pchar( dm.xlng( 'No existe información a procesar.' ) ),
            pchar( dm.xlng( sMATRIZ_ARCHIVOS_FIS ) ), MB_OK );
         panel_fantasma(false);
      end;
   finally
      ptspostrec.repetidos.Free;
      ptspostrec.lista.Free;
      rep_dcl.free;
      repe.Free;
      screen.Cursor := crdefault;
   end;
end;

procedure TfmMatrizAF.btnEjecutarClick(Sender: TObject);
begin
  inherited;
   // validando
   screen.cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   consultas_lista:=TStringList.create;
   try
      if trim( cmbSistema.Text ) = '' then begin
         Application.MessageBox( pchar( dm.xlng( 'El campo Sistema no puede ir en blanco : ' + chr( 13 )
            + chr( 13 ) + '     - Debe elegir un sistema del combo'
            + chr( 13 ) + '     - Si elige - Todos los Sistemas -, '
            + chr( 13 ) + '       el proceso puede tardar varios minutos' ) ),
            pchar( dm.xlng( sMATRIZ_ARCHIVOS_FIS ) ), MB_OK );
         cmbSistema.SetFocus;
      end;

      if (trim( cmbarchivo.Text ) = '') or (trim( cmbarchivo.Text ) = '*') then begin
         if Application.MessageBox( pchar('El proceso puede tardar varios minutos.'+ chr( 13 ) +
                                    '¿Desea continuar sin algun filtro en el campo Archivo?' ),
                                    'Aviso', MB_YESNO ) <> IDYES then begin
            cmbarchivo.setfocus;
            exit;
         end;
         cmbarchivo.Text:='*';
      end;

      panel_fantasma(false);

      arma( cmbarchivo.Text, cmbSistema.text );
   finally
      screen.Cursor := crdefault;
      gral.PubMuestraProgresBar( false );

      consultas_lista.SaveToFile(g_tmpdir+'/ALKborrar_MatrizAF.txt');
      consultas_lista.Free;
   end;
end;

procedure TfmMatrizAF.FormResize(Sender: TObject);
var
   tam : integer;
begin
   inherited;
   tam:=180;

   if cmbSistema.width < 350 then
      cmbsistema.width:=350
   else
      cmbsistema.width:=Panel1.Width-tam;
end;

procedure TfmMatrizAF.panel_fantasma(visible:boolean);
begin
   //---------- para ocultar elementos inferiores y dejar panel fantasma  ---------   ALK
   tabLista.Visible:=visible;
   stbLista.Visible:=visible;
   cxSplitter1.Visible:=visible;
   texto.Visible:=visible;
   cxSplitter2.Visible:=visible;
   lvindice.Visible:=visible;
   //lv.Visible:=false;
   
   if gral.bPubVentanaMaximizada = FALSE then begin
      Height := 600;    //para mostrar el grid de resultados  ALK
      //HorzScrollBar.Visible:=visible;
   end;
   // -----------------------------------------------------------------------------
end;

procedure TfmMatrizAF.grdDatosDBTableView1DblClick(Sender: TObject);
var
   sistema,prog,bib,clase:string;
begin
   inherited;
   if ( grdDatosDBTableView1.Controller.FocusedColumnIndex <> 3 ) and
      ( grdDatosDBTableView1.Controller.FocusedColumnIndex <> 7 ) then
      Exit;

   screen.Cursor := crsqlwait;
   try
      clase:=trim( grdDatosDBTableView1.Columns[ 2 ].EditValue );
      bib:=trim( grdDatosDBTableView1.Columns[ 3 ].EditValue );
      prog:=trim( grdDatosDBTableView1.Columns[ 4 ].EditValue );
//      sistema:=trim( grdDatosDBTableView1.Columns[ 17 ].EditValue );
      sistema:=trim( grdDatosDBTableView1.Columns[ 15 ].EditValue );

      Opciones := gral.ArmarMenuConceptualWeb( prog + ' ' + bib + ' ' + clase + ' ' + sistema, 'archivo_fisico' );
      ArmarOpciones( Opciones );
      gral.PopGral.Popup( g_X, g_Y );
      //---------------

   finally
      screen.Cursor := crdefault;
   end;
end;

procedure TfmMatrizAF.BitBtn2Click(Sender: TObject);
begin
   cmbsistema.SetFocus;
   btnEjecutar.Enabled:=false;
   panel_fantasma(false);
   cmbsistema.Clear;
   cmbarchivo.Text:='';
   BitBtn2.Enabled:=false;

   if dm.sqlselect( DM.qmodify, 'select * from tssistema where estadoactual = ' + g_q + 'ACTIVO' + g_q ) then begin
      cmbSistema.Items.Clear;
      cmbSistema.Items.Add( '- Todos los sistemas -' );

      while not DM.qmodify.Eof do begin
         cmbSistema.Items.Add( DM.qmodify.fields[ 0 ].asstring );
         DM.qmodify.Next;
      end;
   end;
   
   BitBtn2.Enabled:=false;
end;

procedure TfmMatrizAF.cmbarchivoChange(Sender: TObject);
begin
   inherited;
   if trim(cmbarchivo.Text) <> '' then begin
      btnEjecutar.Enabled:=true;
      panel_fantasma(false);
   end
   else begin
      btnEjecutar.Enabled:=false;
   end;
end;

end.

