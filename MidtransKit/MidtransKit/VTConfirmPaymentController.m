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
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Midtrans" bundle:VTBundle];
    self = [storyboard instantiateViewControllerWithIdentifier:@"VTConfirmPaymentController"];
    if (self) {
        self.cardNumber = cardNumber;
        self.grossAmount = grossAmount;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _cardNumberLabel.text = [_cardNumber formattedCreditCardNumber];
    
    NSNumberFormatter *formatter = [NSObject indonesianCurrencyFormatter];
    _grossAmountLabel.text = [formatter stringFromNumber:self.grossAmount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    self.modalSize = self.preferredContentSize;
    [controller presentCustomViewController:self completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
