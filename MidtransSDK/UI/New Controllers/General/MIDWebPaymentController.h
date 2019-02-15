//
//  MIDWebPaymentController.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 14/02/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MIDWebPaymentControllerDelegate;
@protocol MIDWebPaymentControllerDataSource;

@interface MIDWebPaymentController : UIViewController

@property (nonatomic, weak) id<MIDWebPaymentControllerDataSource>dataSource;
@property (nonatomic, weak) id<MIDWebPaymentControllerDelegate>delegate;

- (instancetype)initWithPaymentURL:(NSString *)paymentURL;

@end


@protocol MIDWebPaymentControllerDataSource <NSObject>

/**
 this used to determine if web request is "finish request"
 this text will be compared to the url request
 */
- (NSString *)finishedSignText;

- (NSString *)headerTitle;

@end

@protocol MIDWebPaymentControllerDelegate <NSObject>

- (void)webPaymentControllerDidPending:(MIDWebPaymentController *_Nonnull)viewController;
- (void)webPaymentController:(MIDWebPaymentController *_Nonnull)viewController didError:(NSError *)error;

@end
