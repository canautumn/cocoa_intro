//
//  AppDelegate.m
//  bindingexample
//
//  Created by Can on 1/13/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

//@synthesize fido;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (id)init {
    self = [super init];
    if (self) {
        fido = 30;
    }
    return self;
}

- (int)fido {
    return fido;
}

- (void)setFido:(int)f {
    fido = f;
}

- (IBAction)incrementFido:(id)sender {
    // Method 1:
//    [self willChangeValueForKey:@"fido"];
//    fido++;
//    [self didChangeValueForKey:@"fido"];
    // Method 2:
    [self setValue:[NSNumber numberWithInt:[[self valueForKey:@"fido"] intValue] + 1] forKey:@"fido"];
    // Method 3:
//    [self setFido:[self fido] + 1];
//    self.fido++;
    // Method 3.5:
//    self.fido++;
}
@end
