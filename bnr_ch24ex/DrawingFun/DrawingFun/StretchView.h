//
//  StretchView.h
//  DrawingFun
//
//  Created by Can on 1/24/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface StretchView : NSView

@property (assign, readwrite) float opacity;
@property (strong) NSImage *image;

@end
