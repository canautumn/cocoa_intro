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
#import <WebKit/WebKit.h>

@interface AppDelegate ()

@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSWindow *sheetWindow;
@property (weak) IBOutlet WebView *webBrowser;

@property (assign) BOOL webBrowserIsLoading;

@property (strong) NSArray *classes;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    /* This is to set Double Action programmatically */
//    [self.tableView setTarget:self];
//    [self.tableView setDoubleAction:@selector(openClass:)];
    
    ScheduleFetcher *fetcher = [[ScheduleFetcher alloc] init];
    
    [fetcher fetchClassesWithBlock:^(NSArray *classes, NSError *error) {
        if (classes) {
            self.classes = classes;
            [self.tableView reloadData];
        } else {
            NSAlert *alert = [[NSAlert alloc] init];
            alert.alertStyle = NSCriticalAlertStyle;
            alert.messageText = @"Error loading schedule.";
            alert.informativeText = [error localizedDescription];
            [alert addButtonWithTitle:@"OK"];
            [alert beginSheetModalForWindow:self.window completionHandler:nil];
        }
    }];
    
    
    
    
    /* This is to set webView delegate programmatically */
//    self.webBrowser.frameLoadDelegate = self;
    
    /* KVO is for test only */
//    [self.webBrowser addObserver:self forKeyPath:@"isLoading" options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
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
    
//    NSLog(@"%ld", (long)[sender selectedRow]);
//    NSLog(@"%@", sender);
//    NSLog(@"%@", self.tableView);
    
    ScheduledClass *c = [self.classes objectAtIndex:[sender selectedRow]]; // OR self.tableView.selectedRow BUT sender.selectRow is an error.
    NSURL *baseURL = [NSURL URLWithString:@"http://www.bignerdranch.com/"];
    NSURL *url = [NSURL URLWithString:[c href] relativeToURL:baseURL];
//    [[NSWorkspace sharedWorkspace] openURL:url];
    /* modify the line above to the code below to show a webpage in a sheet. */
    NSLog(@"%d", self.webBrowser.isLoading);
    NSLog(@"%@", [self.webBrowser valueForKey:@"isLoading"]);

    self.webBrowser.mainFrameURL = url.absoluteString;
    [self.window beginSheet:self.sheetWindow completionHandler:nil];
    
    NSLog(@"%d", self.webBrowser.isLoading);
    NSLog(@"%@", [self.webBrowser valueForKey:@"isLoading"]);

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

- (IBAction)closeSheet:(id)sender {
    [self.window endSheet:self.sheetWindow];
}


/* KVO is for test only */
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    NSLog(@"%@ %d %d", keyPath, [[change valueForKey:NSKeyValueChangeOldKey] boolValue], [[change valueForKey:NSKeyValueChangeNewKey] boolValue]);
//    NSLog(@"directly get %d", self.webBrowser.isLoading);
//}

#pragma mark WebKit Delegate Methods

- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame {
    self.webBrowserIsLoading = YES;
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
    self.webBrowserIsLoading = NO;
}

- (void)webView:(WebView *)sender didFailProvisionalLoadWithError:(NSError *)error forFrame:(WebFrame *)frame {
    
    [self.window endSheet:self.sheetWindow];
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    alert.messageText = [NSString stringWithFormat:@"Loading Failed: %@", error.localizedDescription];
    [alert beginSheetModalForWindow:self.window completionHandler:nil];
}

@end
