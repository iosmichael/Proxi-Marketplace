//
//  OrderDetailTableViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 11/25/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//
#import "OrderConnection.h"
#import "OrderDetailTableViewController.h"
#import "HHAlertView.h"
#import "ChatViewController.h"
#define Screen_width [[UIScreen mainScreen]bounds].size.width

@interface OrderDetailTableViewController ()

@end

@implementation OrderDetailTableViewController{
    UIView *titleView;
    UIView *priceTitleView;
    CGSize descSize;
    UIView *personDetailView;
    UIView *descView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"regularTableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    [self.tableView setBackgroundView:nil];
    [self setupElements];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)refresh{
    [self.item_image setImage:[UIImage imageWithData:self.order.img_data]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- Table View Datasource & Table View Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView dequeueReusableCellWithIdentifier:@"regularTableViewCell"];
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    switch (indexPath.section) {
            
        case 0:
            [cell.contentView addSubview:self.item_image];
            break;
        case 1:
            [cell.contentView addSubview:priceTitleView];
            break;
        case 2:
            [cell.contentView addSubview:descView];
            break;
        case 3:
            [cell.contentView addSubview:personDetailView];
            break;
        case 5:
            [cell.contentView addSubview:self.orderButton];
            break;
        case 4:
            [cell.contentView addSubview:self.confirmButton];
            break;
        default:
            break;
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
            
        case 0:
            return Screen_width*0.9+10;
            break;
        case 1:
            return 120;
            break;
        case 2:
            return descSize.height+50;
            break;
        case 3:
            return 100;
            break;
        default:
            return 70;
            break;
    }
    
    
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 1:
            return 35;
            break;
        case 2:
            return 10;
            break;
        case 3:
            return 10;
            break;
        case 4:
            return 10;
            break;
        default:
            return 0;
            break;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==1) {
        UIView *dateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 33)];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(Screen_width-158, 5, 33, 33)];
        [imageView setImage:[UIImage imageNamed:@"Time"]];
        [dateView addSubview:imageView];
        [dateView addSubview:self.item_post_time];
        return dateView;
    }else{
        return nil;
    }
}


#pragma mark- Setup Elements

-(void)setupElements{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"RefreshTableNotification" object:nil];
    UIImage *image = [self resizeImage:[UIImage imageNamed:@"Proxi Logo.png"] toSize:CGSizeMake(90, 35)];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    self.navigationItem.titleView = imageView;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:87/255.0 green:183/255.0 blue:182/255.0 alpha:1.0];
    [self setupTime];
    [self setupItemInfo];
    [self setupPersonInfo];
}

-(void)setupTime{
    self.item_post_time = [[UILabel alloc]initWithFrame:CGRectMake(Screen_width-125,0, 105, 33)];
    /*date Formatter*/
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:self.order.order_date];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    NSString *dateStr=[dateFormatter stringFromDate:date];
    self.item_post_time.text = dateStr;
}
-(void)setupItemInfo{
    UIImageView *titleIcon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 40, 40)];
    self.item_title = [[UILabel alloc]initWithFrame:CGRectMake(75, 20, Screen_width-15, 25)];
    NSAttributedString *titleStr =[[NSAttributedString alloc]initWithString:self.order.item_title attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:20]}];
    self.item_title.attributedText = titleStr;
    [titleIcon setImage:[UIImage imageNamed:@"gift"]];
    UIImageView *priceIcon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 65, 40, 40)];
    [priceIcon setImage:[UIImage imageNamed:@"vemo"]];
    self.item_current_price = [[UILabel alloc]initWithFrame:CGRectMake(75, 70, Screen_width-15, 25)];
    NSAttributedString *priceStr =[[NSAttributedString alloc]initWithString:[@"$ " stringByAppendingString:self.order.order_price] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:19]}];
    self.item_current_price.attributedText = priceStr;

    
    priceTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,Screen_width, 120)];
    [priceTitleView addSubview:self.item_title];
    [priceTitleView addSubview:titleIcon];
    [priceTitleView addSubview:self.item_current_price];
    [priceTitleView addSubview:priceIcon];
    
    UIImageView *descIcon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 40, 40)];
    [descIcon setImage:[UIImage imageNamed:@"note"]];
    
    
    NSAttributedString *descStr =[[NSAttributedString alloc]initWithString:self.order.item_description attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:14]}];
    CGSize size = CGSizeMake(230, 999);
    CGRect textRect = [self.order.item_description
                       boundingRectWithSize:size
                       options:NSStringDrawingUsesLineFragmentOrigin
                       attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:14]}
                       context:nil];
    descSize = textRect.size;
    self.item_description = [[UILabel alloc]initWithFrame:CGRectMake(75, 15, Screen_width-90, descSize.height)];
    self.item_description.attributedText = descStr;
    self.item_description.lineBreakMode = NSLineBreakByWordWrapping;
    self.item_description.numberOfLines = 0;
    descView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, descSize.height)];
    [descView addSubview:self.item_description];
    [descView addSubview:descIcon];
    
    
    self.item_image = [[UIImageView alloc]initWithFrame:CGRectMake(Screen_width*0.05, 10, Screen_width*0.9,Screen_width*0.9)];
    
    self.orderButton = [[UIButton alloc]initWithFrame:CGRectMake(Screen_width*0.05, 5, Screen_width*0.9, 50)];
    [self.orderButton addTarget:self action:@selector(orderButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.orderButton.layer setCornerRadius:25];
    self.orderButton.backgroundColor = [UIColor colorWithRed:251/255.0f green:176/255.0f blue:87/255.0f alpha:1];
    [self.orderButton setTitle:@"Refund" forState:UIControlStateNormal];
    [self.orderButton setTitle:@"Payment Pending..." forState:UIControlStateDisabled];
    
    
    
    self.confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(Screen_width*0.05, 5, Screen_width*0.9, 50)];
    [self.confirmButton addTarget:self action:@selector(confirmButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmButton.layer setCornerRadius:25];
    self.confirmButton.backgroundColor = [UIColor colorWithRed:251/255.0f green:176/255.0f blue:87/255.0f alpha:1];
    [self.confirmButton setTitle:@"Confirm Transaction" forState:UIControlStateNormal];
    [self.confirmButton setTitle:@"Payment Pending..." forState:UIControlStateDisabled];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkoutPostSuccess:) name:@"FinishCheckoutNotification" object:nil];
    
    if (![self.order.order_status isEqualToString:@"held"]) {
        self.orderButton.backgroundColor = [UIColor grayColor];
        self.confirmButton.backgroundColor = [UIColor grayColor];
        self.confirmButton.enabled = YES;
        self.orderButton.enabled = NO;
    }
    
    if (self.order.img_data) {
        [self.item_image setImage:[UIImage imageWithData:self.order.img_data]];
    }else{
        [self.item_image setImage:[UIImage imageNamed:@"manshoes"]];
    }
}

-(void)checkoutPostSuccess:(NSNotification *)noti{
    NSString *protocal = [noti object];
    NSLog(@"protocal: %@",[protocal description]);
    if ([protocal isEqualToString:@"success"]) {
        [HHAlertView showAlertWithStyle:HHAlertStyleOk inView:self.view Title:@"Success" detail:@"Thank you!" cancelButton:nil Okbutton:@"OK"];
    }else{
        [HHAlertView showAlertWithStyle:HHAlertStyleError inView:self.view Title:@"Error" detail:@"Please contact us" cancelButton:nil Okbutton:@"OK"];
    }
}

-(void)orderButtonTapped{
    OrderConnection *orderConnection = [[OrderConnection alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finish:) name:@"RefundNotification" object:nil];
    [orderConnection refund:self.order.item_id];
}

-(void)confirmButtonTapped{
        OrderConnection *orderConnection = [[OrderConnection alloc]init];
        [orderConnection finishCheckOut:self.order.item_id];
        NSLog(@"%@",[self.order description]);
        // [HHAlertView showAlertWithStyle:HHAlertStyleDefault inView:self.view Title:@"Are Your Sure?" detail:@"Confirm transaction after you received money" cancelButton:@"Not now" Okbutton:@"Yes"];
}

-(void)finish:(NSNotification *)noti{
    NSString *protocal = [noti object];
    NSLog(@"protocal: %@",[protocal description]);
    if ([protocal isEqualToString:@"success"]) {
        [HHAlertView showAlertWithStyle:HHAlertStyleOk inView:self.view Title:@"Success" detail:@"Thank you" cancelButton:nil Okbutton:@"OK"];
    }else{
        [HHAlertView showAlertWithStyle:HHAlertStyleError inView:self.view Title:@"Error" detail:@"Please contact with Proxi" cancelButton:nil Okbutton:@"Cancel"];
    }
    
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
    NSAttributedString *nameStr =[[NSAttributedString alloc]initWithString:[self profileName:self.order.user_info[@"seller_email"]] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:14]}];
    nameLabel.attributedText = nameStr;
    NSAttributedString *emailStr =[[NSAttributedString alloc]initWithString:self.order.user_info[@"seller_email"] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:14]}];
    emailLabel.attributedText = emailStr;
    NSAttributedString *phoneStr =[[NSAttributedString alloc]initWithString:self.order.user_info[@"seller_phone"] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:14]}];
    phoneLabel.attributedText = phoneStr;
    [personDetailView addSubview:personIcon];
    [personDetailView addSubview:nameLabel];
    [personDetailView addSubview:emailLabel];
    [personDetailView addSubview:phoneLabel];
    [personDetailView addSubview:personButton];
    
    
}
-(void)personButtonTapped{
    ChatViewController *chatViewController = [[ChatViewController alloc]init];
    chatViewController.title = [self profileName:self.order.user_info[@"seller_email"]];
    chatViewController.seller_email = self.order.user_info[@"seller_email"];
    [self.navigationController pushViewController:chatViewController animated:YES];
}

- (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)resize

{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(resize.width, resize.height), NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, resize.width, resize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
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
