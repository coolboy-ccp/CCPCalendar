//
//  CCPCalendarManager.h
//  CCPCalendar
//
//  Created by Ceair on 17/5/25.
//  Copyright © 2017年 ccp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define main_width  [UIScreen mainScreen].bounds.size.width
#define main_height [UIScreen mainScreen].bounds.size.height

#define rgba(r,g,b,a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]
//相对iphone6布局
#define scale_w main_width / 375.0
#define scale_h main_height / 667.0
/*
 * 日历选择类型
 * 0: 单选
 * 1: 多选
 * 2: 范围选择
 */
typedef NS_ENUM(NSInteger, CCPCalendar_select_type) {
    select_type_single = 0,
    select_type_multiple,
    select_type_range
};

//关闭
typedef void(^closeBlock)(void);
//清除
typedef void(^cleanBlock)(void);
//点击日期
typedef void(^clickBlock)(NSString *dateStr);
//选择完成
typedef void(^completeBlock)(void);

@interface CCPCalendarManager : NSObject
//默认字体颜色
@property (nonatomic, strong) UIColor *normal_text_color;
//无法点击的颜色
@property (nonatomic, strong) UIColor *disable_text_color;
//字体选中颜色
@property (nonatomic, strong) UIColor *selected_text_color;
//选中状态(点击 未放开) 图片名
@property (nonatomic, strong) NSString *touch_img;
//选中状态(点击 放开) 图片名
@property (nonatomic, strong) NSString *touched_img;
//默认背景颜色
@property (nonatomic, strong) UIColor *normal_bg_color;
//选中背景颜色
@property (nonatomic, strong) UIColor *selected_bg_color;
//日历创建的日期
@property (nonatomic, strong) NSDate *createDate;
//日历返回的格式
@property (nonatomic, strong) NSString *backDateFormat;
//开始标题
@property (nonatomic, strong) NSString *startTitle;
//结束标题
@property (nonatomic, strong) NSString *endTitle;

//
@property (copy) closeBlock close;
//
@property (copy) cleanBlock clean;
//
@property (copy) clickBlock click;
//
@property (copy) completeBlock complete;
/*------------private----*/
//日历格式
@property (nonatomic, strong, readonly) NSDateFormatter *dateFormat;

@end
