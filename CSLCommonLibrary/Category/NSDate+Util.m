//
//  NSDate+Util.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/19.
//

#import "NSDate+Util.h"
#import <CSLCommonLibrary/NSString+Util.h>

@implementation NSDate (Util)
+ (NSDate *)sl_dateFromString:(NSString *)string {
    if ([NSString emptyString:string]) return nil;
    
    const char *str = [string cStringUsingEncoding:NSUTF8StringEncoding];
    size_t len = strlen(str);
    if (len == 0) return nil;

    struct tm tm;
    char newStr[25] = "";
    BOOL hasTimezone = NO;
    if (len == 20 && str[len - 1] == 'Z') {
        // 2014-03-30T09:13:00Z
        strncpy(newStr, str, len - 1);
    } else if (len == 25 && str[22] == ':') {
        // 2014-03-30T09:13:00-07:00
        strncpy(newStr, str, 19);
        hasTimezone = YES;
    } else if (len == 24 && str[len - 1] == 'Z') {
        // 2014-03-30T09:13:00.000Z
        strncpy(newStr, str, 19);
    } else if (len == 29 && str[26] == ':') {
        // 2014-03-30T09:13:00.000-07:00
        strncpy(newStr, str, 19);
        hasTimezone = YES;
    } else {
        // Poorly formatted timezone
        strncpy(newStr, str, len > 24 ? 24 : len);
    }
    // Timezone
    size_t l = strlen(newStr);
    if (hasTimezone) {
        strncpy(newStr + l, str + len - 6, 3);
        strncpy(newStr + l + 3, str + len - 2, 2);
    } else {
        strncpy(newStr + l, "+0000", 5);
    }
    // Add null terminator
    newStr[sizeof(newStr) - 1] = 0;
    if (strptime(newStr, "%FT%T%z", &tm) == NULL) return nil;

    time_t t;
    t = mktime(&tm);

    return [NSDate dateWithTimeIntervalSince1970:t];
}
+ (NSDate *)sl_gmtDateFromString:(NSString *)string {
    if ([NSString emptyString:string]) return nil;
    
    const char *str = [string cStringUsingEncoding:NSUTF8StringEncoding];
    size_t len = strlen(str);
    if (len == 0) return nil;

    struct tm tm;
    char newStr[25] = "";
    BOOL hasTimezone = NO;
    if (len == 20 && str[len - 1] == 'Z') {
        // 2014-03-30T09:13:00Z
        strncpy(newStr, str, len - 1);
    } else if (len == 25 && str[22] == ':') {
        // 2014-03-30T09:13:00-07:00
        strncpy(newStr, str, 19);
        hasTimezone = YES;
    } else if (len == 24 && str[len - 1] == 'Z') {
        // 2014-03-30T09:13:00.000Z
        strncpy(newStr, str, 19);
    } else if (len == 29 && str[26] == ':') {
        // 2014-03-30T09:13:00.000-07:00
        strncpy(newStr, str, 19);
        hasTimezone = YES;
    } else {
        // Poorly formatted timezone
        strncpy(newStr, str, len > 24 ? 24 : len);
    }
    // Timezone
    size_t l = strlen(newStr);
    if (hasTimezone) {
        strncpy(newStr + l, str + len - 6, 3);
        strncpy(newStr + l + 3, str + len - 2, 2);
    } else {
        strncpy(newStr + l, "+0000", 5);
    }
    // Add null terminator
    newStr[sizeof(newStr) - 1] = 0;
    if (strptime(newStr, "%FT%T%z", &tm) == NULL) return nil;

    time_t t;
    t = timegm(&tm);

    return [NSDate dateWithTimeIntervalSince1970:t];
}
+ (NSString *)sl_gmtStringFromDate:(NSDate *)date {
    struct tm *timeinfo;
    char buffer[80];
    time_t rawtime = (time_t)[date timeIntervalSince1970];
    timeinfo = gmtime(&rawtime);
    strftime(buffer, 80, "%Y-%m-%dT%H:%M:%SZ", timeinfo);
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}
+ (NSString *)sl_stringFromDate:(NSDate *)date {
    struct tm *timeinfo;
    char buffer[80];
    time_t rawtime = (time_t)[date timeIntervalSince1970];
    timeinfo = localtime(&rawtime);
    strftime(buffer, 80, "%Y-%m-%dT%H:%M:%SZ", timeinfo);
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}
+ (time_t)GMTSecond:(NSDate *)date {
    time_t rawtime = (time_t)[date timeIntervalSince1970];
    return rawtime;
}
+ (int)getCurrentHour:(NSDate *)date{
    struct tm *timeinfo;
    time_t rawtime = (time_t)[date timeIntervalSince1970];
    timeinfo = localtime(&rawtime);
    return timeinfo->tm_hour;
}
+ (int)getCurrentMinus:(NSDate *)date{
    struct tm *timeinfo;
    time_t rawtime = (time_t)[date timeIntervalSince1970];
    timeinfo = localtime(&rawtime);
    return timeinfo->tm_min;
}
+ (int)getCurrentSecond:(NSDate *)date{
    struct tm *timeinfo;
    time_t rawtime = (time_t)[date timeIntervalSince1970];
    timeinfo = localtime(&rawtime);
    return timeinfo->tm_sec;
}
+ (NSArray*)getHoursFromBeginTime:(NSString*)beginTime toEndTime:(NSString*)endTime{
    if ([NSString emptyString:beginTime] || [NSString emptyString:endTime]) return @[];
    time_t beginrawtime = (time_t)[[self sl_dateFromString:beginTime] timeIntervalSince1970];
    time_t endrawtime = (time_t)[[NSDate sl_dateFromString:endTime] timeIntervalSince1970];
    struct tm *timeinfo;
    NSMutableArray* resultArray=[[NSMutableArray alloc] initWithCapacity:0];
    char buffer[80];
    while (beginrawtime<=endrawtime) {
        timeinfo = localtime(&beginrawtime);
        strftime(buffer, 80, "%Y-%m-%d %H:%M:%S", timeinfo);
        [resultArray addObject:[NSString stringWithCString:buffer encoding:NSUTF8StringEncoding] ];
        beginrawtime+=3600;
    }
    return resultArray;
}
+ (NSArray*)getDaysFromBeginTime:(NSString*)beginTime toEndTime:(NSString*)endTime{
    if ([NSString emptyString:beginTime] || [NSString emptyString:endTime]) return @[];
    time_t beginrawtime = (time_t)[[self sl_dateFromString:beginTime] timeIntervalSince1970];
    time_t endrawtime = (time_t)[[NSDate sl_dateFromString:endTime] timeIntervalSince1970];
    struct tm *timeinfo;
    NSMutableArray* resultArray=[[NSMutableArray alloc] initWithCapacity:0];
    char buffer[80];
    while (beginrawtime<=endrawtime) {
        timeinfo = localtime(&beginrawtime);
        strftime(buffer, 80, "%Y-%m-%d %H:%M:%S", timeinfo);
        [resultArray addObject:[NSString stringWithCString:buffer encoding:NSUTF8StringEncoding] ];
        beginrawtime+=3600*24;
    }
    return resultArray;
}
+ (NSDate *)dateByAddingDays:(NSInteger)days months:(NSInteger)months years:(NSInteger)years fromData:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = days;
    dateComponents.month = months;
    dateComponents.year = years;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents
                                                         toDate:date
                                                        options:0];
}

+ (NSDate *)dateByAddingDays:(NSInteger)days fromDate:(NSDate *)date {
    return [self dateByAddingDays:days months:0 years:0 fromData:date];
}

+ (NSDate *)dateByAddingMonths:(NSInteger)months fromDate:(NSDate *)date {
    return [self dateByAddingDays:0 months:months years:0 fromData:date];
}

+ (NSDate *)dateByAddingYears:(NSInteger)years fromDate:(NSDate *)date {
    return [self dateByAddingDays:0 months:0 years:years fromData:date];
}

+ (NSDate *)monthStartDate:(NSDate *)data{
    NSDate *monthStartDate = nil;
    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth
                                    startDate:&monthStartDate
                                     interval:NULL
                                      forDate:data];

    return monthStartDate;
}

+ (NSUInteger)numberOfDaysInMonth:(NSDate *)date {
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay
                                              inUnit:NSCalendarUnitMonth
                                             forDate:date].length;
}

+ (NSUInteger)weekday:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:date];
    return [weekdayComponents weekday];
}

+ (NSUInteger)weekdayFromString:(NSString *)dateString {
    if ([NSString emptyString:dateString]) return -1;
    if (dateString.length < 10) return -1;
    NSString* tempString=[NSString stringWithFormat:@"%@ 00:00:00",[dateString substringToIndex:10]];
    struct tm *timeinfo;
    char buffer[80];
    time_t fromRawtime = (time_t)[[NSDate sl_dateFromString:tempString] timeIntervalSince1970];
    timeinfo = localtime(&fromRawtime);
    strftime(buffer, 80, "%u", timeinfo);
    NSString* weekString= [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
    NSInteger result = [weekString integerValue];
    return result >= 7 ? 0 : result - 1;
}

+ (NSInteger)daysFromDate:(NSDate *)date toDate:(NSDate *)toData {
    return [toData timeIntervalSinceDate:date] / (60 * 60 * 24);
}
@end
