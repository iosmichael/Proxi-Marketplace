//
//  SearchTableViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 10/12/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "SearchTableViewController.h"
#import "SearchResultsTableViewController.h"
#import "ForumPostTableViewController.h"
#import "ItemBigTableViewCell.h"
#import "ItemBigCollectionViewCell.h"
#import "ItemDetailViewController.h"
#import "ItemContainer.h"
#import "ItemConnection.h"
#import "CategoryTableViewCell.h"
#import "Item.h"
#import "Store.h"


@interface SearchTableViewController ()<UISearchResultsUpdating, UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults; // Filtered search results
@property (strong,nonatomic) NSArray *storeArray;
@property (strong,nonatomic) ItemContainer *searchContainer;
@property (strong,nonatomic) ItemConnection *itemConnection;
@property (strong,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) NSArray *datasourceItemArray;

@end

@implementation SearchTableViewController{
    int i;
    NSMutableArray *imagesArray;
    NSArray *categoryArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.searchContainer = [[ItemContainer alloc]init];
    self.itemConnection = [[ItemConnection alloc]init];
    //EventConnection *connection = [[EventConnection alloc]init];
    //[connection fetchEvents];
    [self setupDatabase];

    
//Search code begin
    UINavigationController *searchResultsController = [[self storyboard] instantiateViewControllerWithIdentifier:@"TableSearchResultsNavController"];

    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    self.searchController.searchResultsUpdater = self;
    
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 50.0);
    
    [self.searchController.searchBar setBarTintColor:[UIColor colorWithRed:50/255.0 green:144/255.0 blue:148/255.0 alpha:1.0]];
    [self.searchController.searchBar setTintColor:[UIColor whiteColor]];
    [self.searchController.searchBar setPlaceholder:@"Search"];

    [self.searchController.searchBar.layer setBorderColor:[UIColor clearColor].CGColor];
    [self.searchController.searchBar setSearchBarStyle:UISearchBarStyleDefault];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundView= nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.tableView setShowsVerticalScrollIndicator:NO];
    i = 10;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchString = [self.searchController.searchBar text];
    [self updateSearchForItemName:searchString];
}

-(void)updateSearchForItemName:(NSString *)searchString{
    [self.itemConnection fetchItemsByName:searchString FromIndex:0 amount:5];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        static NSString *CellIdentifierRow2 = @"ItemBigTableViewCellIdentifier";
        ItemBigTableViewCell *cell = (ItemBigTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierRow2];
        if (!cell) {
            cell = [[ItemBigTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierRow2];
        }
        return cell;

}




-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([collectionView isKindOfClass:[ItemBigCollectionView class]]){
        return [categoryArray count];
    }else{
        return 1;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    if ([collectionView isKindOfClass:[ItemBigCollectionView class]]) {
       /* Store *store = [self.storeArray objectAtIndex:indexPath.item];
        //Show Store Info
        StoreViewController *storeViewController = [[StoreViewController alloc]initWithNibName:@"StoreViewController" bundle:nil];
        storeViewController.store = store;
        [self.navigationController pushViewController:storeViewController animated:YES];
        */
       /* Event *event = [self.eventArray objectAtIndex:indexPath.item];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:event.url]];
        */
        NSString *forum_category = [categoryArray objectAtIndex:indexPath.row];
        ForumPostTableViewController *forumViewController = [[ForumPostTableViewController alloc]init];
        forumViewController.category = forum_category;
        [self.navigationController pushViewController:forumViewController animated:YES];
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isKindOfClass:[ItemBigCollectionView class]]){
        self.collectionView = collectionView;
        UINib *nib = [UINib nibWithNibName:@"ItemBigCollectionViewCell" bundle: nil];
        [collectionView registerNib:nib forCellWithReuseIdentifier:@"ItemBigCollectionCell"];
        ItemBigCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItemBigCollectionCell" forIndexPath:indexPath];
        
        //custom cell
        /*Store *store = [self.storeArray objectAtIndex:indexPath.row];
        if ([store.store_status isEqualToString:@"open"]) {
            [cell.cellImage setImage:[UIImage imageNamed:@"store_open"]];
        }else{
            [cell.cellImage setImage:[UIImage imageNamed:@"store_close"]];
        }
        NSString *store_title = store.store_location;
        
        cell.cellPrice.text =store.store_open_time;
        cell.cellTitle.text = store_title;
        return cell;
         */
        [cell.cellImage setImage:[imagesArray objectAtIndex:indexPath.row]];
        return cell;
    }else{
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([cell isKindOfClass:[ItemBigTableViewCell class]]){
        ItemBigTableViewCell *itemBigCell = (ItemBigTableViewCell *)cell;
        [itemBigCell setCollectionViewDataSourceDelegate:self indexPath:indexPath];
    }
    
}


//TableViewSettings

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==0){
        
        return [categoryArray count]*180;//[[UIScreen mainScreen]bounds].size.height*0.4-20+15);
        
    }else{
        return 0;
    }

}


#pragma mark- setup

-(void)setupDatabase{
    /*
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(storesFromNotification:) name:@"StoreNotification" object:nil];
     */
    categoryArray = @[@"Rides Home",@"Tutoring",@"Airport Rides",@"Movers"];
    imagesArray = [NSMutableArray array];
    for (NSString *imageTitle in categoryArray) {
        [imagesArray addObject:[UIImage imageNamed:imageTitle]];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateSearch:) name:@"FetchItemByNameNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(detailItem:) name:@"resultSelected" object:nil];
}

/*
-(void)storesFromNotification:(NSNotification *)noti{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSArray *json = [noti object];
    
    for (NSDictionary *dic in json) {
        NSString *store_id = dic[@"store_id"];
        NSString *store_location = dic[@"store_location"];
        NSString *store_name= dic[@"store_name"];
        NSString *store_open_time = dic[@"store_open_time"];
        NSString *store_operator = dic[@"store_operator"];
        NSString *store_status = dic[@"store_status"];
        Store *store = [[Store alloc]initWithID:store_id name:store_name time:store_open_time owner:store_operator location:store_location status:store_status];
        [array addObject:store];
    }
    self.storeArray = array;

    [self.tableView reloadData];
}
*/

-(void)updateSearch:(NSNotification *)noti{

    [self.searchContainer.container removeAllObjects];
    NSLog(@"%@",[noti object]);
    [self.searchContainer addItemsFromJSONDictionaries:[noti object]];

    if (self.searchController.searchResultsController) {
        UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;
        SearchResultsTableViewController *vc = (SearchResultsTableViewController *)navController.topViewController;
        vc.searchResults = [self.searchContainer.container copy];
        [vc.tableView reloadData];
    }

    //refresh indicator show
}

-(void)detailItem:(NSNotification *)noti{
    if ([[noti object]isKindOfClass:[ItemDetailViewController class]]) {
        ItemDetailViewController *vc = [noti object];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

@end
