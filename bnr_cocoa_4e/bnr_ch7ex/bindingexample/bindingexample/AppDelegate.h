//
//  AppDelegate.h
//  bindingexample
//
//  Created by Can on 1/13/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    int fido;
}
@property int fido;

- (IBAction)incrementFido:(id)sender;

@end

