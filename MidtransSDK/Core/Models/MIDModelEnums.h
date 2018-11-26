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

typedef NS_ENUM(NSUInteger, MIDAcquiringChannel) {
    MIDAcquiringChannelNone,
    MIDAcquiringChannelMIGS
};

typedef NS_ENUM(NSUInteger, MIDCreditCardTransactionType) {
    MIDCreditCardTransactionTypeAuthorizeCapture,
    MIDCreditCardTransactionTypeAuthorize
};

typedef NS_ENUM(NSUInteger, MIDOnlinePaymentType) {
    MIDOnlinePaymentTypeAkulaku,
    MIDOnlinePaymentTypeBRIEpay,
    MIDOnlinePaymentTypeBCAKlikPay,
    MIDOnlinePaymentTypeMandiriEcash,
    MIDOnlinePaymentTypeCIMBClicks,
    MIDOnlinePaymentTypeIndomaret,
    MIDOnlinePaymentTypeKiosOn,
    MIDOnlinePaymentTypeDanamonOnline,
    MIDOnlinePaymentTypeGoPay
};

typedef NS_ENUM(NSUInteger, MIDVirtualAccountType) {
    MIDVirtualAccountTypeEchannel,
    MIDVirtualAccountTypeBCA,
    MIDVirtualAccountTypePermata,
    MIDVirtualAccountTypeBNI,
    MIDVirtualAccountTypeOther
};

typedef NS_ENUM(NSUInteger, MIDExpiryTimeUnit) {
    MIDExpiryTimeUnitHour,
    MIDExpiryTimeUnitHours,
    MIDExpiryTimeUnitDay,
    MIDExpiryTimeUnitDays,
    MIDExpiryTimeUnitMinute,
    MIDExpiryTimeUnitMinutes
};
