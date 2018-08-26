unit ufEstabMenu;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.ListBox, uBusiObj,
  FMX.TabControl;

const
  cTabName = 'TabEstabMenu';
  cHeaderTitle = 'Member Businesses';
  cTag = uBusiObj.tnEstabMenu;

type
  TfraEstabMenu = class(TFrame)
    ToolBar1: TToolBar;
    btnCancel: TSpeedButton;
    shpCarPic: TCircle;
    lblName: TLabel;
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    Layout1: TLayout;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    lblAddress: TLabel;
    Label1: TLabel;
    lblHeaderTItle: TLabel;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    procedure btnCancelClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    FOnNextBtnClick: ^TProc; //<TObject>;   -in the future, this should contain the ID of the next question.
    FOnCloseTab: ^TProc;
    FOnMapBtnClick: ^TProc;
    FOnComplBtnClick:  ^TProc;
    FOnTakeSurvBtnClick:  ^TProc;
    FTID: integer;
    procedure AnimateTrans(AAnimateRule: TAnimateRule);
  public
    { Public declarations }
    FLat, FLon: double;
    procedure PopuUI;
  end;

  TTabOfFrame = class(TTabItem)
  strict private
    FOnNextBtnClick: TProc; //<TObject>;
    FOnCloseTab: TProc; //<TObject>;
    FOnMapBtnClick: TProc;
    FOnComplBtnClick: TProc;
    FOnTakeSurvBtnClick: TProc;
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
    FFrameMain: TfraEstabMenu;
    property OnNextBtnClick: TProc read FOnNextBtnClick write FOnNextBtnClick;
    property OnCloseTab: TProc read FOnCloseTab write FOnCloseTab;
    property OnMapBtnClick: TProc read FOnMapBtnClick write FOnMapBtnClick;
    property OnComplBtnClick: TProc read FOnComplBtnClick write FOnComplBtnClick;
    property OnTakeSurvBtnClick: TProc read FOnTakeSurvBtnClick write FOnTakeSurvBtnClick;
    procedure CloseTab(AIsRelease: Boolean);
    constructor Create(AOwner: TComponent); // supply various params here. AReccordID: integer); // ; AUserRequest: TUserRequest
    destructor Destroy; override;
    procedure ShowTab(ACallerTab: TTabItem; ATID: integer; ATitle,
      AAddress: string; ALat, ALon: double); //; AUserRequest: TUserIntentInit;      ATID, ACarID: integer);
  end;

implementation

{$R *.fmx}


{ TfraEstabMenu }

procedure TfraEstabMenu.AnimateTrans(AAnimateRule: TAnimateRule);
begin
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
end;

{ TTabOfFrame }

procedure TTabOfFrame.CloseTab(AIsRelease: Boolean);
begin
//  FFrameMain.AnimateTrans(TAnimateRule.arOut);  // animate the main tab
  TTabControl(Self.Owner).ActiveTab := FCallerTab;
  if Assigned(FOnCloseTab) then
    FOnCloseTab();
end;

procedure TfraEstabMenu.btnCancelClick(Sender: TObject);
begin
  AnimateTrans(TAnimateRule.arOut);  // animate the main tab
  TTabOfFrame(Owner).CloseTab(false);
end;

procedure TfraEstabMenu.Button1Click(Sender: TObject);
begin
  if Assigned(FOnComplBtnClick^) then
    FOnComplBtnClick^();
end;

procedure TfraEstabMenu.Button2Click(Sender: TObject);
begin
  if Assigned(FOnMapBtnClick^) then
    FOnMapBtnClick^();
end;

procedure TfraEstabMenu.Button3Click(Sender: TObject);
begin
  if Assigned(FOnTakeSurvBtnClick^) then
    FOnTakeSurvBtnClick^();
end;

procedure TfraEstabMenu.PopuUI;
begin
  // update photo here.
end;

constructor TTabOfFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Name := cTabName;
  Tag  := Integer(cTag);

  // create main frame
  FFrameMain := TfraEstabMenu.Create(Self);
  FFrameMain.Parent := Self;

//  FFrameMain.Layout1.Align := TAlignLayout.None;
  FFrameMain.Tag := Integer(cTag); //uBusiObj.tnUOMUpd);

  // define events
  FFrameMain.FOnNextBtnClick := @OnNextBtnClick;
  FFrameMain.FOnCloseTab := @OnCloseTab;
  FFrameMain.FOnMapBtnClick := @OnMapBtnClick;
  FFrameMain.FOnComplBtnClick := @OnComplBtnClick;
  FFrameMain.FOnTakeSurvBtnClick := @OnTakeSurvBtnClick;
end;

destructor TTabOfFrame.Destroy;
begin
  FFrameMain.Free;
  inherited;
end;

procedure TTabOfFrame.ShowTab(ACallerTab: TTabItem; ATID: integer; ATitle,
    AAddress: string; ALat, ALon: double);
begin
  FCallerTab := ACallerTab;
  FFrameMain.FTID := ATID;
  FFrameMain.FLat := ALat;
  FFrameMain.FLon := ALon;

  FFrameMain.AnimateTrans(TAnimateRule.arInit);
  TTabControl(Self.Owner).ActiveTab := Self;
//  if FTabItemState.UserIntentCurr = uicAdding then
//    FFrameMain.edtDescript.SetFocus;
  FFrameMain.AnimateTrans(TAnimateRule.arIn);

  // update fields
  FFrameMain.lblName.Text := ATitle;
  FFrameMain.lblAddress.Text := AAddress;
end;

end.
