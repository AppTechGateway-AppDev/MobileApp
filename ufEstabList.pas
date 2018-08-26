unit ufEstabList;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  ksTypes, ksTableView, FMX.Controls.Presentation, uBusiObj, FMX.Layouts,
  FMX.TabControl, FMX.ListBox, System.Sensors, FMX.Objects, ksTabControl,
  ksSegmentButtons, System.ImageList, FMX.ImgList;

const
  cTabName = 'TabEstabList';
  cHeaderTitle = 'Member Establishements';
  cTag = uBusiObj.tnEstabList;

type
  TfraEstabList = class(TFrame)
    ToolBar1: TToolBar;
    btnCancel: TSpeedButton;
    btnDone: TSpeedButton;
    lblHeaderTItle: TLabel;
    tvMain: TksTableView;
    Layout1: TLayout;
    Panel1: TPanel;
    cboxCategory: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    TabControl1: TTabControl;
    tabiList: TTabItem;
    tabiMap: TTabItem;
    procedure btnCancelClick(Sender: TObject);
    procedure cboxCategoryClosePopup(Sender: TObject);
    procedure tvMainItemClick(Sender: TObject; x, y: Single;
      AItem: TksTableViewItem; AId: string; ARowObj: TksTableViewItemObject);
    procedure btnDoneClick(Sender: TObject);
  private
    { Private declarations }
    FOnNextBtnClick: ^TProc; //<TObject>;   -in the future, this should contain the ID of the next question.
    FOnCloseTab: ^TProc;
    FOnItemClick: ^TProc<integer, string, string>;
  public
    { Public declarations }
    procedure PopuUI;
    procedure PopuEstabList(ACategory: integer);
    procedure AnimateTrans(AAnimateRule: TAnimateRule);
    function GetLoca(ATag: integer): uBusiObj.TLoca;
  end;

  TTabOfFrame = class(TTabItem)
  strict private
    FOnNextBtnClick: TProc; //<TObject>;
    FOnCloseTab: TProc; //<TObject>;
    FOnItemClick: TProc<integer, string, string>;
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
    FFrameMain: TfraEstabList;

    property OnNextBtnClick: TProc read FOnNextBtnClick write FOnNextBtnClick;
    property OnCloseTab: TProc read FOnCloseTab write FOnCloseTab;
    property OnItemClick: TProc<integer, string, string> read FOnItemClick write FOnItemClick;
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

{ TfraEstabList }

procedure TfraEstabList.AnimateTrans(AAnimateRule: TAnimateRule);
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

procedure TfraEstabList.btnCancelClick(Sender: TObject);
begin
  TTabOfFrame(Owner).CloseTab(false);
end;


procedure TfraEstabList.btnDoneClick(Sender: TObject);
var
  lLoca: uBusiObj.TLoca;
begin
  lLoca := GetLoca(0);
showmessage(lLoca.Lat.ToString +'xxx'+ lLoca.Lon.ToString);

end;

procedure TfraEstabList.cboxCategoryClosePopup(Sender: TObject);
begin
  PopuEstabList(cboxCategory.Selected.Index);
end;


function TfraEstabList.GetLoca(ATag: integer):  uBusiObj.TLoca;
begin
  if ATag = 0 then
  begin
    Result.Lat := 52.027648; Result.Lon := -0.764209;
  end
  else if ATag = 1 then
  begin
    Result.Lat := 52.017454; Result.Lon := -0.748851;
  end
  else if ATag = 2 then
  begin
    Result.Lat := 52.053133; Result.Lon := -0.710701;
  end
  else if ATag = 3 then
  begin
    Result.Lat := 52.043171; Result.Lon := -0.767086;
  end
  else if ATag = 4 then
  begin
    Result.Lat := 52.040039; Result.Lon := -0.747329;
  end
  else if ATag = 5 then
  begin
    Result.Lat := 51.996629; Result.Lon := -0.712529;
  end
  else if ATag = 6 then
  begin
    Result.Lat := 52.030433; Result.Lon := -0.722175;
  end
  else if ATag = 7 then
  begin
    Result.Lat := 52.038168; Result.Lon := -0.763601;
  end
  else if ATag = 8 then
  begin
    Result.Lat := 52.037634; Result.Lon := -0.767661;
  end
  else if ATag = 9 then
  begin
    Result.Lat := 52.043225; Result.Lon := -0.757874;
  end
  else if ATag = 10 then
  begin
    Result.Lat := 52.038449; Result.Lon := -0.763338;
  end
  else if ATag = 11 then
  begin
    Result.Lat := 52.037219; Result.Lon := -0.763276;
  end;
end;


procedure TfraEstabList.PopuEstabList(ACategory: integer);
var
  lItem: TksTableViewItem;
//  lLocat: TLocationCoord2D;
//  lLocat: TObject;
  lBar: TksTableViewItemImage;
begin

  // populate establishment
  tvMain.BeginUpdate;
  try
    tvMain.Items.Clear;
    if ACategory = 0 then
    begin
      lItem := tvMain.Items.AddItem('Halfords Autocentre', 'Snowdon Dr', 'Free oil change labor', TksAccessoryType.atMore); //atDetail
      lItem.TagInteger := 0;  //TLocationCoord2D.Create(52.017454, -0.748851);
      lItem := tvMain.Items.AddItem('MK Diagnostics', '2 Summerson Rd', 'Free diagnostic', TksAccessoryType.atMore );
      lItem.TagInteger := 1;
//lBar := lItem.DrawBitmap(Image1.Bitmap, 0, 0, 16, 16);
//lBar.Align := TksTableItemAlign.Trailing;
      lItem := tvMain.Items.AddItem('Pennings Accident and Repair Centre', '9, Northfield Dr', '', TksAccessoryType.atMore );
      lItem.TagInteger := 2;
//lBar := lItem.DrawBitmap(Image2.Bitmap, 0, 0, 24, 24);
//lBar.Align := TksTableItemAlign.Trailing;



    end
    else if ACategory = 1 then
    begin
      lItem := tvMain.Items.AddItem('Portway Service Station', 'H5 Portway, Bradwell Common', 'Free windshield cleaning', TksAccessoryType.atNone );
      lItem.TagInteger := 3;
      lItem := tvMain.Items.AddItem('Esso', 'H6 Childs Way', '5% discount ', TksAccessoryType.atNone );
      lItem.TagInteger := 4;
    end
    else if ACategory = 2 then
    begin
      lItem := tvMain.Items.AddItem('Hôtel Campanile', '40 Penn Rd, Watling St, Bletchley', 'Free beer', TksAccessoryType.atNone );
      lItem.TagInteger := 5;
      lItem := tvMain.Items.AddItem('Woughton House - MGallery by Sofitel', 'Newport Rd, Woughton on the Green', '', TksAccessoryType.atNone );
      lItem.TagInteger := 6;
      lItem := tvMain.Items.AddItem('Jurys Inn - Milton Keynes', 'Midsummer Blvd', 'Free breakfast', TksAccessoryType.atNone );
      lItem.TagInteger := 7;
    end
    else if ACategory = 3 then
    begin
      lItem := tvMain.Items.AddItem('Wetherspoons', '201 Midsummer Blvd', 'Free mango shake ', TksAccessoryType.atNone);  // .atInfo atDetails
      lItem.TagInteger := 8;
      lItem := tvMain.Items.AddItem('Giraffe', '39-41 Silbury Arcade', 'Free softdrink', TksAccessoryType.atNone);
      lItem.TagInteger := 9;
      lItem := tvMain.Items.AddItem('Browns Milton Keynes', '300, Midsummer Blvd', '', TksAccessoryType.atNone);
      lItem.TagInteger := 10;
      lItem := tvMain.Items.AddItem('Loch Fyne Seafood & Grill', 'Witan Gate', '', TksAccessoryType.atNone );
      lItem.TagInteger := 11;
    end;

{
    tvMain.Items.AddItem('', '', '', TksAccessoryType.atNone );
    tvMain.Items.AddItem('', '', '', TksAccessoryType.atNone );
    tvMain.Items.AddItem('', '', '', TksAccessoryType.atNone );
    tvMain.Items.AddItem('', '', '', TksAccessoryType.atNone );
}
  finally
    tvmain.EndUpdate;
  end;

//  showmessage('popuIU called');


end;

procedure TfraEstabList.PopuUI;
//var   //lItemIndex: integer; lObj: TObject;  lItem: tkstableviewitem;
begin
  // populate category
  cboxCategory.BeginUpdate;
  try
    cboxCategory.Items.clear;
    //cboxCategory.Items.Add('All');
    cboxCategory.Items.Add('Auto');
    cboxCategory.Items.Add('Gas/Convenience');
    cboxCategory.Items.Add('Hotel');
    cboxCategory.Items.Add('Restaurant');
    //cboxCategory.Items.Add('');
    // lObj := cboxCategory.Items.Objects[lItemIndex]
  finally
    cboxCategory.EndUpdate;
  end;

end;

procedure TfraEstabList.tvMainItemClick(Sender: TObject; x, y: Single;
  AItem: TksTableViewItem; AId: string; ARowObj: TksTableViewItemObject);
begin
  if Assigned(FOnItemClick^) then
    FOnItemClick^(AItem.TagInteger, AItem.Title.Text, AItem.SubTitle.Text);
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
  FFrameMain := TfraEstabList.Create(Self);
  FFrameMain.Parent := Self;

//  FFrameMain.Layout1.Align := TAlignLayout.None;
  FFrameMain.Tag := Integer(cTag); //uBusiObj.tnUOMUpd);

  // define events
  FFrameMain.FOnNextBtnClick := @OnNextBtnClick;
  FFrameMain.FOnCloseTab := @OnCloseTab;
  FFrameMain.FOnItemClick := @OnItemClick;

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

  FFrameMain.tvMain.ItemHeight := 50;
  FFrameMain.TabControl1.ActiveTab := FFrameMain.tabiList;
end;

destructor TTabOfFrame.Destroy;
begin
  FFrameMain.Free;
  inherited;
end;

procedure TTabOfFrame.ShowTab(ACallerTab: TTabItem);
begin
  Application.ProcessMessages;    // to solve sudden death
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
  Application.ProcessMessages;    // to solve sudden death


  FFrameMain.AnimateTrans(TAnimateRule.arIn);
end;

end.
