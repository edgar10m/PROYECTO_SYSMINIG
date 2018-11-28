unit ufmSVSEditor;

interface

uses
   //Graphics, //ActnList, //StdActns, //ToolWin, //ShellApi, //Printers, //StdCtrls, //ComCtrls,
   Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs, ImgList, Menus, ExtCtrls,
   //RVUni, //CRVFData, //RVItem, //CRVData, //RVFuncs,
   RVMisc, RVScroll, RichView, RVEdit, RVStyle, RVTable, RVNote,
   //RVFontCombos,
   RichViewActions, Ruler, RVRuler, RVALocalize, RVALocRuler,
   //
   SRVPageScroll, SclRView, SclRVRuler, SRVToolWindow, SRVToolBar, SRVALocalize,
   //SRVActions, //RVStyleFuncs,
   RVTypes,

   uConstantes,

   SRVActions, ActnList, dxBarDBNav, dxBar, cxControls, cxSplitter,
   dxBarExtItems, StdCtrls, RVStyleFuncs, RVFontCombos;

type
   TfmSVSEditor = class( TForm )
      RVAControlPanel1: TRVAControlPanel;
      RVAPopupMenu1: TRVAPopupMenu;
      ColorDialog1: TColorDialog;
      srvtwSearch: TSRVToolWindow;
      il1: TImageList;
      ilMenuV: TImageList;
      ilMenuH: TImageList;
      Panel1: TPanel;
      Panel3: TPanel;
      SclRVRuler1: TSclRVRuler;
      Panel4: TPanel;
      RVRulerItemSelector1: TRVRulerItemSelector;
      fd: TFindDialog;
      rd: TReplaceDialog;
      SclRVRuler2: TSclRVRuler;
      SRichViewEdit1: TSRichViewEdit;
      ImageList1: TImageList;
      ActionList1: TActionList;
      rvActionNew1: TrvActionNew;
      rvActionOpen1: TrvActionOpen;
      rvActionSave1: TrvActionSave;
      rvActionSaveAs1: TrvActionSaveAs;
      rvActionExport1: TrvActionExport;
      rvActionCut1: TrvActionCut;
      rvActionCopy1: TrvActionCopy;
      rvActionPaste1: TrvActionPaste;
      rvActionParagraph1: TrvActionParagraph;
      rvActionIndentInc1: TrvActionIndentInc;
      rvActionIndentDec1: TrvActionIndentDec;
      rvActionPasteAsText1: TrvActionPasteAsText;
      rvActionPasteSpecial1: TrvActionPasteSpecial;
      rvActionSelectAll1: TrvActionSelectAll;
      rvActionUndo1: TrvActionUndo;
      rvActionRedo1: TrvActionRedo;
      rvActionFonts1: TrvActionFonts;
      rvActionFontEx1: TrvActionFontEx;
      rvActionFontBold1: TrvActionFontBold;
      rvActionFontItalic1: TrvActionFontItalic;
      rvActionFontUnderline1: TrvActionFontUnderline;
      rvActionFontStrikeout1: TrvActionFontStrikeout;
      rvActionFontGrow1: TrvActionFontGrow;
      rvActionFontShrink1: TrvActionFontShrink;
      rvActionFontGrowOnePoint1: TrvActionFontGrowOnePoint;
      rvActionFontShrinkOnePoint1: TrvActionFontShrinkOnePoint;
      rvActionWordWrap1: TrvActionWordWrap;
      rvActionAlignLeft1: TrvActionAlignLeft;
      rvActionAlignRight1: TrvActionAlignRight;
      rvActionAlignCenter: TrvActionAlignCenter;
      rvActionAlignJustify1: TrvActionAlignJustify;
      rvActionInsertTable1: TrvActionInsertTable;
      rvActionTableInsertRowsAbove1: TrvActionTableInsertRowsAbove;
      rvActionTableInsertRowsBelow1: TrvActionTableInsertRowsBelow;
      rvActionTableInsertColLeft1: TrvActionTableInsertColLeft;
      rvActionTableInsertColRight1: TrvActionTableInsertColRight;
      rvActionTableDeleteRows1: TrvActionTableDeleteRows;
      rvActionTableDeleteCols1: TrvActionTableDeleteCols;
      rvActionTableDeleteTable1: TrvActionTableDeleteTable;
      rvActionTableMergeCells1: TrvActionTableMergeCells;
      rvActionTableSplitCells1: TrvActionTableSplitCells;
      rvActionTableSelectTable1: TrvActionTableSelectTable;
      rvActionTableSelectRows1: TrvActionTableSelectRows;
      rvActionTableSelectCols1: TrvActionTableSelectCols;
      rvActionTableSelectCell1: TrvActionTableSelectCell;
      rvActionFontAllCaps1: TrvActionFontAllCaps;
      rvActionFontOverline1: TrvActionFontOverline;
      rvActionFind1: TrvActionFind;
      rvActionFindNext1: TrvActionFindNext;
      rvActionReplace1: TrvActionReplace;
      rvActionFontColor1: TrvActionFontColor;
      rvActionFontBackColor1: TrvActionFontBackColor;
      rvActionParaColor1: TrvActionParaColor;
      rvActionColor1: TrvActionColor;
      rvActionFillColor1: TrvActionFillColor;
      rvActionInsertFile1: TrvActionInsertFile;
      rvActionInsertPicture1: TrvActionInsertPicture;
      rvActionLineSpacing1001: TrvActionLineSpacing100;
      rvActionLineSpacing1501: TrvActionLineSpacing150;
      rvActionLineSpacing2001: TrvActionLineSpacing200;
      rvActionInsertPageBreak1: TrvActionInsertPageBreak;
      rvActionRemovePageBreak1: TrvActionRemovePageBreak;
      rvActionTableCellVAlignTop1: TrvActionTableCellVAlignTop;
      rvActionTableCellVAlignMiddle1: TrvActionTableCellVAlignMiddle;
      rvActionTableCellVAlignBottom1: TrvActionTableCellVAlignBottom;
      rvActionTableCellVAlignDefault1: TrvActionTableCellVAlignDefault;
      rvActionParaBorder1: TrvActionParaBorder;
      rvActionItemProperties1: TrvActionItemProperties;
      rvActionInsertHLine1: TrvActionInsertHLine;
      rvActionInsertHyperlink1: TrvActionInsertHyperlink;
      rvActionTableProperties1: TrvActionTableProperties;
      rvActionTableGrid1: TrvActionTableGrid;
      rvActionParaList1: TrvActionParaList;
      rvActionInsertSymbol1: TrvActionInsertSymbol;
      rvActionTableCellLeftBorder1: TrvActionTableCellLeftBorder;
      rvActionTableCellRightBorder1: TrvActionTableCellRightBorder;
      rvActionTableCellTopBorder1: TrvActionTableCellTopBorder;
      rvActionTableCellBottomBorder1: TrvActionTableCellBottomBorder;
      rvActionTableCellAllBorders1: TrvActionTableCellAllBorders;
      rvActionTableCellNoBorders1: TrvActionTableCellNoBorders;
      rvActionParaBullets1: TrvActionParaBullets;
      rvActionParaNumbering1: TrvActionParaNumbering;
      rvActionBackground1: TrvActionBackground;
      rvActionTextRTL1: TrvActionTextRTL;
      rvActionTextLTR1: TrvActionTextLTR;
      rvActionParaRTL1: TrvActionParaRTL;
      rvActionParaLTR1: TrvActionParaLTR;
      rvActionCharCase1: TrvActionCharCase;
      rvActionShowSpecialCharacters1: TrvActionShowSpecialCharacters;
      rvActionSubscript1: TrvActionSubscript;
      rvActionSuperscript1: TrvActionSuperscript;
      rvActionClearLeft1: TrvActionClearLeft;
      rvActionClearRight1: TrvActionClearRight;
      rvActionClearBoth1: TrvActionClearBoth;
      rvActionClearNone1: TrvActionClearNone;
      rvActionVAlign1: TrvActionVAlign;
      rvActionRemoveHyperlinks1: TrvActionRemoveHyperlinks;
      srvActionQuickPrint1: TsrvActionQuickPrint;
      srvActionPrint1: TsrvActionPrint;
      srvActionPageSetup1: TsrvActionPageSetup;
      srvActionLayoutPrint1: TsrvActionLayoutPrint;
      srvActionLayoutWeb1: TsrvActionLayoutWeb;
      srvActionLayoutDraft1: TsrvActionLayoutDraft;
      srvActionZoom1: TsrvActionZoom;
      srvActionZoomPageWidth1: TsrvActionZoomPageWidth;
      srvActionZoomFullPage1: TsrvActionZoomFullPage;
      srvActionOrientationPortrait1: TsrvActionOrientationPortrait;
      srvActionOrientationLandscape1: TsrvActionOrientationLandscape;
      srvActionEditHeader1: TsrvActionEditHeader;
      srvActionEditFooter1: TsrvActionEditFooter;
      srvActionEditMain1: TsrvActionEditMain;
      srvActionPageFormatA4: TsrvActionPageFormat;
      srvActionPageFormatA5: TsrvActionPageFormat;
      srvActionPageFormatA6: TsrvActionPageFormat;
      srvActionPageFormatLetter: TsrvActionPageFormat;
      srvActionPageFormatLegal: TsrvActionPageFormat;
      srvActionPageFormatTest: TsrvActionPageFormat;
      srvActionPreview1: TsrvActionPreview;
      srvActionThumbnails1: TsrvActionThumbnails;
      srvActionInsertFootnote1: TsrvActionInsertFootnote;
      srvActionInsertEndnote1: TsrvActionInsertEndnote;
      srvActionReturnToNote1: TsrvActionReturnToNote;
      srvActionEditNote1: TsrvActionEditNote;
      rvActionHide1: TrvActionHide;
      rvActionTableCellRotationNone1: TrvActionTableCellRotationNone;
      rvActionTableCellRotation901: TrvActionTableCellRotation90;
      rvActionTableCellRotation1801: TrvActionTableCellRotation180;
      rvActionTableCellRotation2701: TrvActionTableCellRotation270;
      rvActionTableSplit1: TrvActionTableSplit;
      rvActionTableToText1: TrvActionTableToText;
      rvActionTableSort1: TrvActionTableSort;
      rvActionAddStyleTemplate1: TrvActionAddStyleTemplate;
      rvActionClearFormat1: TrvActionClearFormat;
      rvActionClearTextFormat1: TrvActionClearTextFormat;
      rvActionStyleInspector1: TrvActionStyleInspector;
      rvActionStyleTemplates1: TrvActionStyleTemplates;
      mnuPrincipal: TdxBarManager;
      mnuArchivo: TdxBarSubItem;
      mnuNuevo: TdxBarButton;
      mnuAbrir: TdxBarButton;
      mnuGuardar: TdxBarButton;
      mnuGuardarComo: TdxBarButton;
      mnuExportar: TdxBarButton;
      mnuImprimir: TdxBarButton;
      mnuPaginaConf: TdxBarButton;
      mnuSalirYGuardar: TdxBarButton;
      cxSplitter1: TcxSplitter;
      SRVPageScroll1: TSRVPageScroll;
      mnuCortar: TdxBarButton;
      mnuCopiar: TdxBarButton;
      mnuPegar: TdxBarButton;
      mnuPegarComoTexto: TdxBarButton;
      mnuPegarEspecial: TdxBarButton;
      mnuSeleccionarTodo: TdxBarButton;
      mnuDeshacer: TdxBarButton;
      mnuRehacer: TdxBarButton;
      mnuBuscar: TdxBarButton;
      mnuBuscarSiguiente: TdxBarButton;
      mnuRemplazar: TdxBarButton;
      mnuCasoDeCaracteres: TdxBarButton;
      mnuEdicion: TdxBarSubItem;
      mnuStandard: TdxBarButton;
      mnuFontAvanzado: TdxBarButton;
      mnuTextoColor: TdxBarButton;
      mnuTextoBckColor: TdxBarButton;
      mnuEstilo: TdxBarSubItem;
      mnuTamanio: TdxBarSubItem;
      mnuBold: TdxBarButton;
      mnuItalic: TdxBarButton;
      mnuUnderline: TdxBarButton;
      mnuStrikeOut: TdxBarButton;
      mnuSubScript: TdxBarButton;
      mnuSuperScript: TdxBarButton;
      mnuAllCapitals: TdxBarButton;
      mnuOverline: TdxBarButton;
      mnuShrinkFont: TdxBarButton;
      mnuGrowFont: TdxBarButton;
      mnuShrinkFontByOnePoint: TdxBarButton;
      mnuGrowFontByOnePoint: TdxBarButton;
      mnuFuente: TdxBarSubItem;
      mnuParrafo: TdxBarSubItem;
      dxBarButton1: TdxBarButton;
      dxBarButton2: TdxBarButton;
      dxBarButton3: TdxBarButton;
      dxBarButton4: TdxBarButton;
      dxBarButton5: TdxBarButton;
      dxBarButton6: TdxBarButton;
      dxBarButton7: TdxBarButton;
      dxBarButton8: TdxBarButton;
      dxBarButton9: TdxBarButton;
      dxBarButton10: TdxBarButton;
      dxBarButton11: TdxBarButton;
      dxBarButton12: TdxBarButton;
      dxBarButton13: TdxBarButton;
      dxBarButton14: TdxBarButton;
      dxBarButton15: TdxBarButton;
      dxBarSubItem2: TdxBarSubItem;
      dxBarButton16: TdxBarButton;
      dxBarButton17: TdxBarButton;
      dxBarButton18: TdxBarButton;
      dxBarButton19: TdxBarButton;
      dxBarButton20: TdxBarButton;
      mnuFormato: TdxBarSubItem;
      dxBarButton21: TdxBarButton;
      dxBarButton22: TdxBarButton;
      dxBarButton23: TdxBarButton;
      dxBarButton24: TdxBarButton;
      dxBarButton25: TdxBarButton;
      dxBarButton26: TdxBarButton;
      dxBarButton27: TdxBarButton;
      dxBarButton28: TdxBarButton;
      dxBarButton29: TdxBarButton;
      dxBarButton30: TdxBarButton;
      dxBarButton31: TdxBarButton;
      dxBarButton32: TdxBarButton;
      mnuInsertar: TdxBarSubItem;
      dxBarButton33: TdxBarButton;
      dxBarButton34: TdxBarButton;
      dxBarButton35: TdxBarButton;
      dxBarButton36: TdxBarButton;
      dxBarButton37: TdxBarButton;
      dxBarButton38: TdxBarButton;
      dxBarButton39: TdxBarButton;
      dxBarButton40: TdxBarButton;
      dxBarButton41: TdxBarButton;
      mnuTabla: TdxBarSubItem;
      dxBarButton42: TdxBarButton;
      dxBarButton43: TdxBarButton;
      dxBarButton44: TdxBarButton;
      dxBarButton45: TdxBarButton;
      dxBarButton46: TdxBarButton;
      dxBarButton47: TdxBarButton;
      dxBarButton48: TdxBarButton;
      dxBarButton49: TdxBarButton;
      dxBarButton50: TdxBarButton;
      dxBarSubItem1: TdxBarSubItem;
      dxBarSubItem3: TdxBarSubItem;
      dxBarSubItem4: TdxBarSubItem;
      dxBarSubItem5: TdxBarSubItem;
      dxBarButton51: TdxBarButton;
      dxBarButton52: TdxBarButton;
      dxBarButton53: TdxBarButton;
      dxBarButton54: TdxBarButton;
      dxBarButton55: TdxBarButton;
      dxBarButton56: TdxBarButton;
      dxBarButton57: TdxBarButton;
      dxBarButton58: TdxBarButton;
      dxBarButton59: TdxBarButton;
      dxBarButton60: TdxBarButton;
      dxBarButton61: TdxBarButton;
      dxBarButton62: TdxBarButton;
      dxBarButton63: TdxBarButton;
      dxBarButton64: TdxBarButton;
      dxBarButton65: TdxBarButton;
      dxBarButton66: TdxBarButton;
      dxBarButton67: TdxBarButton;
      dxBarButton68: TdxBarButton;
      dxBarButton69: TdxBarButton;
      dxBarButton70: TdxBarButton;
      dxBarButton71: TdxBarButton;
      dxBarButton72: TdxBarButton;
      dxBarButton73: TdxBarButton;
      dxBarButton74: TdxBarButton;
      mnuQuickPrint: TdxBarButton;
      mnuShowSpecialCharacters: TdxBarButton;
      cmbFuenteEstilo: TRVStyleTemplateComboBox;
      mnuFuenteEstilo: TdxBarControlContainerItem;
      cmbFontCombo: TRVFontComboBox;
      mnuFontCombo: TdxBarControlContainerItem;
      cmbFontSize: TRVFontSizeComboBox;
      mnuFontSize: TdxBarControlContainerItem;
      dxBarButton77: TdxBarButton;
      dxBarButton78: TdxBarButton;
      dxBarButton79: TdxBarButton;
      mnuPreview: TdxBarButton;
      mnuMiniaturas: TdxBarButton;
      mnuSalirSinGuardar: TdxBarButton;
      procedure FormCreate( Sender: TObject );
      procedure FormCloseQuery( Sender: TObject; var CanClose: Boolean );
      procedure mitExitClick( Sender: TObject );
      procedure RichViewEdit1_Jump( Sender: TObject; id: Integer );
      procedure RichViewEdit1_ReadHyperlink( Sender: TCustomRichView;
         const Target, Extras: String; DocFormat: TRVLoadFormat; var StyleNo: Integer;
         var ItemTag: TRVTag; var ItemName: TRVRawByteString );
      procedure Button1Click( Sender: TObject );
      procedure RVAControlPanel1MarginsChanged( Sender: TrvAction;
         Edit: TCustomRichViewEdit );
      procedure RVAControlPanel1Download( Sender: TrvAction;
         const Source: String );
      procedure RichViewEdit1_KeyDown( Sender: TObject; var Key: Word;
         Shift: TShiftState );
      procedure pmFakeDropDownPopup( Sender: TObject );
      procedure RichViewEdit1_KeyPress( Sender: TObject; var Key: Char );
      procedure cmbZoomChange( Sender: TObject );
      procedure SRichViewEdit1CurrentPageChange( Sender: TObject );
      procedure SRichViewEdit1HMenuClickButton( Sender: TObject;
         ToolButton: TSRVToolButton );
      procedure SRichViewEdit1PageScrolled( Sender: TObject );
      procedure SRichViewEdit1VMenuClickButton( Sender: TObject;
         ToolButton: TSRVToolButton );
      procedure SRichViewEdit1CaretMove( Sender: TObject );
      procedure srvtwSearchClickButton( Sender: TObject;
         ToolButton: TSRVToolButton );
      procedure fdFind( Sender: TObject );
      procedure SclRVRuler1MarginDblClick( Sender: TObject;
         Margin: TMarginType );
      procedure RVAControlPanel1BackgroundChange( Sender: TrvAction;
         Edit: TCustomRichViewEdit );
      procedure SRichViewEdit1TableIconClick( Sender: TSRichViewEdit;
         Button: TMouseButton; Shift: TShiftState; X, Y, PageNo: Integer );
      procedure RVAControlPanel1ViewChanged( Sender: TrvCustomAction;
         Edit: TCustomRichViewEdit );
      procedure SRichViewEdit1ZoomChanged( Sender: TObject );
      procedure cmbUnitsClick( Sender: TObject );
      procedure SRichViewEdit1Progress( Sender: TCustomRichView;
         Operation: TRVLongOperation; Stage: TRVProgressStage;
         PercentDone: Byte );
      procedure SRichViewEdit1Printing( Sender: TSRichViewEdit;
         PageCompleted: Integer; Step: TRVPrintingStep );
      procedure SRichViewEdit1Change( Sender: TObject );
      procedure FormClose( Sender: TObject; var Action: TCloseAction );
      procedure mnuSalirYGuardarClick( Sender: TObject );
      procedure mnuSalirSinGuardarClick( Sender: TObject );
      procedure FormDestroy( Sender: TObject );
   private
      { Private declarations }
      bPriNuevo: Boolean; //indica si es un nuevo documento
      bModificado: Boolean; //indica si el docto se modifico
      bSalirSinGuardar: Boolean; //indica si sale del editor sin guardar cambios

      iPriIDDocto: Integer;
      sPriNombre: String;
      sPriCClase, sPriCBib, sPriCProg: String;

      sPriTitulo: String;
      //sPriCBlob: String;
      //sPriDocumento: String;

      VToolButtonIndex: Integer;
      UpdatingCombos: Boolean;
      procedure ColorPickerShow( Sender: TObject );
      procedure ColorPickerHide( Sender: TObject );
      procedure rvActionSave1DocumentFileChange( Sender: TObject;
         Editor: TCustomRichViewEdit; const FileName: String;
         FileFormat: TrvFileSaveFilter; IsNew: Boolean );
      procedure ApplicationHint( Sender: TObject );
      procedure Localize;
      procedure srvActionThumbnails1Executed( Sender: TObject );
   public
      { Public declarations }
      //sPubArchivo: String;
      //PubfmDocumentacion: TfmDocumentacion;
   end;

implementation
uses
   ptsdm, ptsMain, ufmDocumentacion, ptsgral, uListaRutinas; //Math;

{$R *.dfm}

procedure ShowInfo( const msg, cpt: String );
begin
   Application.MessageBox( PChar( msg ), PChar( cpt ), MB_OK or MB_ICONINFORMATION );
end;
{------------------------------------------------------------------------------}

procedure TfmSVSEditor.FormCreate( Sender: TObject );
var
   sTituloDocto: String;
begin
   mnuPrincipal.Style := gral.iPubEstiloActivo;

   if gral.iPubVentanasActivas > 0 then
      gral.PubExpandeMenuVentanas( True );

   iPriIDDocto := iGlbIDDocto;
   sPriNombre := sGlbNombre;

   sPriCClase := sGlbCClase; //clase
   sPriCBib := sGlbCBib; //biblioteca
   sPriCProg := sGlbCProg; //programa

   sPriTitulo := sGlbTitulo; //titulo
   //sPriCBlob := sGlbCBlob; //cblob
   //sPriDocumento := sGlbDocumento; //documento

   bPriNuevo := sPriNombre = '';

   // Almost all these assignments could be done at design time in the Object Inspector
   // But in this demo we do not want to modify srvActionsResource
   // (and we recommend to use a copy of it in your applications)

   //rvActionSave1.OnDocumentFileChange := rvActionSave1DocumentFileChange; //fercar, no se utilizara

   // Styles
   rvActionStyleInspector1.Control := SRichViewEdit1;

   // Code for making color-picking buttons stay pressed while a
   // color-picker window is visible.
   rvActionColor1.OnShowColorPicker := ColorPickerShow;
   rvActionColor1.OnHideColorPicker := ColorPickerHide;
   rvActionParaColor1.OnShowColorPicker := ColorPickerShow;
   rvActionParaColor1.OnHideColorPicker := ColorPickerHide;
   rvActionFontColor1.OnShowColorPicker := ColorPickerShow;
   rvActionFontColor1.OnHideColorPicker := ColorPickerHide;
   rvActionFontBackColor1.OnShowColorPicker := ColorPickerShow;
   rvActionFontBackColor1.OnHideColorPicker := ColorPickerHide;

   // Index of the last clicked button in search toolwindow
   VToolButtonIndex := -1;

   // Initializing the action for showing/hiding thumbnails
   srvActionThumbnails1.PageScroll := SRVPageScroll1;
   srvActionThumbnails1.OnExecuted := srvActionThumbnails1Executed;

   // Delphi 4 and 5 do not have ActionComponent property for actions.
   // Coloring actions have a substitution - CallerControl property
   // It is ignored in Delphi 6+
   {srvActionsResource.rvActionParaColor1.CallerControl := ToolButton39;
   srvActionsResource.rvActionFontBackColor1.CallerControl := ToolButton38;
   srvActionsResource.rvActionFontColor1.CallerControl := ToolButton36;}//fercar

   // Applying the default language
   Localize;

   // Displaying hints on the status bar
   Application.OnHint := ApplicationHint;

   // measuring units
   //RVA_ConvertToTwips( srvActionsResource );
   RVA_ConvertToTwips( Self );
   RVAControlPanel1.UnitsProgram := rvstuTwips;
   SRichViewEdit1.ConvertToTwips;

   //cmbUnits.ItemIndex := ord( SRichViewEdit1.UnitsProgram ); fercar
   RVAControlPanel1.UnitsDisplay := SRichViewEdit1.UnitsProgram;

   //en lugar de rvActionSave1DocumentFileChange
   sTituloDocto := sPriTitulo;

   srvActionPrint1.Title := sTituloDocto;
   srvActionQuickPrint1.Title := sTituloDocto;

   Caption := sTituloDocto;

   //activo porque SRVPageScroll1 esta activo al inicio
   mnuMiniaturas.Down := True;

   //temporal, el cambio de lenguaje es por medio de RVALocaliza
   mnuGuardarComo.Caption := 'Guardar &Copia...';

   if not bPriNuevo then begin
      //Loading initial file via ActionOpen (allowing to update user interface)
      //srvActionsResource.rvActionOpen1.LoadFile( SRichViewEdit1.RichViewEdit,
         //ExtractFilePath( Application.ExeName ) + 'readme.rvf', ffiRVF );
      rvActionOpen1.LoadFile( SRichViewEdit1.RichViewEdit, g_tmpdir + '\' + sPriNombre, ffiRTF );

      //DeleteFile( g_tmpdir + '\' + sPriNombre );
   end
   else begin
      // alternative way to start
      rvActionNew1.ExecuteTarget( SRichViewEdit1.RichViewEdit );
   end;

   //inicializar la variable en caso de que si hayan modificado el docto
   //y salgan de la ventana con [x]
   bSalirSinGuardar := True;
end;

{------------------- Working with document ------------------------------------}

// When document is created, saved, loaded...

procedure TfmSVSEditor.rvActionSave1DocumentFileChange( Sender: TObject;
   Editor: TCustomRichViewEdit; const FileName: String;
   FileFormat: TrvFileSaveFilter; IsNew: Boolean );
var
   //sNombreArchivo: String;
   sTituloDocto: String;
begin
   {sNombreArchivo := ExtractFileName( FileName );
   srvActionPrint1.Title := sNombreArchivo;
   srvActionQuickPrint1.Title := sNombreArchivo;

   if IsNew then
      sNombreArchivo := sNombreArchivo + ' (*)';

   Caption := sNombreArchivo + ' - SysViewSoft';}//original

   if IsNew then
      sTituloDocto := 'Sin Titulo'
   else
      sTituloDocto := sPriTitulo;

   srvActionPrint1.Title := sTituloDocto;
   srvActionQuickPrint1.Title := sTituloDocto;

   Caption := sTituloDocto;
end;

// Prompt for saving...

procedure TfmSVSEditor.FormCloseQuery( Sender: TObject; var CanClose: Boolean );
var
   i: Integer;
   sFecha, sMagic, sTipo: String;
   sCBlobActual: String;

   //// TSDOCUMENTO
   iIDDOCTO: Integer; // NUMBER(9) NOT NULL, -- PK
   sNOMBRE: String; // VARCHAR2(100) NOT NULL, -- IDX1 UNIQUE
   sEXTENSION: String; //VARCHAR2(20) NULL,
   sUSUARIO_ALTA: String; //VARCHAR2(50) NOT NULL,
   sCPROG: String; //VARCHAR2(250) NOT NULL, -- IDX1 UNIQUE
   sCBIB: String; //VARCHAR2(250) NOT NULL, -- IDX1 UNIQUE
   sCCLASE: String; //VARCHAR2(10) NOT NULL, -- IDX1 UNIQUE
   sDESCRIPCION: String; //VARCHAR2(500) NULL,
   sUSUARIO_ESTATUS: String; //VARCHAR2(50) NULL

   //// TSDOCREVISION
   iIDREVISION: Integer; // NUMBER(9) NOT NULL, -- PK -- incremental por IDDOCTO
   sUSUARIO_REV: String; // VARCHAR2(50) NOT NULL, -- FK

   //// TSDOCBLOB
   iTAMNORMAL: Integer; // NUMBER(9) NULL, -- tamaño normal en bytes
   iTAMCRC: Integer; // NUMBER(9) NULL, -- tamaño comprimido (rar) en bytes

   bErrorTransaccion: Boolean;

   function bInsertarTSDOCUMENTO: Boolean;
   var
      sInsert: String;
   begin
      iIDDOCTO := dm.iObtenerID( 'TSDOCUMENTO', 0 );

      sInsert := 'INSERT INTO TSDOCUMENTO(' +
         'IDDOCTO, NOMBRE, EXTENSION, USUARIO_ALTA,' +
         'CPROG, CBIB, CCLASE, DESCRIPCION, FECHA_ESTATUS, USUARIO_ESTATUS ) VALUES (' +
         IntToStr( iIDDOCTO ) + ',' +
         g_q + sNOMBRE + g_q + ',' +
         g_q + sEXTENSION + g_q + ',' +
         g_q + sUSUARIO_ALTA + g_q + ',' +
         g_q + sCPROG + g_q + ',' +
         g_q + sCBIB + g_q + ',' +
         g_q + sCCLASE + g_q + ',' +
         g_q + sDESCRIPCION + g_q + ',' +
         'SYSDATE,' +
         g_q + sUSUARIO_ESTATUS + g_q + ')';

      if not dm.sqlinsert( sInsert ) then begin
         Application.MessageBox( 'ERROR... no puede insertar en tsdocumento',
            'Agregar ', MB_OK );
         Result := False;
      end
      else
         Result := True;
   end;

   function bInsertarTSDOCREVISION: Boolean;
   var
      sInsert: String;
   begin
      iIDREVISION := dm.iObtenerID( 'TSDOCREVISION', iIDDOCTO );

      sInsert := 'INSERT INTO TSDOCREVISION(' +
         'IDDOCTO, IDREVISION, USUARIO_REV, FECHA_INICIO, FECHA_FIN ) VALUES (' +
         IntToStr( iIDDOCTO ) + ',' +
         IntToStr( iIDREVISION ) + ',' +
         g_q + sUSUARIO_REV + g_q + ',' +
         'SYSDATE,' +
         'SYSDATE ' + ')';

      if not dm.sqlinsert( sInsert ) then begin
         Application.MessageBox( 'ERROR... no puede insertar en tsdocrevision',
            'Agregar ', MB_OK );
         Result := False;
      end
      else
         Result := True;
   end;

begin
   CanClose := False;
   try
      if bModificado then begin
         if bSalirSinGuardar then begin
            if Application.MessageBox(
               pchar( 'Existen cambios en el documento, ' + chr( 13 ) +
               '¿Está seguro de salir sin guardar los cambios?' ), 'Confirmar',
               MB_ICONQUESTION OR MB_YESNO ) = IDNO then
               Exit;

            CanClose := True;
            Exit;
         end;

         if bPriNuevo then begin
            //TSDOCUMENTO
            if not InputQuery( 'Capture', 'Nombre del documento', sNOMBRE ) then
               Exit;

            if bGlbQuitaCaracteres( sNOMBRE ) then begin
               Application.MessageBox( Pchar( 'El Nombre del documento no puede contener ninguno ' + chr( 13 ) +
                  'de los siguientes caracteres: \:*?"<>|/' ),
                  Pchar( 'Aviso' ), MB_OK );
               Exit;
            end;

            if Trim( sNOMBRE ) = '' then begin
               Application.MessageBox( Pchar( 'Nombre de documento incorrecto o en blanco' ),
                  Pchar( 'Aviso' ), MB_OK );
               Exit;
            end;

            sEXTENSION := LowerCase( ExtractFileExt( sNOMBRE ) );

            if sEXTENSION <> '.rtf' then begin
               sEXTENSION := '.rtf';
               sNOMBRE := sNOMBRE + sEXTENSION;
            end;

            sUSUARIO_ALTA := g_usuario;
            sCPROG := sPriCProg;
            sCBIB := sPriCBib;
            sCCLASE := sPriCClase;
            sDESCRIPCION := '.'; //sustituir por un dialogo con TMemo
            sUSUARIO_ESTATUS := g_usuario;

            //valida que no se duplique el docto por: nombre,prog,bib,clase
            if dm.bPubDocumentoExiste( sNOMBRE, sCPROG, sCBIB, sCCLASE ) then begin
               Application.MessageBox( Pchar( 'El nombre de documento ya existe.' + chr( 13 ) +
                  'Registre uno diferente. O bien,' + chr( 13 ) +
                  'cargue una nueva version en: Menu - Agregar' ), Pchar( 'Aviso' ), MB_OK );
               Exit;
            end;

            dm.ADOConnection1.BeginTrans;
            try
               bErrorTransaccion := False;

               if bInsertarTSDOCUMENTO then begin
                  //TSDOCREVISION
                  sUSUARIO_REV := g_usuario;
                  if bInsertarTSDOCREVISION then begin
                     //TSDOCBLOB
                     iTAMNORMAL := 0;
                     iTAMCRC := 0;

                     sPriNombre := g_tmpdir + '\' + sNOMBRE; // + sEXTENSION;

                     try
                        SRichViewEdit1.RichViewEdit.SaveRTF( sPriNombre, False );
                     except
                        bErrorTransaccion := True;
                        Application.MessageBox( 'Error... no se puede asignar el nombre al documento',
                           'Aviso', MB_OK );
                     end;

                     if not bErrorTransaccion then
                        if not dm.bInsertarTSDOCBLOB(
                           iIDDOCTO, iIDREVISION, iTAMNORMAL, iTAMCRC, sPriNombre ) then
                           bErrorTransaccion := True;
                  end
                  else
                     bErrorTransaccion := True;
               end
               else
                  bErrorTransaccion := True;

            finally
               if bErrorTransaccion then
                  dm.ADOConnection1.RollbackTrans
               else
                  dm.ADOConnection1.CommitTrans;
            end;

            CanClose := True;

            with ftsMain do
               for i := 0 to MDIChildCount - 1 do
                  if MDIChildren[ i ].ClassName = 'TfmDocumentacion' then
                     with ( MDIChildren[ i ] as TfmDocumentacion ) do
                        if bPubPoblarTabla then begin
                           GlbHabilitarOpcionesMenu( mnuPrincipal, tabDatos.RecordCount > 0 );
                           PubHabilitarOpcionesMenu( tabDatos.RecordCount > 0 );

                           GlbCargarLista( grdEspejo, grdEspejoDBTableView1, slPubLista );
                        end;
         end
         else begin //NO nuevo
            dm.ADOConnection1.BeginTrans;
            try
               bErrorTransaccion := False;

               sPriNombre := g_tmpdir + '\' + sPriNombre;
               try
                  SRichViewEdit1.RichViewEdit.SaveRTF( sPriNombre, False );
               except
                  bErrorTransaccion := True;
                  Application.MessageBox( 'Error... no se puede asignar el nombre al documento',
                     'Aviso', MB_OK );
               end;

               iIDDOCTO := iPriIDDocto;
               sUSUARIO_REV := g_usuario;

               if not bErrorTransaccion then begin
                  if bInsertarTSDOCREVISION then begin
                     //TSDOCBLOB
                     iTAMNORMAL := 0;
                     iTAMCRC := 0;

                     if not dm.bInsertarTSDOCBLOB(
                        iIDDOCTO, iIDREVISION, iTAMNORMAL, iTAMCRC, sPriNombre ) then
                        bErrorTransaccion := True;
                  end
                  else
                     bErrorTransaccion := True;
               end;

            finally
               if bErrorTransaccion then
                  dm.ADOConnection1.RollbackTrans
               else
                  dm.ADOConnection1.CommitTrans;
            end;

            CanClose := True;

            with ftsMain do
               for i := 0 to MDIChildCount - 1 do
                  if MDIChildren[ i ].ClassName = 'TfmDocumentacion' then
                     with ( MDIChildren[ i ] as TfmDocumentacion ) do
                        if bPubPoblarTabla then begin
                           GlbHabilitarOpcionesMenu( mnuPrincipal, tabDatos.RecordCount > 0 );
                           PubHabilitarOpcionesMenu( tabDatos.RecordCount > 0 );
                           GlbCargarLista( grdEspejo, grdEspejoDBTableView1, slPubLista );
                        end;
         end;

         DeleteFile( sPriNombre );
      end
      else
         CanClose := True;
   finally
      if not bPriNuevo then
         DeleteFile( g_tmpdir + '\' + sPriNombre );
   end;
end;

procedure TfmSVSEditor.mitExitClick( Sender: TObject );
begin
end;

{--------------- Working with color-picking buttons ---------------------------}

// Code for making color-picking buttons pressed while
// a color-picker window is visible.

procedure TfmSVSEditor.ColorPickerShow( Sender: TObject );
begin
   {
   if TrvActionCustomColor( Sender ).CallerControl <> nil then
     TToolButton( TrvActionCustomColor( Sender ).CallerControl ).Down := True;
   }//fercar
end;

procedure TfmSVSEditor.ColorPickerHide( Sender: TObject );
begin
   {
   if TrvActionCustomColor( Sender ).CallerControl <> nil then
       TToolButton( TrvActionCustomColor( Sender ).CallerControl ).Down := False;
   }//fercar
end;

{-------------- Set of events for processing hypertext links ------------------}

// Hyperlink click

procedure TfmSVSEditor.RichViewEdit1_Jump( Sender: TObject; id: Integer );
begin
   rvActionInsertHyperlink1.GoToLink( SRichViewEdit1.ActiveEditor, id );
end;

// Importing hyperlink

procedure TfmSVSEditor.RichViewEdit1_ReadHyperlink( Sender: TCustomRichView;
   const Target, Extras: String; DocFormat: TRVLoadFormat; var StyleNo: Integer;
   var ItemTag: TRVTag; var ItemName: TRVRawByteString );
begin
   if DocFormat = rvlfURL then
      StyleNo :=
         rvActionInsertHyperlink1.GetHyperlinkStyleNo( ( Sender as TCustomRichViewEdit ) );
   ItemTag := rvActionInsertHyperlink1.EncodeTarget( Target );
end;

// URL detection on typing

procedure TfmSVSEditor.RichViewEdit1_KeyDown( Sender: TObject; var Key: Word;
   Shift: TShiftState );
begin
   if Key in [ VK_SPACE, VK_RETURN, VK_TAB ] then begin
      {
        // uncomment if you use Addict3
        RVA_Addict3AutoCorrect(SRichViewEdit1.ActiveEditor);
      }
      rvActionInsertHyperlink1.DetectURL( SRichViewEdit1.ActiveEditor );
      rvActionInsertHyperlink1.TerminateHyperlink( SRichViewEdit1.ActiveEditor );
   end;
end;

procedure TfmSVSEditor.RichViewEdit1_KeyPress( Sender: TObject; var Key: Char );
begin
   {
   // uncomment if you use Addict3
   if (Key='''') or ((Key<>' ') and (Pos(Key, SRichViewEdit1.ActiveEditor.Delimiters)<>0)) then
     RVA_Addict3AutoCorrect(SRichViewEdit1.ActiveEditor);
   }
end;

{----------------------- Insert table popup      -----------------------------}
{ We use a trick: insert-table button has style tbsDropDown and assigned
  DropDownMenu (pmFakeDropDown). This menu is empty, but shows table size
  popup instead of itself }

procedure TfmSVSEditor.pmFakeDropDownPopup( Sender: TObject );
begin
   //rvActionInsertTable1.ShowTableSizeDialog(
      //SRichViewEdit1.ActiveEditor, ToolButton12 ); fercar
end;

{---------------------- Zooming combo box -------------------------------------}
// We could implement zooming using only actions, without a combo box

procedure TfmSVSEditor.RVAControlPanel1ViewChanged( Sender: TrvCustomAction;
   Edit: TCustomRichViewEdit );
begin
   SRichViewEdit1ZoomChanged( Edit );
end;

procedure TfmSVSEditor.SRichViewEdit1ZoomChanged( Sender: TObject );
begin
   {UpdatingCombos := True;
   try
      case SRichViewEdit1.ViewProperty.ZoomMode of
         rvzmPageWidth:
            cmbZoom.ItemIndex := cmbZoom.Items.Count - 2;
         rvzmFullPage:
            cmbZoom.ItemIndex := cmbZoom.Items.Count - 1;
         rvzmCustom:
            cmbZoom.ItemIndex := cmbZoom.Items.IndexOf(
               IntToStr( Round( SRichViewEdit1.ViewProperty.ZoomPercent ) ) );
      end;
   finally
      UpdatingCombos := False;
   end;}//fercar
end;

// Applying zooming

procedure TfmSVSEditor.cmbZoomChange( Sender: TObject );
//var Percent : Single;
begin
   if UpdatingCombos then
      exit;
   {if cmbZoom.ItemIndex = cmbZoom.Items.Count - 1 then
      SRichViewEdit1.ViewProperty.ZoomMode := rvzmFullPage
   else if cmbZoom.ItemIndex = cmbZoom.Items.Count - 2 then
      SRichViewEdit1.ViewProperty.ZoomMode := rvzmPageWidth
   else if cmbZoom.ItemIndex >= 0 then begin
      SRichViewEdit1.ViewProperty.ZoomPercent := StrToIntDef( cmbZoom.Text, 0 );
      SRichViewEdit1.ViewProperty.ZoomMode := rvzmCustom;
   end;}//fercar
   {
   // This code will not work, because TsrvActionZoomFullPage and
   // TsrvActionZoomPageWidth are disabled in a web mode

   if cmbZoom.ItemIndex = cmbZoom.Items.Count-1 then
     srvActionsResource.srvActionZoomFullPage1.Execute
   else if cmbZoom.ItemIndex = cmbZoom.Items.Count-2 then
     srvActionsResource.srvActionZoomPageWidth1.Execute
   else if cmbZoom.ItemIndex>=0 then begin
     Percent := srvActionsResource.srvActionZoom1.ZoomPercent;
     srvActionsResource.srvActionZoom1.ZoomPercent := StrToIntDef(cmbZoom.Text, 0);
     srvActionsResource.srvActionZoom1.Execute;
     srvActionsResource.srvActionZoom1.ZoomPercent := Percent;
   end;
   }
end;
{----------------------------- Units combo box --------------------------------}
// Applying units

procedure TfmSVSEditor.cmbUnitsClick( Sender: TObject );
begin
   {SRichViewEdit1.UnitsProgram := TRVUnits( cmbUnits.ItemIndex );
   RVAControlPanel1.UnitsDisplay := TRVUnits( cmbUnits.ItemIndex );
   SclRVRuler1.UnitsDisplay := TRulerUnits( cmbUnits.ItemIndex );
   SclRVRuler2.UnitsDisplay := TRulerUnits( cmbUnits.ItemIndex );}
end;

{------- Synchronizing ScaleRichView after non-editing operations -------------}

procedure TfmSVSEditor.RVAControlPanel1MarginsChanged( Sender: TrvAction;
   Edit: TCustomRichViewEdit );
begin
   //cmbUnits.ItemIndex := ord( SRichViewEdit1.UnitsProgram ); fercar
   SclRVRuler1.UnitsDisplay := TRulerUnits( SRichViewEdit1.UnitsProgram );
   SclRVRuler2.UnitsDisplay := TRulerUnits( SRichViewEdit1.UnitsProgram );
end;

procedure TfmSVSEditor.RVAControlPanel1BackgroundChange( Sender: TrvAction;
   Edit: TCustomRichViewEdit );
begin
   SRichViewEdit1.Repaint;
end;

{---------------------------- Localization ------------------------------------}

procedure TfmSVSEditor.Button1Click( Sender: TObject );
begin
   if RVA_ChooseLanguage then
      Localize;
end;

procedure TfmSVSEditor.Localize;
var
   Index: Integer;
begin
   // Fonts
   Font.Charset := RVA_GetCharset;
   // Localizing all actions on srvActionsResource
   //RVA_LocalizeForm( srvActionsResource ); //fercar
   RVA_LocalizeForm( Self );
   // Localizing all actions on this form
   RVA_LocalizeForm( Self );
   // Localizing the rulers
   RVALocalizeRuler( SclRVRuler1 );
   RVALocalizeRuler( SclRVRuler2 );
   // Localizing the editor
   SRVA_LocalizeSRichViewEdit( SRichViewEdit1 );
   // Localizing the search tool window
   SRVA_LocalizeToolWindow( srvtwSearch );
   // Localizing menus and tool buttons
   {mitFile.Caption := RVA_GetS( rvam_menu_File );
   mitEdit.Caption := RVA_GetS( rvam_menu_Edit );
   mitFont.Caption := RVA_GetS( rvam_menu_Font );
   mitPara.Caption := RVA_GetS( rvam_menu_Para );
   mitFormat.Caption := RVA_GetS( rvam_menu_Format );
   mitInsert.Caption := RVA_GetS( rvam_menu_Insert );
   mitTable.Caption := RVA_GetS( rvam_menu_Table );
   mitExit.Caption := RVA_GetS( rvam_menu_Exit );

   mitFontSize.Caption := RVA_GetS( rvam_menu_FontSize );
   mitFontStyle.Caption := RVA_GetS( rvam_menu_FontStyle );
   mitTextFlow.Caption := RVA_GetS( rvam_menu_TextFlow );

   mitTableSelect.Caption := RVA_GetS( rvam_menu_TableSelect );
   mitTableCellBorders.Caption := RVA_GetS( rvam_menu_TableCellBorders );
   mitTableAlignCellContents.Caption := RVA_GetS( rvam_menu_TableCellAlign );
   mitTableCellRotation.Caption := RVA_GetS( rvam_menu_TableCellRotation );}//fercar

   {btnPageFormat.Caption := SRVA_GetS( srvam_menu_PageSize );
   btnPageFormat.Hint := RVADeleteAmp( btnPageFormat.Caption );}//fercar

   // In your application, you can use either TrvActionFonts or TrvActionFontEx
   rvActionFonts1.Caption := rvActionFonts1.Caption + ' (Estándar)';
   rvActionFontEx1.Caption := rvActionFontEx1.Caption + ' (Avanzado)';

   // Styles
   rvActionStyleInspector1.UpdateInfo;
   cmbFuenteEstilo.Font.Charset := RVA_GetCharset;
   cmbFuenteEstilo.Localize;

   // Localizing measuring units
   {Index := cmbUnits.ItemIndex;
   RVA_TranslateUnits( cmbUnits.Items );
   cmbUnits.ItemIndex := Index;
   cmbUnits.ItemIndex := ord( SRichViewEdit1.UnitsProgram );}//fercar

   // Localizing the zoom combo box

   {Index := cmbZoom.ItemIndex;
   cmbZoom.Items[ cmbZoom.Items.Count - 2 ] := RVA_GetS( rvam_pp_PageWidth );
   cmbZoom.Items[ cmbZoom.Items.Count - 1 ] := RVA_GetS( rvam_pp_FullPage );
   cmbZoom.ItemIndex := Index;}//fercar

   // Localizing toolbar in the horizontal scroll bar area
   TSRVToolButton( SRichViewEdit1.MenuHButtons.Items[ 0 ] ).Hint := RVADeleteAmp( SRVA_GetS( srvam_act_Draft ) );
   TSRVToolButton( SRichViewEdit1.MenuHButtons.Items[ 1 ] ).Hint := RVADeleteAmp( SRVA_GetS( srvam_act_WebLayout ) );
   TSRVToolButton( SRichViewEdit1.MenuHButtons.Items[ 2 ] ).Hint := RVADeleteAmp( SRVA_GetS( srvam_act_PrintLayout ) );

   // Localizing text on the status bar
   SRichViewEdit1CurrentPageChange( SRichViewEdit1 );
   SRichViewEdit1PageScrolled( SRichViewEdit1 );
   SRichViewEdit1CaretMove( SRichViewEdit1 );

   {
   // uncomment if you use Addict3. It's assumed that RVAddictSpell31
   // and RVThesaurus31 are on this form.
   RVAddictSpell31.UILanguage := GetAddictSpellLanguage(RVA_GetLanguageName);
   RVThesaurus31.UILanguage := GetAddictThesLanguage(RVA_GetLanguageName);
   }
end;

{------------------------------ Status bar ------------------------------------}
// Displaying the index of the edited page (OnCurrentPageChange & OnPageCountChanged)

procedure TfmSVSEditor.SRichViewEdit1CurrentPageChange( Sender: TObject );
begin
end;
// Displaying the index of the visible page

procedure TfmSVSEditor.SRichViewEdit1PageScrolled( Sender: TObject );
begin
end;
// Displaying the current line and column

procedure TfmSVSEditor.SRichViewEdit1CaretMove( Sender: TObject );
var
   Line, Column: Integer;
begin
   SRichViewEdit1.GetCurrentLineCol( Line, Column );
end;
// Displaying hints

procedure TfmSVSEditor.ApplicationHint( Sender: TObject );
var
   s: String;
begin
   s := GetLongHint( Application.Hint );
end;
{--------------------- Buttons on scroll-bars ---------------------------------}
// On horizontal scroll bar (view modes)

procedure TfmSVSEditor.SRichViewEdit1HMenuClickButton( Sender: TObject;
   ToolButton: TSRVToolButton );
begin
   if ToolButton = nil then
      Exit;
   SRichViewEdit1.CanUpdate := False;
   case ( ToolButton.Index ) of
      0: srvActionLayoutDraft1.Execute;
      1: srvActionLayoutWeb1.Execute;
      2: srvActionLayoutPrint1.Execute;
   end;
   SRichViewEdit1.CanUpdate := True;
end;
// On vertical scroll bar

procedure TfmSVSEditor.SRichViewEdit1VMenuClickButton( Sender: TObject;
   ToolButton: TSRVToolButton );
var
   sbX, sbY: Integer;
   p: TPoint;
begin
   if ToolButton = nil then
      Exit;
   case ToolButton.Index of
      0: {// "Up arrows" button, performs search to the top} begin
            case VToolButtonIndex of
               SRV_TOOLWIN_PAGE, -1: SRichViewEdit1.PriorCurPage;
               SRV_TOOLWIN_TABLE: SRichViewEdit1.PriorCurItem( [ rvsTable ] );
               SRV_TOOLWIN_PICTURE: SRichViewEdit1.PriorCurItem( [ rvsPicture, rvsHotspot, rvsHotPicture ] );
               SRV_TOOLWIN_HEADLINE: SRichViewEdit1.PriorCurHeading;
               SRV_TOOLWIN_HYPERLINK: SRichViewEdit1.PriorCurHyperlink;
               SRV_TOOLWIN_TEXT: begin
                     fd.Options := fd.Options - [ frDown ];
                     fdFind( nil );
                  end;
               SRV_TOOLWIN_FOOTNOTE: SRichViewEdit1.PriorCurItem( [ rvsFootnote ] );
               SRV_TOOLWIN_ENDNOTE: SRichViewEdit1.PriorCurItem( [ rvsEndnote ] );
            end;
         end;
      1: {// "Circle" button, shows tool window} begin
            sbX := SRichViewEdit1.MenuVertical.SRVToolBar.Width;
            sbY := SRichViewEdit1.MenuVertical.SRVToolBar.Height div 3;

            p := SRichViewEdit1.MenuVertical.SRVToolBar.ClientToScreen( Point( 0, 0 ) );
            p.Y := p.Y + sbY;

            srvtwSearch.Execute( Bounds( p.x, p.y, sbX, sbY ) );
         end;
      2: {// "Down arrows" button, performs search to the bottom} begin
            case VToolButtonIndex of
               SRV_TOOLWIN_PAGE, -1: SRichViewEdit1.NextCurPage;
               SRV_TOOLWIN_TABLE: SRichViewEdit1.NextCurItem( [ rvsTable ] );
               SRV_TOOLWIN_PICTURE: SRichViewEdit1.NextCurItem( [ rvsPicture, rvsHotspot, rvsHotPicture ] );
               SRV_TOOLWIN_HEADLINE: SRichViewEdit1.NextCurHeading;
               SRV_TOOLWIN_HYPERLINK: SRichViewEdit1.NextCurHyperlink;
               SRV_TOOLWIN_TEXT: begin
                     fd.Options := fd.Options + [ frDown ];
                     fdFind( nil );
                  end;
               SRV_TOOLWIN_FOOTNOTE: SRichViewEdit1.NextCurItem( [ rvsFootnote ] );
               SRV_TOOLWIN_ENDNOTE: SRichViewEdit1.NextCurItem( [ rvsEndnote ] );
            end;
         end;
   end;
end;
// Button on the tool window is clicked

procedure TfmSVSEditor.srvtwSearchClickButton( Sender: TObject;
   ToolButton: TSRVToolButton );
var
   s: String;
   posit: Integer;
begin
   if ToolButton = nil then begin
      VToolButtonIndex := -1;
      Exit;
   end
   else
      VToolButtonIndex := ToolButton.Index;
   if ToolButton.Index = SRV_TOOLWIN_TEXT then {// starting text search} begin
      SRichViewEdit1.SetFocus;
      fd.CloseDialog;
      if SRichViewEdit1.RichViewEdit.SelectionExists then begin
         s := SRichViewEdit1.RichViewEdit.GetSelText;
         posit := Pos( #13, s );
         if posit <> 0 then
            s := Copy( s, 1, posit - 1 );
         fd.FindText := s;
      end;
      fd.Execute;
   end
   else // starting search
      SRichViewEdit1VMenuClickButton( Sender,
         TSRVToolButton( SRichViewEdit1.MenuVButtons.Items[ 2 ] ) );
end;
// text search

procedure TfmSVSEditor.fdFind( Sender: TObject );
begin
   if not SRichViewEdit1.RichViewEdit.SearchText( fd.FindText, GetRVESearchOptions( fd.Options ) ) then
      ShowInfo( Format( RVA_GetS( rvam_src_NotFound ), [ fd.FindText ] ), RVA_GetS( rvam_src_Complete ) );
   SRichViewEdit1.Repaint;
end;

{-------------------- Progress messages ---------------------------------------}
// On dowloading image

procedure TfmSVSEditor.RVAControlPanel1Download( Sender: TrvAction;
   const Source: String );
begin
   if Source = '' then
      Application.Hint := ''
   else
      Application.Hint := RVAFormat( RVA_GetS( rvam_msg_Downloading ), [ Source ] );
end;
// Reading/writing

procedure TfmSVSEditor.SRichViewEdit1Progress( Sender: TCustomRichView;
   Operation: TRVLongOperation; Stage: TRVProgressStage; PercentDone: Byte );
begin
   case Stage of
      rvpstgStarting: begin
         end;
      rvpstgRunning: begin
         end;
      rvpstgEnding: begin
         end;
   end;
end;
// Printing

procedure TfmSVSEditor.SRichViewEdit1Printing( Sender: TSRichViewEdit;
   PageCompleted: Integer; Step: TRVPrintingStep );
begin
   Application.Hint := RVA_GetPrintingMessage( PageCompleted, Step );
end;
{-------------------------------- Misc. ---------------------------------------}
// On clicking a table icon

procedure TfmSVSEditor.SRichViewEdit1TableIconClick( Sender: TSRichViewEdit;
   Button: TMouseButton; Shift: TShiftState; X, Y, PageNo: Integer );
begin
   SRichViewEdit1.GetTableIconItem.SelectRows( 0, SRichViewEdit1.GetTableIconItem.RowCount );
   SRichViewEdit1.Repaint;
end;
//  Double clicking on the rulers' margins shows the page setup dialog

procedure TfmSVSEditor.SclRVRuler1MarginDblClick( Sender: TObject;
   Margin: TMarginType );
begin
   srvActionPageSetup1.ExecuteTarget( SRichViewEdit1 );
end;
// After TsrvActionThumbnails is executed

procedure TfmSVSEditor.srvActionThumbnails1Executed( Sender: TObject );
begin
   cxSplitter1.Visible := TsrvActionThumbnails( Sender ).Checked;
   SRVPageScroll1.Visible := TsrvActionThumbnails( Sender ).Checked;
end;

procedure TfmSVSEditor.SRichViewEdit1Change( Sender: TObject );
begin
   bModificado := True;
end;

procedure TfmSVSEditor.FormClose( Sender: TObject;
   var Action: TCloseAction );
begin
   if FormStyle = fsMDIChild then
      Action := caFree;
end;

procedure TfmSVSEditor.mnuSalirYGuardarClick( Sender: TObject );
begin
   bSalirSinGuardar := False;
   Close;
end;

procedure TfmSVSEditor.mnuSalirSinGuardarClick( Sender: TObject );
begin
   bSalirSinGuardar := True;
   Close;
end;

procedure TfmSVSEditor.FormDestroy( Sender: TObject );
begin
   dm.PubEliminarVentanaActiva( Caption );

   if gral.iPubVentanasActivas in [ 0, 1 ] then
      gral.PubExpandeMenuVentanas( False );
end;

end.

