unit usensehat;

{$mode delphi}

interface

uses
  GlobalConfig, GlobalConst, GlobalTypes, Classes, SysUtils, Winsock2,
  FileSystem, Platform, Devices, Ultibo, Console, FrameBuffer, Threads, Font,
  Syncobjs,uhts221,ulps25h,ulms9ds1;

Type
   TOrientation = Class(TObject)
      Pitch : Double;
      Roll : Double;
      Yaw : Double;
   end;
Type
   TColor = Array[0..2] of Integer;

Type
   TLED8x8 = Array[0..63] of TColor;

Type

   { TSenseHat }

   TSenseHat = Class(TObject)

   private
      FLock:TCriticalSection;
      HumiditySensor : THumiditySensor;
   public
      Constructor Create;
      Destructor Destroy; override;
      //Set pixels to Create an image
      Procedure Set_Pixels(aPixels : TLED8x8);
      //Load an Image
      Procedure Load_Image(sFileName : String;cRGB : TColor);
      //Get Pixel Position
      Function Get_Pixels : TLED8x8;
      //Clear all Pixels
      Procedure Clear; overload;
      Procedure Clear(cRGB : TColor);overload;
      Procedure Clear(iRed,iGreen,iBlue : Integer);overload;
      //Rotate LEDS
      Procedure Set_Rotation(dAngle : Double);
      //Flip LEDS Horizonatally
      Procedure Flip_H;
      //FLIP LEDS Vertically
      Procedure Flip_V;
      //Scroll a Message
      Procedure Show_Message(sMsg : String; cRGB : TColor);
      //Show a Single Letter
      Procedure Show_Letter(sLetter : Char);
      //Get Humidity
      Function Get_Humidity : Double;
      //Get Current Temperature
      Function Get_Temperature : Double;
      //Get Current Pressure
      Function Get_Pressure : Double;
      //Get Orientation Radians
      Function Get_Orientation_Radians : TOrientation;
      //Get Orientation Degrees
      Function Get_Orientation_Degrees : TOrientation;
      //Get Orientation
      Function Get_Orientation : TOrientation;
      //Get Compass Reading
      Function Get_Compass : Double;
      //Get Gyroscope Reading
      Function Get_Gyroscope : TOrientation;
      //Get Acceleration
      Function Get_Accelerometer : TOrientation;
   end;

type

      { TSensorThread }

      TSensorThread = Class(TThread)
      private
        FData : TSenseHat;
      public
        Constructor Create(aData : TSenseHat);
      protected

        Procedure Execute; override;
      end;

var
    SenseHat : TSenseHat;
    SensorWindow:THandle;
Procedure StartSensorThread;


implementation

{ TSensorThread }

constructor TSensorThread.Create(aData: TSenseHat);
begin
  FData:=AData;
  inherited Create(False,THREAD_STACK_DEFAULT_SIZE);
end;

procedure TSensorThread.Execute;
var
 dTemp:Double;
begin
 {Free this thread when it terminates}
 FreeOnTerminate:=True;

 {Set the name of the thread}
 ThreadSetName(ThreadGetCurrent,'SenseHat Thread');

 {Create our sensor window to log the readings}
 SensorWindow:=ConsoleWindowCreate(ConsoleDeviceGetDefault,CONSOLE_POSITION_BOTTOMLEFT,False);

 {Setup the window with our defaults}
 ConsoleWindowSetForecolor(SensorWindow,COLOR_DARKGREEN);
 ConsoleWindowSetBackcolor(SensorWindow,COLOR_MIDGRAY);
 ConsoleWindowSetFont(SensorWindow,FontFindByName('Latin1-8x14'));
 ConsoleWindowSetViewport(SensorWindow,1,1,ConsoleWindowGetWidth(SensorWindow),ConsoleWindowGetHeight(SensorWindow));

 {Write the starting message}
 ConsoleWindowWriteLn(SensorWindow,'SenseHat starting at ' + DateTimeToStr(Now));

 {Loop reading our sensor}
 while not Terminated do
  begin
   dTemp := SenseHat.Get_Temperature;
   {Print the latest reading on the console}
   ConsoleWindowWriteLn(SensorWindow,'SenseHat.Temp reading at ' + DateTimeToStr(Now) + ' is ' + FloatToStr(dTemp));

   {Store the reading in our data class}
   //FData. .PutReading(Value);

   {Sleep a while and start again}
   Sleep(1000);
  end;

end;


{ TSenseHat }

function TSenseHat.Get_Pixels : TLED8x8;
begin

end;

constructor TSenseHat.Create;
begin
 inherited Create;
 FLock := TCriticalSection.Create;
 HumiditySensor := THumiditySensor.Create;
end;

destructor TSenseHat.Destroy;
begin
  FLock.Free;
  inherited Destroy;
end;

procedure TSenseHat.Set_Pixels(aPixels: TLED8x8);
begin

end;

procedure TSenseHat.Load_Image(sFileName: String; cRGB: TColor);
begin

end;

procedure TSenseHat.Clear;
begin

end;

procedure TSenseHat.Clear(cRGB: TColor);
begin

end;

procedure TSenseHat.Clear(iRed,iGreen, iBlue: Integer);
begin

end;

procedure TSenseHat.Set_Rotation(dAngle: Double);
begin

end;

procedure TSenseHat.Flip_H;
begin

end;

procedure TSenseHat.Flip_V;
begin

end;

procedure TSenseHat.Show_Message(sMsg: String; cRGB: TColor);
begin

end;

procedure TSenseHat.Show_Letter(sLetter: Char);
begin

end;

function TSenseHat.Get_Humidity: Double;
begin
    FLock.Acquire;
    Result := 0;


    FLock.Release;
end;

function TSenseHat.Get_Temperature: Double;
begin
  Result := 0;



end;

function TSenseHat.Get_Pressure: Double;
begin
  Result := 0;
end;

function TSenseHat.Get_Orientation_Radians: TOrientation;
begin
  Result := Nil;
end;

function TSenseHat.Get_Orientation_Degrees: TOrientation;
begin
  Result := Nil;
end;

function TSenseHat.Get_Orientation: TOrientation;
begin
  Result := Nil;
end;

function TSenseHat.Get_Compass: Double;
begin
  Result := 0;
end;

function TSenseHat.Get_Gyroscope: TOrientation;
begin
  Result := Nil;
end;

function TSenseHat.Get_Accelerometer: TOrientation;
begin
  Result := Nil;
end;

procedure StartSensorThread;
begin
 {Create an instance of the sensor data class}
 SenseHat := TSenseHat.Create;

 {And an instance of the sensor thread}
 TSensorThread.Create(SenseHat);
end;



//initialization
//    SenseHat := TSensHat.Create;

end.

