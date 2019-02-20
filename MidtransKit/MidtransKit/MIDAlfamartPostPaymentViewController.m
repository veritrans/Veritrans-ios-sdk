//
//  MIDAlfamartPostPaymentViewController.m
//  MidtransKit
//
//  Created by Arie.Prasetiyo on 20/02/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "MIDAlfamartPostPaymentViewController.h"
#import "VTClassHelper.h"
@interface MIDAlfamartPostPaymentViewController ()
@property (weak, nonatomic) IBOutlet UILabel *paymentCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *expireTimeLabelText;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;

@end

@implementation MIDAlfamartPostPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Alfamart";
    self.paymentCodeLabel.text = self.transactionResult.indomaretPaymentCode;
    NSString *completeString =  [NSString stringWithFormat:@"Please complete payment before %@",self.transactionResult.alfamartExpireTime];
    NSString *boldString = self.transactionResult.alfamartExpireTime;
    NSRange boldRange = [completeString rangeOfString:boldString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:completeString];
    [attributedString addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:boldRange];
    self.expireTimeLabelText.attributedText = attributedString;
    self.expireTimeLabelText.text = [NSString stringWithFormat:@"Please complete payment before %@",self.transactionResult.alfamartExpireTime];
    // Do any additional setup after loading the view.
    
    self.totalAmountLabel.text = self.token.transactionDetails.grossAmount.formattedCurrencyNumber;
    self.orderIdLabel.text = self.token.transactionDetails.orderId;
    self.title = self.paymentMethod.title;
    
}
- (IBAction)copyButtonDidTapped:(id)sender {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)expandInstructionsDidTapped:(id)sender {
}

@end
