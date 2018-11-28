unit SEGUNDO_MODULO;

interface

uses
  SysUtils, Classes, ActnList;

type
  TDataModule2 = class(TDataModule)
    ActionList1: TActionList;
    ActionList2: TActionList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule2: TDataModule2;

implementation

{$R *.dfm}

end.
