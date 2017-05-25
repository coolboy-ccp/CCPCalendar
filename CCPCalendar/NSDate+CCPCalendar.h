//
//  NSDate+CCPCalendar.h
//  CCPCalendar
//
//  Created by 储诚鹏 on 17/5/25.
//  Copyright © 2017年 ccp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CCPCalendar)
- (NSInteger)firstDay_week;
- (NSDate *)addMonth:(NSInteger)month;
- (NSDate *)addYear:(NSInteger)year;
- (NSDate *)addDay:(NSInteger)day;
- (NSInteger)dayOfMonth;
@end
