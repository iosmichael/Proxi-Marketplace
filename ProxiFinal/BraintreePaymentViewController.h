//
//  BraintreePaymentViewController.h
//  ProxiFinal
//
//  Created by Michael Liu on 11/23/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Braintree/Braintree.h>

@interface BraintreePaymentViewController : UIViewController<BTDropInViewControllerDelegate>
@property (strong,nonatomic) Braintree *braintree;

@end
