//
//  DrawingView.m
//  OvalDrawer
//
//  Created by Can on 1/25/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "DrawingView.h"
#import "Document.h"
#import "OvalArrayController.h"

//static void *KVOContext;

@interface DrawingView ()

@property (assign) NSPoint downPoint;
@property (assign) NSPoint currentPoint;

@end

@implementation DrawingView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [[NSColor whiteColor] setFill];
    NSRectFill(dirtyRect);
    
    Document * doc = [[NSDocumentController sharedDocumentController] currentDocument];
//    NSLog(@"%@", [doc.arrayController arrangedObjects]);
    id values = [doc.arrayController arrangedObjects];
//    NSLog(@"There are %lu ovals.", [values count]);
    for (NSDictionary * value in values) {
        [[NSBezierPath bezierPathWithOvalInRect:[[value valueForKey:@"bounds"] rectValue]] stroke];
    }
    
    
    [[NSBezierPath bezierPathWithOvalInRect:self.currentRect] stroke];
    
    
}

//- (id)initWithCoder:(NSCoder *)coder {
//    self = [super initWithCoder:coder];
//    [self setNeedsDisplay:YES];
//    return self;
//    
//}


//- (void)awakeFromNib {
//    Document * doc = [[NSDocumentController sharedDocumentController] currentDocument];
//    [doc.arrayController addObserver:self forKeyPath:@"arrangedObjects" options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:&KVOContext];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateView:) name:NSManagedObjectContextObjectsDidChangeNotification object:doc.managedObjectContext];
    
//    [[doc.arrayController managedObjectContext] addObserver:self forKeyPath:@"Oval" options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    
//    [self setNeedsDisplay:YES];
//}

//- (void)dealloc {
//    Document * doc = [[NSDocumentController sharedDocumentController] currentDocument];
//    [doc.arrayController removeObserver:self forKeyPath:@"arrangedObjects" context:nil];
//}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    NSLog(@"aa");
//}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    NSLog(@"test");
//}

#pragma mark Mouse Events

- (void)mouseDown:(NSEvent *)theEvent {
    self.downPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    self.currentPoint = self.downPoint;
    self.needsDisplay = YES;
    [super mouseDown:theEvent];
}

- (void)mouseDragged:(NSEvent *)theEvent {
    self.currentPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    [self autoscroll:theEvent];
    self.needsDisplay = YES;
}

- (void)mouseUp:(NSEvent *)theEvent {
    self.currentPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    [[[NSDocumentController sharedDocumentController] currentDocument] addOval:self.currentRect];
    
    self.needsDisplay = YES;
}


#pragma mark Drawing Helpers

- (NSRect)currentRect {
    float minX = MIN(self.downPoint.x, self.currentPoint.x);
    float maxX = MAX(self.downPoint.x, self.currentPoint.x);
    float minY = MIN(self.downPoint.y, self.currentPoint.y);
    float maxY = MAX(self.downPoint.y, self.currentPoint.y);
    return NSMakeRect(minX, minY, maxX - minX, maxY - minY);
}

//#pragma mark Notifications

//- (void)updateView:(NSNotificationCenter *)notificaion {
//    NSLog(@"%@", self);
////    self.needsDisplay = YES;
////    [self drawRect:[self frame]];
//}

@end
