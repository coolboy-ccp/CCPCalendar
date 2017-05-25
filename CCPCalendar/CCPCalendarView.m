//
//  CCPCalendarView.m
//  CCPCalendar
//
//  Created by Ceair on 17/5/25.
//  Copyright © 2017年 ccp. All rights reserved.
//

#import "CCPCalendarView.h"
#import "CCPCalendarButton.h"
#import "CCPCalendarHeader.h"
#import "CCPCalendarManager.h"
#import "NSDate+CCPCalendar.h"
@interface CCPCalendarView()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;


@end

@implementation CCPCalendarView

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
        _dateFormatter.timeZone = [NSTimeZone localTimeZone];
        _dateFormatter.locale = [NSLocale currentLocale];
    }
    return _dateFormatter;
}

/*
 * 生成一个月的日历
 */
- (void)createDateView:(NSDate *)date {
    NSInteger week = [date firstDay_week];
    NSInteger days = [date dayOfMonth];
    CGFloat w = main_width / 7;
    NSInteger count = week + days;
    for (int i = 0; i < count; i++) {
        NSInteger row = count / 7;
        NSInteger column = i - row * 7;
        NSInteger titleNum = i - week;
        
    }
    
}

@end
