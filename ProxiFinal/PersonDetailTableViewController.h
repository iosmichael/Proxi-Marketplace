//
//  PersonDetailTableViewController.h
//  ProxiFinal
//
//  Created by Michael Liu on 10/20/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface PersonDetailTableViewController : UITableViewController
@property (strong,nonatomic)NSString *detailCategory;
@property (strong,nonatomic) Firebase *firebase;


@end
