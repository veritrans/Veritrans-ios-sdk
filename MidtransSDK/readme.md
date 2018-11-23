### Overview
We provide an API-only implementation for all payment types. This allows users to bring your own UI to the mobile App. Please read [this section](https://github.com/veritrans/Veritrans-ios-sdk/wiki/Getting-started-with-the-Veritrans-SDK) first before walking through the implementation guide

### Prerequsites

1. Create a merchant account in MAP
2. Setup your merchant accounts settings, in particular Notification URL.

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

### Requirment

#### Requirement

[Cococapods](https://cocoapods.org/) version 1.0.0

#### Installation
Navigate to your project's root directory and run `pod init` to create a `Podfile`.

```
pod init
```

Open up the `Podfile` and add `MidtransKit` to your project's target.

```
platform :ios, '7.0'

def shared_pods
pod 'MidtransCoreKit'
end

target 'MyBeautifulApp' do
shared_pods
end
```

Save the file and run the following to install `MidtransKit`.

```
pod install --verbose
```

Cocoapods will download and install `MidtransKit` and also create a .xcworkspace project.



#### Integration
#####Configure your Midtrans integration in your App Delegate

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
