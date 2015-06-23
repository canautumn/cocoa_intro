//
//  BigLetterView.m
//  TypingTutor
//
//  Created by Can on 1/26/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "BigLetterView.h"

@implementation BigLetterView

@synthesize bgColor = _bgColor;
@synthesize string = _string;
@synthesize isHighlighted = _isHighlighted;

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSRect bounds = [self bounds];
    if (self.isHighlighted) {
        self.bgColor = [NSColor blueColor];
    } else {
        self.bgColor = [NSColor yellowColor];
    }
    [self.bgColor set];
    [NSBezierPath fillRect:bounds];
    
//    if ([[self window] firstResponder] == self) {
//        [[NSColor keyboardFocusIndicatorColor] set];
//        [NSBezierPath setDefaultLineWidth:4.0];
//        [NSBezierPath strokeRect:bounds];
//    }
    if ([[self window] firstResponder] == self && [NSGraphicsContext currentContextDrawingToScreen]) {
        [NSGraphicsContext saveGraphicsState];
        NSSetFocusRingStyle(NSFocusRingOnly);
        [NSBezierPath fillRect:bounds];
        [NSGraphicsContext restoreGraphicsState];
    }
}

- (BOOL)isOpaque {
    return YES;
}

- (void)awakeFromNib {
    self.bgColor = [NSColor yellowColor];
    self.string = @" ";
    self.isHighlighted = NO;
}

#pragma mark Mouse Tracking Methods

- (void)viewDidMoveToWindow {
    [self addTrackingArea:[[NSTrackingArea alloc] initWithRect:NSZeroRect
                                                       options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect)
                                                         owner:self
                                                      userInfo:nil]];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    self.isHighlighted = YES;
}

- (void)mouseExited:(NSEvent *)theEvent {
    self.isHighlighted = NO;
}

#pragma mark firstResponder Methods

- (BOOL)acceptsFirstResponder {
    NSLog(@"Accepting");
    return YES;
}

- (BOOL)resignFirstResponder {
    NSLog(@"Resigning");
//    [self setNeedsDisplay:YES];
    [self setKeyboardFocusRingNeedsDisplayInRect:[self bounds]];
    return YES;
}

- (BOOL)becomeFirstResponder {
    NSLog(@"Becoming");
    [self setNeedsDisplay:YES];
    return YES;
}

#pragma mark Key Events

- (void)keyDown:(NSEvent *)theEvent {
    [self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
}

- (void)insertText:(id)insertString {
    self.string = insertString;
}

- (void)insertTab:(id)sender {
    [[self window] selectKeyViewFollowingView:self];
}

- (void)insertBacktab:(id)sender {
    [[self window] selectKeyViewPrecedingView:self];
}

- (void)deleteBackward:(id)sender {
    self.string = @" ";
}

#pragma mark Accessors

- (void)setBgColor:(NSColor *)bgColor {
    _bgColor = bgColor;
    [self setNeedsDisplay:YES];
}

- (NSColor *)bgColor {
    return _bgColor;
}

- (void)setString:(NSString *)string {
    _string = string;
    NSLog(@"The string is now %@", string);
}

- (NSString *)string {
    return _string;
}

- (void)setIsHighlighted:(BOOL)isHighlighted {
    _isHighlighted = isHighlighted;
    [self setNeedsDisplay:YES];
}

- (BOOL)isHighlighted {
    return _isHighlighted;
}

@end
