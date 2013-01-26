//
//  NSArray+Hex.m
//  IntelligentHouse
//
//  Created by phylony on 12-12-21.
//  Copyright (c) 2012年 phylony. All rights reserved.
//

#import "NSArray+Hex.h"

@implementation NSArray (Hex)

+(NSArray*)hexToArrBig:(NSData*)byte{
    NSMutableArray *Arr=[NSMutableArray arrayWithCapacity:1];
    Byte *tmpbyte=(Byte*)[byte bytes];
    for (int i=byte.length-1; i>=0; i--) {
        for (int x=7; x>=0; x--) {
            Byte tmp=tmpbyte[i];
            if((tmp>>x)&1){
                [Arr addObject:@(YES)];
            }else{
                [Arr addObject:@(NO)];
            }
        }
    }
    return Arr;
}

+(NSArray*)hexToArr:(NSData*)byte{
    NSMutableArray *Arr=[NSMutableArray arrayWithCapacity:1];
    Byte *tmpbyte=(Byte*)[byte bytes];
    for (int i=0; i<byte.length; i++) {
        for (int x=7; x>=0; x--) {
            Byte tmp=tmpbyte[i];
            if((tmp>>x)&1){
                [Arr addObject:@(YES)];
            }else{
                [Arr addObject:@(NO)];
            }
        }

    }
    return Arr;
}

+(NSArray*)hexSplitToArr:(NSData*)byte{
    
    NSMutableArray *Arr=[NSMutableArray arrayWithCapacity:1];
    Byte *tmpbyte=(Byte*)[byte bytes];
    for (int i=0; i<byte.length; i++) {
        Byte tmp=tmpbyte[i];
        Byte obyte[2];
        obyte[0]=(tmp>>4) & 0x0f;
        obyte[1]=tmp & 0x0f;
        [Arr addObject:@(obyte[0])];
        [Arr addObject:@(obyte[1])];
    }
    return Arr;
}

@end
