//
//  HomeTableViewController.h
//  ProxiFinal
//
//  Created by Michael Liu on 10/10/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>



@interface HomeTableViewController : UITableViewController<UICollectionViewDataSource,UICollectionViewDelegate>
-(void)updateViewController;
@end
