//
//  Document.h
//  OvalDrawer
//
//  Created by Can on 1/25/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class OvalArrayController;

@interface Document : NSPersistentDocument

@property (strong) IBOutlet OvalArrayController *arrayController;

- (void)addOval:(NSRect)rect;
//
//- (void)openDocument:(id)sender;
//
- (IBAction)undo:(id)sender;


@end
