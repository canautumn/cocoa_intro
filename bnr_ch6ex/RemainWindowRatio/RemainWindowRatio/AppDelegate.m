//
//  AppDelegate.m
//  RemainWindowRatio
//
//  Created by Can on 1/12/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize {
    frameSize.height = 2 * frameSize.width;
    return frameSize;
}

@end
