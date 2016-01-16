//
//  LoginMainViewController.h
//  ProxiFinal
//
//  Created by Michael Liu on 1/12/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginMainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UISegmentedControl *switchViewControllers;
@property (strong,nonatomic) NSArray *controllers;
@property (nonatomic, strong) UIViewController *currentViewController;
@property (weak, nonatomic) IBOutlet UIImageView *proxiTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;
- (void)cycleFromViewController:(UIViewController*)oldVC toViewController:(UIViewController*)newVC direction:(BOOL)dir;
@end
