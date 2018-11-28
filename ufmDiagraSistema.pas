unit ptsCreaInd;
interface
uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, StdCtrls, ADODB, ExtCtrls, ComCtrls, dxBar, shellapi, Buttons,
   uConstantes, HTML_HELP, htmlhlp;
   procedure CreaArchivoDirectivas;

implementation
uses ptsdm, ptsgral;

procedure CreaArchivoDirectivas;
Var
   lBib, sClase1, sProg1, lClase1, lClase2, lClase3, lClase4, lClase5, sSQL, lg_ruta : String;
   slIndBib, slSistemaClase, slBusCla, slCarOfiBib : Tstringlist;
   i :  Integer;
   lDatos: String;
begin
   slSistemaClase:=Tstringlist.Create;
   try
      if dm.sqlselect(dm.q1,'select * from tsprog where sistema =' + g_q + 'S502' + g_q + ' order by cclase') then begin
         slSistemaClase.add( 'digraph DS{ ');
         slSistemaClase.add( '   node [ shape=box  fontsize = 4]');
         slSistemaClase.add( '   SISTEMA [ shape = ellipse label ='+g_q+ 'S502' + g_q +' ]');
         while not dm.q1.Eof do begin
            sClase1 := dm.q1.fieldbyname('cclase').AsString;
            bGlbQuitaCaracteres(sClase1);
            sProg1 := dm.q1.fieldbyname('cprog').AsString;
            bGlbQuitaCaracteres(sProg1);
            slSistemaClase.add(sClase1+sProg1 [ label = sClase1+'\n'+sProg1 ] );
            if dm.sqlselect(dm.q2,'select hcclase, hcprog  from tsrela where pcprog = '+ g_q+ sprog1+g_q+' and  pcclase='+g_q+sClase1+g_q+' and pcclase <> '+g_q+ 'CLA'+g_q+
                                  'and hcclase in(select cclase  from tsclase where Estadoactual='+g_q+'ACTIVO'+g_q+' and objeto='+g_q+'FISICO'+g_q+') group by hcclase,hcprog order by hcclase, hcprog ')
                                  then begin
                while not dm.q2.Eof do begin
                  sClase2 := dm.q2.fieldbyname('hclase').AsString;
                  bGlbQuitaCaracteres(sClase2);
                  sProg2 := dm.q2.fieldbyname('hcprog').AsString;
                  bGlbQuitaCaracteres(sProg2);
                  if  sClase2 = sClase1 and
                      sProg2  = sProg1 then  begin
                        slSistemaClase.add(sClase2+sProg2 [ label = sClase2+'\n'+sProg2 ] );
                        slSistemaClase.add(sClase1+sProg1 +' -> ' + sClase2+sProg2  );
                  end;
                  dm.q2.Next;
                end;
            end;

          dm.q1.Next;
         end;
         slslSistemaClase.SaveToFile('DiagSist.dot');
     end;
   finally;
      gral.PubMuestraProgresBar( False );
      slSistemaClase.free;
   end;
end;

end.
