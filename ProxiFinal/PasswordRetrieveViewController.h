//
//  PasswordRetrieveViewController.h
//  ProxiFinal
//
//  Created by Michael Liu on 1/10/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JAMValidatingTextField.h"
@interface PasswordRetrieveViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *email;
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *phone;


@end
