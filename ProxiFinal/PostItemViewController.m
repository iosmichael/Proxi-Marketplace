//
//  PostItemViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 10/10/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "PostItemViewController.h"
#import "ItemConnection.h"
#import "Item.h"
#import "HHAlertView.h"


#define PostItemSuccessProtocol @"success"
//TEST POST ITEM PROCESS

@interface PostItemViewController ()<UITableViewDataSource,UITableViewDelegate,HHAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *postButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *refresher;
@end

@implementation PostItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[HHAlertView shared] setDelegate:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(successPost:) name:@"PostItemNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(errorPost) name:@"PostItemNotificationError" object:nil];
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.refresher setHidden:YES];
    self.navigationController.navigationBarHidden = YES;
    if (!self.postImage) {
        self.postImage = [[UIImage alloc]init];
    }
    self.navigationController.navigationItem.title = @"Post Item";
    CGFloat screen_width = [UIScreen mainScreen].bounds.size.width;
    
    self.imageButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, screen_width-20, screen_width)];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screen_width-20, screen_width)];
    [self.imageButton addSubview:self.imageView];
    [self.imageButton addTarget:self action:@selector(resetImage) forControlEvents:UIControlEventTouchUpInside];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imageView setClipsToBounds:YES];
    [self.imageView setImage:self.postImage];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:87.0f/255.0f green:183.0f/255.0f blue:182.0f/255.0f alpha:0.3];
    self.tableView.backgroundView= nil;
    [self.postButton.layer setCornerRadius:15];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TextfieldCell"];
    [self setupData];
    self.postButton.enabled = YES;
    
}
- (void)resetImage{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return [UIScreen mainScreen].bounds.size.width;
            break;
            
        default:
            return 60;
            break;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextfieldCell"];
    cell.contentView.backgroundColor = [UIColor colorWithRed:87.0f/255.0f green:183.0f/255.0f blue:182.0f/255.0f alpha:0.8];
    cell.backgroundView = nil;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width*0.05, 0, self.tableView.frame.size.width*0.95, 20)];
    [label setTextColor:[UIColor whiteColor]];
    

    switch (indexPath.row) {
        case 1:
            //Title
            label.text = @"Title";
            [cell.contentView addSubview:label];
            [cell.contentView addSubview:self.titleTextfield];
            break;
        case 2:

            label.text = @"High Price";
            [cell.contentView addSubview:label];
            [cell.contentView addSubview:self.highpriceTextfield];
            
            break;
        case 3:

            label.text = @"Low Price";
            [cell.contentView addSubview:label];
            [cell.contentView addSubview:self.lowpriceTextfield];
            
            break;
        case 4:

            label.text = @"Category";
            [cell.contentView addSubview:label];
            [cell.contentView addSubview:self.categoryTextfield];
            
            break;
        case 5:

            label.text = @"Description";
            [cell.contentView addSubview:label];
            [cell.contentView addSubview:self.descriptionTextfield];
            
            break;
        case 0:
            [cell.contentView addSubview:self.imageButton];
            break;
        default:
            
            break;
    }
    return cell;
}


- (IBAction)postItem:(id)sender {
    //post it and Send Data to Server
    
    NSData *img = UIImageJPEGRepresentation(self.imageView.image, 0.2);
#warning  highPrice entered only
#warning NSUserDefaults is invalid
    NSLog( @"%@",[self.titleTextfield.text description]);
    Item *item = [[Item alloc]initWithTitle:self.titleTextfield.text
                                description:self.descriptionTextfield.text
                                  userEmail:[[NSUserDefaults standardUserDefaults]objectForKey:@"username"]
                                      image:img date:nil itemID:nil price:self.highpriceTextfield.text
                    category:self.categoryTextfield.text];
    self.postButton.enabled = NO;
    ItemConnection *connection = [[ItemConnection alloc]init];
    [connection postItemData:item];
    self.refresher.hidden = NO;
    [self.refresher startAnimating];
    //Start Refresher
    
}


-(void)setupData{
    CGRect textfieldFrame = CGRectMake(self.tableView.frame.size.width*0.05, 20, self.tableView.frame.size.width*0.9, 40);
    
    self.titleTextfield = [[JAMValidatingTextField alloc]initWithFrame:textfieldFrame];
    [self.titleTextfield setValidationType:JAMValidatingTextFieldTypeNone];
    self.descriptionTextfield = [[JAMValidatingTextField alloc]initWithFrame:textfieldFrame];
    [self.descriptionTextfield setValidationType: JAMValidatingTextFieldTypeNone];
    self.highpriceTextfield = [[JAMValidatingTextField alloc]initWithFrame:textfieldFrame];
    [self.highpriceTextfield setValidationType: JAMValidatingTextFieldTypeNone];
    self.lowpriceTextfield = [[JAMValidatingTextField alloc]initWithFrame:textfieldFrame];
    [self.lowpriceTextfield setValidationType:JAMValidatingTextFieldTypeNone];
    self.categoryTextfield = [[JAMValidatingTextField alloc]initWithFrame:textfieldFrame];
    [self.categoryTextfield setValidationType:JAMValidatingTextFieldTypeNone];
    
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


@end
