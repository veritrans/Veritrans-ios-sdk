//
//  MidtransUICustomAlertViewController.h
//  MidtransKit
//
//  Created by Vanbungkring on 1/26/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MidtransUICustomAlertViewController;
@protocol MidtransUICustomAlertViewControllerDelegate <NSObject>

- (void)didSelectOKButtonAlertViewController:(MidtransUICustomAlertViewController *)alertViewVC;
@optional
- (void)didSelectCancelButtonAlertViewController:(MidtransUICustomAlertViewController *)alertViewVC;

@end
@interface MidtransUICustomAlertViewController : UIViewController

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                        image:(NSString *)image
                     delegate:(id<MidtransUICustomAlertViewControllerDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
                okButtonTitle:(NSString *)okButtonTitle;
@end
