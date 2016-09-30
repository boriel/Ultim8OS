unit ulps25h;

{$mode delphi}

interface

uses
  Classes, SysUtils;

Const
  LPS25H_ADDRESS0     = $5c;
  LPS25H_ADDRESS1     = $5d;
  LPS25H_REG_ID       = $0f;
  LPS25H_ID           = $bd;
  //	Register map
  LPS25H_REF_P_XL     = $08;
  LPS25H_REF_P_XH     = $09;
  LPS25H_RES_CONF     = $10;
  LPS25H_CTRL_REG_1   = $20;
  LPS25H_CTRL_REG_2   = $21;
  LPS25H_CTRL_REG_3   = $22;
  LPS25H_CTRL_REG_4   = $23;
  LPS25H_INT_CFG      = $24;
  LPS25H_INT_SOURCE   = $25;
  LPS25H_STATUS_REG   = $27;
  LPS25H_PRESS_OUT_XL = $28;
  LPS25H_PRESS_OUT_L  = $29;
  LPS25H_PRESS_OUT_H  = $2a;
  LPS25H_TEMP_OUT_L   = $2b;
  LPS25H_TEMP_OUT_H   = $2c;
  LPS25H_FIFO_CTRL    = $2e;
  LPS25H_FIFO_STATUS  = $2f;
  LPS25H_THS_P_L      = $30;
  LPS25H_THS_P_H      = $31;
  LPS25H_RPDS_L       = $39;
  LPS25H_RPDS_H       = $3a;
implementation

end.

