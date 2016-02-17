//
//  WebViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 2/14/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property (strong,nonatomic) UIWebView *webview;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIWebView *webview = [[UIWebView alloc]initWithFrame:self.view.frame];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
