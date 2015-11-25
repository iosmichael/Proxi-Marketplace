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
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *email;
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *password;
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *phoneNum;
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *realName;
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *Other;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *refresher;

@end
