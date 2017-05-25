//
//  CCPCalendarButton.m
//  CCPCalendar
//
//  Created by Ceair on 17/5/25.
//  Copyright © 2017年 ccp. All rights reserved.
//

#import "CCPCalendarButton.h"

@implementation CCPCalendarButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        fontSize = 14.0 * scale_w;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self setBackgroundColor:[UIColor clearColor]];
        [self setTitleColor:self.manager.normal_text_color forState:UIControlStateNormal];
        [self setTitleColor:self.manager.selected_text_color forState:UIControlStateSelected];
        [self setTitleColor:self.manager.disable_text_color forState:UIControlStateDisabled];
        [self setImage:[UIImage imageNamed:self.manager.touched_img] forState:UIControlStateSelected];
        [self addTarget:self action:@selector(action:event:) forControlEvents:UIControlEventAllTouchEvents];
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize weight:1.0 * scale_w];
    }
    return self;
}


- (void)action:(UIButton *)Bbtn event:(UIEvent *)event {
    UITouchPhase tp = event.allTouches.anyObject.phase;
    if (tp == UITouchPhaseBegan) {
        
    }
    else if (tp == UITouchPhaseEnded) {
        if (self.manager.click) {
            self.manager.click(self.titleLabel.text);
        }
    }
}



@end
