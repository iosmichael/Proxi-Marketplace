//
//  ItemTableViewCell.m
//  ProxiFinal
//
//  Created by Michael Liu on 10/10/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "ItemTableViewCell.h"
#import "ItemCollectionViewCell.h"
@implementation ItemCollectionView


@end

@implementation ItemTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(15,5,15,5);
    layout.itemSize = CGSizeMake(147,185);
    self.collectionView = [[ItemCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.layout = layout;
    [self.collectionView registerClass:[ItemCollectionViewCell class] forCellWithReuseIdentifier:@"ItemCollectionCell"];
    self.collectionView.backgroundColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:241/255.0f alpha:1];
    self.collectionView.showsHorizontalScrollIndicator =NO;
    [self.contentView addSubview:self.collectionView];
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame= self.contentView.bounds;
}

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath
{
    self.collectionView.dataSource = dataSourceDelegate;
    self.collectionView.delegate = dataSourceDelegate;
    self.collectionView.indexPath = indexPath;
    
    [self.collectionView reloadData];
}
-(CGSize)getContentSize{
    return [self.layout collectionViewContentSize];
}

@end
