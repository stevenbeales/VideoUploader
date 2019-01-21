unit Main;


interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, filethread,
  StdCtrls, ExtCtrls, Menus, ActnList, Buttons, ComCtrls, Vcl.Dialogs,
  Vcl.StdActns, resourcethread;

type

  { TFormMain }

  TFormMain = class(TForm)
    ActionUploadFiles: TAction;
    ActionList1: TActionList;
    GroupBoxScoreSheets: TGroupBox;
    GroupBoxVideo: TGroupBox;
    LabelSubjectNumber1: TLabel;
    LabelSubjectNumber2: TLabel;
    LabelSubjectNumber3: TLabel;
    LabelSubjectNumber4: TLabel;
    ListBoxVideos: TListBox;
    ProgressBarUpload: TProgressBar;
    UploadButton: TButton;
    EditSubjectNumber: TEdit;
    LabelSubjectNumberHelp: TLabel;
    LabelSubjectNumber: TLabel;
    FileNameEdit1: TEdit;
    FileNameEdit2: TEdit;
    FileNameEdit3: TEdit;
    FileNameEdit4: TEdit;
    SpeedButton1: TSpeedButton;
    FileOpen1: TFileOpen;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    FileOpen2: TFileOpen;
    FileOpen3: TFileOpen;
    FileOpen4: TFileOpen;
    procedure ActionUploadFilesExecute(Sender: TObject);
    procedure ActionUploadFilesUpdate(Sender: TObject);
    procedure ListBoxVideosDblClick(Sender: TObject);
    procedure FileOpen1Accept(Sender: TObject);
    procedure FileOpen2Accept(Sender: TObject);
    procedure FileOpen3Accept(Sender: TObject);
    procedure FileOpen4Accept(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { private declarations }
    FSiteNumber: ansistring;
    FVideoFinder: TFileThread;
    FResourceFinder: TResourceThread;

    function ValidationFails: boolean;
    procedure ProcessScoreSheets(const Filename: ansiString; counter: integer);
    procedure ProcessVideos(const droppedFile: ansiString; counter: integer);
    function EncodeFile(const programName: ansistring): boolean;
    procedure UploadFile(const programName: ansistring; counter: integer);
  public
    { public declarations }

  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}
{$R VideoUpload.res}

uses
  Types, uFileInfo,  Windows, AnsiStrings, RVMUtils, RVMConsts;


function TFormMain.ValidationFails: boolean;
begin
  result := false;
  if (editSubjectNumber.Text = '') then
  begin
    Application.MessageBox('Please enter the Subject Number before uploading the video file.', pchar(caption), 0);
    result := true;
  end;

  if not result and (length(editSubjectNumber.Text) <> SUBJECTNUMBERLENGTH)  then
  begin
    Application.MessageBox(pchar(Format('Subject Number must contain %s characters e.g. 00176', [SUBJECTNUMBERLENGTH])), pchar(caption), 0);
    result := true;
  end;
end;

{ TFormMain }
procedure TFormMain.ProcessScoreSheets(const Filename: ansiString; counter: integer);
var
  inputfile, outputfile: ansistring;
begin
  if ValidationFails then
    exit;

  inputfile := AnsiStrings.extractfilepath(ansistring(paramstr(0))) + AnsiStrings.extractfilename(filename);

  case counter of
  0:  outputfile :=  GetPrefix(FsiteNumber, editsubjectnumber.Text)  + 'ADASCOG' + AnsiStrings.ExtractFileExt(Filename);
  1:  outputfile :=  GetPrefix(FsiteNumber, editsubjectnumber.Text) + 'ADCSACL' + AnsiStrings.ExtractFileExt(Filename);
  2:  outputfile :=  GetPrefix(FsiteNumber, editsubjectnumber.Text) + 'MMSE' + AnsiStrings.ExtractFileExt(Filename);
  3:  outputfile :=  GetPrefix(FsiteNumber, editsubjectnumber.Text) + 'CDRSB' + AnsiStrings.ExtractFileExt(Filename);
  end;

  CopyFile(PWideChar(widestring(filename)), PWideChar(widestring(inputfile)), true);

  UploadFile(AnsiStrings.extractfilepath(ansistring(paramstr(0))) + 'sftp.bat "'  + inputfile + '" "' +
    outputfile + '"', counter);
  ProgressBarUpload.StepIt;
end;

procedure TFormMain.ProcessVideos(const droppedFile: ansiString; counter: integer);
var
  outputfile: ansistring;
begin
  if ValidationFails then
    exit;

  outputfile :=  GetOutputFileName(FSiteNUmber, editsubjectnumber.Text, counter);

  if EncodeFile(extractfilepath(ansistring(paramstr(0))) + 'compress.bat "' + droppedfile + '" "' + outputfile +'"') then
    UploadFile(extractfilepath(ansistring(paramstr(0))) + 'sftp.bat ' + '"' + extractfilepath(ansistring(paramstr(0))) + outputfile +
  '" "' + outputfile + '"', VIDEO);
end;

procedure TFormMain.FormActivate(Sender: TObject);
begin
  FVideoFinder.Execute;
  FSiteNumber := readsitenumberfromfile;
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FResourceFinder.RemoveResourceFiles;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  FVideoFinder := TFileThread.create(true);
  FResourceFinder := TResourceThread.create(true);
end;

procedure TFormMain.ActionUploadFilesUpdate(Sender: TObject);
const
  SCORESHEETS = 4;
  RESOURCEFILES = 6;
begin
  if FVideoFinder.Suspended and (ListBoxVideos.Items.count = 0)  then
    ListBoxVideos.Items.AddStrings(FVideoFinder.VideoFiles);

  ActionUploadFiles.Enabled :=  (FileNameEdit1.Text <> '')
 and (FileNameEdit2.Text <> '') and (FileNameEdit3.Text <> '') and (FileNameEdit4.Text <> '') and
       (length(editSubjectNumber.Text) = SUBJECTNUMBERLENGTH) and (ListBoxVideos.Items.Count > 0);
  ProgressBarUpload.Max := listboxvideos.Count + SCORESHEETS + RESOURCEFILES;
end;


procedure TFormMain.ActionUploadFilesExecute(Sender: TObject);
var
  i: integer;
begin
  screen.Cursor := crhourglass;
  try
    FResourceFinder.Execute;
    if  listboxvideos.Count > 0 then
    begin
      for i:= 0 to pred(listboxvideos.Count) do
      begin
        ProcessVideos(ansistring(listboxvideos.items[i]), i);
        ProgressBarUpload.StepIt;
      end;
    end;
    ProcessScoreSheets(ansistring(FilenameEdit1.Text), 0);
    ProgressBarUpload.StepBy(1);

    ProcessScoreSheets(ansistring(FilenameEdit2.Text), 1);
    ProgressBarUpload.StepBy(1);

    ProcessScoreSheets(ansistring(FilenameEdit3.Text), 2);
    ProgressBarUpload.StepBy(1);

    ProcessScoreSheets(ansistring(FilenameEdit4.Text), 3);

  finally
    screen.Cursor := crdefault;
  end;
end;



procedure TFormMain.ListBoxVideosDblClick(Sender: TObject);
    var SelectedFile : string;
    Rec          : TSearchRec;
    frInfo       : TfrFileInfo;
begin
  SelectedFile := ListBoxVideos.Items.Strings[ListBoxVideos.ItemIndex];
  if FindFirst(SelectedFile, faAnyFile, Rec) = 0 then
 begin
  frInfo := TfrFileInfo.Create(Self);
  try
    frInfo.lblFile.Caption := SelectedFile;
    frInfo.lblname.Caption := Rec.name;
    frInfo.lblSize.Caption := Format('%d bytes',[Rec.Size]);
    frInfo.lblModified.Caption := DateToStr(Rec.TimeStamp);
    frInfo.lblShortName.Caption := Rec.FindData.cAlternateFileName;
    frInfo.ShowModal;
  finally
    frInfo.Free;
  end;
  SysUtils.FindClose(Rec)
 end;
end;

function TFormMain.EncodeFile(const programName: ansistring): boolean;
begin
  ExecNewProcess(programName, true);
  result := true;
end;


procedure TFormMain.UploadFile(const programName: ansistring; counter: integer);
begin
  //is it a video - wait for video uploading to finish
  if counter = VIDEO then
  begin
    ExecNewProcess(programName, true);
  end
  else //is it any document but the last, upload without waiting
  if counter < (NUMBEROFDOCS - 1) then
  begin
    ExecNewProcess(programName, false);
  end  //last document - wait and quit
  else begin
    ExecNewProcess(programName, true);
    ProgressBarUpload.StepBy(3);
    ExecNewProcess(extractfilepath(ansistring(paramstr(0))) + 'cleanup.bat', true);
    FResourceFinder.RemoveResourceFiles;
    ProgressBarUpload.StepBy(1);
    Application.MessageBox('All uploads completed successfully.  Video Uploader will now close.', pwidechar(caption), 0);
    Application.Terminate;
   end;
end;




procedure TFormMain.FileOpen1Accept(Sender: TObject);
begin
  FileNameEdit1.Text := fileopen1.Dialog.FileName;
end;

procedure TFormMain.FileOpen2Accept(Sender: TObject);
begin
  FileNameEdit2.Text := fileopen2.Dialog.FileName;
end;

procedure TFormMain.FileOpen3Accept(Sender: TObject);
begin
  FileNameEdit3.Text := fileopen3.Dialog.FileName;
end;

procedure TFormMain.FileOpen4Accept(Sender: TObject);
begin
  FileNameEdit4.Text := fileopen4.Dialog.FileName;
end;

end.

