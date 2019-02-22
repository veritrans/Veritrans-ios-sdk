//
//  MIDAlfamartPostPaymentViewController.m
//  MidtransKit
//
//  Created by Arie.Prasetiyo on 20/02/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "MIDAlfamartPostPaymentViewController.h"
#import "VTClassHelper.h"
#import "VTSubGuideController.h"
#import "MidtransUIToast.h"
@interface MIDAlfamartPostPaymentViewController ()
@property (weak, nonatomic) IBOutlet UILabel *paymentCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *expireTimeLabelText;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (nonatomic,strong) VTSubGuideController *subGuide;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UIView *guide1View;
@property (weak, nonatomic) IBOutlet UIView *instructionPage;
@property (weak, nonatomic) IBOutlet UIButton *expandingButton;
@end

@implementation MIDAlfamartPostPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.guide1View.hidden = YES;
    self.instructionPage.hidden = YES;
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
     self.title = @"Alfamart";

    NSString* filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_alfamart"];
    NSString *guidePath = [VTBundle pathForResource:filenameByLanguage ofType:@"plist"];
    if (guidePath == nil) {
        guidePath = [VTBundle pathForResource:[NSString stringWithFormat:@"en_%@",self.paymentMethod.internalBaseClassIdentifier] ofType:@"plist"];
    }
    NSArray *instructions = [VTClassHelper instructionsFromFilePath:guidePath];
    NSMutableArray *rangeArrayInstructions = [NSMutableArray new];
    for (int i = 0; i<instructions.count; i++) {
        if (i>1) {
            [rangeArrayInstructions addObject:instructions[i]];
        }
    }
    self.subGuide = [[VTSubGuideController alloc] initWithInstructions:rangeArrayInstructions];
    [self addSubViewController:self.subGuide toView:self.instructionPage];
    
    
}
- (IBAction)copyButtonDidTapped:(id)sender {
    [[UIPasteboard generalPasteboard] setString:self.transactionResult.indomaretPaymentCode];
    [MidtransUIToast createToast:[VTClassHelper getTranslationFromAppBundleForString:@"toast.copy-text"] duration:1.5 containerView:self.view];
}

- (IBAction)expandInstructionsDidTapped:(id)sender {
    self.guide1View.hidden = !self.guide1View.hidden;
    self.instructionPage.hidden = !self.instructionPage.hidden;
}
- (IBAction)confirmPaymentButtonDidtapped:(id)sender {
    NSDictionary *userInfo = @{TRANSACTION_RESULT_KEY:self.transactionResult};
    [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_PENDING object:nil userInfo:userInfo];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
