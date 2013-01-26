//
//  IntelligentHouseAppDelegate.h
//  IntelligentHouse
//
//  Created by phylony on 12-12-12.
//  Copyright (c) 2012年 phylony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGTabBarController.h"
@class IntelligentHouseViewController;
@class IntelligentAboutViewController;
@class IntelligentSettingViewController;

@interface IntelligentHouseAppDelegate : UIResponder <UIApplicationDelegate,NGTabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) IntelligentHouseViewController *IHVC;

@property (strong,nonatomic) IntelligentAboutViewController *IAVC;

@property (strong,nonatomic) IntelligentSettingViewController *ISVC;

-(void)UpDateSock;
@end
