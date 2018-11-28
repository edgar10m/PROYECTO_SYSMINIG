unit ptspdf;

interface
uses sysutils,graphics,SynPdf;
const
  PDFFactor: Single = 72.0 / 2.54;
var
   lPdf   : TPdfDocumentGDI;
   lPage  : TPdfPage;
procedure PDF_Crea;
procedure PDF_Free;

implementation

procedure PDF_Crea;
begin
   lPdf := TPdfDocumentGDI.Create;
   lPdf.ScreenLogPixels:=150;
   lPage := lPDF.AddPage;
   lPdf.VCLCanvas.Brush.Style:=bsSolid;
   lpdf.VCLCanvas.Pen.Width:=1;
   lpdf.VCLCanvas.Pen.Color:=clblack;
end;
procedure PDF_Free;
begin
   lPDF.Free;
end;
end.
