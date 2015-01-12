//
//  AppDelegate.m
//  CharacterCount
//
//  Created by Can on 1/11/15.
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

- (IBAction)countIt:(id)sender {
    [[self label] setStringValue:[NSString stringWithFormat:@"'%@' has %lu characters.", [_textField stringValue], [[[self textField] stringValue] length] ]];
}
@end
