//
//  BraintreeAccountSignUpViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 3/25/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import "BraintreeAccountSignUpViewController.h"
#import "UserConnection.h"
#import <ActionSheetPicker-3.0/ActionSheetStringPicker.h>
#define stateList @"AL,AK,AZ,AR,CA,CO,CT,DE,FL,GA,HI,ID,IL,IN,IA,KS,KY,LA,ME,MD,MA,MI,MN,MS,MO,MT,NE,NV,NH,NJ,NM,NY,NC,ND,OH,OK,OR,PA,RI,SC,SD,TN,TX,UT,VT,VA,WA,WV,WI,WY"
#define RegisterPassProtocol @"success"
#define highlight_color [UIColor colorWithRed:36/255.0 green:104/255.0 blue:156/255.0 alpha:1.0]
#define gray [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1]

@interface BraintreeAccountSignUpViewController ()<UITextFieldDelegate>

@end

@implementation BraintreeAccountSignUpViewController{
    NSArray *states;
    BOOL stateSelected;
    NSString *selectedState;
    NSInteger stateSelectedIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    stateSelectedIndex = 13;
    // Do any additional setup after loading the view from its nib.
    [self setupTextfieldSettings];
    [self setupGestureRecognizer];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.translucent = NO;
    states = [stateList componentsSeparatedByString:@","];
    [self checkAllValidation];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(registerSuccessResponse:) name:@"RegisterMerchantPassNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(registerErrorResponse) name:@"RegisterMerchantFailNotification" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (IBAction)selectStateButtonTapped:(id)sender {
    [self dismissKeyboard];
    [ActionSheetStringPicker showPickerWithTitle:@"Select State"
                                            rows:states
                                initialSelection:stateSelected
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           stateSelected = YES;
                                           selectedState = selectedValue;
                                           stateSelectedIndex = selectedIndex;
                                           self.selectState.titleLabel.text = selectedState;
                                               [self checkAllValidation];
                                           
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         stateSelected = NO;
                                    [self checkAllValidation];
                                     }
                                          origin:sender];
    [self checkAllValidation];
    
}
- (IBAction)registerMerchantButtonTapped:(id)sender {
    [self checkAllValidation];
    if (!self.registerButton.enabled) {
        return;
    }
   
    NSString *dOB =[[[[self.year.text stringByAppendingString:@"-"] stringByAppendingString:self.month.text]stringByAppendingString:@"-"]stringByAppendingString:self.day.text];
    NSDictionary *merchantInfo = @{@"dateOfBirth":dOB,
                           @"username":[[NSUserDefaults standardUserDefaults]objectForKey:@"username"],
                           @"street":self.street.text,
                           @"city": self.city.text,
                           @"zipcode":self.zipcode.text,
                           @"state":selectedState
                               };
    UserConnection *connection = [[UserConnection alloc]init];
    self.registerButton.enabled = NO;
    [connection registerSubMerchantInfo:merchantInfo];
}

-(void)setupTextfieldSettings{
    self.zipcode.validationType = JAMValidatingTextFieldTypeZIP;
    self.year.validationBlock = ^{
        if (self.year.text.length==0) {
            return JAMValidatingTextFieldStatusIndeterminate;
        }
        if (![self isInteger:self.year.text]|| [self.year.text integerValue]>2000||[self.year.text integerValue]<1900) {
            return JAMValidatingTextFieldStatusInvalid;
        }
        if (!(self.year.text.length==4)) {
            return JAMValidatingTextFieldStatusInvalid;
        }
        else{
            return JAMValidatingTextFieldStatusValid;
        }
    };
    self.month.validationBlock = ^{
        if (self.month.text.length==0) {
            return JAMValidatingTextFieldStatusIndeterminate;
        }
        if (!([self isInteger:self.month.text])||!([self.month.text integerValue]>0)||!([self.month.text integerValue]<13)) {
            return JAMValidatingTextFieldStatusInvalid;
        }
        if (!(self.month.text.length==2)) {
            return JAMValidatingTextFieldStatusInvalid;
        }else{
            return JAMValidatingTextFieldStatusValid;
        }
    };
    self.day.validationBlock = ^{
        if (self.day.text.length==0) {
            return JAMValidatingTextFieldStatusIndeterminate;
        }
        if (!([self isInteger:self.day.text])||!([self.day.text integerValue]>0)||!([self.day.text integerValue]<32)) {
            return JAMValidatingTextFieldStatusInvalid;
        }
        if (!(self.day.text.length==2)) {
            return JAMValidatingTextFieldStatusInvalid;
        }else{
            return JAMValidatingTextFieldStatusValid;
        }
    };
    self.year.required=  YES;
    self.month.required = YES;
    self.day.required = YES;
    self.street.required = YES;
    self.city.required = YES;
    self.zipcode.required = YES;

    self.year.delegate = self;
    self.month.delegate = self;
    self.day.delegate = self;
    self.street.delegate = self;
    self.city.delegate = self;
    self.zipcode.delegate = self;
}

-(void)checkAllValidation{
    if (self.year.validationStatus==JAMValidatingTextFieldStatusValid&&
        self.month.validationStatus==JAMValidatingTextFieldStatusValid&&
        self.day.validationStatus==JAMValidatingTextFieldStatusValid&&self.street.text.length>3&&self.city.text.length>1&&self.zipcode.validationStatus==JAMValidatingTextFieldStatusValid&&
        stateSelected) {
        self.registerButton.enabled=YES;
        [self.registerButton setBackgroundColor:highlight_color];
        [self.registerAlertLabel setTextColor:[UIColor clearColor]];
    }else{
        [self.registerButton setBackgroundColor:gray];
        self.registerButton.enabled=NO;
        [self.registerAlertLabel setTextColor:[UIColor redColor]];
    }
}
-(void)clearAll{
    self.street.text =@"";
    self.city.text = @"";
    self.selectState.titleLabel.text = @"Select State";
    self.zipcode.text =@"";
    self.year.text =@"";
    self.month.text = @"";
    self.day.text = @"";
    stateSelected = NO;
    [self checkAllValidation];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self checkAllValidation];
}



-(BOOL)isInteger:(NSString *)inputString{
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    if ([inputString rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        return YES;
    }
    return NO;
}

-(void)registerSuccessResponse:(NSNotification *)noti{
    if ([[noti object]isEqualToString:RegisterPassProtocol]) {
        UIAlertController * alertYes=   [UIAlertController
                                         alertControllerWithTitle:@"Success"
                                         message:@"Thank you for registering as a Proxi merchant!"
                                         preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"isMerchant"];
                                        [self.navigationController popToRootViewControllerAnimated:YES];
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
                                        [alertNo dismissViewControllerAnimated:YES completion:nil];
                                       [self clearAll];
                                   }];
        
        [alertNo addAction:noButton];
        [self presentViewController:alertNo animated:YES completion:nil];
    }
}

-(void)registerErrorResponse{
    UIAlertController * alertNo=   [UIAlertController
                                    alertControllerWithTitle:@"Lost Connection"
                                    message:@"Weak Wifi Connection"
                                    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Re-Try"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   //Handel your yes please button action here
                                   [alertNo dismissViewControllerAnimated:YES completion:nil];
                               }];
    
    [alertNo addAction:noButton];
    [self presentViewController:alertNo animated:YES completion:nil];

}
-(void)setupGestureRecognizer{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}
-(void)dismissKeyboard{
    [self.street resignFirstResponder];
    [self.city resignFirstResponder];
    [self.zipcode resignFirstResponder];
    [self.year resignFirstResponder];
    [self.month resignFirstResponder];
    [self.day resignFirstResponder];
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
