//
//  LoginViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 10/10/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
#import "UserConnection.h"
#import "HHAlertView.h"
#import "RegisterViewController.h"


#define LoginSuccessProtocol @"success login"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *refresher;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    self.refresher.hidden = YES;
    [self.loginButton.layer setCornerRadius:10];
    [self.registerButton.layer setCornerRadius:10];
    [self.userTextview.layer setCornerRadius:10];
    self.username.autocorrectionType= UITextAutocorrectionTypeNo;
    self.password.secureTextEntry = YES;
    self.username.delegate=self;
    self.password.delegate=self;
    [self.passwordTextview.layer setCornerRadius:10];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginPass:) name:@"LoginPassNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginError) name:@"LoginErrorNotification" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)login:(id)sender {
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
    
    if (self.username.text.length==0||self.password.text.length==0) {
        //Error AlertView
        self.username.text = @"";
        self.password.text = @"";
    }else{
    User *user = [[User alloc]initWithEmail:self.username.text password:self.password.text];
    UserConnection *loginCon = [[UserConnection alloc]init];
    [loginCon loginUserInfo:user];
    self.refresher.hidden =NO;
    [self.refresher startAnimating];
    }
}

- (IBAction)registerButton:(id)sender {
    NSLog(@"Show Register Page");
    RegisterViewController *registerViewController = [[RegisterViewController alloc]init];
    [self presentViewController:registerViewController animated:YES completion:nil];
}



-(void)loginPass:(NSNotification *)noti{
    BOOL success = [[noti object]isEqualToString:LoginSuccessProtocol];
    if (success) {
        self.refresher.hidden = YES;
        [self.refresher stopAnimating];
        //Success AlertView
        
        
        [[NSUserDefaults standardUserDefaults]setObject:self.username.text forKey:@"username"];
        [[NSUserDefaults standardUserDefaults]setObject:self.password.text forKey:@"password"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshTable" object:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        self.refresher.hidden = YES;
        [self.refresher stopAnimating];
        [HHAlertView showAlertWithStyle:HHAlertStyleError inView:self.view Title:@"Login Error" detail:@"pleace check your username and password" cancelButton:nil Okbutton:@"OK"];
        
        self.username.text = @"";
        self.password.text = @"";
    }
}

-(void)loginError{
    
    self.refresher.hidden = YES;
    [self.refresher stopAnimating];
    [HHAlertView showAlertWithStyle:HHAlertStyleError inView:self.view Title:@"Login Error" detail:@"Cannot communicate with the server" cancelButton:nil Okbutton:@"Contact Us"];
    self.username.text =@"";
    self.password.text =@"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
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
