//
//  ReceiptViewController.h
//  ProxiFinal
//
//  Created by Michael Liu on 2/14/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Braintree/Braintree.h>
#import "Item.h"

@interface ReceiptViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *receipt_title;
@property (weak, nonatomic) IBOutlet UILabel *receipt_date;
@property (weak, nonatomic) IBOutlet UILabel *receipt_price;
@property (weak, nonatomic) IBOutlet UIButton *order_button;
@property (weak, nonatomic) IBOutlet UIImageView *receipt_image;
@property (strong,nonatomic) Item *item;
@property (strong,nonatomic) Braintree *braintree;
@property (strong,nonatomic) NSString *timeStr;
@end
