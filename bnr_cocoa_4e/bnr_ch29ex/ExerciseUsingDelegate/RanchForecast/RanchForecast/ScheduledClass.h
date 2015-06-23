//
//  ScheduledClass.h
//  Forecast
//
//  Created by Can on 2/2/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduledClass : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *href;
@property (nonatomic, copy) NSDate *begin;

@end
