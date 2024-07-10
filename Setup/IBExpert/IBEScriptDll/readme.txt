1. IBEScript.dll exports following functions:

   * ExecScriptFile - executes script from file
     
   * ExecScriptText - executes script from string buffer
  
   * Connect - connects to the database if there is no CONNECT 
               statement in script



2. Examples of usage of ExecScriptFile and ExecScriptText - 
   see demo application. 


3. Example of usage of Connect function:


procedure TForm1.Button2Click(Sender: TObject);
var
  Hndl : THandle;
  ESP : TExecuteScriptProc;
  CP : TConnectDBProc;
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
      CP := GetProcAddress(Hndl, 'Connect');
      if (@ESP <> nil) and (@CP <> nil) then
      begin
        Pages.ActivePage := tsOutput;
        Res := CP(PChar('db_name=localhost:c:\empty.fdb; password=masterkey; user_name=SYSDBA;' +
                        'lc_ctype=win1251; sql_role_name=ADMIN; sql_dialect=3;' +
                        'clientlib="c:\program files\firebird\bin\fbclient.dll"'), @CEH);
        if Res = 0 then
          ESP(PChar(s), @HandleError, @BeforeExec, @AfterExec);
      end;
    end;
  finally
    if Hndl > HINSTANCE_ERROR then
      FreeLibrary(Hndl);
  end;
end;

   