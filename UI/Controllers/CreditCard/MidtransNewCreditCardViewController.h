//
//  MidtransNewCreditCardViewController.h
//  MidtransKit
//
//  Created by Vanbungkring on 1/19/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"

@protocol MidtransNewCreditCardViewControllerDelegate <NSObject>
- (void)didDeleteSavedCard;
@end

@interface MidtransNewCreditCardViewController : MidtransUIPaymentController

@property (nonatomic,strong) MIDSavedCardInfo *savedCardInfo;
@property (nonatomic, weak, nullable) id<MidtransNewCreditCardViewControllerDelegate>delegate;
@property (nonatomic)BOOL noCardHash;

@end
