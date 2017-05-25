//
//  CCPCalendarManager.m
//  CCPCalendar
//
//  Created by Ceair on 17/5/25.
//  Copyright © 2017年 ccp. All rights reserved.
//

#import "CCPCalendarManager.h"

@implementation CCPCalendarManager

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}


- (NSDate *)createDate {
    if (!_createDate) {
        _createDate = [NSDate date];
    }
    return _createDate;
}

- (UIColor *)disable_text_color {
    if (!_disable_text_color) {
        _disable_text_color = rgba(255.0, 255.0, 255.0, 0.5);
    }
    return _disable_text_color;
}

- (UIColor *)normal_text_color {
    if (!_normal_bg_color) {
        _normal_bg_color = rgba(255.0, 255.0, 255.0, 1.0);
    }
    return _normal_text_color;
}

- (UIColor *)selected_text_color {
    if (!_selected_text_color) {
        _selected_text_color = rgba(1.0, 255.0, 1.0, 1.0);
    }
    return _selected_text_color;
}

- (NSString *)startTitle {
    if (!_startTitle) {
        _startTitle = @"开始\n日期";
    }
    return _startTitle;
}

- (NSString *)endTitle {
    if (!_endTitle) {
        _endTitle = @"结束\n日期";
    }
    return _endTitle;
}
@end
