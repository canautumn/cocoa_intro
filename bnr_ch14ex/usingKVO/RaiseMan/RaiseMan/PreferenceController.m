//
//  PreferenceController.m
//  RaiseMan
//
//  Created by Can on 1/19/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "PreferenceController.h"

NSString * const TableBgColorKey = @"TableBgColor";
NSString * const EmptyDocKey = @"EmptyDocumentFlag";
NSString * const ColorChangeNotification = @"ColorChanged";

@interface PreferenceController ()

@end

@implementation PreferenceController

- (id)init {
    self = [super initWithWindowNibName:@"PreferenceController"];
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
//    [_colorWell setColor:[PreferenceController preferenceTableBgColor]];
//    [_checkBox setState:[PreferenceController preferenceEmptyDoc]];
}

//- (IBAction)changeBackgroundColor:(id)sender {
//    NSColor *color = [_colorWell color];
////    [PreferenceController setPreferenceTableBgColor:color];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:ColorChangeNotification object:self userInfo:[NSDictionary dictionaryWithObject:color forKey:@"color"]];
//}

//- (IBAction)changeNewEmptyDoc:(id)sender {
//    NSInteger state = [_checkBox state];
//    [PreferenceController setPreferenceEmptyDoc:state];
//}

- (IBAction)resetPreferences:(id)sender {
    for(NSString * key in [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    [_colorWell setColor:[PreferenceController preferenceTableBgColor]];
}

+ (NSColor *)preferenceTableBgColor {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *colorAsData = [defaults objectForKey:TableBgColorKey];
    return [NSKeyedUnarchiver unarchiveObjectWithData:colorAsData];
}

+ (void)setPreferenceTableBgColor:(NSColor *)color {
    NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject:color];
    [[NSUserDefaults standardUserDefaults] setObject:colorAsData forKey:TableBgColorKey];
}

+ (BOOL)preferenceEmptyDoc {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:EmptyDocKey];
}

+ (void)setPreferenceEmptyDoc:(BOOL)emptyDoc {
    [[NSUserDefaults standardUserDefaults] setBool:emptyDoc forKey:EmptyDocKey];
}

@end

