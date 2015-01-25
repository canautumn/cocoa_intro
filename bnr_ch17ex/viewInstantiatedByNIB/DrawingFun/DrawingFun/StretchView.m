//
//  StretchView.m
//  DrawingFun
//
//  Created by Can on 1/24/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "StretchView.h"

@implementation StretchView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSLog(@"drawRect gets called");
    NSRect bounds = [self bounds];
    [[NSColor greenColor] set];
    [NSBezierPath fillRect:bounds];
    
    [[NSColor whiteColor] set];
    [_path stroke];
}

- (id)initWithFrame:(NSRect)frameRect {
    NSLog(@"Will not get called");
    self = [super initWithFrame:frameRect];
    return self;
}

//- (id)initWithCoder:(NSCoder *)coder {
//    NSLog(@"initWithCoder gets called");
//    self = [super initWithCoder:coder];
//    if (self) {
//        srandom((unsigned)time(NULL));
//        _path = [NSBezierPath bezierPath];
//        [_path setLineWidth:3.0];
//        NSPoint p = [self randomPoint];
//        [_path moveToPoint:p];
//        for (int i = 0; i < 15; ++i) {
//            p = [self randomPoint];
//            [_path lineToPoint:p];
//            NSLog(@"%f, %f", p.x, p.y);
//        }
//        [_path closePath];
//
//    }
//    return self;
//}

- (void)awakeFromNib {
    NSLog(@"awakeFromNib gets called");
    srandom((unsigned)time(NULL));
    _path = [NSBezierPath bezierPath];
    [_path setLineWidth:3.0];
    [_path moveToPoint:[self randomPoint]];
    for (int i = 0; i < 15; ++i) {
        [_path curveToPoint:[self randomPoint] controlPoint1:[self randomPoint] controlPoint2:[self randomPoint]];
    }
    [_path closePath];
}

- (NSPoint)randomPoint {
    NSPoint result;
    NSRect r = [self bounds];
    result.x = r.origin.x + random() % (int)r.size.width;
    result.y = r.origin.y + random() % (int)r.size.height;
    return result;
}

@end
