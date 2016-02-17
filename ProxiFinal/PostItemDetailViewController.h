//
//  PostItemDetailViewController.h
//  ProxiFinal
//
//  Created by Michael Liu on 11/26/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostItemDetailViewController : UIViewController
@property (strong,nonatomic) UIImage *image;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *imagePageView;
@property (strong, nonatomic) IBOutlet UIView *itemPageView;
@property (strong, nonatomic) IBOutlet UIView *pricePageView;
@property (strong, nonatomic) IBOutlet UIView *postPageView;
//first page
@property (weak, nonatomic) IBOutlet UIPageControl *page;

@property (weak, nonatomic) IBOutlet UIButton *imagePageRetakeButton;
//second page
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;
//third page
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIPageControl *pageIndicator;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *refresher;
@property (weak, nonatomic) IBOutlet UILabel *postAlertLabel;


//elements
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;
@property (weak, nonatomic) IBOutlet UIButton *button6;
@property (weak, nonatomic) IBOutlet UIButton *button7;
@property (weak, nonatomic) IBOutlet UIButton *button8;
@property (weak, nonatomic) IBOutlet UIButton *button9;
@property (weak, nonatomic) IBOutlet UIButton *button0;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

//Categories

@property (weak, nonatomic) IBOutlet UIButton *clothing;
@property (weak, nonatomic) IBOutlet UIButton *book;
@property (weak, nonatomic) IBOutlet UIButton *ride;
@property (weak, nonatomic) IBOutlet UIButton *furniture;
@property (weak, nonatomic) IBOutlet UIButton *service;
@property (weak, nonatomic) IBOutlet UIButton *other;





@end
