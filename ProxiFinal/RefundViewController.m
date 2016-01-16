//
//  RefundViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 1/9/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import "RefundViewController.h"
#import "OrderConnection.h"
#import "HHAlertView.h"

@interface RefundViewController ()<HHAlertViewDelegate,UITextFieldDelegate,UITextViewDelegate>

@end

@implementation RefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[HHAlertView shared]setDelegate:self];
    self.navigationController.navigationBar.translucent = NO;
    self.refundCode.delegate = self;
    self.feedback.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submitRefund:(id)sender {
    
    OrderConnection *orderConnection = [[OrderConnection alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finish:) name:@"RefundNotification" object:nil];
    [orderConnection refund:self.order.item_id refundCode:self.refundCode.text];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.refundCode resignFirstResponder];
    return NO;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(void)finish:(NSNotification *)noti{
    NSString *protocal = [noti object];
    NSLog(@"protocal: %@",[protocal description]);
    if ([protocal isEqualToString:@"success"]) {
        [HHAlertView showAlertWithStyle:HHAlertStyleOk inView:self.view Title:@"Success" detail:@"Thank you" cancelButton:nil Okbutton:@"OK"];
    }else{
        [HHAlertView showAlertWithStyle:HHAlertStyleError inView:self.view Title:@"Error" detail:@"Please Contact Proxi" cancelButton:@"Cancel" Okbutton:nil];
    }
    
}
- (void)didClickButtonAnIndex:(HHAlertButton )button{
    if (button==HHAlertButtonCancel) {
        self.refundCode.text = @"";
        self.feedback.text = @"";
        self.submitButton.enabled= YES;
    }else if (button==HHAlertButtonOk){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
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
