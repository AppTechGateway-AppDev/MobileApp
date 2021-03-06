unit DW.MultiReceiver.Android;

{*******************************************************}
{                                                       }
{                    Kastri Free                        }
{                                                       }
{          DelphiWorlds Cross-Platform Library          }
{                                                       }
{*******************************************************}

{$I DW.GlobalDefines.inc}

interface

uses
  // Android
  Androidapi.JNIBridge, Androidapi.JNI.JavaTypes, Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.Embarcadero;

type
  TMultiReceiver = class;

  TMultiReceiverListener = class(TJavaLocal, JFMXBroadcastReceiverListener)
  private
    FMultiReceiver: TMultiReceiver;
  public
    { JFMXBroadcastReceiverListener }
    procedure onReceive(context: JContext; intent: JIntent); cdecl;
  public
    constructor Create(const AMultiReceiver: TMultiReceiver);
  end;

  TMultiReceiver = class(TObject)
  private
    FBroadcastReceiver: JFMXBroadcastReceiver;
    FIntentFilter: JIntentFilter;
    FReceiverListener: TMultiReceiverListener;
  protected
    procedure Receive(context: JContext; intent: JIntent); virtual; abstract;
    procedure ConfigureActions; virtual; abstract;
    property IntentFilter: JIntentFilter read FIntentFilter;
  public
    constructor Create;
  end;

implementation

uses
  // Android
  Androidapi.Helpers;

{ TMultiReceiverListener }

constructor TMultiReceiverListener.Create(const AMultiReceiver: TMultiReceiver);
begin
  inherited Create;
  FMultiReceiver := AMultiReceiver;
end;

procedure TMultiReceiverListener.onReceive(context: JContext; intent: JIntent);
begin
  FMultiReceiver.Receive(context, intent);
end;

{ TMultiReceiver }

constructor TMultiReceiver.Create;
begin
  inherited;
  FReceiverListener := TMultiReceiverListener.Create(Self);
  FBroadcastReceiver := TJFMXBroadcastReceiver.JavaClass.init(FReceiverListener);
  FIntentFilter := TJIntentFilter.JavaClass.init;
  ConfigureActions;
  TAndroidHelper.Context.registerReceiver(FBroadcastReceiver, FIntentFilter);
end;

end.
