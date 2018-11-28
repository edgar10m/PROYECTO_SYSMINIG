unit ptsscrsec;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
   Tobjeto = record      //estructura para guardar objetos
      indice : integer;
      tipo : string;
      nombre : string;
      x : integer;
      y : integer;
   end;

type
  Tftsscrsec = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    recibe_archivo : Tstringlist;
    //evalua_cad
    separada : TStringList;
    //gral
    factorX, factorY : Integer;
    objUso : Tobjeto;  //guarda el objeto en uso
    objetos : array of Tobjeto;  //guarda los objetos que van apareciendo
    cuentaObj : Integer;  //contador para el array de objetos

  public
    { Public declarations }
    titulo : String;
    procedure pinta(archivo:string);
    procedure evalua_cad(cadena: string);
    function etiqueta() : integer;
    function text() : integer;
    function esNumero(palabra: string) : integer; //etiqueta, text
    function Limpia_cad(palabra: string) : string;  //para limpiar coordenada
  end;

var
  ftsscrsec: Tftsscrsec;
  procedure CREA_FORM(archivo:string; nombre:string);

implementation

uses ptsdm, ptsgral,parbol;
{$R *.dfm}
procedure Tftsscrsec.pinta(archivo:string);    //para dibujar la pantalla
var
   cuenta : Integer;
   //objetos
   txt: Tedit;
   lab: Tlabel;
begin
   cuentaObj := 1;   //inicializar el contador de objetos
   setlength(objetos,1);
   objetos[0].indice := 0;   //para hacer la comparacion
   objetos[0].tipo := 'nada';
   objetos[0].nombre := 'nada';
   objetos[0].x:=0;
   objetos[0].y:=0;

   factorX := 15;
   factorY := 40;

   if fileexists( archivo ) = false then
      exit;
   recibe_archivo := Tstringlist.Create;
   recibe_archivo.LoadFromFile(archivo);

   for cuenta := 0 to recibe_archivo.Count - 1 do begin
       evalua_cad(recibe_archivo[cuenta]);
       if(separada.Count = 5) then
          begin
             if (text()=1) then
             begin
                objUso.indice := cuentaObj-1;
                objUso.tipo:='text';
                objUso.nombre:=objetos[cuentaObj-1].nombre;

                txt:=TEdit.Create(Self);
                txt.Left:=objetos[cuentaObj-1].x;
                txt.Top:=objetos[cuentaObj-1].y;
                txt.Text := objetos[cuentaObj-1].nombre;
                txt.Parent:= Self;
             end

             else if (etiqueta()=1) then
             begin
                objUso.indice := cuentaObj-1;
                objUso.tipo:='etiqueta';
                objUso.nombre:='FILLER';

                lab:=TLabel.Create(Self);
                lab.Left:=objetos[cuentaObj-1].x;
                lab.Top:=objetos[cuentaObj-1].y;
                lab.Parent:=Self;
             end;
          end

       else if (separada.Count < 5) and (separada.Count > 1) then
       begin
          if(objetos[cuentaObj-1].tipo = 'etiqueta') then begin
             if(separada[0]='VALUE') then
             begin
                lab.Caption := trim(separada[1]);
                objetos[cuentaObj-1].tipo := objetos[cuentaObj-1].tipo + '_OK'; 
             end;
          end;
       end;
   end;
end;

function Tftsscrsec.text() : integer;
var
   nombre : string;
begin
   if((esNumero(separada[0])=1) and (separada[1] <> 'FILLER') and (separada[2]='AT')) then
   begin
      setlength(objetos,(length(objetos)+1));
      nombre:=separada[1];
      objetos[cuentaObj].indice:=cuentaObj;
      objetos[cuentaObj].tipo:='text';
      objetos[cuentaObj].nombre:=nombre;
      objetos[cuentaObj].x:=StrToInt(Limpia_cad(separada[4]))*factorX;
      objetos[cuentaObj].y:=StrToInt(Limpia_cad(separada[3]))*factorY;
      cuentaObj:=cuentaObj+1;
      Result:= 1;
   end
   else
   begin
      //ShowMessage('NO ES TEXT!!');
      Result:= 0;
   end;
end;

function Tftsscrsec.etiqueta() : integer;
begin
   if((esNumero(separada[0])=1) and (separada[1] = 'FILLER') and (separada[2]='AT')) then
   begin
      setlength(objetos,(length(objetos)+1));
      objetos[cuentaObj].indice:=cuentaObj;
      objetos[cuentaObj].tipo:='etiqueta';
      objetos[cuentaObj].nombre:='FILLER';
      objetos[cuentaObj].x:=StrToInt(Limpia_cad(separada[4]))*factorX;
      objetos[cuentaObj].y:=StrToInt(Limpia_cad(separada[3]))*factorY;
      cuentaObj:=cuentaObj+1;
      Result:= 1;
   end
   else
   begin
      //ShowMessage('NO ES ETIQUETA!!');
      Result:= 0;
   end;
end;



function Tftsscrsec.Limpia_cad(palabra: string) : string;
var
   j : integer;
   dig : char;
   res : string;
begin
   for j:=0 to Length(palabra) do begin
      dig:=palabra[j];
      if ((dig >#31) and (dig <#48)) or ((dig >#57) and (dig <#65)) or (dig = #0) then
      begin
         res:=res;
      end
      else begin
         res:=res+palabra[j];
      end;
   end;
   Result := res;
end;

function Tftsscrsec.esNumero(palabra: string) : integer;   // auxiliar para determinar si es numero
var
   i : integer;
   c : integer;
   dig : char;
begin
   try
      c:=0;
      for i := 0 to  Length(palabra) do begin
         dig:=palabra[i];
         if (dig >#47) and (dig <#58) then
         begin
            c := c+1;
         end
         else if dig =#0 then
         begin
            c:=c;
         end
         else
         begin
            c := c-1;
         end;
      end;

      if c = Length(palabra) then
      begin
         Result:=1;
      end
      else
      begin
         Result:=0;
      end;
   Except
      ShowMessage('Error! al comprobar si es numero... :(');
      Result:=0;
   end
end;

procedure Tftsscrsec.evalua_cad(cadena: string);
begin
   separada:=TStringList.Create;
   separada.Clear;
   cadena := trim(cadena);  //quitar los espacios adelante y atras
   separada.Delimiter:=' ';   //indicar marca para separar, espacio
   separada.DelimitedText:=cadena;  //ingresar cadena a separar
end;

procedure CREA_FORM(archivo:string; nombre:string);
begin
   screen.Cursor := crsqlwait;
    try
      Application.CreateForm( Tftsscrsec, ftsscrsec );
      ftsscrsec.Caption:=nombre;
      ftsscrsec.Height:=400;
      ftsscrsec.Width:=600;
      ftsscrsec.Show;
      ftsscrsec.pinta(archivo);
   finally
      screen.Cursor := crdefault;
   end;
end;


procedure Tftsscrsec.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   dm.PubEliminarVentanaActiva(Caption);  //quitar nombre de lista de abiertos
   {gral.borra_elemento(Caption,14);     //borrar elemento del arreglo de productos
   farbol.borra_elemento_a(Caption,14);     //borrar elemento del arreglo de productos
   }
  if FormStyle = fsMDIChild then
      Action := caFree;
end;

procedure Tftsscrsec.FormDestroy(Sender: TObject);
begin
   dm.PubEliminarVentanaActiva( Caption );

   if gral.iPubVentanasActivas in [ 0, 1 ] then
      gral.PubExpandeMenuVentanas( False );
end;

end.

