unit ptsdocumenta;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
   Buttons, StdCtrls, ExtCtrls, ComCtrls, ShellAPI, Menus, dxBar, HTML_HELP,
   RVScroll, SclRView;

type
   Tftsdocumenta = class( TForm )
      lv: TListView;
      Splitter1: TSplitter;
      OpenDialog1: TOpenDialog;
      pop: TPopupMenu;
      Eliminar1: TMenuItem;
      Editar: TMenuItem;
      Popedit: TPopupMenu;
      Cut1: TMenuItem;
      Copy1: TMenuItem;
      Paste1: TMenuItem;
      mnuPrincipal: TdxBarManager;
      mnuCancelar: TdxBarButton;
      mnuGuardar: TdxBarButton;
      mnuAnexar: TdxBarButton;
      mnuEliminar: TdxBarButton;
      mnuEditar: TdxBarButton;
      txtEditor: TSRichViewEdit;
      //procedure bsalirClick( Sender: TObject );
      //procedure bokClick( Sender: TObject );
      procedure lvClick( Sender: TObject );
      //procedure banexoClick( Sender: TObject );
      //procedure bcancelClick( Sender: TObject );
      procedure Eliminar1Click( Sender: TObject );
      procedure popPopup( Sender: TObject );
      procedure EditarClick( Sender: TObject );
      procedure lvDblClick( Sender: TObject );
      procedure FormCreate( Sender: TObject );
      procedure Cut1Click( Sender: TObject );
      procedure Copy1Click( Sender: TObject );
      procedure Paste1Click( Sender: TObject );
      procedure FormClose( Sender: TObject; var Action: TCloseAction );
      procedure FormDestroy( Sender: TObject );
      procedure mnuCancelarClick( Sender: TObject );
      procedure mnuGuardarClick( Sender: TObject );
      procedure mnuAnexarClick( Sender: TObject );
      procedure mnuEliminarClick( Sender: TObject );
      procedure mnuEditarClick( Sender: TObject );
      procedure FormActivate( Sender: TObject );
      procedure txtEditorChange( Sender: TObject );
   private
      { Private declarations }
      procedure actualiza;
   public
      { Public declarations }
      cprog, cbib, cclase: string;
      titulo: string;
      procedure arma( prog: string; bib: string; clase: string );
   end;

implementation
uses ptsdm, ptsgral;
{$R *.dfm}

procedure Tftsdocumenta.arma( prog: string; bib: string; clase: string );
var
   ite: Tlistitem;
begin
   cprog := prog;
   cbib := bib;
   cclase := clase;
   lv.Items.Clear;
   //caption :=  'Documentación ' + cclase + ' ' + cbib + ' ' + cprog );
   caption := titulo;
   if dm.sqlselect( dm.q1, 'select * from tsdocum ' +
      ' where cprog=' + g_q + cprog + g_q +
      ' and   cbib=' + g_q + cbib + g_q +
      ' and   cclase=' + g_q + cclase + g_q +
      ' order by titulo' ) then begin
      while not dm.q1.Eof do begin
         ite := lv.Items.Add;
         ite.Caption := dm.q1.fieldbyname( 'tipo' ).AsString;
         ite.SubItems.Add( dm.q1.fieldbyname( 'titulo' ).AsString );
         ite.SubItems.Add( dm.q1.fieldbyname( 'fecha' ).AsString );
         ite.SubItems.Add( dm.q1.fieldbyname( 'cuser' ).AsString );
         ite.SubItems.Add( dm.q1.fieldbyname( 'cblob' ).AsString );
         dm.q1.Next;
      end;
   end;
end;

{procedure Tftsdocumenta.bsalirClick( Sender: TObject );
begin
   close;
end;
}

procedure Tftsdocumenta.actualiza;
var
   arch, cblob, magic, fecha: string;
begin
   if lv.SelCount = 0 then
      exit;
   arch := g_ruta + 'docux.rtf';
   //re.Lines.SaveToFile( arch );
   txtEditor.RichViewEdit.SaveRTF( arch, False );

   cblob := dm.file2blob( arch, magic );
   fecha := dm.datedb( formatdatetime( 'YYYY/MM/DD HH:NN:SS', now ), 'YYYY/MM/DD HH24:MI:SS' );
   if dm.sqlupdate( 'update tsdocum set ' +
      ' cblob=' + g_q + cblob + g_q + ',' +
      ' magic=' + g_q + magic + g_q + ',' +
      ' fecha=' + fecha +
      ' where cprog=' + g_q + cprog + g_q +
      ' and   cbib=' + g_q + cbib + g_q +
      ' and   cclase=' + g_q + cclase + g_q +
      ' and   titulo=' + g_q + lv.Selected.SubItems[ 0 ] + g_q ) = false then begin
      Application.MessageBox( pchar( dm.xlng( 'ERROR... no puede actualizar en tsdocum' ) ),
         pchar( dm.xlng( 'Actualizar documentación ' ) ), MB_OK );
      abort;
   end;
   dm.sqldelete( 'delete tsblob where cblob=' + g_q + lv.Selected.SubItems[ 3 ] + g_q );
   //re.Lines.Clear;
   txtEditor.RichViewEdit.SelectAll;
   txtEditor.RichViewEdit.DeleteSelection;

   //bok.Caption := dm.xlng( 'Guardar' );
   mnuGuardar.Enabled := false;
   mnuCancelar.Enabled := false;
   arma( cprog, cbib, cclase );
end;

{procedure Tftsdocumenta.bokClick( Sender: TObject );
var
   titulo, cblob, magic, arch, fecha, tipo: string;
begin
   if bok.Caption = dm.xlng( 'Actualizar' ) then begin
      if lv.Selected.SubItems[ 2 ] <> g_usuario then
         if dm.capacidad( 'Documenta - Actualizar documentos' ) = false then begin
            Application.MessageBox( pchar( dm.xlng( 'No tiene capacidad para actualizar documentos ajenos' ) ),
               pchar( dm.xlng( 'Actualizar documentación ' ) ), MB_OK );
            screen.cursor := crdefault;
            exit;
         end;
      actualiza;
      exit;
   end;
   titulo := inputbox( 'Capture', dm.xlng( 'Titulo del documento' ), copy( trim( copy( re.Text, 1, 200 ) ), 1, 80 ) );
   if trim( titulo ) = '' then
      exit;
   arch := g_ruta + 'docux.rtf';
   re.Lines.SaveToFile( arch );
   cblob := dm.file2blob( arch, magic );
   fecha := dm.datedb( formatdatetime( 'YYYY/MM/DD HH:NN:SS', now ), 'YYYY/MM/DD HH24:MI:SS' );
   tipo := '...';
   if dm.sqlinsert( 'insert into tsdocum (cprog,cbib,cclase,titulo,fecha,tipo,cuser,cblob,magic) values(' +
      g_q + cprog + g_q + ',' +
      g_q + cbib + g_q + ',' +
      g_q + cclase + g_q + ',' +
      g_q + titulo + g_q + ',' +
      fecha + ',' +
      g_q + tipo + g_q + ',' +
      g_q + g_usuario + g_q + ',' +
      g_q + cblob + g_q + ',' +
      g_q + magic + g_q + ')' ) = false then begin
      Application.MessageBox( pchar( dm.xlng( 'ERROR... no puede insertar en tsdocum' ) ),
         pchar( dm.xlng( 'Actualizar documentación ' ) ), MB_OK );
      abort;
   end;
   deletefile( arch );
   arma( cprog, cbib, cclase );
   re.Lines.Clear;
   bok.Enabled := false;
   bcancel.Enabled := false;
end;
}

procedure Tftsdocumenta.lvClick( Sender: TObject );
var
   titulo, arch: string;
begin
   if lv.SelCount = 0 then
      exit;
   titulo := lv.Selected.SubItems[ 0 ];
   if lv.Selected.Caption = '...' then begin
      screen.cursor := crsqlwait;
      if dm.sqlselect( dm.q1, 'select * from tsdocum ' +
         ' where cprog=' + g_q + cprog + g_q +
         ' and   cbib=' + g_q + cbib + g_q +
         ' and   cclase=' + g_q + cclase + g_q +
         ' and   titulo=' + g_q + titulo + g_q ) then begin
         arch := g_tmpdir + dm.q1.fieldbyname( 'cblob' ).AsString + '.rtf';
         dm.blob2file( dm.q1.fieldbyname( 'cblob' ).AsString, arch );
         //re.Lines.LoadFromFile( arch );

         txtEditor.RichViewEdit.SelectAll;
         txtEditor.RichViewEdit.DeleteSelection;

         txtEditor.RichViewEdit.LoadRTF( arch );
         txtEditor.RichViewEdit.InsertText( '.');

         deletefile( arch );
         mnuGuardar.Caption := dm.xlng( 'Actualizar' );
         mnuGuardar.Enabled := false;
         mnuCancelar.Enabled := True;
      end;
      screen.cursor := crdefault;
   end
   else begin
      //re.lines.Clear;
      txtEditor.RichViewEdit.SelectAll;
      txtEditor.RichViewEdit.DeleteSelection;
   end;
end;

{procedure Tftsdocumenta.banexoClick( Sender: TObject );
var
   titulo, cblob, magic, arch, fecha, tipo: string;
begin

   arch := opendialog1.FileName;
   if fileexists( arch ) = false then begin
      Application.MessageBox( pchar( dm.xlng( 'ERROR... no existe el archivo ' + arch ) ),
         pchar( dm.xlng( 'Anexos ' ) ), MB_OK );
      abort;
   end;
   titulo := extractfilename( arch );
   if inputquery( 'Capture', dm.xlng( 'Titulo del Anexo' ), titulo ) = false then
      exit;
   titulo := trim( titulo );
   if titulo = '' then
      exit;
   screen.cursor := crsqlwait;
   cblob := dm.file2blob( arch, magic );
   fecha := dm.datedb( formatdatetime( 'YYYY/MM/DD HH:NN:SS', now ), 'YYYY/MM/DD HH24:MI:SS' );
   tipo := extractfileext( arch );
   if dm.sqlselect( dm.q1, 'select titulo from tsdocum ' +
      ' where cprog=' + g_q + cprog + g_q +
      ' and   cbib=' + g_q + cbib + g_q +
      ' and   cclase=' + g_q + cclase + g_q +
      ' and   titulo=' + g_q + titulo + g_q ) then begin
      Application.MessageBox( pchar( dm.xlng( 'ERROR... El titulo "' + titulo + '" ya existe' ) ),
         pchar( dm.xlng( 'Anexos ' ) ), MB_OK );
      screen.cursor := crdefault;
      abort;
   end;
   if dm.sqlinsert( 'insert into tsdocum (cprog,cbib,cclase,titulo,fecha,tipo,cuser,cblob,magic) values(' +
      g_q + cprog + g_q + ',' +
      g_q + cbib + g_q + ',' +
      g_q + cclase + g_q + ',' +
      g_q + titulo + g_q + ',' +
      fecha + ',' +
      g_q + tipo + g_q + ',' +
      g_q + g_usuario + g_q + ',' +
      g_q + cblob + g_q + ',' +
      g_q + magic + g_q + ')' ) = false then begin
      Application.MessageBox( pchar( dm.xlng( 'ERROR... no puede insertar en tsdocum' ) ),
         pchar( dm.xlng( 'Anexos ' ) ), MB_OK );
      screen.cursor := crdefault;
      abort;
   end;
   arma( cprog, cbib, cclase );
   screen.cursor := crdefault;
end;
}
{procedure Tftsdocumenta.bcancelClick( Sender: TObject );
begin
   if application.MessageBox( pchar( dm.xlng( 'Desea limpiar el área de captura?' ) ), pchar( dm.xlng( 'Confirmar' ) ), MB_YESNO ) = IDNO then
      exit;
   re.Lines.Clear;
   bok.Caption := dm.xlng( 'Guardar' );
   bok.Enabled := false;
   bcancel.Enabled := false;
end;
}

procedure Tftsdocumenta.Eliminar1Click( Sender: TObject );
begin
   screen.cursor := crsqlwait;
   if lv.Selected.SubItems[ 2 ] <> g_usuario then
      if dm.capacidad( 'Documenta - Borrar documentos' ) = false then begin
         Application.MessageBox( pchar( dm.xlng( 'No tiene capacidad para eliminar documentos ajenos' ) ),
            pchar( dm.xlng( 'Actualizar documentación' ) ), MB_OK );
         screen.cursor := crdefault;
         exit;
      end;
   if dm.sqldelete( 'delete tsdocum ' +
      ' where cprog=' + g_q + cprog + g_q +
      ' and   cbib=' + g_q + cbib + g_q +
      ' and   cclase=' + g_q + cclase + g_q +
      ' and   titulo=' + g_q + lv.Selected.SubItems[ 0 ] + g_q ) = false then begin
      Application.MessageBox( pchar( dm.xlng( 'ERROR... no puede borrar en tsdocum' ) ),
         pchar( dm.xlng( 'Actualizar documentación' ) ), MB_OK );
      screen.cursor := crdefault;
      abort;
   end;
   if dm.sqldelete( 'delete tsblob where cblob=' + g_q + lv.Selected.SubItems[ 3 ] + g_q ) = false then begin
      Application.MessageBox( pchar( dm.xlng( 'ERROR... no puede borrar en tsblob' ) ),
         pchar( dm.xlng( 'Actualizar documentación' ) ), MB_OK );
      screen.cursor := crdefault;
      abort;
   end;
   arma( cprog, cbib, cclase );
   screen.cursor := crdefault;
end;

procedure Tftsdocumenta.popPopup( Sender: TObject );
begin
   if lv.SelCount = 0 then
      abort;
   editar.Visible := ( lv.Selected.Caption <> '...' );
end;

procedure Tftsdocumenta.EditarClick( Sender: TObject );
var
   arch, cblob, magic, fecha, titulo: string;
begin
   if lv.SelCount = 0 then
      exit;
   if lv.Selected.SubItems[ 2 ] <> g_usuario then
      if dm.capacidad( 'Documenta - Actualizar documentos' ) = false then begin
         Application.MessageBox( pchar( dm.xlng( 'No tiene capacidad para actualizar documentos ajenos' ) ),
            pchar( dm.xlng( 'Editar documentación' ) ), MB_OK );
         screen.cursor := crdefault;
         exit;
      end;
   titulo := lv.Selected.SubItems[ 0 ];
   if lv.Selected.Caption <> '...' then begin
      if dm.sqlselect( dm.q1, 'select * from tsdocum ' +
         ' where cprog=' + g_q + cprog + g_q +
         ' and   cbib=' + g_q + cbib + g_q +
         ' and   cclase=' + g_q + cclase + g_q +
         ' and   titulo=' + g_q + titulo + g_q ) then begin
         arch := g_ruta + dm.q1.fieldbyname( 'cblob' ).AsString + '.' + lv.Selected.Caption;
         dm.blob2file( dm.q1.fieldbyname( 'cblob' ).AsString, arch );
         dm.ejecuta_espera( arch, SW_HIDE );
         cblob := dm.file2blob( arch, magic );
         fecha := dm.datedb( formatdatetime( 'YYYY/MM/DD HH:NN:SS', now ), 'YYYY/MM/DD HH24:MI:SS' );
         if dm.sqlupdate( 'update tsdocum set ' +
            ' cblob=' + g_q + cblob + g_q + ',' +
            ' magic=' + g_q + magic + g_q + ',' +
            ' fecha=' + fecha +
            ' where cprog=' + g_q + cprog + g_q +
            ' and   cbib=' + g_q + cbib + g_q +
            ' and   cclase=' + g_q + cclase + g_q +
            ' and   titulo=' + g_q + titulo + g_q ) = false then begin
            Application.MessageBox( pchar( dm.xlng( 'ERROR... no puede actualizar en tsdocum' ) ),
               pchar( dm.xlng( 'Editar documentación' ) ), MB_OK );
            abort;
         end;
         dm.sqldelete( 'delete tsblob where cblob=' + g_q + lv.Selected.SubItems[ 3 ] + g_q );
         deletefile( arch );
         arma( cprog, cbib, cclase );
      end;
   end;
end;

procedure Tftsdocumenta.lvDblClick( Sender: TObject );
var
   titulo, arch: string;
begin
   if lv.SelCount = 0 then
      exit;
   screen.cursor := crsqlwait;
   titulo := lv.Selected.SubItems[ 0 ];
   if lv.Selected.Caption <> '...' then begin
      if dm.sqlselect( dm.q1, 'select * from tsdocum ' +
         ' where cprog=' + g_q + cprog + g_q +
         ' and   cbib=' + g_q + cbib + g_q +
         ' and   cclase=' + g_q + cclase + g_q +
         ' and   titulo=' + g_q + titulo + g_q ) then begin
         arch := g_ruta + dm.q1.fieldbyname( 'cblob' ).AsString + '.' + lv.Selected.Caption;
         dm.blob2file( dm.q1.fieldbyname( 'cblob' ).AsString, arch );
         ShellExecute( Handle, 'open', pchar( arch ), nil, nil, SW_SHOW );
         g_borrar.Add( arch );
      end;
   end;
   screen.cursor := crdefault;
end;

procedure Tftsdocumenta.FormCreate( Sender: TObject );
begin
   if g_language = 'ENGLISH' then begin
      lv.Columns[ 0 ].Caption := 'Type';
      lv.Columns[ 1 ].Caption := 'Title';
      lv.Columns[ 2 ].Caption := 'Date';
      lv.Columns[ 3 ].Caption := 'User';
      lv.Columns[ 4 ].Caption := 'ID';
      mnuGuardar.Caption := 'Save';
      mnuAnexar.Caption := 'Attachment';
      //bsalir.Hint := 'Exit';
   end;
   mnuPrincipal.Style := gral.iPubEstiloActivo;

   if gral.iPubVentanasActivas > 0 then
      gral.PubExpandeMenuVentanas( True );
end;

procedure Tftsdocumenta.Cut1Click( Sender: TObject );
begin
   //re.CutToClipboard;
   //txtEditor.CutToClipboard;
end;

procedure Tftsdocumenta.Copy1Click( Sender: TObject );
begin
   //re.CopyToClipboard;
   //txtEditor.CopyToClipboard;
end;

procedure Tftsdocumenta.Paste1Click( Sender: TObject );
begin
   //re.PasteFromClipboard;
   //txtEditor.PasteFromClipboard;
end;

procedure Tftsdocumenta.FormClose( Sender: TObject;
   var Action: TCloseAction );
begin
   if FormStyle = fsMDIChild then
      Action := caFree;
end;

procedure Tftsdocumenta.FormDestroy( Sender: TObject );
begin
   dm.PubEliminarVentanaActiva( Caption );

   if gral.iPubVentanasActivas in [ 0, 1 ] then
      gral.PubExpandeMenuVentanas( False );
end;

procedure Tftsdocumenta.mnuCancelarClick( Sender: TObject );
begin
   if application.MessageBox( pchar( dm.xlng( 'Desea limpiar el área de captura?' ) ), pchar( dm.xlng( 'Confirmar' ) ), MB_YESNO ) = IDNO then
      exit;
   //re.Lines.Clear;
   txtEditor.RichViewEdit.SelectAll;
   txtEditor.RichViewEdit.DeleteSelection;

   mnuGuardar.Caption := dm.xlng( 'Guardar' );
   mnuGuardar.Enabled := false;
   mnuCancelar.Enabled := false;
end;

procedure Tftsdocumenta.mnuGuardarClick( Sender: TObject );
var
   titulo, cblob, magic, arch, fecha, tipo: string;
begin
   if mnuGuardar.Caption = dm.xlng( 'Actualizar' ) then begin
      if lv.Selected.SubItems[ 2 ] <> g_usuario then
         if dm.capacidad( 'Documenta - Actualizar documentos' ) = false then begin
            Application.MessageBox( pchar( dm.xlng( 'No tiene capacidad para actualizar documentos ajenos' ) ),
               pchar( dm.xlng( 'Actualizar documentación ' ) ), MB_OK );
            screen.cursor := crdefault;
            exit;
         end;
      actualiza;
      exit;
   end;
   //titulo := inputbox( 'Capture', dm.xlng( 'Titulo del documento' ), copy( trim( copy( re.Text, 1, 200 ) ), 1, 80 ) );
   titulo := inputbox( 'Capture', dm.xlng( 'Titulo del documento' ), '' );

   if trim( titulo ) = '' then
      exit;
   arch := g_ruta + 'docux.rtf';
   //re.Lines.SaveToFile( arch );
   txtEditor.RichViewEdit.SaveRTF( arch, False );

   cblob := dm.file2blob( arch, magic );
   fecha := dm.datedb( formatdatetime( 'YYYY/MM/DD HH:NN:SS', now ), 'YYYY/MM/DD HH24:MI:SS' );
   tipo := '...';
   if dm.sqlinsert( 'insert into tsdocum (cprog,cbib,cclase,titulo,fecha,tipo,cuser,cblob,magic) values(' +
      g_q + cprog + g_q + ',' +
      g_q + cbib + g_q + ',' +
      g_q + cclase + g_q + ',' +
      g_q + titulo + g_q + ',' +
      fecha + ',' +
      g_q + tipo + g_q + ',' +
      g_q + g_usuario + g_q + ',' +
      g_q + cblob + g_q + ',' +
      g_q + magic + g_q + ')' ) = false then begin
      Application.MessageBox( pchar( dm.xlng( 'ERROR... no puede insertar en tsdocum' ) ),
         pchar( dm.xlng( 'Actualizar documentación ' ) ), MB_OK );
      abort;
   end;
   deletefile( arch );
   arma( cprog, cbib, cclase );
   //re.Lines.Clear;
   txtEditor.RichViewEdit.SelectAll;
   txtEditor.RichViewEdit.DeleteSelection;

   mnuGuardar.Enabled := false;
   mnuCancelar.Enabled := false;
end;

procedure Tftsdocumenta.mnuAnexarClick( Sender: TObject );
var
   titulo, cblob, magic, arch, fecha, tipo: string;
begin
   if opendialog1.Execute = false then
      exit;
   arch := opendialog1.FileName;
   if fileexists( arch ) = false then begin
      Application.MessageBox( pchar( dm.xlng( 'ERROR... no existe el archivo ' + arch ) ),
         pchar( dm.xlng( 'Anexos ' ) ), MB_OK );
      abort;
   end;
   titulo := extractfilename( arch );
   if inputquery( 'Capture', dm.xlng( 'Titulo del Anexo' ), titulo ) = false then
      exit;
   titulo := trim( titulo );
   if titulo = '' then
      exit;
   screen.cursor := crsqlwait;
   cblob := dm.file2blob( arch, magic );
   fecha := dm.datedb( formatdatetime( 'YYYY/MM/DD HH:NN:SS', now ), 'YYYY/MM/DD HH24:MI:SS' );
   tipo := extractfileext( arch );
   if dm.sqlselect( dm.q1, 'select titulo from tsdocum ' +
      ' where cprog=' + g_q + cprog + g_q +
      ' and   cbib=' + g_q + cbib + g_q +
      ' and   cclase=' + g_q + cclase + g_q +
      ' and   titulo=' + g_q + titulo + g_q ) then begin
      Application.MessageBox( pchar( dm.xlng( 'ERROR... El titulo "' + titulo + '" ya existe' ) ),
         pchar( dm.xlng( 'Anexos ' ) ), MB_OK );
      screen.cursor := crdefault;
      abort;
   end;
   if dm.sqlinsert( 'insert into tsdocum (cprog,cbib,cclase,titulo,fecha,tipo,cuser,cblob,magic) values(' +
      g_q + cprog + g_q + ',' +
      g_q + cbib + g_q + ',' +
      g_q + cclase + g_q + ',' +
      g_q + titulo + g_q + ',' +
      fecha + ',' +
      g_q + tipo + g_q + ',' +
      g_q + g_usuario + g_q + ',' +
      g_q + cblob + g_q + ',' +
      g_q + magic + g_q + ')' ) = false then begin
      Application.MessageBox( pchar( dm.xlng( 'ERROR... no puede insertar en tsdocum' ) ),
         pchar( dm.xlng( 'Anexos ' ) ), MB_OK );
      screen.cursor := crdefault;
      abort;
   end;
   arma( cprog, cbib, cclase );
   screen.cursor := crdefault;
end;

procedure Tftsdocumenta.mnuEliminarClick( Sender: TObject );
begin
   screen.cursor := crsqlwait;
   if lv.Selected.SubItems[ 2 ] <> g_usuario then
      if dm.capacidad( 'Documenta - Borrar documentos' ) = false then begin
         Application.MessageBox( pchar( dm.xlng( 'No tiene capacidad para eliminar documentos ajenos' ) ),
            pchar( dm.xlng( 'Actualizar documentación' ) ), MB_OK );
         screen.cursor := crdefault;
         exit;
      end;
   if dm.sqldelete( 'delete tsdocum ' +
      ' where cprog=' + g_q + cprog + g_q +
      ' and   cbib=' + g_q + cbib + g_q +
      ' and   cclase=' + g_q + cclase + g_q +
      ' and   titulo=' + g_q + lv.Selected.SubItems[ 0 ] + g_q ) = false then begin
      Application.MessageBox( pchar( dm.xlng( 'ERROR... no puede borrar en tsdocum' ) ),
         pchar( dm.xlng( 'Actualizar documentación' ) ), MB_OK );
      screen.cursor := crdefault;
      abort;
   end;
   if dm.sqldelete( 'delete tsblob where cblob=' + g_q + lv.Selected.SubItems[ 3 ] + g_q ) = false then begin
      Application.MessageBox( pchar( dm.xlng( 'ERROR... no puede borrar en tsblob' ) ),
         pchar( dm.xlng( 'Actualizar documentación' ) ), MB_OK );
      screen.cursor := crdefault;
      abort;
   end;
   arma( cprog, cbib, cclase );
   screen.cursor := crdefault;
end;

procedure Tftsdocumenta.mnuEditarClick( Sender: TObject );
var
   arch, cblob, magic, fecha, titulo: string;
begin
   if lv.SelCount = 0 then
      exit;
   if lv.Selected.SubItems[ 2 ] <> g_usuario then
      if dm.capacidad( 'Documenta - Actualizar documentos' ) = false then begin
         Application.MessageBox( pchar( dm.xlng( 'No tiene capacidad para actualizar documentos ajenos' ) ),
            pchar( dm.xlng( 'Editar documentación' ) ), MB_OK );
         screen.cursor := crdefault;
         exit;
      end;
   titulo := lv.Selected.SubItems[ 0 ];
   if lv.Selected.Caption <> '...' then begin
      if dm.sqlselect( dm.q1, 'select * from tsdocum ' +
         ' where cprog=' + g_q + cprog + g_q +
         ' and   cbib=' + g_q + cbib + g_q +
         ' and   cclase=' + g_q + cclase + g_q +
         ' and   titulo=' + g_q + titulo + g_q ) then begin
         arch := g_ruta + dm.q1.fieldbyname( 'cblob' ).AsString + '.' + lv.Selected.Caption;
         dm.blob2file( dm.q1.fieldbyname( 'cblob' ).AsString, arch );
         dm.ejecuta_espera( arch, SW_HIDE );
         cblob := dm.file2blob( arch, magic );
         fecha := dm.datedb( formatdatetime( 'YYYY/MM/DD HH:NN:SS', now ), 'YYYY/MM/DD HH24:MI:SS' );
         if dm.sqlupdate( 'update tsdocum set ' +
            ' cblob=' + g_q + cblob + g_q + ',' +
            ' magic=' + g_q + magic + g_q + ',' +
            ' fecha=' + fecha +
            ' where cprog=' + g_q + cprog + g_q +
            ' and   cbib=' + g_q + cbib + g_q +
            ' and   cclase=' + g_q + cclase + g_q +
            ' and   titulo=' + g_q + titulo + g_q ) = false then begin
            Application.MessageBox( pchar( dm.xlng( 'ERROR... no puede actualizar en tsdocum' ) ),
               pchar( dm.xlng( 'Editar documentación' ) ), MB_OK );
            abort;
         end;
         dm.sqldelete( 'delete tsblob where cblob=' + g_q + lv.Selected.SubItems[ 3 ] + g_q );
         deletefile( arch );
         arma( cprog, cbib, cclase );
      end;
   end;
end;

procedure Tftsdocumenta.FormActivate( Sender: TObject );
begin
   iHelpContext := IDH_TOPIC_T02700;
   g_producto := 'MENÚ CONTEXTUAL-DOCUMENTACIÓN';
end;

procedure Tftsdocumenta.txtEditorChange( Sender: TObject );
begin
   mnuCancelar.Enabled := true;
   mnuGuardar.Enabled := true;
end;

end.

