//
//  TransactionTableViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 11/2/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "TransactionTableViewController.h"
#import "OrderConnection.h"
#import "ChatViewController.h"
#import "Order.h"
#define Screen_width [[UIScreen mainScreen]bounds].size.width


@interface TransactionTableViewController ()

@end

@implementation TransactionTableViewController{
    UILabel *item_title;
    UILabel *policy;
    UITextView *thankyouNote;
    UILabel *item_price;
    UIButton *completeTransaction;
    UIView *personDetailView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"regularCell"];
    self.navigationItem.title = @"Transaction";
    self.tableView.allowsSelection = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:87/255.0 green:183/255.0 blue:182/255.0 alpha:1.0];
    [self setupElements];
    [self setupPersonInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 4;
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
            return @"Buyer Information";
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
            [cell.contentView addSubview:personDetailView];
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
}

-(void)setupPersonInfo{
    personDetailView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 100)];
    UIButton *personButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 100)];
    [personButton addTarget:self action:@selector(personButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *personIcon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 40, 40)];
    [personIcon setImage:[UIImage imageNamed:@"userIcon"]];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 15, Screen_width-75, 17)];
    UILabel *emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 36, Screen_width - 75, 17)];
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 60, Screen_width - 75, 17)];
    NSAttributedString *nameStr =[[NSAttributedString alloc]initWithString:[self profileName:self.order.user_info[@"user_email"]] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:14]}];
    nameLabel.attributedText = nameStr;
    NSAttributedString *emailStr =[[NSAttributedString alloc]initWithString:self.order.user_info[@"user_email"] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:14]}];
    emailLabel.attributedText = emailStr;
    NSAttributedString *phoneStr =[[NSAttributedString alloc]initWithString:self.order.user_info[@"user_phone"] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:14]}];
    phoneLabel.attributedText = phoneStr;
    [personDetailView addSubview:personIcon];
    [personDetailView addSubview:nameLabel];
    [personDetailView addSubview:emailLabel];
    [personDetailView addSubview:phoneLabel];
    [personDetailView addSubview:personButton];
    
    
}

-(void)personButtonTapped{
    ChatViewController *chatViewController = [[ChatViewController alloc]init];
    chatViewController.title = [self profileName:self.order.user_info[@"user_email"]];
    chatViewController.seller_email = self.order.user_info[@"user_email"];
    [self.navigationController pushViewController:chatViewController animated:YES];
}

-(NSString *)profileName:(NSString *)email{
    NSString *usernameString = email;
    NSArray *components = [usernameString componentsSeparatedByString:@"@"];
    NSString *nameString = [components objectAtIndex:0];
    NSArray *nameComponents = [nameString componentsSeparatedByString:@"."];
    NSString *firstName = [nameComponents objectAtIndex:0];
    
    NSString *capitalizedFirstName = [firstName stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                        withString:[[firstName substringToIndex:1] capitalizedString]];
    NSString *lastName = [nameComponents objectAtIndex:1];
    NSString *capitalizedLastName = [lastName stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                      withString:[[lastName substringToIndex:1] capitalizedString]];
    
    NSString *fullName = [capitalizedFirstName stringByAppendingString:[@" " stringByAppendingString:capitalizedLastName]];
    return fullName;
    
}

@end
