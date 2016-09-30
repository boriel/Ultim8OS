unit ulms9ds1;

{$mode delphi}

interface



uses
  Classes, SysUtils;

Type
   TAccelFullScaleRange = (afsrRange2g,afsrRange16g,afsrRange4g,afsrRange8g);
   TAccelLowPassFilter = (alpfFreq408Hz,alpfFreq211Hz,alpfFreq105Hz,alpfFreq50Hz);
   TAccelSampleRate = (asrNone,asrFreq10Hz,asrFreq50Hz,asrFreq119Hz,asrFreq238Hz,asrFreq476Hz,asrFreq952Hz);
   TCompassSampleRate = (csrFreq0_625Hz,csrFreq1_25Hz,csrFreq2_5Hz,csrFreq5Hz,csrFreq10Hz,csrFreq20Hz,csrFreq40Hz,csrFreq80Hz);
   TGyroBandwidthCode = (gbcBandwidthCode0,gbcBandwidthCode1,gbcBandwidthCode2,gbcBandwidthCode3);
   TGyroFullScaleRange = (gfsrRange245,gfsrRange500,gfsrRange2000);
   TGyroHighPassFilterCode = (ghpfcFilterCode0,ghpfcFilterCode1,ghpfcFilterCode2,ghpfcFilterCode3,ghpfcFilterCode4,ghpfcFilterCode5,ghpfcFilterCode6,ghpfcFilterCode7,ghpfcFilterCode8,ghpfcFilterCode9);
   TGyroSampleRate = (gsrFreq14_9Hz,gsrFreq59_5Hz,gsrFreq119Hz,gsrFreq238Hz,gsrFreq476Hz,gsrFreq952Hz);
   TMagneticFullScaleRange = (mfsrRange4Gauss,mfsrRange8Gauss,mfsrRange12Gauss,mfsrRange16Gauss);


Const
   LMS9DS1_ADDRESS0         = $6a;
   LMS9DS1_ADDRESS1         = $6b;
   LMS9DS1_ID               = $68;
   LMS9DS1_MAG_ADDRESS0     = $1c;
   LMS9DS1_MAG_ADDRESS1     = $1d;
   LMS9DS1_MAG_ADDRESS2     = $1e;
   LMS9DS1_MAG_ADDRESS3     = $1f;
   LMS9DS1_MAG_ID           = $3d;
   //  LSM9DS1 Register map
   LMS9DS1_ACT_THS          = $04;
   LMS9DS1_ACT_DUR          = $05;
   LMS9DS1_INT_GEN_CFG_XL   = $06;
   LMS9DS1_INT_GEN_THS_X_XL = $07;
   LMS9DS1_INT_GEN_THS_Y_XL = $08;
   LMS9DS1_INT_GEN_THS_Z_XL = $09;
   LMS9DS1_INT_GEN_DUR_XL   = $0A;
   LMS9DS1_REFERENCE_G      = $0B;
   LMS9DS1_INT1_CTRL        = $0C;
   LMS9DS1_INT2_CTRL        = $0D;
   LMS9DS1_WHO_AM_I         = $0F;
   LMS9DS1_CTRL1            = $10;
   LMS9DS1_CTRL2            = $11;
   LMS9DS1_CTRL3            = $12;
   LMS9DS1_ORIENT_CFG_G     = $13;
   LMS9DS1_INT_GEN_SRC_G    = $14;
   LMS9DS1_OUT_TEMP_L       = $15;
   LMS9DS1_OUT_TEMP_H       = $16;
   LMS9DS1_STATUS           = $17;
   LMS9DS1_OUT_X_L_G        = $18;
   LMS9DS1_OUT_X_H_G        = $19;
   LMS9DS1_OUT_Y_L_G        = $1A;
   LMS9DS1_OUT_Y_H_G        = $1B;
   LMS9DS1_OUT_Z_L_G        = $1C;
   LMS9DS1_OUT_Z_H_G        = $1D;
   LMS9DS1_CTRL4            = $1E;
   LMS9DS1_CTRL5            = $1F;
   LMS9DS1_CTRL6            = $20;
   LMS9DS1_CTRL7            = $21;
   LMS9DS1_CTRL8            = $22;
   LMS9DS1_CTRL9            = $23;
   LMS9DS1_CTRL10           = $24;
   LMS9DS1_INT_GEN_SRC_XL   = $26;
   LMS9DS1_STATUS2          = $27;
   LMS9DS1_OUT_X_L_XL       = $28;
   LMS9DS1_OUT_X_H_XL       = $29;
   LMS9DS1_OUT_Y_L_XL       = $2A;
   LMS9DS1_OUT_Y_H_XL       = $2B;
   LMS9DS1_OUT_Z_L_XL       = $2C;
   LMS9DS1_OUT_Z_H_XL       = $2D;
   LMS9DS1_FIFO_CTRL        = $2E;
   LMS9DS1_FIFO_SRC         = $2F;
   LMS9DS1_INT_GEN_CFG_G    = $30;
   LMS9DS1_INT_GEN_THS_XH_G = $31;
   LMS9DS1_INT_GEN_THS_XL_G = $32;
   LMS9DS1_INT_GEN_THS_YH_G = $33;
   LMS9DS1_INT_GEN_THS_YL_G = $34;
   LMS9DS1_INT_GEN_THS_ZH_G = $35;
   LMS9DS1_INT_GEN_THS_ZL_G = $36;
   LMS9DS1_INT_GEN_DUR_G    = $37;
   //  Mag Register Map
   LMS9DS1_MAG_OFFSET_X_L   = $05;
   LMS9DS1_MAG_OFFSET_X_H   = $06;
   LMS9DS1_MAG_OFFSET_Y_L   = $07;
   LMS9DS1_MAG_OFFSET_Y_H   = $08;
   LMS9DS1_MAG_OFFSET_Z_L   = $09;
   LMS9DS1_MAG_OFFSET_Z_H   = $0A;
   LMS9DS1_MAG_WHO_AM_I     = $0F;
   LMS9DS1_MAG_CTRL1        = $20;
   LMS9DS1_MAG_CTRL2        = $21;
   LMS9DS1_MAG_CTRL3        = $22;
   LMS9DS1_MAG_CTRL4        = $23;
   LMS9DS1_MAG_CTRL5        = $24;
   LMS9DS1_MAG_STATUS       = $27;
   LMS9DS1_MAG_OUT_X_L      = $28;
   LMS9DS1_MAG_OUT_X_H      = $29;
   LMS9DS1_MAG_OUT_Y_L      = $2A;
   LMS9DS1_MAG_OUT_Y_H      = $2B;
   LMS9DS1_MAG_OUT_Z_L      = $2C;
   LMS9DS1_MAG_OUT_Z_H      = $2D;
   LMS9DS1_MAG_INT_CFG      = $30;
   LMS9DS1_MAG_INT_SRC      = $31;
   LMS9DS1_MAG_INT_THS_L    = $32;
   LMS9DS1_MAG_INT_THS_H    = $33;


implementation

end.

