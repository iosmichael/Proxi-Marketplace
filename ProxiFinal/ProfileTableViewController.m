//
//  ProfileTableViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 1/16/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "ChangePasswordViewController.h"

@interface ProfileTableViewController ()

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ListCell"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.row) {
        case 0:
            cell.textLabel.attributedText = [[NSAttributedString alloc]initWithString:@"Edit Profile" attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Gotham-Light" size:20]}];
            [cell.imageView setImage:[UIImage imageNamed:@"edit_icon"]];
            break;
        case 1:
            cell.textLabel.attributedText = [[NSAttributedString alloc]initWithString:@"Change Password" attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Gotham-Light" size:20]}];
            [cell.imageView setImage:[UIImage imageNamed:@"change_password"]];
            break;
        default:
            cell.backgroundColor = [UIColor clearColor];
            break;

    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }else{
        //edit profile
        ChangePasswordViewController *passwordViewController = [[ChangePasswordViewController alloc]initWithNibName:@"ChangePasswordViewController" bundle:nil];
        [self.navigationController pushViewController:passwordViewController animated:YES];
        
    }
}


@end
