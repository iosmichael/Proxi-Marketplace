//
//  RegisterViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 10/10/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "RegisterViewController.h"
#import "HHAlertView.h"
#import "LoginMainViewController.h"
#import "UserConnection.h"
#import "User.h"

#define kOFFSET_FOR_KEYBOARD 182.0

#define Screen_width [[UIScreen mainScreen]bounds].size.width
#define Screen_height [[UIScreen mainScreen]bounds].size.height
#define highlight_color [UIColor colorWithRed:36/255.0 green:104/255.0 blue:156/255.0 alpha:1.0]
#define gray [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1]

#define RegisterPassProtocol @"successfully create user"

@interface RegisterViewController ()<UITextFieldDelegate,UIScrollViewDelegate,HHAlertViewDelegate>
@property (strong,nonatomic) NSString *capitalizedFirstName;
@property (strong,nonatomic) NSString *capitalizedLastName;



@end

@implementation RegisterViewController{
    BOOL agreeTerms;
    BOOL registerSuccess;
    BOOL keyboardHasShown;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    agreeTerms = NO;
    [self.agreeButton.layer setCornerRadius:5];
    [self.registerButton.layer setCornerRadius:5];
    [[HHAlertView shared]setDelegate:self];
    // Do any additional setup after loading the view from its nib.
    self.firstPage.frame = CGRectMake(0, 0, Screen_width, Screen_height);
    self.secondPage.frame = CGRectMake(Screen_width, 0, Screen_width, Screen_height);
    [self.scrollView setContentSize:CGSizeMake(Screen_width*2, 0)];
    [self.scrollView addSubview:self.firstPage];
    [self.scrollView addSubview:self.secondPage];
    self.scrollView.delegate = self;
    [self setupTextfieldSettings];
    [self setupGestureRecognizer];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(registerPass:) name:@"RegisterPassNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(registerFail) name:@"RegisterFailNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
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


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self keyboardWillHide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)registerButtonTapped:(id)sender {
    [self checkAllValidation];
    if (!self.registerButton.enabled) {
        return;
    }
    
    [self namesWithEmail:self.email.text];
    User *user = [[User alloc]initWithEmail:self.email.text firstName:self.capitalizedFirstName lastName:self.capitalizedLastName password:self.password.text phone:self.phone.text];
    UserConnection *connection = [[UserConnection alloc]init];
    self.registerButton.enabled = NO;
    self.refresher.hidden = NO;
    [connection registeredUserInfo:user];
    NSLog(@"register button pressed");
    
    
}
- (IBAction)acceptTermsButton:(id)sender {
    if (agreeTerms) {
        [self.agreeButton setBackgroundColor:highlight_color];
        agreeTerms = NO;
    }else{
        [self.agreeButton setBackgroundColor:gray];
        agreeTerms = YES;
    }
    [self checkAllValidation];
}

-(void)registerPass:(NSNotification *)noti{
    
    if ([[noti object]isEqualToString:RegisterPassProtocol]) {
        UIAlertController * alertYes=   [UIAlertController
                                         alertControllerWithTitle:@"Success"
                                         message:@"Registered Your Proxi Account. Please Check Your Email to Activate Account."
                                         preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //Handel yes please button action here
                                        [alertYes dismissViewControllerAnimated:YES completion:nil];
                                        if ([self.parentViewController isKindOfClass:[LoginMainViewController class]]) {
                                            LoginMainViewController *mainController = (LoginMainViewController *)self.parentViewController;
                                            mainController.switchViewControllers.selectedSegmentIndex=1;
                                            [mainController cycleFromViewController:self toViewController:[mainController.controllers objectAtIndex:mainController.switchViewControllers.selectedSegmentIndex] direction:YES];
                                            
                                        }
                                        [self clearAll];
                                        [self checkAllValidation];
                                    }];
        
        [alertYes addAction:yesButton];
        [self presentViewController:alertYes animated:YES completion:nil];
    }
    else{
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
                                       [self clearAll];
                                   }];
        
        [alertNo addAction:noButton];
        [self presentViewController:alertNo animated:YES completion:nil];
    }
}


-(void)registerFail{
    self.refresher.hidden = YES;
}
- (IBAction)braintreeliabilityLink:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://www.braintreepayments.com/legal/payment-services-agreement"]];
}

- (IBAction)proxiliabilityLink:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://www.proximarketplace.com"]];
}

-(void)clearAll{
    self.password.text =@"";
    self.email.text = @"";
    self.recheckPassword.text=@"";
    self.phone.text =@"";
    self.firstName.text=@"";
    self.lastName.text=@"";
    
    [self.password validate];
    [self.email validate];
    [self.recheckPassword validate];
    [self.phone validate];
    [self.firstName validate];
    [self.lastName validate];
    
}

-(void)setupTextfieldSettings{
    self.email.validationType = JAMValidatingTextFieldTypeEmail;
    self.phone.validationType = JAMValidatingTextFieldTypePhone;
    self.password.validationBlock = ^{
        if (self.password.text.length == 0) {
            return JAMValidatingTextFieldStatusIndeterminate;
        }
        if (self.password.text.length > 5) {
            return JAMValidatingTextFieldStatusValid;
        }
        return JAMValidatingTextFieldStatusInvalid;
    };
    self.recheckPassword.validationBlock = ^{
        if (self.recheckPassword.text.length==0) {
            return JAMValidatingTextFieldStatusIndeterminate;
        }
        if (self.recheckPassword.text.length == self.password.text.length) {
            if ([self.recheckPassword.text isEqualToString:self.password.text]) {
                return JAMValidatingTextFieldStatusValid;
            }
            return JAMValidatingTextFieldStatusInvalid;
        }
        return JAMValidatingTextFieldStatusInvalid;

    };
    self.firstName.validationBlock = ^{
        if (self.firstName.text.length==0) {
            return JAMValidatingTextFieldStatusIndeterminate;
        }
        else{
            return JAMValidatingTextFieldStatusValid;
        }
        
    };
    self.lastName.validationBlock = ^{
        if (self.lastName.text.length==0) {
            return JAMValidatingTextFieldStatusIndeterminate;
        }
        else{
            return JAMValidatingTextFieldStatusValid;
        }
    };
    self.password.required = YES;
    self.recheckPassword.required = YES;
    self.firstName.required = YES;
    self.lastName.required = YES;
    self.email.delegate = self;
    self.phone.delegate = self;
    self.recheckPassword.delegate = self;
    self.password.delegate = self;
    self.firstName.delegate = self;
    self.lastName.delegate = self;
    
    
}

-(void)checkAllValidation{
    if (self.email.validationStatus==JAMValidatingTextFieldStatusValid&&
        self.phone.validationStatus==JAMValidatingTextFieldStatusValid&&
        self.recheckPassword.validationStatus==JAMValidatingTextFieldStatusValid&&
        self.lastName.validationStatus==JAMValidatingTextFieldStatusValid&&
        self.firstName.validationStatus==JAMValidatingTextFieldStatusValid&&
        agreeTerms) {
            self.registerButton.enabled=YES;
            [self.registerButton setBackgroundColor:highlight_color];
            [self.registerAlertLabel setTextColor:[UIColor clearColor]];
    }else{
        [self.registerButton setBackgroundColor:gray];
        self.registerButton.enabled=NO;
        [self.registerAlertLabel setTextColor:[UIColor redColor]];
    }
}
#pragma mark- Textfield Delegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self checkAllValidation];
}

#pragma mark- ScrollView Delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = floor((self.scrollView.contentOffset.x - Screen_width/2)/Screen_width)+1;
    self.page.currentPage = page;
}

-(BOOL)isInteger:(NSString *)inputString{
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    if ([inputString rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        return YES;
    }
    return NO;
}

-(void)namesWithEmail:(NSString *)email{
    self.capitalizedFirstName = [self.firstName.text stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                        withString:[[self.firstName.text substringToIndex:1]    capitalizedString]];
    self.capitalizedLastName = [self.lastName.text stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                      withString:[[self.lastName.text substringToIndex:1] capitalizedString]];
}

-(void)setupGestureRecognizer{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard{
    
    [self.email resignFirstResponder];
    [self.password resignFirstResponder];
    [self.recheckPassword resignFirstResponder];
    [self.phone resignFirstResponder];
    [self.firstName resignFirstResponder];
    [self.lastName resignFirstResponder];
    [self checkAllValidation];
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
