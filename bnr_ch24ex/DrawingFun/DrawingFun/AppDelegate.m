//
//  AppDelegate.m
//  DrawingFun
//
//  Created by Can on 1/24/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "AppDelegate.h"
#import "StretchView.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet StretchView *stretchView;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)showOpenPanel:(id)sender {
    // __block modifier is not necessary here.
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setAllowedFileTypes:[NSImage imageTypes]];
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK) {
            NSImage *image = [[NSImage alloc] initWithContentsOfURL:[panel URL]];
//            [[self stretchView] setImage:image];
            self.stretchView.image = image;
        }
    }];
}

@end
