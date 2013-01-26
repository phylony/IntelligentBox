//
//  IntelligentSettingViewController.m
//  IntelligentHouse
//
//  Created by phylony on 13-1-26.
//  Copyright (c) 2013年 phylony. All rights reserved.
//

#import "IntelligentSettingViewController.h"
#import "IntelligentHouseAppDelegate.h"

@interface IntelligentSettingViewController ()

@end

@implementation IntelligentSettingViewController
-(NSString*)DocPath{
    NSString *str=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *file=[str stringByAppendingPathComponent:@"IPSetting.plist"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:file]){
        str=[[NSBundle mainBundle] resourcePath];
        NSString *ip=[str stringByAppendingPathComponent:@"IPSetting.plist"];
        NSDictionary *dic=[NSDictionary dictionaryWithContentsOfFile:ip];
        [dic writeToFile:file atomically:YES];
    }
    return str;
}
-(IBAction)SegChange:(id)sender{
    
}
-(IBAction)btnOk:(id)sender{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:IpFiled.text,@"IP",IpPort.text,@"Port",[SockType objectAtIndex:segType.selectedSegmentIndex],@"Type", nil];
    NSString *ip=[[self DocPath] stringByAppendingPathComponent:@"IPSetting.plist"];
    [dic writeToFile:ip atomically:YES];
    IntelligentHouseAppDelegate *dele=(IntelligentHouseAppDelegate*)[[UIApplication sharedApplication] delegate];
    [dele performSelector:@selector(UpDateSock) withObject:Nil afterDelay:0.2];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    SockType=[[NSArray alloc] initWithObjects:@"tcpclient",@"tcpserver",@"udp", nil];
    NSString *ip=[[self DocPath] stringByAppendingPathComponent:@"IPSetting.plist"];
    NSDictionary *dic=[NSDictionary dictionaryWithContentsOfFile:ip];
    if ([[dic objectForKey:@"Type"] isEqual:@"tcpserver"]) {
        [segType setSelectedSegmentIndex:1];
    }
    if ([[dic objectForKey:@"Type"] isEqual:@"tcpclient"]) {
        [segType setSelectedSegmentIndex:0];

    }
    if ([[dic objectForKey:@"Type"] isEqual:@"udp"]) {
        [segType setSelectedSegmentIndex:2];
    }
    IpFiled.text=[dic objectForKey:@"IP"];
    IpPort.text=[dic     objectForKey:@"Port"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [IpFiled resignFirstResponder];
    [IpPort resignFirstResponder];
}
@end
