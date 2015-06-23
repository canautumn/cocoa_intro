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
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    NSRect rect = [[self.window contentView] frame];
    rect.origin.x += 20;
    rect.origin.y += 20;
    rect.size.width -= 40;
    rect.size.height -= 40;
    StretchView * sview = [[StretchView alloc] initWithFrame:rect];
    [[self.window contentView] addSubview:sview];
    NSView *contentView = [self.window contentView];
    
    // This line is important. The superview will be constraint if it is YES (default).
    sview.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    // Either Use Visual Format Language
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(contentView, sview);
    NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[sview]-20-|" options:0 metrics:nil views:viewsDictionary];
    NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[sview]-20-|" options:0 metrics:nil views:viewsDictionary];
    [contentView addConstraints:hConstraints];
    [contentView addConstraints:vConstraints];

    // Or Use Eplicit constraints
//    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:sview attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:[sview superview] attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-20]];
//    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:sview attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:[sview superview] attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20]];
//    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:sview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:[sview superview] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-20]];
//    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:sview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:[sview superview] attribute:NSLayoutAttributeTop multiplier:1.0 constant:20]];
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
