//
//  ColorFormatter.m
//  TypingTutor
//
//  Created by Can on 2/1/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "ColorFormatter.h"

@interface ColorFormatter ()

- (NSString *)firstColorKeyForPartialString:(NSString *)string;

@end

@implementation ColorFormatter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.colorList = [NSColorList colorListNamed:@"Apple"];
    }
    return self;
}

- (NSString *)firstColorKeyForPartialString:(NSString *)string {
    if ([string length] == 0) {
        return nil;
    }
    
    for (NSString *key in [self.colorList allKeys]) {
        NSRange whereFound = [key rangeOfString:string options:NSCaseInsensitiveSearch];
        if ((whereFound.location == 0) && (whereFound.length > 0)) {
            return key;
        }
    }
    return nil;
}

- (NSString *)stringForObjectValue:(id)obj {
    if (![obj isKindOfClass:[NSColor class]]) {
        return nil;
    }
    
    NSColor *color = [obj colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    
    CGFloat red, green, blue;
    [color getRed:&red green:&green blue:&blue alpha:NULL];
    
    float minDistance = 3.0;
    NSString *closestKey = nil;
    
    for (NSString *key in [self.colorList allKeys]) {
        NSColor *c = [self.colorList colorWithKey:key];
        CGFloat r, g, b;
        [c getRed:&r green:&g blue:&b alpha:NULL];
        
        float dist = powf(red - r, 2) + powf(green - g, 2) + powf(blue - b, 2);
        
        if (dist < minDistance) {
            minDistance = dist;
            closestKey = key;
        }
    }
    return closestKey;
}

- (BOOL)getObjectValue:(out __autoreleasing id *)obj forString:(NSString *)string errorDescription:(out NSString *__autoreleasing *)error {
    NSString *matchingKey = [self firstColorKeyForPartialString:string];
    if (matchingKey) {
        *obj = [self.colorList colorWithKey:matchingKey];
        return YES;
    } else {
        if (error != NULL) {
            *error = [NSString stringWithFormat:@"%@ is not a color", string];
        }
        return NO;
    }
}

//- (BOOL)isPartialStringValid:(NSString *)partialString
//            newEditingString:(NSString *__autoreleasing *)newString
//            errorDescription:(NSString *__autoreleasing *)error {
//    if ([partialString length] == 0) {
//        return YES;
//    }
//    NSString *match = [self firstColorKeyForPartialString:partialString];
//    if (match) {
//        return YES;
//    } else {
//        if (error) {
//            *error = @"No such color";
//        }
//        return NO;
//    }
//}

- (BOOL)isPartialStringValid:(NSString *__autoreleasing *)partialStringPtr
       proposedSelectedRange:(NSRangePointer)proposedSelRangePtr
              originalString:(NSString *)origString
       originalSelectedRange:(NSRange)origSelRange
            errorDescription:(NSString *__autoreleasing *)error {
    if ([*partialStringPtr length] == 0) {
        return YES;
    }
    NSString *match = [self firstColorKeyForPartialString:*partialStringPtr];
    if (!match) {
        return NO;
    }
    
    if (origSelRange.location == proposedSelRangePtr->location) {
        return YES;
    }
    
    if ([match length] != [*partialStringPtr length]) {
        proposedSelRangePtr->location = [*partialStringPtr length];
        proposedSelRangePtr->length = [match length] - proposedSelRangePtr->location;
        *partialStringPtr = match;
        return NO;
    }
    return YES;
}

- (NSAttributedString *)attributedStringForObjectValue:(id)obj withDefaultAttributes:(NSDictionary *)attrs {
    NSString *match = [self stringForObjectValue:obj];
    if (!match) {
        return nil;
    }
    NSMutableDictionary *newAttrs = [attrs mutableCopy];
    [newAttrs setObject:obj forKey:NSForegroundColorAttributeName];
    NSAttributedString *aString = [[NSAttributedString alloc] initWithString:match attributes:newAttrs];
    return aString;
}

@end
