//
//  PersonTableViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 10/14/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "PersonTableViewController.h"
#import "PersonDetailTableViewController.h"
#import "LoginViewController.h"


@interface PersonTableViewController ()
@property (strong,nonatomic)NSArray *entryArray;
@property (strong,nonatomic)NSArray *imageArray;

@end

@implementation PersonTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTable) name:@"RefreshTable" object:nil];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:20]}];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"RegularTableViewCell"];
 
    [self setupArray];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    switch (section) {
        case 0:
            return 1;// My Profile
            break;
        case 1:
            return 4;//My Items, My Orders, My History, My Like
            break;
        default:
            return 0;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==0) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"RegularTableViewCell"];
        
        NSString *usernameString = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
        if (!usernameString) {
            cell.textLabel.text =@"My Profile";
        }else{
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
        
        cell.textLabel.text = fullName;
        cell.detailTextLabel.text = usernameString;
        }
        [cell.imageView setImage:[UIImage imageNamed:@"manshoes"]];
        return cell;
    }
    else if(indexPath.section ==1) {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RegularTableViewCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [self.entryArray objectAtIndex:indexPath.row];
    [cell.imageView setImage:[self.imageArray objectAtIndex:indexPath.row]];
    return cell;
    }else{
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }else if(indexPath.section ==1){
        PersonDetailTableViewController *detailVC = [[PersonDetailTableViewController alloc]init];
        detailVC.detailCategory = [self.entryArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

-(void)setupArray{
#warning link to the personDetailController
    self.entryArray = [NSArray arrayWithObjects:@"My Items",@"My Orders",@"My Sells",@"My History", nil];
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    [imageArray addObject:[UIImage imageNamed:@"manshoes"]];
    [imageArray addObject:[UIImage imageNamed:@"manshoes"]];
    [imageArray addObject:[UIImage imageNamed:@"manshoes"]];
    [imageArray addObject:[UIImage imageNamed:@"manshoes"]];
    [imageArray addObject:[UIImage imageNamed:@"manshoes"]];
    self.imageArray = [NSArray arrayWithArray:imageArray];
}
-(void)refreshTable{
    [self.tableView reloadData];
}


@end
