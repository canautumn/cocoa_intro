//
//  Person.m
//  RaiseMan
//
//  Created by Can on 1/13/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "Person.h"

@implementation Person

- (id)init {
    self = [super init];
    if (self) {
        self.expectedRaise = 0.05;
        self.personName = @"New Person";
    }
    return self;
}

@end
