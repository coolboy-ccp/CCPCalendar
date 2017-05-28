//
//  CCPCalendarScorllView.h
//  CCPCalendar
//
//  Created by 储诚鹏 on 17/5/27.
//  Copyright © 2017年 ccp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCPCalendarManager.h"

@interface CCPCalendarScorllView : UIScrollView
@property (nonatomic, strong) CCPCalendarManager *manager;
@property (nonatomic, strong) NSString *direction;

- (void)initSub;

@end
