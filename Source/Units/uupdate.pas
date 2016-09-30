unit uUpdate;

{$mode delphi}{$H+}

interface

uses
  GlobalConfig, GlobalConst, GlobalTypes,Classes, SysUtils, Winsock2, FileSystem, Platform, HTTP,
  Devices,Ultibo, Console, FrameBuffer;

type

    { TURLUpdate }
    TURLUpdate = Class(TObject)

    private
      FAutoRestart: Boolean;
      FForce: Boolean;
      FLocalFileName: String;
      FRemoteFileName: String;
      FBak_Extention: String;
      FTmp_Extention: String;
      FUpdate: Boolean;
      WH:TWindowHandle;
    public
      Constructor Create;
      Destructor Destroy;
      function UpdateGet:Boolean;
      function UpdateCheck:Boolean;
    protected

    published
      Property WinHandle : TWindowHandle read wh write wh;
      Property AutoRestart : Boolean read FAutoRestart write FAutoRestart;
      Property Force : Boolean read FForce write FForce;
      Property Update : Boolean read FUpdate write FUpdate;
      Property LocalFileName : String read FLocalFileName write FLocalFileName;
      Property RemoteFileName : String read FRemoteFileName write FRemoteFileName;
      Property Tmp_Extention : String read FTmp_Extention write FTmp_Extention;
      Property Bak_Extention : String read FBak_Extention write FBak_Extention;
end;

//Adjust to your own settings
Const
   sUpdateURL = 'http://192.168.1.100:80/pi_update';
   sUpdateIni = 'version.ini';
   bAutomaticUpdate = True;
   sUpdateFolder = 'update';
   {$IFDEF RPi}
     sLocalFileName = 'kernel.img';
   {$ELSE}
     sLocalFileName = 'kernel7.img';
   {$ENDIF}
   sRemoteFileName = 'http://192.168.1.100/'+sLocalFileName;
   sTmp_Extention = '.tmp';
   sBak_Extention = '.bak';
//No Changes needed after this line

Procedure CheckForUpdate;

implementation

Procedure CheckForUpdate;
Var
  URLUpdate : TURLUpdate;
  TCP : TWinsock2TCPClient;
  IPAddress : String;
begin
  sleep(5000);
  TCP := TWinsock2TCPClient.Create;
  URLUpdate := TURLUpdate.Create;
  try
    IPAddress := TCP.LocalAddress;
    ConsoleWindowWriteLn(URLUpdate.WinHandle,'IP address is ' + IPAddress);
    if (IPAddress = '') or (IPAddress = '0.0.0.0') or (IPAddress = '255.255.255.255') then
    begin
      while (IPAddress = '') or (IPAddress = '0.0.0.0') or (IPAddress = '255.255.255.255') do
        begin
          sleep (100);
          IPAddress := TCP.LocalAddress;
          ConsoleWindowWriteLn(URLUpdate.WinHandle,'IP address is ' + IPAddress);
        end;
    end;
  finally
    TCP.Free;
  end;


   try
    with URLUpdate Do
    Begin
      ConsoleWindowWriteLn(WinHandle,'IP address is ' + IPAddress);
      UpdateGet;

      if Update and AutoRestart then
        SystemRestart(1000);

    End;
   finally
     FreeAndNil(URLUpdate);
   end;
end;


{ TURLUpdate }
constructor TURLUpdate.Create;
begin
  inherited Create;
  FLocalFileName := sLocalFileName;
  FRemoteFileName := sRemoteFileName;
  FTmp_Extention := sTmp_Extention;
  FBak_Extention := sBak_Extention;
  FAutoRestart := bAutomaticUpdate;
  WH := ConsoleWindowCreate(ConsoleDeviceGetDefault,CONSOLE_POSITION_BOTTOMRIGHT,False);
end;

destructor TURLUpdate.Destroy;
begin
 ConsoleWindowDestroy(WH);
 inherited Destroy;
end;

function TURLUpdate.UpdateGet:Boolean;
var
 TempName, BackupName:String;
 FileStream:TFSFileStream;
 HTTPClient:THTTPClient;
begin
 Result:=False;

 {Check Update}
 if UpdateCheck then
  begin
   if FUpdate then
    begin
     {Get Temp Name}
     TempName:=ChangeFileExt(FLocalFileName,FTmp_Extention);
     ConsoleWindowWriteLn(WH,'  Saving update to temporary file ' + TempName);

     {Check Temp File}
     if FSFileExists(TempName) then
      begin
       ConsoleWindowWriteLn(WH,'  Deleting existing temporary file ' + TempName);

       {Temp Backup File}
       FSFileSetAttr(TempName,faNone);
       if not FSDeleteFile(TempName) then Exit;
      end;

     {Create Client}
     HTTPClient:=THTTPClient.Create;
     try
      {Set Receive Size}
      HTTPClient.ReceiveSize:=SIZE_2M; //To Do //This doesn't work until after Connect (Add to TWinsockTCPClient)
      try
       {Create Temp File}
       FileStream:=TFSFileStream.Create(TempName,fmCreate);
       try
        {GET Request}
        if HTTPClient.GetStream(FRemoteFileName,FileStream) then
         begin
          {Check Status}
          case HTTPClient.ResponseStatus of
           HTTP_STATUS_OK:begin
             FUpdate:=True;

             {Set Date/Time}
             FSFileSetDate(FileStream.Handle,FileTimeToFileDate(RoundFileTime(HTTPDateToFileTime(HTTPClient.GetResponseHeader(HTTP_ENTITY_HEADER_LAST_MODIFIED)))));
            end;
           else
            begin
             FUpdate:=False;

             ConsoleWindowWriteLn(WH,'  HTTP GET request not successful (Status=' + HTTPStatusToString(HTTPClient.ResponseStatus) + ' Reason=' + HTTPClient.ResponseReason + ')');
             ConsoleWindowWriteLn(WH,'');
            end;
          end;
         end
        else
         begin
          FUpdate:=False;

          ConsoleWindowWriteLn(WH,'  HTTP GET request failed (Status=' + HTTPStatusToString(HTTPClient.ResponseStatus) + ' Reason=' + HTTPClient.ResponseReason + ')');
          ConsoleWindowWriteLn(WH,'');
         end;
       finally
        FileStream.Free;
       end;
      except
       FUpdate:=False;

       ConsoleWindowWriteLn(WH,'  Failed to create temporary file ' + TempName);
       ConsoleWindowWriteLn(WH,'');
      end;
     finally
      HTTPClient.Free;
     end;

     if FUpdate then
      begin
       {Check Local File}
       if FSFileExists(FLocalFileName) then
        begin
         {Get Backup Name}
         BackupName:=ChangeFileExt(FLocalFileName,FBak_Extention);

         ConsoleWindowWriteLn(WH,'  Saving file ' + FLocalFileName +  ' to backup file ' + BackupName);

         {Check Backup File}
         if FSFileExists(BackupName) then
          begin
           ConsoleWindowWriteLn(WH,'  Deleting existing backup file ' + BackupName);

           {Delete Backup File}
           FSFileSetAttr(BackupName,faNone);
           if not FSDeleteFile(BackupName) then Exit;
          end;

         {Rename Local File}
         if not FSRenameFile(FLocalFileName,BackupName) then Exit;
        end;

       ConsoleWindowWriteLn(WH,'  Saving temporary file ' + TempName +  ' to ' + FLocalFileName);

       {Rename Temporary File}
       if not FSRenameFile(TempName,FLocalFileName) then Exit;

       ConsoleWindowWriteLn(WH,'');
       ConsoleWindowWriteLn(WH,'  Successfully updated ' + FLocalFileName);
      end;

     ConsoleWindowWriteLn(WH,'');
    end;
  end;

 {Return Result}
 Result:=True;
end;

function TURLUpdate.UpdateCheck:Boolean;
var
 LocalSize, RemoteSize:Int64;
 LocalTime, RemoteTime:TDateTime;
 LocalExists, RemoteExists:Boolean;
 SearchRec:TFileSearchRec;
 HTTPClient:THTTPClient;
begin
 {}
 Result:=False;

 {Set Update}
 FUpdate:=False;

 {Check Paths}
 if (Length(FLocalFileName) <> 0) and (Length(FRemoteFileName) <> 0) then
  begin
   {Local File}
   LocalExists:=False;

   ConsoleWindowWriteLn(WH,' Local file is ' + FLocalFileName);

   {Find First}
   if FSFindFirstEx(FLocalFileName,SearchRec) = 0 then
    begin
     LocalExists:=True;

     {Get Size/Time}
     TULargeInteger(LocalSize).HighPart:=SearchRec.FindData.nFileSizeHigh;
     TULargeInteger(LocalSize).LowPart:=SearchRec.FindData.nFileSizeLow;
     LocalTime:=FileTimeToDateTime(SearchRec.FindData.ftLastWriteTime);

     ConsoleWindowWriteLn(WH,'  Size: ' + IntToStr(LocalSize));
     ConsoleWindowWriteLn(WH,'  Modified: ' + DateTimeToStr(LocalTime));
     ConsoleWindowWriteLn(WH,'');

     FSFindCloseEx(SearchRec);
    end
   else
    begin
     ConsoleWindowWriteLn(WH,'  File does not exist');
     ConsoleWindowWriteLn(WH,'');
    end;

   {Remote File}
   RemoteExists:=False;

   ConsoleWindowWriteLn(WH,' Remote file is ' + FRemoteFileName);

   {Create Client}
   HTTPClient:=THTTPClient.Create;
   try
    {HEAD Request}
    if HTTPClient.Head(FRemoteFileName) then
     begin
      {Check Status}
      case HTTPClient.ResponseStatus of
       HTTP_STATUS_OK:begin
         RemoteExists:=True;

         {Get Size/Time}
         RemoteSize:=HTTPClient.ResponseContentSize;
         RemoteTime:=FileTimeToDateTime(RoundFileTime(HTTPDateToFileTime(HTTPClient.GetResponseHeader(HTTP_ENTITY_HEADER_LAST_MODIFIED))));

         ConsoleWindowWriteLn(WH,'  Size: ' + IntToStr(RemoteSize));
         ConsoleWindowWriteLn(WH,'  Modified: ' + DateTimeToStr(RemoteTime));
         ConsoleWindowWriteLn(WH,'');
        end;
       else
        begin
         ConsoleWindowWriteLn(WH,'  HTTP HEAD request not successful (Status=' + HTTPStatusToString(HTTPClient.ResponseStatus) + ' Reason=' + HTTPClient.ResponseReason + ')');
         ConsoleWindowWriteLn(WH,'');
        end;
      end;
     end
    else
     begin
      ConsoleWindowWriteLn(WH,'  HTTP HEAD request failed (Status=' + HTTPStatusToString(HTTPClient.ResponseStatus) + ' Reason=' + HTTPClient.ResponseReason + ')');
      ConsoleWindowWriteLn(WH,'');
     end;
   finally
    HTTPClient.Free;
   end;

   if LocalExists and RemoteExists then
    begin
     if (FForce) then
      begin
       FUpdate:=True;

       ConsoleWindowWriteLn(WH,'  Forcing update');
      end
     else if (LocalSize <> RemoteSize) or (LocalTime <> RemoteTime) then
      begin
       FUpdate:=True;

       ConsoleWindowWriteLn(WH,'  Update is available');
      end
     else
      begin
       ConsoleWindowWriteLn(WH,'  No update available');
      end;
    end
   else if LocalExists and not(RemoteExists) then
    begin
     ConsoleWindowWriteLn(WH,'  No update available');
    end
   else if not(LocalExists) and RemoteExists then
    begin
     FUpdate:=True;

     ConsoleWindowWriteLn(WH,'  Update is available');
    end
   else
    begin
     ConsoleWindowWriteLn(WH,'  No update available');
    end;

   ConsoleWindowWriteLn(WH,'');
  end;

 {Return Result}
 Result:=True;
end;
end.
