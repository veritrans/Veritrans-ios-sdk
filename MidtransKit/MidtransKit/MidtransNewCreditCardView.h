//
//  MidtransNewCreditCardView.h
//  MidtransKit
//
//  Created by Vanbungkring on 1/19/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MidtransUITextField.h"
@interface MidtransNewCreditCardView : UIView
@property (weak, nonatomic) IBOutlet MidtransUITextField *creditCardNumberTextField;
@property (weak, nonatomic) IBOutlet MidtransUITextField *cardExpireTextField;
@property (weak, nonatomic) IBOutlet MidtransUITextField *cardCVVNumberTextField;

@end
