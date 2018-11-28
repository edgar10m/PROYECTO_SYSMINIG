unit alkAnCom;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ptsdm,uConstantes;

type
  TalkAnCompl = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    rgSist: TRadioGroup;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure rgSistClick(Sender: TObject);
  private
    { Private declarations }
    sel : String;
  public
    { Public declarations }
    procedure llena_sistemas();
  end;

var
  alkAnCompl: TalkAnCompl;

implementation

{$R *.dfm}

procedure TalkAnCompl.Button1Click(Sender: TObject);
begin
   alkSistema:=sel;
   Self.Close ;
end;

procedure TalkAnCompl.llena_sistemas();
var
   cons:String;
   cont: integer;
begin
   cont:=0;

   cons:='select distinct sistema from tsprog ' +
         ' where cclase='+ g_q + 'CBL' + g_q+
         ' or cclase='+ g_q + 'CMA' + g_q;
   if dm.sqlselect(dm.q1, cons) then begin
      while not dm.q1.Eof do begin
         cont:=cont+1;
         rgSist.items.Add(dm.q1.FieldByName( 'sistema' ).AsString);
         alkSistema:=dm.q1.FieldByName( 'sistema' ).AsString;
         dm.q1.Next;
      end;

      if cont = 1 then begin                    //si solo tiene una opcion tomarla y salir
         Self.Close;
         exit;
      end
      else
         alkSistema:='';
   end
   else begin
      ShowMessage('No existe un sistema con Cobol');
      alkSistema:='-';
      Self.Close;
      exit;
   end;
end;

procedure TalkAnCompl.rgSistClick(Sender: TObject);
begin
   sel:=rgSist.Items.Strings[rgSist.ItemIndex];
   if sel <> '' then
      Button1.Enabled:=true;
end;

end.
