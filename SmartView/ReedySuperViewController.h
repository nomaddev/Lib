//
//  ReedySuperViewController.h
//  ReadyScore
//
//  Created by Verve on 01/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ReadyScoreAppDelegate.h"

@interface ReedySuperViewController : UIViewController {
    ReadyScoreAppDelegate *appDelegate;
    
    IBOutlet UIScrollView *scrollView;
    
    CGPoint svos;
    
    UIView *loadingView;
    
    UIActivityIndicatorView *activityIndicator;
    

    
}

-(void)showPickerView :(UIToolbar *) toolBar pickerView: (UIView *) pickerView targetView:(UIView *) targetView;
-(void)hidePickerView :(UIToolbar *) toolBar pickerView : (UIView *) pickerView;

-(void)showProgressView;
-(void)hideProgressView;

-(void) setOffsetOnInputViewShown :(UIView *) targetView;
-(void) removeOffsetOnInputViewHide;


@end
