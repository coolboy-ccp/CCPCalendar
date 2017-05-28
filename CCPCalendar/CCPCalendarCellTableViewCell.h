//
//  CCPCalendarCellTableViewCell.h
//  CCPCalendar
//
//  Created by 储诚鹏 on 17/5/28.
//  Copyright © 2017年 ccp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCPCalendarManager.h"

@interface CCPCalendarCellTableViewCell : UITableViewCell
@property (nonatomic, strong) CCPCalendarManager *manager;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSDate *date;
@end
