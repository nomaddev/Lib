//
//  SmartPickerViewDelegate.m
//  ReadyScore
//
//  Created by Verve on 01/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SmartPickerViewDataSource.h"

@implementation SmartPickerViewDataSource

@synthesize delegate;

#pragma mark - UIPickerViewDataSource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_pickerData count];
}

#pragma mark - UIPickerViewDelegate Methods

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_pickerData objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (delegate) {
        [delegate updateViewOnSelect : _targetView  :[_pickerData objectAtIndex:row] :row];
    }
}


//-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    UILabel *channelLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 320, 60)];
//    channelLabel.text = [_pickerData objectAtIndex:row];
//    channelLabel.font = [UIFont boldSystemFontOfSize:20.0f];
//    channelLabel.textAlignment = UITextAlignmentLeft;
//    channelLabel.backgroundColor = [UIColor clearColor];
//    channelLabel.textColor = [UIColor grayColor];
//    
//    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
//    [tmpView insertSubview:channelLabel atIndex:1];
//    return tmpView;
//}

#pragma mark - other initialization methods

-(void) setTargetView : (UIView *) targetView pickerView:(UIPickerView *) pickerView pickerData:(NSArray *) pickerData currentTitle : (NSString *) currentTitle {
    _targetView = targetView;
    _pickerData = pickerData;
    _pickerView = pickerView;
    
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    
    if (currentTitle) {
        for (int i = 0; i < [_pickerData count]; i++) {
            if ([[_pickerData objectAtIndex:i] isEqualToString:currentTitle]) {
                [_pickerView selectRow:i inComponent:0 animated:YES];
                break;
            }
        }
    }
    
}

@end
