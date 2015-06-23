//
//  AppDelegate.m
//  Scattered
//
//  Created by Can on 2/6/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

- (void)addImagesFromFolderURL:(NSURL *)url;
- (NSImage *)thumbImageFromImage:(NSImage *)image;
- (void)presentImage:(NSImage *)image withImageName:(NSString *)name;
- (void)setText:(NSString *)text;
- (CGPoint)randomPoint;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    srandom((unsigned)time(NULL));
    
    self.animationDuration = 1.5;
    
    // Set view to be layer-hosting
    self.view.layer = [CALayer layer];
    self.view.wantsLayer = YES;
    
    CALayer *textContainer = [CALayer layer];
    textContainer.anchorPoint = CGPointZero;
    textContainer.position = CGPointMake(10.0, 10.0);
    textContainer.zPosition = 100.0;
    textContainer.backgroundColor = CGColorGetConstantColor(kCGColorBlack);
    textContainer.borderColor = CGColorGetConstantColor(kCGColorWhite);
    textContainer.borderWidth = 2.0;
    textContainer.cornerRadius = 15.0;
    textContainer.shadowOpacity = 0.5f;
    [self.view.layer addSublayer:textContainer];
    
    self.textLayer = [CATextLayer layer];
    self.textLayer.anchorPoint = CGPointZero;
    self.textLayer.position = CGPointMake(10.0, 6.0);
    self.textLayer.zPosition = 100.0;
    self.textLayer.fontSize = 24.0;
    self.textLayer.foregroundColor = CGColorGetConstantColor(kCGColorWhite);
    [textContainer addSublayer:self.textLayer];
    
    // Rely on setText: to set the above layer's bounds:
    [self setText:@"Loading..."];
    
    [self addImagesFromFolderURL:[NSURL fileURLWithPath:@"/Library/Desktop Pictures"]];
}

- (void)setText:(NSString *)text {
    NSFont *font = [NSFont systemFontOfSize:self.textLayer.fontSize];
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    NSSize size = [text sizeWithAttributes:attrs];
    // Ensure that the size is in whole numbers; not necessary
//    size.width = ceilf(size.width);
//    size.height = ceilf(size.height);
    
    self.textLayer.bounds = CGRectMake(0.0, 0.0, size.width, size.height);
    // superlayer is the textContainer
    self.textLayer.superlayer.bounds = CGRectMake(0.0, 0.0, size.width + 16.0, size.height + 20.0);
    self.textLayer.string = text;
}

- (NSImage *)thumbImageFromImage:(NSImage *)image {
    const CGFloat targetHeight = 200.0f;
    NSSize imageSize = image.size;
    NSSize smallerSize = NSMakeSize(targetHeight * imageSize.width / imageSize.height, targetHeight);
    
    NSImage *smallerImage = [[NSImage alloc] initWithSize:smallerSize];
    
    [smallerImage lockFocus];
    [image drawInRect:NSMakeRect(0.0, 0.0, smallerSize.width, smallerSize.height)
             fromRect:NSZeroRect
            operation:NSCompositeCopy
             fraction:1.0];
    [smallerImage unlockFocus];
    
    return smallerImage;
}

- (void)addImagesFromFolderURL:(NSURL *)url {
    NSTimeInterval t0 = [NSDate timeIntervalSinceReferenceDate];
    
    NSFileManager *fileManager = [NSFileManager new];
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtURL:url
                                       includingPropertiesForKeys:nil
                                                          options:NSDirectoryEnumerationSkipsHiddenFiles
                                                     errorHandler:nil];
    
    int allowedFiles = 10;
    
    for (NSURL *url in dirEnum) {
        // Skip directories
        NSNumber *isDirectory = nil;
        [url getResourceValue:&isDirectory
                       forKey:NSURLIsDirectoryKey
                        error:nil];
        if ([isDirectory boolValue]) {
            continue;
        }
        
        NSImage *image = [[NSImage alloc] initWithContentsOfURL:url];
        if (!image) {
            return;
        }
        
        allowedFiles--;
        if (allowedFiles < 0) {
            break;
        }
        
        NSImage *thumbImage = [self thumbImageFromImage:image];
        
        [self presentImage:thumbImage withImageName:[url lastPathComponent]];
        [self setText:[NSString stringWithFormat:@"%0.1fs", [NSDate timeIntervalSinceReferenceDate] - t0]];
    }
}

- (CGPoint)randomPoint {
    CGRect superlayerBounds = self.view.layer.bounds;
    return CGPointMake(CGRectGetMaxX(superlayerBounds) *
                       (float)random() / (float)RAND_MAX,
                       CGRectGetMaxY(superlayerBounds) *
                       (float)random() / (float)RAND_MAX);
}

- (void)presentImage:(NSImage *)image withImageName:(NSString *)name{
    CGRect superlayerBounds = self.view.layer.bounds;
    NSPoint center = NSMakePoint(CGRectGetMidX(superlayerBounds), CGRectGetMidY(superlayerBounds));
    NSRect imageBounds = NSMakeRect(0.0, 0.0, image.size.width, image.size.height);
    CGPoint randomPoint = [self randomPoint];
    
    CAMediaTimingFunction *tf = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *posAnim = [CABasicAnimation animation];
    posAnim.fromValue = [NSValue valueWithPoint:center];
    posAnim.duration = self.animationDuration;
    posAnim.timingFunction = tf;
    
    CABasicAnimation *bdsAnim = [CABasicAnimation animation];
    bdsAnim.fromValue = [NSValue valueWithRect:NSZeroRect];
    bdsAnim.duration = self.animationDuration;
    bdsAnim.timingFunction = tf;
    
    CALayer *layer = [CALayer layer];
    layer.contents = image;
    layer.actions = [NSDictionary dictionaryWithObjectsAndKeys:posAnim, @"position", bdsAnim, @"bounds", nil];
    layer.shadowRadius = 2.0;
    layer.shadowOffset = CGSizeMake(5.0, -3.0);
    layer.shadowOpacity = 0.3;
    layer.borderColor = CGColorGetConstantColor(kCGColorWhite);
    layer.borderWidth = 2.0;
    
    CABasicAnimation *labelFontSizeAnim = [CABasicAnimation animation];
    labelFontSizeAnim.fromValue = [NSNumber numberWithFloat:0.0];
    labelFontSizeAnim.duration = self.animationDuration;
    labelFontSizeAnim.timingFunction = tf;
    
    CABasicAnimation *labelBdsAnim = [CABasicAnimation animation];
    labelBdsAnim.fromValue = [NSValue valueWithRect:NSZeroRect];
    labelBdsAnim.duration = self.animationDuration;
    labelBdsAnim.timingFunction = tf;
    
    CATextLayer *labelLayer = [CATextLayer layer];
    labelLayer.string = name;
    labelLayer.position = CGPointMake(3, -3);
    labelLayer.anchorPoint = CGPointMake(0.0, 0.0);
    labelLayer.actions = [NSDictionary dictionaryWithObjectsAndKeys:labelFontSizeAnim, @"fontSize", labelBdsAnim, @"bounds", nil];
    
    [layer addSublayer:labelLayer];
    
    [CATransaction begin];
    [self.view.layer addSublayer:layer];
    layer.position = randomPoint;
    layer.bounds = NSRectToCGRect(imageBounds);
    labelLayer.bounds = NSRectToCGRect(imageBounds);
    labelLayer.fontSize = 18;
    [CATransaction commit];
}


- (IBAction)shuffle:(id)sender {
    // End editing for the text field to update binding values.
    [self.window endEditingFor:self.window.firstResponder];
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:self.animationDuration];
    
    for (CALayer *layer in [self.view.layer sublayers]) {
        if (layer == self.textLayer.superlayer) {
            continue;
        }
        
        CGPoint randomPoint = [self randomPoint];
        layer.actions = nil; // start from zero point if delete this line
        layer.position = randomPoint;
    }
    [CATransaction commit];
}

@end
