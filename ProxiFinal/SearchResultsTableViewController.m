//
//  SearchResultsTableViewController.m
//  Sample-UISearchController
//
//  Created by James Dempsey on 9/20/14.
//  Copyright (c) 2014 Tapas Software. All rights reserved.
//

#import "SearchResultsTableViewController.h"
#import "Item.h"
#import "ItemDetailViewController.h"

@implementation SearchResultsTableViewController
-(void)viewDidLoad{
    self.searchResults = [[NSArray alloc]init];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SearchResultCell"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SearchResultCell" forIndexPath:indexPath];
    Item *item = [self.searchResults objectAtIndex:indexPath.row];
    cell.textLabel.text = item.item_title;
   // Product *product = [self.searchResults objectAtIndex:indexPath.row];

    //cell.textLabel.text = product.name;

    return cell;

}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Item *product = [self.searchResults objectAtIndex:indexPath.row];
    ItemDetailViewController *vc = [[ItemDetailViewController alloc]initWithNibName:@"ItemDetailViewController" bundle:nil];
    vc.item = product;
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"resultSelected" object:vc];
    }];

}


@end
