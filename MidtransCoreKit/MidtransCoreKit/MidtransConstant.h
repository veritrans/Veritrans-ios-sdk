//
//  MidtransConstant.h
//  MidtransCoreKit
//
//  Created by atta on 6/9/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

/**
 *  error domain
 */

static NSString * const MIDTRANS_CUSTOMFIELD_1 = @"custom_field1";
static NSString * const MIDTRANS_CUSTOMFIELD_2 = @"custom_field2";
static NSString * const MIDTRANS_CUSTOMFIELD_3 = @"custom_field3";

static NSString * const MIDTRANS_ERROR_DOMAIN = @"error.veritrans.co.id";

/**
 *  transaction status
 */
static NSString * const MIDTRANS_TRANSACTION_STATUS_DENY   = @"deny";
static NSString * const MIDTRANS_TRANSACTION_STATUS_SETTLE   = @"settlement";


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
static NSString * const MIDTRANS_PAYMENT_BCA_KLIKPAY = @"bca_klikpay";
static NSString * const MIDTRANS_PAYMENT_KLIK_BCA = @"bca_klikbca";
static NSString * const MIDTRANS_PAYMENT_INDOMARET = @"indomaret";
static NSString * const MIDTRANS_PAYMENT_CIMB_CLICKS = @"cimb_clicks";
static NSString * const MIDTRANS_PAYMENT_CSTORE = @"cstore";
static NSString * const MIDTRANS_PAYMENT_MANDIRI_ECASH = @"mandiri_ecash";
static NSString * const MIDTRANS_PAYMENT_CREDIT_CARD = @"credit_card";

static NSString * const MIDTRANS_PAYMENT_ECHANNEL = @"echannel";
static NSString * const MIDTRANS_PAYMENT_PERMATA_VA = @"permata_va";
static NSString * const MIDTRANS_PAYMENT_BCA_VA = @"bca_va";
static NSString * const MIDTRANS_PAYMENT_ALL_VA = @"all_va";
static NSString * const MIDTRANS_PAYMENT_OTHER_VA= @"other_va";
static NSString * const MIDTRANS_PAYMENT_VA = @"va";

static NSString * const MIDTRANS_PAYMENT_BRI_EPAY = @"bri_epay";
static NSString * const MIDTRANS_PAYMENT_TELKOMSEL_CASH = @"telkomsel_cash";
static NSString * const MIDTRANS_PAYMENT_INDOSAT_DOMPETKU = @"indosat_dompetku";
static NSString * const MIDTRANS_PAYMENT_XL_TUNAI = @"xl_tunai";
static NSString * const MIDTRANS_PAYMENT_MANDIRI_CLICKPAY = @"mandiri_clickpay";
static NSString * const MIDTRANS_PAYMENT_GCI = @"gci";
static NSString * const MIDTRANS_PAYMENT_KIOS_ON = @"kioson";

static NSString *const TRANSACTION_SUCCESS = @"vtTRANSACTION_SUCCESS";
static NSString *const TRANSACTION_PENDING = @"vtTRANSACTION_PENDING";
static NSString *const TRANSACTION_FAILED = @"vtTRANSACTION_FAILED";
static NSString *const TRANSACTION_CANCELED = @"vtTRANSACTION_CANCELED";

static NSString * const TRANSACTION_RESULT_KEY = @"tr_result";
static NSString * const TRANSACTION_ERROR_KEY = @"tr_error";

/**
 *  CONSTANT REGEX
 */
static NSString * const MIDTRANS_VISA_REGEX         = @"^4[0-9]{0,}$";
static NSString * const MIDTRANS_MASTER_CARD_REGEX   = @"^5[1-5][0-9]{0,}$";
static NSString * const MIDTRANS_JCB_REGEX          = @"^(?:2131|1800|35)[0-9]{0,}";
static NSString * const MIDTRANS_AMEX_REGEX         = @"^3[47][0-9]{0,}$";

/**
 * CONSTANT ENDPOINT
 */

static NSString * const ENDPOINT_CHARGE = @"%@/transactions/%@/pay";
static NSString * const ENDPOINT_TRANSACTION_DETAIL = @"%@/transactions/%@";
static NSString * const ENDPOINT_PAYMENT_PAGES = @"%@/payment_pages/%@";

/**
 *  MESSAGE CONSTANT
 */

static NSString * const MIDTRANS_MESSAGE_CARD_INVALID = @"Card number is invalid";
static NSString * const MIDTRANS_MESSAGE_INPUT_VALUE_INVALID = @"Input Invalid";
static NSString * const MIDTRANS_MESSAGE_EXPIRE_DATE_INVALID = @"Expiry Year is invalid";
static NSString * const MIDTRANS_MESSAGE_EXPIRE_MONTH_INVALID = @"Expiry Month is invalid";
static NSString * const MIDTRANS_MESSAGE_CARD_CVV_INVALID = @"CVV is invalid";
static NSString * const MIDTRANS_MESSAGE_MERCHANT_SERVER_NOT_SET = @"Please set your merchant server URL in MidtransConfig";
static NSString * const MIDTRANS_MESSAGE_CLIENT_KEY_NOT_SET = @"Please set your Veritrans Client Key in MidtransConfig";

static NSString *const MIDTRANS_SANDBOX_API_URL = @"https://api.sandbox.veritrans.co.id/v2";
static NSString *const MIDTRANS_SANDBOX_MIXPANEL = @"cc005b296ca4ce612fe3939177c668bb";
static NSString *const MIDTRANS_SANDBOX_SNAP = @"https://app.sandbox.veritrans.co.id/snap/v1";
static NSString *const MIDTRANS_SANDBOX_BIN_URL = @"https://app.sandbox.midtrans.com/snap/v1/bank_bins";

static NSString *const MIDTRANS_PRODUCTION_API_URL = @"https://api.veritrans.co.id/v2";
static NSString *const MIDTRANS_PRODUCTION_SNAP = @"https://app.midtrans.com/snap/v1";
static NSString *const MIDTRANS_PRODUCTION_MIXPANEL = @"0269722c477a0e085fde32e0248c6003";
static NSString *const MIDTRANS_PRODUCTION_BIN_URL = @"https://app.midtrans.com/snap/v1/bank_bins";

/*staging*/

static NSString *const MIDTRANS_STAGING_API_URL = @"https://api.stg.veritrans.co.id/v2";
static NSString *const MIDTRANS_STAGING_MIXPANEL = @"cc005b296ca4ce612fe3939177c668bb";
static NSString *const MIDTRANS_STAGING_SNAP = @"https://app.stg.veritrans.co.id/snap/v1";
static NSString *const MIDTRANS_STAGING_BIN_URL = @"https://app.stg.midtrans.com/snap/v1/bank_bins";

static NSString *const MIDTRANS_TRACKING_CC_TOKEN = @"token";
static NSString *const MIDTRANS_TRACKING_PAYMENT_METHOD = @"payment_method";
static NSString *const MIDTRANS_TRACKING_PAYMENT_AMOUNT = @"amount";
static NSString *const MIDTRANS_TRACKING_PAYMENT_FEATURE = @"payment_feature";
static NSString *const MIDTRANS_TRACKING_SECURE_PROTOCOL = @"secure";
static NSString *const MIDTRANS_TRACKING_DEVICE_ID = @"Device ID";
static NSString *const MIDTRANS_TRACKING_TIME_STAMP = @"Timestamp";
static NSString *const MIDTRANS_TRACKING_DISTINCT_ID = @"distinct_id";
static NSString *const MIDTRANS_TRACKING_DEVICE_MODEL = @"Device Model";
static NSString *const MIDTRANS_TRACKING_DEVICE_TYPE = @"Device Type";
static NSString *const MIDTRANS_TRACKING_DEVICE_LANGUAGE = @"Device Language";
static NSString *const MIDTRANS_TRACKING_APP_TOKENIZER_SUCCESS = @"Tokenize Success";
static NSString *const MIDTRANS_TRACKING_APP_TOKENIZER_ERROR = @"Tokenize Failed";

static NSString *const MIDTRANS_TRACKING_APP_GET_SNAP_TOKEN_SUCCESS = @"Success Getting Snap Transaction";
static NSString *const MIDTRANS_TRACKING_APP_GET_SNAP_PAYMENT_LIST = @"Success Getting Payment List";
static NSString *const MIDTRANS_TRACKING_APP_GET_SNAP_TOKEN_FAIL = @"Fail Getting Snap Transaction";

static NSString *const MIDTRANS_TRACKING_APP_TRANSACTION_SUCCESS = @"Transaction Success";
static NSString *const MIDTRANS_TRACKING_APP_TRANSACTION_ERROR = @"Transaction Failed";

static NSString *const MIDTRANS_CORE_SNAP_MERCHANT_SERVER_CHARGE = @"charge";
static NSString *const MIDTRANS_CORE_SNAP_PARAMETER_TRANSACTION_DETAILS = @"transaction_details";
static NSString *const MIDTRANS_CORE_SNAP_PARAMETER_ITEM_DETAILS = @"item_details";
static NSString *const MIDTRANS_CORE_SNAP_PARAMETER_CUSTOM = @"custom";
static NSString *const MIDTRANS_CORE_SNAP_PARAMETER_EXPIRE_TIME = @"expiry";
static NSString *const MIDTRANS_CORE_SNAP_PARAMETER_CUSTOMER_DETAILS = @"customer_details";

static NSString *const MIDTRANS_CORE_STATUS_CODE = @"status_code";
static NSString *const MIDTRANS_CORE_SAVED_ID_TOKEN = @"saved_token_id";
static NSString *const MIDTRANS_CORE_TRANSACTION_ID = @"transaction_id";
static NSString *const MIDTRANS_CORE_MERCHANT_LOGO_KEY = @"merchant_logo_key";
static NSString *const MIDTRANS_CORE_MERCHANT_NAME = @"merchant_name";

static NSString *const SNP_CORE_BNI_POINT = @"BNI_POINT";
static NSString *const SNP_CORE_CREDIT_CARD_SAVE = @"CREDIT_CARD_SAVE";

static NSString *const SNP_CORE_DEBIT_CARD = @"debit";
static NSString *const SNP_CORE_BANK_MANDIRI = @"mandiri";
static NSString *const SNP_CORE_BANK_BNI = @"bni";
static NSString *const MIDTRANS_CORE_TRACKING_MIXPANEL_URL = @"https://api.mixpanel.com/track";

static NSString *const  MIDTRANS_UIKIT_TRACKING_SELECT_PAYMENT = @"Payment Select";
static NSString *const  MIDTRANS_UIKIT_TRACKING_SELECT_PAYMENT_TYPE = @"Payment Type";
//static NSString *const MIDTRANS_CORE_USING_CREDIT_CARD_SCANNER = @"credit.card.scanner";
//static NSString *const MIDTRANS_CORE_CREDIT_CARD_SCANNER_OUTPUT = @"credit.card.scanner.output";
//static NSString *const MIDTRANS_CORE_CREDIT_CARD_SCANNER_OUTPUT_CARD_NUMBER = @"credit_card_result_scan";
//static NSString *const MIDTRANS_CORE_CREDIT_CARD_SCANNER_OUTPUT_EXPIRED_YEAR = @"credit_card_result_scan_expired_year";
//static NSString *const MIDTRANS_CORE_CREDIT_CARD_SCANNER_OUTPUT_EXPIRED_MONTH = @"credit_card_result_scan_expired_month";


static NSInteger const MIDTRANS_ERROR_CODE_3DSECURE = -30;
static NSInteger const MIDTRANS_ERROR_CODE_CANCELED_WEBPAYMENT = -31;

static NSInteger const MIDTRANS_ERROR_CODE_INVALIDCVV = -22;
static NSInteger const MIDTRANS_ERROR_CODE_INVALID_EXPIRY_DATE = -21;
static NSInteger const MIDTRANS_ERROR_CODE_INVALID_CC_NUMBER = -20;
static NSInteger const MIDTRANS_ERROR_CODE_INVALID_BIN = -23;

static NSInteger const MIDTRANS_ERROR_CODE_INVALID_CUSTOMER_DETAILS = -40;

static NSInteger const MIDTRANS_ERROR_CODE_INVALID_VALUE = -50;

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
