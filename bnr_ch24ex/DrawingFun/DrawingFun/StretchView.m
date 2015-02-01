//
//  StretchView.m
//  DrawingFun
//
//  Created by Can on 1/24/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "StretchView.h"

@interface StretchView ()

@property (strong) NSBezierPath *path;
@property (assign) NSPoint downPoint;
@property (assign) NSPoint currentPoint;

@property (strong) NSTimer *scrollingTimer;

@end

@implementation StretchView


@synthesize image = _image;
@synthesize opacity = _opacity;

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSLog(@"drawRect gets called");
    NSRect bounds = [self bounds];
    [[NSColor greenColor] set];
    [NSBezierPath fillRect:bounds];
    
    [[NSColor whiteColor] set];
    [self.path stroke];
    if (self.image) {
        NSRect imageRect;
        imageRect.origin = NSZeroPoint;
        imageRect.size = self.image.size;
        NSRect drawingRect = self.currentRect; // dot notation is a syntactic sugar, so also works for this method in this case.
        [self.image drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:self.opacity];
    }
}

- (void)awakeFromNib {
    NSLog(@"awakeFromNib gets called");
    srandom((unsigned)time(NULL));
    self.path = [NSBezierPath bezierPath];
    [self.path setLineWidth:3.0];
    [self.path moveToPoint:[self randomPoint]];
    for (int i = 0; i < 15; ++i) {
        [self.path curveToPoint:[self randomPoint] controlPoint1:[self randomPoint] controlPoint2:[self randomPoint]];
    }
    [self.path closePath];
    self.opacity = 1.0;
}

#pragma mark Drawing Helpers

- (NSPoint)randomPoint {
    NSPoint result;
    NSRect r = [self bounds];
    result.x = r.origin.x + random() % (int)r.size.width;
    result.y = r.origin.y + random() % (int)r.size.height;
    return result;
}

- (NSRect)currentRect {
    float minX = MIN(self.downPoint.x, self.currentPoint.x);
    float maxX = MAX(self.downPoint.x, self.currentPoint.x);
    float minY = MIN(self.downPoint.y, self.currentPoint.y);
    float maxY = MAX(self.downPoint.y, self.currentPoint.y);
    return NSMakeRect(minX, minY, maxX - minX, maxY - minY);
}

#pragma mark Accessors

- (NSImage *)image {
    return _image;
}

- (void)setImage:(NSImage *)image {
    _image = image;
    NSSize imageSize = [image size];
    self.downPoint = NSZeroPoint;
    self.currentPoint = NSMakePoint(self.downPoint.x + imageSize.width, self.downPoint.y + imageSize.height);
    // WRONG:
//    self.currentPoint.x = self.downPoint.x + imageSize.width;
//    self.currentPoint.y = self.downPoint.y + imageSize.height;
    self.needsDisplay = YES;
}

- (float)opacity {
    return _opacity;
}

- (void)setOpacity:(float)opacity {
    _opacity = opacity;
    self.needsDisplay = YES;
}

#pragma mark Mouse Events

- (void)mouseDown:(NSEvent *)theEvent {
    
    // Another way to add a timer:
//    
//    self.scrollingTimer = [NSTimer timerWithTimeInterval:0.1
//                                                  target:self
//                                                selector:@selector(handleScrollingTimer:)
//                                                userInfo:nil
//                                                 repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:self.scrollingTimer forMode:NSRunLoopCommonModes];
//
    
    
    self.scrollingTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                           target:self
                                                         selector:@selector(handleScrollingTimer:)
                                                         userInfo:nil
                                                          repeats:YES];

    NSLog(@"%@", self.scrollingTimer);
    self.downPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    self.currentPoint = self.downPoint;
    self.needsDisplay = YES;
}

- (void)mouseDragged:(NSEvent *)theEvent {
    self.currentPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
//    [self autoscroll:theEvent];
    self.needsDisplay = YES;
}

- (void)mouseUp:(NSEvent *)theEvent {
    NSLog(@"terminate %@", self.scrollingTimer);

    [self.scrollingTimer invalidate];
    self.scrollingTimer = nil;
    
    self.currentPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    self.needsDisplay = YES;
}

- (void)handleScrollingTimer:(NSTimer *)aTimer {
    NSLog(@"Timer");
    NSEvent *event = [NSApp currentEvent];
    [self autoscroll:event];
}

@end
