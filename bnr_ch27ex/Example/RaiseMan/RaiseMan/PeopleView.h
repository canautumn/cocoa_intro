//
//  PeopleView.h
//  RaiseMan
//
//  Created by Can on 2/2/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PeopleView : NSView

@property (strong) NSArray *people;
@property (strong) NSMutableDictionary *attributes;
@property (assign) float lineHeight;
@property (assign) NSRect pageRect;
@property (assign) NSInteger linesPerPage;
@property (assign) NSInteger currentPage;

- (id)initWithPeople:(NSArray *)array;

@end
