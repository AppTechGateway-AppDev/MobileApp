unit MainFrm;
{source: http://delphifmandroid.blogspot.com/2014/06/sms.html
}

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, //System.Threading,
  System.IniFiles, FMX.Media, System.IOUtils, FMX.StdCtrls
{$IF DEFINED(ANDROID)}
  ,
   Androidapi.JNI.GraphicsContentViewText, FMX.Helpers.Android, Androidapi.Helpers,
   DW.SMSReceiver.Android, DW.SMSMessage.Types
{$ENDIF}
   ;

const
  CSettingIniFile = 'PhoneLoc.INI';

type
  TAppSetting = record
    LastRingRcvdTimeStamp: string;
  end;
  TRingData = record
    Duration: SmallInt;
    SoundVol: SmallInt;
    RingTimes: Smallint;
    TurnOnLight: boolean;
    PinCode: string;
  end;
  TSplitBody = record
    Ring: string;
    Volume: integer;
  end;
  TfrmMain = class(TForm)
    LogMemo: TMemo;
    MediaPlayer1: TMediaPlayer;
    btnRing: TButton;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    timerGetSMS: TTimer;
    Button3: TButton;
    CameraComponent: TCameraComponent;
    timerFlasher: TTimer;
    timerLightDuration: TTimer;
    procedure btnRingClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure timerGetSMSTimer(Sender: TObject);
    procedure timerFlasherTimer(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure timerLightDurationTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FAppSetting: TAppSetting;
//    FSMSReceiver: TSMSReceiver;
    {$IF DEFINED(ANDROID)}
    procedure MessagesReceivedHandler(Sender: TObject; const AMessages: TSMSMessages);
    procedure ReadSMSInbox;
    {$ENDIF}
    function GetSoundName: string;
    function GetDefaultFilePath: string;
    function GetIniFPath: string;
    function ReadRegisSetting: TAppSetting;
    function SplitBodyTxt(ATxt: string): TSplitBody;
    procedure LogMsg(AMsg: string);
//    procedure ParseSMS(AMsg: string; out NewForm: TStrings); //: TString; // TList<string>;
//    function ParseSMS(AMsg: string): TStrings; // TList<string>;
    procedure TurnFlashLight(AYes: Boolean);
    procedure ActivateFlashLight;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

{ TfrmMain }

procedure TfrmMain.ActivateFlashLight;
begin
  timerLightDuration.Enabled := true;     // will be terminated when OntimerLightDuration is called
  timerFlasher.Enabled := true;           // will be terminated when OntimerLightDuration is called
end;

procedure TfrmMain.btnRingClick(Sender: TObject);
begin
  MediaPlayer1.FileName := GetSoundName;
  MediaPlayer1.Play;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  TThread.CreateAnonymousThread(
    procedure
    begin
//showmessage('threading now');
      {$IF DEFINED(ANDROID)}
      ReadSMSInbox;
      {$ENDIF}
    end).Start;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
  LogMemo.Lines.clear;
  LogMemo.Lines.Add('GetIniFPath = '+ GetIniFPath);
  LogMemo.Lines.Add(GetIniFPath.Substring(1, 3) );
end;

procedure TfrmMain.Button3Click(Sender: TObject);
begin
//  TurnFlashLight( CameraComponent.TorchMode = TTorchMode.ModeOff );
//  Timer2.Enabled := not Timer2.Enabled;
  if CameraComponent.HasTorch then
    ActivateFlashLight
  else
    showmessage('No torch detected.');
end;

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited;
{
  FSMSReceiver := TSMSReceiver.Create;
  FSMSReceiver.OnMessagesReceived := MessagesReceivedHandler;
}
end;

destructor TfrmMain.Destroy;
begin
//  FSMSReceiver.Free;
  inherited;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  MediaPlayer1.FileName := GetSoundName;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  FAppSetting := ReadRegisSetting;
//  btnRing.Visible := false;
//  LogMemo.Visible := false;
end;

function TfrmMain.GetDefaultFilePath: string;
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

function TfrmMain.GetIniFPath: string;
begin
  Result := TPath.Combine(GetDefaultFilePath, CSettingIniFile);
end;

function TfrmMain.GetSoundName: string;
begin
  //Result := TPath.Combine(GetDefaultFilePath, 'telephone-ring-01a.mp3');
  //Result := TPath.Combine(GetDefaultFilePath, 'phone-off-hook-1.mp3');
  Result := TPath.Combine(GetDefaultFilePath, 'Siren_Noise-KevanGC-1337458893_Plus2db.mp3');



{$IFDEF IOSxxxx }
  Result := 'myiOSSound.caf';
{$ENDIF}
{$IFDEF ANDROIDxxxx}
//  Result := TPath.Combine(TPath.GetSharedDocumentsPath, 'telephone-ring-01a.mp3');
{$ENDIF}
{$IFDEF WINDOWSxxxx}
  Result := 'telephone-ring-01a.mp3';
{$ENDIF}
end;

procedure TfrmMain.LogMsg(AMsg: string);
begin
//  LogMemo.Lines.Add(AMsg);
end;

{$IF DEFINED(ANDROID)}
procedure TfrmMain.MessagesReceivedHandler(Sender: TObject; const AMessages: TSMSMessages);
var
  I: Integer;
begin
{
  for I := 0 to Length(AMessages) - 1 do
  begin
    LogMsg('Message from: ' + AMessages[I].OriginatingAddress);
    LogMsg(AMessages[I].MessageBody);
  end;
}


  for I := 0 to Length(AMessages) - 1 do
  begin
    if UpperCase(AMessages[I].MessageBody.Trim) = 'RING' then
    begin
      LogMsg('Message from: ' + AMessages[I].OriginatingAddress);
      LogMsg(AMessages[I].MessageBody);

//      MediaPlayer1.FileName := GetSoundName;
//      MediaPlayer1.Play;
    end;
  end;
end;
{$ENDIF}


function TfrmMain.ReadRegisSetting: TAppSetting;
var
  LIni: TIniFile;
begin
//  {$IF DEFINED(TESTING)}
//  {$IF DEFINED(MSWINDOWS) AND DEFINED(CODEGENERATION_2)}
//  SHOWMESSAGE('TTTT');
//  {$ENDIF}
//  {$ELSEIF DEFINED(MSWINDOWS)}
    LIni := TIniFile.Create(GetIniFPath);  // uses Forms
    try
      Result.LastRingRcvdTimeStamp := LIni.ReadString('Ring', 'LastRingRcvdTimeStamp', '');

{
      Result.RegKey := LIni.ReadString('Registration', 'RegKey', '');
      Result.RegUserName := LIni.ReadString('Registration', 'RegUserName', '*UNKNOWN*');
      if Result.RegUserName.IsEmpty then
        Result.RegUserName := '*UNKNOWN*';
      Result.IsDeviceIDRegistered := LIni.ReadBool('Registration', 'IsDeviceIDRegistered', false);
}
    finally
      LIni.Free;
    end;
  LogMsg('aaaa Result.LastRingRcvdTimeStamp = '+ Result.LastRingRcvdTimeStamp);
//  {$ENDIF}
end;

{$IF DEFINED(ANDROID)}
procedure TfrmMain.ReadSMSInbox;
var
  cursor: JCursor;
//  catalog, SMSListBoxItem: TListBoxItem;
  lBody, lDate: string;
  LIni: TIniFile;
  lSplit: TSplitBody;
  lMaxSMSLismit: integer;
//  LActive: Boolean;
begin
  try
    cursor := SharedActivity.getContentResolver.query(
     StrToJURI('content://sms/inbox'),
      nil,
       nil,
        nil,
         nil);

    if(cursor.getCount > 0) then
    begin
      lMaxSMSLismit := 0;
      while (cursor.moveToNext) do      // limit the loop up to max 20
      begin
        inc(lMaxSMSLismit);

        LogMsg(
          JStringToString(cursor.getString(
            cursor.getColumnIndex(StringToJString('ADDRESS')))) +' '+
          JStringToString(cursor.getString(
            cursor.getColumnIndex(StringToJString('BODY'))))  +' '+
          JStringToString(cursor.getString(
            cursor.getColumnIndex(StringToJString('READ')))) +' '+    //0-UNREAD, 1-read
          JStringToString(cursor.getString(
            cursor.getColumnIndex(StringToJString('DATE'))))
          );

        lBody := JStringToString(cursor.getString(
            cursor.getColumnIndex(StringToJString('BODY'))));
        lDate := trim( JStringToString(cursor.getString(
            cursor.getColumnIndex(StringToJString('DATE'))))
                    );

lSplit := SplitBodyTxt(lBody);
LogMsg('lSplit.Ring = ' + lSplit.Ring );
LogMsg('lSplit.Volume = ' + lSplit.Volume.ToString );

        if (lSplit.Ring = 'RING') and // if (UpperCase(lBody.Trim) = 'RING') and
            (lDate > FAppSetting.LastRingRcvdTimeStamp) then
//            (JStringToString(cursor.getString(cursor.getColumnIndex(StringToJString('READ')))) = '0') then
        begin
          LogMsg('aaaa Found it: ' + lBody + lDate +' = '+ FAppSetting.LastRingRcvdTimeStamp );
          // save new timestamp
          FAppSetting.LastRingRcvdTimeStamp := lDate;
          LIni := TIniFile.Create(GetIniFPath);
          try
            LIni.WriteString('Ring', 'LastRingRcvdTimeStamp', lDate.Trim);
          finally
            lini.Free;
          end;
{
          // Turn on the Torch, if supported
          if CameraComponent.HasTorch then
          begin
            LActive := CameraComponent.Active;
            CameraComponent.Active := False;
            CameraComponent.TorchMode := TTorchMode.ModeOn;
            CameraComponent.Active := LActive;
          end;
}

          ActivateFlashLight;     // turn on light

          MediaPlayer1.Volume := lSplit.Volume / 100;
//LogMsg('MediaPlayer1.Volume = ' + MediaPlayer1.Volume.ToString);
          MediaPlayer1.Play;

{
          Sleep(5000);
          MediaPlayer1.Play;
          Sleep(5000);
          MediaPlayer1.Play;
}
{
          if CameraComponent.HasTorch then
          begin
            LActive := CameraComponent.Active;
            try
              CameraComponent.Active := False;
              CameraComponent.TorchMode := TTorchMode.ModeOff;
            finally
              CameraComponent.Active := LActive;
            end;
          end;
}
          exit;
        end
        else if (lSplit.Ring = 'RING') then    //old ringer request
        begin
          exit;
        end
        else if lMaxSMSLismit > 20 then
        begin
          exit;
        end;;
//        SMSListBoxItem := TListBoxItem.Create(ListBox2);
//        SMSListBoxItem.ItemData.Text := JStringToString(cursor.getString(
//        cursor.getColumnIndex(StringToJString('ADDRESS'))));

//        ListBox2.AddObject(SMSListBoxItem);

      end;
    end;


  finally
    cursor.close;
//    ListBox2.EndUpdate;
  end;
{
  catalog := TListBoxItem(Sender);
  ListBox2.Clear;
  ListBox2.BeginUpdate;
  try
    cursor := SharedActivity.getContentResolver.query(
     StrToJURI(catalog.ItemData.Detail),
      nil,
       nil,
        nil,
         nil);

    if(cursor.getCount > 0) then
    begin

      while (cursor.moveToNext) do
      begin

        SMSListBoxItem := TListBoxItem.Create(ListBox2);

        SMSListBoxItem.ItemData.Text := JStringToString(cursor.getString(
        cursor.getColumnIndex(StringToJString('ADDRESS'))));

        ListBox2.AddObject(SMSListBoxItem);

      end;
    end;


  finally
    cursor.close;
    ListBox2.EndUpdate;
  end;

  TabControl1.ActiveTab := TabItem2;
}

end;
{$ENDIF}

function TfrmMain.SplitBodyTxt(ATxt: string): TSplitBody;
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

procedure TfrmMain.timerGetSMSTimer(Sender: TObject);
begin
  LogMemo.Lines.Clear;
  LogMsg('Iimer event');

  TThread.CreateAnonymousThread(
    procedure
    begin
      timerGetSMS.Enabled := false;
      try
        {$IF DEFINED(ANDROID)}
        ReadSMSInbox;
        {$ENDIF}
      finally
        timerGetSMS.Enabled := true;
      end;
    end).Start;
end;

procedure TfrmMain.timerFlasherTimer(Sender: TObject);
begin
//  TurnFlashLight(false);
  TurnFlashLight( CameraComponent.TorchMode = TTorchMode.ModeOff );
end;

procedure TfrmMain.timerLightDurationTimer(Sender: TObject);
begin
  TurnFlashLight(false);
  timerFlasher.Enabled := false;
  timerLightDuration.Enabled := false;
  LogMsg('timerLightDuration.Enabled := false');
end;

procedure TfrmMain.TurnFlashLight(AYes: Boolean);
var
  lActive: Boolean;
begin
  if AYes then
  begin
    // Turn on the Torch, if supported
    if CameraComponent.HasTorch then
    begin
//      if CameraComponent.TorchMode <> TTorchMode.ModeOn then
//      begin
        lActive := CameraComponent.Active;
        CameraComponent.Active := False;
        CameraComponent.TorchMode := TTorchMode.ModeOn;
        CameraComponent.Active := lActive;
//      end;
    end;
  end
  else
  begin
    if CameraComponent.HasTorch then
    begin
//      if CameraComponent.TorchMode <> TTorchMode.ModeOff then
//      begin
        LActive := CameraComponent.Active;
        try
          CameraComponent.Active := False;
          CameraComponent.TorchMode := TTorchMode.ModeOff;
        finally
          CameraComponent.Active := lActive;
        end;
//      end;
    end;

  end;
end;

//i just thought a blinking light makes your phone easy to spot among hundreds of others.
end.
