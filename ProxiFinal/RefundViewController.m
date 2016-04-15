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

#define complete_button_background [UIColor colorWithRed:104/255.0 green:198/255.0 blue:196/255.0 alpha:1]

@interface RefundViewController ()<HHAlertViewDelegate,UITextFieldDelegate,UITextViewDelegate>

@end

@implementation RefundViewController{
    int numbersOfOrderDaysBeforeRefund;
    BOOL textViewEdited;
    BOOL policyPassed;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[HHAlertView shared]setDelegate:self];
    self.navigationController.navigationBar.translucent = NO;
    self.feedback.delegate = self;
    self.item_title.text = self.order.item_title;
    self.refundAmount.text = [@"Refund Amount: $" stringByAppendingString:self.order.order_price];
    numbersOfOrderDaysBeforeRefund = 10;
    [self setupRefundTimeRequirement];
    [self setupGestureRecognizer];
    [self checkValidation];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.completeRefundButton.layer.cornerRadius = 25;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submitRefund:(id)sender {
    
    OrderConnection *orderConnection = [[OrderConnection alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finish:) name:@"RefundNotification" object:nil];
    [orderConnection refund:self.order.item_id feedback:self.feedback.text];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(void)setupGestureRecognizer{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}
-(void)dismissKeyboard{
    [self.feedback resignFirstResponder];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (!textViewEdited) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    textViewEdited = YES;
    [self checkValidation];
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length==0) {
        textViewEdited= NO;
        self.feedback.text = @"What is wrong?";
        self.feedback.textColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1];
    }
    [self checkValidation];
}
-(void)checkValidation{
    if (!textViewEdited||!policyPassed) {
        self.completeRefundButton.enabled = NO;
        self.completeRefundButton.backgroundColor = [UIColor grayColor];
    }else{
        self.completeRefundButton.enabled = YES;
        self.completeRefundButton.backgroundColor = complete_button_background;
    }
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
        self.feedback.text = @"";
        self.submitButton.enabled= YES;
    }else if (button==HHAlertButtonOk){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
-(void)setupRefundTimeRequirement{
    NSDate *now = [NSDate date];
    NSDate *tenDaysBefore = [now dateByAddingTimeInterval:-60*60*24*numbersOfOrderDaysBeforeRefund];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *order_date = [dateFormatter dateFromString:self.order.order_date];
    if ([order_date compare:tenDaysBefore]==NSOrderedAscending) {
        self.alertLabel.hidden = YES;
        policyPassed = YES;
    }else{
        self.completeRefundButton.enabled = NO;
        self.completeRefundButton.backgroundColor = [UIColor grayColor];
        self.alertLabel.hidden = NO;
        
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
