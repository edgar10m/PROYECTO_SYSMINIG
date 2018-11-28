unit uRutinasExcel;

interface

uses
   ADODB, Dialogs, StrUtils, Classes, Forms;

const
   ADOCONN_EXCEL = 'Provider=Microsoft.Jet.OLEDB.4.0;'+
         'User ID=Admin;'+
         'Mode=Share Deny None;'+
         'Persist Security Info=False;'+
         'Jet OLEDB:System database="";'+
         'Jet OLEDB:Registry Path="";'+
         'Jet OLEDB:Database Password="";'+
         'Jet OLEDB:Engine Type=96;'+
         'Jet OLEDB:Database Locking Mode=0;'+
         'Jet OLEDB:Global Partial Bulk Ops=2;'+
         'Jet OLEDB:Global Bulk Transactions=1;'+
         'Jet OLEDB:New Database Password="";'+
         'Jet OLEDB:Create System Database=False;'+
         'Jet OLEDB:Encrypt Database=False;'+
         'Jet OLEDB:Don'+''''+'t Copy Locale on Compact=False;'+
         'Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB:SFP=False;'+
         'Data Source=';

function bGlbPoblarGrid( adoConn: TADOConnection; ParDataSource: String;
   ParTableExcel: String; tblExcel: TADOTable ): Boolean;

implementation

function bGlbPoblarGrid( adoConn: TADOConnection; ParDataSource: String;   //conexion a directorio, directorio
   ParTableExcel: String; tblExcel: TADOTable ): Boolean;                // nombre del archivo, conexion al grid
var
   num_reg : TStringList;
   max_reg : integer;
begin
   Result := False;

   max_reg:= 65000;
   num_reg:=TStringList.Create;

   try
      adoConn.Connected := false;
      adoConn.ConnectionString := ADOCONN_EXCEL + ParDataSource + ';';
      adoConn.Connected := true;

      num_reg.LoadFromFile(ParDataSource + ParTableExcel);

      if num_reg.Count> max_reg then begin
         Application.MessageBox( pchar( 'AVISO: '+ chr( 13 ) + chr( 13 ) +
            'Rebasa el limite de registros, se sugiere:' + chr( 13 ) + chr( 13 ) +
            '  1. Si realiza una consulta, modifique su query'),
            pchar( 'Sys-Mining' ), 1 );

         while num_reg.Count>max_reg do begin
            num_reg.Delete(max_reg);    //borra y recorre
         end;
         num_reg.SaveToFile(ParDataSource + ParTableExcel);

      end;
      tblExcel.Active := false;
      tblExcel.TableName := Copy( ParTableExcel, 1, Pos( '.', ParTableExcel ) - 1 )+'#'+
               Copy( ParTableExcel, Pos( '.', ParTableExcel ) + 1, Length(ParTableExcel) );
      //tblExcel.MaxRecords := 71000;
      tblExcel.Active := true;
      Result := True;
   except
      Result := False;
   end;
end;

end.
