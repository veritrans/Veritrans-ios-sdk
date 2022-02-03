//
//  ViewController.swift
//  CoreKitDemo
//
//  Created by Muhammad Fauzi Masykur on 26/01/22.
//  Copyright © 2022 Midtrans. All rights reserved.
//

import UIKit
import MidtransCoreKit

class ViewController: UIViewController, Midtrans3DSControllerDelegate {
    @IBOutlet weak var infoLabel: UILabel!
    
    var redirectURL : String?
    var threeDSVersion : String?
    var threeDSViewController = Midtrans3DSController()
    
    var address = MidtransAddress()
    var customerDetails = MidtransCustomerDetails()
    var snapToken = MidtransTransactionTokenResponse()
    var ccToken: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MidtransNetworkLogger.shared().startLogging()
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Transaction Callback Result", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func generateRandomOrderId() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyy_hhmmss"
        return formatter.string(from: date)
    }
    
    func createSnaptoken () {
        let transactionDetails =  MidtransTransactionDetails(orderID: "randomOrderID\(generateRandomOrderId())", andGrossAmount: 10000, andCurrency: .IDR)
        let itemDetails = MidtransItemDetail(itemID: "jacket-001", name: "one piece jacket", price: 10000, quantity: 1)
        self.address = MidtransAddress(firstName: "leo", lastName: "davinci", phone: "082221009988", address: "jalan buntu 25", city: "jakarta", postalCode: "12345", countryCode: "IDN")
        self.customerDetails = MidtransCustomerDetails(firstName: "Leo", lastName: "Davinci", email: "leodavinci@midtrans.com", phone: "082221009988", shippingAddress: address, billingAddress: address)
        MidtransCreditCardConfig.shared().authenticationType = .type3DS
        
        MidtransMerchantClient.shared().requestTransactionToken(with: transactionDetails!, itemDetails:[itemDetails!], customerDetails: self.customerDetails) { response, error in
            if let response = response {
                self.snapToken = response
                self.getCreditCardToken()
            } else if let error = error {
                print("oops ada error \(error.localizedDescription)")
            }
        }
    }
    
    func getCreditCardToken () {
        let creditCardNUmber = MidtransCreditCard(number: "4811111111111114", expiryMonth: "12", expiryYear: "24", cvv: "123")
        let creditCardTokenRequest = MidtransTokenizeRequest(creditCard: creditCardNUmber, grossAmount: 10000)
        creditCardTokenRequest!.secure = true
        
        MidtransClient.shared().generateToken(creditCardTokenRequest!) { ccToken, error in
            if let ccToken = ccToken {
                print("token credit cardnya adalah \(ccToken)")
                self.ccToken = ccToken
                self.chargeUsingCreditCard(ccToken: self.ccToken!, snapToken: self.snapToken)
            } else {
                print("error is \(error?.localizedDescription)")
            }
        }
    }
    
    func chargeUsingCreditCard(ccToken :String, snapToken: MidtransTransactionTokenResponse) {
        let ccPaymentDetails = MidtransPaymentCreditCard.model(withToken: ccToken, customer: self.customerDetails, saveCard: false, point: nil)
        let ccTransaction = MidtransTransaction(paymentDetails: ccPaymentDetails, token:snapToken)
        
        MidtransMerchantClient.shared().perform(ccTransaction!) { result, error in
            if let result = result {
                self.threeDSViewController = Midtrans3DSController(token: snapToken.tokenId, redirectURL: result.redirectURL.absoluteString, threeDSVersion: result.threeDSVersion)
                self.threeDSViewController.delegate = self
                self.threeDSViewController.modalPresentationStyle = .fullScreen
                self.navigationController?.present(self.threeDSViewController, animated: true, completion: nil)
            } else {
                print("oops transaction is error \(error?.localizedDescription)")
            }
        }
    }
    
    @IBAction func open3dsWebView(_ sender: Any) {
        createSnaptoken()
        infoLabel.text = "Payment is starting.. please wait"
    }
    
    // MARK: - 3ds delegate methods
    func rbaDidGetTransactionStatus(_ transactionResult: MidtransTransactionResult!) {
        infoLabel.text = ""
        showAlert(message: "Your transaction status is \(transactionResult.transactionStatus ?? "null")")
    }
    
    func rbaDidGetError(_ error: Error!) {
        infoLabel.text = ""
        showAlert(message: "Oops, error on transaction")
    }
}

