//
//  UIView+CCPView.m
//  CCPCalendar
//
//  Created by Ceair on 17/5/26.
//  Copyright © 2017年 ccp. All rights reserved.
//

#import "UIView+CCPView.h"

@implementation UIView (CCPView)

//得到父视图高度
- (CGFloat)getSupH {
    NSMutableArray *svHs = [NSMutableArray array];
    for (UIView *sv in self.subviews) {
        [svHs addObject:@(CGRectGetMaxY(sv.frame))];
    }
    CGFloat max = [[svHs valueForKeyPath:@"@max.doubleValue"] floatValue];
    return max;
}

@end
