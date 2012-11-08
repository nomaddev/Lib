//
//  NSDateUtils.m
//  AccountabilityAppNew
//
//  Created by Verve on 13/08/12.
//  Copyright (c) 2012 __Verve Mobile Labs__. All rights reserved.
//

#import "DateUtils.h"

@implementation DateUtils

+(NSDate *) toLocalTime :(NSDate *) dateToBeConverted
{
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: dateToBeConverted];
    return [NSDate dateWithTimeInterval: seconds sinceDate: dateToBeConverted];
}

+(NSDate *) toGlobalTime : (NSDate *) dateToBeConverted
{
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = -[tz secondsFromGMTForDate: dateToBeConverted];
    return [NSDate dateWithTimeInterval: seconds sinceDate: dateToBeConverted];
}

+(NSDate *) toDateFromString : (NSString *) stringToBeConverted {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
//    [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    NSDate *date = [dateFormatter dateFromString:stringToBeConverted ];
    [dateFormatter release];
    return date;
}

+(NSDate *) toDateFromStringWithTimeZone : (NSString *) stringToBeConverted {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    //    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
//    [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    NSDate *date = [dateFormatter dateFromString:stringToBeConverted ];
    [dateFormatter release];
    return date;
}

+(NSString *) toStringFromDateWithoutTimeZone :(NSDate *) dateToBeConverted {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
//    [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    NSString *string = [dateFormatter stringFromDate:dateToBeConverted];
    [dateFormatter release];
    return string;
}

+(NSString *) toDirectStringFromDate : (NSDate *) dateToBeConverted {
    NSString *toBeReturned = @"";
    
    NSArray *strComps = [[dateToBeConverted description] componentsSeparatedByString:@" "];
    toBeReturned = [toBeReturned stringByAppendingFormat:@"%@ %@", [strComps objectAtIndex:0], [strComps objectAtIndex:1]];
    return toBeReturned;
}

+(NSString *) toStringFromDateWithFormat : (NSString *) formatString : (NSDate *) dateToBeConverted {
    //For getting day name of week use @"EEEE" formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    return [dateFormatter stringFromDate:dateToBeConverted];
}

+(int) getDayOfWeekFromDate : (NSDate *) dateToBeConverted {
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:dateToBeConverted];
    return [comps weekday];
}

+(int) getDateOfMonthFromDate : (NSDate *) dateToBeConverted {
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *comps = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:dateToBeConverted];
    return [comps day];
}

+(NSDate *) makeSecondsZeroInDate : (NSDate *) dateToBeConverted {
    NSDate *dateToBeReturned = nil;
    
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *comps = [gregorian components:NSSecondCalendarUnit fromDate:dateToBeConverted];
    
    NSDateComponents *compsToBeAdded = [[NSDateComponents alloc] init];
    [compsToBeAdded setSecond:comps.second * -1];
    
    dateToBeReturned = [gregorian dateByAddingComponents:compsToBeAdded toDate:dateToBeConverted options:0];
    
    return dateToBeReturned;
}

+(NSString *) getNumberOfWeekInWordFromDate : (NSDate *) dateToBeConverted {
//    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
//    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:dateToBeConverted];
    NSString *toBeReturned = @"";
    
    
    switch ([[DateUtils toStringFromDateWithFormat:@"W" :dateToBeConverted] intValue]) {
        case 1:
            toBeReturned = [toBeReturned stringByAppendingString:@"First"];
            break;
            
        case 2:
            toBeReturned = [toBeReturned stringByAppendingString:@"Second"];
            break;
            
        case 3:
            toBeReturned = [toBeReturned stringByAppendingString:@"Third"];
            break;
            
        case 4:
            toBeReturned = [toBeReturned stringByAppendingString:@"Forth"];
            break;
        
        case 5:
            toBeReturned = [toBeReturned stringByAppendingString:@"Fifth"];
            break;
            
        default:
            break;
    }
    return toBeReturned;
}
@end
