//
//  HomePageSlideView.m
//  ProxiFinal
//
//  Created by Michael Liu on 10/11/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "HomePageSlideView.h"
@interface HomePageSlideView()<UIScrollViewDelegate>
@property (strong,nonatomic)UIScrollView *scrollView;
@property (strong,nonatomic)UIPageControl *pageIndex;
    
@end


#define PageNumber 4
#define ScrollViewChangeTimeInterval 4.0
@implementation HomePageSlideView
-  (instancetype)initWithFrame:(CGRect)frame{
    // Initialization code
    self = [super initWithFrame:frame];
    if (self) {
        if (!self.images) {
            UIImage *image = [UIImage imageNamed:@"banner"];
            self.images = [[NSMutableArray alloc]init];
            for (int i= 0; i<PageNumber; i++) {
                
                [self.images addObject:image];
            }
        }
        
        [self setupScrollView:self.images];
        [self setupPageIndex];
        [self addSubview:self.scrollView];
        [self addSubview:self.pageIndex];
        self.pageIndex.numberOfPages = PageNumber;
        [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(changePage) userInfo:nil repeats:YES];
    }
    return self;
}



#pragma mark - Setup Page Index
-(void)setupPageIndex{
    if (!self.pageIndex) {
        self.pageIndex = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.scrollView.frame.size.height*0.8, self.scrollView.frame.size.width, 20)];
    }
    [self.pageIndex setTintColor:[UIColor grayColor]];
    self.pageIndex.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageIndex.currentPage = 0;
}

#pragma mark - Setup Scroll View
-(void)setupScrollView: (NSMutableArray *)images {
    if (!self.scrollView) {
        self.scrollView = [[UIScrollView alloc]initWithFrame:self.frame];
    }
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width*PageNumber, 0);
    // Add images to Scroll View
    for (int i = 0 ; i<PageNumber; i++) {
        UIImage* advertiseImage = [images objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
        imageView.image = advertiseImage;
        [self.scrollView addSubview:imageView];
    }
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    [self.scrollView setAutoresizingMask:UIViewAutoresizingNone];
    self.scrollView.delegate = self;
}

-(void)changePage{
    
    CGFloat pageWidth = self.scrollView.frame.size.width;
    if (self.pageIndex.currentPage==(PageNumber-1)) {
        self.pageIndex.currentPage = 0;
        [self.scrollView setContentOffset:CGPointZero animated:YES];
    }else{
        self.pageIndex.currentPage+=1;
        CGFloat newX = self.scrollView.contentOffset.x + pageWidth;
        [self.scrollView setContentOffset:CGPointMake(newX, 0) animated:YES];
    }
    
    
}

#pragma mark - ScrollView Delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    //根据scrolView的左右滑动,对pageCotrol的当前指示器进行切换(设置currentPage)
    int page = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    //切换改变页码，小圆点
    self.pageIndex.currentPage = page;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
