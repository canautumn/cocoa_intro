//
//  Document.m
//  Departments
//
//  Created by Can on 2/4/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "Document.h"
#import "DepartmentViewController.h"
#import "EmployeeViewController.h"

@interface Document ()

@end

@implementation Document

- (instancetype)init {
    self = [super init];
    if (self) {
        self.viewControllers = [[NSMutableArray alloc] init];
        ManagingViewController *vc;
        
        vc = [[DepartmentViewController alloc] init];
        vc.managedObjectContext = self.managedObjectContext;
        [self.viewControllers addObject:vc];
    
        vc = [[EmployeeViewController alloc] init];
        vc.managedObjectContext = self.managedObjectContext;
        [self.viewControllers addObject:vc];
    }
    return self;
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController]; // template code
    
    NSMenu *menu = self.popUp.menu;
    for (int i = 0; i < self.viewControllers.count; ++i) {
        NSViewController *vc = [self.viewControllers objectAtIndex:i];
        NSMenuItem *mi = [[NSMenuItem alloc] initWithTitle:vc.title action:@selector(changeViewController:) keyEquivalent:@""];
        mi.tag = i;
        [menu addItem:mi];
    }
    
    [self displayViewController:[self.viewControllers objectAtIndex:0]];
    [self.popUp selectItemAtIndex:0];
}

+ (BOOL)autosavesInPlace {
    return YES;
}

- (NSString *)windowNibName {
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

#pragma mark View Management

- (void)displayViewController:(ManagingViewController *)vc {
    NSWindow *w = self.box.window;
    BOOL ended = [w makeFirstResponder:w];
    if (!ended) {
        NSBeep();
        return;
    }
    NSView *v = [vc view];
    
    /* BEGIN: resize window according to the view */
    NSSize currentSize = [self.box.contentView frame].size; // contentView is of id type, you cannot use dot notation on id.
    NSSize newSize = v.frame.size;
    float deltaWidth = newSize.width - currentSize.width;
    float deltaHeight = newSize.height - currentSize.height;
    NSRect windowFrame = w.frame;
    windowFrame.size.height += deltaHeight;
    windowFrame.origin.y -= deltaHeight;
    windowFrame.size.width += deltaWidth;
 
    self.box.contentView = nil; // clear before animate
    [w setFrame:windowFrame display:YES animate:YES];
    
    
    /* END: resize window according to the view */
    
    self.box.contentView = v;
    
//    /* Responder chain */
//    v.nextResponder = vc;
//    vc.nextResponder = self.box;
}

#pragma mark Actions

- (IBAction)changeViewController:(id)sender {
    NSUInteger i = [sender tag];
    ManagingViewController *vc = [self.viewControllers objectAtIndex:i];
    [self displayViewController:vc];
}
@end
