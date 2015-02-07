//
//  AppDelegate.h
//  RanchForecast
//
//  Created by Can on 2/2/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ScheduleFetcher.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource, ScheduleFetcherDelegate>

@end

