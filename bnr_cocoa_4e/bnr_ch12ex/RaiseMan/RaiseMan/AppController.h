//
//  AppController.h
//  RaiseMan
//
//  Created by Can on 1/19/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PreferenceController;

@interface AppController : NSObject {
    PreferenceController *_preferenceController;
    IBOutlet NSPanel *_aboutPanel;
}

- (IBAction)showPreferencePanel:(id)sender;
- (IBAction)showAboutPanel:(id)sender;

@end
