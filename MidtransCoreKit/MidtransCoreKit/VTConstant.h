//
//  VTConstant.h
//  MidtransCoreKit
//
//  Created by atta on 6/9/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

/**
 *  error domain
 */
static NSString * const VT_ERROR_DOMAIN = @"error.veritrans.co.id";

/**
 *  transaction status
 */
static NSString * const VT_TRANSACTION_STATUS_DENY   = @"deny";
static NSString * const VT_TRANSACTION_STATUS_SETTLE   = @"settlement";


/**
 *  credit card type
 *
 *  @param systemVersion]
 *
 *  @return 
 */
static NSString * const CREDIT_CARD_TYPE_AMEX   = @"Amex";
static NSString * const CREDIT_CARD_TYPE_JCB    = @"JCB";
static NSString * const CREDIT_CARD_TYPE_MASTER_CARD    = @"MasterCard";
static NSString * const CREDIT_CARD_TYPE_VISA    = @"Visa";

/**
 *  PAYMENT TYPE
 */
static NSString * const VT_PAYMENT_BCA_KLIKPAY = @"bca_klikpay";
static NSString * const VT_PAYMENT_KLIK_BCA = @"bca_klikbca";
static NSString * const VT_PAYMENT_INDOMARET = @"indomaret";
static NSString * const VT_PAYMENT_CIMB_CLICKS = @"cimb_clicks";
static NSString * const VT_PAYMENT_CSTORE = @"cstore";
static NSString * const VT_PAYMENT_MANDIRI_ECASH = @"mandiri_ecash";
static NSString * const VT_PAYMENT_CREDIT_CARD = @"credit_card";
static NSString * const VT_PAYMENT_BANK_TRANSFER = @"bank_transfer";
static NSString * const VT_PAYMENT_ECHANNEL = @"echannel";
static NSString * const VT_PAYMENT_BRI_EPAY = @"bri_epay";
static NSString * const VT_PAYMENT_TELKOMSEL_CASH = @"telkomsel_cash";
static NSString * const VT_PAYMENT_INDOSAT_DOMPETKU = @"indosat_dompetku";
static NSString * const VT_PAYMENT_XL_TUNAI = @"xl_tunai";
static NSString * const VT_PAYMENT_MANDIRI_CLICKPAY = @"mandiri_clickpay";

static NSString *const TRANSACTION_SUCCESS = @"vtTRANSACTION_SUCCESS";
static NSString *const TRANSACTION_PENDING = @"vtTRANSACTION_PENDING";
static NSString *const TRANSACTION_FAILED = @"vtTRANSACTION_FAILED";

static NSString *const VT_VA_PERMATA_IDENTIFIER = @"vapermata";
static NSString *const VT_VA_BCA_IDENTIFIER = @"vabca";
static NSString *const VT_VA_MANDIRI_IDENTIFIER = @"vamandiri";
static NSString *const VT_VA_OTHER_IDENTIFIER = @"vaother";

/**
 *  CONSTANT REGEX
 */
static NSString * const VT_VISA_REGEX         = @"^4[0-9]{0,}$";
static NSString * const VT_MASTER_CARD_REGEX   = @"^5[1-5][0-9]{1,}$";
static NSString * const VT_JCB_REGEX          = @"^35(2[89]|[3-8][0-9]){0,}$";
static NSString * const VT_AMEX_REGEX         = @"^3[47][0-9]{0,}$";

/**
 * CONSTANT ENDPOINT
 */

static NSString * const ENDPOINT_PAYMENT_PAGES = @"payment_pages";
static NSString * const ENDPOINT_CHARGE_CC = @"pay_with_credit_card";
static NSString * const ENDPOINT_CHARGE_BCA_KLIKPAY = @"pay_with_bca_klikpay";
static NSString * const ENDPOINT_CHARGE_KLIKBCA = @"pay_with_bca_klikbca";
static NSString * const ENDPOINT_CHARGE_BRI_EPAY = @"pay_with_bri_epay";
static NSString * const ENDPOINT_CHARGE_MANDIRI_CLICKPAY = @"pay_with_mandiri_clickpay";
static NSString * const ENDPOINT_CHARGE_CIMB_CLICKS = @"pay_with_cimb_clicks";
static NSString * const ENDPOINT_CHARGE_PERMATA_VA = @"pay_with_permata";
static NSString * const ENDPOINT_CHARGE_BCA_VA = @"pay_with_bank_transfer_bca";
static NSString * const ENDPOINT_CHARGE_MANDIRI_VA = @"pay_with_mandiri_billpayment";
static NSString * const ENDPOINT_CHARGE_OTHER_VA = @"va_all_bank";
static NSString * const ENDPOINT_CHARGE_MANDIRI_ECASH = @"pay_with_mandiri_ecash";
static NSString * const ENDPOINT_CHARGE_TELKOMSEL_CASH = @"pay_with_telkomsel_cash";
static NSString * const ENDPOINT_CHARGE_XL_TUNAI = @"pay_with_xl_tunai";
static NSString * const ENDPOINT_CHARGE_INDOSAT_DOMPETKU = @"pay_with_indosat_dompetku";
static NSString * const ENDPOINT_CHARGE_KIOS_ON = @"pay_with_kioson";
static NSString * const ENDPOINT_CHARGE_INDOMARET = @"pay_with_indomaret";

/**
 *  MESSAGE CONSTANT
 */

static NSString * const VT_MESSAGE_CARD_INVALID = @"Card number is invalid";
static NSString * const VT_MESSAGE_EXPIRE_DATE_INVALID = @"Expiry Year is invalid";
static NSString * const VT_MESSAGE_EXPIRE_MONTH_INVALID = @"Expiry Month is invalid";
static NSString * const VT_MESSAGE_CARD_CVV_INVALID = @"CVV is invalid";
static NSString * const VT_MESSAGE_MERCHANT_SERVER_NOT_SET = @"Please set your merchant server URL in VTConfig";
static NSString * const VT_MESSAGE_CLIENT_KEY_NOT_SET = @"Please set your Veritrans Client Key in VTConfig";

static NSString *const VT_SANDBOX_API_URL = @"https://api.sandbox.veritrans.co.id/v2";
static NSString *const VT_SANDBOX_MIXPANEL = @"cc005b296ca4ce612fe3939177c668bb";
static NSString *const VT_SANDBOX_SNAP = @"https://app.sandbox.veritrans.co.id/snap/v1";
static NSString *const VT_PRODUCTION_API_URL = @"https://api.veritrans.co.id/v2";
static NSString *const VT_PROD_SNAP = @"https://app.sandbox.veritrans.co.id/snap/v1/payment_pages/";
static NSString *const VT_PRODUCTION_MIXPANEL = @"0269722c477a0e085fde32e0248c6003";

static NSString *const VT_TRACKING_CC_TOKEN = @"token";
static NSString *const VT_TRACKING_PAYMENT_METHOD = @"payment_method";
static NSString *const VT_TRACKING_PAYMENT_AMOUNT = @"amount";
static NSString *const VT_TRACKING_PAYMENT_FEATURE = @"payment_feature";
static NSString *const VT_TRACKING_SECURE_PROTOCOL = @"secure";

static NSString *const VT_TRACKING_APP_TOKENIZER_SUCCESS = @"Tokenize Success";
static NSString *const VT_TRACKING_APP_TOKENIZER_ERROR = @"Tokenize Failed";

static NSString *const VT_TRACKING_APP_GET_SNAP_TOKEN_SUCCESS = @"Success Getting Snap Transaction";
static NSString *const VT_TRACKING_APP_GET_SNAP_TOKEN_FAIL = @"Fail Getting Snap Transaction";

static NSString *const VT_TRACKING_APP_TRANSACTION_SUCCESS = @"Transaction Success";
static NSString *const VT_TRACKING_APP_TRANSACTION_ERROR = @"Transaction Failed";

static NSString *const VT_CORE_SNAP_MERCHANT_SERVER_CHARGE = @"charge";
static NSString *const VT_CORE_SNAP_PARAMETER_TRANSACTION_DETAILS = @"transaction_details";
static NSString *const VT_CORE_SNAP_PARAMETER_ITEM_DETAILS = @"item_details";
static NSString *const VT_CORE_SNAP_PARAMETER_CUSTOMER_DETAILS = @"customer_details";

static NSString *const VT_CORE_STATUS_CODE = @"status_code";
static NSString *const VT_CORE_SAVED_ID_TOKEN = @"saved_token_id";
static NSString *const VT_CORE_TRANSACTION_ID = @"transaction_id";
static NSString *const VT_CORE_MERCHANT_LOGO_KEY = @"merchant_logo_key";
static NSString *const VT_CORE_MERCHANT_NAME = @"merchant_name";


/**
 *  if needed we maybe need it as is to detect ios version and also device version
 *
 *  @param systemVersion]
 *
 *  @return
 */

#define SYSTEM_VERSION                              ([[UIDevice currentDevice] systemVersion])
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([SYSTEM_VERSION compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IS_IOS8_OR_ABOVE                            (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
