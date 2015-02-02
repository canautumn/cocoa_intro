//
//  TutorController.m
//  TypingTutor
//
//  Created by Can on 1/31/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "TutorController.h"
#import "BigLetterView.h"

static NSString * const TutorControllerElapsedTimeKey = @"elapsedTime";

@interface TutorController ()

- (void)updateElapsedTime;
- (void)resetElapsedTime;
- (void)showAnotherLetter;

@end

@implementation TutorController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.letters = [NSArray arrayWithObjects:@"a", @"s", @"d", @"f", @"j", @"k", @"l", @";", nil];
        srandom((unsigned)time(NULL));
        self.timeLimit = 5.0;
    }
    return self;
}

- (void)awakeFromNib {
    [self showAnotherLetter];
}

- (void)resetElapsedTime {
    self.startTime = [NSDate timeIntervalSinceReferenceDate];
    [self updateElapsedTime];
}

- (void)updateElapsedTime {
    // use property instead of instance variable, KVO notifying is not necessary.
//    [self willChangeValueForKey:TutorControllerElapsedTimeKey];
    self.elapsedTime = [NSDate timeIntervalSinceReferenceDate] - self.startTime;
//    [self didChangeValueForKey:TutorControllerElapsedTimeKey];
}

- (void)showAnotherLetter {
    int x = self.lastIndex;
    while (x == self.lastIndex) {
        x = (int)(random() % [self.letters count]);
    }
    self.lastIndex = x;
    self.outLetterView.string = [self.letters objectAtIndex:x];
    [self resetElapsedTime];
}

- (IBAction)stopGo:(id)sender {
    [self resetElapsedTime];
    if (self.timer == nil) {
        NSLog(@"Starting");
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                      target:self
                                                    selector:@selector(checkThem:)
                                                    userInfo:nil
                                                     repeats:YES];
    } else {
        NSLog(@"Stopping");
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (IBAction)showSpeedSheet:(id)sender {
    // call from NSApp is deprecated in 10.10:
//    [NSApp beginSheet:self.speedSheet
//       modalForWindow:self.inLetterView.window
//        modalDelegate:nil
//       didEndSelector:NULL
//          contextInfo:NULL];
    [self.inLetterView.window beginSheet:self.speedSheet completionHandler:nil];
}

- (IBAction)endSpeedSheet:(id)sender {
    // call from NSApp is deprecated in 10.10:
//    [NSApp endSheet:self.speedSheet];
//    [self.speedSheet orderOut:sender];
    [self.inLetterView.window endSheet:self.speedSheet];
}

- (void)checkThem:(NSTimer *)aTimer {
    if ([[self.inLetterView string] isEqual:[self.outLetterView string]]) {
        [self showAnotherLetter];
    }
    [self updateElapsedTime];
    if (self.elapsedTime >= self.timeLimit) {
        NSBeep();
        [self resetElapsedTime];
    }
}

#pragma mark Text Field Delegate Methods

- (BOOL)control:(NSControl *)control didFailToFormatString:(NSString *)string errorDescription:(NSString *)error {
    NSLog(@"TutorController told that formatting of %@ failed: %@", string, error);
    return NO; // try YES
}

@end

