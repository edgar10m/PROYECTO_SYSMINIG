program genword;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  dialogs,
  forms,
  activex,
  alkDocAutoDinamica in '..\alkDocAutoDinamica.pas' {alkFormDocAutoDinam},
  ptsdm in 'ptsdm.pas' {dm: TDataModule},
  uconstantes in 'uconstantes.pas';

const
   CONNECTSTRING =
      //dm.ADOConnection1.ConnectionString:='Provider=MSDASQL.1;'+
   'Provider=OraOLEDB.Oracle.1;' +
      'Password=SYSVIEWHELPDESK;Persist Security Info=True;' +
      'User ID=sysview11;Data Source=sysviewsoftscm';

var    DocDinamica : TalkFormDocAutoDinam;
       fecha:string;
       j : integer;

procedure detecta_base( sParConexion, sParUsuarioDB: string );
begin
   if dm.ADOConnection1.Connected then
      dm.ADOConnection1.Connected := false;

   dm.ADOConnection1.ConnectionString := CONNECTSTRING;

   dm.ADOConnection1.ConnectionString :=
      stringreplace( dm.ADOConnection1.ConnectionString, '=sysviewsoftscm', '=' + sParConexion, [ ] );

   dm.ADOConnection1.ConnectionString :=
      stringreplace( dm.ADOConnection1.ConnectionString, '=sysview11;', '=' + sParUsuarioDB + ';', [ ] );

   try
      g_user_procesa := copy( sParUsuarioDB, 1, length( sParUsuarioDB ) - 2 ) +
         inttostr( strtoint( copy( sParUsuarioDB, length( sParUsuarioDB ) - 1, 2 ) ) + 1 );
   except
      g_user_procesa := sParUsuarioDB + '01';
   end;

end;
procedure detecta_usuarios( sParUsuarioDB: string; bParCreaBD: Boolean ); //fercar cias
var
   pass: string;
begin
   try
      dm.ADOConnection1.Connected := false;
      dm.ADOConnection1.Connected := true;
   except
      on E: exception do begin
         showmessage('ERROR DE CONEXION: ' + E.Message + chr( 13 ) + chr( 13 ) +
            'VERIFIQUE:' + chr( 13 ) + chr( 13 ) +
            '1. QUE ESTÉ CONECTADO A LA RED.' + chr( 13 ) +
            '2. QUE LOS PARAMETROS TNSNAME Y USUARIO SEAN CORRECTOS.' );
         application.Terminate;
         Abort;
      end;
   end;
   if dm.sqlselect( dm.q1, 'select * from ' + g_user_procesa + '.shdbase' ) then begin
      pass := dm.desencripta( dm.q1.fieldbyname( 'base1' ).asstring );

      dm.ADOConnection1.Connected := false;
      dm.ADOConnection1.ConnectionString :=
         stringreplace( dm.ADOConnection1.ConnectionString, sParUsuarioDB, g_user_procesa, [ ] );
      if pos( 'assword=', dm.ADOConnection1.ConnectionString ) > 0 then
         dm.ADOConnection1.ConnectionString :=
            stringreplace( dm.ADOConnection1.ConnectionString, 'SYSVIEWHELPDESK', copy( pass, 3, 50 ), [ ] )
      else
         dm.ADOConnection1.ConnectionString :=
            dm.ADOConnection1.ConnectionString + 'password=' + copy( pass, 3, 50 ) + ';';
      g_pass := copy( pass, 3, 50 );
      dm.ADOConnection1.Connected := true;
      if dm.sqlselect( dm.q1, 'select * from shdbase' ) = false then begin
         showmessage( 'Error en el password de base de la aplicación' );
         exit;
      end;
   end
   else begin
      if bParCreaBD then begin
         showmessage( 'ERROR... no tiene acceso a la tabla SHDBASE, desea crear la Base de Datos?');
         //verifica_llave;
      end
      else begin
         showmessage( 'ERROR... no tiene acceso a la tabla SHDBASE');
      end;
      Application.Terminate;
      Abort;
   end;
   //RGM verifica_llave;
end;
begin
   { TODO -oUser -cConsole Main : Insert code here }
   Application.Initialize;
   Application.Title := 'Sys-Mining 7.0.30 ';
   Application.CreateForm(Tdm, dm);
  if paramcount <> 10 then begin
      showmessage('ERROR... parametros insuficientes '+paramstr(1)+' '+paramstr(2)+' '+paramstr(3)+' '+paramstr(4)+' '+paramstr(5)+' '+paramstr(6)+' '+paramstr(7)+' '+
                            paramstr(8)+' '+paramstr(9));
      abort;
      exit;
   end;
   g_ruta:=paramstr(10);
   g_tmpdir:=g_ruta+'tmp';
   //g_tmpdir:='c:\sysmining_fuentes\sysmining\tmp';
   detecta_base(paramstr(1),paramstr(2));
   detecta_usuarios(paramstr(2),false);
   fecha:=FormatDateTime('yyyy/mm/dd',now);

   try
      DocDinamica := TalkFormDocAutoDinam.Create(nil);
      DocDinamica.get_datos(paramstr(3),paramstr(4),paramstr(5),paramstr(6),paramstr(7),
                            paramstr(8),paramstr(9));
      //for j:=0 to 200 do
       DocDinamica.crear;

      DocDinamica.terminar;
   finally
      DocDinamica.Free;
   end;
end.
