//
//  PaymentCreditCardViewController.h
//  VTDirectDemo
//
//  Created by Arie on 8/31/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TransactionTokenResponse;
@interface PaymentCreditCardViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardExpireMonthTextfield;
@property (weak, nonatomic) IBOutlet UITextField *cvvTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardExpireYeartextField;
@property (nonatomic, strong) TransactionTokenResponse *transactionToken;
@end
