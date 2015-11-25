//
//  OrderConfirmationTableViewController.h
//  ProxiFinal
//
//  Created by Michael Liu on 10/31/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@interface OrderConfirmationTableViewController : UITableViewController
@property (strong,nonatomic) Item *orderItem;
@end
