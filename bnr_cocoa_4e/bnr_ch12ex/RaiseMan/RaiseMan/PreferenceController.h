//
//  PreferenceController.h
//  RaiseMan
//
//  Created by Can on 1/19/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferenceController : NSWindowController {
    IBOutlet NSColorWell *_colorWell;
    IBOutlet NSButton *_checkBox;
}

- (IBAction)changeBackgroundColor:(id)sender;
- (IBAction)changeNewEmptyDoc:(id)sender;

@end
