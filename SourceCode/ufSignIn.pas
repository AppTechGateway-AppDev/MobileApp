unit ufSignIn;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListBox, FMX.Edit, FMX.Layouts, FMX.Controls.Presentation, uBusiObj,
  FMX.TabControl;

const
  cTabName = 'TabSignIn';
  cHeaderTitle = 'Sign In';
  cTag = uBusiObj.tnSignIn;

type
  TfraSignIn = class(TFrame)
    ToolBar1: TToolBar;
    btnCancel: TSpeedButton;
    lblHeaderTItle: TLabel;
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    edtEmail: TEdit;
    ListBoxItem5: TListBoxItem;
    edtPassword: TEdit;
    ListBoxGroupFooter1: TListBoxGroupFooter;
    ListBoxItem7: TListBoxItem;
    Layout1: TLayout;
    Label6: TLabel;
    Label2: TLabel;
    chkbxShowPass: TCheckBox;
    btnSubmit: TButton;
    procedure chkbxShowPassChange(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FramePaint(Sender: TObject; Canvas: TCanvas;
      const [Ref] ARect: TRectF);
    procedure btnSubmitClick(Sender: TObject);
  private
    { Private declarations }
    FOnCloseTab: ^TProc;
    FOnSubmit: ^TProc;
  public
    { Public declarations }
    procedure AnimateTrans(AAnimateRule: TAnimateRule);
  end;

  TTabOfFrame = class(TTabItem)
  strict private
    FOnCloseTab: TProc; //<TObject>;
    FOnSubmit: TProc;
  private
//    FRecID: integer;
  public
    FCallerTab: TTabItem;
    FFrameMain: TfraSignIn;
    property OnSubmit: TProc read FOnSubmit write FOnSubmit;
    property OnCloseTab: TProc read FOnCloseTab write FOnCloseTab;
    constructor Create(AOwner: TComponent); // supply various params here. AReccordID: integer); // ; AUserRequest: TUserRequest
    destructor Destroy; override;
    procedure CloseTab(AIsRelease: Boolean);
    procedure ShowTab(ACallerTab: TTabItem); //; AUserRequest: TUserIntentInit;      ATID, ACarID: integer);
  end;

implementation

{$R *.fmx}

procedure TfraSignIn.AnimateTrans(AAnimateRule: TAnimateRule);
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

procedure TfraSignIn.btnCancelClick(Sender: TObject);
begin
  AnimateTrans(TAnimateRule.arOut);  // animate the main tab
  TTabOfFrame(Owner).CloseTab(false);
end;

procedure TfraSignIn.btnSubmitClick(Sender: TObject);
begin
  AnimateTrans(TAnimateRule.arOut);  // animate the main tab
  TTabOfFrame(Owner).CloseTab(false);
end;

procedure TfraSignIn.chkbxShowPassChange(Sender: TObject);
begin
  edtPassword.Password := not chkbxShowPass.IsChecked;
end;

procedure TfraSignIn.FramePaint(Sender: TObject; Canvas: TCanvas;
  const [Ref] ARect: TRectF);
begin
  Label2.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  Label6.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  chkbxShowPass.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
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
  FFrameMain := TfraSignIn.Create(Self);
  FFrameMain.Parent := Self;

//  FFrameMain.Layout1.Align := TAlignLayout.None;
  FFrameMain.Tag := Integer(cTag); //uBusiObj.tnUOMUpd);

  // define events
  FFrameMain.FOnSubmit := @OnSubmit;
  FFrameMain.FOnCloseTab := @OnCloseTab;
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
end;

end.
