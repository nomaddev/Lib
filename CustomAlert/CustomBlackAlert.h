
#import <Foundation/Foundation.h>


@interface CustomBlackAlert : UIAlertView
typedef enum AlertViewButtons {
    AlertViewButtonOK,
    AlertViewButtonCancel
} AlertViewButtons;

+(void)setBackgroundColor:(UIColor *) background withStrokeColor:(UIColor *) stroke;
+(void)showAlertForProcess;
+(void)showAlertForProcesswithMessege:(NSString*)imessege;
+(void)hideAlert;
+(void)showMessageBoxWithButton:(NSString*)strTitle Message:(NSString*)strMessage Button:(NSString*)strButtonTitle alertViewDelegate: (id<UIAlertViewDelegate>) delegate;
+(void)showMessageBoxWithButtons:(NSString*)strTitle Message:(NSString*)strMessage Button:(NSString*)strButtonTitle alertViewDelegate: (id<UIAlertViewDelegate>) delegate;
+(void)showMessageBoxWithYesButtons:(NSString*)strTitle Message:(NSString*)strMessage Button:(NSString*)strButtonTitle alertViewDelegate: (id<UIAlertViewDelegate>) delegate;
+(void)showConsentMessageBox:(NSString*)strTitle Message:(NSString*)strMessage alertViewDelegate: (id<UIAlertViewDelegate>) delegate;
@end
