//
//  SettingTableViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 10/14/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "SettingTableViewController.h"
#import "LoginMainViewController.h"
#import "ContactUsTableViewCell.h"
#import "AboutTableViewController.h"
#import "ProfileTableViewController.h"
#import "PersonDetailTableViewController.h"

#define screen_width [UIScreen mainScreen].bounds.size.width
@interface SettingTableViewController ()<ContactUsDelegate>
@property (strong,nonatomic) UIButton *logoutButton;
@property (strong,nonatomic) NSString *email;
@end

@implementation SettingTableViewController{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nibCell = [UINib nibWithNibName:@"ContactUsTableViewCell" bundle:nil];
    [self.tableView registerNib:nibCell forCellReuseIdentifier:@"ContactUsCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"regularCell"];
    self.tableView.separatorColor = [UIColor groupTableViewBackgroundColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"Gotham-Book" size:25]}];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"regularCell"];
    UIView *footerView = [self setupFooterView];
    self.tableView.tableFooterView = footerView;
    
    self.email = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    // Configure the cell...
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated{
    self.email = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    [super viewDidAppear:animated];
}




-(void)didClickButtonAnIndex:(ContactButton)button{
    if(button == Facebook){
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://www.facebook.com/proximarketplace"]];
    }else if (button==Twitter){
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://twitter.com/proxiwheaton"]];
    }else if (button==Instagram){
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://www.instagram.com/proxi.wheaton/"]];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0){
        //ProfileTableViewController *profTableView = [[ProfileTableViewController alloc]init];
        //[self.navigationController pushViewController:profTableView animated:YES];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    if (indexPath.row==0) {
        PersonDetailTableViewController *history = [[PersonDetailTableViewController alloc]init];
        history.detailCategory = @"My History";
        [self.navigationController pushViewController:history animated:YES];
        
    }else if (indexPath.row==1) {
        //Payment
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://venmo.com"]];
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }else if (indexPath.row==2){
        //Report a Problem
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://goo.gl/forms/MKuxVXNXKk"]];
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }else if(indexPath.row==3){
        //About Page
        AboutTableViewController *aboutVC = [[AboutTableViewController alloc]init];
        [self.navigationController pushViewController:aboutVC animated:YES];
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section==0) {
        return 1;
    }else{
        return 5;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 4:
            return 160;
            break;
            
        default:
            return 120;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"regularCell"];
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        cell.textLabel.attributedText = [[NSAttributedString alloc]initWithString:[self profileName:self.email] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Gotham-Book" size:20]}];
        cell.detailTextLabel.attributedText=[[NSAttributedString alloc]initWithString:self.email attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Gotham-Light" size:14]}];
        return cell;

    }
    
    if (indexPath.row==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"regularCell" forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.attributedText = [[NSAttributedString alloc]initWithString:@"History" attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Gotham-Light" size:20]}];
        [cell.imageView setImage:[UIImage imageNamed:@"history"]];
        return cell;
    }
    else if (indexPath.row==1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"regularCell" forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.attributedText = [[NSAttributedString alloc]initWithString:@"Payment" attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Gotham-Light" size:20]}];
        [cell.imageView setImage:[UIImage imageNamed:@"payment"]];
        return cell;
    }else if (indexPath.row==2){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"regularCell" forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.attributedText = [[NSAttributedString alloc]initWithString:@"Report a Problem" attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Gotham-Light" size:20]}];
        [cell.imageView setImage:[UIImage imageNamed:@"problem"]];
        return cell;
    }else if (indexPath.row==3){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"regularCell" forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.attributedText = [[NSAttributedString alloc]initWithString:@"About" attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Gotham-Light" size:20]}];
        [cell.imageView setImage:[UIImage imageNamed:@"about"]];
        return cell;
    }else if (indexPath.row==4){
        ContactUsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactUsCell"];
        [cell setDelegate:self];
        return cell;
    }else{
        return nil;
    }
    
}

-(void)logoutTapped{
    LoginMainViewController *loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginMain"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"username"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"password"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"isMerchant"];    
    [self presentViewController:loginController animated:YES completion:nil];
    
}




-(UIView *)setupFooterView{
    UIView *footerButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    footerButtonView.backgroundColor = [UIColor clearColor];
    self.logoutButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, 0, self.view.frame.size.width*0.9, 50)];
    
    [self.logoutButton setTitle:@"Log Out" forState:UIControlStateNormal];
    [self.logoutButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.logoutButton.layer.borderColor = [UIColor colorWithRed:1/255.0 green:175/255.0 blue:178/255.0 alpha:1].CGColor;
    self.logoutButton.layer.borderWidth = 3;
    [self.logoutButton.layer setCornerRadius:25];
    [self.logoutButton.titleLabel setFont:[UIFont fontWithName:@"Gotham-Book" size:22.0]];
    [footerButtonView addSubview:self.logoutButton];
    self.logoutButton.backgroundColor = [UIColor whiteColor];
    [self.logoutButton addTarget:self action:@selector(logoutTapped) forControlEvents:UIControlEventTouchUpInside];
    return footerButtonView;
    
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
   
    
    NSString *fullName = [[capitalizedFirstName stringByAppendingString:@" "]stringByAppendingString:capitalizedLastName];
    return fullName;
    
}

@end
