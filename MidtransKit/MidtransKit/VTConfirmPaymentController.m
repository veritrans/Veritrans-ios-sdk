//
//  VTConfirmPaymentController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/14/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTConfirmPaymentController.h"
#import "VTClassHelper.h"
#import "UIViewController+Modal.h"

@interface VTConfirmPaymentController ()
@property (strong, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *grossAmountLabel;

@property (nonatomic) NSString *cardNumber;
@property (nonatomic) NSNumber *grossAmount;

@property (nonatomic, copy) void (^completion)(NSUInteger selectedIndex);

@end

@implementation VTConfirmPaymentController

- (instancetype)initWithCardNumber:(NSString *)cardNumber grossAmount:(NSNumber *)grossAmount {
    self = [[VTConfirmPaymentController alloc] initWithNibName:@"VTConfirmPaymentController" bundle:VTBundle];
    if (self) {
        self.cardNumber = cardNumber;
        self.grossAmount = grossAmount;
        self.modalSize = CGSizeMake(270, 250);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _cardNumberLabel.text = [_cardNumber formattedCreditCardNumber];
    
    _grossAmountLabel.text = self.grossAmount.formattedCurrencyNumber;
}

- (IBAction)buttonPressed:(UIButton *)sender {
    [self dismissCustomViewController:^{
        if (self.completion) {
            self.completion(sender.tag);
        }
    }];
}

- (void)showOnViewController:(UIViewController *)controller clickedButtonsCompletion:(void (^)(NSUInteger selectedIndex))completion {
    self.completion = completion;
    [controller presentCustomViewController:self completion:nil];
}

@end
