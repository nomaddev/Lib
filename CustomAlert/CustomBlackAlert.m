
#import "CustomBlackAlert.h"

@interface CustomBlackAlert (Private)

- (void) drawRoundedRect:(CGRect) rect inContext:(CGContextRef) 
context withRadius:(CGFloat) radius;

@end
static UIColor *fillColor = nil;
static UIColor *borderColor = nil;

@implementation CustomBlackAlert

static CustomBlackAlert *av;
UIActivityIndicatorView *actInd;

+(void)showAlertForProcess
{
	if(av!=nil && [av retainCount]>0){ [av release]; av=nil; }
	if(actInd!=nil && [actInd retainCount]>0){ [actInd removeFromSuperview];[actInd release]; actInd=nil; }	
	av=[[CustomBlackAlert alloc] initWithTitle:@"Loading..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	actInd=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[actInd setFrame:CGRectMake(120, 50, 37, 37)];
	[actInd startAnimating];
	[av addSubview:actInd];
	[av show];
}

+(void)showAlertForProcesswithMessege:(NSString*)imessege
{
	if(av!=nil && [av retainCount]>0){ [av release]; av=nil; }
	if(actInd!=nil && [actInd retainCount]>0){ [actInd removeFromSuperview];[actInd release]; actInd=nil; }	
	av=[[CustomBlackAlert alloc] initWithTitle:imessege message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	//	[av setFrame:CGRectMake(120, 100, 37, 37)];
	actInd=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[actInd setFrame:CGRectMake(120, 72, 37, 37)];
	[actInd startAnimating];
	[av addSubview:actInd];
	[av show];
}

+(void)hideAlert
{
	[av dismissWithClickedButtonIndex:0 animated:YES];
	if(av!=nil && [av retainCount]>0){ [av dismissWithClickedButtonIndex:0 animated:YES]; [av release]; av=nil; }
	if(actInd!=nil && [actInd retainCount]>0){ [actInd removeFromSuperview];[actInd release]; actInd=nil; }	
}

+(void)showMessageBoxWithButton:(NSString*)strTitle Message:(NSString*)strMessage Button:(NSString*)strButtonTitle alertViewDelegate: (id<UIAlertViewDelegate>) delegate
{
	if(av!=nil && [av retainCount]>0){ [av release]; av=nil; }	
	av = [[CustomBlackAlert alloc]initWithTitle:strTitle message:strMessage  delegate:delegate cancelButtonTitle:strButtonTitle otherButtonTitles: nil];
    av.delegate = delegate;
	[av show];
}

+(void)showMessageBoxWithButtons:(NSString*)strTitle Message:(NSString*)strMessage Button:(NSString*)strButtonTitle alertViewDelegate: (id<UIAlertViewDelegate>) delegate
{
	if(av!=nil && [av retainCount]>0){ [av release]; av=nil; }	
	av = [[CustomBlackAlert alloc]initWithTitle:strTitle message:strMessage  delegate:nil cancelButtonTitle:strButtonTitle otherButtonTitles:@"Cancel", nil];
    av.delegate = delegate;
	[av show];
}
+(void)showConsentMessageBox:(NSString*)strTitle Message:(NSString*)strMessage alertViewDelegate: (id<UIAlertViewDelegate>) delegate
{
	if(av!=nil && [av retainCount]>0){ [av release]; av=nil; }	
	av = [[CustomBlackAlert alloc]initWithTitle:strTitle message:strMessage  delegate:nil cancelButtonTitle:@"Don't Allow" otherButtonTitles:@"Allow", nil];
    av.delegate = delegate;
	[av show];
}

+(void)showMessageBoxWithYesButtons:(NSString*)strTitle Message:(NSString*)strMessage Button:(NSString*)strButtonTitle alertViewDelegate: (id<UIAlertViewDelegate>) delegate
{
	if(av!=nil && [av retainCount]>0){ [av release]; av=nil; }	
	av = [[CustomBlackAlert alloc]initWithTitle:strTitle message:strMessage  delegate:delegate cancelButtonTitle:strButtonTitle otherButtonTitles:@"Yes", nil];
    av.delegate = delegate;
	[av show];
}

+ (void) setBackgroundColor:(UIColor *) background withStrokeColor:(UIColor *) stroke
{
	if(fillColor != nil)
	{
		[fillColor release];
		[borderColor release];
	}
    
	fillColor = [background retain];
	borderColor = [stroke retain];
}

- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame]))
	{
        if(fillColor == nil)
		{
            // 50% clear color
			fillColor = [[UIColor colorWithRed:0.0/256.0 green:0.0/256.0 blue:8.0/256.0 alpha:0.6f] retain];
            
//          fillColor = [[UIColor colorWithRed:31.0/256.0 green:64.0/256.0 blue:138.0/256.0 alpha:1.0] retain];
//          fillColor = [[UIColor colorWithRed:2.0/256.0 green:63.0/256.0 blue:183.0/256.0 alpha:1.0] retain];
			borderColor = [[UIColor blackColor] retain];
		}
    }
    
    return self;
}

- (void)layoutSubviews
{
	for (UIView *sub in [self subviews])
	{
		if([sub class] == [UIImageView class] && sub.tag == 0)
		{
			[sub removeFromSuperview];
			break;
		}
	}
}

- (void)drawRect:(CGRect)rect
{	
	CGContextRef context = UIGraphicsGetCurrentContext();
    
	CGContextClearRect(context, rect);
	CGContextSetAllowsAntialiasing(context, true);
	CGContextSetLineWidth(context, 0.0);
	CGContextSetAlpha(context, 0.9); 
	CGContextSetLineWidth(context, 2.0);
	CGContextSetStrokeColorWithColor(context, [borderColor CGColor]);
	CGContextSetFillColorWithColor(context, [fillColor CGColor]);
    
	// Draw background
	CGFloat backOffset = 2;
	CGRect backRect = CGRectMake(rect.origin.x + backOffset, 
                                 rect.origin.y + backOffset, 
                                 rect.size.width - backOffset*2, 
                                 rect.size.height - backOffset*2);
    
	[self drawRoundedRect:backRect inContext:context withRadius:8];
	CGContextDrawPath(context, kCGPathFillStroke);
    
	// Clip Context
	CGRect clipRect = CGRectMake(backRect.origin.x + backOffset-1, 
                                 backRect.origin.y + backOffset-1, 
                                 backRect.size.width - (backOffset-1)*2, 
                                 backRect.size.height - (backOffset-1)*2);
    
	[self drawRoundedRect:clipRect inContext:context withRadius:8];
	CGContextClip (context);
    
	//Draw highlight
	CGGradientRef glossGradient;
	CGColorSpaceRef rgbColorspace;
	size_t num_locations = 2;
	CGFloat locations[2] = { 0.0, 1.0 };
	CGFloat components[8] = { 1.0, 1.0, 1.0, 0.35, 1.0, 1.0, 1.0, 0.06 };
	rgbColorspace = CGColorSpaceCreateDeviceRGB();
	glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, 
                                                        components, locations, num_locations);
    
	CGRect ovalRect = CGRectMake(-130, -115, (rect.size.width*2), 
                                 rect.size.width/2);
    
	CGPoint start = CGPointMake(rect.origin.x, rect.origin.y);
	CGPoint end = CGPointMake(rect.origin.x, rect.size.height/5);
    
	CGContextSetAlpha(context, 1.0); 
	CGContextAddEllipseInRect(context, ovalRect);
	CGContextClip (context);
    
	CGContextDrawLinearGradient(context, glossGradient, start, end, 0);
    
	CGGradientRelease(glossGradient);
	CGColorSpaceRelease(rgbColorspace); 
}

- (void) drawRoundedRect:(CGRect) rrect inContext:(CGContextRef) context 
              withRadius:(CGFloat) radius
{
	CGContextBeginPath (context);
    
	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), 
    maxx = CGRectGetMaxX(rrect);
    
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), 
    maxy = CGRectGetMaxY(rrect);
    
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
}

- (void)dealloc
{
    [super dealloc];
}

@end
