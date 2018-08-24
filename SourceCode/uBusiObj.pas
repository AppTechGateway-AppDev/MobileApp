unit uBusiObj;

interface

uses
  System.SysUtils, System.IniFiles, System.IOUtils;

const
  cTab = #9;
  cEnter = #13#10;
  cSettingIniFile = 'AppTechSetting.INI';

type
  TTabName = (tnMainTab, tnAbout, tnTest, tnQMultiSele, tnYesNo, tnEstabList,
    tnEstabMenu, tnEstabMap, tnEstabComp, tnUserRegis, tnSignIn, tnIntro);
  TAnimateRule = (arIn, arOut, arInit,
    arInFromLeft, arInFromRight, arInitInFromLeft, arInitInFromRight,
    arOutToLeft, arOutToRight, arInitOutToLeft, arInitOutToRight);
  TAppSettings = record
    IsShowIntro: boolean;
    RegisID: integer;    // based on Leo's result after successful registration.
    Email: string;
    FullName: string;
    ShortName: string;
    Password: string;
    RingPIN: string;
    LastRingRcvdTimeStamp: string;
  end;

  TLoca = record
    Lat: double;
    Lon: Double;
  end;
  TSplitBody = record
    Ring: string;
    Volume: integer;
  end;

{
  TLocat = TObject;
    public
      FLat: double;
      FLon: double;
  end;

{
  TLocat = record
    Lat: Double;
    Lon: Double;
  end;
}

  function GetDefaultFilePath: string;
  function GetIniFullFileName: string;
  function LoadAppSettings: TAppSettings;
  function GetAppPath: string;
  function SplitBodyTxt(ATxt: string): TSplitBody;

implementation

function GetDefaultFilePath: string;
{$IF DEFINED(MSWINDOWS)}
var
  lAppPath: string;
{$ENDIF}
begin
  {$IF DEFINED(MSWINDOWS)}  //  {$IfDef MSWINDOWS}
  lAppPath := ParamStr(0);
  Result := ExtractFilepath(lAppPath);
  {$ELSEIF DEFINED(ANDROID) OR DEFINED(IOS) OR DEFINED(MACOS)}
  Result := TPath.GetDocumentsPath; //GetSharedDocumentsPath;
  {$ENDIF}
end;

function GetIniFullFileName: string;
begin
  {$IF DEFINED(MSWINDOWS)}  //  {$IfDef MSWINDOWS}
  Result := GetAppPath;
  {$ELSEIF DEFINED(ANDROID) OR DEFINED(IOS) OR DEFINED(MACOS)} //  {$EndIf}  {$IfDef ANDROID}
  Result := TPath.GetDocumentsPath; //GetSharedDocumentsPath; //.GetHomePath;  //sample from my samsung: /data/data/com.embarcadero.Keto/files/
//  {$ELSEIF DEFINED(IOS) OR DEFINED(MACOS)} //   {$EndIf}
//    Result := TPath.GetDocumentsPath; //GetSharedDocumentsPath; //.GetHomePath;  //sample from my samsung: /data/data/com.embarcadero.Keto/files/
  {$ENDIF}
//showmessage('Path = '+ Result);
  Result := TPath.Combine(Result, CSettingIniFile);
//showmessage('Full Filename = '+ Result);

{
Result:
  GetSharedDocumentsPath =  /storage/emulated/0/Documents/DIC.INI
  GetDocumentsPath =        /data/data/com.embarcadero.Keto/files/DIC.INI
}
end;

function LoadAppSettings: TAppSettings;
var
  lIniFile: TIniFile;
begin
  lIniFile := TIniFile.Create(GetIniFullFileName);  // uses Forms
  try
    Result.IsShowIntro := lIniFile.ReadBool('Regis', 'IsShowIntro', true);
    Result.RegisID := lIniFile.ReadInteger('Regis', 'RegisID', -1);      // from Leo's API.
    Result.Password := lIniFile.ReadString('Regis', 'Password', '');
    Result.FullName := lIniFile.ReadString('Regis', 'FullName', '');
    Result.ShortName := lIniFile.ReadString('Regis', 'ShortName', '');
    Result.Email := lIniFile.ReadString('Regis', 'Email', '');
    Result.RingPIN := lIniFile.ReadString('Ringer', 'RingPIN', '');
    Result.LastRingRcvdTimeStamp := lIniFile.ReadString('Ringer', 'LastRingRcvdTimeStamp', '');
  finally
    lIniFile.Free;
  end;
end;

function GetAppPath: string;
var
  lFPath: string;
begin
  lFPath := ParamStr(0);
  Result := ExtractFilepath(lFPath);
end;

function SplitBodyTxt(ATxt: string): TSplitBody;
// format: RING100, RING 100, RING50, RING 50
var
  lTxt: string;
  lSubRing, lSubVol : string;
  lVol: integer;
begin
  Result.Ring := '';
  Result.Volume := 0;
  if ATxt.IsEmpty then
    exit;
  lTxt := UpperCase(ATxt.Trim);
  if lTxt.Substring(0, 4) = 'RING' then
  begin
    lSubVol := lTxt.Substring(4, 4);
    if not TryStrToInt(lSubVol, lVol) then
      lVol := 100;
    if lVol < 1 then
      lVol := 50;
    Result.Ring := 'RING';
    Result.Volume := lVol;
  end;

end;

end.
