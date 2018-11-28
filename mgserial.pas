unit mgserial;

interface
uses
  windows,sysutils,classes, forms, dialogs, strutils;
procedure verifica_llave;

implementation
uses ptsdm;
Function GetDriveSerialNo(Drive : String) : String; // Drive as 'x:' ...
var VolSerNum: DWORD;
    Dummy1, Dummy2: DWORD; 
begin 
   if GetVolumeInformation(pchar(drive+'\'), NIL, 0, @VolSerNum, Dummy1, Dummy2, NIL, 0) then
      Result := Format('%.4x:%.4x', [HiWord(VolSerNum), LoWord(VolSerNum)]);
End;

procedure verifica_llave;
var seria:string;
    cod,cod2,archi:string;
    fil:Tstringlist;
    llave:string;
    i:integer;
begin
   seria:=GetDriveSerialNo('c:');
   fil:=Tstringlist.Create;
   for i:=1 to length(seria) do begin
      cod:=cod+rightstr('000'+(inttostr(ord(seria[i])+29)),3);
      cod2:=cod2+inttostr(ord(seria[i])-40)+'.';
   end;
   delete(cod2,length(cod2),1);
   archi:=g_windir+'\sysviewsoftscm.lnc';
   if fileexists(archi) then begin
      fil.LoadFromFile(archi);
      llave:=copy(fil[0],5,500);
      if cod=llave then begin
         fil.free;
         exit;
      end;
   end;
   llave:=copy(inputbox('License','Key: ',cod2),5,500);
   if llave<>cod then begin
      Application.MessageBox(pchar(dm.xlng('Licencia incorrecta')),
                             pchar(dm.xlng('Verificar llave de la licencia')), MB_OK );
      application.Terminate;
      abort;
   end;
   fil.Clear;
   fil.Add(formatdatetime('nnss',now)+llave);
   fil.SaveToFile(archi);
   fil.Free;
end;

end.
