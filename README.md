# CCPCalendar
A simple calendar
step:
1、#import "CCPCalendarManager.h"
2、[CCPCalendarManager show_signal_past:^(NSArray *stArr) {
        
    }];
Support 4 styles calendar,
single,single_past(show past date),mutil,mutil_past
3、The block 'complete' give an array for you.
Each element of the array is a CCPCalendarModel.
4、Use '[obj valueForKey:@"key"]' to get what you want.
5、The project with an demo.
