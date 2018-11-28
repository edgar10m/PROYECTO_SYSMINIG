unit PRIMER_MODULO;

interface

uses
  SysUtils, Classes, ActnList;

type
  TDataModule1 = class(TDataModule)
    ActionList1: TActionList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{$R *.dfm}

end.
