unit uHS1x0Demo;

///
///  Author:  Laurent Meyer
///  Contact: HS1x0@ea4d.com
///
///  https://github.com/bnzbnz/Delphi-TP-Link-HS1x0-Protocol
///
///  License: MPL 1.1 / GPL 2.1
///

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, uHS1x0Discovery,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids, System.Generics.Collections,
  uHS1x0, Vcl.Menus, uEditCntDwnFrm, uEditScheduleFrm;

type

  THSRealTime = class(Tthread)
    Index: Integer;
    IP: string;
    procedure Execute; override;
  end;

  THSForm = class(TForm)
    Panel1: TPanel;
    PBar: TProgressBar;
    Button1: TButton;
    Popup: TPopupMenu;
    PowerON1: TMenuItem;
    PowerOFF1: TMenuItem;
    N1: TMenuItem;
    LedON1: TMenuItem;
    LedOFF1: TMenuItem;
    N2: TMenuItem;
    Reboot1: TMenuItem;
    Reset1: TMenuItem;
    StatsReset1: TMenuItem;
    Panel2: TPanel;
    N3: TMenuItem;
    Rename1: TMenuItem;
    Panel3: TPanel;
    PopupScheds: TPopupMenu;
    Enable1: TMenuItem;
    Grid: TStringGrid;
    GridD: TStringGrid;
    GridS: TStringGrid;
    GRidC: TStringGrid;
    PopupCntDwn: TPopupMenu;
    Edit1: TMenuItem;
    N4: TMenuItem;
    Edit2: TMenuItem;
    N5: TMenuItem;
    Add1: TMenuItem;
    Edit3: TMenuItem;
    Delete1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure GridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure PowerON1Click(Sender: TObject);
    procedure PowerOFF1Click(Sender: TObject);
    procedure LedON1Click(Sender: TObject);
    procedure LedOFF1Click(Sender: TObject);
    procedure Reboot1Click(Sender: TObject);
    procedure StatsReset1Click(Sender: TObject);
    procedure Reset1Click(Sender: TObject);
    procedure Rename1Click(Sender: TObject);
    procedure Enable1Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure Edit2Click(Sender: TObject);
    procedure GRidCDblClick(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Add1Click(Sender: TObject);
    procedure Edit3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    RowThreadCnt: Integer;
    Scanner : THS1x0Discovery;
    HSTrealTimeList : TObjectList<THSRealTime>;
    procedure InitRow(nIP: Cardinal);
    procedure Stop;
    procedure SyncGrid(
                Thread: THSRealTime;
                Index: Integer;
                HS1x0: THS1x0;
                Info: THS1x0_SystemInfoResponse;
                RealTime: THS1x0_GetRealtimeCVResponse;
                MonthStats, PrevMonthStats: THS1x0_GetDayStatResponse;
                Scheds: THS1x0_GetRulesListResponse;
                CntDwn: THS1x0_CountdownGetRulesResponse
              );
  end;

var
  HSForm : THSForm;

implementation
uses uNetUtils, DateUtils, uHS1x0Hlp;

{$R *.dfm}

const
  BInt: array[boolean] of integer = (0, 1);
  BEnable: array[boolean] of string = ('Disable', 'Enable');
  BOnOff: array[boolean] of string = ('OFF', 'ON');

function IIF(C: Boolean; A, B: variant): variant;
begin
  if C then Result := A else Result := B;
end;

procedure OnScanned;
begin
  HSForm.PBar.Position := HSForm.PBar.Position + 1;
end;

procedure OnFound(nIP: Cardinal);
begin
  HSForm.InitRow(nIP);
end;

procedure THSForm.InitRow(nIP: Cardinal);
begin
  var TH := THSRealTime.Create(True);
  TH.Index := Grid.RowCount;
  TH.IP := IpAddrToStr(nIP);
  Grid.Cells[0, Grid.RowCount] := TH.IP;
  HSTrealTimeList.Add(TH);
  TH.Priority := tpIdle;
  Grid.RowCount := Grid.RowCount + 1;
  TH.Start;
  Grid.Refresh;
end;

procedure THSForm.LedOFF1Click(Sender: TObject);
begin
  var IP := Grid.Cells[0, Grid.Row ];
  var HS1x0 := THS1x0.Create(IP);
  HS1x0.System_LedOff;
  HS1x0.Free
end;

procedure THSForm.LedON1Click(Sender: TObject);
begin
  var IP := Grid.Cells[0, Grid.Row ];
  var HS1x0 := THS1x0.Create(IP);
  HS1x0.System_LedOn;
  HS1x0.Free
end;

procedure THSForm.Delete1Click(Sender: TObject);
begin
  var HS: THS1x0 := Nil;
  var Res: THS1x0_DeleteRuleResponse := Nil;
  var IP := Grid.Cells[0, Grid.Row ];
  var ID := GridS.Cells[0, Grids.Row ];
  try
    HS := THS1x0.Create(IP);
    if HS = nil then Exit;
    Res := HS.Schedule_DeleteRule(ID);
    if Res = nil then Exit;
  finally
    Res.Free;
    HS.Free;
  end;
end;

procedure THSForm.Edit1Click(Sender: TObject);
begin
  var HS: THS1x0 := Nil;
  var Rule: THS1x0_CountDown := Nil;
  var Req: THS1x0_CountdownEditRuleRequest := Nil;
  var IP := Grid.Cells[0, Grid.Row ];
  var ID := GridC.Cells[0, Grids.Row ];
  try
    HS := THS1x0.Create(IP);
    if HS = nil then Exit;
    Rule := HS.Countdown_GetRule(ID);
    if Rule = nil then Exit;
    Rule.Fenable := IIF(Rule.Fenable = 0, 1 ,0);
    Req := THS1x0_CountdownEditRuleRequest.Create(Rule);
    HS.CountDown_EditRule(Req).Free;
  finally
    Req.Free;
    Rule.Free;
    HS.Free;
  end;
end;

procedure THSForm.Edit2Click(Sender: TObject);
begin
  var HS: THS1x0 := Nil;
  var Rule: THS1x0_CountDown := Nil;
  var Req: THS1x0_CountdownEditRuleRequest := Nil;
  var IP := Grid.Cells[0, Grid.Row ];
  var ID := GridC.Cells[0, Grids.Row ];
  try
    HS := THS1x0.Create(IP);
    if HS = nil then Exit;
    Rule := HS.Countdown_GetRule(ID);
    if Rule = nil then Exit;
    EditCntDwnFrm.ShowAsModal(Rule);

    Req := THS1x0_CountdownEditRuleRequest.Create(Rule);
    HS.CountDown_EditRule(Req).Free;
  finally
    Req.Free;
    Rule.Free;
    HS.Free;
  end;
end;

procedure THSForm.Edit3Click(Sender: TObject);
begin
  var HS: THS1x0 := Nil;
  var Rule: THS1x0_Schedule := Nil;
  var Req: THS1x0_EditRuleRequest;
  var IP := Grid.Cells[0, Grid.Row ];
  var ID := GridS.Cells[0, Grids.Row ];
  try
    HS := THS1x0.Create(IP);
    if HS = nil then EXit;
    Rule :=  HS.Schedule_GetRule(ID);
    if Rule = nil then EXit;
    if EditScheduleFrm.ShowAsModal(Rule) then
    begin
      Req := THS1x0_EditRuleRequest.Create(Rule);
      HS.Schedule_EditRule(Req).Free;
    end;
  finally
    Req.Free;
    Rule.Free;
    HS.Free;
  end;
end;

procedure THSForm.Enable1Click(Sender: TObject);
begin
  var HS: THS1x0 := Nil;
  var Rule: THS1x0_Schedule := Nil;
  var Req: THS1x0_EditRuleRequest := Nil;
  var IP := Grid.Cells[0, Grid.Row ];
  var ID := GridS.Cells[0, Grids.Row ];
  try
    HS := THS1x0.Create(IP);
    if HS = nil then Exit;
    Rule := HS.Schedule_GetRule(ID);
    if Rule = nil then Exit;
    Rule.Fenable := IIF(Rule.Fenable = 0, 1 ,0);
    Req := THS1x0_EditRuleRequest.Create(Rule);
    HS.Schedule_EditRule(Req).Free;
  finally
    Req.Free;
    Rule.Free;
    HS.Free;
  end;
end;

procedure THSForm.PowerOFF1Click(Sender: TObject);
begin
  var IP := Grid.Cells[0, Grid.Row ];
  var HS1x0 := THS1x0.Create(IP);
  HS1x0.System_PowerOff;
  HS1x0.Free;
end;

procedure THSForm.PowerON1Click(Sender: TObject);
begin
  var IP := Grid.Cells[0, Grid.Row ];
  var HS1x0 := THS1x0.Create(IP);
  HS1x0.System_PowerOn;
  HS1x0.Free;
end;

procedure THSForm.Reboot1Click(Sender: TObject);
begin
  var IP := Grid.Cells[0, Grid.Row ];
  var HS1x0 := THS1x0.Create(IP);
  HS1x0.System_Reboot;
  HS1x0.Free;
end;


procedure THSForm.Rename1Click(Sender: TObject);
begin
  var IP := Grid.Cells[0,  Grid.Row];
  var HS1x0 := THS1x0.Create(IP);
  var HS1x0Res := HS1x0.System_GetSysinfo;
  if HS1x0Res <> Nil then
  begin
    HS1x0.System_SetDeviceAlias(
      InputBox('Rename', 'New Name', HS1x0Res.Fsystem.Fget_5Fsysinfo.Falias )
    );
  end;
  HS1x0Res.Free;
  HS1x0.Free;
end;

procedure THSForm.Reset1Click(Sender: TObject);
begin
  var IP := Grid.Cells[0, Grid.Row ];
  var HS1x0 := THS1x0.Create(IP);
  HS1x0.System_Reset(1);
  HS1x0.Free;
end;

procedure THSForm.StatsReset1Click(Sender: TObject);
begin
begin
  var IP := Grid.Cells[0, Grid.Row ];
  var HS1x0 := THS1x0.Create(IP);
  HS1x0.Emeter_Reset;
  HS1x0.Free;
end;

end;

procedure THSForm.Stop;
begin
   for var Th in HSTrealTimeList do
    Th.Terminate;

  Scanner.Stop;

  PBar.Position := 0;
  Grid.RowCount := 1;
  RowThreadCnt  := 0;

  for var Th in HSTrealTimeList do
  begin
    Th.WaitFor;
    Th.Free;
  end;
  HSTrealTimeList.Clear;
end;

procedure THSForm.Add1Click(Sender: TObject);
begin
  var HS: THS1x0 := Nil;
  var Rule: THS1x0_AddRuleRequest := Nil;
  var IP := Grid.Cells[0, Grid.Row ];
  try
    Rule := THS1x0_AddRuleRequest.Create;

    Rule.Fschedule.Fadd_5Frule.Fid := '';
    Rule.Fschedule.Fadd_5Frule.Fstime_opt := 0;
    Rule.Fschedule.Fadd_5Frule.Fwday.Add(1);
    Rule.Fschedule.Fadd_5Frule.Fwday.Add(1);
    Rule.Fschedule.Fadd_5Frule.Fwday.Add(1);
    Rule.Fschedule.Fadd_5Frule.Fwday.Add(1);
    Rule.Fschedule.Fadd_5Frule.Fwday.Add(1);
    Rule.Fschedule.Fadd_5Frule.Fwday.Add(1);
    Rule.Fschedule.Fadd_5Frule.Fwday.Add(1);
    Rule.Fschedule.Fadd_5Frule.Fsmin := 1104;
    Rule.Fschedule.Fadd_5Frule.Fenable := 0;
    Rule.Fschedule.Fadd_5Frule.Frepeat := 1;
    Rule.Fschedule.Fadd_5Frule.Fetime_opt := -1;
    Rule.Fschedule.Fadd_5Frule.Fname := 'New Schedule';
    Rule.Fschedule.Fadd_5Frule.Feact := -1;
    Rule.Fschedule.Fadd_5Frule.Fmonth := 0;
    Rule.Fschedule.Fadd_5Frule.Fsact := 0;
    Rule.Fschedule.Fadd_5Frule.Fyear := 0;
    //Rule.Fschedule.Fadd_5Frule.Flongitude := 0;
    //Rule.Fschedule.Fadd_5Frule.Flatitude := 0;
    Rule.Fschedule.Fadd_5Frule.Fday := 0;
    //Rule.Fschedule.Fadd_5Frule.Fforce := 0;
    Rule.Fschedule.Fadd_5Frule.Femin := 0;

    if EditScheduleFrm.ShowAsModal(Rule.Fschedule.Fadd_5Frule) then
    begin
      HS := THS1x0.Create(IP);
      HS.Schedule_AddRule(Rule).Free;
    end;

  finally
    Rule.Free;
    HS.Free;
  end;
end;

procedure THSForm.Button1Click(Sender: TObject);
begin
  Stop;
  Scanner.Start;
end;

procedure THSForm.FormCreate(Sender: TObject);
begin

  if debugHook <> 0 then
    ShowMessage('You are running in the IDE : Due to a Debugger Bug while multi-threading, the port scanning feature is going to be slow...');

  PBar.Position := 0;
  Grid.RowCount := 1;
  RowThreadCnt  := 0;

  HSTrealTimeList := TObjectList<THSRealTime>.Create(False);

  Scanner := THS1x0Discovery.Create;
  Scanner.OnScanned := OnScanned;
  Scanner.OnFound := OnFound;
  // Scanner.Start(12, 20); // Dev Only;
  Scanner.Start;

  Grid.Cells[0,0] := 'IP'; Grid.ColWidths[0] := 80;
  Grid.Cells[1,0] := 'Alias'; Grid.ColWidths[1] := 128;
  Grid.Cells[2, 0] := 'Power'; Grid.ColWidths[2] := 44;
  Grid.Cells[3, 0] := '  LED'; Grid.ColWidths[3] := 44;
  Grid.Cells[4, 0] := 'Watts';
  Grid.Cells[5, 0] := 'KWh (Instant)' ;
  Grid.Cells[6, 0] := 'Day KW';
  Grid.Cells[7, 0] := 'Day KWh (Estimated)';
  Grid.Cells[8, 0] := 'Day -1 KWh';
  Grid.Cells[9, 0] := 'ON Since';

end;

procedure THSForm.FormDestroy(Sender: TObject);
begin
  Stop;
  Scanner.Free;
  HSTrealTimeList.Free;
end;

procedure THSForm.GRidCDblClick(Sender: TObject);
begin
  Edit2Click(Self);
end;

procedure THSForm.GridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  if (ACol = 0) and (ARow = 0)  then
    Exit;
  for var i := 0  to GridD.ColCount do
    for var J := 0  to GridD.RowCount do
      GridD.Cells[i, j] := '';

  GridD.ColWidths[0] := 80;
  GridD.ColWidths[1] := 240;

  var IP := Grid.Cells[0, ARow];
  var HS1x0 := THS1x0.Create(IP);
  var Info := HS1x0.System_GetSysinfo;
  if Info <> Nil then
  begin
    GridD.Cells[0, 0] := 'Device :';
    GridD.Cells[1, 0] := Info.Fsystem.Fget_5Fsysinfo.Fdev_5Fname;
    GridD.Cells[0, 1] := 'Model :';
    GridD.Cells[1, 1] := Info.Fsystem.Fget_5Fsysinfo.Fmodel;
    GridD.Cells[0, 2] := 'Hardware :';
    GridD.Cells[1, 2] := 'v' + Info.Fsystem.Fget_5Fsysinfo.Fhw_5Fver;
    GridD.Cells[0, 3] := 'Software :';
    GridD.Cells[1, 3] := 'v' + Info.Fsystem.Fget_5Fsysinfo.Fsw_5Fver;
    GridD.Cells[0, 4] := 'MAC :';
    GridD.Cells[1, 4] := Info.Fsystem.Fget_5Fsysinfo.Fmac;
    Info.Free;
  end;

  HS1x0.Free;
end;

function secToDHMS(sec: Integer; IncludeDays: Boolean = True): string;
var
  D, H, M, S: Integer;
begin
  D:= sec div 86400;
  H:= (sec - D * 86400) div 60 div 60;
  M:= (sec - D * 86400 -  H * 3600) div 60;
  S:= sec - D * 86400 - H * 3600 - M * 60;

  Result := VarToStr(IIF(IncludeDays
      , Format('%dd %.*d:%.*d:%.*d ', [D, 2, H, 2, M, 2, S])
      , Format('%.*d:%.*d:%.*d ', [2, H, 2, M, 2, S])
  ));
end;

procedure THSForm.SyncGrid(
                    Thread: THSRealTime;
                    Index: Integer; HS1x0:
                    THS1x0; Info: THS1x0_SystemInfoResponse;
                    RealTime: THS1x0_GetRealtimeCVResponse;
                    MonthStats, PrevMonthStats: THS1x0_GetDayStatResponse;
                    Scheds: THS1x0_GetRulesListResponse;
                    CntDwn: THS1x0_CountdownGetRulesResponse
                  );
var
  H, M, S, Ms:  Word;
begin
  GridS.BeginUpdate;
  Grid.BeginUpdate;

  Grid.Cells[1, Index] := Info.Fsystem.Fget_5Fsysinfo.Falias;

  if (Info <> nil) then
  begin
     if Info.Fsystem.Fget_5Fsysinfo.Frelay_state = 1 then
      Grid.Cells[2, Index] := '   🗲'
     else
      Grid.Cells[2, Index] := '' ;

     if Info.Fsystem.Fget_5Fsysinfo.Fled_5Foff = 0 then
      Grid.Cells[3, Index] := '   💡'
     else
      Grid.Cells[3, Index] := '' ;

      Grid.Cells[9, Index] := secToDHMS( Info.Fsystem.Fget_5Fsysinfo.Fon_5Ftime );
  end;

  if RealTime <> nil then
  begin
    Grid.Cells[4, Index] := VarToStr(Round(RealTime.Femeter.Fget_5Frealtime.Fpower));
    Grid.Cells[5, Index] := FormatFloat('0.000', RealTime.Femeter.Fget_5Frealtime.Fpower * 24 / 1000);
  end;

  if MonthStats <> nil then
  begin
    DecodeTime(Now, H, M, S, MS);
    var Cnt := MonthStats.Femeter.Fget_5Fdaystat.Fday_5Flist.Count;
    var X := THS1x0_DayStat(MonthStats.Femeter.Fget_5Fdaystat.Fday_5Flist.Items[Cnt - 1]).Fenergy;
    Grid.Cells[6, Index] := VarToStr(X);
    var v := 0.0;
    try v := X / (H + (M / 60)) * 24  except v := 0 end;
    Grid.Cells[7, Index] := FormatFloat('0.000', v);
    if Cnt >=2  then
    begin
      X := THS1x0_DayStat(MonthStats.Femeter.Fget_5Fdaystat.Fday_5Flist.Items[Cnt - 2]).Fenergy;
      Grid.Cells[8, Index] := VarToStr(X);
    end else  begin
      if (PrevMonthStats <> nil)  then
      begin
       Cnt := PrevMonthStats.Femeter.Fget_5Fdaystat.Fday_5Flist.Count;
       if Cnt > 0  then
          Grid.Cells[8, Index] := THS1x0_DayStat(PrevMonthStats.Femeter.Fget_5Fdaystat.Fday_5Flist.Items[Cnt - 1]).Fenergy;
       end;
    end;
  end;

 if (Scheds <> Nil) and (Index = Grid.Row)  then
  begin

    for var i := 0  to GridS.ColCount do
     for var J := 0  to GridS.RowCount do
        GridS.Cells[i, j] := '';

    GridS.Cells[0, 0] := 'Id';    GridS.ColWidths[0] := 0;
    GridS.Cells[1, 0] := 'Schedule';  GridS.ColWidths[1] := 128;
    GridS.Cells[2, 0] := 'Status'; GridS.ColWidths[2] := 68;
    GridS.Cells[3, 0] := 'Power'; GridS.ColWidths[3] := 68;
    GridS.Cells[4, 0] := 'Time (hh:mm)';  GridS.ColWidths[4] := 68;
    GridS.Cells[5, 0] := 'Days';  GridS.ColWidths[5] := 200;

    GridS.RowCount := Scheds.Fschedule.Fget_5Frules.Frule_5Flist.Count + 1;
    var Row := 1;
    for var uRule in Scheds.Fschedule.Fget_5Frules.Frule_5Flist do
    begin
      var Rule := THS1x0_Schedule(uRule);
      GridS.Cells[0, Row] := Rule.FId;
      GridS.Cells[1, Row] := Rule.FName;
      GridS.Cells[2, Row] := BEnable[Boolean(Rule.Fenable)];
      GridS.Cells[3, Row] := BOnOff[Boolean(Rule.Fsact)];
      GridS.Cells[4, Row] :=Inttostr(Rule.Fsmin div 60) + ':'+  Inttostr(Rule.Fsmin mod 60) ;
      var CDay := 1;
      var DayTxt := '';
      for var Day in Rule.Fwday do
      begin
          if Day = 1 then DayTxt := DayTxt + TFormatSettings.Create.ShortDayNames[CDay] + ' ';
          Inc(CDay);
      end;
      GridS.Cells[5, Row] := DayTxt;
      Inc(Row);
    end;
  end;

  if (CntDwn <> Nil) and (Index = Grid.Row)  then
  begin

    if CntDwn.Fcount_5Fdown.Fget_5Frules.Frule_5Flist.Count = 0 then
    begin
      // ?? Bug ?? We Should have at least 1 rule...
      var AddCDRule := THS1x0_CountdownAddRuleRequest.Create;
      AddCDRule.Fcount_5Fdown.Fadd_5Frule.Fid := 0;
      AddCDRule.Fcount_5Fdown.Fadd_5Frule.Fenable := 0;
      AddCDRule.Fcount_5Fdown.Fadd_5Frule.Fname := 'Default Countdown';
      AddCDRule.Fcount_5Fdown.Fadd_5Frule.Fdelay := 30*60;
      AddCDRule.Fcount_5Fdown.Fadd_5Frule.Fact := 0;
      HS1x0.Countdown_AddRule(AddCDRule).Free;
      AddCDrule.Free;
    end;

    for var i := 0  to GridC.ColCount do
     for var J := 0  to GridC.RowCount do
        GridC.Cells[i, j] := '';

    GridC.Cells[0, 0] := 'Id';        GridC.ColWidths[0] := 0;
    GridC.Cells[1, 0] := 'Countdown'; GridC.ColWidths[1] := 128;
    GridC.Cells[2, 0] := 'Power';     GridC.ColWidths[2] := 68;
    GridC.Cells[3, 0] := 'Delay (hh:mm)';     GridC.ColWidths[3] := 72;
    GridC.Cells[4, 0] := 'Remaining'; GridC.ColWidths[4] := 68;
    GridC.RowCount := CntDwn.Fcount_5Fdown.Fget_5Frules.Frule_5Flist.Count + 1;
    var Row := 1;
    for var uCountdown in CntDwn.Fcount_5Fdown.Fget_5Frules.Frule_5Flist do
    begin
      var Countdown := THS1x0_Countdown(uCountdown);
      GridC.Cells[0, Row] := Countdown.FId;
      GridC.Cells[1, Row] := BEnable[Boolean(Countdown.Fenable)];
      GridC.Cells[2, Row] := BOnOff[Boolean(Countdown.Fact)];

      var Dd: integer := Countdown.Fdelay div 86400;
      var Hd: integer := (Countdown.Fdelay - Dd * 86400) div 60 div 60;
      var Md: integer := (Countdown.Fdelay - Dd * 86400 -  Hd * 3600) div 60;
      var Sd: integer := Countdown.Fdelay - Dd * 86400 - Hd * 3600 - Md * 60;
      GridC.Cells[3, Row] := Format('%.2d:%.2d', [Hd, Md]);
      GridC.Cells[4, Row] := secToDHMS(Countdown.Fremain, False);
      Inc(Row);
    end;

  end;

  Grid.EndUpdate;
  GridS.EndUpdate;
end;

{ THS1x0Thread }

procedure THSRealTime.Execute;
begin
  while not Terminated do
  begin
    var Start := Cardinal(GetTickCount);
    try
      var HS1x0 := THS1x0.Create(IP);
      if HS1x0 <> nil then
      begin
        var Info := HS1x0.System_GetSysinfo;
        var RealTime := HS1x0.Emeter_GetRealtime;
        var MonthStats      := HS1x0.Emeter_GetDayStat(IncDay(Now, 0));
        var Scheds := HS1x0.Schedule_GetRulesList;
        var CntDwn := HS1x0.Countdown_GetRulesList;
        var PrevMonthStats  := HS1x0.Emeter_GetDayStat(IncDay(Now, -1));
        if (Info <> Nil) and (RealTime <> Nil) and ( MonthStats <> Nil) then
          Synchronize( procedure begin HSForm.SyncGrid(Self, Self.Index, HS1x0, Info, RealTime, MonthStats, PrevMonthStats, Scheds, CntDwn); end );
        FreeAndNil(CntDwn);
        FreeAndNil(Scheds);
        FreeAndNil(PrevMonthStats);
        FreeAndNil(MonthStats);
        FreeAndNil(RealTime);
        FreeAndNil(Info);
      end;
      HS1x0.Free;
    except; end;
    while ((Start + 1000) > GetTickCount) and not Terminated do sleep(250);
  end;
end;

end.
