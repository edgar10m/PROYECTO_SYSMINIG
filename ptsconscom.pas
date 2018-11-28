unit ptsconscom;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, StdCtrls, ADODB, ExtCtrls, ComCtrls, dxBar, shellapi, Buttons,
   HTML_HELP, htmlhlp;
type
   Tftsconscom = class( TForm )
      Panel1: TPanel;
      Panel2: TPanel;
      cmbclase: TComboBox;
      Label3: TLabel;
      txtfil: TEdit;                                      
      lv: TListView;
      bproyecto: TButton;
      cmbproyecto: TComboBox;
      lblproyecto: TLabel;
      Label1: TLabel;
      Label5: TLabel;
      mnuPrincipal: TdxBarManager;
      mnuAgregarParaConsulta: TdxBarButton;
      mnuMas: TdxBarButton;
      lbltotal: TLabel;
      BitBtn1: TBitBtn;
      BitBtn2: TBitBtn;
      mnuImprimir: TdxBarButton;
      procedure cmbclaseChange( Sender: TObject );
      procedure bokClick( Sender: TObject );
      procedure bcancelClick( Sender: TObject );
      //procedure bmasClick( Sender: TObject );
      procedure lvDblClick( Sender: TObject );
      procedure lvClick( Sender: TObject );
      procedure txtfilClick( Sender: TObject );
      procedure FormActivate( Sender: TObject );
      procedure bproyectoClick( Sender: TObject );
      procedure cmbproyectoChange( Sender: TObject );
      procedure buscarText;
      procedure FormClose( Sender: TObject; var Action: TCloseAction );
      procedure Button1Click( Sender: TObject );
      function  ArmarOpciones(b1:Tstringlist):integer;
      procedure FormDestroy(Sender: TObject);
      procedure mnuAgregarAlProyectoClick(Sender: TObject);
      procedure mnuAgregarParaConsultaClick(Sender: TObject);
      procedure mnuCancelarClick(Sender: TObject);
      procedure mnuMasClick(Sender: TObject);
      procedure BitBtn1Click(Sender: TObject);
      procedure BitBtn2Click(Sender: TObject);
      procedure mnuImprimirClick(Sender: TObject);
      procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    function FormHelp(Command: Word; Data: Integer;
      var CallHelp: Boolean): Boolean;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);


   private
      { Private declarations }
      qq: TADOquery;
      n: integer;
      clase: string;
      Opciones: Tstringlist;
      Wclase  : string;
      Wnumreg : integer;
   public
      { Public declarations }
      titulo: string;
      estado: boolean;
   end;

var
   a: string;
   ftsconscom: Tftsconscom;

implementation
uses ptsdm, parbol, ptsgral;
{$R *.dfm}

procedure Tftsconscom.cmbclaseChange( Sender: TObject );
begin
   screen.Cursor := crsqlwait;
   lv.Items.Clear;
   screen.Cursor := crdefault;
   clase := copy( cmbclase.Text, 1, 3 );
   if copy(clase,1,1) = '*' then
      clase := '';
end;

procedure Tftsconscom.bokClick( Sender: TObject );
var
   i: integer;
begin
   for i := 0 to lv.Items.Count - 1 do begin
      if lv.items[ i ].Selected then begin
         //farbol.agrega_componente( lv.Items[ i ].SubItems[ 0 ], lv.Items[ i ].Caption, clase, nil,
         farbol.agrega_componente( lv.Items[ i ].SubItems[ 0 ], lv.Items[ i ].Caption, lv.Items[ i ].SubItems[ 1 ], nil,
            '', '', 'CONSULTA' );
      end;
   end;
end;

procedure Tftsconscom.bcancelClick( Sender: TObject );
begin
   cmbclase.clear;
   txtfil.Clear;
   lv.Clear;
end;

{procedure Tftsconscom.bmasClick( Sender: TObject );
var
   ite: Tlistitem;
begin
   while not qq.Eof do begin
      ite := lv.Items.Add;
      ite.Caption := qq.fieldbyname( 'hcbib' ).AsString;
      ite.SubItems.Add( qq.fieldbyname( 'hcprog' ).AsString );
      qq.Next;
      n := n + 1;
      if n mod 1000 = 0 then
         break;
   end;
   if not qq.Eof then begin
      lbltotal.Caption := 'Total  ' + inttostr( qq.RecordCount ) + '  (1 - ' + inttostr( n ) + ')';
      bmas.Visible := true;
   end
   else begin
      lbltotal.Caption := 'Total  ' + inttostr( qq.RecordCount );
      bmas.Visible := false;
   end;
end;
}
procedure Tftsconscom.lvDblClick( Sender: TObject );
var
   i, y : Integer;
begin
   for i := 0 to lv.Items.Count - 1 do begin
      if lv.items[ i ].Selected then begin
        bgral := lv.Items[ i ].SubItems[ 0 ]+' '+lv.Items[ i ].Caption+' '+lv.Items[ i ].SubItems[ 1 ];
       //bgral := lv.Items[ i ].SubItems[ 0 ]+' '+lv.Items[ i ].Caption+' '+clase;
        Opciones := gral.ArmarMenuConceptualWeb( bgral, 'consulta_componentes' );
        y:=ArmarOpciones(Opciones);
        gral.PopGral.Popup(g_X, g_Y);
      end;
   end;

//   bokclick( sender );
end;

procedure Tftsconscom.lvClick( Sender: TObject );
var
   i, y : Integer;
begin
   gral.popgral.Items.Clear;
   mnuAgregarParaConsulta.Enabled := ( lv.ItemIndex > -1 );
end;

procedure Tftsconscom.txtfilClick( Sender: TObject );
begin
   txtfil.SetFocus;
end;

procedure Tftsconscom.FormActivate( Sender: TObject );
var
   proy: string;
begin
   buscarText; //esta rutina puede servir en el futuro para una busqueda màs amplia.

   proy := cmbproyecto.Text;
   dm.feed_combo( cmbproyecto, 'select distinct cproyecto ' +
      ' from tsuserpro' +
      ' where cuser=' + g_q + g_usuario + g_q +
      ' order by cproyecto' );
   cmbproyecto.Visible := ( cmbproyecto.items.Count > 0 );
   cmbproyecto.ItemIndex := cmbproyecto.Items.IndexOf( proy );
   bproyecto.Visible := cmbproyecto.Visible;
   bproyecto.Enabled := ( cmbproyecto.Text <> '' );
   lblproyecto.Visible := cmbproyecto.Visible;
   iHelpContext:=HTML_HELP.IDH_TOPIC_T01300;
end;

procedure Tftsconscom.bproyectoClick( Sender: TObject );
var
   i: integer;
   nodo: Ttreenode;
   Wproy: string;
begin
   if cmbproyecto.Text = '' then
      exit;
   for i := 0 to farbol.nodo_proyecto.Count - 1 do begin
      if farbol.nodo_proyecto.Item[ i ].Text = cmbproyecto.Text then begin
         nodo := farbol.nodo_proyecto.Item[ i ];
         break;
      end;
   end;

   for i := 0 to lv.Items.Count - 1 do begin
      if lv.items[ i ].Selected then begin
         //if farbol.alta_a_proyecto( lv.Items[ i ].SubItems[ 0 ], lv.Items[ i ].Caption, clase, cmbproyecto.Text ) then begin
            //farbol.agrega_componente( lv.Items[ i ].SubItems[ 0 ], lv.Items[ i ].Caption, clase, nodo,
         if farbol.alta_a_proyecto( lv.Items[ i ].SubItems[ 0 ], lv.Items[ i ].Caption, lv.Items[ i ].SubItems[ 1 ], cmbproyecto.Text ) then begin
            farbol.agrega_componente( lv.Items[ i ].SubItems[ 0 ], lv.Items[ i ].Caption, lv.Items[ i ].SubItems[ 1 ], nodo,
               cmbproyecto.text, '', 'USERPRO' );
            Wproy := cmbproyecto.text;
            Application.MessageBox( 'Componente agregado al proyecto', pansichar( Wproy ), MB_OK );
         end;
      end;
   end;
end;

procedure Tftsconscom.cmbproyectoChange( Sender: TObject );
begin
   bproyecto.Enabled := ( cmbproyecto.Text <> '' );
end;

procedure Tftsconscom.buscarText;
var
   b, ii: Integer;
   s, ss, st: string;
begin
{   b := length( buscar.Text );
   if ( b = 0 ) or ( buscar.Text = ' ' ) then
      buscar.Text := '*';

   if ( buscar.Text = '*' ) or
      ( buscar.Text = '%' ) then
      b := 0;
   s := buscar.Text;
   s := UpCase( s[ 1 ] );
   cmbclase.clear;
   lv.Items.Clear;
   txtfil.clear;
}
//   if b = 0 then
     dm.feed_combo( cmbclase, 'select cclase||' + g_q + ',' + g_q + '||descripcion from tsclase order by cclase' );

   ///////////    dm.feed_combo1( cmbclase, 'select unique hcclase from tsrela order by hcclase');
{   else begin
      s := buscar.Text;
      for ii := 1 to b do begin
         ss := UpCase( s[ ii ] );
         st := st + ss;
      end;
      //busca texto en el nombre y descripcion de la clase con minúsculas y mayúsculas. //
      dm.feed_combo( cmbclase, 'select cclase||' + g_q + ',' + g_q + '||descripcion from tsclase  where cclase like '
         + g_q + '%' + st + '%' + g_q + ' or descripcion like ' + g_q + '%' + st + '%' + g_q + ' or cclase like '
         + g_q + '%' + s + '%' + g_q + ' or descripcion like ' + g_q + '%' + s + '%' + g_q
         + ' order by cclase' );

   end;
}
   qq := Tadoquery.Create( self );
   qq.Connection := dm.ADOConnection1;
end;

procedure Tftsconscom.FormClose( Sender: TObject; var Action: TCloseAction );
begin
   cmbclase.clear;
   lv.Clear;
   txtfil.clear;
   if FormStyle = fsMDIChild then
      Action := caFree;
end;

procedure Tftsconscom.Button1Click( Sender: TObject );
var
   o, n: integer;
   c, cc: string;
begin
   screen.Cursor := crsqlwait;
   lbltotal.Caption := 'Total: ';
   lv.Items.Clear;
   Wclase := ' where hcclase=' + g_q + clase + g_q;
   if txtfil.Text = '' then
      txtfil.Text := '*';
   clase := trim( clase );
   if clase = '' then begin
      o := cmbclase.items.count;
      for n := 1 to o - 1 do begin
         c := copy( cmbclase.items[ n ], 1, 3 );
         if n = 1 then
            cc := c
         else
            cc := cc + '?' + c;
      end;
      cc := stringreplace( cc, '?', g_q + ',' + g_q, [ rfreplaceall ] );
      Wclase := 'where hcclase in(' + g_q + cc + g_q + ')';
   end;

   if dm.sqlselect( qq, 'select distinct hcprog,hcbib from tsrela ' +
      Wclase +
      ' and hcprog like ' + g_q + stringreplace( txtfil.Text, '*', '%', [ rfreplaceall ] ) + g_q +
      ' order by hcprog' ) then begin
      Wnumreg :=  qq.RecordCount;
      lbltotal.Caption := 'Total: ' + inttostr( Wnumreg );
      n := 0;
      mnuMasClick( sender );
   end;
   screen.Cursor := crdefault;
end;

function Tftsconscom.ArmarOpciones(b1:Tstringlist):integer;
 var
     titulo    : string;
     mm      : Tstringlist;
begin
   mm:=Tstringlist.Create;
   mm.CommaText:=bgral;
   if mm.count < 3 then begin
      Application.MessageBox(pchar(dm.xlng('Falta Nombre ó biblioteca ó clase')),
                             pchar(dm.xlng('Consulta de componentes ')), MB_OK );
      mm.free;
      exit;
   end;
   //titulo:=Nombre_proc+'  '+mm[0]+' '+mm[1]+' '+mm[2];
   gral.EjecutaOpcionB (b1,'Consulta de Componentes');
   mm.free;

end;


procedure Tftsconscom.FormDestroy(Sender: TObject);
begin
    if FormStyle = fsMDIChild then
       dm.PubEliminarVentanaActiva( Caption );

   if gral.iPubVentanasActivas in [ 0, 1 ] then  
      gral.PubExpandeMenuVentanas( False );
end;


procedure Tftsconscom.mnuAgregarAlProyectoClick(Sender: TObject);
var
   i: integer;
   nodo: Ttreenode;
   Wproy: string;
begin
   if cmbproyecto.Text = '' then
      exit;
   for i := 0 to farbol.nodo_proyecto.Count - 1 do begin
      if farbol.nodo_proyecto.Item[ i ].Text = cmbproyecto.Text then begin
         nodo := farbol.nodo_proyecto.Item[ i ];
         break;
      end;
   end;
   for i := 0 to lv.Items.Count - 1 do begin
      if lv.items[ i ].Selected then begin
         //if farbol.alta_a_proyecto( lv.Items[ i ].SubItems[ 0 ], lv.Items[ i ].Caption, clase, cmbproyecto.Text ) then begin
            //farbol.agrega_componente( lv.Items[ i ].SubItems[ 0 ], lv.Items[ i ].Caption, clase, nodo,
         if farbol.alta_a_proyecto( lv.Items[ i ].SubItems[ 0 ], lv.Items[ i ].Caption, lv.Items[ i ].SubItems[ 1 ], cmbproyecto.Text ) then begin
            farbol.agrega_componente( lv.Items[ i ].SubItems[ 0 ], lv.Items[ i ].Caption, lv.Items[ i ].SubItems[ 1 ], nodo,
               cmbproyecto.text, '', 'USERPRO' );
            Wproy := cmbproyecto.text;
            Application.MessageBox( 'Componente agregado al proyecto', pansichar( Wproy ), MB_OK );
         end;
      end;
   end;
end;


procedure Tftsconscom.mnuAgregarParaConsultaClick(Sender: TObject);
var
   i: integer;
begin
   for i := 0 to lv.Items.Count - 1 do begin
      if lv.items[ i ].Selected then begin
         //farbol.agrega_componente( lv.Items[ i ].SubItems[ 0 ], lv.Items[ i ].Caption, clase, nil,
         farbol.agrega_componente( lv.Items[ i ].SubItems[ 0 ], lv.Items[ i ].Caption, lv.Items[ i ].SubItems[ 1 ], nil,
            '', '', 'CONSULTA' );
      end;
   end;
end;

procedure Tftsconscom.mnuCancelarClick(Sender: TObject);
begin
   cmbclase.clear;

   txtfil.Clear;
   lv.Clear;
end;

procedure Tftsconscom.mnuMasClick(Sender: TObject);
var
   ite: Tlistitem;
begin

   while not qq.Eof do begin
      ite := lv.Items.Add;
      ite.Caption := qq.fieldbyname( 'hcbib' ).AsString;
      ite.SubItems.Add( qq.fieldbyname( 'hcprog' ).AsString );
      ite.SubItems.Add( qq.fieldbyname( 'hcclase' ).AsString );
      ite.SubItems.Add( qq.fieldbyname( 'lineas_blanco' ).AsString );
      ite.SubItems.Add( qq.fieldbyname( 'lineas_total' ).AsString );
      ite.SubItems.Add( qq.fieldbyname( 'lineas_comentario' ).AsString );
      ite.SubItems.Add( qq.fieldbyname( 'lineas_efectivas' ).AsString );
      qq.Next;
      n := n + 1;
      if n mod 1000 = 0 then
         break;
   end;

   if not qq.Eof then begin
      lbltotal.Caption := 'Total  ' + inttostr( Wnumreg ) + '  (1 - ' + inttostr( n ) + ')';
      mnuMas.Visible := ivAlways;
   end
   else begin
      lbltotal.Caption := 'Total  ' + inttostr( Wnumreg );
      mnuMas.Visible := ivNever;
   end;
end;


procedure Tftsconscom.BitBtn1Click(Sender: TObject);
var
   o, n: integer;
   c, cc : string;
begin
   screen.Cursor := crsqlwait;
   mnuImprimir.Visible := ivNever;
   lbltotal.Caption := 'Total: ';
   lv.Items.Clear;
   Wclase := ' where hcclase=' + g_q + clase + g_q;
   if txtfil.Text = '' then
      txtfil.Text := '*';
   clase := trim( clase );
   if clase = '' then begin
      o := cmbclase.items.count;
      for n := 1 to o - 1 do begin
         c := copy( cmbclase.items[ n ], 1, 3 );
         if n = 1 then
            cc := c
         else
            cc := cc + '?' + c;
      end;
      cc := stringreplace( cc, '?', g_q + ',' + g_q, [ rfreplaceall ] );
      Wclase := 'where hcclase in(' + g_q + cc + g_q + ')';
   end;

   if dm.sqlselect( qq, 'select distinct x.hcprog,x.hcbib ,x.hcclase ,t.lineas_blanco,t.lineas_total,t.lineas_comentario,t.lineas_efectivas  from tsrela x, tsproperty t ' +
      Wclase +
      ' and x.hcprog like ' + g_q + stringreplace( txtfil.Text, '*', '%', [ rfreplaceall ] ) + g_q +
      ' and x.hcprog = t.cprog and x.hcbib=t.cbib ' +
      'UNION ALL  '+
      ' select distinct x.hcprog ,x.hcbib ,x.hcclase ,0 lineas_blanco,0 lineas_total,0 lineas_comentario,0 lineas_efectivas  '+
      ' from tsrela x  '+
      Wclase +
      ' and x.hcprog like ' + g_q + stringreplace( txtfil.Text, '*', '%', [ rfreplaceall ] ) + g_q +
      ' and x.hcprog not in (select t.cprog from tsproperty t where t.cprog=x.hcprog and t.cbib=x.hcbib and t.cclase=x.hcclase) ' +
      ' order by hcprog' ) then begin
      Wnumreg :=  qq.RecordCount;
      lbltotal.Caption := 'Total: ' + inttostr( Wnumreg );
      mnuImprimir.Visible := ivAlways;
      n := 0;
      mnuMasClick( sender );
   end else begin
      Application.MessageBox(pchar(dm.xlng('No encontro informaciòn ')),
                             pchar(dm.xlng('Consulta de Componentes ')), MB_OK );
   end;
   screen.Cursor := crdefault;
end;


procedure Tftsconscom.BitBtn2Click(Sender: TObject);
begin
   cmbclase.clear;
   txtfil.Clear;
   lv.Clear;
   mnuImprimir.Visible := ivNever;
   lbltotal.Caption :=  ' ';
end;

procedure Tftsconscom.mnuImprimirClick(Sender: TObject);
var
   i : Integer;
   sl : Tstringlist;
   archivocsv : string;
begin
   sl := Tstringlist.create;

{   if dm.sqlselect( dm.q1, 'select distinct hcprog,hcbib from tsrela ' +
      Wclase +
      ' and hcprog like ' + g_q + stringreplace( txtfil.Text, '*', '%', [ rfreplaceall ] ) + g_q +
      ' order by hcprog' ) then begin}


  {if (clase ='BFR') or (clase= 'WHH') or (clase = 'BMS') then begin

    if dm.sqlselect( dm.q1, 'select distinct x.hcprog,x.hcbib ,x.hcclase ,t.lineas_blanco,t.lineas_total,t.lineas_comentario,t.lineas_efectivas  from tsrela x, tsattribute t ' +
      Wclase +
      ' and x.hcprog like ' + g_q + stringreplace( txtfil.Text, '*', '%', [ rfreplaceall ] ) + g_q +
      ' and x.hcprog = t.cprog and x.hcbib=t.cbib ' +
      'UNION ALL  '+
      ' select distinct x.hcprog ,x.hcbib ,x.hcclase ,0 lineas_blanco,0 lineas_total,0 lineas_comentario,0 lineas_efectivas  '+
      ' from tsrela x  '+
      Wclase +
      ' and x.hcprog like ' + g_q + stringreplace( txtfil.Text, '*', '%', [ rfreplaceall ] ) + g_q +
      ' and x.hcprog not in (select t.cprog from tsattribute t where t.cprog=x.hcprog and t.cbib=x.hcbib and t.cclase=x.hcclase) ' +
      ' order by hcprog' ) then begin
      sl.Add('Componente,Libreria,Clase,Líneas en blanco,Total de líneas,Líneas de Comentario,Líneas efectivas');
      while not dm.q1.Eof do begin
          sl.add( dm.q1.fieldbyname( 'hcprog' ).AsString+','+dm.q1.fieldbyname( 'hcbib' ).AsString +','+clase+','+
                  dm.q1.fieldbyname( 'lineas_blanco' ).AsString+','+dm.q1.fieldbyname( 'lineas_total' ).AsString+','+
                  dm.q1.fieldbyname( 'lineas_comentario' ).AsString+','+dm.q1.fieldbyname( 'lineas_efectivas' ).AsString);
          dm.q1.Next;
      end;
      archivocsv:=g_tmpdir+'\Cons'+clase+formatdatetime('YYYYMMDDHHNNSS',now)+'.csv';
      sl.SaveToFile(archivocsv);
      if ShellExecute(Handle, nil,pchar(archivocsv),nil, nil, SW_SHOW) <= 32 then
          Application.MessageBox(pchar(dm.xlng('No puede ejecutar '+archivocsv)),
                                 pchar(dm.xlng('Error')), MB_ICONEXCLAMATION);
    end;
   end
   else begin
}
   if dm.sqlselect( dm.q1, 'select distinct x.hcprog,x.hcbib ,x.hcclase ,t.lineas_blanco,t.lineas_total,t.lineas_comentario,t.lineas_efectivas  from tsrela x, tsproperty t ' +
      Wclase +
      ' and x.hcprog like ' + g_q + stringreplace( txtfil.Text, '*', '%', [ rfreplaceall ] ) + g_q +
      ' and x.hcprog = t.cprog and x.hcbib=t.cbib ' +
      'UNION ALL  '+
      ' select distinct x.hcprog ,x.hcbib ,x.hcclase ,0 lineas_blanco,0 lineas_total,0 lineas_comentario,0 lineas_efectivas  '+
      ' from tsrela x  '+
      Wclase +
      ' and x.hcprog like ' + g_q + stringreplace( txtfil.Text, '*', '%', [ rfreplaceall ] ) + g_q +
      ' and x.hcprog not in (select t.cprog from tsproperty t where t.cprog=x.hcprog and t.cbib=x.hcbib and t.cclase=x.hcclase) ' +
      ' order by hcprog' ) then begin
      sl.Add('Componente,Libreria,Clase,Líneas en blanco,Total de líneas,Líneas de Comentario,Líneas efectivas');
      while not dm.q1.Eof do begin
          //sl.add( dm.q1.fieldbyname( 'hcprog' ).AsString+','+dm.q1.fieldbyname( 'hcbib' ).AsString +','+clase+','+
          sl.add( dm.q1.fieldbyname( 'hcprog' ).AsString+','+dm.q1.fieldbyname( 'hcbib' ).AsString +','+dm.q1.fieldbyname( 'hcclase' ).AsString+','+
                  dm.q1.fieldbyname( 'lineas_blanco' ).AsString+','+dm.q1.fieldbyname( 'lineas_total' ).AsString+','+
                  dm.q1.fieldbyname( 'lineas_comentario' ).AsString+','+dm.q1.fieldbyname( 'lineas_efectivas' ).AsString);
          dm.q1.Next;
      end;
      archivocsv:=g_tmpdir+'\Cons'+clase+formatdatetime('YYYYMMDDHHNNSS',now)+'.csv';
      sl.SaveToFile(archivocsv);
      if ShellExecute(Handle, nil,pchar(archivocsv),nil, nil, SW_SHOW) <= 32 then
          Application.MessageBox(pchar(dm.xlng('No puede ejecutar '+archivocsv)),
                                 pchar(dm.xlng('Error')), MB_ICONEXCLAMATION);
     end;
   //end;
   exit;
   sl.Free;
end;

procedure Tftsconscom.FormCreate(Sender: TObject);
begin

   mnuPrincipal.Style := gral.iPubEstiloActivo;

   if gral.iPubVentanasActivas > 0 then
      gral.PubExpandeMenuVentanas( True );

end;

procedure Tftsconscom.FormDeactivate(Sender: TObject);
begin
   gral.PopGral.Items.Clear;
end;

function Tftsconscom.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
   try
      HtmlHelp(Application.Handle,
            PChar(Format('%s::/T%5.5d.htm',
           //[Application.HelpFile,ActiveControl.HelpContext])),HH_DISPLAY_TOPIC, 0);
           [Application.HelpFile,iHelpContext ])),HH_DISPLAY_TOPIC, 0);
      CallHelp := False;
   except
      Application.MessageBox( 'No existe ayuda para la pantalla ó campo seleccionado','Ayuda ' , MB_OK );
   end;
end;

procedure Tftsconscom.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
      //iHelpContext:=ActiveControl.HelpContext;
      iHelpContext:=HTML_HELP.IDH_TOPIC_T01300;
end;

end.


