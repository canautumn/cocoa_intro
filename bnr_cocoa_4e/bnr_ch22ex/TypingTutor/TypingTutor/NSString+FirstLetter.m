//
//  NSString+FirstLetter.m
//  TypingTutor
//
//  Created by Can on 1/29/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "NSString+FirstLetter.h"

@implementation NSString (FirstLetter)

- (NSString *)can_firstLetter {
    if ([self length] < 2) {
        return self;
    }
    NSRange r;
    r.location = 0;
    r.length = 1;
    return [self substringWithRange:r];
}

@end
