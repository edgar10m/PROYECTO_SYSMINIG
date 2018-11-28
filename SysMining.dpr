program SysMining;

{%ToDo 'SysMining.todo'}


 //userrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr
uses
  Forms,
  windows,
  ptsmain in 'ptsmain.pas' {ftsmain},
  ptsdm in 'ptsdm.pas' {dm: TDataModule},
  mgserial in 'mgserial.pas',
  pcatalog in 'pcatalog.pas' {fcatalog},
  pbrowse in 'pbrowse.pas' {fbrowse},
  ppasswrd in 'ppasswrd.pas' {fpasswrd},
  ptsrecibe in 'ptsrecibe.pas' {ftsrecibe},
  ptsutileria in 'ptsutileria.pas' {ftsutileria},
  parbol in 'parbol.pas' {farbol},
  svsdelphi in 'svsdelphi.pas' {fsvsdelphi},
  psvsfmb in 'psvsfmb.pas' {fsvsfmb},
  ptsdiagjcl in 'ptsdiagjcl.pas' {ftsdiagjcl},
  ptsdiagramas in 'ptsdiagramas.pas',
  ptspanel in 'ptspanel.pas' {ftspanel},
  ptsmapanat in 'ptsmapanat.pas' {ftsmapanat},
  facerca in 'facerca.pas' {facerc},
  mgflcob in 'mgflcob.pas' {fmgflcob},
  mgcodigo in 'mgcodigo.pas' {fmgcodigo},
  mgfrcob in 'mgfrcob.pas' {frcob: TFrame},
  ptsproperty in 'ptsproperty.pas' {ftsproperty},
  ptsvmlx in 'ptsvmlx.pas',
  mgflrpg in 'mgflrpg.pas' {fmgflrpg},
  mgfrclp in 'mgfrclp.pas' {frclp: TFrame},
  ptsdghtml in 'ptsdghtml.pas' {ftsdghtml},
  ptsversionado in 'ptsversionado.pas' {ftsversionado},
  pbarra in 'pbarra.pas' {fbarra},
  ExeMod in 'ExeMod.pas',
  ptsbms in 'ptsbms.pas' {ftsbms},
  ptsbfr in 'ptsbfr.pas' {ftsbfr},
  ptsattribute in 'ptsattribute.pas' {ftsattribute},
  ptsinventario in 'ptsinventario.pas' {ftsinventario},
  ptsadminctrusu in 'ptsadminctrusu.pas' {ftsadminctrusu},
  ptscaducidad in 'ptscaducidad.pas' {ftscaducidad},
  ptscnvprog in 'ptscnvprog.pas' {ftscnvprog},
  HTML_HELP in 'HTML_HELP.pas',
  HtmlHlp in 'HtmlHlp.pas',
  uDiagramaRutinas in 'uDiagramaRutinas.pas',
  pstviewhtml in 'pstviewhtml.pas' {ftsviewhtml},
  ptsanaprog in 'ptsanaprog.pas' {ftsanaprog},
  ptspropaga in 'ptspropaga.pas' {ftspropaga},
  uConstantes in 'uConstantes.pas',
  ufmSVSDiagrama in 'ufmSVSDiagrama.pas' {fmSVSDiagrama},
  ufmUMLPaquetes in 'ufmUMLPaquetes.pas' {fmUMLPaquetes},
  ptsCreaInd in 'ptscreaind.pas',
  ufmUMLClases in 'ufmUMLClases.pas' {fmUMLClases},
  ufmAnalisisImpacto in 'ufmAnalisisImpacto.pas' {fmAnalisisImpacto},
  ufmProcesos in 'ufmProcesos.pas' {fmProcesos},
  ptsscrsec in 'ptsscrsec.pas' {ftsscrsec},
  ufmSVSEditor in 'ufmSVSEditor.pas' {fmSVSEditor},
  ufmSVSLista in 'ufmSVSLista.pas' {fmSVSLista},
  uListaRutinas in 'uListaRutinas.pas',
  ufmDocumentacion in 'ufmDocumentacion.pas' {fmDocumentacion},
  ufmScheduler in 'ufmScheduler.pas' {fmScheduler},
  ufmClasesXProducto in 'ufmClasesXProducto.pas' {fmClasesXProducto},
  ufmBloques in 'ufmBloques.pas' {fmBloques},
  UfmListaCompo in 'UfmListaCompo.pas' {fmListaCompo},
  UfmMatrizCrud in 'UfmMatrizCrud.pas' {fmMatrizCrud},
  UfmListaDependencias in 'UfmListaDependencias.pas' {fmListaDependencias},
  UfmConsCom in 'ufmConsCom.pas' {fmConsCom},
  ufmSVSGrid in 'ufmSVSGrid.pas' {fmSVSGrid},
  ufmDocHistorial in 'ufmDocHistorial.pas' {fmDocHistorial},
  UfmRefCruz in 'UfmRefCruz.pas' {fmRefCruz},
  UfmMatrizAF in 'UfmMatrizAF.pas' {fmMatrizAF},
  ufmListaDrill in 'ufmListaDrill.pas' {fmListaDrill},
  ptscomun in 'ptscomun.pas',
  ptsrec in 'ptsrec.pas',
  ufmInvCompo in 'ufmInvCompo.pas' {fmInvCompo},
  ufmMatrizArchLog in 'ufmMatrizArchLog.pas' {fmMatrizArchLog},
  ufmDocSistema in 'ufmDocSistema.pas' {fmDocSistema},
  ufmDigraSistema in 'ufmDigraSistema.pas' {fmDigraSistema},
  uRutinasExcel in 'uRutinasExcel.pas',
  ufmSVSListaExcel in 'ufmSVSListaExcel.pas' {fmSVSListaExcel},
  ufmBuscaCompo in 'ufmBuscaCompo.pas' {fmBuscaCompo},
  ptsgral in 'ptsgral.pas' {gral},
  alkNuevoDiag in 'alkNuevoDiag.pas' {alkNuevoDiagrama},
  alkJerCla in 'alkJerCla.pas' {alkFormJerCla},
  alkScheduler in 'alkScheduler.pas' {alkFormScheduler},
  alkAnCom in 'alkAnCom.pas' {alkAnCompl},
  alkReingresaDocto in 'alkReingresaDocto.pas' {alkGridReingresa},
  GIFImage in 'GIFImage.pas',
  mORMotReport in 'mORMotReport.pas',
  SynCommons in 'SynCommons.pas',
  SynCrypto in 'SynCrypto.pas',
  SynGdiPlus in 'SynGdiPlus.pas',
  SynLZ in 'SynLZ.pas',
  SynPdf in 'SynPdf.pas',
  SynZip in 'SynZip.pas',
  alkDetTab in 'alkDetTab.pas' {alkFormDetTab},
  ptsconver in 'ptsconver.pas' {ftsconver},
  ptsestatica in 'ptsestatica.pas' {ftsestatica},
  alkConfDiag in 'alkConfDiag.pas' {alkFormConfDiag},
  alkDocAutoDinamica in 'alkDocAutoDinamica.pas' {alkFormDocAutoDinam},
  ptsmuerto in 'ptsmuerto.pas' {ftsmuerto},
  ptsgenera in 'ptsgenera.pas' {ftsgenera},
  ptsvaxfrm in 'ptsvaxfrm.pas' {ftsvaxfrm},
  ptspostrec in 'ptspostrec.pas',
  alkDocWord in 'alkDocWord.pas' {alkFormDocWord},
  fptpar in 'fptpar.pas' {ftsparametros},
  alkBrowse in 'alkBrowse.pas' {alkFormBrowse},
  formulario in '..\SysMining_Proyect\formulario.pas' {Form1},
  FRIMER_FROME in 'FRIMER_FROME.pas' {Form2},
  PRIMER_MODULO in 'PRIMER_MODULO.pas' {DataModule1: TDataModule},
  SEGUNDO_MODULO in 'SEGUNDO_MODULO.pas' {DataModule2: TDataModule};

{$R *.res}
begin
   Application.Initialize;
   Application.Title := 'Sys-Mining 7.0.30 ';
  Application.HelpFile := 'SysHelp\AyudaPrueba.chm';
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(Tftsmain, ftsmain);
  Application.CreateForm(Tgral, gral);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TDataModule2, DataModule2);
  Application.Run;
   //  ExitProcess(UINT(-1));
   //  exitprocess(0);
   //  dm.Free;
   //  ftsmain.Free;
   //  application.Terminate;
end.




