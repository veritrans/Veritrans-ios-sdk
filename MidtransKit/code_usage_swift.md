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
pod install
```

Cocoapods will download and install `MidtransKit` and also create a .xcworkspace project.

### Integration

Once you have completed installation of MidtransKit, configure it with your `clientKey` and `environment` in your `AppDelegate.h`

```
//AppDelegate.swift
import MidtransKit

MidtransConfig.shared().setClientKey("client key", environment: .sandbox, merchantServerURL: "merchant server url")
```

### Credit Card Payment Feature
#### Custom Acquiring Bank

```
MidtransCreditCardConfig.shared().acquiringBank = acquiringBank
/*
these are banks that we've supported
MTAcquiringBankBCA
MTAcquiringBankBRI
MTAcquiringBankCIMB
MTAcquiringBankMandiri
MTAcquiringBankBNI
*/
```

#### Enable 3D Secure
```
MidtransCreditCardConfig.shared()?.authenticationType = .type3DS
```
#### 1-Click
To enable 1-click you need to:

1. enable 3ds
2. enable saved card


```
MidtransCreditCardConfig.shared().paymentType = .oneclick
MidtransCreditCardConfig.shared().saveCardEnabled = true
MidtransCreditCardConfig.shared()?.authenticationType = .type3DS
```

#### 2-Clicks

To enable 2-clicks you only need to:

1. enable saved card

```
MidtransCreditCardConfig.shared().paymentType = .twoclick
MidtransCreditCardConfig.shared().saveCardEnabled = true
```

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
vc?.paymentDelegate = self

self.present(vc!, animated: true, completion: nil)
```

Implement the delegate methods to your view controller, these methods are from MidtransUIPaymentViewControllerDelegate protocol

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

//This delegate methods is added on ios sdk v1.16.4 to handle the new3ds flow
func paymentViewController(_ viewController: MidtransUIPaymentViewController!, paymentDeny result: MidtransTransactionResult!) {
}

```

### Want to Implement Your Own Status Page
```
MidtransUIConfiguration.shared().hideStatusPage = true
```

### Hide `Did You Know` Label
If you don't want to show this view

![Did You Know Screenshot](http://s.pictub.club/2016/12/19/s0IYDC.png)

then set `hideDidYouKnowView` to `false`

```
MidtransUIConfiguration.shared().hideDidYouKnowView = true/false;
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
