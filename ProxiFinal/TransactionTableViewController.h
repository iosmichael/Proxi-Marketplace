//
//  TransactionTableViewController.h
//  ProxiFinal
//
//  Created by Michael Liu on 11/2/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@interface TransactionTableViewController : UITableViewController
@property (strong,nonatomic) Order *order;
@end
