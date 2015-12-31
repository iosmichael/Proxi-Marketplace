//
//  TransactionTableViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 11/2/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "TransactionTableViewController.h"
#import "HHAlertView.h"
#import "OrderConnection.h"
#import "Order.h"


@interface TransactionTableViewController ()<HHAlertViewDelegate>

@end

@implementation TransactionTableViewController{
    UILabel *item_title;
    UILabel *policy;
    UITextView *thankyouNote;
    UILabel *item_price;
    UIButton *completeTransaction;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"regularCell"];
    self.navigationItem.title = @"Transaction";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:87/255.0 green:183/255.0 blue:182/255.0 alpha:1.0];
    [[HHAlertView shared]setDelegate:self];
    [self setupElements];
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            return 50;
            break;
        case 1:
            return 50;
            break;
        case 2:
            return 110;
            break;
        case 3:
            return 110;
            break;
        case 4:
            return 70;
            break;
        default:
            return 0;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 2:
            return @"Term & Policy";
            break;
        case 3:
            return @"Write a Thank you Note";
            break;
        default:
            return nil;
            break;
    }

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"regularCell" forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            [cell.contentView addSubview:item_title];
            break;
        case 1:
            [cell.contentView addSubview:item_price];
            break;
        case 2:
            [cell.contentView addSubview:policy];
            break;
        case 3:
            [cell.contentView addSubview:thankyouNote];
            break;
        case 4:
            [cell.contentView addSubview:completeTransaction];
            break;
        default:
            break;
    }
    return cell;
}


-(void)setupElements{
    CGFloat screen_width = [[UIScreen mainScreen]bounds].size.width;
    item_title = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, screen_width-20,50)];
    item_title.text = [@"Item Title:  " stringByAppendingString: self.order.item_title];
    policy = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, screen_width-20, 110)];
    policy.lineBreakMode = NSLineBreakByWordWrapping;
    policy.numberOfLines = 0;
    policy.text = @"Proxi will craft a pre-made message using your phone number to connect you will the seller once the purchase has been made.The exchange will take place in person on campus.";
    thankyouNote = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, screen_width-20, 100)];
    item_price = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, screen_width-20, 50)];
    item_price.text = [@"Item Price:  $" stringByAppendingString:self.order.order_price];
    completeTransaction = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, screen_width-20, 70)];
    [completeTransaction addTarget:self action:@selector(completeTransactionButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [completeTransaction setTitle:@"Check Out" forState:UIControlStateNormal];
    completeTransaction.backgroundColor = [UIColor colorWithRed:251/255.0 green:176/255.0 blue:87/255.0 alpha:1];
    completeTransaction.layer.cornerRadius = 15;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkoutPostSuccess:) name:@"FinishCheckoutNotification" object:nil];
    
    if (![self.order.order_status isEqualToString:@"held"]) {
        completeTransaction.enabled = NO;
        completeTransaction.backgroundColor = [UIColor grayColor];
        [completeTransaction setTitle:@"Payment Pending..." forState:UIControlStateNormal];
    }
    
}

-(void)completeTransactionButtonTapped{
    OrderConnection *orderConnection = [[OrderConnection alloc]init];
    [orderConnection finishCheckOut:self.order.item_id];
    NSLog(@"%@",[self.order description]);
   // [HHAlertView showAlertWithStyle:HHAlertStyleDefault inView:self.view Title:@"Are Your Sure?" detail:@"Confirm transaction after you received money" cancelButton:@"Not now" Okbutton:@"Yes"];
}

-(void)checkoutPostSuccess:(NSNotification *)noti{
    NSString *protocal = [noti object];
    NSLog(@"protocal: %@",[protocal description]);
    if ([protocal isEqualToString:@"success"]) {
        [HHAlertView showAlertWithStyle:HHAlertStyleOk inView:self.view Title:@"Success" detail:@"Thank you for using our App!" cancelButton:nil Okbutton:@"OK"];
    }else{
        [HHAlertView showAlertWithStyle:HHAlertStyleError inView:self.view Title:@"Error" detail:@"Please check your WIFI connection" cancelButton:nil Okbutton:@"OK"];
    }
}

-(void)didClickButtonAnIndex:(HHAlertButton)button{
    if (button==HHAlertStyleOk) {
        OrderConnection *orderConnection = [[OrderConnection alloc]init];
        [orderConnection finishCheckOut:self.order.item_id];
    }
}

@end
