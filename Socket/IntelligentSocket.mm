//
//  IntelligentSocket.m
//  IntelligentHouse
//  CFSwapInt32BigToHost
//
//  Created by phylony on 12-12-12.
//  Copyright (c) 2012年 phylony. All rights reserved.
//

#import "IntelligentSocket.h"
#import "NSString+Hex.h"
#import "IntelligentDeviceData.h"
static const char HexString[]="0123456789ABCDEF";

@protocol SocketDataDelegate <NSObject>

-(void)socketReceiveData:(NSData*)dat;

@end

@interface IntelligentSocket (){
    id              socks;
    NSMutableArray *SockArr;
    sockType        SockType_;
    dispatch_queue_t queue;
    NSString *Address;
}

@end

@implementation IntelligentSocket

-(id)initWithType:(sockType)type withAddress:(NSString*)add{
    self=[super init];
    if (self) {
        Address=add;
        SockArr=[[NSMutableArray alloc] initWithCapacity:1];
        SockType_=type;
        queue=dispatch_queue_create("socket", NULL);
        switch (SockType_) {
            case tcpClient:{
                
                socks=[[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
                if (![socks connectToHost:Address onPort:6000 error:Nil]){
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Can't connect due to invalid config" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    alert=Nil;
                }else{
                    [socks readDataWithTimeout:-1 tag:0];
                }
                
                NSLog(@"client mode:%@",Address);
            }
                break;
            case tcpServer:{
                socks=[[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
                [socks acceptOnPort:6000 error:Nil];

            }
                break;
            case udp:{
                socks=[[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:queue];
                NSString *tmpstr=@"55 AA AA AA AA AA 22 01 0F D9 16";
                Byte *ch=[tmpstr hexStrToHex];
                int len=[tmpstr hexStrLength];
                
                [socks sendData:[NSData dataWithBytes:ch length:len] toHost:Address port:6000 withTimeout:-1 tag:0];
                [socks sendData:[@"Active" dataUsingEncoding:NSUTF8StringEncoding] toHost:Address port:6000 withTimeout:-1 tag:0];
                [socks bindToPort:0 error:Nil];
                [socks beginReceiving:Nil];
                
            }
                break;
            default:
                break;
        }
        

    }
    SockPort=6000;
    
    return self;
}
-(id)initWithType:(sockType)type withAddress:(NSString*)add andPort:(NSInteger)Port{
    self=[super init];
    if (self) {
        Address=add;
        SockPort=Port;
        SockArr=[[NSMutableArray alloc] initWithCapacity:1];
        SockType_=type;
        queue=dispatch_queue_create("socket", NULL);
        switch (SockType_) {
            case tcpClient:{
                
                socks=[[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
                if (![socks connectToHost:Address onPort:Port error:Nil]){
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Can't connect due to invalid config" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    alert=Nil;
                }else{
                    [socks readDataWithTimeout:-1 tag:0];
                }
                
                NSLog(@"client mode:%@",Address);
            }
                break;
            case tcpServer:{
                socks=[[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
                [socks acceptOnPort:Port error:Nil];
                
            }
                break;
            case udp:{
                socks=[[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:queue];
                NSString *tmpstr=@"55 AA AA AA AA AA 22 01 0F D9 16";
                Byte *ch=[tmpstr hexStrToHex];
                int len=[tmpstr hexStrLength];
                
                [socks sendData:[NSData dataWithBytes:ch length:len] toHost:Address port:Port withTimeout:-1 tag:0];
                [socks sendData:[@"Active" dataUsingEncoding:NSUTF8StringEncoding] toHost:Address port:Port withTimeout:-1 tag:0];
                [socks bindToPort:0 error:Nil];
                [socks beginReceiving:Nil];
                
            }
                break;
            default:
                break;
        }
        
        
    }
    return self;

}
-(void)SendDataA{

    Byte *ch= [[IntelligentDeviceData getSharedInstance] WriteHexByte:@"11" WithData:@"01 00" AndVerifyBaseCode:@"00"];
    int len=[[IntelligentDeviceData  getSharedInstance] getSize];
    NSData *dat=[NSData dataWithBytes:ch  length:len];
    if (SockType_==tcpClient) {
        GCDAsyncSocket *s=socks;
        [s writeData:dat withTimeout:-1 tag:1];
        [s readDataWithTimeout:-1 tag:0];
    }else if(SockType_==tcpServer){
        for (GCDAsyncSocket *soc in SockArr) {
            [soc writeData:dat withTimeout:-1 tag:0];
            [soc readDataWithTimeout:-1 tag:1];
        }
    }else if (SockType_==udp){
        GCDAsyncUdpSocket *s=socks;
        [s sendData:dat toHost:Address port:SockPort withTimeout:-1 tag:0];

    }

}
-(void)SendDataB{
    Byte *ch= [[IntelligentDeviceData getSharedInstance] WriteHexByte:@"11" WithAddress:@"00000001"  WithData:@"11 00" AndVerifyBaseCode:@"00"];
    int len=[[IntelligentDeviceData  getSharedInstance] getSize];
    NSData *dat=[NSData dataWithBytes:ch  length:len];

    if (SockType_==tcpClient) {
        GCDAsyncSocket *s=socks;
        [s writeData:dat withTimeout:-1 tag:1];
        [s readDataWithTimeout:-1 tag:0];
    }else if(SockType_==tcpServer){
        for (GCDAsyncSocket *soc in SockArr) {
            [soc writeData:dat withTimeout:-1 tag:0];
            [soc readDataWithTimeout:-1 tag:1];
        }
    }else if (SockType_==udp){
        GCDAsyncUdpSocket *s=socks;
        [s sendData:dat toHost:Address port:SockPort withTimeout:-1 tag:0];

    }

}
-(void)CheckStatus{
    NSString *cmd=@"55 AA AA AA AA AA 22 01 0F D9 16";
    Byte *ch=[cmd hexStrToHex];
    
    NSData *dat=[NSData dataWithBytes:ch  length:[cmd hexStrLength]];
    
    if (SockType_==tcpClient) {
        GCDAsyncSocket *s=socks;
        [s writeData:dat withTimeout:-1 tag:1];
        [s readDataWithTimeout:-1 tag:0];
    }else if(SockType_==tcpServer){
        for (GCDAsyncSocket *soc in SockArr) {
            [soc writeData:dat withTimeout:-1 tag:0];
            [soc readDataWithTimeout:-1 tag:1];
        }
    }else if (SockType_==udp){
        GCDAsyncUdpSocket *s=socks;
        [s sendData:dat toHost:Address port:SockPort withTimeout:-1 tag:0];
        
    }

}
-(void)OpenAll:(NSInteger)status{
    NSString *cmd;
    Byte *ch;
    if (status) {
        cmd=@"55 AA AA AA AA AA 11 0D 0F 00 00 00 00 00 00 00 00 00 00 00 00 D4 16";
        ch=[cmd hexStrToHex];
    }else{
        cmd=@"55 AA AA AA AA AA 11 0D 1F 00 00 00 00 00 00 00 00 00 00 00 00 E4 16";
        ch=[cmd hexStrToHex];
    }
    NSData *dat=[NSData dataWithBytes:ch  length:[cmd hexStrLength]];
    
    if (SockType_==tcpClient) {
        GCDAsyncSocket *s=socks;
        [s writeData:dat withTimeout:-1 tag:1];
        [s readDataWithTimeout:-1 tag:0];
    }else if(SockType_==tcpServer){
        for (GCDAsyncSocket *soc in SockArr) {
            [soc writeData:dat withTimeout:-1 tag:0];
            [soc readDataWithTimeout:-1 tag:1];
        }
    }else if (SockType_==udp){
        GCDAsyncUdpSocket *s=socks;
        [s sendData:dat toHost:Address port:SockPort withTimeout:-1 tag:0];
        
    }

}
-(void)SendCommand:(NSString*)str{
    NSArray *arr=[str componentsSeparatedByString:@":"];
    int devid=[[arr objectAtIndex:1] intValue];
    int devstat=[[arr objectAtIndex:0] intValue];

    ;
    
    NSString *command=[NSString stringWithFormat:@"%d%c 00",devstat,HexString[devid] ];
    Byte *ch= [[IntelligentDeviceData getSharedInstance] WriteHexByte:@"11" WithAddress:@"AAAAAAAA"  WithData:command AndVerifyBaseCode:@"00"];
    int len=[[IntelligentDeviceData  getSharedInstance] getSize];
    NSData *dat=[NSData dataWithBytes:ch  length:len];
    if (SockType_==tcpClient) {
        GCDAsyncSocket *s=socks;
        [s writeData:dat withTimeout:-1 tag:1];
        [s readDataWithTimeout:-1 tag:0];
    }else if(SockType_==tcpServer){
        for (GCDAsyncSocket *soc in SockArr) {
            [soc writeData:dat withTimeout:-1 tag:0];
            [soc readDataWithTimeout:-1 tag:1];
        }
    }else if (SockType_==udp){
        GCDAsyncUdpSocket *s=socks;
        [s sendData:dat toHost:Address port:SockPort withTimeout:-1 tag:0];
        
    }

}
//****************************************************************************************
//TCP socket delegate
//****************************************************************************************
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    Byte *ch=[@"55 AA AA AA AA AA 22 01 0F D9 16" hexStrToHex];
    NSData *dat=[NSData dataWithBytes:ch length:strlen((char*)ch)];
    [sock writeData:dat withTimeout:-1 tag:1];
    NSLog(@"connected");
    [sock readDataWithTimeout:-1 tag:0];
}
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"disconnect");
    sock=nil;
    if (SockType_==tcpClient) {
        if (![socks connectToHost:Address onPort:SockPort error:Nil]){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Can't connect due to invalid config" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            alert=Nil;
        }else{
            [socks readDataWithTimeout:-1 tag:0];
        }
    }else if (SockType_==tcpServer){
        [SockArr removeObject:sock];
        sock=nil    ;
    }


}
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
	// This method is executed on the socketQueue (not the main thread)
	@synchronized(SockArr)
	{
		[SockArr addObject:newSocket];
	}
    Byte *ch=[@"55 AA AA AA AA AA 22 01 0F D9 16" hexStrToHex];
    NSData *dat=[NSData dataWithBytes:ch length:strlen((char*)ch)];
    [newSocket writeData:dat withTimeout:-1 tag:1];
	[newSocket readDataWithTimeout:-1 tag:0];
}


- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	// This method is executed on the socketQueue (not the main thread)
    [sock readDataWithTimeout:-1 tag:0];
    IntelligentDeviceData *iddata=[IntelligentDeviceData getSharedInstance];
    IntelligentDataProtocol *datas=[iddata ReadBytes:data];
    [self.delegate intelligentSocketReceiveData:datas];
    if (SockType_==tcpServer) {
        
    }
}
//****************************************************************************************
//TCP socket delegate
//****************************************************************************************
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address{
    Byte *ch=[@"55 AA AA AA AA AA 22 01 0F D9 16" hexStrToHex];
    NSData *dat=[NSData dataWithBytes:ch length:strlen((char*)ch)];
    [sock sendData:dat toAddress:address withTimeout:-1 tag:0];

}
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    IntelligentDeviceData *iddata=[IntelligentDeviceData getSharedInstance];
    IntelligentDataProtocol *datas=[iddata ReadBytes:data];
    [self.delegate intelligentSocketReceiveData:datas];

}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error{
    [sock sendData:[@"Active" dataUsingEncoding:NSUTF8StringEncoding] toHost:Address port:SockPort withTimeout:-1 tag:0];
}
- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error{
    NSLog(@"close socket");
    socks =Nil;
    socks=[[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:queue];
    [socks sendData:[@"Active" dataUsingEncoding:NSUTF8StringEncoding] toHost:Address port:SockPort withTimeout:-1 tag:0];
    [socks bindToPort:0 error:Nil];
    [socks beginReceiving:Nil];

}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    
    //NSLog(@"%d,%d,%@", sock.isClosed,sock.isConnected,error);
    
    [sock close];

}
-(void)dealloc{
    [socks disconnect];
    if (SockType_==udp) {
        [socks close];
    }
    for (GCDAsyncSocket *sock in SockArr) {
        [sock disconnect];
    }
    socks=Nil;
    
    NSLog(@"Dealloc sock");
}
@end
