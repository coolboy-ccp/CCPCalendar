//
//  CCPCalendarManager.m
//  CCPCalendar
//
//  Created by Ceair on 17/5/25.
//  Copyright © 2017年 ccp. All rights reserved.
//

#import "CCPCalendarManager.h"
#import "CCPCalendarView.h"
#import "AppDelegate.h"

@interface CCPCalendarManager()
{
    CCPCalendarView *av;
}

@end

@implementation CCPCalendarManager

- (instancetype)init {
    if (self = [super init]) {
        self.isShowPast = YES;
    }
    return self;
}

- (UIWindow *)appWindow {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.window;
}

- (void)av {
    if (!av) {
        av = [[CCPCalendarView alloc] init];
        av.frame = CGRectMake(0, main_height, main_width, main_height);
        av.manager = self;
        [av initSubviews];
        av.alpha = 0.0;
        [[self appWindow] addSubview:av];
    }
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        av.alpha = 1.0;
        av.frame = CGRectMake(0, 0, main_width, main_height);
    } completion:nil];
}

- (closeBlock)close {
    __weak typeof(av)weekAV = av;
    if (!_close) {
        _close = ^() {
            [UIView animateWithDuration:.35 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                weekAV.frame = CGRectMake(0, main_height, main_width, main_height);
                weekAV.alpha = 0.0;
            } completion:nil];
        };
    }
    return _close;
}

//单选有过去
- (void)show_signal_past {
    self.isShowPast = YES;
    [self av];
}

//多选有过去
- (void)show_mutil_past {
    self.isShowPast = YES;
    self.selectType = select_type_multiple;
    [self av];
}
//单选没有过去
- (void)show_signal {
    self.isShowPast = NO;
    [self av];
    
}
//多选没有过去
- (void)show_mutil {
    self.isShowPast = NO;
    self.selectType = select_type_multiple;
    [self av];
}


- (NSDate *)createDate {
    if (!_createDate) {
        _createDate = [NSDate date];
    }
    return _createDate;
}

- (UIColor *)disable_text_color {
    if (!_disable_text_color) {
        _disable_text_color = rgba(255.0, 255.0, 255.0, 0.7);
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
