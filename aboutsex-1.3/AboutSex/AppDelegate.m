//
//  AppDelegate.m
//  AboutSex
//
//  Created by Shane Wen on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "SharedStates.h"

#import "StoreManager.h"

#import "MobClick.h"
#import "SharedVariables.h"

#import "time.h"
#import "SDURLCache.h"

@interface AppDelegate ()

- (void) checkUpdateAutomatically;

@end


@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[SharedStates getInstance] getMainTabController];

    [StoreManager openIfNecessary];
    
    [self.window makeKeyAndVisible];
    
    //UMeng SDK invocation
    [MobClick startWithAppkey:APP_KEY_UMENG reportPolicy:BATCH channelId:CHANNEL_ID];
    
    [self checkUpdateAutomatically];
    
    //init SharedStates.
    [SharedStates getInstance];
    
    
    //for now, we do not need to cache to disk.
//    SDURLCache *urlCache = [[SDURLCache alloc] initWithMemoryCapacity:1024*1024   // 1MB mem cache
//                                                         diskCapacity:1024*1024*5 // 5MB disk cache
//                                                             diskPath:[SDURLCache defaultCachePath]];
//    [NSURLCache setSharedURLCache:urlCache];
//    [urlCache release];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [StoreManager close];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) checkUpdateAutomatically
{
    [MobClick checkUpdate:NSLocalizedString(@"New Version Found", nil) cancelButtonTitle:NSLocalizedString(@"Skip", nil) otherButtonTitles:NSLocalizedString(@"Update now", nil)];
}

@end
