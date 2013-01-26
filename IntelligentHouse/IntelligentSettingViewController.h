//
//  IntelligentSettingViewController.h
//  IntelligentHouse
//
//  Created by phylony on 13-1-26.
//  Copyright (c) 2013年 phylony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntelligentSettingViewController : UIViewController{
    NSArray *SockType;
    NSString *SockIp;
    IBOutlet UISegmentedControl *segType;
    IBOutlet UITextField        *IpFiled;
    IBOutlet UITextField        *IpPort;
}

-(IBAction)SegChange:(id)sender;
-(IBAction)btnOk:(id)sender;
@end
