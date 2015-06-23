//
//  TutorController.h
//  TypingTutor
//
//  Created by Can on 1/31/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BigLetterView;

@interface TutorController : NSObject

@property (weak) IBOutlet BigLetterView *inLetterView;
@property (weak) IBOutlet BigLetterView *outLetterView;

@property (copy) NSArray *letters;
@property (assign) int lastIndex;

@property NSTimeInterval startTime;
@property NSTimeInterval elapsedTime;
@property NSTimeInterval timeLimit;
@property NSTimer *timer;

- (IBAction)stopGo:(id)sender;

@end
