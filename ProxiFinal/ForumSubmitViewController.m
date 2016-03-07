//
//  ForumSubmitViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 3/5/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import "ForumSubmitViewController.h"
#import "HHAlertView.h"
#define forum_url @"https://luminous-inferno-5888.firebaseio.com/"

@interface ForumSubmitViewController ()<UITextViewDelegate,HHAlertViewDelegate>
@property (strong,nonatomic) Firebase *firebase;

@end

@implementation ForumSubmitViewController{
    NSString *user_name;
    NSString *user_email;
    BOOL textViewEdited;
    UIViewController *modalViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.firebase = [[[[Firebase alloc] initWithUrl:forum_url]childByAppendingPath:@"forum"]childByAppendingPath:self.forum_category];
    [self setupGestureRecognizer];
    [[HHAlertView shared]setDelegate:self];
    modalViewController = [[UIViewController alloc]init];
    user_email = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    [self setupUsername];
    self.navigationController.navigationBar.translucent = NO;
    self.forum_description.delegate = self;
    self.postButton.layer.cornerRadius = 5.0;
}

- (IBAction)sendPressed
{
    NSDate *now = [NSDate date];
    NSNumber *timeInt = [NSNumber numberWithInt:[now timeIntervalSince1970]];
    NSDictionary *message = @{
                              @"forum_title":user_name,
                              @"forum_email": user_email,
                              @"forum_description": [self.forum_description.text stringByAppendingString:@"\n"],
                              @"time": timeInt
                              };
    Firebase *destineFirebase = [self.firebase childByAutoId];
    [destineFirebase setValue:message withCompletionBlock:^(NSError *error, Firebase *ref) {
        if (error) {
            [self postErrorResponse];
        }else{
            [self postSuccessResponse];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (!textViewEdited) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    textViewEdited = YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length==0) {
        textViewEdited= NO;
        self.forum_description.text = @"You Post Here...";
        self.forum_description.textColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1];
    }
}
-(void)textViewDidChange:(UITextView *)textView{
    NSArray *components = [textView.text componentsSeparatedByString:@" "];
    self.wordCount.text = [[@(components.count)stringValue]stringByAppendingString:@" words"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
-(void)setupGestureRecognizer{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard{
    [self.forum_description resignFirstResponder];
}

-(void)postErrorResponse{
    [HHAlertView showAlertWithStyle:HHAlertStyleError inView:modalViewController.view Title:@"Error!" detail:@"Please Check Network Connection" cancelButton:@"Cancel" Okbutton:nil];
    [self presentViewController:modalViewController animated:YES completion:nil];
    
}
-(void)postSuccessResponse{
    [HHAlertView showAlertWithStyle:HHAlertStyleOk inView:modalViewController.view Title:@"Congrats!" detail:@"Thank you for using Proxi" cancelButton:nil Okbutton:@"Thank you"];
    [self presentViewController:modalViewController animated:YES completion:nil];
}

-(void)didClickButtonAnIndex:(HHAlertButton)button{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)setupUsername{
    user_name = @"";
    NSArray *components = [user_email componentsSeparatedByString:@"@"];
    NSArray *sub_components = [components[0] componentsSeparatedByString:@"."];
    for (NSString *name in sub_components) {
//to uppercase
        NSString *uppercase = [[name substringToIndex:1]uppercaseString];
        NSString *lowercase = [[name substringFromIndex:1]lowercaseString];
        user_name = [[[user_name stringByAppendingString:uppercase]stringByAppendingString:lowercase]stringByAppendingString:@" "];
    }
}
@end
