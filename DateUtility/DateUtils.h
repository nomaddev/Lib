//
//  NSDateUtils.h
//  AccountabilityAppNew
//
//  Created by Verve on 13/08/12.
//  Copyright (c) 2012 __Verve Mobile Labs__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtils : NSObject

+(NSDate *) toLocalTime :(NSDate *) dateToBeConverted;
+(NSDate *) toGlobalTime : (NSDate *) dateToBeConverted;
+(NSDate *) toDateFromString : (NSString *) stringToBeConverted;
+(NSString *) toStringFromDateWithoutTimeZone :(NSDate *) dateToBeConverted;
+(NSDate *) toDateFromStringWithTimeZone : (NSString *) stringToBeConverted;
+(NSString *) toStringFromDateWithFormat : (NSString *) formatString : (NSDate *) dateToBeConverted;
+(int) getDayOfWeekFromDate : (NSDate *) dateToBeConverted;
+(int) getDateOfMonthFromDate : (NSDate *) dateToBeConverted;
+(NSString *) getNumberOfWeekInWordFromDate : (NSDate *) dateToBeConverted;
+(NSDate *) makeSecondsZeroInDate : (NSDate *) dateToBeConverted;
+(NSString *) toDirectStringFromDate : (NSDate *) dateToBeConverted;
@end
