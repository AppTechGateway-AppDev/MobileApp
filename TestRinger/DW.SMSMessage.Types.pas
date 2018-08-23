unit DW.SMSMessage.Types;

{*******************************************************}
{                                                       }
{                    Kastri Free                        }
{                                                       }
{          DelphiWorlds Cross-Platform Library          }
{                                                       }
{*******************************************************}

{$I DW.GlobalDefines.inc}

interface

type
  TSMSMessage = record
    OriginatingAddress: string;
    MessageBody: string;
  end;

  TSMSMessages = TArray<TSMSMessage>;

  TSMSMessagesEvent = procedure(Sender: TObject; const Messages: TSMSMessages) of object;

implementation

end.
