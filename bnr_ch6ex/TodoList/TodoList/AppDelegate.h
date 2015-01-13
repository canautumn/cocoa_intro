//
//  AppDelegate.h
//  TodoList
//
//  Created by Can on 1/12/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource> {
    NSMutableArray *_items;
}

@property (weak) IBOutlet NSTextField *textField;
@property (weak) IBOutlet NSTableView *tableView;
- (IBAction)addItem:(id)sender;

@end

