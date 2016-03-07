//
//  ChatViewController.h
//  ProxiFinal
//
//  Created by Michael Liu on 1/7/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
#import "JSMessagesViewController.h"

@interface ChatViewController : JSMessagesViewController
@property (strong,nonatomic) NSString *seller_email;
@property (strong,nonatomic) NSString *message_title;
@property (strong,nonatomic) NSString *me;
@property (strong,nonatomic) Firebase *firebase;
@end
