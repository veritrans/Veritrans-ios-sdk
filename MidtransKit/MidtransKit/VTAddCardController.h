//
//  VTAddCardController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTPaymentController.h"


@protocol VTAddCardControllerDelegate;

@interface VTAddCardController : VTPaymentController
@property (nonatomic, assign) id<VTAddCardControllerDelegate>delegate;
@end

@protocol VTAddCardControllerDelegate <NSObject>

- (void)viewController:(VTAddCardController *)viewController didRegisterCard:(VTMaskedCreditCard *)registeredCard;

@end