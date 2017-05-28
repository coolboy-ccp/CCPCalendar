//
//  ViewController.m
//  CCPCalendar
//
//  Created by Ceair on 17/5/25.
//  Copyright © 2017年 ccp. All rights reserved.
//

#import "ViewController.h"
#import "CCPCalendarManager.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)test:(id)sender {
//    [CCPCalendarManager show_mutil:^(NSArray *stArr) {
//        [stArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSLog(@"obj.ccpDate---%@",[obj valueForKey:@"ccpDate"]);
//            NSLog(@"obj.week---%@",[obj valueForKey:@"week"]);
//        }];
//    }];
    [CCPCalendarManager show_signal_past:^(NSArray *stArr) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
