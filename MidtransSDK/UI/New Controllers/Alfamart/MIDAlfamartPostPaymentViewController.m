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

@property (nonatomic) MIDCStoreResult *result;
@end

@implementation MIDAlfamartPostPaymentViewController

- (instancetype)initWithResult:(MIDCStoreResult *)result paymentMethod:(MIDPaymentDetail *)paymentMethod {
    if (self = [super initWithPaymentMethod:paymentMethod]) {
        self.result = result;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.guide1View.hidden = YES;
    self.instructionPage.hidden = YES;
    self.paymentCodeLabel.text = self.result.paymentCode;
    NSString *completeString =  [NSString stringWithFormat:@"Please complete payment before %@",self.result.expiration];
    NSString *boldString = self.result.expiration;
    NSRange boldRange = [completeString rangeOfString:boldString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:completeString];
    [attributedString addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:boldRange];
    self.expireTimeLabelText.attributedText = attributedString;
    self.expireTimeLabelText.text = [NSString stringWithFormat:@"Please complete payment before %@",self.result.expiration];
    // Do any additional setup after loading the view.
    self.totalAmountLabel.text = self.info.transaction.grossAmount.formattedCurrencyNumber;
    self.orderIdLabel.text = self.info.transaction.orderID;
    self.title = @"Alfamart";
    
    NSString* filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_alfamart"];
    NSString *guidePath = [VTBundle pathForResource:filenameByLanguage ofType:@"plist"];
    if (guidePath == nil) {
        guidePath = [VTBundle pathForResource:[NSString stringWithFormat:@"en_%@",self.paymentMethod.paymentID] ofType:@"plist"];
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
    [[UIPasteboard generalPasteboard] setString:self.result.paymentCode];
    [MidtransUIToast createToast:[VTClassHelper getTranslationFromAppBundleForString:@"toast.copy-text"] duration:1.5 containerView:self.view];
}

- (IBAction)expandInstructionsDidTapped:(id)sender {
    self.guide1View.hidden = !self.guide1View.hidden;
    self.instructionPage.hidden = !self.instructionPage.hidden;
}
- (IBAction)confirmPaymentButtonDidtapped:(id)sender {
    NSDictionary *userInfo = @{TRANSACTION_RESULT_KEY:self.result.dictionaryValue};
    [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_PENDING object:nil userInfo:userInfo];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
