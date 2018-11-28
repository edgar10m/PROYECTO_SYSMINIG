unit fptpar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, ExtCtrls, ImgList, Buttons;

type
   estr_param = record
      dato : String;
      campo : String;
      nombre : String;
end;

type
  Tftsparametros = class(TForm)
    pnlTitulo: TPanel;
    img_bandera: TImage;
    lista_img: TImageList;
    lb_pais: TLabel;
    btn_faltantes: TButton;
    refresh: TBitBtn;
    cerrar: TBitBtn;
    ScrollBox1: TScrollBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    fpt_vr_min_storage_violation: TEdit;
    fpt_vr_min_numero_muestras: TEdit;
    fpt_vr_min_tiempo_promedio_cpu: TEdit;
    fpt_vr_max_tiempo_promedio_cpu: TEdit;
    fpt_vr_min_tiempo_promedio_respuesta: TEdit;
    fpt_vr_max_tiempo_promedio_respuesta: TEdit;
    btn_fpt_realiza_vr: TButton;
    btn_fpt_condicion_vr: TButton;
    btn_fpt_vr_min_commit: TButton;
    btn_fpt_vr_min_numero_muestras: TButton;
    btn_fpt_vr_min_storage_violation: TButton;
    btn_fpt_vr_min_tiempo_promedio_cpu: TButton;
    btn_fpt_vr_min_tiempo_promedio_respuesta: TButton;
    btn_fpt_vr_max_commit: TButton;
    btn_fpt_vr_max_numero_muestras: TButton;
    btn_fpt_vr_max_storage_violation: TButton;
    btn_fpt_vr_max_tiempo_promedio_cpu: TButton;
    btn_fpt_vr_max_tiempo_promedio_respuesta: TButton;
    fpt_condicion_vr: TComboBox;
    fpt_vr_min_commit: TEdit;
    fpt_vr_max_commit: TEdit;
    fpt_vr_max_numero_muestras: TEdit;
    fpt_vr_max_storage_violation: TEdit;
    fpt_realiza_vr: TComboBox;
    fpt_vr_min_abend: TEdit;
    btn_fpt_vr_min_abend: TButton;
    fpt_vr_max_abend: TEdit;
    btn_fpt_vr_max_abend: TButton;
    ScrollBox2: TScrollBox;
    GroupBox2: TGroupBox;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    fpt_smtp_from: TEdit;
    fpt_smtp_host: TEdit;
    fpt_smtp_port: TEdit;
    fpt_smtp_psw: TEdit;
    fpt_smtp_depto_bd: TEdit;
    btn_fpt_smtp_from: TButton;
    btn_fpt_smtp_host: TButton;
    btn_fpt_smtp_port: TButton;
    btn_fpt_smtp_psw: TButton;
    btn_fpt_smtp_depto_bd: TButton;
    Splitter1: TSplitter;
    ScrollBox3: TScrollBox;
    GroupBox5: TGroupBox;
    Label10: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    cmbcapa: TComboBox;
    cmbconcepto: TComboBox;
    cmbsubconcepto: TComboBox;
    cmbccategoria: TComboBox;
    cmbcprog: TComboBox;
    cmbcbib: TComboBox;
    cmbcclase: TComboBox;
    txtminimo: TEdit;
    txtmaximo: TEdit;
    txtmedida: TEdit;
    txtcumbral: TEdit;
    bumbral: TButton;
    ScrollBox4: TScrollBox;
    GroupBox3: TGroupBox;
    Label22: TLabel;
    Label23: TLabel;
    fpt_incluye_archivos_strobe: TComboBox;
    fpt_incluye_archivos_strobe_descripcion: TEdit;
    fptbatch_expire_days: TEdit;
    fptbatch_expire_days_descripcion: TEdit;
    btn_fpt_incluye_archivos_strobe: TButton;
    btn_fptbatch_expire_days: TButton;
    Splitter2: TSplitter;
    ScrollBox5: TScrollBox;
    GroupBox4: TGroupBox;
    Label9: TLabel;
    fpt_multiproceso_solicitud: TEdit;
    fpt_multiproceso_solicitud_descripcion: TEdit;
    btn_fpt_multiproceso_solicitud: TButton;
    Splitter3: TSplitter;
    Splitter4: TSplitter;
    procedure FormCreate(Sender: TObject);
    // accion de boton aceptar (update)
    procedure btn_fpt_realiza_vrClick(Sender: TObject);
    procedure btn_fpt_condicion_vrClick(Sender: TObject);
    procedure btn_fpt_vr_min_commitClick(Sender: TObject);
    procedure btn_fpt_vr_min_numero_muestrasClick(Sender: TObject);
    procedure btn_fpt_vr_min_storage_violationClick(Sender: TObject);
    procedure btn_fpt_vr_min_tiempo_promedio_cpuClick(Sender: TObject);
    procedure btn_fpt_vr_min_tiempo_promedio_respuestaClick(Sender: TObject);
    procedure btn_fpt_vr_max_commitClick(Sender: TObject);
    procedure btn_fpt_vr_max_numero_muestrasClick(Sender: TObject);
    procedure btn_fpt_vr_max_storage_violationClick(Sender: TObject);
    procedure btn_fpt_vr_max_tiempo_promedio_cpuClick(Sender: TObject);
    procedure btn_fpt_vr_max_tiempo_promedio_respuestaClick(Sender: TObject);
    procedure btn_fpt_smtp_fromClick(Sender: TObject);
    procedure btn_fpt_smtp_hostClick(Sender: TObject);
    procedure btn_fpt_smtp_portClick(Sender: TObject);
    procedure btn_fpt_smtp_pswClick(Sender: TObject);
    procedure btn_fpt_smtp_depto_bdClick(Sender: TObject);
    procedure btn_fpt_incluye_archivos_strobeClick(Sender: TObject);
    procedure btn_fptbatch_expire_daysClick(Sender: TObject);
    // validacion de numerico
    procedure fpt_vr_min_storage_violationKeyPress(Sender: TObject;var Key: Char);
    procedure fpt_vr_max_storage_violationKeyPress(Sender: TObject;var Key: Char);
    procedure fpt_vr_min_numero_muestrasKeyPress(Sender: TObject;var Key: Char);
    procedure fpt_vr_max_numero_muestrasKeyPress(Sender: TObject;var Key: Char);
    procedure fpt_vr_min_commitKeyPress(Sender: TObject; var Key: Char);
    procedure fpt_vr_max_commitKeyPress(Sender: TObject; var Key: Char);
    procedure fpt_smtp_portKeyPress(Sender: TObject; var Key: Char);
    procedure fptbatch_expire_daysKeyPress(Sender: TObject; var Key: Char);
    procedure btn_fpt_vr_min_abendClick(Sender: TObject);
    procedure btn_fpt_vr_max_abendClick(Sender: TObject);
    procedure fpt_vr_min_abendKeyPress(Sender: TObject; var Key: Char);
    procedure fpt_vr_max_abendKeyPress(Sender: TObject; var Key: Char);
    procedure btn_faltantesClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure refreshClick(Sender: TObject);
    procedure fpt_vr_min_tiempo_promedio_cpuKeyPress(Sender: TObject;var Key: Char);
    procedure fpt_vr_min_tiempo_promedio_respuestaKeyPress(Sender: TObject;var Key: Char);
    procedure fpt_vr_max_tiempo_promedio_respuestaKeyPress(Sender: TObject;var Key: Char);
    procedure fpt_vr_max_tiempo_promedio_cpuKeyPress(Sender: TObject;var Key: Char);
    procedure fpt_multiproceso_solicitudKeyPress(Sender: TObject; var Key: Char);
    procedure btn_fpt_multiproceso_solicitudClick(Sender: TObject);
    procedure fpt_realiza_vrKeyPress(Sender: TObject; var Key: Char);
    procedure fpt_condicion_vrKeyPress(Sender: TObject; var Key: Char);
    procedure fpt_incluye_archivos_strobeKeyPress(Sender: TObject; var Key: Char);
    procedure fpt_smtp_fromKeyPress(Sender: TObject; var Key: Char);
    procedure fpt_smtp_hostKeyPress(Sender: TObject; var Key: Char);
    procedure fpt_smtp_pswKeyPress(Sender: TObject; var Key: Char);
    procedure fpt_smtp_depto_bdKeyPress(Sender: TObject; var Key: Char);
    procedure cerrarClick(Sender: TObject);
    procedure cmbcapaChange(Sender: TObject);
    procedure cmbconceptoChange(Sender: TObject);
    procedure cmbsubconceptoChange(Sender: TObject);
    procedure cmbccategoriaChange(Sender: TObject);
    procedure bumbralClick(Sender: TObject);
    procedure txtminimoKeyPress(Sender: TObject; var Key: Char);
    procedure txtmaximoKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure muestra_datos( sParUsuarioDB: string);

    procedure crear;
  public
    { Public declarations }
    consulta,pais : String;
    claves : array of estr_param;   // considerando 22 elementos
    noExiste : TStringList;  // para la lista de los parámetros que no encuentra

    procedure llena_claves;
    procedure bandera(pais:String);
    {procedure muestra_edit(nombre:TEdit;valor:String);
    procedure muestra_combo(nombre:TComboBox;valor:String);}
    procedure llena_componentes(componente : String; valor:String);
    procedure bloquea_edits;
    function valida_minmax(componente:String; valor:Extended):boolean;
    function emailValido(const Value: String): boolean;  //validar que sea un email el que guarden en la base de datos
  end;

var
  ftsparametros: Tftsparametros;
  procedure PR_MANTPARAM;

implementation
//uses svsrutinas;
uses ptsdm,ptscomun,uConstantes,ptsutileria, ptsgral;
{$R *.dfm}


procedure PR_MANTPARAM;
begin
   if gral.bPubVentanaActiva( 'Parámetros en VD-VR' ) then
      Exit;

   gral.PubMuestraProgresBar( True );
   Application.CreateForm( Tftsparametros, ftsparametros );
   {try
      ftsparametros.Showmodal;
   finally
      ftsparametros.Free;
   end;  }

   ftsparametros.FormStyle := fsMDIChild;

   if gral.bPubVentanaMaximizada = FALSE then begin
      ftsparametros.Width := g_Width;
      ftsparametros.Height := g_Height;
   end;

   ftsparametros.Show;

   dm.PubRegistraVentanaActiva( ftsparametros.Caption );

   gral.PubMuestraProgresBar( False );
end;


procedure Tftsparametros.FormCreate(Sender: TObject);
begin
   {if paramcount < 3 then begin
      Application.MessageBox( pchar( 'Parámetros incorrectos.' + char(13) + char(13)+
               'Imposible conectar a la base de datos, revise que contenga:' + char(13)+
               'SID de Oracle, Usuario y Tipo de conexión'),
               'Error en Parámetros',MB_ICONINFORMATION );
      self.Close;
      exit;
   end;  }

   //detecta_base;
   //if detecta_usuarios = false then
     // exit;

   noExiste := TStringList.Create;

   if dm.sqlselect(dm.q1,'select * from tsoficina') then
      pais:= dm.q1.fieldbyname( 'coficina' ).AsString;

   bandera(g_user_entrada);

   crear;
end;

procedure Tftsparametros.crear;
begin
   muestra_datos( g_user_entrada );

   {if noExiste.Count = 0 then
      btn_faltantes.Visible:=false
   else
      btn_faltantes.Visible:=true; }      // A peticion se quita el boton de faltantes

   //bloquea_edits;   // no correr para que se pueda insertar los que estan vacios
end;

procedure Tftsparametros.bandera(pais:String);
var
   paises:TStringList;
   p,i:integer;
begin
   paises:=TStringList.Create;
   paises.Add('chile11');
   paises.Add('colombia11');
   paises.Add('sysview11');
   paises.Add('peru11');

   p:=-1;
   for i:=0 to paises.Count-1 do 
      if UpperCase(pais) = UpperCase(paises[i]) then begin
         p:=i;
         break;
      end;

   case p of
      0:    //Chile
         begin
            lista_img.GetBitMap(0, img_bandera.Picture.Bitmap);
            img_bandera.Hint:='Chile';
            lb_pais.Caption:='Chile';
         end;
      1 :  //Colombia
         begin
            lista_img.GetBitMap(1, img_bandera.Picture.Bitmap);
            img_bandera.Hint:='Colombia';
            lb_pais.Caption:='Colombia';
         end;
      2 :  //México
         begin
            lista_img.GetBitMap(2, img_bandera.Picture.Bitmap);
            img_bandera.Hint:='México';
            lb_pais.Caption:='México';
         end;
      3 :  //Perú
         begin
            lista_img.GetBitMap(3, img_bandera.Picture.Bitmap);
            img_bandera.Hint:='Perú';
            lb_pais.Caption:='Perú';
         end;
      else
         begin
            lista_img.GetBitMap(2, img_bandera.Picture.Bitmap);
            img_bandera.Hint:='SysViewSoft';
            lb_pais.Caption:='';
            exit;
         end;
   end;

   paises.Free;
end;

procedure Tftsparametros.llena_claves;
var
   tam : integer;   // cuantos parametros?
begin
   tam:=25;
   SetLength(claves,tam);

   claves[0].dato:='fpt_vr_min_storage_violation';
   claves[1].dato:='fpt_vr_max_storage_violation';
   claves[2].dato:='fpt_vr_max_numero_muestras';
   claves[3].dato:='fpt_vr_max_commit';
   claves[4].dato:='fpt_condicion_vr';
   claves[5].dato:='fpt_vr_min_tiempo_promedio_cpu';
   claves[6].dato:='fpt_vr_min_numero_muestras';
   claves[7].dato:='fpt_vr_min_commit';
   claves[8].dato:='fpt_vr_max_tiempo_promedio_respuesta';
   claves[9].dato:='fpt_vr_max_tiempo_promedio_cpu';
   claves[10].dato:='fpt_realiza_vr';
   claves[11].dato:='fpt_vr_min_tiempo_promedio_respuesta';
   claves[12].dato:='fpt_smtp_psw';
   claves[13].dato:='fpt_smtp_port';
   claves[14].dato:='fpt_smtp_host';
   claves[15].dato:='fpt_smtp_from';
   claves[16].dato:='fpt_smtp_depto_bd';
   claves[17].dato:='fptbatch_expire_days';
   claves[18].dato:='fptbatch_expire_days';
   claves[19].dato:='fpt_incluye_archivos_strobe';
   claves[20].dato:='fpt_incluye_archivos_strobe';
   claves[21].dato:='fpt_vr_min_abend';
   claves[22].dato:='fpt_vr_max_abend';
   claves[23].dato:='fpt_multiproceso_solicitud';
   claves[24].dato:='fpt_multiproceso_solicitud';

   claves[0].campo:='secuencia';
   claves[1].campo:='secuencia';
   claves[2].campo:='secuencia';
   claves[3].campo:='secuencia';
   claves[4].campo:='dato';
   claves[5].campo:='dato';
   claves[6].campo:='secuencia';
   claves[7].campo:='secuencia';
   claves[8].campo:='dato';
   claves[9].campo:='dato';
   claves[10].campo:='dato';
   claves[11].campo:='dato';
   claves[12].campo:='dato';
   claves[13].campo:='secuencia';
   claves[14].campo:='dato';
   claves[15].campo:='dato';
   claves[16].campo:='dato';
   claves[17].campo:='secuencia';
   claves[18].campo:='descripcion';
   claves[19].campo:='descripcion';
   claves[20].campo:='dato';
   claves[21].campo:='secuencia';
   claves[22].campo:='secuencia';
   claves[23].campo:='secuencia';
   claves[24].campo:='descripcion';

   claves[0].nombre:='Valor mínimo Storage Violation';
   claves[1].nombre:='Valor máximo Storage Violation';
   claves[2].nombre:='Valor máximo número muestras';
   claves[3].nombre:='Valor máximo COMMIT';
   claves[4].nombre:='Condición';
   claves[5].nombre:='Valor mínimo tiempo promedio CPU';
   claves[6].nombre:='Valor mínimo número muestras';
   claves[7].nombre:='Valor mínimo COMMIT';
   claves[8].nombre:='Valor máximo tiempo promedio respuesta';
   claves[9].nombre:='Valor máximo tiempo promedio CPU';
   claves[10].nombre:='Realiza';
   claves[11].nombre:='Valor mínimo tiempo promedio respuesta';
   claves[12].nombre:='Contraseña';
   claves[13].nombre:='Puerto';
   claves[14].nombre:='Host';
   claves[15].nombre:='Origen';
   claves[16].nombre:='Departamento BD';
   claves[17].nombre:='Días expiración BATCH';
   claves[18].nombre:='Días expiración BATCH';
   claves[19].nombre:='Incluye archivos STROBE';
   claves[20].nombre:='Incluye archivos STROBE';
   claves[21].nombre:='Valor mínimo ABEND';
   claves[22].nombre:='Valor máximo ABEND';
   claves[23].nombre:='Solucitud Multiproceso';
   claves[24].nombre:='Solucitud Multiproceso';
end;

procedure Tftsparametros.muestra_datos( sParUsuarioDB: string );
var
   i : integer;
   cons, param: String;
begin
   noExiste.Clear;

   llena_claves;  // para tener la lista de los parámetros


   for i:=0 to length(claves) -1 do begin
      if claves[i].dato = 'fpt_multiproceso_solicitud' then
         param:= UpperCase(claves[i].dato + '_' + pais)
      else
         param:= UpperCase(claves[i].dato);

      cons:= 'select * from parametro where clave=' + g_q + param + g_q;

      if dm.sqlselect( dm.q1, cons ) then begin
         llena_componentes (claves[i].dato,claves[i].campo);
         {if (claves[i].dato = 'fpt_realiza_vr') or
            (claves[i].dato = 'fpt_condicion_vr') or
            (claves[i].dato = 'fpt_incluye_archivos_strobe') then begin

            muestra_combo(TComboBox(claves[i].dato),claves[i].campo);
         end
         else begin
            muestra_edit(TEdit(claves[i].dato),claves[i].campo);
         end;}
      end
      else begin
         llena_componentes (claves[i].dato,claves[i].campo);
         noExiste.Add(claves[i].dato);
      end;
   end;
   cmbcapa.Items.Clear;
   if dm.sqlselect(dm.q1,'select distinct capa from fptumbral order by 1') then begin
      while not dm.q1.Eof do begin
         cmbcapa.Items.Add(dm.q1.fieldbyname('capa').AsString);
         dm.q1.Next;
      end;
   end;
   cmbconcepto.Items.Clear;
   cmbconcepto.Items.Clear;
   cmbsubconcepto.Items.Clear;
   cmbccategoria.Items.Clear;
   cmbcprog.Items.Clear;
   cmbcbib.Items.Clear;
   cmbcclase.Items.Clear;
   txtminimo.Text:='';
   txtmaximo.Text:='';
   txtmedida.Text:='';
   txtcumbral.Text:='';
end;

{procedure TParametros.muestra_edit(nombre:TEdit;valor:String);
begin
   (nombre as TEdit).Text:=dm.q1.fieldbyname( valor ).AsString;
end;

procedure TParametros.muestra_combo(nombre:TComboBox;valor:String);
var
   val : String;
begin
   val:=dm.q1.fieldbyname(valor).AsString;
   if val = '' then exit;
   (nombre as TComboBox).ItemIndex:=nombre.Items.IndexOf(val);
end;}

procedure Tftsparametros.llena_componentes(componente : String; valor:String);
begin
   if valor = 'descripcion' then
      componente:=componente+'_descripcion';

   if componente = 'fpt_vr_min_storage_violation' then begin
      if dm.q1.fieldbyname( valor ).AsString <> '' then
         fpt_vr_min_storage_violation.Text:=dm.q1.fieldbyname( valor ).AsString
      else
         fpt_vr_min_storage_violation.Text:='';
   end;
   if componente = 'fpt_vr_max_storage_violation' then begin
      if dm.q1.fieldbyname( valor ).AsString <> '' then
         fpt_vr_max_storage_violation.Text:=dm.q1.fieldbyname( valor ).AsString
      else
         fpt_vr_max_storage_violation.Text:='';
   end;
   if componente = 'fpt_vr_max_numero_muestras' then begin
      if dm.q1.fieldbyname( valor ).AsString <> '' then
         fpt_vr_max_numero_muestras.Text:=dm.q1.fieldbyname( valor ).AsString
      else
         fpt_vr_max_numero_muestras.Text:='';
   end;
   if componente = 'fpt_vr_max_commit' then begin
      if dm.q1.fieldbyname( valor ).AsString <> '' then
         fpt_vr_max_commit.Text:=dm.q1.fieldbyname( valor ).AsString
      else
         fpt_vr_max_commit.Text:='';
   end;
   if componente = 'fpt_condicion_vr' then begin   //combo
      if dm.q1.fieldbyname(valor).AsString = '' then
         exit;
      fpt_condicion_vr.ItemIndex:=fpt_condicion_vr.Items.IndexOf(dm.q1.fieldbyname(valor).AsString);
   end;
   if componente = 'fpt_vr_min_tiempo_promedio_cpu' then begin
      if dm.q1.fieldbyname( valor ).AsString <> '' then
         fpt_vr_min_tiempo_promedio_cpu.Text:=dm.q1.fieldbyname( valor ).AsString
      else
         fpt_vr_min_tiempo_promedio_cpu.Text:='';
   end;
   if componente = 'fpt_vr_min_numero_muestras' then begin
      if dm.q1.fieldbyname( valor ).AsString <> '' then
         fpt_vr_min_numero_muestras.Text:=dm.q1.fieldbyname( valor ).AsString
      else
         fpt_vr_min_numero_muestras.Text:='';
   end;
   if componente = 'fpt_vr_min_commit' then begin
      if dm.q1.fieldbyname( valor ).AsString <> '' then
         fpt_vr_min_commit.Text:=dm.q1.fieldbyname( valor ).AsString
      else
         fpt_vr_min_commit.Text:='';
   end;
   if componente = 'fpt_vr_max_tiempo_promedio_respuesta' then begin
      if dm.q1.fieldbyname( valor ).AsString <> '' then
         fpt_vr_max_tiempo_promedio_respuesta.Text:=dm.q1.fieldbyname( valor ).AsString
      else
         fpt_vr_max_tiempo_promedio_respuesta.Text:='';
   end;
   if componente = 'fpt_vr_max_tiempo_promedio_cpu' then begin
      if dm.q1.fieldbyname( valor ).AsString <> '' then
         fpt_vr_max_tiempo_promedio_cpu.Text:=dm.q1.fieldbyname( valor ).AsString
      else
         fpt_vr_max_tiempo_promedio_cpu.Text:='';
   end;
   if componente = 'fpt_realiza_vr' then begin   // combo
      if dm.q1.fieldbyname(valor).AsString = '' then
         exit;
      fpt_realiza_vr.ItemIndex:=fpt_realiza_vr.Items.IndexOf(dm.q1.fieldbyname(valor).AsString);
   end;
   if componente = 'fpt_vr_min_tiempo_promedio_respuesta' then begin
      if dm.q1.fieldbyname( valor ).AsString <> '' then
         fpt_vr_min_tiempo_promedio_respuesta.Text:=dm.q1.fieldbyname( valor ).AsString
      else
         fpt_vr_min_tiempo_promedio_respuesta.Text:='';
   end;
   // -------- campo contraseña -----------------------------
   if componente = 'fpt_smtp_psw' then begin
      if dm.q1.fieldbyname( valor ).AsString <> '' then
         //fpt_smtp_psw.Text:=desencripta(dm.q1.fieldbyname( valor ).AsString)
         fpt_smtp_psw.Text:=dm.q1.fieldbyname( valor ).AsString
      else
         fpt_smtp_psw.Text:='';
   end;
   // -------------------------------------------------------
   if componente = 'fpt_smtp_port' then begin
      if dm.q1.fieldbyname( valor ).AsString <> '' then
         fpt_smtp_port.Text:=dm.q1.fieldbyname( valor ).AsString
      else
         fpt_smtp_port.Text:='';
   end;
   if componente = 'fpt_smtp_host' then begin
      if dm.q1.fieldbyname( valor ).AsString <> '' then
         fpt_smtp_host.Text:=dm.q1.fieldbyname( valor ).AsString
      else
         fpt_smtp_host.Text:='';
   end;
   if componente = 'fpt_smtp_from' then begin
      if dm.q1.fieldbyname( valor ).AsString <> '' then
         fpt_smtp_from.Text:=dm.q1.fieldbyname( valor ).AsString
      else
         fpt_smtp_from.Text:='';
   end;
   if componente = 'fpt_smtp_depto_bd' then begin
      if dm.q1.fieldbyname( valor ).AsString <> '' then
         fpt_smtp_depto_bd.Text:=dm.q1.fieldbyname( valor ).AsString
      else
         fpt_smtp_depto_bd.Text:='';
   end;
   if componente = 'fptbatch_expire_days' then begin
      if dm.q1.fieldbyname( valor ).AsString <> '' then
         fptbatch_expire_days.Text:=dm.q1.fieldbyname( valor ).AsString
      else
         fptbatch_expire_days.Text:='';
   end;
   if componente = 'fptbatch_expire_days_descripcion' then begin
      if dm.q1.fieldbyname( valor ).AsString <> '' then
         fptbatch_expire_days_descripcion.Text:=dm.q1.fieldbyname( valor ).AsString
      else
         fptbatch_expire_days_descripcion.Text:='';
   end;
   if componente = 'fpt_incluye_archivos_strobe' then begin      // combo
      if dm.q1.fieldbyname(valor).AsString = '' then
         exit;
      fpt_incluye_archivos_strobe.ItemIndex:=fpt_incluye_archivos_strobe.Items.IndexOf(dm.q1.fieldbyname(valor).AsString);
   end;
   if componente = 'fpt_incluye_archivos_strobe_descripcion' then begin
      if dm.q1.fieldbyname( valor ).AsString <> '' then
         fpt_incluye_archivos_strobe_descripcion.Text:=dm.q1.fieldbyname( valor ).AsString
      else
         fpt_incluye_archivos_strobe_descripcion.Text:='';
   end;
   if componente = 'fpt_vr_min_abend' then begin
      if dm.q1.fieldbyname( valor ).AsString <> '' then
         fpt_vr_min_abend.Text:=dm.q1.fieldbyname( valor ).AsString
      else
         fpt_vr_min_abend.Text:='';
   end;
   if componente = 'fpt_vr_max_abend' then begin
      if dm.q1.fieldbyname( valor ).AsString <> '' then
         fpt_vr_max_abend.Text:=dm.q1.fieldbyname( valor ).AsString
      else
         fpt_vr_max_abend.Text:='';
   end;
   if componente = 'fpt_multiproceso_solicitud' then begin
      if dm.q1.fieldbyname( valor ).AsString <> '' then
         fpt_multiproceso_solicitud.Text:=dm.q1.fieldbyname( valor ).AsString
      else
         fpt_multiproceso_solicitud.Text:='';
   end;
   if componente = 'fpt_multiproceso_solicitud_descripcion' then begin
      if dm.q1.fieldbyname( valor ).AsString <> '' then
         fpt_multiproceso_solicitud_descripcion.Text:=dm.q1.fieldbyname( valor ).AsString
      else
         fpt_multiproceso_solicitud_descripcion.Text:='';
   end;
end;

procedure Tftsparametros.btn_faltantesClick(Sender: TObject);
begin
   Application.MessageBox( pchar( 'Parémetros no encontrados: ' + char(13) + char(13) +
                           noExiste.Text ),
                           pchar( 'Parámetros faltantes' ), MB_OK );
end;

procedure Tftsparametros.bloquea_edits;
var
   i:integer;
begin
   for i:=0 to componentcount-1 do begin
     if (components[i] is TEdit) then
        if (components[i] as TEdit).Text = '' then
           (components[i] as TEdit).Enabled:=false;
   end;
end;

// .......................................................................... //


// --- Accion del boton (update/insert) ---
procedure Tftsparametros.btn_fpt_realiza_vrClick(Sender: TObject);
begin
   if trim(fpt_realiza_vr.Text) = '' then
      exit;

   consulta:= 'select * from parametro where clave=' + g_q + UpperCase('fpt_realiza_vr') + g_q;
   if dm.sqlselect(dm.q1,consulta) then begin
      consulta:= 'update parametro set dato=' + g_q + fpt_realiza_vr.Text + g_q +
                 ' where clave=' + g_q + UpperCase('fpt_realiza_vr') + g_q;
      if dm.sqlupdate(consulta) then
         btn_fpt_realiza_vr.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede actualizar fpt_realiza_vr' ),
                                 pchar( 'Aviso' ), MB_OK );
   end
   else begin
      consulta:='insert into parametro (clave,dato) values (' +
                g_q + UpperCase('fpt_realiza_vr') + g_q +  ' , ' +  // clave
                g_q + fpt_realiza_vr.Text + g_q +       // dato
                ')';
      if dm.sqlinsert(consulta) then
         btn_fpt_realiza_vr.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede insertar fpt_realiza_vr' ),
                                 pchar( 'Aviso' ), MB_OK );
   end;
end;

procedure Tftsparametros.btn_fpt_condicion_vrClick(Sender: TObject);
begin
   if trim(fpt_condicion_vr.Text) = '' then
      exit;

   consulta:= 'select * from parametro where clave=' + g_q + UpperCase('fpt_condicion_vr') + g_q;
   if dm.sqlselect(dm.q1,consulta) then begin
      consulta:= 'update parametro set dato=' + g_q + fpt_condicion_vr.Text + g_q +
                 ' where clave=' + g_q + UpperCase('fpt_condicion_vr') + g_q;
      if dm.sqlupdate(consulta) then
         btn_fpt_condicion_vr.Visible:=False

      else
         Application.MessageBox( pchar( 'No puede actualizar fpt_condicion_vr' ),
                                 pchar( 'Aviso' ), MB_OK );
   end
   else begin
      consulta:='insert into parametro (clave,dato) values (' +
                g_q + UpperCase('fpt_condicion_vr') + g_q + ' , ' +   // clave
                g_q + fpt_condicion_vr.Text + g_q +      // dato
                ')';
      if dm.sqlinsert(consulta) then
         btn_fpt_condicion_vr.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede insertar fpt_condicion_vr ' ),
                                 pchar( 'Aviso' ), MB_OK );
   end;
end;

procedure Tftsparametros.btn_fpt_vr_min_commitClick(Sender: TObject);
begin
   if trim(fpt_vr_min_commit.Text) = '' then
      exit;

   if not valida_minmax('fpt_vr_min_commit', strtofloat(fpt_vr_min_commit.text)) then
      exit;

   consulta:= 'select * from parametro where clave=' + g_q + UpperCase('fpt_vr_min_commit') + g_q;
   if dm.sqlselect(dm.q1,consulta) then begin
      consulta:= 'update parametro set secuencia=' + g_q + fpt_vr_min_commit.Text + g_q +
                 ' where clave=' + g_q + UpperCase('fpt_vr_min_commit') + g_q;
      if dm.sqlupdate(consulta) then
         btn_fpt_vr_min_commit.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede actualizar fpt_vr_min_commit' ),
                                 pchar( 'Aviso' ), MB_OK );
   end
   else begin
      consulta:='insert into parametro (clave,secuencia) values (' +
                g_q + UpperCase('fpt_vr_min_commit') + g_q + ' , ' +   // clave
                g_q + fpt_vr_min_commit.Text + g_q +   // secuencia
                ')';
      if dm.sqlinsert(consulta) then
         btn_fpt_vr_min_commit.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede insertar fpt_vr_min_commit ' ),
                                 pchar( 'Aviso' ), MB_OK );
   end;
end;

procedure Tftsparametros.btn_fpt_vr_min_numero_muestrasClick(Sender: TObject);
begin
   if trim(fpt_vr_min_numero_muestras.Text) = '' then
      exit;

   if not valida_minmax('fpt_vr_min_numero_muestras', strtofloat(fpt_vr_min_numero_muestras.text)) then
      exit;

   consulta:= 'select * from parametro where clave=' + g_q + UpperCase('fpt_vr_min_numero_muestras') + g_q;
   if dm.sqlselect(dm.q1,consulta) then begin
      consulta:= 'update parametro set secuencia=' + g_q + fpt_vr_min_numero_muestras.Text + g_q +
                 ' where clave=' + g_q + UpperCase('fpt_vr_min_numero_muestras') + g_q;
      if dm.sqlupdate(consulta) then
         btn_fpt_vr_min_numero_muestras.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede actualizar fpt_vr_min_numero_muestras' ),
                                 pchar( 'Aviso' ), MB_OK );
   end
   else begin
      consulta:='insert into parametro (clave,secuencia) values (' +
                g_q + UpperCase('fpt_vr_min_numero_muestras') + g_q + ' , ' +  // clave
                g_q + fpt_vr_min_numero_muestras.Text + g_q +  // secuencia
                ')';
      if dm.sqlinsert(consulta) then
         btn_fpt_vr_min_numero_muestras.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede insertar fpt_vr_min_numero_muestras' ),
                                 pchar( 'Aviso' ), MB_OK );
   end;
end;

procedure Tftsparametros.btn_fpt_vr_min_storage_violationClick(Sender: TObject);
begin
   if trim(fpt_vr_min_storage_violation.Text) = '' then
      exit;

   if not valida_minmax('fpt_vr_min_storage_violation', strtofloat(fpt_vr_min_storage_violation.text)) then
      exit;

   consulta:= 'select * from parametro where clave=' + g_q + UpperCase('fpt_vr_min_storage_violation') + g_q;
   if dm.sqlselect(dm.q1,consulta) then begin
      consulta:= 'update parametro set secuencia=' + g_q + fpt_vr_min_storage_violation.Text + g_q +
                 ' where clave=' + g_q + UpperCase('fpt_vr_min_storage_violation') + g_q;
      if dm.sqlupdate(consulta) then
         btn_fpt_vr_min_storage_violation.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede actualizar fpt_vr_min_storage_violation' ),
                                 pchar( 'Aviso' ), MB_OK );
   end
   else begin
      consulta:='insert into parametro (clave,secuencia) values (' +
                g_q + UpperCase('fpt_vr_min_storage_violation') + g_q + ' , ' +  // clave
                g_q + fpt_vr_min_storage_violation.Text + g_q +  // secuencia
                ')';
      if dm.sqlinsert(consulta) then
         btn_fpt_vr_min_storage_violation.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede insertar fpt_vr_min_storage_violation' ),
                                 pchar( 'Aviso' ), MB_OK );
   end;
end;

procedure Tftsparametros.btn_fpt_vr_min_tiempo_promedio_cpuClick(Sender: TObject);
begin
   if trim(fpt_vr_min_tiempo_promedio_cpu.Text) = '' then
      exit;

   if not valida_minmax('fpt_vr_min_tiempo_promedio_cpu', strtofloat(fpt_vr_min_tiempo_promedio_cpu.text)) then
      exit;

   consulta:= 'select * from parametro where clave=' + g_q + UpperCase('fpt_vr_min_tiempo_promedio_cpu') + g_q;
   if dm.sqlselect(dm.q1,consulta) then begin
      consulta:= 'update parametro set dato=' + g_q + fpt_vr_min_tiempo_promedio_cpu.Text + g_q +
                 ' where clave=' + g_q + UpperCase('fpt_vr_min_tiempo_promedio_cpu') + g_q;
      if dm.sqlupdate(consulta) then
         btn_fpt_vr_min_tiempo_promedio_cpu.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede actualizar fpt_vr_min_tiempo_promedio_cpu' ),
                                 pchar( 'Aviso' ), MB_OK );
   end
   else begin
      consulta:='insert into parametro (clave,dato) values (' +
                g_q + UpperCase('fpt_vr_min_tiempo_promedio_cpu') + g_q + ' , ' +  // clave
                g_q + fpt_vr_min_tiempo_promedio_cpu.Text + g_q +  // dato
                ')';
      if dm.sqlinsert(consulta) then
         btn_fpt_vr_min_tiempo_promedio_cpu.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede insertar fpt_vr_min_tiempo_promedio_cpu' ),
                                 pchar( 'Aviso' ), MB_OK );
   end;
end;

procedure Tftsparametros.btn_fpt_vr_min_tiempo_promedio_respuestaClick(Sender: TObject);
begin
   if trim(fpt_vr_min_tiempo_promedio_respuesta.Text) = '' then
      exit;

   if not valida_minmax('fpt_vr_min_tiempo_promedio_respuesta', strtofloat(fpt_vr_min_tiempo_promedio_respuesta.text)) then
      exit;

   consulta:= 'select * from parametro where clave=' + g_q + UpperCase('fpt_vr_min_tiempo_promedio_respuesta') + g_q;
   if dm.sqlselect(dm.q1,consulta) then begin
      consulta:= 'update parametro set dato=' + g_q + fpt_vr_min_tiempo_promedio_respuesta.Text + g_q +
                 ' where clave=' + g_q + UpperCase('fpt_vr_min_tiempo_promedio_respuesta') + g_q;
      if dm.sqlupdate(consulta) then
         btn_fpt_vr_min_tiempo_promedio_respuesta.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede actualizar fpt_vr_min_tiempo_promedio_respuesta' ),
                                 pchar( 'Aviso' ), MB_OK );
   end
   else begin
      consulta:='insert into parametro (clave,dato) values ( ' +
                g_q + UpperCase('fpt_vr_min_tiempo_promedio_respuesta') + g_q + ' , ' +  // clave
                g_q + fpt_vr_min_tiempo_promedio_respuesta.Text + g_q +  // dato
                ')';
      if dm.sqlinsert(consulta) then
         btn_fpt_vr_min_tiempo_promedio_respuesta.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede insertar fpt_vr_min_tiempo_promedio_respuesta' ),
                                 pchar( 'Aviso' ), MB_OK );
   end;
end;

procedure Tftsparametros.btn_fpt_vr_max_commitClick(Sender: TObject);
begin
   if trim(fpt_vr_max_commit.Text) = '' then
      exit;

   if not valida_minmax('fpt_vr_max_commit', strtofloat(fpt_vr_max_commit.text)) then
      exit;

   consulta:= 'select * from parametro where clave=' + g_q + UpperCase('fpt_vr_max_commit') + g_q;
   if dm.sqlselect(dm.q1,consulta) then begin
      consulta:= 'update parametro set secuencia=' + g_q + fpt_vr_max_commit.Text + g_q +
                 ' where clave=' + g_q + UpperCase('fpt_vr_max_commit') + g_q;
      if dm.sqlupdate(consulta) then
         btn_fpt_vr_max_commit.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede actualizar fpt_vr_max_commit' ),
                                 pchar( 'Aviso' ), MB_OK );
   end
   else begin
      consulta:='insert into parametro (clave,secuencia) values ( ' +
                g_q + UpperCase('fpt_vr_max_commit') + g_q + ' , ' +  // clave
                g_q + fpt_vr_max_commit.Text + g_q +  // secuencia
                ')';
      if dm.sqlinsert(consulta) then
         btn_fpt_vr_max_commit.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede insertar fpt_vr_max_commit' ),
                                 pchar( 'Aviso' ), MB_OK );
   end;
end;

procedure Tftsparametros.btn_fpt_vr_max_numero_muestrasClick(Sender: TObject);
begin
   if trim(fpt_vr_max_numero_muestras.Text) = '' then
      exit;

   if not valida_minmax('fpt_vr_max_numero_muestras', strtofloat(fpt_vr_max_numero_muestras.text)) then
      exit;

   consulta:= 'select * from parametro where clave=' + g_q + UpperCase('fpt_vr_max_numero_muestras') + g_q;
   if dm.sqlselect(dm.q1,consulta) then begin
      consulta:= 'update parametro set secuencia=' + g_q + fpt_vr_max_numero_muestras.Text + g_q +
                 ' where clave=' + g_q + UpperCase('fpt_vr_max_numero_muestras') + g_q;
      if dm.sqlupdate(consulta) then
         btn_fpt_vr_max_numero_muestras.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede actualizar fpt_vr_max_numero_muestras' ),
                                 pchar( 'Aviso' ), MB_OK );
   end
   else begin
      consulta:='insert into parametro (clave,secuencia) values (' +
                g_q + UpperCase('fpt_vr_max_numero_muestras') + g_q + ' , ' +  // clave
                g_q + fpt_vr_max_numero_muestras.Text + g_q +   //secuencia
                ')';
      if dm.sqlinsert(consulta) then
         btn_fpt_vr_max_numero_muestras.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede insertar fpt_vr_max_numero_muestras' ),
                                 pchar( 'Aviso' ), MB_OK );
   end;
end;

procedure Tftsparametros.btn_fpt_vr_max_storage_violationClick(Sender: TObject);
begin
   if trim(fpt_vr_max_storage_violation.Text) = '' then
      exit;

   if not valida_minmax('fpt_vr_max_storage_violation', strtofloat(fpt_vr_max_storage_violation.text)) then
      exit;

   consulta:= 'select * from parametro where clave=' + g_q + UpperCase('fpt_vr_max_storage_violation') + g_q;
   if dm.sqlselect(dm.q1,consulta) then begin
      consulta:= 'update parametro set secuencia=' + g_q + fpt_vr_max_storage_violation.Text + g_q +
                 ' where clave=' + g_q + UpperCase('fpt_vr_max_storage_violation') + g_q;
      if dm.sqlupdate(consulta) then
         btn_fpt_vr_max_storage_violation.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede actualizar fpt_vr_max_storage_violation' ),
                                 pchar( 'Aviso' ), MB_OK );
   end
   else begin
      consulta:='insert into parametro (clave,secuencia) values (' +
                g_q + UpperCase('fpt_vr_max_storage_violation') + g_q + ' , ' +   // clave
                g_q + fpt_vr_max_storage_violation.Text + g_q +   // secuencia
                ')';
      if dm.sqlinsert(consulta) then
         btn_fpt_vr_max_storage_violation.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede insertar fpt_vr_max_storage_violation' ),
                                 pchar( 'Aviso' ), MB_OK );
   end;
end;

procedure Tftsparametros.btn_fpt_vr_max_tiempo_promedio_cpuClick(Sender: TObject);
begin
   if trim(fpt_vr_max_tiempo_promedio_cpu.Text) = '' then
      exit;

   if not valida_minmax('fpt_vr_max_tiempo_promedio_cpu', strtofloat(fpt_vr_max_tiempo_promedio_cpu.text)) then
      exit;

   consulta:= 'select * from parametro where clave=' + g_q + UpperCase('fpt_vr_max_tiempo_promedio_cpu') + g_q;
   if dm.sqlselect(dm.q1,consulta) then begin
      consulta:= 'update parametro set dato=' + g_q + fpt_vr_max_tiempo_promedio_cpu.Text + g_q +
                 ' where clave=' + g_q + UpperCase('fpt_vr_max_tiempo_promedio_cpu') + g_q;
      if dm.sqlupdate(consulta) then
         btn_fpt_vr_max_tiempo_promedio_cpu.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede actualizar fpt_vr_max_tiempo_promedio_cpu' ),
                                 pchar( 'Aviso' ), MB_OK );
   end
   else begin
      consulta:='insert into parametro (clave,dato) values (' +
                g_q + UpperCase('fpt_vr_max_tiempo_promedio_cpu') + g_q + ' , ' +   // clave
                g_q + fpt_vr_max_tiempo_promedio_cpu.Text + g_q +  // dato
                ')';
      if dm.sqlinsert(consulta) then
         btn_fpt_vr_max_tiempo_promedio_cpu.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede insertar fpt_vr_max_tiempo_promedio_cpu' ),
                                 pchar( 'Aviso' ), MB_OK );
   end;
end;

procedure Tftsparametros.btn_fpt_vr_max_tiempo_promedio_respuestaClick(Sender: TObject);
begin
   if trim(fpt_vr_max_tiempo_promedio_respuesta.Text) = '' then
      exit;

   if not valida_minmax('fpt_vr_max_tiempo_promedio_respuesta', strtofloat(fpt_vr_max_tiempo_promedio_respuesta.text)) then
      exit;

   consulta:= 'select * from parametro where clave=' + g_q + UpperCase('fpt_vr_max_tiempo_promedio_respuesta') + g_q;
   if dm.sqlselect(dm.q1,consulta) then begin
      consulta:= 'update parametro set dato=' + g_q + fpt_vr_max_tiempo_promedio_respuesta.Text + g_q +
                 ' where clave=' + g_q + UpperCase('fpt_vr_max_tiempo_promedio_respuesta') + g_q;
      if dm.sqlupdate(consulta) then
         btn_fpt_vr_max_tiempo_promedio_respuesta.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede actualizar fpt_vr_max_tiempo_promedio_respuesta' ),
                                 pchar( 'Aviso' ), MB_OK );
   end
   else begin
      consulta:='insert into parametro (clave,dato) values (' +
                g_q + UpperCase('fpt_vr_max_tiempo_promedio_respuesta') + g_q + ' , ' +   // clave
                g_q + fpt_vr_max_tiempo_promedio_respuesta.Text + g_q +  // dato
                ')';
      if dm.sqlinsert(consulta) then
         btn_fpt_vr_max_tiempo_promedio_respuesta.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede insertar fpt_vr_max_tiempo_promedio_respuesta' ),
                                 pchar( 'Aviso' ), MB_OK );
   end;
end;

procedure Tftsparametros.btn_fpt_smtp_fromClick(Sender: TObject);
begin
   if not emailValido(fpt_smtp_from.Text) then begin
      Application.MessageBox( pchar( 'Correo inválido' ),
                                 pchar( 'Origen' ), MB_OK );
      exit;
   end;

   consulta:= 'select * from parametro where clave=' + g_q + UpperCase('fpt_smtp_from') + g_q;
   if dm.sqlselect(dm.q1,consulta) then begin
      consulta:= 'update parametro set dato=' + g_q + fpt_smtp_from.Text + g_q +
                 ' where clave=' + g_q + UpperCase('fpt_smtp_from') + g_q;
      if dm.sqlupdate(consulta) then
         btn_fpt_smtp_from.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede actualizar fpt_smtp_from' ),
                                 pchar( 'Aviso' ), MB_OK );
   end
   else begin
      consulta:='insert into parametro (clave,dato) values (' +
                g_q + UpperCase('fpt_smtp_from') + g_q + ' , ' +   // clave
                g_q + fpt_smtp_from.Text + g_q +  // dato
                ')';
      if dm.sqlinsert(consulta) then
         btn_fpt_smtp_from.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede insertar fpt_smtp_from' ),
                                 pchar( 'Aviso' ), MB_OK );
   end;
end;

procedure Tftsparametros.btn_fpt_smtp_hostClick(Sender: TObject);
begin
   consulta:= 'select * from parametro where clave=' + g_q + UpperCase('fpt_smtp_host') + g_q;
   if dm.sqlselect(dm.q1,consulta) then begin
      consulta:= 'update parametro set dato=' + g_q + fpt_smtp_host.Text + g_q +
                 ' where clave=' + g_q + UpperCase('fpt_smtp_host') + g_q;
      if dm.sqlupdate(consulta) then
         btn_fpt_smtp_host.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede actualizar fpt_smtp_host' ),
                                 pchar( 'Aviso' ), MB_OK );
   end
   else begin
      consulta:='insert into parametro (clave,dato) values (' +
                g_q + UpperCase('fpt_smtp_host') + g_q + ' , ' +   // clave
                g_q + fpt_smtp_host.Text + g_q + // dato
                ')';
      if dm.sqlinsert(consulta) then
         btn_fpt_smtp_host.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede insertar fpt_smtp_host' ),
                                 pchar( 'Aviso' ), MB_OK );
   end;
end;

procedure Tftsparametros.btn_fpt_smtp_portClick(Sender: TObject);
begin
   consulta:= 'select * from parametro where clave=' + g_q + UpperCase('fpt_smtp_port') + g_q;
   if dm.sqlselect(dm.q1,consulta) then begin
      consulta:= 'update parametro set secuencia=' + g_q + fpt_smtp_port.Text + g_q +
                 ' where clave=' + g_q + UpperCase('fpt_smtp_port') + g_q;
      if dm.sqlupdate(consulta) then
         btn_fpt_smtp_port.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede actualizar fpt_smtp_port' ),
                                 pchar( 'Aviso' ), MB_OK );
   end
   else begin
      consulta:='insert into parametro (clave,secuencia) values (' +
                g_q + UpperCase('fpt_smtp_port') + g_q + ' , ' +   // clave
                g_q + fpt_smtp_port.Text + g_q +   // secuencia
                ')';
      if dm.sqlinsert(consulta) then
         btn_fpt_smtp_port.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede insertar fpt_smtp_port' ),
                                 pchar( 'Aviso' ), MB_OK );
   end;
end;

procedure Tftsparametros.btn_fpt_smtp_pswClick(Sender: TObject);
begin
   consulta:= 'select * from parametro where clave=' + g_q + UpperCase('fpt_smtp_psw') + g_q;
   if dm.sqlselect(dm.q1,consulta) then begin
      //consulta:= 'update parametro set dato=' + g_q + encripta(fpt_smtp_psw.Text) + g_q +
      consulta:= 'update parametro set dato=' + g_q + fpt_smtp_psw.Text + g_q +
                 ' where clave=' + g_q + UpperCase('fpt_smtp_psw') + g_q;
      if dm.sqlupdate(consulta) then
         btn_fpt_smtp_psw.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede actualizar fpt_smtp_psw' ),
                                 pchar( 'Aviso' ), MB_OK );
   end
   else begin
      consulta:='insert into parametro (clave,dato) values (' +
                g_q + UpperCase('fpt_smtp_psw') + g_q + ' , ' +   // clave
                //g_q + encripta(fpt_smtp_psw.Text) + g_q +  // dato
                g_q + fpt_smtp_psw.Text + g_q +  // dato
                ')';
      if dm.sqlinsert(consulta) then
         btn_fpt_smtp_psw.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede insertar fpt_smtp_psw' ),
                                 pchar( 'Aviso' ), MB_OK );
   end;
end;

procedure Tftsparametros.btn_fpt_smtp_depto_bdClick(Sender: TObject);
begin
   if not emailValido(fpt_smtp_from.Text) then begin
      Application.MessageBox( pchar( 'Correo inválido' ),
                                 pchar( 'Departamento BD' ), MB_OK );
      exit;
   end;

   consulta:= 'select * from parametro where clave=' + g_q + UpperCase('fpt_smtp_depto_bd') + g_q;
   if dm.sqlselect(dm.q1,consulta) then begin
      consulta:= 'update parametro set dato=' + g_q + fpt_smtp_depto_bd.Text + g_q +
                 ' where clave=' + g_q + UpperCase('fpt_smtp_depto_bd') + g_q;
      if dm.sqlupdate(consulta) then
         btn_fpt_smtp_depto_bd.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede actualizar fpt_smtp_depto_bd' ),
                                 pchar( 'Aviso' ), MB_OK );
   end
   else begin
      consulta:='insert into parametro (clave,dato) values (' +
                g_q + UpperCase('fpt_smtp_depto_bd') + g_q + ' , ' +   // clave
                g_q + fpt_smtp_depto_bd.Text + g_q +  // dato
                ')';
      if dm.sqlinsert(consulta) then
         btn_fpt_smtp_depto_bd.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede insertar fpt_smtp_depto_bd' ),
                                 pchar( 'Aviso' ), MB_OK );
   end;
end;

procedure Tftsparametros.btn_fpt_incluye_archivos_strobeClick(Sender: TObject);
begin
   consulta:= 'select * from parametro where clave=' + g_q + UpperCase('fpt_incluye_archivos_strobe') + g_q;
   if dm.sqlselect(dm.q1,consulta) then begin
      consulta:= 'update parametro set dato=' + g_q + fpt_incluye_archivos_strobe.Text + g_q +
                 ' where clave=' + g_q + UpperCase('fpt_incluye_archivos_strobe') + g_q;
      if dm.sqlupdate(consulta) then
         btn_fpt_incluye_archivos_strobe.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede actualizar fpt_incluye_archivos_strobe' ),
                                 pchar( 'Aviso' ), MB_OK );
   end
   else begin
      consulta:='insert into parametro (clave,dato) values (' +
                g_q + UpperCase('fpt_incluye_archivos_strobe') + g_q + ' , ' +   // clave
                g_q + fpt_incluye_archivos_strobe.Text + g_q +  // dato
                ')';
      if dm.sqlinsert(consulta) then
         btn_fpt_incluye_archivos_strobe.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede insertar fpt_incluye_archivos_strobe' ),
                                 pchar( 'Aviso' ), MB_OK );
   end;
end;

procedure Tftsparametros.btn_fptbatch_expire_daysClick(Sender: TObject);
begin
   if trim(fptbatch_expire_days.Text) = '' then
      exit;

   if (strtofloat(fptbatch_expire_days.Text) > 10) or
      (strtofloat(fptbatch_expire_days.Text) < 1) then begin
      Application.MessageBox( pchar( 'El valor debe estar entre 1 y 10' ),
                                 pchar( 'Aviso' ), MB_OK );
      exit;
   end;

   consulta:= 'select * from parametro where clave=' + g_q + UpperCase('fptbatch_expire_days') + g_q;
   if dm.sqlselect(dm.q1,consulta) then begin
      consulta:= 'update parametro set secuencia=' + g_q + fptbatch_expire_days.Text + g_q +
                 ' where clave=' + g_q + UpperCase('fptbatch_expire_days') + g_q;
      if dm.sqlupdate(consulta) then
         btn_fptbatch_expire_days.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede actualizar fptbatch_expire_days' ),
                                 pchar( 'Aviso' ), MB_OK );
   end
   else begin
      consulta:='insert into parametro (clave,secuencia) values (' +
                g_q + UpperCase('fptbatch_expire_days') + g_q + ' , ' +   // clave
                g_q + fptbatch_expire_days.Text + g_q +     // secuencia
                ')';
      if dm.sqlinsert(consulta) then
         btn_fptbatch_expire_days.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede insertar fptbatch_expire_days' ),
                                 pchar( 'Aviso' ), MB_OK );
   end;
end;

procedure Tftsparametros.btn_fpt_vr_min_abendClick(Sender: TObject);
begin
   if trim(fpt_vr_min_abend.Text) = '' then
      exit;

   if not valida_minmax('fpt_vr_min_abend', strtofloat(fpt_vr_min_abend.text)) then
      exit;

   consulta:= 'select * from parametro where clave=' + g_q + UpperCase('fpt_vr_min_abend') + g_q;
   if dm.sqlselect(dm.q1,consulta) then begin
      consulta:= 'update parametro set secuencia=' + g_q + fpt_vr_min_abend.Text + g_q +
                 ' where clave=' + g_q + UpperCase('fpt_vr_min_abend') + g_q;
      if dm.sqlupdate(consulta) then
         btn_fpt_vr_min_abend.Visible:=false
      else
         Application.MessageBox( pchar( 'No puede actualizar fpt_vr_min_abend' ),
                                 pchar( 'Aviso' ), MB_OK );
   end
   else begin
      consulta:='insert into parametro (clave,secuencia) values (' +
                g_q + UpperCase('fpt_vr_min_abend') + g_q + ' , ' +   // clave
                g_q + fpt_vr_min_abend.Text + g_q +     // secuencia
                ')';
      if dm.sqlinsert(consulta) then
         btn_fpt_vr_min_abend.Visible:=false
      else
         Application.MessageBox( pchar( 'No puede insertar fpt_vr_min_abend' ),
                                 pchar( 'Aviso' ), MB_OK );
   end;
end;

procedure Tftsparametros.btn_fpt_vr_max_abendClick(Sender: TObject);
begin
   if trim(fpt_vr_max_abend.Text) = '' then
      exit;

   if not valida_minmax('fpt_vr_max_abend', strtofloat(fpt_vr_max_abend.text)) then
      exit;

   consulta:= 'select * from parametro where clave=' + g_q + UpperCase('fpt_vr_max_abend') + g_q;
   if dm.sqlselect(dm.q1,consulta) then begin
      consulta:= 'update parametro set secuencia=' + g_q + fpt_vr_max_abend.Text + g_q +
                 ' where clave=' + g_q + UpperCase('fpt_vr_max_abend') + g_q;
      if dm.sqlupdate(consulta) then
         btn_fpt_vr_max_abend.Visible:=false
      else
         Application.MessageBox( pchar( 'No puede actualizar fpt_vr_max_abend' ),
                                 pchar( 'Aviso' ), MB_OK );
   end
   else begin
      consulta:='insert into parametro (clave,secuencia) values (' +
                g_q + UpperCase('fpt_vr_max_abend') + g_q + ' , ' +   // clave
                g_q + fpt_vr_max_abend.Text + g_q +     // secuencia
                ')';
      if dm.sqlinsert(consulta) then
         btn_fpt_vr_max_abend.Visible:=false
      else
         Application.MessageBox( pchar( 'No puede insertar fpt_vr_max_abend' ),
                                 pchar( 'Aviso' ), MB_OK );
   end;
end;

procedure Tftsparametros.btn_fpt_multiproceso_solicitudClick(Sender: TObject);
begin
   if trim(fpt_multiproceso_solicitud.Text) = '' then
      exit;

   if (strtofloat(fpt_multiproceso_solicitud.Text) > 99) or
      (strtofloat(fpt_multiproceso_solicitud.Text) < 1) then begin
      Application.MessageBox( pchar( 'El valor debe estar entre 1 y 99' ),
                                 pchar( 'Aviso' ), MB_OK );
      exit;
   end;

   consulta:= 'select * from parametro where clave=' + g_q + UpperCase('fpt_multiproceso_solicitud'+'_'+pais) + g_q;
   if dm.sqlselect(dm.q1,consulta) then begin
      consulta:= 'update parametro set secuencia=' + g_q + fpt_multiproceso_solicitud.Text + g_q +
                 ' where clave=' + g_q + UpperCase('fpt_multiproceso_solicitud'+'_'+pais) + g_q;
      if dm.sqlupdate(consulta) then
         btn_fpt_multiproceso_solicitud.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede actualizar fpt_multiproceso_solicitud' ),
                                 pchar( 'Aviso' ), MB_OK );
   end
   else begin
      consulta:='insert into parametro (clave,secuencia) values (' +
                g_q + UpperCase('fpt_multiproceso_solicitud'+'_'+pais) + g_q + ' , ' +   // clave
                g_q + fpt_multiproceso_solicitud.Text + g_q +     // secuencia
                ')';
      if dm.sqlinsert(consulta) then
         btn_fpt_multiproceso_solicitud.Visible:=False
      else
         Application.MessageBox( pchar( 'No puede insertar fpt_multiproceso_solicitud' ),
                                 pchar( 'Aviso' ), MB_OK );
   end;
end;

// --- Validar numerico en edit de secuencia --
procedure Tftsparametros.fpt_vr_min_storage_violationKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then begin    // si es enter
      btn_fpt_vr_min_storage_violationClick(self);
      exit;
   end;

   if not (key in ['0'..'9',#127,#8]) then
    begin
      key:=#0;
      showmessage('Por favor introduzca numeros');
    end;

    if key <> #9 then   // si no es tabulador
       btn_fpt_vr_min_storage_violation.Visible:=true;
end;

procedure Tftsparametros.fpt_vr_max_storage_violationKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then begin    // si es enter
      btn_fpt_vr_max_storage_violationClick(self);
      exit;
   end;

   if not (key in ['0'..'9',#127,#8]) then
    begin
      key:=#0;
      showmessage('Por favor introduzca numeros');
    end;

    if key <> #9 then   // si no es tabulador
       btn_fpt_vr_max_storage_violation.Visible:=true;
end;

procedure Tftsparametros.fpt_vr_min_numero_muestrasKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then begin    // si es enter
      btn_fpt_vr_min_numero_muestrasClick(self);
      exit;
   end;

   if not (key in ['0'..'9',#127,#8]) then
    begin
      key:=#0;
      showmessage('Por favor introduzca numeros');
    end;

    if key <> #9 then   // si no es tabulador
       btn_fpt_vr_min_numero_muestras.Visible:=true;
end;

procedure Tftsparametros.fpt_vr_max_numero_muestrasKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then begin    // si es enter
      btn_fpt_vr_max_numero_muestrasClick(self);
      exit;
   end;

   if not (key in ['0'..'9',#127,#8]) then begin
      key:=#0;
      showmessage('Por favor introduzca numeros');
    end;

    if key <> #9 then   // si no es tabulador
       btn_fpt_vr_max_numero_muestras.Visible:=true;
end;

procedure Tftsparametros.fpt_vr_min_commitKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then begin    // si es enter
      btn_fpt_vr_min_commitClick(self);
      exit;
   end;

   if not (key in ['0'..'9',#127,#8]) then
    begin
      key:=#0;
      showmessage('Por favor introduzca numeros');
    end;

    if key <> #9 then   // si no es tabulador
      btn_fpt_vr_min_commit.Visible:=true;
end;

procedure Tftsparametros.fpt_vr_max_commitKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then begin    // si es enter
      btn_fpt_vr_max_commitClick(self);
      exit;
   end;

   if not (key in ['0'..'9',#127,#8]) then
    begin
      key:=#0;
      showmessage('Por favor introduzca numeros');
    end;

    if key <> #9 then   // si no es tabulador
       btn_fpt_vr_max_commit.Visible:=true;
end;

procedure Tftsparametros.fpt_smtp_portKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then begin    // si es enter
      btn_fpt_smtp_portClick(self);
      exit;
   end;

   if not (key in ['0'..'9',#127,#8]) then
    begin
      key:=#0;
      showmessage('Por favor introduzca numeros');
    end;

    if key <> #9 then   // si no es tabulador
       btn_fpt_smtp_port.Visible:=true;
end;

procedure Tftsparametros.fptbatch_expire_daysKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then begin    // si es enter
      btn_fptbatch_expire_daysClick(self);
      exit;
   end;

   if not (key in ['0'..'9',#127,#8]) then
    begin
      key:=#0;
      showmessage('Por favor introduzca numeros');
    end;

    if key <> #9 then   // si no es tabulador
       btn_fptbatch_expire_days.Visible:=true;
end;

procedure Tftsparametros.fpt_vr_min_abendKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then begin    // si es enter
      btn_fpt_vr_min_abendClick(self);
      exit;
   end;

   if not (key in ['0'..'9',#127,#8]) then
    begin
      key:=#0;
      showmessage('Por favor introduzca numeros');
    end;

    if key <> #9 then   // si no es tabulador
       btn_fpt_vr_min_abend.Visible:=true;
end;

procedure Tftsparametros.fpt_vr_max_abendKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then begin    // si es enter
      btn_fpt_vr_max_abendClick(self);
      exit;
   end;

   if not (key in ['0'..'9',#127,#8]) then
    begin
      key:=#0;
      showmessage('Por favor introduzca numeros');
    end;

    if key <> #9 then   // si no es tabulador
       btn_fpt_vr_max_abend.Visible:=true;
end;

procedure Tftsparametros.fpt_vr_min_tiempo_promedio_cpuKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then begin    // si es enter
      btn_fpt_vr_min_tiempo_promedio_cpuClick(self);
      exit;
   end;

   if not (key in ['0'..'9',#127,#8,#46]) then begin
      key:=#0;
      showmessage('Por favor introduzca numeros');
   end;

   if key = #46 then        // si es punto
      if ansipos('.',fpt_vr_min_tiempo_promedio_cpu.Text) > 0 then begin
         key:=#0;
         showmessage('Solo se permite un punto');
      end;

   if key <> #9 then   // si no es tabulador
      btn_fpt_vr_min_tiempo_promedio_cpu.Visible:=true;
end;

procedure Tftsparametros.fpt_vr_min_tiempo_promedio_respuestaKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then begin    // si es enter
      btn_fpt_vr_min_tiempo_promedio_respuestaClick(self);
      exit;
   end;

   if not (key in ['0'..'9',#127,#8,#46]) then begin
      key:=#0;
      showmessage('Por favor introduzca numeros');
    end;

    if key = #46 then        // si es punto
      if ansipos('.',fpt_vr_min_tiempo_promedio_respuesta.Text) > 0 then begin
         key:=#0;
         showmessage('Solo se permite un punto');
      end;

   if key <> #9 then   // si no es tabulador
      btn_fpt_vr_min_tiempo_promedio_respuesta.Visible:=true;
end;

procedure Tftsparametros.fpt_vr_max_tiempo_promedio_respuestaKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then begin    // si es enter
      btn_fpt_vr_max_tiempo_promedio_respuestaClick(self);
      exit;
   end;

   if not (key in ['0'..'9',#127,#8,#46]) then begin
      key:=#0;
      showmessage('Por favor introduzca numeros');
    end;

    if key = #46 then        // si es punto
      if ansipos('.',fpt_vr_max_tiempo_promedio_respuesta.Text) > 0 then begin
         key:=#0;
         showmessage('Solo se permite un punto');
      end;
      
   if key <> #9 then   // si no es tabulador
      btn_fpt_vr_max_tiempo_promedio_respuesta.Visible:=true;
end;

procedure Tftsparametros.fpt_vr_max_tiempo_promedio_cpuKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then begin    // si es enter
      btn_fpt_vr_max_tiempo_promedio_cpuClick(self);
      exit;
   end;

   if not (key in ['0'..'9',#127,#8,#46]) then begin
      key:=#0;
      showmessage('Por favor introduzca numeros');
   end;

   if key = #46 then        // si es punto
      if ansipos('.',fpt_vr_max_tiempo_promedio_cpu.Text) > 0 then begin
         key:=#0;
         showmessage('Solo se permite un punto');
      end;

   if key <> #9 then   // si no es tabulador
      btn_fpt_vr_max_tiempo_promedio_cpu.Visible:=true;
end;

procedure Tftsparametros.fpt_multiproceso_solicitudKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then begin    // si es enter
      btn_fpt_multiproceso_solicitudClick(self);
      exit;
   end;

   if not (key in ['0'..'9',#127,#8]) then begin
      key:=#0;
      showmessage('Por favor introduzca numeros');
   end;

    if key <> #9 then   // si no es tabulador
       btn_fpt_multiproceso_solicitud.Visible:=true;
end;

// --- Activar boton para combos ---
procedure Tftsparametros.fpt_realiza_vrKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then begin    // si es enter
      btn_fpt_realiza_vrClick(self);
      exit;
   end;

   if key <> '#9' then    // si es tabulador
      btn_fpt_realiza_vr.Visible:=true;
end;

procedure Tftsparametros.fpt_condicion_vrKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then begin    // si es enter
      btn_fpt_condicion_vrClick(self);
      exit;
   end;

   if key <> '#9' then    // si es tabulador
      btn_fpt_condicion_vr.Visible:=true;
end;

procedure Tftsparametros.fpt_incluye_archivos_strobeKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then begin    // si es enter
      btn_fpt_incluye_archivos_strobeClick(self);
      exit;
   end;

   if key <> '#9' then    // si es tabulador
      btn_fpt_incluye_archivos_strobe.Visible:=true;
end;

procedure Tftsparametros.fpt_smtp_fromKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then begin    // si es enter
      btn_fpt_smtp_fromClick(self);
      exit;
   end;

   if not (key in ['a'..'z','A'..'Z','0'..'9',#127,#8,#64,#46,#95,#45]) then begin    //letras, punto y arroba  guiones bajo y alto
      showmessage('"'+key+'" es un caracter no permitido');
      key:=#0;
   end;

   if key <> #9 then   // si no es tabulador
      btn_fpt_smtp_from.Visible:=true;
end;

procedure Tftsparametros.fpt_smtp_hostKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then begin    // si es enter
      btn_fpt_smtp_hostClick(self);
      exit;
   end;                                

   if not (key in ['0'..'9',#127,#8,#46]) then begin    // numeros y punto
     showmessage('"'+key+'" es un caracter no permitido');
     key:=#0;
   end;

   if key <> #9 then   // si no es tabulador
      btn_fpt_smtp_host.Visible:=true;
end;

procedure Tftsparametros.fpt_smtp_pswKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then begin    // si es enter
      btn_fpt_smtp_pswClick(self);
      exit;
   end;

   if key <> #9 then   // si no es tabulador
      btn_fpt_smtp_psw.Visible:=true;
end;

procedure Tftsparametros.fpt_smtp_depto_bdKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then begin    // si es enter
      btn_fpt_smtp_depto_bdClick(self);
      exit;
   end;

   if not (key in ['a'..'z','A'..'Z','0'..'9',#127,#8,#64,#46,#95,#45]) then begin    //letras, punto y arroba  guiones bajo y alto
      showmessage('"'+key+'" es un caracter no permitido');
      key:=#0;
   end;

   if key <> #9 then   // si no es tabulador
      btn_fpt_smtp_depto_bd.Visible:=true;
end;

// --------------------------------------------------------------

function Tftsparametros.valida_minmax(componente:String; valor:Extended):boolean;
var
   i,mm: integer;
   maxmin: String;
begin
   if valor >99999999999999 then begin
      Application.MessageBox('El valor excede de 14 digitos','Aviso',MB_ICONINFORMATION);
      valida_minmax:=false;
      exit;
   end;
   mm:=-1;
   if ansipos('max',componente) > 0 then begin    // si es maximo, hay que encontrar el minimo
      maxmin:=stringreplace(componente,'max','min',[rfReplaceAll, rfIgnoreCase]);
      mm:=0;
   end;
   if ansipos('min',componente) > 0 then begin    // si es minimo, hay que encontrar el maximo
      maxmin:=stringreplace(componente,'min','max',[rfReplaceAll, rfIgnoreCase]);
      mm:=1;
   end;

   for i:=0 to componentcount-1 do begin
      if (components[i] is TEdit) then begin
         if (components[i] as TEdit).Name = maxmin then begin
            case mm of
               0: begin
                  if (components[i] as TEdit).Text <> '' then begin
                     if valor <= strtofloat((components[i] as TEdit).Text) then begin
                        Application.MessageBox('El valor máximo debe ser mayor al mínimo','Aviso',MB_ICONINFORMATION);
                        valida_minmax:=false;
                        exit;
                     end;
                  end;
               end;
               1: begin
                  if (components[i] as TEdit).Text <> '' then begin
                     if valor >= strtofloat((components[i] as TEdit).Text) then begin
                        Application.MessageBox('El valor mínimo debe ser menor al máximo','Aviso',MB_ICONINFORMATION);
                        valida_minmax:=false;
                        exit;
                     end;
                  end;
               end;
            end;
         end;
      end;
   end;
   valida_minmax:=true;
end;

// --------------------------------------------------------------
procedure Tftsparametros.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
   i,j:integer;
   componente : String;
   lista:TStringList;
begin
   lista:=TStringList.Create;
   for i:=0 to componentcount-1 do begin
     if (components[i] is TButton) then begin
        if (components[i] as TButton).Visible = true then
           if ((components[i] as TButton).Name <> 'btn_faltantes') and
              ((components[i] as TButton).Name <> 'cerrar') and
              ((components[i] as TButton).Name <> 'refresh') then
              for j:=0 to length(claves)-1 do begin
                 componente:= stringreplace((components[i] as TButton).Name,
                              'btn_','',[rfReplaceAll, rfIgnoreCase]);
                 if componente = claves[j].dato then begin
                    lista.Add(claves[j].nombre);
                    break;
                 end;
              end;
     end;
   end;

   if lista.count > 0 then
      if Application.MessageBox( pchar( 'Hay cambios sin guardar ' + char(13) + char(13)+
               lista.text + char(13) + char(13)+ ' ¿Desea salir del sistema' + char(13)+
               'e ignorar los cambios?'),pchar( 'Aviso' ),
               (MB_YESNO + MB_ICONQUESTION) ) = IDNO then
         CanClose := False;

   lista.Free;
end;


procedure Tftsparametros.refreshClick(Sender: TObject);
var
   i,j:integer;
   componente : String;
   lista:TStringList;
begin
   lista:=TStringList.Create;
   for i:=0 to componentcount-1 do begin
     if (components[i] is TButton) then begin
        if (components[i] as TButton).Visible = true then
           if ((components[i] as TButton).Name <> 'btn_faltantes') and
              ((components[i] as TButton).Name <> 'cerrar') and
              ((components[i] as TButton).Name <> 'refresh') then
              for j:=0 to length(claves)-1 do begin
                 componente:= stringreplace((components[i] as TButton).Name,
                              'btn_','',[rfReplaceAll, rfIgnoreCase]);
                 if componente = claves[j].dato then begin
                    lista.Add(claves[j].nombre);
                    break;
                 end;
              end;
     end;
   end;
   if bumbral.Visible then
      lista.Add('Umbrales');
   if lista.count > 0 then
      if Application.MessageBox( pchar( 'Hay cambios sin guardar ' + char(13) + char(13)+
               lista.text + char(13) + char(13)+ ' ¿Desea refrescar la pantalla ' + char(13)+
               'e ignorar los cambios?'), pchar( 'Aviso' ),
               (MB_YESNO + MB_ICONQUESTION) ) = IDYES then begin

         crear;
         for i:=0 to componentcount-1 do begin
            if (components[i] is TButton) then
               if ((components[i] as TButton).Name <> 'cerrar') and
                  ((components[i] as TButton).Name <> 'refresh') and
                  ((components[i] as TButton).Visible = true) then
                  (components[i] as TButton).Visible:=false;
         end;
      end;

   lista.Free;
end;

procedure Tftsparametros.cerrarClick(Sender: TObject);
var
   i,j:integer;
   componente : String;
   lista:TStringList;
begin
   lista:=TStringList.Create;
   for i:=0 to componentcount-1 do begin
     if (components[i] is TButton) then begin
        if (components[i] as TButton).Visible = true then
           if ((components[i] as TButton).Name <> 'btn_faltantes') and
              ((components[i] as TButton).Name <> 'cerrar') and
              ((components[i] as TButton).Name <> 'refresh') then
              for j:=0 to length(claves)-1 do begin
                 componente:= stringreplace((components[i] as TButton).Name,
                              'btn_','',[rfReplaceAll, rfIgnoreCase]);
                 if componente = claves[j].dato then begin
                    lista.Add(claves[j].nombre);
                    break;
                 end;
              end;
     end;
   end;
   if bumbral.Visible then
      lista.Add('Umbrales');
   if lista.count > 0 then
      if Application.MessageBox( pchar( 'Hay cambios sin guardar ' + char(13) + char(13)+
               lista.text + char(13) + char(13)+ ' ¿Desea abandonar la pantalla ' + char(13)+
               'e ignorar los cambios?'), pchar( 'Aviso' ),
               (MB_YESNO + MB_ICONQUESTION) ) = IDNO then
               exit;
   Self.Close;
end;

function Tftsparametros.emailValido(const Value: String): boolean;
   function CheckAllowed(const s: String): boolean;
   var
      i: Integer;
   begin
      Result:= False;
      for i:= 1 to Length(s) do
      if not (s[i] in ['a'..'z','A'..'Z','0'..'9','_','-','.']) then Exit;
      Result:= true;
   end;
var
   i,len: Integer;
   namePart, serverPart: String;
begin
   Result:= False;
   i:= Pos('@', Value);
   if (i=0) or (Pos('..',Value) > 0) then Exit;
   namePart:= Copy(Value, 1, i - 1);
   serverPart:= Copy(Value,i+1,Length(Value));
   len:=Length(serverPart);
   if (len<4) or
      (Pos('.',serverPart)=0) or
      (serverPart[1]='.') or
      (serverPart[len]='.') or
      (serverPart[len-1]='.') then Exit;
   Result:= CheckAllowed(namePart) and CheckAllowed(serverPart);
end;


procedure Tftsparametros.cmbcapaChange(Sender: TObject);
begin
   cmbconcepto.Items.Clear;
   if dm.sqlselect(dm.q1,'select distinct concepto from fptumbral '+
      ' where capa='+g_q+cmbcapa.Text+g_q+
      ' order by 1') then begin
      while not dm.q1.Eof do begin
         cmbconcepto.Items.Add(dm.q1.fieldbyname('concepto').AsString);
         dm.q1.Next;
      end;
   end;
   cmbsubconcepto.Items.Clear;
   cmbccategoria.Items.Clear;
   cmbcprog.Items.Clear;
   cmbcbib.Items.Clear;
   cmbcclase.Items.Clear;
   txtminimo.Text:='';
   txtmaximo.Text:='';
   txtmedida.Text:='';
   txtcumbral.Text:='';
   txtminimo.Enabled:=false;
   txtmaximo.Enabled:=false;
   bumbral.Visible:=false;
end;

procedure Tftsparametros.cmbconceptoChange(Sender: TObject);
begin
   if trim(cmbconcepto.Text)='' then exit;
   if dm.sqlselect(dm.q1,'select distinct subconcepto from fptumbral '+
      ' where capa='+g_q+cmbcapa.Text+g_q+
      ' and concepto='+g_q+cmbconcepto.Text+g_q+
      ' order by 1') then begin
      while not dm.q1.Eof do begin
         cmbsubconcepto.Items.Add(dm.q1.fieldbyname('subconcepto').AsString);
         dm.q1.Next;
      end;
   end;
   cmbccategoria.Items.Clear;
   cmbcprog.Items.Clear;
   cmbcbib.Items.Clear;
   cmbcclase.Items.Clear;
   txtminimo.Text:='';
   txtmaximo.Text:='';
   txtmedida.Text:='';
   txtcumbral.Text:='';
end;

procedure Tftsparametros.cmbsubconceptoChange(Sender: TObject);
begin
   if trim(cmbsubconcepto.Text)='' then exit;
   if dm.sqlselect(dm.q1,'select distinct ccategoria from fptumbral '+
      ' where capa='+g_q+cmbcapa.Text+g_q+
      ' and concepto='+g_q+cmbconcepto.Text+g_q+
      ' and subconcepto='+g_q+cmbsubconcepto.Text+g_q+
      ' order by 1') then begin
      while not dm.q1.Eof do begin
         cmbccategoria.Items.Add(dm.q1.fieldbyname('ccategoria').AsString);
         dm.q1.Next;
      end;
   end;
   cmbcprog.Items.Clear;
   cmbcbib.Items.Clear;
   cmbcclase.Items.Clear;
   txtminimo.Text:='';
   txtmaximo.Text:='';
   txtmedida.Text:='';
   txtcumbral.Text:='';
end;

procedure Tftsparametros.cmbccategoriaChange(Sender: TObject);
begin
   if trim(cmbccategoria.Text)='' then exit;
   cmbcprog.Items.Add('-TODOS-');
   cmbcbib.Items.Add('-todos-');
   cmbcclase.Items.Add('-todos-');
   cmbcprog.ItemIndex:=0;
   cmbcbib.ItemIndex:=0;
   cmbcclase.ItemIndex:=0;
   if dm.sqlselect(dm.q1,'select * from fptumbral '+
      ' where capa='+g_q+cmbcapa.Text+g_q+
      ' and concepto='+g_q+cmbconcepto.Text+g_q+
      ' and subconcepto='+g_q+cmbsubconcepto.Text+g_q+
      ' and ccategoria='+g_q+cmbccategoria.Text+g_q+
      ' and cprog='+g_q+cmbcprog.Text+g_q+
      ' and cbib='+g_q+cmbcbib.Text+g_q+
      ' and cclase='+g_q+cmbcclase.Text+g_q) then begin
      txtminimo.Text:=dm.q1.fieldbyname('minimo').AsString;
      txtmaximo.Text:=dm.q1.fieldbyname('maximo').AsString;
      txtmedida.Text:=dm.q1.fieldbyname('medida').AsString;
      txtcumbral.Text:=dm.q1.fieldbyname('cumbral').AsString;
      txtminimo.Enabled:=true;
      txtmaximo.Enabled:=true;
   end;
end;

procedure Tftsparametros.bumbralClick(Sender: TObject);
begin
   if trim(txtminimo.Text)='' then txtminimo.Text:='0';
   if trim(txtmaximo.Text)='' then txtmaximo.Text:='0';
   if length(trim(txtminimo.Text))>14 then begin
      Application.MessageBox('El valor minimo excede de 14 digitos','Aviso',MB_ICONINFORMATION);
      exit;
   end;
   if length(trim(txtmaximo.Text))>14 then begin
      Application.MessageBox('El valor maximo excede de 14 digitos','Aviso',MB_ICONINFORMATION);
      exit;
   end;
   if strtoint(txtminimo.Text)>strtoint(txtmaximo.Text) then begin
      Application.MessageBox('El valor mínimo debe ser menor al máximo','Aviso',MB_ICONINFORMATION);
      exit;
   end;
   if dm.sqlupdate('update fptumbral set minimo='+txtminimo.Text+', maximo='+txtmaximo.Text+
      ' where capa='+g_q+cmbcapa.Text+g_q+
      ' and concepto='+g_q+cmbconcepto.Text+g_q+
      ' and subconcepto='+g_q+cmbsubconcepto.Text+g_q+
      ' and ccategoria='+g_q+cmbccategoria.Text+g_q+
      ' and cprog='+g_q+cmbcprog.Text+g_q+
      ' and cbib='+g_q+cmbcbib.Text+g_q+
      ' and cclase='+g_q+cmbcclase.Text+g_q)=false then begin
      Application.MessageBox('No puede actualizar valor minimo y maximo','Aviso',MB_ICONINFORMATION);
      exit;
   end;
   bumbral.Visible:=false;
end;

procedure Tftsparametros.txtminimoKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then begin    // si es enter
      bumbralclick(self);
      exit;
   end;
   if not (key in ['0'..'9',#127,#8]) then begin
      key:=#0;
      showmessage('Por favor introduzca numeros');
    end;
    if key <> #9 then   // si no es tabulador
       bumbral.Visible:=true;
end;

procedure Tftsparametros.txtmaximoKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then begin    // si es enter
      bumbralclick(self);
      exit;
   end;
   if not (key in ['0'..'9',#127,#8]) then begin
      key:=#0;
      showmessage('Por favor introduzca numeros');
    end;
    if key <> #9 then   // si no es tabulador
       bumbral.Visible:=true;
end;

procedure Tftsparametros.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   gral.PubMuestraProgresBar( True );

   noExiste.Free;

   if FormStyle = fsMDIChild then
      dm.PubEliminarVentanaActiva( ftsparametros.Caption );  //quitar nombre de lista de abiertos

   gral.PubMuestraProgresBar( False );

   ftsparametros.Destroy;
end;

end.

