//
//  PreferenceController.m
//  RaiseMan
//
//  Created by Can on 1/19/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "PreferenceController.h"

@interface PreferenceController ()

@end

@implementation PreferenceController

- (id)init {
    self = [super initWithWindowNibName:@"PreferenceController"];
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    NSLog(@"Nib file is loaded");
}

- (IBAction)changeBackgroundColor:(id)sender {
    NSColor *color = [_colorWell color];
    NSLog(@"Color changed: %@", color);
}

- (IBAction)changeNewEmptyDoc:(id)sender {
    NSInteger state = [_checkBox state];
    NSLog(@"Checkbo changed %ld", state);
}

@end
