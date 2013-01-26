//
//  IntelligentDeviceData.m
//  IntelligentHouse
//
//  Created by phylony on 12-12-16.
//  Copyright (c) 2012年 phylony. All rights reserved.
//

#import "IntelligentDeviceData.h"

@interface IntelligentDeviceData (){
    vector<Byte>::iterator idData;
}

@end

static IntelligentDeviceData *IDevieData;

@implementation IntelligentDeviceData

@synthesize delegate;

@synthesize idSend;

+(id)getSharedInstance{
    if (!IDevieData) {
        IDevieData=[[IntelligentDeviceData alloc] init];
    }
    return IDevieData;
}

-(void)writeByteHead{
    idSend.erase(idSend.begin(),idSend.end());
    Byte Head[]={0x55,0xAA,0xAA,0xAA,0xAA,0xAA,0x0F,0xFF};
    idSend.insert(idSend.end(), Head, &(Head[8]));
}
-(void)writeByteHead:(Byte*)str{
    idSend.erase(idSend.begin(),idSend.end());
    Byte Head[]={0x55,str[0],str[1],str[2],str[3],0xAA,0x0F,0xFF};
    idSend.insert(idSend.end(), Head, &(Head[8]));
}
-(void)writeCommand:(Byte)Command{
    idSend[6]=Command;
}

-(void)writeByteData:(Byte*)data withLength:(int)len AndVerifyBaseCode:(Byte)Base{
    idSend[7]=len;
    idSend.erase(idSend.begin()+8,idSend.end());
    
    Byte verify=Base;
    for (vector<Byte>::iterator it=idSend.begin(); it!=idSend.end(); it++) {
        verify+=*it;
    }
    for (int i=0; i<len; ++i) {
        idSend.push_back(data[i]);
        verify+=data[i];
    }
    idSend.push_back(verify);
    idSend.push_back(0x16);

}

Byte *GetCorrectDataPointer(Byte *data,int len){
    Byte *tmp=data;
    int length=len;
    //confirm the data length is max then 9;
    if (length<10) {
        return NULL;
    }
    //check data;
    if (tmp[0]!=0x55) {
        tmp=GetCorrectDataPointer(tmp+1, length-1);
    }
    int delta= tmp-data;
    if (delta<0) {
        return NULL;
    }
    length=len-delta;
    if (length<10) {
        return NULL;
    }
    if(tmp[5]!=0xAA){
        tmp=GetCorrectDataPointer(tmp+1, length-1);
    }
    delta=tmp-data;
    if (delta<0) {
        return NULL;
    }
    length=len-delta;
    if (length<10) {
        return NULL;
    }
    int datalen=10+tmp[7];
    if (datalen!=length) {
        tmp=GetCorrectDataPointer(tmp+1, length-1);
    }else{
        return tmp;
    }
    return tmp;
    
}

-(void)splitByte:(Byte&)byte withByte:(Byte*)obyte{
    obyte[0]=(byte>>4) & 0x0f;
    obyte[1]=byte & 0x0f;
}

-(IntelligentDataProtocol*)ReadBytes:(NSData*)data{
    Byte *byte=(Byte*)data.bytes;
    int len=data.length;
    if (len<9) {
        return nil;
    }
    Byte *tmp=GetCorrectDataPointer(byte, len);
    if (tmp==NULL) {
        return nil;
    }
    len-=(tmp-byte);
    Byte verify=0;
    //the last step verify authority code;
    for (Byte *bt=tmp; bt<tmp+len-2; bt++) {
        verify+=*bt;
    }
    if (verify==tmp[len-2]) {
        NSLog(@"Correct Verify:%2x,%2x",verify,tmp[len-2]);
    }else{
        NSLog(@"Error Verify:%2x,%2x",verify,tmp[len-2]);
        return nil;
    }
    int recLen=tmp[7];
    Byte recControl=tmp[6];//receive controller code;
    Byte recData[recLen];
    memcpy(recData, tmp+8, recLen);
    //NSData *tdat=[NSData dataWithBytes:recData length:recLen];
    NSString    *messeage=[NSString hexToStr:[NSData dataWithBytes:tmp length:len]];
    
    //NSString    *datas=[NSString hexToStr:[NSData dataWithBytes:recData length:recLen]];
    //NSString    *str=[NSString hexToBinBig:[NSData dataWithBytes:recData length:recLen]];
    //NSArray *spd=[NSArray hexSplitToArr:tdat];
    NSLog(@"%@",messeage);
    @autoreleasepool {
        IntelligentDataProtocol *data=[[IntelligentDataProtocol alloc] init];
        data.frameTag=[[NSString    hexToStr:[NSData dataWithBytes:&recControl length:1]] stringByReplacingOccurrencesOfString:@" " withString:@""];

        if ([data.frameTag isEqualToString:kIntelligentA2]) {
            if(recData[0]==0x0f){
                NSString *s1=[NSString hexToBinInv:recData[1]];;
                NSString *s2=[NSString hexToBinInv:recData[2]];;
                NSString *str=[NSString stringWithFormat:@"%@%@",s1,s2];
                data.frameInData=str;
                NSString *e1=[NSString hexToBinInv:recData[3]];
                NSString *e2=[NSString hexToBinInv:recData[4]];
                NSString *etr=[NSString stringWithFormat:@"%@%@",e1,e2];
                data.frameOutData=etr;
            }
        }else if ([data.frameTag isEqualToString:kIntelligent81]){
            if(recData[0]==0x0f){
                NSString *e1=[NSString hexToBinInv:recData[1]];
                NSString *e2=[NSString hexToBinInv:recData[2]];
                NSString *etr=[NSString stringWithFormat:@"%@%@",e1,e2];
                data.frameOutData=etr;
                data.frameInData=Nil;
            }
        }else if ([data.frameTag isEqualToString:kIntelligent90]){
            if(recData[0]==0x0f){
                NSString *e1=[NSString hexToBinInv:recData[1]];
                NSString *e2=[NSString hexToBinInv:recData[2]];
                NSString *etr=[NSString stringWithFormat:@"%@%@",e1,e2];
                data.frameOutData=etr;
                data.frameInData=Nil;
            }else{
                data.frameTag=Nil;
            }
        }else if ([data.frameTag isEqualToString:kIntelligent91]){
            if(recData[0]==0x1f){
                NSString *e1=[NSString hexToBinInv:recData[1]];
                NSString *e2=[NSString hexToBinInv:recData[2]];
                NSString *etr=[NSString stringWithFormat:@"%@%@",e1,e2];
                data.frameOutData=etr;
                data.frameInData=Nil;
            }else{
                data.frameTag=Nil;
            }
        }else{
            NSLog(@"In Other:%@",data.frameTag);
        }
        return data;
    }
}

-(Byte*)WriteHexByte:(NSString*)Command WithData:(NSString*)str AndVerifyBaseCode:(NSString*)Base{
    [self writeByteHead];
    Byte *byte=[Command hexStrToHex];
    [self writeCommand:*byte];
    Byte *tmp=[str hexStrToHex];
    Byte *base=[Base hexStrToHex];
    [self writeByteData:tmp withLength:[str hexStrLength] AndVerifyBaseCode:*base];
    //debug out
    //NSString  *log=[NSString hexToStr:[NSData dataWithBytes:idSend.data() length:idSend.size()]];
    //NSLog(@"%@,%ld",log,idSend.size());
    return idSend.data();
}

-(Byte*)WriteHexByte:(NSString*)Command WithAddress:(NSString *)address WithData:(NSString *)str AndVerifyBaseCode:(NSString *)Base{
    [self writeByteHead:[address hexStrToHex]];
    Byte *byte=[Command hexStrToHex];
    [self writeCommand:*byte];
    Byte *tmp=[str hexStrToHex];
    Byte *base=[Base hexStrToHex];
    [self writeByteData:tmp withLength:[str hexStrLength] AndVerifyBaseCode:*base];
    //NSString  *log=[NSString hexToStr:[NSData dataWithBytes:idSend.data() length:idSend.size()]];
    //NSLog(@"%@,%ld",log,idSend.size());
    return idSend.data();
}

-(int)getSize{
    return idSend.size();
}


-(NSMutableArray*)getDeviceState:(Byte*)Stat withLen:(int)length{
    NSMutableArray *arr=[NSMutableArray arrayWithCapacity:1];
    [arr     removeAllObjects];
    for (int n=0; n<length; n++) {
        unsigned char t=Stat[n];
        for (int x=0; x<8; x++) {
            int tmp=t>>x &0x0001;
            if (tmp==1) {
                [self.delegate DeviceOn:x];
            }else{
                [self.delegate DeviceOff:x];
            }
            
            [arr addObject:[NSNumber numberWithBool:tmp]];
        }
        
    }
    return arr;
}
@end
