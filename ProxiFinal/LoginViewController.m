//
//  LoginViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 10/10/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginMainViewController.h"
#import "MasterViewController.h"
#import "User.h"
#import "UserConnection.h"
#import "RegisterViewController.h"
#import "PasswordRetrieveViewController.h"

#define LoginSuccessProtocol @"success login"
#define LoginPartialSuccessProtocol @"success login without selling authority"
#define kOFFSET_FOR_KEYBOARD 182.0
@interface LoginViewController ()

@end

@implementation LoginViewController{
    BOOL keyboardHasShown;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    self.refresher.hidden = YES;
    [self.loginButton.layer setCornerRadius:10];
    self.username.autocorrectionType= UITextAutocorrectionTypeNo;
    self.password.secureTextEntry = YES;
    self.username.delegate=self;
    self.password.delegate=self;
    [self setupGestureRecognizer];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self keyboardWillHide];
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

- (IBAction)passwordRetrieve:(id)sender {
    PasswordRetrieveViewController *passwordRetrieveViewController= [self.storyboard instantiateViewControllerWithIdentifier:@"password"];
    [self presentViewController:passwordRetrieveViewController animated:YES completion:nil];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return NO;
}

-(void)setupGestureRecognizer{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard{
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
}
-(void)keyboardWillShow{
    if (keyboardHasShown) {
        return;
    }
    LoginMainViewController *container = (LoginMainViewController *)self.parentViewController;
    [UIView animateWithDuration:0.5
                     animations:^{
                         container.headerHeight.constant -=kOFFSET_FOR_KEYBOARD;
                     }];
    keyboardHasShown = YES;
}
-(void)keyboardWillHide{
    if (!keyboardHasShown) {
        return;
    }
    LoginMainViewController *container = (LoginMainViewController *)self.parentViewController;
    [UIView animateWithDuration:0.5
                     animations:^{
                         container.headerHeight.constant +=kOFFSET_FOR_KEYBOARD;
                     }];
    keyboardHasShown=NO;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
