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
    
    [self drawStringCenteredIn:bounds];
    
    
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
    [self prepareAttributes];
    self.bgColor = [NSColor yellowColor];
    self.string = @" ";
    self.isHighlighted = NO;
    
//    id obj = [[NSNotificationCenter defaultCenter] addObserverForName:NSUserDefaultsDidChangeNotification object:self queue:nil usingBlock:^(NSNotification *note) {
//        NSLog(@"AAAAA");
//        [self drawStringCenteredIn:self.bounds];
//    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshString) name:NSUserDefaultsDidChangeNotification object:nil];
}

- (void)refreshString {
    [self drawStringCenteredIn:self.bounds];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark String Related

- (void)prepareAttributes {
    self.attributes = [NSMutableDictionary dictionary];
    [self.attributes setObject:[NSFont userFontOfSize:75] forKey:NSFontAttributeName];
    [self.attributes setObject:[NSColor redColor] forKey:NSForegroundColorAttributeName];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = NSMakeSize(5.0, -3.0);
    shadow.shadowColor = [NSColor grayColor];
    shadow.shadowBlurRadius = 2.0;
    
    [self.attributes setObject:shadow forKey:NSShadowAttributeName];
}

- (void)drawStringCenteredIn:(NSRect)r {
    NSSize strSize = [self.string sizeWithAttributes:self.attributes];
    NSPoint strOrigin;
    strOrigin.x = r.origin.x + (r.size.width - strSize.width) / 2;
    strOrigin.y = r.origin.y + (r.size.height - strSize.height) / 2;
    
    NSFontTraitMask traits = 0;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isBold"]) {
        traits |= NSBoldFontMask;
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isItalic"]) {
        traits |= NSItalicFontMask;
    }
    
    NSFont *font = [[NSFontManager sharedFontManager] convertFont:[NSFont userFontOfSize:75] toHaveTrait:traits];
    [self.attributes setObject:font forKey:NSFontAttributeName];
    
    [self.string drawAtPoint:strOrigin withAttributes:self.attributes];
    [self setNeedsDisplay:YES]; // Add this line
}


- (IBAction)savePDF:(id)sender {
    NSSavePanel *panel = [NSSavePanel savePanel];
    [panel setAllowedFileTypes:[NSArray arrayWithObject:@"pdf"]];
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK) {
            NSRect r = self.bounds;
            NSData *data = [self dataWithPDFInsideRect:r];
            NSError *error;
            BOOL successful = [data writeToURL:[panel URL] options:0 error:&error];
            if (!successful) {
                NSAlert *a = [NSAlert alertWithError:error];
                [a runModal];
            }
        }
    }];
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
    [self setNeedsDisplay:YES];
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

