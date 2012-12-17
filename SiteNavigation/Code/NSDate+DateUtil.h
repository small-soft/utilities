//
//  NSDate+DateUtil.h
//  AlibabaMobile
//
//  Created by 佳 刘 on 12-8-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

typedef NS_ENUM(NSInteger, NSDateUtilCompareResult)
{
    //0：同一天,1：前一天，2：一周内，3： 一个月内 ，4：一个月前
    NSDateUtilCompareResultSameDay = 0,
    NSDateUtilCompareResultBeforeDay,
    NSDateUtilCompareResultInWeek,
    NSDateUtilCompareResultInMonth,
    NSDateUtilCompareResultOutMonth,
};

#import <Foundation/Foundation.h>

@interface NSDate (DateUtil)

- (int) year;
- (int) month;
- (int) day;

// 可以取得日期的年月日时分秒的集合
- (NSDateComponents *) components;
// 格式化日期，template如@"yyyy-MM-dd HH:mm:ss"
- (NSString *) formate:(NSString *)template;
-(NSString *)getDateStringForTodayYesterday;
+(NSString *)getDateStringForTodayYesterdayWithGmtOccured:(NSNumber*)gmtOccured;
-(NSDateUtilCompareResult)compareWith:(NSDate*)date;
@end
