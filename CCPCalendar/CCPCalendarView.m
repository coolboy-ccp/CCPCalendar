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
#import "NSDate+CCPCalendar.h"
#import "UIView+CCPView.h"
#import "CCPCalendarModel.h"
@interface CCPCalendarView()
{
    CGFloat bottomH;
    //底部按钮
    UIButton *saveBtn;
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
    [self createAScrDate];
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

/*
 * 生成一个月的日历
 */
- (UIView *)createDateView:(NSDate *)date {
    UIView *dateSupV = [[UIView alloc] init];
    CGFloat t_gap = 15 * scale_h;
    CGFloat l_gap = 25 * scale_w;
    CGFloat label_h = 24 * scale_h;
    UILabel *bigLabel = [[UILabel alloc] init];
    NSString *label_text;
    if ([date getYear]==[self.manager.createDate getYear]) {
        label_text = [NSString stringWithFormat:@"%ld月",(long)[date getMonth]];
    }
    else {
        label_text = [NSString stringWithFormat:@"%ld年%ld月",(long)[date getYear],(long)[date getMonth]];
    }
    bigLabel.text = label_text;
    bigLabel.backgroundColor = [UIColor clearColor];
    CGFloat label_w = [bigLabel widthBy:label_h];
    bigLabel.frame = CGRectMake(l_gap, t_gap, label_w, label_h);
    bigLabel.textColor = [UIColor whiteColor];
    [dateSupV addSubview:bigLabel];
    NSInteger week = [date firstDay_week];
    NSInteger week_last = [date lastDay_week];
    NSInteger days = [date dayOfMonth];
    CGFloat w = main_width / 7;
    NSInteger count = week + days + 6 - week_last;
    NSInteger h = count / 7;
    if (count % 7 > 0) {
        h += 1;
    }
    for (int i = 0; i < count; i++) {
        NSInteger row = i / 7;
        NSInteger column = i - row * 7;
        CCPCalendarButton *btn = [[CCPCalendarButton alloc] initWithFrame:CGRectMake(column * w, row * w + CGRectGetMaxY(bigLabel.frame) + 10 * scale_h, w, w)];
        NSString *ym = [NSString stringWithFormat:@"%ld%02ld%02d",[date getYear],[date getMonth],i];
        btn.tag = [ym integerValue];
        btn.date = [date changToDay:i - week + 1];
        btn.manager = self.manager;
        if (i >= week && i < (count + week_last - 6)) {
           NSString * titleNum = [NSString stringWithFormat:@"%ld",i - week + 1];
            [self manageClick];
            [btn ccpDispaly];
            [btn setTitle:titleNum forState:UIControlStateNormal];
        }
        [btn addObesers];
        [dateSupV addSubview:btn];
    }
    dateSupV.backgroundColor = [UIColor clearColor];
    [self managerClean];
    return dateSupV;
}

//清除
- (void)managerClean {
    __weak typeof(self)ws = self;
    self.manager.clean = ^() {
        ws.manager.startTitle = ws.manager.endTitle = nil;
        ws.manager.startTag = ws.manager.endTag = 0;
        for (CCPCalendarButton *btn in ws.selectArr) {
            btn.manager = ws.manager;
            btn.selected = NO;
        }
        [ws.selectArr removeAllObjects];
    };
}

//按钮点击
- (void)manageClick {
    __weak typeof(self)ws = self;
    __weak typeof(saveBtn)wsBtn = saveBtn;
    self.manager.click = ^(NSString *str, UIButton *abtn) {
        if (ws.manager.selectType == 0) {
            if (ws.selectArr.count > 0) {
                UIButton *lastBtn = ws.selectArr.firstObject;
                if (abtn == lastBtn) {
                    return;
                }
                lastBtn.selected = NO;
                [ws.selectArr removeAllObjects];
            }
            wsBtn.enabled = YES;
        }
        else if (ws.manager.selectType == 1) {
            if (ws.selectArr.count > 1) {
                for (UIButton *lastBtn in ws.selectArr) {
                    lastBtn.selected = NO;
                }
                [ws.selectArr removeAllObjects];
                ws.manager.endTag = ws.manager.startTag = 0;
            }
            else if (ws.selectArr.count > 0) {
                UIButton *lastBtn = ws.selectArr.firstObject;
                CCPCalendarButton *ccpBtn1 = (CCPCalendarButton *)lastBtn;
                CCPCalendarButton *ccpBtn2 = (CCPCalendarButton *)abtn;
                if (ccpBtn1 == ccpBtn2) {
                    return;
                }
                if (![ccpBtn1.date laterThan:ccpBtn2.date]) {
                    ccpBtn1.selected = NO;
                    [ws.selectArr removeObject:ccpBtn1];
                }
                else {
                    ws.manager.startTag = ccpBtn1.tag;
                    ws.manager.endTag = ccpBtn2.tag;
                    wsBtn.enabled = YES;
                }
            }
        }
        [ws.manager.selectArr removeAllObjects];
        [ws.selectArr addObject:abtn];
        for (CCPCalendarButton *obj in ws.selectArr) {
            [[ws.manager mutableArrayValueForKey:@"selectArr"] addObject:obj.date];
        }
    };
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

- (void)createAScrDate {
    UIScrollView *scr = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), main_width, main_height - bottomH - CGRectGetMaxY(self.headerView.frame))];
    scr.backgroundColor = [UIColor clearColor];
    [self addSubview:scr];
    NSArray *views = [self getViewArr];
    __block CGFloat scrH = 0;
    [views enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            obj.frame = CGRectMake(0, 0, main_width, [obj getSupH] + 10 * scale_h);
        }
        else {
            UIView *preView = views[idx - 1];
            obj.frame = CGRectMake(0, CGRectGetMaxY(preView.frame), main_width, [obj getSupH] + 10 * scale_h);
        }
        if (self.manager.isShowPast) {
            NSInteger a = views.count / 2;
            if (idx == a - 1) {
                scrH = CGRectGetMaxY(obj.frame);
            }
        }
        [scr addSubview:obj];
    }];
    CGFloat contentH = [scr getSupH];
    [scr setContentSize:CGSizeMake(main_width, contentH)];
    scr.bounces = NO;
    scr.showsVerticalScrollIndicator = NO;
    [scr setContentOffset:CGPointMake(0, scrH)];
}

- (NSArray *)getViewArr {
    NSDate *date = self.manager.createDate;
    NSMutableArray *mDates = [NSMutableArray array];
    NSMutableArray *views = [NSMutableArray array];
    for (int i = -12; i < 13; i ++) {
        if (self.manager.isShowPast) {
            [mDates addObject:[date addMonth:i]];
        }
        else {
            if (i >= 0) {
                [mDates addObject:[date addMonth:i]];
            }
        }
    }
    [mDates enumerateObjectsUsingBlock:^(NSDate *date, NSUInteger idx, BOOL * _Nonnull stop) {
        [views addObject:[self createDateView:date]];
    }];
    return views;
}


@end
