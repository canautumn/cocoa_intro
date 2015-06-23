//
//  ScheduleFetcher.h
//  Forecast
//
//  Created by Can on 2/2/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ScheduleFetcherDelegate;

@interface ScheduleFetcher : NSObject <NSXMLParserDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, weak) id<ScheduleFetcherDelegate> delegate;

- (void)fetchClasses;

@end


@protocol ScheduleFetcherDelegate <NSObject>
@optional // opional requires check respondsToSelector before calling
- (void)scheduledFetcher:(ScheduleFetcher *)fetcher didFinishLoadingClasses:(NSArray *)classes;
- (void)scheduledFetcher:(ScheduleFetcher *)fetcher didFailWithError:(NSError *)error;
@end
