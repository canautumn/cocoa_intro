//
//  EmployeeViewController.m
//  Departments
//
//  Created by Can on 2/4/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "EmployeeViewController.h"

@interface EmployeeViewController ()

@end

@implementation EmployeeViewController

//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        self.title = @"Employees";
//    }
//    return self;
//}

- (instancetype)init {
    self = [super initWithNibName:@"EmployeeView" bundle:nil];
    if (self) {
        self.title = @"Departments";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

@end
