//
//  CommonTableViewController.m
//  AboutSex
//
//  Created by Shane Wen on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonTableViewController.h"
#import "ContentViewController.h"
#import "TaggedButton.h"
@interface CommonTableViewController ()
@end

@implementation CommonTableViewController

@synthesize mHasAppearedBefore;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithTitle:(NSString*)aTitle
{
    self = [super init];
    if (self)
    {   
        if (aTitle)
        {
            self.navigationItem.title = aTitle;
            self.mHasAppearedBefore = NO;
        } 
        
        [self configTableView];
    }
    return self;
}

- (void) configTableView
{    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setSeparatorColor:[UIColor colorWithRed:RGB_DIV_255(235) green:RGB_DIV_255(235) blue:RGB_DIV_255(235) alpha:1.0f]];
    self.tableView.scrollEnabled = YES;
    self.tableView.allowsSelection = YES;
//    self.tableView.allowsMultipleSelection = NO;
    self.tableView.backgroundColor = TAB_PAGE_BGCOLOR;


    return;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshTableView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (!(self.mHasAppearedBefore))
    {
        self.mHasAppearedBefore = YES;        
    }
}

- (void) refreshTableView
{
    [self loadData];
    [self.tableView reloadData];
}

- (BOOL) appearFirstTime
{
    return (!(self.mHasAppearedBefore));
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) markItemOfSeletedRowAsReaded
{
    NSIndexPath* sSelectedIndexPath =  [self.tableView indexPathForSelectedRow];
    Item* sItem = [self getItemByIndexPath:sSelectedIndexPath];
    
    if (!sItem.mIsRead)
    {
        sItem.mIsRead = YES;
        [sItem markAsReadInDatabase];
//        [StoreManager updateItemReadStatus:YES ItemID:sItem.mItemID];
    }
}


- (Item*) getItemByIndexPath:(NSIndexPath*)aIndexPath
{
    return nil;
}

- (BOOL) canCollectOnContentPage
{
    return YES;
}

- (void) loadData
{    
    return;
}

- (BOOL) getCollectionStatuForSelectedRow
{
    NSIndexPath* sSelectedIndexPath = [self.tableView indexPathForSelectedRow];    
    Item* sItem = [self getItemByIndexPath:sSelectedIndexPath];
    return sItem.mIsMarked;
}

- (BOOL) toggleCollectedStatusByButton:(id)aButton
{
#ifdef DEBUG
    NSLog(@"aButton: %@", [aButton class]);
#endif
    TaggedButton* sFavButton = (TaggedButton*)aButton;
    NSIndexPath* sIndexPath = sFavButton.mIndexPath;
    
    BOOL sRet = [self reverseColletedStatus:sIndexPath];
    
    if (sRet)
    {
        [sFavButton setImage: [UIImage imageNamed:@"favorite24.png"] forState:UIControlStateNormal];
    }
    else 
    {
        [sFavButton setImage: [UIImage imageNamed:@"favorite_inactive24.png"] forState:UIControlStateNormal];
    }   
    
    
    return sRet;
}

- (BOOL) toggleColletedStatusOfSelectedRow
{
    NSIndexPath* sSelectedIndexPath =  [self.tableView indexPathForSelectedRow];
    
    BOOL sRet = [self reverseColletedStatus:sSelectedIndexPath];
    //the following line does not work, strangely, so use UITableView selectRowAtIndexPath:
    //        [self.tableView cellForRowAtIndexPath:sSelectedIndexPath].selected = YES;
    //    [self.tableView selectRowAtIndexPath:sSelectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    return sRet;    
}


#pragma mark -
#pragma mark methods to chanage message's collection status.
- (BOOL) reverseColletedStatus:(NSIndexPath*)aIndexPath
{
    Item* sItem = [self getItemByIndexPath:aIndexPath];
    
    sItem.mIsMarked = !sItem.mIsMarked;
    [sItem updateMarkedStaus:sItem.mIsMarked];
    
    return sItem.mIsMarked;
}

#pragma mark - Table view data source

///!!!! method below is called even if the method is overridden in its inheritting class, why???
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    //    NSInteger sRow = [indexPath row];
    Item* sItem = [self getItemByIndexPath:indexPath];
    NSString* sTitle = sItem.mName;
    NSString* sLoc = sItem.mLocation;
    NSURL* sURL = nil;
    if ([sLoc hasPrefix:@"data/"])
    {
        NSString* sBundlePath = [[NSBundle mainBundle] bundlePath];
        sLoc = [sBundlePath stringByAppendingPathComponent:sLoc];
        sURL = [NSURL fileURLWithPath:sLoc];
    }
    else if([sLoc hasPrefix:@"StreamData/"])
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES); 
        NSString *documentsDirectory = [paths objectAtIndex:0];   
        sLoc = [documentsDirectory stringByAppendingPathComponent:sLoc];
        sURL = [NSURL fileURLWithPath:sLoc];
    }
    else 
    {
        sURL = [NSURL URLWithString:sLoc];
    }
    
//    NSString* sLoc = [APP_DIR stringByAppendingString: sLocV];
    
    ContentViewController* sContentViewController;
    sContentViewController = [[ContentViewController alloc]init];
    sContentViewController.hidesBottomBarWhenPushed = YES;
    sContentViewController.mItemListViewController = self;
    
    [self.navigationController pushViewController:sContentViewController animated:YES];
    
    [sContentViewController setTitle:sTitle AndContentLoc:sURL AndWithCollectionSupport:[self canCollectOnContentPage]];
    
    [sContentViewController release];
    
    //refresh the corresponding item's isRead status if necessary.
    [self markItemOfSeletedRowAsReaded];
    
    
    return;
}
@end
