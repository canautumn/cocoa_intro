//
//  EmployeeViewController.m
//  Departments
//
//  Created by Can on 2/4/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "EmployeeViewController.h"

@interface EmployeeViewController ()

//@property (strong) IBOutlet NSArrayController *employeeController;

@end

@implementation EmployeeViewController

- (instancetype)init {
    self = [super initWithNibName:@"EmployeeView" bundle:nil];
    if (self) {
        self.title = @"Employees";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

//- (void)keyDown:(NSEvent *)theEvent {
//    [self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
//}
//
//- (void)deleteBackward:(id)sender {
//    [self.employeeController remove:nil];
//}

@end
