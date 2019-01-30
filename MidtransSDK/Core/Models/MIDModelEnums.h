//
//  MIDModelEnums.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 19/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

typedef NS_ENUM(NSUInteger, MIDAcquiringBank) {
    MIDAcquiringBankNone,
    MIDAcquiringBankBCA,
    MIDAcquiringBankBNI,
    MIDAcquiringBankMandiri,
    MIDAcquiringBankCIMB,
    MIDAcquiringBankBRI,
    MIDAcquiringBankDanamon,
    MIDAcquiringBankMaybank,
    MIDAcquiringBankMega
};

typedef NS_ENUM(NSUInteger, MIDAuthentication) {
    MIDAuthenticationNone,
    MIDAuthentication3DS,
    MIDAuthenticationRBA
};

typedef NS_ENUM(NSUInteger, MIDAcquiringChannel) {
    MIDAcquiringChannelNone,
    MIDAcquiringChannelMIGS
};

typedef NS_ENUM(NSUInteger, MIDCreditCardTransactionType) {
    MIDCreditCardTransactionTypeAuthorizeCapture,
    MIDCreditCardTransactionTypeAuthorize
};

typedef NS_ENUM(NSUInteger, MIDWebPaymentType) {
    MIDWebPaymentTypeAkulaku,
    MIDWebPaymentTypeBRIEpay,
    MIDWebPaymentTypeBCAKlikPay,
    MIDWebPaymentTypeMandiriEcash,
    MIDWebPaymentTypeCIMBClicks,
    MIDWebPaymentTypeKiosOn,
    MIDWebPaymentTypeDanamonOnline
};

typedef NS_ENUM(NSUInteger, MIDBankTransferType) {
    MIDBankTransferTypeEchannel,
    MIDBankTransferTypeBCA,
    MIDBankTransferTypePermata,
    MIDBankTransferTypeBNI,
    MIDBankTransferTypeOther
};

typedef NS_ENUM(NSUInteger, MIDExpiryTimeUnit) {
    MIDExpiryTimeUnitHour,
    MIDExpiryTimeUnitHours,
    MIDExpiryTimeUnitDay,
    MIDExpiryTimeUnitDays,
    MIDExpiryTimeUnitMinute,
    MIDExpiryTimeUnitMinutes
};

typedef NS_ENUM(NSInteger, MIDCurrency) {
    MIDCurrencyIDR,
    MIDCurrencySGD
};

typedef NS_ENUM(NSInteger, MIDSavedCardType) {
    MIDSavedCardTypeOneClick,
    MIDSavedCardTypeTwoClick
};
