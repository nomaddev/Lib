//
//  NSString+MyString.h
//  TestCategories
//
//  Created by Verve-1 on 05/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MyString)

- (NSString *)MyReverseString;
- (BOOL)MyValidateEmailString;
- (NSString *) MyStringDateFromDate :(NSDate *) date ;
- (NSString *) MyStringTimeFromDate :(NSDate *) date ;
- (BOOL)MyHasFloatingPointValue ;
- (BOOL)MyHasFloatingPointValueForLocale:(NSLocale *)locale ;
- (BOOL)MyHasIntegerValue ;
- (BOOL)MyIsNumeric;
- (BOOL)MyIsEmptyString ;
- (NSString *)MyTrimLeadingAndTrailingWhiteSpaces ;
- (BOOL)MyContainsString:(NSString *)aString ;
- (BOOL)MyContainsString:(NSString *)aString ignoringCase:(BOOL)flag ;
- (NSString *) MyInverseCapitalisationString;
@end
