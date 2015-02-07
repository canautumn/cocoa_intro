//
//  Department.m
//  Departments
//
//  Created by Can on 2/6/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "Department.h"
#import "Employee.h"


@implementation Department

@dynamic deptName;
@dynamic employees;
@dynamic manager;

- (void)addEmployeesObject:(Employee *)value {
    NSLog(@"Dept %@ adding employee %@", self.deptName, value.fullName);
    NSSet *s = [NSSet setWithObject:value];
    [self willChangeValueForKey:@"employees" withSetMutation:NSKeyValueUnionSetMutation usingObjects:s];
    [[self primitiveValueForKey:@"employees"] addObject:value];
    [self didChangeValueForKey:@"employees" withSetMutation:NSKeyValueUnionSetMutation usingObjects:s];
}

- (void)removeEmployeesObject:(Employee *)value {
    NSLog(@"Dept %@ removing employee %@", self.deptName, value.fullName);
    Employee *manager = self.manager;
    if (manager == value) {
        self.manager = nil;
    }
    NSSet *s = [NSSet setWithObject:value];
    [self willChangeValueForKey:@"employees" withSetMutation:NSKeyValueMinusSetMutation usingObjects:s];
    [[self primitiveValueForKey:@"employees"] removeObject:value];
    [self didChangeValueForKey:@"employees" withSetMutation:NSKeyValueMinusSetMutation usingObjects:s];
}

@end
