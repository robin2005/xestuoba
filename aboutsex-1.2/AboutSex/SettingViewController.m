//
//  SettingViewController.m
//  AboutSex
//
//  Created by Wen Shane on 12-11-28.
//
//

#import "SettingViewController.h"
#import "UMFeedback.h"
#import "SharedVariables.h"
#import "SharedStates.h"

#import "MobClick.h"
#import "SVProgressHUD.h"

#import "TapkuLibrary.h"

#import "UserConfiger.h"

#import "FontSizeSettingController.h"
#import "CustomCellBackgroundView.h"

#define MAX_TIME_OF_UPDATE_CHECK    7
#define TIME_OF_CHECK_RESULTS_BEFORE_DISAPPEAR  1.7
#define AboutViewController_TAG_FOR_LEFT_VERSION_TITLE_LABEL 1110
#define AboutViewController_TAG_FOR_RIGHT_VERSION_NUMBER_LABEL 1111

#define HEADER_HEIGHT_VIEW   105

#define DEFUALT_RECOMMAND_APP_NAME  @"减肥记记"
#define DEFAULT_RECOMMAND_APP_URL   @"https://itunes.apple.com/cn/app/jian-fei-ji-ji/id583710058"

@interface SettingViewController ()
{
    
    UITableView* mTableView;

    BOOL mIsCheckingUpdate;
    NSTimer* mUpdateCheckOuttimeTimer;
    NSString* mPathForUpdate;
    
    
    NSString* mRecommandedAppName;
    NSString* mRecommandedAppUrl;
    MyURLConnection* mURLConnection;
    
}
@property (nonatomic, retain) UITableView* mTableView;

@property (nonatomic, assign) BOOL mIsCheckingUpdate;
@property (nonatomic, retain) NSTimer* mUpdateCheckOuttimeTimer;
@property (nonatomic, retain)     NSString* mPathForUpdate;

@property (nonatomic, retain) NSString* mRecommandedAppName;
@property (nonatomic, retain) NSString* mRecommandedAppUrl;

@property (nonatomic, retain) MyURLConnection* mURLConnection;

- (void)updateCheckCallBack:(NSDictionary *)appInfo;
- (void) showNewUpdateInfoOnMainThread:(id) aAppInfo;


@end


@implementation SettingViewController

@synthesize mTableView;
@synthesize mIsCheckingUpdate;
@synthesize mUpdateCheckOuttimeTimer;
@synthesize mPathForUpdate;

@synthesize mRecommandedAppName;
@synthesize mRecommandedAppUrl;
@synthesize mURLConnection;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
            [self setRecommandedAppInfo];
        }
        
    }
    return self;
}

- (void) setRecommandedAppInfo;
{
    //firstly initialize recommanded app info as default values.
    self.mRecommandedAppName = DEFUALT_RECOMMAND_APP_NAME;
    self.mRecommandedAppUrl = DEFAULT_RECOMMAND_APP_URL;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSMutableURLRequest* sURLRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:GET_RECOMMANDED_APP_INFO]];
    
    [sURLRequest setHTTPMethod:@"POST"];
    
    [sURLRequest setValue:[NSString stringWithFormat:@"%d", 0] forHTTPHeaderField:@"Content-length"];
    [sURLRequest setHTTPBody:nil];
    
    MyURLConnection* sURLConnection = [[MyURLConnection alloc]initWithDelegate:sURLRequest withDelegate:self];
    self.mURLConnection = sURLConnection;
    [sURLRequest release];
    [sURLConnection release];
    
    if (![self.mURLConnection start])
    {
#ifdef DEBUG
        NSLog(@"conncetin creation error.");
#endif
    }
    
    return;
}


- (void) loadView
{
//    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
//    
//    UIView* sView = [[UIView alloc] initWithFrame:applicationFrame];
//    self.view = sView;
//    [sView release];
    
    [super loadView];
    

    
    CGFloat sPosX = 0;
    CGFloat sPosY = 5;
    
    //tableview
    UITableView* sTableView = [[UITableView alloc]initWithFrame:CGRectMake(sPosX, sPosY, self.mMainView.bounds.size.width, self.mMainView.bounds.size.height-sPosY) style:UITableViewStyleGrouped];
    sTableView.dataSource = self;
    sTableView.delegate = self;
    [sTableView setBackgroundView:nil];
    [sTableView setBackgroundColor:[UIColor clearColor]];
//    sTableView.scrollEnabled = FALSE;
    
    [self.mMainView addSubview:sTableView];
    
    self.mTableView = sTableView;
    [sTableView release];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.mTableView reloadData];
    
}

- (void) dealloc
{
    self.mTableView = nil;
    [self.mUpdateCheckOuttimeTimer invalidate];
    self.mUpdateCheckOuttimeTimer = nil;
    self.mRecommandedAppName = nil;
    self.mRecommandedAppUrl = nil;
    self.mURLConnection = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark methods for datasource interface

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 2;
        case 1:
            return 3;
        default:
            return 0;
    }
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    switch (section)
//    {
//        case 0:
//            return @"阅读设定";
//        case 1:
//            return nil;
//        default:
//            return nil;
//    }
//
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sSection = [indexPath section];
    NSInteger sRow = [indexPath row];
    
    UITableViewCell* sCell = nil;
    
    if (0 == sSection
        && 1 == sRow)
    {
        sCell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
        if (!sCell)
        {
            sCell = [[[TKSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SwitchCell"] autorelease];
            sCell.backgroundColor = [UIColor clearColor];

            CustomCellBackgroundView* sBGView = [CustomCellBackgroundView backgroundCellViewWithFrame:sCell.frame Row:[indexPath row] totalRow:[tableView numberOfRowsInSection:[indexPath section]] borderColor:SELECTED_CELL_COLOR fillColor:SELECTED_CELL_COLOR tableViewStyle:tableView.style];
            sCell.selectedBackgroundView = sBGView;

            
            sCell.textLabel.text = NSLocalizedString(@"nightmode", nil);
            [sCell.imageView setImage:[UIImage imageNamed:@"nightmode_inactive24.png"]];
            if ([((TKSwitchCell*)sCell).switcher respondsToSelector:@selector(onTintColor)])
            {
                ((TKSwitchCell*)sCell).switcher.onTintColor = MAIN_BGCOLOR;     
            }
            [((TKSwitchCell*)sCell).switcher addTarget:self action:@selector(nightModeChanged:) forControlEvents:UIControlEventValueChanged];
            sCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if ([UserConfiger isNightModeOn])
        {
            ((TKSwitchCell*)sCell).switcher.on = YES;
        }
        else
        {
            ((TKSwitchCell*)sCell).switcher.on = NO;
        }

    }
    else
    {
        sCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!sCell)
        {
            sCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"] autorelease];
            CustomCellBackgroundView* sBGView = [CustomCellBackgroundView backgroundCellViewWithFrame:sCell.frame Row:[indexPath row] totalRow:[tableView numberOfRowsInSection:[indexPath section]] borderColor:SELECTED_CELL_COLOR fillColor:SELECTED_CELL_COLOR tableViewStyle:tableView.style];
            sCell.selectedBackgroundView = sBGView;
            sCell.backgroundColor = [UIColor clearColor];

        }
        if (0 == sSection
            && 0 == sRow)
        {
            sCell.textLabel.text =  NSLocalizedString(@"contentsfontsize", nil);
            [sCell.imageView setImage:[UIImage imageNamed:@"font24.png"]];
            sCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            NSString* sFontSizeStr = nil;
            switch ([UserConfiger getFontSizeType]) {
                case ENUM_FONT_SIZE_SMALL:
                    sFontSizeStr = NSLocalizedString(@"small", nil);
                    break;
                case ENUM_FONT_SIZE_NORMAL:
                    sFontSizeStr = NSLocalizedString(@"medium", nil);
                    break;
                case ENUM_FONT_SIZE_LARGE:
                    sFontSizeStr = NSLocalizedString(@"large", nil);
                    break;
                default:
                    break;
            }
            sCell.detailTextLabel.text = sFontSizeStr;
        }
        else if (1 == sSection)
        {
            if (0 == sRow)
            {
                sCell.textLabel.text = NSLocalizedString(@"Check for update", nil);
                sCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [sCell.imageView setImage:[UIImage imageNamed:@"search24.png"]];
            }
            else if (1 == sRow)
            {
                sCell.textLabel.text = NSLocalizedString(@"Feedback", nil);
                [sCell.imageView setImage:[UIImage imageNamed:@"chat24.png"]];
                sCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else if (2 == sRow)
            {
                sCell.textLabel.text = NSLocalizedString(@"Recomman Apps", nil);
                sCell.detailTextLabel.text = self.mRecommandedAppName;
                [sCell.imageView setImage:[UIImage imageNamed:@"app24.png"]];
                sCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            }
            else
            {
                //nothing
            }
        }
        else
        {
            //nothing done here.
        }

    }
    
    return sCell;
}

- (void) nightModeChanged:(id)aSwitch
{
    UISwitch* sNightModeSwitch = (UISwitch*)aSwitch;
    if (sNightModeSwitch.on)
    {
        [[SharedStates getInstance] dimBGColorViews];
    }
    else
    {
        [[SharedStates getInstance] restoreBGColorViews];

    }
    [UserConfiger setNightMode:sNightModeSwitch.on];
}


#pragma mark -
#pragma mark methods for delegate interface

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section)
    {
        return HEADER_HEIGHT_VIEW;
    }
    else
    {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0  == section)
    {
        CGFloat sPosX = 0;
        CGFloat sPosY = 0;

        UIView* sHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, HEADER_HEIGHT_VIEW, tableView.bounds.size.width)] autorelease];

        //0. icon
        UIImage* sImage = [UIImage imageNamed:@"Icon-72_Rounded.png"];
        UIImageView* sImageView = [[UIImageView alloc]initWithImage:sImage];
        [sImageView setFrame:CGRectMake(sPosX, sPosY, 72, 72)];
        sImageView.center = CGPointMake(self.mMainView.center.x, sImageView.center.y);
        [sHeaderView addSubview:sImageView];
        
        [sImageView release];
        
        sPosX =43;
        sPosY = sImageView.frame.origin.y+sImageView.frame.size.height+5;
        //1. intro
        UILabel* sIntroLabel = [[UILabel alloc] initWithFrame:CGRectMake(sPosX, sPosY, 270, 400)];
        sIntroLabel.numberOfLines = 0;
        NSString* sBundleDisplayName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        NSString* sVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleVersion"];
        sIntroLabel.text = [NSString stringWithFormat:@"%@ %@", sBundleDisplayName, sVersion];
        sIntroLabel.textAlignment = UITextAlignmentCenter;
        sIntroLabel.font = [UIFont systemFontOfSize:17];
        sIntroLabel.backgroundColor = [UIColor clearColor];
        [sIntroLabel sizeToFit];
        sIntroLabel.center = CGPointMake(self.mMainView.center.x, sIntroLabel.center.y);

        [sHeaderView addSubview:sIntroLabel];
        [sIntroLabel release];
        return sHeaderView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sSection = [indexPath section];
    NSInteger sRow = [indexPath row];
    
    if (sSection == 0)
    {
        if (0 == sRow)
        {
            [self presentFontSizeSettingViewController];
        }
        else if (1 == sRow)
        {
            return;      
        }
        else
        {
            //nothing
        }
    }
    else if (sSection == 1)
    {
        if (sRow == 0)
        {
            if (!self.mIsCheckingUpdate)
            {
                self.mIsCheckingUpdate = YES;
                [SVProgressHUD showWithStatus:NSLocalizedString(@"Checking", nil) maskType:SVProgressHUDMaskTypeClear];
                [SVProgressHUD setBackgroudColorForHudView:COLOR_ACTIVITY_INDICATOR];
                [MobClick checkUpdateWithDelegate:self selector:@selector(updateCheckCallBack:)];
                
                
                //set outtime timer
                if(self.mUpdateCheckOuttimeTimer
                   && [self.mUpdateCheckOuttimeTimer isValid])
                {
                    [self.mUpdateCheckOuttimeTimer invalidate];
                }
                
                NSTimer* sTimer = [[NSTimer alloc]initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:MAX_TIME_OF_UPDATE_CHECK]  interval:1 target:self selector:@selector(updateCheckOuttimerHandler) userInfo:nil repeats:NO];
                self.mUpdateCheckOuttimeTimer  = sTimer;
                [sTimer release];
                [[NSRunLoop currentRunLoop] addTimer:self.mUpdateCheckOuttimeTimer forMode:NSDefaultRunLoopMode];
                
            }
        }
        else if (sRow == 1)
        {
            UIViewController* sViewController = [[UIViewController alloc]init];
            [UMFeedback showFeedback:self withAppkey:APP_KEY_UMENG];
            [sViewController release];
        }
        else if (sRow == 2)
        {
            [self presentRecommandedApp];
        }
        else
        {
            //nothing done.
        }
    }
    else
    {
        //nothing done.
    }
    
    return;
}

- (void) presentFontSizeSettingViewController
{
    
    FontSizeSettingController* sFontSizeSettingViewController = [[FontSizeSettingController alloc] init];
    sFontSizeSettingViewController.hidesBottomBarWhenPushed = YES;
    sFontSizeSettingViewController.title = NSLocalizedString(@"set font size", nil);
    
    [self.navigationController pushViewController:sFontSizeSettingViewController animated:YES];
    
    
    [sFontSizeSettingViewController release];

}

- (void)updateCheckCallBack:(NSDictionary *)appInfo
{
    //    NSEnumerator* sEnum = [appInfo keyEnumerator];
    //
    //    id sKey;
    //    while (sKey = [sEnum nextObject]) {
    //        NSLog(@"%@-%@:\t %@", [sKey class], sKey, [appInfo objectForKey:sKey]);
    //    }
    
    if (self.mIsCheckingUpdate)
    {
        if (self.mUpdateCheckOuttimeTimer
            && [self.mUpdateCheckOuttimeTimer isValid])
        {
            [self.mUpdateCheckOuttimeTimer invalidate];
        }
        
        BOOL sNeedUpdate = ((NSNumber*)[appInfo objectForKey:@"update"]).boolValue;
        CGFloat sCurVersion = [(NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleVersion"] doubleValue];
        CGFloat sNewVersion = [((NSString*)[appInfo objectForKey:@"version"]) doubleValue];
        if (sNeedUpdate
            && sNewVersion>sCurVersion)
        {
            //note that the display of alertview must take place on main thread, otherwise it loads very slowly.
            [self performSelectorOnMainThread:@selector(showNewUpdateInfoOnMainThread:) withObject:appInfo waitUntilDone:NO];
            [SVProgressHUD dismiss];
        }
        else
        {
            [SVProgressHUD dismissWithSuccess:NSLocalizedString(@"No updates found", nil) afterDelay: TIME_OF_CHECK_RESULTS_BEFORE_DISAPPEAR];
        }
        self.mIsCheckingUpdate = NO;
    }
    
    return;
}

- (void) showNewUpdateInfoOnMainThread:(id) aAppInfo
{
    
    NSDictionary* sAppInfo = (NSDictionary*)aAppInfo;
    
    
    NSString* sVersionStr = (NSString*)[sAppInfo objectForKey:@"version"];
    NSString* sUpdateLogStr = (NSString*)[sAppInfo objectForKey:@"update_log"];
    self.mPathForUpdate = (NSString*) [sAppInfo objectForKey:@"path"];
    
    
    NSString* sAlertViewTitle = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"New Version Found", nil), sVersionStr];
    UIAlertView* sAlertView = [[UIAlertView alloc] initWithTitle:sAlertViewTitle message:sUpdateLogStr  delegate:self cancelButtonTitle:NSLocalizedString(@"Ignore", nil) otherButtonTitles:NSLocalizedString(@"Update now", nil), nil];
    [sAlertView show];
    [sAlertView release];
    
}

- (void) updateCheckOuttimerHandler
{
    if (self.mIsCheckingUpdate)
    {
        self.mIsCheckingUpdate = NO;
        [SVProgressHUD dismissWithError:NSLocalizedString(@"Update checking error", nil) afterDelay: TIME_OF_CHECK_RESULTS_BEFORE_DISAPPEAR];
    }
}

- (void) presentRecommandedApp
{
    [MobClick event:@"UEID_RECOMMAND_APP_HIT"];
    
    NSString* sUrlOfFatcampOnStore = nil;
    sUrlOfFatcampOnStore = self.mRecommandedAppUrl;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: sUrlOfFatcampOnStore]];
}

#pragma mark -
#pragma mark delegate for update checking's alertview
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex)
    {
        if (self.mPathForUpdate)
        {
            NSURL *sURL = [NSURL URLWithString:self.mPathForUpdate];
            [[UIApplication sharedApplication] openURL:sURL];
        }
    }
}

- (void)appUpdate:(NSDictionary *)appInfo {
    NSLog(@"自定义更新 %@",appInfo);
}

#pragma mark -
#pragma mark delegate methods for MyURLConnectionDelegate

- (void) failWithConnectionError: (NSError*)aErr
{
}

- (void) failWithServerError: (NSInteger)aStatusCode
{
}

- (void) succeed: (NSMutableData*)aData
{
    NSError* sErr = nil;
    
    id sJSONObject =  [JSONWrapper JSONObjectWithData: aData
                                              options:NSJSONReadingMutableContainers
                                                error:&sErr];
    
    NSString* sRecommandedAppName = nil;
    NSString* sRecommandedAppUrl = nil;
    if ([sJSONObject isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *sDict = (NSDictionary *)sJSONObject;
        sRecommandedAppName = (NSString*)[sDict objectForKey:@"recommanded_app_name"];
        sRecommandedAppUrl = (NSString*)[sDict objectForKey:@"recommanded_app_url"];
    }
    
    if (sRecommandedAppName
        && sRecommandedAppUrl)
    {
        self.mRecommandedAppName = sRecommandedAppName;
        self.mRecommandedAppUrl = sRecommandedAppUrl;
    }

    return;
}



@end
