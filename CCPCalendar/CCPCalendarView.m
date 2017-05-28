//
//  CCPCalendarView.m
//  CCPCalendar
//
//  Created by Ceair on 17/5/25.
//  Copyright © 2017年 ccp. All rights reserved.
//

#import "CCPCalendarView.h"
#import "CCPCalendarHeader.h"
#import "NSDate+CCPCalendar.h"
#import "UIView+CCPView.h"
#import "CCPCalendarModel.h"
#import "CCPCalendarScorllView.h"

@interface CCPCalendarView()<UIScrollViewDelegate>
{
    CGFloat bottomH;
    //底部按钮
    UIButton *saveBtn;
    CCPCalendarScorllView *scr;
    CGFloat scrStart;

}
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) CCPCalendarHeader *headerView;
@property (nonatomic, strong) NSMutableArray *selectArr;
@end

@implementation CCPCalendarView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor orangeColor];
        self.selectArr = [NSMutableArray array];
    }
    return self;
}

- (void)initSubviews {
    NSCAssert(self.manager, @"manager不可为空");
    [self headerView];
    [self createBottomView];
    [self createScr];
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
        _dateFormatter.timeZone = [NSTimeZone localTimeZone];
        _dateFormatter.locale = [NSLocale currentLocale];
    }
    return _dateFormatter;
}

- (CCPCalendarHeader *)headerView {
    if (!_headerView) {
        _headerView = [[CCPCalendarHeader alloc] init];
        _headerView.manager = self.manager;
        [_headerView initSubviews];
        CGFloat h = [_headerView getSupH];
        _headerView.frame = CGRectMake(0, 0, main_width, h);
        [self addSubview:_headerView];
    }
    return _headerView;
}



- (void)compelet {
    if (self.manager.complete) {
        NSMutableArray *marr = [NSMutableArray array];
        for (NSDate *date in self.manager.selectArr) {
            NSString *year = [NSString stringWithFormat:@"%ld",[date getYear]];
            NSString *month = [NSString stringWithFormat:@"%02ld",[date getMonth]];
            NSString *day = [NSString stringWithFormat:@"%02ld",[date getDay]];
            NSString *weekString = [date weekString];
            NSInteger week = [date getWeek];
            NSString *ccpDate = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
            NSArray *arr = @[ccpDate,year,month,day,weekString,@(week)];
            CCPCalendarModel *model = [[CCPCalendarModel alloc] initWithArray:arr];
            [marr addObject:model];
        }
        self.manager.complete(marr);
        if (self.manager.close) {
            self.manager.close();
        }
    }
    
}

/*
 * 底部
 */
- (void)createBottomView {
    CGFloat l_gap = 20 * scale_w;
    CGFloat t_gap = 15 * scale_h;
    CGFloat btnH = 50 * scale_h;
    UIView *bottomV = [[UIView alloc] init];
    bottomV.backgroundColor = [UIColor clearColor];
    saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.enabled = NO;
    saveBtn.backgroundColor = rgba(255, 255, 255, 0.4);
    saveBtn.frame = CGRectMake(l_gap, t_gap, main_width - 2 * l_gap, btnH);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitle:@"保存" forState:UIControlStateDisabled];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setTitleColor:rgba(255, 255, 255, 0.7) forState:UIControlStateDisabled];
    saveBtn.layer.cornerRadius = 5 * scale_w;
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:20 * scale_h];
    [saveBtn addTarget:self action:@selector(compelet) forControlEvents:UIControlEventTouchUpInside];
    [bottomV addSubview:saveBtn];
    CGFloat H = bottomH = [bottomV getSupH] + t_gap;
    bottomV.frame = CGRectMake(0, main_height - H, main_width, H);
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, main_width, 1.0)];
    line.backgroundColor = rgba(255, 255, 255, 0.6);
    [bottomV addSubview:line];
    [self addSubview:bottomV];
    
}

- (void)createScr {
    scr = [[CCPCalendarScorllView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), main_width, main_height - bottomH - CGRectGetMaxY(self.headerView.frame))];
    scr.delegate = self;
    scr.manager = self.manager;
    [scr initSub];
    [self addSubview:scr];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    scrStart = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrStart - scrollView.contentOffset.y > 0) {
        scr.direction = @"up";
    }
    else {
        scr.direction = @"down";
    }
}



@end
