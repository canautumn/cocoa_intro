//
//  Document.m
//  RaiseMan
//
//  Created by Can on 1/13/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "Document.h"
#import "Person.h"
#import "PreferenceController.h"

@interface Document ()

@end

@implementation Document

static void *DocumentKVOContext;

- (void)startObservingPerson:(Person *)person {
    [person addObserver:self forKeyPath:@"personName" options:NSKeyValueObservingOptionOld context:&DocumentKVOContext];
    [person addObserver:self forKeyPath:@"expectedRaise" options:NSKeyValueObservingOptionOld context:&DocumentKVOContext];
}

- (void)stopObservingPerson:(Person *)person {
    [person removeObserver:self forKeyPath:@"personName" context:&DocumentKVOContext];
    [person removeObserver:self forKeyPath:@"expectedRaise" context:&DocumentKVOContext];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _employees = [[NSMutableArray alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDefaultsChange:) name:NSUserDefaultsDidChangeNotification object:nil];

    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleDefaultsChange:(NSNotification *)note {
    NSLog(@"UserDefaultsChanged");
    [_tableView setBackgroundColor:[PreferenceController preferenceTableBgColor]];
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController];
    
    [_tableView setBackgroundColor:[PreferenceController preferenceTableBgColor]];
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
    // end editing
    [[_tableView window] endEditingFor:nil];
    // create an NSData object from the employees array
    return [NSKeyedArchiver archivedDataWithRootObject:_employees];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    NSLog(@"About to read data of type %@", typeName);
    NSMutableArray *newArray = nil;
    @try {
        newArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException *exception) {
        NSLog(@"exception = %@", exception);
        if (outError) {
            NSDictionary *d = [NSDictionary dictionaryWithObject:@"The data is corrupted." forKey:NSLocalizedFailureReasonErrorKey];
            *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:d];
        }
        return NO;
    }
    [self setEmployees:newArray];
    return YES;
}


- (void)setEmployees:(NSMutableArray *)a {
    if (a == _employees) {
        return;
    }
    for (Person *person in _employees) {
        [self stopObservingPerson:person];
    }
//    NSLog(@"setted");
    _employees = a;
    for (Person *person in _employees) {
        [self startObservingPerson:person];
    }
}

//- (NSMutableArray *)employees {
//    return _employees;
//}

#pragma mark Undo Manager KVC methods

- (void)insertObject:(Person *)p inEmployeesAtIndex:(NSUInteger)index {
    NSLog(@"adding %@ to %@", p, _employees);
    NSUndoManager *undo = [self undoManager];
    [[undo prepareWithInvocationTarget:self] removeObjectFromEmployeesAtIndex:index];
    if (![undo isUndoing]) {
        [undo setActionName:@"Add Person"];
    }
    [self startObservingPerson:p];
    [_employees insertObject:p atIndex:index];
}

- (void)removeObjectFromEmployeesAtIndex:(NSUInteger)index {
    Person *p = [_employees objectAtIndex:index];
    NSLog(@"removing %@ from %@", p, _employees);
    NSUndoManager *undo = [self undoManager];
    [[undo prepareWithInvocationTarget:self] insertObject:p inEmployeesAtIndex:index];
    if (![undo isUndoing]) {
        [undo setActionName:@"Remove Person"];
    }
    [self stopObservingPerson:p];
    [_employees removeObjectAtIndex:index];
}

#pragma mark Undo Manager KVO methods

- (void)changeKeyPath:(NSString *)keyPath ofObject:(id)obj toValue:(id)newValue {
    // setValue:forKeyPath: will cause the key-value observing method to be called, which takes care of the undo stuff
    [obj setValue:newValue forKeyPath:keyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context != &DocumentKVOContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    NSUndoManager *undo = [self undoManager];
    id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    // NSNull objects are used to represent nil in a dictionary
    if (oldValue == [NSNull null]) {
        oldValue = nil;
    }
    NSLog(@"oldValue = %@", oldValue);
    [[undo prepareWithInvocationTarget:self] changeKeyPath:keyPath ofObject:object toValue:oldValue];
    [undo setActionName:@"Edit"]; // why not check "undoing"?
}

#pragma mark Action methods

- (IBAction)createEmployee:(id)sender {
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
    // create the object
    Person *p = [_employeeController newObject];
    
    // add it to the content array of '_employeeController'
    [_employeeController addObject:p];
    
    // re-sort (in case the user has sorted a column)
    [_employeeController rearrangeObjects];
    
    // get the sorted array
    NSArray *a = [_employeeController arrangedObjects];
    
    // find the object just added
    NSUInteger row = [a indexOfObjectIdenticalTo:p];
    NSLog(@"starting edit of %@ in row %lu", p, row);
    
    // begin the edit in thet first column
    [_tableView editColumn:0 row:row withEvent:nil select:YES];
}

@end
