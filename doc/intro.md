VT iOS SDK
==========


Overview
--------

VT iOS SDK is a iOS library written in Objective-C that will help iOS developer to integrate Veritrans service into their iOS application.

Note:

For developing and testing you will need a Sandbox Account.


Integration
-----------

### Step 1: Installation

TODO: Waiting for the SDK to be uploaded to Cocoapods.


### Step 2: Setting up environment

There are 5 configurations in the SDK, 2 of them is mandatory to be set before the SDK can work.

1. Client key (mandatory). This value should be filled with you Veritrans account's client key (you can get it from [TODO url to get client key])

    Example:
    
    `[VTConfig setClientKey:@"abcdef1234567890"];`

2. Merchant server base URL (mandatory). You should fill this with the base URL of your server.

    Example:

    `[VTConfig setMerchantBaseURL:@"http://vt-merchant.the-company.com"];`

3. Use production environment (optional, default to `false`). When your application is ready to be released, you need to set this to true.

    Example:

    `[VTConfig useProductionEnvironment:true];`

4. Merchant authentication parameter (optional, default to `nil`). If this value is set to non-nil, then every HTTP request to merchant server will contain this authencation data in one of its header entry.

    Example:

    `[VTConfig setMerchantAuthData:[VTMerchantAuthData initWithKey:@"X-Auth" withValue:@"user-auth-token"]];`

5. Merchant `register-card` API path (optional, default to `api/card/register`). You should change this to configure the API endpoint for registering card.

    Example:

    `[VTConfig setRegisterCardAPIPath:@"your-register-card-endpoint"];`

6. Merchant `charge` API path (optional, default to `api/charge`). You should change this to configure the API endpont for charging.

    Example:

    `[VTConfig setChargeAPIPath:@"your-charge-endpoint"];`


Usage
-----

There are two types of flow that this SDK provides:

1. UI flow

    Use this flow if you want integrate Veritrans service easily. The UI will be provided by the SDK.

2. Core flow

    Use this flow if you want full control of the payment flow, including using your own custom UI.


#### UI-flow

TODO: Waiting for UI flow to be integrated and tested.


#### Core-flow

TODO: Waiting for delete API to be implemented.


Full API Documentation
----------------------

TODO: Auto generated