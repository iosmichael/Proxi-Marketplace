//
//  PostItemViewController.h
//  ProxiFinal
//
//  Created by Michael Liu on 10/10/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JAMValidatingTextField.h"

@interface PostItemViewController : UIViewController
@property (strong,nonatomic) UIButton *imageButton;
@property (strong,nonatomic) UIImageView *imageView;
@property (strong,nonatomic)UIImage *postImage;
@property (strong,nonatomic)JAMValidatingTextField *titleTextfield;
@property (strong,nonatomic) JAMValidatingTextField *descriptionTextfield;
@property (strong,nonatomic) JAMValidatingTextField *categoryTextfield;
@property (strong,nonatomic) JAMValidatingTextField *highpriceTextfield;
@property (strong,nonatomic) JAMValidatingTextField *lowpriceTextfield;

@end
