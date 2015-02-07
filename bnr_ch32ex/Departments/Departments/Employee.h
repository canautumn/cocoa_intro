//
//  Employee.h
//  Departments
//
//  Created by Can on 2/6/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Employee : NSManagedObject

@property (nonatomic, copy) NSString * firstName;
@property (nonatomic, copy) NSString * lastName;
@property (nonatomic, retain) NSManagedObject *department;

@property (nonatomic, readonly) NSString *fullName;

@end
