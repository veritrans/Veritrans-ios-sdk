//
//  VTCreditCardPaymentFeature.h
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/29/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

/**
 The types of credit card payment.
 */
typedef NS_ENUM(NSUInteger, VTCreditCardPaymentFeature) {
    /**
     One-click credit card payment. By using this feature, end user need to input credit card information just for the first time. The subsequent payment will use the saved card information. See http://docs.veritrans.co.id/en/api/methods.html#card-payment-features-one-click for more information.
     */
    VTCreditCardPaymentFeatureOneClick,
    
    /**
     Two-click credit card payment. By using this feature, end user need to input credit card information just for the first time. The subsequent payment will need only the CVV information. See http://docs.veritrans.co.id/en/api/methods.html#card-payment-features-one-click for more information.
     */
    VTCreditCardPaymentFeatureTwoClick,
    
    /**
     Normal credit card payment. By using this feature, end user will need to input credit card information everytime user wants to make payment.
     */
    VTCreditCardPaymentFeatureNormal,
    
    /**
     Unknown credit card payment type. Internal usage only.
     */
    VTCreditCardPaymentFeatureUnknown
};
