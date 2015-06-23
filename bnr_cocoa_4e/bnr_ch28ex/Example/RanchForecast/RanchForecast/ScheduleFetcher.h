//
//  ScheduleFetcher.h
//  Forecast
//
//  Created by Can on 2/2/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduleFetcher : NSObject <NSXMLParserDelegate>

@property (strong) NSMutableArray *classes;
@property (strong) NSMutableString *currentString;
@property (strong) NSMutableDictionary *currentFields;
@property (strong) NSDateFormatter *dateFormatter;

- (NSArray *)fetchClassesWithError:(NSError **)outError;

@end
