program AppTech;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {fMain},
  ufQMultSele in 'ufQMultSele.pas' {fraQMultSele: TFrame},
  uBusiObj in 'uBusiObj.pas',
  ufQYesNo in 'ufQYesNo.pas' {fraQYesNo: TFrame},
  JsonDataObjects in 'E:\Program Files\RADStudio\JsonDataObjects-master\Source\JsonDataObjects.pas',
  ufEstabList in 'ufEstabList.pas' {fraEstabList: TFrame},
  ufEstabMenu in 'ufEstabMenu.pas' {fraEstabMenu: TFrame},
  ufEstabMap in 'ufEstabMap.pas' {fraEstabMap: TFrame},
  ufEstabComp in 'ufEstabComp.pas' {fraEstabComp: TFrame},
  ufUserRegis in 'ufUserRegis.pas' {fraUserRegis: TFrame},
  ufSignIn in 'ufSignIn.pas' {fraSignIn: TFrame},
  ufIntro in 'ufIntro.pas' {fraIntro: TFrame},
  ufAbout in 'ufAbout.pas' {fraAbout: TFrame},
  uAppVersion in 'uAppVersion.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
