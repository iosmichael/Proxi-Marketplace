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
//third page
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIPageControl *pageIndicator;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *refresher;
@property (weak, nonatomic) IBOutlet UILabel *postAlertLabel;

//elements


@end
