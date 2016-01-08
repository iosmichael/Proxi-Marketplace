//
//  OrderConfirmationTableViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 10/31/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "OrderConfirmationTableViewController.h"
#import "OrderConnection.h"
#import "HHAlertView.h"
#import "LoginViewController.h"
// Display Item Title, Item Price, Message to the Seller and Item Description and Link to PayPal

@interface OrderConfirmationTableViewController ()<HHAlertViewDelegate,BTDropInViewControllerDelegate>

@end

@implementation OrderConfirmationTableViewController{
    UILabel *item_title;
    UILabel *instruction;
    UITextView *messageToSeller;
    UILabel *item_price;
    UIButton *forwardOrder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBraintree];
    
    
    [[HHAlertView shared] setDelegate:self];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"regularTableViewCell"];
    self.tableView.allowsSelection = NO;
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Checkout";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:87/255.0 green:183/255.0 blue:182/255.0 alpha:1.0];
    self.navigationController.navigationBar.translucent = YES;
    [[HHAlertView shared]setDelegate:self];
    [self setupElements];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"username"]) {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginID"];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 1:
            return @"EXCHANGE";
            break;
            
        default:
            return nil;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 50;
            break;
        case 1:
            return 110;
            break;
        case 2:
            return 110;
            break;
        case 3:
            return 50;
            break;
        case 4:
            return 70;
            break;
        default:
            return 0;
            break;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView dequeueReusableCellWithIdentifier:@"regularTableViewCell"];
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    switch (indexPath.section) {
        case 0:
            [cell.contentView addSubview:item_title];
            break;
        case 1:
            [cell.contentView addSubview:instruction];
            break;
        case 2:
            [cell.contentView addSubview:messageToSeller];
            break;
        case 3:
            [cell.contentView addSubview:item_price];
            break;
        case 4:
            [cell.contentView addSubview:forwardOrder];
            break;
        default:
            break;
    }
    
    return cell;
}


-(void)setupElements{
    
    CGFloat screen_width = [[UIScreen mainScreen]bounds].size.width;
    item_title = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, screen_width-20,50)];
    item_title.text = [@"Item Title:  " stringByAppendingString: self.orderItem.item_title];
    instruction = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, screen_width-20, 110)];
    instruction.lineBreakMode = NSLineBreakByWordWrapping;
    instruction.numberOfLines = 0;
    instruction.text = @"Proxi will craft a pre-made message using your phone number to connect you will the seller once the purchase has been made.The exchange will take place in person on campus.";
    messageToSeller = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, screen_width-20, 100)];
    item_price = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, screen_width-20, 50)];
    item_price.text = [@"Item Price:  $" stringByAppendingString:self.orderItem.price_current];
    forwardOrder = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, screen_width-20, 70)];
    [forwardOrder addTarget:self action:@selector(paymentButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [forwardOrder setTitle:@"Check Out" forState:UIControlStateNormal];
    forwardOrder.backgroundColor = [UIColor colorWithRed:251/255.0 green:176/255.0 blue:87/255.0 alpha:1];
    forwardOrder.layer.cornerRadius = 15;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orderPostSuccess:) name:@"CheckoutNotification" object:nil];
}


-(void)orderPostSuccess:(NSNotification *)noti{
    NSString *protocal = [noti object];
    if ([protocal isEqualToString:@"success"]) {
        [HHAlertView showAlertWithStyle:HHAlertStyleOk inView:self.view Title:@"Success" detail:@"Congrats! Please Contact With The Sellers" cancelButton:@"Thank you" Okbutton:@"View Seller Detail"];
        //Dismiss Page
    }else{
        [HHAlertView showAlertWithStyle:HHAlertStyleError inView:self.view Title:@"Error" detail:@"Please Check Your WIFI Connection or Contact With Our Support Team" cancelButton:nil Okbutton:@"Cancel"];
        
    }
}


-(void)didClickButtonAnIndex:(HHAlertButton)button{
    if (button ==HHAlertButtonOk) {
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if (button ==HHAlertButtonCancel){
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


#pragma mark- Braintree API

-(void)setupBraintree{
    // TODO: Handle errors
    
    //Only for sandbox
    
    NSString *clientToken = @"eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiI4NTVhYzBkMjIzZGU3NWQ3N2RkMjdkZGQxMjU1NmNhMDJiMGE5MjUzOTQyODZlN2FkOTA2ODkxYzAzMGJkNmNkfGNyZWF0ZWRfYXQ9MjAxNS0xMS0yNFQwMTo0NTowMi4zMTQxMDIxMDIrMDAwMFx1MDAyNm1lcmNoYW50X2lkPTM0OHBrOWNnZjNiZ3l3MmJcdTAwMjZwdWJsaWNfa2V5PTJuMjQ3ZHY4OWJxOXZtcHIiLCJjb25maWdVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvMzQ4cGs5Y2dmM2JneXcyYi9jbGllbnRfYXBpL3YxL2NvbmZpZ3VyYXRpb24iLCJjaGFsbGVuZ2VzIjpbXSwiZW52aXJvbm1lbnQiOiJzYW5kYm94IiwiY2xpZW50QXBpVXJsIjoiaHR0cHM6Ly9hcGkuc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbTo0NDMvbWVyY2hhbnRzLzM0OHBrOWNnZjNiZ3l3MmIvY2xpZW50X2FwaSIsImFzc2V0c1VybCI6Imh0dHBzOi8vYXNzZXRzLmJyYWludHJlZWdhdGV3YXkuY29tIiwiYXV0aFVybCI6Imh0dHBzOi8vYXV0aC52ZW5tby5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIiwiYW5hbHl0aWNzIjp7InVybCI6Imh0dHBzOi8vY2xpZW50LWFuYWx5dGljcy5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIn0sInRocmVlRFNlY3VyZUVuYWJsZWQiOnRydWUsInRocmVlRFNlY3VyZSI6eyJsb29rdXBVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvMzQ4cGs5Y2dmM2JneXcyYi90aHJlZV9kX3NlY3VyZS9sb29rdXAifSwicGF5cGFsRW5hYmxlZCI6dHJ1ZSwicGF5cGFsIjp7ImRpc3BsYXlOYW1lIjoiQWNtZSBXaWRnZXRzLCBMdGQuIChTYW5kYm94KSIsImNsaWVudElkIjpudWxsLCJwcml2YWN5VXJsIjoiaHR0cDovL2V4YW1wbGUuY29tL3BwIiwidXNlckFncmVlbWVudFVybCI6Imh0dHA6Ly9leGFtcGxlLmNvbS90b3MiLCJiYXNlVXJsIjoiaHR0cHM6Ly9hc3NldHMuYnJhaW50cmVlZ2F0ZXdheS5jb20iLCJhc3NldHNVcmwiOiJodHRwczovL2NoZWNrb3V0LnBheXBhbC5jb20iLCJkaXJlY3RCYXNlVXJsIjpudWxsLCJhbGxvd0h0dHAiOnRydWUsImVudmlyb25tZW50Tm9OZXR3b3JrIjp0cnVlLCJlbnZpcm9ubWVudCI6Im9mZmxpbmUiLCJ1bnZldHRlZE1lcmNoYW50IjpmYWxzZSwiYnJhaW50cmVlQ2xpZW50SWQiOiJtYXN0ZXJjbGllbnQzIiwiYmlsbGluZ0FncmVlbWVudHNFbmFibGVkIjp0cnVlLCJtZXJjaGFudEFjY291bnRJZCI6ImFjbWV3aWRnZXRzbHRkc2FuZGJveCIsImN1cnJlbmN5SXNvQ29kZSI6IlVTRCJ9LCJjb2luYmFzZUVuYWJsZWQiOmZhbHNlLCJtZXJjaGFudElkIjoiMzQ4cGs5Y2dmM2JneXcyYiIsInZlbm1vIjoib2ZmIn0=";
    
    // Initialize `Braintree` once per checkout session
    self.braintree = [Braintree braintreeWithClientToken:clientToken];
}

- (void)dropInViewController:(__unused BTDropInViewController *)viewController didSucceedWithPaymentMethod:(BTPaymentMethod *)paymentMethod {
    // Send payment method nonce to your server
    [self postNonceToServer:paymentMethod.nonce];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dropInViewControllerDidCancel:(__unused BTDropInViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)paymentButtonTapped{
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
    [connection postOrder:[[NSUserDefaults standardUserDefaults]objectForKey:@"username"] item:self.orderItem messageToSeller:messageToSeller.text paymentMethodNonce:paymentMethodNonce];

}

@end
