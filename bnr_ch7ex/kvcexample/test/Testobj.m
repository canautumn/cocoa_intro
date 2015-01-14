//
//  Testobj.m
//  test
//
//  Created by Can on 1/13/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "Testobj.h"

@implementation Testobj

- (void)setFidor:(int)x {
    NSLog(@"disabled");
}


- (id)init {
    self = [super init];
    if (self) {
        [self setValue:[NSNumber numberWithInt:5] forKey:@"fidor"];
        NSNumber *n = [self valueForKey:@"fidor"];
        NSLog(@"fido = %@", n);
        NSLog(@"fido = %lu", fidor);
        fidor = 5;
        
    }
    return self;
}
@end
