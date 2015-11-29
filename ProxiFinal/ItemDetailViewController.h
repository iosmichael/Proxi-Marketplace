//
//  ItemDetailViewController.h
//  ProxiFinal
//
//  Created by Michael Liu on 10/20/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import "HomeTableViewController.h"
#import "SearchTableViewController.h"
@interface ItemDetailViewController : UIViewController
@property (strong,nonatomic) Item *item;

@property (strong, nonatomic) UIImageView *item_image;
@property (strong, nonatomic) UILabel *item_description;
@property (strong,nonatomic) UILabel *item_title;
@property (strong, nonatomic) UILabel *item_post_time;
@property (strong, nonatomic) UIButton *orderButton;
@property (strong, nonatomic) UILabel *item_current_price;
@property (strong, nonatomic) UILabel *owner_info;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
