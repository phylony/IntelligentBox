//
//  NSArray+Hex.h
//  IntelligentHouse
//
//  Created by phylony on 12-12-21.
//  Copyright (c) 2012年 phylony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Hex)
+(NSArray*)hexToArrBig:(NSData*)byte;
+(NSArray*)hexToArr:(NSData*)byte;
+(NSArray*)hexSplitToArr:(NSData*)byte;
@end
