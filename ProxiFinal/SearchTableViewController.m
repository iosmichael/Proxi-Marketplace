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
#import "GMDCircleLoader.h"
#import "Item.h"

#define Image_url_prefix @"http://proximarketplace.com/database/images/event/"

@interface SearchTableViewController ()<UISearchResultsUpdating, UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults; // Filtered search results
@property (strong,nonatomic) NSArray *eventArray;
@property (strong,nonatomic) ItemContainer *searchContainer;
@property (strong,nonatomic) ItemConnection *itemConnection;
@property (strong,nonatomic) NSArray *colorArray;
@property (strong,nonatomic) NSMutableDictionary *contentOffsetDictionary;
@property (strong,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) NSArray *datasourceItemArray;
@property (strong,nonatomic) UIButton *viewMoreButton;
@property (strong,nonatomic) NSArray *categoryImagesArray;
@end

@implementation SearchTableViewController{
    int i;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.searchContainer = [[ItemContainer alloc]init];
    self.itemConnection = [[ItemConnection alloc]init];
    EventConnection *connection = [[EventConnection alloc]init];
    [self setupTestingSources];
    [self setupDatabase];
    [connection fetchEvents];
    // Create a mutable array to contain products for the search results table.
    
    // The table view controller is in a nav controller, and so the containing nav controller is the 'search results controller'

    
//Search code begin
    UINavigationController *searchResultsController = [[self storyboard] instantiateViewControllerWithIdentifier:@"TableSearchResultsNavController"];

    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    self.searchController.searchResultsUpdater = self;
    
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 50.0);
    
    [self.searchController.searchBar setBarTintColor:[UIColor colorWithRed:87/255.0 green:183/255.0 blue:182/255.0 alpha:1.0]];
    [self.searchController.searchBar setTintColor:[UIColor colorWithRed:251/255.0 green:176/255.0 blue:81/255.0 alpha:1.0]];
    [self.searchController.searchBar setPlaceholder:@"Search"];

    [self.searchController.searchBar.layer setBorderColor:[UIColor clearColor].CGColor];
    [self.searchController.searchBar setSearchBarStyle:UISearchBarStyleDefault];
    
// Search code end
    
    
    
    self.tableView.backgroundColor = [UIColor colorWithRed:153.0f/255.0f green:226.0f/255.0f blue:225.0f/255.0f alpha:1];
    self.tableView.backgroundView= nil;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.tableView setShowsVerticalScrollIndicator:NO];
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
        return [self.eventArray count];
    }else{
        return 1;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    if ([collectionView isKindOfClass:[ItemBigCollectionView class]]) {
        Event *event = [self.eventArray objectAtIndex:indexPath.item];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:event.url]];
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isKindOfClass:[ItemBigCollectionView class]]){
        self.collectionView = collectionView;
        UINib *nib = [UINib nibWithNibName:@"ItemBigCollectionViewCell" bundle: nil];
        [collectionView registerNib:nib forCellWithReuseIdentifier:@"ItemBigCollectionCell"];
        ItemBigCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItemBigCollectionCell" forIndexPath:indexPath];
        
        //custom cell
        Event *event = [self.eventArray objectAtIndex:indexPath.row];
        if (!event.img_url) {
            UIImage *item_img= [UIImage imageNamed:@"manshoes"];
            [cell.cellImage setImage:item_img];
        }else{
            
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSError *error;
                NSString *urlString =[Image_url_prefix stringByAppendingString:event.img_url];
                NSURL *url = [NSURL URLWithString:urlString];
                NSData *event_img_url = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
                if (error) {
                    NSLog(@"%@",[error description]);
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cell.cellImage setImage:[UIImage imageWithData: event_img_url]];
                });
            });
            
            
        }
        NSString *event_title = event.title;
        
        cell.cellPrice.text =event.time;
        cell.cellTitle.text = event_title;
        return cell;

        
               
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
        //NSInteger index = itemCell.collectionView.tag;
        
        // CGFloat horizontalOffset = [self.contentOffsetDictionary[[@(index) stringValue]] floatValue];
        //[itemCell.collectionView setContentOffset:CGPointMake(horizontalOffset, 0)];
    }else{
        
    }
    
}


//TableViewSettings

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   if(indexPath.section ==0){
        
        return [self.eventArray count]*([[UIScreen mainScreen]bounds].size.height*0.4-20+15)+10;
        
    }else{
        return 0;
    }
}


#pragma mark- setup
-(void)setupTestingSources{
    const NSInteger numberOfTableViewRows = 1;
    const NSInteger numberOfCollectionViewCells = 6;
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:numberOfTableViewRows];
    
    for (NSInteger tableViewRow = 0; tableViewRow < numberOfTableViewRows; tableViewRow++)
    {
        NSMutableArray *colorArray = [NSMutableArray arrayWithCapacity:numberOfCollectionViewCells];
        
        for (NSInteger collectionViewItem = 0; collectionViewItem < numberOfCollectionViewCells; collectionViewItem++)
        {
            
            UIImageView *categoryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
            UIImage *categoryImage= [UIImage imageNamed:[self.categoryImagesArray objectAtIndex:collectionViewItem]];
            [categoryImageView setImage:categoryImage];
            [colorArray addObject:categoryImageView];
        }
        
        [mutableArray addObject:colorArray];
    }
    
    self.colorArray = [NSArray arrayWithArray:mutableArray];
    
    self.contentOffsetDictionary = [NSMutableDictionary dictionary];
}



-(void)setupDatabase{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(eventsFromNotification:) name:@"EventNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateSearch:) name:@"FetchItemByNameNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(detailItem:) name:@"resultSelected" object:nil];
}


-(void)eventsFromNotification:(NSNotification *)noti{
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSArray *json = [noti object];
    
    for (NSDictionary *dic in json) {
        NSString *title = dic[@"event_title"];
        NSString *url = dic[@"event_url"];
        NSString *time = dic[@"event_time"];
        NSString *img_url = dic[@"img_url"];
        Event *event = [[Event alloc]initWithTitle:title time:time url:url image:img_url];
        [array addObject:event];
    }

    self.eventArray = array;

    [self.tableView reloadData];
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

    //refresh indicator show
}

-(void)detailItem:(NSNotification *)noti{
    if ([[noti object]isKindOfClass:[ItemDetailViewController class]]) {
        ItemDetailViewController *vc = [noti object];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

@end
