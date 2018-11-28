unit ptsrec;

interface

uses classes, comctrls, HTML_HELP, Forms, windows, dialogs, sysutils, ADODB, stdctrls, extctrls, filectrl;

function recibeclick(compos: Tstrings; origen: string;
   cmboficina_text, cmbsistema_text, cmbclase_text,
   cmbbiblioteca_text, txtsufijo_text, txtextra_text: string;
   chktodas_checked, chkruta_checked, chkextra_checked, chkexiste_checked,
   chkversion_checked, chkanaliza_checked, chkextension_checked,
   chkproduccion_checked, chkverifica_checked, chknombre_version_checked,
   yextra_Visible, chkparams_checked, chkcopys_checked: boolean;
   rgnombre_itemindex: integer;
   dir_directory,
   cla_tipo,
   herramienta: string;
   barra: Tprogressbar;
   rxfc: Tstrings;
   reemplaza1, reemplaza2: string): boolean;

   function trae_configuracion(cmbsistema, cmbclase, cmbbiblioteca: Tcombobox;
   chkruta, chkextra, chkexiste, chkanaliza, chkextension, chkproduccion, chkversion,
   chkverifica, chknombre_version, chkparams, chkcopys: tcheckbox;
   txtextra, txtsufijo: tedit; rgnombre: Tradiogroup;
   yextra: Tgroupbox; dir: Tdirectorylistbox;
   chkreemplaza: Tcheckbox;
   txtreemplaza1, txtreemplaza2: Tedit;
   var bib_dir, bib_base, cla_tipo: string): boolean;

   procedure checa_case_sensitive(sistema:string);         // debe ser llamado por ptsrecibe o la carga batch

   procedure regresa_case_sensitive;         // debe ser llamado por ptsrecibe o la carga batch
   procedure reemplaza_basedef_userdef(origen:string);
   procedure inserta_tslog(nom, rutina, clave, descripcion, estado: string);
   procedure mensaje_online_batch(origen, rutina,componente,numero_error,tipo_error,mensaje,caption:string);
   //function analiza_componente( clase: string; biblioteca: string;
  // programa: string; lista: Tstrings ): boolean;
var
   ptsrec_clase,ptsrec_bib:string;

implementation

uses ptsdm, ptscomun;

var
   g_fteobj: boolean = false;
   g_bibfte, g_bibobj: Tstringlist;
   g_conciliado: Tstringlist; // Para concilia_hcbib
   b_otros_sistemas: boolean;
   var_prog, var_general:Tstringlist;
   modulo_prod:Tstringlist;
   b_tiene_var:boolean;
   recibe_case_insensitive:boolean;
   nls_sort,nls_comp:string;
//..................................................................
procedure inserta_tslog(nom, rutina, clave, descripcion, estado: string);
begin
   ptscomun.inserta_tslog(ptsrec_clase, ptsrec_bib, nom, rutina, clave, descripcion, estado, g_procesando);
end;

procedure mensaje_online_batch(origen, rutina,componente,numero_error,tipo_error,mensaje,caption:string);
begin
   if origen = 'ptsrecibe' then begin
      Application.MessageBox(pchar(ptscomun.xlng(mensaje)),
         pchar(ptscomun.xlng(caption)), MB_OK);
   end
   else begin
      inserta_tslog(componente,rutina,numero_error,ptscomun.xlng(mensaje),tipo_error);
   end;
end;
procedure reemplaza_basedef_userdef(origen:string);
var cons:string;
begin
   cons:='select distinct CROL from tsroluser where CUSER='+ g_q + g_usuario + g_q;
   if dm.sqlselect( dm.q2, cons ) then begin
      if ((dm.q2.fieldbyname('CROL').AsString = 'ADMIN')
         or (dm.capacidad('DEFAULT USERDEF'))) then begin    // revisar si es administrador o si tiene la capacidad de userdef
         // Revisando para cada sistema el parametro
         cons:='select csistema from tssistema where estadoactual=' + g_q + 'ACTIVO' + g_q;
         if dm.sqlselect(dm.q3,cons) then begin
            while not dm.q3.Eof do begin
               // ------- Para USERDEF  ----------------
               cons:= 'select dato from parametro where clave='+ g_q +
                      'USERDEF_'+dm.q3.FieldByName('csistema').AsString + g_q;
               if dm.sqlselect(dm.q4,cons) then begin
                  cons:='update tsrela set hcbib=' +
                        ' replace(hcbib,'+ g_q +'$USERDEF$'+ g_q +
                        ','+ g_q + dm.q4.FieldByName('dato').AsString + g_q +
                        ') where hcbib like '+ g_q +'%$USERDEF$%'+ g_q +
                        ' and sistema='+ g_q +dm.q3.FieldByName('csistema').AsString+ g_q;
                  if dm.sqlupdate( cons ) = false then
                     mensaje_online_batch(origen,'reemplaza_basedef_userdef','',
                        'G0001','WARNING','No se pudo actualizar USERDEF.','AVISO');
                  cons:='update tsrela set pcbib=' +
                        ' replace(pcbib,'+ g_q +'$USERDEF$'+ g_q +
                        ','+ g_q + dm.q4.FieldByName('dato').AsString + g_q +
                        ') where pcbib like '+ g_q +'%$USERDEF$%'+ g_q +
                        ' and sistema='+ g_q +dm.q3.FieldByName('csistema').AsString+ g_q;
                  if dm.sqlupdate( cons ) = false then
                     mensaje_online_batch(origen,'reemplaza_basedef_userdef','',
                        'G0001','WARNING','No se pudo actualizar USERDEF.','AVISO');
               end;
               // -------- Para BASEDEF  ----------------
               cons:= 'select dato from parametro where clave='+ g_q +
                      'BASEDEF_'+dm.q3.FieldByName('csistema').AsString + g_q;
               if dm.sqlselect(dm.q4,cons) then begin
                  cons:='update tsrela set hcbib=' +
                        ' replace(hcbib,'+ g_q +'$BASEDEF$'+ g_q +
                        ','+ g_q + dm.q4.FieldByName('dato').AsString + g_q +
                        ') where hcbib like '+ g_q +'%$BASEDEF$%'+ g_q +
                        ' and sistema='+ g_q +dm.q3.FieldByName('csistema').AsString+ g_q;
                  if dm.sqlupdate( cons ) = false then
                     mensaje_online_batch(origen,'reemplaza_basedef_userdef','',
                        'G0001','WARNING','No se pudo actualizar BASEDEF.','AVISO');
                  cons:='update tsrela set pcbib=' +
                        ' replace(pcbib,'+ g_q +'$BASEDEF$'+ g_q +
                        ','+ g_q + dm.q4.FieldByName('dato').AsString + g_q +
                        ') where pcbib like '+ g_q +'%$BASEDEF$%'+ g_q +
                        ' and sistema='+ g_q +dm.q3.FieldByName('csistema').AsString+ g_q;
                  if dm.sqlupdate( cons ) = false then
                     mensaje_online_batch(origen,'reemplaza_basedef_userdef','',
                        'G0001','WARNING','No se pudo actualizar BASEDEF.','AVISO');
               end;
               // -----------------------------------------
               dm.q3.Next;
            end;
         end;
      end;
   end;
   // =====================================================
end;
//========================================== Extraccion codigo de ptsrecibe

function bibfte(bibobj: string; recrea: boolean = false): string;
var
   k: integer;
begin
   if recrea and g_fteobj then begin
      g_bibobj.Free;
      g_bibfte.Free;
      g_fteobj := false;
   end;
   if g_fteobj = false then begin
      g_bibobj := Tstringlist.create;
      g_bibfte := Tstringlist.create;
      if dm.sqlselect(dm.q1, 'select bibobj,cbib from tsbib order by 1,2') then begin
         while not dm.q1.Eof do begin
            g_bibobj.Add(dm.q1.fieldbyname('bibobj').AsString);
            g_bibfte.Add(dm.q1.fieldbyname('cbib').AsString);
            dm.q1.Next;
         end;
      end;
      g_fteobj := true;
   end;
   k := g_bibobj.IndexOf(bibobj);
   if k > -1 then
      bibfte := g_bibfte[k]
   else
      bibfte := bibobj;
end;

procedure alta_resumen(compo: string; bib: string; clase: string);
var
   lis: Tstringlist;
   archivo: string;
   cam, campos, valor: string;
   i: integer;
   qq: tADOquery;
begin
   archivo := 'resumen_' + ptscomun.cprog2bfile(compo);
   if fileexists(archivo) = false then
      exit;
   lis := Tstringlist.Create;
   lis.LoadFromFile(archivo);
   qq := TADOquery.Create(nil);
   qq.Connection := dm.ADOConnection1;
   if dm.sqlselect(qq, 'select * from tsproperty ' + // si ya existe el registro
      ' where cprog=' + g_q + compo + g_q +
      ' and   cbib=' + g_q + bib + g_q +
      ' and   cclase=' + g_q + clase + g_q) then begin
      for i := 0 to lis.Count - 1 do begin
         cam := copy(lis[i], 1, pos('=', lis[i]) - 1);
         if qq.FieldList.IndexOf(cam) = -1 then
            continue;
         campos := campos + lis[i] + ',';
      end;
      delete(campos, length(campos), 1);
      dm.sqlupdate('update tsproperty set ' + campos +
         ' where cprog=' + g_q + compo + g_q +
         ' and   cbib=' + g_q + bib + g_q +
         ' and   cclase=' + g_q + clase + g_q);
   end
   else begin
      campos := 'cprog,cbib,cclase,';
      valor := g_q + compo + g_q + ',' + g_q + bib + g_q + ',' + g_q + clase + g_q + ',';
      for i := 0 to lis.Count - 1 do begin
         campos := campos + copy(lis[i], 1, pos('=', lis[i]) - 1) + ',';
         valor := valor + copy(lis[i], pos('=', lis[i]) + 1, 1000) + ',';
      end;
      delete(campos, length(campos), 1);
      delete(valor, length(valor), 1);
      dm.sqlinsert('insert into tsproperty (' + campos + ')' +
         ' values(' + valor + ')');
   end;
   deletefile(archivo);
   lis.Free;
   qq.Free;
end;

function trae_configuracion(cmbsistema, cmbclase, cmbbiblioteca: Tcombobox;
   chkruta, chkextra, chkexiste, chkanaliza, chkextension, chkproduccion, chkversion,
   chkverifica, chknombre_version, chkparams, chkcopys: tcheckbox;
   txtextra, txtsufijo: tedit; rgnombre: Tradiogroup;
   yextra: Tgroupbox; dir: Tdirectorylistbox;
   chkreemplaza: Tcheckbox;
   txtreemplaza1, txtreemplaza2: Tedit;
   var bib_dir, bib_base, cla_tipo: string): boolean;
var b_rgnombre: boolean;
begin
   if (cmbsistema.Text <> '') and (cmbclase.Text <> '') and (cmbbiblioteca.Text <> '') then begin
      if dm.sqlselect(dm.q1, 'select * from parametro ' +
         ' where clave=' + g_q + 'dir_' + cmbsistema.Text + '_' + cmbclase.Text + '_' + cmbbiblioteca.Text + g_q) then begin
         if directoryexists(dm.q1.fieldbyname('dato').AsString) then begin
            dir.Directory := dm.q1.fieldbyname('dato').AsString;
         end;
      end;
      if dm.sqlselect(dm.q1, 'select * from parametro ' +
         ' where clave=' + g_q + 'mask_' + cmbsistema.Text + '_' + cmbclase.Text + '_' + cmbbiblioteca.Text + g_q) then begin
         txtsufijo.Text := dm.q1.fieldbyname('dato').AsString;
      end;
      if dm.sqlselect(dm.q1, 'select * from parametro ' +
         ' where clave=' + g_q + 'chkextra_' + cmbsistema.Text + '_' + cmbclase.Text + '_' + cmbbiblioteca.Text + g_q) then begin
         chkextra.Checked := (dm.q1.fieldbyname('dato').AsString = 'TRUE');
      end;
      if dm.sqlselect(dm.q1, 'select * from parametro ' +
         ' where clave=' + g_q + 'chkruta_' + cmbsistema.Text + '_' + cmbclase.Text + '_' + cmbbiblioteca.Text + g_q) then begin
         chkruta.Checked := (dm.q1.fieldbyname('dato').AsString = 'TRUE');
      end;
      if dm.sqlselect(dm.q1, 'select * from parametro ' +
         ' where clave=' + g_q + 'chkextension_' + cmbsistema.Text + '_' + cmbclase.Text + '_' + cmbbiblioteca.Text + g_q) then begin
         chkextension.Checked := (dm.q1.fieldbyname('dato').AsString = 'TRUE');
      end;
      if dm.sqlselect(dm.q1, 'select * from parametro ' +
         ' where clave=' + g_q + 'chknombre_version_' + cmbsistema.Text + '_' + cmbclase.Text + '_' + cmbbiblioteca.Text + g_q) then begin
         chknombre_version.Checked := (dm.q1.fieldbyname('dato').AsString = 'TRUE');
      end;
      if dm.sqlselect(dm.q1, 'select * from parametro ' +
         ' where clave=' + g_q + 'chkcopys_' + cmbsistema.Text + '_' + cmbclase.Text + '_' + cmbbiblioteca.Text + g_q) then begin
         chkcopys.Checked := (dm.q1.fieldbyname('dato').AsString = 'TRUE');
      end;
      chkreemplaza.checked := false;
      if dm.sqlselect(dm.q1, 'select * from parametro ' +
         ' where clave=' + g_q + 'chkreemplaza_' + cmbsistema.Text + '_' + cmbclase.Text + '_' + cmbbiblioteca.Text + g_q +
         ' and secuencia=1') then begin
         chkreemplaza.Checked := true;
         txtreemplaza1.Text := dm.q1.fieldbyname('dato').AsString;
         txtreemplaza2.Text := '';
         if dm.sqlselect(dm.q1, 'select * from parametro ' +
            ' where clave=' + g_q + 'chkreemplaza_' + cmbsistema.Text + '_' + cmbclase.Text + '_' + cmbbiblioteca.Text + g_q +
            ' and secuencia=2') then begin
            txtreemplaza2.Text := dm.q1.fieldbyname('dato').AsString;
         end;
      end;
      if dm.sqlselect(dm.q1, 'select * from tsbib where cbib=' + g_q + cmbbiblioteca.Text + g_q) then begin
         bib_dir := dm.q1.fieldbyname('path').AsString;
         bib_base := dm.q1.fieldbyname('dirprod').AsString;
      end;
      b_rgnombre := false;
      if dm.sqlselect(dm.q1, 'select * from parametro ' +
         ' where clave=' + g_q + 'rgnombre_' + cmbsistema.Text + '_' + cmbclase.Text + '_' + cmbbiblioteca.Text + g_q) then begin
         rgnombre.ItemIndex := dm.q1.fieldbyname('secuencia').AsInteger;
         b_rgnombre := true;
      end;
      if dm.sqlselect(dm.q1, 'select * from tsclase where cclase=' + g_q + cmbclase.Text + g_q) then begin
         cla_tipo := dm.q1.fieldbyname('tipo').AsString;
         if (cmbclase.Text = 'TDC') then begin
            if (b_rgnombre = false) and (rgnombre.ItemIndex <> 0) then begin
               iHelpContext := IDH_TOPIC_T01728;
               Application.MessageBox(pchar(dm.xlng('Para esta clase se recomienda manejar el nombre' + chr(13) +
                  'del componente en modo "ACTUAL" (Cuadro inferior)')),
                  pchar(dm.xlng('Recepción de componentes')), MB_OK);
            end;
         end
         else begin
            if dm.q1.FieldByName('estructura').asstring = 'PATH BASE' then begin
               chkruta.Checked := true;
               chkruta.OnClick(nil);
               if (b_rgnombre = false) and (rgnombre.ItemIndex <> 0) then begin
                  Application.MessageBox(pchar(dm.xlng('Para esta clase se recomienda manejar el nombre' + chr(13) +
                     'del componente en modo "Actual" (Cuadro inferior)')),
                     pchar(dm.xlng('Recepción de componentes')), MB_OK);
                  rgnombre.ItemIndex := 0;
               end;
            end
            else begin
               chkruta.Checked := false;
               chkruta.OnClick(nil);
               if (b_rgnombre = false) and (rgnombre.ItemIndex <> 2) then begin
                  Application.MessageBox(pchar(dm.xlng('Para esta clase se recomienda manejar el nombre' + chr(13) +
                     'del componente en modo "MAYUSCULAS" (Cuadro inferior)')),
                     pchar(dm.xlng('Recepción de componentes')), MB_OK);
               end;
            end;
         end;
      end;
      if (cmbclase.Text = 'JOB') or (cmbclase.text = 'JCL') then begin
         chkparams.Checked := true;
         chkparams.Visible := true;
      end
      else begin
         chkparams.Checked := false;
         chkparams.Visible := false;
      end;
      if (cmbclase.Text = 'CBL') or (cmbclase.Text = 'CPY') then begin
         yextra.Visible := true;
         if dm.sqlselect(dm.q1, 'select * from parametro ' +
            ' where clave=' + g_q + 'EXTRA_MINING_' + cmbsistema.Text+'_'+ cmbclase.Text +'_'+cmbbiblioteca.Text+ g_q) then
            txtextra.Text := dm.q1.fieldbyname('dato').AsString
         else
         if dm.sqlselect(dm.q1, 'select * from parametro ' +
            ' where clave=' + g_q + 'EXTRA_MINING_' + cmbclase.Text + g_q) then
            txtextra.Text := dm.q1.fieldbyname('dato').AsString;
      end
      else begin
         yextra.Visible := false;
      end;
      if (cmbclase.Text = 'COS') then begin
         chkverifica.Visible := true;
         chkverifica.Checked := true;
      end;
      trae_configuracion := true;
   end;
end;

procedure alta_atributo(compo: string; bib: string; clase: string);
var
   lis: Tstringlist;
   archivo: string;
   cam, campo, valor, acompo, abib, aclase, hcclase, hcbib, hcprog, orden, indice: string;
   formato_alfa: boolean;
   i, j: integer;
begin
   archivo := 'atributos_' + ptscomun.cprog2bfile(compo);
   if fileexists(archivo) = false then
      exit;
   lis := Tstringlist.Create;
   lis.LoadFromFile(archivo);
   if lis.count=0 then
      lis.Add('');
   formato_alfa := (lis[0] = 'FORMATO ALFA');
   if formato_alfa then begin
      lis.Delete(0);
   end
   else begin
      dm.sqldelete('delete tsattribute ' +
         ' where ocprog=' + g_q + compo + g_q +
         ' and   ocbib=' + g_q + bib + g_q +
         ' and   occlase=' + g_q + clase + g_q);
   end;
   for i := 0 to lis.Count - 1 do begin
      if trim(lis[i]) = '' then
         continue;
      //               ATRIBUTOS(\aCOMPOCLASE\r|\aCOMPOBIB\r|\aCOMPONOM\r)=CLASE=\vCLASE0\r.\vCLASE\r{}
      // formato alfa: ATRIBUTOS(\aCOMPOCLASE\r|\aCOMPOBIB\r|\aCOMPONOM\ahijoCLASE\r|\ahijoBIB\r|\ahijoNOM\r|\vORDENr)=CLASE=\vCLASE0\r.\vCLASE\r{}
      if copy(lis[i], 1, 10) <> 'ATRIBUTOS(' then
         continue;
      lis[i] := stringreplace(lis[i], '$OFICINA$', g_pais, [rfreplaceall]); // Para reemplazar en el resultado de la mineria   //RGM20130220
      lis[i] := stringreplace(lis[i], '$SISTEMA$', g_sistema_actual, [rfreplaceall]); //RGM20130220
      lis[i] := stringreplace(lis[i], '$CLASE$', clase, [rfreplaceall]); //RGM20130220
      lis[i] := stringreplace(lis[i], '$BIBLIOTECA$', bib, [rfreplaceall]); //RGM20130220
      cam := copy(lis[i], 11, 5000);
      j := pos('|', cam);
      aclase := copy(cam, 1, j - 1);
      cam := copy(cam, j + 1, 5000);
      j := pos('|', cam);
      abib := copy(cam, 1, j - 1);
      cam := copy(cam, j + 1, 5000);
      if formato_alfa = false then begin
         j := pos(')', cam);
         acompo := copy(cam, 1, j - 1);
         cam := copy(cam, j + 2, 5000);
      end
      else begin
         j := pos('|', cam);
         acompo := copy(cam, 1, j - 1);
         cam := copy(cam, j + 1, 5000);
         j := pos('|', cam);
         hcclase := copy(cam, 1, j - 1);
         cam := copy(cam, j + 1, 5000);
         j := pos('|', cam);
         hcbib := copy(cam, 1, j - 1);
         cam := copy(cam, j + 1, 5000);
         j := pos('|', cam);
         hcprog := copy(cam, 1, j - 1);
         cam := copy(cam, j + 1, 5000);
         j := pos(')', cam);
         orden := copy(cam, 1, j - 1);
         cam := copy(cam, j + 2, 5000);
      end;
      j := pos('}INDEX=', cam);
      if j = 0 then
         indice := '0'
      else begin
         indice := copy(cam, j + 7, 5000);
         indice := copy(indice, 1, pos('{}', indice) - 1);
      end;
      cam := stringreplace(cam, 'ó', 'O', [rfreplaceall]);
      cam := stringreplace(cam, ':', '.', [rfreplaceall]);
      if formato_alfa = false then begin
         dm.sqlinsert('insert into tsattribute ' +
            ' (ocprog,ocbib,occlase,cprog,cbib,cclase,indice,atributos) values(' +
            g_q + compo + g_q + ',' +
            g_q + bib + g_q + ',' +
            g_q + clase + g_q + ',' +
            g_q + acompo + g_q + ',' +
            g_q + abib + g_q + ',' +
            g_q + aclase + g_q + ',' +
            indice + ',' +
            g_q + stringreplace(stringreplace(cam, g_q, g_q + g_q, [rfreplaceall])
            , '&', '', [rfreplaceall]) + g_q + ')');
      end
      else begin
         dm.sqlupdate('update tsrela set atributos=' + g_q + stringreplace(stringreplace(cam, g_q, g_q + g_q, [rfreplaceall])
            , '&', '', [rfreplaceall]) + g_q +
            ' where ocprog=' + g_q + compo + g_q +
            ' and   ocbib=' + g_q + bib + g_q +
            ' and   occlase=' + g_q + clase + g_q +
            ' and   pcprog=' + g_q + acompo + g_q +
            ' and   pcbib=' + g_q + abib + g_q +
            ' and   pcclase=' + g_q + aclase + g_q +
            ' and   hcprog=' + g_q + hcprog + g_q +
            ' and   hcbib=' + g_q + hcbib + g_q +
            ' and   hcclase=' + g_q + hcclase + g_q +
            ' and   orden=' + g_q + orden + g_q);
      end;
   end;
   deletefile(archivo);
   lis.Free;
end;

procedure concilia_hcbib(clase, bibli, programa, sistema: string);
   function matchea_bib(bscratch, bib: string): boolean; // checa que traiga SCRATCH en alguna parte de la biblioteca
   var k, m: integer;
   begin
      k := pos('SCRATCH', bscratch);
      if k = 1 then begin // SCRATCH_aaa_bbb
         m := length(bscratch) - 7; // toma la longitud de la bib sin SCRATCH
         if copy(bscratch, 8, m) = copy(bib, length(bib) - m + 1, m) then begin
            matchea_bib := true;
            exit;
         end;
      end
      else begin
         if k = length(bscratch) - 7 + 1 then begin //   aaa_bbb_SCRATCH
            if copy(bscratch, 1, k - 1) = copy(bib, 1, k - 1) then begin
               matchea_bib := true;
               exit;
            end;
         end
         else begin //   aaa_SCRATCH_bbb
            if length(bscratch) - 7 <= length(bib) then begin // para asegurar que no se traslaparan las comparaciones siguientes
               if copy(bscratch, 1, k - 1) = copy(bib, 1, k - 1) then begin
                  m := length(bscratch) - 7 - k + 1;
                  if copy(bscratch, k + 7, m) = copy(bib, length(bib) - m + 1, m) then begin
                     matchea_bib := true;
                     exit;
                  end;
               end;
            end;
         end;
      end;
      matchea_bib := false;
   end;
begin
   b_otros_sistemas := false;
   if g_conciliado.IndexOf(clase + '_' + bibli + '_' + programa + '_' + sistema) > -1 then
      exit;
   g_conciliado.Add(clase + '_' + bibli + '_' + programa + '_' + sistema);
   if clase = 'TAB' then begin
      dm.sqlupdate('update tsrela set hcbib=' + g_q + bibli + g_q +
         ' ,hcprog='+ g_q + programa + g_q +
         ' where hcprog=' + g_q + programa + g_q +
         ' and   hcbib in (' + g_q + 'BD' + g_q + ',' + g_q + 'SCRATCH' + g_q + ')' +
         ' and   hcclase in (' + g_q + 'TAB' + g_q + ',' + g_q + 'INS' + g_q + ',' + g_q + 'UPD' + g_q + ',' + g_q + 'DEL' + g_q + ')' +
         ' and   hsistema=' + g_q + sistema + g_q);
      if b_otros_sistemas then begin
         dm.sqlupdate('update tsrela set hcbib=' + g_q + bibli + g_q +
            ' ,hcprog='+ g_q + programa + g_q +
            ' where hcprog=' + g_q + programa + g_q +
            ' and   hcbib in (' + g_q + 'BD' + g_q + ',' + g_q + 'SCRATCH' + g_q + ')' +
            ' and   hcclase in (' + g_q + 'TAB' + g_q + ',' + g_q + 'INS' + g_q + ',' + g_q + 'UPD' + g_q + ',' + g_q + 'DEL' + g_q + ')');
      end;
   end;
   //   actualiza clase XXX de registros que ya están en TSRELA
   dm.sqlupdate('update tsrela set hcclase=' + g_q + clase + g_q +
      ' ,hcprog='+ g_q + programa + g_q +
      ' where hcprog=' + g_q + programa + g_q +
      ' and   hcbib=' + g_q + bibli + g_q +
      ' and   hcclase=' + g_q + 'XXX' + g_q +
      ' and   hsistema=' + g_q + sistema + g_q);
   if b_otros_sistemas then begin
      dm.sqlupdate('update tsrela set hcclase=' + g_q + clase + g_q +
         ' ,hcprog='+ g_q + programa + g_q +
         ' where hcprog=' + g_q + programa + g_q +
         ' and   hcbib=' + g_q + bibli + g_q +
         ' and   hcclase=' + g_q + 'XXX' + g_q);
   end;
   dm.sqlupdate('update tsrela set hcbib=' + g_q + bibli + g_q + ', hcclase=' + g_q + clase + g_q +
      ' ,hcprog='+ g_q + programa + g_q +
      ' where hcprog=' + g_q + programa + g_q +
      ' and   hcbib=' + g_q + 'SCRATCH' + g_q +
      ' and   xcclase like ' + g_q + '%' + clase + '%' + g_q +
      ' and   hsistema=' + g_q + sistema + g_q);
   if b_otros_sistemas then begin
      dm.sqlupdate('update tsrela set hcbib=' + g_q + bibli + g_q + ', hcclase=' + g_q + clase + g_q +
         ' ,hcprog='+ g_q + programa + g_q +
         ' where hcprog=' + g_q + programa + g_q +
         ' and   hcbib=' + g_q + 'SCRATCH' + g_q +
         ' and   xcclase like ' + g_q + '%' + clase + '%' + g_q);
   end;
   if dm.sqlselect(dm.q1, 'select * from tsrela ' +
      ' where hcprog=' + g_q + programa + g_q +
      ' and   hcbib like ' + g_q + '%SCRATCH%' + g_q +
      ' and   hcclase=' + g_q + 'XXX' + g_q +
      ' and   hsistema=' + g_q + sistema + g_q) then begin
      while not dm.q1.Eof do begin
         if matchea_bib(dm.q1.FieldByName('hcbib').AsString, bibli) then begin
            dm.sqlupdate('update tsrela set hcbib=' + g_q + bibli + g_q + ',hcclase=' + g_q + clase + g_q +
               ' ,hcprog='+ g_q + programa + g_q +
               ' where hcprog=' + g_q + programa + g_q +
               ' and   hcbib=' + g_q + dm.q1.FieldByName('hcbib').AsString + g_q +
               ' and   hcclase=' + g_q + 'XXX' + g_q +
               ' and   hsistema=' + g_q + sistema + g_q);
            exit;
         end;
         dm.q1.Next;
      end;
   end;
   if b_otros_sistemas then begin
      if dm.sqlselect(dm.q1, 'select * from tsrela ' +
         ' where hcprog=' + g_q + programa + g_q +
         ' and   hcbib like ' + g_q + '%SCRATCH%' + g_q +
         ' and   hcclase=' + g_q + 'XXX' + g_q) then begin
         while not dm.q1.Eof do begin
            if matchea_bib(dm.q1.FieldByName('hcbib').AsString, bibli) then begin
               dm.sqlupdate('update tsrela set hcbib=' + g_q + bibli + g_q + ',hcclase=' + g_q + clase + g_q +
                  ' ,hcprog='+ g_q + programa + g_q +
                  ' where hcprog=' + g_q + programa + g_q +
                  ' and   hcbib=' + g_q + dm.q1.FieldByName('hcbib').AsString + g_q +
                  ' and   hcclase=' + g_q + 'XXX' + g_q);
               exit;
            end;
            dm.q1.Next;
         end;
      end;
   end;
   if dm.sqlselect(dm.q1, 'select * from tsrela ' +
      ' where hcprog=' + g_q + programa + g_q +
      ' and   hcbib like ' + g_q + '%SCRATCH%' + g_q +
      ' and   xcclase like ' + g_q + '%' + clase + '%' + g_q +
      ' and   hsistema=' + g_q + sistema + g_q) then begin
      while not dm.q1.Eof do begin
         if matchea_bib(dm.q1.FieldByName('hcbib').AsString, bibli) then begin
            dm.sqlupdate('update tsrela set hcbib=' + g_q + bibli + g_q + ', hcclase=' + g_q + clase + g_q +
               ' ,hcprog='+ g_q + programa + g_q +
               ' where hcprog=' + g_q + programa + g_q +
               ' and   hcbib=' + g_q + dm.q1.FieldByName('hcbib').AsString + g_q +
               ' and   xcclase like ' + g_q + '%' + clase + '%' + g_q +
               ' and   hsistema=' + g_q + sistema + g_q);
            exit;
         end;
         dm.q1.Next;
      end;
   end;
   if b_otros_sistemas then begin
      if dm.sqlselect(dm.q1, 'select * from tsrela ' +
         ' where hcprog=' + g_q + programa + g_q +
         ' and   hcbib like ' + g_q + '%SCRATCH%' + g_q +
         ' and   xcclase like ' + g_q + '%' + clase + '%' + g_q) then begin
         while not dm.q1.Eof do begin
            if matchea_bib(dm.q1.FieldByName('hcbib').AsString, bibli) then begin
               dm.sqlupdate('update tsrela set hcbib=' + g_q + bibli + g_q + ', hcclase=' + g_q + clase + g_q +
                  ' ,hcprog='+ g_q + programa + g_q +
                  ' where hcprog=' + g_q + programa + g_q +
                  ' and   hcbib=' + g_q + dm.q1.FieldByName('hcbib').AsString + g_q +
                  ' and   xcclase like ' + g_q + '%' + clase + '%' + g_q);
               exit;
            end;
            dm.q1.Next;
         end;
      end;
   end;
   dm.sqlupdate('update tsrela set hcbib=' + g_q + bibli + g_q +
      ' ,hcprog='+ g_q + programa + g_q +
      ' where hcprog=' + g_q + programa + g_q +
      ' and   hcbib=' + g_q + 'SCRATCH' + g_q +
      ' and   hcclase=' + g_q + clase + g_q +
      ' and   hsistema=' + g_q + sistema + g_q);
   if b_otros_sistemas then begin
      dm.sqlupdate('update tsrela set hcbib=' + g_q + bibli + g_q +
         ' ,hcprog='+ g_q + programa + g_q +
         ' where hcprog=' + g_q + programa + g_q +
         ' and   hcbib=' + g_q + 'SCRATCH' + g_q +
         ' and   hcclase=' + g_q + clase + g_q);
   end;
   dm.sqlupdate('update tsrela set hcbib=' + g_q + bibli + g_q + ', hcclase=' + g_q + clase + g_q +
      ' ,hcprog='+ g_q + programa + g_q +
      ' where hcprog=' + g_q + programa + g_q +
      ' and   hcbib=' + g_q + 'SCRATCH' + g_q +
      ' and   xcclase like ' + g_q + '%' + clase + '%' + g_q +
      ' and   hsistema=' + g_q + sistema + g_q);
   if b_otros_sistemas then begin
      dm.sqlupdate('update tsrela set hcbib=' + g_q + bibli + g_q + ', hcclase=' + g_q + clase + g_q +
         ' ,hcprog='+ g_q + programa + g_q +
         ' where hcprog=' + g_q + programa + g_q +
         ' and   hcbib=' + g_q + 'SCRATCH' + g_q +
         ' and   xcclase like ' + g_q + '%' + clase + '%' + g_q);
   end;
   if dm.sqlselect(dm.q1, 'select * from tsrela ' +
      ' where hcprog=' + g_q + programa + g_q +
      ' and   hcbib like ' + g_q + '%SCRATCH%' + g_q +
      ' and   hcclase=' + g_q + clase + g_q +
      ' and   hsistema=' + g_q + sistema + g_q) then begin
      while not dm.q1.Eof do begin
         if matchea_bib(dm.q1.FieldByName('hcbib').AsString, bibli) then begin
            dm.sqlupdate('update tsrela set hcbib=' + g_q + bibli + g_q +
               ' ,hcprog='+ g_q + programa + g_q +
               ' where hcprog=' + g_q + programa + g_q +
               ' and   hcbib=' + g_q + dm.q1.FieldByName('hcbib').AsString + g_q +
               ' and   hcclase=' + g_q + clase + g_q +
               ' and   hsistema=' + g_q + sistema + g_q);
            exit;
         end;
         dm.q1.Next;
      end;
   end;
   if b_otros_sistemas then begin
      if dm.sqlselect(dm.q1, 'select * from tsrela ' +
         ' where hcprog=' + g_q + programa + g_q +
         ' and   hcbib like ' + g_q + '%SCRATCH%' + g_q +
         ' and   hcclase=' + g_q + clase + g_q) then begin
         while not dm.q1.Eof do begin
            if matchea_bib(dm.q1.FieldByName('hcbib').AsString, bibli) then begin
               dm.sqlupdate('update tsrela set hcbib=' + g_q + bibli + g_q +
                  ' ,hcprog='+ g_q + programa + g_q +
                  ' where hcprog=' + g_q + programa + g_q +
                  ' and   hcbib=' + g_q + dm.q1.FieldByName('hcbib').AsString + g_q +
                  ' and   hcclase=' + g_q + clase + g_q);
               exit;
            end;
            dm.q1.Next;
         end;
      end;
   end;
   if dm.sqlselect(dm.q1, 'select * from tsrela ' +
      ' where hcprog=' + g_q + programa + g_q +
      ' and   hcbib like ' + g_q + '%SCRATCH%' + g_q +
      ' and   xcclase like ' + g_q + '%' + clase + '%' + g_q +
      ' and   hsistema=' + g_q + sistema + g_q) then begin
      while not dm.q1.Eof do begin
         if matchea_bib(dm.q1.FieldByName('hcbib').AsString, bibli) then begin
            dm.sqlupdate('update tsrela set hcbib=' + g_q + bibli + g_q + ', hcclase=' + g_q + clase + g_q +
               ' ,hcprog='+ g_q + programa + g_q +
               ' where hcprog=' + g_q + programa + g_q +
               ' and   hcbib=' + g_q + dm.q1.FieldByName('hcbib').AsString + g_q +
               ' and   xcclase like ' + g_q + '%' + clase + '%' + g_q +
               ' and   hsistema=' + g_q + sistema + g_q);
            exit;
         end;
         dm.q1.Next;
      end;
   end;
   if b_otros_sistemas then begin
      if dm.sqlselect(dm.q1, 'select * from tsrela ' +
         ' where hcprog=' + g_q + programa + g_q +
         ' and   hcbib like ' + g_q + '%SCRATCH%' + g_q +
         ' and   xcclase like ' + g_q + '%' + clase + '%' + g_q) then begin
         while not dm.q1.Eof do begin
            if matchea_bib(dm.q1.FieldByName('hcbib').AsString, bibli) then begin
               dm.sqlupdate('update tsrela set hcbib=' + g_q + bibli + g_q + ', hcclase=' + g_q + clase + g_q +
                  ' ,hcprog='+ g_q + programa + g_q +
                  ' where hcprog=' + g_q + programa + g_q +
                  ' and   hcbib=' + g_q + dm.q1.FieldByName('hcbib').AsString + g_q +
                  ' and   xcclase like ' + g_q + '%' + clase + '%' + g_q);
               exit;
            end;
            dm.q1.Next;
         end;
      end;
   end;
end;
procedure var_ambiente_general;
begin
   if var_general=nil then
      var_general:=Tstringlist.Create
   else
      var_general.Clear;
   if dm.sqlselect(dm.q2,'select pcprog,hcprog, count(*) cuenta from tsrela '+
      ' where pcclase='+g_q+'VAR'+g_q+
      ' group by pcprog,hcprog '+
      ' order by pcprog,hcprog,cuenta desc') then begin
      while not dm.q2.Eof do begin
         var_general.add(dm.q2.fieldbyname('pcprog').AsString+'_=_'+dm.q2.fieldbyname('hcprog').AsString+'<=>VAR_GENERAL');
         dm.q2.next;
      end;
   end;
end;

procedure var_ambiente_prog(cmbclase_text,cmbbiblioteca_text,este:string);
begin
   if var_prog=nil then
      var_prog:=Tstringlist.Create
   else
      var_prog.Clear;
   if dm.sqlselect(dm.q2,'select distinct ocprog,ocbib,occlase from tsrela '+
      ' where hcprog='+g_q+este+g_q+
      ' and   hcbib='+g_q+cmbbiblioteca_text+g_q+
      ' and   hcclase='+g_q+cmbclase_text+g_q) then begin
      while not dm.q2.Eof do begin
         if dm.sqlselect(dm.q3,'select distinct pcprog,hcprog from tsrela '+
            ' where ocprog='+g_q+dm.q2.fieldbyname('ocprog').AsString+g_q+
            ' and   ocbib='+g_q+dm.q2.fieldbyname('ocbib').AsString+g_q+
            ' and   occlase='+g_q+dm.q2.fieldbyname('occlase').AsString+g_q+
            ' and   pcclase='+g_q+'VAR'+g_q) then begin
            while not dm.q3.eof do begin
               var_prog.add(dm.q3.fieldbyname('pcprog').AsString+
               '_=_'+dm.q3.fieldbyname('hcprog').AsString+
               '<=>'+dm.q2.fieldbyname('occlase').AsString +'_'+dm.q2.fieldbyname('ocbib').AsString+'_'+dm.q2.fieldbyname('ocprog').AsString);
               dm.q3.next;
            end;
         end;
         dm.q2.next;
      end;
   end;
   var_prog.sort;
end;

procedure reemplaza_var_ambiente(cmbclase_text,cmbbiblioteca_text,este,hclase,hbib,hprog:string);
var i,j,k:integer;
   prog,valor,propietario,biblioteca,sele:string;
   b_ok:boolean;
   vprog:Tstringlist;
begin
   vprog:=var_prog;
   for j:=1 to 2 do begin
      for i:=0 to vprog.Count-1 do begin
         prog:=hprog+'_=_';
         k:=length(prog);
         if prog=copy(vprog[i],1,k) then begin
            valor:=copy(vprog[i],pos('_=_',vprog[i])+3,100);
            valor:=copy(valor,1,pos('<=>',valor)-1);
            propietario:=copy(vprog[i],pos('<=>',vprog[i])+3,100);
            if dm.sqlselect(dm.q1,'select * from tsrela '+
               ' where ocprog='+g_q+este+g_q+
               ' and   ocbib='+g_q+cmbbiblioteca_text+g_q+
               ' and   occlase='+g_q+cmbclase_text+g_q+
               ' and   hcprog='+g_q+hprog+g_q+
               ' and   hcbib='+g_q+hbib+g_q+
               ' and   hcclase='+g_q+hclase+g_q) then begin
               while not dm.q1.Eof do begin
                  biblioteca:=dm.q1.FieldByName('hcbib').AsString;
                  if (biblioteca='SCRATCH') or (biblioteca='BD') then begin      // busca la biblioteca a
                     if dm.sqlselect(dm.q2,'select hcbib,count(*) cuenta from tsrela '+
                        ' where hcprog='+g_q+valor+g_q+
                        ' and   hcbib not in ('+g_q+'SCRATCH'+g_q+','+g_q+'BD'+g_q+')'+
                        ' and   hcclase='+g_q+dm.q1.fieldbyname('hcclase').AsString + g_q +
                        ' group by hcbib '+
                        ' order by cuenta desc') then begin
                        biblioteca:=dm.q2.FieldByName('hcbib').AsString;
                     end;
                  end;
                  {
                  if (biblioteca='SCRATCH') or (biblioteca='BD') then begin       //   si no la encuentra, no la grab
                     dm.q1.next;
                     continue;
                  end;
                  }
                  dm.sqldelete('delete tsrela '+
                     ' where pcprog='+g_q+dm.q1.fieldbyname('pcprog').AsString+g_q+
                     ' and   pcbib='+g_q+dm.q1.fieldbyname('pcbib').AsString+g_q+
                     ' and   pcclase='+g_q+dm.q1.fieldbyname('pcclase').AsString+g_q+
                     ' and   ocprog='+g_q+dm.q1.fieldbyname('ocprog').AsString+g_q+
                     ' and   ocbib='+g_q+dm.q1.fieldbyname('ocbib').AsString+g_q+
                     ' and   occlase='+g_q+dm.q1.fieldbyname('occlase').AsString+g_q+
                     ' and   orden='+g_q+dm.q1.fieldbyname('orden').AsString+g_q+
                     ' and   coment='+g_q+propietario+g_q);
                  sele := 'insert into tsrela (pcprog,pcbib,pcclase,hcprog,hcbib,hcclase,modo,' +
                     'organizacion,externo,coment,orden,sistema,ocprog,ocbib,occlase,lineainicio,lineafinal,ambito,icprog,icbib,icclase,' +
                     'polimorfismo,xcclase,hsistema,hparametros,hinterfase) ' +
                     ' values(' +
                     g_q + dm.q1.fieldbyname('pcprog').AsString + g_q + ',' +
                     g_q + dm.q1.fieldbyname('pcbib').AsString + g_q + ',' +
                     g_q + dm.q1.fieldbyname('pcclase').AsString + g_q + ',' +
                     g_q + valor + g_q + ',' +        // aqui se reemplazó
                     g_q + biblioteca + g_q + ',' +
                     g_q + dm.q1.fieldbyname('hcclase').AsString + g_q + ',' +
                     g_q + dm.q1.fieldbyname('modo').AsString + g_q + ',' +
                     g_q + dm.q1.fieldbyname('organizacion').AsString + g_q + ',' +
                     g_q + dm.q1.fieldbyname('externo').AsString + g_q + ',' +
                     g_q + propietario+ g_q + ',' +
                     g_q + dm.q1.fieldbyname('orden').AsString + g_q + ',' +
                     g_q + dm.q1.fieldbyname('sistema').AsString + g_q + ',' +
                     g_q + dm.q1.fieldbyname('ocprog').AsString + g_q + ',' +
                     g_q + dm.q1.fieldbyname('ocbib').AsString + g_q + ',' +
                     g_q + dm.q1.fieldbyname('occlase').AsString + g_q + ',' +
                     dm.q1.fieldbyname('lineainicio').AsString + ',' +
                     dm.q1.fieldbyname('lineafinal').AsString + ',' +
                     g_q + dm.q1.fieldbyname('ambito').AsString + g_q + ',' +
                     g_q + dm.q1.fieldbyname('icprog').AsString + g_q + ',' +
                     g_q + dm.q1.fieldbyname('icbib').AsString + g_q + ',' +
                     g_q + dm.q1.fieldbyname('icclase').AsString + g_q + ',' +
                     g_q + dm.q1.fieldbyname('polimorfismo').AsString + g_q + ',' +
                     g_q + dm.q1.fieldbyname('xcclase').AsString + g_q + ',' +
                     g_q + dm.q1.fieldbyname('hsistema').AsString + g_q + ',' +
                     g_q + dm.q1.fieldbyname('hparametros').AsString + g_q + ',' +
                     g_q + dm.q1.fieldbyname('hinterfase').AsString + g_q + ')';
                  dm.sqlinsert(sele);
                  b_ok:=true;
                  dm.q1.Next;
               end;
            end;
         end;
      end;
      if b_ok then
         break;
      vprog:=var_general;
   end;
end;

procedure reemplaza_var_en_hijos(clase,biblioteca,programa:string);
var  actual:string;
begin
   var_ambiente_general;
   if dm.sqlselect(dm.q4,'select distinct hcprog,hcbib,hcclase from tsrela '+
      ' where ocprog='+g_q+programa+g_q+
      ' and   ocbib='+g_q+biblioteca+g_q+
      ' and   occlase='+g_q+clase+g_q) then begin
      while not dm.q4.Eof do begin
         if dm.sqlselect(dm.q5,'select * from tsrela '+
            ' where ocprog='+g_q+dm.q4.fieldbyname('hcprog').AsString+g_q+
            ' and   ocbib='+g_q+dm.q4.fieldbyname('hcbib').AsString+g_q+
            ' and   occlase='+g_q+dm.q4.fieldbyname('hcclase').AsString+g_q+
            ' and   coment='+g_q+'GETENV'+g_q) then begin
            while not dm.q5.Eof do begin
               if actual<>dm.q5.FieldByName('occlase').AsString+'_'+
                  dm.q5.FieldByName('ocbib').AsString+'_'+
                  dm.q5.FieldByName('ocprog').AsString then begin
                  var_ambiente_prog(dm.q5.FieldByName('occlase').AsString,
                     dm.q5.FieldByName('ocbib').AsString,
                     dm.q5.FieldByName('ocprog').AsString);
                  actual:=dm.q5.FieldByName('occlase').AsString+'_'+
                     dm.q5.FieldByName('ocbib').AsString+'_'+
                     dm.q5.FieldByName('ocprog').AsString;
               end;
               reemplaza_var_ambiente(dm.q5.FieldByName('occlase').AsString,
                     dm.q5.FieldByName('ocbib').AsString,
                     dm.q5.FieldByName('ocprog').AsString,
                     dm.q5.FieldByName('hcclase').AsString,
                     dm.q5.FieldByName('hcbib').AsString,
                     dm.q5.FieldByName('hcprog').AsString);
               dm.q5.Next;
            end;
         end;
         dm.q4.Next;
      end;
   end;
end;

function concilia_del(w_xcclase,w_sistema_hijo:string; var clase,bib,prog:string):boolean;
   function busca_idx_tab:boolean;
   begin
      if dm.sqlselect(dm.q1, 'select * from tsrela ' + // busca nombre de componente y mismo tipo
         ' where pcprog=' + g_q + prog + g_q +
         ' and pcbib=' + g_q + bib + g_q +
         ' and pcclase=' + g_q + 'IDX' + g_q +
         ' and hcclase=' + g_q + 'TAB' + g_q +
         ' and sistema=' + g_q + w_sistema_hijo + g_q) then begin
         prog:= dm.q1.fieldbyname('pcprog').AsString;
         busca_idx_tab:=true;
         exit;
      end;
      busca_idx_tab:=false;
   end;
begin
   if dm.sqlselect(dm.q1, 'select * from tsprog ' + // busca nombre de componente y mismo tipo
      ' where cprog=' + g_q + prog + g_q +
      ' and cbib<>' + g_q + 'SCRATCH' + g_q +
      ' and   cclase=' + g_q + 'IDX' + g_q +
      ' and sistema=' + g_q + w_sistema_hijo + g_q) then begin
      if dm.q1.RecordCount = 1 then begin
         bib := dm.q1.fieldbyname('cbib').AsString;
         prog := dm.q1.fieldbyname('cprog').AsString;
         concilia_del:=busca_idx_tab;
         exit;
      end
      else begin
         if dm.sqlselect(dm.q1, 'select * from tsprog ' + // cuando está en más de una biblioteca, busca igual al del padre
            ' where cprog=' + g_q + prog + g_q +
            ' and cbib='+g_q+bib+g_q+
            ' and   cclase=' + g_q + 'IDX' + g_q +
            ' and sistema=' + g_q + w_sistema_hijo + g_q) then begin
            bib := dm.q1.fieldbyname('cbib').AsString;
            prog := dm.q1.fieldbyname('cprog').AsString;
            concilia_del:=busca_idx_tab;
            exit;
         end;
      end;
   end;
   if dm.sqlselect(dm.q1, 'select distinct hcbib,hcprog from tsrela ' + // busca nombre de componente y mismo tipo
      ' where hcprog=' + g_q + prog + g_q +
      ' and  ( lineainicio>0 and lineafinal>0) ' +
      ' and   hcclase=' + g_q + 'IDX' + g_q +
      ' and   hsistema=' + g_q + w_sistema_hijo + g_q) then begin
      if dm.q1.RecordCount = 1 then begin
         bib := dm.q1.fieldbyname('hcbib').AsString;
         prog := dm.q1.fieldbyname('hcprog').AsString;
         concilia_del:=busca_idx_tab;
         exit;
      end
      else begin
         if b_otros_sistemas then begin
            if dm.sqlselect(dm.q1, 'select distinct hcbib,hcprog from tsrela ' + // busca nombre de componente y mismo tipo
               ' where hcprog=' + g_q + prog + g_q +
               ' and ( lineainicio>0 and lineafinal>0) '+
               ' and   hcclase=' + g_q + 'IDX' + g_q) then begin
               if dm.q1.RecordCount = 1 then begin
                  bib := dm.q1.fieldbyname('hcbib').AsString;
                  prog := dm.q1.fieldbyname('hcprog').AsString;
                  concilia_del:=busca_idx_tab;
                  exit;
               end;
            end;
         end;
      end;
   end;
   concilia_del:=false;
end;

function analiza_componente(clase: string; biblioteca: string;
   programa: string; lista: Tstrings): boolean;
var
   m: Tstringlist;
   i, j, k: integer;
   sele, owner_tipo, bibli, owner_prg, sis, lst: string;
   ucla: string;
   w_lineainicio, w_lineafinal, w_ambito, w_icprog, w_icbib, w_icclase, w_polimorfismo, q_polimorfismo, w_xcclase, w_xbib, w_sistema_hijo, w_parametros, w_interfase: string;
   w_where: string;
   wb,wc:Tstringlist;
   w_ok:boolean;
   tempo: string;
   padre_igual_owner: boolean;
   es_del:boolean;
   nclase,nbib,nprog:string;
   cc_reg,dd_reg:string;   // para prever archivos de carga (INS,DEL,UPD)
begin
   b_otros_sistemas := false;
   b_tiene_var:=false;
   owner_tipo := clase;
   owner_prg := programa;
   m := Tstringlist.create;
   wb := Tstringlist.create;
   wc := Tstringlist.create;
   g_conciliado.Clear;
   for i := 0 to lista.Count - 1 do begin
      if trim(lista[i]) = '' then
         continue;
      // m.CommaText:=stringreplace(stringreplace(stringreplace(lista[i],',','',[rfreplaceall]),'|',',',[rfreplaceall]),' ','',[rfreplaceall]);
      //m.CommaText := stringreplace( stringreplace( stringreplace( lista[ i ], ',', '', [ rfreplaceall ] ), '|', ',', [ rfreplaceall ] ), ' ', '{}', [ rfreplaceall ] );
      for j := 1 to length(lista[i]) do begin // limpia caracteres especiales menores a 32
         if ord(lista[i][j]) < 32 then begin
            lst := lista[i][j];
            lista[i] := stringreplace(lista[i], lst, '_', [rfreplaceall]);
         end;
      end;
      {
      //******************* Temporal para la demo de SCOTIABANK SCB. RGM
      if uppercase(g_empresa)='SCOTIA' then begin
         lista[i]:=stringreplace(lista[i],'\DESA.','',[rfreplaceall]);
         lista[i]:=stringreplace(lista[i],'/DESA.','',[rfreplaceall]);
      end;
      //****************************************************************
      }
      m.Delimiter := '|';
      m.DelimitedText := lista[i];
      //m.DelimitedText := '"'+stringreplace(lista[ i ],'|','"|"',[rfreplaceall])+'"';
      if m.Count <> 12 then begin
         g_log.Add('analiza_componente|' + clase + '|' + biblioteca + '|' + programa +
            '|ERROR... lista inconsistente' + m.CommaText);
         analiza_componente := false;
         exit;
      end;
      // control de archivos de carga
      dd_reg:=m[0]+'|'+m[1]+'|'+m[2]+'|'+m[3]+'|'+m[4]+'|'+m[5]+'|'+m[7]+'|'+m[8]+'|'+m[9]+'|'+m[10]+'|';
      if (m[3]='INS') or (m[3]='UPD') or (m[3]='DEL') then begin
         if dd_reg=cc_reg then
            continue;
      end;
      cc_reg:=dd_reg;

      tempo := m[6];
      w_lineainicio := '0';
      w_lineafinal := '0';
      w_ambito := '';
      w_icprog := '';
      w_icbib := '';
      w_icclase := '';
      w_polimorfismo := '';
      w_xbib := '';
      w_xcclase := '';
      w_sistema_hijo := '';
      w_parametros := '';
      w_interfase := '';
      while pos('][', tempo) > 0 do begin
         if copy(tempo, 1, 3) = 'LI=' then
            w_lineainicio := copy(tempo, 4, pos('][', tempo) - 4)
         else if copy(tempo, 1, 3) = 'LF=' then
            w_lineafinal := copy(tempo, 4, pos('][', tempo) - 4)
         else if copy(tempo, 1, 3) = 'AM=' then
            w_ambito := copy(tempo, 4, pos('][', tempo) - 4)
         else if copy(tempo, 1, 3) = 'IP=' then
            w_icprog := copy(tempo, 4, pos('][', tempo) - 4)
         else if copy(tempo, 1, 3) = 'IB=' then
            w_icbib := copy(tempo, 4, pos('][', tempo) - 4)
         else if copy(tempo, 1, 3) = 'IC=' then
            w_icclase := copy(tempo, 4, pos('][', tempo) - 4)
         else if copy(tempo, 1, 3) = 'PO=' then
            w_polimorfismo := copy(tempo, 4, pos('][', tempo) - 4)
         else if copy(tempo, 1, 3) = 'XB=' then
            w_xbib := copy(tempo, 4, pos('][', tempo) - 4)
         else if copy(tempo, 1, 3) = 'XC=' then
            w_xcclase := copy(tempo, 4, pos('][', tempo) - 4)
         else if copy(tempo, 1, 3) = 'HS=' then
            w_sistema_hijo := copy(tempo, 4, pos('][', tempo) - 4)
         else if copy(tempo, 1, 3) = 'HP=' then
            w_parametros := copy(tempo, 4, pos('][', tempo) - 4)
         else if copy(tempo, 1, 3) = 'HI=' then
            w_interfase := copy(tempo, 4, pos('][', tempo) - 4);
         tempo := copy(tempo, pos('][', tempo) + 2, 5000);
      end;
      if trim(w_sistema_hijo) = '' then
         w_sistema_hijo := g_sistema_actual;
      m[4] := bibfte(m[4]);
      m[10] := copy(stringreplace(m[10], g_q, g_q + g_q, [rfreplaceall]), 1, 200); // Apóstrofes en comentarios que chocan con apóstrofes de SQL
      m[5] := stringreplace(m[5], '''', '', [rfreplaceall]);
      m[5] := stringreplace(m[5], '\', '.', [rfreplaceall]); // Csharp
      if ((clase = 'NAT') or // Natural programa lo caza contra Locales
         (clase = 'NSP') or
         (clase = 'NSR')) and
         ((m[3] = 'NVW') or
         (m[3] = 'NIN') or
         (m[3] = 'NUP') or
         (m[3] = 'NDL')) then begin
         if dm.sqlselect(dm.q1, 'select hcprog from tsrela ' +
            ' where (pcprog,pcbib,pcclase) in ' +
            ' ( select hcprog,hcbib,hcclase from tsrela ' +
            '   where pcprog=' + g_q + programa + g_q +
            '   and   pcbib=' + g_q + biblioteca + g_q +
            '   and   pcclase=' + g_q + clase + g_q +
            '   and   hcclase=' + g_q + 'NLC' + g_q +
            '  ) ' +
            ' and   hcclase=' + g_q + 'LOC' + g_q +
            ' and   externo=' + g_q + m[9] + g_q) then begin
            m[5] := dm.q1.fieldbyname('hcprog').AsString;
         end;
      end;
      // ruta base, caso JAVA
      {
      if (m[4]='SCRATCH') and (trim(m[10])<>'') then begin
         if dm.sqlselect(dm.q1,'select * from tsbib where dirprod='+g_q+m[10]+g_q) then begin
            m[4]:=dm.q1.fieldbyname('cbib').AsString;
         end;
      end;
      }
      // java web.xml
      sis := '/' + g_sistema_actual + '/';
      if (m[0] = 'JSU') or (m[0] = 'JSN') or (m[0] = 'JTG') then begin
         if copy(m[2], 1, length(sis)) <> sis then begin
            m[2] := sis + m[2];
            m[2] := stringreplace(m[2], '//', '/', []); // por si tenia diagonal al principio
         end;
      end;
      if (m[3] = 'JSU') or (m[3] = 'JSN') or (m[3] = 'JTG') then begin
         if copy(m[5], 1, length(sis)) <> sis then begin
            m[5] := sis + m[5];
            m[5] := stringreplace(m[5], '//', '/', []); // por si tenia diagonal al principio
         end;
      end;
      // ............

      if owner_tipo='OBY' then begin   // TANDEM Server  TSP->OBY->TSE
         if (m[0]='TSE') and (m[1]='SCRATCH') then begin
            if dm.sqlselect(dm.q2,'select pcprog from tsrela '+
               ' where hcprog='+g_q+owner_prg+g_q+
               ' and   hcbib='+g_q+biblioteca+g_q+
               ' and   hcclase='+g_q+owner_tipo+g_q+
               ' and   pcclase='+g_q+'TSP'+g_q) then
               m[1]:=dm.q2.fieldbyname('pcprog').asstring;
         end;
         if (m[0]='TSP') and (m[2]='SCRATCH') then begin
            if dm.sqlselect(dm.q2,'select pcprog from tsrela '+
               ' where hcprog='+g_q+owner_prg+g_q+
               ' and   hcbib='+g_q+biblioteca+g_q+
               ' and   hcclase='+g_q+owner_tipo+g_q+
               ' and   pcclase='+g_q+'TSP'+g_q) then
               m[2]:=dm.q2.fieldbyname('pcprog').asstring;
         end;
         if (m[3]='TSE') and (m[4]='SCRATCH') then begin
            if dm.sqlselect(dm.q2,'select pcprog from tsrela '+
               ' where hcprog='+g_q+owner_prg+g_q+
               ' and   hcbib='+g_q+biblioteca+g_q+
               ' and   hcclase='+g_q+owner_tipo+g_q+
               ' and   pcclase='+g_q+'TSP'+g_q) then
               m[4]:=dm.q2.fieldbyname('pcprog').asstring;
         end;
      end;
      //--------------------------------- XB
      if (w_xbib<>'') and (m[4]='SCRATCH') then begin
         w_ok:=false;
         wb.CommaText:=w_xbib;
         wc.Clear;
         if w_xcclase<>'' then
            wc.CommaText:=w_xcclase;
         if (m[3]='DEL') or (m[3]='INS') or (m[3]='UPD') then
            wc.Insert(0,'TAB')
         else
            if m[3]<>'XXX' then
               wc.Insert(0,m[3]);
         if m[3]='XXX' then begin
            for j:=0 to wb.Count-1 do begin
               for k:=0 to wc.count-1 do begin                  // Busca en las clases alternas XC
                  if dm.sqlselect(dm.q1,'select * from tsprog '+
                     ' where cprog=' + g_q + m[5] + g_q +
                     ' and cbib=' + g_q + wb[j] + g_q +
                     ' and cclase=' + g_q + wc[k] + g_q +
                     ' and sistema=' + g_q + w_sistema_hijo + g_q) then begin
                     if dm.q1.RecordCount = 1 then begin
                        m[3] := dm.q1.fieldbyname('cclase').AsString;
                        m[4] := dm.q1.fieldbyname('cbib').AsString;
                        m[5] := dm.q1.fieldbyname('cprog').AsString;
                        w_ok:=true;
                        break;
                     end;
                  end
                  else begin
                     if dm.sqlselect(dm.q1, 'select distinct hcclase,hcbib from tsrela ' +
                        ' where hcprog=' + g_q + m[5] + g_q +
                        ' and hcbib=' + g_q + wb[j] + g_q +
                        ' and hcclase=' + g_q + wc[k] + g_q +
                        ' and ' +
                        ' (( lineainicio>0 and lineafinal>0) or (ambito=' + g_q + 'PUBLIC' + g_q + ')) ' +
                        ' and hsistema=' + g_q + w_sistema_hijo + g_q) then begin
                        if dm.q1.RecordCount = 1 then begin
                           m[3] := dm.q1.fieldbyname('hcclase').AsString;
                           m[4] := dm.q1.fieldbyname('hcbib').AsString;
                           m[5] := dm.q1.fieldbyname('hcprog').AsString;
                           w_ok:=true;
                           break;
                        end;
                     end;
                  end;
               end;
               if w_ok then
                  break;
               if dm.sqlselect(dm.q1,'select * from tsprog '+      // si no o encontró en las alternas lo busca entre todas
                  ' where cprog=' + g_q + m[5] + g_q +
                  ' and cbib=' + g_q + wb[j] + g_q +
                  ' and sistema=' + g_q + w_sistema_hijo + g_q) then begin
                  if dm.q1.RecordCount = 1 then begin
                     m[3] := dm.q1.fieldbyname('cclase').AsString;
                     m[4] := dm.q1.fieldbyname('cbib').AsString;
                     m[5] := dm.q1.fieldbyname('cprog').AsString;
                     w_ok:=true;
                     break;
                  end;
               end
               else begin
                  if dm.sqlselect(dm.q1, 'select distinct hcclase,hcbib from tsrela ' +
                     ' where hcprog=' + g_q + m[5] + g_q +
                     ' and hcbib=' + g_q + wb[j] + g_q +
                     ' and ' +
                     ' (( lineainicio>0 and lineafinal>0) or (ambito=' + g_q + 'PUBLIC' + g_q + ')) ' +
                     ' and hsistema=' + g_q + w_sistema_hijo + g_q) then begin
                     if dm.q1.RecordCount = 1 then begin
                        m[3] := dm.q1.fieldbyname('hcclase').AsString;
                        m[4] := dm.q1.fieldbyname('hcbib').AsString;
                        m[5] := dm.q1.fieldbyname('hcprog').AsString;
                        w_ok:=true;
                        break;
                     end;
                  end;
               end;
            end;
         end
         else begin        //   m[3]<>'XXX'
            for j:=0 to wb.Count-1 do begin
               for k:=0 to wc.count-1 do begin                  // Busca en las clases alternas XC
                  if dm.sqlselect(dm.q1,'select * from tsprog '+
                     ' where cprog=' + g_q + m[5] + g_q +
                     ' and cbib=' + g_q + wb[j] + g_q +
                     ' and cclase=' + g_q + wc[k] + g_q +
                     ' and sistema=' + g_q + w_sistema_hijo + g_q) then begin
                     if dm.q1.RecordCount = 1 then begin
                        if wc.count>1 then
                           m[3] := dm.q1.fieldbyname('cclase').AsString;
                        m[4] := dm.q1.fieldbyname('cbib').AsString;
                        m[5] := dm.q1.fieldbyname('cprog').AsString;
                        w_ok:=true;
                        break;
                     end;
                  end
                  else begin
                     if dm.sqlselect(dm.q1, 'select distinct hcclase,hcbib,hcprog from tsrela ' +
                        ' where hcprog=' + g_q + m[5] + g_q +
                        ' and hcbib=' + g_q + wb[j] + g_q +
                        ' and hcclase=' + g_q + wc[k] + g_q +
                        ' and ' +
                        ' (( lineainicio>0 and lineafinal>0) or (ambito=' + g_q + 'PUBLIC' + g_q + ')) ' +
                        ' and hsistema=' + g_q + w_sistema_hijo + g_q) then begin
                        if dm.q1.RecordCount = 1 then begin
                           if wc.count>1 then
                              m[3] := dm.q1.fieldbyname('hcclase').AsString;
                           m[4] := dm.q1.fieldbyname('hcbib').AsString;
                           m[5] := dm.q1.fieldbyname('hcprog').AsString;
                           w_ok:=true;
                           break;
                        end;
                     end;
                  end;
               end;
               if w_ok then
                  break;
            end;
         end;
      end;
      if m[4] = 'BD' then
         m[4] := 'SCRATCH';
      if (m[3] = 'XXX') then begin
         if (m[4] <> 'SCRATCH') then begin
            if (m[3] = 'XXX') and (pos('SCRATCH', m[4]) > 0) then begin
               if dm.sqlselect(dm.q1, 'select * from tsprog ' +
                  ' where cprog=' + g_q + m[5] + g_q +
                  ' and cbib like ' + g_q + stringreplace(m[4], 'SCRATCH', '%', [rfreplaceall]) + g_q +
                  ' and sistema=' + g_q + g_sistema_actual + g_q) then begin
                  if dm.q1.RecordCount = 1 then begin
                     m[3] := dm.q1.fieldbyname('cclase').AsString;
                     m[4] := dm.q1.fieldbyname('cbib').AsString;
                     m[5] := dm.q1.fieldbyname('cprog').AsString;
                  end;
               end
               else begin
                  if dm.sqlselect(dm.q1, 'select distinct hcclase,hcbib,hcprog from tsrela ' +
                     ' where hcprog=' + g_q + m[5] + g_q +
                     ' and hcbib like ' + g_q + stringreplace(m[4], 'SCRATCH', '%', [rfreplaceall]) + g_q +
                     ' and ' +
                     ' (( lineainicio>0 and lineafinal>0) or (ambito=' + g_q + 'PUBLIC' + g_q + ')) ' +
                     ' and hsistema=' + g_q + g_sistema_actual + g_q) then begin
                     if dm.q1.RecordCount = 1 then begin
                        m[3] := dm.q1.fieldbyname('hcclase').AsString;
                        m[4] := dm.q1.fieldbyname('hcbib').AsString;
                        m[5] := dm.q1.fieldbyname('hcprog').AsString;
                     end;
                  end;
               end;
            end
            else begin
               if dm.sqlselect(dm.q1, 'select * from tsprog ' +
                  ' where cprog=' + g_q + m[5] + g_q +
                  ' and cbib=' + g_q + m[4] + g_q) then begin
                  if dm.q1.RecordCount = 1 then begin
                     m[3] := dm.q1.fieldbyname('cclase').AsString;
                     m[5] := dm.q1.fieldbyname('cprog').AsString;
                  end;
               end
               else begin
                  if dm.sqlselect(dm.q1, 'select distinct hcclase,hcprog from tsrela ' +
                     ' where hcprog=' + g_q + m[5] + g_q +
                     ' and hcbib=' + g_q + m[4] + g_q +
                     ' and ' +
                     ' (( lineainicio>0 and lineafinal>0) or (ambito=' + g_q + 'PUBLIC' + g_q + ')) ' +
                     ' and hsistema=' + g_q + g_sistema_actual + g_q) then begin
                     if dm.q1.RecordCount = 1 then begin
                        m[3] := dm.q1.fieldbyname('hcclase').AsString;
                        m[5] := dm.q1.fieldbyname('hcprog').AsString;
                     end;
                  end;
               end;
            end;
         end
         else begin //  m[3]='XXX' m[4]='SCRATCH'
            if dm.sqlselect(dm.q1, 'select * from tsprog ' +
               ' where cprog=' + g_q + m[5] + g_q +
               ' and cbib<>' + g_q +'SCRATCH'+ g_q +
               ' and sistema=' + g_q + g_sistema_actual + g_q) then begin
               if dm.q1.RecordCount = 1 then begin
                  m[3] := dm.q1.fieldbyname('cclase').AsString;
                  m[4] := dm.q1.fieldbyname('cbib').AsString;
                  m[5] := dm.q1.fieldbyname('cprog').AsString;
               end;
            end
            else begin
               if dm.sqlselect(dm.q1, 'select distinct hcclase,hcbib,hcprog from tsrela ' +
                  ' where hcprog=' + g_q + m[5] + g_q +
                  ' and hcbib<>' + g_q +'SCRATCH'+ g_q +
                  ' and ' +
                  ' (( lineainicio>0 and lineafinal>0) or (ambito=' + g_q + 'PUBLIC' + g_q + ')) ' +
                  ' and hsistema=' + g_q + g_sistema_actual + g_q) then begin
                  if dm.q1.RecordCount = 1 then begin
                     m[3] := dm.q1.fieldbyname('hcclase').AsString;
                     m[4] := dm.q1.fieldbyname('hcbib').AsString;
                     m[5] := dm.q1.fieldbyname('hcprog').AsString;
                  end;
               end;
            end;
         end;
      end
      else begin // m[3]<>'XXX'
         if (m[4] = 'SCRATCH') then begin // actualiza componentes SCRATCH
            ucla := m[3];
            if (ucla = 'INS') or (ucla = 'UPD') or (ucla = 'DEL') then
               ucla := 'TAB';
            if dm.sqlselect(dm.q1, 'select * from tsprog ' + // busca nombre de componente y mismo tipo
               ' where cprog=' + g_q + m[5] + g_q +
               ' and cbib<>' + g_q + 'SCRATCH' + g_q +
               ' and   cclase=' + g_q + ucla + g_q +
               ' and sistema=' + g_q + g_sistema_actual + g_q) then begin
               if dm.q1.RecordCount = 1 then begin
                  m[4] := dm.q1.fieldbyname('cbib').AsString;
                  m[5] := dm.q1.fieldbyname('cprog').AsString;
               end
               else begin
                  if dm.sqlselect(dm.q1, 'select * from tsprog ' + // cuando está en más de una biblioteca, busca igual al del padre
                     ' where cprog=' + g_q + m[5] + g_q +
                     // ' and cbib='+g_q+biblioteca+g_q+
                     ' and (cbib=' + g_q + biblioteca + g_q + ' or sistema=' + g_q + g_sistema_actual + g_q + ')' +
                     ' and   cclase=' + g_q + ucla + g_q +
                     ' and sistema=' + g_q + g_sistema_actual + g_q) then begin
                     m[4] := dm.q1.fieldbyname('cbib').AsString;
                     m[5] := dm.q1.fieldbyname('cprog').AsString;
                  end;
               end;
            end
            else begin
               es_del:=false;
               if m[3]='DEL' then begin
                  nclase:=m[3];
                  nbib:=m[4];
                  nprog:=m[5];
                  if concilia_del(w_xcclase,w_sistema_hijo, nclase,nbib,nprog) then begin
                     es_del:=true;
                     m[3]:=nclase;
                     m[4]:=nbib;
                     m[5]:=nprog;
                  end;
               end;
               if es_del=false then begin
                  if (trim(w_xcclase) <> '') and (dm.sqlselect(dm.q1, 'select * from tsprog ' + // busca nombre de componente y tipo alternativo XCCLASE
                     ' where cprog=' + g_q + m[5] + g_q +
                     ' and cbib<>' + g_q + 'SCRATCH' + g_q +
                     ' and   cclase in (' + g_q + stringreplace(w_xcclase, ',', g_q + ',' + g_q, [rfreplaceall]) + g_q + ')')) then begin
                     if dm.q1.RecordCount = 1 then begin
                        m[3] := dm.q1.fieldbyname('cclase').AsString;
                        m[4] := dm.q1.fieldbyname('cbib').AsString;
                        m[5] := dm.q1.fieldbyname('cprog').AsString;
                     end
                     else begin
                        if dm.sqlselect(dm.q1, 'select * from tsprog ' + // cuando está en más de una biblioteca, busca igual al del padre
                           ' where cprog=' + g_q + m[5] + g_q +
                        // ' and cbib='+g_q+biblioteca+g_q+
                           ' and (cbib=' + g_q + biblioteca + g_q + ' or sistema=' + g_q + g_sistema_actual + g_q + ')' +
                           ' and   cclase in (' + g_q + stringreplace(w_xcclase, ',', g_q + ',' + g_q, [rfreplaceall]) + g_q + ')') then begin
                           m[3] := dm.q1.fieldbyname('cclase').AsString;
                           m[4] := dm.q1.fieldbyname('cbib').AsString;
                           m[5] := dm.q1.fieldbyname('cprog').AsString;
                        end;
                     end;
                  end
                  else
               {   se agrega busqueda en TSRELA porque el TAB viene en el schema, pero en general para cualquier tipo           }
                     if dm.sqlselect(dm.q1, 'select distinct hcbib,hcprog from tsrela ' + // busca nombre de componente y mismo tipo
                        ' where hcprog=' + g_q + m[5] + g_q +
                        ' and ' +
                        ' (( lineainicio>0 and lineafinal>0) or (ambito=' + g_q + 'PUBLIC' + g_q + ')) ' +
                        ' and   hcclase=' + g_q + ucla + g_q +
                        ' and   hsistema=' + g_q + g_sistema_actual + g_q) then begin
                        if dm.q1.RecordCount = 1 then begin
                           m[4] := dm.q1.fieldbyname('hcbib').AsString;
                           m[5] := dm.q1.fieldbyname('hcprog').AsString;
                        end
                        else begin
                           if b_otros_sistemas then begin
                              if dm.sqlselect(dm.q1, 'select distinct hcbib,hcprog from tsrela ' + // busca nombre de componente y mismo tipo
                                 ' where hcprog=' + g_q + m[5] + g_q +
                                 ' and ' +
                                 ' (( lineainicio>0 and lineafinal>0) or (ambito=' + g_q + 'PUBLIC' + g_q + ')) ' +
                                 ' and   hcclase=' + g_q + ucla + g_q) then begin
                                 if dm.q1.RecordCount = 1 then begin
                                    m[4] := dm.q1.fieldbyname('hcbib').AsString;
                                    m[5] := dm.q1.fieldbyname('hcprog').AsString;
                                 end;
                              end;
                           end;
                        end;
                     end
                     else
                        if (trim(w_xcclase) <> '') and (dm.sqlselect(dm.q1, 'select distinct pcbib,pcclase,pcprog from tsrela ' + // busca nombre de componente y tipo alternativo xcclase
                           ' where pcprog=' + g_q + m[5] + g_q +
                           ' and   pcbib<>' + g_q + 'SCRATCH' + g_q +
                           ' and   pcclase in (' + g_q + stringreplace(w_xcclase, ',', g_q + ',' + g_q, [rfreplaceall]) + g_q + ')')) then begin
                           if dm.q1.RecordCount = 1 then begin
                              m[3] := dm.q1.fieldbyname('pcclase').AsString;
                              m[4] := dm.q1.fieldbyname('pcbib').AsString;
                              m[5] := dm.q1.fieldbyname('pcprog').AsString;
                           end
                           else begin
                              if dm.sqlselect(dm.q1, 'select distinct pcbib,pcclase,pcprog from tsrela ' + // cuando está en más de una biblioteca, busca igual al del padre
                                 ' where pcprog=' + g_q + m[5] + g_q +
                        // ' and cbib='+g_q+biblioteca+g_q+
                                 ' and (pcbib=' + g_q + biblioteca + g_q + ' or sistema=' + g_q + g_sistema_actual + g_q + ')' +
                                 ' and   pcclase in (' + g_q + stringreplace(w_xcclase, ',', g_q + ',' + g_q, [rfreplaceall]) + g_q + ')') then begin
                                 m[3] := dm.q1.fieldbyname('pcclase').AsString;
                                 m[4] := dm.q1.fieldbyname('pcbib').AsString;
                                 m[5] := dm.q1.fieldbyname('pcprog').AsString;
                              end;
                           end;
                        end
                        else begin
                  //w_polimorfismo := '';
                           if w_polimorfismo = '' then
                              q_polimorfismo := ' IS NULL'
                           else
                              q_polimorfismo := '=' + g_q + w_polimorfismo + g_q;
                           if dm.sqlselect(dm.q1, 'select distinct hcbib,hcprog from tsrela ' + // Expansion de TSRELA 20131107
                              ' where hcprog=' + g_q + m[5] + g_q +
                              ' and   hcbib<>' + g_q + 'SCRATCH' + g_q +
                              ' and   hcclase=' + g_q + m[3] + g_q +
                              ' and   ambito=' + g_q + 'PUBLIC' + g_q +
                              ' and   polimorfismo' + q_polimorfismo +
                              ' and   sistema=' + g_q + g_sistema_actual + g_q +
                              ' and   hcbib=' + g_q + biblioteca + g_q) then begin
                              m[4] := dm.q1.fieldbyname('hcbib').AsString;
                              m[5] := dm.q1.fieldbyname('hcprog').AsString;
                           end
                           else if dm.sqlselect(dm.q1, 'select distinct hcbib,hcprog from tsrela ' + // Expansion de TSRELA 20131107
                              ' where hcprog=' + g_q + m[5] + g_q +
                              ' and   hcbib<>' + g_q + 'SCRATCH' + g_q +
                              ' and   hcclase=' + g_q + m[3] + g_q +
                              ' and   ambito=' + g_q + 'PUBLIC' + g_q +
                              ' and   polimorfismo' + q_polimorfismo +
                              ' and   sistema=' + g_q + g_sistema_actual + g_q) then begin
                              m[4] := dm.q1.fieldbyname('hcbib').AsString;
                              m[5] := dm.q1.fieldbyname('hcprog').AsString;
                           end
                           else if dm.sqlselect(dm.q1, 'select distinct hcbib,hcprog from tsrela ' + // Expansion de TSRELA 20131107
                              ' where hcprog=' + g_q + m[5] + g_q +
                              ' and   hcbib<>' + g_q + 'SCRATCH' + g_q +
                              ' and   hcclase=' + g_q + m[3] + g_q +
                              ' and   ambito=' + g_q + 'PUBLIC' + g_q +
                              ' and   polimorfismo' + q_polimorfismo) then begin
                              m[4] := dm.q1.fieldbyname('hcbib').AsString;
                              m[5] := dm.q1.fieldbyname('hcprog').AsString;
                           end
                           else if dm.sqlselect(dm.q1, 'select distinct hcbib,hcprog from tsrela ' + // Expansion de TSRELA 20131107
                              ' where hcprog=' + g_q + m[5] + g_q +
                              ' and   hcbib<>' + g_q + 'SCRATCH' + g_q +
                              ' and   hcclase=' + g_q + m[3] + g_q +
                              ' and   ambito=' + g_q + 'PUBLIC' + g_q) then begin
                              m[4] := dm.q1.fieldbyname('hcbib').AsString;
                              m[5] := dm.q1.fieldbyname('hcprog').AsString;
                           end
                           else begin
                              if m[3] = 'XXX' then begin // busca por el nombre y sustituye biblioteca y clase
                                 if dm.sqlselect(dm.q1, 'select * from tsprog ' +
                                    ' where cprog=' + g_q + m[5] + g_q +
                                    ' and cbib<>' + g_q + 'SCRATCH' + g_q) then begin
                                    if dm.q1.RecordCount = 1 then begin
                                       m[4] := dm.q1.fieldbyname('cbib').AsString;
                                       m[3] := dm.q1.fieldbyname('cclase').AsString;
                                       m[5] := dm.q1.fieldbyname('cprog').AsString;
                                    end;
                                 end;
                              end;                       // revisar, el siguiente código es obsoleto. Las ETP se validan por lineafinal>0 igual que las demás clases RGM20140604
                              if m[3] = 'ETP' then begin // procesa entry points
                                 if dm.sqlselect(dm.q1, 'select distinct hcbib,hcprog from tsrela ' +
                                    ' where hcprog=' + g_q + m[5] + g_q +
                                    ' and   hcbib<>' + g_q + 'SCRATCH' + g_q +
                                    ' and   pcprog=ocprog ' + //RGM20130220
                                    ' and   sistema=' + g_q + g_sistema_actual + g_q + //RGM20130220
                                    ' and   hcclase=' + g_q + 'ETP' + g_q) then begin
                                    m[4] := dm.q1.fieldbyname('hcbib').AsString;
                                    m[5] := dm.q1.fieldbyname('hcprog').AsString;
                                 end;
                        {
                        if dm.sqlselect(dm.q1,'select distinct pcbib from tsrela '+
                           ' where pcprog='+g_q+m[5]+g_q+
                           ' and   pcclase='+g_q+'ETP'+g_q) then begin
                           m[4]:=dm.q1.fieldbyname('pcbib').AsString;
                        end;
                        }
                              end;
                              if m[3] = 'BFR' then begin // procesa pantallas, reemplaza nombre de FRM por el interno
                                 if dm.sqlselect(dm.q1, 'select distinct pcbib,pcprog from tsrela ' +
                                    ' where hcprog=' + g_q + m[5] + g_q +
                                    ' and   hcclase=' + g_q + 'ETP' + g_q +
                                    ' and   pcclase=' + g_q + 'BFR' + g_q) then begin
                                    m[4] := dm.q1.fieldbyname('pcbib').AsString;
                                    m[5] := dm.q1.fieldbyname('pcprog').AsString;
                                 end;
                              end;
                           end;
                        end;
               end;
            end;
         end
         else begin
            if pos('SCRATCH', m[1]) > 0 then begin // Nombres parciales de biblioteca, busca y actualiza
               if dm.sqlselect(dm.q1, 'select distinct pcbib,sistema from tsrela ' + // busca nombre de componente y mismo tipo
                  ' where pcprog=' + g_q + m[2] + g_q +
                  ' and   pcbib like ' + g_q + stringreplace(m[1], 'SCRATCH', '%', [rfreplaceall]) + g_q +
                  ' and   pcclase=' + g_q + m[0] + g_q) then begin
                  while not dm.q1.Eof do begin
                     if pos('SCRATCH', dm.q1.fieldbyname('pcbib').AsString) = 0 then begin
                        m[1] := dm.q1.fieldbyname('pcbib').AsString;
                        if g_sistema_actual = dm.q1.FieldByName('sistema').AsString then
                           break;
                     end;
                     dm.q1.Next;
                  end;
               end;
            end;
            if pos('SCRATCH', m[4]) > 0 then begin // Nombres parciales de biblioteca, busca y actualiza
               if dm.sqlselect(dm.q1, 'select distinct hcbib,hcprog,sistema from tsrela ' + // busca nombre de componente y mismo tipo
                  ' where hcprog=' + g_q + m[5] + g_q +
                  ' and   hcbib like ' + g_q + stringreplace(m[4], 'SCRATCH', '%', [rfreplaceall]) + g_q +
                  ' and   hcclase=' + g_q + m[3] + g_q) then begin
                  while not dm.q1.Eof do begin
                     if pos('SCRATCH', dm.q1.fieldbyname('hcbib').AsString) = 0 then begin
                        m[4] := dm.q1.fieldbyname('hcbib').AsString;
                        m[5] := dm.q1.fieldbyname('hcprog').AsString;
                        if g_sistema_actual = dm.q1.FieldByName('sistema').AsString then
                           break;
                     end;
                     dm.q1.Next;
                  end;
               end;
            end;
         end;
      end;
      //      if (owner_tipo='NCP') and (m[3]='NSS') then begin   // Natural Subrutinas dentro de un Copy
      if (m[3] = 'NSS') then begin // Natural Subrutinas
         dm.sqldelete('delete from tsrela ' +
            ' where hcprog=' + g_q + m[5] + g_q +
            ' and   hcbib=' + g_q + 'SCRATCH' + g_q +
            ' and   hcclase=' + g_q + 'NSR' + g_q +
            ' and   (pcprog,pcbib,pcclase) in ' +
            '  (select pcprog,pcbib,pcclase from tsrela ' + // la rutina es hermana
            '   where hcprog=' + g_q + programa + g_q +
            '   and   hcbib=' + g_q + biblioteca + g_q +
            '   and   hcclase=' + g_q + clase + g_q + ')');
         dm.sqldelete('delete from tsrela ' +
            ' where hcprog=' + g_q + m[5] + g_q +
            ' and   hcbib=' + g_q + 'SCRATCH' + g_q +
            ' and   hcclase=' + g_q + 'NSR' + g_q +
            ' and   (pcprog,pcbib,pcclase) in ' +
            '  (select hcprog,hcbib,hcclase from tsrela ' + // la rutina es nieta
            '   where pcprog=' + g_q + programa + g_q +
            '   and   pcbib=' + g_q + biblioteca + g_q +
            '   and   pcclase=' + g_q + clase + g_q + ')');
      end;
      if (m[4] = 'SCRATCH') and (m[3] = 'NSR') then begin // Busca subrutina en algún copy
         if dm.sqlselect(dm.q1, 'select * from tsrela ' +
            ' where hcprog=' + g_q + m[5] + g_q +
            ' and   hcbib=' + g_q + 'SCRATCH' + g_q +
            ' and   hcclase=' + g_q + 'NSS' + g_q +
            ' and   (pcprog,pcbib,pcclase) in ' +
            '  (select hcprog,hcbib,hcclase from tsrela ' + // la rutina es nieta
            '   where pcprog=' + g_q + programa + g_q +
            '   and   pcbib=' + g_q + biblioteca + g_q +
            '   and   pcclase=' + g_q + clase + g_q +
            '   )') then
            continue;
         if dm.sqlselect(dm.q1, 'select * from tsrela ' +
            ' where hcprog=' + g_q + m[5] + g_q +
            ' and   hcbib=' + g_q + 'SCRATCH' + g_q +
            ' and   hcclase=' + g_q + 'NSS' + g_q +
            ' and   (pcprog,pcbib,pcclase) in ' +
            '  (select pcprog,pcbib,pcclase from tsrela ' + // la subrutina es hermana
            '   where hcprog=' + g_q + programa + g_q +
            '   and   hcbib=' + g_q + biblioteca + g_q +
            '   and   hcclase=' + g_q + clase + g_q +
            '   )') then
            continue;
      end;
      if (owner_tipo <> 'FMB') and
         (owner_tipo <> 'FRM') and
         (owner_tipo <> 'PCK') and
         (owner_tipo <> 'PSQ') then begin
         clase := m[0];
         if m[1] <> 'SCRATCH' then
            bibli := m[1] // antes reemplazaba biblioteca
         else begin
            if (m[0]=owner_tipo) and (m[2]=owner_prg) then   // si es clase y nombre del owner
               bibli := biblioteca
            else
               bibli:=m[1];
         end;
         programa := m[2];
      end;

      if (w_lineainicio='0') and (w_lineafinal<>'0') then begin    // actualiza linea final
         if dm.sqlselect(dm.q1,'select * from tsrela '+
            '   where pcprog=' + g_q + programa + g_q +
            '   and   pcbib=' + g_q + bibli + g_q +
            '   and   pcclase=' + g_q + clase + g_q +
            '   and   hcprog=' + g_q + m[5] + g_q +
            '   and   hcbib=' + g_q + m[4] + g_q +
            '   and   hcclase=' + g_q + m[3] + g_q +
            '   and   lineainicio<'+w_lineafinal+
            '   and   lineafinal=999999')=false then
            continue;
         dm.sqlupdate('update tsrela '+
            ' set lineafinal='+w_lineafinal+
            '   where pcprog=' + g_q + programa + g_q +
            '   and   pcbib=' + g_q + bibli + g_q +
            '   and   pcclase=' + g_q + clase + g_q +
            '   and   hcprog=' + g_q + m[5] + g_q +
            '   and   hcbib=' + g_q + m[4] + g_q +
            '   and   hcclase=' + g_q + m[3] + g_q +
            '   and   lineainicio<'+w_lineafinal+
            '   and   lineafinal=999999');
         continue;
      end;

      sele := 'insert into tsrela (pcprog,pcbib,pcclase,hcprog,hcbib,hcclase,modo,' +
         'organizacion,externo,coment,orden,sistema,ocprog,ocbib,occlase,lineainicio,lineafinal,ambito,icprog,icbib,icclase,' +
         'polimorfismo,xcclase,hsistema,hparametros,hinterfase) ' +
         ' values(' +
         g_q + programa + g_q + ',' +
         g_q + bibli + g_q + ',' +
         g_q + clase + g_q + ',' +
         g_q + m[5] + g_q + ',' +
         g_q + m[4] + g_q + ',' +
         g_q + m[3] + g_q + ',' +
         g_q + m[7] + g_q + ',' +
         g_q + m[8] + g_q + ',' +
         g_q + m[9] + g_q + ',' +
         g_q + m[10] + g_q + ',' +
         g_q + m[11] + g_q + ',' +
         g_q + g_sistema_actual + g_q + ',' +
         g_q + owner_prg + g_q + ',' +
         g_q + biblioteca + g_q + ',' +
         g_q + owner_tipo + g_q + ',' +
         w_lineainicio + ',' +
         w_lineafinal + ',' +
         g_q + w_ambito + g_q + ',' +
         g_q + w_icprog + g_q + ',' +
         g_q + w_icbib + g_q + ',' +
         g_q + w_icclase + g_q + ',' +
         g_q + w_polimorfismo + g_q + ',' +
         g_q + w_xcclase + g_q + ',' +
         g_q + w_sistema_hijo + g_q + ',' +
         g_q + w_parametros + g_q + ',' +
         g_q + w_interfase + g_q + ')';
      if dm.sqlinsert(sele) = false then begin
         g_log.Add('analiza_componente|' + clase + '|' + biblioteca + '|' + programa +
            '|ERROR... no puede insertar en TSRELA:' + sele);
         analiza_componente := false;
         exit;
      end;
      if (clase='TSP') and (m[3]='OBY') then begin   // TANDEM Server  TSP->OBY->TSE
         dm.sqlupdate('update tsrela set pcbib='+g_q+programa+g_q+
            ' where ocprog='+g_q+m[5]+g_q+
            ' and   occlase='+g_q+'OBY'+g_q+
            ' and   pcclase='+g_q+'TSE'+g_q+
            ' and   pcbib='+g_q+'SCRATCH'+g_q);
         dm.sqlupdate('update tsrela set hcbib='+g_q+programa+g_q+
            ' where ocprog='+g_q+m[5]+g_q+
            ' and   occlase='+g_q+'OBY'+g_q+
            ' and   hcclase='+g_q+'TSE'+g_q+
            ' and   hcbib='+g_q+'SCRATCH'+g_q);
         dm.sqlupdate('update tsrela set pcprog='+g_q+programa+g_q+
            ' where ocprog='+g_q+m[5]+g_q+
            ' and   occlase='+g_q+'OBY'+g_q+
            ' and   pcclase='+g_q+'TSP'+g_q+
            ' and   pcprog='+g_q+'SCRATCH'+g_q);
      end;
      concilia_hcbib(clase, bibli, programa, g_sistema_actual);
      if m[10]='GETENV' then
         reemplaza_var_ambiente(owner_tipo,biblioteca,owner_prg,m[3],m[4],m[5]);
      if clase='VAR' then
         b_tiene_var:=true;
      //padre_igual_owner:=((programa=owner_prg) and (bibli=biblioteca) and (clase=owner_tipo));
      padre_igual_owner := ((strtoint(w_lineainicio) > 0) and (strtoint(w_lineafinal) > 0));
      if padre_igual_owner then
         concilia_hcbib(m[3], m[4], m[5], g_sistema_actual);
      {
      if w_where<>'' then
         dm.sqlupdate('update tsrela set lineafinal='+inttostr(strtoint(w_lineainicio)-1)+' where '+w_where);
      if w_lineafinal='999999' then begin
         w_where:=' pcprog='+g_q + programa + g_q + ',' +
            ' and pcbib='+g_q + bibli + g_q + ',' +
            ' and pcclase='+g_q + clase + g_q + ',' +
            ' and hcprog='+g_q + m[ 5 ] + g_q + ',' +
            ' and hcbib='+g_q + m[ 4 ] + g_q + ',' +
            ' and hcclase='+g_q + m[ 3 ] + g_q + ',' +
            ' and orden='+g_q + m[ 11 ] + g_q + ',' +
            ' and ocprog='+g_q + owner_prg + g_q + ',' +
            ' and ocbib='+g_q + biblioteca + g_q + ',' +
            ' and occlase='+g_q + owner_tipo + g_q;
      end
      else
         w_where:='';
      }
      if (clase = 'NLC') and (m[3] = 'LOC') then begin // Local Natural actualiza vistas de adabas
         dm.sqlupdate('update tsrela set hcprog=' + g_q + m[5] + g_q +
            ' where (pcprog,pcbib,pcclase) in ' +
            ' ( select pcprog,pcbib,pcclase from tsrela ' +
            '   where hcprog=' + g_q + programa + g_q +
            '   and   hcbib=' + g_q + biblioteca + g_q +
            '   and   hcclase=' + g_q + clase + g_q +
            '   and   pcclase in (' + g_q + 'NAT' + g_q + ',' + g_q + 'NSP' + g_q + ',' + g_q + 'NSR' + g_q + ')' +
            '  ) ' +
            ' and   hcclase in (' + g_q + 'NVW' + g_q + ',' + g_q + 'NUP' + g_q + ',' + g_q + 'NIN' + g_q + ',' + g_q + 'NDL' + g_q + ')' +
            ' and   externo=' + g_q + m[9] + g_q);
      end;
   end;
   if b_tiene_var then
      reemplaza_var_en_hijos(clase,biblioteca,programa);
   m.Free;
   wb.free;
   wc.Free;
   analiza_componente := true;
end;

function recibeclick(compos: Tstrings; origen: string;
   cmboficina_text, cmbsistema_text, cmbclase_text,
   cmbbiblioteca_text, txtsufijo_text, txtextra_text: string;
   chktodas_checked, chkruta_checked, chkextra_checked, chkexiste_checked,
   chkversion_checked, chkanaliza_checked, chkextension_checked,
   chkproduccion_checked, chkverifica_checked, chknombre_version_checked,
   yextra_Visible, chkparams_checked, chkcopys_checked: boolean;
   rgnombre_itemindex: integer;
   dir_directory,
   cla_tipo,
   herramienta: string;
   barra: Tprogressbar;
   rxfc: Tstrings;
   reemplaza1, reemplaza2: string): boolean;
var
   i: integer;
   anterior, este, magic, nblob, fecha, idversion: string;
   analizador, reservadas, directivas, qcomponente, copiado: string;
   fmbanalizador: string;
   inicio: Tdatetime;
   dire: Tstringlist;
   colini, colfin, mens: string;
   extrapars: string;
   b_extra: boolean;
   verdad: string;
   basenombre: string; // para shell UNIX
   oocprog, oocbib, oocclase, oocoment: string; // para herencia
   ocprog, ocbib, occlase: string;
   w_polimorfismo: string;
   directorio_origen: string;
   oracledir, path: string;
   nombre_version: string;
   politica_componente_identico, politica_version_anterior: string;
   rxfuente: Tstringlist;
   chkcopys_analizador, chkcopys_directivas: string;
   nombre_fisico:string;
   inst : string;  // ALK para poder probar por fuera
   rgmlang, complejidad, dirCBL, dirCMA, res : String;   // ALK para complejidad

   //............................................................
   procedure actualiza_lineas_final(cprog, cbib, cclase: string);
   var final: integer;
   begin
      final := 999999;
      if dm.sqlselect(dm.q1, 'select lineas_total from tsproperty ' +
         ' where cprog=' + g_q + cprog + g_q +
         ' and   cbib=' + g_q + cbib + g_q +
         ' and   cclase=' + g_q + cclase + g_q) then
         final := dm.q1.fieldbyname('lineas_total').AsInteger;
      if dm.sqlselect(dm.q1, 'select * from tsrela ' +
         ' where ocprog=' + g_q + cprog + g_q +
         ' and   ocbib=' + g_q + cbib + g_q +
         ' and   occlase=' + g_q + cclase + g_q +
         ' and   lineafinal=999999' +
         ' order by orden desc') then begin
         while not dm.q1.Eof do begin
            dm.sqlupdate('update tsrela set lineafinal=' + inttostr(final) +
               ' where ocprog=' + g_q + cprog + g_q +
               ' and   ocbib=' + g_q + cbib + g_q +
               ' and   occlase=' + g_q + cclase + g_q +
               ' and   pcprog=' + g_q + dm.q1.fieldbyname('pcprog').AsString + g_q +
               ' and   pcbib=' + g_q + dm.q1.fieldbyname('pcbib').AsString + g_q +
               ' and   pcclase=' + g_q + dm.q1.fieldbyname('pcclase').AsString + g_q +
               ' and   hcprog=' + g_q + dm.q1.fieldbyname('hcprog').AsString + g_q +
               ' and   hcbib=' + g_q + dm.q1.fieldbyname('hcbib').AsString + g_q +
               ' and   hcclase=' + g_q + dm.q1.fieldbyname('hcclase').AsString + g_q +
               ' and   orden=' + g_q + dm.q1.fieldbyname('orden').AsString + g_q +
               ' and   lineafinal=999999');
            final := dm.q1.fieldbyname('lineainicio').AsInteger - 1;
            dm.q1.Next;
         end;
      end;
   end;
   //...................................................
   function nombre_componente(nombre: string): string;
   var
      nom: string;
   begin
      if copy(nombre, 1, 5) = 'ROOT\' then
         nombre := '\' + copy(nombre, 6, 500);
      if chkextension_Checked = false then begin
         if chkruta_Checked then
            nom := changefileext(nombre, '')
         else
            nom := changefileext(extractfilename(nombre), '');
      end
      else begin
         if chkruta_Checked then
            nom := nombre
         else
            nom := extractfilename(nombre);
      end;
      if reemplaza1 <> '' then
         nom := stringreplace(nom, reemplaza1, reemplaza2, [rfreplaceall]);
      case rgnombre_ItemIndex of
         0: begin
               iHelpContext := IDH_TOPIC_T01726;
            end;
         1: begin
               nom := lowercase(nom);
               iHelpContext := IDH_TOPIC_T01731;
            end;
         2: begin
               nom := uppercase(nom);
               iHelpContext := IDH_TOPIC_T01728;
            end;
      end;
      nombre_version := '';
      if chknombre_version_Checked then begin
         nombre_version := nom;
         while pos('_', nombre_version) > 0 do
            nombre_version := copy(nombre_version, pos('_', nombre_version) + 1, 500);
         if nombre_version = nom then
            nombre_version := ''
         else
            nom := copy(nom, 1, length(nom) - length(nombre_version) - 1);
      end;
      nombre_componente := nom;
   end;
   //..........................................................................
   function verifica_archivo(k: integer; nombre: string; mensaje: string): boolean;
   var j: integer;
      bok: array of boolean;
      ext, nuevo, mensaje2: string;
   begin
      if fileexists(nombre) = false then begin
         if origen = 'ptsrecibe' then begin
            showmessage('ERROR... no existe el archivo ' + nombre);
            abort;
         end
         else begin
            inserta_tslog(nombre_componente(nombre), 'verifica_archivo', 'REC001', 'ERROR... no existe el archivo ' + nombre, 'ERROR');
            verifica_archivo := false;
            exit;
         end;
      end;
      rxfuente.LoadFromFile(nombre);
      setlength(bok, k);
      for j := 0 to k - 1 do
         bok[j] := false;
      for j := 0 to rxfuente.Count - 1 do begin
         if cmbclase_Text = 'COS' then begin // Tarjetas COSORT
            if pos('/INFILE', uppercase(rxfuente[j])) > 0 then
               bok[0] := true;
            if pos('/OUTFILE', uppercase(rxfuente[j])) > 0 then
               bok[1] := true;
         end;
      end;
      for j := 0 to k - 1 do begin
         if bok[j] = false then begin
            if origen <> 'ptsrecibe' then begin
               verifica_archivo := false;
               exit;
            end;
            while true do begin
               case application.MessageBox(pchar('Componente ' + nombre + chr(13) +
                  mensaje + chr(13) + 'Desea cambiar la extensión del componente?'),
                  'Confirme', MB_YESNOCANCEL) of
                  IDYES: begin
                        ext := extractfileext(nombre);
                        if trim(ext) = '' then
                           ext := '.';
                        ext := inputbox('Capture', 'Nueva extensión', ext);
                        if copy(ext, 1, 1) <> '.' then
                           ext := '.' + ext;
                        nuevo := changefileext(nombre, ext);
                        if fileexists(nuevo) then begin
                           showmessage('El archivo ' + nuevo + ' ya existe');
                        end
                        else begin
                           renamefile(nombre, nuevo);
                           verifica_archivo := false;
                           exit;
                        end;
                     end;
                  IDCANCEL: begin
                     //ftsrecibe.Enabled := true;
                     //screen.Cursor := crdefault;
                        abort;
                     end;
                  IDNO: begin
                        verifica_archivo := true;
                        exit;
                     end;
               end;
            end;
         end;
      end;
      verifica_archivo := true;
      exit;
   end;
   //.............................
   function cambios_clase: boolean;
   var i, k: integer;
      nombre: string;
      b_cambios: boolean;
      mensaje: string;
   begin
      b_cambios := false;
      if cmbclase_Text = 'COS' then begin // Tarjetas COSORT
         k := 2;
         mensaje := 'No tiene comandos /INFILE o /OUTFILE';
      end;
      i := 0;
      while i < compos.Count do begin
         nombre := compos[i];
         if trim(nombre) = '' then
            continue;
         if verifica_archivo(k, nombre, mensaje) = false then begin // Se cambió alguna extensión(linea) o un archivo es invalido(batch)
            b_cambios := true;
            if origen <> 'ptsrecibe' then begin
               compos.Delete(i);
               i := i - 1;
            end;
         end;
         inc(i);
      end;
      cambios_clase := b_cambios;
   end;
   //..................................................................
   procedure tsparams_job_jcl(job: string; bib: string; clase: string;
      jcl: string; jbib: string; jclase: string);
   var
      dato, par, par2: string;
   begin
      if dm.sqlselect(dm.q2, 'select * from tsrela ' + // busca hijos del JCL con parametros
         ' where ocprog=' + g_q + jcl + g_q +
         ' and   ocbib=' + g_q + jbib + g_q +
         ' and   occlase=' + g_q + jclase + g_q +
         ' and   hcprog like ' + g_q + '%&%' + g_q) then begin
         while not dm.q2.Eof do begin
            dato := dm.q2.fieldbyname('hcprog').AsString;
            while pos('&', dato) > 0 do begin // reemplaza parametros
               par := copy(dato, pos('&', dato), 500);
               if pos('.', par) > 0 then // a veces el parametro no termina con punto
                  par := copy(par, 1, pos('.', par));
               par2 := stringreplace(copy(par, 2, 500), '.', '', []);
               if dm.sqlselect(dm.q3, 'select valor from tsparams ' +
                  ' where cprog=' + g_q + job + g_q +
                  ' and   cbib=' + g_q + bib + g_q +
                  ' and   cclase=' + g_q + clase + g_q +
                  ' and   param=' + g_q + par2 + g_q) then begin
                  dato := stringreplace(dato, par, dm.q3.fieldbyname('valor').AsString, [rfreplaceall]);
               end
               else begin
                  dato := '';
               end;
            end; // inserta copia de registro con propietario JOB
            if trim(dato) <> '' then begin
               dm.sqlinsert('insert into tsrela (pcprog,pcbib,pcclase,hcprog,hcbib,hcclase,' +
                  'modo,organizacion,externo,coment,orden,ocprog,ocbib,occlase,sistema,hsistema,hparametros,hinterfase) values(' +
                  g_q + dm.q2.fieldbyname('pcprog').AsString + g_q + ',' +
                  g_q + dm.q2.fieldbyname('pcbib').AsString + g_q + ',' +
                  g_q + dm.q2.fieldbyname('pcclase').AsString + g_q + ',' +
                  g_q + dato + g_q + ',' +
                  g_q + dm.q2.fieldbyname('hcbib').AsString + g_q + ',' +
                  g_q + dm.q2.fieldbyname('hcclase').AsString + g_q + ',' +
                  g_q + dm.q2.fieldbyname('modo').AsString + g_q + ',' +
                  g_q + dm.q2.fieldbyname('organizacion').AsString + g_q + ',' +
                  g_q + dm.q2.fieldbyname('externo').AsString + g_q + ',' +
                  g_q + dm.q2.fieldbyname('coment').AsString + g_q + ',' +
                  g_q + dm.q2.fieldbyname('orden').AsString + g_q + ',' +
                  g_q + job + g_q + ',' +
                  g_q + bib + g_q + ',' +
                  g_q + clase + g_q + ',' +
                  g_q + dm.q2.fieldbyname('sistema').AsString + g_q + ',' +
                  g_q + dm.q2.fieldbyname('hsistema').AsString + g_q + ',' +
                  g_q + dm.q2.fieldbyname('hparametros').AsString + g_q + ',' +
                  g_q + dm.q2.fieldbyname('hinterfase').AsString + g_q + ')');
            end;
            dm.q2.Next;
         end;
      end;
   end;
   //..................................................................
   procedure tsparams_job(job: string; bib: string; copiado: string);
   var
      directivas, analizador, nuevo, salida, valor: string;
      lista, pp: Tstringlist;
      i: integer;
   begin
      directivas := g_tmpdir + '\hta452345'; // ejecuta herramienta para extraer parámetros
      if fileexists(directivas) = false then
         ptscomun.get_utileria('PARAMS.DIR', directivas, (origen = 'ptsrecibe'));
      analizador := g_tmpdir + '\hta3214444.exe';
      if fileexists(analizador) = false then
         ptscomun.get_utileria('RGMLANG', analizador, (origen = 'ptsrecibe'));
      nuevo := g_tmpdir + '\nada1234';
      salida := g_tmpdir + '\nada4444';
      g_borrar.Add(directivas);
      g_borrar.Add(analizador);
      g_borrar.Add(nuevo);
      g_borrar.Add(salida);
      ptscomun.ejecuta_espera(analizador + ' "' + copiado + '" ' + nuevo + ' ' + directivas + ' >' + salida, SW_HIDE);
      lista := Tstringlist.Create;
      pp := Tstringlist.Create;
      lista.LoadFromFile(salida);
      dm.sqldelete('delete tsparams ' + // borra parametros anteriores
         ' where cprog=' + g_q + job + g_q +
         ' and cbib=' + g_q + bib + g_q +
         ' and cclase=' + g_q + 'JOB' + g_q);
      for i := 0 to lista.Count - 1 do begin // alta nuevos parametros
         pp.CommaText := lista[i];
         if pp.Count <> 5 then
            continue;
         dm.sqlinsert('insert into tsparams (cprog,cbib,cclase,param,valor) values(' +
            g_q + job + g_q + ',' +
            g_q + bib + g_q + ',' +
            g_q + 'JOB' + g_q + ',' +
            g_q + pp[3] + g_q + ',' +
            g_q + stringreplace(pp[4], '''', '', [rfreplaceall]) + g_q + ')');
      end;
      if dm.sqlselect(dm.q1, 'select * from tsrela ' + // busca JCLs llamados por el JOB
         ' where ocprog=' + g_q + job + g_q +
         ' and   ocbib=' + g_q + bib + g_q +
         ' and   occlase=' + g_q + 'JOB' + g_q +
         ' and   hcclase=' + g_q + 'JCL' + g_q) then begin
         while not dm.q1.Eof do begin
            tsparams_job_jcl(job, bib, 'JOB', dm.q1.fieldbyname('hcprog').AsString,
               dm.q1.fieldbyname('hcbib').AsString, dm.q1.fieldbyname('hcclase').AsString);
            dm.q1.Next;
         end;
      end;
   end;
   //.................................................
   procedure tsparams_jcl(jcl: string; bib: string);
   begin
      // revisa si los JOB que lo llaman usan parametros
      if dm.sqlselect(dm.q1, 'select distinct ocprog,ocbib,occlase from tsrela,tsparams ' +
         ' where ocprog=cprog ' +
         ' and   hcprog=' + g_q + jcl + g_q +
         ' and   hcbib=' + g_q + bib + g_q +
         ' and   hcclase=' + g_q + 'JCL' + g_q +
         ' and   occlase=' + g_q + 'JOB' + g_q) then begin
         // reprocesa los JOB en su manejo de parametros
         while not dm.q1.Eof do begin
            dm.sqldelete('delete tsrela ' + // borra registros adoptados anteriores
               ' where ocprog=' + g_q + dm.q1.fieldbyname('ocprog').AsString + g_q +
               ' and   ocbib=' + g_q + dm.q1.fieldbyname('ocbib').AsString + g_q +
               ' and   occlase=' + g_q + dm.q1.fieldbyname('occlase').AsString + g_q +
               ' and   (pcprog,pcbib,pcclase) in ' +
               '       (select distinct pcprog,pcbib,pcclase from tsrela ' +
               '           where ocprog=' + g_q + jcl + g_q +
               '           and   ocbib=' + g_q + bib + g_q +
               '           and   occlase=' + g_q + 'JCL' + g_q + ')');
            tsparams_job_jcl(dm.q1.fieldbyname('ocprog').AsString,
               dm.q1.fieldbyname('ocbib').AsString,
               dm.q1.fieldbyname('occlase').AsString, jcl, bib, 'JCL');
            dm.q1.Next;
         end;
      end;
   end;
   //.....................................................
   function volumen_default(clase, bib, prog: string): string;
   var volumen: string;
      k: integer;
   begin
      volumen := ''; // Busca el volumen default
      if dm.sqlselect(dm.q2, 'select * from tsrela ' +
         ' where ocprog=' + g_q + prog + g_q +
         ' and   ocbib=' + g_q + bib + g_q +
         ' and   occlase=' + g_q + clase + g_q +
         ' and   pcprog=' + g_q + clase + g_q +
         ' and   pcclase=' + g_q + 'CLA' + g_q) then begin
         k := pos('VOLUME=', dm.q2.fieldbyname('atributos').AsString);
         if k > 0 then begin
            volumen := copy(dm.q2.fieldbyname('atributos').AsString, k + 7, 1000);
            k := pos('{}', volumen);
            if k > 0 then
               volumen := copy(volumen, 1, k - 1);
            k := pos('.', volumen);
            if k > 0 then
               volumen := copy(volumen, 1, k - 1);
         end;
      end;
      volumen_default := volumen;
   end;
   //.....................................................
   procedure volumen_macro_cobol(clase, bib, prog: string);
   var volumen: string;
      k: integer;
      lista, archivos, externos: Tstringlist;
      //............................................................................
      procedure procesa_macro_cobol(hcclase, hcbib, hcprog: string; lista: Tstringlist);
      var qq: Tadoquery;
         k: integer;
      begin
         qq := Tadoquery.Create(nil);
         qq.Connection := dm.ADOConnection1;
         lista.Add(clase + '_' + bib + '_' + prog);
         if dm.sqlselect(qq, 'select * from tsrela ' +
            ' where pcprog=' + g_q + hcprog + g_q +
            ' and   pcbib=' + g_q + hcbib + g_q +
            ' and   pcclase=' + g_q + hcclase + g_q) then begin
            while not qq.Eof do begin
               if lista.IndexOf(qq.fieldbyname('hcclase').AsString + '_' +
                  qq.fieldbyname('hcbib').AsString + '_' +
                  qq.fieldbyname('hcprog').AsString) > -1 then begin
                  qq.Next;
                  continue;
               end;
               lista.Add(qq.fieldbyname('hcclase').AsString + '_' +
                  qq.fieldbyname('hcbib').AsString + '_' +
                  qq.fieldbyname('hcprog').AsString);
               // agrega registro con el ASSIGN de la macro TANDEM
               if (hcclase = 'CBL') and (qq.FieldByName('hcclase').AsString = 'FIL') then begin
                  k := externos.IndexOf(qq.fieldbyname('externo').AsString);
                  if k > -1 then begin
                     if archivos[k] <> qq.fieldbyname('hcprog').AsString then begin
                        dm.sqlinsert('insert into tsrela ' +
                           ' (pcprog,pcbib,pcclase,hcprog,hcbib,hcclase,modo,organizacion,' +
                           '  externo,coment,orden,ocprog,ocbib,occlase,sistema,atributos,' +
                           '  lineainicio,lineafinal,ambito,icprog,icbib,icclase,polimorfismo,hsistema,hparametros,hinterfase) ' +
                           ' values(' +
                           g_q + qq.fieldbyname('pcprog').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('pcbib').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('pcclase').AsString + g_q + ',' +
                           g_q + archivos[k] + g_q + ',' +
                           g_q + qq.fieldbyname('hcbib').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('hcclase').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('modo').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('organizacion').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('externo').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('coment').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('orden').AsString + g_q + ',' +
                           g_q + prog + g_q + ',' +
                           g_q + bib + g_q + ',' +
                           g_q + clase + g_q + ',' +
                           g_q + qq.fieldbyname('sistema').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('atributos').AsString + g_q + ',' +
                           qq.fieldbyname('lineainicio').AsString + ',' +
                           qq.fieldbyname('lineafinal').AsString + ',' +
                           g_q + qq.fieldbyname('ambito').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('icprog').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('icbib').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('icclase').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('polimorfismo').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('hsistema').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('hparametros').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('hinterfase').AsString + g_q + ')');
                     end;
                  end
                  else begin // reemplaza el $VOLUMEN$ por el default de la macro TANDEM
                     if pos('$VOLUMEN$', qq.fieldbyname('hcprog').AsString) > 0 then begin
                        dm.sqlinsert('insert into tsrela ' +
                           ' (pcprog,pcbib,pcclase,hcprog,hcbib,hcclase,modo,organizacion,' +
                           '  externo,coment,orden,ocprog,ocbib,occlase,sistema,atributos,' +
                           '  lineainicio,lineafinal,ambito,icprog,icbib,icclase,polimorfismo,hsistema,hparametros,hinterfase) ' +
                           ' values(' +
                           g_q + qq.fieldbyname('pcprog').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('pcbib').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('pcclase').AsString + g_q + ',' +
                           g_q + stringreplace(qq.fieldbyname('hcprog').AsString, '$VOLUMEN$', volumen, []) + g_q + ',' +
                           g_q + qq.fieldbyname('hcbib').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('hcclase').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('modo').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('organizacion').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('externo').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('coment').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('orden').AsString + g_q + ',' +
                           g_q + prog + g_q + ',' +
                           g_q + bib + g_q + ',' +
                           g_q + clase + g_q + ',' +
                           g_q + qq.fieldbyname('sistema').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('atributos').AsString + g_q + ',' +
                           qq.fieldbyname('lineainicio').AsString + ',' +
                           qq.fieldbyname('lineafinal').AsString + ',' +
                           g_q + qq.fieldbyname('ambito').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('icprog').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('icbib').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('icclase').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('polimorfismo').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('hsistema').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('hparametros').AsString + g_q + ',' +
                           g_q + qq.fieldbyname('hinterfase').AsString + g_q + ')');
                     end;
                  end;
               end;
               procesa_macro_cobol(qq.fieldbyname('hcclase').AsString,
                  qq.fieldbyname('hcbib').AsString,
                  qq.fieldbyname('hcprog').AsString, lista);
               qq.Next;
            end;
         end;
         qq.Free;
      end;
   begin
      if (clase <> 'TMC') and (clase <> 'TMP') then exit;
      volumen := volumen_default(clase, bib, prog);
      archivos := Tstringlist.Create; // Busca ASSIGNS de la macro
      externos := Tstringlist.Create;
      if dm.sqlselect(dm.q1, 'select * from tsrela ' +
         ' where ocprog=' + g_q + prog + g_q +
         ' and   ocbib=' + g_q + bib + g_q +
         ' and   occlase=' + g_q + clase + g_q +
         ' and   pcprog=' + g_q + prog + g_q +
         ' and   pcbib=' + g_q + bib + g_q +
         ' and   pcclase=' + g_q + clase + g_q +
         ' and   hcclase=' + g_q + 'FIL' + g_q +
         ' and   externo is not null ') then begin
         while not dm.q1.Eof do begin
            archivos.Add(dm.q1.fieldbyname('hcprog').AsString);
            externos.Add(dm.q1.fieldbyname('externo').AsString);
            dm.q1.Next;
         end;
      end;
      lista := Tstringlist.Create;
      procesa_macro_cobol(clase, bib, prog, lista);
      archivos.free;
      externos.free;
      lista.free;
   end;
   procedure prepara_incluye;
   var b1, b2: Tstringlist;
   begin
      if dm.sqlselect(dm.q1, 'select ocbib,count(*) cuenta from tsrela ' +
         ' where occlase=' + g_q + 'CPY' + g_q +
         ' and sistema=' + g_q + cmbsistema_text + g_q +
         ' group by ocbib order by cuenta desc') then begin
         if dm.sqlselect(dm.q2, 'select path from tsbib where cbib=' + g_q + dm.q1.FieldByName('ocbib').AsString + g_q) then begin
            SetEnvironmentVariable(pchar('COPYLIB'), pchar(dm.q2.FieldByName('path').AsString + '\CPY'));
         end;
      end
      else
         SetEnvironmentVariable(pchar('COPYLIB'), '');
      if herramienta = 'RGMLANG' then begin
         chkcopys_analizador := analizador;
      end
      else begin
         chkcopys_analizador := g_tmpdir + '\chkcopys.exe';
         ptscomun.get_utileria('RGMLANG', chkcopys_analizador, (origen = 'ptsrecibe'));
      end;
      chkcopys_directivas := g_tmpdir + '\chkcopys.dir';
      ptscomun.get_utileria('INSERTA_COMPONENTES', chkcopys_directivas, (origen = 'ptsrecibe'));
      b1 := Tstringlist.Create;
      b2 := Tstringlist.Create;
      if dm.sqlselect(dm.q1, 'select cbib,path from tsbib order by cbib') then begin
         while not dm.q1.Eof do begin
            b1.Add(dm.q1.fieldbyname('cbib').AsString);
            b2.Add(dm.q1.fieldbyname('path').AsString);
            dm.q1.Next;
         end;
      end;
      b1.SaveToFile(g_tmpdir + '\chkcopys.cbib');
      b2.SaveToFile(g_tmpdir + '\chkcopys.path');
      b1.Free;
      b2.Free;
   end;
   function incluye_copys: boolean;
   begin
      inst:=chkcopys_analizador + ' ' + copiado + ' ' + copiado + '.new2 ' + chkcopys_directivas + '>' + g_tmpdir + '\nada.txt';
      ptscomun.ejecuta_espera(inst, SW_HIDE);
      rxfc.LoadFromFile(g_tmpdir + '\nada.txt');
      if pos('[ERROR...]', rxfc.text) > 0 then begin
         g_log.add(formatdatetime('YYYYMMDD-HHNNSS', now) + '|' + 'incluye_copys|' +
            cmboficina_text + '|' + cmbsistema_text + '|' + cmbclase_text + '|' +
            cmbbiblioteca_text + '|' + este + '|' +
            copy(rxfc.text, pos('[ERROR...]', rxfc.text), 100));
         inserta_tslog(este, 'incluye_copys',
            'E043', ptscomun.xlng('ERROR... detectado por inserta_componentes '), 'ERROR');
         if barra <> nil then
            barra.StepIt;
         incluye_copys := false;
         exit;
      end;
      copyfile(pchar(copiado + '.new2'), pchar(copiado), false);
      if fileexists(copiado + '.concopys') then
         incluye_copys;
      incluye_copys := true;
   end;
   procedure volumen_cobol_macro(clase, bib, prog: string);
   begin
   end;
begin
   if g_conciliado = nil then
      g_conciliado := Tstringlist.Create;
   if modulo_prod = nil then
      modulo_prod := Tstringlist.Create;
   rxfuente := Tstringlist.Create;
   g_sistema_actual := cmbsistema_text;
   g_procesando := compos[0];
   ptsrec_clase:=cmbclase_text;
   ptsrec_bib:=cmbbiblioteca_text;
   extrapars := '';
   var_ambiente_general;
   //TSBIBCLA
   if dm.sqlselect(dm.q1, 'select * from tsbibcla ' +
      ' where cbib=' + g_q + cmbbiblioteca_text + g_q +
      ' and   cclase=' + g_q + cmbclase_text + g_q) = false then begin
      if dm.sqlselect(dm.q2, 'select * from tsbib ' +
         ' where cbib=' + g_q + cmbbiblioteca_text + g_q) then begin
         oracledir := 'D' + formatdatetime('YYYYMMDDHHNNSSZZZ', now);
         path := dm.q2.fieldbyname('path').AsString + '\' + cmbclase_text;
         dm.sqlinsert('insert into tsbibcla ' + // alta a TSBIBCLA
            ' (cbib,cclase,oracledir,path) values(' +
            g_q + cmbbiblioteca_text + g_q + ',' +
            g_q + cmbclase_text + g_q + ',' +
            g_q + oracledir + g_q + ',' +
            g_q + path + g_q + ')');
         // crea los directorios
         ptscomun.checa_directorio(oracledir, path);
         ptscomun.checa_directorio('VER_' + oracledir, path + '\versiones');
      end;
   end;
   if chkproduccion_checked then
      directorio_origen := dm.pathbib(cmbbiblioteca_text, cmbclase_text)
   else
      directorio_origen := dir_Directory;
   if (chkverifica_checked) and (chkproduccion_checked = false) then begin // revisa que los archivos sean de la clase correcta
      if cambios_clase then begin // Hubo errores o archivos que no checan con la clase
         if origen = 'ptsrecibe' then begin
            recibeclick := false;
            exit;
         end;
      end;
   end;
   if directoryexists(dm.pathbib(cmbbiblioteca_text, cmbclase_text)) = false then begin
      try
         forcedirectories(dm.pathbib(cmbbiblioteca_text, cmbclase_text));
         forcedirectories(dm.pathbib(cmbbiblioteca_text, cmbclase_text) + '\versiones');
      except
         if origen = 'ptsrecibe' then begin
            Application.MessageBox(pchar(ptscomun.xlng('ERROR... No puede crear directorio ' + dm.pathbib(cmbbiblioteca_text, cmbclase_text))),
               pchar(ptscomun.xlng('Procesa archivos ')), MB_OK);
         end
         else begin
            inserta_tslog(nombre_componente(compos[0]), 'volumen_cobol_macro',
               'F001', ptscomun.xlng('ERROR... No puede crear directorio ' +
               dm.pathbib(cmbbiblioteca_text, cmbclase_text)), 'FATAL');
         end;
         abort;
      end;
   end;
   if directoryexists(dm.pathbib(cmbbiblioteca_text, cmbclase_text) + '\versiones') = false then begin
      try
         forcedirectories(dm.pathbib(cmbbiblioteca_text, cmbclase_text) + '\versiones');
      except
         if origen = 'ptsrecibe' then begin
            Application.MessageBox(pchar(ptscomun.xlng('ERROR... No puede crear directorio ' + dm.pathbib(cmbbiblioteca_text, cmbclase_text))),
               pchar(ptscomun.xlng('Procesa archivos ')), MB_OK);
         end
         else begin
            inserta_tslog(nombre_componente(compos[0]), 'volumen_cobol_macro',
               'F001', ptscomun.xlng('ERROR... No puede crear directorio ' +
               dm.pathbib(cmbbiblioteca_text, cmbclase_text)), 'FATAL');
         end;
         abort;
      end;
   end;
   if directoryexists(dm.pathbib(cmbbiblioteca_text, cmbclase_text)) = false then begin
      if origen = 'ptsrecibe' then begin
         Application.MessageBox(pchar(ptscomun.xlng('ERROR... no existe el directorio ' + dm.pathbib(cmbbiblioteca_text, cmbclase_text))),
            pchar(ptscomun.xlng('Procesa archivos ')), MB_OK);
      end
      else begin
         inserta_tslog(nombre_componente(compos[0]), 'volumen_cobol_macro',
            'F001', ptscomun.xlng('ERROR... No puede crear directorio ' +
            dm.pathbib(cmbbiblioteca_text, cmbclase_text)), 'FATAL');
      end;
      abort;
   end;
   if directoryexists(dm.pathbib(cmbbiblioteca_text, cmbclase_text) + '\versiones') = false then begin
      if origen = 'ptsrecibe' then begin
         Application.MessageBox(pchar(ptscomun.xlng('ERROR... no existe el directorio ' + dm.pathbib(cmbbiblioteca_text, cmbclase_text) + '\versiones')),
            pchar(ptscomun.xlng('Procesa archivos ')), MB_OK);
      end
      else begin
         inserta_tslog(nombre_componente(compos[0]), 'volumen_cobol_macro',
            'F001', ptscomun.xlng('ERROR... No puede crear directorio ' +
            dm.pathbib(cmbbiblioteca_text, cmbclase_text)), 'FATAL');
      end;
      abort;
   end;
   anterior := '';
   if (chkextension_checked = false) and (chkproduccion_checked = false) then begin
      for i := 0 to compos.Count - 1 do begin // checa que no haya 2 iguales con diferente extensión
         este := nombre_componente(compos[i]);
         if este = anterior then begin
            g_log.Add(ptscomun.xlng(formatdatetime('YYYYMMDD-HHNNSS', now) + ' ERROR... el componente aparece más de una vez [' + anterior + ']'));
            g_log.Add(ptscomun.xlng(formatdatetime('YYYYMMDD-HHNNSS', now) + ' No se dio de alta ningún componente'));
            if origen = 'ptsrecibe' then begin
               Application.MessageBox(pchar(ptscomun.xlng('ERROR... el componente aparece más de una vez [' + anterior + ']')),
                  pchar(ptscomun.xlng('Procesa archivos ')), MB_OK);
               Application.MessageBox(pchar(ptscomun.xlng('No se dio de alta ningún componente')),
                  pchar(ptscomun.xlng('Procesa archivos ')), MB_OK);
            end
            else begin
               inserta_tslog(este, 'dm.recibeclick',
                  'E005', ptscomun.xlng('ERROR... el componente aparece más de una vez [' + anterior + ']'), 'ERROR');
               inserta_tslog(este, 'dm.recibeclick',
                  'F002', ptscomun.xlng('ERROR... No se dio de alta ningún componente'), 'FATAL');
            end;
            abort;
         end;
         anterior := este;
      end;
   end;
   if cmbclase_text = 'JOB' then begin // para procesar TSPARAMS
      deletefile(g_tmpdir + '\hta452345');
      deletefile(g_tmpdir + '\hta3214444.exe');
   end;
   SetEnvironmentVariable(pchar('COPYLIB'), pchar(ptscomun.get_copylib(cmbsistema_text)));
   SetEnvironmentVariable(pchar('ZTIPO'), pchar(cmbclase_text));
   SetEnvironmentVariable(pchar('ZSISTEMAZ'), pchar(cmbsistema_text));
   SetEnvironmentVariable(pchar('ZBIBLIOTECAZ'), pchar(cmbbiblioteca_text));
   SetEnvironmentVariable(pchar('ZOFICINAZ'), pchar(cmboficina_text));
   if pos('\ORIGINALES\',directorio_origen)>0 then
      SetEnvironmentVariable(pchar('ZORIGINALESZ'), pchar(copy(directorio_origen,1,pos('\ORIGINALES\',directorio_origen)+length('\ORIGINALES')-1)))
   else
      SetEnvironmentVariable(pchar('ZORIGINALESZ'), pchar(directorio_origen));
   if (chkanaliza_checked) and (cla_tipo = 'ANALIZABLE') then begin
      fmbanalizador := g_tmpdir + '\fmb321432.exe';
      if cmbclase_text = 'FMB' then begin // Formas ORACLE DEVELOPER 2000
         ptscomun.get_utileria('SVSFMB', fmbanalizador, (origen = 'ptsrecibe'));
      end;
      analizador := g_tmpdir + '\hta321432.exe';
      ptscomun.get_utileria(herramienta, analizador, (origen = 'ptsrecibe'));
      if chkcopys_checked then begin
         prepara_incluye;
      end;
      g_borrar.Add(g_tmpdir + '\source.new');
      // Estas utilerias se descargan una sola vez para todos los componentes seleccionados
      if (cmbclase_text='CBL') or (cmbclase_text='TDB') or (cmbclase_text='CPY')  then begin
         dm.get_utileria('TANDEM_VOLUMEN_DEFAULT',g_tmpdir+'\TANDEM_VOLUMEN_DEFAULT.txt');
      end;

      if herramienta = 'RGMLANG' then begin
         directivas := g_tmpdir + '\hta321432.dir';
         ptscomun.get_utileria('DIRECTIVAS ' + cmbclase_text, directivas, (origen = 'ptsrecibe'));
      end
      else begin     // descarga utilerias para procesar SQLs
         dm.get_utileria('RGMLANG',g_tmpdir+'\GUTIL_RGMLANG.exe');
         dm.get_utileria('DIRECTIVAS DDL',g_tmpdir+'\GUTIL_DIRECTIVAS_DDL');
         dm.get_utileria('DIRECTIVAS COMPLEMENTO SQL',g_tmpdir+'\GUTIL_DIRECTIVAS_COMPLEMENTO_SQL');
         dm.get_utileria('RESERVADAS DDL',g_tmpdir+'\GUTIL_RESERVADAS_DDL');
      end;
      reservadas := g_tmpdir + '\reserved';
      ptscomun.get_utileria('RESERVADAS ' + cmbclase_text, reservadas, (origen = 'ptsrecibe'));
   end;
   //screen.Cursor := crsqlwait;
   if barra <> nil then begin
      barra.Max := compos.Count;
      barra.Position := 0;
      barra.Step := 1;
      barra.Visible := true;
   end;
   inicio := now;
   b_extra := false;
   for i := 0 to compos.Count - 1 do begin
      rxfc.Text := '';
      basenombre := extractfilepath(nombre_componente(compos[i]));
      este := nombre_componente(compos[i]);
      // este := stringreplace( este, '/', '.', [ rfreplaceall ] );
      // este := stringreplace( este, '\', '.', [ rfreplaceall ] );
      if (cmbclase_text = 'JXM') or (cmbclase_text = 'TLD') then begin // JAVA para web.xml y anexas
         este := stringreplace(cmbsistema_text + '_' + este, ' ', '.', [rfreplaceall]);
      end;
      if (chkexiste_checked) and (chkproduccion_checked = false) then begin
         if dm.sqlselect(dm.q1, 'select * from tsprog ' +
            ' where cprog=' + g_q + este + g_q +
            ' and   cbib=' + g_q + cmbbiblioteca_text + g_q) then
            continue;
      end;
      SetEnvironmentVariable(pchar('ZCPROG2BFILEZ'), pchar(ptscomun.cprog2bfile(este)));
      SetEnvironmentVariable(pchar('ZPROGRAMAZ'), pchar(este));
      if chkproduccion_checked then
         nombre_fisico:=directorio_origen + '\' +ptscomun.cprog2bfile(este)
      else
         nombre_fisico:=directorio_origen + '\' +compos[i];
      if fileexists(nombre_fisico)=false then begin
         if origen = 'ptsrecibe' then begin
            Application.MessageBox(pchar(ptscomun.xlng('ERROR... no existe el archivo '+nombre_fisico)),
               pchar(ptscomun.xlng('Procesa archivos ')), MB_OK);
            abort;
         end
         else begin
            inserta_tslog(este, 'recibeclick',
               'F009', ptscomun.xlng('ERROR... no no existe el archivo '+nombre_fisico), 'ERROR');
            abort;
         end;
      end;
      magic := ptscomun.filemagic(nombre_fisico);
      nblob := '1';
      inserta_tslog(este, 'recibeclick',
         'C015', ptscomun.xlng('Inicia Proceso'), 'COMIENZA');
      if (chkversion_checked) and (chkproduccion_checked = false) then begin
         // checa que no sea igual a la {ultima version
         if dm.sqlselect(dm.q1, 'select * from tsprog ' +
            ' where cprog=' + g_q + este + g_q +
            ' and   cbib='+g_q+cmbbiblioteca_text+g_q+
            ' and   cclase='+g_q+cmbclase_text+g_q+
            ' and   magic=' + g_q + magic + g_q) then begin
            dm.trae_fuente(cmbsistema_text,este,cmbbiblioteca_text,cmbclase_text,modulo_prod);
            rxfuente.LoadFromFile(directorio_origen + '\' + compos[i]);
            if modulo_prod.Text=rxfuente.Text then
               continue;
         end;
      end;
      { -------- Esto se deshabilita, queda pendiente revisar si procede para la carga automatica RGM
         // Checa que no esté en otra biblioteca u otro sistema
         if dm.sqlselect(dm.q1, 'select * from tsprog ' +
            ' where cprog=' + g_q + este + g_q +
            ' and   magic=' + g_q + magic + g_q +
            ' and   (cbib<>' + g_q + cmbbiblioteca_text + g_q +
            '    or  sistema<>' + g_q + cmbsistema_text + g_q + ')' +
            ' order by cclase,cbib') then begin
            anterior := '';
            while not dm.q1.Eof do begin
               anterior := anterior + char(13) + 'Sistema:' + dm.q1.fieldbyname('sistema').AsString + ' ' +
                  ' Clase:' + dm.q1.fieldbyname('cclase').AsString + ' ' +
                  ' Libreria:' + dm.q1.fieldbyname('cbib').AsString + ' ' + formatdatetime('YYYY-MM-DD HH:NN:SS',
                  dm.q1.fieldbyname('fecha').Asdatetime);
               dm.q1.Next;
            end;
            if origen = 'ptsrecibe' then begin
               case application.MessageBox(pchar(ptscomun.xlng('El componente ' + este + ' es idéntico a: ' + anterior +
                  char(13) + 'Desea darlo de alta?')), pchar(ptscomun.xlng('Confirmar')), MB_YESNOCANCEL) of
                  IDNO: begin
                        continue;
                     end;
                  IDCANCEL: begin
                        //ftsrecibe.Enabled := true;
                        //screen.Cursor := crdefault;
                        exit;
                     end;
               end;
            end
            else begin
               if politica_componente_identico = '' then begin
                  if dm.sqlselect(dm.q2, 'select * from parametro where clave=' + g_q + 'politica_componente_identico' + g_q) then
                     politica_componente_identico := dm.q2.fieldbyname('dato').AsString
                  else
                     politica_componente_identico := 'RECHAZA';
               end;
               if politica_componente_identico = 'RECHAZA' then begin
                  inserta_tslog(este, 'recibeclick',
                     'E006', 'politica_componente_identico=' + politica_componente_identico + ', ' +
                     ptscomun.xlng('El componente ' + este + ' es idéntico a: ' + anterior), 'ERROR');
                  continue;
               end;
               if politica_componente_identico = 'CANCELA' then begin
                  inserta_tslog(este, 'recibeclick',
                     'F006', 'politica_componente_identico=' + politica_componente_identico + ', ' +
                     ptscomun.xlng('El componente ' + este + ' es idéntico a: ' + anterior), 'FATAL');
                  abort;
               end;
               if politica_componente_identico = 'ACEPTA' then begin
                  inserta_tslog(este, 'recibeclick',
                     'W006', 'politica_componente_identico=' + politica_componente_identico + ', ' +
                     ptscomun.xlng('El componente ' + este + ' es idéntico a: ' + anterior), 'WARNING');
               end;
            end;

         end;
         // Checa que no se trate de versiones anteriores
         if dm.sqlselect(dm.q1, 'select * from tsversion ' +
            ' where cprog=' + g_q + este + g_q +
            ' and   cbib=' + g_q + cmbbiblioteca_text + g_q +
            ' and   cclase=' + g_q + cmbclase_text + g_q +
            ' and   magic=' + g_q + magic + g_q +
            ' order by fecha desc') then begin
            anterior := '';
            while not dm.q1.Eof do begin
               anterior := anterior + char(13) + formatdatetime('YYYY-MM-DD HH:NN:SS',
                  dm.q1.fieldbyname('fecha').Asdatetime);
               dm.q1.Next;
            end;
            if origen = 'ptsrecibe' then begin
               case application.MessageBox(pchar(ptscomun.xlng('El componente ' + este + ' es igual a las versiones ' + anterior +
                  char(13) + 'Desea darla de alta?')), pchar(ptscomun.xlng('Confirmar')), MB_YESNOCANCEL) of
                  IDNO: begin
                        continue;
                     end;
                  IDCANCEL: begin
                        //ftsrecibe.Enabled := true;
                        //screen.Cursor := crdefault;
                        exit;
                     end;
               end;
            end
            else begin
               if politica_version_anterior = '' then begin
                  if dm.sqlselect(dm.q2, 'select * from parametro where clave=' + g_q + 'politica_version_anterior' + g_q) then
                     politica_version_anterior := dm.q2.fieldbyname('dato').asstring
                  else
                     politica_version_anterior := 'ACEPTA';
               end;
               if politica_version_anterior = 'RECHAZA' then begin
                  inserta_tslog(este, 'recibeclick',
                     'E007', 'politica_version_anterior=' + politica_version_anterior + ', ' +
                     ptscomun.xlng('El componente ' + este + ' es idéntico a: ' + anterior), 'ERROR');
                  continue;
               end;
               if politica_version_anterior = 'CANCELA' then begin
                  inserta_tslog(este, 'recibeclick',
                     'F007', 'politica_version_anterior=' + politica_version_anterior + ', ' +
                     ptscomun.xlng('El componente ' + este + ' es idéntico a: ' + anterior), 'FATAL');
                  abort;
               end;
               if politica_version_anterior = 'ACEPTA' then begin
                  inserta_tslog(este, 'recibeclick',
                     'W007', 'politica_version_anterior=' + politica_version_anterior + ', ' +
                     ptscomun.xlng('El componente ' + este + ' es idéntico a: ' + anterior), 'WARNING');
               end;
            end;
         end;
      end;
      }
      fecha := ptscomun.datedb(formatdatetime('YYYY/MM/DD HH:NN:SS', now), 'YYYY/MM/DD HH24:MI:SS');
      if dm.sqlselect(dm.q1, 'select * from tsprog ' +
         ' where cprog=' + g_q + este + g_q +
         ' and   cbib=' + g_q + cmbbiblioteca_text + g_q +
         ' and   cclase=' + g_q + cmbclase_text + g_q) then begin
         if dm.sqlupdate('update tsprog set ' +
            ' fecha=' + fecha + ',' +
            ' cblob=' + g_q + nblob + g_q + ',' +
            ' magic=' + g_q + magic + g_q + ',' +
            ' sistema=' + g_q + cmbsistema_text + g_q +
            ' where cprog=' + g_q + este + g_q +
            ' and   cbib=' + g_q + cmbbiblioteca_text + g_q +
            ' and   cclase=' + g_q + cmbclase_text + g_q) = false then begin
            if origen = 'ptsrecibe' then begin
               Application.MessageBox(pchar(ptscomun.xlng('ERROR... no puede actualizar registro a tsprog')),
                  pchar(ptscomun.xlng('Procesa archivos ')), MB_OK);
            end
            else begin
               inserta_tslog(este, 'recibeclick',
                  'E008', ptscomun.xlng('ERROR... no puede actualizar registro a tsprog ' + cmbclase_text + ' ' + cmbbiblioteca_text + ' ' + este), 'ERROR');
            end;
            exit;
         end;
      end
      else begin
         if dm.sqlinsert('insert into tsprog (cprog,cbib,cclase,fecha,cblob,magic,sistema) values (' +
            g_q + este + g_q + ',' +
            g_q + cmbbiblioteca_text + g_q + ',' +
            g_q + cmbclase_text + g_q + ',' +
            fecha + ',' +
            g_q + nblob + g_q + ',' +
            g_q + magic + g_q + ',' +
            g_q + cmbsistema_text + g_q + ')') = false then begin
            g_log.Add(formatdatetime('YYYYMMDD-HHNNSS', now) + '|' + ptscomun.xlng('ftsrecibe.barchivoClick|' + cmbclase_text + '|' +
               cmbbiblioteca_text + '|' + este +
               '|ERROR... no puede agregar registro a tsprog'));
            if origen = 'ptsrecibe' then begin
               Application.MessageBox(pchar(ptscomun.xlng('ERROR... no puede agregar registro a tsprog')),
                  pchar(ptscomun.xlng('Procesa archivos ')), MB_OK);
            end
            else begin
               inserta_tslog(este, 'recibeclick',
                  'E009', ptscomun.xlng('ERROR... no puede agregar registro a tsprog ' + cmbclase_text + ' ' + cmbbiblioteca_text + ' ' + este), 'ERROR');
            end;
            exit;
         end;
      end;
      var_ambiente_prog(cmbclase_text,cmbbiblioteca_text,este);    //  detecta las variables de ambiente declaradas en los padres del programa
      // carga de versiones
      if chkproduccion_checked = false then begin
         idversion := formatdatetime('YYYYMMDDHHNNSS', inicio);
         if dm.sqlinsert('insert into tsversion (cprog,cbib,cclase,fecha,cuser,cblob,magic) values (' +
            g_q + este + g_q + ',' +
            g_q + cmbbiblioteca_text + g_q + ',' +
            g_q + cmbclase_text + g_q + ',' +
            fecha + ',' +
            g_q + g_usuario + g_q + ',' +
            g_q + idversion + g_q + ',' +
            g_q + magic + g_q + ')') = false then begin
            g_log.Add(formatdatetime('YYYYMMDD-HHNNSS', now) + '|' + ptscomun.xlng('ftsrecibe.barchivoClick|' + cmbclase_text + '|' +
               cmbbiblioteca_text + '|' + este +
               '|ERROR... no puede agregar registro a tsversion'));
            if origen = 'ptsrecibe' then begin
               Application.MessageBox(pchar(ptscomun.xlng('ERROR... no puede agregar registro a tsversion')),
                  pchar(ptscomun.xlng('Procesa archivos ')), MB_OK);
            end
            else begin
               inserta_tslog(este, 'recibeclick',
                  'E010', ptscomun.xlng('ERROR... no puede agregar registro a tsversion ' + cmbclase_text + ' ' + cmbbiblioteca_text + ' ' + este), 'ERROR');
            end;
            exit;
         end;
         try
            //copyfile(pchar(dir_Directory + '\' + compos[i]),
            copyfile(pchar(directorio_origen + '\' + compos[i]),
               pchar(dm.pathbib(cmbbiblioteca_text, cmbclase_text) + '\' + ptscomun.cprog2bfile(este)),
               false);
         except
            g_log.Add(formatdatetime('YYYYMMDD-HHNNSS', now) + '|' + ptscomun.xlng('ftsrecibe.barchivoClick|' + cmbclase_text + '|' +
               cmbbiblioteca_text + '|' + este +
               '|ERROR... no puede integrar a ' +
               dm.pathbib(cmbbiblioteca_text, cmbclase_text) + '\' + este));
            if origen = 'ptsrecibe' then begin
               Application.MessageBox(pchar(ptscomun.xlng('ERROR... no puede integrar a ' + dm.pathbib(cmbbiblioteca_text, cmbclase_text) + '\' + este)),
                  pchar(ptscomun.xlng('Procesa archivos ')), MB_OK);
            end
            else begin
               inserta_tslog(este, 'recibeclick',
                  'E011', ptscomun.xlng('ERROR... no puede integrar a ' +
                  dm.pathbib(cmbbiblioteca_text, cmbclase_text) + '\' + este +
                  ' ' + cmbclase_text + ' ' + cmbbiblioteca_text + ' ' + este), 'ERROR');
            end;
            abort;
         end;
         try
            //copyfile(pchar(dir_Directory + '\' + compos[i]),
            copyfile(pchar(directorio_origen + '\' + compos[i]),
               pchar(dm.pathbib(cmbbiblioteca_text, cmbclase_text) + '\versiones\' + ptscomun.cprog2bfile(este) + '.' + idversion),
               true);
         except
            g_log.Add(formatdatetime('YYYYMMDD-HHNNSS', now) + '|' + ptscomun.xlng('ftsrecibe.barchivoClick|' + cmbclase_text + '|' +
               cmbbiblioteca_text + '|' + este +
               '|ERROR... no puede integrar a ' +
               dm.pathbib(cmbbiblioteca_text, cmbclase_text) + '\versiones\' + este + '.' + idversion));
            if origen = 'ptsrecibe' then begin
               Application.MessageBox(pchar(ptscomun.xlng('ERROR... no puede integrar a ' +
                  dm.pathbib(cmbbiblioteca_text, cmbclase_text) + '\versiones\' + este + '.' + idversion)),
                  pchar(ptscomun.xlng('Procesa archivos ')), MB_OK);
            end
            else begin
               inserta_tslog(este, 'recibeclick',
                  'E012', ptscomun.xlng('ERROR... no puede integrar a ' +
                  dm.pathbib(cmbbiblioteca_text, cmbclase_text) + '\versiones\' + este + '.' + idversion +
                  ' ' + cmbclase_text + ' ' + cmbbiblioteca_text + ' ' + este), 'ERROR');
            end;
            abort;
         end;
      end;
      dm.sqldelete('delete tsrela where ocprog=' + g_q + este + g_q +
         ' and ocbib=' + g_q + cmbbiblioteca_text + g_q +
         ' and occlase=' + g_q + cmbclase_text + g_q);
      dm.sqlinsert('insert into tsrela (pcprog,pcbib,pcclase,hcprog,hcbib,' +
         'hcclase,coment,orden,sistema,ocprog,ocbib,occlase,hsistema) values (' +
         g_q + cmbclase_text + g_q + ',' +
         g_q + cmbsistema_text + g_q + ',' +
         g_q + 'CLA' + g_q + ',' +
         g_q + este + g_q + ',' +
         g_q + cmbbiblioteca_text + g_q + ',' +
         g_q + cmbclase_text + g_q + ',' +
         g_q + nombre_version + g_q + ',' + // si ypath no es visible, debe estar vacia "dbase"
         g_q + '0001' + g_q + ',' +
         g_q + g_sistema_actual + g_q + ',' +
         g_q + este + g_q + ',' +
         g_q + cmbbiblioteca_text + g_q + ',' +
         g_q + cmbclase_text + g_q + ',' +
         g_q + cmbsistema_text + g_q + ')');
      copiado := g_tmpdir + '\' + ptscomun.cprog2bfile(este);
      if fileexists(copiado) then
         ptscomun.ejecuta_espera('attrib -r ' + copiado, SW_HIDE);
      //--- Analiza --------------------------------------------
      if (chkanaliza_checked) and (cla_tipo = 'ANALIZABLE') then begin
         copyfile(pchar(nombre_fisico), pchar(copiado), false);
         g_borrar.Add(copiado);
         chdir(g_tmpdir);
         if (yextra_Visible) and (chkextra_checked) and (b_extra = false) then begin
            extrapars := '';
            if origen = 'ptsrecibe' then begin
               if application.MessageBox(
                  pchar('Procesará con los parámetros extra:[' + txtextra_text + '] Correcto?'),
                  'Confirme', MB_OKCANCEL) = IDCANCEL then
                  exit;
            end
            else begin
               inserta_tslog(este, 'recibeclick',
                  'I013', ptscomun.xlng('Procesará con los parámetros extra:[' + txtextra_text + '] '), 'INFO');
            end;
            b_extra := true;
            dm.sqldelete('delete parametro ' +
               ' where clave=' + g_q + 'EXTRA_MINING_' +cmbsistema_text+'_'+ cmbclase_text +'_'+cmbbiblioteca_text+ g_q);
            dm.sqlinsert('insert into parametro (CLAVE,SECUENCIA,DATO,DESCRIPCION) ' +
               ' values(' + g_q + 'EXTRA_MINING_' + cmbsistema_text+'_'+ cmbclase_text +'_'+cmbbiblioteca_text+ g_q + ',1,' +
               g_q + trim(txtextra_text) + g_q + ',' +
               g_q + 'PARAMETROS EXTRA PARA LA MINERIA (CASO TANDEM)' + g_q + ')');
            extrapars := txtextra_text;
         end;
         if chkcopys_checked then begin
            if incluye_copys = false then
               continue;
         end;
         if herramienta = 'RGMLANG' then begin
            if cmbclase_text = 'FMB' then begin // FORMA ORACLE DEVELOPER 2000
               ptscomun.ejecuta_espera(fmbanalizador + ' ' + copiado + ' ' + copiado + '.new', SW_HIDE);
               copyfile(pchar(copiado + '.new'), pchar(copiado), false);
            end;
            //dm.get_utileria('TANDEM_VOLUMEN_DEFAULT',g_ruta+'\TANDEM_VOLUMEN_DEFAULT.txt');
            inst:= analizador + ' "' +
               copiado + '" ' + g_tmpdir + '\source.new ' +
               directivas + ' ' + reservadas + ' ' +
               basenombre + ' >' + g_tmpdir + '\nada.txt';
            ptscomun.ejecuta_espera(inst, SW_HIDE);
         end
         else begin
            inst:=analizador + ' ' +
               cmbclase_text + ' "' + copiado + '" ' + cmboficina_text +
               ' ' + cmbbiblioteca_text + ' ' + este + ' ' + '321432' + ' ' +
               extrapars + ' >' + g_tmpdir + '\nada.txt';
            ptscomun.ejecuta_espera(inst, SW_HIDE);
         end;
         rxfc.LoadFromFile(g_tmpdir + '\nada.txt');
         g_borrar.Add(g_tmpdir + '\nada.txt');

         if (chkruta_checked = false) and (cmbclase_text <> 'TDC') and (cmbclase_text <> 'STP')
            and (cmbclase_text <> 'CCH') and (cmbclase_text <> 'USH') then begin // TANDEM C
            rxfc.text := uppercase(rxfc.text);
         end;

         rxfc.text := stringreplace(rxfc.text, '$OFICINA$', cmboficina_text, [rfreplaceall]); // Para reemplazar en el resultado de la mineria
         rxfc.text := stringreplace(rxfc.text, '$SISTEMA$', cmbsistema_text, [rfreplaceall]);
         rxfc.text := stringreplace(rxfc.text, '$CLASE$', cmbclase_text, [rfreplaceall]);
         rxfc.text := stringreplace(rxfc.text, '$BIBLIOTECA$', cmbbiblioteca_text, [rfreplaceall]);
         if pos('ERROR...', rxfc.text) > 0 then begin
            g_log.add(formatdatetime('YYYYMMDD-HHNNSS', now) + '|' + 'ftsrecibe.barchivoClick|' +
               cmboficina_text + '|' + cmbsistema_text + '|' + cmbclase_text + '|' +
               cmbbiblioteca_text + '|' + este + '|' +
               copy(rxfc.text, pos('ERROR...', rxfc.text), 100));
            inserta_tslog(este, 'recibeclick',
               'E014', ptscomun.xlng('ERROR... detectado por el escaneador '), 'ERROR');
            if barra <> nil then
               barra.StepIt;
            continue;
         end;
         if analiza_componente(cmbclase_text, cmbbiblioteca_text, este, rxfc) then begin
            inserta_tslog(este, 'recibeclick',
               'T015', ptscomun.xlng('Procesado'), 'TERMINA');

            if chkproduccion_checked = false then begin
               dm.sqlupdate('update tsprog set analizado=' + g_q + idversion + g_q +
                  ' where cprog=' + g_q + este + g_q +
                  ' and cbib=' + g_q + cmbbiblioteca_text + g_q);
            end;

            //=========================================== Herencia ===============================================
            if dm.sqlselect(dm.q1, 'select * from tsrela ' + // el analizado es extend (es heredado)
               ' where hcprog=' + g_q + este + g_q +
               ' and   hcbib=' + g_q + cmbbiblioteca_text + g_q +
               ' and   hcclase=' + g_q + cmbclase_text + g_q +
               ' and   pcclase=' + g_q + 'INH' + g_q) then begin
               while not dm.q1.Eof do begin
                  oocprog := dm.q1.fieldbyname('ocprog').AsString;
                  oocbib := dm.q1.fieldbyname('ocbib').AsString;
                  oocclase := dm.q1.fieldbyname('occlase').AsString;
                  oocoment := cmbclase_text + '_' + cmbbiblioteca_text + '_' + este;
                  dm.sqldelete('delete tsrela ' + // borra herencia anterior si existe // borra registro Clase-Programa -> ETP-Rutina
                     ' where ocprog=' + g_q + oocprog + g_q + // borra registro ETP-Rutina -> ETP-Rutina heredada
                     ' and   ocbib=' + g_q + oocbib + g_q +
                     ' and   occlase=' + g_q + oocclase + g_q +
                     ' and   hcclase=' + g_q + 'ETP' + g_q +
                     ' and   coment=' + g_q + oocoment + g_q +
                     ' and   orden=' + g_q + '0000' + g_q);
                  if dm.sqlselect(dm.q2, 'select * from tsrela ' +
                     ' where ocprog=pcprog ' +
                     ' and   ocbib=pcbib ' +
                     ' and   occlase=pcclase ' +
                     ' and   ocprog=' + g_q + este + g_q +
                     ' and   ocbib=' + g_q + cmbbiblioteca_text + g_q +
                     ' and   occlase=' + g_q + cmbclase_text + g_q +
                     ' and   hcclase=' + g_q + 'ETP' + g_q) then begin
                     while not dm.q2.Eof do begin // Falta actualizar los campos agregados hsistema,hinterfase,hparams
                        dm.sqlinsert('insert into tsrela (pcprog,pcbib,pcclase,hcprog,hcbib,' + // inserta registro Clase-Programa -> ETP-Rutina
                           'hcclase,coment,orden,sistema,ocprog,ocbib,occlase) values(' +
                           g_q + oocprog + g_q + ',' +
                           g_q + oocbib + g_q + ',' +
                           g_q + oocclase + g_q + ',' +
                           g_q + dm.q2.fieldbyname('hcprog').AsString + g_q + ',' +
                           g_q + oocprog + g_q + ',' +
                           g_q + 'ETP' + g_q + ',' +
                           g_q + oocoment + g_q + ',' +
                           g_q + '0000' + g_q + ',' +
                           g_q + dm.q1.fieldbyname('sistema').AsString + g_q + ',' +
                           g_q + oocprog + g_q + ',' +
                           g_q + oocbib + g_q + ',' +
                           g_q + oocclase + g_q + ')'); // Falta actualizar los campos agregados hsistema,hinterfase,hparams
                        dm.sqlinsert('insert into tsrela (pcprog,pcbib,pcclase,hcprog,hcbib,' + // inserta registro ETP-Rutina -> ETP-Rutina heredada
                           'hcclase,coment,orden,sistema,ocprog,ocbib,occlase) values(' +
                           g_q + dm.q2.fieldbyname('hcprog').AsString + g_q + ',' +
                           g_q + oocprog + g_q + ',' +
                           g_q + 'ETP' + g_q + ',' +
                           g_q + dm.q2.fieldbyname('hcprog').AsString + g_q + ',' +
                           g_q + dm.q2.fieldbyname('hcbib').AsString + g_q + ',' +
                           g_q + 'ETP' + g_q + ',' +
                           g_q + oocoment + g_q + ',' +
                           g_q + '0000' + g_q + ',' +
                           g_q + dm.q1.fieldbyname('sistema').AsString + g_q + ',' +
                           g_q + oocprog + g_q + ',' +
                           g_q + oocbib + g_q + ',' +
                           g_q + oocclase + g_q + ')');
                        dm.q2.Next;
                     end;
                  end;
                  dm.q1.Next;
               end;
            end;
            // falta cuando es alta del que hereda *******************************************
            if dm.sqlselect(dm.q1, 'select * from tsrela ' + // el analizado tiene extend (tiene herencia)
               ' where ocprog=' + g_q + este + g_q +
               ' and   ocbib=' + g_q + cmbbiblioteca_text + g_q +
               ' and   occlase=' + g_q + cmbclase_text + g_q +
               ' and   pcclase=' + g_q + 'INH' + g_q) then begin
               while not dm.q1.Eof do begin
                  oocprog := dm.q1.fieldbyname('hcprog').AsString;
                  oocbib := dm.q1.fieldbyname('hcbib').AsString;
                  oocclase := dm.q1.fieldbyname('hcclase').AsString;
                  oocoment := oocclase + '_' + oocbib + '_' + oocprog;
                  if dm.sqlselect(dm.q2, 'select * from tsrela ' +
                     ' where ocprog=pcprog ' +
                     ' and   ocbib=pcbib ' +
                     ' and   occlase=pcclase ' +
                     ' and   ocprog=' + g_q + oocprog + g_q +
                     ' and   ocbib=' + g_q + oocbib + g_q +
                     ' and   occlase=' + g_q + oocclase + g_q +
                     ' and   hcclase=' + g_q + 'ETP' + g_q) then begin
                     while not dm.q2.Eof do begin // Falta actualizar los campos agregados hsistema,hinterfase,hparams
                        dm.sqlinsert('insert into tsrela (pcprog,pcbib,pcclase,hcprog,hcbib,' + // inserta registro Clase-Programa -> ETP-Rutina
                           'hcclase,coment,orden,sistema,ocprog,ocbib,occlase) values(' +
                           g_q + este + g_q + ',' +
                           g_q + cmbbiblioteca_text + g_q + ',' +
                           g_q + cmbclase_text + g_q + ',' +
                           g_q + dm.q2.fieldbyname('hcprog').AsString + g_q + ',' +
                           g_q + este + g_q + ',' +
                           g_q + 'ETP' + g_q + ',' +
                           g_q + oocoment + g_q + ',' +
                           g_q + '0000' + g_q + ',' +
                           g_q + cmbsistema_text + g_q + ',' +
                           g_q + este + g_q + ',' +
                           g_q + cmbbiblioteca_text + g_q + ',' +
                           g_q + cmbclase_text + g_q + ')'); // Falta actualizar los campos agregados hsistema,hinterfase,hparams
                        dm.sqlinsert('insert into tsrela (pcprog,pcbib,pcclase,hcprog,hcbib,' + // inserta registro ETP-Rutina -> ETP-Rutina heredada
                           'hcclase,coment,orden,sistema,ocprog,ocbib,occlase) values(' +
                           g_q + dm.q2.fieldbyname('hcprog').AsString + g_q + ',' +
                           g_q + este + g_q + ',' +
                           g_q + 'ETP' + g_q + ',' +
                           g_q + dm.q2.fieldbyname('hcprog').AsString + g_q + ',' +
                           g_q + dm.q2.fieldbyname('hcbib').AsString + g_q + ',' +
                           g_q + 'ETP' + g_q + ',' +
                           g_q + oocoment + g_q + ',' +
                           g_q + '0000' + g_q + ',' +
                           g_q + cmbsistema_text + g_q + ',' +
                           g_q + este + g_q + ',' +
                           g_q + cmbbiblioteca_text + g_q + ',' +
                           g_q + cmbclase_text + g_q + ')');
                        dm.q2.Next;
                     end;
                  end;
                  dm.q1.Next;
               end;
            end;

            // ----------- Proceso para complejidad  ALK --------------

            // -------- Trayendo utilerias para complejidades ---------
            if dm.sqlselect(dm.q1,'select cclase from tsclase '+
               ' where cclase='+g_q+cmbclase_text+g_q+
               ' and complejidad='+g_q+'TRUE'+g_q) then begin
               if (cmbclase_text='CBL') or (cmbclase_text='CMA') then begin   //RGM-ALE
                  complejidad := g_tmpdir + '\calcomplejidadprograma' + formatdatetime( 'YYYYMMDDhhnnss', now ) + '.exe';
                  dirCBL := g_tmpdir + '\procesaCBL' + formatdatetime( 'YYYYMMDDhhnnss', now ) + '.dir';
                  dirCMA := g_tmpdir + '\procesaCMA' + formatdatetime( 'YYYYMMDDhhnnss', now ) + '.dir';
                  res := g_tmpdir + '\reservadasCMACBL' + formatdatetime( 'YYYYMMDDhhnnss', now );
                  rgmlang := g_tmpdir + '\hta' + formatdatetime( 'YYYYMMDDhhnnss', now ) + '.exe';

                  dm.get_utileria( 'COMPLEJIDAD', complejidad );  // traer el ejecutable de Natan
                  dm.get_utileria( 'COMPLEJIDAD_DIRECTIVAS_CBL', dirCBL,true,true );
                  ptscomun.parametros_extra(cmbsistema_text,cmbclase_text,cmbbiblioteca_text,dirCBL); //--------- Checa si necesita parametros especiales ---------  RGM
                  dm.get_utileria( 'COMPLEJIDAD_DIRECTIVAS_CMA', dirCMA,true,true );
                  dm.get_utileria( 'COMPLEJIDAD_RESERVADAS_CMACBL', res );
                  ptscomun.parametros_extra(cmbsistema_text,cmbclase_text,cmbbiblioteca_text,dirCMA); //--------- Checa si necesita parametros especiales ---------  RGM
                  dm.get_utileria( 'RGMLANG', rgmlang );

                  g_borrar.Add(complejidad);
                  g_borrar.Add(dirCBL);
                  g_borrar.Add(dirCMA);
                  g_borrar.Add(res);
                  g_borrar.Add(rgmlang);

                  dm.complejidad(este, cmbclase_text, cmbbiblioteca_text, cmbsistema_text,
                                 rgmlang, complejidad, dirCBL, dirCMA, res);
               end; //RGM-ALE
            end;
         end
         else begin
            g_log.add(formatdatetime('YYYYMMDD-HHNNSS', now) + '|' + 'ftsrecibe.barchivoClick|' +
               cmboficina_text + '|' + cmbsistema_text + '|' + cmbclase_text + '|' +
               cmbbiblioteca_text + '|' + este + '|' + 'ERROR... analiza_componente');
            inserta_tslog(este, 'recibeclick',
               'E015', ptscomun.xlng('Procesado con ERROR'), 'ERROR');
            if barra <> nil then
               barra.StepIt;
            continue;
         end;

         alta_resumen(este, cmbbiblioteca_text, cmbclase_text);
         alta_atributo(este, cmbbiblioteca_text, cmbclase_text);
         actualiza_lineas_final(este, cmbbiblioteca_text, cmbclase_text);
         //--------------------------------- Actualiza rutinas public ------------------------------------------------------------------
         ocprog := este;
         ocbib := cmbbiblioteca_text;
         occlase := cmbclase_text;
         if dm.sqlselect(dm.q2, 'select * from tsrela ' +
            ' where ocprog=' + g_q + ocprog + g_q +
            ' and   ocbib=' + g_q + ocbib + g_q +
            ' and   occlase=' + g_q + occlase + g_q +
            ' and   ambito=' + g_q + 'PUBLIC' + g_q +
            ' and   hcbib<>' + g_q + 'SCRATCH' + g_q) then begin
            while not dm.q2.Eof do begin
               w_polimorfismo := dm.q2.fieldbyname('polimorfismo').asstring;
               if w_polimorfismo = '' then
                  w_polimorfismo := ' IS NULL'
               else
                  w_polimorfismo := '=' + g_q + w_polimorfismo + g_q;
               dm.sqlupdate('update tsrela set hcbib=' + g_q + dm.q2.fieldbyname('hcbib').asstring + g_q +
                  '      ,hcprog=' + g_q + dm.q2.fieldbyname('hcprog').asstring + g_q +
                  ' where hcprog=' + g_q + dm.q2.fieldbyname('hcprog').asstring + g_q +
                  ' and   hcbib=' + g_q + 'SCRATCH' + g_q +
                  ' and   hcclase=' + g_q + dm.q2.fieldbyname('hcclase').asstring + g_q +
                  ' and   polimorfismo' + w_polimorfismo +
                  ' and   sistema=' + g_q + g_sistema_actual + g_q);
               dm.q2.Next;
            end;
         end;
         //-------------------------------- Actualiza del sistema primero ----------------------------------------------------------------
         if dm.sqlselect(dm.q1, 'select distinct hcbib,hcprog from tsrela where ocprog=' + g_q + este + g_q + // actualiza componentes SCRATCH y clase ETP
            ' and ocbib=' + g_q + cmbbiblioteca_text + g_q + // checa contra hijos porque la rutina puede no tener hijos
            ' and occlase=' + g_q + cmbclase_text + g_q +
            ' and ocprog=pcprog ' +
            ' and hcclase=' + g_q + 'ETP' + g_q +
            ' and hcbib<>' + g_q + 'SCRATCH' + g_q +
            ' and hsistema=' + g_q + cmbsistema_text + g_q) then begin
            while not dm.q1.Eof do begin
               dm.sqlupdate('update tsrela set hcbib=' + g_q + dm.q1.fieldbyname('hcbib').AsString + g_q +
                  '      ,hcprog=' + g_q + dm.q1.fieldbyname('hcprog').AsString + g_q +
                  ' where hcprog=' + g_q + dm.q1.fieldbyname('hcprog').AsString + g_q +
                  ' and   hcbib=' + g_q + 'SCRATCH' + g_q +
                  ' and   hcclase=' + g_q + 'ETP' + g_q +
                  ' and   hcprog=' + g_q + dm.q1.fieldbyname('hcprog').AsString + g_q +
                  ' and hsistema=' + g_q + cmbsistema_text + g_q);
               dm.q1.Next;
            end;
         end;
         if dm.sqlselect(dm.q1, 'select * from tsrela where ocprog=' + g_q + este + g_q + // actualiza componentes SCRATCH y clase ETP
            ' and ocbib=' + g_q + cmbbiblioteca_text + g_q +
            ' and occlase=' + g_q + cmbclase_text + g_q +
            ' and pcclase=' + g_q + 'BFR' + g_q +
            ' and organizacion=' + g_q + 'BFR' + g_q +
            ' and hsistema=' + g_q + cmbsistema_text + g_q) then begin
            while not dm.q1.Eof do begin
                  dm.sqlupdate('update tsrela set hcbib=' + g_q + dm.q1.fieldbyname('pcbib').AsString + g_q +
                  '      ,hcprog=' + g_q + dm.q1.fieldbyname('pcprog').AsString + g_q +
                  ' where hcprog=' + g_q + dm.q1.fieldbyname('hcprog').AsString + g_q +
                  ' and   hcbib=' + g_q + 'SCRATCH' + g_q +
                  ' and   hcclase=' + g_q + 'BFR' + g_q +
                  ' and hsistema=' + g_q + cmbsistema_text + g_q);
               dm.q1.Next;
            end;
         end;
         //-------------------------------- Demás sistemas ----------------------------------------------------------------------------
         if b_otros_sistemas then begin
            if dm.sqlselect(dm.q1, 'select distinct hcbib,hcprog from tsrela where ocprog=' + g_q + este + g_q + // actualiza componentes SCRATCH y clase ETP
               ' and ocbib=' + g_q + cmbbiblioteca_text + g_q + // checa contra hijos porque la rutina puede no tener hijos
               ' and occlase=' + g_q + cmbclase_text + g_q +
               ' and hcclase=' + g_q + 'ETP' + g_q +
               ' and hcbib<>' + g_q + 'SCRATCH' + g_q) then begin
               while not dm.q1.Eof do begin
                  dm.sqlupdate('update tsrela set hcbib=' + g_q + dm.q1.fieldbyname('hcbib').AsString + g_q +
                     '      ,hcprog=' + g_q + dm.q1.fieldbyname('hcprog').AsString + g_q +
                     ' where hcprog=' + g_q + dm.q1.fieldbyname('hcprog').AsString + g_q +
                     ' and   hcbib=' + g_q + 'SCRATCH' + g_q +
                     ' and  hcclase=' + g_q + 'ETP' + g_q );
                  dm.q1.Next;
               end;
            end;
            if dm.sqlselect(dm.q1, 'select * from tsrela where ocprog=' + g_q + este + g_q + // actualiza componentes SCRATCH y clase ETP
               ' and ocbib=' + g_q + cmbbiblioteca_text + g_q +
               ' and occlase=' + g_q + cmbclase_text + g_q +
               ' and pcclase=' + g_q + 'BFR' + g_q +
               ' and organizacion=' + g_q + 'BFR' + g_q) then begin
               while not dm.q1.Eof do begin
                  dm.sqlupdate('update tsrela set hcbib=' + g_q + dm.q1.fieldbyname('pcbib').AsString + g_q +
                     '      ,hcprog=' + g_q + dm.q1.fieldbyname('pcprog').AsString + g_q +
                     ' where hcprog=' + g_q + dm.q1.fieldbyname('hcprog').AsString + g_q +
                     ' and   hcbib=' + g_q + 'SCRATCH' + g_q +
                     ' and hcclase=' + g_q + 'BFR' + g_q );
                  dm.q1.Next;
               end;
            end;
         end;
      end;
      reemplaza_basedef_userdef(origen);
      //============================= Actualiza componentes SCRATCH ===============================================================
      //--------------------- Da preferencia a los del mismo SISTEMA --------------------------------------------------------------
      dm.sqlupdate('update tsrela set hcbib=' + g_q + cmbbiblioteca_text + g_q + // actualiza componentes SCRATCH
         '      ,hcprog='+ g_q + este + g_q +
         ' where hcprog=' + g_q + este + g_q +
         ' and   hcbib=' + g_q + 'SCRATCH' + g_q +
         ' and   hcclase=' + g_q + cmbclase_text + g_q +
         ' and   hsistema=' + g_q + cmbsistema_text + g_q);
      dm.sqlupdate('update tsrela set hcbib=' + g_q + cmbbiblioteca_text + g_q + // actualiza componentes BD (TAB y STP) Hijo
         '      ,hcprog='+ g_q + este + g_q +
         ' where hcprog=' + g_q + este + g_q +
         ' and   hcbib=' + g_q + 'BD' + g_q +
         ' and   hcclase=' + g_q + cmbclase_text + g_q +
         ' and   hsistema=' + g_q + cmbsistema_text + g_q);
      dm.sqlupdate('update tsrela set pcbib=' + g_q + cmbbiblioteca_text + g_q + // actualiza componentes BD (TAB y STP) Padre
         ' where pcprog=' + g_q + este + g_q +
         ' and   pcbib=' + g_q + 'BD' + g_q +
         ' and   pcclase=' + g_q + cmbclase_text + g_q +
         ' and   hsistema=' + g_q + cmbsistema_text + g_q);
      dm.sqlupdate('update tsrela set hcclase=' + g_q + cmbclase_text + g_q + // actualiza componentes clase XXX
         '      ,hcprog='+ g_q + este + g_q +
         ' where hcprog=' + g_q + este + g_q +
         ' and   hcbib=' + g_q + cmbbiblioteca_text + g_q +
         ' and   hcclase=' + g_q + 'XXX' + g_q +
         ' and   hsistema=' + g_q + cmbsistema_text + g_q);
      dm.sqlupdate('update tsrela set hcbib=' + g_q + cmbbiblioteca_text + g_q + // actualiza componentes SCRATCH y clase XXX
         ', hcclase=' + g_q + cmbclase_text + g_q +
         ' ,hcprog='+ g_q + este + g_q +
         ' where hcprog=' + g_q + este + g_q +
         ' and   hcbib=' + g_q + 'SCRATCH' + g_q +
         ' and   hcclase=' + g_q + 'XXX' + g_q +
         ' and   hsistema=' + g_q + cmbsistema_text + g_q);
      dm.sqlupdate('update tsrela a set hcbib=NVL(' + // actualiza formas llamadas por su nombre lógico. Probablemente sirva para otros tipos (REVISAR)
         '  (select hcbib from tsrela ' +
         '   where pcclase=' + g_q + 'BFR' + g_q +
         '     and hcclase=' + g_q + 'WFO' + g_q +
         '     and hcbib<>' + g_q + 'SCRATCH' + g_q +
         '     and hcprog=a.hcprog ' +
         '     and hsistema=' + g_q + cmbsistema_text + g_q +
         '     and rownum=1),' + g_q + 'SCRATCH' + g_q + ')' +
         ' where hcclase=' + g_q + 'WFO' + g_q +
         '   and hcbib=' + g_q + 'SCRATCH' + g_q);
      //--------------------- Busca en todos los SISTEMAS --------------------------------------------------------------------------
      b_otros_sistemas := false;
      if b_otros_sistemas then begin
         dm.sqlupdate('update tsrela set hcbib=' + g_q + cmbbiblioteca_text + g_q + // actualiza componentes SCRATCH
            ' ,hcprog='+ g_q + este + g_q +
            ' where hcprog=' + g_q + este + g_q +
            ' and   hcbib=' + g_q + 'SCRATCH' + g_q +
            ' and   hcclase=' + g_q + cmbclase_text + g_q);
         dm.sqlupdate('update tsrela set hcbib=' + g_q + cmbbiblioteca_text + g_q + // actualiza componentes BD hijo
            ' ,hcprog='+ g_q + este + g_q +
            ' where hcprog=' + g_q + este + g_q +
            ' and   hcbib=' + g_q + 'BD' + g_q +
            ' and   hcclase=' + g_q + cmbclase_text + g_q);
         dm.sqlupdate('update tsrela set hcbib=' + g_q + cmbbiblioteca_text + g_q + // actualiza componentes BD padre
            ' where pcprog=' + g_q + este + g_q +
            ' and   pcbib=' + g_q + 'BD' + g_q +
            ' and   pcclase=' + g_q + cmbclase_text + g_q);
         dm.sqlupdate('update tsrela set hcclase=' + g_q + cmbclase_text + g_q + // actualiza componentes clase XXX
            ' ,hcprog='+ g_q + este + g_q +
            ' where hcprog=' + g_q + este + g_q +
            ' and   hcbib=' + g_q + cmbbiblioteca_text + g_q +
            ' and   hcclase=' + g_q + 'XXX' + g_q);
         dm.sqlupdate('update tsrela set hcbib=' + g_q + cmbbiblioteca_text + g_q + // actualiza componentes SCRATCH y clase XXX
            ', hcclase=' + g_q + cmbclase_text + g_q +
            ' ,hcprog='+ g_q + este + g_q +
            ' where hcprog=' + g_q + este + g_q +
            ' and   hcbib=' + g_q + 'SCRATCH' + g_q +
            ' and   hcclase=' + g_q + 'XXX' + g_q);
         dm.sqlupdate('update tsrela a set hcbib=NVL(' + // actualiza formas llamadas por su nombre lógico. Probablemente sirva para otros tipos (REVISAR)
            '  (select hcbib from tsrela ' +
            '   where pcclase=' + g_q + 'BFR' + g_q +
            '     and hcclase=' + g_q + 'WFO' + g_q +
            '     and hcbib<>' + g_q + 'SCRATCH' + g_q +
            '     and hcprog=a.hcprog ' +
            '     and rownum=1),' + g_q + 'SCRATCH' + g_q + ')' +
            ' where hcclase=' + g_q + 'WFO' + g_q +
            '   and hcbib=' + g_q + 'SCRATCH' + g_q);
      end;
      volumen_macro_cobol(cmbclase_text, cmbbiblioteca_text, este);
      volumen_cobol_macro(cmbclase_text, cmbbiblioteca_text, este);
      if chkparams_checked then begin
         copyfile(pchar(directorio_origen + '\' + compos[i]), pchar(copiado), false);
         if cmbclase_text = 'JOB' then begin
            tsparams_job(este, cmbbiblioteca_text, copiado);
         end;
         if cmbclase_text = 'JCL' then begin
            tsparams_jcl(este, cmbbiblioteca_text);
         end;
      end;
      if barra <> nil then
         barra.StepIt;
   end;
   deletefile(reservadas);
   deletefile(analizador);
   deletefile(g_ruta + 'nada.txt');
   deletefile(g_ruta + 'source.new');
   rxfuente.Free;
   recibeclick := true;
end;
//..................................................................
procedure checa_case_sensitive(sistema:string);         // debe ser llamado por ptsrecibe o la carga batch
begin
      if dm.sqlselect(dm.q1,'select * from parametro '+
         ' where clave='+g_q+'RECIBE_CASE_INSENSITIVE_'+sistema+g_q+
         ' and dato='+g_q+'TRUE'+g_q) then begin
         if nls_comp='' then begin
            if dm.sqlselect(dm.q1,'select value from v$nls_parameters '+
               ' where parameter='+g_q+'NLS_COMP'+g_q) then
               nls_comp:=dm.q1.fieldbyname('value').AsString;
            if dm.sqlselect(dm.q1,'select value from v$nls_parameters '+
               ' where parameter='+g_q+'NLS_SORT'+g_q) then
               nls_sort:=dm.q1.fieldbyname('value').AsString;
         end;
         dm.sqlupdate('alter session set nls_comp='+g_q+'LINGUISTIC'+g_q);
         dm.sqlupdate('alter session set nls_sort='+g_q+'BINARY_AI'+g_q);
         recibe_case_insensitive:=true;
      end
      else begin
         recibe_case_insensitive:=false;
      end;
end;
//..................................................................
procedure regresa_case_sensitive;         // debe ser llamado por ptsrecibe o la carga batch
begin
   if nls_comp<>'' then begin
      dm.sqlupdate('alter session set nls_comp='+g_q+nls_comp+g_q);
      dm.sqlupdate('alter session set nls_sort='+g_q+nls_sort+g_q);
   end;
   recibe_case_insensitive:=false;
end;

end.

