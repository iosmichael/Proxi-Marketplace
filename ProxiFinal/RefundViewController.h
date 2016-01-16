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
@property (weak, nonatomic) IBOutlet UITextField *refundCode;
@property (weak, nonatomic) IBOutlet UITextView *feedback;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (strong,nonatomic) Order *order;

@end
