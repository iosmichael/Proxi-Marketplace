//
//  ForumPostTableViewController.h
//  ProxiFinal
//
//  Created by Michael Liu on 3/4/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>
#import <MessageUI/MessageUI.h>

@interface ForumPostTableViewController : UITableViewController
@property (strong,nonatomic) NSString *category;
@end
