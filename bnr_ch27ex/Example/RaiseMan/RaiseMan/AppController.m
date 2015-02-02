//
//  AppController.m
//  RaiseMan
//
//  Created by Can on 1/19/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "AppController.h"
#import "PreferenceController.h"

@implementation AppController

+ (void)initialize {
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
    NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject:[NSColor yellowColor]];
    [defaultValues setObject:colorAsData forKey:TableBgColorKey];
    [defaultValues setObject:[NSNumber numberWithBool:YES] forKey:EmptyDocKey];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
    NSLog(@"registered defaults: %@", defaultValues);
}

- (IBAction)showPreferencePanel:(id)sender {
    if (!_preferenceController) {
        _preferenceController = [[PreferenceController alloc] init];
    }
    NSLog(@"showing %@", _preferenceController);
    [_preferenceController showWindow:self];
}

- (IBAction)showAboutPanel:(id)sender {
    if (!_aboutPanel) {
        [[NSBundle mainBundle] loadNibNamed:@"About"
                                          owner:self
                                topLevelObjects:nil];
    }
    [[[NSWindowController alloc] initWithWindow:_aboutPanel] showWindow:self];
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender {
    NSLog(@"applicationShouldOpenUntitledFile:");
    return [PreferenceController preferenceEmptyDoc];
}

//- (void)applicationDidResignActive:(NSNotification *)notification {
//    NSBeep();
//}

@end
