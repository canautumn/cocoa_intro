//
//  Document.h
//  CarLot
//
//  Created by Can on 1/18/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class CarArrayController;

@interface Document : NSPersistentDocument {
    IBOutlet CarArrayController *_carArrayController;
    __weak IBOutlet NSTableView *_tableView;
}

- (IBAction)createItem:(id)sender;

@end
