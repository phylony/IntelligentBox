//
//  IntelligentHouseViewController.h
//  IntelligentHouse
//
//  Created by phylony on 12-12-12.
//  Copyright (c) 2012年 phylony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKInfoPanel.h"
#import "NSString+Hex.h"
#import "IntelligentSocket.h"

@interface IntelligentHouseViewController : UIViewController<UIWebViewDelegate,IntelligentSocketDelegate>{
    IBOutlet UIButton *btnNotify;
    IBOutlet UIWebView *webView;

    
}
-(IBAction)btnClicked:(id)sender;
-(void)ReloadSock;
@end
