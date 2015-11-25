//
//  HomePageSlideView.h
//  ProxiFinal
//
//  Created by Michael Liu on 10/11/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HomePageSlideDataSource <NSObject>

-(NSMutableArray *)getImagesForHomeSliderView;

@end

@interface HomePageSlideView : UIView
@property (strong,nonatomic) NSMutableArray *images;
@property id <HomePageSlideDataSource> delegate;
-(instancetype)initWithFrame:(CGRect)frame;

@end
