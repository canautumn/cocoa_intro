//
//  AppDelegate.h
//  TypingTutor
//
//  Created by Can on 1/26/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class BigLetterView;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet BigLetterView *bigLetterView;

@end

