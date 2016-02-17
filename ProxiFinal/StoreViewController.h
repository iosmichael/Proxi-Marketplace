//
//  StoreViewController.h
//  ProxiFinal
//
//  Created by Michael Liu on 1/30/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Store.h"
@interface StoreViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *openTime;
@property (weak, nonatomic) IBOutlet UILabel *owner;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) Store *store;

@end
