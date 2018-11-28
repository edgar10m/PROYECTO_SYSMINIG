unit pcatalog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ToolWin, ComCtrls, dxBar, HTML_HELP, htmlhlp;

type
    reg=record
      op1:string;
      con:string;
      op2:string;
      orr:string;
      men:string;
    end;
    ini=record
      campo:string;
      valor:string;
      tipo:string;
    end;
    operacion=record
      campo:string;
      opera:string;        
      texto:string;
    end;
type
  Tfcatalog = class(TForm)
    pan: TScrollBox;
    mnuPrincipal: TdxBarManager;
    mnuCancela: TdxBarButton;
    mnuAceptar: TdxBarButton;
    mnuAlta: TdxBarButton;
    mnuModificar: TdxBarButton;
    mnuBorrar: TdxBarButton;
    mnuBuscar: TdxBarButton;
    mnuBrowse: TdxBarButton;
    Panel1: TPanel;
    modo: TStaticText;
    mnuAyuda: TdxBarButton;
    procedure consultaclick(Sender: TObject);
    procedure altaClick(Sender: TObject);
    procedure cambio1Click(Sender: TObject);
    procedure cambio2Click(Sender: TObject);
    procedure bajaClick(Sender: TObject);
    procedure cancelaclick(Sender: TObject);
    procedure solo_numeros(Sender: TObject; var Key: Char );
    procedure baltaClick(Sender: TObject);
    procedure bconsultaClick(Sender: TObject);
    procedure bcambioClick(Sender: TObject);
    procedure bbajaClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure bbrowseClick(Sender: TObject);
    procedure bsalirClick(Sender: TObject);
    procedure xExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mnuCancelaClick(Sender: TObject);
    procedure mnuAltaClick(Sender: TObject);
    procedure mnuModificarClick(Sender: TObject);
    procedure mnuBorrarClick(Sender: TObject);
    procedure mnuBrowseClick(Sender: TObject);
    procedure mnuBuscarClick(Sender: TObject);
    {procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    function FormHelp(Command: Word; Data: Integer;
      var CallHelp: Boolean): Boolean; }
    procedure mnuAyudaClick(Sender: TObject);

  private
    { Private declarations }
     rr:array of reg;
     ii:array of ini;
     oper:array of operacion;
     xalta,xcambio,xbaja,xconsulta:string;
     xhay_regs:integer;
     mem:Tmemo;
     function vars(a:string):string;
     function reglas_de_negocio:boolean;
     procedure valores_iniciales;
     procedure habilita(n:integer);
  public
    { Public declarations }
     sele,inse,upda,dele:string;
     procedure arma;
     procedure regla(oper1:string; condi:string; oper2:string; orr:string; mensaje:string);
     procedure inicial(campo:string; valor:string; tipo:string='');
     procedure xonexit(campo:string; opera:string; texto:string);
     procedure foco(componente:String);
  end;

var
  fcatalog: Tfcatalog;
   procedure PR_CATALOG(catalogo:string; sele:string; inse:string; upda:string; dele:string; ind_img:integer );

implementation
uses ptsdm, pbrowse, pbarra,alkBrowse;
{$R *.dfm}
procedure PR_CATALOG(catalogo:string; sele:string; inse:string; upda:string; dele:string; ind_img:integer);
var
   imagen: Ticon;
begin
     Application.CreateForm( Tfcatalog, fcatalog );
   //fcatalog.lblcatalogo.Caption:=catalogo;
   fcatalog.Caption:=catalogo;
   imagen:=ticon.Create;
   try
      dm.ImageList1.GetIcon( ind_img, imagen );
      fcatalog.Icon := imagen;
   finally
      imagen.Free;
   end;
   {

      sele:=stringreplace(sele,'v___Descripcion','v___Description',[]);
      sele:=stringreplace(sele,'v___Direccion_IP','v___IP_Address',[]);
      sele:=stringreplace(sele,'vk__Clave_de_Usuario','vk__User_ID',[]);
      sele:=stringreplace(sele,'v___Nombre','v___First_Name',[]);
      sele:=stringreplace(sele,'v___Apellido_Paterno','v___Last_Name',[]);
      sele:=stringreplace(sele,'v___Apellido_Materno','v___Last_Name_2',[]);
   if g_language='ENGLISH' then begin
      sele:=stringreplace(sele,'vk__Biblioteca','vk__Library',[]);
      sele:=stringreplace(sele,'vk__Clave_de_Rol','vk__Roll_ID',[]);
      sele:=stringreplace(sele,'v_c_Capacidad_Mineria','v_c_Capacity',[]);
      sele:=stringreplace(sele,'vk__Clave_de_Parametro','vk__Parameter_ID',[]);
      sele:=stringreplace(sele,'v__nSecuencia','v__nSequence',[]);
      sele:=stringreplace(sele,'v___Dato','v___Data',[]);
      sele:=stringreplace(sele,'vk__Clave_de_Capacidad','vk__Capacity_ID',[]);
      sele:=stringreplace(sele,'vkc_Rol','vkc_Roll',[]);
      sele:=stringreplace(sele,'vkc_Usuario','vkc_User',[]);
      sele:=stringreplace(sele,'vk__Clase','vk__Class',[]);
      sele:=stringreplace(sele,'v_c_Tipo','v_c_Type',[]);
      sele:=stringreplace(sele,'v_c_Herramienta_de_Analisis','v_c_Analysis_Utility',[]);
      sele:=stringreplace(sele,'vk__Sistema','vk__Application',[]);
      sele:=stringreplace(sele,'v_c_Oficina','v_c_Office',[]);
      sele:=stringreplace(sele,'v_c_Sistema_Padre','v_c_Parent_Application',[]);
      sele:=stringreplace(sele,'v___Direccion','v___Address',[]);
      sele:=stringreplace(sele,'vk__Utileria','vk__Utility',[]);
   end;
   }
   fcatalog.sele:=sele;
   fcatalog.inse:=inse;
   fcatalog.upda:=upda;
   fcatalog.dele:=dele;
   fcatalog.arma;
end;
procedure Tfcatalog.regla(oper1:string; condi:string; oper2:string; orr:string; mensaje:string);
var z:integer;
begin
   z:=length(rr);
   setlength(rr,z+1);
   rr[z].op1:=oper1;
   rr[z].con:=condi;
   rr[z].op2:=oper2;
   rr[z].orr:=orr;
   rr[z].men:=mensaje;
end;

procedure Tfcatalog.inicial(campo:string; valor:string; tipo:string);
var z:integer;
begin
   z:=length(ii);
   setlength(ii,z+1);
   ii[z].campo:=campo;
   ii[z].valor:=valor;
   ii[z].tipo:=tipo;
end;

procedure Tfcatalog.foco(componente:String);
begin
   (pan.findcomponent(componente) as Tedit).SetFocus;
   //(componente as Tedit).SetFocus;
end;

function Tfcatalog.vars(a:string):string;
var i,k:integer;
   campo,valor:string;
   tex:Tedit;
   com:Tcombobox;
begin
   k:=1;
   for i:=0 to pan.componentcount-1 do begin
      if pan.components[i].ClassType=TEdit then begin
         tex:=pan.components[i] as Tedit;
         valor:=tex.Text;
         campo:='$'+inttostr(k)+'$';
         a:=stringreplace(a,campo,valor,[rfreplaceall]);
         inc(k);
      end;
      if pan.components[i].ClassType=Tmemo then begin
         mem:=pan.components[i] as Tmemo;
         valor:=mem.Text;
         campo:='$'+inttostr(k)+'$';
         a:=stringreplace(a,campo,valor,[rfreplaceall]);
         inc(k);
      end;
      if pan.components[i].ClassType=TComboBox then begin
         com:=pan.components[i] as Tcombobox;
         valor:=com.Text;
         campo:='$'+inttostr(k)+'$';
         a:=stringreplace(a,campo,valor,[rfreplaceall]);
         inc(k);
      end;
   end;
//   if (pos('SELECT ',uppercase(a))>0) or
//      (pos('DELETE ',uppercase(a))>0) then
   if (copy(trim(uppercase(a)),1,7)='SELECT ') or
      (copy(trim(uppercase(a)),1,7)='DELETE ') then
      a:=stringreplace(a,'=''''',g_is_null,[rfreplaceall]);
   vars:=a;
end;
procedure Tfcatalog.consultaclick(Sender: TObject);
var i,k:integer;
   tex:Tedit;
   com:Tcombobox;
begin
   xhay_regs:=0;
   if dm.sqlselect(dm.q1,vars(sele)) then begin
      k:=0;
      for i:=0 to pan.componentcount-1 do begin
         if pan.components[i].ClassType=TEdit then begin
            tex:=pan.components[i] as Tedit;
            tex.Text:=dm.q1.Fields[k].AsString;
            inc(k);
         end;
         if pan.components[i].ClassType=Tmemo then begin
            mem:=pan.components[i] as Tmemo;
            mem.Text:=dm.q1.Fields[k].AsString;
            inc(k);
         end;
         if pan.components[i].ClassType=TComboBox then begin
            com:=pan.components[i] as Tcombobox;
            com.ItemIndex:=com.Items.IndexOf(dm.q1.Fields[k].AsString);
            inc(k);
         end;
      end;
      xhay_regs:=1;
   end
   else begin
      Application.MessageBox(pchar(dm.xlng('No hay resultados ')),
                             pchar(dm.xlng('Consulta catálogo ')), MB_OK );
      cancelaclick(sender);
   end;
end;
procedure Tfcatalog.cancelaclick(Sender: TObject);
var i:integer;
   tex:Tedit;
   com:Tcombobox;
begin
   for i:=0 to pan.componentcount-1 do begin
      if pan.components[i].ClassType=TEdit then begin
         tex:=pan.components[i] as Tedit;
         tex.Text:='';
      end;
      if pan.components[i].ClassType=Tmemo then begin
         mem:=pan.components[i] as Tmemo;
         mem.Text:='';
      end;
      if pan.components[i].ClassType=TComboBox then begin
         com:=pan.components[i] as Tcombobox;
         com.ItemIndex:=-1;
      end;
   end;
   if modo.Caption=xcambio then begin
      habilita(1);
      mnuAceptar.OnClick:=cambio1click;
   end;
   if modo.Caption=xalta then valores_iniciales;
   //bok.SetFocus;
      keybd_event(VK_TAB,1,0,0);
end;
procedure Tfcatalog.arma;
var
   i,y, maxx, wWidth,ia:integer;
   lab:Tlabel;
   tex:Tedit;
   com:Tcombobox;
   x,nombre:string;
begin
   if dm.sqlselect(dm.q1,'select * from parametro where clave='+g_q+'EMPRESA-NOMBRE-1'+g_q) then
    //lbltitulo1.Caption:=dm.q1.fieldbyname('dato').AsString;
   //y:=lblcatalogo.Top+lblcatalogo.Height+50;
   y:=20;
   maxx:=0;
   dm.sqlselect(dm.q1,stringreplace(stringreplace(sele,'''$','''',[rfreplaceall]),'$''','''',[rfreplaceall]));
   for i:=0 to dm.q1.FieldCount-1 do begin
      x:=uppercase(dm.q1.Fields[i].DisplayName);
      nombre:=copy(x,5,200);
      lab:=Tlabel.Create(pan);
      lab.Parent:=pan;
      lab.Top:=y;
      lab.Left:=50;
      lab.Font.Size:=8;
      lab.Visible:=copy(x,1,1)='V';
      lab.Caption:=dm.xlng(stringreplace(nombre,'_AST',' *',[rfreplaceall]));
      lab.Caption:=dm.xlng(stringreplace(lab.Caption,'_',' ',[rfreplaceall]));
      nombre:=dm.xlng(stringreplace(nombre,'_AST','',[rfreplaceall]));
      if copy(x,3,1)='C' then begin
         com:=Tcombobox.Create(pan);
         com.Parent:=pan;
         com.Visible:=copy(x,1,1)='V';
         com.Name:='SELE_'+nombre;
         com.Style:=csDropDownList;
         com.Font.Size:=8;
         com.Top:=y;
         //com.Width:=dm.q1.Fields[i].DataSize*5+30;
          wWidth:=dm.q1.Fields[i].Size*5+30;
         if (wWidth < 500) and (wWidth > 0)  then
            com.Width:=wWidth
         else
            com.Width:=500;
         //com.Left:=lab.Left+lab.Width+30;
         com.Left:=lab.Left+170;
         if com.Left>maxx then maxx:=com.left;
         com.Enabled:=(copy(x,2,1)='K');
         com.OnExit:=xexit;
      end
      else
      if copy(x,3,1)='M' then begin
         mem:=Tmemo.Create(pan);
         mem.Parent:=pan;
         mem.Visible:=copy(x,1,1)='V';
         mem.Name:='SELE_'+nombre;
         mem.Text:='';
         mem.Font.Size:=8;
         mem.Top:=y;
         wWidth:=dm.q1.Fields[i].Size*5;
         if (wWidth < 500) and (wWidth > 0) then
            mem.Width:=wWidth
         else
            mem.Width:=500;
         mem.height:=81;
         //tex.Left:=lab.Left+lab.Width+30;
         mem.Left:=lab.Left+170;
         //mem.CharCase:=ecUpperCase;
         if mem.Left>maxx then maxx:=mem.left;
         mem.Enabled:=(copy(x,2,1)='K');
         mem.OnExit:=xexit;
         mem.ReadOnly:=(copy(x,4,1)='R');
      end
      else begin
         tex:=Tedit.Create(pan);
         tex.Parent:=pan;
         tex.Visible:=copy(x,1,1)='V';
         tex.Name:='SELE_'+nombre;
         tex.Text:='';
         tex.Font.Size:=8;
         tex.Top:=y;
         //**INICIO esto es temporal, se quitará cuando se actualice la ayuda

         if nombre = 'CARACTERES_PERMITIDOS' then begin
            tex.Hint:='El Campo -CARACTERES PERMITIDOS- no debe quedar vacio. Cuando BUSQUEDA SELECT esta ACTIVA.' +
                     chr( 13 )+ ' ( Ej. "-_"  ó  "$&.%%" ). ' +
                     chr( 13 )+ ' CBL, CPY = “-_” ' +
                     chr( 13 )+ ' JCL, JOB, CTC = "$&.%%" ' +
                     chr( 13 )+ ' Los caracteres varian segun la CLASE-LENGUAJE.';
            tex.ShowHint:=TRUE;
         end;

         {if nombre = 'DATO' then begin
            tex.Hint:=
                          ' $HCCLASE$_$HCBIB$_$HCPROG$ ->  CBL_COBLIB_PROGRAMA1 donde HCCLASE=CBL, HCBIB=COBLIB, HCPROG=PROGRAMA1 ' +
               chr( 13 )+ ' $HCCLASE$=$HCPROG_NOEXT$   ->  FIL=C:\ARCHIVOS\FILE1 donde HCCLASE=FIL, HCPROG= C:\ARCHIVOS\FILE1.DAT ' +
               chr( 13 )+ ' --$HCPROG_BASENAME$        ->  --FILE1.DAT donde  HCPROG= C:\ARCHIVOS\FILE1.DAT ' +
               chr( 13 )+ ' >$HCCLASE$>>>$HCPROG_BASENAME_NOEXT$  ->  >FIL>>>FILE1  donde HCCLASE=FIL, HCPROG= C:\ARCHIVOS\FILE1.DAT ';
            tex.ShowHint:=TRUE;
         end; }
         //**FIN

//       tex.Width:=dm.q1.Fields[i].DataSize*5;
            wWidth:=dm.q1.Fields[i].Size*5;
         if (wWidth < 500) and (wWidth > 0) then
            tex.Width:=wWidth
         else
            tex.Width:=500;
         //tex.Left:=lab.Left+lab.Width+30;
         tex.Left:=lab.Left+170;
         tex.CharCase:=ecUpperCase;
         if tex.Left>maxx then maxx:=tex.left;
         tex.Enabled:=(copy(x,2,1)='K');
         if copy(x,4,1)='N' then begin
            tex.OnKeyPress:=solo_numeros;
            tex.width:=80;
         end;
         tex.OnExit:=xexit;
         tex.ReadOnly:=(copy(x,4,1)='R');
      end;
      if copy(x,1,1)='V' then
         y:=y+30;
      if copy(x,2,1)='K' then pan.components[pan.componentcount-1].tag:=1;
      if copy(x,3,1)='M' then
         y:=y+61;
   end;
   for i:=0 to pan.componentcount-1 do begin
      if pan.components[i].ClassName='TEdit' then begin
         tex:=(pan.components[i] as Tedit);
         //tex.Left:=maxx;
      end;
      if pan.components[i].ClassName='TComboBox' then begin
         com:=(pan.components[i] as TComboBox);
         //com.Left:=maxx;
      end;               
   end;
   while (pan.VertScrollBar.IsScrollBarVisible) and
      (height+10<screen.Height) do
      height:=height+10;
   while (pan.HorzScrollBar.IsScrollBarVisible) and
      (width+10<screen.Width) do
      Width:=Width+10;
      width:=width+50;
   mnuAceptar.OnClick:=cancelaclick;
   //bcancel.Left:=width div 3 - bcancelg.Width div 2;
   mnuAceptar.OnClick:=consultaclick;
   //bok.Left:=(width div 3) * 2 - bok.Width div 2;

   top:=screen.Height div 2 - (height div 2);
   left:=screen.Width div 2 - (width div 2);

end;

procedure Tfcatalog.habilita(n:integer);
var i:integer;
   tex:Tedit;               
   com:Tcombobox;
   mem:Tmemo;
begin
   for i:=0 to pan.componentcount-1 do begin
      if pan.components[i].ClassType=TEdit then begin
         tex:=pan.components[i] as Tedit;
         tex.Enabled:=((tex.tag=n) or (n=2));
      end;
      if pan.components[i].ClassType=TComboBox then begin
         com:=pan.components[i] as Tcombobox;
         com.Enabled:=((com.tag=n) or (n=2));
      end;
      if pan.components[i].ClassType=TMemo then begin
         mem:=pan.components[i] as TMemo;
         mem.Enabled:=((mem.tag=n) or (n=2));
      end;
   end;
end;
function Tfcatalog.reglas_de_negocio:boolean;
var i:integer;
begin
   reglas_de_negocio:=false;
   for i:=0 to length(rr)-1 do begin
      if (rr[i].con='=') and  (vars(rr[i].op1)=vars(rr[i].op2)) then continue;
      if (rr[i].con='<>') and (vars(rr[i].op1)<>vars(rr[i].op2)) then continue;
      if (rr[i].con='>') and  (vars(rr[i].op1)>vars(rr[i].op2)) then continue;
      if (rr[i].con='<') and  (vars(rr[i].op1)<vars(rr[i].op2)) then continue;
      if (rr[i].con='>=') and (vars(rr[i].op1)>=vars(rr[i].op2)) then continue;
      if (rr[i].con='<=') and (vars(rr[i].op1)<=vars(rr[i].op2)) then continue;
      if (rr[i].orr<>'OR') then begin
         application.MessageBox(pchar(rr[i].men),'Regla de Negocio',MB_OK);
         exit;
      end;
   end;
   reglas_de_negocio:=true;
end;
procedure Tfcatalog.valores_iniciales;
var i:integer;
   com:Tcombobox;
begin
   for i:=0 to length(ii)-1 do begin
      if pan.findcomponent(ii[i].campo) is Tedit then
         (pan.findcomponent(ii[i].campo) as Tedit).Text:=ii[i].valor
      else
      if pan.findcomponent(ii[i].campo) is Tmemo then
         (pan.findcomponent(ii[i].campo) as Tmemo).Text:=ii[i].valor
      else
      if pan.findcomponent(ii[i].campo) is Tcombobox then begin
         com:=(pan.findcomponent(ii[i].campo) as Tcombobox);
         if ii[i].tipo='SQL' then
            dm.feed_combo(com,ii[i].valor)
         else
            com.ItemIndex:=com.Items.IndexOf(ii[i].valor);
      end;
   end;
end;
procedure Tfcatalog.altaClick(Sender: TObject);
begin
   if reglas_de_negocio=false then exit;
   if dm.sqlselect(dm.q1,vars(sele)) then begin
      Application.MessageBox(pchar(dm.xlng('ERROR... el registro ya existe')),
                             pchar(dm.xlng('Alta catálogo')), MB_OK );
      exit;
   end;
   if dm.sqlinsert(vars(inse))=false then begin
      Application.MessageBox(pchar(dm.xlng('ERROR... no puede dar el INSERT')),
                             pchar(dm.xlng('Alta catálogo')), MB_OK );
   end
   else
         cancelaclick(sender);
end;
procedure Tfcatalog.cambio1Click(Sender: TObject);
begin
   consultaclick(sender);
//   if dm.q1.RecordCount>0 then begin
   if xhay_regs =1 then begin
      habilita(0);
      mnuAceptar.OnClick:=cambio2Click;
   end;
end;
procedure Tfcatalog.cambio2Click(Sender: TObject);
begin
   if reglas_de_negocio=false then exit;
   if dm.sqlupdate(vars(upda))=false then begin
      Application.MessageBox(pchar(dm.xlng('ERROR... no puede dar el UPDATE')),
                             pchar(dm.xlng('Modificar catálogo')), MB_OK );
   end
   else
      cancelaclick(sender);
end;
procedure Tfcatalog.bajaClick(Sender: TObject);
begin
   consultaclick(sender);
//      if dm.q1.RecordCount>0 then begin
   if xhay_regs=1 then begin  // Si encontro registros.
      if application.MessageBox(pchar(dm.xlng('Desea borrar este registro?')),
         pchar(dm.xlng('Confirmar')),MB_YESNO)=IDYES then begin
         if dm.sqldelete(vars(dele))=false then begin
            Application.MessageBox(pchar(dm.xlng('ERROR... no puede dar el DELETE')),
                                   pchar(dm.xlng('Borrar del catálogo ')), MB_OK );
         end;
      end;
   end;
   cancelaclick(sender);
end;

procedure Tfcatalog.baltaClick(Sender: TObject);
begin
   modo.Caption:=xalta;
   cancelaclick(sender);
   habilita(2);
   mnuAceptar.OnClick:=altaclick;
end;

procedure Tfcatalog.bconsultaClick(Sender: TObject);
begin
   modo.Caption:=xconsulta;
   cancelaclick(sender);
   habilita(1);
   mnuAceptar.OnClick:=consultaclick;
end;

procedure Tfcatalog.bcambioClick(Sender: TObject);
begin
   modo.Caption:=xcambio;
   cancelaclick(sender);
   habilita(1);
   mnuAceptar.OnClick:=cambio1click;
end;

procedure Tfcatalog.bbajaClick(Sender: TObject);
begin
   modo.Caption:=xbaja;
   cancelaclick(sender);
   habilita(1);
   mnuAceptar.OnClick:=bajaclick;
end;

procedure Tfcatalog.FormActivate(Sender: TObject);
begin
   fcatalog.cancelaclick(fcatalog);
end;

procedure Tfcatalog.bbrowseClick(Sender: TObject);
var i:integer;
    sel:string;
    cam,cam2:string;
begin
   PR_BROWSE;
   //fbrowse.Caption:=lblcatalogo.caption;
   fbrowse.Caption:=caption;
   sel:=vars(sele);
   i:=pos(' WHERE ',uppercase(sel));
   fbrowse.sele:=copy(sel,1,i);
   dm.sqlselect(dm.q1,sele);
   setlength(fbrowse.ck,dm.q1.FieldCount);
   for i:=0 to dm.q1.FieldCount-1 do begin
      fbrowse.campos.Add(dm.q1.fields[i].FieldName);
      cam:= copy(dm.q1.Fields[i].FieldName,5,100);
      cam2:= stringreplace(cam,'_AST','',[rfreplaceall]);
      cam:=stringreplace(cam2,'_',' ',[rfreplaceall]);

      fbrowse.lstcampos.Items.add(cam);

      if i>0 then
         fbrowse.vl.InsertRow(cam,'',true)
      else
         fbrowse.vl.Keys[1]:=cam;

      fbrowse.lstorder.Items.add(cam+'.'+inttostr(i+1));
      fbrowse.ck[i]:=Tcheckbox.Create(fbrowse.yck);
      fbrowse.ck[i].Parent:=fbrowse.yck;
      fbrowse.ck[i].Visible:=true;
      fbrowse.ck[i].Caption:='Z ---> A';
      fbrowse.ck[i].Top:=i*13;
   end;
   fbrowse.lstcampos.SelectAll;
   fbrowse.bokClick(sender);
   try
      fbrowse.Showmodal;
   finally
      fbrowse.Free;
   end;
end;

procedure Tfcatalog.bsalirClick(Sender: TObject);
begin
   close;
end;
procedure Tfcatalog.solo_numeros(Sender: TObject; var Key: Char );
begin
   if key in [ '0'..'9', chr(8)] then
   else
      key := chr( 0 );
end;
procedure Tfcatalog.xExit(Sender: TObject);
var i:integer;
   nombre,combo,sele:string;
   cmb:Tcombobox;
begin
   if sender is Tedit then
      (sender as Tedit).Text:=trim((sender as Tedit).Text);
   if sender is Tmemo then
      (sender as Tmemo).Text:=trim((sender as Tmemo).Text);
   if length(oper)=0 then exit;
   if sender is Tedit then
      nombre:=(sender as Tedit).Name;
   if sender is Tmemo then
      nombre:=(sender as Tmemo).Name;
   if sender is Tcombobox then
      nombre:=(sender as Tcombobox).Name;
   for i:=0 to length(oper)-1 do begin
      if nombre=oper[i].campo then begin
         if oper[i].opera='feed_combo' then begin
            combo:=copy(oper[i].texto,1,pos(',',oper[i].texto)-1);
            sele:=copy(oper[i].texto,pos(',',oper[i].texto)+1,1000);
            sele:=vars(sele);
            cmb:=pan.findcomponent(combo) as Tcombobox;
            dm.feed_combo(cmb,sele);
            exit;
         end;
      end;
   end;
end;
procedure Tfcatalog.xonexit(campo:string; opera:string; texto:string);
var k:integer;
begin
   k:=length(oper);
   setlength(oper,k+1);
   oper[k].campo:=campo;
   oper[k].opera:=opera;
   oper[k].texto:=texto;
end;
procedure Tfcatalog.FormCreate(Sender: TObject);
begin
   if g_language='ENGLISH' then begin
      //bsalir.Hint:='Exit';
      modo.caption:='ENQUIRE';
      xconsulta:='ENQUIRE';
      xalta:='NEW';
      xcambio:='MODIFY';
      xbaja:='DELETE';
   end
   else begin
      xconsulta:='BUSCAR';
      xalta:='ALTA';
      xcambio:='MODIFICAR';
      xbaja:='BORRAR';
   end;
end;

procedure Tfcatalog.mnuCancelaClick(Sender: TObject);
var i:integer;
   tex:Tedit;
   com:Tcombobox;
begin
   for i:=0 to pan.componentcount-1 do begin
      if pan.components[i].ClassType=TEdit then begin
         tex:=pan.components[i] as Tedit;
         tex.Text:='';
      end;
      if pan.components[i].ClassType=Tmemo then begin
         mem:=pan.components[i] as Tmemo;
         mem.Text:='';
      end;
      if pan.components[i].ClassType=TComboBox then begin
         com:=pan.components[i] as Tcombobox;
         com.ItemIndex:=-1;
      end;
   end;
   if modo.Caption=xcambio then begin
      habilita(1);
      mnuAceptar.OnClick:=cambio1click;
   end;
   if modo.Caption=xalta then valores_iniciales;
   //bok.SetFocus;
   keybd_event(VK_TAB,1,0,0);
end;

procedure Tfcatalog.mnuAltaClick(Sender: TObject);
begin
   modo.Caption:=xalta;
   cancelaclick(sender);
   habilita(2);
   mnuAceptar.OnClick:=altaclick;
end;

procedure Tfcatalog.mnuModificarClick(Sender: TObject);
begin
   modo.Caption:=xcambio;
   cancelaclick(sender);
   habilita(1);
   mnuAceptar.OnClick:=cambio1click;
end;

procedure Tfcatalog.mnuBorrarClick(Sender: TObject);
begin
   modo.Caption:=xbaja;
   cancelaclick(sender);
   habilita(1);
   mnuAceptar.OnClick:=bajaclick;
end;

procedure Tfcatalog.mnuBrowseClick(Sender: TObject);
var i:integer;
    sel:string;
    cam,cam2:string;
begin
   PR_ALK_BROWSE;
   //sel:=vars(sele);
   if not alkFormBrowse.arma_tabla (stringreplace(stringreplace(sele,'''$','''',[rfreplaceall]),'$''','''',[rfreplaceall]), caption)then exit;
   //try
      alkFormBrowse.Show;
   //finally
      //alkFormBrowse.Free;
   //end;
   {PR_BROWSE;
   //fbrowse.Caption:=lblcatalogo.caption;
   fbrowse.Caption:=caption;
   fbrowse.Icon:= fcatalog.Icon;
   sel:=vars(sele);
   i:=pos(' WHERE ',uppercase(sel));
   fbrowse.sele:=copy(sel,1,i);

   dm.sqlselect(dm.q1,stringreplace(stringreplace(sele,'''$','''',[rfreplaceall]),'$''','''',[rfreplaceall]));

   setlength(fbrowse.ck,dm.q1.FieldCount);
   for i:=0 to dm.q1.FieldCount-1 do begin
      fbrowse.campos.Add(dm.q1.fields[i].FieldName);
      cam:= copy(dm.q1.Fields[i].FieldName,5,100);
      cam2:= stringreplace(cam,'_AST','',[rfreplaceall]);
      cam:=stringreplace(cam2,'_',' ',[rfreplaceall]);

      fbrowse.lstcampos.Items.add(cam);

      if i>0 then
         fbrowse.vl.InsertRow(cam,'',true)
      else
         fbrowse.vl.Keys[1]:=cam;

      fbrowse.lstorder.Items.add(cam+'.'+inttostr(i+1));
      fbrowse.ck[i]:=Tcheckbox.Create(fbrowse.yck);
      fbrowse.ck[i].Parent:=fbrowse.yck;
      fbrowse.ck[i].Visible:=true;
      fbrowse.ck[i].Caption:='Z ---> A';
      fbrowse.ck[i].Top:=i*13;
   end;
   fbrowse.lstcampos.SelectAll;
   fbrowse.bokClick(sender);
   try
      fbrowse.Showmodal;
   finally
      fbrowse.Free;
   end;}
end;

procedure Tfcatalog.mnuBuscarClick(Sender: TObject);
begin
   modo.Caption:=xconsulta;
   cancelaclick(sender);
   habilita(1);
   mnuAceptar.OnClick:=consultaclick;
end;

{
procedure Tfcatalog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   iHelpContext:=ActiveControl.HelpContext;
end;

function Tfcatalog.FormHelp(Command: Word; Data: Integer;
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
end; }

procedure Tfcatalog.mnuAyudaClick(Sender: TObject);
  var CallHelp: Boolean;
begin
   CallHelp := False;
   try
     PR_BARRA;
     //iHelpContext:=IDH_TOPIC_T02200;
      HtmlHelp(Application.Handle,
            PChar(Format('%s::/T%5.5d.htm',
           //[Application.HelpFile,ActiveControl.HelpContext])),HH_DISPLAY_TOPIC, 0);
           [Application.HelpFile,iHelpContext])),HH_DISPLAY_TOPIC, 0);
     CallHelp := False;
   except
      Application.MessageBox( 'No existe ayuda para la pantalla ó campo seleccionado','Ayuda ' , MB_OK );
   end;
end;


end.
