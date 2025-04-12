[Setup]
AppName=SongwritersdB
AppVersion=1.0.7
DefaultDirName={pf}\SongwritersdB
DefaultGroupName=SongwritersdB
OutputBaseFilename=SongwritersdB
Compression=lzma
SolidCompression=yes
SetupIconFile=appico.ico
PrivilegesRequired=admin

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
[Files]
; Main application files
Source: "E:\Clones\SWDB\swdb_winproplus_application\MusicApp\bin\x64\Release\SongwritersdB.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "E:\Clones\SWDB\swdb_winproplus_application\MusicApp\bin\x64\Release\*.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "E:\Clones\SWDB\swdb_winproplus_application\MusicApp\bin\x64\Release\*.config"; DestDir: "{app}"; Flags: ignoreversion

; SQLite specific files
Source: "E:\Clones\SWDB\swdb_winproplus_application\MusicApp\bin\x64\Release\System.Data.SQLite.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "E:\Clones\SWDB\swdb_winproplus_application\MusicApp\bin\x64\Release\x86\SQLite.Interop.dll"; DestDir: "{app}\x86"; Flags: ignoreversion
Source: "E:\Clones\SWDB\swdb_winproplus_application\MusicApp\bin\x64\Release\x64\SQLite.Interop.dll"; DestDir: "{app}\x64"; Flags: ignoreversion

; Additional resources
Source: "E:\Clones\SWDB\swdb_winproplus_application\MusicApp\Images\*"; DestDir: "{app}\Assets"; Flags: recursesubdirs ignoreversion
Source: "E:\Clones\SWDB\swdb_winproplus_application\MusicApp\defaultsongs\*"; DestDir: "{app}\Assets"; Flags: recursesubdirs ignoreversion
Source: "E:\Clones\SWDB\InnooScript\WelcomeWizard.txt"; DestDir: "{tmp}"; Flags: dontcopy
Source: "E:\Clones\SWDB\InnooScript\EULA.txt"; DestDir: "{tmp}"; Flags: dontcopy

Source: "E:\Clones\SWDB\swdb_winproplus_application\MusicApp\defaultsongs\*"; DestDir: "{app}\defaultsongs"; Flags: recursesubdirs ignoreversion

[Icons]
Name: "{group}\SongwritersdB"; Filename: "{app}\SongwritersdB.exe"; IconFilename: "{app}\SongwritersdB.exe"
Name: "{commondesktop}\SongwritersdB"; Filename: "{app}\SongwritersdB.exe"; IconFilename: "{app}\SongwritersdB.exe"; Check: CreateDesktopShortcut

[Run]
Filename: "{app}\SongwritersdB.exe"; Description: "Launch SongwritersdB"; Flags: nowait postinstall skipifsilent; Check: AutoRunAfterInstall

[Code]
var
  TermsPage, LicensePage, OptionPage: TWizardPage;
  AgreeCheck: TNewCheckBox;
  TermsMemo: TMemo;
  LicenseMemo: TMemo;
  ShortcutCheck: TNewCheckBox;
  AutoRunCheck: TNewCheckBox;

function CreateDesktopShortcut: Boolean;
begin
  Result := ShortcutCheck.Checked;
end;

function AutoRunAfterInstall: Boolean;
begin
  Result := AutoRunCheck.Checked;
end;

procedure InitializeWizard;
var
  TermsContent: AnsiString;
  LicenseContent: AnsiString;
begin
  { Hide the standard Ready page and Tasks page }
  WizardForm.ReadyLabel.Visible := False;
  WizardForm.ReadyMemo.Visible := False;
  WizardForm.TasksList.Visible := False;
  
  { Terms & Conditions Page }
  TermsPage := CreateCustomPage(wpWelcome, 'Terms & Conditions', 'Please review our Terms & Conditions and Privacy Policy.');
  TermsMemo := TMemo.Create(TermsPage);
  TermsMemo.Parent := TermsPage.Surface;
  TermsMemo.ScrollBars := ssVertical;
  TermsMemo.ReadOnly := True;
  TermsMemo.WordWrap := True;
  TermsMemo.SetBounds(0, 0, TermsPage.SurfaceWidth, TermsPage.SurfaceHeight - 10);

  ExtractTemporaryFile('WelcomeWizard.txt');
  
  if LoadStringFromFile(ExpandConstant('{tmp}\WelcomeWizard.txt'), TermsContent) then
    TermsMemo.Lines.Text := TermsContent
  else
    TermsMemo.Lines.Text := 'Failed to load Terms & Conditions.';

  { License Agreement Page }
  LicensePage := CreateCustomPage(TermsPage.ID, 'License Agreement', 'Please accept the license agreement to continue.');
  LicenseMemo := TMemo.Create(LicensePage);
  LicenseMemo.Parent := LicensePage.Surface;
  LicenseMemo.ScrollBars := ssVertical;
  LicenseMemo.ReadOnly := True;
  LicenseMemo.WordWrap := True;
  LicenseMemo.SetBounds(0, 0, LicensePage.SurfaceWidth, LicensePage.SurfaceHeight - 50);
  
  ExtractTemporaryFile('EULA.txt');
  
  if LoadStringFromFile(ExpandConstant('{tmp}\EULA.txt'), LicenseContent) then
    LicenseMemo.Lines.Text := LicenseContent
  else
    LicenseMemo.Lines.Text := 'Failed to load License Agreement.';

  AgreeCheck := TNewCheckBox.Create(LicensePage);
  AgreeCheck.Parent := LicensePage.Surface;
  AgreeCheck.Caption := 'I agree to the terms of the license agreement';
  AgreeCheck.Left := 0;
  AgreeCheck.Top := LicensePage.SurfaceHeight - 40;
  AgreeCheck.Width := LicensePage.SurfaceWidth - 20;

  { Options Page - replaces the standard Tasks page }
  OptionPage := CreateCustomPage(LicensePage.ID, 'Installation Options', 'Choose additional options.');
  
  ShortcutCheck := TNewCheckBox.Create(OptionPage);
  ShortcutCheck.Parent := OptionPage.Surface;
  ShortcutCheck.Caption := 'Create Desktop Shortcut';
  ShortcutCheck.Checked := True;
  ShortcutCheck.Top := 10;
  ShortcutCheck.Left := 0;
  ShortcutCheck.Width := OptionPage.SurfaceWidth - 20;

  AutoRunCheck := TNewCheckBox.Create(OptionPage);
  AutoRunCheck.Parent := OptionPage.Surface;
  AutoRunCheck.Caption := 'Start application after installation';
  AutoRunCheck.Checked := True;
  AutoRunCheck.Top := 40;
  AutoRunCheck.Left := 0;
  AutoRunCheck.Width := OptionPage.SurfaceWidth - 20;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;

  if CurPageID = LicensePage.ID then
  begin
    if not AgreeCheck.Checked then
    begin
      MsgBox('You must accept the license agreement to continue.', mbError, MB_OK);
      Result := False;
    end;
  end;
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  // Customize the Ready page text if needed
  if CurPageID = wpReady then
  begin
    WizardForm.ReadyLabel.Visible := True;
    WizardForm.ReadyMemo.Visible := True;
    WizardForm.ReadyLabel.Caption := 'Setup is now ready to begin installing SongwritersdB on your computer.';
    WizardForm.ReadyMemo.Text := 'Click Install to continue with the installation, or click Back if you want to review or change any settings.';
  end;
end;