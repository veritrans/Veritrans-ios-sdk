//
//  MIDSwiftViewController.swift
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 09/01/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

import UIKit

class MIDSwiftViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MIDClient.configureClientKey(
            "VT-client-ABCDEFG-KM1234",
            merchantServerURL: "https://merchant-server.com/charge/index.php",
            environment: .sandbox
        )
        
        let orderID = "unique string"
        let trx = MIDCheckoutTransaction(
            orderID: orderID,
            grossAmount: 1000,
            currency: .IDR
        )
        
        let address = MIDAddress(
            firstName: "susan",
            lastName: "bahtiar",
            email: "susan_bahtiar@gmail.com",
            phone: "085293837657",
            address: "Kemayoran",
            city: "Jakarta",
            postalCode: "10610",
            countryCode: "IDN"
        )
        let customer = MIDCustomerDetails(
            firstName: "susan",
            lastName: "bahtiar",
            email: "susan_bahtiar@gmail.com",
            phone: "085293837657",
            billingAddress: address,
            shippingAddress: address
        )
        
        let item = MIDItem(
            id: "item1",
            price: 15000,
            quantity: 1,
            name: "Tooth paste",
            brand: "Pepsodent",
            category: "health care",
            merchantName: "Neo Store"
        )
        let checkoutItem = MIDCheckoutItems(items: [item])
        
        let whitelistBins = ["48111111", "41111111"]
        let blacklistBins = ["49111111", "44111111"]
        let term = MIDInstallmentTerm(bank: .BCA, terms: [6, 12])
        let installment = MIDInstallment(terms: [term], required: true)
        let cc = MIDCreditCard(
            creditCardTransactionType: .authorizeCapture,
            enableSecure: true,
            acquiringBank: .BCA,
            acquiringChannel: .MIGS,
            installment: installment,
            whiteListBins: whitelistBins,
            blackListBins: blacklistBins
        )
        
        let gopay = MIDCheckoutGoPay(callbackSchemeURL: "yoururlscheme://")
        
        let customExpiry = MIDCheckoutExpiry(start: Date(), duration: 1, unit: .day)
        
        let customField = MIDCustomField(
            customField1: "field content 1",
            customField2: "field content 2",
            customField3: "field content 3"
        )
        
        //and put it at checkout options
        
        MIDClient.checkout(with: trx, options: [customField]) { (token, error) in
            let snapToken = token?.token ?? ""
            
            MIDClient.getPaymentInfo(withToken: snapToken, completion: { (info, error) in
                
            })
            
            MIDBankTransferCharge.bca(withToken: snapToken, email: "susan_bahtiar@gmail.com", completion: { (result, error) in
                
            })
            
            MIDBankTransferCharge.permata(withToken: snapToken, email: "susan_bahtiar@gmail.com", completion: { (result, error) in
                
            })
            
            MIDBankTransferCharge.bni(withToken: snapToken, email: "susan_bahtiar@gmail.com", completion: { (result, error) in
                
            })
            
            MIDBankTransferCharge.mandiri(withToken: snapToken, email: "susan_bahtiar@gmail.com", completion: { (result, error) in
                
            })
            
            MIDDirectDebitCharge.mandiriClickpay(
                withToken: snapToken,
                cardNumber: "4111111111111111",
                clickpayToken: "000000",
                completion: { (result, error) in
                    
            })
            
            MIDDirectDebitCharge.cimbClicks(withToken: snapToken, completion: { (result, error) in
                
            })
            
            MIDDirectDebitCharge.briEpay(withToken: snapToken, completion: { (result, error) in
                
            })
            
            MIDDirectDebitCharge.bcaKlikPay(withToken: snapToken, completion: { (result, error) in
                
            })
            
            MIDDirectDebitCharge.klikbca(withToken: snapToken, userID: "SUSAN0707", completion: { (result, error) in
                
            })
            
            MIDStoreCharge.indomaret(withToken: snapToken, completion: { (result, error) in
                
            })
            
            MIDEWalletCharge.gopay(withToken: snapToken, completion: { (result, error) in
                
            })
            
            MIDEWalletCharge.tcash(withToken: snapToken, phoneNumber: "0811111111", completion: { (result, error) in
                
            })
            
            MIDEWalletCharge.mandiriECash(withToken: snapToken, completion: { (result, error) in
                
            })
        }
        
        
        
    }
    
}
