unit alkScheduler;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ShellApi, uConstantes;

type
  TalkFormScheduler = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    rgTipo: TRadioGroup;      //<RGM20170506> Se le eliminó la opción: Dependencia de componentes + Condiciones manuales + Horario

    Button1: TButton;
    Label3: TLabel;
    Label4: TLabel;
    rgPer: TRadioGroup;
    Label5: TLabel;
    ComboBox1: TComboBox;
    Label6: TLabel;
    Edit1: TEdit;
    Label7: TLabel;
    cbtodos: TCheckBox;
    rgtipolinea: TRadioGroup;
    procedure Button1Click(Sender: TObject);
    procedure rgPerClick(Sender: TObject);
    procedure rgTipoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure cbtodosClick(Sender: TObject);
  private
    { Private declarations }
     entrada, salida, clase, componente, sistema : String;
     sel_per, sel_tipo : integer;
     sel_dia : char;
     per, tipo,tipo_sal, dia_malla, nivel_malla : String;

     procedure es_CTR ();

  public
    { Public declarations }
    procedure get_nombre(titulo,cla,comp,sis:String);
    procedure es_CTM();
  end;

var
  alkFormScheduler: TalkFormScheduler;

implementation

uses ptsdm;

{$R *.dfm}

procedure TalkFormScheduler.es_CTR ();
var
   instruccion, sRutaMisDocumentos, sDirClase: String;
   error: TStringList;
begin
   chdir(g_tmpdir);
   sel_per:=rgPer.ItemIndex;
   case sel_per of
      0: per:='M';   //No genera nada!!
      1: per:='W';
      2: per:='S';
      else per:='T';
   end;

   sel_tipo:=rgTipo.ItemIndex;
   case sel_tipo of
      1: begin
         tipo_sal:='DepComCondMan';
         tipo:='2';
      end;
      2: begin
         tipo_sal:='DepComCondManHor';
         tipo:='3';
      end;
      else begin
         tipo_sal:='DepCom';
         tipo:='1';
      end;
   end;

   dia_malla:=ComboBox1.Text;
   sel_dia:= 'T';
   if dia_malla = 'Lunes' then sel_dia:='0';
   if dia_malla = 'Martes' then sel_dia:='1';
   if dia_malla = 'Miercoles' then sel_dia:='2';
   if dia_malla = 'Jueves' then sel_dia:='3';
   if dia_malla = 'Viernes' then sel_dia:='4';
   if dia_malla = 'Sabado' then sel_dia:='5';
   if dia_malla = 'Domingo' then sel_dia:='6';
   if dia_malla = 'Todos' then sel_dia:='T';

   if cbtodos.Checked then
      nivel_malla:='T'
   else
      nivel_malla:=Edit1.Text;

   //entrada:='Malla_'+sistema+'.txt';
   salida:=salida+'-'+per+'-'+tipo_sal+'-'+dia_malla+'-'+nivel_malla;

   //instruccion:=g_tmpdir +'\genmalla '+g_tmpdir + '\' + entrada+' '+g_tmpdir + '\' +salida+' '+per+' '+tipo+' '+g_tmpdir +'\gendiagramamalla';

   instruccion:=g_tmpdir +'\genmalla '+
      //g_tmpdir + '\' + 'gendiagramamalla.exe' +' '+
      g_tmpdir + '\' + entrada+' '+
      g_tmpdir + '\' +salida+' '+
      per+' '+tipo+' '+ sel_dia +' '+ nivel_malla +' '+
      g_tmpdir + ' ' + inttostr(rgtipolinea.ItemIndex+1)+' '+
      g_tmpdir +
      '>'+g_tmpdir+'\'+salida+'.txt';     /// temporal ALK

   salida:= salida+'.pdf';

   if dm.ejecuta_espera(instruccion,SW_HIDE) then begin
      // Para dejar el diagrama en la ruta mis documentos/Scheduler
      sRutaMisDocumentos := GlbObtenerRutaMisDocumentos;
      sDirClase := sRutaMisDocumentos + '\Scheduler';
      if directoryexists( sDirClase ) = false then begin
         if forcedirectories( sDirClase ) = false then begin
            Application.MessageBox( pchar( dm.xlng( 'ERROR... No puede crear directorio ' + sDirClase ) ),
                     pchar( dm.xlng( 'Diagrama Scheduler' ) ), MB_OK );
            exit;
         end;
      end;

      if FileExists(g_tmpdir + '\gendiagramamallaerror.txt') then begin
         error:=TstringList.Create;
         error.LoadFromFile(g_tmpdir + '\gendiagramamallaerror.txt');

         Application.MessageBox( PChar( 'AVISO:' + chr( 13 ) +
                                 error.Text ),
                                 PChar( 'Diagrama Scheduler' ), MB_ICONEXCLAMATION );
         DeleteFile(g_tmpdir + '\gendiagramamallaerror.txt');
         exit;
      end;

      if FileExists(g_tmpdir + '\' + salida) then begin
         if fileexists( sDirClase + '\' + salida ) then
            DeleteFile( sDirClase + '\' + salida );

         MoveFile(PChar(g_tmpdir + '\' + salida) , PChar(sDirClase+'\'+salida));
      end;


      if fileexists( sDirClase + '\' + salida ) = false then begin
         Application.MessageBox( PChar( 'Diagrama Scheduler vacio' ),
            PChar( 'Diagrama Scheduler' ), MB_ICONEXCLAMATION );
         exit;
      end;
      ShellExecute( 0, 'open', pchar( salida ), nil, PChar( sDirClase ), SW_SHOW );
   end
   else
      Application.MessageBox( PChar( 'No se puede generar diagrama Scheduler' ),
            PChar( 'Diagrama Scheduler' ), MB_ICONEXCLAMATION );

   salida:='';
   Self.Close;
end;

procedure TalkFormScheduler.es_CTM();
var
   instruccion, sRutaMisDocumentos, sDirClase: String;
begin
   chdir(g_tmpdir);
   if alkFormScheduler <> nil then
      alkFormScheduler.Enabled:=false;  //para que no muestre la ventana, no necesitamos datos adicionales
   dm.get_utileria( 'SCHEDULER_CTM', g_tmpdir + '\gendiagramacomponentemalla.exe' );
   //dm.get_utileria( 'MALLA_SCH', g_tmpdir + '\Malla_'+sistema+'.txt' );
   dm.get_utileria( 'SCHEDULER_BAT_CTM', g_tmpdir + '\genmallaesp.bat' );

   //entrada:='Malla_'+sistema+'.txt';

   instruccion:=g_tmpdir +'\genmallaesp '+
      g_tmpdir + '\' + entrada+' '+
      g_tmpdir + '\' +salida+
      ' '+componente+' '+
      //g_tmpdir +'\gendiagramacomponentemalla '+
      g_tmpdir + ' ' +
      inttostr(rgtipolinea.ItemIndex+1)+' '+
      '>'+g_tmpdir+'\'+salida+'.txt';     /// temporal ALK
   //ShowMessage(instruccion);

   salida:= salida+'.pdf';

   if dm.ejecuta_espera(instruccion,SW_HIDE) then begin
      // Para dejar el diagrama en la ruta mis documentos/Scheduler
      sRutaMisDocumentos := GlbObtenerRutaMisDocumentos;
      sDirClase := sRutaMisDocumentos + '\Scheduler';
      if directoryexists( sDirClase ) = false then begin
         if forcedirectories( sDirClase ) = false then begin
            Application.MessageBox( pchar( dm.xlng( 'ERROR... No puede crear directorio ' + sDirClase ) ),
                     pchar( dm.xlng( 'Diagrama Scheduler' ) ), MB_OK );
            exit;
         end;
      end;

      if FileExists(g_tmpdir + '\' + salida) then begin
         if fileexists( sDirClase + '\' + salida ) then
            DeleteFile( sDirClase + '\' + salida );

         MoveFile(PChar(g_tmpdir + '\' + salida) , PChar(sDirClase+'\'+salida));
      end;

      if fileexists( sDirClase + '\' + salida ) = false then begin
         Application.MessageBox( PChar( 'Diagrama Scheduler vacio' ),
            PChar( 'Diagrama Scheduler' ), MB_ICONEXCLAMATION );
         exit;
      end;
      ShellExecute( 0, 'open', pchar( salida ), nil, PChar( sDirClase ), SW_SHOW );
   end
   else
      Application.MessageBox( PChar( 'No se puede generar diagrama Scheduler' ),
            PChar( 'Diagrama Scheduler' ), MB_ICONEXCLAMATION );

   salida:='';
end;

procedure TalkFormScheduler.get_nombre(titulo,cla,comp,sis:String);
begin
   salida:='DgrScheduler_' + titulo;
   entrada:= 'fte_' + titulo;
   clase:=cla;
   componente:=comp;
   sistema:=sis;
end;

procedure TalkFormScheduler.Button1Click(Sender: TObject);
begin
   if (clase='CTR') then begin
      dm.get_utileria( 'SCHEDULER_CTR', g_tmpdir + '\gendiagramamalla.exe' );
      //dm.get_utileria( 'MALLA_SCH', g_tmpdir + '\Malla_'+sistema+'.txt' );
      dm.get_utileria( 'SCHEDULER_BAT_CTR', g_tmpdir + '\genmalla.bat' );
      es_CTR;
   end;
end;

procedure TalkFormScheduler.rgPerClick(Sender: TObject);
begin
   Button1.Visible:=true;
   //Button1.Enabled:=false;
   Label5.Visible:=true;
   ComboBox1.Visible:=true;
end;

procedure TalkFormScheduler.rgTipoClick(Sender: TObject);
begin
   Label6.Visible:=true;
   Edit1.Visible:=true;
   cbtodos.Visible:=true;
   //Button1.Enabled:=true;
end;

procedure TalkFormScheduler.FormCreate(Sender: TObject);
begin
   per:='';
   tipo:='';
   salida:='salida';
end;

procedure TalkFormScheduler.ComboBox1Change(Sender: TObject);
begin
   Label2.Visible:=true;
   rgTipo.Visible:=true;
end;

procedure TalkFormScheduler.Edit1Change(Sender: TObject);
begin
   Button1.Enabled:=true;
end;

procedure TalkFormScheduler.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
   if not (Key in['0'..'9',#8]) then begin
      Key:=#0;
      ShowMessage('Ingrese solo números');
   end;
end;

procedure TalkFormScheduler.cbtodosClick(Sender: TObject);
begin
   if Edit1.Visible then
      Edit1.Visible:=false
   else
      Edit1.Visible:=true;

   Edit1.Enabled:=true;
   Button1.Enabled:=true
end;

end.
