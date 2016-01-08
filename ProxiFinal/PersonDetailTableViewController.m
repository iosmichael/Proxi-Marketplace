//
//  PersonDetailTableViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 10/20/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "PersonDetailTableViewController.h"
#import "MyTableViewCell.h"
#import "TransactionTableViewController.h"
#import "OrderDetailTableViewController.h"
#import "ChatViewController.h"
#import "ItemConnection.h"
#import "ItemContainer.h"
#import "HHAlertView.h"
#import "Item.h"
#import "Order.h"
#import "Transaction.h"
#import "GMDCircleLoader.h"

#define Image_url_prefix @"http://proximarketplace.com/database/images/"

@interface PersonDetailTableViewController ()
@property (nonatomic,strong) ItemConnection *itemConnection;
@property (strong,nonatomic) ItemContainer *itemContainer;
@property (strong,nonatomic) NSArray *datasourceArray;
@property (nonatomic,strong) NSString *connectionMethod;

@end

@implementation PersonDetailTableViewController{
    NSIndexPath *deleteRow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyTableViewCell" bundle:nil] forCellReuseIdentifier:@"myTableViewCell"];
    self.navigationController.navigationItem.title= self.detailCategory;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:87/255.0 green:183/255.0 blue:182/255.0 alpha:1.0];
    if ([self.detailCategory isEqualToString:@"My Items"]) {
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.firebase = [[[[[Firebase alloc]initWithUrl:@"https://luminous-inferno-5888.firebaseio.com"]childByAppendingPath:@"users"]childByAppendingPath:@"WheatonCollege"]childByAppendingPath:[self profileName:[[NSUserDefaults standardUserDefaults]objectForKey:@"username"] withSpace:NO]];
    [self filterDetailCategory];
}
#warning viewDidDisappear added
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.firebase removeAllObservers];
    [GMDCircleLoader hideFromView:self.view animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.datasourceArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 101;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    // Delete the row from the data source
        deleteRow = indexPath;
        if ([[self.itemContainer.container objectAtIndex:indexPath.row]isKindOfClass:[Item class]]) {
            Item *item = [self.itemContainer.container objectAtIndex:indexPath.row];
            NSString *item_id = item.item_id;
            [self.itemConnection drop:item_id detail_category:self.detailCategory];
            [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
        }
        else{
                return;
            }
        }
        NSLog(@"%@",[self.detailCategory description]);
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myTableViewCell" forIndexPath:indexPath];

    if ([[self.itemContainer.container objectAtIndex:indexPath.row]isKindOfClass:[Item class]]) {
        
    
        Item *item = [self.itemContainer.container objectAtIndex:indexPath.row];
        if (!item.image) {
            UIImage *item_img= [UIImage imageNamed:@"manshoes"];
            [cell.cellImageView setImage:item_img];
        }else{
            [cell.cellImageView setImage:[UIImage imageWithData: item.image]];
        }
        cell.cellStatus.text = @"";
        cell.cellPrice.text = [@"$" stringByAppendingString:item.price_current];
        NSString *dateStr= [self stringToDate:item.date];
        cell.cellDescription.text = dateStr;
        cell.cellTitle.text = item.item_title;
        [cell.pointer setImage:nil];
        cell.badge.hidden = YES;
        cell.badgeNum.hidden = YES;
        
        return cell;
        
    }else if ([[self.itemContainer.container objectAtIndex:indexPath.row]isKindOfClass:[Order class]]){
        Order *order = [self.itemContainer.container objectAtIndex:indexPath.row];
        cell.cellPrice.text = [@"$" stringByAppendingString:order.order_price];
        if ([order.order_status isEqualToString:@"held"]) {
            if ([self.detailCategory isEqualToString:@"My Sells"]) {
                cell.cellStatus.text = @"Waiting for Delivery";
            }else{
            
                cell.cellStatus.text = @"Ready";
            }
        }else{
            cell.cellStatus.text = @"Payment Pending";
            cell.cellStatus.textColor = [UIColor redColor];
        }
        cell.cellTitle.text = order.item_title;
        NSString *dateStr = [self stringToDate:order.order_date];
        cell.cellDescription.text = dateStr;
        if(!order.message_number||[order.message_number isEqualToString:@"0"]){
            cell.badge.hidden = YES;
            cell.badgeNum.hidden= YES;
        }else {
            cell.badge.hidden = NO;
            cell.badgeNum.hidden = NO;
            [cell.badgeNum setText:order.message_number];
            NSLog(@"badgeNum: %@",cell.badgeNum.text);
        }
        if (!order.img_data) {
            UIImage *item_img= [UIImage imageNamed:@"manshoes"];
            [cell.cellImageView setImage:item_img];
        }else{
            [cell.cellImageView setImage:[UIImage imageWithData: order.img_data]];
        }
        return cell;
    }else if([[self.itemContainer.container objectAtIndex:indexPath.row]isKindOfClass:[Transaction class]]){
        Transaction *transaction = [self.itemContainer.container objectAtIndex:indexPath.row];
        cell.cellPrice.text = [@"$" stringByAppendingString:transaction.item_price];
        cell.cellStatus.text = @"";
        cell.cellTitle.text = transaction.item_title;
        if ([transaction.transaction_status isEqualToString:@"purchased"]) {
            [cell.cellImageView setImage:[UIImage imageNamed:@"Sold"]];
        }else{
            [cell.cellImageView setImage:[UIImage imageNamed:@"refund"]];
        }
        [cell.pointer setImage:nil];
        NSString *dateStr = [self stringToDate:transaction.bought_date];
        cell.cellDescription.text= dateStr;
        cell.badge.hidden = YES;
        cell.badgeNum.hidden = YES;
        return cell;
    }else{
        return cell;
    }

}

#pragma mark- Setup

-(void)filterDetailCategory{
    if (!self.detailCategory) {
        return;
    }
    if ([self.detailCategory isEqualToString:@"My Items"]) {
        self.connectionMethod = @"myItems";
        self.tableView.allowsSelection = NO;
    }else if([self.detailCategory isEqualToString:@"My Orders"]){
        self.connectionMethod = @"myOrders";
    }else if([self.detailCategory isEqualToString:@"My Sells"]){
        self.connectionMethod = @"mySells";
    }else if([self.detailCategory isEqualToString:@"My History"]){
        self.connectionMethod = @"myTransactions";
        self.tableView.allowsSelection = NO;
    }else{
        return;
    }
    [self setupDatabase:self.connectionMethod];
}

//Connection Method


-(void)setupDatabase:(NSString *)detailCategory{
    self.datasourceArray = [[NSArray alloc]init];
    self.itemConnection = [[ItemConnection alloc]init];
    self.itemContainer = [[ItemContainer alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"RefreshTableNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dropSuccess:) name:@"DropNotification" object:nil];
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"username"]) {
        return;
    }
    
    if ([self.detailCategory isEqualToString:@"My Items"]) {
        [self.itemConnection myItems:[[NSUserDefaults standardUserDefaults]objectForKey:@"username"] FromIndex:0 amount:20 detail_category:detailCategory];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTable:) name:@"MyTableNotification" object:nil];
    }else if([self.detailCategory isEqualToString:@"My Orders"]){
        [self.itemConnection myOrders:[[NSUserDefaults standardUserDefaults]objectForKey:@"username"] detail_category:detailCategory];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTableOrder:) name:@"MyOrderNotification" object:nil];
    }
    else if([self.detailCategory isEqualToString:@"My Sells"]){
        [self.itemConnection mySells:[[NSUserDefaults standardUserDefaults]objectForKey:@"username"] detail_category:detailCategory];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTableOrder:) name:@"MySellNotification" object:nil];
    }else if([self.detailCategory isEqualToString:@"My History"]){
#warning myHistory or transaction
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTableHistory:) name:@"MyHistoryNotification" object:nil];
        [self.itemConnection myTransactions:[[NSUserDefaults standardUserDefaults]objectForKey:@"username"] detail_category:detailCategory];
        
    }
}

#pragma mark- Notification Selectors
-(void)refreshTable:(NSNotification *)noti{
    [self.itemContainer addItemsFromJSONDictionaries:[noti object]];
    self.datasourceArray = [self.itemContainer allItem];
    [self.tableView reloadData];
    [GMDCircleLoader hideFromView:self.view animated:YES];
}



-(void)refreshTableOrder:(NSNotification *)noti{
    NSArray *json = [noti object];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in json) {
        NSString *item_id = dic[@"item_id"];
        NSString *user_id = dic[@"user_id"];
        NSString *order_id = dic[@"order_id"];
        NSString *order_price = dic[@"order_price"];
        NSString *order_date = dic[@"order_date"];
        NSString *item_img_url = dic[@"item_img_url"];
        NSString *item_title = dic[@"item_title"];
        NSString *item_description = dic[@"item_description"];
        NSString *order_status = dic[@"order_status"];
        NSDictionary *user_info = dic[@"user_info"];
//Firebase Method here!
        Order *order = [[Order alloc]initWithItem:item_id user:user_id orderID:order_id orderDate:order_date orderPrice:order_price item_img_url:item_img_url item_title:item_title item_description:item_description user_info:user_info order_status:order_status];
        if (user_info[@"seller_email"]) {
            [self badgeUpdater:user_info[@"seller_email"] order:order];
        }else{
            [self badgeUpdater:user_info[@"user_email"] order:order];
        }
        [array addObject:order];
    }
    
    self.itemContainer.container = array;
    self.datasourceArray = array;
    [self.tableView reloadData];
    [GMDCircleLoader hideFromView:self.view animated:YES];
}

-(void)refreshTableHistory:(NSNotification *)noti{
    NSArray *json = [noti object];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in json) {
        NSString *item_title = dic[@"item_title"];
#warning dic[@"item_price"] is null from database; my history;
        NSString *item_price = dic[@"item_price"];
        NSString *bought_date = dic[@"sold_date"];
        NSString *transaction_status = dic[@"transaction_status"];
        Transaction *transaction = [[Transaction alloc]initWith:item_title date:bought_date price:item_price status:transaction_status];
        [array addObject:transaction];
    }
    self.itemContainer.container = array;
    self.datasourceArray = array;
    [self.tableView reloadData];
    [GMDCircleLoader hideFromView:self.view animated:YES];
}
 

-(void)refresh{
    self.datasourceArray = [self.itemContainer allItem];
    [self.tableView reloadData];
    [GMDCircleLoader hideFromView:self.view animated:YES];
}
-(void)dropSuccess:(NSNotification *)noti{
    NSString *protocol = [noti object];
    [GMDCircleLoader hideFromView:self.view animated:YES];
    if ([protocol isEqualToString:@"success"]) {
        [HHAlertView showAlertWithStyle:HHAlertStyleOk inView:self.view Title:@"Success" detail:@"delete item from database" cancelButton:nil Okbutton:@"thank you"];
        [self.itemContainer.container removeObjectAtIndex:deleteRow.row];
        self.datasourceArray = self.itemContainer.container;
        [self.tableView deleteRowsAtIndexPaths:@[deleteRow] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        [HHAlertView showAlertWithStyle:HHAlertStyleError inView:self.view Title:@"Sorry" detail:@"Item has been ordered" cancelButton:nil Okbutton:@"OK"];
    }

    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[self.datasourceArray objectAtIndex:indexPath.row]isKindOfClass:[Item class]]) {
        
    }else if ([[self.datasourceArray objectAtIndex:indexPath.row]isKindOfClass:[Order class]]&&[self.detailCategory isEqualToString:@"My Sells"]){
        /*TransactionTableViewController *ttvc = [[TransactionTableViewController alloc]init];
        Order *order = [self.datasourceArray objectAtIndex:indexPath.row];
        ttvc.order = order;
        [self.navigationController pushViewController:ttvc animated:YES];
         */
        Order *order = [self.datasourceArray objectAtIndex:indexPath.row];
        ChatViewController *chatViewController = [[ChatViewController alloc]init];
        chatViewController.title = [@"Buyer: " stringByAppendingString:[self profileName:order.user_info[@"user_email"]withSpace:YES]];
        chatViewController.seller_email = order.user_info[@"user_email"];
        [self.navigationController pushViewController:chatViewController animated:YES];
        
        
    }else if([[self.datasourceArray objectAtIndex:indexPath.row]isKindOfClass:[Order class]]&&[self.detailCategory isEqualToString:@"My Orders"]){
        OrderDetailTableViewController *odtvc = [[OrderDetailTableViewController alloc]init];
        Order *order = [self.datasourceArray objectAtIndex:indexPath.row];
        odtvc.order = order;
        [self.navigationController pushViewController:odtvc animated:YES];
        
    }
}

-(NSString *)stringToDate:(NSString *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *nwdate=[dateFormatter dateFromString:date];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    NSString *dateStr=[dateFormatter stringFromDate:nwdate];
    return dateStr;
}


-(NSString *)profileName:(NSString *)email withSpace:(BOOL)space{
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
    NSString *fullName;
    if (space) {
        fullName = [capitalizedFirstName stringByAppendingString:[@" " stringByAppendingString:capitalizedLastName]];
    }else{
        fullName = [capitalizedFirstName stringByAppendingString:capitalizedLastName];
    }
    
    return fullName;
    
}

-(void)badgeUpdater:(NSString *)email order:(Order *)order{

    [[[self.firebase queryOrderedByChild:@"sender"]queryEqualToValue:[self profileName:email withSpace:NO]] observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        if ([snapshot.value[@"read"]isEqualToString:@"yes"]) {
            return;
        }
        if (!order.badge_number) {
            order.badge_number = 1;
        }else{
            order.badge_number+=1;
        }
        NSString *messages = [NSString stringWithFormat:@"%i",order.badge_number];
        order.message_number = messages;
        NSLog(@"child badge added");
        [self.tableView reloadData];
    }];
}

@end
