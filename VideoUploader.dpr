program VideoUploader;

{$R *.dres}

uses
  Vcl.Forms,
  main in 'main.pas' {FormMain},
  filethread in 'filethread.pas',
  uFileInfo in 'uFileInfo.pas' {frFileInfo},
  resourcethread in 'resourcethread.pas',
  RVMUtils in 'RVMUtils.pas',
  RVMConsts in 'RVMConsts.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
