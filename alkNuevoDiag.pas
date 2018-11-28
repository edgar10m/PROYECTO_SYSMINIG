unit alkNuevoDiag;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, CheckLst,ptsdm,ADODB,uConstantes;

type
  TalkNuevoDiagrama = class(TForm)
    Label1: TLabel;
    btnGenerar: TButton;
    CheckListBox1: TCheckListBox;
    rbselecciona: TRadioButton;
    rbdeselecciona: TRadioButton;
    rgPadres: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure btnGenerarClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure rbdeseleccionaClick(Sender: TObject);
    procedure rbseleccionaClick(Sender: TObject);
    procedure CheckListBox1Click(Sender: TObject);
    procedure rgPadresClick(Sender: TObject);

  private
    { Private declarations }
    x,y:integer;
    sistema:String;
    procesadas,clases,no_activas: TStringList;
    procedure leeclases( clase, sistema:  string);     //ALK
  public
    { Public declarations }
    procedure check(clases,activas:TStringList);
    procedure radio(clases,actual:TStringList;sis:string);
  end;

var
  alkNuevoDiagrama: TalkNuevoDiagrama;

implementation
{$R *.dfm}
uses ptsgral;

procedure TalkNuevoDiagrama.FormCreate(Sender: TObject);
begin
   x:=100;    //left
   y:=130;    //top
   alkActivo:=0;
end;

procedure TalkNuevoDiagrama.radio(clases,actual:TStringList;sis:string);
var
   i : integer;
begin
   actual.SaveToFile(g_tmpdir+'\clases_act_tmp.txt');
   sistema:=sis;
   for i:=0 to clases.Count-1 do
      //if (clases[i]='NEG') or (clases[i]='CTR') then
         rgPadres.Items.Add(clases[i]);

   rgPadres.Visible:=true;
end;

procedure TalkNuevoDiagrama.check(clases,activas:TStringList);
var
   i,j:integer;
begin
   rbselecciona.Enabled:=true;
   rbdeselecciona.Enabled:=true;

   for i:=0 to clases.Count-1 do
      CheckListBox1.Items.Add(clases[i]);

   for i:=0 to activas.Count-1 do
      for j:=0 to CheckListBox1.Items.Count -1 do
         if CheckListBox1.Items.Strings[j] = activas[i] then
            CheckListBox1.Checked[j]:=true;
end;


procedure TalkNuevoDiagrama.btnGenerarClick(Sender: TObject);
var
   limite,i:integer;
   nuevas_clases:TStringList;
   archivo_tmp:string;
begin
   gral.PubMuestraProgresBar( True );
   Screen.Cursor := crSQLWait;

   nuevas_clases:=TStringList.Create;
   limite:=CheckListBox1.Items.Count;

   for i:=0 to limite-1 do begin
      if CheckListBox1.Checked[i] then
         nuevas_clases.Add(CheckListBox1.Items.Strings[i]);
   end;

   archivo_tmp:=g_tmpdir+'\clases_tmp.txt';
   nuevas_clases.SaveToFile(archivo_tmp);

   Screen.Cursor := crDefault;
   gral.PubMuestraProgresBar( False );

   alkActivo:=1;   //para indicar que se acepto un cambio en el diagrama

   Self.Close;
end;

procedure TalkNuevoDiagrama.FormDestroy(Sender: TObject);
var
   consulta_param:string;
   tmp : TStringList;
begin
   if not fileexists(g_tmpdir+'\clases_tmp.txt') then begin
      //btnGenerarClick(self);
      consulta_param:='select dato from parametro where clave ='+ g_q +
                'DIAGSIS_'+sUsuario+'_'+ sistema + g_q ;

      if ((sUsuario = '') or (sistema = '')) then
         exit;

      if dm.sqlselect(dm.q1,consulta_param)then begin
         tmp := TStringList.Create;
         tmp.CommaText:=dm.q1.FieldByName( 'dato' ).AsString;
         tmp.SaveToFile(g_tmpdir+'\clases_tmp.txt');
      end
      else
         Application.MessageBox( 'No selecciono ninguna clase y no existe configuracion' + Chr( 13 ) +
         ' de clases previa. El diagrama saldra vacío', 'AVISO', MB_OK );
   end;
end;

procedure TalkNuevoDiagrama.rbdeseleccionaClick(Sender: TObject);
var
   i:integer;
begin
   rbdeselecciona.Checked:=true;
   rbselecciona.Checked:=false;

   for i:=0 to CheckListBox1.Items.Count-1 do
      if CheckListBox1.Checked[i] then
         CheckListBox1.Checked[i]:=false;
end;

procedure TalkNuevoDiagrama.rbseleccionaClick(Sender: TObject);
var
   i:integer;
begin
   rbselecciona.Checked:=true;
   rbdeselecciona.Checked:=false;

   for i:=0 to CheckListBox1.Items.Count-1 do
      if not CheckListBox1.Checked[i] then
         CheckListBox1.Checked[i]:=true;
end;

procedure TalkNuevoDiagrama.CheckListBox1Click(Sender: TObject);
begin
   rbselecciona.Checked:=false;
   rbdeselecciona.Checked:=false;
   btnGenerar.Enabled:=true;
end;

procedure TalkNuevoDiagrama.rgPadresClick(Sender: TObject);
var
   sel,cons,consulta_param:string;
   clases_hijas: TStringList;
   i:integer;
begin
   gral.PubMuestraProgresBar( True );
   Screen.Cursor := crSQLWait;

   rbselecciona.Checked:=false;
   rbdeselecciona.Checked:=false;
   CheckListBox1.Clear;

   sel:=rgPadres.Items.Strings[rgPadres.ItemIndex];

   clases:=TstringList.Create;  //al llamarla desde un nuevo formulario, hay que crearla
   procesadas:=TStringList.Create; //auxiliar para leeclases

   clases.Add(sel);

   if sel <>'' then begin
      leeclases(sel,sistema);

      no_activas:=TStringList.Create;
      consulta_param:='select dato from parametro where clave ='+ g_q +
                         'DIAGSIS_'+sUsuario+'_'+sistema + g_q ;
      if dm.sqlselect(dm.q1,consulta_param) then
         no_activas.CommaText:=dm.q1.fieldbyname( 'dato' ).AsString;

      //no_activas.LoadFromFile(g_tmpdir+'\clases_act_tmp.txt');
      check(clases,no_activas);
   end;

   clases.Free;
   procesadas.Free;

   Screen.Cursor := crDefault;
   gral.PubMuestraProgresBar( False );
end;

procedure TalkNuevoDiagrama.leeclases( clase, sistema:  string);    //ALK
var
   nombre,cons:string;
begin
   nombre:='JER_' + sistema + '_' + clase;
   cons:='select dato from parametro where clave= '+ g_q + nombre + g_q;
   if dm.sqlselect(dm.q1,cons) then
      clases.CommaText:= dm.q1.FieldByName( 'dato' ).AsString
   else
      Application.MessageBox( 'No se ha cargado la jerarquia de clases.'+ chr( 13 ) + chr( 13 ) +
                              'Para cargar la configuracion vaya al menu "Administracion"'+ chr( 13 ) +
                              'en la opcion "Jerarquia de clases".', 'Jerarquia de clases ', MB_OK );
end;


end.
