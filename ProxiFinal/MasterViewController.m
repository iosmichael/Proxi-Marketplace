//
//  MasterViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 10/10/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "MasterViewController.h"
#import "PersonTableViewController.h"
#import "LoginViewController.h"
#import "ABCIntroView.h"

@interface MasterViewController ()<ABCIntroViewDelegate>
@property ABCIntroView *introView;
@property (strong,nonatomic) UIButton *centerButton;
@end

@implementation MasterViewController
#define CENTERBUTTONSIZE_WIDTH 55
#define CENTERBUTTONSIZE_HEIGHT 45

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupWithTabbarTheme];
    
    UIButton *centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    centerButton.frame = CGRectMake(0, 0, CENTERBUTTONSIZE_WIDTH, CENTERBUTTONSIZE_HEIGHT);
    
    UIImage *buttonImage = [[UIImage imageNamed:@"Camera"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *buttonSelectedImage = [[UIImage imageNamed:@"Camera_highlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [centerButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [centerButton setBackgroundImage:buttonSelectedImage forState:UIControlStateHighlighted];
    [centerButton addTarget:self action:@selector(switchTab) forControlEvents:UIControlEventTouchUpInside];
    CGFloat heightDifference =buttonImage.size.height -self.tabBar.frame.size.height;
    if (heightDifference<0) {
        centerButton.center = self.tabBar.center;
    }else{
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        centerButton.center = center;
    }
    self.centerButton = centerButton;
    [self.view addSubview:self.centerButton];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"intro_screen_viewed"]) {
        self.introView = [[ABCIntroView alloc] initWithFrame:self.view.frame];
        self.introView.delegate = self;
        self.introView.backgroundColor = [UIColor greenColor];
        [self.view addSubview:self.introView];
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ABCIntroViewDelegate Methods

-(void)onDoneButtonPressed{
    
    //    Uncomment so that the IntroView does not show after the user clicks "DONE"
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    [defaults setObject:@"YES"forKey:@"intro_screen_viewed"];
    //    [defaults synchronize];
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.introView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.introView removeFromSuperview];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)setupWithTabbarTheme{
    
    [[UITabBar appearance]setBackgroundColor:[UIColor colorWithRed:87/255.0 green:183/255.0 blue:182/255.0 alpha:1.0]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:251/255 green:176/255 blue:93/255 alpha:1]}
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }
                                             forState:UIControlStateSelected];
    
    UITabBarItem *tabBarItem1 = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem4 = [self.tabBar.items objectAtIndex:3];
    UITabBarItem *tabBarItem5 = [self.tabBar.items objectAtIndex:4];
    
    
    tabBarItem1.selectedImage = [[UIImage imageNamed:@"Home_highlighted"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem1.image = [[UIImage imageNamed:@"Home"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem1.imageInsets= UIEdgeInsetsMake(5, 0, -5, 0);
    tabBarItem2.image = [[UIImage imageNamed:@"Search"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem2.selectedImage = [[UIImage imageNamed:@"Search_highlighted"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem2.imageInsets= UIEdgeInsetsMake(5, 0, -5, 0);
    
    tabBarItem4.image = [[UIImage imageNamed:@"User"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem4.selectedImage = [[UIImage imageNamed:@"User_highlighted"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem4.imageInsets= UIEdgeInsetsMake(5, 0, -5, 0);
    tabBarItem5.image =[[UIImage imageNamed:@"More"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem5.selectedImage = [[UIImage imageNamed:@"More_highlighted"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem5.imageInsets= UIEdgeInsetsMake(5, 0, -5, 0);
}


-(void)toggleButton{
    if (self.centerButton.hidden) {
        self.centerButton.hidden = NO;
    }else{
        self.centerButton.hidden = YES;
    }
}

-(void)switchTab{
    [self setSelectedIndex:2];
    
}

@end
