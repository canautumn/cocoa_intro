//
//  OvalArrayController.m
//  OvalDrawer
//
//  Created by Can on 1/25/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "OvalArrayController.h"

@implementation OvalArrayController

- (id)newObjectWithRect:(NSRect)rect {
    id newObj = [super newObject];
    [self willChangeValueForKey:@"arrangedObjects"];
    [newObj setValue:[NSValue valueWithRect:rect] forKey:@"bounds"];
    [self didChangeValueForKey:@"arrangedObjects"];
    return newObj;
}

@end
