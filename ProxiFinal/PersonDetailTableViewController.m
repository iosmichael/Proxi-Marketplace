//
//  PersonDetailTableViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 10/20/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "PersonDetailTableViewController.h"
#import "MyTableViewCell.h"
#import "RefundViewController.h"
#import "OrderDetailTableViewController.h"
#import "OrderConnection.h"
#import "ChatViewController.h"
#import "ItemConnection.h"
#import "ItemContainer.h"
#import "HHAlertView.h"
#import "Item.h"
#import "Order.h"
#import "Transaction.h"
#import "GMDCircleLoader.h"

#define Image_url_prefix @"http://proximarketplace.com/database/images/"
#define screen_width [UIScreen mainScreen].bounds.size.width
@interface PersonDetailTableViewController ()<MyTableViewCellDelegate,HHAlertViewDelegate>
@property (nonatomic,strong) ItemConnection *itemConnection;
@property (strong,nonatomic) ItemContainer *itemContainer;
@property (strong,nonatomic) ItemContainer *storeContainer;
@property (strong,nonatomic) NSString *confirm_status;

@property (strong,nonatomic) NSArray *datasourceArray;
@property (nonatomic,strong) NSString *connectionMethod;
@property (strong,nonatomic) NSArray *itemsArray;



@end

@implementation PersonDetailTableViewController{
    NSIndexPath *deleteRow;
    NSIndexPath *selectRow;
    BOOL sync_order;
    BOOL sync_item;
    UIViewController *presentingModalViewController;
    int numberToWarn;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyTableViewCell" bundle:nil] forCellReuseIdentifier:@"myTableViewCell"];
    if ([self.detailCategory isEqualToString:@"My Items"]) {
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
    self.tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    numberToWarn = 0;
    //self.tableView.tableHeaderView = [self setupTableViewHeader:![self.detailCategory isEqualToString:@"My Sales"] numberToWarn:numberToWarn];
    self.firebase = [[[[[Firebase alloc]initWithUrl:@"https://luminous-inferno-5888.firebaseio.com"]childByAppendingPath:@"users"]childByAppendingPath:@"WheatonCollege"]childByAppendingPath:[self profileName:[[NSUserDefaults standardUserDefaults]objectForKey:@"username"] withSpace:NO]];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshControlRefresh)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    [[HHAlertView shared]setDelegate:self];
    [self filterDetailCategory];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [[HHAlertView shared]setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.firebase removeAllObservers];
    [GMDCircleLoader hideFromView:self.view animated:YES];
}
-(void)viewDidDisappear:(BOOL)animated{
    [self.refreshControl endRefreshing];
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.detailCategory isEqualToString:@"My Orders"]||[self.detailCategory isEqualToString:@"My History"]) {
        return 1;
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.detailCategory isEqualToString:@"My Orders"]) {
        return [self.datasourceArray count];
    }else if ([self.detailCategory isEqualToString:@"My Sales"]){
        if (section==0) {
            return [self.datasourceArray count];
        }else if (section==1){
            return [self.itemsArray count];
        }else{
            return 0;
        }
    }
    return [self.datasourceArray count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([selectRow isEqual:indexPath]){
        return 102+40;
    }
    return 102;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==1) {
        return [self setupSubtableFooterView];
    }
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 43)];
    if ([self.detailCategory isEqualToString:@"My Sales"]) {
        //Three Icon Instructions
        UIView *iconFirst = [self createIntructionViewWith:[UIImage imageNamed:@"badge"] andWords:@"Message Notification" index:0];
        UIView *iconSecond = [self createIntructionViewWith:[UIImage imageNamed:@"finance"] andWords:@"Pending Payment" index:1];
        UIView *iconThird = [self createIntructionViewWith:[UIImage imageNamed:@"checkMark"] andWords:@"Item Delivered" index:2];
        [footer addSubview:iconFirst];
        [footer addSubview:iconSecond];
        [footer addSubview:iconThird];
    }
    footer.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return footer;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([self.detailCategory isEqualToString:@"My Orders"]) {
        return 0;
    }
    if (section==0) {
        return 43;
    }else{
        return 20;
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.detailCategory isEqualToString:@"My Sales"]) {
        if (indexPath.section==1) {
            return UITableViewCellEditingStyleDelete;
        }
    }else if([[self.itemContainer.container objectAtIndex:indexPath.row]isKindOfClass:[Transaction class]]){
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    // Delete the row from the data source
        
        
        if ([self.detailCategory isEqualToString:@"My Sales"]) {
            if (indexPath.section==1) {
                
                Item *item = [self.storeContainer.container objectAtIndex:indexPath.row];
                NSString *item_id = item.item_id;
                [self.itemConnection drop:item_id detail_category:@"My Items"];
                [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
                deleteRow = indexPath;
    
            }
        }
        else if([[self.itemContainer.container objectAtIndex:indexPath.row]isKindOfClass:[Transaction class]]){
            Transaction *transaction = [self.itemContainer.container objectAtIndex:indexPath.row];
            [self.itemConnection hideTransaction:transaction.transaction_id];
            [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
            deleteRow = indexPath;
        }
        else{
                return ;
            }
        }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setDelegate:self];
    if ([selectRow isEqual:indexPath]) {
        cell.subbar.hidden=NO;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        Order *order = [self.itemContainer.container objectAtIndex:indexPath.row];
        cell.leftButtonWidth.constant = screenWidth/2;
        cell.rightButtonWidth.constant = screenWidth/2;
        [self createSubbarButtonViewWith:order andLeft:NO withCell:cell];
        [self createSubbarButtonViewWith:order andLeft:YES withCell:cell];
    }else{
        cell.subbar.hidden = YES;
    }
    
    if ([self.detailCategory isEqualToString:@"My Orders"]) {
        Order *order = [self.itemContainer.container objectAtIndex:indexPath.row];
            cell.cellPrice.text = [@"$" stringByAppendingString:order.order_price];
        
        //badge icon settings
        cell.badge.hidden = NO;
            if(order.message_number&&![order.message_number isEqualToString:@"0"]){
                
            }else if ([order.item_status isEqualToString:@"receive"]&&[order.order_status isEqualToString:@"held"]){
                cell.badge.image = [UIImage imageNamed:@"checkMark"];
                cell.leftButton.enabled = YES;
                numberToWarn++;
                //self.tableView.tableHeaderView = [self setupTableViewHeader:YES numberToWarn:numberToWarn];
            }else if([order.item_status isEqualToString:@"paid"]){
                cell.badge.image = [UIImage imageNamed:@"waitingDelivery"];
            }
            else if (![order.order_status isEqualToString:@"held"]){
                cell.badge.image = [UIImage imageNamed:@"finance"];
            }else{
                cell.badge.hidden=YES;
            }
        
        
        //end badge icon settings
            cell.cellTitle.text = order.item_title;
            NSString *dateStr = [self stringToDate:order.order_date];
            cell.cellDescription.text = dateStr;
        
            if (!order.img_data) {
                UIImage *item_img= [UIImage imageNamed:@"manshoes"];
                [cell.cellImageView setImage:item_img];
            }else{
                [cell.cellImageView setImage:[UIImage imageWithData: order.img_data]];
            }
            return cell;
    }else if ([self.detailCategory isEqualToString:@"My Sales"]){
        if (indexPath.section==0) {
            Order *order = [self.itemContainer.container objectAtIndex:indexPath.row];
            cell.cellPrice.text = [@"$" stringByAppendingString:order.order_price];
            
            cell.cellTitle.text = order.item_title;
            NSString *dateStr = [self stringToDate:order.order_date];
            cell.cellDescription.text = dateStr;
            //badge icon settings
            
            if(order.message_number&&![order.message_number isEqualToString:@"0"]){
                cell.badge.hidden = NO;
               
            }else if (![order.order_status isEqualToString:@"held"]){
                cell.badge.hidden=NO;
                cell.badge.image = [UIImage imageNamed:@"finance"];
               
            }else if ([order.item_status isEqualToString:@"receive"]){
                cell.badge.hidden=NO;
                cell.badge.image = [UIImage imageNamed:@"checkMark"];
            }
            else {
                cell.badge.hidden = YES;
            }
            //end badge icon settings
            
            if (!order.img_data) {
                UIImage *item_img= [UIImage imageNamed:@"manshoes"];
                [cell.cellImageView setImage:item_img];
            }else{
                [cell.cellImageView setImage:[UIImage imageWithData: order.img_data]];
            }
            return cell;

        }else if (indexPath.section==1){

            Item *item = [self.storeContainer.container objectAtIndex:indexPath.row];
            if (!item.image) {
                UIImage *item_img= [UIImage imageNamed:@"manshoes"];
                [cell.cellImageView setImage:item_img];
            }else{
                [cell.cellImageView setImage:[UIImage imageWithData: item.image]];
            }
            cell.cellPrice.text = [@"$" stringByAppendingString:item.price_current];
            NSString *dateStr= [self stringToDate:item.date];
            cell.cellDescription.text = dateStr;
            cell.cellTitle.text = item.item_title;
            cell.badge.hidden = YES;
            
            return cell;
        }else{
            return nil;
        }
    }else{
        if([[self.itemContainer.container objectAtIndex:indexPath.row]isKindOfClass:[Transaction class]]){
            Transaction *transaction = [self.itemContainer.container objectAtIndex:indexPath.row];
            cell.cellPrice.text = [@"$" stringByAppendingString:transaction.item_price];

            cell.cellTitle.text = transaction.item_title;
            if ([transaction.transaction_status isEqualToString:@"purchased"]) {
                [cell.cellImageView setImage:[UIImage imageNamed:@"Sold"]];
            }else{
                [cell.cellImageView setImage:[UIImage imageNamed:@"refund"]];
            }
            NSString *dateStr = [self stringToDate:transaction.bought_date];
            cell.cellDescription.text= dateStr;
            cell.badge.hidden = YES;
            return cell;
        }else{
            return nil;
        }
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
    }else if([self.detailCategory isEqualToString:@"My Sales"]){
        self.connectionMethod = @"mySells";
    }else if([self.detailCategory isEqualToString:@"My History"]){
        self.connectionMethod = @"myTransactions";
        self.tableView.allowsSelection = NO;
    }else{
        return;
    }
    
    
    
    if ([self.detailCategory isEqualToString:@"My Orders"]) {
        //Three Icon Instructions
        UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 43)];
        UIView *iconFirst = [self createIntructionViewWith:[UIImage imageNamed:@"badge"] andWords:@"Message Notification" index:0];
        UIView *iconSecond = [self createIntructionViewWith:[UIImage imageNamed:@"finance"] andWords:@"Pending Payment" index:1];
        UIView *iconThird = [self createIntructionViewWith:[UIImage imageNamed:@"waitingDelivery"] andWords:@"Waiting Delivery" index:2];
        [footer addSubview:iconFirst];
        [footer addSubview:iconSecond];
        [footer addSubview:iconThird];
        footer.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
        self.tableView.tableFooterView = footer;
    }
    
    
    
    [self setupDatabase:self.connectionMethod];
}

//Connection Method


-(void)setupDatabase:(NSString *)detailCategory{
    self.datasourceArray = [[NSArray alloc]init];
    self.itemConnection = [[ItemConnection alloc]init];
    self.itemContainer = [[ItemContainer alloc]init];
    self.storeContainer = [[ItemContainer alloc]init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"RefreshTableNotification" object:nil];
    if ([detailCategory isEqualToString:@"mySells"]) {
        
    }
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"username"]) {
        return;
    }
    
    if([self.detailCategory isEqualToString:@"My Orders"]){
        [self.itemConnection myOrders:[[NSUserDefaults standardUserDefaults]objectForKey:@"username"] detail_category:detailCategory];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTableOrder:) name:@"MyOrderNotification" object:nil];
    }
    else if([self.detailCategory isEqualToString:@"My Sales"]){
        [self.itemConnection myItems:[[NSUserDefaults standardUserDefaults]objectForKey:@"username"] FromIndex:0 amount:20 detail_category:@"myItems"];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTableItem:) name:@"MyTableNotification" object:nil];
        [self.itemConnection mySells:[[NSUserDefaults standardUserDefaults]objectForKey:@"username"] detail_category:detailCategory];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTableOrder:) name:@"MySellNotification" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dropSuccess:) name:@"DropNotification" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fulfilDelivery:) name:@"FulfillDeliveryNotification" object:nil];
    }else if([self.detailCategory isEqualToString:@"My History"]){

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTableHistory:) name:@"MyHistoryNotification" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dropHistorySuccess:) name:@"HideTransactionNotification" object:nil];
        [self.itemConnection myTransactions:[[NSUserDefaults standardUserDefaults]objectForKey:@"username"] detail_category:detailCategory];
        
    }
}

-(UIView *)createIntructionViewWith:(UIImage *)insturctionImage andWords:(NSString *)words index:(NSInteger)index{
    UIView *instructionView = [[UIView alloc]initWithFrame:CGRectMake(15+index*85, 9, 70+15, 25)];
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [icon setImage:insturctionImage];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20+10, 0, 45, 25)];
    label.numberOfLines= 0;
    label.attributedText = [[NSAttributedString alloc]initWithString:words attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gotham-Light" size:10]}];
    [instructionView addSubview:icon];
    [instructionView addSubview:label];
    return instructionView;
}

-(void)createSubbarButtonViewWith:(Order *)order andLeft:(BOOL)dir withCell:(MyTableViewCell *)cell{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if (!dir) {
        UIButton *right = cell.rightButton;
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 20)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30+20, 12, screenWidth/2-30-20, 16)];
        icon.image = [UIImage imageNamed:@"messageBox"];
        NSString *msgStr = [[NSString alloc]init];
        if ([self.detailCategory isEqualToString:@"My Sales"]) {
            msgStr = @"Message to Buyer";
        }else{
            msgStr = @"Message to Seller";
        }
        label.attributedText = [[NSAttributedString alloc]initWithString:msgStr attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gotham-Light" size:12],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        if (cell.setRight) {
            return;
        }
        [right addSubview:icon];
        [right addSubview:label];
        cell.setRight = YES;
        right.backgroundColor = [UIColor colorWithRed:29/255.0 green:129/255.0 blue:210/255.0 alpha:1];
    }else{
        UIButton *left = cell.leftButton;
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 25, 20)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(25+20, 12, screenWidth/2-25-20, 16)];
        NSString *msgStr = [[NSString alloc]init];
        icon.image = [UIImage imageNamed:@"exchangeConfirm"];
        if ([self.detailCategory isEqualToString:@"My Sales"]) {
            if ([order.item_status isEqualToString:@"receive"]&&[order.order_status isEqualToString:@"held"]){
                msgStr = @"Item Delivered";
            }else{
                msgStr = @"Fulfill Delivery";
            }
        }else{
            if(order.message_number&&![order.message_number isEqualToString:@"0"]){
                msgStr=@"Contact Seller";
            }else if ([order.item_status isEqualToString:@"receive"]&&[order.order_status isEqualToString:@"held"]){
                msgStr = @"Confirmation";
            }else if([order.item_status isEqualToString:@"paid"]){
                msgStr = @"Waiting Deliver";
            }else if (![order.order_status isEqualToString:@"held"]){
                msgStr = @"Pending Payment";
            }else{
                msgStr = @"Contact Proxi";
            }
        }
        label.attributedText = [[NSAttributedString alloc]initWithString:msgStr attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gotham-Light" size:13],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        if (cell.setLeft) {
            [cell.leftButtonLabel removeFromSuperview];
            cell.leftButtonLabel = label;
            [left addSubview:cell.leftButtonLabel];
            return;
        }
        cell.leftButtonLabel = label;
        [left addSubview:icon];
        [left addSubview:cell.leftButtonLabel];
        cell.setLeft = YES;
        left.backgroundColor = [UIColor colorWithRed:100/255.0 green:181/255.0 blue:246/255.0 alpha:1];
        
    }
    
}

#pragma mark- Notification Selectors
-(void)refreshTableItem:(NSNotification *)noti{
    [self.storeContainer.container removeAllObjects];
    [self.storeContainer addItemsFromJSONDictionaries:[noti object]];
    self.itemsArray = [self.storeContainer allItem];
    [self refreshTheWholeTable];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if ([self.detailCategory isEqualToString:@"My Sales"]) {
        if (section==0) {
            return @"Sold";
        }else if (section==1){
            return @"My Items";
        }else{
            return nil;
        }
    }else if([self.detailCategory isEqualToString:@"My Orders"]){
        return @"Bought";
    }else{
        return @"History";
    }
}

-(void)refreshTheWholeTable{
    numberToWarn = 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [GMDCircleLoader hideFromView:self.view animated:YES];
        });
    [self.refreshControl endRefreshing];
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
        NSString *item_status=dic[@"item_status"];
//Firebase Method here!
        Order *order = [[Order alloc]initWithItem:item_id user:user_id orderID:order_id orderDate:order_date orderPrice:order_price item_img_url:item_img_url item_title:item_title item_description:item_description user_info:user_info order_status:order_status item_status:item_status];
        if (user_info[@"seller_email"]) {
            [self badgeUpdater:user_info[@"seller_email"] order:order];
        }else{
            [self badgeUpdater:user_info[@"user_email"] order:order];
        }
        [array addObject:order];
    }
    
    self.itemContainer.container = array;
    self.datasourceArray = array;
    [self refreshTheWholeTable];
    
}



-(void)refreshTableHistory:(NSNotification *)noti{
    NSArray *json = [noti object];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in json) {
        NSString *item_title = dic[@"item_title"];

        NSString *item_price = dic[@"item_price"];
        NSString *bought_date = dic[@"sold_date"];
        NSString *transaction_status = dic[@"transaction_status"];
        NSString *transction_id = dic[@"transaction_id"];
        Transaction *transaction = [[Transaction alloc]initWith:item_title date:bought_date price:item_price status:transaction_status Trans_id:transction_id];
        [array addObject:transaction];
    }
    self.itemContainer.container = array;
    self.datasourceArray = array;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    [GMDCircleLoader hideFromView:self.view animated:YES];
}
 

-(void)refresh{
    self.datasourceArray = [self.itemContainer allItem];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    [GMDCircleLoader hideFromView:self.view animated:YES];
}
-(void)dropSuccess:(NSNotification *)noti{
    NSString *protocol = [noti object];
    [GMDCircleLoader hideFromView:self.view animated:YES];
    UIViewController *alertViewContainer = [self makingAlertViewController];
    if ([protocol isEqualToString:@"success"]) {
        [HHAlertView showAlertWithStyle:HHAlertStyleOk inView:alertViewContainer.view Title:@"Success" detail:@"Removed Item From Proxi" cancelButton:nil Okbutton:@"Thank You"];
        
        [self.storeContainer.container removeObjectAtIndex:deleteRow.row];
        self.itemsArray = self.storeContainer.container;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }else{
        [HHAlertView showAlertWithStyle:HHAlertStyleError inView:alertViewContainer.view Title:@"Sorry" detail:@"Please Check Your Wifi Connection" cancelButton:nil Okbutton:@"OK"];
    }
    [self presentViewController:alertViewContainer animated:YES completion:^{
        presentingModalViewController = alertViewContainer;
    }];

    
}

-(void)dropHistorySuccess:(NSNotification *)noti{
    NSString *protocol = [noti object];
    [GMDCircleLoader hideFromView:self.view animated:YES];
    UIViewController *alertViewContainer = [self makingAlertViewController];
    if ([protocol isEqualToString:@"success"]) {
        [HHAlertView showAlertWithStyle:HHAlertStyleOk inView:alertViewContainer.view Title:@"Success" detail:@"You Will No Longer View this History" cancelButton:nil Okbutton:@"Thank You"];
        [self.itemContainer.container removeObjectAtIndex:deleteRow.row];
        self.datasourceArray = self.itemContainer.container;
        [self.tableView deleteRowsAtIndexPaths:@[deleteRow] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        [HHAlertView showAlertWithStyle:HHAlertStyleError inView:alertViewContainer.view Title:@"Sorry" detail:@"Please Check Your Wifi Connection" cancelButton:nil Okbutton:@"OK"];
    }
    [self presentViewController:alertViewContainer animated:YES completion:^{
        presentingModalViewController = alertViewContainer;
    }];
    
    
}
- (void)didClickButtonAnIndex:(HHAlertButton )button{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)refreshControlRefresh{
    self.firebase = [[[[[Firebase alloc]initWithUrl:@"https://luminous-inferno-5888.firebaseio.com"]childByAppendingPath:@"users"]childByAppendingPath:@"WheatonCollege"]childByAppendingPath:[self profileName:[[NSUserDefaults standardUserDefaults]objectForKey:@"username"] withSpace:NO]];
    
    if([self.detailCategory isEqualToString:@"My Orders"]){
        [self.itemConnection myOrders:[[NSUserDefaults standardUserDefaults]objectForKey:@"username"] detail_category:@"myOrders"];
    }
    else if([self.detailCategory isEqualToString:@"My Sales"]){
        [self.itemConnection myItems:[[NSUserDefaults standardUserDefaults]objectForKey:@"username"] FromIndex:0 amount:20 detail_category:@"myItems"];
        [self.itemConnection mySells:[[NSUserDefaults standardUserDefaults]objectForKey:@"username"] detail_category:@"mySells"];
    }else{
        return;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.detailCategory isEqualToString:@"My Sales"]){
        if(indexPath.section==1){
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }else if (indexPath.section==0){
           
            if ([selectRow isEqual:indexPath]) {
                selectRow=nil;
            }else{
            selectRow = indexPath;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            return;
        }
    }else if([[self.datasourceArray objectAtIndex:indexPath.row]isKindOfClass:[Order class]]&&[self.detailCategory isEqualToString:@"My Orders"]){
        if (indexPath.section==0){
            
            if ([selectRow isEqual:indexPath]) {
                selectRow=nil;
            }else{
                selectRow = indexPath;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            return;
            
        }
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
    NSString *capitalizedLastName= capitalizedFirstName;
    if ([nameComponents count]>1) {
        NSString *lastName = [nameComponents objectAtIndex:1];
        capitalizedLastName = [lastName stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                withString:[[lastName substringToIndex:1] capitalizedString]];
    }
    
    NSString *fullName;
    if (space) {
        fullName = [capitalizedFirstName stringByAppendingString:[@" " stringByAppendingString:capitalizedLastName]];
    }else{
        fullName = [capitalizedFirstName stringByAppendingString:capitalizedLastName];
    }
    
    return fullName;
    
}

-(void)badgeUpdater:(NSString *)email order:(Order *)order{

    [[[self.firebase queryOrderedByChild:@"sender"]queryEqualToValue:email] observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        if ([snapshot.value[@"read"]isEqualToString:@"yes"]) {
            return;
        }
        if (!order.badge_number) {
            order.badge_number = 1;
        }else{
            order.badge_number+=1;
        }
        NSString *messages = [NSString stringWithFormat:@"%li",(long)order.badge_number];
        order.message_number = messages;
        NSLog(@"child badge added");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}
#pragma marks - MyTableViewCell Delegate
-(void)didClickButtonAtIndex:(SelectionButton)button{
    Order *order = [self.datasourceArray objectAtIndex:selectRow.row];
    if ([self.detailCategory isEqualToString:@"My Orders"]) {
        if (button==Confirmation) {
            [self transactionConfirmed:order];
        }else if (button==Message){
            ChatViewController *chatViewController = [[ChatViewController alloc]init];
            chatViewController.title = [self profileName:order.user_info[@"seller_email"]];
            chatViewController.seller_email = order.user_info[@"seller_email"];
            [self.navigationController pushViewController:chatViewController animated:YES];
        }else{
            return;
        }
    }else if ([self.detailCategory isEqualToString:@"My Sales"]){
        if (button==Confirmation) {
            [self fulfilledDeliveryButtonPressed:order];
        }else if (button==Message){
            ChatViewController *chatViewController = [[ChatViewController alloc]init];
            chatViewController.title = [@"" stringByAppendingString:[self profileName:order.user_info[@"user_email"]withSpace:YES]];
            chatViewController.seller_email = order.user_info[@"user_email"];
            [self.navigationController pushViewController:chatViewController animated:YES];
        }else{
            return;
        }
    }else{
        return;
    }
    
    
}
-(NSString *)profileName:(NSString *)email{
    NSString *usernameString = email;
    NSArray *components = [usernameString componentsSeparatedByString:@"@"];
    NSString *nameString = [components objectAtIndex:0];
    NSArray *nameComponents = [nameString componentsSeparatedByString:@"."];
    NSString *firstName = [nameComponents objectAtIndex:0];
    
    NSString *capitalizedFirstName = [firstName stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                        withString:[[firstName substringToIndex:1] capitalizedString]];
    NSString *capitalizedLastName= capitalizedFirstName;
    if ([nameComponents count]>1) {
        NSString *lastName = [nameComponents objectAtIndex:1];
        capitalizedLastName = [lastName stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                withString:[[lastName substringToIndex:1] capitalizedString]];
    }
    
    
    NSString *fullName = [capitalizedFirstName stringByAppendingString:[@" " stringByAppendingString:capitalizedLastName]];
    return fullName;
    
}
#pragma marks - buttons pressed method

-(void)fulfilledDeliveryButtonPressed:(Order *)order{
    UIAlertController *deliverActionSheet = [UIAlertController alertControllerWithTitle:@"Item Delivery Confirmation" message:@"By admitting this, you are confirming that you have finished your delivery to the buyer." preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];  // UIAlertActionStyleCancel
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Item Delivered" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.itemConnection fulfillDelivery:order.item_id order:order.order_id];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];  // UIAlertActionStyleDestructive
    
    [deliverActionSheet addAction:cancelAction];
    [deliverActionSheet addAction:okAction];
    [self presentViewController:deliverActionSheet animated:YES completion:nil];
}

-(void)transactionConfirmed:(Order *)order{
    UIAlertController *deliverActionSheet = [UIAlertController alertControllerWithTitle:@"Exchange Actions" message:@"Please Contact Seller for Item Delivery. \nThanks!" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];  // UIAlertActionStyleCancel
    UIAlertAction *itemInfo=[UIAlertAction actionWithTitle:@"Item Info" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
        OrderDetailTableViewController *odtvc = [[OrderDetailTableViewController alloc]init];
        odtvc.order = order;
        [self.navigationController pushViewController:odtvc animated:YES];
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Transaction Confirmed" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self confirmButtonTapped:order];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkoutPostSuccess:) name:@"FinishCheckoutNotification" object:nil];
    }];
    UIAlertAction *refundAction = [UIAlertAction actionWithTitle:@"Refund" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        RefundViewController *refundViewController = [[RefundViewController alloc]initWithNibName:@"RefundViewController" bundle:nil];
        [self.navigationController pushViewController:refundViewController animated:YES];
        refundViewController.order = order;
        [self dismissViewControllerAnimated:YES completion:nil];
    }];  // UIAlertActionStyleDestructive
    
    [deliverActionSheet addAction:cancelAction];
    [deliverActionSheet addAction:itemInfo];
    if ([order.item_status isEqualToString:@"receive"]&&[order.order_status isEqualToString:@"held"]) {
        deliverActionSheet.message = @"By admitting this, you are confirming that you have received and are satisfied with the item.";
        deliverActionSheet.title =@"Transaction Confirmation";
        [deliverActionSheet addAction:okAction];
    }else{
        [deliverActionSheet addAction:refundAction];
    }
    if (self.presentedViewController == NULL) {
        [self presentViewController:deliverActionSheet animated:YES completion:nil];
    }
}
-(void)fulfilDelivery:(NSNotification *)noti{
    if ([[noti object]isEqualToString:@"success"]) {
        UIAlertController *alertInfo = [UIAlertController alertControllerWithTitle:@"Success" message:@"Thank you for your delivery" preferredStyle:UIAlertControllerStyleAlert];
        [alertInfo addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.itemConnection mySells:[[NSUserDefaults standardUserDefaults]objectForKey:@"username"] detail_category:@"mySells"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertInfo animated:YES completion:nil];
    }else{
        UIAlertController *alertInfo = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"Is it too late to say sorry? Please contact Proxi!" preferredStyle:UIAlertControllerStyleAlert];
        [alertInfo addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertInfo animated:YES completion:nil];
        
    }
}

-(void)infoActionAlert{
    UIAlertController *alertInfo = [UIAlertController alertControllerWithTitle:@"Unable to Confirm Transaction" message:@"Reason: Payment Pending\nPlease come back again after 2 business days" preferredStyle:UIAlertControllerStyleAlert];
    [alertInfo addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    if (self.presentedViewController == NULL) {
        [self presentViewController:alertInfo animated:YES completion:nil];
    }
}




-(void)checkoutPostSuccess:(NSNotification *)noti{
    NSString *protocal = [noti object];
    NSLog(@"protocal: %@",[protocal description]);
    
    UIAlertController *alert = [[UIAlertController alloc]init];
    if ([protocal isEqualToString:@"success"]) {
        alert.title =@"Success";
        alert.message = @"Your Payment has been successfully processed! Please Continue to use Proxi in the future!";
    }else{
        alert.title =@"Error";
        alert.message = @"Your Payment has not been processed. Please contact Proxi Team for Troubleshooting.";
    }
    UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:yesButton];
    
    if (self.presentedViewController == NULL) {
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)confirmButtonTapped:(Order *)order{
    self.confirm_status = @"Confirm Status";
    UIAlertController *alert= [UIAlertController alertControllerWithTitle:@"Confirmed?" message:@"This Action Cannot be Undone" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        OrderConnection *orderConnection = [[OrderConnection alloc]init];
        [self dismissViewControllerAnimated:YES completion:nil];
        [orderConnection finishCheckOut:order.item_id];
    }];
    UIAlertAction *noButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:yesButton];
    [alert addAction:noButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *v = (UITableViewHeaderFooterView *)view;
    v.backgroundView.backgroundColor = [UIColor colorWithRed:139/255.0 green:220/255.0 blue:218/255.0 alpha:1];
}

-(UIViewController *)makingAlertViewController{
    UIViewController *viewcontroller = [[UIViewController alloc]init];
    viewcontroller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    viewcontroller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    viewcontroller.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    return viewcontroller;
}

-(UIView *)setupTableViewHeader:(BOOL)isLeft numberToWarn:(NSInteger)number{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 20)];
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, screen_width, 10)];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    if (number!=0) {
        headerView.backgroundColor = [UIColor yellowColor];
    }
    NSString *alert= [NSString stringWithFormat:@"%li",(long)number];
    if (isLeft) {
        alert = [alert stringByAppendingString:@" transactions needed to confirm."];
    }else{
        alert = [alert stringByAppendingString:@" items needed to deliver."];
        
    }
    NSAttributedString *labelDes = [[NSAttributedString alloc]initWithString:alert attributes:@{
                                                                    NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont fontWithName:@"Gotham-Light" size:12]
                                                                                                }];
    headerLabel.attributedText = labelDes;
    [headerView addSubview:headerLabel];
    return headerView;
}

-(UIView *)setupSubtableFooterView{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 20)];
    footerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    NSAttributedString *footerStr = [[NSAttributedString alloc]initWithString:@"Swipe left to remove items" attributes:@{
                                                                                                                             NSFontAttributeName:[UIFont fontWithName:@"Gotham-Light" size:10.5],NSForegroundColorAttributeName: [UIColor grayColor]
                                                                                                                             }];
    UILabel *footerTitle = [[UILabel alloc]initWithFrame:CGRectMake(screen_width*0.1, 5, screen_width*0.8, 10)];
    footerTitle.attributedText = footerStr;
    footerTitle.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:footerTitle];
    return footerView;
}
@end
