unit ptsuso_gral;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  Tgeneral = class(Tframe)
    jquery: TMemo;
    jquery_fixer: TMemo;

  private
    { Private declarations }

  public
    { Public declarations }
    procedure CargaRutinasjs();
    procedure CargaLogo();
    procedure CargaIconosBasicos();
    procedure CargaIconosClases();
    procedure BorraIconosTmp();
  end;

implementation
uses ptsdm;
{$R *.dfm}

procedure Tgeneral.CargaRutinasjs();

begin
   jquery.Lines.SaveToFile(g_tmpdir+'\jquery.js');
   jquery_fixer.Lines.SaveToFile(g_tmpdir+'\jquery.fixer.js');
end;

procedure Tgeneral.CargaLogo();

begin
   dm.get_utileria('LOGO_EMPRESA',g_tmpdir+'\logo.png');
end;

procedure Tgeneral.CargaIconosBasicos();

begin
   dm.get_utileria('ICONO_TICK',g_tmpdir+'\ICONO_TICK.ico');
   dm.get_utileria('ICONO_TICK',g_tmpdir+'\ICONO_cross.ico');
end;

procedure Tgeneral.CargaIconosClases();

begin

   if dm.sqlselect(dm.q4,'select * from parametro where clave like '+g_q+'ICONO_%'+g_q)then begin
{      icono:=Ticon.Create;
      icono.Width:=16;
      icono.Height:=16;
 }
      while not dm.q4.Eof do begin
//       dm.lclases.Add(copy(dm.q4.fieldbyname('clave').AsString,7,100));
         dm.blob2file(dm.q4.fieldbyname('dato').AsString,g_tmpdir+'\'+dm.q4.fieldbyname('clave').AsString+'.ico');
         dm.q4.Next;
      end;
   end;
end;

procedure Tgeneral.BorraIconosTmp();
   var
      arch : string;
begin
   //Borra todos los ICONOS de ..\tmp...
   arch:=g_tmpdir+'\ICONO_TICK.ico';
   g_borrar.Add(arch);
   arch:=g_tmpdir+'\ICONO_cross.ico';
   g_borrar.Add(arch);
   dm.q4.First;
   while not dm.q4.Eof do begin
      arch:=g_tmpdir+'\'+dm.q4.fieldbyname('clave').AsString+'.ico';
      g_borrar.Add(arch);
      dm.q4.Next;
   end;
end;


end.
