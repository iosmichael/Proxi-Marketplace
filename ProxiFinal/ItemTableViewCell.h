//
//  ItemTableViewCell.h
//  ProxiFinal
//
//  Created by Michael Liu on 10/10/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ItemCollectionView: UICollectionView
@property (strong,nonatomic)NSIndexPath *indexPath;

@end


@interface ItemTableViewCell : UITableViewCell
@property (strong,nonatomic)ItemCollectionView *collectionView;
@property (strong,nonatomic)UICollectionViewFlowLayout *layout;


- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath;
-(CGSize)getContentSize;

@end
