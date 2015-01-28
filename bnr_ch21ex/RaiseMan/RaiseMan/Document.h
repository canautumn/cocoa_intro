//
//  Document.h
//  RaiseMan
//
//  Created by Can on 1/13/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class Person;

@interface Document : NSDocument {
    NSMutableArray *_employees;
    __weak IBOutlet NSTableView *_tableView;
    IBOutlet NSArrayController *_employeeController;
}

- (IBAction)createEmployee:(id)sender;
- (IBAction)removeEmployee:(id)sender;

- (void)setEmployees:(NSMutableArray *)a;

- (void)insertObject:(Person *)p inEmployeesAtIndex:(NSUInteger)index;
- (void)removeObjectFromEmployeesAtIndex:(NSUInteger)index;

@end

