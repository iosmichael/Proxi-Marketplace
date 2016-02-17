//
//  ChangePasswordViewController.h
//  ProxiFinal
//
//  Created by Michael Liu on 1/16/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JAMValidatingTextField.h"

@interface ChangePasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *changeButton;
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *currentPassword;
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *reenterPassword;

@end
