//
//  ForumPostTableViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 3/4/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import "ForumPostTableViewController.h"
#import "ForumTableViewCell.h"
#import "ForumSubmitViewController.h"

#define forum_url @"https://luminous-inferno-5888.firebaseio.com/"
#define screen_width [UIScreen mainScreen].bounds.size.width
#define header_backgroundColor [UIColor colorWithRed:47/255.0 green:52/255.0 blue:87/255.0 alpha:1]

@interface ForumPostTableViewController ()
@property (strong,nonatomic) NSMutableArray *dataSource;
@property (strong,nonatomic) NSMutableArray *dataSourceKey;
@property (strong,nonatomic) Firebase *firebase;
@end

@implementation ForumPostTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:50/255.0 green:144/255.0 blue:148/255.0 alpha:1];
    UIImage *image = [self resizeImage:[UIImage imageNamed:@"Proxi Logo.png"] toSize:CGSizeMake(90, 35)];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    self.navigationItem.titleView = imageView;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.dataSource = [NSMutableArray array];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.firebase = [[[[Firebase alloc]initWithUrl:forum_url]childByAppendingPath:@"forum"]childByAppendingPath:self.category];
    UINib *nibForScrollViewCell = [UINib nibWithNibName:@"ForumTableViewCell" bundle:nil];
    [self.tableView registerNib:nibForScrollViewCell forCellReuseIdentifier:@"forumCell"];
    self.tableView.tableHeaderView = [self setupTableHeaderView:self.category];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    [self setupDatabase];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addForumPost)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addForumPost{
    ForumSubmitViewController *forumSubmitViewController = [[ForumSubmitViewController alloc]init];
    forumSubmitViewController.forum_category = self.category;
    [self.navigationController pushViewController:forumSubmitViewController animated:YES];
}
# pragma mark - Cell Setup
- (void)setUpCell:(ForumTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    cell.forum_title.text = dic[@"forum_title"];
    cell.forum_email.text = dic[@"forum_email"];
    cell.forum_description.text = dic[@"forum_description"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ForumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"forumCell" forIndexPath:indexPath];
    [self setUpCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static ForumTableViewCell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"forumCell"];
    });
    [self setUpCell:cell atIndexPath:indexPath];
    
    return [self calculateHeightForConfiguredSizingCell:cell withEmailButton:NO];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(ForumTableViewCell *)sizingCell withEmailButton:(BOOL)extraHeight{
    [sizingCell layoutIfNeeded];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    if (extraHeight) {
        return size.height+40;
    }
    return size.height;
}

-(void)setupDatabase{
    [[self.firebase queryLimitedToFirst:15] observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        NSDictionary *message = @{
                                  @"forum_title":snapshot.value[@"forum_title"],
                                  @"forum_email":snapshot.value[@"forum_email"],
                                  @"forum_description":snapshot.value[@"forum_description"],
                                  @"time":snapshot.value[@"time"]
                                  };
        [self.dataSource addObject:message];
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"time"  ascending:YES];
        NSArray *messages=[self.dataSource sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
        self.dataSource = [NSMutableArray arrayWithArray:messages];
        NSLog(@"%@",[self.dataSource description]);
        [self.tableView reloadData];
    }];
    
}

-(UIView *)setupTableHeaderView:(NSString *)category{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 90)];
    headerView.backgroundColor = header_backgroundColor;
    NSAttributedString *headerStr = [[NSAttributedString alloc]initWithString:category attributes:@{
                                        NSFontAttributeName:[UIFont fontWithName:@"Gotham-Medium" size:27.5],
                                        NSForegroundColorAttributeName: [UIColor whiteColor]
                                }];
    UILabel *headerTitle = [[UILabel alloc]initWithFrame:CGRectMake(screen_width*0.1, 14, screen_width*0.8, 65.5)];
    headerTitle.attributedText = headerStr;
    headerTitle.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:headerTitle];
    return headerView;
}


- (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)resize

{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(resize.width, resize.height), NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, resize.width, resize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
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
