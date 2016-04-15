//
//  RegisterViewController.h
//  ProxiFinal
//
//  Created by Michael Liu on 10/10/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JAMValidatingTextField.h"

@interface RegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIControl *firstPage;
@property (strong, nonatomic) IBOutlet UIControl *secondPage;


@property (weak, nonatomic) IBOutlet UILabel *registerAlertLabel;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UIPageControl *page;


@property (weak, nonatomic) IBOutlet JAMValidatingTextField *email;
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *password;
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *recheckPassword;

@property (weak, nonatomic) IBOutlet JAMValidatingTextField *phone;
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *firstName;

@property (weak, nonatomic) IBOutlet JAMValidatingTextField *lastName;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *refresher;

@end
