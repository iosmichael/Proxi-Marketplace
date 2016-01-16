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


    self.username.autocorrectionType= UITextAutocorrectionTypeNo;
    self.password.secureTextEntry = YES;
    self.username.delegate=self;
    self.password.delegate=self;

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

- (IBAction)passwordRetrieve:(id)sender {
    
}



-(void)loginPass:(NSNotification *)noti{
    BOOL success = [[noti object]isEqualToString:LoginSuccessProtocol];
    if (success) {
        self.refresher.hidden = YES;
        [self.refresher stopAnimating];
        //Success AlertView
        
        
        [[NSUserDefaults standardUserDefaults]setObject:self.username.text forKey:@"username"];
        [[NSUserDefaults standardUserDefaults]setObject:self.password.text forKey:@"password"];
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        self.refresher.hidden = YES;
        [self.refresher stopAnimating];
        UIAlertController * alertNo=   [UIAlertController
                                        alertControllerWithTitle:@"Error"
                                        message:@"Invalid Account Information"
                                        preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       //Handel your yes please button action here
                                       [alertNo dismissViewControllerAnimated:YES completion:nil];
                                       self.username.text = @"";
                                       self.password.text = @"";
                                   }];
        
        [alertNo addAction:noButton];
        [self presentViewController:alertNo animated:YES completion:nil];
    }
}

-(void)loginError{
    
    self.refresher.hidden = YES;
    [self.refresher stopAnimating];
    self.username.text =@"";
    self.password.text =@"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return NO;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
