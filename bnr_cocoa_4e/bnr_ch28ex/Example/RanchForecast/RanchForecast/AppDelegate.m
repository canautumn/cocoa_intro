//
//  AppDelegate.m
//  RanchForecast
//
//  Created by Can on 2/2/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "AppDelegate.h"
#import "ScheduleFetcher.h"
#import "ScheduledClass.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSWindow *window;

@property (strong) NSArray *classes;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    /* This is to set Double Action programmatically */
//    [self.tableView setTarget:self];
//    [self.tableView setDoubleAction:@selector(openClass:)];
    
    ScheduleFetcher *fetcher = [[ScheduleFetcher alloc] init];
    NSError *error = nil;
    self.classes = [fetcher fetchClassesWithError:&error];
    [self.tableView reloadData];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mark -
#pragma mark NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.classes.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    ScheduledClass *c = [self.classes objectAtIndex:row];
    return [c valueForKey:[tableColumn identifier]];
}

#pragma mark -
#pragma mark Actions


/* This method can only be used for setting Double Action programmatically */
//- (void)openClass:(id)sender {
//    NSLog(@"%ld", (long)[sender clickedRow]);
//    NSLog(@"%@", sender);
//    NSLog(@"%@", self.tableView);
//    
//    ScheduledClass *c = [self.classes objectAtIndex:[sender clickedRow]]; // OR self.tableView.clickedRow BUT sender.clickedRow is an error.
//    NSURL *baseURL = [NSURL URLWithString:@"http://www.bignerdranch.com/"];
//    NSURL *url = [NSURL URLWithString:[c href] relativeToURL:baseURL];
//    [[NSWorkspace sharedWorkspace] openURL:url];
//}



/* This method can be used both for setting Double Action programmatically or by bindings. */
/* If by bindings, the argument should have MKP ''self.tableView'' */
- (void)openClass:(id)sender {
    NSLog(@"%ld", (long)[sender selectedRow]);
    NSLog(@"%@", sender);
    NSLog(@"%@", self.tableView);
    
    ScheduledClass *c = [self.classes objectAtIndex:[sender selectedRow]]; // OR self.tableView.selectedRow BUT sender.selectRow is an error.
    NSURL *baseURL = [NSURL URLWithString:@"http://www.bignerdranch.com/"];
    NSURL *url = [NSURL URLWithString:[c href] relativeToURL:baseURL];
    [[NSWorkspace sharedWorkspace] openURL:url];
}


/* This method only works for bindings, and the argument should have MKP ''self.tableView.selectedRow''. */
//- (void)openClass:(NSNumber *)selectedRow {
//    ScheduledClass *c = [self.classes objectAtIndex:selectedRow.intValue];
//    NSURL *baseURL = [NSURL URLWithString:@"http://www.bignerdranch.com/"];
//    NSURL *url = [NSURL URLWithString:[c href] relativeToURL:baseURL];
//    [[NSWorkspace sharedWorkspace] openURL:url];
//}

/* This is a wrong example since the bindings only passes objects. */
//- (void)openClass:(NSInteger)selectedRow {
//    ScheduledClass *c = [self.classes objectAtIndex:selectedRow];
//    NSURL *baseURL = [NSURL URLWithString:@"http://www.bignerdranch.com/"];
//    NSURL *url = [NSURL URLWithString:[c href] relativeToURL:baseURL];
//    [[NSWorkspace sharedWorkspace] openURL:url];
//}

/* This method only works for bindings, and the argument should not be bound, only the action selector, but the selector must be ''openClass'', not ''openClass:'' */
//- (void)openClass {
//    ScheduledClass *c = [self.classes objectAtIndex:self.tableView.selectedRow];
//    NSURL *baseURL = [NSURL URLWithString:@"http://www.bignerdranch.com/"];
//    NSURL *url = [NSURL URLWithString:[c href] relativeToURL:baseURL];
//    [[NSWorkspace sharedWorkspace] openURL:url];
//}

@end
