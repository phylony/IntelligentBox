//
//  IHTabBarViewController.m
//  IntelligentHouse
//
//  Created by phylony on 12-12-12.
//  Copyright (c) 2012年 phylony. All rights reserved.
//

#import "IHTabBarViewController.h"

@interface IHTabBarViewController ()
- (void)setupForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
@end

@implementation IHTabBarViewController

- (id)initWithDelegate:(id<NGTabBarControllerDelegate>)delegate {
    self = [super initWithDelegate:delegate];
    if (self) {
        self.animation = NGTabBarControllerAnimationMoveAndScale;
        self.tabBar.tintColor = [UIColor colorWithRed:50/255.f green:50/255.f blue:50/255.f alpha:0.5f];
        self.tabBar.itemPadding = 10.f;
        [self setupForInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
    }
    return self;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self setupForInterfaceOrientation:toInterfaceOrientation];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Private
////////////////////////////////////////////////////////////////////////

- (void)setupForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation; {
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        self.tabBarPosition = NGTabBarPositionBottom;
        self.tabBar.drawItemHighlight = NO;
        self.tabBar.layoutStrategy = NGTabBarLayoutStrategyCentered;
        self.tabBar.drawGloss = YES;
    } else {
        self.tabBarPosition = NGTabBarPositionLeft;
        self.tabBar.drawItemHighlight = YES;
        self.tabBar.drawGloss = NO;
        self.tabBar.layoutStrategy = NGTabBarLayoutStrategyStrungTogether;
    }
}

@end
