unit ufEstabComp;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FMX.ListBox, FMX.Edit, uBusiObj,
  FMX.TabControl;

const
  cTabName = 'TabEstabComp';
  cHeaderTitle = 'Complaint';
  cTag = uBusiObj.tnEstabComp;

type
  TfraEstabComp = class(TFrame)
    ToolBar1: TToolBar;
    btnCancel: TSpeedButton;
    lblHeaderTItle: TLabel;
    Layout1: TLayout;
    lblEstabName: TLabel;
    Label1: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    FOnCloseTab: ^TProc;
    FOnSubmit: ^TProc;
    procedure AnimateTrans(AAnimateRule: TAnimateRule);
  public
    { Public declarations }
//    procedure PopuUI;
  end;

  TTabOfFrame = class(TTabItem)
  strict private
    FOnCloseTab: TProc; //<TObject>;
    FOnSubmit: TProc;
  private
//    FRecID: integer;
  public
    FCallerTab: TTabItem;
    FFrameMain: TfraEstabComp;
    property OnSubmit: TProc read FOnSubmit write FOnSubmit;
    property OnCloseTab: TProc read FOnCloseTab write FOnCloseTab;
    constructor Create(AOwner: TComponent); // supply various params here. AReccordID: integer); // ; AUserRequest: TUserRequest
    destructor Destroy; override;
    procedure CloseTab(AIsRelease: Boolean);
    procedure ShowTab(ACallerTab: TTabItem; AEstabName: string); //; AUserRequest: TUserIntentInit;      ATID, ACarID: integer);
  end;

implementation

{$R *.fmx}

{ TfraEstabComp }

procedure TfraEstabComp.AnimateTrans(AAnimateRule: TAnimateRule);
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
  FFrameMain := TfraEstabComp.Create(Self);
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

procedure TTabOfFrame.ShowTab(ACallerTab: TTabItem; AEstabName: string);
begin
  FCallerTab := ACallerTab;
//  FFrameMain.FTID := ATID;

  FFrameMain.AnimateTrans(TAnimateRule.arInit);
  TTabControl(Self.Owner).ActiveTab := Self;
//  if FTabItemState.UserIntentCurr = uicAdding then
//    FFrameMain.edtDescript.SetFocus;
  FFrameMain.AnimateTrans(TAnimateRule.arIn);

  // update fields
  FFrameMain.lblEstabName.Text := AEstabName;
end;

procedure TfraEstabComp.btnCancelClick(Sender: TObject);
begin
  AnimateTrans(TAnimateRule.arOut);  // animate the main tab
  TTabOfFrame(Owner).CloseTab(false);
end;

procedure TfraEstabComp.Button3Click(Sender: TObject);
begin
  ShowMessage('Complaint/Comment submitted.');
  AnimateTrans(TAnimateRule.arOut);  // animate the main tab
  TTabOfFrame(Owner).CloseTab(false);
end;

end.
