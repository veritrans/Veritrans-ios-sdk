//
//  PaymentCreditCardView.h
//  VTDirectDemo
//
//  Created by Vanbungkring on 2/10/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JVFloatLabeledTextField.h>
@interface PaymentCreditCardView : UIView
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *creditcardTextField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *validDateTextField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *cvvTextField;

@end
