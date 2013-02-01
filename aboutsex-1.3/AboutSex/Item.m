//
//  Item.m
//  AboutSex
//
//  Created by Shane Wen on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Item.h"
#import "StoreManager.h"

@implementation Item


@synthesize mItemID;
@synthesize mName;
@synthesize mLocation;
@synthesize mIsRead;
@synthesize mIsMarked;
@synthesize mReleasedTime;
@synthesize mMarkedTime;
@synthesize mCategory;
@synthesize mSection;



- (void)dealloc
{
    self.mName = nil;
    self.mLocation = nil;
    self.mReleasedTime = nil;
    self.mMarkedTime = nil;
    self.mSection = nil;
    self.mCategory = nil;
    
    [super dealloc];

}

- (void) markAsReadInDatabase
{
    [StoreManager updateItemReadStatus:YES ItemID:self.mItemID];
    return;
}

- (void) updateMarkedStaus: (BOOL)aNewMarkedStatus
{
    [StoreManager updateItemMarkedStatus:aNewMarkedStatus ItemID:self.mItemID];
    return;
}

@end