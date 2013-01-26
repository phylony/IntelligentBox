//
//  IntelligentDeviceData.h
//  IntelligentHouse
//
//  Created by phylony on 12-12-16.
//  Copyright (c) 2012年 phylony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Hex.h"
#import "NSArray+Hex.h"
#import "IntelligentDataProtocol.h"

#import <vector>
using namespace std;

@protocol HexStateDelegate <NSObject>

-(void)DeviceOn:(int)Index;
-(void)DeviceOff:(int)Index;

@end

@interface IntelligentDeviceData : NSObject{

}

@property (nonatomic,assign) vector<Byte> idSend;
@property (nonatomic,assign) id<HexStateDelegate>delegate;

+(id)getSharedInstance;

-(IntelligentDataProtocol*)ReadBytes:(NSData*)data;

-(Byte*)WriteHexByte:(NSString*)Command WithData:(NSString*)str AndVerifyBaseCode:(NSString*)Base;
-(Byte*)WriteHexByte:(NSString*)Command WithAddress:(NSString*)address WithData:(NSString*)str AndVerifyBaseCode:(NSString*)Base;

-(int)getSize;

@end
