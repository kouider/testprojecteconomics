program SystemInformation;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {SystemInfoForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TSystemInfoForm, SystemInfoForm);
  Application.Run;
end.
