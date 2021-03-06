//
//  FMStoreController.h
//  AboutSex
//
//  Created by Wen Shane on 13-4-27.
//
//

#import <UIKit/UIKit.h>
#import "DownloadManager.h"


@protocol FMListControllerDelegate <NSObject>

@optional
- (void) notifyUpdateDate:(NSDate*)aDate;

@end


typedef enum _ENUM_FM_LIST_TYPE{
    ENUM_FM_LIST_TYPE_ALL = 0,
    ENUM_FM_LIST_TYPE_AFFECTION = 1,
    ENUM_FM_LIST_TYPE_SEX = 2,
    ENUM_FM_LIST_TYPE_HEALTH = 3,
    ENUM_FM_LIST_TYPE_MUSIC = 4,
    
}ENUM_FM_LIST_TYPE;


@interface FMListController : UITableViewController<DownloadManagerDelegate>
{
    id<FMListControllerDelegate> mDelegate;
}
@property (nonatomic, assign)   id<FMListControllerDelegate> mDelegate;

- (id) initWithType:(ENUM_FM_LIST_TYPE)aType;

@end
