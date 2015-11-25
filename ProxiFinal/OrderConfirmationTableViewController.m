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

@interface OrderConfirmationTableViewController ()<HHAlertViewDelegate>

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
#warning Incomplete implementation, return the number of sections
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
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
    [forwardOrder addTarget:self action:@selector(forwardOrderButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [forwardOrder setTitle:@"Check Out" forState:UIControlStateNormal];
    forwardOrder.backgroundColor = [UIColor colorWithRed:251/255.0 green:176/255.0 blue:87/255.0 alpha:1];
    forwardOrder.layer.cornerRadius = 15;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orderPostSuccess:) name:@"CheckoutNotification" object:nil];
}

-(void)forwardOrderButtonTapped{
    OrderConnection *connection = [[OrderConnection alloc]init];
    [connection postOrder:[[NSUserDefaults standardUserDefaults]objectForKey:@"username"] item:self.orderItem messageToSeller:messageToSeller.text];
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

@end
