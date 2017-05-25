//
//  CCPCalendarButton.h
//  CCPCalendar
//
//  Created by Ceair on 17/5/25.
//  Copyright © 2017年 ccp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCPCalendarManager.h"

@interface CCPCalendarButton : UIButton
{
    CGFloat fontSize;
}
@property (nonatomic, strong) CCPCalendarManager *manager;
@end
