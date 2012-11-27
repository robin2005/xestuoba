//
//  CommonTableViewController.h
//  AboutSex
//
//  Created by Shane Wen on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Item.h"
#import "SharedVariables.h"
#import "StoreManager.h"

@interface CommonTableViewController : UITableViewController
{
    BOOL mHasAppearedBefore;
}

@property (nonatomic, assign) BOOL mHasAppearedBefore;

- (id) initWithTitle:(NSString*)aTitle;
- (void) configTableView;
- (void) markItemOfSeletedRowAsReaded;


- (Item*) getItemByIndexPath:(NSIndexPath*)aIndexPath;
- (BOOL) canCollectOnContentPage;
- (void) loadData;

- (void) refreshTableView;
- (BOOL) appearFirstTime;

- (BOOL) toggleColletedStatusOfSelectedRow;
- (BOOL) getCollectionStatuForSelectedRow;


@end
