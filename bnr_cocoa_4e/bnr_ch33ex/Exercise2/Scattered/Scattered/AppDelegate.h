//
//  AppDelegate.h
//  Scattered
//
//  Created by Can on 2/6/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSView *view;

@property (nonatomic, strong) CATextLayer *textLayer;

@property (assign) float animationDuration;

- (IBAction)shuffle:(id)sender;

@end

