//
//  IntelligentHouseAppDelegate.m
//  IntelligentHouse
//
//  Created by phylony on 12-12-12.
//  Copyright (c) 2012年 phylony. All rights reserved.
//

#import "IntelligentHouseAppDelegate.h"
#import "IHTabBarViewController.h"

#import "IntelligentHouseViewController.h"
#import "IntelligentAboutViewController.h"
#import "IntelligentSettingViewController.h"

@implementation IntelligentHouseAppDelegate
-(void)UpDateSock{
    [self.IHVC ReloadSock];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.IHVC = [[IntelligentHouseViewController alloc] initWithNibName:@"IntelligentHouseViewController_iPhone" bundle:nil];
        self.ISVC=[[IntelligentSettingViewController alloc] initWithNibName:@"IntelligentSettingViewController_iPhone" bundle:Nil];
    } else {
        self.IHVC = [[IntelligentHouseViewController alloc] initWithNibName:@"IntelligentHouseViewController_iPad" bundle:nil];
        self.ISVC=[[IntelligentSettingViewController alloc] initWithNibName:@"IntelligentSettingViewController_iPad" bundle:Nil];
    }
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.IAVC = [[IntelligentAboutViewController alloc] initWithNibName:@"IntelligentAboutViewController_iPhone" bundle:nil];
    } else {
        self.IAVC = [[IntelligentAboutViewController alloc] initWithNibName:@"IntelligentAboutViewController_iPad" bundle:nil];
    }
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:self.IHVC];
    nav.navigationItem.title=@"智能无线控制开关";
    nav.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"控制界面" image:Nil];
    self.IAVC.ng_tabBarItem=[NGTabBarItem itemWithTitle:@"关于" image:Nil];
    self.ISVC.ng_tabBarItem=[NGTabBarItem itemWithTitle:@"设置" image:Nil];
    
    NSArray *viewController = [NSArray arrayWithObjects:nav,self.ISVC,self.IAVC,nil];
    
    NGTabBarController *tabBarController = [[IHTabBarViewController alloc] initWithDelegate:self];
    
    tabBarController.viewControllers = viewController;

    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (CGSize)tabBarController:(NGTabBarController *)tabBarController
sizeOfItemForViewController:(UIViewController *)viewController
                   atIndex:(NSUInteger)index
                  position:(NGTabBarPosition)position {
    if (NGTabBarIsVertical(position)) {
        return CGSizeMake(60, 30);
    } else {
        return CGSizeMake(60, 49.f);
    }
}


@end
