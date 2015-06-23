//
//  AppDelegate.m
//  iPing
//
//  Created by Can on 2/11/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (unsafe_unretained) IBOutlet NSTextView *outputView; //unsafe_unretained for some reason?
@property (weak) IBOutlet NSButton *startButton;
@property (weak) IBOutlet NSTextField *hostField;

@property NSTask *task;
@property NSPipe *pipe;

- (IBAction)startStopPing:(id)sender;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)startStopPing:(id)sender {
    // Is the task running?
    if (self.task) {
        [self.task interrupt];
    } else {
        self.task = [[NSTask alloc] init];
        self.task.launchPath = @"/sbin/ping";
        self.task.arguments = @[@"-c10", self.hostField.stringValue];
        
        self.pipe = [[NSPipe alloc] init];
        self.task.standardOutput = self.pipe;
        
        NSFileHandle *fh = self.pipe.fileHandleForReading;
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc removeObserver:self];
        [nc addObserver:self selector:@selector(dataReady:) name:NSFileHandleReadCompletionNotification object:fh];
        [nc addObserver:self selector:@selector(taskTerminated:) name:NSTaskDidTerminateNotification object:self.task];
        [self.task launch];
        self.outputView.string = @"";
        
        [fh readInBackgroundAndNotify];
    }
}

- (void)appendData:(NSData *)d {
    NSString *s = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    NSTextStorage *ts = self.outputView.textStorage;
    [ts replaceCharactersInRange:NSMakeRange(ts.length, 0) withString:s];
}

- (void)dataReady:(NSNotification *)n {
    NSData *d = n.userInfo[NSFileHandleNotificationDataItem];
    
    NSLog(@"dataReady:%ld bytes", d.length);
    
    if (d.length) {
        [self appendData:d];
    }
    // If the task is running, start reading again
    if (self.task) {
        [[self.pipe fileHandleForReading] readInBackgroundAndNotify];
    }
}

- (void)taskTerminated:(NSNotification *)n {
    NSLog(@"taskTerminated:");
    
    self.task = nil;
    
    self.startButton.state = NSOffState;
}

@end
