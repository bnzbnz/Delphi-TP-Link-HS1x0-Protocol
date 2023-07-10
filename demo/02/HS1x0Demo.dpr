program HS1x0Demo;

///
///  Author:  Laurent Meyer
///  Contact: HS1x0@ea4d.com
///
///  https://github.com/bnzbnz/HS1x0 :
///
///  License: MPL 1.1 / GPL 2.1
///

uses
  Vcl.Forms,
  uHS1x0Demo in 'uHS1x0Demo.pas',
  uNetUtils in '..\..\source\uNetUtils.pas',
  uJsonX in '..\..\source\uJsonX.pas',
  uJsonX.Types in '..\..\source\uJsonX.Types.pas',
  uJsonX.RTTI in '..\..\source\uJsonX.RTTI.pas',
  JsonDataObjects in '..\..\source\JsonDataObjects.pas',
  uJsonX.Utils in '..\..\source\uJsonX.Utils.pas',
  uHS1x0 in '..\..\source\uHS1x0.pas',
  uHS110DemoExt in '..\common\uHS110DemoExt.pas',
  uHS1x0Hlp in '..\..\source\uHS1x0Hlp.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(THSForm, HSForm);
  Application.Run;
end.
