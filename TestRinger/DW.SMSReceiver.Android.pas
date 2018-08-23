unit DW.SMSReceiver.Android;

interface

uses
  Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.Provider, Androidapi.JNI.Telephony,
  DW.MultiReceiver.Android, DW.SMSMessage.Types;

type
  TSMSReceiver = class(TMultiReceiver)
  private
    FOnMessagesReceived: TSMSMessagesEvent;
    procedure DoMessagesReceived(const AMessages: TSMSMessages);
  protected
    procedure Receive(context: JContext; intent: JIntent); override;
    procedure ConfigureActions; override;
  public
    property OnMessagesReceived: TSMSMessagesEvent read FOnMessagesReceived write FOnMessagesReceived;
  end;

implementation

uses
  Androidapi.JNIBridge, Androidapi.JNI.JavaTypes, Androidapi.JNI.Os, Androidapi.Helpers;

{ TSMSReceiver }

procedure TSMSReceiver.ConfigureActions;
begin
  IntentFilter.addAction(TJSms_Intents.JavaClass.SMS_RECEIVED_ACTION);
end;

procedure TSMSReceiver.DoMessagesReceived(const AMessages: TSMSMessages);
begin
  if Assigned(FOnMessagesReceived) and (Length(AMessages) > 0) then
    FOnMessagesReceived(Self, AMessages);
end;

procedure TSMSReceiver.Receive(context: JContext; intent: JIntent);
var
  LJSmsMessages: TJavaObjectArray<JSmsMessage>;
  LSMSMessages: TSMSMessages;
  I: Integer;
begin
  LJSmsMessages := TJSms_Intents.JavaClass.getMessagesFromIntent(intent);
  SetLength(LSMSMessages, LJSmsMessages.Length);
  for I := 0 to LJSmsMessages.Length - 1 do
  begin
    LSMSMessages[I].OriginatingAddress := JStringToString(LJSmsMessages[I].getOriginatingAddress);
    LSMSMessages[I].MessageBody := JStringToString(LJSmsMessages[I].getMessageBody);
  end;
  DoMessagesReceived(LSMSMessages);
end;

end.
