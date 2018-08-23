unit ufIntro;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  ksTabControl, uBusiObj, FMX.Layouts, FMX.TabControl, FMX.Controls.Presentation,
  System.Actions, FMX.ActnList, FMX.Gestures, FMX.Objects, FMX.ScrollBox,
  FMX.Memo, FGX.LinkedLabel, FMX.ListBox, FMX.Edit, System.ImageList;
//  System.UITypes; // FMX.Graphics; //FMX.ImgList,

const
  cTabName = 'TabIntro';
  cHeaderTitle = 'Introduction';
  cTag = uBusiObj.tnIntro;

type
  TfraIntro = class(TFrame)
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    Label1: TLabel;
    GestureManager1: TGestureManager;
    TabActionList: TActionList;
    ChangeTabActionPrev: TChangeTabAction;
    ChangeTabActionNext: TChangeTabAction;
    Label4: TLabel;
    Label5: TLabel;
    Layout1: TLayout;
    Label2: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Image2: TImage;
    Image3: TImage;
    Text1: TText;
    TabItem5: TTabItem;
    Image5: TImage;
    Text6: TText;
    fgLinkedLabel2: TfgLinkedLabel;
    TabItem6: TTabItem;
    Image6: TImage;
    Text8: TText;
    btnRegis: TButton;
    Layout7: TLayout;
    ToolBar1: TToolBar;
    btnCancel: TSpeedButton;
    lblHeaderTItle: TLabel;
    TabItem7: TTabItem;
    Image7: TImage;
    Text10: TText;
    Label20: TLabel;
    TabItem8: TTabItem;
    Image8: TImage;
    Text9: TText;
    Label23: TLabel;
    TabItem9: TTabItem;
    Image9: TImage;
    Text11: TText;
    Label26: TLabel;
    TabItem10: TTabItem;
    Image10: TImage;
    Label29: TLabel;
    fgLinkedLabel1: TfgLinkedLabel;
    Label30: TLabel;
    Label31: TLabel;
    TabItem11: TTabItem;
    Label34: TLabel;
    Label36: TLabel;
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    editFirstName: TEdit;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Image14: TImage;
    Button1: TButton;
    Label33: TLabel;
    Label37: TLabel;
    TabItem12: TTabItem;
    Image15: TImage;
    Label38: TLabel;
    Label40: TLabel;
    Label39: TLabel;
    Layout4: TLayout;
    Image4: TImage;
    Image16: TImage;
    Image17: TImage;
    Image18: TImage;
    Image19: TImage;
    Layout14: TLayout;
    Image1: TImage;
    Image20: TImage;
    Image21: TImage;
    Label3: TLabel;
    Label6: TLabel;
    Image22: TImage;
    Label7: TLabel;
    Label12: TLabel;
    Layout2: TLayout;
    Image25: TImage;
    Image26: TImage;
    Label35: TLabel;
    Layout15: TLayout;
    Image23: TImage;
    Image24: TImage;
    Label10: TLabel;
    Layout13: TLayout;
    Image27: TImage;
    Image28: TImage;
    Label11: TLabel;
    Layout3: TLayout;
    Image29: TImage;
    Image30: TImage;
    Label14: TLabel;
    Layout5: TLayout;
    Image31: TImage;
    Image32: TImage;
    Label13: TLabel;
    Layout8: TLayout;
    Image33: TImage;
    Image34: TImage;
    Label15: TLabel;
    Layout9: TLayout;
    Image35: TImage;
    Image36: TImage;
    Label16: TLabel;
    Layout6: TLayout;
    Image37: TImage;
    Image38: TImage;
    Label17: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure ChangeTabActionPrevUpdate(Sender: TObject);
    procedure ChangeTabActionNextUpdate(Sender: TObject);
    procedure btnRegisClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TabControl1Paint(Sender: TObject; Canvas: TCanvas;
      const [Ref] ARect: TRectF);
    procedure TabItem9Paint(Sender: TObject; Canvas: TCanvas;
      const [Ref] ARect: TRectF);
  private
    { Private declarations }
    FOnCloseTab: ^TProc;
    FOnRegisBtnClick: ^TProc;
  public
    { Public declarations }
    procedure AnimateTrans(AAnimateRule: TAnimateRule);
  end;

  TTabOfFrame = class(TTabItem)
  strict private
    FOnCloseTab: TProc; //<TObject>;
    FOnRegisBtnClick: TProc;
  private
//    FRecID: integer;
  public
    FCallerTab: TTabItem;
    FFrameMain: TfraIntro;
//    property OnSubmit: TProc read FOnSubmit write FOnSubmit;
    property OnCloseTab: TProc read FOnCloseTab write FOnCloseTab;
    property OnRegisBtnClick: TProc read FOnRegisBtnClick write FOnRegisBtnClick;
    procedure CloseTab(AIsRelease: Boolean);
    constructor Create(AOwner: TComponent); // supply various params here. AReccordID: integer); // ; AUserRequest: TUserRequest
    destructor Destroy; override;
    procedure ShowTab(ACallerTab: TTabItem); //; AUserRequest: TUserIntentInit;      ATID, ACarID: integer);
  end;

implementation

{$R *.fmx}

{ TfraIntro }

procedure TfraIntro.AnimateTrans(AAnimateRule: TAnimateRule);
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
end;

procedure TfraIntro.btnCancelClick(Sender: TObject);
begin
  AnimateTrans(TAnimateRule.arOut);  // animate the main tab
  TTabOfFrame(Owner).CloseTab(false);
end;

procedure TfraIntro.btnRegisClick(Sender: TObject);
begin
  AnimateTrans(TAnimateRule.arOut);  // animate the main tab
  TTabOfFrame(Owner).CloseTab(false);
  if Assigned(FOnRegisBtnClick^) then    // show user regis tab
    FOnRegisBtnClick^();
end;

procedure TfraIntro.Button1Click(Sender: TObject);
begin
  ShowMessage('Contact info submitted.');
  AnimateTrans(TAnimateRule.arOut);  // animate the main tab
  TTabOfFrame(Owner).CloseTab(false);
end;

procedure TfraIntro.ChangeTabActionNextUpdate(Sender: TObject);
begin

  if TabControl1.TabIndex < TabControl1.TabCount -1 then
    ChangeTabActionNext.Tab := TabControl1.Tabs[TabControl1.TabIndex + 1]
  else
    ChangeTabActionNext.Tab := nil;

  if TabControl1.TabIndex > 0 then
    ChangeTabActionPrev.Tab := TabControl1.Tabs[TabControl1.TabIndex - 1]
  else
    ChangeTabActionPrev.Tab := nil;

end;

procedure TfraIntro.ChangeTabActionPrevUpdate(Sender: TObject);
begin

  if TabControl1.TabIndex < TabControl1.TabCount -1 then
    ChangeTabActionNext.Tab := TabControl1.Tabs[TabControl1.TabIndex + 1]
  else
    ChangeTabActionNext.Tab := nil;

  if TabControl1.TabIndex > 0 then
    ChangeTabActionPrev.Tab := TabControl1.Tabs[TabControl1.TabIndex - 1]
  else
    ChangeTabActionPrev.Tab := nil;

end;

procedure TfraIntro.TabControl1Paint(Sender: TObject; Canvas: TCanvas;
  const [Ref] ARect: TRectF);
begin
  //TabItem1
  Label1.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  Label4.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  Label5.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  //TabItem10
  Label29.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  Label30.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  Label31.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  fgLinkedLabel1.Color := TAlphaColors.White;
  //TabItem11
  Label34.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  Label36.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  //TabItem12
  Label38.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  Label40.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  //TabItem2
  //    Label8.StyledSettings := [TStyledSetting.FontColor];  -this will color the font Black and ignore the .FontColr.White.
  Label2.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  Label8.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  Label9.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  //TabItem3
  Label33.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  Text1.TextSettings.FontColor := TAlphaColors.White;
  //TabItem5
  Label37.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  Text6.TextSettings.FontColor := TAlphaColors.White;
  fgLinkedLabel2.Color := TAlphaColors.White;
  //TabItem6
  Label39.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  Text8.TextSettings.FontColor := TAlphaColors.White;
  //TabItem7
  Label20.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  Text10.TextSettings.FontColor := TAlphaColors.White;
  //TabItem8
  Label23.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  Text9.TextSettings.FontColor := TAlphaColors.White;
  //TabItem9
  Label26.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  Text11.TextSettings.FontColor := TAlphaColors.White;
  //TabItem
  //TabItem
end;

procedure TfraIntro.TabItem9Paint(Sender: TObject; Canvas: TCanvas;
  const [Ref] ARect: TRectF);
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
  FFrameMain := TfraIntro.Create(Self);
  FFrameMain.Parent := Self;

//  FFrameMain.Layout1.Align := TAlignLayout.None;
  FFrameMain.Tag := Integer(cTag); //uBusiObj.tnUOMUpd);

  // define events
//  FFrameMain.FOnSubmit := @OnSubmit;
  FFrameMain.FOnCloseTab := @OnCloseTab;
  FFrameMain.FOnRegisBtnClick := @OnRegisBtnClick;
end;

destructor TTabOfFrame.Destroy;
begin
  FFrameMain.Free;
  inherited;
end;

procedure TTabOfFrame.ShowTab(ACallerTab: TTabItem);
begin
  FCallerTab := ACallerTab;
//  FFrameMain.FTID := ATID;

  FFrameMain.AnimateTrans(TAnimateRule.arInit);
  TTabControl(Self.Owner).ActiveTab := Self;
//  if FTabItemState.UserIntentCurr = uicAdding then
//    FFrameMain.edtDescript.SetFocus;
  FFrameMain.AnimateTrans(TAnimateRule.arIn);

  // update fields
//  FFrameMain.lblEstabName.Text := AEstabName;
  FFrameMain.TabControl1.ActiveTab := FFrameMain.TabItem1;
end;

end.
