//
//  CCPCalendarScorllView.m
//  CCPCalendar
//
//  Created by 储诚鹏 on 17/5/27.
//  Copyright © 2017年 ccp. All rights reserved.
//

#import "CCPCalendarScorllView.h"
#import "NSDate+CCPCalendar.h"
#import "CCPCalendarButton.h"
#import "UIView+CCPView.h"

@interface CCPCalendarScorllView()
{
    UIView *v1;
    UIView *v2;
    UIView *v3;
}

@property (nonatomic, strong) NSMutableArray *views;
@property (nonatomic, strong) NSMutableArray *dates;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSArray *showViews;
@property (nonatomic, strong) NSMutableArray *exitTimes;

@end

@implementation CCPCalendarScorllView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        v1 = [[UIView alloc] init];
        v2 = [[UIView alloc] init];
        v3 = [[UIView alloc] init];
        [self addSubview:v1];
        [self addSubview:v2];
        [self addSubview:v3];
        _views = [NSMutableArray array];
        _dates = [NSMutableArray array];
        _selectArr = [NSMutableArray array];
        _showViews = [NSArray array];
        _exitTimes = [NSMutableArray array];
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
        [self addObserver:self forKeyPath:@"direction" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}


- (void)initSub {
    [self getViewArr];
    [self getDates];
    [self setScrViews];
}

- (void)setScrViews {
    NSArray *vs = @[v1,v2,v3];
    [vs enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *subv = self.showViews[idx];
        CGFloat obj_h = [subv getSupH] + 10 * scale_h;
        subv.frame = CGRectMake(0, 0, main_width, obj_h);
        [obj.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [obj addSubview:self.showViews[idx]];
        
        if (idx == 0) {
            obj.frame = CGRectMake(0, 0, main_width, obj_h);
        }
        else {
            UIView *preV = vs[idx - 1];
            obj.frame = CGRectMake(0, CGRectGetMaxY(preV.frame), main_width, obj_h);
        }
    }];
    CGFloat s_h = [self getSupH];
    [self setContentSize:CGSizeMake(main_width, s_h)];
    if (self.manager.isShowPast) {
        CGFloat offY = CGRectGetHeight(v1.frame);
        [self setContentOffset:CGPointMake(0, offY)];
    }
}


- (void) getViewArr {
    __weak typeof(self)ws = self;
    NSDate *date = self.manager.createDate;
    NSMutableArray *mDates = [NSMutableArray array];
    if (!self.manager.isShowPast) {
        for (int i = 0; i < 3; i ++) {
            [mDates addObject:[date addMonth:i]];
        }
    }
    else {
        for (int i = -1; i < 2; i ++) {
            [mDates addObject:[date addMonth:i]];
        }
    }
    [mDates enumerateObjectsUsingBlock:^(NSDate *date, NSUInteger idx, BOOL * _Nonnull stop) {
        [ws.views addObject:[self createDateView:date]];
        [ws.dates addObject:date];
        [ws.exitTimes addObject:date];
    }];
    self.showViews = self.views.copy;
}

- (void)updateViews_past {
    typeof(self)ws = self;
    UIView *btn = self.showViews.firstObject;
    [self.views enumerateObjectsUsingBlock:^(CCPCalendarButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == btn) {
            if (idx > 0) {
                ws.showViews = @[ws.views[idx-1],ws.views[idx],ws.views[idx+1]];

                [self setContentOffset:CGPointMake(0, CGRectGetHeight(v1.frame))];
                [self setScrViews];
            }
        }
    }];
}

- (void)updateViews_future {
    typeof(self)ws = self;
    UIView *btn = self.showViews.lastObject;
    [self.views enumerateObjectsUsingBlock:^(CCPCalendarButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == btn) {
            if (ws.views.count - idx > 1) {
                ws.showViews = @[ws.views[idx-1],ws.views[idx],ws.views[idx+1]];
                [self setContentOffset:CGPointMake(0, CGRectGetHeight(v1.frame))];
                [self setScrViews];
            }
            
        }
    }];
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


- (void)upDate {
    NSDate *date = [self.dates.lastObject addMonth:1];
    [self.dates addObject:date];
}

- (void)downDate {
    NSDate *date = [self.dates[0] addMonth:-1];
    NSMutableArray *mdates = [NSMutableArray array];
    [mdates addObject:date];
    [mdates addObjectsFromArray:self.dates];
    self.dates = mdates.mutableCopy;
}

- (void)getDates {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (self.dates.count < 25) {
            if (self.manager.isShowPast) {
                [self downDate];
            }
            [self upDate];
        }
        [self performSelectorOnMainThread:@selector(addViews) withObject:nil waitUntilDone:NO];
    });
}

- (void)addViews {
    typeof(self)ws = self;
    NSDate *date = self.exitTimes.firstObject;
    NSDate *date1 = self.exitTimes.lastObject;
    NSArray *revserArr = [self.dates reverseObjectEnumerator].allObjects;
    [revserArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL last = [date laterThan:obj];
        if (last) {
            NSLog(@"obj--%@--%@",date,obj);
            NSMutableArray *marr = [NSMutableArray array];
            [marr addObject:[ws createDateView:obj]];
            [marr addObjectsFromArray:ws.views];
            ws.views = marr.mutableCopy;
            NSMutableArray *times = [NSMutableArray array];
            [times addObject:obj];
            [times addObjectsFromArray:ws.exitTimes];
            ws.exitTimes = times.mutableCopy;
            // NSLog(@"cccc");
        }
    }];
    [self.dates enumerateObjectsUsingBlock:^(NSDate *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL future = [obj laterThan:date1];
        
        if (future) {
            [ws.exitTimes addObject:obj];
            [ws.views addObject:[ws createDateView:obj]];
            NSLog(@"1111");
        }
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    id obj = change[NSKeyValueChangeNewKey];
    if ([obj isEqualToString:@"down"]) {
        int y = (int)self.contentOffset.y;
        int h = (int)(self.contentSize.height - self.bounds.size.height);
        if (y == h) {
            [self updateViews_future];
        }
    }
    else {
        if (self.manager.isShowPast) {
            if (self.contentOffset.y == 0) {
                [self updateViews_past];
            }
        }
    }
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
        btn.enabled = NO;
        if (i >= week && i < (count + week_last - 6)) {
            NSString * titleNum = [NSString stringWithFormat:@"%ld",i - week + 1];
            btn.enabled = YES;
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
@end
