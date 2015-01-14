//
//  main.m
//  test
//
//  Created by Can on 1/13/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Testobj.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        Testobj * test = [[Testobj alloc] init];
        [test setValue:@10 forKey:@"fidor"];
        NSLog(@"%@", [test valueForKey:@"fidor"]);
    }
    return 0;
}
