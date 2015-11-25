//
//
//  ItemDetailViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 10/20/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "OrderConfirmationTableViewController.h"
#define Screen_width [[UIScreen mainScreen]bounds].size.width

@interface ItemDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ItemDetailViewController{
    UIView *titleView;
    UIView *priceTitleView;
    CGSize descSize;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"regularTableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
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
            [cell.contentView addSubview:self.item_description];
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
            return Screen_width*0.9+10;
            break;
        case 1:
            return 100;
            break;
        case 2:
            return descSize.height+30;
            break;
        default:
            return 60;
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
            return 20;
            break;
        case 3:
            return 30;
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
}

-(void)setupTime{
    self.item_post_time = [[UILabel alloc]initWithFrame:CGRectMake(Screen_width-125,0, 105, 33)];
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
    
    self.item_current_price = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, Screen_width-90, 40)];
    NSAttributedString *priceStr =[[NSAttributedString alloc]initWithString:[@"Price: $" stringByAppendingString:self.item.price_current] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:19]}];
    self.item_current_price.attributedText = priceStr;
    self.item_title = [[UILabel alloc]initWithFrame:CGRectMake(0, 12, Screen_width-90, 21)];
    NSAttributedString *titleStr =[[NSAttributedString alloc]initWithString:self.item.item_title attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:20]}];
    self.item_title.attributedText = titleStr;
    self.item_title.textAlignment = NSTextAlignmentCenter;
    priceTitleView = [[UIView alloc]initWithFrame:CGRectMake(45, 0,Screen_width-90, 100)];
    [priceTitleView addSubview:self.item_title];
    [priceTitleView addSubview:self.item_current_price];

    NSString *detailStr = [@"Item Detail: " stringByAppendingString:self.item.item_description];
    CGSize size = CGSizeMake(230, 999);
    CGRect textRect = [detailStr
                       boundingRectWithSize:size
                       options:NSStringDrawingUsesLineFragmentOrigin
                       attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:18]}
                       context:nil];
    descSize = textRect.size;
    self.item_description = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, Screen_width-60, descSize.height)];
    
    self.item_description.text = detailStr;
    self.item_description.lineBreakMode = NSLineBreakByWordWrapping;
    self.item_description.numberOfLines = 0;
    
    self.item_image = [[UIImageView alloc]initWithFrame:CGRectMake(Screen_width*0.05, 10, Screen_width*0.9,Screen_width*0.9)];
    self.orderButton = [[UIButton alloc]initWithFrame:CGRectMake(Screen_width*0.05, 5, Screen_width*0.9, 50)];
    [self.orderButton addTarget:self action:@selector(orderButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.orderButton.layer setCornerRadius:25];
    self.orderButton.backgroundColor = [UIColor colorWithRed:251/255.0f green:176/255.0f blue:87/255.0f alpha:1];
    [self.orderButton setTitle:@"BUY" forState:UIControlStateNormal];
    
    
    
    if (self.item.image) {
        [self.item_image setImage:[UIImage imageWithData:self.item.image]];
    }else{
        [self.item_image setImage:[UIImage imageNamed:@"manshoes"]];
    }
}

-(void)orderButtonTapped{
    OrderConfirmationTableViewController *orderConfirmationTableViewController = [[OrderConfirmationTableViewController alloc]init];
    orderConfirmationTableViewController.orderItem = self.item;
    [self.navigationController pushViewController:orderConfirmationTableViewController animated:YES];
}


- (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)resize

{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(resize.width, resize.height), NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, resize.width, resize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
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
