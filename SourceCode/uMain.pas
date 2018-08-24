unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.StdCtrls, FMX.Controls.Presentation, ksTypes, ksSpeedButton, FMX.ScrollBox,
  FMX.Memo, FMX.MultiView, FMX.TabControl, JsonDataObjects, //System.IOUtils,
  FMX.Ani, uBusiObj, FMX.ListBox, FMX.WebBrowser, System.Math, FMX.Objects,
  System.IOUtils, System.ImageList, FMX.ImgList, System.IniFiles, FMX.Media
{$IF DEFINED(ANDROID)}
  ,
   Androidapi.JNI.GraphicsContentViewText, FMX.Helpers.Android, Androidapi.Helpers,
   DW.SMSReceiver.Android, DW.SMSMessage.Types
{$ENDIF}
   ;

  //, ksTileMenu;  --receive error before remarking is 'file empty'??

type
  TfMain = class(TForm)
    VertScrollBox1: TVertScrollBox;
    ToolBar1: TToolBar;
    lblMainTitle: TLabel;
    loMain: TLayout;
    StyleBook1: TStyleBook;
    Label2: TLabel;
    Label3: TLabel;
    btnSignInMain: TButton;
    TabControl1: TTabControl;
    tabiMain: TTabItem;
    btnMainMenu: TSpeedButton;
    mvMain: TMultiView;
    btnAbout: TksSpeedButton;
    btnFindMyPhone: TksSpeedButton;
    btnFeedback: TksSpeedButton;
    btnSurvey: TksSpeedButton;
    Layout1XX: TLayout;
    TabItem1: TTabItem;
    SpeedButton1: TSpeedButton;
    Memo1: TMemo;
    FloatAnimation1: TFloatAnimation;
    FloatAnimation2: TFloatAnimation;
    ComboBox1: TComboBox;
    Image1: TImage;
    btnSignUp: TButton;
    Layout2: TLayout;
    TabItem2: TTabItem;
    FlowLayout1: TFlowLayout;
    Layout1: TLayout;
    Image2: TImage;
    Rectangle1: TRectangle;
    Label1: TLabel;
    Image3: TImage;
    ImageList1: TImageList;
    btnIntro: TSpeedButton;
    btnSOS: TSpeedButton;
    btnEstabList: TSpeedButton;
    btnUserRegis: TSpeedButton;
    btnSignIn: TSpeedButton;
    btnSignOut: TSpeedButton;
    Label4: TLabel;
    timerGetSMS: TTimer;
    Button1: TButton;
    Button2: TButton;
    timerFlasher: TTimer;
    timerLightDuration: TTimer;
    Button3: TButton;
    CameraComponent: TCameraComponent;
    MediaPlayer1: TMediaPlayer;
    procedure btnSignInMainClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FloatAnimation2Finish(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const [Ref] Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const [Ref] Bounds: TRect);
    procedure VertScrollBox1CalcContentBounds(Sender: TObject;
      var ContentBounds: TRectF);
    procedure btnSignUpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Rectangle1Click(Sender: TObject);
    procedure Layout1Click(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure btnEstabListClick(Sender: TObject);
    procedure btnUserRegisClick(Sender: TObject);
    procedure btnSignInClick(Sender: TObject);
    procedure btnIntroClick(Sender: TObject);
    procedure btnSignOutClick(Sender: TObject);
//    procedure Button1Click(Sender: TObject);
    procedure timerGetSMSTimer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure timerLightDurationTimer(Sender: TObject);
    procedure timerFlasherTimer(Sender: TObject);
  private
    { Private declarations }
    FKBBounds: TRectF;                  // for Vert scroll box
    FNeedOffset: Boolean;               // for Vert scroll box
    FAppSettings: TAppSettings;
    function CreateTabQMultiSele: TTabItem;
    function CreateTabQYesNo: TTabItem;
    function CreateTabEstabList: TTabItem;
    function CreateEstabMenu: TTabItem;
    function CreateEstabMap: TTabItem;
    function CreateEstabComp: TTabItem;
    function CreateUserRegis: TTabItem;
    function CreateSignIn: TTabItem;
    function CreateIntro: TTabItem;
    function CreateAbout: TTabItem;
    procedure TestListAllQues(AJSONObj: TJSONObject);
    procedure TestListAllQues2(AJSONObj: TJSONObject);
    procedure ReadJSON;
    procedure ReadJSON2;
    procedure AnimateTrans(AAnimateRule: TAnimateRule);
    procedure TestAnimate;
    procedure RestorePosition;          // for Vert scroll box
    procedure UpdateKBBounds;           // for Vert scroll box
    procedure ShowUserRegis;
    procedure ShowIntro;
    procedure ShowEstabList;
    procedure LogMsg(AMsg: string);
    {$IF DEFINED(ANDROID)}
    //procedure MessagesReceivedHandler(Sender: TObject; const AMessages: TSMSMessages);
    procedure ReadSMSInbox;
    {$ENDIF}
    procedure ActivateFlashLight;
    procedure TurnFlashLight(AYes: Boolean);
    procedure PlaySound(AVolume: SmallInt);
    function GetSoundName: string;
  public
    { Public declarations }
//    procedure AnimateTrans(AAnimateType: TAnimationType);
  end;

var
  fMain: TfMain;

implementation

{$R *.fmx}

uses ufQMultSele, ufQYesNo, ufEstabList, ufEstabMenu, ufEstabMap, ufEstabComp,
  ufUserRegis, ufSignIn, ufIntro, ufAbout;

{ TfMain }

{
procedure TfMain.AnimateTrans(AAnimateType: TAnimationType);
var
  lOrgWidth: Extended;
begin
// i dont' understand TAnimationType.InOut???

  Layout1.Align := TAlignLayout.None;
  try
    if AAnimateType = TAnimationType.In then
    begin
      lOrgWidth := Layout1.Width;
      Layout1.Position.X := -lOrgWidth;
      Layout1.AnimateFloat('Position.X', 0, 0.2, TAnimationType.In, TInterpolationType.Linear);
    end
    else if AAnimateType = TAnimationType.Out then
    begin
//      Layout1.AnimateFloat('Position.X', Layout1.Width, 0.2, TAnimationType.Out, TInterpolationType.Linear);
    end;
  finally
    if AAnimateType = TAnimationType.In then
      Layout1.Align := TAlignLayout.Client;
  end;
end;
}

procedure TfMain.ActivateFlashLight;
begin
  TThread.Synchronize(nil,
    procedure
    begin
      timerLightDuration.Enabled := true;     // will be terminated when OntimerLightDuration is called
      timerFlasher.Enabled := true;           // will be terminated when OntimerLightDuration is called
    end
    );
end;

procedure TfMain.AnimateTrans(AAnimateRule: TAnimateRule);
//var   lOrgWidth: Extended;
begin
// i dont' understand TAnimationType.InOut???
{

  //Layout1.Align := TAlignLayout.None;
  try
    if AAnimateRule = uBusiObj.TAnimateRule.arInit then
    begin
      Layout1.Align := TAlignLayout.None;
      Layout1.Position.X := -Layout1.Width;
    end
    else if AAnimateRule = TAnimateRule.arIn then
    begin
      //lOrgWidth := Layout1.Width;
      //Layout1.Position.X := -Layout1.Width;
      Layout1.AnimateFloat('Position.X', 0, 0.2, TAnimationType.In, TInterpolationType.Linear);
      Application.ProcessMessages;
    end
    else if AAnimateRule = TAnimateRule.arOut then
    begin
//      Layout1.AnimateFloat('Position.X', Layout1.Width, 0.2, TAnimationType.Out, TInterpolationType.Linear);
    end;
  finally
    if AAnimateRule = TAnimateRule.arIn then
      Layout1.Align := TAlignLayout.Client;
  end;
}
end;

procedure TfMain.btnSignInClick(Sender: TObject);
//------ this should be consolidated with btnSignInMainClick -------
var
  lTabItem: ufSignIn.TTabOfFrame;
begin
  mvMain.HideMaster; // .Visible := false;
  lTabItem := ufSignIn.TTabOfFrame(CreateSignIn);
  lTabItem.ShowTab(TabControl1.ActiveTab);
//  lTabItem.FFrameMain.PopuUI;
//  lTabItem.FFrameHdr.PopuUI(lTabItem.GetCarID);

//  AnimateTrans(TAnimationType.In);
//  AnimateTrans(TAnimateRule.arInit); - shoule be fMain.Animate ???
end;

procedure TfMain.btnSignInMainClick(Sender: TObject);
//------ this should be consolidated with btnSignInMainClick -------
var
  lTabItem: ufSignIn.TTabOfFrame;
begin
  mvMain.HideMaster; // .Visible := false;
  lTabItem := ufSignIn.TTabOfFrame(CreateSignIn);
  lTabItem.ShowTab(TabControl1.ActiveTab);
//  lTabItem.FFrameMain.PopuUI;
//  lTabItem.FFrameHdr.PopuUI(lTabItem.GetCarID);

//  AnimateTrans(TAnimationType.In);
//  AnimateTrans(TAnimateRule.arInit); - shoule be fMain.Animate ???
{
var
  lTabItem: ufQMultSele.TTabOfFrame;
begin
  lTabItem := ufQMultSele.TTabOfFrame(CreateTabQMultiSele);
  lTabItem.ShowTab(TabControl1.ActiveTab); //, uiiAdd, -1, lTabItem.GetCarID);
  lTabItem.FFrameMain.PopuUI;
//  lTabItem.FFrameHdr.PopuUI(lTabItem.GetCarID);

//  AnimateTrans(TAnimationType.In);
  AnimateTrans(TAnimateRule.arInit);
}
end;

procedure TfMain.btnSignOutClick(Sender: TObject);
begin
  ShowMessage('You are now signed out.');
end;

function TfMain.CreateAbout: TTabItem;
var
  lTabItem: ufAbout.TTabOfFrame;
begin
  // get the needed tab if any or create tab if one doesn't exist
  lTabItem := ufAbout.TTabOfFrame(Self.TabControl1.FindComponent(ufAbout.cTabName));

  if lTabItem = nil then
  begin
    lTabItem := ufAbout.TTabOfFrame.Create(Self.TabControl1);
    lTabItem.Parent := Self.TabControl1;

    // set up events
    lTabItem.OnCloseTab :=
      procedure
      begin
        fMain.AnimateTrans(TAnimateRule.arIn);  // animate the MAIN tab
      end;
 {
    lTabItem.OnSubmit :=
      procedure()
      var
        lSubTabItem: ufEstabMap.TTabOfFrame;
      begin
        lSubTabItem := ufEstabMap.TTabOfFrame(CreateEstabMap);
        lSubTabItem.ShowTab(TabControl1.ActiveTab, lTabItem.FFrameMain.lblName.Text);
        lSubTabItem.FFrameMain.PopuUI;
        AnimateTrans(TAnimateRule.arInit);
      end;
 }


    //- populate fields
//    lTabItem.FFrameMain.PopuUIx;
  end;
  Result := lTabItem;
end;

function TfMain.CreateEstabComp: TTabItem;
var
  lTabItem: ufEstabComp.TTabOfFrame;
begin
  // get the needed tab if any or create tab if one doesn't exist
  lTabItem := ufEstabComp.TTabOfFrame(Self.TabControl1.FindComponent(ufEstabComp.cTabName));

  if lTabItem = nil then
  begin
    lTabItem := ufEstabComp.TTabOfFrame.Create(Self.TabControl1);
    lTabItem.Parent := Self.TabControl1;

    // set up events
    lTabItem.OnCloseTab :=
      procedure
      begin
        AnimateTrans(TAnimateRule.arIn);  // animate the MAIN tab
      end;
 {
    lTabItem.OnSubmit :=
      procedure()
      var
        lSubTabItem: ufEstabMap.TTabOfFrame;
      begin
        lSubTabItem := ufEstabMap.TTabOfFrame(CreateEstabMap);
        lSubTabItem.ShowTab(TabControl1.ActiveTab, lTabItem.FFrameMain.lblName.Text);
        lSubTabItem.FFrameMain.PopuUI;
        AnimateTrans(TAnimateRule.arInit);
      end;
 }


    //- populate fields
//    lTabItem.FFrameMain.PopuUIx;
  end;
  Result := lTabItem;
end;

function TfMain.CreateEstabMap: TTabItem;
var
  lTabItem: ufEstabMap.TTabOfFrame;
begin
  // get the needed tab if any or create tab if one doesn't exist
  lTabItem := ufEstabMap.TTabOfFrame(Self.TabControl1.FindComponent(ufEstabMap.cTabName));

  if lTabItem = nil then
  begin
    lTabItem := ufEstabMap.TTabOfFrame.Create(Self.TabControl1);
    lTabItem.Parent := Self.TabControl1;

    // set up events
    lTabItem.OnCloseTab :=
      procedure
      begin
        AnimateTrans(TAnimateRule.arIn);  // animate the main tab
      end;

{
    lTabItem.OnNextBtnClick :=
      procedure
        var
          lTabItem: ufQYesNo.TTabOfFrame;
        begin
          lTabItem := ufQYesNo.TTabOfFrame(CreateTabQYesNo);
          lTabItem.ShowTab(TabControl1.ActiveTab); //, uiiAdd, -1, lTabItem.GetCarID);
          lTabItem.FFrameMain.PopuUI;
        //  lTabItem.FFrameHdr.PopuUI(lTabItem.GetCarID);

        //  AnimateTrans(TAnimationType.In);
          AnimateTrans(TAnimateRule.arInit);
      end;
}

    //- populate fields
//    lTabItem.FFrameMain.PopuUIx;
  end;
  Result := lTabItem;
end;

function TfMain.CreateEstabMenu: TTabItem;
var
  lTabItem: ufEstabMenu.TTabOfFrame;
begin
  // get the needed tab if any or create tab if one doesn't exist
  lTabItem := ufEstabMenu.TTabOfFrame(Self.TabControl1.FindComponent(ufEstabMenu.cTabName));

  if lTabItem = nil then
  begin
    lTabItem := ufEstabMenu.TTabOfFrame.Create(Self.TabControl1);
    lTabItem.Parent := Self.TabControl1;

    // set up events
    lTabItem.OnCloseTab :=
      procedure
      begin
        AnimateTrans(TAnimateRule.arIn);  // animate the main tab
      end;
    lTabItem.OnMapBtnClick :=
      procedure()
      var
        lSubTabItem: ufEstabMap.TTabOfFrame;
      begin
        lSubTabItem := ufEstabMap.TTabOfFrame(CreateEstabMap);
        //lSubTabItem.ShowTab(TabControl1.ActiveTab, 52.017454, -0.748851, lTabItem.FFrameMain.lblName.Text);
        lSubTabItem.ShowTab(TabControl1.ActiveTab, lTabItem.FFrameMain.FLat,
            lTabItem.FFrameMain.FLon, lTabItem.FFrameMain.lblName.Text);
        lSubTabItem.FFrameMain.PopuUI;
        AnimateTrans(TAnimateRule.arInit);
      end;
    lTabItem.OnComplBtnClick :=
      procedure()
      var
        lSubTabItem: ufEstabComp.TTabOfFrame;
      begin
        lSubTabItem := ufEstabComp.TTabOfFrame(CreateEstabComp);
        lSubTabItem.ShowTab(TabControl1.ActiveTab, lTabItem.FFrameMain.lblName.Text);
        //lSubTabItem.FFrameMain.PopuUI;
        AnimateTrans(TAnimateRule.arInit);
      end;
    lTabItem.OnTakeSurvBtnClick :=
      procedure()
      var
        lSubTabItem: ufQMultSele.TTabOfFrame;
      begin
        lSubTabItem := ufQMultSele.TTabOfFrame(CreateTabQMultiSele);
        lSubTabItem.ShowTab(TabControl1.ActiveTab); //, uiiAdd, -1, lTabItem.GetCarID);
        lSubTabItem.FFrameMain.PopuUI;
      //  lTabItem.FFrameHdr.PopuUI(lTabItem.GetCarID);

      //  AnimateTrans(TAnimationType.In);
        AnimateTrans(TAnimateRule.arInit);
      end;

{

 ++++++++++++++
    lTabItem.OnNextBtnClick :=
      procedure
        var
          lTabItem: ufQYesNo.TTabOfFrame;
        begin
          lTabItem := ufQYesNo.TTabOfFrame(CreateTabQYesNo);
          lTabItem.ShowTab(TabControl1.ActiveTab); //, uiiAdd, -1, lTabItem.GetCarID);
          lTabItem.FFrameMain.PopuUI;
        //  lTabItem.FFrameHdr.PopuUI(lTabItem.GetCarID);

        //  AnimateTrans(TAnimationType.In);
          AnimateTrans(TAnimateRule.arInit);
      end;
}

    //- populate fields
//    lTabItem.FFrameMain.PopuUIx;
  end;
  Result := lTabItem;
end;

function TfMain.CreateIntro: TTabItem;
var
  lTabItem: ufIntro.TTabOfFrame;
begin
  // get the needed tab if any or create tab if one doesn't exist
  lTabItem := ufIntro.TTabOfFrame(Self.TabControl1.FindComponent(ufIntro.cTabName));

  if lTabItem = nil then
  begin
    lTabItem := ufIntro.TTabOfFrame.Create(Self.TabControl1);
    lTabItem.Parent := Self.TabControl1;

    // set up events
    lTabItem.OnCloseTab :=
      procedure
      begin
        fMain.AnimateTrans(TAnimateRule.arIn);  //  animate the MAIN tab ??? seems not working.
      end;
    lTabItem.OnRegisBtnClick :=
      procedure
      begin
        ShowUserRegis;
      end;

 {
    lTabItem.OnSubmit :=
      procedure()
      var
        lSubTabItem: ufEstabMap.TTabOfFrame;
      begin
        lSubTabItem := ufEstabMap.TTabOfFrame(CreateEstabMap);
        lSubTabItem.ShowTab(TabControl1.ActiveTab, lTabItem.FFrameMain.lblName.Text);
        lSubTabItem.FFrameMain.PopuUI;
        AnimateTrans(TAnimateRule.arInit);
      end;
 }


    //- populate fields
//    lTabItem.FFrameMain.PopuUIx;
  end;
  Result := lTabItem;
end;

function TfMain.CreateSignIn: TTabItem;
var
  lTabItem: ufSignIn.TTabOfFrame;
begin
  // get the needed tab if any or create tab if one doesn't exist
  lTabItem := ufSignIn.TTabOfFrame(Self.TabControl1.FindComponent(ufSignIn.cTabName));

  if lTabItem = nil then
  begin
    lTabItem := ufSignIn.TTabOfFrame.Create(Self.TabControl1);
    lTabItem.Parent := Self.TabControl1;

    // set up events
    lTabItem.OnCloseTab :=
      procedure
      begin
        fMain.AnimateTrans(TAnimateRule.arIn);  // animate the MAIN tab
      end;
 {
    lTabItem.OnSubmit :=
      procedure()
      var
        lSubTabItem: ufEstabMap.TTabOfFrame;
      begin
        lSubTabItem := ufEstabMap.TTabOfFrame(CreateEstabMap);
        lSubTabItem.ShowTab(TabControl1.ActiveTab, lTabItem.FFrameMain.lblName.Text);
        lSubTabItem.FFrameMain.PopuUI;
        AnimateTrans(TAnimateRule.arInit);
      end;
 }


    //- populate fields
//    lTabItem.FFrameMain.PopuUIx;
  end;
  Result := lTabItem;
end;

function TfMain.CreateTabEstabList: TTabItem;
var
  lTabItem: ufEstabList.TTabOfFrame;
begin
  // get the needed tab if any or create tab if one doesn't exist
  lTabItem :=  ufEstabList.TTabOfFrame(Self.TabControl1.FindComponent(ufEstabList.cTabName)); //??

  if lTabItem = nil then
  begin
    lTabItem := ufEstabList.TTabOfFrame.Create(Self.TabControl1);
    lTabItem.Parent := Self.TabControl1;

    // set up events
    lTabItem.OnCloseTab :=
      procedure
      begin
        AnimateTrans(TAnimateRule.arOut);  // animate the main tab
{
        TfraEstabList(FFrameMain).AnimateTrans(TAnimateRule.arInit);
        TfraEstabList(FFrameMain).AnimateTrans(TAnimateRule.ar.arInit);
        //AnimateTrans(TAnimateRule.arIn);        // animate the main tab
//        ufEstabList. .TTabOfFrame. TTabControl(Self.Owner).ActiveTab := FCallerTab;
}
      end;
    lTabItem.OnItemClick :=
      procedure(ATID: Integer; ATitle, AAddress: string)
      var
        lSubTabItem: ufEstabMenu.TTabOfFrame;
        lLoca: uBusiObj.TLoca;
      begin
        lLoca := lTabItem.FFrameMain.GetLoca(ATID);
//showmessage(lLoca.Lat.ToString +'xxx'+ lLoca.Lon.ToString  +'ee'+ ATID.ToString);
        lSubTabItem := ufEstabMenu.TTabOfFrame(CreateEstabMenu);
//        lSubTabItem.ShowTab(TabControl1.ActiveTab, ATID, ATitle, AAddress, 52.017454, -0.748851);
        lSubTabItem.ShowTab(TabControl1.ActiveTab, ATID, ATitle, AAddress, lLoca.Lat, lLoca.Lon);
        lSubTabItem.FFrameMain.PopuUI;
        AnimateTrans(TAnimateRule.arInit);
      end;

{
    lTabItem.OnNextBtnClick :=
      procedure
        var
          lTabItem: ufQYesNo.TTabOfFrame;
        begin
          lTabItem := ufQYesNo.TTabOfFrame(CreateTabQYesNo);
          lTabItem.ShowTab(TabControl1.ActiveTab); //, uiiAdd, -1, lTabItem.GetCarID);
          lTabItem.FFrameMain.PopuUI;
        //  lTabItem.FFrameHdr.PopuUI(lTabItem.GetCarID);

        //  AnimateTrans(TAnimationType.In);
          AnimateTrans(TAnimateRule.arInit);
      end;
}

    //- populate fields
//    lTabItem.FFrameMain.PopuUIx;
  end;
  Result := lTabItem;
end;

function TfMain.CreateTabQMultiSele: TTabItem;
var
  lTabItem: ufQMultSele.TTabOfFrame;
begin
  // get the needed tab if any or create tab if one doesn't exist
  lTabItem := ufQMultSele.TTabOfFrame(Self.TabControl1.FindComponent(ufQMultSele.cTabName)); //??

  if lTabItem = nil then
  begin
    lTabItem := ufQMultSele.TTabOfFrame.Create(Self.TabControl1);
    lTabItem.Parent := Self.TabControl1;

    // set up events
    lTabItem.OnCloseTab :=
      procedure
      begin
        // animate the main tab
        AnimateTrans(TAnimateRule.arIn);
      end;
    lTabItem.OnNextBtnClick :=
      procedure
        var
          lSubTabItem: ufQYesNo.TTabOfFrame;
        begin
          lSubTabItem := ufQYesNo.TTabOfFrame(CreateTabQYesNo);
          lSubTabItem.ShowTab(TabControl1.ActiveTab); //, uiiAdd, -1, lTabItem.GetCarID);
          lSubTabItem.FFrameMain.PopuUI;
        //  lTabItem.FFrameHdr.PopuUI(lTabItem.GetCarID);

        //  AnimateTrans(TAnimationType.In);
          AnimateTrans(TAnimateRule.arInit);
      end;

{
    lTabItem.OnUOMPickList :=
      procedure(AEditor: TEdit)
      var
        lDlgPickList: TDlgPickList;
      begin
        lDlgPickList := TDlgPickList(CreateUOMPickList(AEditor)); //(lTabItem)
        lDlgPickList.OnAfterSelect :=
          procedure(AItemTag: integer; AUpdateMade: TUpdateMade)
          begin
//            if AEditor.Tag <> AItemTag then
            if AUpdateMade = umSelectedNew then
              lTabItem.FFrameMain.btnDone.Enabled := true;
          end;
        lDlgPickList.ShowDlg(lTabItem, AEditor.Tag);
      end;

    //  define after save event
    lTabItem.OnAfterSave :=
      procedure(AUpdateMade: TUpdateMade; ATID: integer)
      begin
        ufCarHist.TTabOfFrame(lTabItem.FCallerTab).PopuUIDtl;
      end;
    lTabItem.OnAfterDelete :=
      procedure(AUpdateMade: TUpdateMade; ATID: integer)
      begin
        // refresh list
        ufCarHist.TTabOfFrame(lTabItem.FCallerTab).PopuUIDtl;
      end;

    // set up UI.
    //lTabItem.TabItemStateStack := Self.FMainTabStack; +++
}
    //- populate fields
//    lTabItem.FFrameMain.PopuUIx;
  end;
  Result := lTabItem;
end;

function TfMain.CreateTabQYesNo: TTabItem;
var
  lTabItem: ufQYesNo.TTabOfFrame;
begin
  // get the needed tab if any or create tab if one doesn't exist
  lTabItem := ufQYesNo.TTabOfFrame(Self.TabControl1.FindComponent(ufQYesNo.cTabName));

  if lTabItem = nil then
  begin
    lTabItem := ufQYesNo.TTabOfFrame.Create(Self.TabControl1);
    lTabItem.Parent := Self.TabControl1;

    // set up events
    lTabItem.OnCloseTab :=
      procedure
      begin
        // animate the main tab
        AnimateTrans(TAnimateRule.arIn);
      end;

    lTabItem.OnNextBtnClick :=
      procedure
      begin
//
      end;

{
    lTabItem.OnUOMPickList :=
      procedure(AEditor: TEdit)
      var
        lDlgPickList: TDlgPickList;
      begin
        lDlgPickList := TDlgPickList(CreateUOMPickList(AEditor)); //(lTabItem)
        lDlgPickList.OnAfterSelect :=
          procedure(AItemTag: integer; AUpdateMade: TUpdateMade)
          begin
//            if AEditor.Tag <> AItemTag then
            if AUpdateMade = umSelectedNew then
              lTabItem.FFrameMain.btnDone.Enabled := true;
          end;
        lDlgPickList.ShowDlg(lTabItem, AEditor.Tag);
      end;

    //  define after save event
    lTabItem.OnAfterSave :=
      procedure(AUpdateMade: TUpdateMade; ATID: integer)
      begin
        ufCarHist.TTabOfFrame(lTabItem.FCallerTab).PopuUIDtl;
      end;
    lTabItem.OnAfterDelete :=
      procedure(AUpdateMade: TUpdateMade; ATID: integer)
      begin
        // refresh list
        ufCarHist.TTabOfFrame(lTabItem.FCallerTab).PopuUIDtl;
      end;

    // set up UI.
    //lTabItem.TabItemStateStack := Self.FMainTabStack; +++
}
    //- populate fields
//    lTabItem.FFrameMain.PopuUIx;
  end;
  Result := lTabItem;
end;

function TfMain.CreateUserRegis: TTabItem;
var
  lTabItem: ufUserRegis.TTabOfFrame;
begin
  // get the needed tab if any or create tab if one doesn't exist
  lTabItem := ufUserRegis.TTabOfFrame(Self.TabControl1.FindComponent(ufUserRegis.cTabName));

  if lTabItem = nil then
  begin
    lTabItem := ufUserRegis.TTabOfFrame.Create(Self.TabControl1);
    lTabItem.Parent := Self.TabControl1;

    // set up events
    lTabItem.OnCloseTab :=
      procedure
      begin
        fMain.AnimateTrans(TAnimateRule.arIn);  // animate the MAIN tab
      end;
 {
    lTabItem.OnSubmit :=
      procedure()
      var
        lSubTabItem: ufEstabMap.TTabOfFrame;
      begin
        lSubTabItem := ufEstabMap.TTabOfFrame(CreateEstabMap);
        lSubTabItem.ShowTab(TabControl1.ActiveTab, lTabItem.FFrameMain.lblName.Text);
        lSubTabItem.FFrameMain.PopuUI;
        AnimateTrans(TAnimateRule.arInit);
      end;
 }


    //- populate fields
//    lTabItem.FFrameMain.PopuUIx;
  end;
  Result := lTabItem;
end;

procedure TfMain.FloatAnimation2Finish(Sender: TObject);
begin
{
  if FloatAnimation2.AnimationType = TAnimationType.In then
begin
    Layout1.Align := TAlignLayout.Client;
showmessage('aaa Layout1.Align := TAlignLayout.Client');
end
else
showmessage('bbbb Layout1.Align := TAlignLayout.Client');
}
end;

procedure TfMain.FormCreate(Sender: TObject);
begin
  FAppSettings := uBusiObj.LoadAppSettings;
{
  ksTileMenu1.Items.AddOption('Near By', 'OPT_1',
    System.UITypes.TAlphaColors.Skyblue, System.UITypes.TAlphaColors.Black, Image2.Bitmap);
  ksTileMenu1.Items[0].TextColor := System.UITypes.TAlphaColors.Red;
}
//  showmessage('1 FormCreate '+ DateTimeToStr(time) );
//  showmessage('2 FormCreate '+ DateTimeToStr(time) );
end;

procedure TfMain.FormShow(Sender: TObject);
begin
  TabControl1.ActiveTab := tabiMain;
  if FAppSettings.IsShowIntro then
    ShowIntro;

  // activate the ringer monitoring
  timerGetSMS.Enabled := true;
end;

procedure TfMain.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const [Ref] Bounds: TRect);
// for Vert scroll box
begin
  FKBBounds.Create(0, 0, 0, 0);
  FNeedOffset := False;
  RestorePosition;
end;

procedure TfMain.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const [Ref] Bounds: TRect);
// for Vert scroll box
begin
  FKBBounds := TRectF.Create(Bounds);
  FKBBounds.TopLeft := ScreenToClient(FKBBounds.TopLeft);
  FKBBounds.BottomRight := ScreenToClient(FKBBounds.BottomRight);
  UpdateKBBounds;
end;

function TfMain.GetSoundName: string;
begin
  Result := TPath.Combine(GetDefaultFilePath, 'Siren_Noise-KevanGC-1337458893_Plus2db.mp3');
end;

procedure TfMain.Image2Click(Sender: TObject);
begin
//  ShowMessage('111');
  ShowEstabList;
end;

procedure TfMain.Label1Click(Sender: TObject);
begin
//  ShowEstabList;
  ShowMessage('333');
end;

procedure TfMain.Layout1Click(Sender: TObject);
begin
  ShowMessage('444');
end;

procedure TfMain.btnAboutClick(Sender: TObject);
var
  lTabItem: ufAbout.TTabOfFrame;
begin
  mvMain.HideMaster; // .Visible := false;
  lTabItem := ufAbout.TTabOfFrame(CreateAbout);
  lTabItem.ShowTab(TabControl1.ActiveTab);
//  lTabItem.FFrameMain.PopuUI;
//  lTabItem.FFrameHdr.PopuUI(lTabItem.GetCarID);

//  AnimateTrans(TAnimationType.In);
//  AnimateTrans(TAnimateRule.arInit); - shoule be fMain.Animate ???
end;

procedure TfMain.btnEstabListClick(Sender: TObject);
begin
  ShowEstabList;
end;

procedure TfMain.btnIntroClick(Sender: TObject);
begin
  ShowIntro;
end;

procedure TfMain.btnUserRegisClick(Sender: TObject);
begin
  mvMain.HideMaster; // .Visible := false;
  ShowUserRegis;
//  lTabItem := ufUserRegis.TTabOfFrame(CreateUserRegis);
//  lTabItem.ShowTab(TabControl1.ActiveTab);
//  lTabItem.FFrameMain.PopuUI;
//  lTabItem.FFrameHdr.PopuUI(lTabItem.GetCarID);

//  AnimateTrans(TAnimationType.In);
//  AnimateTrans(TAnimateRule.arInit); - shoule be fMain.Animate ???
end;

procedure TfMain.Button1Click(Sender: TObject);
begin
  timerGetSMS.Enabled := not timerGetSMS.Enabled;
end;

procedure TfMain.Button2Click(Sender: TObject);
begin
  Memo1.Lines.Clear;
end;

procedure TfMain.Button3Click(Sender: TObject);
begin
{
        CameraComponent.Active := False;
        CameraComponent.TorchMode := TTorchMode.ModeOn;
        CameraComponent.Active := true;
        sleep(3000);
        CameraComponent.Active := False;
        CameraComponent.TorchMode := TTorchMode.ModeOff;
        CameraComponent.Active := true;

        // below code doesn't work
        CameraComponent.Active := False;
        CameraComponent.FlashMode := TFlashMode.FlashOn;
        CameraComponent.Active := true;
        sleep(3000);
        CameraComponent.Active := False;
        CameraComponent.FlashMode := TFlashMode.FlashOff;
        CameraComponent.Active := true;
        sleep(3000);
exit;
}
{

  if CameraComponent.HasTorch then
  begin
    showmessage('With torch.');
    ActivateFlashLight;
  end
  else
    showmessage('No torch detected.');

  if CameraComponent.HasFlash then
    showmessage('With flash.')
  else
    showmessage('No flash detected.');
}
{
  ActivateFlashLight;
//  LogMsg(GetSoundName);
  PlaySound(50);
}
  timerGetSMSTimer(Sender);
//  timerGetSMS.Enabled := true;
end;

procedure TfMain.btnSignUpClick(Sender: TObject);
//var   lTabItem: ufUserRegis.TTabOfFrame;
begin
//  mvMain.HideMaster; // .Visible := false;
  ShowUserRegis;
//  lTabItem := ufUserRegis.TTabOfFrame(CreateUserRegis);
//  lTabItem.ShowTab(TabControl1.ActiveTab);
//  lTabItem.FFrameMain.PopuUI;
//  lTabItem.FFrameHdr.PopuUI(lTabItem.GetCarID);

//  AnimateTrans(TAnimationType.In);
//  AnimateTrans(TAnimateRule.arInit); - shoule be fMain.Animate ???
end;

procedure TfMain.ReadJSON;
var
  lFileName: TFileName;
  JSONValue, jv: TJsonDataValue; // TJSONValue;
  lJSONObject: TJSONObject;
  lTxt: string;
begin
  Memo1.Lines.Clear;
  Memo1.Lines.Add('determine the filespec');
  // read JSON from file
  lFileName := TPath.Combine(uBusiObj.GetDefaultFilePath, 'get_survey.json');
  //lFileName := TPath.Combine(uBusiObj.GetDefaultFilePath, 'SampleJSON.txt');

  Memo1.Lines.Add('reading txt file content to JSONObject');
//  JSONValue := TJsonDataValue( TJSONObject.ParseFromFile(TFile.ReadAllText(lFileName)) );
//  lJSONObject := TJSONObject( TJSONObject.ParseFromFile(TFile.ReadAllText(lFileName)) );
  lJSONObject := TJSONObject( TJSONObject.ParseFromFile(lFileName) );

//  lTxt := TFile.ReadAllText(lFileName);
  Memo1.Lines.Add('display JSONObject as string');
//  showmessage(lTxt);
//  Memo1.Lines.Add(lTxt);
  Memo1.Lines.Add(lJSONObject.ToString);

  // display json data
  Memo1.Lines.Add('section count = '+ IntToStr(lJSONObject['survey']['sections'].Count));
  Memo1.Lines.Add(lJSONObject['survey']['sections'].Items[0]['sectionTypeName'] );
  Memo1.Lines.Add('question count = '+ IntToStr( lJSONObject['survey']['sections'].Items[0]['questions'].Count) );
  Memo1.Lines.Add('question display name = '+ lJSONObject['survey']['sections'].Items[0]['questions'].Items[0]['displayName'] );

//  Memo1.Lines.Add(lJSONObject['']);
//  Memo1.Lines.Add(lJSONObject['']);

  Memo1.Lines.Add('Questions:');
  TestListAllQues(lJSONObject);
end;

procedure TfMain.ReadJSON2;
var
  lFileName: TFileName;
  JSONValue, jv: TJsonDataValue; // TJSONValue;
  lJSONObject: TJSONObject;
  lTxt: string;
begin
  Memo1.Lines.Clear;
  Memo1.Lines.Add('determine the filespec');
  // read JSON from file
  lFileName := TPath.Combine(uBusiObj.GetDefaultFilePath, 'get_survey.json');
  //lFileName := TPath.Combine(uBusiObj.GetDefaultFilePath, 'SampleJSON.txt');

  Memo1.Lines.Add('reading txt file content to JSONObject');
//  JSONValue := TJsonDataValue( TJSONObject.ParseFromFile(TFile.ReadAllText(lFileName)) );
//  lJSONObject := TJSONObject( TJSONObject.ParseFromFile(TFile.ReadAllText(lFileName)) );
  lJSONObject := TJSONObject( TJSONObject.ParseFromFile(lFileName) );

//  lTxt := TFile.ReadAllText(lFileName);
  Memo1.Lines.Add('display JSONObject as string');
//  showmessage(lTxt);
//  Memo1.Lines.Add(lTxt);
  Memo1.Lines.Add(lJSONObject.ToString);

  // display json data
  Memo1.Lines.Add('section count = '+ IntToStr(lJSONObject['sections'].Count));
  Memo1.Lines.Add(lJSONObject['sections'].Items[0]['sectionTypeName'] );
  Memo1.Lines.Add('question count = '+ IntToStr( lJSONObject['sections'].Items[0]['questions'].Count) );
  Memo1.Lines.Add('question display name = '+ lJSONObject['sections'].Items[0]['questions'].Items[0]['displayName'] );

//  Memo1.Lines.Add(lJSONObject['']);
//  Memo1.Lines.Add(lJSONObject['']);

  Memo1.Lines.Add('Questions:');
  TestListAllQues2(lJSONObject);
end;

{$IF DEFINED(ANDROID)}
procedure TfMain.ReadSMSInbox;
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
LogMsg('ReadSMSInbox: calling getContentResolver');
    try
      cursor := SharedActivity.getContentResolver.query(
       StrToJURI('content://sms/inbox'),
        nil,
         nil,
          nil,
           nil);
    except on E: Exception do
LogMsg('Error msg: ' + E.Message);
    end;

LogMsg('cursor.getCount = ' + cursor.getCount.ToString );

//exit;
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
            (lDate > FAppSettings.LastRingRcvdTimeStamp) then // compare date so as not to read the old ones that are still n the inbox.
//            (JStringToString(cursor.getString(cursor.getColumnIndex(StringToJString('READ')))) = '0') then
        begin
          LogMsg('aaaa Found it: ' + lBody +' '+ lDate +' > '+ FAppSettings.LastRingRcvdTimeStamp );
          // save new timestamp
          FAppSettings.LastRingRcvdTimeStamp := lDate;
          LIni := TIniFile.Create(GetIniFullFileName);
          try
            LIni.WriteString('Ringer', 'LastRingRcvdTimeStamp', lDate);
          finally
            lIni.Free;
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

{ enable thie later 8/23/18
          ActivateFlashLight;     // turn on light

          MediaPlayer1.Volume := lSplit.Volume / 100;
//LogMsg('MediaPlayer1.Volume = ' + MediaPlayer1.Volume.ToString);
          MediaPlayer1.Play;
}

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

LogMsg('Play sound here.');

          ActivateFlashLight;
          PlaySound(lSplit.Volume);
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

LogMsg('cursor.close');

end;
{$ENDIF}

procedure TfMain.Rectangle1Click(Sender: TObject);
begin
  //ShowMessage('222');
  ShowEstabList;
end;

procedure TfMain.RestorePosition;
// for Vert scroll box
begin
//  Self.vsboxMain.ViewportPosition := PointF(Self.vsboxMain.ViewportPosition.X, 0);
  VertScrollBox1.ViewportPosition := PointF(VertScrollBox1.ViewportPosition.X, 0);
//  Self.loutMain.Align := TAlignLayout.Client;
  loMain.Align := TAlignLayout.Client;
//  Self.vsboxMain.RealignContent;
  VertScrollBox1.RealignContent;
end;

procedure TfMain.ShowEstabList;
var
  lTabItem: ufEstabList.TTabOfFrame;
begin
  mvMain.HideMaster; // .Visible := false;
  lTabItem := ufEstabList.TTabOfFrame(CreateTabEstabList);
  lTabItem.ShowTab(TabControl1.ActiveTab);
  lTabItem.FFrameMain.PopuUI;
//  lTabItem.FFrameHdr.PopuUI(lTabItem.GetCarID);

//  AnimateTrans(TAnimationType.In);
  AnimateTrans(TAnimateRule.arInit);
end;

procedure TfMain.ShowIntro;
var
  lTabItem: ufIntro.TTabOfFrame;
begin
  mvMain.HideMaster; // .Visible := false;
  lTabItem := ufIntro.TTabOfFrame(CreateIntro);
  lTabItem.ShowTab(TabControl1.ActiveTab);
//  lTabItem.FFrameMain.PopuUI;
//  lTabItem.FFrameHdr.PopuUI(lTabItem.GetCarID);

//  AnimateTrans(TAnimationType.In);
//  AnimateTrans(TAnimateRule.arInit); - shoule be fMain.Animate ???
end;

procedure TfMain.ShowUserRegis;
var
  lTabItem: ufUserRegis.TTabOfFrame;
begin
//  mvMain.HideMaster; // .Visible := false;
  lTabItem := ufUserRegis.TTabOfFrame(CreateUserRegis);
  lTabItem.ShowTab(TabControl1.ActiveTab);
//  lTabItem.FFrameMain.PopuUI;
//  lTabItem.FFrameHdr.PopuUI(lTabItem.GetCarID);

//  AnimateTrans(TAnimationType.In);
//  AnimateTrans(TAnimateRule.arInit); - shoule be fMain.Animate ???
end;

procedure TfMain.SpeedButton1Click(Sender: TObject);
var
  lWB: TWebBrowser;
begin
  ReadJSON2;
//  TestAnimate;
  // test webbrowser
{
  lWB := TWebBrowser.Create(TabItem1);
  lwb.Parent := TabItem1;
  lWB.Align := TAlignLayout.Client;
}
end;

procedure TfMain.TestAnimate;
begin
  if Memo1.Height > 200 then
    Memo1.AnimateFloat('Height', 200, 0.2, TAnimationType.InOut, TInterpolationType.Linear)
  else
    Memo1.AnimateFloat('Height', 300, 0.2, TAnimationType.InOut, TInterpolationType.Linear);
end;

procedure TfMain.TestListAllQues(AJSONObj: TJSONObject);
var
  lSectionCount, lQuestCount, lChoiceCount: SmallInt;
  i, ii, iii: Integer;
begin
  //Memo1.Lines.Clear;
  Memo1.Lines.Add('++++++++++++ ');
  // display questions by section
  lSectionCount := AJSONObj['survey']['sections'].Count;
  for i := 0 to lSectionCount - 1 do
  begin
    Memo1.Lines.Add(AJSONObj['survey']['sections'].Items[i]['sectionTypeName'].Value +'='+ i.ToString);
    lQuestCount := AJSONObj['survey']['sections'].Items[i]['questions'].Count;
    for ii := 0 to lQuestCount - 1 do
    begin
      Memo1.Lines.Add(cTab + AJSONObj['survey']['sections'].Items[i]['questions'].Items[ii]['displayName'].Value +'='+ ii.ToString);
      lChoiceCount := AJSONObj['survey']['sections'].Items[i]['questions'].Items[ii]['inputChoices'].Count;
      for iii := 0 to lChoiceCount -1 do
      begin
        Memo1.Lines.Add(cTab+cTab+ AJSONObj['survey']['sections'].Items[i]['questions'].Items[ii]['inputChoices'].Items[iii]['optionName'].Value +'='+ iii.ToString);
      end;
    end;
  end;
end;

procedure TfMain.TestListAllQues2(AJSONObj: TJSONObject);
var
  lSectionCount, lQuestCount, lChoiceCount: SmallInt;
  i, ii, iii: Integer;
begin
  //Memo1.Lines.Clear;
  Memo1.Lines.Add('++++++++++++ ');
  // display questions by section
  lSectionCount := AJSONObj['sections'].Count;
  for i := 0 to lSectionCount - 1 do
  begin
    Memo1.Lines.Add(AJSONObj['sections'].Items[i]['sectionTypeName'].Value +'='+ i.ToString);
    lQuestCount := AJSONObj['sections'].Items[i]['questions'].Count;
    for ii := 0 to lQuestCount - 1 do
    begin
      Memo1.Lines.Add(cTab + AJSONObj['sections'].Items[i]['questions'].Items[ii]['questionDisplayText'].Value +'='+ ii.ToString);
      Memo1.Lines.Add(cTab + cTab + cTab + AJSONObj['sections'].Items[i]['questions'].Items[ii]['questionInputTypeName'].Value);
      lChoiceCount := AJSONObj['sections'].Items[i]['questions'].Items[ii]['inputChoices'].Count;
      for iii := 0 to lChoiceCount -1 do
      begin
        Memo1.Lines.Add(cTab+cTab+ AJSONObj['sections'].Items[i]['questions'].Items[ii]['inputChoices'].Items[iii]['optionName'].Value +'='+ iii.ToString);
      end;
    end;
  end;
end;

procedure TfMain.timerFlasherTimer(Sender: TObject);
begin
//  TurnFlashLight(false);
  TurnFlashLight( CameraComponent.TorchMode = TTorchMode.ModeOff );
//  TurnFlashLight( CameraComponent.FlashMode = TFlashMode.FlashOff);   -- doesn't work with Samsung J2
end;

procedure TfMain.timerGetSMSTimer(Sender: TObject);
begin
  LogMsg('timerGetSMSTimer');
  TThread.CreateAnonymousThread(
    procedure
    begin
      TThread.Synchronize(nil,
        procedure
        begin
          timerGetSMS.Enabled := false;
        end
        );
      try
        {$IF DEFINED(ANDROID)}
        LogMsg('timerGetSMSTimer: calling ReadSMSInbox');
        ReadSMSInbox;
        {$ENDIF}
      finally
        TThread.Synchronize(nil,
          procedure
          begin
            timerGetSMS.Enabled := true;      // this doesnt work in Win w/o Synchronize.
          end
          );
      end;
    end).Start;
end;

procedure TfMain.timerLightDurationTimer(Sender: TObject);
begin
  TurnFlashLight(false);
  TThread.Synchronize(nil,
    procedure
    begin
      timerFlasher.Enabled := false;
      timerLightDuration.Enabled := false;
LogMsg('timerLightDuration.Enabled := false');
    end
    );
end;

procedure TfMain.TurnFlashLight(AYes: Boolean);
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
        //CameraComponent.FlashMode := TFlashMode.FlashOn;
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
          //CameraComponent.FlashMode := TFlashMode.FlashOff;
        finally
          CameraComponent.Active := lActive;
        end;
//      end;
    end;

  end;

end;

procedure TfMain.UpdateKBBounds;
// for Vert scroll box
var
  LFocused : TControl;
  LFocusRect: TRectF;
begin
  FNeedOffset := False;
  if Assigned(Focused) then
  begin
    LFocused := TControl(Focused.GetObject);
    LFocusRect := LFocused.AbsoluteRect;
//    LFocusRect.Offset(Self.vsboxMain.ViewportPosition);
    LFocusRect.Offset(VertScrollBox1.ViewportPosition);
    if (LFocusRect.IntersectsWith(TRectF.Create(FKBBounds))) and
       (LFocusRect.Bottom > FKBBounds.Top) then
    begin
      FNeedOffset := True;
//      Self.loutMain.Align := TAlignLayout.Horizontal;
      loMain.Align := TAlignLayout.Horizontal;
//      Self.vsboxMain.RealignContent;
      VertScrollBox1.RealignContent;
      Application.ProcessMessages;
//      Self.vsboxMain.ViewportPosition :=
//        PointF(Self.vsboxMain.ViewportPosition.X,
//               LFocusRect.Bottom - FKBBounds.Top);
      VertScrollBox1 .ViewportPosition :=
        PointF(VertScrollBox1.ViewportPosition.X,
               LFocusRect.Bottom - FKBBounds.Top);
    end;
  end;
  if not FNeedOffset then
    RestorePosition;
end;

procedure TfMain.VertScrollBox1CalcContentBounds(Sender: TObject;
  var ContentBounds: TRectF);
// for Vert scroll box
begin
  if FNeedOffset and (FKBBounds.Top > 0) then
  begin
    ContentBounds.Bottom := Max(ContentBounds.Bottom,
                                2 * ClientHeight - FKBBounds.Top);
  end;
end;

procedure TfMain.LogMsg(AMsg: string);
begin
{
  TThread.Synchronize(nil,
    procedure
    begin
      Memo1.Lines.Add(TimeToStr(Time) +' '+ AMsg);
    end
    );
}
end;

procedure TfMain.PlaySound(AVolume: SmallInt);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      MediaPlayer1.FileName := GetSoundName;
      MediaPlayer1.Volume := AVolume / 100;
      MediaPlayer1.Play;
    end
    );
end;

end.
