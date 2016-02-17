//
//  StoreViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 1/30/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import "StoreViewController.h"

@interface StoreViewController ()

@end

@implementation StoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden= NO;
    self.navigationController.navigationBar.translucent = NO;
    self.openTime.text = self.store.store_open_time;
    self.location.text = self.store.store_location;
    self.owner.text = self.store.store_operator;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.navigationController.navigationBarHidden = YES;
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
