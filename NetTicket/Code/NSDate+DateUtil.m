//
//  NSDate+DateUtil.m
//  AlibabaMobile
//
//  Created by 佳 刘 on 12-8-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSDate+DateUtil.h"
@implementation NSDate (DateUtil)

- (NSDateComponents *)components {
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]autorelease]; 
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |  
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;  
    
    return [calendar components:unitFlags fromDate:self];
}

- (int)year {
    return [self components].year;
}

- (int)month {
    return [self components].month;
}

- (int)day {
    return [self components].day;
}

- (NSString *)formate:(NSString *)template {
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]autorelease];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:template];
    //用[NSDate date]可以获取系统当前时间
    return [dateFormatter stringFromDate:self];
}

-(NSString *)getDateStringForTodayYesterday{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSDateComponents *components = [(NSDate*)[[NSDate date] copy] components];
    components.hour= 0;
    components.minute = 0;
    components.second = 0;
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDate * todayZeroHourDate = [calendar dateFromComponents:components];
    
    if ([self timeIntervalSinceDate:todayZeroHourDate]>=0) {
        return [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:self]];
    }else if([self timeIntervalSinceDate:todayZeroHourDate]<0&&[self timeIntervalSinceDate:todayZeroHourDate]>=-24*60*60){
        return [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:self]];
    }else if([self timeIntervalSinceDate:todayZeroHourDate]<-24*60*60&&[self timeIntervalSinceDate:todayZeroHourDate]>=-2*24*60*60){
        return [NSString stringWithFormat:@"前天 %@",[dateFormatter stringFromDate:self]];
    }else {
         return [NSDate getDateStrLong:[self timeIntervalSince1970]];
    }

}

+(NSString *)getDateStringForTodayYesterdayWithGmtOccured:(NSNumber*)gmtOccured{
    NSTimeInterval interval = gmtOccured.doubleValue/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return [date getDateStringForTodayYesterday];
}

+(NSString *) getDateStrLong:(double)timeStr
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSTimeInterval interval = timeStr;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSString * str = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    
    
    return str;
}


-(NSDateUtilCompareResult)compareWith:(NSDate*)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *thatDay = [dateFormatter dateFromString:[dateFormatter stringFromDate:date]];
    
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *yesterday = [[NSDate alloc] initWithTimeInterval:-secondsPerDay sinceDate:thatDay];
    NSDate *inWeekDay = [[NSDate alloc] initWithTimeInterval:-secondsPerDay*7 sinceDate:thatDay];
    NSDate *inMonthDay = [[NSDate alloc] initWithTimeInterval:-secondsPerDay*30 sinceDate:thatDay];

if([self compare:thatDay] >= 0 ){
    return NSDateUtilCompareResultSameDay;
}

if([self compare:yesterday] >= 0){
    return NSDateUtilCompareResultBeforeDay;
}

if([self compare:inWeekDay] >= 0){
    return NSDateUtilCompareResultInWeek;
}
if([self compare:inMonthDay] >= 0){
    return NSDateUtilCompareResultInMonth;
}

return NSDateUtilCompareResultOutMonth;

}
@end
