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

- (void)setNilValueForKey:(NSString *)key {
    if ([key isEqual:@"expectedRaise"]) {
        [self setExpectedRaise:0.0];
    } else {
        [super setNilValueForKey:key];
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_personName forKey:@"personName"];
    [aCoder encodeFloat:_expectedRaise forKey:@"expectedRaise"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _personName = [aDecoder decodeObjectForKey:@"personName"];
        _expectedRaise = [aDecoder decodeFloatForKey:@"expectedRaise"];
    }
    return self;
}

@end
