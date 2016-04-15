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
#import "ReceiptViewController.h"
#define Screen_width [[UIScreen mainScreen]bounds].size.width

@interface ItemDetailViewController ()<UITableViewDelegate,UITableViewDataSource,HHAlertViewDelegate>
@property (strong,nonatomic) UIViewController *presentedModalView;

@end

@implementation ItemDetailViewController{
    UIView *titleView;
    UIView *priceTitleView;
    CGSize descSize;
    UIView *descView;
    NSString *timeStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"regularTableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.tableView setBackgroundView:nil];
    [self setupElements];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
            cell.backgroundColor = [UIColor clearColor];
            break;
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        
        case 0:
            return Screen_width;
            break;
        case 1:
            return 110;
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

#pragma mark- Setup Elements

-(void)setupElements{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"RefreshTableNotification" object:nil];
    UIImage *image = [self resizeImage:[UIImage imageNamed:@"Proxi Logo.png"] toSize:CGSizeMake(90, 35)];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    self.navigationItem.titleView = imageView;
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:50/255.0 green:144/255.0 blue:148/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self setupTime];
    [self setupItemInfo];
}

-(void)setupTime{
    self.item_post_time = [[UILabel alloc]initWithFrame:CGRectMake(30,2.5, 100, 33+3)];
    /*date Formatter*/
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:self.item.date];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    NSString *dateStr=[dateFormatter stringFromDate:date];
    timeStr = dateStr;
    NSAttributedString *dateAttrStr =[[NSAttributedString alloc]initWithString:dateStr attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Gotham-Light" size:12],NSForegroundColorAttributeName:[UIColor grayColor]}];
    self.item_post_time.attributedText = dateAttrStr;
}
-(void)setupItemInfo{
    self.item_title = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, Screen_width-15-5, 25+25)];
    self.item_title.textAlignment = NSTextAlignmentCenter;
    self.item_title.font = [UIFont fontWithName:@"Gotham-Light" size:22];
    //NSAttributedString *titleStr =[[NSAttributedString alloc]initWithString:self.item.item_title attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:20]}];
    [self.item_title setMinimumScaleFactor:20.0/[UIFont labelFontSize]];
    self.item_title.adjustsFontSizeToFitWidth = YES;
    self.item_title.lineBreakMode = NSLineBreakByWordWrapping;
    self.item_title.numberOfLines= 0;
    self.item_title.text = self.item.item_title;
    UIImageView *priceIcon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 65, 40, 40)];
    [priceIcon setImage:[UIImage imageNamed:@"vemo"]];
    self.item_current_price = [[UILabel alloc]initWithFrame:CGRectMake(75, 70, Screen_width*0.3, 25)];
    self.item_current_price.font= [UIFont fontWithName:@"Gotham-Medium" size:20];
    self.item_current_price.text = [@"$ " stringByAppendingString:self.item.price_current];

    
    priceTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,Screen_width, 120)];
    [priceTitleView addSubview:self.item_title];
    [priceTitleView addSubview:self.item_current_price];
    [priceTitleView addSubview:[self setupDateView]];
    [priceTitleView addSubview:priceIcon];
    
    UIImageView *descIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 30, 30)];
    [descIcon setImage:[UIImage imageNamed:@"note"]];
    NSAttributedString *descStr =[[NSAttributedString alloc]initWithString:self.item.item_description attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Gotham-Light" size:16]}];
    CGSize size = CGSizeMake(230, 999);
    CGRect textRect = [self.item.item_description
                       boundingRectWithSize:size
                       options:NSStringDrawingUsesLineFragmentOrigin
                       attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gotham-Light" size:16]}
                       context:nil];
    descSize = textRect.size;
    self.item_description = [[UILabel alloc]initWithFrame:CGRectMake(75, 15, Screen_width-90, descSize.height)];
    self.item_description.attributedText = descStr;
    self.item_description.lineBreakMode = NSLineBreakByWordWrapping;
    self.item_description.numberOfLines = 0;
    descView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, descSize.height)];
    [descView addSubview:self.item_description];
    [descView addSubview:descIcon];
    
    
    self.item_image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_width,Screen_width)];
    self.orderButton = [[UIButton alloc]initWithFrame:CGRectMake(Screen_width*0.05, 5, Screen_width*0.9, 50)];
    [self.orderButton addTarget:self action:@selector(paymentButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.orderButton.layer setCornerRadius:25];
    self.orderButton.backgroundColor = [UIColor whiteColor];
    [self.orderButton.layer setBorderColor:[UIColor colorWithRed:251/255.0f green:176/255.0f blue:87/255.0f alpha:1].CGColor];
    [self.orderButton.layer setBorderWidth:3.0];
    NSAttributedString *title = [[NSAttributedString alloc]initWithString:@"Purchase" attributes:@{ NSFontAttributeName: [UIFont fontWithName:@"Gotham-Book" size:22.0],NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self.orderButton setAttributedTitle:title forState:UIControlStateNormal];
    
    
    
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

- (void)paymentButtonTapped{
    
    ReceiptViewController *receiptVC = [[ReceiptViewController alloc]initWithNibName:@"ReceiptViewController" bundle:nil];
    receiptVC.timeStr = timeStr;
    receiptVC.item = self.item;
    [self.navigationController pushViewController:receiptVC animated:YES];
    
}

-(UIView *)setupDateView{
    UIView *dateView = [[UIView alloc]initWithFrame:CGRectMake(75+Screen_width*0.5, 60, Screen_width*0.5-75, 25)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 25, 25)];
    [imageView setImage:[UIImage imageNamed:@"Time"]];
    [dateView addSubview:imageView];
    [dateView addSubview:self.item_post_time];
    dateView.backgroundColor = [UIColor whiteColor];
    return dateView;
}

@end
