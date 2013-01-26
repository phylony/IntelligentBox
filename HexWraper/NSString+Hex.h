//
//  NSString+Hex.h
//  IntelligentHouse
//
//  Created by phylony on 12-12-14.
//  Copyright (c) 2012年 phylony. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Hex)
+(NSString*)hexToBinInv:(Byte)byte;

+(NSString*)hexToBinBig:(NSData*)byte;

+(NSString*)hexToBin:(NSData*)byte;

+(NSString*)strToHexStr:(NSString*)str;

+(NSString*)hexToStr:(NSData*)hex;

-(Byte*)hexStrToHex;

-(int)hexStrLength;

-(NSMutableArray*)getDeviceState:(uint16_t)Stat;

@end
