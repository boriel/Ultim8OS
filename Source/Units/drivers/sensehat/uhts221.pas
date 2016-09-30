unit uhts221;

{$mode delphi}

interface

uses
  Classes, SysUtils,i2c,GlobalConst,GlobalConfig;




Type

   { THumiditySensor }

   THumiditySensor = Class(TObject)
       Private
         FHumidity: Double;
         FHumidityValid: Boolean;
         FI2cDevice : PI2CDevice;
         FTemperature: Double;
         FTemperatureValid: Boolean;
         FHTS221Initialized: Boolean;
         procedure SetHumidity(AValue: Double);
         procedure SetHumidityValid(AValue: Boolean);
         procedure SetTemperature(AValue: Double);
         procedure SetTemperatureValid(AValue: Boolean);
         Procedure TemperatureConvert;
         Procedure HumidityConvert;
       Public
         constructor Create;
         Property HumidityValid : Boolean read FHumidityValid write SetHumidityValid;
         Property Humidity : Double read FHumidity write SetHumidity;
         Property TemperatureValid : Boolean read FTemperatureValid write SetTemperatureValid;
         Property Temperature : Double read FTemperature write SetTemperature;


   end;

 const
   HTS221_ADDRESS        = $5f;
   HTS221_REG_ID         = $0f;
   HTS221_ID             = $bc;
   //  Register map
   HTS221_REG_WHO_AM_I       = $0f;
   HTS221_REG_AV_CONF        = $10;
   HTS221_REG_CTRL1          = $20;
   HTS221_REG_CTRL2          = $21;
   HTS221_REG_CTRL3          = $22;
   HTS221_REG_STATUS         = $27;
   HTS221_REG_HUMIDITY_OUT_L = $28;
   HTS221_REG_HUMIDITY_OUT_H = $29;
   HTS221_REG_TEMP_OUT_L     = $2a;
   HTS221_REG_TEMP_OUT_H     = $2b;
   HTS221_REG_H0_H_2         = $30;
   HTS221_REG_H1_H_2         = $31;
   HTS221_REG_T0_C_8         = $32;
   HTS221_REG_T1_C_8         = $33;
   HTS221_REG_T1_T0          = $35;
   HTS221_REG_H0_T0_OUT      = $36;
   HTS221_REG_H1_T0_OUT      = $3a;
   HTS221_REG_T0_OUT         = $3c;
   HTS221_REG_T1_OUT         = $3e;

implementation

{ THumiditySensor }

procedure THumiditySensor.SetHumidity(AValue: Double);
begin
  if FHumidity=AValue then Exit;
  FHumidity:=AValue;
end;

procedure THumiditySensor.SetHumidityValid(AValue: Boolean);
begin
  if FHumidityValid=AValue then Exit;
  FHumidityValid:=AValue;
end;

procedure THumiditySensor.SetTemperature(AValue: Double);
begin
  if FTemperature=AValue then Exit;
  FTemperature:=AValue;
end;

procedure THumiditySensor.SetTemperatureValid(AValue: Boolean);
begin
  if FTemperatureValid=AValue then Exit;
  FTemperatureValid:=AValue;
end;

procedure THumiditySensor.TemperatureConvert;
begin

end;

procedure THumiditySensor.HumidityConvert;
begin

end;

constructor THumiditySensor.Create;
var
  lStatus : LongWord;
begin
  if FHTS221Initialized then Exit;
  FI2cDevice.I2CId := HTS221_ID;
  FI2cDevice.SlaveAddress:=HTS221_ADDRESS;
  lStatus:=I2CDeviceRegister(FI2cDevice);
  if lStatus <> ERROR_SUCCESS then
  begin
    if I2C_LOG_ENABLED then
      I2CLogError(nil,'HTS221: Failed to register new I2C0 device: ' + ErrorToString(lStatus));
    Exit;
  end;

  FHTS221Initialized := True;
end;

end.

