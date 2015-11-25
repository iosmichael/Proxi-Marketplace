//
//  ItemBigTableViewCell.m
//  ProxiFinal
//
//  Created by Michael Liu on 10/13/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "ItemBigTableViewCell.h"
#import "ItemBigCollectionViewCell.h"


@implementation ItemBigCollectionView


@end

@implementation ItemBigTableViewCell

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
    CGRect rect = [[UIScreen mainScreen]bounds];
    CGFloat screenWidth = rect.size.width;
    CGFloat screenHeight = rect.size.height;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(0,5,0,10);
    layout.itemSize = CGSizeMake(screenWidth,screenHeight *0.8);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[ItemBigCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.layout = layout;
    [self.collectionView registerClass:[ItemBigCollectionViewCell class] forCellWithReuseIdentifier:@"ItemBigCollectionCell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
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
