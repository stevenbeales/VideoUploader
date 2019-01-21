object FormMain: TFormMain
  Left = 643
  Top = 101
  AlphaBlend = True
  BorderStyle = bsDialog
  Caption = 'Video and Scoresheet Uploader'
  ClientHeight = 651
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object LabelSubjectNumber: TLabel
    Left = 25
    Top = 25
    Width = 97
    Height = 16
    Caption = 'Subject Number:'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    Font.Quality = fqDraft
    ParentColor = False
    ParentFont = False
  end
  object LabelSubjectNumberHelp: TLabel
    Left = 116
    Top = 55
    Width = 113
    Height = 16
    Caption = '(5 digits like 00001)'
    Color = clBtnFace
    ParentColor = False
  end
  object GroupBoxScoreSheets: TGroupBox
    Left = 22
    Top = 88
    Width = 340
    Height = 252
    Caption = 'Scoresheets:'
    TabOrder = 1
    object LabelSubjectNumber1: TLabel
      Left = 6
      Top = 28
      Width = 64
      Height = 16
      Caption = 'ADAS-Cog:'
      Color = clBtnFace
      ParentColor = False
    end
    object LabelSubjectNumber2: TLabel
      Left = 6
      Top = 86
      Width = 64
      Height = 16
      Caption = 'ADCS-ACL:'
      Color = clBtnFace
      ParentColor = False
    end
    object LabelSubjectNumber3: TLabel
      Left = 6
      Top = 138
      Width = 40
      Height = 16
      Caption = 'MMSE:'
      Color = clBtnFace
      ParentColor = False
    end
    object LabelSubjectNumber4: TLabel
      Left = 6
      Top = 190
      Width = 49
      Height = 16
      Caption = 'CDR-SB:'
      Color = clBtnFace
      ParentColor = False
    end
    object SpeedButton1: TSpeedButton
      Left = 295
      Top = 25
      Width = 23
      Height = 22
      Action = FileOpen1
    end
    object SpeedButton2: TSpeedButton
      Left = 295
      Top = 83
      Width = 23
      Height = 22
      Action = FileOpen2
    end
    object SpeedButton3: TSpeedButton
      Left = 295
      Top = 135
      Width = 23
      Height = 22
      Action = FileOpen3
    end
    object SpeedButton4: TSpeedButton
      Left = 295
      Top = 187
      Width = 23
      Height = 22
      Action = FileOpen4
    end
    object FileNameEdit1: TEdit
      Left = 86
      Top = 25
      Width = 203
      Height = 24
      TabOrder = 0
    end
    object FileNameEdit2: TEdit
      Left = 86
      Top = 83
      Width = 203
      Height = 24
      TabOrder = 1
    end
    object FileNameEdit3: TEdit
      Left = 86
      Top = 135
      Width = 203
      Height = 24
      TabOrder = 2
    end
    object FileNameEdit4: TEdit
      Left = 86
      Top = 187
      Width = 203
      Height = 24
      TabOrder = 3
    end
  end
  object EditSubjectNumber: TEdit
    Left = 24
    Top = 48
    Width = 80
    Height = 24
    TabOrder = 0
  end
  object UploadButton: TButton
    Left = 264
    Top = 608
    Width = 108
    Height = 30
    Action = ActionUploadFiles
    TabOrder = 3
  end
  object ProgressBarUpload: TProgressBar
    Left = 24
    Top = 608
    Width = 217
    Height = 30
    ParentShowHint = False
    Smooth = True
    Step = 1
    ShowHint = False
    TabOrder = 4
  end
  object GroupBoxVideo: TGroupBox
    Left = 22
    Top = 349
    Width = 350
    Height = 250
    Caption = 'Videos:'
    TabOrder = 2
    object ListBoxVideos: TListBox
      Left = 2
      Top = 18
      Width = 346
      Height = 230
      Align = alClient
      Sorted = True
      TabOrder = 0
      OnDblClick = ListBoxVideosDblClick
    end
  end
  object ActionList1: TActionList
    Left = 281
    Top = 59
    object ActionUploadFiles: TAction
      Caption = '&Upload Files'
      ShortCut = 16469
      OnExecute = ActionUploadFilesExecute
      OnUpdate = ActionUploadFilesUpdate
    end
    object FileOpen1: TFileOpen
      Caption = '...'
      Dialog.Filter = 'PDF Files|*.PDF|Word Files|*.docx;*.doc|All Files|*.*'
      Hint = 'Open|Opens an existing file'
      ImageIndex = 7
      ShortCut = 16463
      OnAccept = FileOpen1Accept
    end
    object FileOpen2: TFileOpen
      Caption = '...'
      Dialog.Filter = 'PDF Files|*.PDF|Word Files|*.docx;*.doc|All Files|*.*'
      Hint = 'Open|Opens an existing file'
      ImageIndex = 7
      ShortCut = 16463
      OnAccept = FileOpen2Accept
    end
    object FileOpen3: TFileOpen
      Caption = '...'
      Dialog.Filter = 'PDF Files|*.PDF|Word Files|*.docx;*.doc|All Files|*.*'
      Hint = 'Open|Opens an existing file'
      ImageIndex = 7
      ShortCut = 16463
      OnAccept = FileOpen3Accept
    end
    object FileOpen4: TFileOpen
      Caption = '...'
      Dialog.Filter = 'PDF Files|*.PDF|Word Files|*.docx;*.doc|All Files|*.*'
      Hint = 'Open|Opens an existing file'
      ImageIndex = 7
      ShortCut = 16463
      OnAccept = FileOpen4Accept
    end
  end
end
