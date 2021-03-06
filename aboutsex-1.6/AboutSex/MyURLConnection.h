//
//  MyURLConnection.h
//  AboutSex
//
//  Created by Shane Wen on 12-9-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyURLConnectionDelegate.h"
#import "JSONWrapper.h"

@interface MyURLConnection : NSObject<NSURLConnectionDataDelegate>
{
    id<MyURLConnectionDelegate> mDelegate;
    NSMutableData* mWebData;
    NSMutableURLRequest* mRequest;
    NSURLConnection* mURLConnection;
}

@property (nonatomic, assign) id<MyURLConnectionDelegate> mDelegate;
@property (nonatomic, retain)  NSMutableData* mWebData;
@property (nonatomic, retain)  NSMutableURLRequest* mRequest;
@property (nonatomic, retain)  NSURLConnection* mURLConnection;

- (id) initWithDelegate: (NSMutableURLRequest*)aRequest withDelegate:(id<MyURLConnectionDelegate>) aDelegate;
- (BOOL) start;
- (void) stop;
@end
