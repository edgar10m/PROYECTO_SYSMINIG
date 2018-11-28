unit ptsbfr;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, stdctrls, Extctrls, comctrls, dbgrids, filectrl, StrUtils,
   Menus, dxBar, Grids, Buttons, jpeg, MPlayer, ToolWin, ImgList;
type
   Tlineas = record
      nombre: string;
      inicio: integer;
      fin: integer;
   end;
type
   Tcompos = record
      compo: Tcomponent;
      nombre: string;
      tipo: string;
   end;
type
   Tstack=record
      nivel:integer;
      pp:string;
//      pp:Tpagecontrol;
   end;
type
   Tftsbfr = class( TForm )
      Image1: TImage;
      Memo1: TMemo;
      Splitter1: TSplitter;
    mnuPrincipal: TdxBarManager;
    ToolBar1: TToolBar;
    Image2: TImage;
    Image3: TImage;
    ToolButton1: TToolButton;
    ImageList1: TImageList;
      procedure Visible1Click( Sender: TObject );
      procedure Click( Sender: TObject );
      procedure FormClose( Sender: TObject; var Action: TCloseAction );
      procedure FormCreate(Sender: TObject);
      procedure FormDestroy(Sender: TObject);
   // procedure Image5Click(Sender: TObject);
    //======================================= MENU=========================
    procedure item_onclick(Sender: Tobject);
    //======================================================================
   private
      { Private declarations }
      w1, w2, w3: string;
      tabcontrol: Tstringlist;
      lis, tipo: Tstringlist;
      z: array of Tcompos;
      rut: array of Tlineas;
      nombre_anterior: string;
      nombres : TStringList;    //alk

      //======================================= MENU ========================
      xmenu:Tpanel;
      xitem:Tlabel;
      xsubitem:Tmenuitem;
      xpop:Tpopupmenu;
      //=====================================================================
      tabs: array of Ttabsheet;
      pagecontrol: Tpagecontrol;
      stacks:array of Tstack;
      procedure mainmenu_create;
      procedure item_create(captio:string);
      procedure subitem_create(captio:string);
      procedure mainmenu_display;
      //=====================================================================
      procedure separa( cadena: string );
      function valor( x: string ): integer;
      function entabs( w3: string ): integer;
      procedure alta_compo( compo: Tcomponent; nombre: string; tipo: string );
      procedure procesa_rutinas( n: integer );
      procedure agrega_tabs(n:integer);
      procedure nombretab (cap:string);
      function obtienePes (cad : string) : integer;
      procedure manda_atras();
   public
      { Public declarations }

      procedure arma( archivo: string );
   end;

var
   ftsbfr: Tftsbfr;
procedure PR_BFR( archivo: string; Titulo:string);

implementation

//uses Unit1;

uses ptsgral, ptsdm;
//ptsdm, parbol,ptsgral, ptsmain;

{$R *.dfm}

procedure PR_BFR( archivo: string; Titulo: string );
//var
   //titulo: string;
begin
    screen.Cursor := crsqlwait;
    gral.PubMuestraProgresBar( True );
    try
      //titulo := 'Vista Previa ' + archivo;
      Application.CreateForm( Tftsbfr, ftsbfr );
      ftsbfr.arma( archivo );
      ftsbfr.mainmenu_display;
      //Titulo := ftsbfr.Caption;
      ftsbfr.Caption := Titulo  ;
      ftsbfr.memo1.Visible := false;
      ftsbfr.splitter1.Visible := false;
      ftsbfr.Show;
      //ftsbfr.Refresh;
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;
//========================================= MENU =============================
procedure Tftsbfr.mainmenu_create;
begin
   xmenu:=Tpanel.Create(ftsbfr);
   xmenu.Parent:=ftsbfr;
   xmenu.Height:=19;
   xmenu.Caption:='';
   xmenu.Align:=altop;
   xmenu.Visible:=true;
   xmenu.Color:=clMenuBar;
end;
procedure Tftsbfr.item_onclick(sender: Tobject);
begin
   (sender as Tlabel).PopupMenu.Popup((parent as Tform).Left+left+(sender as Tlabel).Left+10,(parent as Tform).Top+top+49+51);
end;

//**********alk
procedure Tftsbfr.nombretab (cap:string);
var
  i : integer;
  t : string;
begin
   nombres.Clear;
   //ShowMessage(cap);
       for i:=1 to length(cap) do begin
          case cap[i] of
          'à','á': cap[i]:='a';
          'Á','À': cap[i]:='A';
          'è','é': cap[i]:='e';
          'É','È': cap[i]:='E';
          'ì','í': cap[i]:='i';
          'Í','Ì': cap[i]:='I';
          'ò','ó': cap[i]:='o';
          'Ó','Ò': cap[i]:='O';
          'ù','ú': cap[i]:='u';
          'Ú','Ù': cap[i]:='U';
          '\','/',':','*','?','"','<','>','&','(',')','.':cap[i]:=' ';
          end;
       t:=t+cap[i];
       end;
   t := StringReplace(t, ' ', '', [rfReplaceAll]);
    //   ShowMessage(t);
   nombres.Delimiter:='|';
   nombres.DelimitedText:=t;

  // ShowMessage(nombres.GetText);
//   nombres.Free;
end;
//***********
procedure Tftsbfr.manda_atras();
var
   i:integer;
begin
   for i:=0 to componentcount-1 do begin
 //  for i:=componentcount-1 downto 0 do begin
      if (components[i] is TPanel) then
         (components[i] as TPanel).SendToBack;
      if (components[i] is TGroupBox) then
         (components[i] as TGroupBox).SendToBack;
   end;
end;

procedure Tftsbfr.item_create(captio:string);
var x:integer;
begin
   if xitem=nil then
      x:=8
   else
      x:=xitem.Left+xitem.Width+8;
      xitem:=Tlabel.Create(xmenu);
      xitem.Parent:=xmenu;
      xitem.Visible:=true;
      xitem.Caption:=captio;
      xitem.Left:=x;
      xitem.Top:=3;
      xpop:=Tpopupmenu.Create(self);
      xitem.PopupMenu:=xpop;
      xitem.OnClick:=item_onclick;
end;
procedure Tftsbfr.subitem_create(captio:string);
begin
   xsubitem:=Tmenuitem.Create(self);
   xsubitem.Caption:=captio;
   xpop.Items.Add(xsubitem);
end;
procedure Tftsbfr.mainmenu_display;
var i:integer;
begin
  for i:=0 to componentcount-1 do begin
    if (components[i] is Tpopupmenu) or
       (components[i] is Tsplitter) or
       (components[i] is TMenuItem) or
       (components[i] is TImageList) or
       (components[i] is TToolButton) or
       (components[i] is TDateTimePicker) or
       (components[i] is TdxBarManager) then
       continue
    else
    if components[i] is Tlabel then
      (components[i] as Tlabel).Top:=(components[i] as Tlabel).Top+xmenu.Height
    else
    if components[i] is Tpanel then
      (components[i] as Tpanel).Top:=(components[i] as Tpanel).Top+xmenu.Height
    else
    if components[i] is Tgroupbox then
      (components[i] as Tgroupbox).Top:=(components[i] as Tgroupbox).Top+xmenu.Height
    else
    if components[i] is Timage then
      (components[i] as Timage).Top:=(components[i] as Timage).Top+xmenu.Height
    else
    if components[i] is TMemo then
      (components[i] as TMemo).Top:=(components[i] as TMemo).Top+xmenu.Height
    else
    if components[i] is TToolBar then
      (components[i] as TToolBar).Top:=(components[i] as TToolBar).Top+xmenu.Height
    else
    if components[i] is TEdit then
      (components[i] as TEdit).Top:=(components[i] as TEdit).Top+xmenu.Height
    else
    if components[i] is TDBGrid then
      (components[i] as TDBGrid).Top:=(components[i] as TDBGrid).Top+xmenu.Height
    else
    if components[i] is TComboBox then
      (components[i] as TComboBox).Top:=(components[i] as TComboBox).Top+xmenu.Height
    else
    if components[i] is TRadioButton then
      (components[i] as TRadioButton).Top:=(components[i] as TRadioButton).Top+xmenu.Height
    else
    if components[i] is TBitBtn then
      (components[i] as TBitBtn).Top:=(components[i] as TBitBtn).Top+xmenu.Height
    else
    if components[i] is TPaintBox then
      (components[i] as TPaintBox).Top:=(components[i] as TPaintBox).Top+xmenu.Height
    else
    if components[i] is TButton then
      (components[i] as TButton).Top:=(components[i] as TButton).Top+xmenu.Height
    else
    if components[i] is TPageControl then
      (components[i] as TPageControl).Top:=(components[i] as TPageControl).Top+xmenu.Height
    else
    if components[i] is TStringGrid then
      (components[i] as TStringGrid).Top:=(components[i] as TStringGrid).Top+xmenu.Height
    else
    if components[i] is TCheckBox then
      (components[i] as TCheckBox).Top:=(components[i] as TCheckBox).Top+xmenu.Height
    else
    if components[i] is TListBox then
      (components[i] as TListBox).Top:=(components[i] as TListBox).Top+xmenu.Height
    else

      showmessage(components[i].ClassName);
  end;
end;
//============================================================================

procedure Tftsbfr.separa( cadena: string );
var
   k: integer;
begin
   cadena := trim( cadena );
   w1 := cadena;
   w2 := '';
   w3 := '';
   k := pos( ' ', cadena );
   if k = 0 then
      exit;
   w1 := copy( cadena, 1, k - 1 );
   cadena := trim( copy( cadena, k + 1, 1000 ) );
   w2 := cadena;
   w2 := stringreplace( w2, '"', '', [ rfreplaceall ] );
   k := pos( ' ', cadena );
   if k = 0 then
      exit;
   w2 := copy( cadena, 1, k - 1 );
   cadena := trim( copy( cadena, k + 1, 1000 ) );
   w3 := cadena;
   if copy( cadena, 1, 1 ) = '"' then begin
      delete( cadena, 1, 1 );
      k := pos( '"', cadena );
   end
   else
      k := pos( ' ', cadena );
   if k = 0 then
      exit;
   w3 := copy( cadena, 1, k - 1 );
end;

function Tftsbfr.valor( x: string ): integer;
var
   n: integer;
begin
   n := strtoint( x ) div 13;
  // if n < 0 then
    //  n := ( n + 6000 ) div 13;
   valor := n;
end;

function Tftsbfr.entabs( w3: string ): integer;
var
   j, z3: integer;
begin
   z3 := -1;
   for j := 0 to tabcontrol.Count - 1 do begin
      if pos( w3 + ',', tabcontrol[ j ] ) = 1 then begin
         z3 := strtoint( copy( tabcontrol[ j ], pos( ',', tabcontrol[ j ] ) + 1, 100 ) );
         break;
      end;
   end;
   entabs := z3;
end;

function Tftsbfr.obtienePes(cad : string): integer;   //::::::::::::::::::::alk 2
var
   cont,ni : integer;
   compo : string;
begin
   for cont:=0 to length(stacks)-1 do begin
      compo:= stacks[cont].pp;
      if compo = cad then begin
         ni:= stacks[cont].nivel;
         break;
      end
      else begin
         ni:=0;
      end;
   end;
   Result:=ni;
end;

procedure Tftsbfr.alta_compo( compo: Tcomponent; nombre: string; tipo: string );
var
   k: integer;
begin
   k := length( z );
   setlength( z, k + 1 );
   z[ k ].compo := compo;
   z[ k ].nombre := nombre;
   z[ k ].tipo := tipo;
   compo.Tag := k;
end;

procedure Tftsbfr.procesa_rutinas( n: integer );
var
   j, k: integer;
   b_ok: boolean;
   rutina: string;
begin
   for j := n to lis.Count - 1 do begin // Procesa rutinas
      separa( lis[ j ] );
      b_ok := false;
      if w1 = 'Exit' then
         continue;
      if ( w1 = 'End' ) and ( w2 = 'Sub' ) then begin
         rut[ k ].fin := j;
         continue;
      end;
      if ( w1 = 'End' ) and ( w2 = 'Function' ) then begin
         rut[ k ].fin := j;
         continue;
      end;
      if ( w1 = 'Sub' ) or ( w1 = 'Function' ) then begin
         b_ok := true;
         rutina := w2;
      end;
      if ( w2 = 'Sub' ) or ( w2 = 'Function' ) then begin
         b_ok := true;
         rutina := w3;
      end;
      if b_ok then begin
         k := length( rut );
         setlength( rut, k + 1 );
         rut[ k ].nombre := rutina;
         rut[ k ].inicio := j;
         rut[ k ].fin := j;
      end;
   end;
end;
procedure Tftsbfr.agrega_tabs(n:integer);
var j,k:integer;
begin
   k:=length(tabs);
   if n>=length(tabs) then begin
      setlength( tabs, n+1);
      for j := k to n do begin
         tabs[ j ] := TTabSheet.Create( pagecontrol );
         tabs[ j ].PageControl := PageControl;
      end;
   end;
end;

procedure Tftsbfr.arma( archivo: string );
var
   edit: Tedit;
   lab: Tlabel;
   combobox: Tcombobox;
   //boton: TButton;                                                                            // free;
   listbox: Tlistbox;
   image: Timage;
   dbgrid: Tdbgrid;
   radio: TRadioButton;
   checkbox: Tcheckbox;
   frame: TGroupBox;
   filelistbox: Tfilelistbox;
   directorylistbox: Tdirectorylistbox;
   drivecombobox: Tdrivecombobox;
   panel:Tpanel;
   i, j, k, z3,ci,csi: integer;
   componente: array of Tcomponent;
   wincontrol: array of Twincontrol;
   wincon: Twincontrol;
   Picker: TDateTimePicker;
   Grid: TStringGrid;
   Line: TPaintBox;
   BitB,botonT,boton: TBitBtn;
   cuadro : TOpenDialog;
   b_cuadro : boolean;
   //video : TMediaPlayer;
   ToolBar : TToolBar;
   botT : TToolButton;
  // botonT, boton : TButton;
   menu,mnu,ind,nomC : Integer;
   anterior,pan, nomComBox : string;
   tab : TTabSheet;
   compTab,f,paope,compT : integer;
   nive,ka,pestania,compara: integer;
   au1,auc : integer;
begin
   mainmenu_create;
   xmenu.Visible:=false;
   compTab:=0;
   f:=-1;
   nive:=0;
   auc:=0;
   nomC:=-1;
//   listaPanel:=TStringList.Create;

   if fileexists( archivo ) = false then
      exit;
   lis := Tstringlist.Create;
   tipo := Tstringlist.Create;
   tipo.Add( '-' );
   tabcontrol := Tstringlist.Create;
   lis.LoadFromFile( archivo );
   for i := 0 to lis.Count - 1 do begin
      separa( lis[ i ] );
      if ( w1 = 'Attribute' ) and ( w2 = 'VB_Name' ) and ( w3 = '=' ) then
         break;


      if w1 = 'Begin' then begin
         if menu = 3 then begin
            mnu:=mnu+1;
         end
         else begin
            mnu:=1;
         end;

         nive:=nive+1;                // ----------- pila nivel

         if pos('.',w2)>0 then begin
            w2:=copy(w2,pos('.',w2)+1,500);
         end;
         tipo.Insert( 0, w2 );
         k := length( componente );
         setlength( componente, k + 1 );
         setlength( wincontrol, k + 1 );
         if w2 = 'Form' then begin // inicia forma
            componente[ k ] := ftsbfr;
            wincontrol[ k ] := ( ftsbfr as twincontrol );
            ftsbfr.OnClick := click;
            alta_compo( ftsbfr, w3, w2 );
         end
         else
         if (w2 = 'Adodc') or (w2 = 'NTService') then begin

         end
         else
         if (w2 = 'BarraTitulo') or (w2 = 'MarcoForma')then begin
            z3 := entabs( w3 );
            if z3 > -1 then begin
               panel := Tpanel.Create( tabs[ z3 ] );
               panel.Parent := tabs[ z3 ];
            end
            else begin
               panel := Tpanel.Create( componente[ k - 1 ] );
               panel.Parent := wincontrol[ k - 1 ];
            end;
            panel.Visible := true;
            panel.OnClick := click;
            componente[ k ] := panel;
            wincontrol[ k ] := panel;
            alta_compo( panel, w3, w2 );
         end
         else
         if (w2 = 'cBlueCaption') or (w2 = 'Shape') then begin
            z3 := entabs( w3 );
            if z3 > -1 then begin
               lab := Tlabel.Create( tabs[ z3 ] );
               lab.Parent := tabs[ z3 ];
            end
            else begin
               lab := Tlabel.Create( componente[ k - 1 ] );
               lab.Parent := wincontrol[ k - 1 ];
            end;
            lab.Visible := true;
            lab.OnClick := click;
            componente[ k ] := lab;
            wincontrol[ k ] := ftsbfr;
            alta_compo( lab, w3, w2 );
         end
         else
         if (w2 = 'CheckBox') or (w2 = 'SSCheck') then begin
            z3 := entabs( w3 );
            if z3 > -1 then begin
               CheckBox := TCheckBox.Create( tabs[ z3 ] );
               CheckBox.Parent := tabs[ z3 ];
            end
            else begin
               CheckBox := TCheckBox.Create( componente[ k - 1 ] );
               CheckBox.Parent := wincontrol[ k - 1 ];
            end;
            CheckBox.Visible := true;
            CheckBox.OnClick := click;
            componente[ k ] := CheckBox;
            wincontrol[ k ] := CheckBox;
            alta_compo( CheckBox, w3, w2 );
         end
         else
         if w2 = 'ComboBox' then begin
            z3 := entabs( w3 );
            nomComBox:=w3;
            if z3 > -1 then begin
               ComboBox := TComboBox.Create( tabs[ z3 ] );
               ComboBox.Parent := tabs[ z3 ];
            end
            else begin
               ComboBox := TComboBox.Create( componente[ k - 1 ] );
               ComboBox.Parent := wincontrol[ k - 1 ];
            end;
            ComboBox.Visible := true;
            ComboBox.OnClick := click;
            componente[ k ] := ComboBox;
            wincontrol[ k ] := ComboBox;
            alta_compo( ComboBox, w3, w2 );
         end
         else
         if (w2 = 'CommandButton') then begin
            z3 := entabs( w3 );
            if z3 > -1 then begin
               BitB := TBitBtn.Create( tabs[ z3 ] );
               BitB.Parent := tabs[ z3 ];
            end
            else begin
               BitB := TBitBtn.Create( componente[ k - 1 ] );
               BitB.Parent := wincontrol[ k - 1 ];
            end;
            BitB.Visible := true;
            BitB.OnClick := click;
            componente[ k ] := BitB;
            wincontrol[ k ] := BitB;
            alta_compo( BitB, w3, w2 );
         end
         else
         if w2='CommonDialog' then begin
             cuadro:=TOpenDialog.Create(Application);
             cuadro.Title := '**DEMOSTRACION**';
             b_cuadro:=true;
         end
         else
         if w2='CRViewer' then begin
            z3 := entabs( w3 );
            if z3 > -1 then begin
               panel := Tpanel.Create( tabs[ z3 ] );
               panel.Parent := tabs[ z3 ];
            end
            else begin
               panel := Tpanel.Create( componente[ k - 1 ] );
               panel.Parent := wincontrol[ k - 1 ];
            end;
            panel.Visible := true;
            panel.OnClick := click;
            panel.Caption:='CRViewer';
            panel.Color:= clsilver;
            componente[ k ] := panel;
            wincontrol[ k ] := panel;
            alta_compo( panel, w3, w2 );
         end
         else
         if (w2= 'Data') or (w2= 'CrystalReport') or (w2= 'Inet') or (w2= 'Timer') then begin

         end
         else
         if w2 = 'DirListBox' then begin
            z3 := entabs( w3 );
            if z3 > -1 then begin
               directorylistbox := Tdirectorylistbox.Create( tabs[ z3 ] );
               directorylistbox.Parent := tabs[ z3 ];
            end
            else begin
               directorylistbox := Tdirectorylistbox.Create( componente[ k - 1 ] );
               directorylistbox.Parent := wincontrol[ k - 1 ];
            end;
            directorylistbox.Visible := true;
            directorylistbox.OnClick := click;
            componente[ k ] := directorylistbox;
            wincontrol[ k ] := directorylistbox;
            alta_compo( directorylistbox, w3, w2 );
         end
         else
         if w2 = 'DriveListBox' then begin
            z3 := entabs( w3 );
            if z3 > -1 then begin
               drivecombobox := Tdrivecombobox.Create( tabs[ z3 ] );
               drivecombobox.Parent := tabs[ z3 ];
            end
            else begin
               drivecombobox := Tdrivecombobox.Create( componente[ k - 1 ] );
               drivecombobox.Parent := wincontrol[ k - 1 ];
            end;
            drivecombobox.Visible := true;
            drivecombobox.OnClick := click;
            componente[ k ] := drivecombobox;
            wincontrol[ k ] := drivecombobox;
            alta_compo( drivecombobox, w3, w2 );
         end
         else
         if w2 = 'DTPicker' then begin
            z3 := entabs( w3 );
            if z3 > -1 then begin
               Picker := TDateTimePicker.Create( tabs[ z3 ] );
               Picker.Parent := tabs[ z3 ];
            end
            else begin
               Picker := TDateTimePicker.Create( componente[ k - 1 ] );
               Picker.Parent := wincontrol[ k - 1 ];
            end;
            Picker.Visible := true;
            Picker.OnClick := click;
            componente[ k ] := Picker;
            wincontrol[ k ] := Picker;
            alta_compo( Picker, w3, w2 );
         end
         else
         if w2 = 'FileListBox' then begin
            z3 := entabs( w3 );
            if z3 > -1 then begin
               FileListBox := TFileListBox.Create( tabs[ z3 ] );
               FileListBox.Parent := tabs[ z3 ];
            end
            else begin
               FileListBox := TFileListBox.Create( componente[ k - 1 ] );
               FileListBox.Parent := wincontrol[ k - 1 ];
            end;
            FileListBox.Visible := true;
            FileListBox.OnClick := click;
            componente[ k ] := FileListBox;
            wincontrol[ k ] := FileListBox;
            alta_compo( FileListBox, w3, w2 );
         end
         else
         if (w2 = 'Frame') or (w2 = 'SSFrame') then begin
            z3 := entabs( w3 );
            if z3 > -1 then begin
               frame := TGroupBox.Create( tabs[ z3 ] );
                frame.Parent := tabs[ z3 ];
            end
            else begin
               frame := TGroupBox.Create( componente[ k - 1 ] );
                frame.Parent := wincontrol[ k - 1 ];
            end;
            frame.Visible := true;
            frame.OnClick := click;
            componente[ k ] := frame;
            wincontrol[ k ] := frame;
            alta_compo( frame, w3, w2 );
         end
         else
         if (w2 = 'Gauge') or (w2 = 'ProgressBar') or (w2 = 'StatusBar') then begin
            z3 := entabs( w3 );
            if z3 > -1 then begin
               image := Timage.Create( tabs[ z3 ] );
               image.Parent := tabs[ z3 ];
            end
            else begin
               image := Timage.Create( componente[ k - 1 ] );
               image.Parent := wincontrol[ k - 1 ];
            end;
            image.Stretch := true;
            image.Picture := image1.Picture;
            image.Visible := true;
            image.OnClick := click;
            componente[ k ] := image;
            alta_compo( image, w3, w2 );
         end
         else

         if w2 = 'Image' then begin
            z3 := entabs( w3 );
            if z3 > -1 then begin
               image := Timage.Create( tabs[ z3 ] );
               image.Parent := tabs[ z3 ];
            end
            else begin
               image := Timage.Create( componente[ k - 1 ] );
               image.Parent := wincontrol[ k - 1 ];
            end;
            image.Stretch := true;
            image.Picture := image2.Picture;
            image.Visible := true;
            image.OnClick := click;
            componente[ k ] := image;
            alta_compo( image, w3, w2 );
         end
         else
         if w2 = 'ImageList' then begin
            
         end
         else

         if w2 = 'Label' then begin
            z3 := entabs( w3 );
            if z3 > -1 then begin
               lab := Tlabel.Create( tabs[ z3 ] );
               lab.Parent := tabs[ z3 ];
            end
            else begin
               lab := Tlabel.Create( componente[ k - 1 ] );
               lab.Parent := wincontrol[ k - 1 ];
            end;
            lab.Visible := true;
            lab.OnClick := click;
            componente[ k ] := lab;
            wincontrol[ k ] := ftsbfr;
            alta_compo( lab, w3, w2 );
         end
         else
          if w2 = 'LightAx' then begin
            z3 := entabs( w3 );
            if z3 > -1 then begin
               BitB := TBitBtn.Create( tabs[ z3 ] );
               BitB.Parent := tabs[ z3 ];
            end
            else begin
               BitB := TBitBtn.Create( componente[ k - 1 ] );
               BitB.Parent := wincontrol[ k - 1 ];
            end;
            BitB.Visible := true;
            BitB.OnClick := click;
            componente[ k ] := BitB;
            wincontrol[ k ] := BitB;
            alta_compo( BitB, w3, w2 );
         end
         else
         if w2 = 'ListBox' then begin
            z3 := entabs( w3 );
            if z3 > -1 then begin
               Listbox := Tlistbox.Create( tabs[ z3 ] );
               Listbox.Parent := tabs[ z3 ];
            end
            else begin
               Listbox := Tlistbox.Create( componente[ k - 1 ] );
               Listbox.Parent := wincontrol[ k - 1 ];
            end;
            Listbox.Visible := true;
            Listbox.OnClick := click;
            componente[ k ] := Listbox;
            wincontrol[ k ] := Listbox;
            alta_compo( Listbox, w3, w2 );
         end
         else
         if w2 = 'Line' then begin
            z3 := entabs( w3 );
            if z3 > -1 then begin
               Line := TPaintBox.Create( tabs[ z3 ] );
               Line.Parent := tabs[ z3 ];
            end
            else begin
               Line := TPaintBox.Create( componente[ k - 1 ] );
               Line.Parent := wincontrol[ k - 1 ];
            end;
            Line.Visible := true;
            Line.OnClick := click;
            componente[ k ] := Line;
            alta_compo( Line, w3, w2 );
         end
         else
         if (w2 = 'Menu') then begin
            if menu = 3 then begin
               //continue;
            end
            else begin
               xmenu.Color:=clInactiveCaption;
               xmenu.Visible:=true;
               menu:=3;
            end
         end
         else
         if (w2 = 'OptionButton') or (w2 = 'SSOption') then begin
            z3 := entabs( w3 );
            if z3 > -1 then begin
               radio := TRadioButton.Create( tabs[ z3 ] );
               radio.Parent := tabs[ z3 ];
            end
            else begin
               radio := TRadioButton.Create( componente[ k - 1 ] );
               radio.Parent := wincontrol[ k - 1 ];
            end;
            radio.Visible := true;
            radio.OnClick := click;
            componente[ k ] := radio;
            wincontrol[ k ] := radio;
            alta_compo( radio, w3, w2 );
         end
         else
         if w2 = 'PictureBox' then begin
            z3 := entabs( w3 );
            if z3 > -1 then begin
               image := Timage.Create( tabs[ z3 ] );
               image.Parent := tabs[ z3 ];
            end
            else begin
               image := Timage.Create( componente[ k - 1 ] );
               image.Parent := wincontrol[ k - 1 ];
            end;
            image.Stretch := true;
            image.Picture := image2.Picture;
            image.Visible := true;
            image.OnClick := click;
            componente[ k ] := image;
            alta_compo( image, w3, w2 );
         end
         else
         if w2 = 'SSCommand' then begin
             z3 := entabs( w3 );
            if z3 > -1 then begin
               BitB := TBitBtn.Create( tabs[ z3 ] );
               BitB.Parent := tabs[ z3 ];
            end
            else begin
               BitB := TBitBtn.Create( componente[ k - 1 ] );
               BitB.Parent := wincontrol[ k - 1 ];
            end;
            BitB.Visible := true;
            BitB.OnClick := click;
            componente[ k ] := BitB;
            wincontrol[ k ] := BitB;
            alta_compo( BitB, w3, w2 );
         end
         else
         if w2 = 'SSPanel' then begin
            z3 := entabs( w3 );

            ka:=length(stacks);          //:::::::::::PILA
            setlength(stacks,ka+1);
            stacks[ka].nivel:=nive;
            stacks[ka].pp:=w2;

            pestania:=obtienePes('VideoSoftIndexTab');
            compara:= stacks[ka].nivel;
            if (compTab = 1) and (pestania > 0) and ( compara = pestania+1) and (auc < nombres.Count)then begin
               auc:=auc+1;
               if nomC = -1 then begin     //pestaña 0
                  tab.Destroy;

                  tab := TTabSheet.Create(pagecontrol);
                  tab.PageControl := pagecontrol;
                  nomC:=nomC+1;
                  tab.Name := nombres[nomC];
               end
               else
               if nomC > -1 then begin     //pestaña 1 .. n
                  tab := TTabSheet.Create(pagecontrol);
                  tab.PageControl := pagecontrol;
                  nomC:=nomC+1;
                  tab.Name := nombres[nomC];
               end;
               tab.Visible:=true;
               componente[k] := tab;
               wincontrol[k] := tab;
               alta_compo(tab,w3,w2);
               paope:=1;
            end
            else begin
               if z3 > -1 then begin
                  panel := TPanel.Create( tabs[ z3 ] );
                  panel.Parent := tabs[ z3 ];
                  paope:=0;
                  panel.Visible := true;
                  panel.OnClick := click;
                  componente[ k ] := panel;
                  wincontrol[ k ] := panel;
                  alta_compo( panel, w3, w2 );
               end
               else begin
                  panel := TPanel.Create( componente[ k - 1 ] );
                  panel.Parent := wincontrol[ k - 1 ];
                  paope:=0;
                  panel.Visible := true;
                  panel.OnClick := click;
                  componente[ k ] := panel;
                  wincontrol[ k ] := panel;
                  alta_compo( panel, w3, w2 );
               end;
            end;
         end
         else
         if w2 = 'SSTab' then begin
            z3 := entabs( w3 );
            if z3 > -1 then begin
               pagecontrol := Tpagecontrol.Create( tabs[ z3 ] );
               pagecontrol.Parent := tabs[ z3 ];
            end
            else begin
               pagecontrol := Tpagecontrol.Create( componente[ k - 1 ] );
               pagecontrol.Parent := wincontrol[ k - 1 ];
            end;
            tabcontrol.Clear;
            componente[ k ] := pagecontrol;
            wincontrol[ k ] := pagecontrol;
            alta_compo( pagecontrol, w3, w2 );
         end
         else
         if w2 = 'TextBox' then begin
            z3 := entabs( w3 );
            if z3 > -1 then begin
               edit := Tedit.Create( tabs[ z3 ] );
               edit.Parent := tabs[ z3 ];
            end
            else begin
               edit := Tedit.Create( componente[ k - 1 ] );
               edit.Parent := wincontrol[ k - 1 ];
            end;
            edit.Visible := true;
            edit.OnClick := click;
            componente[ k ] := edit;
            wincontrol[ k ] := edit;
            alta_compo( edit, w3, w2 );
            edit.Text:=w3;
         end
         else
         if (w2 = 'TDBGrid') then begin
            z3 := entabs( w3 );
            if z3 > -1 then begin
               dbgrid := Tdbgrid.Create( tabs[ z3 ] );
               dbgrid.Parent := tabs[ z3 ];
            end
            else begin
               dbgrid := Tdbgrid.Create( componente[ k - 1 ] );
               dbgrid.Parent := wincontrol[ k - 1 ];
            end;
            dbgrid.Visible := true;
            componente[ k ] := dbgrid;
            wincontrol[ k ] := dbgrid;
            alta_compo( dbgrid, w3, w2 );
         end
         else
         if w2 = 'Toolbar' then begin
            z3 := entabs( w3 );
            if z3 > -1 then begin
               ToolBar := TToolBar.Create( tabs[ z3 ] );
               ToolBar.Parent := tabs[ z3 ];
            end
            else begin
               ToolBar := TToolBar.Create( componente[ k - 1 ] );
               ToolBar.Parent := wincontrol[ k - 1 ];
            end;
            ToolBar.Visible := true;
            ToolBar.ShowCaptions:=true;
            componente[ k ] := ToolBar;
            wincontrol[ k ] := ToolBar;
            alta_compo( ToolBar, w3, w2 );
         end
         else
         if w2 = 'TreeView' then begin
            z3 := entabs( w3 );
            if z3 > -1 then begin
               image := Timage.Create( tabs[ z3 ] );
               image.Parent := tabs[ z3 ];
            end
            else begin
               image := Timage.Create( componente[ k - 1 ] );
               image.Parent := wincontrol[ k - 1 ];
            end;
            image.Stretch := true;
            image.Picture := image3.Picture;
            image.Visible := true;
            image.OnClick := click;
            componente[ k ] := image;
            alta_compo( image, w3, w2 );
         end
         else
         if (w2 = 'TrueGrid') or (w2 = 'ListView') or (w2 = 'Grid')then begin
            z3 := entabs( w3 );
            if z3 > -1 then begin
               Grid := TStringGrid.Create( tabs[ z3 ] );
               Grid.Parent := tabs[ z3 ];
            end
            else begin
               Grid := TStringGrid.Create( componente[ k - 1 ] );
               Grid.Parent := wincontrol[ k - 1 ];
            end;
            Grid.Visible := true;
            Grid.OnClick := click;
            componente[ k ] := Grid;
            wincontrol[ k ] := Grid;
            alta_compo( Grid, w3, w2 );
         end
         else
         if w2 = 'VideoSoftElastic' then begin
             if (compTab=1) and (nomC = -1) then begin     //pestaña 0
                 tab.Destroy;
                 tab := TTabSheet.Create(pagecontrol);
                 tab.PageControl := pagecontrol;
                 nomC:=nomC+1;
                 tab.Name := nombres[nomC];

                 tab.Visible:=true;
                 componente[k] := tab;
                 wincontrol[k] := tab;
                 alta_compo(tab,w3,w2);
             end
             else
             if (compTab=1) and (nomC > -1) then begin     //pestaña 1 .. n
                 tab := TTabSheet.Create(pagecontrol);
                 tab.PageControl := pagecontrol;
                 nomC:=nomC+1;
                 tab.Name := nombres[nomC];

                 tab.Visible:=true;
                 componente[k] := tab;
                 wincontrol[k] := tab;
                 alta_compo(tab,w3,w2);
             end
             else
             if compTab=0 then begin
                 z3 := entabs( w3 );
                 if z3 > -1 then begin
                    frame := TGroupBox.Create( tabs[ z3 ] );
                    frame.Parent := tabs[ z3 ];
                 end
                 else begin
                    frame := TGroupBox.Create( componente[ k - 1 ] );
                    frame.Parent := wincontrol[ k - 1 ];
                 end;
                 frame.Visible := true;
                 frame.OnClick := click;
                 componente[ k ] := frame;
                 wincontrol[ k ] := frame;
                 alta_compo( frame, w3, w2 );
             end;

             {if compT=1 then begin
                 tab := TTabSheet.Create(pagecontrol);
                 tab.PageControl := pagecontrol;
             end
             else
             if compTab=0 then begin
                 pagecontrol := TPageControl.Create(Self);
                 pagecontrol.Parent := Self;
                 componente[ k ] := pagecontrol;
                 wincontrol[ k ] := pagecontrol;
                 alta_compo( pagecontrol, w3, w2 );
                 tab := TTabSheet.Create(pagecontrol);
                 tab.PageControl := pagecontrol;
                 compT:=1;
             end;       }

             ka:=length(stacks);             //*********************PILA
             setlength(stacks,ka+1);
             stacks[ka].nivel:=nive;
             stacks[ka].pp:=w2;
         end
         else
         if w2 = 'VideoSoftIndexTab' then begin
            z3 := entabs( w3 );
            if z3 > -1 then begin
               pagecontrol := Tpagecontrol.Create( tabs[ z3 ] );
               pagecontrol.Parent := tabs[ z3 ];
            end
            else begin
               pagecontrol := Tpagecontrol.Create( componente[ k - 1 ] );
               pagecontrol.Parent := wincontrol[ k - 1 ];
            end;
            tab := TTabSheet.Create(pagecontrol);
            tab.PageControl := pagecontrol;

            ka:=length(stacks);
            setlength(stacks,ka+1);
            stacks[ka].nivel:=nive;
            stacks[ka].pp:=w2;

            //tabcontrol.Clear;
            componente[ k ] := pagecontrol;
            wincontrol[ k ] := pagecontrol;
            alta_compo( pagecontrol, w3, w2 );

            tab.Visible:=true;
            componente[k] := tab;
            wincontrol[k] := tab;
            alta_compo(tab,w3,w2);
         end
         else
         if (w2 = 'WhiteAX') or (w2 = 'PBXPButton') then begin
             z3 := entabs( w3 );
            if z3 > -1 then begin
               BitB := TBitBtn.Create( tabs[ z3 ] );
               BitB.Parent := tabs[ z3 ];
            end
            else begin
               BitB := TBitBtn.Create( componente[ k - 1 ] );
               BitB.Parent := wincontrol[ k - 1 ];
            end;
            BitB.Visible := true;
            BitB.OnClick := click;
            componente[ k ] := BitB;
            wincontrol[ k ] := BitB;
            alta_compo( BitB, w3, w2 );
         end
         else begin
            showMessage(w2);
            continue;
         end;
      end;
      anterior:=w2;

      if w1 = 'End' then begin
         if tipo.Count > 1 then
            tipo.Delete( 0 );
         k := length( componente );
         setlength( componente, k - 1 );
         setlength( wincontrol, k - 1 );
         if b_cuadro then begin
            if cuadro<>nil then
               cuadro.Execute;
            b_cuadro:=false;
         end;
         if tipo.count=1 then
            break;

         if menu = 3 then
            mnu:=mnu-1;

         nive:=nive-1;        //-------- pila nivel
         continue;
      end;

      if (tipo[ 0 ] = 'BarraTitulo') or (tipo[ 0 ] = 'MarcoForma') then begin
         if w1 = 'Caption' then
            panel.Caption := w3;
         if w1 = 'Left' then
            panel.Left := valor( w3 );
         if w1 = 'Top' then
            panel.Top := valor( w3 );
         if w1 = 'Width' then
            panel.Width := valor( w3 );
         if w1 = 'Height' then
            panel.Height := valor( w3 );
         if w1 = 'TabIndex' then
            panel.TabOrder := strtoint( w3 );
         continue;
      end;
      if (tipo[ 0 ] = 'cBlueCaption') or (tipo[ 0 ] = 'Shape')then begin
         if w1 = 'Caption' then
            lab.Caption := w3;
         if w1 = 'Left' then
            lab.Left := valor( w3 );
         if w1 = 'Top' then
            lab.Top := valor( w3 );
         if w1 = 'Width' then
            lab.Width := valor( w3 );
         if w1 = 'Height' then
            lab.Height := valor( w3 );
         if w1 = 'AutoSize' then
            lab.AutoSize := ( w3 = '-1' );
         if (tipo[0] = 'cBlueCaption') then
            lab.color:=clBlue;
         if (tipo[0] = 'shape') then
            lab.color:=clGray;
         continue;
      end;
      if (tipo[ 0 ] = 'CheckBox') or (tipo[ 0 ] = 'SSCheck') then begin
         if w1 = 'Left' then
            CheckBox.Left := valor( w3 );
         if w1 = 'Top' then
            CheckBox.Top := valor( w3 );
         if w1 = 'Width' then
            CheckBox.Width := valor( w3 );
         if w1 = 'Height' then
            CheckBox.Height := valor( w3 );
         if w1 = 'Caption' then
            CheckBox.Caption := w3;
         if w1 = 'TabIndex' then
            CheckBox.TabOrder := strtoint( w3 );
         if w1 = 'Value' then
            CheckBox.Checked := ( w3 = '1' );
         if w1 = 'Caption' then
            CheckBox.Caption:= w3;
         if w1 = 'Visible' then
            CheckBox.Color:=clyellow;
         continue;
      end;
      if tipo[ 0 ] = 'ComboBox' then begin
         if w1 = 'Left' then
            ComboBox.Left := valor( w3 );
         if w1 = 'Top' then
            ComboBox.Top := valor( w3 );
         if w1 = 'Width' then
            ComboBox.Width := valor( w3 );
         if w1 = 'Height' then
            ComboBox.Height := valor( w3 );

         ComboBox.Text:=nomComBox;
         continue;
      end;
      if (tipo[ 0 ] = 'CommandButton') then begin
         BitB.BringToFront;
         if w1 = 'Caption' then
            BitB.Caption := w3;
         if w1 = 'Left' then
            BitB.Left := valor( w3 );
         if w1 = 'Top' then
            BitB.Top := valor( w3 );
         if w1 = 'Width' then
            BitB.Width := valor( w3 );
         if w1 = 'Height' then
            BitB.Height := valor( w3 );
         if w1 = 'TabIndex' then
            BitB.TabOrder := valor( w3 );
         if w1 = 'Picture' then
            ImageList1.GetBitmap(0,BitB.Glyph);
         if w1 = 'Visible' then
            ImageList1.GetBitmap(1,BitB.Glyph);
         continue;
      end;
      if (tipo[0]='CommonDialog') then begin
          if w1 = 'DialogTitle' then
          cuadro.Title := '**DEMOSTRACION** '+w3;
          if w1 = 'DefaultExt' then
          cuadro.DefaultExt:=w3;
      end;
      if (tipo[0]='CRViewer') then begin
         if w1 = 'Width' then
            panel.Width := valor( w3 );
         if w1 = 'Height' then
            panel.Height := valor( w3 );
         if w1 = 'Left' then
            panel.Left := valor( w3 );
         if w1 = 'Top' then
            panel.Top := valor( w3 );
         if w1 = 'TabIndex' then
            panel.TabOrder := strtoint( w3 );
         continue;
      end;
      if tipo[ 0 ] = 'DTPicker' then begin
         if w1 = 'Left' then
            Picker.Left := valor( w3 );
         if w1 = 'Top' then
            Picker.Top := valor( w3 );
         if w1 = 'Width' then
            Picker.Width := valor( w3 );
         if w1 = 'Height' then
            Picker.Height := valor( w3 );
         if w1 = 'TabIndex' then
            Picker.TabOrder := strtoint( w3 );
         continue;
      end;
      if tipo[ 0 ] = 'Label' then begin
         if w1 = 'Caption' then
            lab.Caption := w3;
         if w1 = 'Left' then
            lab.Left := valor( w3 );
         if w1 = 'Top' then
            lab.Top := valor( w3 );
         if w1 = 'Width' then
            lab.Width := valor( w3 );
         if w1 = 'Height' then
            lab.Height := valor( w3 );
         if w1 = 'AutoSize' then
            lab.AutoSize := ( w3 = '-1' );
         if (w1 = 'Visible') and (w3 = '0') then
            lab.color:=clyellow;
         continue;
      end;
      if tipo[ 0 ] = 'LightAx' then begin
         BitB.BringToFront;
         if w1 = 'Caption' then
            BitB.Caption := w3;
         if w1 = 'Left' then
            BitB.Left := valor( w3 );
         if w1 = 'Top' then
            BitB.Top := valor( w3 );
         if w1 = 'Width' then
            BitB.Width := valor( w3 );
         if w1 = 'Height' then
            BitB.Height := valor( w3 );
         if w1 = 'TabIndex' then
            BitB.TabOrder := valor( w3 );
         if w1 = 'Picture' then
            ImageList1.GetBitmap(0,BitB.Glyph);
         continue;
      end;
      if tipo[ 0 ] = 'Line' then begin
         if w1 = 'Left' then
            Line.Left := valor( w3 );
         if w1 = 'Top' then
            Line.Top := valor( w3 );
         if w1 = 'Width' then
            Line.Width := valor( w3 );
         if w1 = 'Height' then
            Line.Height := valor( w3 );
         continue;
      end;
      if tipo[ 0 ] = 'ListBox' then begin
         if w1 = 'Left' then
            Listbox.Left := valor( w3 );
         if w1 = 'Top' then
            Listbox.Top := valor( w3 );
         if w1 = 'Width' then
            Listbox.Width := valor( w3 );
         if w1 = 'Height' then
            Listbox.Height := valor( w3 );
         if w1 = 'TabIndex' then
            Listbox.TabOrder := strtoint( w3 );
         continue;
      end;
      if tipo[ 0 ] = 'Menu' then begin
         if (w1='Caption') and (mnu = 1) then
            item_create(w3);
         if (w1='Caption') and (mnu > 1) then
            subitem_create(w3);
         continue;
      end;

      if (tipo[ 0 ] = 'OptionButton') or (tipo[ 0 ] = 'SSOption') then begin
         if w1 = 'Left' then
            radio.Left := valor( w3 );
         if w1 = 'Top' then
            radio.Top := valor( w3 );
         if w1 = 'Width' then
            radio.Width := valor( w3 );
         if w1 = 'Height' then
            radio.Height := valor( w3 );
         if w1 = 'Caption' then
            radio.Caption := w3;
         if w1 = 'TabIndex' then
            radio.TabOrder := strtoint( w3 );
         if w1 = 'Value' then
            radio.Checked := ( w3 = '-1' );
         if w1 = 'Caption' then
            radio.Caption:=w3;
         continue;
      end;
      if tipo[ 0 ] = 'DirListBox' then begin
         if w1 = 'Left' then
            DirectoryListbox.Left := valor( w3 );
         if w1 = 'Top' then
            DirectoryListbox.Top := valor( w3 );
         if w1 = 'Width' then
            DirectoryListbox.Width := valor( w3 );
         if w1 = 'Height' then
            DirectoryListbox.Height := valor( w3 );
         if w1 = 'TabIndex' then
            DirectoryListbox.TabOrder := strtoint( w3 );
         continue;
      end;
      if tipo[ 0 ] = 'DriveListBox' then begin
         if w1 = 'Left' then
            drivecombobox.Left := valor( w3 );
         if w1 = 'Top' then
            drivecombobox.Top := valor( w3 );
         if w1 = 'Width' then
            drivecombobox.Width := valor( w3 );
         if w1 = 'Height' then
            drivecombobox.Height := valor( w3 );
         if w1 = 'TabIndex' then
            drivecombobox.TabOrder := strtoint( w3 );
         continue;
      end;
      if tipo[ 0 ] = 'FileListBox' then begin
         if w1 = 'Left' then
            FileListbox.Left := valor( w3 );
         if w1 = 'Top' then
            FileListbox.Top := valor( w3 );
         if w1 = 'Width' then
            FileListbox.Width := valor( w3 );
         if w1 = 'Height' then
            FileListbox.Height := valor( w3 );
         if w1 = 'TabIndex' then
            FileListbox.TabOrder := strtoint( w3 );
         continue;
      end;
      if tipo[ 0 ] = 'Form' then begin
         if w1 = 'Caption' then
            caption := w3;
         if w1 = 'ClientTop' then
            top := valor( w3 );
         if w1 = 'ClientLeft' then
            left := valor( w3 );
         if w1 = 'ClientHeight' then
            height := valor( w3 ) + 60;
         if w1 = 'ClientWidth' then
            width := valor( w3 ) + 30;
         continue;
      end;
      if (tipo[ 0 ] = 'Frame') or (tipo[ 0 ] = 'SSFrame')then begin
         if w1 = 'Caption' then
            frame.Caption := w3;
         if w1 = 'Left' then
            frame.Left := valor( w3 );
         if w1 = 'Top' then
            frame.Top := valor( w3 );
         if w1 = 'Width' then
            frame.Width := valor( w3 );
         if w1 = 'Height' then
            frame.Height := valor( w3 );
         if w1 = 'TabIndex' then
            frame.TabOrder := strtoint( w3 );
         continue;
      end;
      if (tipo[ 0 ] = 'Gauge') or (tipo[ 0 ] = 'ProgressBar') or (tipo[ 0 ] = 'StatusBar') then begin
         if w1 = 'Left' then
            image.Left := valor( w3 );
         if w1 = 'Top' then
            image.Top := valor( w3 );
         if w1 = 'Width' then
            image.Width := valor( w3 );
         if w1 = 'Height' then
            image.Height := valor( w3 );
         continue;
      end;
      if tipo[ 0 ] = 'Image' then begin
         if w1 = 'Left' then
            image.Left := valor( w3 );
         if w1 = 'Top' then
            image.Top := valor( w3 );
         if w1 = 'Width' then
            image.Width := valor( w3 );
         if w1 = 'Height' then
            image.Height := valor( w3 );
         continue;
      end;
      if tipo[ 0 ] = 'ImageList'then begin
         continue;
      end;
      if tipo[ 0 ] = 'PictureBox' then begin
         if w1 = 'Left' then
            image.Left := valor( w3 );
         if w1 = 'Top' then
            image.Top := valor( w3 );
         if w1 = 'Width' then
            image.Width := valor( w3 );
         if w1 = 'Height' then
            image.Height := valor( w3 );
         continue;
      end;
      if tipo[ 0 ] = 'SSCommand' then begin
         BitB.BringToFront;
         if w1 = 'Caption' then
            BitB.Caption := w3;
         if w1 = 'Left' then
            BitB.Left := valor( w3 );
         if w1 = 'Top' then
            BitB.Top := valor( w3 );
         if w1 = 'Width' then
            BitB.Width := valor( w3 );
         if w1 = 'Height' then
            BitB.Height := valor( w3 );
         if w1 = 'TabIndex' then
            BitB.TabOrder := valor( w3 );
         if w1 = 'Picture' then
            ImageList1.GetBitmap(0,BitB.Glyph);
         if w1 = 'Visible' then
            ImageList1.GetBitmap(1,BitB.Glyph);

         continue;
      end;
      if tipo[ 0 ] = 'SSPanel' then begin
         if paope = 0 then begin        // es panel
            if w1 = 'Caption' then
               panel.Caption := w3;
            if w1 = 'Left' then
               panel.Left := valor( w3 );
            if w1 = 'Top' then
               panel.Top := valor( w3 );
            if w1 = 'Width' then
               panel.Width := valor( w3 );
            if w1 = 'Height' then
               panel.Height := valor( w3 );
            if w1 = 'TabIndex' then
               panel.TabOrder := strtoint( w3 );
            if (w1 = 'Visible') and (w3 = '0') then
               panel.Color := clyellow;
//            if w1 = 'ForeColor' then
//               panel.Font.Color := valor(w3);
         end
         else
         if paope = 1 then begin   // es pestania
            if w1 = 'Left' then
               tab.Left := valor( w3 );
            if w1 = 'Top' then
               tab.Top := valor( w3 );
            if w1 = 'Width' then
               tab.Width := valor( w3 );
            if w1 = 'Height' then
               tab.Height := valor( w3 );
         end;
         continue;
      end;
      if (tipo[ 0 ] = 'SSTab') then begin
         if w1 = 'Left' then
            pagecontrol.Left := valor( w3 );
         if w1 = 'Top' then
            pagecontrol.Top := valor( w3 );
         if w1 = 'Width' then
            pagecontrol.Width := valor( w3 );
         if w1 = 'Height' then
            pagecontrol.Height := valor( w3 );
         if w1 = 'Tabs' then begin
            agrega_tabs(strtoint(w3));
         end;
         if copy( w1, 1, 11 ) = 'TabCaption(' then begin
            j := strtoint( copy( w1, 12, length( w1 ) - 12 ) );
            agrega_tabs(j);
            tabs[ j ].Caption := w3;
         end;
         if ( copy( w1, 1, 4 ) = 'Tab(' ) and ( pos( ').Control(', w1 ) > 0 ) then begin
            j := strtoint( copy( w1, 5, pos( ').Control(', w1 ) - 5 ) );
            agrega_tabs(j);
            tabcontrol.Add( w2 + ',' + inttostr( j ) );
         end;
         continue;
      end;

      if tipo[ 0 ] = 'TDBGrid' then begin
         if w1 = 'Left' then
            dbgrid.Left := valor( w3 );
         if w1 = 'Top' then
            dbgrid.Top := valor( w3 );
         if w1 = 'Width' then
            dbgrid.Width := valor( w3 );
         if w1 = 'Height' then
            dbgrid.Height := valor( w3 );
         continue;
      end;
      if tipo[ 0 ] = 'TextBox' then begin
         if w1 = 'Text' then
            edit.Text := w3;
         if w1 = 'Left' then
            edit.Left := valor( w3 );
         if w1 = 'Top' then
            edit.Top := valor( w3 );
         if w1 = 'Width' then
            edit.Width := valor( w3 );
         if w1 = 'Height' then
            edit.Height := valor( w3 );
         if w1 = 'TabIndex' then
            edit.TabOrder := strtoint( w3 );
         if (w1 = 'Visible') and (w3 = '0') then
            edit.color:=clyellow;
         continue;
      end;
      if tipo[ 0 ] = 'Toolbar' then begin
         if w1 = 'Left' then
            ToolBar.Left := valor( w3 );
         if w1 = 'Top' then
            ToolBar.Top := valor( w3 );
         if w1 = 'Width' then
            ToolBar.Width := valor( w3 );
         if w1 = 'Height' then
            ToolBar.Height := 41;
         if w1 = 'ButtonHeight' then
            ToolBar.ButtonHeight := valor( w3 );
         if w1 = 'ButtonWidth' then
            ToolBar.ButtonWidth := valor( w3 );
         if w1 = 'Caption' then begin
             botT:=TToolButton.Create(ToolBar);
             botT.Parent:=ToolBar;
             botT.Caption:=w3;
             botT.Visible:=true;
         end;
         continue;
      end;
      if tipo[ 0 ] = 'TreeView' then begin
         if w1 = 'Left' then
            image.Left := valor( w3 );
         if w1 = 'Top' then
            image.Top := valor( w3 );
         if w1 = 'Width' then
            image.Width := valor( w3 );
         if w1 = 'Height' then
            image.Height := valor( w3 );
         continue;
      end;
      if (tipo[ 0 ] = 'TrueGrid') or (tipo[ 0 ] = 'ListView') or (tipo[ 0 ] = 'Grid') then begin
         if w1 = 'Left' then
            Grid.Left := valor( w3 );
         if w1 = 'Top' then
            Grid.Top := valor( w3 );
         if w1 = 'Width' then
            Grid.Width := valor( w3 );
         if w1 = 'Height' then
            Grid.Height := valor( w3 );
         if w1 = 'TabIndex' then
            Grid.TabOrder := strtoint( w3 );
         continue;
      end;
      if tipo[ 0 ] = 'VideoSoftElastic' then begin
         if compTab = 0 then begin
            if w1 = 'Left' then
               frame.Left := valor( w3 );
            if w1 = 'Top' then
               frame.Top := valor( w3 );
            if w1 = 'Width' then
               frame.Width := valor( w3 );
            if w1 = 'Height' then
               frame.Height := valor( w3 );
            if w1 = 'Caption' then
               frame.Caption := w3;
         end
         else begin
            if w1 = 'Left' then
               tab.Left := valor( w3 );
            if w1 = 'Top' then
               tab.Top := valor( w3 );
            if w1 = 'Width' then
               tab.Width := valor( w3 );
            if w1 = 'Height' then
               tab.Height := valor( w3 );
            if w1 = 'Caption' then begin
               nombretab(w3);
               tab.Name := nombres[0];
            end;
         end;
         continue;
      end;
      if tipo[ 0 ] = 'VideoSoftIndexTab' then begin
         //pagecontrol := TPageControl.Create(Self);
       //  pagecontrol.Parent := Self;
         if w1 = 'Left' then begin
            pagecontrol.Left := valor( w3 );
            tab.Left:=valor(w3);
         end;
         if w1 = 'Top' then begin
            pagecontrol.Top := valor( w3 );
            tab.Top:=valor(w3);
         end;
         if w1 = 'Width' then begin
            pagecontrol.Width := valor( w3 );
            tab.Width:=valor(w3);
         end;
         if w1 = 'Height' then begin
            pagecontrol.Height := valor( w3 );
            tab.Height:=valor(w3);
         end;
         if w1 = 'TabIndex' then
            pagecontrol.TabIndex := valor(w3);
         if w1 = 'Tabs' then
            agrega_tabs(strtoint(w3));
         if w1 = 'Caption' then
            nombretab(w3);
         compTab:=1;
      end;
      if (tipo[ 0 ] = 'WhiteAX') or (tipo[ 0 ] = 'PBXPButton') then begin
         if w1 = 'Caption' then
            BitB.Caption := w3;
         if w1 = 'Left' then
            BitB.Left := valor( w3 );
         if w1 = 'Top' then
            BitB.Top := valor( w3 );
         if w1 = 'Width' then
            BitB.Width := valor( w3 );
         if w1 = 'Height' then
            BitB.Height := valor( w3 );
         if w1 = 'TabIndex' then
            BitB.TabOrder := strtoint( w3 );
         if w1 = 'Picture' then
            ImageList1.GetBitmap(0,BitB.Glyph);
         BitB.Visible:=true;
         continue;
      end;
   end;
   procesa_rutinas( i );
   manda_atras();
   ftsbfr.Width:=Width+150;
   refresh;
end;

procedure Tftsbfr.Click( Sender: TObject );
var
   i, j, k: integer;
   nombre: string;
begin
   j := ( sender as Tcomponent ).Tag;
   if ( z[ j ].nombre = nombre_anterior ) and ( memo1.Visible ) then begin
      memo1.Visible := false;
      splitter1.Visible := false;
      nombre_anterior := z[ j ].nombre;
      exit;
   end;
   memo1.Visible := true;
   splitter1.Visible := true;
   nombre_anterior := z[ j ].nombre;
   nombre := z[ j ].nombre + '_';
   k := length( nombre );
   memo1.Lines.Clear;
   for i := 0 to length( rut ) - 1 do begin
      if copy( rut[ i ].nombre, 1, k ) = nombre then begin
         for j := rut[ i ].inicio to rut[ i ].fin do
            memo1.Lines.Add( lis[ j ] );
      end;
   end;
end;

procedure Tftsbfr.Visible1Click( Sender: TObject );
var
   i: integer;
begin
   for i := 0 to componentcount - 1 do begin
      if components[ i ] is Tlabel then begin
         if ( ( components[ i ] as Tlabel ).Visible = false ) or
            ( ( components[ i ] as Tlabel ).Tag = 99 ) then begin
            ( components[ i ] as Tlabel ).Visible := not ( components[ i ] as Tlabel ).Visible;
            ( components[ i ] as Tlabel ).Tag := 99;
         end;
      end;
      if components[ i ] is Tedit then begin
         if ( ( components[ i ] as Tedit ).Visible = false ) or
            ( ( components[ i ] as Tedit ).Tag = 99 ) then begin
            ( components[ i ] as Tedit ).Visible := not ( components[ i ] as Tedit ).Visible;
            ( components[ i ] as Tedit ).Tag := 99;
         end;
      end;
      if components[ i ] is Tcombobox then begin
         if ( ( components[ i ] as Tcombobox ).Visible = false ) or
            ( ( components[ i ] as Tcombobox ).Tag = 99 ) then begin
            ( components[ i ] as Tcombobox ).Visible := not ( components[ i ] as Tcombobox ).Visible;
            ( components[ i ] as Tcombobox ).Tag := 99;
         end;
      end;
   end;
   refresh;
end;

procedure Tftsbfr.FormClose( Sender: TObject; var Action: TCloseAction );
begin
   if FormStyle = fsMDIChild then
      Action := caFree;
  // free;
end;

procedure Tftsbfr.FormCreate(Sender: TObject);
begin

   mnuPrincipal.Style := gral.iPubEstiloActivo;

   if gral.iPubVentanasActivas > 0 then
      gral.PubExpandeMenuVentanas( True );

   nombres:=TStringList.Create;
end;

procedure Tftsbfr.FormDestroy(Sender: TObject);
begin
   dm.PubEliminarVentanaActiva( Caption );

  if gral.iPubVentanasActivas > 0 then
      gral.PubExpandeMenuVentanas( True );
end;
end.

