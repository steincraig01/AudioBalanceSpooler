program SoundDriver;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  MMDevAPI in 'MMDevAPI.pas',
  Grijjy.TextToSpeech.Base in 'Grijjy.TextToSpeech.Base.pas',
  Grijjy.TextToSpeech in 'Grijjy.TextToSpeech.pas',
  Grijjy.TextToSpeech.Windows in 'Grijjy.TextToSpeech.Windows.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
