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
    
    NSRect bounds = [self bounds];
    [[NSColor greenColor] set];
    [NSBezierPath fillRect:bounds];
    
    [[NSColor whiteColor] set];
    [_path fill];
}

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        srandom((unsigned)time(NULL));
        _path = [NSBezierPath bezierPath];
        [_path setLineWidth:3.0];
        NSPoint p = [self randomPoint];
        [_path moveToPoint:p];
        for (int i = 0; i < 15; ++i) {
            p = [self randomPoint];
            [_path lineToPoint:p];
            NSLog(@"%f, %f", p.x, p.y);
        }
        [_path closePath];
    }
    return self;
}

- (void)awakeFromNib {
    NSLog(@"Will not Get called");
    srandom((unsigned)time(NULL));
    _path = [NSBezierPath bezierPath];
    [_path setLineWidth:3.0];
    NSPoint p = [self randomPoint];
    [_path moveToPoint:p];
    for (int i = 0; i < 15; ++i) {
        p = [self randomPoint];
        [_path lineToPoint:p];
        NSLog(@"%f, %f", p.x, p.y);
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
