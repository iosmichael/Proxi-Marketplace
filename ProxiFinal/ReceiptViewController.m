//
//  ReceiptViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 2/14/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import "ReceiptViewController.h"
#import "HHAlertView.h"
#import "OrderConnection.h"

@interface ReceiptViewController ()<BTDropInViewControllerDelegate,HHAlertViewDelegate>

@end

@implementation ReceiptViewController{
    UIViewController *presentedModalView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.order_button setEnabled:NO];
    [self setupBraintree];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orderPostSuccess:) name:@"CheckoutNotification" object:nil];
    [self setupElements];
    [[HHAlertView shared]setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)orderPostSuccess:(NSNotification *)noti{
    NSString *protocal = [noti object];
    if ([protocal isEqualToString:@"success"]) {
        [HHAlertView showAlertWithStyle:HHAlertStyleOk inView:self.view Title:@"Congrats!" detail:@"Thank you for using Proxi" cancelButton:nil Okbutton:@"Thank you"];
        //Dismiss Page
    }else if ([protocal isEqualToString:@"item has already been ordered"]){
        [HHAlertView showAlertWithStyle:HHAlertStyleError inView:self.view Title:@"Sorry" detail:@"Item has already been ordered" cancelButton:nil Okbutton:@"Cancel"];
    }
    else{
        [HHAlertView showAlertWithStyle:HHAlertStyleError inView:self.view Title:@"Error" detail:@"Order didn't process" cancelButton:nil
                               Okbutton:@"Cancel"];
    }
}

-(void)didClickButtonAnIndex:(HHAlertButton)button{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateTableNotification" object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark- Braintree API

-(void)setupBraintree{
    NSURL *clientTokenURL = [NSURL URLWithString:@"https://www.proximarketplace.com/database/generator.php"];
    NSMutableURLRequest *clientTokenRequest = [NSMutableURLRequest requestWithURL:clientTokenURL];
    [clientTokenRequest setValue:@"text/plain" forHTTPHeaderField:@"Accept"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:clientTokenRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // TODO: Handle errors
        NSString *clientToken = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        // Initialize `Braintree` once per checkout session
        self.braintree = [Braintree braintreeWithClientToken:clientToken];
        [self.order_button setEnabled:YES];
        // As an example, you may wish to present our Drop-in UI at this point.
        // Continue to the next section to learn more...
    }] resume];
    
}

- (void)dropInViewController:(__unused BTDropInViewController *)viewController didSucceedWithPaymentMethod:(BTPaymentMethod *)paymentMethod {
    // Send payment method nonce to your server
    [self postNonceToServer:paymentMethod.nonce];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dropInViewControllerDidCancel:(__unused BTDropInViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)paymentButtonTapped{
    // If you haven't already, create and retain a `Braintree` instance with the client token.
    // Typically, you only need to do this once per session.
    //self.braintree = [Braintree braintreeWithClientToken:aClientToken];
    
    // Create a BTDropInViewController
    BTDropInViewController *dropInViewController = [self.braintree dropInViewControllerWithDelegate:self];
    // This is where you might want to customize your Drop in. (See below.)
    
    // The way you present your BTDropInViewController instance is up to you.
    // In this example, we wrap it in a new, modally presented navigation controller:
    dropInViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                                          target:self
                                                                                                          action:@selector(userDidCancelPayment)];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:dropInViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)userDidCancelPayment {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)postNonceToServer:(NSString *)paymentMethodNonce {
    OrderConnection *connection = [[OrderConnection alloc]init];
    [connection postOrder:[[NSUserDefaults standardUserDefaults]objectForKey:@"username"] item:self.item paymentMethodNonce:paymentMethodNonce];
}

-(void)setupElements{
    if (self.item.image) {
        [self.receipt_image setImage:[UIImage imageWithData:self.item.image]];
    }else{
        [self.receipt_image setImage:[UIImage imageNamed:@"manshoes"]];
    }
    self.receipt_title.text = self.item.item_title;
    self.receipt_date.text = self.timeStr;
    self.receipt_price.text = [@"Price: $" stringByAppendingString:self.item.price_current];
    self.order_button.layer.cornerRadius = 10.0;
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
