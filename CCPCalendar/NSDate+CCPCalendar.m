//
//  NSDate+CCPCalendar.m
//  CCPCalendar
//
//  Created by 储诚鹏 on 17/5/25.
//  Copyright © 2017年 ccp. All rights reserved.
//

#import "NSDate+CCPCalendar.h"

@implementation NSDate (CCPCalendar)

/*------private--------*/

- (NSCalendar *)calendar {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    calendar.timeZone = [NSTimeZone localTimeZone];
    calendar.locale = [NSLocale currentLocale];
    return calendar;
}

- (NSDateComponents *)compts:(NSDate *)date {
    NSDateComponents *dateFormatter = [[self calendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:date];
    return dateFormatter;
}

- (NSDate *)firstDay {
    NSCalendar *clendar = [self calendar];
    NSDateComponents *compts = [self compts:self];
    compts.day = 6;
    NSDate *date = [clendar dateFromComponents:compts];
    return date;
}

/*-------public-----*/

- (NSInteger)firstDay_week {
    NSDate *firstDate = [self firstDay];
    NSDateComponents *compts = [self compts:firstDate];
    return compts.weekday - 1;
}

- (NSDate *)addMonth:(NSInteger)month {
    NSCalendar *clendar = [self calendar];
    NSDateComponents *compts = [self compts:self];
    compts.month += month;
    return [clendar dateFromComponents:compts];
}

- (NSDate *)addYear:(NSInteger)year {
    NSCalendar *clendar = [self calendar];
    NSDateComponents *compts = [self compts:self];
    compts.year += 1;
    return [clendar dateFromComponents:compts];
}

- (NSDate *)addDay:(NSInteger)day {
    NSCalendar *clendar = [self calendar];
    NSDateComponents *compts = [self compts:self];
    compts.day += day;
    return [clendar dateFromComponents:compts];
}

- (NSInteger)dayOfMonth {
    NSCalendar *clendar = [self calendar];
    NSRange days = [clendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return days.length;
}

@end
