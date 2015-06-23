//
//  RootViewController.m
//  RanchForecastTouch
//
//  Created by Can on 2/6/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "RootViewController.h"
#import "ScheduleFetcher.h"
#import "ScheduleViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"Ranch Forecast";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)fetchClasses:(id)sender {
    [self.activityIndicator startAnimating];
    self.fetchButton.enabled = NO;
    
    ScheduleFetcher *fetcher = [[ScheduleFetcher alloc] init];
    
    [fetcher fetchClassesWithBlock:^(NSArray *classes, NSError *error) {
        
        self.fetchButton.enabled = YES;
        [self.activityIndicator stopAnimating];
        
        if (classes) {
            ScheduleViewController *svc = [[ScheduleViewController alloc] initWithStyle:UITableViewStylePlain];
            svc.classes = classes;
            [self.navigationController pushViewController:svc animated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Error Fetching Classes"
                                  message:[error localizedDescription]
                                  delegate:nil
                                  cancelButtonTitle:@"Dismiss"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}
@end
