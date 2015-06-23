//
//  PreferenceController.h
//  RaiseMan
//
//  Created by Can on 1/19/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString * const TableBgColorKey;
extern NSString * const EmptyDocKey;
extern NSString * const ColorChangeNotification;

@interface PreferenceController : NSWindowController {
//    IBOutlet NSColorWell *_colorWell;
//    IBOutlet NSButton *_checkBox;
}

//- (IBAction)changeBackgroundColor:(id)sender;
//- (IBAction)changeNewEmptyDoc:(id)sender;

- (IBAction)resetPreferences:(id)sender;

+ (NSColor *)preferenceTableBgColor;
+ (void)setPreferenceTableBgColor:(NSColor *)color;
+ (BOOL)preferenceEmptyDoc;
+ (void)setPreferenceEmptyDoc:(BOOL)emptyDoc;

@end
