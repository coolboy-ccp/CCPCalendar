//
//  CCPCalendarHeader.m
//  CCPCalendar
//
//  Created by Ceair on 17/5/25.
//  Copyright © 2017年 ccp. All rights reserved.
//

#import "CCPCalendarHeader.h"
#import "UIView+CCPView.h"


@interface CCPCalendarHeader()
{
    /*
     * l_gap,r_gap 左右距离
     * big_l_gap,big_r_gap 大字左右距离
     * t_gap 上方间距
     */
    CGFloat l_gap,r_gap,big_l_gap,big_r_gap,t_gap;
    
    UIButton *l_btn,*r_btn;
    UILabel *l_label, *r_label;
}
@end

@implementation CCPCalendarHeader

- (instancetype)init {
    if (self = [super init]) {
        l_gap = r_gap = scale_w * 20.0;
        big_l_gap = big_r_gap = scale_w * 25.0;
        t_gap = scale_h * 15;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)initSubviews {
    [self functionBtns];
    [self showSelect];
    [self weeks];
    [self line];
    CGFloat h = [self getSupH];
    UIView *bLine = [[UIView alloc] initWithFrame:CGRectMake(0, h, main_width, 1)];
    bLine.backgroundColor = rgba(255, 255, 255, 0.6);
    [self addSubview:bLine];
}

/*
 * 最上方按钮
 */
- (void)functionBtns {
    l_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [l_btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [l_btn setTitle:@"cancle" forState:UIControlStateNormal];
    l_btn.frame = CGRectMake(l_gap, t_gap, scale_w * 25, scale_w * 25);
    [l_btn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:l_btn];
    r_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [r_btn setTitle:@"clear" forState:UIControlStateNormal];
    r_btn.titleLabel.font = [UIFont systemFontOfSize:14.0 * scale_w weight:1.0 * scale_w];
    r_btn.titleLabel.textColor = [UIColor whiteColor];
    [r_btn addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    r_btn.frame = CGRectMake(main_width - r_gap - [self r_btn_w], t_gap, [self r_btn_w], scale_w * 25);
    [self addSubview:r_btn];
}

//中间显示大字
- (void)showSelect {
    l_label = [[UILabel alloc] init];
    l_label.font = [UIFont systemFontOfSize:scale_w * 20];
    l_label.textColor = [UIColor whiteColor];
    l_label.textAlignment = NSTextAlignmentLeft;
    l_label.numberOfLines = 2;
    [self addSubview:l_label];
    r_label = [[UILabel alloc] init];
    r_label.font = l_label.font;
    r_label.textColor = [UIColor whiteColor];
    r_label.textAlignment = NSTextAlignmentRight;
    r_label.numberOfLines = 2;
    [self addSubview:r_label];
    [self displayLabel];
}

//星期
- (void)weeks {
    NSArray *arr = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    CGFloat w = main_width / 7;
    CGFloat y;
    for (NSString *week in arr) {
        NSInteger idx = [arr indexOfObject:week];
        UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(w * idx , CGRectGetMaxY(r_label.frame) + 15 * scale_h, w, 25 * scale_h)];
        y = CGRectGetMaxY(weekLabel.frame);
        weekLabel.textAlignment = NSTextAlignmentCenter;
        weekLabel.font = [UIFont systemFontOfSize:14 * scale_h];
        weekLabel.textColor = [UIColor whiteColor];
        weekLabel.text = week;
        [self addSubview:weekLabel];
    }
//    UIView *line = [UIView alloc] initWithFrame:CGRectMake(0, y, main_width, <#CGFloat height#>);
}

//中间斜线
- (void)line {
    CGFloat distance = 25 * scale_w;
    CGFloat centerX = main_width / 2;
    CGPoint startP = CGPointMake(centerX - distance, CGRectGetMaxY(l_label.frame) - 5);
    CGPoint endP = CGPointMake(centerX + distance, CGRectGetMinY(r_label.frame) + 5);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startP];
    [path addLineToPoint:endP];
    CAShapeLayer *shapeL = [CAShapeLayer layer];
    shapeL.path = path.CGPath;
    shapeL.strokeColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:shapeL];
}

- (CGFloat)r_btn_w {
    NSString *tt = r_btn.titleLabel.text;
    CGRect rect = [tt boundingRectWithSize:CGSizeMake(1000, 25 * scale_w) options:NSStringDrawingUsesFontLeading attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:14 * scale_w weight:1.0 * scale_w]} context:nil];
    return rect.size.width;
}

- (void)displayLabel {
    CGFloat top = 15 * scale_h;
    CGFloat h = 48 * scale_h;
    if (![self.manager.startTitle isEqualToString:l_label.text]) {
        l_label.text = self.manager.startTitle;
        CGFloat w = [l_label widthBy:h];
        l_label.frame = CGRectMake(big_l_gap, CGRectGetMaxY(l_btn.frame) + top, w, h);
    }
    if (![self.manager.endTitle isEqualToString:r_label.text]) {
        r_label.text = self.manager.endTitle;
        CGFloat w = [r_label widthBy:h];
        r_label.frame = CGRectMake(main_width - big_r_gap - w, CGRectGetMaxY(l_btn.frame) + top, w, h);
    }
}

- (void)close {
    if (self.manager.close) {
        self.manager.close();
    }
}

- (void)clear {
    if (self.manager.clean) {
        self.manager.clean();
    }
}



@end
