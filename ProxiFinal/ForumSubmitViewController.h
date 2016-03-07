//
//  ForumSubmitViewController.h
//  ProxiFinal
//
//  Created by Michael Liu on 3/5/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface ForumSubmitViewController : UIViewController
@property (strong,nonatomic) NSString *forum_category;
@property (weak, nonatomic) IBOutlet UITextView *forum_description;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UILabel *wordCount;


@end
