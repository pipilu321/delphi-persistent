program DelphiPersistent;

uses
  Vcl.Forms,
  UMainForm in 'Forms\MainForm\UMainForm.pas' {MainForm},
  UQyPersistent in '..\Sources\UQyPersistent.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
