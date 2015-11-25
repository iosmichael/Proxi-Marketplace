//
//  CategoryTableViewCell.h
//  ProxiFinal
//
//  Created by Michael Liu on 10/10/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryCollectionView : UICollectionView
@property (nonatomic, strong) NSIndexPath *indexPath;
@end


@interface CategoryTableViewCell : UITableViewCell
@property (strong,nonatomic) CategoryCollectionView *collectionView;

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath;

@end
