//
//  SmartPickerViewDelegate.h
//  ReadyScore
//
//  Created by Verve on 01/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol SmartPickerViewDataSourceProtocol <NSObject>

-(void) updateViewOnSelect : (UIView *) view :(NSString *) title : (int) index;

@end

@interface SmartPickerViewDataSource : NSObject <UIPickerViewDataSource, UIPickerViewDelegate> {
    NSArray *_pickerData;
    UIView *_targetView;
    UIPickerView *_pickerView;
}

@property (nonatomic, retain) id<SmartPickerViewDataSourceProtocol> delegate;

-(void) setTargetView : (UIView *) targetView pickerView:(UIPickerView *) pickerView pickerData:(NSArray *) pickerData currentTitle : (NSString *) currentTitle;

@end
