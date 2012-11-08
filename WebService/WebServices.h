//
//  WebServices.h
//  ReadyScore
//
//  Created by Verve-1 on 21/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol WebServiceCallBackDelegate <NSObject>

-(void) successCallBack:(NSString *) strResult;
-(void) failureCallBack:(NSString *) strResult;
-(void) internetNotAvailable:(NSString *) strResult;


@optional
-(void) successCallBackWithResult:(NSMutableArray *) strResult forMethod:(NSString *) methodName;

@end


@interface WebServices : NSObject<UIAlertViewDelegate>
{    
    NSMutableURLRequest  *request;
    NSMutableString *strUrl;
}


@property (nonatomic, retain) id<WebServiceCallBackDelegate> wsDelegate;

-(NSString *)kFireCallByString:(id<WebServiceCallBackDelegate>) wsDelegate;
-(void)kCleanUp;
-(NSString *)kPrepareWithUrl:(NSString *)url;
-(void)kFireCallByArrayThread;
-(NSString *)kParameterWithKey:(NSArray *)key withValue:(NSArray *)value;
-(NSString *)kParameterWithString:(NSString *)strWithParameterValue withData: (NSData *)data;
-(void) makeCallInThread;

-(NSMutableArray *)kFireCallByArray;

@end
