//
//  CarArrayController.m
//  CarLot
//
//  Created by Can on 1/18/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "CarArrayController.h"

@implementation CarArrayController

- (id)newObject {
    id newObj = [super newObject];
    NSDate *now = [NSDate date];
    [newObj setValue:now forKey:@"datePurchased"];
    return newObj;
}

@end
