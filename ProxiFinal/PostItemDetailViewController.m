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
#define keyboardHeight 96.0
#define PostItemSuccessProtocol @"success"
#define gray [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1]
#define hightlight_color [UIColor colorWithRed:245/255.0 green:166/255.0 blue:35/255.0 alpha:1]
#define theme_color [UIColor colorWithRed:73/255.0 green:143/255.0 blue:157/255.0 alpha:1]


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
    [self setKeyboardTheme];
    self.descriptionTextView.text = @"What do you want buyers to know?\n-Quality\n-Size\n-Color";
    self.descriptionTextView.textColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1];
    /*[self.buttons.layer setCornerRadius:5];
    self.buttons.layer.borderWidth=3;
    [self.buttons.layer setBorderColor:[UIColor colorWithRed:73/255.0 green:143/255.0 blue:157/255.0 alpha:1].CGColor];
     */
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, Screen_width-20, Screen_width-20)];
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
    self.titleTextField.delegate = self;
    self.descriptionTextView.delegate = self;
    self.postButton.enabled = NO;
    [self.view addSubview:self.scrollView];
    UIImage *image = [self resizeImage:[UIImage imageNamed:@"Proxi Logo.png"] toSize:CGSizeMake(90, 35)];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    self.navigationItem.titleView = imageView;
    [self.tabBarController.tabBar setHidden:YES];
    [self setupGestureRecognizer];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
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
    [self.other setImage:[UIImage imageNamed:@"other_icon_inactive.png"] forState:UIControlStateNormal];
    [self.clothing setImage:[UIImage imageNamed:@"cloth_icon_inactive.png"] forState:UIControlStateNormal];
    [self.ride setImage:[UIImage imageNamed:@"ride_icon_inactive.png"] forState:UIControlStateNormal];
    [self.book setImage:[UIImage imageNamed:@"book_icon_inactive.png"] forState:UIControlStateNormal];
    [self.service setImage:[UIImage imageNamed:@"service_icon_inactive.png"] forState:UIControlStateNormal];
    [self.furniture setImage:[UIImage imageNamed:@"furniture_icon_inactive.png"] forState:UIControlStateNormal];
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
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    [self checkAllValidation];
    
    
}
- (IBAction)postItemButtonTapped:(id)sender {
    NSData *img = UIImageJPEGRepresentation(self.imageView.image, 0.7);
    NSLog( @"%@",[self.titleTextField.text description]);
    NSArray *priceComponents = [self.priceLabel.text componentsSeparatedByString:@"$"];
    NSString *price = [priceComponents objectAtIndex:1];
    Item *item = [[Item alloc]initWithTitle: [self capitalizeFirstLetter:self.titleTextField.text]
                                description:self.descriptionTextView.text
                                  userEmail:[[NSUserDefaults standardUserDefaults]objectForKey:@"username"]
                                      image:img date:nil itemID:nil price:price
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
    
    switch (buttonTapped.tag) {
        case 101: //book
            self.category=@"Book";
            [self.book setImage:[UIImage imageNamed:@"book_icon.png"] forState:UIControlStateNormal];
            break;
        case 102: //ride
            self.category=@"Ride";
            [self.ride setImage:[UIImage imageNamed:@"rides_icon.png"] forState:UIControlStateNormal];
            break;
        case 103: //furniture
            self.category=@"Furniture";
            [self.furniture setImage:[UIImage imageNamed:@"furniture_icon.png"] forState:UIControlStateNormal];
            break;
        case 104: //service
            self.category=@"Service";
            [self.service setImage:[UIImage imageNamed:@"service_icon.png"] forState:UIControlStateNormal];
            break;
        case 105: //cloth
            self.category=@"Clothing";
            [self.clothing setImage:[UIImage imageNamed:@"cloth_icon.png"] forState:UIControlStateNormal];
            break;
        case 106: //other
            self.category=@"Other";
            [self.other setImage:[UIImage imageNamed:@"other_icon.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    

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
        [HHAlertView showAlertWithStyle:HHAlertStyleOk inView:self.view Title:@"Congrats!" detail:@"Successfully Posted Item" cancelButton:nil Okbutton:@"OK"];
    }else{
        [HHAlertView showAlertWithStyle:HHAlertStyleError inView:self.view Title:@"Sorry" detail:@"Item Didn't Post Successfully" cancelButton:nil Okbutton:@"Contact Us"];
        //Error Alert View
        self.postButton.enabled = YES;
    }
}
-(void)errorPost{
    [self.refresher stopAnimating];
    self.refresher.hidden = YES;
    //Error Alert View
    [HHAlertView showAlertWithStyle:HHAlertStyleError inView:self.view Title:@"Sorry" detail:@"Please Check Wifi Connection" cancelButton:nil Okbutton:@"Contact Us"];
    self.postButton.enabled = YES;
}

//HHAlert
-(void)didClickButtonAnIndex:(HHAlertButton)button{
    if (button ==HHAlertButtonOk) {
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateTableNotification" object:nil];
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
        textView.textColor = [UIColor blackColor];
    }
    textViewEdited = YES;
    self.titleHeight.constant-=keyboardHeight;
    
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length==0) {
        textViewEdited= NO;
        self.descriptionTextView.text = @"What do you want buyers to know?\n-Quality\n-Size\n-Color";
        self.descriptionTextView.textColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1];
    }
    self.titleHeight.constant+=keyboardHeight;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self checkAllValidation];
    return NO;
}
-(void)checkAllValidation{
    NSArray *priceComponents = [self.priceLabel.text componentsSeparatedByString:@"$"];
    NSString *price = [priceComponents objectAtIndex:1];
    
    if (self.image&&
        self.titleTextField.text.length!=0&&
        self.descriptionTextView.text.length!=0&&
        categoryClicked&&[price doubleValue]>=5.0) {
        self.postAlertLabel.textColor = [UIColor clearColor];
        
        self.postButton.enabled = YES;
        [self.postButton setImage:[UIImage imageNamed:@"post_icon.png"] forState:UIControlStateNormal];
        
    }else{
        self.postAlertLabel.textColor = [UIColor redColor];
        self.postButton.enabled = NO;
        [self.postButton setImage:[UIImage imageNamed:@"post_inactive_icon.png"] forState:UIControlStateNormal];
    }
}
- (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)resize

{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(resize.width, resize.height), NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, resize.width, resize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}


-(NSString *)capitalizeFirstLetter:(NSString *)str{
    NSString *strNew = [str stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                 withString:[[str substringToIndex:1] capitalizedString]];
    return strNew;
}

-(void)setKeyboardTheme{
    [self changeButtonTheme:self.button0];
    [self changeButtonTheme:self.button1];
    [self changeButtonTheme:self.button2];
    [self changeButtonTheme:self.button3];
    [self changeButtonTheme:self.button4];
    [self changeButtonTheme:self.button5];
    [self changeButtonTheme:self.button6];
    [self changeButtonTheme:self.button7];
    [self changeButtonTheme:self.button8];
    [self changeButtonTheme:self.button9];
    [self.deleteButton.layer setCornerRadius:5];
    [self.clearButton.layer setCornerRadius:5];
    [self.imagePageRetakeButton.layer setCornerRadius:25];
    self.imagePageRetakeButton.layer.borderWidth=3;
    [self.imagePageRetakeButton.layer setBorderColor:theme_color.CGColor];
}
-(void)changeButtonTheme:(UIButton *)button{
    [button.layer setCornerRadius:5];
    button.layer.borderWidth=3;
    [button.layer setBorderColor:theme_color.CGColor];
}

-(void)setupGestureRecognizer{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard{
    [self.titleTextField resignFirstResponder];
    [self.descriptionTextView resignFirstResponder];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.titleTextField resignFirstResponder];
    [self.descriptionTextView resignFirstResponder];
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
