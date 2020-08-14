unit Unit4;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  dxSkinsCore, dxSkinsDefaultPainters, cxTrackBar, cxLabel, registry;

type
  TForm4 = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    tbMaxPercent: TcxTrackBar;
    lblMaxPercent: TcxLabel;
    tbAdjPercent: TcxTrackBar;
    lblAdjPercent: TcxLabel;
    Button1: TButton;
    procedure tbAdjPercentPropertiesChange(Sender: TObject);
    procedure tbMaxPercentPropertiesChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}



procedure TForm4.Button1Click(Sender: TObject);
begin
  write_maxvolume(inttostr(tbMaxPercent.Position * 10));
  write_adjustvolume(inttostr(tbAdjPercent.Position * 10));
  form4.Close;
end;

procedure TForm4.tbAdjPercentPropertiesChange(Sender: TObject);
begin
lblAdjPercent.Caption:= inttostr(tbAdjPercent.Position * 10) + ' %';
end;

procedure TForm4.tbMaxPercentPropertiesChange(Sender: TObject);
begin
lblMaxPercent.Caption:= inttostr(tbMaxPercent.Position * 10) + ' %';
end;

end.
