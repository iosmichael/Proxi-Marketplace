//
//  BraintreeAccountSignUpViewController.h
//  ProxiFinal
//
//  Created by Michael Liu on 3/25/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JAMValidatingTextField.h"

@interface BraintreeAccountSignUpViewController : UIViewController
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *street;
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *city;
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *zipcode;
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *year;
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *month;
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *day;
@property (weak, nonatomic) IBOutlet UIButton *selectState;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UILabel *registerAlertLabel;

@end
