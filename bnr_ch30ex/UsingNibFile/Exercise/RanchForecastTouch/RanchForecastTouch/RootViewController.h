//
//  RootViewController.h
//  RanchForecastTouch
//
//  Created by Can on 2/6/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *fetchButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)fetchClasses:(id)sender;

@end
