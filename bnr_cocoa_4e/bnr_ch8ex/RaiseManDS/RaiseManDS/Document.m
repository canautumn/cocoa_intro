//
//  Document.m
//  RaiseManDS
//
//  Created by Can on 1/14/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "Document.h"
#import "Person.h"

@interface Document ()

@end

@implementation Document

- (instancetype)init {
    self = [super init];
    if (self) {
        _employees = [NSMutableArray array];
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

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    [NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    [NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
    return YES;
}

# pragma mark Action methods

- (IBAction)deleteSelectedEmployees:(id)sender {
    NSIndexSet *rows = [_tableView selectedRowIndexes];
    if ([rows count] == 0) {
        NSBeep();
        return;
    }
    [_employees removeObjectsAtIndexes:rows];
    [_tableView reloadData];
}

- (IBAction)createEmployee:(id)sender {
    Person *newEmployee = [[Person alloc] init];
    [_employees addObject:newEmployee];
    [_tableView reloadData];
}

#pragma mark Table view dataSource methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
//    NSLog(@"rows %lu", [_employees count]);
    return [_employees count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
//    NSLog(@"%@", [tableColumn identifier]);
    return [[_employees objectAtIndex:row] valueForKey:[tableColumn identifier]];
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
//    NSLog(@"%@", [tableColumn identifier]);
    [[_employees objectAtIndex:row] setValue:object forKey:[tableColumn identifier]];
}

- (void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray *)oldDescriptors {
//    NSLog(@"old descriptor: %@, new descriptor: %@", oldDescriptors, [tableView sortDescriptors]);
    [_employees sortUsingDescriptors:[tableView sortDescriptors]];
    [tableView reloadData];
}
@end
