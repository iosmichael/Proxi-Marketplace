//
//  AboutTableViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 1/16/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import "AboutTableViewController.h"

@interface AboutTableViewController ()

@end

@implementation AboutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"regularCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
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
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
            return 5;
            break;
        default:
            return 0;
            break;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"regularCell"];
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text=@"Ben Temple";
                cell.detailTextLabel.text =@"Boss Man";
                break;
            case 1:
                cell.textLabel.text =@"Michael Liu";
                cell.detailTextLabel.text = @"Tech Nerd";
                break;
            case 2:
                cell.textLabel.text = @"Connor Jenkins";
                cell.detailTextLabel.text = @"Design Guru";
                break;
            case 3:
                cell.textLabel.text = @"Kelen Caldwell";
                cell.detailTextLabel.text =@"Social Butterfly";
                break;
            default:
                break;
        }
        return cell;
    }else if (indexPath.section==1){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"regularCell"];
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text =@"ProxiMarketplace.com";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.imageView.image = [UIImage imageNamed:@"manshoes"];
                break;
            case 1:
                cell.textLabel.text =@"Rate Proxi";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.imageView.image = [UIImage imageNamed:@"manshoes"];
                break;
            case 2:
                cell.textLabel.text =@"Terms of Service";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 3:
                cell.textLabel.text =@"Privacy Policy";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 4:
                cell.textLabel.text =@"Legal";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            default:
                break;
        }
        return cell;
    }else{
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 80;
    }else if(indexPath.section==1){
        return 62;
    }else{
        return 0;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 30;
    }else if(section==1){
        return 10;
    }else{
        return 0;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"TEAM";
    }
    return nil;
}

@end
