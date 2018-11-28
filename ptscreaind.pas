unit ptsCreaInd;
interface
uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, StdCtrls, ADODB, ExtCtrls, ComCtrls, dxBar, shellapi, Buttons,
   HTML_HELP, htmlhlp;
   procedure CargaUtilerias;
   procedure LeeCatBib;
var
   tsindex01: String;
   tsindex02: String;
   tsindex04: String;
   indexa: String;
   logsalida:string;

implementation
uses ptsdm, ptsgral;

procedure CargaUtilerias;
begin
   logsalida:=g_tmpdir+'\log_indexa.txt';
   tsindex01:=g_tmpdir+'\tsindex01.exe';
   tsindex02:=g_tmpdir+'\tsindex02.exe';
   tsindex04:=g_tmpdir+'\tsindex04.exe';
   dm.get_utileria('TSINDEX01',tsindex01);
   dm.get_utileria('TSINDEX02',tsindex02);
   dm.get_utileria('TSINDEX04',tsindex04);
   g_borrar.add(tsindex01);
   g_borrar.add(tsindex02);
   g_borrar.add(tsindex04);
   indexa := g_tmpdir+'\indexa.bat';
   dm.get_utileria('INDEXA',indexa);
   g_borrar.Add(indexa);
end;

procedure LeeCatBib;
var asalida:string;
begin
   if dm.sqlselect(dm.q2,'select a.cclase,cbib,path,modocaracteres,caracterespermitidos,modoactualizacion '+
      ' from tsbibcla a,tsclase b '+
      ' where a.cclase=b.cclase '+
      ' and   busquedaselect='+g_q+'ACTIVO'+g_q+
      ' and   estadoactual='+g_q+'ACTIVO'+g_q+
      ' and   modocaracteres is not null '+
      ' and   caracterespermitidos is not null '+
      ' and   modoactualizacion is not null '+
      ' order by a.cclase,cbib') then begin
      if Application.MessageBox( pchar(inttostr(dm.q2.RecordCount)+
         ' Librerias a procesar. La creación de indices puede llevar varios minutos, Desea Continuar? '),
         'Creación de indices', MB_YESNO ) = IDNO then exit;
      screen.Cursor := crsqlwait;
      gral.PubMuestraProgresBar( True );
      CargaUtilerias;
      asalida:='>';
      while not dm.q2.Eof do begin
         dm.ejecuta_espera( indexa+' '+dm.q2.FieldByName('path').AsString+' '+
            dm.q2.FieldByName('modocaracteres').AsString+' '+
            '"'+stringreplace(dm.q2.FieldByName('caracterespermitidos').AsString,'"','',[rfreplaceall])+'" '+
            dm.q2.FieldByName('modoactualizacion').AsString+' '+asalida+logsalida+' 2>&1', SW_HIDE );
         asalida:='>>';
         dm.q2.Next;
      end;
      //dm.ejecuta_espera(logsalida,SW_HIDE);  // se deja de mostrar el txt a peticion de Martha -- 271015 --  ALK
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;
end.
