//
//  IntelligentSocket.h
//  IntelligentHouse
//
//  Created by phylony on 12-12-12.
//  Copyright (c) 2012年 phylony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "GCDAsyncUdpSocket.h"
@class IntelligentDataProtocol;

@protocol IntelligentSocketDelegate <NSObject>

-(void)intelligentSocketReceiveData:(IntelligentDataProtocol*)str;

@end

typedef enum _sockType{
    tcpClient,tcpServer,udp
}sockType;

@interface IntelligentSocket : NSObject<GCDAsyncSocketDelegate,GCDAsyncUdpSocketDelegate>{
    int SockPort;
    
}
@property (nonatomic,assign)id<IntelligentSocketDelegate> delegate;
-(id)initWithType:(sockType)type withAddress:(NSString*)add;
-(id)initWithType:(sockType)type withAddress:(NSString*)add andPort:(NSInteger)Port;

-(void)SendDataA;
-(void)SendDataB;
-(void)SendCommand:(NSString*)str;
-(void)CheckStatus;
-(void)OpenAll:(NSInteger)status;
@end
