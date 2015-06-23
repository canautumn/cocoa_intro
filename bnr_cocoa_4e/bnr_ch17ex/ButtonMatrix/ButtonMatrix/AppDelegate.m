//
//  AppDelegate.m
//  ButtonMatrix
//
//  Created by Can on 1/25/15.
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

- (IBAction)myAction:(id)sender {
    id theCell = [sender selectedCell];
    NSUInteger theTag = [theCell tag];
    NSLog(@"%lu", theTag);
}
@end
