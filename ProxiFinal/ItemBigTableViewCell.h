//
//  ItemBigTableViewCell.h
//  ProxiFinal
//
//  Created by Michael Liu on 10/13/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemBigCollectionView : UICollectionView
@property (strong,nonatomic) NSIndexPath *indexPath;
@end


@interface ItemBigTableViewCell : UITableViewCell
@property (strong,nonatomic) ItemBigCollectionView *collectionView;
@property (strong,nonatomic) UICollectionViewFlowLayout *layout;
- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath;
@end
