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
    
    @IBOutlet weak var snapTokenTextField: UITextField!
    @IBOutlet weak var redirectUrlTextField: UITextField!
    @IBOutlet weak var threeDsVersionTextField: UITextField!
    
    var snapToken : String?
    var redirectURL : String?
    var threeDSVersion : String?
    var threeDSViewController = Midtrans3DSController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.snapTokenTextField.text = "762e755a-a65b-458e-b625-fb286960c8d5"
        self.redirectUrlTextField.text = "https://api.sandbox.midtrans.com/v2/token/rba/redirect/481111-1114-4320e923-b05f-47b6-9657-529ccd79f749"
        self.threeDsVersionTextField.text = "1"
        getTextFieldValue()
        self.threeDSViewController = Midtrans3DSController(token: self.snapToken, redirectURL: self.redirectURL, threeDSVersion: self.threeDSVersion)
        self.threeDSViewController.delegate = self
    }
    
    func getTextFieldValue () {
        self.snapToken = snapTokenTextField.text
        self.redirectURL = redirectUrlTextField.text
        self.threeDSVersion = threeDsVersionTextField.text
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Transaction Callback Result", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
             }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func open3dsWebView(_ sender: Any) {
        self.navigationController?.present(self.threeDSViewController, animated: true, completion: nil)
    }
    
// MARK: - 3ds delegate methods
    func rbaDidGetTransactionStatus(_ transactionResult: MidtransTransactionResult!) {
        showAlert(message: "Your transaction status is \(transactionResult.transactionStatus ?? "null")")
    }
    
    func rbaDidGetError(_ error: Error!) {
        showAlert(message: "Oops, error on transaction")
    }

}

