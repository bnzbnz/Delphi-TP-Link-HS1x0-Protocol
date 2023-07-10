unit uHS1x0Hlp;

interface
  uses uHS1x0;

type

  THS1x0Hlp = class Helper  for THS1x0

    function Schedule_GetRule(Id: string): THS1x0_Schedule;
    function Countdown_GetRule(Id: string): THS1x0_Countdown;

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
      var Rule := THS1x0_Countdown(uRule);
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

end.
