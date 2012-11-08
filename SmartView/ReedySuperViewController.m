//
//  ReedySuperViewController.m
//  ReadyScore
//
//  Created by Verve on 01/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ReedySuperViewController.h"

@interface ReedySuperViewController ()

@end

@implementation ReedySuperViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    appDelegate = (ReadyScoreAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [scrollView setContentSize:CGSizeMake(320, 650)];
    
    svos = scrollView.contentOffset;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    scrollView.scrollEnabled = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - other custom methods
-(void)showPickerView :(UIToolbar *) toolBar pickerView: (UIView *) pickerView targetView:(UIView *) targetView
{
    if (pickerView && [pickerView isKindOfClass:[UIPickerView class]]) {
        [((UIPickerView *)pickerView) reloadAllComponents];
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelay:0.0];
    toolBar.frame = CGRectMake(0, 200, 320, 44);
    pickerView.frame = CGRectMake(0, 244, 320, 216);
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView commitAnimations];
    CGRect rc;
    CGPoint pt;
    rc = [targetView bounds];
    rc = [targetView convertRect:rc toView:scrollView];
    
    if (rc.origin.y >= 120.0f) {
        pt = rc.origin;
        pt.x = 0;
        pt.y -= 120;
        [scrollView setContentOffset:pt animated:YES];
    }  
}

-(void)hidePickerView :(UIToolbar *) toolBar pickerView : (UIView *) pickerView
{
    if (pickerView) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelay:0.0];
        toolBar.frame = CGRectMake(0, 500, 320, 44);
        pickerView.frame = CGRectMake(0, 550, 320, 216);
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView commitAnimations];
        
        [scrollView setContentOffset:svos animated:YES];
    }
    
}

-(void)showProgressView
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [CustomBlackAlert showAlertForProcess];
    [pool release];
        
}
-(void)hideProgressView
{
    [CustomBlackAlert hideAlert];
}


-(void) removeOffsetOnInputViewHide {
    [scrollView setContentOffset:svos animated:YES];
}

-(void) setOffsetOnInputViewShown :(UIView *) targetView {
    CGRect rc;
    CGPoint pt;
    rc = [targetView bounds];
    rc = [targetView convertRect:rc toView:scrollView];
    
    if (rc.origin.y >= 120.0f) {
        pt = rc.origin;
        pt.x = 0;
        pt.y -= 120;
        [scrollView setContentOffset:pt animated:YES];
    }
}


@end
