unit ufQMultSele;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.ScrollBox, FMX.Memo, ksTypes,
  ksVirtualListView, uBusiObj, FMX.TabControl, FMX.ListBox, FMX.Ani;

const
  cTabName = 'TabQMultiSele';
  cHeaderTitle = 'Sample Survey Question';
  cTag = uBusiObj.tnQMultiSele;

type
  TfraQMultSele = class(TFrame)
    ToolBar1: TToolBar;
    btnCancel: TSpeedButton;
    btnDone: TSpeedButton;
    lblHeaderTItle: TLabel;
    Memo1: TMemo;
    Layout1: TLayout;
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxGroupFooter1: TListBoxGroupFooter;
    FloatAnimation1: TFloatAnimation;
    Button1: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure ListBoxItem1Click(Sender: TObject);
    procedure btnDoneClick(Sender: TObject);
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
    FFrameMain: TfraQMultSele;
    property OnNextBtnClick: TProc read FOnNextBtnClick write FOnNextBtnClick;
    property OnCloseTab: TProc read FOnCloseTab write FOnCloseTab;
    procedure CloseTab(AIsRelease: Boolean);
    constructor Create(AOwner: TComponent); // supply various params here. AReccordID: integer); // ; AUserRequest: TUserRequest
    destructor Destroy; override;
    procedure ShowTab(ACallerTab: TTabItem); //; AUserRequest: TUserIntentInit;      ATID, ACarID: integer);

{
    FFrameMain: TfraCarHistUpd;
    FFrameHdr: TfraCarHdr;
    //property OnBackBtnClick: TProc<TObject> read FOnBackBtnClick write FOnBackBtnClick;
    //property OnDoneBtnClick: TProc<TObject> read FOnDoneBtnClick write FOnDoneBtnClick;
    property OnAfterSave: TProc<TUpdateMade, Integer> read FOnAfterSave write FOnAfterSave;
    property OnAfterDelete: TProc<TUpdateMade, integer> read FOnAfterDeleted write FOnAfterDeleted;
    property OnUOMPickList: TProc<TEdit> read FOnUOMPickList write FOnUOMPickList;
    property OnATPickList: TProc<TEdit> read FOnATPickList write FOnATPicklist;
    function GetCarID: integer;
    function GetCurrTabItemState: TUserIntentCurrent;
    function GetRecID: integer;
}
  end;

implementation

{$R *.fmx}

{ TTabOfFrame }

procedure TTabOfFrame.CloseTab(AIsRelease: Boolean);
begin
  TTabControl(Self.Owner).ActiveTab := FCallerTab;
  if Assigned(FOnCloseTab) then
    FOnCloseTab();
end;

procedure TfraQMultSele.AnimateTrans(AAnimateRule: TAnimateRule);
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

procedure TfraQMultSele.btnCancelClick(Sender: TObject);
begin
{
  TThread.CreateAnonymousThread(
    procedure
    begin
          TThread.Synchronize(nil,
            procedure
            begin
  AnimateTrans(TAnimationType.Out);
            end
            );
    end);
}

//  AnimateTrans(TAnimationType.Out);
//Application.ProcessMessages;
//sleep(1000);

  TTabOfFrame(Owner).CloseTab(false);
end;

procedure TfraQMultSele.btnDoneClick(Sender: TObject);
begin
//  AnimateTrans(TAnimationType.Out);
end;

procedure TfraQMultSele.Button1Click(Sender: TObject);
begin
  if Assigned(FOnNextBtnClick^) then
    FOnNextBtnClick^();
end;

procedure TfraQMultSele.ListBoxItem1Click(Sender: TObject);
begin
  TListBoxItem(Sender).IsChecked := not TListBoxItem(Sender).IsChecked;
{
  if TListBoxItem(Sender).ItemData.Accessory = TListBoxItemData.TAccessory.aCheckmark then
    TListBoxItem(Sender).ItemData.Accessory := TListBoxItemData.TAccessory.aNone
  else
    TListBoxItem(Sender).ItemData.Accessory := TListBoxItemData.TAccessory.aCheckmark;
}
end;

procedure TfraQMultSele.PopuUI;
  procedure AddItem(AText: string);
  var
    lItem: TListBoxItem;
  begin
    lItem := TListBoxItem.Create(nil);
    lItem.Parent := ListBox1;
    lItem.Text := AText;
    lItem.Height := 41;
    lItem.OnClick := ListBoxItem1Click;
    lItem.Selectable := false;
  end;
//var
//  lItem: TListBoxItem;
begin
  ListBox1.BeginUpdate;
  try
    ListBox1.Items.clear;
    AddItem('Sunday');
    AddItem('Monday');
    AddItem('Tuesday');
    AddItem('Wednesday');
    AddItem('Thursday');
    AddItem('Friday');
    AddItem('Saturday');
    AddItem('Any day we want');
  finally
    ListBox1.EndUpdate;
  end;
{
  lItem.Text := 'Sunday';
  lItem.Height := 41;
  lItem.OnClick := ListBoxItem1Click;
}



//  lItem.StyleLookup := 'CustomItem';

{
  ksVirtualListView1.BeginUpdate;
  try
    ksVirtualListView1.Items.Add('Sunday', '', '', atNone);
    ksVirtualListView1.Items.Add('Monday', '', '', atNone);
    ksVirtualListView1.Items.Add('Tuesday', '', '', atNone);
    ksVirtualListView1.Items.Add('Wednesday', '', '', atNone);
    ksVirtualListView1.Items.Add('Thursday', '', '', atNone);
    ksVirtualListView1.Items.Add('Friday', '', '', atNone);
    ksVirtualListView1.Items.Add('Saturday', '', '', atNone);
    ksVirtualListView1.Items.Add('No fix day', '', '', atNone);
  finally
    ksVirtualListView1.EndUpdate;
  end;
}
end;

constructor TTabOfFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Name := cTabName;
  Tag  := Integer(cTag);

  // create main frame
  FFrameMain := TfraQMultSele.Create(Self);
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

procedure TTabOfFrame.ShowTab(ACallerTab: TTabItem); //   AUserRequest: TUserIntentInit; ATID, ACarID: integer);
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
