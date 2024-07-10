unit uTestDLL;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls,  registry, math
;

type
  TForm1 = class(TForm)
    Pages: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    tsOutput: TTabSheet;
    mLog: TMemo;
    fne: TEdit;
    Button1: TButton;
    mScript: TMemo;
    Label1: TLabel;
    Panel1: TPanel;
    Button2: TButton;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private

  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  StmtCount : integer;
  ErrCount : integer;

type

  TConnectErrorCallbackFunc = function (AErrorMessage : PChar) : integer;  stdcall;
  TScriptErrorCallbackFunc = function (AStmtText, AErrMessage : PChar) : integer; stdcall;
  TScriptBeforeExecStatementFunc = function (AStmtText, AText : PChar) : integer; stdcall;
  TScriptAfterExecStatementFunc = function (AStmtText : PChar; Success : integer) : integer; stdcall;

  TExecuteScriptProc = procedure (AScriptFile : PChar;
                                  AErrorCallbackFunc : TScriptErrorCallbackFunc;
                                  ABeforeCallbackFunc : TScriptBeforeExecStatementFunc;
                                  AAfterCallbackFunc : TScriptAfterExecStatementFunc); stdcall;

  TConnectDBProc = function (AConnectParams : PChar;
                             AConnectErrorCallbacFunc : TConnectErrorCallbackFunc) : integer; stdcall;


function HandleError(AStmtText, AErrMessage : PChar) : integer; stdcall;
function BeforeExec(AStmtText, AText : PChar) : integer; stdcall;
function AfterExec(AStmtText : PChar; Success : integer) : integer; stdcall;
function CEH(AErrorMessage : PChar) : integer;  stdcall;

implementation

{$R *.DFM}

function HandleError(AStmtText, AErrMessage : PChar) : integer; stdcall;
begin
  Result := 0;
  Inc(ErrCount);
  Form1.mLog.Lines.Add('------- STATEMENT --------');
  Form1.mLog.Lines.Add(AStmtText);
  Form1.mLog.Lines.Add('-------   ERROR   --------');
  Form1.mLog.Lines.Add(AErrMessage);
end;

function BeforeExec(AStmtText, AText : PChar) : integer; stdcall;
begin
  Result := 0;
  Form1.mLog.Lines.Add(AText);
end;

function AfterExec(AStmtText : PChar; Success : integer) : integer; stdcall;
begin
  Result := 0;
  if Success = 1 then
    Inc(StmtCount)
  else
    Result := 1; // Abort script execution
end;

function CEH(AErrorMessage : PChar) : integer;  stdcall;
begin
  ShowMessage(AErrorMessage);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  Hndl : THandle;
  ESP : TExecuteScriptProc;
begin
  ErrCount := 0;
  StmtCount := 0;
  mLog.Lines.Clear;
  if Trim(fne.Text) = '' then
  begin
    ShowMessage('Script file is not specified!');
    Exit;
  end;
  if not FileExists(Trim(fne.Text)) then
  begin
    ShowMessage('File doesn''t exist!');
    Exit;
  end;
  Hndl := LoadLibrary(PChar('IBEScript.dll'));
  try
    if (Hndl > HINSTANCE_ERROR) then
    begin
      ESP := GetProcAddress(Hndl, 'ExecScriptFile');
      if @ESP <> nil then
      begin
        Pages.ActivePage := tsOutput;
        ESP(PChar(fne.Text), @HandleError, @BeforeExec, @AfterExec);
      end;
    end;
  finally
    if Hndl > HINSTANCE_ERROR then
      FreeLibrary(Hndl);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Hndl : THandle;
  ESP : TExecuteScriptProc;
  s : string;
  Res : integer;
begin
  ErrCount := 0;
  StmtCount := 0;
  mLog.Lines.Clear;
  s := mScript.Text;
  if Trim(s) = '' then
  begin
    ShowMessage('Nothing to do!');
    Exit;
  end;
  try
    Hndl := LoadLibrary(PChar('IBEScript.dll'));
    if (Hndl > HINSTANCE_ERROR) then
    begin
      ESP := GetProcAddress(Hndl, 'ExecScriptText');
      if @ESP <> nil then
      begin
        Pages.ActivePage := tsOutput;
        ESP(PChar(s), @HandleError, @BeforeExec, @AfterExec);
      end;
    end;
  finally
    if Hndl > HINSTANCE_ERROR then
      FreeLibrary(Hndl);
  end;
end;


end.
