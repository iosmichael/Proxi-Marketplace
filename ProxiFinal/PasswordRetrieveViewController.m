//
//  PasswordRetrieveViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 1/10/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import "PasswordRetrieveViewController.h"

#import "UserConnection.h"

@interface PasswordRetrieveViewController ()

@end

@implementation PasswordRetrieveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self.submitButton layer]setCornerRadius:10];
    [[self.cancelButton layer]setCornerRadius:10];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(passwordSuccess:) name:@"RetrievePasswordNotification" object:nil];
    self.email.validationType = JAMValidatingTextFieldTypeEmail;
    self.phone.validationType=JAMValidatingTextFieldTypePhone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)passwordSuccess:(NSNotification *)noti{
    self.submitButton.enabled = YES;
    self.cancelButton.enabled = YES;
    if ([[noti object]isEqualToString:@"success"]) {
        UIAlertController * alertYes=   [UIAlertController
                                         alertControllerWithTitle:@"Success"
                                         message:@"Please Check Your Email For Verification."
                                         preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {//Handel your yes please button action here
                                        [alertYes dismissViewControllerAnimated:YES completion:^{
                                            [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
                                        }];
                                    }];
        [alertYes addAction:yesButton];
        [self presentViewController:alertYes animated:YES completion:nil];
    }else{
        UIAlertController * alertNo=   [UIAlertController
                                         alertControllerWithTitle:@"Error"
                                         message:@"Invalid Account Information"
                                         preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* noButton = [UIAlertAction
                                    actionWithTitle:@"Cancel"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {//Handel your yes please button action here
                                        [alertNo dismissViewControllerAnimated:YES completion:^{
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                        }];
                                    }];
        [alertNo addAction:noButton];
        [self presentViewController:alertNo animated:YES completion:nil];
    }
}

- (IBAction)submit:(id)sender {
    if (self.email.validationStatus!=JAMValidatingTextFieldStatusValid||self.phone.validationStatus!=JAMValidatingTextFieldStatusValid) {
        self.email.text = @"";
        self.phone.text = @"";
    }else{
        UserConnection *con = [[UserConnection alloc]init];
        [con retrievePassword:self.email.text phone:self.phone.text];
        self.submitButton.enabled=NO;
        self.cancelButton.enabled=NO;
    }
}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter]removeObserver:self];
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

@end
