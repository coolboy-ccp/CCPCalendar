//
//  CCPCalendarButton.m
//  CCPCalendar
//
//  Created by Ceair on 17/5/25.
//  Copyright © 2017年 ccp. All rights reserved.
//

#import "CCPCalendarButton.h"

@interface CCPCalendarButton()
{
    CGFloat fontSize;
    CAShapeLayer *sl;
}
@end

@implementation CCPCalendarButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        fontSize = 14.0 * scale_w;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self setBackgroundColor:[UIColor clearColor]];
        [self addTarget:self action:@selector(action:event:) forControlEvents:UIControlEventAllTouchEvents];
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize weight:1.0 * scale_w];
    }
    return self;
}

- (void)ccpDispaly {
    [self setTitleColor:self.manager.normal_text_color forState:UIControlStateNormal];
    [self setTitleColor:self.manager.selected_text_color forState:UIControlStateSelected];
    [self setTitleColor:self.manager.disable_text_color forState:UIControlStateDisabled];
    if ([self.date laterThan:self.manager.createDate]) {
        self.enabled = NO;
    }
    else {
        self.enabled = YES;
    }
    if (self.manager.isShowPast) {
        self.enabled = YES;
    }
    [self cirPath];
}

- (void)cirPath {
    CGFloat radius = main_width / 20;
    CGPoint center = CGPointMake(main_width / 14, main_width / 14);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    sl = [CAShapeLayer layer];
    sl.path = path.CGPath;
    sl.lineWidth = 1.0;
    sl.strokeColor = [UIColor clearColor].CGColor;
    sl.fillColor = [UIColor clearColor].CGColor;
    sl.zPosition = -1;
    if ([self.date isSameTo:self.manager.createDate]) {
        NSLog(@"%@-- %@",self.date,self.manager.createDate);
        sl.strokeColor = [UIColor whiteColor].CGColor;
    }
    [self.layer addSublayer:sl];
}

- (void)action:(UIButton *)Bbtn event:(UIEvent *)event {
    UITouchPhase tp = event.allTouches.anyObject.phase;
    if (tp == UITouchPhaseBegan) {
        sl.fillColor = rgba(255, 255, 255, 0.5).CGColor;
    }
    else if (tp == UITouchPhaseEnded) {
        sl.fillColor = [UIColor whiteColor].CGColor;
        Bbtn.selected = YES;
        if (self.manager.click) {
            self.manager.click(self.titleLabel.text,self);
        }
    }
}



@end
