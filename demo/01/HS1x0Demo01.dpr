program HS1x0Demo01;

uses
  Vcl.Forms,
  uHSScan in 'uHSScan.pas' {HSScanFrm},
  uHS110DemoExt in '..\common\uHS110DemoExt.pas',
  uHS1x0 in '..\..\source\uHS1x0.pas',
  uJsonX in '..\..\source\uJsonX.pas',
  uJsonX.RTTI in '..\..\source\uJsonX.RTTI.pas',
  uJsonX.Types in '..\..\source\uJsonX.Types.pas',
  uJsonX.Utils in '..\..\source\uJsonX.Utils.pas',
  uNetUtils in '..\..\source\uNetUtils.pas',
  uHS1x0Hlp in '..\..\source\uHS1x0Hlp.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(THSScanFrm, HSScanFrm);
  Application.Run;
end.
