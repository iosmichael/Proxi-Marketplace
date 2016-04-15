//
//  MasterViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 10/10/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "MasterViewController.h"
#import "LoginMainViewController.h"
#import "ABCIntroView.h"


@interface MasterViewController ()<ABCIntroViewDelegate>
@property ABCIntroView *introView;
@property (strong,nonatomic) UIButton *centerButton;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupWithTabbarTheme];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"intro_viewed"]) {
        self.introView = [[ABCIntroView alloc] initWithFrame:self.view.frame];
        self.introView.delegate = self;
        self.introView.backgroundColor = [UIColor colorWithRed:22/255.0 green:61/255.0 blue:91/255.0 alpha:1];
        [self.view addSubview:self.introView];
        [defaults setValue:@"Yes" forKey:@"intro_viewed"];
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
    UITabBarItem *tabBarItem3 = [self.tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [self.tabBar.items objectAtIndex:3];
    UITabBarItem *tabBarItem5 = [self.tabBar.items objectAtIndex:4];
    
    tabBarItem1.selectedImage = [[UIImage imageNamed:@"Home_highlighted"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem1.image = [[UIImage imageNamed:@"Home"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem1.imageInsets= UIEdgeInsetsMake(5, 0, -5, 0);
    tabBarItem2.image = [[UIImage imageNamed:@"Search"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem2.selectedImage = [[UIImage imageNamed:@"Search_highlighted"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem2.imageInsets= UIEdgeInsetsMake(5, 0, -5, 0);
    
    tabBarItem3.image = [[UIImage imageNamed:@"Camera"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem3.selectedImage = [[UIImage imageNamed:@"Camera_highlighted"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem3.imageInsets= UIEdgeInsetsMake(5, 0, -5, 0);
    
    tabBarItem4.image = [[UIImage imageNamed:@"User"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem4.selectedImage = [[UIImage imageNamed:@"User_highlighted"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem4.imageInsets= UIEdgeInsetsMake(5, 0, -5, 0);
    
    tabBarItem5.image =[[UIImage imageNamed:@"More"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem5.selectedImage = [[UIImage imageNamed:@"More_highlighted"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem5.imageInsets= UIEdgeInsetsMake(5, 0, -5, 0);
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"username"]||![[NSUserDefaults standardUserDefaults]objectForKey:@"password"]) {
        LoginMainViewController *loginMainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginMain"];
        [self presentViewController:loginMainViewController animated:YES completion:nil];
    }

}


-(void)toggleButton{
    if (self.centerButton.hidden) {
        self.centerButton.hidden = NO;
    }else{
        self.centerButton.hidden = YES;
    }
}




@end
