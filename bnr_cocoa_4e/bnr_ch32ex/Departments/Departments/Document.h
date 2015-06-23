//
//  Document.h
//  Departments
//
//  Created by Can on 2/4/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Document : NSPersistentDocument

@property (weak) IBOutlet NSBox *box;
@property (weak) IBOutlet NSPopUpButton *popUp;

@property NSMutableArray *viewControllers;

- (IBAction)changeViewController:(id)sender;

@end
