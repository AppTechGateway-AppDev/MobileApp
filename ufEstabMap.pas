unit ufEstabMap;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, System.Sensors, FMX.WebBrowser,
  System.Sensors.Components, uBusiObj, FMX.TabControl;

const
  cTabName = 'TabEstabMap';
  cHeaderTitle = 'Company Name';
  cTag = uBusiObj.tnEstabMap;

type
  TfraEstabMap = class(TFrame)
    ToolBar1: TToolBar;
    btnCancel: TSpeedButton;
    lblHeaderTItle: TLabel;
    Layout1: TLayout;
    LocationSensor1: TLocationSensor;
    procedure btnCancelClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure LocationSensor1LocationChanged(Sender: TObject;
      const [Ref] OldLocation, NewLocation: TLocationCoord2D);
//    LocationSensor1: TLocationSensor;
//    WebBrowser1: TWebBrowser;
  private
    { Private declarations }
    FOnCloseTab: ^TProc;
//    FGeocoder: TGeocoder;
    FLat, FLon: double;
//    procedure OnGeocodeReverseEvent(const Address: TCivicAddress);
    procedure AnimateTrans(AAnimateRule: TAnimateRule);
  public
    { Public declarations }
    FWebB: TWebBrowser;
    procedure PopuUI;
    {$IF DEFINED(MSWINDOWS)}
    procedure WindowsTest;
    {$ENDIF}
    procedure ShowMap; //(ALat, ALon: double);
  end;

  TTabOfFrame = class(TTabItem)
  strict private
    FOnNextBtnClick: TProc; //<TObject>;
    FOnCloseTab: TProc; //<TObject>;
{
    FTabItemState: TTabItemState;
    //FOnBackBtnClick: TProc<TObject>;
    //FOnDoneBtnClick: TProc<TObject>; // TProc<TObject, TUpdateMade, integer>;
    FOnAfterSave: TProc<TUpdateMade, integer>;
    FOnAfterDeleted: TProc<TUpdateMade, integer>;
    FCarID: integer;
    FOnUOMPickList: TProc<TEdit>;
    FOnATPickList: TProc<TEdit>;
}
  private
//    FRecID: integer;
  public
    FCallerTab: TTabItem;
    FFrameMain: TfraEstabMap;
    property OnNextBtnClick: TProc read FOnNextBtnClick write FOnNextBtnClick;
    property OnCloseTab: TProc read FOnCloseTab write FOnCloseTab;
    constructor Create(AOwner: TComponent); // supply various params here. AReccordID: integer); // ; AUserRequest: TUserRequest
    destructor Destroy; override;
    procedure CloseTab(AIsRelease: Boolean);
    procedure ShowTab(ACallerTab: TTabItem; ALat, ALon: double; ATitle: string); //; AUserRequest: TUserIntentInit;      ATID, ACarID: integer);
  end;

implementation

{$R *.fmx}

{ TfraEstabMap }

procedure TfraEstabMap.AnimateTrans(AAnimateRule: TAnimateRule);
begin
{
  try
    if AAnimateRule = uBusiObj.TAnimateRule.arInit then
    begin
      Layout1.Align := TAlignLayout.None;
      Layout1.Position.X := Layout1.Width;
    end
    else if AAnimateRule = uBusiObj.TAnimateRule.arIn then
    begin
      //Layout1.Position.X := Layout1.Width;
      Layout1.AnimateFloat('Position.X', 0, 0.3, TAnimationType.InOut, TInterpolationType.Linear);
    end
    else if AAnimateRule = uBusiObj.TAnimateRule.arOut then
    begin
//      Layout1.Position.X := Layout1.Width;
      Layout1.Align := TAlignLayout.None;
      Layout1.AnimateFloat('Position.X', Layout1.Width, 0.2, TAnimationType.Out, TInterpolationType.Linear);
    end;
  finally
    if AAnimateRule = uBusiObj.TAnimateRule.arIn then
      Layout1.Align := TAlignLayout.Client;
  end;
}
  try
    if AAnimateRule = uBusiObj.TAnimateRule.arInitInFromRight then
    begin
      Layout1.Align := TAlignLayout.None;
      Layout1.Position.X := Layout1.Width;
    end
    else if AAnimateRule = uBusiObj.TAnimateRule.arIn then
    begin
      //Layout1.Position.X := Layout1.Width;
      Layout1.AnimateFloat('Position.X', 0, 0.3, TAnimationType.InOut, TInterpolationType.Linear);
    end;
  finally
    if AAnimateRule = uBusiObj.TAnimateRule.arIn then
      Layout1.Align := TAlignLayout.Client;
  end;
end;

procedure TfraEstabMap.btnCancelClick(Sender: TObject);
begin
  AnimateTrans(TAnimateRule.arOut);  // animate the main tab
  TTabOfFrame(Owner).CloseTab(false);
end;

procedure TfraEstabMap.LocationSensor1LocationChanged(Sender: TObject;
  const [Ref] OldLocation, NewLocation: TLocationCoord2D);
var
  URLString: String;
  LSettings: TFormatSettings;
  LDecSeparator : Char;
//  lLat, lLong: Double;
begin

  LDecSeparator := FormatSettings.DecimalSeparator;
  LSettings := FormatSettings;
  try
    FormatSettings.DecimalSeparator := '.';
    // Show current location
    //ListBoxItemLatitude.ItemData.Detail  := Format('%2.6f', [NewLocation.Latitude]);
    //ListBoxItemLongitude.ItemData.Detail := Format('%2.6f', [NewLocation.Longitude]);

    // Show Map using Google Maps
    URLString := Format('https://maps.google.com/maps?q=%2.6f,%2.6f', [ NewLocation.Latitude, NewLocation.Longitude]);
//    URLString := Format('https://maps.google.com/maps?q=%2.6f,%2.6f', [7.064041, 125.387248]); -tungkalan
//    URLString := Format('https://maps.google.com/maps?q=%2.6f,%2.6f', [52.027648, -0.764209]);
  finally
    FormatSettings.DecimalSeparator := LDecSeparator;
  end;
//  if swDispMap.IsChecked then
//  begin
    FWebB.Navigate(URLString);

{
    // Setup an instance of TGeocoder
    try
      if not Assigned(FGeocoder) then
      begin
        if Assigned(TGeocoder.Current) then
          FGeocoder := TGeocoder.Current.Create;
//        if Assigned(FGeocoder) then
//          FGeocoder.OnGeocodeReverse := OnGeocodeReverseEvent;
      end;
    except
//      ListBoxGroupHeader1.Text := 'Geocoder service error.';
    end;

    // Translate location to address
    if Assigned(FGeocoder) and not FGeocoder.Geocoding then
      FGeocoder.GeocodeReverse(NewLocation);
//  end;
}

  // stop the sensor after receiving the gps coordinate.
  LocationSensor1.Active := false;
end;

{
procedure TfraEstabMap.OnGeocodeReverseEvent(const Address: TCivicAddress);
begin
  ListBoxItemAdminArea.ItemData.Detail       := Address.AdminArea;
  ListBoxItemCountryCode.ItemData.Detail     := Address.CountryCode;
  ListBoxItemCountryName.ItemData.Detail     := Address.CountryName;
  ListBoxItemFeatureName.ItemData.Detail     := Address.FeatureName;
  ListBoxItemLocality.ItemData.Detail        := Address.Locality;
  ListBoxItemPostalCode.ItemData.Detail      := Address.PostalCode;
  ListBoxItemSubAdminArea.ItemData.Detail    := Address.SubAdminArea;
  ListBoxItemSubLocality.ItemData.Detail     := Address.SubLocality;
  ListBoxItemSubThoroughfare.ItemData.Detail := Address.SubThoroughfare;
  ListBoxItemThoroughfare.ItemData.Detail    := Address.Thoroughfare;
end;
}

procedure TfraEstabMap.PopuUI;
begin
  FWebB.Parent := Layout1;
  {$IF DEFINED(MSWINDOWS)}
  WindowsTest;
  {$ELSEIF DEFINED(ANDROID) OR DEFINED(IOS) OR DEFINED(MACOS)}
  //LocationSensor1.Active := true;
  ShowMap; //(52.017454, -0.748851);
  {$ENDIF}
end;

procedure TfraEstabMap.ShowMap; //(ALat, ALon: double);
var
  URLString: String;
  LSettings: TFormatSettings;
  LDecSeparator : Char;
//  lLat, lLon: Double;
  lNewLocation: TLocationCoord2D;
begin
//  lLat := 7.064041;  lLon := 125.387248;
  lNewLocation := TLocationCoord2D.Create(FLat, FLon);

  LDecSeparator := FormatSettings.DecimalSeparator;
  LSettings := FormatSettings;
  try
    FormatSettings.DecimalSeparator := '.';
    // Show current location
    //ListBoxItemLatitude.ItemData.Detail  := Format('%2.6f', [NewLocation.Latitude]);
    //ListBoxItemLongitude.ItemData.Detail := Format('%2.6f', [NewLocation.Longitude]);

    // Show Map using Google Maps
//    URLString := Format('https://maps.google.com/maps?q=%2.6f,%2.6f', [ NewLocation.Latitude, NewLocation.Longitude]);
    URLString := Format('https://maps.google.com/maps?q=%2.6f,%2.6f', [lNewLocation.Latitude, lNewLocation.Longitude]);
  finally
    FormatSettings.DecimalSeparator := LDecSeparator;
  end;
//  if swDispMap.IsChecked then
//  begin
    FWebB.Navigate(URLString);

{
    // Setup an instance of TGeocoder
    try
      if not Assigned(FGeocoder) then
      begin
        if Assigned(TGeocoder.Current) then
          FGeocoder := TGeocoder.Current.Create;
//        if Assigned(FGeocoder) then
//          FGeocoder.OnGeocodeReverse := OnGeocodeReverseEvent;
      end;
    except
//      ListBoxGroupHeader1.Text := 'Geocoder service error.';
    end;

    // Translate location to address
    if Assigned(FGeocoder) and not FGeocoder.Geocoding then
      FGeocoder.GeocodeReverse(lNewLocation);
}
//  end;
end;

procedure TfraEstabMap.SpeedButton1Click(Sender: TObject);
begin
end;

{$IF DEFINED(MSWINDOWS)}
procedure TfraEstabMap.WindowsTest;
var
  URLString: String;
  LSettings: TFormatSettings;
  LDecSeparator : Char;
  lLat, lLon: Double;
  lNewLocation: TLocationCoord2D;
begin
  lLat := 7.064041;
  lLon := 125.387248;
  lNewLocation := TLocationCoord2D.Create(lLat, lLon);

  LDecSeparator := FormatSettings.DecimalSeparator;
  LSettings := FormatSettings;
  try
    FormatSettings.DecimalSeparator := '.';
    // Show current location
    //ListBoxItemLatitude.ItemData.Detail  := Format('%2.6f', [NewLocation.Latitude]);
    //ListBoxItemLongitude.ItemData.Detail := Format('%2.6f', [NewLocation.Longitude]);

    // Show Map using Google Maps
//    URLString := Format('https://maps.google.com/maps?q=%2.6f,%2.6f', [ NewLocation.Latitude, NewLocation.Longitude]);
    URLString := Format('https://maps.google.com/maps?q=%2.6f,%2.6f', [lNewLocation.Latitude, lNewLocation.Longitude]);
  finally
    FormatSettings.DecimalSeparator := LDecSeparator;
  end;
//  if swDispMap.IsChecked then
//  begin
    FWebB.Navigate(URLString);

{
    // Setup an instance of TGeocoder
    try
      if not Assigned(FGeocoder) then
      begin
        if Assigned(TGeocoder.Current) then
          FGeocoder := TGeocoder.Current.Create;
//        if Assigned(FGeocoder) then
//          FGeocoder.OnGeocodeReverse := OnGeocodeReverseEvent;
      end;
    except
//      ListBoxGroupHeader1.Text := 'Geocoder service error.';
    end;

    // Translate location to address
    if Assigned(FGeocoder) and not FGeocoder.Geocoding then
      FGeocoder.GeocodeReverse(lNewLocation);
}
//  end;

end;
{$ENDIF}

{ TTabOfFrame }

procedure TTabOfFrame.CloseTab(AIsRelease: Boolean);
begin
  if FFrameMain.LocationSensor1.Active then
    FFrameMain.LocationSensor1.Active := false;
  TTabControl(Self.Owner).ActiveTab := FCallerTab;
  if Assigned(FOnCloseTab) then
    FOnCloseTab();
end;

constructor TTabOfFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Name := cTabName;
  Tag  := Integer(cTag);

  // create main frame
  FFrameMain := TfraEstabMap.Create(Self);
  FFrameMain.Parent := Self;

//  FFrameMain.Layout1.Align := TAlignLayout.None;
  FFrameMain.Tag := Integer(cTag); //uBusiObj.tnUOMUpd);

  // define events
//  FFrameMain.FOnNextBtnClick := @OnNextBtnClick;
  FFrameMain.FOnCloseTab := @OnCloseTab;
  // create browseer

  FFrameMain.FWebB := TWebBrowser.Create(FFrameMain.Layout1);
  //FFrameMain.FWebB.Parent := FFrameMain.Layout1;  -error, moved to popuui instead.
  FFrameMain.FWebB.Align := TAlignLayout.Client;

end;

destructor TTabOfFrame.Destroy;
begin
  FFrameMain.Free;
  inherited;
end;

procedure TTabOfFrame.ShowTab(ACallerTab: TTabItem; ALat, ALon: double; ATitle: string);
begin
  FCallerTab := ACallerTab;
//  FFrameMain.FTID := ATID;
  FFrameMain.FLat := ALat;
  FFrameMain.FLon := ALon;

  FFrameMain.lblHeaderTItle.Text := ATitle;
  FFrameMain.AnimateTrans(TAnimateRule.arInit);
  TTabControl(Self.Owner).ActiveTab := Self;
//  if FTabItemState.UserIntentCurr = uicAdding then
//    FFrameMain.edtDescript.SetFocus;
  FFrameMain.AnimateTrans(TAnimateRule.arIn);

  // update fields
  FFrameMain.lblHeaderTItle.Text := ATitle;
end;

end.
