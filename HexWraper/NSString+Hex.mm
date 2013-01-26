//
//  NSString+Hex.m
//  IntelligentHouse
//
//  Created by phylony on 12-12-14.
//  Copyright (c) 2012年 phylony. All rights reserved.
//

#import "NSString+Hex.h"
#import <objc/runtime.h>
#import <string>
#import <string.h>
#import <vector>

static const char HexString[]="0123456789ABCDEF";

@implementation NSString (Hex)

//******************************************************************************************
//convert hex format showing In String;
//0xFF -> @"1111 1111"
//******************************************************************************************
+(NSString*)hexToBinInv:(Byte)byte{
    NSMutableString *Arr=[NSMutableString stringWithCapacity:1];
    Byte tmp=byte;
    for (int x=0; x<=7; x++) {
        if((tmp>>x)&1){
            [Arr appendString:@"1"];
        }else{
            [Arr appendString:@"0"];
        }
    }
    return Arr;
}
+(NSString*)hexToBinBig:(NSData*)byte{
    NSMutableString *Arr=[NSMutableString stringWithCapacity:1];
    Byte *tmpbyte=(Byte*)[byte bytes];
    for (int i=byte.length-1; i>=0; i--) {
        for (int x=7; x>=0; x--) {
            Byte tmp=tmpbyte[i];
            if((tmp>>x)&1){
                [Arr appendString:@"1"];
            }else{
                [Arr appendString:@"0"];
            }
        }
    }
    return Arr;
}

+(NSString*)hexToBin:(NSData*)byte{
    NSMutableString *Arr=[NSMutableString stringWithCapacity:1];
    Byte *tmpbyte=(Byte*)[byte bytes];
    for (int i=0; i<byte.length; i++) {
        for (int x=7; x>=0; x--) {
            Byte tmp=tmpbyte[i];
            if((tmp>>x)&1){
                [Arr appendString:@"1"];
            }else{
                [Arr appendString:@"0"];
            }
        }
        
    }
    return Arr;
}

//******************************************************************************************
//convert hex format showing In String;
//0xFFFFFF -> @"FF FF FF"
//******************************************************************************************

+(NSString*)strToHexStr:(NSString*)str{
    NSMutableString  *mstr=[NSMutableString string];
    for (int i=0; i<str.length; i++) {
        char tmp=[str characterAtIndex:i];
        [mstr appendFormat:@"%c",HexString[(tmp>>4 & 0x0f)]];
        [mstr appendFormat:@"%c",HexString[(tmp & 0x0f) ] ];
        [mstr appendFormat:@"%c",' '];
    }
    return mstr;
}

+(NSString*)hexToStr:(NSData*)hexs{
    NSMutableString  *mstr=[NSMutableString string];
    Byte *hex=(Byte*)hexs.bytes;
    size_t len= hexs.length;
    for (int i=0; i<len; i++) {
        [mstr appendFormat:@"%c",HexString[(hex[i]>>4 & 0x0f)]];
        [mstr appendFormat:@"%c",HexString[(hex[i] & 0x0f) ] ];
        [mstr appendFormat:@"%c",' '];
    }
    NSString *str=[NSString stringWithFormat:@"%@",mstr];
    return str;
}

//******************************************************************************************
//convert strings in hex format to hex binary
//@"FF FF FF" -> 0xFFFFFF
//******************************************************************************************

-(Byte*)hexStrToHex{
    NSString *tmp=[self stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (tmp.length&1) {
        return NULL;
    }
    
    int len=tmp.length/2;

    __block Byte *hex=(Byte*)malloc(len);
    
    for (int i=0; i<tmp.length; i+=2) {
        
        char a=[tmp characterAtIndex:i];
        const char* p = std::lower_bound(HexString, HexString + 16, a);//返回小于等于a的最近Hextstring指针；
        if (*p!=a) {
            NSLog(@"Error Hex Format");
        }
        
        char b=[tmp characterAtIndex:i+1];
        const char* q = std::lower_bound(HexString, HexString + 16, b);
        if (*q!=b) {
            NSLog(@"Error Hex Format");
        }
        hex[i/2]=((p-HexString)<<4 | (q-HexString));
    }
    dispatch_queue_t queue=dispatch_queue_create("free", NULL);
    dispatch_async(queue, ^{
        sleep(2.0);//hex live time:2.0 s;
        free(hex);
    });

    return hex;
}

-(int)hexStrLength{
    NSString *tmp=[self stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (tmp.length&1) {
        return NULL;
    }
    
    int len=tmp.length/2;
    return len;
}
//******************************************************************************************
//convert status hex binary to Array  with Bool
//@"FF FF FF" -> 0xFFFFFF
//******************************************************************************************

-(NSMutableArray*)getDeviceState:(uint16_t)Stat{
    NSMutableArray *arr=[NSMutableArray arrayWithCapacity:1];
    [arr     removeAllObjects];
    for (int x=0; x<sizeof(UInt16)*8; x++) {
        int tmp=(int)( Stat>>x & 0x0001);
        if (tmp==1) {
        }else{
        }
    
        [arr addObject:[NSNumber numberWithBool:tmp]];
    }
    return arr;
}


@end
