//
//  SearchTableViewController.m
//  ProxiFinal
//
//  Created by Michael Liu on 10/12/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "SearchTableViewController.h"
#import "SearchResultsTableViewController.h"
#import "ItemBigTableViewCell.h"
#import "ItemBigCollectionViewCell.h"
#import "ItemDetailViewController.h"
#import "ItemContainer.h"
#import "ItemConnection.h"
#import "CategoryTableViewCell.h"
#import "Item.h"

#define Image_url_prefix @"http://proximarketplace.com/database/images/"

@interface SearchTableViewController ()<UISearchResultsUpdating, UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults; // Filtered search results
@property (strong,nonatomic) ItemContainer *itemContainer;
@property (strong,nonatomic) ItemContainer *searchContainer;
@property (strong,nonatomic) ItemConnection *itemConnection;
@property (strong,nonatomic) NSArray *colorArray;
@property (strong,nonatomic) NSMutableDictionary *contentOffsetDictionary;
@property (strong,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) NSArray *datasourceItemArray;
@property (strong,nonatomic) UIButton *viewMoreButton;
@end

@implementation SearchTableViewController{
    int i;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.itemConnection = [[ItemConnection alloc]init];
    self.searchContainer = [[ItemContainer alloc]init];
    [self.itemConnection fetchItemsFromIndex:0 amount:10];
    
    self.itemContainer = [[ItemContainer alloc]init];
    [self setupTestingSources];
    [self setupDatabase];
    [self setupFooterView];
    // Create a mutable array to contain products for the search results table.
    UIView *footerView = [self setupFooterView];
    
    self.tableView.tableFooterView = footerView;
    
    // The table view controller is in a nav controller, and so the containing nav controller is the 'search results controller'
    
    UINavigationController *searchResultsController = [[self storyboard] instantiateViewControllerWithIdentifier:@"TableSearchResultsNavController"];

    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    self.searchController.searchResultsUpdater = self;
    
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 50.0);
    
    [self.searchController.searchBar setBarTintColor:[UIColor colorWithRed:87/255.0 green:183/255.0 blue:182/255.0 alpha:1.0]];
    [self.searchController.searchBar setTintColor:[UIColor colorWithRed:251/255.0 green:176/255.0 blue:81/255.0 alpha:1.0]];
    [self.searchController.searchBar setPlaceholder:@"Search"];


    
    [self.searchController.searchBar.layer setBorderColor:[UIColor clearColor].CGColor];
    [self.searchController.searchBar setSearchBarStyle:UISearchBarStyleDefault];
    
    

    self.tableView.backgroundColor = [UIColor colorWithRed:153.0f/255.0f green:226.0f/255.0f blue:225.0f/255.0f alpha:1];
    self.tableView.backgroundView= nil;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    i = 10;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        static NSString *CellIdentifierRow1 = @"CategoryCellIdentifier";
        
        CategoryTableViewCell *cell = (CategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierRow1];
        
        if (!cell)
        {
            cell = [[CategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierRow1];
        }
        return cell;
    }else if(indexPath.section ==1){
        static NSString *CellIdentifierRow2 = @"ItemBigTableViewCellIdentifier";
        ItemBigTableViewCell *cell = (ItemBigTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierRow2];
        if (!cell) {
            cell = [[ItemBigTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierRow2];
        }
        return cell;
    }else{
        return nil;
    }
}




-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([collectionView isKindOfClass:[CategoryCollectionView class]]) {
        NSArray *collectionViewArray = self.colorArray[[(CategoryCollectionView *)collectionView indexPath].row];
        return collectionViewArray.count;
    }else if ([collectionView isKindOfClass:[ItemBigCollectionView class]]){
        return [self.datasourceItemArray count];
    }else{
        return 1;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    
    NSLog(@"%i",indexPath.item);
    if ([collectionView isKindOfClass:[ItemBigCollectionView class]]) {
        Item *item = [self.datasourceItemArray objectAtIndex:indexPath.item];
        ItemDetailViewController *itemDetailController = [[ItemDetailViewController alloc]initWithNibName:@"ItemDetailViewController" bundle:nil];
        itemDetailController.item = item;
        [self.navigationController pushViewController:itemDetailController animated:YES];
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isKindOfClass:[CategoryCollectionView class]]) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Category" forIndexPath:indexPath];
        //custom cell
        NSArray *collectionViewArray = self.colorArray[[(CategoryCollectionView *)collectionView indexPath].row];
        cell.backgroundColor = collectionViewArray[indexPath.item];
        [cell.layer setCornerRadius:50];
        
        
        return cell;
    }else if ([collectionView isKindOfClass:[ItemBigCollectionView class]]){
        self.collectionView = collectionView;
        UINib *nib = [UINib nibWithNibName:@"ItemBigCollectionViewCell" bundle: nil];
        [collectionView registerNib:nib forCellWithReuseIdentifier:@"ItemBigCollectionCell"];
        ItemBigCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItemBigCollectionCell" forIndexPath:indexPath];
        
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
                    [cell.cellImage setImage:[UIImage imageWithData: item_image_data]];
                });
            });
            
            
        }
        NSString *item_title = item.item_title;
        
        cell.cellPrice.text =[@"$ " stringByAppendingString:item.price_current];
        cell.cellTitle.backgroundColor = [UIColor colorWithRed:140/255.0 green:158/255.0 blue:255/255.0 alpha:1];
        cell.cellTitle.textColor = [UIColor whiteColor];
        cell.cellTitle.text = item_title;
        cell.cellTitle.textAlignment = NSTextAlignmentCenter;
        cell.cellPrice.textAlignment = NSTextAlignmentCenter;
        
        return cell;

        
               
        return cell;
    }else{
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[CategoryTableViewCell class]]) {
        CategoryTableViewCell *categoryCell = (CategoryTableViewCell *)cell;
        [categoryCell setCollectionViewDataSourceDelegate:self indexPath:indexPath];
        NSInteger index = categoryCell.collectionView.tag;
        
        CGFloat horizontalOffset = [self.contentOffsetDictionary[[@(index) stringValue]] floatValue];
        [categoryCell.collectionView setContentOffset:CGPointMake(horizontalOffset, 0)];
    }else if([cell isKindOfClass:[ItemBigTableViewCell class]]){
        ItemBigTableViewCell *itemBigCell = (ItemBigTableViewCell *)cell;
        [itemBigCell setCollectionViewDataSourceDelegate:self indexPath:indexPath];
        //NSInteger index = itemCell.collectionView.tag;
        
        // CGFloat horizontalOffset = [self.contentOffsetDictionary[[@(index) stringValue]] floatValue];
        //[itemCell.collectionView setContentOffset:CGPointMake(horizontalOffset, 0)];
    }else{
        
    }
    
}


//TableViewSettings

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ==0) {
        return 120;
    }else if(indexPath.section ==1){
        
        return [self.datasourceItemArray count]*([[UIScreen mainScreen]bounds].size.height*0.8+15)+10;
        
    }else{
        return 10;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 35;
            break;
        case 1:
            return 15;
            break;
        default:
            return 0;
            break;
    }
    
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Trending";
            break;
        case 1:
            sectionName = @"Today's sale";
            break;
            // ...
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

#pragma mark- setup
-(void)setupTestingSources{
    const NSInteger numberOfTableViewRows = 1;
    const NSInteger numberOfCollectionViewCells = 5;
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:numberOfTableViewRows];
    
    for (NSInteger tableViewRow = 0; tableViewRow < numberOfTableViewRows; tableViewRow++)
    {
        NSMutableArray *colorArray = [NSMutableArray arrayWithCapacity:numberOfCollectionViewCells];
        
        for (NSInteger collectionViewItem = 0; collectionViewItem < numberOfCollectionViewCells; collectionViewItem++)
        {
            
            CGFloat red = arc4random() % 255;
            CGFloat green = arc4random() % 255;
            CGFloat blue = arc4random() % 255;
            UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0f];
            
            [colorArray addObject:color];
        }
        
        [mutableArray addObject:colorArray];
    }
    
    self.colorArray = [NSArray arrayWithArray:mutableArray];
    
    self.contentOffsetDictionary = [NSMutableDictionary dictionary];
}


-(UIView *)setupFooterView{
    UIView *footerButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    footerButtonView.backgroundColor = [UIColor clearColor];
    self.viewMoreButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, 0, self.view.frame.size.width*0.9, 50)];
    
    [self.viewMoreButton setTitle:@"View More" forState:UIControlStateNormal];
    [self.viewMoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.viewMoreButton.layer setCornerRadius:25];
    [footerButtonView addSubview:self.viewMoreButton];
    self.viewMoreButton.backgroundColor = [UIColor colorWithRed:251.0f/255.0f green:176.0f/255.0f blue:87.0f/255.0f alpha:1];
    [self.viewMoreButton addTarget:self action:@selector(viewMoreButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    return footerButtonView;
    
}


-(void)setupDatabase{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTable:) name:@"FetchBigItemNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTable) name:@"updateTable" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateSearch:) name:@"FetchItemByNameNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(detailItem:) name:@"resultSelected" object:nil];
}

-(void)refreshTable:(NSNotification *)noti{
    
    [self.itemContainer addItemsFromJSONDictionaries:[noti object]];
    [self updateTable];
}

-(void)updateTable{
    self.datasourceItemArray = [self.itemContainer allItem];
    [self.tableView reloadData];
    
}

-(void)viewMoreButtonTapped{
    [self.itemContainer.container removeAllObjects];
    [self.itemConnection fetchItemsFromIndex:0 amount:[self.itemContainer.container count]+i];
    self.viewMoreButton.enabled = NO;
}

-(void)updateSearch:(NSNotification *)noti{
    
    [self.searchContainer.container removeAllObjects];
    [self.searchContainer addItemsFromJSONDictionaries:[noti object]];
    if (self.searchController.searchResultsController) {
        UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;
        SearchResultsTableViewController *vc = (SearchResultsTableViewController *)navController.topViewController;
        vc.searchResults = [self.searchContainer.container copy];
        [vc.tableView reloadData];
    }
    self.viewMoreButton.enabled = YES;
    //refresh indicator show
}

-(void)detailItem:(NSNotification *)noti{
    if ([[noti object]isKindOfClass:[ItemDetailViewController class]]) {
        ItemDetailViewController *vc = [noti object];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

@end
