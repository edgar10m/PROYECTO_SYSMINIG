unit ptsarranca;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DB, ADODB, Grids, DBGrids;

type
  Tftsarranca = class(TForm)
    Panel1: TPanel;
    ComboBox1: TComboBox;
    Label1: TLabel;
    ComboBox2: TComboBox;
    Label2: TLabel;
    ComboBox3: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    ComboBox4: TComboBox;
    Label5: TLabel;
    ComboBox5: TComboBox;
    Label6: TLabel;
    Label7: TLabel;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    DataSource3: TDataSource;
    ADOQuery1: TADOQuery;
    ADOQuery2: TADOQuery;
    ADOQuery3: TADOQuery;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    bejecuta: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ftsarranca: Tftsarranca;

implementation

{$R *.dfm}

end.
