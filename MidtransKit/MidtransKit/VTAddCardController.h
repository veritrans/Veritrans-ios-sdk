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

@property (nonatomic, assign, nonnull) id<VTAddCardControllerDelegate>delegate;

- (instancetype _Nonnull)initWithToken:(MidtransTransactionTokenResponse *_Nonnull)token maskedCards:(NSMutableArray *_Nonnull)maskedCards;

@end

@protocol VTAddCardControllerDelegate <NSObject>

- (void)viewController:(VTAddCardController *_Nonnull)viewController didRegisterCard:(MidtransMaskedCreditCard *_Nonnull)registeredCard;

@end