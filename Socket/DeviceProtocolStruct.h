//
//  DeviceProtocolStruct.h
//  IntelligentHouse
//
//  Created by phylony on 12-12-15.
//  Copyright (c) 2012年 phylony. All rights reserved.
//


typedef struct
{
    uint8_t Head;
    uint8_t Add1,Add2,Add3,Add4;
    uint8_t End;
}devicePacketHead;

typedef struct
{
    devicePacketHead Head;
    uint8_t ControlCode;
    uint8_t CodeLength;
    uint8_t *CodePointer;
    uint8_t CodeVerify;
    uint8_t CodeEnd;
} devicePacket;
