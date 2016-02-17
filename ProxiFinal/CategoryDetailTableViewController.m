//
//  CategoryDetailTableViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 11/15/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "CategoryDetailTableViewController.h"
#import "Item.h"
#import "ItemConnection.h"
#import "ItemContainer.h"
#import "ItemTableViewCell.h"
#import "ItemCollectionViewCell.h"
#import "ItemDetailViewController.h"

#define Image_url_prefix @"http://proximarketplace.com/database/images/"
#define Screen_width [[UIScreen mainScreen]bounds].size.width

@interface CategoryDetailTableViewController()<UISearchBarDelegate>
@property (strong,nonatomic)NSArray *datasourceArray;
@property (strong,nonatomic)ItemConnection *connection;
@property (strong,nonatomic)ItemContainer  *itemContainer;
@property (strong,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) UISearchBar *searchBar;
@property (strong,nonatomic) UIRefreshControl *bottomRefresher;
@property (strong,nonatomic)NSString *searchText;

@end



@implementation CategoryDetailTableViewController{
    int i;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDatabase];

    self.tableView.backgroundColor = [UIColor whiteColor];
    i = 10;
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 44)];
    self.searchText = @"";
    self.searchBar.delegate = self;
    self.searchBar.barTintColor = [UIColor colorWithRed:50/255.0 green:144/255.0 blue:148/255.0 alpha:1.0];
    self.searchBar.tintColor = [UIColor whiteColor];
    self.searchBar.placeholder = @"Search Name";
    self.bottomRefresher = [UIRefreshControl new];
    self.bottomRefresher.triggerVerticalOffset = 100.;
    [self.bottomRefresher addTarget:self action:@selector(viewMoreButtonTapped) forControlEvents:UIControlEventValueChanged];
    self.tableView.bottomRefreshControl = self.bottomRefresher;
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)didReceiveMemoryWarning{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0) {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        [cell.contentView addSubview:self.searchBar];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }else if (indexPath.row==1){
        ItemTableViewCell *cell = (ItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
        if (!cell) {
            cell = [[ItemTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ItemCell"];
        }
        return cell;
    }else{
        return nil;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([collectionView isKindOfClass:[ItemCollectionView class]]){
        return [self.datasourceArray count];
    }else{
        return 1;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    if ([collectionView isKindOfClass:[ItemCollectionView class]]) {
        Item *item = [self.datasourceArray objectAtIndex:indexPath.item];
        ItemDetailViewController *itemDetailController = [[ItemDetailViewController alloc]initWithNibName:@"ItemDetailViewController" bundle:nil];
        itemDetailController.item = item;
        [self.navigationController pushViewController:itemDetailController animated:YES];
    }
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isKindOfClass:[ItemCollectionView class]]){
        self.collectionView = collectionView;
        UINib *nib = [UINib nibWithNibName:@"ItemCollectionViewCell" bundle: nil];
        [collectionView registerNib:nib forCellWithReuseIdentifier:@"ItemCollectionCell"];
        ItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItemCollectionCell" forIndexPath:indexPath];
        
        //custom cell
        Item *item = [self.itemContainer.container objectAtIndex:indexPath.row];
        if (!item.image_url) {
            UIImage *item_img= [UIImage imageNamed:@"manshoes"];
            [cell.cellImage setImage:item_img];
        }else{
            
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSError *error;
                NSString *urlString =[Image_url_prefix stringByAppendingString:item.image_url];
                NSURL *url = [NSURL URLWithString:urlString];
                NSData *item_image_data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
                if (error) {
                    NSLog(@"%@",[error description]);
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    ItemCollectionViewCell *cell = (ItemCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                    [cell.cellImage setImage:[UIImage imageWithData: item_image_data]];
                    
                });
            });
            
            
        }
        NSString *item_title = item.item_title;
        cell.cellPrice.text =[[@"$ " stringByAppendingString:item.price_current]stringByAppendingString:@" USD"];
        cell.cellLabel.text = item_title;
        cell.cellLabel.textAlignment = NSTextAlignmentCenter;
        cell.layer.masksToBounds = NO;
        cell.layer.cornerRadius = 2;
        cell.layer.shadowOffset = CGSizeMake(-1, 2);
        cell.layer.shadowRadius = 2;
        cell.layer.shadowOpacity = 0.5;
        return cell;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 44;
    }else{
        if ([self.datasourceArray count]%2==1) {
            return [self.datasourceArray count]*120+120;
        }
        else{
            return [self.datasourceArray count]*120;
        }
    }
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([cell isKindOfClass:[ItemTableViewCell class]]){
        ItemTableViewCell *itemCell = (ItemTableViewCell *)cell;
        [itemCell setCollectionViewDataSourceDelegate:self indexPath:indexPath];
    }
}

-(void)refreshTable:(NSNotification *)noti{
    NSArray *json = [noti object];
    [self.itemContainer addItemsFromJSONDictionaries:json];
    self.datasourceArray = self.itemContainer.container;
    [self.refreshControl endRefreshing];
    [self.bottomRefresher endRefreshing];
    [self.tableView reloadData];
}
-(void)refreshData{
    if ([self.searchText isEqualToString:@""]) {
        [self.connection fetchItemsByCategory:self.categoryName amount:[self.itemContainer.container count]];
        [self.itemContainer.container removeAllObjects];
    }else{
        [self.connection fetchItemsByCategory:self.categoryName titleSearch:self.searchText amount:[self.itemContainer.container count]];
        [self.itemContainer.container removeAllObjects];
    }
}

-(void)viewMoreButtonTapped{
    if ([self.searchText isEqualToString:@""]) {
        [self.connection fetchItemsByCategory:self.categoryName amount:[self.itemContainer.container count]+i];
        [self.itemContainer.container removeAllObjects];
    }else{
        [self.connection fetchItemsByCategory:self.categoryName titleSearch:self.searchText amount:[self.itemContainer.container count]+i];
        [self.itemContainer.container removeAllObjects];
    }
}


-(void)setupDatabase{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTable:) name:@"FetchItemByCategoryNotification" object:nil];
    self.itemContainer = [[ItemContainer alloc]init];
    self.datasourceArray = [[NSMutableArray alloc]init];
    self.connection = [[ItemConnection alloc]init];
    i = 10;
    self.navigationController.navigationBarHidden = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:50/255.0 green:144/255.0 blue:148/255.0 alpha:1.0];

    self.navigationItem.title = self.categoryName;
    [self.itemContainer fetchItemsFromDatabaseWithCategoryName:self.categoryName number:20];
    
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.searchText = [searchBar text];
    [self.connection fetchItemsByCategory:self.categoryName titleSearch:self.searchText amount:[self.itemContainer.container count]];
    [self.itemContainer.container removeAllObjects];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}



@end
