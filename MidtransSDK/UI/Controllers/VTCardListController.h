//
//  VTCardListController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIdtransUICardCell.h"
#import "MidtransUIPaymentController.h"

@interface VTCardListController : MidtransUIPaymentController
@property (nonatomic) MidtransMaskedCreditCard *selectedMaskedCard;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
-(instancetype)initWithToken:(MidtransTransactionTokenResponse *)token
           paymentMethodName:(MidtransPaymentListModel *)paymentMethod
           andCreditCardData:(MidtransPaymentRequestV2CreditCard *)creditCard
andCompleteResponseOfPayment:(MidtransPaymentRequestV2Response *)responsePayment;
@end
