//
//  NSDate+CCPDate.h
//  CCPCalendar
//
//  Created by Ceair on 17/5/25.
//  Copyright © 2017年 ccp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CCPDate)

//+月
- (NSDate *_Nonnull)add_month:(NSInteger)month;
//+星期
- (NSDate *_Nonnull)add_week:(NSInteger)week;
//+天
- (NSDate *_Nonnull)add_day:(NSInteger)day;
//
- (NSUInteger)weeks_number;
//当月第一天
- (NSDate *_Nonnull)month_firstDay;
//当月第一周是周几
- (NSDate *_Nonnull)month_firstWeekDay;
//当月第一周
- (NSDate *_Nonnull)week_firstWeekDay;
//当月最后一天
- (NSDate *_Nonnull)month_lastDay;

- (BOOL)same_month:(NSDate *_Nonnull)date;
- (BOOL)same_week:(NSDate *_Nonnull)date;
- (BOOL)same_day:(NSDate *_Nonnull)date;

- (BOOL)before:(NSDate *_Nonnull)date;
- (BOOL)before_equel:(NSDate *_Nonnull)date;
- (BOOL)after:(NSDate *_Nonnull)date;
- (BOOL)after_equel:(NSDate *_Nonnull)date;

- (BOOL)between:(NSDate *_Nonnull)startDate endDate:(NSDate *_Nonnull)endDate;
- (BOOL)between_equal:(NSDate *_Nonnull)startDate endDate:(NSDate *_Nonnull)endDate;


@end
