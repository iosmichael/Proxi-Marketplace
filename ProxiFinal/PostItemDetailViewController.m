//
//  PostItemDetailViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 11/26/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "PostItemDetailViewController.h"
#define Screen_width [[UIScreen mainScreen]bounds].size.width
#define Screen_height [[UIScreen mainScreen]bounds].size.height
#define gray [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1]
#define hightlight_color [UIColor colorWithRed:255/255.0 green:227/255.0 blue:184/255.0 alpha:1]
@interface PostItemDetailViewController ()<UIScrollViewDelegate>
@property (strong,nonatomic)NSMutableArray *numberArray;
@property (strong,nonatomic)UIImageView *imageView;
@property (strong, nonatomic)NSString *category;

@end

@implementation PostItemDetailViewController{
    int numberOfArray;
    BOOL dotted;
}


- (void)viewDidLoad {

    [super viewDidLoad];
    self.numberArray = [[NSMutableArray alloc]init];
    numberOfArray = 3;
    dotted = NO;
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(27, 53+10, Screen_width-54, Screen_width-54)];
    if (self.image) {
        [self.imageView setImage:self.image];
    }else{
        [self.imageView setImage:[UIImage imageNamed:@"manshoes"]];
    }
    self.imagePageView.frame = CGRectMake(0, 0, Screen_width, Screen_height);
    [self.imagePageView addSubview:self.imageView];
    
    self.itemPageView.frame = CGRectMake(Screen_width, 0, Screen_width, Screen_height);
    self.pricePageView.frame = CGRectMake(Screen_width *2, 0, Screen_width, Screen_height);
    self.postPageView.frame = CGRectMake(Screen_width*3, 0, Screen_width, Screen_height);
    [self.scrollView addSubview:self.imagePageView];
    [self.scrollView addSubview:self.itemPageView];
    [self.scrollView addSubview:self.pricePageView];
    [self.scrollView addSubview:self.postPageView];
    self.scrollView.delegate = self;
    [self setupScrollView];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"viewDidLoad");
    [self.view addSubview:self.scrollView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setupScrollView{
    self.scrollView.contentSize = CGSizeMake(Screen_width*4, 0);
    
}
-(void)clearCategoryButtons{
    self.category = @"";
    for (int i=1; i<7; i++) {
        UIButton *categoryButton = [self.scrollView viewWithTag:i+100];
        [categoryButton setBackgroundColor:gray];
    }
}
-(void)renewNumber{
    int number = [self.numberArray count];
    NSString *numberString= @"$";
    if (number>2) {
        for (int i=0; i<number-2; i++) {
            numberString = [numberString stringByAppendingString:[self.numberArray objectAtIndex:i]];
        }
        numberString = [numberString stringByAppendingString:@"."];
        numberString = [numberString stringByAppendingString:[self.numberArray objectAtIndex:number-2]];
        numberString = [numberString stringByAppendingString:[self.numberArray objectAtIndex:number-1]];
    }else{
        numberString = [numberString stringByAppendingString:@"0."];
        switch (number) {
            case 0:
                numberString = [numberString stringByAppendingString:@"00"];
                break;
            case 1:
                numberString = [numberString stringByAppendingString:@"0"];
                numberString = [numberString stringByAppendingString:[self.numberArray objectAtIndex:0]];
                break;
            case 2:
                numberString = [numberString stringByAppendingString:[self.numberArray objectAtIndex:0]];
                numberString = [numberString stringByAppendingString:[self.numberArray objectAtIndex:1]];
                break;
            default:
                break;
        }
        
    }
    self.priceLabel.text = numberString;
}

#pragma mark- Button Control Methods

- (IBAction)retakeImageButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)numberPadTapped:(id)sender {
    UIButton *buttonTapped = sender;
    if ([self.numberArray count]==0) {
        if (buttonTapped.tag==200||buttonTapped.tag==100||buttonTapped.tag==0) {
            return;
        }
        [self.numberArray addObject:[@(buttonTapped.tag)stringValue]];
    }else if([self.numberArray count]==5){
        if (buttonTapped.tag==100) {
            [self.numberArray removeAllObjects];
        }else if (buttonTapped.tag==200){
            [self.numberArray removeObjectAtIndex:[self.numberArray count]-1];
        }else{
            return;
        }
    }else{
        if (buttonTapped.tag==100) {
            [self.numberArray removeAllObjects];
        }else if (buttonTapped.tag==200){
            [self.numberArray removeObjectAtIndex:[self.numberArray count]-1];
        }else{
            [self.numberArray addObject:[@(buttonTapped.tag)stringValue]];
        }
    }
    [self renewNumber];
    
    
}
- (IBAction)postItemButtonTapped:(id)sender {
}
- (IBAction)categoryButtonTapped:(id)sender {
    UIButton *buttonTapped = sender;
    [self clearCategoryButtons];
    switch (buttonTapped.tag) {
        case 101:
            //book
            self.category = @"book";
            [buttonTapped setBackgroundColor:hightlight_color];
            break;
        case 102:
            //ride
            self.category = @"ride";
            [buttonTapped setBackgroundColor:hightlight_color];
            break;
        case 103:
            //services
            self.category = @"furniture";
            [buttonTapped setBackgroundColor:hightlight_color];
            break;
        case 104:
            self.category = @"services";
            [buttonTapped setBackgroundColor:hightlight_color];
            break;
        case 105:
            self.category = @"clothing";
            [buttonTapped setBackgroundColor:hightlight_color];
            break;
        case 106:
            self.category = @"other";
            [buttonTapped setBackgroundColor:hightlight_color];
            break;
        default:
            break;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = floor((self.scrollView.contentOffset.x - Screen_width/2)/Screen_width)+1;
    self.page.currentPage = page;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
