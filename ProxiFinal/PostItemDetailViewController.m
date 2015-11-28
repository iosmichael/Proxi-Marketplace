//
//  PostItemDetailViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 11/26/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "PostItemDetailViewController.h"
#import "HHAlertView.h"
#import "Item.h"
#import "ItemConnection.h"

#define Screen_width [[UIScreen mainScreen]bounds].size.width
#define Screen_height [[UIScreen mainScreen]bounds].size.height
#define PostItemSuccessProtocol @"success"
#define gray [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1]
#define hightlight_color [UIColor colorWithRed:255/255.0 green:227/255.0 blue:184/255.0 alpha:1]


@interface PostItemDetailViewController ()<UIScrollViewDelegate,HHAlertViewDelegate, UITextViewDelegate,UITextFieldDelegate>
@property (strong,nonatomic)NSMutableArray *numberArray;
@property (strong,nonatomic)UIImageView *imageView;
@property (strong, nonatomic)NSString *category;

@end

@implementation PostItemDetailViewController{
    int numberOfArray;
    BOOL categoryClicked;
    BOOL textViewEdited;
}


- (void)viewDidLoad {

    [super viewDidLoad];
    [self setupElements];
    self.numberArray = [[NSMutableArray alloc]init];
    numberOfArray = 3;
    categoryClicked = NO;
    textViewEdited = NO;
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
    self.titleTextField.delegate = self;
    self.descriptionTextView.delegate = self;
    [self.postButton setBackgroundColor:gray];
    self.postButton.enabled = NO;
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
    //[self.navigationController popToRootViewControllerAnimated:YES];
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
    NSData *img = UIImageJPEGRepresentation(self.imageView.image, 0.2);
#warning  highPrice entered only
#warning NSUserDefaults is invalid
    NSLog( @"%@",[self.titleTextField.text description]);
    Item *item = [[Item alloc]initWithTitle:self.titleTextField.text
                                description:self.descriptionTextView.text
                                  userEmail:[[NSUserDefaults standardUserDefaults]objectForKey:@"username"]
                                      image:img date:nil itemID:nil price:self.priceLabel.text
                                   category:self.category];
    self.postButton.enabled = NO;
    ItemConnection *connection = [[ItemConnection alloc]init];
    [connection postItemData:item];
    self.refresher.hidden = NO;
    [self.refresher startAnimating];
    
}
- (IBAction)categoryButtonTapped:(id)sender {
    categoryClicked = YES;
    UIButton *buttonTapped = sender;
    [self clearCategoryButtons];
    self.category = buttonTapped.titleLabel.text;
    [buttonTapped setBackgroundColor:hightlight_color];
    [self checkAllValidation];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = floor((self.scrollView.contentOffset.x - Screen_width/2)/Screen_width)+1;
    self.page.currentPage = page;
}


-(void)successPost:(NSNotification *)noti{
    [self.refresher stopAnimating];
    self.refresher.hidden = YES;
    //Success Alert View
    BOOL success = [[noti object]isEqualToString:PostItemSuccessProtocol];
    if (success) {
        [HHAlertView showAlertWithStyle:HHAlertStyleOk inView:self.view Title:@"Congrats!" detail:@"Successfully Posted Item" cancelButton:nil Okbutton:@"Gotcha!"];
        
    }else{
        [HHAlertView showAlertWithStyle:HHAlertStyleError inView:self.view Title:@"Sorry" detail:@"Item Didn't Post Successfully" cancelButton:nil Okbutton:@"Please Contact Us"];
        //Error Alert View
        self.postButton.enabled = YES;
    }
}
-(void)errorPost{
    [self.refresher stopAnimating];
    self.refresher.hidden = YES;
    //Error Alert View
    [HHAlertView showAlertWithStyle:HHAlertStyleError inView:self.view Title:@"Sorry" detail:@"Item Didn't Post Successfully" cancelButton:nil Okbutton:@"Please Contact Us"];
    self.postButton.enabled = YES;
}

//HHAlert
-(void)didClickButtonAnIndex:(HHAlertButton)button{
    if (button ==HHAlertButtonOk) {
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
-(void)setupElements{
    [[HHAlertView shared] setDelegate:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(successPost:) name:@"PostItemNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(errorPost) name:@"PostItemNotificationError" object:nil];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imageView setClipsToBounds:YES];
    [self.imageView setImage:self.image];
    [self.refresher setHidden:YES];
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (!textViewEdited) {
        textView.text = @"";
    }
    textViewEdited = YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length==0) {
        textViewEdited= NO;
        textView.text = @"Anything You Want Your Buyers To Know?";
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSRange resultRange = [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet] options:NSBackwardsSearch];
    if ([text length] == 1 && resultRange.location != NSNotFound) {
        [textView resignFirstResponder];
        [self checkAllValidation];
        return NO;
    }
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self checkAllValidation];
    return NO;
}
-(void)checkAllValidation{
    if (self.image&&
        self.titleTextField.text.length!=0&&
        self.descriptionTextView.text.length!=0&&
        categoryClicked&&
        ![self.priceLabel.text isEqualToString:@"0.00"]) {
        self.postAlertLabel.textColor = [UIColor clearColor];
        self.postButton.enabled = YES;
        [self.postButton setBackgroundColor:hightlight_color];
    }else{
        self.postAlertLabel.textColor = [UIColor redColor];
        self.postButton.enabled = NO;
        [self.postButton setBackgroundColor:gray];
    }
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
