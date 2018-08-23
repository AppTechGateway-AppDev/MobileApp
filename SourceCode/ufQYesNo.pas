unit ufQYesNo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FMX.ListBox, FMX.TabControl, uBusiObj;

const
  cTabName = 'TabQYesNo';
  cHeaderTitle = 'Sample Survey Question';
  cTag = uBusiObj.tnYesNo;

type
  TfraQYesNo = class(TFrame)
    ToolBar1: TToolBar;
    btnCancel: TSpeedButton;
    btnDone: TSpeedButton;
    lblHeaderTItle: TLabel;
    Label1: TLabel;
    Layout1: TLayout;
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    Label2: TLabel;
    Label3: TLabel;
    ListBoxGroupFooter1: TListBoxGroupFooter;
    Button1: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FOnNextBtnClick: ^TProc; //<TObject>;   -in the future, this should contain the ID of the next question.
    FOnCloseTab: ^TProc;
    procedure AnimateTrans(AAnimateRule: TAnimateRule);
  public
    { Public declarations }
    procedure PopuUI;
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
    FFrameMain: TfraQYesNo;
    property OnNextBtnClick: TProc read FOnNextBtnClick write FOnNextBtnClick;
    property OnCloseTab: TProc read FOnCloseTab write FOnCloseTab;
    procedure CloseTab(AIsRelease: Boolean);
    constructor Create(AOwner: TComponent); // supply various params here. AReccordID: integer); // ; AUserRequest: TUserRequest
    destructor Destroy; override;
    procedure ShowTab(ACallerTab: TTabItem); //; AUserRequest: TUserIntentInit;      ATID, ACarID: integer);
  end;


implementation

{$R *.fmx}

//uses uBusiObj;

{ TfraQYesNo }

procedure TfraQYesNo.AnimateTrans(AAnimateRule: TAnimateRule);
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
      Layout1.AnimateFloat('Position.X', Layout1.Width, 0.2, TAnimationType.InOut, TInterpolationType.Linear);
    end;
  finally
    if AAnimateRule = uBusiObj.TAnimateRule.arIn then
      Layout1.Align := TAlignLayout.Client;
  end;
end;

procedure TfraQYesNo.btnCancelClick(Sender: TObject);
begin
  TTabOfFrame(Owner).CloseTab(false);
end;

procedure TfraQYesNo.Button1Click(Sender: TObject);
begin
  showmessage('Survey data submitted');
//  TTabOfFrame(Owner).CloseTab(false);
end;

procedure TfraQYesNo.PopuUI;
begin
  //  empty
end;

procedure TfraQYesNo.SpeedButton1Click(Sender: TObject);
begin
end;

{ TTabOfFrame }

procedure TTabOfFrame.CloseTab(AIsRelease: Boolean);
begin
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
  FFrameMain := TfraQYesNo.Create(Self);
  FFrameMain.Parent := Self;

//  FFrameMain.Layout1.Align := TAlignLayout.None;
  FFrameMain.Tag := Integer(cTag); //uBusiObj.tnUOMUpd);

  // define events
  FFrameMain.FOnNextBtnClick := @OnNextBtnClick;
  FFrameMain.FOnCloseTab := @OnCloseTab;

{
  //FFrameMain.FOnBackBtnClick := @OnBackBtnClick;
  //FFrameMain.FOnDoneBtnClick := @OnDoneBtnClick;
  FFrameMain.FOnAfterDelete := @OnAfterDelete;
  FFrameMain.FOnUOMPickList := @OnUOMPickList;
  FFrameMain.FOnATPickList := @OnATPickList;

  // create header frame
  FFrameHdr := TfraCarHdr.Create(Self);
  FFrameHdr.Parent := FFrameMain.Layout1;
  //FFrameHdr.FOnHdrEditClick := @OnHdrEditClick;
  FFrameHdr.loEdit.Visible := false;
  FFrameHdr.lblCarName.Align := TAlignLayout.Contents;
  FFrameHdr.lblCarName.Margins.Left := 100;
  FFrameHdr.lblCarName.Margins.Top := 0;
}

end;

destructor TTabOfFrame.Destroy;
begin
  FFrameMain.Free;
  inherited;
end;

procedure TTabOfFrame.ShowTab(ACallerTab: TTabItem);
begin
  FCallerTab := ACallerTab;
{
  FRecID := ATID;
  FCarID := ACarID;
  FTabItemState.UserIntentInit := AUserRequest;
  FTabItemState.UserIntentCurr := UserIntentInitToCurr(AUserRequest);
}

  FFrameMain.AnimateTrans(TAnimateRule.arInit);

  TTabControl(Self.Owner).ActiveTab := Self;
//  if FTabItemState.UserIntentCurr = uicAdding then
//    FFrameMain.edtDescript.SetFocus;

  FFrameMain.AnimateTrans(TAnimateRule.arIn);
end;

end.
