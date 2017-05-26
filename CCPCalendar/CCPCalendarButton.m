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
    CALayer *lay;
    CALayer *sLay;
    CALayer *eLay;
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
        [self lay];
        
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
    [self addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"manager.endDate" options:(NSKeyValueObservingOptionNew) context:nil];
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
    sl.bounds = self.bounds;
    sl.position = center;
    [sl setAnchorPoint:CGPointMake(0.5, 0.5)];
    if ([self.date isSameTo:self.manager.createDate]) {
        sl.strokeColor = [UIColor whiteColor].CGColor;
    }
    [self.layer addSublayer:sl];
}

- (void)action:(UIButton *)Bbtn event:(UIEvent *)event {
    UITouchPhase tp = event.allTouches.anyObject.phase;
    if (tp == UITouchPhaseBegan) {
        sl.fillColor = rgba(255, 255, 255, 0.5).CGColor;
        sl.transform = CATransform3DMakeScale(1.2, 1.2, 1.0);
    }
    else if (tp == UITouchPhaseEnded) {
        sl.transform = CATransform3DIdentity;
        Bbtn.selected = YES;
        if (self.manager.click) {
            self.manager.click(self.titleLabel.text,self);
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    id obj = change[NSKeyValueChangeNewKey];
    if ([keyPath isEqualToString:@"selected"]) {
        if ([obj boolValue]) {
            sl.fillColor = [UIColor whiteColor].CGColor;
        }
        else {
            sl.fillColor = [UIColor clearColor].CGColor;
        }
    }
    else if ([keyPath isEqualToString:@"manager.endDate"]) {
        if (self.manager.endDate) {
            if ([self.date isSameTo:self.manager.endDate]) {
                [self eLay];
            }
            else if ([self.date isSameTo:self.manager.startDate]) {
                [self sLay];
            }
            else {
                if (![self.date laterThan:self.manager.startDate] && ![self.manager.endDate laterThan:self.date]) {
                    [self lay];
                }
            }
        }
        else {
            [lay removeFromSuperlayer];
            [sLay removeFromSuperlayer];
            [eLay removeFromSuperlayer];
        }
    }
}

- (void)lay {
    if (!lay) {
        lay = [CALayer layer];
        lay.bounds = CGRectMake(0, 0, main_width / 7, main_width / 10);
        lay.position = CGPointMake(0, main_width * 3 / 140);
        lay.anchorPoint = CGPointMake(0, 0);
        lay.zPosition = -1;
        lay.backgroundColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:lay];
    }
}

- (void)sLay {
    if (!sLay) {
        sLay = [CALayer layer];
        sLay.bounds = CGRectMake(0, 0, main_width / 14, main_width / 10);
        sLay.position = CGPointMake(main_width / 14, main_width / 14);
        sLay.anchorPoint = CGPointMake(0, 0.5);
        sLay.zPosition = -1;
        sLay.backgroundColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:sLay];
    }
}

- (void)eLay {
    if (!eLay) {
        eLay = [CALayer layer];
        eLay.bounds = CGRectMake(0, 0, main_width / 14, main_width / 10);
        eLay.position = CGPointMake(0, main_width / 14);
        eLay.anchorPoint = CGPointMake(0, 0.5);
        eLay.zPosition = -1;
        eLay.backgroundColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:eLay];
    }
}


@end
