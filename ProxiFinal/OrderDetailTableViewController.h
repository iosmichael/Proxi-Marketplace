//
//  OrderDetailTableViewController.h
//  ProxiFinal
//
//  Created by Michael Liu on 11/25/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@interface OrderDetailTableViewController : UITableViewController
@property (strong,nonatomic) Order *order;

@property (strong, nonatomic) UIImageView *item_image;
@property (strong, nonatomic) UILabel *item_description;
@property (strong,nonatomic) UILabel *item_title;
@property (strong, nonatomic) UILabel *item_post_time;


@property (strong, nonatomic) UILabel *item_current_price;
@property (strong, nonatomic) UILabel *owner_info;
@property (strong,nonatomic) UIButton *refundButton;
@property (strong,nonatomic) UILabel *refundLabel;
@property (strong,nonatomic) NSString *confirm_status;
@end
