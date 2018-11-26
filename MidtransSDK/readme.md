### Overview
Midtarns iOS SDK makes it easy to build an excellent payment experience in your iOS app. It provides powerful, customizable to collect your users' payment details.

We also expose the low-level APIs that power those elements to make it easy to build fully custom forms. This guide will take you all the way from integrating our SDK to accepting payments from your users via our payment method that we provide

### Prerequsites

1. Create a merchant account in MAP
2. Setup your merchant accounts settings, in particular Notification URL.
3. [Install and configure the SDK] (#install-and-configure-sdk)
4. [Integration] (#sdk-integration)
5. Checkout
 * Standard
 * Custom with Options
 		- Customer info
		- Items info
   		- Credit card options
   		- Gopay options
   		- Custom expired
   		- Custom fields
 * Get payment info
 * Charge
 		- Credit Card
		- VA / Bank Transfer
		- CIMB Clicks
		- Indomaret
		- BCA KlikPay
		- Klikbca
		- Mandiri E-Cash
		- Mandiri Clickpay
		- BRI E-Pay
		- Kios ON
		- Akulaku


### Supported Payments
1. Credit Card
2. VA / Bank Transfer
3. CIMB Clicks
4. Indomaret
5. BCA KlikPay
6. Klikbca
7. Mandiri E-Cash
8. Mandiri Clickpay
9. BRI E-Pay
10. Kios ON
11. Akulaku


#### <a id="install-and-configure-sdk"></a> Install and configure the SDK
You can choose to install the Stripe iOS SDK via your favorite method. We support CocoaPods and manual installation with both static and dynamic frameworks.

1. If you haven't already, install the latest version of [Cococapods](https://cocoapods.org/).
2. Add this line to your Podfile:


	```
	platform :ios, '7.0'

	def shared_pods
	pod 'MidtransCoreKit'
	end

	target 'MyBeautifulApp' do
	shared_pods
	end
	```
3. Run the following command:

	```
	pod install

	```
4. Don't forget to use the .xcworkspace file to open your project in Xcode, instead of the .xcodeproj file, from here on out.
5. In the future, to update to the latest version of the SDK, just run:

	```
	pod update MidtransCoreKit
	```

#### <a id="sdk-integration"></a> Integration
After you're done installing the SDK, configure it with your Stripe API keys.



```
#import "AppDelegate"
#import <Midtrans/MidtransCoreKit.h>


@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	[[MIDClient shared] configureClientKey:`client_key`
						 merchantServerURL:`merchant url`
						 environment:'environment'];
    	return YES;
	}
@end

```
