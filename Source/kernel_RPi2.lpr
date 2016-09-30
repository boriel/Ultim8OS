program kernel;

{$mode delphi}{$H+}
{$DEFINE RPi2}

{ Raspberry Pi Application                                                     }
{  Add your program code below, add additional units to the "uses" section if  }
{  required and create new units by selecting File, New Unit from the menu.    }
{                                                                              }
{  To compile your program select Run, Compile (or Run, Build) from the menu.  }

uses
  RaspberryPi2, GlobalConst, SysUtils,Threads,
  Ultibo, Classes, Console,
  SyncObjs, Keyboard,   Serial,  GraphicsConsole,
  HTTP,            {Include the HTTP unit for the server classes}
  Shell,           {Add the Shell unit just for some fun}
  ShellFileSystem, {Plus the File system shell commands}
  RemoteShell, ShellUpdate, uMisc, uMain, uConstants, uGraphics, uUpdate,
  usensehat, uinit,Devices, uHTS221, ulps25h, ulms9ds1;


var

  Main_Thread : TMain_Thread;
  x,y : Word;
  Device:PDevice;
  DeviceTable:PDevice;
Const
  sMesgHello = '\r\nRemote Boot Checkup V1.0\r\n';
  sMesgHalting = '\r\n*** System Restarting ***\r\n';
  Version = 'Version 1.0.0.6';
  //Colours
  BLACK = $657b83;
  WHITE = $fdf6e3;

  Procedure Init_Screen;
  Var
      i : Integer;
  begin
     For i := 0 TO Pred(OS_SCREEN_WIDTH*OS_SCREEN_HEIGHT) Do
     Begin
       ScreenArray[i] := BLACK;
     End;
  end;


begin
    CheckForUpdate;
    WHLoop:= ConsoleWindowCreate(ConsoleDeviceGetDefault,CONSOLE_POSITION_TOPRIGHT,False);
    GH := GraphicsWindowCreate(ConsoleDeviceGetDefault,CONSOLE_POSITION_TOPLEFT);
   // ActivityLEDEnable;
    Init_Screen;
    ConsoleWindowWriteLn(WHLoop,'OS Running' + Version);
    iLoop := 0;



    ConsoleWindowWriteLn(WHLoop,'Prompt :>');
    //Main_Thread := TMain_Thread.Create(False);
    //SetThreadAffinityMask(GetCurrentThread(), 0);
    //SetThreadAffinityMask(Main_Thread.ThreadID, 1);

   // Application.OnMessage := OnAppMessage;
    GraphicsWindowDrawImage(GH, 50, 50, @ScreenArray, OS_SCREEN_WIDTH, OS_SCREEN_HEIGHT,COLOR_FORMAT_UNKNOWN);

   //For x:= 0 to  OS_SCREEN_WIDTH-1 do
   // begin
   //   For y:=0 to OS_SCREEN_HEIGHT-1  do
   //     begin
   //       //PutPixel(x,y,WHITE,ScreenArray);
   //       ConsoleWindowWriteLn(WHLOOP,'X= ' + IntToStr(x) + ' y= ' + IntToStr(y));
  ///        Inc(iLoop);
   //     end;
        //GraphicsWindowDrawImage(GH, 50, 50, @ScreenArray, OS_SCREEN_WIDTH, OS_SCREEN_HEIGHT,COLOR_FORMAT_UNKNOWN);
   // end;

  try
    Device := DeviceTable;
    while Device <> nil do
     begin
      {Check State}
      if Device.DeviceState = DEVICE_STATE_REGISTERED then
       begin
        {Check Description}
        ConsoleWindowWriteLn(WHLoop,Device.DeviceDescription);
       end;

      {Get Next}
      Device:=Device.Next;
     end;
   finally
    {Release the Lock}
    //CriticalSectionUnlock(DeviceTableLock);
   end;


    ConsoleWindowWriteLn(WHLoop,'Flash!!!');
    StartSensorThread;
    ThreadHalt(0);
end.









