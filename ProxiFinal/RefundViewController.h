//
//  RefundViewController.h
//  ProxiFinal
//
//  Created by Michael Liu on 1/9/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@interface RefundViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *feedback;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (strong,nonatomic) Order *order;
@property (weak, nonatomic) IBOutlet UILabel *item_title;
@property (weak, nonatomic) IBOutlet UILabel *refundAmount;
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;
@property (weak, nonatomic) IBOutlet UIButton *completeRefundButton;

@end
