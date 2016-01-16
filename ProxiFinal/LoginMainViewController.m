//
//  LoginMainViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 1/12/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import "LoginMainViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "MasterViewController.h"

@interface LoginMainViewController ()

@end

@implementation LoginMainViewController{
    NSInteger priorSegmentIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    RegisterViewController *registerVC = [[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
    LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginID"];
    
    //instantiate all view controllers
    self.controllers = [[NSArray alloc] initWithObjects:registerVC,loginVC, nil];
    
    // Ensure a view controller is loaded
    self.switchViewControllers.selectedSegmentIndex = priorSegmentIndex = 1;
    [self cycleFromViewController:self.currentViewController toViewController:[self.controllers objectAtIndex:self.switchViewControllers.selectedSegmentIndex] direction:YES];
    [self.switchViewControllers addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    [self.switchViewControllers setBackgroundImage:[self imageWithColor:[UIColor colorWithWhite:1.0 alpha:0.3]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.switchViewControllers setBackgroundImage:[self imageWithColor:[UIColor colorWithWhite:1.0 alpha:1.0]] forState:UIControlStateSelected  barMetrics:UIBarMetricsDefault];
    
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)cycleFromViewController:(UIViewController*)oldVC toViewController:(UIViewController*)newVC direction:(BOOL)dir
{
    
    // Do nothing if we are attempting to swap to the same view controller
    if (newVC == oldVC) return;
    
    // Check the newVC is non-nil otherwise expect a crash: NSInvalidArgumentException
    if (newVC) {
        int newStartX = CGRectGetMinX(self.viewContainer.bounds) - CGRectGetWidth(self.viewContainer.bounds);
        int oldEndX = CGRectGetMinX(self.viewContainer.bounds) + CGRectGetWidth(self.viewContainer.bounds);
        if (dir) {
            newStartX = CGRectGetWidth(self.viewContainer.bounds) + CGRectGetMinX(self.viewContainer.bounds);
            oldEndX = CGRectGetMinX(self.viewContainer.bounds) - CGRectGetWidth(self.viewContainer.bounds);
        }
        
        newVC.view.frame = CGRectMake(newStartX,
                                      CGRectGetMinY(self.viewContainer.bounds),
                                      CGRectGetWidth(self.viewContainer.bounds),
                                      CGRectGetHeight(self.viewContainer.bounds));
        
        // Check the oldVC is non-nil otherwise expect a crash: NSInvalidArgumentException
        if (oldVC) {
            
            // Start both the view controller transitions
            [oldVC willMoveToParentViewController:nil];
            [self addChildViewController:newVC];
            
            // Swap the view controllers
            // No frame animations in this code but these would go in the animations block
            [self transitionFromViewController:oldVC
                              toViewController:newVC
                                      duration:0.15
                                       options:UIViewAnimationOptionLayoutSubviews
                                    animations:^{
                                        newVC.view.frame = oldVC.view.frame;
                                        oldVC.view.frame = CGRectMake(oldEndX,
                                                                      CGRectGetMinY(self.viewContainer.bounds),
                                                                      CGRectGetWidth(self.viewContainer.bounds),
                                                                      CGRectGetHeight(self.viewContainer.bounds));
                                    }
                                    completion:^(BOOL finished) {
                                        // Finish both the view controller transitions
                                        [oldVC removeFromParentViewController];
                                        [newVC didMoveToParentViewController:self];
                                        // Store a reference to the current controller
                                        self.currentViewController = newVC;
                                    }];
            
        } else {
            
            newVC.view.frame = CGRectMake(CGRectGetMinX(self.viewContainer.bounds), CGRectGetMinY(self.viewContainer.bounds), CGRectGetWidth(self.viewContainer.bounds), CGRectGetHeight(self.viewContainer.bounds));
            
            // Otherwise we are adding a view controller for the first time
            // Start the view controller transition
            [self addChildViewController:newVC];
            
            [self.viewContainer addSubview:newVC.view];
            
            // End the view controller transition
            [newVC didMoveToParentViewController:self];
            
            // Store a reference to the current controller
            self.currentViewController = newVC;
        }
    }
}
- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender
{
    
    NSUInteger index = sender.selectedSegmentIndex;
    
    if (UISegmentedControlNoSegment != index) {
        BOOL direction = NO;
        if (priorSegmentIndex < index)
            direction = YES;
        
        UIViewController *incomingViewController = [self.controllers objectAtIndex:index];
        [self cycleFromViewController:self.currentViewController toViewController:incomingViewController direction:direction];
    }
    priorSegmentIndex = index;
    
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