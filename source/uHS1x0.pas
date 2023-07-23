unit uHS1x0;

///
///  Author:  Laurent Meyer
///  Contact: HS1x0@ea4d.com
///
///  https://github.com/bnzbnz/Delphi-TP-Link-HS1x0-Protocol
///
///  License: MPL 1.1 / GPL 2.1
///

interface
uses Classes,
     IdTCPClient,
     uJsonX, uJsonX.Types;

// Reference
// https://www.softscheck.com/en/blog/tp-link-reverse-engineering/
// https://github.com/softScheck/tplink-smartplug/blob/master/tplink-smarthome-commands.txt

type

{$REGION 'HS1x0 JSON Types'}

  THS1x0_GenericError = class(TJsonXBaseEx2Type)
    Ferr_5Fcode: variant;
    Ferr_5Fmsg : variant;
  end;

  THS1x0Ex_Type047 = class(TJsonXBaseEx2Type)
    Ftype: variant;
    Fid: variant;
    Fschd_5Fsec: variant;
    Faction: variant;
  end;

  THS1x0_Type048 = class(THS1x0_GenericError)
    Fsw_5Fver: variant;
    Fhw_5Fver: variant;
    Ftype: variant;
    Fmodel: variant;
    Fmac: variant;
    Fdev_5Fname: variant;
    Falias: variant;
    Frelay_state: variant;
    Fon_5Ftime: variant;
    Factive_5Fmode: variant;
    Ffeature: variant;
    Fupdating: variant;
    Ficon_5Fhash: variant;
    Frssi: variant;
    Fled_5Foff: variant;
    Flongitude_5Fi: variant;
    Flatitude_5Fi: variant;
    Flongitude: variant;
    Flatitude: variant;
    FhwId: variant;
    FfwId: variant;
    FdeviceId: variant;
    FoemId: variant;
    Fnext_5Faction: THS1x0Ex_Type047;
  end;

  THS1x0_Type050 = class(TJsonXBaseEx2Type)
    Fset_5Frelay_5Fstate: THS1x0_GenericError;
  end;

  THS1x0_Type051 = class(TJsonXBaseEx2Type)
    Fget_5Fsysinfo: THS1x0_Type048;
  end;

  THS1x0_Type052 = class(TJsonXBaseEx2Type)
    Fset_5Fled_5Foff: THS1x0_Type048;
  end;

   THS1x0_Type053 = class(THS1x0_GenericError)
    // hw v1.0
    Fvoltage: variant;
    Fcurrent: variant;
    Fpower: variant;
    Ftotal: variant;
    // hw v2.0
    Fvoltage_mv: variant;
    Fcurrent_ma: variant;
    Fpower_mw: variant;
    Ftotal_wh: variant;
    // Common
    Ferr_5Fcode: variant;
  end;

  THS1x0_Type054 = class(TJsonXBaseEx2Type)
    Fget_5Frealtime: THS1x0_Type053;
  end;

  THS1x0_Type055 = class(TJsonXBaseEx2Type)
    Fset_5Fdev_5Falias: THS1x0_GenericError;
  end;

  THS1x0_Type056 = class(TJsonXBaseEx2Type)
    Freboot: THS1x0_GenericError;
  end;
  
  THS1x0_Type057 = class(TJsonXBaseEx2Type)
    Freset: THS1x0_GenericError;
  end;

  THS1x0_DayStat = class(TJsonXBaseEx2Type)
    // hw v1.0
    Fenergy_wh: variant; //Wh
    // hw v2.0
    Fenergy: variant;  //KWh
    // Common
    Fyear: variant;
    Fmonth: variant;
    Fday: variant;
  end;

  THS1x0_Type060 = class(THS1x0_GenericError)
    [AJsonXClassType(THS1x0_DayStat)]
    Fday_5Flist: TJsonXObjListType;
  end;

  THS1x0_Type058 = class(TJsonXBaseEx2Type)
    Fget_5Fdaystat: THS1x0_Type060;
  end;

  THS1x0_MonthStat = class(TJsonXBaseEx2Type)
    // hw v1.0
    Fenergy_wh: variant; //Wh
    // hw v2.0
    Fenergy: variant; //KWh
    // Common
    Fyear: variant;
    Fmonth: variant;
  end;

  THS1x0_Type071 = class(THS1x0_GenericError)
    [AJsonXClassType(THS1x0_MonthStat)]
    Fmonth_5Flist: TJsonXObjListType;
  end;

  THS1x0_Type070 = class(TJsonXBaseEx2Type)
    Fget_5Fmonthstat: THS1x0_Type071;
  end;

  THS1x0_System_SetRelayStateResponse = class(TJsonXBaseEx2Type)
    Fsystem: THS1x0_Type050;
  end;

  THS1x0_System_GetSysInfoResponse = class(TJsonXBaseEx2Type)
    Fsystem: THS1x0_Type051;
  end;

  THS1x0_System_SetLedResponse = class(TJsonXBaseEx2Type)
    Fsystem: THS1x0_Type052;
  end;

  THS1x0_EMeter_GetRealtimeCVResponse = class(TJsonXBaseEx2Type)
    Femeter: THS1x0_Type054;
  end;

  THS1x0_System_SetDeviceAliasResponse = class(TJsonXBaseEx2Type)
    Fsystem: THS1x0_Type055;
  end;

  THS1x0_System_RebootResponse = class(TJsonXBaseEx2Type)
    Fsystem: THS1x0_Type056;
  end;

  THS1x0_System_SystemResetResponse = class(TJsonXBaseEx2Type)
    Fsystem: THS1x0_Type057;
  end;

  THS1x0_EMeter_GetDayStatResponse = class(TJsonXBaseEx2Type)
    Femeter: THS1x0_Type058;
  end;

  THS1x0_EmEter_GetMonthStatResponse = class(TJsonXBaseEx2Type)
    Femeter: THS1x0_Type070;
  end;

  THS1x0_Type080 = class(TJsonXBaseEx2Type)

  end;

  // System: Get_Time

  THS1x0_Type081 = class(THS1x0_GenericError)
   Fyear: variant;
   Fmonth: variant;
   Fmday: variant;
   Fhour: variant;
   Fmin: variant;
   Fsec: variant;
  end;

  THS1x0_Type082 = class(TJsonXBaseEx2Type)
    Fget_5Ftime: THS1x0_Type081;
  end;

  THS1x0_System_GetTimeResponse = class(TJsonXBaseEx2Type)
    Ftime: THS1x0_Type082;
  end;

  // System: Get_Timezone

  THS1x0_Type083 = class(THS1x0_GenericError)
   Findex: variant;
  end;

  THS1x0_Type084 = class(TJsonXBaseEx2Type)
    Fget_5Ftimezone: THS1x0_Type083;
  end;

  THS1x0_System_GetTimezoneResponse = class(TJsonXBaseEx2Type)
    Ftime: THS1x0_Type084;
  end;

  // System: Set_Timezone

  THS1x0_Type085 = class(TJsonXBaseEx2Type)
   Fyear: variant;
   Fmonth: variant;
   Fmday: variant;
   Fhour: variant;
   Fmin: variant;
   Fsec: variant;
   Findex: variant;
  end;

  THS1x0_Type086 = class(TJsonXBaseEx2Type)
    Fset_5Ftimezone: THS1x0_Type085;
    constructor Create; overload;
  end;

  THS1x0_System_SetTimezoneRequest = class(TJsonXBaseEx2Type)
    Ftime: THS1x0_Type086;
    constructor Create; overload;
  end;

  THS1x0_Type088 = class(TJsonXBaseEx2Type)
    Fset_5Ftimezone: THS1x0_GenericError;
  end;

  THS1x0_System_SetTimezoneResponse = class(TJsonXBaseEx2Type)
    Ftime: THS1x0_Type088;
  end;

  // System: Set MAC Adress

  THS1x0_Type089 = class(TJsonXBaseEx2Type)
    Fset_5Fmac_5Faddr: THS1x0_GenericError;
  end;

  THS1x0_System_SetMACAdressResponse = class(TJsonXBaseEx2Type)
    Fsystem: THS1x0_Type089;
  end;

  // System: Set Device ID

  THS1x0_Type090 = class(TJsonXBaseEx2Type)
    Fset_5Fdevice_5Fid: THS1x0_GenericError;
  end;

  THS1x0_System_SetDeviceIDResponse = class(TJsonXBaseEx2Type)
    Fsystem: THS1x0_Type090;
  end;

  // System: Set Hardware ID

  THS1x0_Type091 = class(TJsonXBaseEx2Type)
    Fset_5Fhw_5Fid: THS1x0_GenericError;
  end;

  THS1x0_System_SetHardwareIDResponse = class(TJsonXBaseEx2Type)
    Fsystem: THS1x0_Type091;
  end;

  // System: Set Location

  THS1x0_Type092 = class(TJsonXBaseEx2Type)
    Fset_5Fdev_5Flocation: THS1x0_GenericError;
  end;

  THS1x0_System_SetDeviceLocationResponse = class(TJsonXBaseEx2Type)
    Fsystem: THS1x0_Type092;
  end;

  // System: TestCheckUBoot Location

  THS1x0_Type093 = class(TJsonXBaseEx2Type)
    Ftest_5Fcheck_5Fuboot: THS1x0_GenericError;
  end;

  THS1x0_System_TestCheckUBootResponse = class(TJsonXBaseEx2Type)
    Fsystem: THS1x0_Type093;
  end;

  // System: Get Device Icon

  THS1x0_Type094 = class(THS1x0_GenericError)
    Ficon: variant;
    Fhash: variant;
  end;

  THS1x0_Type095 = class(TJsonXBaseEx2Type)
    Fget_5Fdev_5Ficon: THS1x0_Type094;
  end;

  THS1x0_System_GetDeviceIconResponse = class(TJsonXBaseEx2Type)
    Fsystem: THS1x0_Type095;
  end;

  // System: Set Device Icon

  THS1x0_Type096 = class(TJsonXBaseEx2Type)
    Fset_5Fdev_5Ficon: THS1x0_GenericError;
  end;

  THS1x0_System_SetDeviceIconResponse = class(TJsonXBaseEx2Type)
    Fsystem: THS1x0_Type096;
  end;

  // System: Set Test Mode

  THS1x0_Type097 = class(TJsonXBaseEx2Type)
    Fset_5Ftest_5Fmode: THS1x0_GenericError;
  end;

  THS1x0_System_SetTestModeResponse = class(TJsonXBaseEx2Type)
    Fsystem: THS1x0_Type097;
  end;

  // System: Set Test Mode

  THS1x0_Type098 = class(TJsonXBaseEx2Type)
    Fdownload_5Ffirmware: THS1x0_GenericError;
  end;

  THS1x0_System_DowloadFirmwareResponse = class(TJsonXBaseEx2Type)
    Fsystem: THS1x0_Type098;
  end;

  // System: Get Dowload State

  THS1x0_Type099 = class(THS1x0_GenericError)
    Fstatus: variant;
    Fratio: variant;
    Freboot_5Ftime: variant;
    Fflash_5Ftime: variant;
  end;

  THS1x0_Type100 = class(TJsonXBaseEx2Type)
    Fget_5Fdownload_5Fstate: THS1x0_Type099;
  end;

  THS1x0_System_GetDownloadStateResponse = class(TJsonXBaseEx2Type)
    Fsystem: THS1x0_Type100;
  end;

  // System: Flash Firmware

  THS1x0_Type0102 = class(TJsonXBaseEx2Type)
    Fflash_5Ffirmware: THS1x0_GenericError;
  end;

  THS1x0_System_FlashFirmwareResponse = class(TJsonXBaseEx2Type)
    Fsystem: THS1x0_Type0102;
  end;

  // System: Check Config


  THS1x0_Type104 = class(TJsonXBaseEx2Type)
    Fcheck_5Fnew_5Fconfig: THS1x0_GenericError;
  end;

  THS1x0_System_CheckConfigResponse = class(TJsonXBaseEx2Type)
    Fsystem: THS1x0_Type104;
  end;

  // WLAN/Netif: Get Scan Info

  THS1x0_Type107 = class(TJsonXBaseEx2Type)
    Fssid: variant;
    Fkey_5Ftype: variant;
  end;

  THS1x0_Type106 = class(THS1x0_GenericError)
    [AJsonXClassType(THS1x0_Type107)]
    Fap_5Flist: TJsonXObjListType;
  end;

  THS1x0_Type105 = class(TJsonXBaseEx2Type)
    Fget_5Fscaninfo: THS1x0_Type106;
  end;

  THS1x0_Netif_GetScanInfoResponse = class(TJsonXBaseEx2Type)
    Fnetif: THS1x0_Type105;
  end;

  // WLAN/Netif: Set Sta Info ??

  THS1x0_Type108 = class(TJsonXBaseEx2Type)
    Fset_5Fstainfo: THS1x0_GenericError;
  end;

  THS1x0_Netif_SetStaInfoResponse = class(TJsonXBaseEx2Type)
    Fnetif: THS1x0_Type108;
  end;

  // Cloud: Get CLoud Info

  THS1x0_Type110 = class(THS1x0_GenericError)
    Fusername: variant;
    Fserver: variant;
    Fbinded: variant;
    Fcld_connection: variant;
    FillegalType: variant;
    FstopConnect: variant;
    FtcspStatus: variant;
    FfwDlPage: variant;
    FtcspInfo: variant;
    FfwNotifyType: variant;
  end;

  THS1x0_Type109 = class(TJsonXBaseEx2Type)
    Fget_5Finfo: THS1x0_Type110
  end;

  THS1x0_Cloud_GetCloudInfoResponse = class(TJsonXBaseEx2Type)
    FcnCloud : THS1x0_Type109;
  end;

  // Cloud: Get Intl Firmware List

  THS1x0_Type114 = class(TJsonXBaseEx2Type)
    // ??
  end;

  THS1x0_Type113 = class(THS1x0_GenericError)
    [AJsonXClassType(THS1x0_Type114)]
    Ffw_list: TJsonXObjListType;
  end;

  THS1x0_Type112 = class(TJsonXBaseEx2Type)
    Fget_5Fintl_5Ffw_5Flist: THS1x0_Type113
  end;

  THS1x0_Cloud_GetIntlFwListResponse = class(TJsonXBaseEx2Type)
    FcnCloud : THS1x0_Type112;
  end;

  // Cloud: Set Server URL

  THS1x0_Type115 = class(TJsonXBaseEx2Type)
    Fset_5Fserver_5Furl: THS1x0_GenericError;
  end;

  THS1x0_Cloud_SetServerURLResponse= class(TJsonXBaseEx2Type)
    FcnCloud : THS1x0_Type115;
  end;

  // Cloud: Bind

  THS1x0_Type0117 = class(TJsonXBaseEx2Type)
    Fbind: THS1x0_GenericError;
  end;

  THS1x0_Cloud_BindResponse = class(TJsonXBaseEx2Type)
    FcnCloud : THS1x0_Type0117;
  end;

  // Cloud Unbiind

  THS1x0_Type0119= class(TJsonXBaseEx2Type)
    Funbind: THS1x0_GenericError;
  end;

  THS1x0_Cloud_UnbindResponse = class(TJsonXBaseEx2Type)
    FcnCloud : THS1x0_Type0119;
  end;

  // EMeter: Get VGain IGain

  THS1x0_Type0121= class(THS1x0_GenericError)
    Fvgain: variant;
    Figain: variant;
  end;

  THS1x0_Type0120= class(TJsonXBaseEx2Type)
    Fget_5Fvgain_5Figain: THS1x0_Type0121;
  end;

  THS1x0_GetVGainIGainResponse = class(TJsonXBaseEx2Type)
    Femeter : THS1x0_Type0120;
  end;

  // EMeter: Set VGain IGain

  THS1x0_Type0122= class(TJsonXBaseEx2Type)
    Fset_5Fvgain_5Figain: THS1x0_GenericError;
  end;

  THS1x0_SetVGainIGainResponse = class(TJsonXBaseEx2Type)
    Femeter : THS1x0_Type0122;
  end;

  // EMeter: Start Calibration

  THS1x0_Type0124= class(TJsonXBaseEx2Type)
    Fstart_5Fcalibration: THS1x0_GenericError;
  end;

  THS1x0_StartCalibrationResponse = class(TJsonXBaseEx2Type)
    Femeter : THS1x0_Type0124;
  end;

  // Schedule: Get Next Action

  THS1x0_Type0127= class(THS1x0_GenericError)
    Ftype: variant;
    Fid: variant;
    Fschd_time: variant;
    Faction: variant;
  end;

  THS1x0_Type0126= class(TJsonXBaseEx2Type)
    Fget_5Fnext_5Faction: THS1x0_Type0127;
  end;

  THS1x0_Schedule_GetNextActionResponse = class(TJsonXBaseEx2Type)
    Fschedule : THS1x0_Type0126;
  end;

  // Schedule: Get Rules List

  THS1x0_Schedule = class(TJsonXBaseEx2Type)
    Fid: variant;
    Fstime_opt: variant;
    Fwday: TJsonXVarListType;
    Fsmin: variant;
    Fenable: variant;
    Frepeat: variant;
    Fetime_opt: variant;
    Fname: variant;
    Feact: variant;
    Fmonth: variant;
    Fsact: variant;
    Fyear: variant;
    Flongitude: variant;
    Flatitude: variant;
    Fday: variant;
    Fforce: variant;
    Femin: variant;
    constructor Create;
    //function Clone: TJsonXBaseExType; override;
  end;

  THS1x0_Type0129 = class(THS1x0_GenericError)
    [AJsonXClassType(THS1x0_Schedule)]
    Frule_5Flist: TJsonXObjListType;
    Fversion: variant;
    Fenable: variant;
  end;

  THS1x0_Type0128 = class(TJsonXBaseEx2Type)
    Fget_5Frules: THS1x0_Type0129;
  end;

  THS1x0_Schedule_GetRulesListResponse = class(TJsonXBaseEx2Type)
    Fschedule : THS1x0_Type0128;
  end;

  // Schedule: Add Rule

  THS1x0_Type0131 = class(TJsonXBaseEx2Type)
    Fadd_5Frule: THS1x0_Schedule;
    constructor Create;
  end;

  THS1x0_Schedule_AddRuleRequest = class(TJsonXBaseEx2Type)
    Fschedule : THS1x0_Type0131;
    constructor Create;
  end;

  THS1x0_Type0135 = class(THS1x0_GenericError)
    Fid: variant;
    Fconflict_5Fid: variant;
  end;

  THS1x0_Type0134 = class(TJsonXBaseEx2Type)
    Fadd_5Frule: THS1x0_Type0135;
  end;

  THS1x0_Schedule_AddRuleResponse = class(TJsonXBaseEx2Type)
    Fschedule : THS1x0_Type0134;
  end;

  // Schedule: Edit Rule

  THS1x0_Type0136 = class(TJsonXBaseEx2Type)
    Fedit_5Frule : THS1x0_Schedule;
    constructor Create;
  end;

  THS1x0_Schedule_EditRuleRequest = class(TJsonXBaseEx2Type)
    Fschedule : THS1x0_Type0136;
    constructor Create; overload;
    constructor Create(Id: string; aRule: THS1x0_Schedule_AddRuleRequest); overload;
    constructor Create(Rule: THS1x0_Schedule); overload;
  end;

  THS1x0_Type0139 = class(THS1x0_GenericError)
    Fconflict_5Fid: variant;
  end;

  THS1x0_Type0138 = class(TJsonXBaseEx2Type)
    Fedit_5Frule : THS1x0_Type0139;
  end;

  THS1x0_Schedule_EditRuleResponse = class(TJsonXBaseEx2Type)
    Fschedule : THS1x0_Type0138;
  end;

  // Schedule Delete Rule


  THS1x0_Type0140 = class(TJsonXBaseEx2Type)
    Fdelete_5Frule : THS1x0_GenericError;
  end;

  THS1x0_Schedule_DeleteRuleResponse = class(TJsonXBaseEx2Type)
    Fschedule : THS1x0_Type0140;
  end;

  //Delete All Rules

  THS1x0_Type0142 = class(TJsonXBaseEx2Type)
    Fdelete_5Fall_5Frules : THS1x0_GenericError;
  end;

  THS1x0_Schedule_DeleteAllRulesResponse = class(TJsonXBaseEx2Type)
    Fschedule : THS1x0_Type0142;
  end;

  // Countdown Get Rules

  THS1x0_Countdown  = class(TJsonXBaseEx2Type)
    Fid: variant;
    Fenable: variant;
    Fname: variant;
    Fdelay: variant; // Secondes
    Fact: variant;
    Fremain: variant;
  end;

  THS1x0_Type0145 = class(THS1x0_GenericError)
    [AJsonXClassType(THS1x0_Countdown)]
    Frule_5Flist: TJsonXObjListType;
  end;

  THS1x0_Type0144 = class(TJsonXBaseEx2Type)
    Fget_5Frules : THS1x0_Type0145;
  end;

  THS1x0_Countdown_GetRulesResponse = class(TJsonXBaseEx2Type)
    Fcount_5Fdown : THS1x0_Type0144;
  end;

  // Countdown: Add Rule

  THS1x0_Type0146 = class(TJsonXBaseEx2Type)
    Fadd_5Frule: THS1x0_Countdown;
    constructor Create;
  end;

  THS1x0_Countdown_AddRuleRequest = class(TJsonXBaseEx2Type)
    Fcount_5Fdown : THS1x0_Type0146;
    constructor Create;
  end;

  THS1x0_Type0148 = class(THS1x0_GenericError)
    Fid: variant;
    Fconflict_5Fid: variant;
  end;

  THS1x0_Type0147 = class(TJsonXBaseEx2Type)
    Fadd_5Frule: THS1x0_Type0148;
  end;

  THS1x0_Countdown_AddRuleResponse = class(TJsonXBaseEx2Type)
    Fcount_5Fdown : THS1x0_Type0147;
  end;

  // Countdown: Edit Rule

  THS1x0_Type0151 = class(TJsonXBaseEx2Type)
    Fedit_5Frule: THS1x0_Countdown;
    constructor Create;
  end;

  THS1x0_Countdown_EditRuleRequest = class(TJsonXBaseEx2Type)
    Fcount_5Fdown : THS1x0_Type0151;
    constructor Create; overload;
    constructor Create(Countdown: THS1x0_Countdown); overload;
  end;

  THS1x0_Type0149 = class(TJsonXBaseEx2Type)
    Fadd_5Frule: THS1x0_GenericError;
  end;

  THS1x0_Countdown_EditRuleResponse = class(TJsonXBaseEx2Type)
    Fcount_5Fdown : THS1x0_Type0149;
  end;

  // Countdown: Delete Rule

  THS1x0_Type0152 = class(THS1x0_GenericError)
    Fdelete_5Frule: THS1x0_GenericError;
  end;

  THS1x0_Countdown_DeleteRuleResponse = class(TJsonXBaseEx2Type)
    Fcount_5Fdown : THS1x0_Type0152;
  end;

  // Countdown: Delete All Rules

  THS1x0_Type0155 = class(TJsonXBaseEx2Type)
    Fdelete_5Fall_5Frules: THS1x0_GenericError;
  end;

  THS1x0_Countdown_DeleteAllRulesResponse = class(TJsonXBaseEx2Type)
    Fcount_5Fdown : THS1x0_Type0155;
  end;

  // AntiTheft: Get Rules List

  THS1x0_AntiTheft =  class(TJsonXBaseEx2Type)
    Fid: variant;
    Fname: variant;
    Fenable: variant;
    Fwday: TJsonXVarListType;
    Fstime_opt: variant;
    Fsoffset: variant;
    Fsmin: variant;
    Fetime_opt: variant;
    Feoffset: variant;
    Femin: variant;
    Ffrequency: variant;
    Frepeat: variant;
    Fyear: variant;
    Fmonth: variant;
    Fday: variant;
    Fduration: variant;
    Flastfor: variant;
    FLongitude: variant;
    Flatitude: variant;
    Fforce: variant;
    constructor Create;
  end;

  THS1x0_Type0157 = class(THS1x0_GenericError)
    [AJsonXClassType(THS1x0_AntiTheft)]
    Frule_5Flist: TJsonXObjListType;
    Fversion: variant;
    Fenable: variant;
  end;

  THS1x0_Type0156 =  class(TJsonXBaseEx2Type)
    Fget_5Frules: THS1x0_Type0157
  end;

  THS1x0_AnitTheft_GetRulesResponse = class(TJsonXBaseEx2Type)
    Fanti_5Ftheft : THS1x0_Type0156;
  end;

  // AntiTheft: Add Rule

  THS1x0_Type0158 = class(TJsonXBaseEx2Type)
    Fadd_5Frule: THS1x0_AntiTheft;
    Fset_5Foverall_5Fenable: variant;
    constructor Create;
  end;

  THS1x0_AnitTheft_AddRuleRequest = class(TJsonXBaseEx2Type)
    Fanti_5Ftheft : THS1x0_Type0158;
    constructor Create; overload;
    constructor Create(AntiTheft: THS1x0_AntiTheft); overload;
  end;


  THS1x0_Type0160 =  class(THS1x0_GenericError)
    [AJsonXClassType(THS1x0_AntiTheft)]
    Fid: variant;
  end;

  THS1x0_Type0159 =  class(TJsonXBaseEx2Type)
    Fadd_5Frule: THS1x0_Type0160
  end;

  THS1x0_AnitTheft_AddRuleResponse = class(TJsonXBaseEx2Type)
    Fanti_5Ftheft : THS1x0_Type0159;
  end;

  // AntiTheft: Edit Rule

  THS1x0_Type0161 = class(TJsonXBaseEx2Type)
    Fedit_5Frule: THS1x0_AntiTheft;
    constructor Create;
  end;

  THS1x0_AntiTheft_EditRuleRequest = class(TJsonXBaseEx2Type)
    Fanti_5Ftheft : THS1x0_Type0161;
    constructor Create; overload;
    constructor Create(AntiTheft: THS1x0_AntiTheft); overload;
  end;

  THS1x0_Type0162 = class(THS1x0_GenericError)
    Fid: variant;
    Fconflic_5Fid: variant;
  end;

  THS1x0_Type0163 = class(TJsonXBaseEx2Type)
    Fedit_5Frule: THS1x0_Type0152;
  end;

  THS1x0_AntiTheft_EditRuleResponse = class(TJsonXBaseEx2Type)
    Fanti_5Ftheft : THS1x0_Type0163;
  end;

  // AntiTheft: Delete Rule

  THS1x0_Type0165 = class(TJsonXBaseEx2Type)
    Fdelete_5Frule: THS1x0_GenericError;
  end;

  THS1x0_AntiTheft_DeleteRuleResponse = class(TJsonXBaseEx2Type)
    Fanti_5Ftheft : THS1x0_Type0165;
  end;

  // AntiTheft Delete All Rules

  THS1x0_Type0167 = class(TJsonXBaseEx2Type)
    Fdelete_5Fall_5Frules : THS1x0_GenericError;
  end;

  THS1x0_AntiTheft_DeleteAllRulesResponse = class(TJsonXBaseEx2Type)
    Fanti_5Ftheft : THS1x0_Type0167;
  end;

{$ENDREGION}

{$REGION 'HS1x0 Intf'}

  THS1x0 = class(TObject)
  private
    FTCP :    TidTCPClient;
    FIP:      string;
    LReq:     string;
    LRes:     string;
    function  RequestToJson(Request: TJsonXBaseEx2Type): string;  // HS 100 Compatibility
    function  XOREncrypt(Key: Byte; Str: string): TMemoryStream;
    function  XORDecrypt(Key: Byte; Stream: TMemoryStream): string;
    function  DoRequest(JsonBody: string): string;
    function  GetnIPv4: Cardinal;
  public

    constructor     Create(IP: string); overload;
    constructor     Create(nIP: Cardinal); overload;
    destructor      Destroy; override;

    // Custom Commands
    function        Ping: Boolean;
    // System Commands
    function        System_GetSysinfo: THS1x0_System_GetSysInfoResponse;
    function        System_Reboot: THS1x0_System_RebootResponse;
    function        System_Reset(DelaySec: Integer): THS1x0_System_SystemResetResponse;
    function        System_PowerOn: Boolean;
    function        System_PowerOff: Boolean;
    function        System_LedOn: Boolean;
    function        System_LedOff: Boolean;
    function        System_SetDeviceAlias(NewAlias: string): Boolean;
    function        System_SetMACAdress(MAC: string): Boolean;
    function        System_SetDeviceID(DeviceID: string): Boolean;
    function        System_SetHardwareID(HardwareID: string): Boolean;
    function        System_SetDeviceLocation(Longitude, Latitude : Real): Boolean;
    function        System_TestCheckUBoot: Boolean;
    function        System_GetDeviceIcon: Boolean;
    function        System_SetDeviceIcon(Icon, Hash: string): Boolean;
    function        System_SetTestMode: Boolean; // (command only accepted coming from IP 192.168.1.100)
    function        System_DownloadFrimware(Uri: string): Boolean;
    function        System_GetDownloadState: THS1x0_System_GetDownloadStateResponse;
    function        System_FlashFirmware: THS1x0_System_FlashFirmwareResponse;
    function        System_CheckConfig: THS1x0_System_CheckConfigResponse;

    // WLAN/Netif Commands
    function        Netif_GetScanInfo(Refresh: Integer = 1): THS1x0_Netif_GetScanInfoResponse;
    function        Netif_SetStaInfo(Ssid, Password: string; KeyType: Integer): Boolean;

    // Cloud Commands
    function        Cloud_GetInfo: THS1x0_Cloud_GetCloudInfoResponse;
    function        Cloud_GetIntlFwList: THS1x0_Cloud_GetIntlFwListResponse;
    function        Cloud_SetServerURL(URL: string = 'devs.tplinkcloud.com'): Boolean;
    function        Cloud_Bind(Username, Password: string): Boolean;
    function        Cloud_Unbind: Boolean;

    // Time Commands
    function        Time_GetTime: TDateTime;
    function        Time_GetTimezone: Integer;
    function        Time_SetTimezone(DateTime: TDateTime; TimeZoneIndex: Integer): Boolean;

    // Emeter Commands
    function        Emeter_GetRealtime: THS1x0_EMeter_GetRealtimeCVResponse;
    function        Emeter_GetVGainIGain: THS1x0_GetVGainIGainResponse;
    function        Emeter_SetVGainIGain(VGain, IGain: Integer): Boolean;
    function        Emeter_StartCalibration(VTarget, ITarget: Integer): Boolean;
    function        Emeter_GetDayStat(Month, Year: Integer): THS1x0_EMeter_GetDayStatResponse; overload;
    function        Emeter_GetDayStat(Date: TDateTime): THS1x0_EMeter_GetDayStatResponse; overload;
    function        Emeter_GetMonthStat(Date: TDateTime): THS1x0_EMeter_GetMonthStatResponse;
    function        Emeter_Reset: Boolean;

    // Schedule Commands
    function        Schedule_GetNextAction: THS1x0_Schedule_GetNextActionResponse;
    function        Schedule_GetRulesList: THS1x0_Schedule_GetRulesListResponse;
    function        Schedule_AddRule(Rule: THS1x0_Schedule_AddRuleRequest): THS1x0_Schedule_AddRuleResponse;
    function        Schedule_EditRule(Rule: THS1x0_Schedule_EditRuleRequest): THS1x0_Schedule_EditRuleResponse;
    function        Schedule_DeleteRule(Id: string): THS1x0_Schedule_DeleteRuleResponse;
    function        Schedule_DeleteAllRules: THS1x0_Schedule_DeleteAllRulesResponse;

    // Countdown Commands                                        x`
    function        Countdown_GetRulesList: THS1x0_Countdown_GetRulesResponse;
    function        Countdown_AddRule(Rule: THS1x0_Countdown_AddRuleRequest): THS1x0_Countdown_AddRuleResponse;
    function        Countdown_EditRule(Rule: THS1x0_Countdown_EditRuleRequest): THS1x0_Countdown_EditRuleResponse;
    function        Countdown_DeleteRule(Id: string): THS1x0_Countdown_DeleteRuleResponse;
    function        Countdown_DeleteAllRules: THS1x0_Countdown_DeleteAllRulesResponse;

    // AntiTheft Commands
    function        AntiTheft_GetRulesList: THS1x0_AnitTheft_GetRulesResponse;
    function        AntiTheft_AddRule(Rule: THS1x0_AnitTheft_AddRuleRequest): THS1x0_AnitTheft_AddRuleResponse;
    function        AntiTheft_EditRule(Rule: THS1x0_AntiTheft_EditRuleRequest): THS1x0_AntiTheft_EditRuleResponse;
    function        AntiTheft_DeleteRule(Id: string): THS1x0_AntiTheft_DeleteRuleResponse;
    function        AntiTheft_DeleteAllRules: THS1x0_AntiTheft_DeleteAllRulesResponse;

     // Debugging
    property IPv4: string read FIP;
    property nIPv4: Cardinal read GetnIPv4;
    property LastRequest: string read LReq;
    property LastResponse: string read LRes;
  end;

{$ENDREGION}

implementation
uses StrUtils, SysUtils, DateUtils, IdGlobal, IdIOHandler, Variants, uNetUtils;

{$REGION 'THS1x0 Core'}

constructor THS1x0.Create(IP: string);
begin
  inherited Create;
  FTCP := TidTCPClient.Create(nil);
  FIP := IP;
  FTCP.Host := FIP;
  FTCP.Port := 9999;
  FTCP.ConnectTimeout := 500;
  FTCP.ReadTimeout := 1500;
  FTCP.ReuseSocket := rsOSDependent;
end;

constructor THS1x0.Create(nIP: Cardinal);
begin
  Create(IpAddrToStr(nIP));
end;

destructor THS1x0.Destroy;
begin
  FTCP.Disconnect;
  FTCP.Free;
  inherited;
end;

function THS1x0.XOREncrypt(Key: Byte; Str: string): TMemoryStream;
begin
  Result := TMemoryStream.Create;
  for var i := 1 to Length(Str) do
  begin
    var a := Key xor ord(Str[i]);
    Key := a;
    Result.WriteData(Byte(a));
  end;
  Result.Position := 0;
end;

function THS1x0.XORDecrypt(Key: Byte; Stream: TMemoryStream): string;
var
  c: Byte;
begin
  Result := '';
  Stream.Position := 0;
  while(Stream.Position < Stream.Size) do
  begin
    Stream.read(c, 1);
    var a := Key xor c;
    Key := c;
    Result := Result + chr(a);
  end;
end;

function THS1x0.RequestToJson(Request: TJsonXBaseEx2Type): string;  // HS 100 Compatibility
begin
  var ParamsHS100 := TJsonXSystemParameters.Create(Nil, [jxoUnassignedAsNull]);
  try
    Result := TJsonX.Writer(Request, ParamsHS100)
  finally
    ParamsHS100.Free;
  end;
end;


function THS1x0.DoRequest(JsonBody: string): string;
var
  Stream: TMemoryStream;
begin
  Stream := nil;
  try
    LReq := JsonBody;
    try
      if not FTCP.Connected then FTCP.Connect;
      Stream := XOREncrypt($AB, JsonBody);
      FTCP.IOHandler.Write(UInt32(Stream.Size), True);
      FTCP.IOHandler.Write(Stream);
      FTCP.IOHandler.Readable;
      Stream.Clear;
      var ResSize := FTCP.IOHandler.ReadUInt32(True);
      FTCP.IOHandler.ReadStream(Stream, ResSize);
      Result := XORDecrypt($AB, Stream);
    except
      Result := '';
    end;
  finally
    LRes := Result;
    Stream.Free;
    FTCP.Disconnect;
  end;
end;

function THS1x0.GetnIPv4: Cardinal;
begin
  Result := StrToIPAddr(FIP);
end;

function THS1x0.Ping: Boolean;
begin
  Result := DoRequest('{"system":{"ping":{}}}') <> '';
end;

{$ENDREGION}

{$REGION 'System Commands'}

function THS1x0.System_GetSysinfo: THS1x0_System_GetSysInfoResponse;
begin
  Result :=
    TJsonX.Parser<THS1x0_System_GetSysInfoResponse>(
      DoRequest('{"system":{"get_sysinfo":{}}}')
    );
end;


function THS1x0.System_LedOn: Boolean;
begin
  Result :=  False;
  var Response := DoRequest('{"system":{"set_led_off":{"off":0}}}');
  if Response = '' then Exit;
  var Led := TJsonX.Parser<THS1x0_System_SetLedResponse>(Response);
  if Led <> nil then
  begin
    Result := Led.FSystem.Fset_5Fled_5Foff.Ferr_5Fcode = 0;
    Led.Free;
  end;
end;

function THS1x0.System_LedOff: Boolean;
begin
  Result :=  False;
  var Response := DoRequest('{"system":{"set_led_off":{"off":1}}}');
  if Response = '' then Exit;
  var Led := TJsonX.Parser<THS1x0_System_SetLedResponse>(Response);
  if Led <> nil then
  begin
    Result := Led.FSystem.Fset_5Fled_5Foff.Ferr_5Fcode = 0;
    Led.Free;
  end;
end;

function THS1x0.System_PowerOn: Boolean;
begin
  Result := False;
  var Response := DoRequest('{"system":{"set_relay_state":{"state":1}}}');
  var RelayState := TJsonX.Parser<THS1x0_System_SetRelayStateResponse>(Response);
  if RelayState <> nil then
  begin
    Result := RelayState.Fsystem.Fset_5Frelay_5Fstate.Ferr_5Fcode = 0;
    RelayState.Free;
  end;
end;

function THS1x0.System_PowerOff: Boolean;
begin
  Result := False;
  var Response := DoRequest('{"system":{"set_relay_state":{"state":0}}}');
  if Response = '' then Exit;
  var RelayState := TJsonX.Parser<THS1x0_System_SetRelayStateResponse>(Response);
  if RelayState <> nil then
  begin
    Result := RelayState.Fsystem.Fset_5Frelay_5Fstate.Ferr_5Fcode = 0;
    RelayState.Free;
  end;
end;

function THS1x0.System_Reboot: THS1x0_System_RebootResponse;
begin
  Result :=
    TJsonX.Parser<THS1x0_System_RebootResponse>(
      DoRequest('{"system":{"reboot":{"delay":1}}}')
    );
end;

function THS1x0.System_Reset(DelaySec: Integer): THS1x0_System_SystemResetResponse;
begin
  Result :=
    TJsonX.Parser<THS1x0_System_SystemResetResponse>(
      DoRequest(Format('{"system":{"reset":{"delay":%d}}}', [DelaySec]))
    );
end;

function THS1x0.System_SetDeviceAlias(NewAlias: string): Boolean;
begin
  Result := False;
  var ResJSON := DoRequest(Format('{"system":{"set_dev_alias":{"alias":"%s"}}}', [NewAlias]));
  if ResJSON = '' then Exit;
  var Response := TJsonX.Parser<THS1x0_System_SetDeviceAliasResponse>(ResJSON);
  if Response <> nil then
  begin
    Result := Response.Fsystem.Fset_5Fdev_5Falias.Ferr_5Fcode = 0;
    Response.Free;
  end;
end;

function THS1x0.System_SetMACAdress(MAC: string): Boolean;
begin
  Result := False;
  var ResJSON := DoRequest(Format('{"system":{"set_mac_addr":{"mac":"%s"}}}}', [MAC]));
  if ResJSON = '' then Exit;
  var Response  := TJsonX.Parser<THS1x0_System_SetMACAdressResponse>(ResJSON);
  if Response <> nil then
  begin
    Result := Response.Fsystem.Fset_5Fmac_5Faddr.Ferr_5Fcode = 0;
    Response.Free;
  end;
end;

function THS1x0.System_TestCheckUBoot: Boolean;
begin
  Result := False;
  var ResJSON := DoRequest(Format('{"system":{"test_check_uboot":null}}}', []));
  if ResJSON = '' then Exit;
  var Response  := TJsonX.Parser<THS1x0_System_TestCheckUBootResponse>(ResJSON);
  if Response <> nil then
  begin
    Result := Response.Fsystem.Ftest_5Fcheck_5Fuboot.Ferr_5Fcode = 0;
    Response.Free;
  end;
end;

function THS1x0.System_GetDeviceIcon: Boolean;
begin
  Result := False;
  var ResJSON := DoRequest(Format('{"system":{"get_dev_icon":null}}', []));
    if ResJSON = '' then Exit;
  var Response := TJsonX.Parser<THS1x0_System_GetDEviceIconResponse>(ResJSON);
  if Response <> nil then
  begin
    Result := Response.Fsystem.Fget_5Fdev_5Ficon.Ferr_5Fcode = 0;
    Response.Free;
  end;
end;

function THS1x0.System_SetDeviceID(DeviceID: string): Boolean;
begin
  Result := False;
  var ResJSON := DoRequest(Format('{"system":{"set_device_id":{"deviceId":"%s"}}}}', [DeviceID]));
  if ResJSON = '' then Exit;
  var Response  := TJsonX.Parser<THS1x0_System_SetDeviceIDResponse>(ResJSON);
  if Response <> nil then
  begin
    Result := Response.Fsystem.Fset_5Fdevice_5Fid.Ferr_5Fcode = 0;
    Response.Free;
  end;
end;

function THS1x0.System_SetHardwareID(HardwareID: string): Boolean;
begin
  Result := False;
  var ResJSON := DoRequest(Format('{"system":{"set_hw_id":{"hwId":"%s"}}}}', [HardwareID]));
  if ResJSON = '' then Exit;
  var Response  := TJsonX.Parser<THS1x0_System_SetHardwareIDResponse>(ResJSON);
  if Response <> nil then
  begin
    Result := Response.Fsystem.Fset_5Fhw_5Fid.Ferr_5Fcode = 0;
    Response.Free;
  end;
end;

function THS1x0.System_SetDeviceLocation(Longitude, Latitude: Real): Boolean;
begin
  Result := False;
  var ResJSON := DoRequest(Format('{"system":{"set_dev_location":{"longitude":%.6f,"latitude":%.6f}}}', [Longitude, Latitude]));
  if ResJSON = '' then Exit;
  var Response  := TJsonX.Parser<THS1x0_System_SetDeviceLocationResponse>(ResJSON);
  if Response <> nil then
  begin
    Result := Response.Fsystem.Fset_5Fdev_5Flocation.Ferr_5Fcode = 0;
    Response.Free;
  end
end;

function THS1x0.System_SetDeviceIcon(Icon, Hash: string): Boolean;
begin
  Result := False;
  var ResJSON := DoRequest(Format('{"system":{"set_dev_icon":{"icon":"%S","hash":"%s"}}}', [Icon, Hash]));
  if ResJSON = '' then Exit;
  var Response  := TJsonX.Parser<THS1x0_System_SetDeviceIconResponse>(ResJSON);
  if Response <> nil then
  begin
    Result := Response.Fsystem.Fset_5Fdev_5Ficon.Ferr_5Fcode = 0;
    Response.Free;
  end;
end;

function THS1x0.System_SetTestMode: Boolean;  // (command only accepted coming from IP 192.168.1.100)
begin
  Result := False;
  var ResJSON := DoRequest(Format('{"system":{"set_test_mode":{"enable":1}}}', []));
  if ResJSON = '' then Exit;
  var Response  := TJsonX.Parser<THS1x0_System_SetTestModeResponse>(ResJSON);
  if Response <> nil then
  begin
    Result := Response.Fsystem.Fset_5Ftest_5Fmode.Ferr_5Fcode = 0;
    Response.Free;
  end;
end;

function THS1x0.System_DownloadFrimware(Uri: string): Boolean;
begin
  Result := False;
  var ResJSON := DoRequest(Format('{"system":{"download_firmware":{"url":"%s"}}}', [Uri]));
  if ResJSON = '' then Exit;
  var Response  := TJsonX.Parser<THS1x0_System_DowloadFirmwareResponse>(ResJSON);
  if Response <> nil then
  begin
    Result := Response.Fsystem.Fdownload_5Ffirmware.Ferr_5Fcode = 0;
    Response.Free;
  end;
end;

function THS1x0.System_GetDownloadState: THS1x0_System_GetDownloadStateResponse;
begin
  Result := nil;
  var ResJSON := DoRequest(Format('{"system":{"get_download_state":{}}}', []));
  if ResJSON = '' then Exit;
  Result :=  TJsonX.Parser<THS1x0_System_GetDownloadStateResponse>(ResJSON);
end;

function THS1x0.System_FlashFirmware: THS1x0_System_FlashFirmwareResponse;
begin
  Result := nil;
  var ResJSON := DoRequest(Format('{"system":{"flash_firmware":{}}}', []));
  if ResJSON = '' then Exit;
  Result := TJsonX.Parser<THS1x0_System_FlashFirmwareResponse>(ResJSON);
end;

function THS1x0.System_CheckConfig: THS1x0_System_CheckConfigResponse;
begin
  Result := nil;
  var ResJSON := DoRequest(Format('{"system":{"check_new_config":null}}', []));
  if ResJSON = '' then Exit;
  Result := TJsonX.Parser<THS1x0_System_CheckConfigResponse>(ResJSON);
end;

{$ENDREGION}

{$REGION 'WLAN Commands'}

function  THS1x0.Netif_GetScanInfo(Refresh: Integer): THS1x0_Netif_GetScanInfoResponse;
begin
  Result := nil;
  var ResJSON := DoRequest( Format('{"netif":{"get_scaninfo":{"refresh":%d}}}}',[Refresh]));
  if ResJSON = '' then Exit;
  Result :=  TJsonX.Parser<THS1x0_Netif_GetScanInfoResponse>(ResJSON);
end;

function THS1x0.Netif_SetStaInfo(Ssid, Password: string; KeyType: Integer): Boolean;
begin
  Result := False;
  var ResJSON := DoRequest( Format('{"netif":{"set_stainfo":{"ssid":"%s","password":"%s","key_type":%d}}}',[Ssid, Password, KeyType]));
  if ResJSON = '' then Exit;
   var Response := TJsonX.Parser<THS1x0_Netif_SetStaInfoResponse>(ResJSON);
  if Response <> nil then
  begin
    Result := Response.Fnetif.Fset_5Fstainfo.Ferr_5Fcode = 0;
    Response.Free;
  end;
end;

{$ENDREGION}

{$REGION 'Emeter Commands'}

function THS1x0.Emeter_GetRealtime: THS1x0_EMeter_GetRealtimeCVResponse;
begin
  Result := nil;
  try
    var ResJSON := DoRequest('{"emeter":{"get_realtime":{}}}');
    if ResJSON = '' then raise Exception.Create('Invalid Response');
    Result := TJsonX.Parser<THS1x0_EMeter_GetRealtimeCVResponse>(ResJSON);
    if Result = nil then
      raise Exception.Create('Invalid Response');
    if Result.Femeter.Fget_5Frealtime = nil then  // HS100
      raise Exception.Create('Invalid Response');

    if Result.Femeter.Fget_5Frealtime.Ferr_5Fcode = 0 then
    begin
       // Compat hw v1.0/2.0
      if VarIsEmpty(Result.Femeter.Fget_5Frealtime.Fpower_mw) then
        Result.Femeter.Fget_5Frealtime.Fpower_mw := Result.Femeter.Fget_5Frealtime.Fpower * 1000;
      if VarIsEmpty(Result.Femeter.Fget_5Frealtime.Fcurrent_ma) then
        Result.Femeter.Fget_5Frealtime.Fcurrent_ma := Result.Femeter.Fget_5Frealtime.Fcurrent * 1000;
      if VarIsEmpty(Result.Femeter.Fget_5Frealtime.Fvoltage_mv) then
        Result.Femeter.Fget_5Frealtime.Fvoltage_mv := Result.Femeter.Fget_5Frealtime.Fvoltage * 1000;
      if VarIsEmpty(Result.Femeter.Fget_5Frealtime.Ftotal_wh) then
        Result.Femeter.Fget_5Frealtime.Ftotal_wh := Result.Femeter.Fget_5Frealtime.Ftotal * 1000;
      // Compat hw v1.0/2.0
      if VarIsEmpty(Result.Femeter.Fget_5Frealtime.Fpower) then
        Result.Femeter.Fget_5Frealtime.Fpower := Result.Femeter.Fget_5Frealtime.Fpower_mw / 1000;
      if VarIsEmpty(Result.Femeter.Fget_5Frealtime.Fcurrent) then
        Result.Femeter.Fget_5Frealtime.Fcurrent := Result.Femeter.Fget_5Frealtime.Fcurrent_ma / 1000;
      if VarIsEmpty(Result.Femeter.Fget_5Frealtime.Fvoltage) then
        Result.Femeter.Fget_5Frealtime.Fvoltage := Result.Femeter.Fget_5Frealtime.Fvoltage_mv / 1000;
      if VarIsEmpty(Result.Femeter.Fget_5Frealtime.Ftotal) then
        Result.Femeter.Fget_5Frealtime.Ftotal := Result.Femeter.Fget_5Frealtime.Ftotal_wh / 1000;
    end;
  except
    FreeAndNil(Result);
  end;
end;

function THS1x0.Emeter_GetVGainIGain: THS1x0_GetVGainIGainResponse;
begin
  Result := nil;
  try
    var ResJSON := DoRequest('{"emeter":{"get_vgain_igain":{}}}');
    if ResJSON = '' then Exit;
    Result := TJsonX.Parser<THS1x0_GetVGainIGainResponse>(ResJSON);
    if Result = nil then
      raise Exception.Create('Invalid Response');
    if Result.Femeter.Fget_5Fvgain_5Figain = nil then // HS100
      raise Exception.Create('Invalid Response');
  except
    FreeAndNil(Result);
  end;
end;

function THS1x0.Emeter_SetVGainIGain(VGain, IGain: Integer): Boolean;
begin
  var ResObj: THS1x0_SetVGainIGainResponse := nil;
  Result := False;
  try
    var ResJSON := DoRequest(Format('{"emeter":{"set_vgain_igain":{"vgain":%d,"igain":%d}}}',[VGain, IGain]));
    ResObj := TJsonX.Parser<THS1x0_SetVGainIGainResponse>(ResJSON);
    if ResObj = nil then Exit;
    if ResObj.Femeter.Fset_5Fvgain_5Figain = nil then Exit; // HS100
    Result := ResObj.Femeter.Fset_5Fvgain_5Figain.Ferr_5Fcode = 0;
  finally
    ResObj.Free;
  end;
end;

function THS1x0.Emeter_StartCalibration(VTarget, ITarget: Integer): Boolean;
begin
  var ResObj: THS1x0_StartCalibrationResponse := nil;
  Result := False;
  try
    var ResJSON := DoRequest(Format('{"emeter":{"start_calibration":{"vtarget":%d,"itarget":%d}}}',[VTarget, ITarget]));
    ResObj := TJsonX.Parser<THS1x0_StartCalibrationResponse>(ResJSON);
    if ResObj = nil then Exit;
    if ResObj.Femeter.Fstart_5Fcalibration = nil then Exit; // HS100
    Result := ResObj.Femeter.Fstart_5Fcalibration.Ferr_5Fcode = 0;
  finally
     ResObj.Free;
  end;
end;

function THS1x0.Emeter_GetDayStat(Month, Year: Integer): THS1x0_EMeter_GetDayStatResponse;
begin
  Result := nil;
  try
    var ResJSON := DoRequest( Format('{"emeter":{"get_daystat":{"month":%d,"year":%d}}}',[Month,Year]));
    if ResJSON = '' then Exit;
    Result :=  TJsonX.Parser<THS1x0_EMeter_GetDayStatResponse>(ResJSON);
    if Result = nil then
      raise Exception.Create('Invalid Response');
    if Result.Femeter.Fget_5Fdaystat = nil then // HS100
    raise Exception.Create('Invalid Response');
    // Compat hw v1.0/2.0
    if Result.Femeter.Fget_5Fdaystat.Ferr_5Fcode = 0 then
      for var v in (Result.Femeter.Fget_5Fdaystat.Fday_5Flist) do
      begin
        if VarIsEmpty(THS1x0_DayStat(v).Fenergy_wh) then
          THS1x0_DayStat(v).Fenergy_wh := THS1x0_DayStat(v).Fenergy * 1000;
        if VarIsEmpty(THS1x0_DayStat(v).Fenergy) then
          THS1x0_DayStat(v).Fenergy := THS1x0_DayStat(v).Fenergy_wh / 1000;
      end;
  except
    FreeAndNil(Result);
  end;
end;

function THS1x0.Emeter_GetDayStat(Date: TDateTime): THS1x0_EMeter_GetDayStatResponse;
var
  Y, M, D: Word;
begin
  DecodeDate(Date, Y, M, D);
  Result := Emeter_GetDayStat(M, Y);
end;

function THS1x0.Emeter_GetMonthStat(Date: TDateTime): THS1x0_EMeter_GetMonthStatResponse;
var
  Y, M, D: Word;
begin
  Result := nil;
  try
    DecodeDate(Date, Y, M, D);
    var ResJSON := DoRequest( Format('{"emeter":{"get_monthstat":{"year":Y}}}',[Y]));
    if ResJSON = '' then Exit;
    Result := TJsonX.Parser<THS1x0_EMeter_GetMonthStatResponse>(ResJSON);
    if Result = nil then
      raise Exception.Create('Invalid Response');
    if Result.Femeter.Fget_5Fmonthstat = nil then // HS100
      raise Exception.Create('Invalid Response');
    if Result.Femeter.Fget_5Fmonthstat.Ferr_5Fcode = 0 then
    begin
      // Compat hw v1.0/2.0
      for var v in (Result.Femeter.Fget_5Fmonthstat.Fmonth_5Flist) do
      begin
        if VarIsEmpty(THS1x0_MonthStat(v).Fenergy_wh) then
          THS1x0_MonthStat(v).Fenergy_wh := THS1x0_MonthStat(v).Fenergy * 1000;
        if VarIsEmpty(THS1x0_MonthStat(v).Fenergy) then
          THS1x0_MonthStat(v).Fenergy := THS1x0_MonthStat(v).Fenergy_wh / 1000;
      end;
    end;
  except
    FreeAndNil(Result);
  end;
end;

function THS1x0.Emeter_Reset: Boolean;
begin
  Result := DoRequest('{"emeter":{"erase_emeter_stat":null}}') <> '';
end;

{$ENDREGION}

{$REGION 'Schedule Commands'}

function THS1x0.Schedule_GetNextAction: THS1x0_Schedule_GetNextActionResponse;
begin
  Result := nil;
  var ResJSON := DoRequest( Format('{"schedule":{"get_next_action":null}}', []));
  if ResJSON = '' then Exit;
  Result :=  TJsonX.Parser<THS1x0_Schedule_GetNextActionResponse>(ResJSON);
end;

function THS1x0.Schedule_GetRulesList: THS1x0_Schedule_GetRulesListResponse;
begin
  Result := nil;
  var ResJSON := DoRequest( Format('{"schedule":{"get_rules":null}}', []));
  if ResJSON = '' then Exit;
  Result :=  TJsonX.Parser<THS1x0_Schedule_GetRulesListResponse>(ResJSON);
end;

constructor THS1x0_Type0131.Create;
begin
  inherited;
  Self.Fadd_5Frule := THS1x0_Schedule.Create;
end;

constructor THS1x0_Schedule_AddRuleRequest.Create;
begin
  inherited;
  Self.Fschedule := THS1x0_Type0131.Create;
end;

constructor THS1x0_Schedule.Create;
begin
  inherited;
  Self.Fwday := TJsonXVarListType.Create;
end;

function THS1x0.Schedule_AddRule(Rule: THS1x0_Schedule_AddRuleRequest): THS1x0_Schedule_AddRuleResponse;
begin
  Result := nil;
  var ReqJSON := RequestToJson(Rule);
  if ReqJSON = '' then Exit;
  var ResJSON := DoRequest(ReqJSON);
  if ResJSON = '' then Exit;
  Result :=  TJsonX.Parser<THS1x0_Schedule_AddRuleResponse>(ResJSON);
  if (Result <> nil) and (Result.Fschedule.Fadd_5Frule.Ferr_5Fcode = 0) then
    Rule.Fschedule.Fadd_5Frule.Fid := Result.Fschedule.Fadd_5Frule.Fid;
end;

constructor THS1x0_Type0136.Create;
begin
  Inherited;
  Self.Fedit_5Frule := THS1x0_Schedule.Create;
end;

constructor THS1x0_Schedule_EditRuleRequest.Create;
begin
  Inherited;
  Self.Fschedule := THS1x0_Type0136.Create;
end;

constructor THS1x0_Schedule_EditRuleRequest.Create(Id: string; aRule: THS1x0_Schedule_AddRuleRequest);
begin
  Create;
  Self.Fschedule.Fedit_5Frule.Fid := Id;
  Self.Fschedule.Fedit_5Frule.Fstime_opt := aRule.Fschedule.Fadd_5Frule.Fstime_opt;
  for var day in  aRule.Fschedule.Fadd_5Frule.Fwday do
    Self.Fschedule.FEdit_5Frule.Fwday.Add(Day);
  Self.Fschedule.Fedit_5Frule.Fsmin := aRule.Fschedule.Fadd_5Frule.Fsmin;
  Self.Fschedule.Fedit_5Frule.Fenable:= aRule.Fschedule.Fadd_5Frule.Fenable;
  Self.Fschedule.Fedit_5Frule.Frepeat:= aRule.Fschedule.Fadd_5Frule.Frepeat;

  Self.Fschedule.Fedit_5Frule.Fetime_opt:= aRule.Fschedule.Fadd_5Frule.Fetime_opt;
  Self.Fschedule.Fedit_5Frule.Fname:= aRule.Fschedule.Fadd_5Frule.Fname;
  Self.Fschedule.Fedit_5Frule.Feact:= aRule.Fschedule.Fadd_5Frule.Feact;
  Self.Fschedule.Fedit_5Frule.Fmonth:= aRule.Fschedule.Fadd_5Frule.Fmonth;

  Self.Fschedule.Fedit_5Frule.Fsact:= aRule.Fschedule.Fadd_5Frule.Fsact;
  Self.Fschedule.Fedit_5Frule.Fyear:= aRule.Fschedule.Fadd_5Frule.Fyear;
  Self.Fschedule.Fedit_5Frule.Flongitude:= aRule.Fschedule.Fadd_5Frule.Flongitude;
  Self.Fschedule.Fedit_5Frule.Flatitude:= aRule.Fschedule.Fadd_5Frule.Flatitude;

  Self.Fschedule.Fedit_5Frule.Fday:= aRule.Fschedule.Fadd_5Frule.Fday;
  Self.Fschedule.Fedit_5Frule.Fforce:= aRule.Fschedule.Fadd_5Frule.Fforce;
  Self.Fschedule.Fedit_5Frule.Femin:= aRule.Fschedule.Fadd_5Frule.Femin;
end;

constructor THS1x0_Schedule_EditRuleRequest.Create(Rule: THS1x0_Schedule);
begin
  Create;
  Self.Fschedule.Fedit_5Frule.Fid := Rule.Fid;
  Self.Fschedule.Fedit_5Frule.Fstime_opt:= Rule.Fstime_opt;
  for var day in  Rule.Fwday do
    Self.Fschedule.FEdit_5Frule.Fwday.Add(Day);
  Self.Fschedule.Fedit_5Frule.Fsmin := Rule.Fsmin;
  Self.Fschedule.Fedit_5Frule.Fenable:= Rule.Fenable;
  Self.Fschedule.Fedit_5Frule.Frepeat:= Rule.Frepeat;

  Self.Fschedule.Fedit_5Frule.Fetime_opt:= Rule.Fetime_opt;
  Self.Fschedule.Fedit_5Frule.Fname:= Rule.Fname;
  Self.Fschedule.Fedit_5Frule.Feact:= Rule.Feact;
  Self.Fschedule.Fedit_5Frule.Fmonth:= Rule.Fmonth;

  Self.Fschedule.Fedit_5Frule.Fsact:= Rule.Fsact;
  Self.Fschedule.Fedit_5Frule.Fyear:= Rule.Fyear;
  Self.Fschedule.Fedit_5Frule.Flongitude:= Rule.Flongitude;
  Self.Fschedule.Fedit_5Frule.Flatitude:= Rule.Flatitude;

  Self.Fschedule.Fedit_5Frule.Fday:=Rule.Fday;
  Self.Fschedule.Fedit_5Frule.Fforce:=Rule.Fforce;
  Self.Fschedule.Fedit_5Frule.Femin:= Rule.Femin;
end;

function THS1x0.Schedule_EditRule(Rule: THS1x0_Schedule_EditRuleRequest): THS1x0_Schedule_EditRuleResponse;
begin
  Result := Nil;
  var ReqJSON := RequestToJson(Rule);
  if ReqJSON = '' then Exit;
  var ResJSON := DoRequest(ReqJSON);
  if ResJSON = '' then Exit;
  Result := TJsonX.Parser<THS1x0_Schedule_EditRuleResponse>(ResJSON);
end;

function THS1x0.Schedule_DeleteRule(Id: string): THS1x0_Schedule_DeleteRuleResponse;
begin
  Result := nil;
  var ResJSON := DoRequest( Format('{"schedule":{"delete_rule":{"id":"%s"}}}', [Id]));
  if ResJSON = '' then Exit;
  Result := TJsonX.Parser<THS1x0_Schedule_DeleteRuleResponse>(ResJSON);
end;

function THS1x0.Schedule_DeleteAllRules: THS1x0_Schedule_DeleteAllRulesResponse;
begin
  Result := nil;
  var ResJSON := DoRequest('{"schedule":{"delete_all_rules":null}}');
  if ResJSON = '' then Exit;
  Result := TJsonX.Parser<THS1x0_Schedule_DeleteAllRulesResponse>(ResJSON);
end;

{$ENDREGION}

{$REGION 'Countdown Commands'}

function THS1x0.Countdown_GetRulesList: THS1x0_Countdown_GetRulesResponse;
begin
  Result := nil;
  var ResJSON := DoRequest('{"count_down":{"get_rules":null}}');
  if ResJSON = '' then Exit;
  Result := TJsonX.Parser<THS1x0_Countdown_GetRulesResponse>(ResJSON);
end;

constructor THS1x0_Type0146.Create;
begin
  Inherited;
  Self.Fadd_5Frule := THS1x0_Countdown.Create;
end;

constructor THS1x0_Countdown_AddRuleRequest.Create;
begin
  Inherited;
  Self.Fcount_5Fdown := THS1x0_Type0146.Create;
end;

function THS1x0.Countdown_AddRule(Rule: THS1x0_Countdown_AddRuleRequest): THS1x0_Countdown_AddRuleResponse;
begin
  Result := nil;
  var ReqJSON := RequestToJson(Rule);
  if ReqJSON = '' then Exit;
  var ResJSON := DoRequest(ReqJSON);
  if ResJSON = '' then Exit;
  Result :=  TJsonX.Parser<THS1x0_Countdown_AddRuleResponse>(ResJSON);
  if (Result <> nil) and (Result.Fcount_5Fdown.Fadd_5Frule.Ferr_5Fcode = 0) then
    Rule.Fcount_5Fdown.Fadd_5Frule.Fid := Result.Fcount_5Fdown.Fadd_5Frule.Fid;
end;

constructor THS1x0_Type0151.Create;
begin
  Inherited;
  Fedit_5Frule := THS1x0_Countdown.Create;
end;

constructor THS1x0_Countdown_EditRuleRequest.Create;
begin
  Inherited;
  Fcount_5Fdown := THS1x0_Type0151.Create;
end;

constructor THS1x0_Countdown_EditRuleRequest.Create(Countdown: THS1x0_Countdown);
begin
  Create;
  Self.Fcount_5Fdown.Fedit_5Frule.Fid := Countdown.Fid;
  Self.Fcount_5Fdown.Fedit_5Frule.Fenable := Countdown.Fenable;
  Self.Fcount_5Fdown.Fedit_5Frule.Fname := Countdown.Fname;
  Self.Fcount_5Fdown.Fedit_5Frule.Fdelay := Countdown.Fdelay;
  Self.Fcount_5Fdown.Fedit_5Frule.Fact := Countdown.Fact;
  Self.Fcount_5Fdown.Fedit_5Frule.Fremain := Countdown.Fremain;
end;

function  THS1x0.Countdown_EditRule(Rule: THS1x0_Countdown_EditRuleRequest): THS1x0_Countdown_EditRuleResponse;
begin
  Result := Nil;
  var ReqJSON := RequestToJson(Rule);
  if ReqJSON = '' then Exit;
  var ResJSON := DoRequest(ReqJSON);
  if ResJSON = '' then Exit;
  Result := TJsonX.Parser<THS1x0_Countdown_EditRuleResponse>(ResJSON);
end;

function THS1x0.Countdown_DeleteRule(Id: string): THS1x0_Countdown_DeleteRuleResponse;
begin
  Result := nil;
  var ResJSON := DoRequest( Format('{"count_down":{"delete_rule":{"id":"7C90311A1CD3227F25C6001D88F7FC13"}}}', [Id]));
  if ResJSON = '' then Exit;
  Result := TJsonX.Parser<THS1x0_Countdown_DeleteRuleResponse>(ResJSON);
end;

function THS1x0.Countdown_DeleteAllRules: THS1x0_Countdown_DeleteAllRulesResponse;
begin
  Result := nil;
  var ResJSON := DoRequest('{"count_down":{"delete_all_rules":null}}');
  if ResJSON = '' then Exit;
  Result := TJsonX.Parser<THS1x0_Countdown_DeleteAllRulesResponse>(ResJSON);
end;

{$ENDREGION}

{$REGION 'AntiTheft Commands'}

constructor THS1x0_AntiTheft.Create;
begin
  Inherited;
  Self.Fwday := TJsonXVarListType.Create;
end;

function THS1x0.AntiTheft_GetRulesList: THS1x0_AnitTheft_GetRulesResponse;
begin
  Result := nil;
  var ResJSON := DoRequest('{"anti_theft":{"get_rules":null}}');
  if ResJSON = '' then Exit;
  Result := TJsonX.Parser<THS1x0_AnitTheft_GetRulesResponse>(ResJSON);
end;

 constructor THS1x0_Type0158.Create;
 begin
   Inherited;
   Fadd_5Frule := THS1x0_AntiTheft.Create;
 end;

constructor THS1x0_AnitTheft_AddRuleRequest.Create;
begin
  Inherited;
  Fanti_5Ftheft := THS1x0_Type0158.Create;
end;

constructor THS1x0_AnitTheft_AddRuleRequest.Create(AntiTheft: THS1x0_AntiTheft);
begin
  Create;
  Self.Fanti_5Ftheft.Fadd_5Frule.Fname := AntiTheft.Fname;
  Self.Fanti_5Ftheft.Fadd_5Frule.Fenable := AntiTheft.Fenable;
  for var Day in  AntiTheft.Fwday do
    Self.Fanti_5Ftheft.Fadd_5Frule.Fwday.Add(Day);
  Self.Fanti_5Ftheft.Fadd_5Frule.Fstime_opt := AntiTheft.Fstime_opt;
  Self.Fanti_5Ftheft.Fadd_5Frule.Fsoffset := AntiTheft.Fsoffset;
  Self.Fanti_5Ftheft.Fadd_5Frule.Fsmin := AntiTheft.Fsmin;
  Self.Fanti_5Ftheft.Fadd_5Frule.Fetime_opt := AntiTheft.Fetime_opt;
  Self.Fanti_5Ftheft.Fadd_5Frule.Feoffset := AntiTheft.Feoffset;
  Self.Fanti_5Ftheft.Fadd_5Frule.Femin := AntiTheft.Femin;
  Self.Fanti_5Ftheft.Fadd_5Frule.Ffrequency := AntiTheft.Ffrequency;
  Self.Fanti_5Ftheft.Fadd_5Frule.Frepeat := AntiTheft.Frepeat;
  Self.Fanti_5Ftheft.Fadd_5Frule.Fyear := AntiTheft.Fyear;
  Self.Fanti_5Ftheft.Fadd_5Frule.Fmonth := AntiTheft.Fmonth;
  Self.Fanti_5Ftheft.Fadd_5Frule.Fday := AntiTheft.Fday;
  Self.Fanti_5Ftheft.Fadd_5Frule.Fduration := AntiTheft.Fduration;
  Self.Fanti_5Ftheft.Fadd_5Frule.Flastfor := AntiTheft.Flastfor;
  Self.Fanti_5Ftheft.Fadd_5Frule.FLongitude := AntiTheft.FLongitude;
  Self.Fanti_5Ftheft.Fadd_5Frule.Flatitude := AntiTheft.Flatitude;
  Self.Fanti_5Ftheft.Fadd_5Frule.Fforce := AntiTheft.Fforce;
  Self.Fanti_5Ftheft.Fadd_5Frule.FLongitude := AntiTheft.FLongitude;
  Self.Fanti_5Ftheft.Fadd_5Frule.FLatitude := AntiTheft.Flatitude;
  Self.Fanti_5Ftheft.Fadd_5Frule.Fduration := AntiTheft.Fduration;
  Self.Fanti_5Ftheft.Fadd_5Frule.Flastfor := AntiTheft.Flastfor;
end;

function THS1x0.AntiTheft_AddRule(Rule: THS1x0_AnitTheft_AddRuleRequest): THS1x0_AnitTheft_AddRuleResponse;
begin
  Result := Nil;
  var ReqJSON := RequestToJson(Rule);
  if ReqJSON = '' then Exit;
  var ResJSON := DoRequest(ReqJSON);
  if ResJSON = '' then Exit;
  Result := TJsonX.Parser<THS1x0_AnitTheft_AddRuleResponse>(ResJSON);
  if (Result <> nil) and (Result.Fanti_5Ftheft.Fadd_5Frule.Ferr_5Fcode = 0) then
    Rule.Fanti_5Ftheft.Fadd_5Frule.Fid := Result.Fanti_5Ftheft.Fadd_5Frule.Fid;
end;

constructor THS1x0_Type0161.Create;
begin
  Inherited;
  Fedit_5Frule := THS1x0_AntiTheft.Create;
end;

constructor THS1x0_AntiTheft_EditRuleRequest.Create;
begin
  Inherited;
   Fanti_5Ftheft := THS1x0_Type0161.Create;
end;

constructor THS1x0_AntiTheft_EditRuleRequest.Create(AntiTheft: THS1x0_AntiTheft);
begin
  Create;
  Self.Fanti_5Ftheft.Fedit_5Frule.Fid := AntiTheft.Fid;
  Self.Fanti_5Ftheft.Fedit_5Frule.Fname := AntiTheft.Fname;
  Self.Fanti_5Ftheft.Fedit_5Frule.Fenable := AntiTheft.Fenable;
  for var Day in  AntiTheft.Fwday do
    Self.Fanti_5Ftheft.Fedit_5Frule.Fwday.Add(Day);
  Self.Fanti_5Ftheft.Fedit_5Frule.Fstime_opt := AntiTheft.Fstime_opt;
  Self.Fanti_5Ftheft.Fedit_5Frule.Fsoffset := AntiTheft.Fsoffset;
  Self.Fanti_5Ftheft.Fedit_5Frule.Fsmin := AntiTheft.Fsmin;
  Self.Fanti_5Ftheft.Fedit_5Frule.Fetime_opt := AntiTheft.Fetime_opt;
  Self.Fanti_5Ftheft.Fedit_5Frule.Feoffset := AntiTheft.Feoffset;
  Self.Fanti_5Ftheft.Fedit_5Frule.Femin := AntiTheft.Femin;
  Self.Fanti_5Ftheft.Fedit_5Frule.Ffrequency := AntiTheft.Ffrequency;
  Self.Fanti_5Ftheft.Fedit_5Frule.Frepeat := AntiTheft.Frepeat;
  Self.Fanti_5Ftheft.Fedit_5Frule.Fyear := AntiTheft.Fyear;
  Self.Fanti_5Ftheft.Fedit_5Frule.Fmonth := AntiTheft.Fmonth;
  Self.Fanti_5Ftheft.Fedit_5Frule.Fday := AntiTheft.Fday;
  Self.Fanti_5Ftheft.Fedit_5Frule.Fduration := AntiTheft.Fduration;
  Self.Fanti_5Ftheft.Fedit_5Frule.Flastfor := AntiTheft.Flastfor;
  Self.Fanti_5Ftheft.Fedit_5Frule.FLongitude := AntiTheft.FLongitude;
  Self.Fanti_5Ftheft.Fedit_5Frule.Flatitude := AntiTheft.Flatitude;
  Self.Fanti_5Ftheft.Fedit_5Frule.Fforce := AntiTheft.Fforce;
end;

function THS1x0.AntiTheft_EditRule(Rule: THS1x0_AntiTheft_EditRuleRequest): THS1x0_AntiTheft_EditRuleResponse;
begin
  Result := Nil;
  var ReqJSON := RequestToJson(Rule);
  if ReqJSON = '' then Exit;
  var ResJSON := DoRequest(ReqJSON);
  if ResJSON = '' then Exit;
  Result := TJsonX.Parser<THS1x0_AntiTheft_EditRuleResponse>(ResJSON);
end;

function THS1x0.AntiTheft_DeleteRule(Id: string): THS1x0_AntiTheft_DeleteRuleResponse;
begin
  Result := nil;
  var ResJSON := DoRequest( Format('{"anti_theft":{"delete_rule":{"id":"%s"}}}', [Id]));
  if ResJSON = '' then Exit;
  Result := TJsonX.Parser<THS1x0_AntiTheft_DeleteRuleResponse>(ResJSON);
end;

function THS1x0.AntiTheft_DeleteAllRules: THS1x0_AntiTheft_DeleteAllRulesResponse;
begin
  Result := nil;
  var ResJSON := DoRequest('{"anti_theft":{"delete_all_rules":null}}');
  if ResJSON = '' then Exit;
  Result := TJsonX.Parser<THS1x0_AntiTheft_DeleteAllRulesResponse>(ResJSON);
end;

{$ENDREGION}

{$REGION 'Cloud Commands'}

function THS1x0.Cloud_GetInfo: THS1x0_Cloud_GetCloudInfoResponse;
begin
  Result := nil;
  var ResJSON := DoRequest( Format('{"cnCloud":{"get_info":null}}',[]));
  if ResJSON = '' then Exit;
  Result :=  TJsonX.Parser<THS1x0_Cloud_GetCloudInfoResponse>(ResJSON);
end;

function THS1x0.Cloud_GetIntlFwList: THS1x0_Cloud_GetIntlFwListResponse;
begin
  Result := nil;
  var ResJSON := DoRequest( Format('{"cnCloud":{"get_intl_fw_list":{}}}',[]));
  if ResJSON = '' then Exit;
   Result :=  TJsonX.Parser<THS1x0_Cloud_GetIntlFwListResponse>(ResJSON);
end;

function THS1x0.Cloud_SetServerURL(URL: string): Boolean;
begin
  Result := False;
  var ResJSON := DoRequest( Format('{"cnCloud":{"set_server_url":{"server":"%s"}}}',[URL]));
  if ResJSON = '' then Exit;
  var Response :=  TJsonX.Parser<THS1x0_Cloud_SetServerURLResponse>(ResJSON) ;
  if Response <> nil then
  begin
    Result := Response.FcnCloud.Fset_5Fserver_5Furl.Ferr_5Fcode = 0;
    Response.Free;
  end;
end;

function  THS1x0.Cloud_Bind(Username, Password: string): Boolean;
begin
  Result := False;
  var ResJSON := DoRequest( Format('{"cnCloud":{"bind":{"username":"%s", "password":"%s"}}}',[Username, PAssword]));
 var Response :=  TJsonX.Parser<THS1x0_Cloud_BindResponse>(ResJSON);
  if Response <> nil then
  begin
    Result := Response.FcnCloud.Fbind.Ferr_5Fcode = 0;
    Response.Free;
  end;
end;

function  THS1x0.Cloud_Unbind: Boolean;
begin
  Result := False;
  var ResJSON := DoRequest( Format('{"cnCloud":{"unbind":null}}',[]));
 var Response :=  TJsonX.Parser<THS1x0_Cloud_UnbindResponse>(ResJSON);
  if Response <> nil then
  begin
    Result := Response.FcnCloud.Funbind.Ferr_5Fcode = 0;
    Response.Free;
  end;
end;

{$ENDREGION}

{$REGION 'Time Commands'}

  constructor THS1x0_Type086.Create;
  begin
    inherited;
    Self.Fset_5Ftimezone := THS1x0_Type085.Create;
  end;

  constructor THS1x0_System_SetTimezoneRequest.Create;
  begin
    inherited;
    Self.Ftime := THS1x0_Type086.Create;
  end;


  function THS1x0.Time_GetTime: TDateTime;
  begin
    Result := 0;
    var ResJSON := DoRequest('{"time":{"get_time":null}}');
    if ResJSON = '' then Exit;
    var Response := TJsonX.Parser<THS1x0_System_GetTimeResponse>(ResJSON);
    if Response.Ftime.Fget_5Ftime.Ferr_5Fcode = 0 then
      Result := EncodeDateTime(
        Response.Ftime.Fget_5Ftime.Fyear,
        Response.Ftime.Fget_5Ftime.Fmonth,
        Response.Ftime.Fget_5Ftime.Fmday,
        Response.Ftime.Fget_5Ftime.Fhour,
        Response.Ftime.Fget_5Ftime.Fmin,
       Response.Ftime.Fget_5Ftime.Fsec,
        0
      );
    Response.Free;
  end;

  function THS1x0.Time_GetTimezone: Integer;
  begin
    Result := -1;
    var ResJSON := DoRequest('{"time":{"get_timezone":null}}');
    if ResJSON = '' then Exit;
    var Response := TJsonX.Parser<THS1x0_System_GetTimezoneResponse>(ResJSON);
    if Response.Ftime.Fget_5Ftimezone.Ferr_5Fcode= 0 then
      Result := Response.Ftime.Fget_5Ftimezone.Findex;
    Response.Free;
  end;

  function THS1x0.Time_SetTimezone(DateTime: TDateTime; TimeZoneIndex: Integer): Boolean;
  var
    AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: Word;
  begin
    Result := False;
    DecodeDateTime(DateTime, AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond);
    var Request :=  THS1x0_System_SetTimezoneRequest.Create;
    Request.Ftime.Fset_5Ftimezone.Fyear := AYear;
    Request.Ftime.Fset_5Ftimezone.Fmonth := AMonth;
    Request.Ftime.Fset_5Ftimezone.Fmday := ADay;
    Request.Ftime.Fset_5Ftimezone.Fhour := AHour;
    Request.Ftime.Fset_5Ftimezone.Fmin := AMinute;
    Request.Ftime.Fset_5Ftimezone.Fsec := ASecond;
    Request.Ftime.Fset_5Ftimezone.Findex := TimeZoneIndex;
    var ReqJSON := RequestToJson(Request);
    Request.Free;
    var ResJSON := DoRequest(ReqJSON);
    if ResJSON = '' then Exit;
    var Response := TJsonX.Parser<THS1x0_System_SetTimezoneResponse>(ResJSON);
    Result := Response.Ftime.Fset_5Ftimezone.Ferr_5Fcode = 0;
    Response.Free;
  end;

{$ENDREGION}

end.



