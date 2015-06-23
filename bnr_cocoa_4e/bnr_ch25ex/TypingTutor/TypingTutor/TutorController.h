//
//  TutorController.h
//  TypingTutor
//
//  Created by Can on 1/31/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class BigLetterView;

@interface TutorController : NSObject

@property (weak) IBOutlet BigLetterView *inLetterView;
@property (weak) IBOutlet BigLetterView *outLetterView;
@property (weak) IBOutlet NSWindow *speedSheet;

@property (copy) NSArray *letters;
@property (assign) int lastIndex;

@property NSTimeInterval startTime;
@property NSTimeInterval elapsedTime;
@property NSTimeInterval timeLimit;
@property NSTimer *timer;

- (IBAction)stopGo:(id)sender;
- (IBAction)showSpeedSheet:(id)sender;
- (IBAction)endSpeedSheet:(id)sender;

@end
