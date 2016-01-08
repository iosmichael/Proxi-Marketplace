//
//  ChatViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 1/7/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import "ChatViewController.h"
#import "MasterViewController.h"

@interface ChatViewController ()<JSMessagesViewDelegate, JSMessagesViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSMutableArray *messageArray;
@property (strong,nonatomic) NSMutableArray *messageKeyArray;
@property BOOL readSeller;
@property (nonatomic,strong) UIImage *willSendImage;
@property (strong, nonatomic) NSMutableArray *timestamps;
@property (strong,nonatomic) NSString *sellerName;

@end

@implementation ChatViewController



#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.me = [self profileName:[[NSUserDefaults standardUserDefaults]objectForKey:@"username"]];
    self.sellerName = [self profileName:self.seller_email];
    self.firebase = [[[[Firebase alloc] initWithUrl:@"https://luminous-inferno-5888.firebaseio.com/"]childByAppendingPath:@"users"]childByAppendingPath:@"WheatonCollege"];
    self.delegate = self;
    self.dataSource = self;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:87/255.0 green:183/255.0 blue:182/255.0 alpha:1.0];
    self.navigationItem.title = self.title;
    self.messageArray = [NSMutableArray array];
    self.timestamps = [NSMutableArray array];
    self.messageKeyArray = [NSMutableArray array];
    
    self.tabBarController.tabBar.translucent= NO;
    [self setupDatabase];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.firebase removeAllObservers];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count;
}

#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    NSDate *now = [NSDate date];
    [self.timestamps addObject:now];
    NSNumber *timeInt = [NSNumber numberWithInt:[now timeIntervalSince1970]];
    
    NSDictionary *message = @{
                              @"content":text,
                              @"sender": self.me,
                              @"time": timeInt,
                              @"read": @"no"
                              };
    
    
    Firebase *destineFirebase = [[self.firebase childByAppendingPath:self.sellerName]childByAutoId];
    [destineFirebase setValue:message withCompletionBlock:^(NSError *error, Firebase *ref) {
        if (error) {
            [self errorResponse];
        }else{
            [JSMessageSoundEffect playMessageSentSound];
            [self finishSend];
        }
    }];

}
-(void)errorResponse{
    
}
- (void)cameraPressed:(id)sender{
    /*UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
     */
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"method"]isEqualToString:@"send"]) {
        return JSBubbleMessageTypeOutgoing;
    }else{
        return JSBubbleMessageTypeIncoming;
    }
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JSBubbleMessageStyleFlat;
}

- (JSBubbleMediaType)messageMediaTypeForRowAtIndexPath:(NSIndexPath *)indexPath{

        return JSBubbleMediaTypeText;

}

- (UIButton *)sendButton
{
    return [UIButton defaultSendButton];
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    /*
     JSMessagesViewTimestampPolicyAll = 0,
     JSMessagesViewTimestampPolicyAlternating,
     JSMessagesViewTimestampPolicyEveryThree,
     JSMessagesViewTimestampPolicyEveryFive,
     JSMessagesViewTimestampPolicyCustom
     */
    return JSMessagesViewTimestampPolicyEveryFive;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    /*
     JSMessagesViewAvatarPolicyIncomingOnly = 0,
     JSMessagesViewAvatarPolicyBoth,
     JSMessagesViewAvatarPolicyNone
     */
    return JSMessagesViewAvatarPolicyBoth;
}

- (JSAvatarStyle)avatarStyle
{
    /*
     JSAvatarStyleCircle = 0,
     JSAvatarStyleSquare,
     JSAvatarStyleNone
     */
    return JSAvatarStyleNone;
}

- (JSInputBarStyle)inputBarStyle
{
    /*
     JSInputBarStyleDefault,
     JSInputBarStyleFlat
     
     */
    return JSInputBarStyleFlat;
}

//  Optional delegate method
//  Required if using `JSMessagesViewTimestampPolicyCustom`
//
//  - (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
//

#pragma mark - Messages view data source
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"content"];
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *timeInt = [[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"time"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeInt doubleValue]];
    return date;
}

- (UIImage *)avatarImageForIncomingMessage
{
    return [UIImage imageNamed:@"image"];
}

- (UIImage *)avatarImageForOutgoingMessage
{
    return [UIImage imageNamed:@"image"];
}

- (id)dataForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
    
}

#pragma UIImagePicker Delegate

#pragma mark - Image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    self.willSendImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.messageArray addObject:[NSDictionary dictionaryWithObject:self.willSendImage forKey:@"Image"]];
    [self.timestamps addObject:[NSDate date]];
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
    
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



-(void)setupDatabase{
    
    [[[[[self.firebase childByAppendingPath:self.me]queryOrderedByChild:@"sender"]queryEqualToValue:self.sellerName]queryLimitedToLast:15] observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
            NSDictionary *message = @{
                                      @"content":snapshot.value[@"content"],
                                      @"time":snapshot.value[@"time"],
                                      @"method":@"receive"
                                      };
            [self.messageArray addObject:message];
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"time"  ascending:YES];
        NSArray *messages=[self.messageArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
        self.messageArray = [NSMutableArray arrayWithArray:messages];
        [self.messageKeyArray addObject:snapshot.key];
        [[[self.firebase childByAppendingPath:self.me]childByAppendingPath:snapshot.key]updateChildValues:@{@"read":@"yes"}];
        [self.tableView reloadData];
    }];
    [[[[[self.firebase childByAppendingPath:self.sellerName]queryOrderedByChild:@"sender"]queryEqualToValue:self.me]queryLimitedToLast:15] observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        NSDictionary *message = @{
                                  @"content":snapshot.value[@"content"],
                                  @"time":snapshot.value[@"time"],
                                  @"method":@"send"
                                  };
        [self.messageArray addObject:message];
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"time"  ascending:YES];
        NSArray *messages=[self.messageArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
        self.messageArray = [NSMutableArray arrayWithArray:messages];
        [self.tableView reloadData];
    }];
    
    
}



-(NSString *)profileName:(NSString *)email{
    NSString *usernameString = email;
    NSArray *components = [usernameString componentsSeparatedByString:@"@"];
    NSString *nameString = [components objectAtIndex:0];
    NSArray *nameComponents = [nameString componentsSeparatedByString:@"."];
    NSString *firstName = [nameComponents objectAtIndex:0];
    
    NSString *capitalizedFirstName = [firstName stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                        withString:[[firstName substringToIndex:1] capitalizedString]];
    NSString *lastName = [nameComponents objectAtIndex:1];
    NSString *capitalizedLastName = [lastName stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                      withString:[[lastName substringToIndex:1] capitalizedString]];
    
    NSString *fullName = [capitalizedFirstName stringByAppendingString:capitalizedLastName];
    return fullName;
    
}

@end
