//
//  Document.m
//  OvalDrawer
//
//  Created by Can on 1/25/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "Document.h"
#import "OvalArrayController.h"

@interface Document ()

@end

@implementation Document

- (instancetype)init {
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace {
    return NO; // prompt instead of auto saving when closing after editing.
}

- (NSString *)windowNibName {
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

#pragma mark Model related methods

- (void)addOval:(NSRect)rect {
//    NSLog(@"%@", NSStringFromRect(rect));
    [self.arrayController addObject:[self.arrayController newObjectWithRect:rect]];
}

//#pragma mark Menu Item Methods
//
//- (void)openDocument:(id)sender {
////    [[self nextResponder] openDocument:sender];
//    NSLog(@"open");
//}

//
//- (void)undo:(id)sender {
//    NSLog(@"test2");
//}

//- (IBAction)undo:(id)sender {
//    NSLog(@"testok");
//}

@end



