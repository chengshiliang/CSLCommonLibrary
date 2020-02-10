//
//  NSDate+Util.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Util)
/**
 字符串转date
 */
+ (NSDate *)sl_dateFromString:(NSString *)string;
/**
date转字符串
*/
+ (NSString *)sl_stringFromDate:(NSDate *)date;
/**
 date转gmt时间格式的字符串
 */
+ (NSString *)sl_gmtStringFromDate:(NSDate *)date;
/**
字符串转gmt 格式 date
*/
+ (NSDate *)sl_gmtDateFromString:(NSString *)string;
/**
 当前时间的总共second
 */
+ (time_t)GMTSecond:(NSDate *)date;
/**
 当前某时
 */
+ (int)getCurrentHour:(NSDate *)date;
/**
 当前某分
 */
+ (int)getCurrentMinus:(NSDate *)date;
/**
 当前某秒
 */
+ (int)getCurrentSecond:(NSDate *)date;
/**
 计算两个时间段之间相隔的小时数
 */
+ (NSArray*)getHoursFromBeginTime:(NSString*)beginTime toEndTime:(NSString*)endTime;
/**
 计算两个时间段之间相隔的天数
 */
+ (NSArray*)getDaysFromBeginTime:(NSString*)beginTime toEndTime:(NSString*)endTime;
/**
 返回date后xx年，xx月，xx天的日期
 */
+ (NSDate *)dateByAddingDays:(NSInteger)days months:(NSInteger)months years:(NSInteger)years fromData:(NSDate *)date;
+ (NSDate *)dateByAddingDays:(NSInteger)days fromDate:(NSDate *)date;
+ (NSDate *)dateByAddingMonths:(NSInteger)months fromDate:(NSDate *)date;
+ (NSDate *)dateByAddingYears:(NSInteger)years fromDate:(NSDate *)date;
/**
 date对应月份开始第一天的日期
 */
+ (NSDate *)monthStartDate:(NSDate *)data;
/**
 date对应月份的天数
 */
+ (NSUInteger)numberOfDaysInMonth:(NSDate *)date;
/**
 date对应的星期
 */
+ (NSUInteger)weekday:(NSDate *)date;
/**
 dateString对应的星期
 */
+ (NSUInteger)weekdayFromString:(NSString *)dateString;
/**
 从date 到 toData经过了多少天
 */
+ (NSInteger)daysFromDate:(NSDate *)date toDate:(NSDate *)toData;
@end

NS_ASSUME_NONNULL_END
