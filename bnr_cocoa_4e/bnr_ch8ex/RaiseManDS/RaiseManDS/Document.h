//
//  Document.h
//  RaiseManDS
//
//  Created by Can on 1/14/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Document : NSDocument <NSTableViewDataSource> {
    NSMutableArray *_employees;
    __weak IBOutlet NSTableView *_tableView;
}

- (IBAction)createEmployee:(id)sender;
- (IBAction)deleteSelectedEmployees:(id)sender;

@end

