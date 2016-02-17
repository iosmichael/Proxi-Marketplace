//
//  PersonContainerViewController.h
//  ProxiFinal
//
//  Created by Michael Liu on 2/6/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonDetailTableViewController.h"

@interface PersonContainerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UISegmentedControl *switches;
@property (strong,nonatomic) NSArray *controllers;
@property (nonatomic, strong) UITableViewController *currentTableViewController;
@property (strong,nonatomic) PersonDetailTableViewController *buyTableViewController;
@property (strong,nonatomic) PersonDetailTableViewController *sellTableViewController;

- (void)cycleFromViewController:(UITableViewController*)oldVC toViewController:(UITableViewController*)newVC direction:(BOOL)dir;
@end
