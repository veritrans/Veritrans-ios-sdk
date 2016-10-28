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
```

### Customise Theme Color & Font

We've created `MidtransUIThemeManager` to configure the theme color and font of the veritrans payment UI.

```
let fontSource = MidtransUIFontSource.init(fontNameBold: font_name, fontNameRegular: font_name, fontNameLight: font_name)

MidtransUIThemeManager.applyCustomThemeColor(theme_color, themeFont: fontSource)
```
Put this code before you present the `MidtransUIPaymentViewController`


