//
//  ScheduleFetcher.h
//  Forecast
//
//  Created by Can on 2/2/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ScheduleFetcherResultBlock)(NSArray *classes, NSError *error);

@interface ScheduleFetcher : NSObject <NSXMLParserDelegate, NSURLConnectionDataDelegate>

- (void)fetchClassesWithBlock:(ScheduleFetcherResultBlock)theBlock;

@end
