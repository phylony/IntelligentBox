//
//  IntelligentDataProtocol.h
//  IntelligentHouse
//
//  Created by phylony on 13-1-21.
//  Copyright (c) 2013年 phylony. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kIntelligentA2 @"A2"
#define kIntelligent81 @"81"
#define kIntelligent90 @"90"
#define kIntelligent91 @"91"

@interface IntelligentDataProtocol : NSObject
@property (nonatomic,strong) NSString *frameTag;
@property (nonatomic,strong) NSString *frameInData;
@property (nonatomic,strong) NSString *frameOutData;

@end
