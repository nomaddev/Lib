//
//  WebServices.m
//  ReadyScore
//
//  Created by Verve-1 on 21/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebServices.h"
#import "Reachability.h"
#import "CustomBlackAlert.h"
#import "SBJSON.h"

@interface WebServices()
- (BOOL) validateUrl: (NSString *) candidate;
- (BOOL) isNetworkAvailable;
@end

@implementation WebServices
@synthesize wsDelegate;
-(void)kCleanUp
{
    [strUrl release];
    strUrl = Nil;
    strUrl = [[NSMutableString alloc] init];
    [request release];
    request = Nil;
    request = [[NSMutableURLRequest alloc] init];
}

-(NSString *)kFireCallByString
{       
    if (![self isNetworkAvailable]) {
        [CustomBlackAlert showMessageBoxWithButton:@"Alert" Message:@"No Network Connection" Button:@"Ok" alertViewDelegate:self];
        return @"No Network Connection";
    }
    if ([strUrl length] > 0) {
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"Actual response :: %@", json_string);
        if ([json_string length] <= 0) {
            return NULL;
        }else{
            return json_string;
        }
    }
    return @"Done";
}


-(NSMutableArray *)kFireCallByArray
{
    if (![self isNetworkAvailable]) {
        [CustomBlackAlert hideAlert];
        [CustomBlackAlert showMessageBoxWithButton:@"Alert" Message:@"No Network Connection" Button:@"Ok" alertViewDelegate:self];
        NSLog(@"No Network Connection");
    }
    
    if ([strUrl length] > 0) {
        SBJSON *parser = [[SBJSON alloc] init];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"Actual response :: %@", json_string);
        NSMutableArray *statuses = [parser objectWithString:json_string error:nil];
        if (statuses != NULL) {
            return statuses;
        } else if ([json_string isEqualToString:@"true"]) {
            return [NSMutableArray arrayWithObject:@"true"];
        }
        
    }
    return NULL;
}


-(void)kFireCallByArrayThread
{
   [NSThread detachNewThreadSelector:@selector(makeCallInThread) toTarget:self withObject:nil];
}

-(void) makeCallInThread {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    if (![self isNetworkAvailable]) {
        if (wsDelegate != nil) {
            [wsDelegate internetNotAvailable:@"internet not available"];
        }
        NSLog(@"No Network Connection");
    } else if ([strUrl length] > 0) {
        SBJSON *parser = [[SBJSON alloc] init];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"Actual response :: %@", json_string);
        NSMutableArray *statuses = [parser objectWithString:json_string error:nil];
        if (statuses != NULL) {
            if (self.wsDelegate != nil) {
                [self.wsDelegate successCallBackWithResult:statuses forMethod:strUrl];
            }
            //            return statuses;
        } else if ([json_string isEqualToString:@"true"]) {
            if (self.wsDelegate != nil) {
                [self.wsDelegate successCallBack:json_string];
            }
            //            return [NSMutableArray arrayWithObject:@"true"];
        } else {
            if (self.wsDelegate != nil) {
                [self.wsDelegate failureCallBack:@"NO"];
            }
        }
        
    }
        [pool release];
}


-(NSString *)kPrepareWithUrl:(NSString *)url;
{
    if ([url length] <= 0) {
        return @"No Url found";
    }
    strUrl = [[NSMutableString alloc] initWithString:url];
    request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[strUrl description]]];
    return @"Done Url";
}

-(NSString *)kParameterWithKey:(NSArray *)key withValue:(NSArray *)value
{
    if (strUrl == Nil) {
        return @"Url is Null";
    }
    
    if ([key count] <= 0) {
        return @"Key array is null";
    }
    
    if ([value count] <= 0) {
        return @"value array is null";    
    }
    
    [strUrl appendString:@"?"];
    for (short i = 0; i < [key count]; i++) {
        [strUrl appendString:[NSString stringWithFormat:@"%@",[key objectAtIndex:i]]];
        [strUrl appendString:@"="];      
        [strUrl appendString:[NSString stringWithFormat:@"%@",[value objectAtIndex:i]]];
        [strUrl appendString:@"&"];              
    }
    if ([strUrl hasSuffix:@"&"]) {
        [strUrl deleteCharactersInRange:NSMakeRange([strUrl length]-1, 1)];
    }
    
    request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[strUrl description]]];
    NSLog(@"value %@",strUrl);
    return @"Done";
}

-(NSString *)kParameterWithString:(NSString *)strWithParameterValue withData: (NSData *)data
{
    if (strWithParameterValue == Nil) {
        return @"Parameter is Null";
    }
    
    if (strUrl == Nil) {
        return @"Url is Null";
    }
    
    [strUrl appendString:strWithParameterValue];

    request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[strUrl description]]];

    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody:data];
    [request setValue:[NSString stringWithFormat:@"%d",[data length] ] forHTTPHeaderField:@"Content-Length"];
    
    return @"Done";
}

-(BOOL)isNetworkAvailable
{
    Reachability *r = [Reachability reachabilityWithHostName:@"finance.yahoo.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    BOOL internet;
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) 
    {
        internet = NO;
    } 
    else 
    {
        internet = YES;
    }
    return internet;
}

- (BOOL) validateUrl: (NSString *) candidate {
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx]; 
    return [urlTest evaluateWithObject:candidate];
}

@end
