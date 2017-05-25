//
//  NSDate+CCPDate.m
//  CCPCalendar
//
//  Created by Ceair on 17/5/25.
//  Copyright © 2017年 ccp. All rights reserved.
//

#import "NSDate+CCPDate.h"


@implementation NSDate (CCPDate)

/*----------private------------------*/
- (NSCalendar *)calendar {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    calendar.timeZone = [NSTimeZone localTimeZone];
    calendar.locale = [NSLocale currentLocale];
    return calendar;
}

- (NSDateFormatter *)createDateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [self calendar].timeZone;
    dateFormatter.locale = [self calendar].locale;
    return dateFormatter;
}

- (NSDateComponents *)componets {
    return [NSDateComponents new];
}

- (NSDate *)changeDate {
   return [[self calendar] dateByAddingComponents:self.componets toDate:self options:0];
}

- (NSDateComponents *)currentComponets {
    NSDateComponents *components = [[self calendar] components:NSCalendarUnitYear |NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekOfYear fromDate:self];
    return components;
}

- (NSDate *)changeCurrentDate {
   return [[self calendar] dateFromComponents:[self currentComponets]];
}

/*-------------------public---------------------*/
- (NSDate *_Nonnull)add_month:(NSInteger)month {
    self.componets.month = month;
    return [self changeDate];
}

- (NSDate *_Nonnull)add_week:(NSInteger)week {
    self.componets.day = 7 * week;
    return [self changeDate];
}

- (NSDate *_Nonnull)add_day:(NSInteger)day {
    [self componets].day = day;
    return [self changeDate];
}

- (NSUInteger)weeks_number {
    NSDate *firstDay = [self month_firstDay];
    NSDate *lastDay = [self month_lastDay];
    NSDateComponents *componets_first = [[self calendar] components:NSCalendarUnitWeekOfYear fromDate:firstDay];
    NSDateComponents *componets_last = [[self calendar] components:NSCalendarUnitWeekOfYear fromDate:lastDay];
    return (componets_last.weekOfYear - componets_first.weekOfYear + 52 + 1) % 52;
}

- (NSDate *_Nonnull)month_firstDay {
    [self currentComponets].weekOfMonth = 1;
    [self currentComponets].day = 1;
    return [self changeCurrentDate];
}

- (NSDate *_Nonnull)month_lastDay {
    [self currentComponets].month += 1;
    [self currentComponets].day = 0;
    return [self changeCurrentDate];
}

- (NSDate *_Nonnull)month_firstWeekDay {
    NSDateComponents *components = [[self calendar] components:NSCalendarUnitYear |NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:[self month_firstDay]];
    components.weekday = [self calendar].firstWeekday;
    return [[self calendar] dateFromComponents:components];;
}

- (NSDate *_Nonnull)week_firstWeekDay {
    [self currentComponets].weekday = [self calendar].firstWeekday;
    return [self changeCurrentDate];
}

- (BOOL)same_month:(NSDate * _Nonnull)date {
    NSAssert(self == nil || date == nil, @"date can not be nil");
    NSDateComponents *compA = [self currentComponets];
    NSDateComponents *compB = [[self calendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:date];
    return compA.year == compB.year && compB.month == compA.month;
}

- (BOOL)same_week:(NSDate *)date {
    NSAssert(self == nil || date == nil, @"date can not be nil");
    NSDateComponents *compA = [self currentComponets];
    NSDateComponents *compB = [[self calendar] components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear fromDate:date];
    return compA.year == compB.year && compA.weekOfYear == compB.weekOfYear;
}

- (BOOL)same_day:(NSDate *)date {
    NSAssert(self == nil || date == nil, @"date can not be nil");
    NSDateComponents *compA = [self currentComponets];
    NSDateComponents *compB = [[self calendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    return compA.year==compB.year && compA.month==compB.month && compA.day == compB.day;
}

- (BOOL)before_equel:(NSDate *)date {
     NSAssert(self == nil || date == nil, @"date can not be nil");
    if ([self compare:date] == NSOrderedAscending || [self compare:date] == NSOrderedSame) {
        return YES;
    }
    return NO;
}

- (BOOL)before:(NSDate *)date {
     NSAssert(self == nil || date == nil, @"date can not be nil");
    if ([self compare:date] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

- (BOOL)after:(NSDate *)date {
    if ([self compare:date] == NSOrderedDescending) {
        return YES;
    }
    return NO;
}

- (BOOL)after_equel:(NSDate *)date {
    if ([self compare:date] == NSOrderedDescending || [self compare:date] == NSOrderedSame) {
        return YES;
    }
    return NO;
}

- (BOOL)between:(NSDate *)startDate endDate:(NSDate *)endDate {
    if ([self after:startDate] && [self before:endDate]) {
        return YES;
    }
    return NO;
}

- (BOOL)between_equal:(NSDate *)startDate endDate:(NSDate *)endDate {
    if ([self after_equel:startDate] && [self before_equel:endDate]) {
        return YES;
    }
    return NO;
}
@end
