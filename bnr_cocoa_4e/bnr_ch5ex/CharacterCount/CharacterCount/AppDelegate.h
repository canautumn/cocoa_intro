//
//  AppDelegate.h
//  CharacterCount
//
//  Created by Can on 1/11/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSTextField *textField;
@property (weak) IBOutlet NSTextField *label;

- (IBAction)countIt:(id)sender;

@end

