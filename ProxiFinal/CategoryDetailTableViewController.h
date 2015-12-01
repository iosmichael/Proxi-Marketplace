//
//  CategoryDetailTableViewController.h
//  ProxiFinal
//
//  Created by Michael Liu on 11/15/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryDetailTableViewController : UITableViewController<UICollectionViewDataSource,UICollectionViewDelegate>
#warning add view more button. limit the downloads numbers

@property (strong,nonatomic)NSString *categoryName;

@end
