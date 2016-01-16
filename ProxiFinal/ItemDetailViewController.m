//
//
//  ItemDetailViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 10/20/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "OrderConnection.h"
#import "HHAlertView.h"
#define Screen_width [[UIScreen mainScreen]bounds].size.width

@interface ItemDetailViewController ()<UITableViewDelegate,UITableViewDataSource,BTDropInViewControllerDelegate,HHAlertViewDelegate>

@end

@implementation ItemDetailViewController{
    UIView *titleView;
    UIView *priceTitleView;
    CGSize descSize;
    UIView *descView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBraintree];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"regularTableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    [self.tableView setBackgroundView:nil];
    [[HHAlertView shared]setDelegate:self];
    [self setupElements];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orderPostSuccess:) name:@"CheckoutNotification" object:nil];
    self.navigationController.navigationBarHidden = NO;
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 7.0)
    {
        self.navigationController.navigationBar.translucent = NO;
        self.tabBarController.tabBar.translucent =NO;
    }

}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    if ([self.parentViewController isKindOfClass:[HomeTableViewController class]]) {
        HomeTableViewController *parentVC = (HomeTableViewController *)self.parentViewController;
        [parentVC updateViewController];
    }else if ([self.parentViewController isKindOfClass:[SearchTableViewController class]]){

    }else{
        
    }
}

-(void)refresh{
    [self.item_image setImage:[UIImage imageWithData:self.item.image]];
    
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
        default:
            [cell.contentView addSubview:self.orderButton];
            cell.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:239/255.0f alpha:1  ];
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
            return 120+25;
            break;
        case 2:
            return descSize.height+50;
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
    return 4;
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
        default:
            return 0;
            break;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==1) {
        UIView *dateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 33)];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(Screen_width-158+4, 5+4, 25, 25)];
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
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:36/255.0 green:104/255.0 blue:156/255.0 alpha:1.0];
    [self setupTime];
    [self setupItemInfo];
}

-(void)setupTime{
    self.item_post_time = [[UILabel alloc]initWithFrame:CGRectMake(Screen_width-125,0, 105, 33+3)];
    /*date Formatter*/
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:self.item.date];
    NSLog(@"%@",self.item.date);
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    NSString *dateStr=[dateFormatter stringFromDate:date];
    self.item_post_time.text = dateStr;
}
-(void)setupItemInfo{
    self.item_title = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, Screen_width-15-5, 25+25)];
    self.item_title.textAlignment = NSTextAlignmentCenter;
    self.item_title.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    //NSAttributedString *titleStr =[[NSAttributedString alloc]initWithString:self.item.item_title attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:20]}];
    self.item_title.adjustsFontSizeToFitWidth = YES;
    self.item_title.lineBreakMode = NSLineBreakByWordWrapping;
    self.item_title.numberOfLines= 0;
    self.item_title.text = self.item.item_title;
    UIImageView *priceIcon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 65, 40, 40)];
    [priceIcon setImage:[UIImage imageNamed:@"vemo"]];
    self.item_current_price = [[UILabel alloc]initWithFrame:CGRectMake(75, 70, Screen_width-15, 25)];
    self.item_current_price.font= [UIFont boldSystemFontOfSize:20];
    self.item_current_price.text = [@"$ " stringByAppendingString:self.item.price_current];

    
    priceTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,Screen_width, 120)];
    [priceTitleView addSubview:self.item_title];
    [priceTitleView addSubview:self.item_current_price];
    [priceTitleView addSubview:priceIcon];
    
    UIImageView *descIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 30, 30)];
    [descIcon setImage:[UIImage imageNamed:@"note"]];
    NSAttributedString *descStr =[[NSAttributedString alloc]initWithString:self.item.item_description attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:14]}];
    CGSize size = CGSizeMake(230, 999);
    CGRect textRect = [self.item.item_description
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
    [self.orderButton addTarget:self action:@selector(paymentButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.orderButton.layer setCornerRadius:25];
    self.orderButton.backgroundColor = [UIColor colorWithRed:251/255.0f green:176/255.0f blue:87/255.0f alpha:1];
    [self.orderButton setTitle:@"Purchase" forState:UIControlStateNormal];
    
    
    if (self.item.image) {
        [self.item_image setImage:[UIImage imageWithData:self.item.image]];
    }else{
        [self.item_image setImage:[UIImage imageNamed:@"manshoes"]];
    }

}



- (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)resize

{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(resize.width, resize.height), NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, resize.width, resize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}



-(void)orderPostSuccess:(NSNotification *)noti{
    NSString *protocal = [noti object];
    if ([protocal isEqualToString:@"success"]) {
        [HHAlertView showAlertWithStyle:HHAlertStyleOk inView:self.view Title:@"Congrats!" detail:@"Thank you for using Proxi" cancelButton:nil Okbutton:@"Thank you"];
        //Dismiss Page
    }else{
        [HHAlertView showAlertWithStyle:HHAlertStyleError inView:self.view Title:@"Error" detail:@"Order didn't process" cancelButton:nil
                            Okbutton:@"Cancel"];
        
    }
}

-(void)didClickButtonAnIndex:(HHAlertButton)button{
    if (button ==HHAlertButtonOk) {
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateTableNotification" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark- Braintree API

-(void)setupBraintree{
    // TODO: Handle errors
    
    //Only for sandbox
    
    NSURL *clientTokenURL = [NSURL URLWithString:@"https://www.proximarketplace.com/database/generator.php"];
    NSMutableURLRequest *clientTokenRequest = [NSMutableURLRequest requestWithURL:clientTokenURL];
    [clientTokenRequest setValue:@"text/plain" forHTTPHeaderField:@"Accept"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:clientTokenRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // TODO: Handle errors
        NSString *clientToken = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        // Initialize `Braintree` once per checkout session
        self.braintree = [Braintree braintreeWithClientToken:clientToken];
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
    [connection postOrder:[[NSUserDefaults standardUserDefaults]objectForKey:@"username"] item:self.item paymentMethodNonce:paymentMethodNonce];
#warning What if credit card is invalid?
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
