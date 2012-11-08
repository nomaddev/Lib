//
//  NSString+MyString.m
//  TestCategories
//
//  Created by Verve-1 on 05/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+MyString.h"
#import <Foundation/Foundation.h>

//#define MYLOG(fmt, …) NSLog((@”File [%s] Method [%s] Line [%d]: ” fmt),__FILE__, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

@implementation NSString (MyString)

-(NSString *)MyReverseString
{
    int length = [self length];      
    NSMutableString *reversedString;  
    reversedString = [[NSMutableString alloc] initWithCapacity: length];  
    while (length > 0) {  
        [reversedString appendString:[NSString stringWithFormat:@"%C", [self characterAtIndex:--length]]];  
    }  
    return reversedString; 
}

-(BOOL)MyValidateEmailString
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,5}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    return [emailTest evaluateWithObject:self];
}

-(NSString *) MyStringDateFromDate :(NSDate *) date 
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [df setDateFormat:@"dd/MM/yyyy"];
    return [df stringFromDate:date];
}

-(NSString *) MyStringTimeFromDate :(NSDate *) date 
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];    
//    [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0530"]];
    [df setDateFormat:@"hh:mm aa"];
    return [df stringFromDate:date];
}


- (BOOL)MyHasFloatingPointValue
{
    return [self MyHasFloatingPointValueForLocale:[NSLocale currentLocale]];
}

- (BOOL)MyHasFloatingPointValueForLocale:(NSLocale *)locale
{
    NSString *currencySymbol = [locale objectForKey:NSLocaleCurrencySymbol];
    NSString *decimalSeparator = [locale objectForKey:NSLocaleDecimalSeparator];
    NSString *groupingSeparator = [locale objectForKey:NSLocaleGroupingSeparator];
    
    
    // Must be at least one character
    if ([self length] == 0)
        return NO;
    NSString *compare = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // Strip out grouping separators
    compare = [compare stringByReplacingOccurrencesOfString:groupingSeparator withString:@""];
    
    // We'll allow a single dollar sign in the mix
    if ([compare hasPrefix:currencySymbol])
    {   
        compare = [compare substringFromIndex:1];
        // could be spaces between dollar sign and first digit
        compare = [compare stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
    NSUInteger numberOfSeparators = 0;
    
    NSCharacterSet *validCharacters = [NSCharacterSet decimalDigitCharacterSet];
    for (NSUInteger i = 0; i < [compare length]; i++) 
    {
        unichar oneChar = [compare characterAtIndex:i];
        if (oneChar == [decimalSeparator characterAtIndex:0])
            numberOfSeparators++;
        else if (![validCharacters characterIsMember:oneChar])
            return NO;
    }
    return (numberOfSeparators == 1);
    
}

- (BOOL)MyHasIntegerValue
{
    if ([self length] == 0)
        return NO;
    
    NSString *compare = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSCharacterSet *validCharacters = [NSCharacterSet decimalDigitCharacterSet];
    for (NSUInteger i = 0; i < [compare length]; i++) 
    {
        unichar oneChar = [compare characterAtIndex:i];
        if (![validCharacters characterIsMember:oneChar])
            return NO;
    }
    return YES;
}


- (BOOL)MyIsNumeric
{
    BOOL isValid = NO;
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:self];
    isValid = [alphaNumbersSet isSupersetOfSet:stringSet];
    return isValid;
}


-(BOOL)MyIsEmptyString
{
    NSString *myString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (myString.length == 0)
        return TRUE;
    else
        return FALSE;
}

-(NSString *)MyTrimLeadingAndTrailingWhiteSpaces
{
    NSString *myString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return myString;
}


- (BOOL)MyContainsString:(NSString *)aString
{
    return [self MyContainsString:aString ignoringCase:NO];
}

- (BOOL)MyContainsString:(NSString *)aString ignoringCase:(BOOL)flag
{
    unsigned mask = (flag ? NSCaseInsensitiveSearch : NSLiteralSearch);
    NSRange range = [self rangeOfString:aString options:mask];
    return (range.length > 0);
}


- (NSString *) MyInverseCapitalisationString

{
    // This is a quick hack to convert upper case letters to lowercase, and vice versa
    // It uses the standard C character manipulation functions so it will obviously not
    // work on anything other than basic ASCII strings.
    
    // get the length of the string that is to be manipulated
    int len = [self length];
    
    // create a string to hold our modified text
    NSMutableString *capitalisedString = [NSMutableString stringWithCapacity:len];
    
    // iterate over the original string, pulling out each character for inspection
    for (int i = 0; i < len; i++)
    {
        // get the next character in the original string
        char ch = [self characterAtIndex:i];
        
        // convert upper-case to lower-case, and lower-case to upper-case
        if (isupper(ch))
        {
            ch = tolower(ch);
        }
        else if (islower(ch))
        {
            ch = toupper(ch);
        }
        
        // append the manipulated character to the modified string
        [capitalisedString appendString:[NSString stringWithFormat:@"%c", ch]];
    }
    
    // return the newly modified string
    return capitalisedString;
}


@end
