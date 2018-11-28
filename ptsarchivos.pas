unit ptsarchivos;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons, strutils, shellapi, Menus,
   ADOdb, OleCtrls, SHDocVw, ExcelXP, ComObj, OleServer, ImgList, dxBar, Excel97,
  CustomizeDlg;

type
   Tftsarchivos = class( TForm )
      lv: TListView;
      Panel1: TPanel;
      SaveDialog1: TSaveDialog;
      Splitter1: TSplitter;
      lvindice: TListView;
      Splitter2: TSplitter;
      cmbarchivo: TEdit;
      lbltotal: TLabel;
      bmas: TButton;
      PopupMenu1: TPopupMenu;
      Editarcopia1: TMenuItem;
      textorich: TRichEdit;
      texto: TMemo;
      web: TWebBrowser;
      ExcelApplication1: TExcelApplication;
      StaticText1: TStaticText;
      mnuPrincipal: TdxBarManager;
      mnuImprimir: TdxBarButton;
      mnuExportar: TdxBarButton;
      CustomizeDlg1: TCustomizeDlg;
      procedure bexportarClick( Sender: TObject );
      procedure FormCreate( Sender: TObject );
      procedure bsalirClick( Sender: TObject );
      procedure lvClick( Sender: TObject );
      procedure lvindiceClick( Sender: TObject );
      procedure textoDblClick( Sender: TObject );
      procedure textoClick( Sender: TObject );
      procedure cmbarchivoKeyPress( Sender: TObject; var Key: Char );
      procedure cmbarchivoExit( Sender: TObject );
      procedure cmbarchivoClick( Sender: TObject );
      procedure bmasClick( Sender: TObject );
      procedure creaweb( );
      procedure crea_web( );
      procedure webBeforeNavigate2( Sender: TObject; const pDisp: IDispatch;
         var URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
         var Cancel: WordBool );
      procedure webDocumentComplete( Sender: TObject; const pDisp: IDispatch;
         var URL: OleVariant );
      procedure ImpWebClick( Sender: TObject );
      procedure WebPreviewPrint( web: TWebBrowser );
      procedure FormClose( Sender: TObject; var Action: TCloseAction );
      procedure FormDestroy(Sender: TObject);
      procedure webProgressChange(Sender: TObject; Progress, ProgressMax: Integer);
      procedure mnuImprimirClick(Sender: TObject);
      procedure mnuExportarClick(Sender: TObject);
      procedure FormDeactivate(Sender: TObject);


   private
      { Private declarations }
      filtro: string;
      cuenta: integer;
      fisicos: Tstringlist;
      xarchivo, xclase, xbib, xprogra: string;
      yclase, ybib, yprogra: string;
      zclase, zbib, zprogra: string;
      bclase, bbib, bprogra: string;
      mmodo,oorganiza : string;
      mil: integer;
      it: Tlistitem;
      b_impresion: boolean;
      Opciones: Tstringlist;
      xfisicos: Tstringlist;
      WnomLogo: string;
      Warchivos: string;
      Wmodo: string;
//      procedure agrega( archivo: string; clase: string; bib: string; progra: string; modo: string; externo: string ); // it:Tlistitem);
//    procedure agrega_fisico( archivo: string; clase: string; bib: string; progra: string; modo: string; externo: string );
      procedure agrega( archivo: string;  jclase: string;  jbib: string;  jprogra: string;  sclase: string;  sbib: string;  sprogra: string;
          uclase: string;  ubib: string;  uprogra: string;  XXclase: string;  XXbib: string;  XXprogra: string;  organiza: string; modo: string;  externo: string );
      procedure agrega_fisico( archivo: string; Jclase:  string; Jbib: string; Jprogra: string;
          Sclase : string; Sbib: string; Sprogra: string; Uclase:  string; Ubib: string; Uprogra: string;
          XXclase:  string; XXbib: string; XXprogra: string; organiza: string; modo: string; externo : string );

      procedure lee;
      procedure LeeDos;
      procedure LeeTres;
   public
      { Public declarations }
      Warchivo : string;
      G_externo : string;
      tipo: string;
      titulo: String;
      function ArmarOpciones(b1:Tstringlist):Integer;
      procedure arma( archivos: string );
      procedure prepara( archivos: string );
   end;
var
   ftsarchivos: Tftsarchivos;

implementation
uses ptsdm, isvsserver1, ptsgral, parbol;
{$R *.dfm}

procedure Tftsarchivos.bexportarClick( Sender: TObject );
var
   i, ii, j: integer;
   Libro: _WORKBOOK;
   Hoja: _WORKSHEET;
begin
   j := 5;
   Libro := ExcelApplication1.Workbooks.Add( Null, 0 );
   Hoja := Libro.Sheets[ 1 ] as _WORKSHEET;
   Hoja.Cells.Item[ 2, 1 ] := trim( g_empresa );
   Hoja.Cells.Item[ 2, 1 ].font.size := 10;
   Hoja.Cells.Item[ 3, 1 ] := 'Matriz Archivos Físicos: ' + lv.items[ 0 ].caption;
   Hoja.Cells.Item[ 3, 1 ].font.size := 9;
   Hoja.Cells.Item[ 2, 1 ].Font.Bold := True;
   Hoja.Cells.Item[ 3, 1 ].Font.Bold := True;
   Hoja.Cells.Item[ 4, 1 ].Font.Bold := True;

   for ii := 0 to lv.Columns.Count - 1 do begin
      Hoja.Cells.Item[ j, ii + 1 ] := lv.columns[ ii ].caption;
      Hoja.Cells.Item[ j, ii + 1 ].Font.Bold := True;
   end;

   j := j + 1;

   for i := 0 to lv.items.Count - 1 do begin
      Hoja.Cells.Item[ j, 1 ] := lv.items[ i ].caption;
      Hoja.Cells.Item[ j, 1 ].Font.Bold := True;

      for ii := 1 to lv.items.item[ i ].subitems.Count do begin
         Hoja.Cells.Item[ j, ii + 1 ] := lv.items.item[ i ].subitems[ ii - 1 ];
      end;
      j := j + 1;
   end;
   ExcelApplication1.Visible[ 1 ] := true;
end;

procedure Tftsarchivos.prepara( archivos: string );
begin
   if (tipo = 'FIL') then
      //filtro := '  hcclase in (' + g_q + 'FIL' + g_q +','+ g_q +'LOC' + g_q +') '
      filtro := '  hcclase in (' + g_q + 'FIL' + g_q +') ';
//   if archivos <> '' then
     Warchivos := archivos ;
//   else
//      Warchivos := '';
   cmbarchivo.Text := archivos;
end;

procedure Tftsarchivos.FormCreate( Sender: TObject );
begin
   mnuPrincipal.Style := gral.iPubEstiloActivo;
   caption := titulo;
   if g_language = 'ENGLISH' then begin
      caption := 'File Usage';
      lv.Column[ 0 ].Caption := 'File';
      lv.Column[ 1 ].Caption := 'Class';
      lv.Column[ 2 ].Caption := 'Library';
      lv.Column[ 3 ].Caption := 'Component';
   end;
   gral.CargaRutinasjs( );
   WnomLogo := 'CR' + formatdatetime( 'YYYYMMDDHHNNSSZZZZ', now );
   gral.CargaLogo( WnomLogo );
   gral.CargaIconosBasicos( );

   //htt.WSDLLocation := g_ruta + 'IsvsServer.xml';
   fisicos := Tstringlist.Create;
   if dm.sqlselect( dm.q1, 'select * from tsclase where objeto=' + g_q + 'FISICO' + g_q + ' and  estadoactual = '+ g_q + 'ACTIVO' + g_q +
      ' order by cclase' ) then begin
      while not dm.q1.Eof do begin
         fisicos.Add( dm.q1.fieldbyname( 'cclase' ).AsString );
         dm.q1.Next;
      end;
   end;
   xfisicos := Tstringlist.Create; // para controlar el loop en agrega_fisicos

  if gral.iPubVentanasActivas > 0 then
      gral.PubExpandeMenuVentanas( True );
end;

//procedure Tftsarchivos.agrega( archivo: string; clase: string; bib: string;
//   progra: string; modo: string; externo: string );
procedure Tftsarchivos.agrega( archivo: string;  jclase: string;  jbib: string;  jprogra: string;  sclase: string;  sbib: string;  sprogra: string;
          uclase: string;  ubib: string;  uprogra: string;  XXclase: string;  XXbib: string;  XXprogra: string;  organiza: string; modo: string;  externo: string );
begin
    if (( archivo <> xarchivo ) or
      ( jclase <> xclase ) or
      ( jbib <> xbib ) or
      ( jprogra <> xprogra ) or
      ( sclase <> yclase ) or
      ( sbib <> ybib ) or
      ( sprogra <> yprogra ) or
      ( uclase <> zclase ) or
      ( ubib <> zbib ) or
      ( uprogra <> zprogra ) or
      ( XXclase <> bclase ) or
      ( XXbib <> bbib ) or
      ( XXprogra <> bprogra ) or
      ( (modo <> mmodo) and (modo <> null) ) or
      ( (organiza <> oorganiza) and (organiza <> null))
       )
      or
      (( archivo <> xarchivo ) or
      ( jclase <> xclase ) or
      ( jbib <> xbib ) or
      ( jprogra <> xprogra ) or
      ( sclase <> yclase ) or
      ( sbib <> ybib ) or
      ( sprogra <> yprogra ) or
      ( XXclase <> bclase ) or
      ( XXbib <> bbib ) or
      ( XXprogra <> bprogra ) or
      ( (modo <> mmodo) and (modo <> null) ) or
      ( (organiza <> oorganiza) and (organiza <> null))
       )
      then begin
      if mil > 1000 then begin
         lbltotal.Caption := 'Total  ' + inttostr( dm.q1.RecordCount ) + '  (1 - ' + inttostr( cuenta ) + ')';
         bmas.Visible := false; //true;
         mil:=0;
         exit;
      end;

      it := lv.Items.Add;
      it.Caption := archivo;
      it.SubItems.Add( jclase );
      it.SubItems.Add( jbib );
      it.SubItems.Add( jprogra );
      it.SubItems.Add( sprogra );
      it.SubItems.Add( uprogra );
      it.SubItems.Add( XXclase );
      it.SubItems.Add( XXbib );
      it.SubItems.Add( XXprogra );
      it.SubItems.Add( organiza );
      it.SubItems.Add( ' ' );
      it.SubItems.Add( ' ' );
      it.SubItems.Add( ' ' );
      it.SubItems.Add( ' ' );
      it.SubItems.Add( ' ' );
      it.SubItems.Add( ' ' );
      it.SubItems.Add( ' ' );
      it.SubItems.Add( ' ' );

      xarchivo := archivo;
      xclase   := jclase;
      xbib     := jbib;
      xprogra  := jprogra;
      yclase   := sclase;
      ybib     := sbib;
      yprogra  := sprogra;
      zclase   := uclase;
      zbib     := ubib;
      zprogra  := uprogra;
      bclase   := XXclase;
      bbib     := XXbib;
      bprogra  := XXprogra;
      oorganiza:= organiza;
      mmodo    := modo;
    end;

   if ( organiza = 'OX' )  then
      it.SubItems[ 8 ] := 'SALIDA'
   else if ( organiza = 'RX' )  then
      it.SubItems[ 8 ] := 'RELATIVO'
   else if ( organiza = 'SX' )  then
      it.SubItems[ 8 ] := 'SECUENCIAL'
   else if ( organiza = 'X' )   then
      it.SubItems[ 8 ] := 'No definido'
   else if ( organiza = 'IX' )  then
      it.SubItems[ 8] := 'INDEXADO'
   else if ( organiza = 'EXP') or ( organiza = 'EXPAND')  then
      it.SubItems[ 8] := '';
;

 //  if ( modo = 'FIL' )  then
//     it.SubItems[ 3 ] := 'X'
//   else
   if ( modo = 'S' )  then
      it.SubItems[ 9 ] := 'X'
   else if ( modo = 'I' )  then
      it.SubItems[ 10 ] := 'X'
   else if ( modo = 'O' )  then
      it.SubItems[ 11 ] := 'X'
   else if ( modo = 'A' ) or (modo = 'U')  then
      it.SubItems[ 12 ] := 'X'
   else if ( modo = 'SHR' )  then
      it.SubItems[ 13] := 'X'
   else if ( modo = 'NEW' )  then
      it.SubItems[ 14 ] := 'X'
   else if ( modo = 'OLD' )  then
      it.SubItems[ 15 ] := 'X'
   else if ( modo = 'MOD' )  then
      it.SubItems[ 16 ] := 'X';
   inc( mil );
   inc( cuenta );
end;

procedure Tftsarchivos.agrega_fisico( archivo: string; Jclase:  string; Jbib: string; Jprogra: string;
          Sclase : string; Sbib: string; Sprogra: string; Uclase:  string; Ubib: string; Uprogra: string;
          XXclase: string; XXbib: string; XXprogra: string; organiza: string; modo: string; externo : string );

var
   hcprog, pcclase, pcbib, pcprog: string;
   qq: Tadoquery;
begin

   if xfisicos.IndexOf(  Jclase + '+' + Jbib + '+' + Jprogra + '+' +
                         Sclase + '+' + Sbib + '+' + Sprogra + '+' +
                         Uclase + '+' + Ubib + '+' + Uprogra + '+' +
                         XXclase + '+' + XXbib + '+' + XXprogra + '+' +
                         organiza + '+' + modo   + '+' + externo ) > -1 then
      exit;
   xfisicos.Add(  Jclase + '+' + Jbib + '+' + Jprogra + '+' +
                  Sclase + '+' + Sbib + '+' + Sprogra + '+' +
                  Uclase + '+' + Ubib + '+' + Uprogra + '+' +
                  XXclase + '+' + XXbib + '+' + XXprogra + '+' +
                  organiza + '+' + modo   + '+' + externo );

   if fisicos.IndexOf( Jclase ) = -1 then begin
      qq := Tadoquery.Create( self );
      qq.Connection := dm.ADOConnection1;
      if dm.sqlselect( qq,
          ' select distinct occlase,ocbib,ocprog,pcclase,pcbib,pcprog,hcclase,hcbib,hcprog,externo,organizacion,modo from tsrela ' +
         ' where hcprog=' + g_q + Jprogra + g_q +
         ' and   hcbib=' + g_q + Jbib + g_q +
         ' and   hcclase=' + g_q + Jclase + g_q +
         ' and   pcclase<>' + g_q + 'CLA' + g_q + 'order by occlase,ocbib,ocprog,pcclase,pcbib,pcprog' ) then begin // porque se metio FIL como FISICO
         //' order by hcprog,pcclase,pcbib,pcprog,hcclase' ) then begin
         while not qq.Eof do begin
          agrega_fisico( archivo,qq.fieldbyname( 'occlase' ).AsString,
                                 qq.fieldbyname( 'ocbib' ).AsString,
                                 qq.fieldbyname( 'oprog' ).AsString,
                                 qq.fieldbyname( 'pcclase' ).AsString,
                                 qq.fieldbyname( 'pcbib' ).AsString,
                                 qq.fieldbyname( 'pprog' ).AsString,
                                          '', '', '',
                                          '', '', '',
                                 qq.fieldbyname( 'organizacion' ).AsString,
                                 qq.fieldbyname( 'modo' ).AsString,
                                 qq.fieldbyname( 'externo' ).AsString );
            qq.Next;
         end;
      end;
      qq.Free;
      exit;
   end;

   if  (XXbib <> 'SCRATCH')
   and (xxclase <> 'CPU')
   and (xxclase <> 'OWN') then
      agrega( archivo, jclase, jbib, jprogra, sclase, sbib, sprogra, uclase, ubib, uprogra,
              XXclase, XXbib, XXprogra, organiza, modo, externo );
end;

procedure Tftsarchivos.lee;
var
   archivo, Jclase, Jbib, Jprogra, Sclase, Sbib, Sprogra, Uclase, Ubib, Uprogra, XXclase,XXbib, XXprogra, organiza, modo: string; externo: string;
begin
   archivo := '';
   mil := 0;
   Wmodo := '';
   repeat begin
         //Warchivos := uppercase( dm.q1.FieldByName( 'hcprog' ).AsString );
         G_externo := '';

         Jclase := dm.q1.FieldByName( 'occlase' ).AsString;
         Jbib := dm.q1.FieldByName( 'ocbib' ).AsString;
         Jprogra := dm.q1.FieldByName( 'ocprog' ).AsString;
         Sclase := dm.q1.FieldByName( 'pcclase' ).AsString;
         Sbib := dm.q1.FieldByName( 'pcbib' ).AsString;
         Sprogra := dm.q1.FieldByName( 'pcprog' ).AsString;
         modo := dm.q1.FieldByName( 'modo' ).AsString;
         Wmodo := dm.q1.FieldByName( 'modo' ).AsString;
         organiza := dm.q1.FieldByName( 'organizacion' ).AsString;
         externo := dm.q1.FieldByName( 'externo' ).AsString;
         G_externo := dm.q1.FieldByName( 'externo' ).AsString;
         G_externo := stringreplace( G_externo, '*', '%', [ rfReplaceAll ] );
         xfisicos.Clear;


        if ( ( Jclase = 'CBL' ) or ( Jclase = 'ALG' ) or  ( Jclase = 'WFL' ) )  then begin
          if dm.sqlselect( dm.q4,
            ' select distinct occlase,ocbib,ocprog,pcclase,pcbib,pcprog,hcclase,hcbib,hcprog, organizacion, externo,modo from tsrela ' +
            ' where pcprog =' + g_q + dm.q1.FieldByName( 'pcprog' ).AsString + g_q +
            ' and pcclase =' + g_q + dm.q1.FieldByName( 'pcclase' ).AsString + g_q +
            ' and pcbib =' + g_q + dm.q1.FieldByName( 'pcbib' ).AsString + g_q +
            //' and hcclase =' + g_q + 'LOC' + g_q +
            ' and externo  like ' + g_q + G_externo + g_q +
            ' order by occlase,ocbib,ocprog,pcclase,pcbib,pcprog' ) then begin
            organiza := dm.q4.FieldByName( 'organizacion' ).AsString;
            modo := dm.q4.FieldByName( 'modo' ).AsString;
            agrega_fisico( Warchivos, Jclase, Jbib, Jprogra, Sclase, Sbib, Sprogra, Uclase, Ubib, Uprogra, XXclase, XXbib, XXprogra, organiza, modo, externo );
          end;
        end else begin
          if dm.sqlselect( dm.q2,
            ' select distinct occlase,ocbib,ocprog,pcclase,pcbib,pcprog,hcclase,hcbib,hcprog, organizacion, externo,modo from tsrela ' +
            ' where pcprog =' + g_q + dm.q1.FieldByName( 'pcprog' ).AsString + g_q +
            ' and pcclase =' + g_q + dm.q1.FieldByName( 'pcclase' ).AsString + g_q +
            ' and pcbib =' + g_q + dm.q1.FieldByName( 'pcbib' ).AsString + g_q +
            //' and hcbib <> ' + g_q + 'SCRATCH' + g_q +
            ' and hcclase not in (' + g_q + 'FIL' + g_q + ',' + g_q + 'CLA' + g_q + ',' + g_q + 'REP' + g_q +',' + g_q + 'TAB' + g_q +')' +
            ' order by occlase,ocbib,ocprog,pcclase,pcbib,pcprog' ) then begin
           LeeDos;
          end else begin
            agrega_fisico( Warchivos, Jclase, Jbib, Jprogra, Sclase, Sbib, Sprogra, Uclase, Ubib, Uprogra, XXclase, XXbib, XXprogra, organiza, modo, externo );
          end;
       end;
       dm.q1.Next;

   end
   until dm.q1.Eof;

   lbltotal.Caption := 'Total  ' + inttostr( dm.q1.RecordCount ) + '  (1 - ' + inttostr( cuenta ) + ')';//'Total  ' + inttostr( dm.q1.RecordCount );
   //bmas.Visible := false;
end;



procedure Tftsarchivos.LeeDos;
var
   archivo, Jclase, Jbib, Jprogra, Sclase, Sbib, Sprogra, Uclase, Ubib, Uprogra, XXclase,XXbib, XXprogra, organiza, modo: string; externo: string;
begin
   archivo := '';
   repeat begin
         //Warchivos := uppercase( dm.q2.FieldByName( 'hcprog' ).AsString );
         Jclase := dm.q2.FieldByName( 'occlase' ).AsString;
         Jbib := dm.q2.FieldByName( 'ocbib' ).AsString;
         Jprogra := dm.q2.FieldByName( 'ocprog' ).AsString;
         Sclase := dm.q2.FieldByName( 'pcclase' ).AsString;
         Sbib := dm.q2.FieldByName( 'pcbib' ).AsString;
         Sprogra := dm.q2.FieldByName( 'pcprog' ).AsString;
         Uclase := '';
         Ubib := '';
         uprogra := '';
         XXclase := '';
         XXbib := '';
         XXprogra := '';
         organiza := dm.q1.FieldByName( 'organizacion' ).AsString;
         modo := dm.q1.FieldByName( 'modo' ).AsString;
         externo := dm.q1.FieldByName( 'externo' ).AsString;
         xfisicos.Clear;

        If  dm.q2.FieldByName( 'hcclase' ).AsString = 'UTI' then begin
            modo := Wmodo;
            Uclase  := dm.q2.FieldByName( 'hcclase' ).AsString;
            Ubib    := dm.q2.FieldByName( 'hcbib' ).AsString;
            uprogra := dm.q2.FieldByName( 'hcprog' ).AsString;
        end else begin
            organiza := dm.q2.FieldByName( 'organizacion' ).AsString;
            modo     := dm.q2.FieldByName( 'modo' ).AsString;
            externo  := dm.q2.FieldByName( 'externo' ).AsString;
            XXclase  := dm.q2.FieldByName( 'hcclase' ).AsString;
            XXbib    := dm.q2.FieldByName( 'hcbib' ).AsString;
            XXprogra := dm.q2.FieldByName( 'hcprog' ).AsString;
        end;


        if ( XXclase = 'CBL' )  then begin
          if dm.sqlselect( dm.q4,
            ' select distinct occlase,ocbib,ocprog,pcclase,pcbib,pcprog,hcclase,hcbib,hcprog, organizacion, externo,modo from tsrela ' +
            ' where pcprog =' + g_q + dm.q2.FieldByName( 'hcprog' ).AsString + g_q +
            ' and pcclase =' + g_q + dm.q2.FieldByName( 'hcclase' ).AsString + g_q +
            ' and pcbib =' + g_q + dm.q2.FieldByName( 'hcbib' ).AsString + g_q +
            //' and hcbib <>' + g_q + 'SCRATCH' + g_q +
            //' and hcclase =' + g_q + 'LOC' + g_q +
            ' and externo  like ' + g_q + '%' + G_externo + g_q +
            ' order by occlase,ocbib,ocprog,pcclase,pcbib,pcprog' ) then begin
            organiza := dm.q4.FieldByName( 'organizacion' ).AsString;
            modo := dm.q4.FieldByName( 'modo' ).AsString;
            agrega_fisico( Warchivos, Jclase, Jbib, Jprogra, Sclase, Sbib, Sprogra, Uclase, Ubib, Uprogra, XXclase, XXbib, XXprogra, organiza, modo, externo );
          end;
        end else begin
          if dm.sqlselect( dm.q3,
            ' select distinct occlase,ocbib,ocprog,pcclase,pcbib,pcprog,hcclase,hcbib,hcprog, organizacion, externo,modo from tsrela ' +
            ' where pcprog =' + g_q + dm.q2.FieldByName( 'hcprog' ).AsString + g_q +
            ' and  pcclase =' + g_q + dm.q2.FieldByName( 'hcclase' ).AsString + g_q +
            ' and  pcbib =' + g_q + dm.q2.FieldByName( 'hcbib' ).AsString + g_q +
            ' and  hcbib <>' + g_q + 'BD' + g_q +
            ' and hcclase not in (' + g_q + 'FIL' + g_q + ',' + g_q + 'CLA' + g_q + ',' + g_q + 'REP' + g_q +',' + g_q + 'TAB' + g_q + ',' + g_q + 'LOC' + g_q  +
            ',' + g_q + 'CPY' + g_q + ','+ g_q + 'INS' + g_q + ') ' +
//            ',' + g_q + 'CPY' + g_q + ','+ g_q + 'INS' + g_q + ','+ g_q + 'UTI' + g_q +') ' +
            ' order by occlase,ocbib,ocprog,pcclase,pcbib,pcprog' ) then begin
            LeeTres;
          end else begin
            if (Uclase <> '') then
             agrega_fisico( Warchivos, Jclase, Jbib, Jprogra, Sclase, Sbib, Sprogra, Uclase, Ubib, Uprogra, XXclase, XXbib, XXprogra, organiza, modo, externo );
          end;
        end;
        dm.q2.Next;
   end
   until dm.q2.Eof;

end;


procedure Tftsarchivos.LeeTres;
var
   archivo, Jclase, Jbib, Jprogra, Sclase, Sbib, Sprogra, Uclase, Ubib, Uprogra, XXclase,XXbib, XXprogra, organiza, modo: string; externo: string;
begin
   archivo := '';
   repeat begin
         //Warchivos := uppercase( dm.q2.FieldByName( 'hcprog' ).AsString );
         Jclase := dm.q2.FieldByName( 'occlase' ).AsString;
         Jbib := dm.q2.FieldByName( 'ocbib' ).AsString;
         Jprogra := dm.q2.FieldByName( 'ocprog' ).AsString;
         Sclase := dm.q2.FieldByName( 'pcclase' ).AsString;
         Sbib := dm.q2.FieldByName( 'pcbib' ).AsString;
         Sprogra := dm.q2.FieldByName( 'pcprog' ).AsString;
         Uclase := '';
         Ubib := '';
         uprogra := '';
         XXclase := '';
         XXbib := '';
         XXprogra := '';
         organiza := dm.q3.FieldByName( 'organizacion' ).AsString;
         modo := dm.q3.FieldByName( 'modo' ).AsString;
         externo := dm.q3.FieldByName( 'externo' ).AsString;
         xfisicos.Clear;

        If  dm.q3.FieldByName( 'hcclase' ).AsString = 'UTI' then begin
            modo := Wmodo;
            Uclase := dm.q3.FieldByName( 'hcclase' ).AsString;
            Ubib := dm.q3.FieldByName( 'hcbib' ).AsString;
            uprogra := dm.q3.FieldByName( 'hcprog' ).AsString;
        end else begin
            organiza := dm.q3.FieldByName( 'organizacion' ).AsString;
            modo := dm.q3.FieldByName( 'modo' ).AsString;
            externo := dm.q3.FieldByName( 'externo' ).AsString;
            XXclase := dm.q3.FieldByName( 'hcclase' ).AsString;
            XXbib := dm.q3.FieldByName( 'hcbib' ).AsString;
            XXprogra := dm.q3.FieldByName( 'hcprog' ).AsString;
        end;

        if (XXclase = 'CBL') then begin
          if dm.sqlselect( dm.q4,
            ' select distinct occlase,ocbib,ocprog,pcclase,pcbib,pcprog,hcclase,hcbib,hcprog, organizacion, externo,modo from tsrela ' +
            ' where pcprog =' + g_q + dm.q3.FieldByName( 'hcprog' ).AsString + g_q +
            ' and  pcclase =' + g_q + dm.q3.FieldByName( 'hcclase' ).AsString + g_q +
            ' and  pcbib =' + g_q + dm.q3.FieldByName( 'hcbib' ).AsString + g_q +
            //' and  hcbib <>' + g_q + 'SCRATCH' + g_q +
            //' and hcclase =' + g_q + 'LOC' + g_q +
            ' and externo  like ' + g_q + '%' + G_externo + g_q +
            ' order by occlase,ocbib,ocprog,pcclase,pcbib,pcprog' ) then begin
            organiza := dm.q4.FieldByName( 'organizacion' ).AsString;
            modo := dm.q4.FieldByName( 'modo' ).AsString;
            agrega_fisico( Warchivos, Jclase, Jbib, Jprogra, Sclase, Sbib, Sprogra, Uclase, Ubib, Uprogra, XXclase, XXbib, XXprogra, organiza, modo, externo );

          end;
          //dm.q4.Next;
        end else begin
          agrega_fisico( Warchivos, Jclase, Jbib, Jprogra, Sclase, Sbib, Sprogra, Uclase, Ubib, Uprogra, XXclase, XXbib, XXprogra, organiza, modo, externo );
        end;
     dm.q3.Next;
   end
   until dm.q3.Eof;

end;


procedure Tftsarchivos.arma( archivos: string );
var
   seleccion: string;
begin
   caption := titulo;
   if trim( archivos ) = '' then begin
         Application.MessageBox( pchar( dm.xlng( 'El campo Archio, no puede ir en blanco.' ) ),
            pchar( dm.xlng( 'Matriz de Archivos Físicos' ) ), MB_OK );
      exit;
   end;
   lv.Items.Clear;
   archivos := stringreplace( archivos, '*', '%', [ rfreplaceall ] );
   {if pos( '%', archivos ) > 0 then begin
      seleccion := ' where hcprog like ' + g_q + archivos + g_q;   Temporal...porque hay nombres de archivo con %.
      Warchivos := '';
   end else begin
   }

   If archivos = '%' then
      seleccion := ''
   else  begin
      if pos( '%', archivos  ) <> 0 then
         seleccion := ' hcprog like ' + g_q + archivos + g_q+ ' and '
      else
         seleccion := ' hcprog=' + g_q + archivos + g_q+ ' and ';
   end;

   Warchivos := archivos;
  // end;
   if dm.sqlselect( dm.q1,
      ' select distinct occlase,ocbib,ocprog,pcclase,pcbib,pcprog,hcclase,hcbib,hcprog,externo,organizacion,modo from tsrela  where ' +
      seleccion + filtro +
      ' and pcclase<>' + g_q + 'CLA' + g_q +
      ' order by occlase,ocbib,ocprog,pcclase,pcbib,pcprog' ) then begin //'and pcclase = occlase '+// porque se metio FIL como FISICO
      ///' order by occlase,ocbib,ocprog,hcclase' ) then begin
      cuenta := 0;
      lee;
   end;
   Crea_Web( );
end;

procedure Tftsarchivos.bsalirClick( Sender: TObject );
var
   arch: string;
begin
   gral.BorraIconosBasicos( );
   gral.BorraRutinasjs( );
   gral.BorraLogo( WnomLogo + g_ext );
   arch := g_tmpdir + '\MatCRUDarch.html';
   g_borrar.Add( arch );
   arch := g_tmpdir + '\MatCRUDarchIMP.html';
   g_borrar.Add( arch );
   close;
end;

procedure Tftsarchivos.lvClick( Sender: TObject );
var
   ite, nitem: Tlistitem;
   i, ini: integer;
   linea: string;
begin
   if lv.ItemIndex = -1 then
      exit;
   for i := 0 to lv.Items.Count - 1 do
      lv.Items[ i ].Checked := lv.Items[ i ].Selected;
   screen.cursor := crsqlwait;
   ite := lv.Items[ lv.itemindex ];
   if ite.SubItems[ 0 ] = 'ETP' then begin
      if dm.sqlselect( dm.q1, 'select * from tsrela ' +
         ' where hcprog=' + g_q + ite.SubItems[ 2 ] + g_q +
         ' and   hcbib=' + g_q + ite.SubItems[ 1 ] + g_q +
         ' and   hcclase=' + g_q + 'ETP' + g_q +
         ' and   pcclase<>' + g_q + 'ETP' + g_q ) then begin
         dm.trae_fuente( dm.q1.fieldbyname( 'pcprog' ).AsString,
            dm.q1.fieldbyname( 'pcbib' ).AsString, dm.q1.fieldbyname( 'pcclase' ).AsString, texto );
      end
      else begin
         Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe' ) ),
            pchar( dm.xlng( 'Busca archivo fuente ' ) ), MB_OK );
         abort;
      end;
   end
   else
      dm.trae_fuente( ite.SubItems[ 2 ], ite.SubItems[ 1 ], ite.SubItems[ 0 ], texto );

   lvindice.Items.Clear;
   if pos( chr( 13 ) + chr( 10 ), texto.Text ) = 0 then // corrige cuando el fuente no tiene CR
      texto.Text := stringreplace( texto.Text, chr( 10 ), chr( 13 ) + chr( 10 ), [ rfreplaceall ] );
   for i := 0 to texto.Lines.Count - 1 do begin
      linea := texto.Lines[ i ];

      while pos( uppercase( ite.Caption ), uppercase( linea ) ) > 0 do begin
         nitem := lvindice.Items.Add;
         nitem.Caption := inttostr( i + 1 );
         nitem.SubItems.Add( texto.Lines[ i ] );
         linea := copy( linea, pos( uppercase( ite.Caption ), uppercase( linea ) ) + length( ite.Caption ), 500 );
      end;
   end;
   screen.cursor := crdefault;
end;

procedure Tftsarchivos.lvindiceClick( Sender: TObject );
var
   i, y: integer;
begin
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

procedure Tftsarchivos.textoDblClick( Sender: TObject );
var
   arch: string;
begin
   if trim( texto.Text ) = '' then
      exit;
   screen.Cursor := crsqlwait;
   if pos( chr( 13 ) + chr( 10 ), texto.Text ) = 0 then // corrige cuando el fuente no tiene CR
      texto.Text := stringreplace( texto.Text, chr( 10 ), chr( 13 ) + chr( 10 ), [ rfreplaceall ] );
   arch := g_tmpdir + '\f' + formatdatetime( 'YYYYMMDDhhnnss', now ) + '.txt';
   texto.Lines.SaveToFile( arch );
   ShellExecute( 0, 'open', pchar( arch ), nil, PChar( g_tmpdir ), SW_SHOW );
   g_borrar.Add( arch );
   arch := g_tmpdir + '\ICONO_TICK.ico';
   g_borrar.Add( arch );
   screen.Cursor := crdefault;
end;

procedure Tftsarchivos.textoClick( Sender: TObject );
begin
   texto.setfocus;
end;

procedure Tftsarchivos.cmbarchivoKeyPress( Sender: TObject; var Key: Char );
begin
   if Key = #13 then begin
      Key := #0; { eat enter key }
      Perform( WM_NEXTDLGCTL, 0, 0 ); { move to next control }
   end
end;

procedure Tftsarchivos.cmbarchivoExit( Sender: TObject );
begin
   if cmbarchivo.Text = '' then
      exit
   else
      arma( cmbarchivo.Text );
end;

procedure Tftsarchivos.cmbarchivoClick( Sender: TObject );
begin
   cmbarchivo.SetFocus;
end;

procedure Tftsarchivos.bmasClick( Sender: TObject );
begin
   screen.Cursor := crsqlwait;
   if dm.procrunning( 'Notepad.exe' ) then
      Application.MessageBox( pchar( dm.xlng( 'Ejecutando!!!!' ) ),
         pchar( dm.xlng( 'Archivos CRUD' ) ), MB_OK )
   else
      Application.MessageBox( pchar( dm.xlng( 'No esta Ejecutando!!!!' ) ),
         pchar( dm.xlng( 'Archivos CRUD' ) ), MB_OK );

   SwitchDesktop( CreateDesktop( 'ClubDelphi', nil, nil, 0, MAXIMUM_ALLOWED, nil ) );
   Sleep( 12000 );
   SwitchDesktop( OpenDesktop( 'Default', 0, False, DESKTOP_SWITCHDESKTOP ) );
   screen.Cursor := crdefault;
   lee;
   exit;

end;

procedure Tftsarchivos.creaweb;
var
   i, j, ii : integer;
   texto,Wi, Wii: string;
   x, x1: Tstringlist;
begin
   x := Tstringlist.create;
   x1 := Tstringlist.create;
   x.Add( '<HTML>' );
   x1.Add( '<HTML>' );
   x.Add( '<HEAD>' );
   x1.Add( '<HEAD>' );
   x.Add( '<TITLE>Sys-Mining</TITLE>' );
   x1.Add( '<TITLE>Sys-Mining</TITLE>' );
   // PARA RESALTAR LA LINEA.
   x.ADD( '<script language="JavaScript" type="text/javascript">' );
   x.ADD( ' function ResaltarFila(id_archivo){' );
   x.ADD( '  if (id_archivo == undefined)' );
   x.ADD( 'var filas = document.getElementsByTagName("tr");' );
   x.ADD( '  else{' );
   x.ADD( 'var archivo = document.getElementById(id_archivo);' );
   x.ADD( 'var filas = archivo.getElementsByTagName("tr");' );
   x.ADD( '}' );
   x.ADD( 'for(var i in filas) { ' );
   x.ADD( 'filas[i].onmouseover = function() { ' );
   x.ADD( 'this.className = "resaltar";' );
   x.ADD( '}' );
   x.ADD( 'filas[i].onmouseout = function() { ' );
   x.ADD( 'this.className = null; ' );
   x.ADD( '  }' );
   x.ADD( ' }' );
   x.ADD( '}' );
   x.ADD( '</script>' );

   x.ADD( '<style type="text/css">' );
   x.ADD( 'tr.resaltar {' );
   x.ADD( 'background-color: #E6E6E6;' );
   x.ADD( '}' );
   x.ADD( '</style>' );

   // FIN RESALTAR LA LINEA
   x.Add( '</HEAD>' );
   x1.Add( '<TITLE>SysViewSoft</TITLE>' );
   x.Add( '<BODY  Text="#000000" link="#000000" alink= "#FF0000" vlink= "#000000">' );
   x1.Add( '<BODY Text="#000000" link="#000000">' );
   x.Add( '<div ALIGN=middle ><img width="100" height="30" src="' + trim( WnomLogo ) + g_ext + '" ALIGN=right>' );
   x1.Add( '<div ALIGN=middle ><img width="100" height="30" src="' + trim( WnomLogo ) + g_ext + '" ALIGN=right>' );


   x.Add( '<font size=1>'+'<b>'+g_empresa+'</b>'+'<font>' );
   x1.Add( '<font size=1>'+'<b>'+g_empresa+'</b>'+'<font>' );
   texto := dm.xlng( 'MATRIZ CRUD: ' );

   //x.Add( '<p><font size=1 >' +'<b>'+ '*'+'</b>' + '</font></p>' );
   x.Add( '<p><font size=1 >' + '<b>'+ texto+' '+Warchivos+'</b>'  + '</font></p>' );
   x1.Add( '<p><font size=1 >' + '<b>'+ texto+' '+Warchivos+'</b>'  + '</font></p>' );

   x.Add( '<TABLE id="archivo_MatrizCRUD" cellspacing="1" BORDER="3">' );
   x1.Add( '<TABLE id="archivo_MatrizCRUD" cellspacing="1" BORDER="3">' );
   x.Add( '<TR>' );
   x1.Add( '<TR>' );

   for i := 0 to lv.Columns.Count - 1 do begin
{      If (Warchivos <> '') and (i = 0)  then  begin
         x.add( '<TD bgcolor="#A9D0F5">&nbsp;</TD>' );
         x1.add( '<TD bgcolor="#A9D0F5">&nbsp;</TD>' );
      end else begin }
         x.add( '<TH bgcolor="#A9D0F5" NOWRAP><FONT  FACE="verdana" size="2">' + lv.columns[ i ].caption + '</font></TH>' );
         x1.add( '<TH bgcolor="#A9D0F5" NOWRAP><FONT FACE="verdana" size="2">' + lv.columns[ i ].caption + '</font></TH>' );
//      end;
   end;
   x.add( '</TR>' );
   x1.add( '</TR>' );

   for i := 0 to lv.items.Count - 1 do begin
       if i > 0 then  begin
           if  ( lv.items.item[ i-1 ].subitems[ 0 ]  =   lv.items.item[ i ].subitems[ 0 ] )
           and ( lv.items.item[ i-1 ].subitems[ 1 ]  =   lv.items.item[ i ].subitems[ 1 ] )
           and ( lv.items.item[ i-1 ].subitems[ 2 ]  =   lv.items.item[ i ].subitems[ 2 ] )
           and ( lv.items.item[ i-1 ].subitems[ 3 ]  =   lv.items.item[ i ].subitems[ 3 ] )
           and ( lv.items.item[ i-1 ].subitems[ 4 ] <> '' )
           and ( lv.items.item[ i   ].subitems[ 5 ] <> '' )then begin
                 lv.items.item[ i ].subitems[ 4 ] := lv.items.item[ i-1 ].subitems[ 4 ] ;
                 lv.items.item[ i-1 ].subitems[ 4 ] := '';
           end;
       end;

       if (i + 1) <= lv.items.Count - 1 then  begin
           if  ( lv.items.item[ i+1 ].subitems[ 0 ]  =   lv.items.item[ i ].subitems[ 0 ] )
           and ( lv.items.item[ i+1 ].subitems[ 1 ]  =   lv.items.item[ i ].subitems[ 1 ] )
           and ( lv.items.item[ i+1 ].subitems[ 2 ]  =   lv.items.item[ i ].subitems[ 2 ] )
           and ( lv.items.item[ i+1 ].subitems[ 3 ]  =   lv.items.item[ i ].subitems[ 3 ] )
           and ( lv.items.item[ i+1 ].subitems[ 4 ] <> '' ) then begin
                 lv.items.item[ i ].subitems[ 4 ] := lv.items.item[ i+1 ].subitems[ 4 ] ;
                 lv.items.item[ i+1 ].subitems[ 4 ] := '';
           end;
       end;
    end;

   for i := 0 to lv.items.Count - 1 do begin
     IF
      ( (lv.items.item[ i ].subitems[ 0 ] <> 'CTC') and
         (lv.items.item[ i ].subitems[ 0 ] <> 'CBL') )
     and ( lv.items.item[ i ].subitems[ 4 ]  = '' )
     and ( lv.items.item[ i ].subitems[ 5 ]  = '' )
     and ( lv.items.item[ i ].subitems[ 6 ]  = '' )
     and ( lv.items.item[ i ].subitems[ 7 ]  = '' )
     and ( lv.items.item[ i ].subitems[ 8 ]  = '' ) then begin
     {
     (( lv.items.item[ i ].subitems[ 0 ] <> 'CTC' )
        and ( lv.items.item[ i ].subitems[ 4 ]  = '' )
        and ( lv.items.item[ i ].subitems[ 5 ]  = '' )
        and ( lv.items.item[ i ].subitems[ 6 ]  = '' )
        and ( lv.items.item[ i ].subitems[ 7 ]  = '' )
        and ( lv.items.item[ i ].subitems[ 8 ]  = '' )
        and ( lv.items.item[ i ].subitems[ 9 ]  = '' )
        and ( lv.items.item[ i ].subitems[ 10 ]  = '' )
        and ( lv.items.item[ i ].subitems[ 11 ]  = '' )
        and ( lv.items.item[ i ].subitems[ 12 ]  = '' )
        and ( lv.items.item[ i ].subitems[ 13 ]  = '' )
        and ( lv.items.item[ i ].subitems[ 14 ]  = '' )
        and ( lv.items.item[ i ].subitems[ 15 ]  = '' )
        and ( lv.items.item[ i ].subitems[ 16 ]  = '' ))  }

      texto := trim( lv.items.item[ i ].caption );
     end else begin
      x1.add( '<TR>' );
      x.add( '<TR>' );
      texto := trim( lv.items.item[ i ].caption );

      if texto = '' then begin
         x.add( '<TD bgcolor="#A9D0F5">&nbsp;</TD>' );
         x1.add( '<TD bgcolor="#A9D0F5">&nbsp;</TD>' );
      end
      else begin
         //x.add( '<TD bgcolor="#4169E1" NOWRAP><FONT FACE="verdana" size="1">' +
         x.add( '<TD NOWRAP><FONT FACE="verdana" size="1">' +
         lv.items.item[ i ].caption + '</font></TD>' );
         x1.add( '<TD NOWRAP><FONT FACE="verdana" size="1">' +
         lv.items.item[ i ].caption + '</font></TD>' );
      end;

      for ii := 0 to lv.items.item[ i ].subitems.Count - 1 do begin

         texto := trim( lv.items.item[ i ].subitems[ ii ] );

         if texto <> '' then begin

            if (ii = 2)  or (ii = 7)then begin
              { If Warchivos = '' then
                  Wii := ''
               else}
                  Wii := lv.items.item[ i ].caption + '|';
                  if ii = 2 then begin
                     x.add( '<TD ALIGN=left><FONT FACE="verdana" size="1" ><A HREF=#lin' +
                     lv.items.item[ i ].caption + '|' +
                     //Wii+
                     lv.items.item[ i ].subitems[ ii - 2 ] + '|' +
                     lv.items.item[ i ].subitems[ ii - 1 ] + '|' +
                     lv.items.item[ i ].subitems[ ii ] +
                     '>' + lv.items.item[ i ].subitems[ ii ] + '</A></font></TD>' );
                  end else begin
                     x.add( '<TD ALIGN=left><FONT FACE="verdana" size="1" ><A HREF=#lin' +
                     lv.items.item[ i ].caption + '|' +
                     //Wii+
                     lv.items.item[ i ].subitems[ ii - 2 ] + '|' +
                     lv.items.item[ i ].subitems[ ii - 1 ] + '|' +
                     lv.items.item[ i ].subitems[ ii ] +
                     '>' + lv.items.item[ i ].subitems[ ii ] + '</A></font></TD>' );
                  end;

                  x1.add( '<TD ALIGN=center><FONT FACE="verdana" size="1">' + lv.items.item[ i ].subitems[ ii ] + '</font></TD>' );
               end
               else begin
                  if lv.items.item[ i ].subitems[ ii ] = 'X' then begin
                     x.add( '<TD ALIGN=center><IMG width="18" height="18" SRC="' + g_tmpdir + '\ICONO_TICK.ico"></TD>' );
                     x1.add( '<TD ALIGN=center><IMG width="18" height="18" SRC="' + g_tmpdir + '\ICONO_TICK.ico"></TD>' );
                  end
                  else begin
                     x.add( '<TD ALIGN=center><FONT FACE="verdana" size="1" >' + lv.items.item[ i ].subitems[ ii ] + '</font></TD>' );
                     x1.add( '<TD align=center><FONT FACE="verdana" size="1">' + lv.items.item[ i ].subitems[ ii ] + '</font></TD>' );
                  end;
               end;
            end

         else begin
            x.add( '<TD>&nbsp;</TD>' );
            x1.add( '<TD>&nbsp;</TD>' );
         end;
      end;
      x.Add( '</TR>' );
      x1.Add( '</TR>' );
    end;
   end;
   x.Add( '</TABLE>' );
   x1.Add( '</TABLE>' );
   x.Add( '<script language="JavaScript" type="text/javascript">' );
   x.Add( 'ResaltarFila("archivo_MatrizCRUD");' );
   x.Add( '</script>' );
   x.ADD( '</div>' );
   x1.ADD( '</div>' );
   x.Add( '</BODY>' );
   x1.Add( '</BODY>' );
   x.Add( '</HTML>' );
   x1.Add( '</HTML>' );
   x.savetofile( g_tmpdir + '\MatCRUDarch.html' );
   g_borrar.Add( g_tmpdir + '\MatCRUDarch.html' );
   x1.savetofile( g_tmpdir + '\MatCRUDarchIMP.html' );
   g_borrar.Add( g_tmpdir + '\MatCRUDarchIMP.html' );
   x.free;
   x1.free;
end;

procedure Tftsarchivos.Crea_Web;
begin
   if lv.items.Count <> 0 then begin
      screen.Cursor := crsqlwait;
      mnuExportar.Visible := ivAlways;
      mnuImprimir.visible := ivAlways;
      creaweb;
      try
         web.Navigate( g_tmpdir + '\MatCRUDarch.html' );
      except
         exit;
      end;
      screen.Cursor := crdefault;
   end else begin
       Application.MessageBox( pchar( dm.xlng( 'No existe información a procesar.' ) ),
       pchar( dm.xlng( 'Matriz CRUD' ) ), MB_OK );
   end;

end;

procedure Tftsarchivos.webBeforeNavigate2( Sender: TObject;
   const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
   Headers: OleVariant; var Cancel: WordBool );
var
   nitem: Tlistitem;
   i: integer;
   linea: string;
   k, l: integer;
   b1: string;
   m: Tstringlist;
   x, y: integer;
begin
   k := pos( '#lin', URL );
   if k > 0 then begin
      screen.Cursor := crsqlwait;
      l := Length( URL );
      b1 := copy( URL, K + 4, l - 4 );
      b1 := trim( b1 );
   end;
   if b1 = '' then
      exit;
   b1 := stringreplace( trim( b1 ), '|', ' ', [ rfReplaceAll ] );
   m := Tstringlist.Create;
   m.CommaText := b1;
   if m.count < 3 then begin
      Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
         pchar( dm.xlng( 'Matríz Archivos Físicos ' ) ), MB_OK );
      m.free;
      exit;
   end;
   if m[ 1 ] = 'ETP' then begin
      if dm.sqlselect( dm.q1, 'select * from tsrela ' +
         ' where hcprog=' + g_q + m[ 3 ] + g_q +
         ' and   hcbib=' + g_q + m[ 2 ] + g_q +
         ' and   hcclase=' + g_q + 'ETP' + g_q +
         ' and   pcclase<>' + g_q + 'ETP' + g_q ) then begin
         dm.trae_fuente( dm.q1.fieldbyname( 'pcprog' ).AsString,
            dm.q1.fieldbyname( 'pcbib' ).AsString,
            dm.q1.fieldbyname( 'pcclase' ).AsString, texto );
      end
      else begin
         Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe' ) ),
            pchar( dm.xlng( 'Matriz CRUD ' ) ), MB_OK );
         abort;
      end;
   end
   else
      dm.trae_fuente( m[ 3 ], m[ 2 ],  m[ 1 ], texto );
   if pos( chr( 13 ) + chr( 10 ), texto.Text ) = 0 then // corrige cuando el fuente no tiene CR
      texto.Text := stringreplace( texto.Text, chr( 10 ), chr( 13 ) + chr( 10 ), [ rfreplaceall ] );
   lvindice.Items.Clear;
   for i := 0 to texto.Lines.Count - 1 do begin
      linea := texto.Lines[ i ];
      while pos( uppercase( m[ 0 ] ), uppercase( linea ) ) > 0 do begin
         nitem := lvindice.Items.Add;
         nitem.Caption := inttostr( i + 1 );
         nitem.SubItems.Add( texto.Lines[ i ] );
         linea := copy( linea, pos( uppercase( m[ 0 ] ), uppercase( linea ) ) + length( m[ 0 ] ), 500 );
      end;
   end;

   //---------------
   screen.Cursor:=crdefault;
   //bgral:=m[0]+' '+m[1]+' '+m[2];
   Opciones:=gral.ArmarMenuConceptualWeb(m[3]+' '+m[2]+' '+m[1],'archivo_fisico');
   y:=ArmarOpciones(Opciones);
   gral.PopGral.Popup(g_X, g_Y);
   //---------------

   Warchivo := m[ 0 ];
   m.Free;
   screen.cursor := crdefault;
end;
function Tftsarchivos.ArmarOpciones(b1:Tstringlist):Integer;

begin
  gral.EjecutaOpcionB (b1,'Matriz CRUD');
end;
procedure Tftsarchivos.ImpWebClick( Sender: TObject );
begin
   b_impresion := true;
   Web.Navigate( g_tmpdir + '\MatCRUDarchIMP.html' );
end;

procedure Tftsarchivos.WebPreviewPrint( web: TWebBrowser );
var
   vin, Vout: OleVariant;
begin
   web.ControlInterface.ExecWB( OLECMDID_PRINTPREVIEW, OLECMDEXECOPT_DONTPROMPTUSER, vin, Vout );
end;

procedure Tftsarchivos.webDocumentComplete( Sender: TObject;
   const pDisp: IDispatch; var URL: OleVariant );
begin
   screen.Cursor := crdefault;
   try
      if b_impresion then begin
         WebPreviewPrint( web );
         Web.Navigate( g_tmpdir + '\MatCRUDarch.html' );
         b_impresion := false;
      end;
   finally
      gral.PubMuestraProgresBar( False );
   end;
end;


procedure Tftsarchivos.FormClose( Sender: TObject; var Action: TCloseAction );
var
   arch: string;
begin
   if FormStyle = fsMDIChild then
      Action := caFree;

  //g_log.SaveToFile( g_tmpdir + '\sysviewlog');
   gral.BorraIconosBasicos( );
   gral.BorraRutinasjs( );
   gral.BorraLogo( WnomLogo + g_ext );
   arch := g_tmpdir + '\MatCRUDarch.html';
   g_borrar.Add( arch );
   arch := g_tmpdir + '\MatCRUDarchIMP.html';
   g_borrar.Add( arch );
end;

procedure Tftsarchivos.FormDestroy(Sender: TObject);
begin
      dm.PubEliminarVentanaActiva( Caption );

   if gral.iPubVentanasActivas in [ 0, 1 ] then
      gral.PubExpandeMenuVentanas( False );
end;

procedure Tftsarchivos.webProgressChange(Sender: TObject; Progress,
  ProgressMax: Integer);
begin
   gral.PubAvanzaProgresBar;
end;

procedure Tftsarchivos.mnuImprimirClick(Sender: TObject);
begin
   b_impresion := true;
   Web.Navigate( g_tmpdir + '\MatCRUDarchIMP.html' );
end;

procedure Tftsarchivos.mnuExportarClick(Sender: TObject);
var
   i, ii, j: integer;
   Libro: _WORKBOOK;
   Hoja: _WORKSHEET;
begin
   j := 5;
   Libro := ExcelApplication1.Workbooks.Add( Null, 0 );
   Hoja := Libro.Sheets[ 1 ] as _WORKSHEET;
   Hoja.Cells.Item[ 2, 1 ] := trim( g_empresa );
   Hoja.Cells.Item[ 2, 1 ].font.size := 10;
   Hoja.Cells.Item[ 3, 1 ] := 'Matriz CRUD : ' + lv.items[ 0 ].caption;
   Hoja.Cells.Item[ 3, 1 ].font.size := 9;
   Hoja.Cells.Item[ 2, 1 ].Font.Bold := True;
   Hoja.Cells.Item[ 3, 1 ].Font.Bold := True;
   Hoja.Cells.Item[ 4, 1 ].Font.Bold := True;

   for ii := 0 to lv.Columns.Count - 1 do begin
      Hoja.Cells.Item[ j, ii + 1 ] := lv.columns[ ii ].caption;
      Hoja.Cells.Item[ j, ii + 1 ].Font.Bold := True;
   end;

   j := j + 1;

   for i := 0 to lv.items.Count - 1 do begin
      Hoja.Cells.Item[ j, 1 ] := lv.items[ i ].caption;
      Hoja.Cells.Item[ j, 1 ].Font.Bold := True;

      for ii := 1 to lv.items.item[ i ].subitems.Count do begin
         Hoja.Cells.Item[ j, ii + 1 ] := lv.items.item[ i ].subitems[ ii - 1 ];
      end;
      j := j + 1;
   end;
   ExcelApplication1.Visible[ 1 ] := true;
end;

procedure Tftsarchivos.FormDeactivate(Sender: TObject);
begin
   gral.PopGral.Items.Clear;
end;



end.
