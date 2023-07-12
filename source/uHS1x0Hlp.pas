unit uHS1x0Hlp;

///
///  Author:  Laurent Meyer
///  Contact: HS1x0@ea4d.com
///
///  https://github.com/bnzbnz/Delphi-TP-Link-HS1x0-Protocol
///
///  License: MPL 1.1 / GPL 2.1
///

interface
  uses uHS1x0;

type

  THS1x0Hlp = class Helper  for THS1x0

    // Badly missing functioons
    function Schedule_GetRule(Id: string): THS1x0_Schedule;
    function Countdown_GetRule(Id: string): THS1x0_Countdown;
    function AntiTheft_GetRule(Id: string): THS1x0_AntiTheft;

  end;

implementation

function THS1x0Hlp.Schedule_GetRule(Id: string): THS1x0_Schedule;
begin
  Result := Nil;
  var Rules := Self.Schedule_GetRulesList;
  if Rules = nil then Exit;
  try
    for var uRule in Rules.Fschedule.Fget_5Frules.Frule_5Flist do
    begin
      var Rule := THS1x0_Schedule(uRule);
      if Rule.Fid = Id then
      begin
        Result := THS1x0_Schedule(Rule.Clone);
        Exit;
      end;
    end;
  finally
    Rules.Free;
  end;
end;

function THS1x0Hlp.Countdown_GetRule(Id: string): THS1x0_Countdown;
begin
  Result := Nil;
  var Rules := Self.Countdown_GetRulesList;
  if Rules = nil then Exit;
  try
    for var uRule in Rules.Fcount_5Fdown.Fget_5Frules.Frule_5Flist do
    begin
      var Rule := THS1x0_Countdown(uRule);
      if Rule.Fid = Id then
      begin
        Result := THS1x0_Countdown(Rule.Clone);
        Exit;
      end;
    end;
  finally
    Rules.Free;
  end;
end;

function THS1x0Hlp.AntiTheft_GetRule(Id: string): THS1x0_AntiTheft;
begin
  Result := Nil;
  var Rules := Self.AntiTheft_GetRulesList;
  if Rules = nil then Exit;
  try
    for var uRule in Rules.Fanti_5Ftheft.Fget_5Frules.Frule_5Flist do
    begin
      var Rule := THS1x0_AntiTheft(uRule);
      if Rule.Fid = Id then
      begin
        Result := THS1x0_AntiTheft(Rule.Clone);
        Exit;
      end;
    end;
  finally
    Rules.Free;
  end;
end;

end.
