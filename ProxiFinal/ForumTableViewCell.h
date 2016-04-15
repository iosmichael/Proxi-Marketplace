//
//  ForumTableViewCell.h
//  ProxiFinal
//
//  Created by Michael Liu on 3/5/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForumTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *forum_title;
@property (weak, nonatomic) IBOutlet UILabel *forum_email;
@property (weak, nonatomic) IBOutlet UILabel *forum_description;
@property (weak, nonatomic) IBOutlet UIView *forum_email_button;

@end
