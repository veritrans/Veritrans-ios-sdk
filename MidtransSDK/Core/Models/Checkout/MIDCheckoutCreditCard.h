//
//  MIDCreditCardOption.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 19/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDCheckoutOption.h"
#import "MIDCheckoutInstallment.h"
#import "MIDModelEnums.h"

@interface MIDCheckoutCreditCard : NSObject<MIDCheckoutOption>

@property (nonatomic) BOOL saveCard;
@property (nonatomic) BOOL secure;
@property (nonatomic) MIDAcquiringBank bank;
@property (nonatomic) MIDAcquiringChannel channel;
@property (nonatomic) MIDCreditCardTransactionType type;
@property (nonatomic) NSArray <NSString *> *whiteListBins;
@property (nonatomic) MIDCheckoutInstallment *installment;

/**
 Credit card payment options
 
 @param type Credit card transaction type. Default: MIDCreditCardTransactionTypeAuthorizeCapture
 @param secure Use 3D-Secure authentication when using credit card. Default: false
 @param saveCard Set enable if you want to save recently used card
 @param bank Acquiring bank. Options: bca, bni, mandiri, cimb, bri, danamon, maybank, mega
 @param channel Acquiring channel. Options: migs
 @param installment Credit card payment with installment
 */
- (instancetype)initWithTransactionType:(MIDCreditCardTransactionType)type
                           enableSecure:(BOOL)secure
                         enableSaveCard:(BOOL)saveCard
                          acquiringBank:(MIDAcquiringBank)bank
                       acquiringChannel:(MIDAcquiringChannel)channel
                            installment:(MIDCheckoutInstallment *)installment
                          whiteListBins:(NSArray <NSString *> *)bins;

@end
