//
//  BigLetterView.h
//  TypingTutor
//
//  Created by Can on 1/26/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BigLetterView : NSView <NSDraggingSource>

@property (strong) NSColor *bgColor;
@property (copy) NSString *string;
@property (assign) BOOL isHighlighted;
@property (strong) NSMutableDictionary *attributes;

- (IBAction)cut:(id)sender;
- (IBAction)copy:(id)sender;
- (IBAction)paste:(id)sender;

@end
