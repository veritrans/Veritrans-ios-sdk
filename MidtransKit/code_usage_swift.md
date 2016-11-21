### Setup
Please read [this section](https://github.com/veritrans/Veritrans-ios-sdk/wiki/Getting-started-with-the-Veritrans-SDK) first before walking through the implementation guide

### Requirement

[Cococapods](https://cocoapods.org/) version 1.0.0

### Installation
Navigate to your project's root directory and run `pod init` to create a `Podfile`.

```
pod init
```

Open up the `Podfile` and add `MidtransKit` to your project's target.

```
use_frameworks!

def shared_pods
    pod 'MidtransKit'
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

### Integration

Once you have completed installation of MidtransKit, configure it with your `clientKey` and `environment` in your `AppDelegate.h`

```
//AppDelegate.swift
import MidtransKit

MidtransConfig.setClientKey(client_key, serverEnvironment: .sandbox OR .production, merchantURL: merchant_url)
```

### Credit Card Payment Feature
#### 2-Clicks
```
MidtransCreditCardConfig.setPaymentType(.twoclick, secure: true)
MidtransCreditCardConfig.disableTokenStorage(true)
```
Parameter `secure` is for enabling 3D secure transaction, but for 2-clicks, actually it's forced to `true` even if you set it to `false`.
You cannot use `tokenStorage` feature for 2-Click, so disable it and make sure that you're already setup your merchant server to support **save card**. You can see the documentation [here.](https://github.com/veritrans/veritrans-android/wiki/Implementation-for-Merchant-Server)


#### 1-Click

```
MidtransCreditCardConfig.setPaymentType(.oneclick, secure: <Boolean>)
MidtransCreditCardConfig.disableTokenStorage(false)
```
Parameter `secure` is for enabling 3D secure transaction, and you need to enable `Token Storage` feature. 

### Payment

##### Generate `TransactionTokenResponse` object

To create this object, you need to prepare required objects like `MidtransItemDetail` as an item representation etc.

```
//ViewController.swift
let itemDetail = MidtransItemDetail.init(itemID: item_id, name: item_name, price: item_price, quantity: item_qty)

let customerDetail = MidtransCustomerDetails.init(firstName: first_name, lastName: last_name, email: email_addr, phone: phone_number, shippingAddress: ship_addr, billingAddress: bill_addr)

let transactionDetail = MidtransTransactionDetails.init(orderID: order_ir, andGrossAmount: gross_amount)

MidtransMerchantClient.shared().requestTransactionToken(with: transactionDetail!, itemDetails: [itemDetail!], customerDetails: customerDetail) { (response, error) in
	if (response != nil) {
		//handle response                
    }
    else {        
    	//handle error
    }
}
```

##### Present the `MidtransUIPaymentViewController`

We provide you a `MidtransUIPaymentViewController` to handle all the payment, it's basically a `UINavigtionViewController` so you need to use `presentViewController:_ animated:_ completion:_` to present it.

```
let vc = MidtransUIPaymentViewController.init(token: response)
self.present(vc!, animated: true, completion: nil)
```

### Get Notified

Set your view controller to conform with **MidtransUIPaymentViewControllerDelegate**

```
//ViewController.swift

import MidtransKit

class ViewController: UIViewController, MidtransUIPaymentViewControllerDelegate

//other code
```

Set the delegate of MidtransUIPaymentViewController

```
//ViewController.swift

let vc = MidtransUIPaymentViewController.init(token: response)

//set the delegate
vc?.delegate = self

self.present(vc!, animated: true, completion: nil)
```

Add two methods to your view controller, these methods are from MidtransUIPaymentViewControllerDelegate protocol

```
//ViewController.swift

#pragma mark - MidtransUIPaymentViewControllerDelegate

func paymentViewController(_ viewController: MidtransUIPaymentViewController!, paymentFailed error: Error!) {
    
}
    
func paymentViewController(_ viewController: MidtransUIPaymentViewController!, paymentPending result: MidtransTransactionResult!) {
    
}
    
func paymentViewController(_ viewController: MidtransUIPaymentViewController!, paymentSuccess result: MidtransTransactionResult!) {
    
}

func paymentViewController_paymentCanceled(_ viewController: MidtransUIPaymentViewController!) {
    
}

```

### Customise Theme Color & Font

We've created `MidtransUIThemeManager` to configure the theme color and font of the veritrans payment UI.

```
let fontSource = MidtransUIFontSource.init(fontNameBold: font_name, fontNameRegular: font_name, fontNameLight: font_name)

MidtransUIThemeManager.applyCustomThemeColor(theme_color, themeFont: fontSource)
```
Put this code before you present the `MidtransUIPaymentViewController`

### Want Support [CardIO](https://www.card.io/) ?

Update the `Podfile` to this

```
use_frameworks!

def shared_pods
	pod 'MidtransKit'
	pod 'MidtransKit/CardIO'
end

target 'MyBeautifulApp' do
    shared_pods
end
```

Then because CardIO not support dynamic framework, your project need to implement **Bridging Header**, here is how you can implement it

1. Add a new file to Xcode (File > New > File), then select “Source” and click “Header File“.
2. Name your file “YourProjectName-Bridging-Header.h”.  Example: In my app Station, the file is named “Station-Bridging-Header”.
3. Create the file.
4. Navigate to your project build settings and find the “Swift Compiler – Code Generation” section.  You may find it faster to type in “Swift Compiler” into the search box to narrow down the results.  Note: If you don’t have a “Swift Compiler – Code Generation” section, this means you probably don’t have any Swift classes added to your project yet.  Add a Swift file, then try again.
5. Next to “Objective-C Bridging Header” you will need to add the name/path of your header file.  If your file resides in your project’s root folder simply put the name of the header file there.  Examples:  “ProjectName/ProjectName-Bridging-Header.h” or simply “ProjectName-Bridging-Header.h”.
6. Open up your newly created bridging header and import your Objective-C classes using #import statements.  Any class listed in this file will be able to be accessed from your swift classes.

Then insert this

```
#import <MidtransKit/MidtransKit.h>
#import <MidtransCoreKit/MidtransCoreKit.h>
```

to the bridging header file, now you can the SDK anywhere inside your project without importing **MidtransKit** inside your class


