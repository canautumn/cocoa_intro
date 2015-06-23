//
//  BigLetterView.m
//  TypingTutor
//
//  Created by Can on 1/26/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "BigLetterView.h"
#import "NSString+FirstLetter.h"

@interface BigLetterView ()

@property (strong) NSEvent *mouseDownEvent;

@end

@implementation BigLetterView

@synthesize bgColor = _bgColor;
@synthesize string = _string;
@synthesize isHighlighted = _isHighlighted;

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSRect bounds = [self bounds];
    if (self.isHighlighted) {
        NSGradient *gr = [[NSGradient alloc] initWithStartingColor:[NSColor whiteColor] endingColor:self.bgColor];
        [gr drawInRect:bounds relativeCenterPosition:NSZeroPoint];
    } else {
        [self.bgColor set];
        [NSBezierPath fillRect:bounds];
    }
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshString) name:NSUserDefaultsDidChangeNotification object:nil];
    
    [self registerForDraggedTypes:[NSArray arrayWithObject:NSPasteboardTypeString]];
}

- (void)refreshString {
    [self drawStringCenteredIn:self.bounds];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark Pasteboard

- (void)writeToPasteboard:(NSPasteboard *)pb {
    [pb clearContents];
    NSPasteboardItem *item = [[NSPasteboardItem alloc] init];
    [item setData:[self dataWithPDFInsideRect:self.bounds] forType:NSPasteboardTypePDF];
    [item setString:self.string forType:NSPasteboardTypeString];
    
    [pb writeObjects:[NSArray arrayWithObject:item]];
}

- (BOOL)readFromPasteboard:(NSPasteboard *)pb {
    NSArray *classes = [NSArray arrayWithObject:[NSString class]];
    NSArray *objects = [pb readObjectsForClasses:classes options:nil];
    if ([objects count] > 0) {
        NSString *value = [objects objectAtIndex:0];
        [self setString:[value can_firstLetter]];
        return YES;
    }
    return NO;
}

- (IBAction)cut:(id)sender {
    [self copy:sender];
    [self setString:@" "];
}

- (IBAction)copy:(id)sender {
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    [self writeToPasteboard:pb];
}

- (IBAction)paste:(id)sender {
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    if (![self readFromPasteboard:pb]) {
        NSBeep();
    }
}


#pragma mark Drag-and-Drop - Source

/* before 10.7 */
//- (NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)flag {
//    return NSDragOperationCopy | NSDragOperationDelete;
//}

/* after 10.7 */
- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context {
    return NSDragOperationCopy | NSDragOperationDelete;
}

- (void)mouseDown:(NSEvent *)theEvent {
    self.mouseDownEvent = theEvent;
}

- (void)mouseDragged:(NSEvent *)theEvent {
    /* before 10.7 */
//    NSPoint down = [self.mouseDownEvent locationInWindow];
//    NSPoint drag = [theEvent locationInWindow];
//    float distance = hypot(down.x - drag.x, down.y - drag.y);
//    if (distance < 3) {
//        return;
//    }
//    
//    if ([self.string length] == 0) {
//        return;
//    }
//    
//    NSSize s = [self.string sizeWithAttributes:self.attributes];
//    NSImage *anImage = [[NSImage alloc] initWithSize:s];
//    NSRect imageBounds;
//    imageBounds.origin = NSZeroPoint;
//    imageBounds.size = s;
//    
//    [anImage lockFocus];
//    [self drawStringCenteredIn:imageBounds];
//    [anImage unlockFocus];
//    
//    NSPoint p = [self convertPoint:down fromView:nil];
//    
//    p.x = p.x - s.width / 2;
//    p.y = p.y - s.height / 2;
//    
//    NSPasteboard *pb = [NSPasteboard pasteboardWithName:NSDragPboard];
//    
//    [self writeToPasteboard:pb];
//    
//    [self dragImage:anImage
//                 at:p
//             offset:NSZeroSize
//              event:self.mouseDownEvent
//         pasteboard:pb
//             source:self
//          slideBack:YES];
//
    
    /* after 10.7: */
    
    NSPoint down = [self.mouseDownEvent locationInWindow];
    NSPoint drag = [theEvent locationInWindow];
    float distance = hypot(down.x - drag.x, down.y - drag.y);
    if (distance < 3) {
        return;
    }
    
    if ([self.string length] == 0) {
        return;
    }
    
    NSSize s = [self.string sizeWithAttributes:self.attributes];
    NSImage *anImage = [[NSImage alloc] initWithSize:s];
    NSRect imageBounds;
    imageBounds.origin = NSZeroPoint;
    imageBounds.size = s;
    
    [anImage lockFocus];
    [self drawStringCenteredIn:imageBounds];
    [anImage unlockFocus];
    
    NSPoint p = [self convertPoint:down fromView:nil];
    
    p.x = p.x - s.width / 2;
    p.y = p.y - s.height / 2;
    
    imageBounds.origin = p;
    
    /* NSPasteboardItemDataProvider */
//    NSPasteboardItem *pbItem = [NSPasteboardItem new];
//    
//    [pbItem setDataProvider:self forTypes:[NSArray arrayWithObjects:NSPasteboardTypeString, nil]];
    
//    NSDraggingItem *item = [[NSDraggingItem alloc] initWithPasteboardWriter:pbItem]
    
    NSDraggingItem *item = [[NSDraggingItem alloc] initWithPasteboardWriter:self.string];
    [item setDraggingFrame:imageBounds contents:anImage];
    
    NSDraggingSession *draggingSession = [self beginDraggingSessionWithItems:[NSArray arrayWithObject:item] event:self.mouseDownEvent source:self];
    
    draggingSession.animatesToStartingPositionsOnCancelOrFail = YES;
    
}


/* NSPasteboardItemDataProvider */
//- (void)pasteboard:(NSPasteboard *)sender provideDataForType:(NSString *)type {
//    NSLog(@"called");
//    if ([type compare:NSPasteboardTypeString] == NSOrderedSame) {
//        [sender setString:self.string forType:NSPasteboardTypeString];
//    }
//}


/* before 10.7 */
//- (void)draggedImage:(NSImage *)image endedAt:(NSPoint)screenPoint operation:(NSDragOperation)operation {
//    if (operation == NSDragOperationDelete) {
//        self.string = @" ";
//    }
//}
//

/* after 10.7 */

- (void)draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)screenPoint operation:(NSDragOperation)operation {
    if (operation == NSDragOperationDelete) {
        self.string = @" ";
    }
}


#pragma mark Drag-and-Drop - Destination

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    NSLog(@"draggingEntered:");
    if ([sender draggingSource] == self) {
        return NSDragOperationNone;
    }
    self.isHighlighted = YES;
    self.needsDisplay = YES;
    return NSDragOperationCopy;
}

- (void)draggingExited:(id<NSDraggingInfo>)sender {
    NSLog(@"draggingExited:");
    self.isHighlighted = NO;
    self.needsDisplay = YES;
}

- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender {
    return YES;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    NSPasteboard *pb = [sender draggingPasteboard];
    if (![self readFromPasteboard:pb]) {
        NSLog(@"Error: Could not read from dragging Pasteboard");
        return NO;
    }
    return YES;
}

- (void)concludeDragOperation:(id<NSDraggingInfo>)sender {
    NSLog(@"concludeDragOperation:");
    self.isHighlighted = NO;
    self.needsDisplay = YES;
}


#pragma mark Dragging Info (Demo only)

- (NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender {
    NSDragOperation op = [sender draggingSourceOperationMask];
    NSLog(@"operation mask = %ld", op);
    if ([sender draggingSource] == self) {
        return NSDragOperationNone;
    }
    return NSDragOperationCopy;
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

