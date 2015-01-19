//
//  Document.m
//  CarLot
//
//  Created by Can on 1/18/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "Document.h"
#import "CarArrayController.h"

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
    return YES;
}

- (NSString *)windowNibName {
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

- (IBAction)createItem:(id)sender {
    NSWindow *w = [_tableView window];
    // try to end any editing that is taking place.
    BOOL editingEnded = [w makeFirstResponder:w];
    if (!editingEnded) {
        NSLog(@"Unable to end editing");
        return;
    }
    NSUndoManager *undo = [self undoManager];
    
    // has an edit occured already in this event?
    if ([undo groupingLevel] > 0) {
        // close the last group
        [undo endUndoGrouping];
        // open a new group
        [undo beginUndoGrouping];
    }
    
    id newObj = [_carArrayController newObject];
    [_carArrayController addObject:newObj];
    [_carArrayController rearrangeObjects];
    
    NSArray *a = [_carArrayController arrangedObjects];
    NSUInteger row = [a indexOfObjectIdenticalTo:newObj];
    [_tableView editColumn:0 row:row withEvent:nil select:YES];
}

@end
