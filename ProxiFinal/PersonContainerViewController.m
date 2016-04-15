//
//  PersonContainerViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 2/6/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import "PersonContainerViewController.h"
#import "PersonDetailTableViewController.h"

@interface PersonContainerViewController ()

@end

@implementation PersonContainerViewController{
    NSInteger firstSegmentIndex;
}

-(void)viewDidAppear:(BOOL)animated{
    if (self.buyTableViewController&&self.sellTableViewController) {
        [self.buyTableViewController refreshControlRefresh];
        [self.sellTableViewController refreshControlRefresh];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"Gotham-Book" size:25]}];
    PersonDetailTableViewController *buyController = [[PersonDetailTableViewController alloc]init];
    buyController.detailCategory = @"My Orders";
    self.buyTableViewController = buyController;
    PersonDetailTableViewController *sellController = [[PersonDetailTableViewController alloc]init];
    sellController.detailCategory = @"My Sales";
    self.sellTableViewController = sellController;
    self.controllers = [[NSArray alloc]initWithObjects:buyController,sellController, nil];
    [self cycleFromViewController:self.currentTableViewController toViewController:[self.controllers objectAtIndex:self.switches.selectedSegmentIndex] direction:YES];
    [self.switches addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    [self.switches setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.switches setBackgroundImage:[self imageWithColor:[UIColor colorWithWhite:1.0 alpha:1.0]] forState:UIControlStateSelected  barMetrics:UIBarMetricsDefault];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"Gotham-Book" size:20],NSFontAttributeName,
                                nil];
    [self.switches setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    [self.switches setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cycleFromViewController:(UITableViewController*)oldVC toViewController:(UITableViewController*)newVC direction:(BOOL)dir
{
    
    // Do nothing if we are attempting to swap to the same view controller
    if (newVC == oldVC) return;
    
    // Check the newVC is non-nil otherwise expect a crash: NSInvalidArgumentException
    if (newVC) {
        int newStartX = CGRectGetMinX(self.container.bounds) - CGRectGetWidth(self.container.bounds);
        int oldEndX = CGRectGetMinX(self.container.bounds) + CGRectGetWidth(self.container.bounds);
        if (dir) {
            newStartX = CGRectGetWidth(self.container.bounds) + CGRectGetMinX(self.container.bounds);
            oldEndX = CGRectGetMinX(self.container.bounds) - CGRectGetWidth(self.container.bounds);
        }
        
        newVC.view.frame = CGRectMake(newStartX,
                                      CGRectGetMinY(self.container.bounds),
                                      CGRectGetWidth(self.container.bounds),
                                      CGRectGetHeight(self.container.bounds));
        
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
                                                                      CGRectGetMinY(self.container.bounds),
                                                                      CGRectGetWidth(self.container.bounds),
                                                                      CGRectGetHeight(self.container.bounds));
                                    }
                                    completion:^(BOOL finished) {
                                        // Finish both the view controller transitions
                                        [oldVC removeFromParentViewController];
                                        [newVC didMoveToParentViewController:self];
                                        // Store a reference to the current controller
                                        self.currentTableViewController = newVC;
                                    }];
            
        } else {
            
            newVC.view.frame = CGRectMake(CGRectGetMinX(self.container.bounds), CGRectGetMinY(self.container.bounds), CGRectGetWidth(self.container.bounds), CGRectGetHeight(self.container.bounds));
            
            // Otherwise we are adding a view controller for the first time
            // Start the view controller transition
            [self addChildViewController:newVC];
            
            [self.container addSubview:newVC.view];
            
            // End the view controller transition
            [newVC didMoveToParentViewController:self];
            
            // Store a reference to the current controller
            self.currentTableViewController = newVC;
        }
    }
}
     
- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender
{
    
    NSUInteger index = sender.selectedSegmentIndex;
    
    if (UISegmentedControlNoSegment != index) {
        BOOL direction = NO;
        if (firstSegmentIndex < index)
            direction = YES;
        
        UITableViewController *incomingViewController = [self.controllers objectAtIndex:index];
        [self cycleFromViewController:self.currentTableViewController toViewController:incomingViewController direction:direction];
    }
    firstSegmentIndex = index;
    
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
