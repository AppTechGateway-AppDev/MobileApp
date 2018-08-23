unit ufUserRegis;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, uBusiObj, FMX.ListBox, FMX.TabControl,
  FMX.Edit, FMX.ScrollBox, FMX.Memo, FMX.TMSBaseControl, FGX.LinkedLabel,
  System.IniFiles;

const
  cTabName = 'TabUserRegis';
  cHeaderTitle = 'User Registration';
  cTag = uBusiObj.tnUserRegis;

type
  TfraUserRegis = class(TFrame)
    ToolBar1: TToolBar;
    btnCancel: TSpeedButton;
    lblHeaderTItle: TLabel;
    Layout1: TLayout;
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    edtEmail: TEdit;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    edtFullName: TEdit;
    edtRingerPIN: TEdit;
    edtShortName: TEdit;
    edtRetypePassword: TEdit;
    ListBoxItem6: TListBoxItem;
    edtPassword: TEdit;
    chkbxShowPass: TCheckBox;
    ListBoxGroupFooter1: TListBoxGroupFooter;
    ListBoxItem7: TListBoxItem;
    ListBoxItem8: TListBoxItem;
    chkbxIHaveRead: TCheckBox;
    btnSubmit: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ListBoxItem9: TListBoxItem;
    Label8: TLabel;
    Edit1: TEdit;
    fgLinkedLabel2: TfgLinkedLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure chkbxShowPassChange(Sender: TObject);
    procedure btnSubmitClick(Sender: TObject);
    procedure FramePaint(Sender: TObject; Canvas: TCanvas;
      const [Ref] ARect: TRectF);
    procedure chkbxIHaveReadChange(Sender: TObject);
  private
    { Private declarations }
    FOnCloseTab: ^TProc;
    FOnSubmit: ^TProc;
  public
    { Public declarations }
    procedure AnimateTrans(AAnimateRule: TAnimateRule);
    procedure SaveRegisToIni;
  end;

  TTabOfFrame = class(TTabItem)
  strict private
    FOnCloseTab: TProc; //<TObject>;
    FOnSubmit: TProc;
  private
//    FRecID: integer;
  public
    FCallerTab: TTabItem;
    FFrameMain: TfraUserRegis;
    property OnSubmit: TProc read FOnSubmit write FOnSubmit;
    property OnCloseTab: TProc read FOnCloseTab write FOnCloseTab;
    constructor Create(AOwner: TComponent); // supply various params here. AReccordID: integer); // ; AUserRequest: TUserRequest
    destructor Destroy; override;
    procedure CloseTab(AIsRelease: Boolean);
    procedure ShowTab(ACallerTab: TTabItem); //; AUserRequest: TUserIntentInit;      ATID, ACarID: integer);
  end;

implementation

{$R *.fmx}

procedure TfraUserRegis.AnimateTrans(AAnimateRule: TAnimateRule);
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

procedure TfraUserRegis.btnCancelClick(Sender: TObject);
begin
  AnimateTrans(TAnimateRule.arOut);  // animate the main tab
  TTabOfFrame(Owner).CloseTab(false);
end;

procedure TfraUserRegis.btnSubmitClick(Sender: TObject);
begin
  SaveRegisToIni;
  ShowMessage('Registration submitted.');
  AnimateTrans(TAnimateRule.arOut);  // animate the main tab
  TTabOfFrame(Owner).CloseTab(false);
end;

procedure TfraUserRegis.chkbxIHaveReadChange(Sender: TObject);
begin
  btnSubmit.Enabled := chkbxIHaveRead.IsChecked;
end;

procedure TfraUserRegis.chkbxShowPassChange(Sender: TObject);
begin
  edtPassword.Password := not chkbxShowPass.IsChecked;
  edtRetypePassword.Password := not chkbxShowPass.IsChecked;
end;

procedure TfraUserRegis.FramePaint(Sender: TObject; Canvas: TCanvas;
  const [Ref] ARect: TRectF);
begin
//  Label1.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  Label2.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  Label3.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  Label4.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  Label5.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  Label6.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  Label7.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  Label8.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  chkbxShowPass.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  chkbxIHaveRead.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  fgLinkedLabel2.Color := TAlphaColors.White;
end;

procedure TfraUserRegis.SaveRegisToIni;
var
  lIniFile: TIniFile;
begin
  lIniFile := TIniFile.Create(GetIniFullFileName);  // uses Forms
  try
    lIniFile.WriteBool('Regis', 'IsShowIntro', false);
    lIniFile.WriteInteger('Regis', 'RegisID', -2);                // from Leo's API.  -2=temp value.
    lIniFile.WriteString('Regis', 'Password', edtPassword.Text);
    lIniFile.WriteString('Regis', 'FullName', edtFullName.Text);
    lIniFile.WriteString('Regis', 'ShortName', edtShortName.Text);
    lIniFile.WriteString('Regis', 'Email', edtEmail.Text);

    lIniFile.WriteString('Ringer', 'RingPIN', edtRingerPIN.Text)
  finally
    lIniFile.Free;
  end;
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
  FFrameMain := TfraUserRegis.Create(Self);
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
