//
//  IntelligentHouseViewController.m
//  IntelligentHouse
//
//  Created by phylony on 12-12-12.
//  Copyright (c) 2012年 phylony. All rights reserved.
//

#import "IntelligentHouseViewController.h"
#import "NGTabBarController.h"
#import "IntelligentDataProtocol.h"
@interface IntelligentHouseViewController (){
    IntelligentSocket *sock;
}

@end

@implementation IntelligentHouseViewController
-(void)intelligentSocketReceiveData:(IntelligentDataProtocol *)str{
    if ([str.frameTag isEqualToString:kIntelligentA2]) {
        const char *com=[str.frameOutData cStringUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%s",com);
        NSMutableString *command=[NSMutableString stringWithCapacity:1];
        for (int i=0; i<16; i++) {
            if (com[i]=='1') {
                [command appendString:[NSString stringWithFormat:@"Lights[%d].openImg();",i]];
            }
        }
        NSLog(@"%@",command);
        dispatch_async(dispatch_get_main_queue(), ^{

            [webView performSelector:@selector(stringByEvaluatingJavaScriptFromString:) withObject:command afterDelay:0.1];

        });

    }else if ([str.frameTag isEqualToString:kIntelligent81]){
        const char *com=[str.frameOutData cStringUsingEncoding:NSUTF8StringEncoding];
        NSMutableString *command=[NSMutableString stringWithCapacity:1];
        for (int i=0; i<16; i++) {
            if (com[i]) {
                [command appendString:[NSString stringWithFormat:@"Lights[%d].openImg();",i]];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [webView stringByEvaluatingJavaScriptFromString:command];
        });
        
    }else if ([str.frameTag isEqualToString:kIntelligent90]){
        const char *com=[str.frameOutData cStringUsingEncoding:NSUTF8StringEncoding];
        NSMutableString *command=[NSMutableString stringWithCapacity:1];
        for (int i=0; i<16; i++) {
            if (com[i]) {
                [command appendString:[NSString stringWithFormat:@"Lights[%d].openImg();",i]];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [webView stringByEvaluatingJavaScriptFromString:command];
        });
        
    }else if ([str.frameTag isEqualToString:kIntelligent91]){
        const char *com=[str.frameOutData cStringUsingEncoding:NSUTF8StringEncoding];
        NSMutableString *command=[NSMutableString stringWithCapacity:1];
        for (int i=0; i<16; i++) {
            if (com[i]) {
                [command appendString:[NSString stringWithFormat:@"Lights[%d].closeImg();",i]];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [webView stringByEvaluatingJavaScriptFromString:command];
        });
        
    }
}
-(NSString*)DocPath{
    NSString *str=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *file=[str stringByAppendingPathComponent:@"index.html"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:file]){
        str=[[NSBundle mainBundle] resourcePath];
    }
    file=[str stringByAppendingPathComponent:@"IPSetting.plist"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:file]){
        str=[[NSBundle mainBundle] resourcePath];
        NSString *ip=[str stringByAppendingPathComponent:@"IPSetting.plist"];
        NSDictionary *dic=[NSDictionary dictionaryWithContentsOfFile:ip];
        [dic writeToFile:file atomically:YES];
    }

    return str;
}
-(IBAction)btnClicked:(id)sender{
    UIButton *tmp=(UIButton*)sender;

    switch (tmp.tag) {
        case 0:
            [sock SendDataA];
            break;
        case 1:
            [sock SendDataB];
            break;
        default:
            break;
    }
}

-(void)DeviceOn:(int)num{
    //NSLog(@"ON%d",num);
}
-(void)DeviceOff:(int)num{
    //NSLog(@"OFF%d",num);

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=[NSString stringWithFormat:@"智能无线控制开关"];
    NSString *str=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSString *ip=[str stringByAppendingPathComponent:@"IPSetting.plist"];
    NSString *htm=[[self DocPath] stringByAppendingPathComponent:@"index.html"];
    NSLog(@"%@",ip);
    NSDictionary *dic=[NSDictionary dictionaryWithContentsOfFile:ip];
    sockType stype=tcpClient;
    if ([[dic objectForKey:@"Type"] isEqual:@"tcpserver"]) {
        stype=tcpServer;
    }
    if ([[dic objectForKey:@"Type"] isEqual:@"tcpclient"]) {
        stype=tcpClient;
    }
    if ([[dic objectForKey:@"Type"] isEqual:@"udp"]) {
        stype=udp;
    }
    NSLog(@"Dics:%@",dic);
    sock=[[IntelligentSocket alloc] initWithType:stype withAddress:[dic objectForKey:@"IP"] andPort:[[dic objectForKey:@"Port"] intValue]];
    sock.delegate=self;
    
    [webView loadRequest:[NSURLRequest   requestWithURL:[NSURL fileURLWithPath:htm]]];
    webView.delegate=self;
}
-(void)ReloadSock{
    sock=Nil;

    NSString *str=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];    
    NSString *ip=[str stringByAppendingPathComponent:@"IPSetting.plist"];
    NSString *htm=[[self DocPath] stringByAppendingPathComponent:@"index.html"];
    NSDictionary *dic=[NSDictionary dictionaryWithContentsOfFile:ip];
    sockType stype=tcpClient;
    if ([[dic objectForKey:@"Type"] isEqual:@"tcpserver"]) {
        stype=tcpServer;
    }
    if ([[dic objectForKey:@"Type"] isEqual:@"tcpclient"]) {
        stype=tcpClient;
    }
    if ([[dic objectForKey:@"Type"] isEqual:@"udp"]) {
        stype=udp;
    }
    NSLog(@"%@",dic);
    sock=[[IntelligentSocket alloc] initWithType:stype withAddress:[dic objectForKey:@"IP"] andPort:[[dic objectForKey:@"Port"] intValue]];
    sock.delegate=self;
    
    [webView loadRequest:[NSURLRequest   requestWithURL:[NSURL fileURLWithPath:htm]]];
    webView.delegate=self;

}
-(void)viewWillDisappear:(BOOL)animated{
    
}
-(void)viewWillAppear:(BOOL)animated{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [sock CheckStatus];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *str=[[request URL] absoluteString];
    NSLog(@"str:%@",str);
    NSArray *arr=[str componentsSeparatedByString:@"app://"];
    if ([arr count]>1) {
        NSString *strs=[arr objectAtIndex:1];
        NSArray *arrt=[strs componentsSeparatedByString:@":"];
        if ([arrt count]<=1) {
            if ([strs isEqualToString:@"on"]) {
                [sock OpenAll:1];
            }
            if ([strs isEqualToString:@"off"]) {
                [sock OpenAll:0];
            }
            if ([strs isEqualToString:@"refresh"]) {
                [sock CheckStatus];
            }

        }else{
            [sock SendCommand:[arr objectAtIndex:1]];

        }
    }
    return  YES;
}
@end
