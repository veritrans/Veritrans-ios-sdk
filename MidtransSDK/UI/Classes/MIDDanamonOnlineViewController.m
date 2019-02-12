//
//  MIDDanamonOnlineViewController.m
//  MidtransKit
//
//  Created by Tommy.Yohanes on 23/05/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDDanamonOnlineViewController.h"
#import "VTSubGuideController.h"
#import "VTClassHelper.h"
#import "MIdtransUIBorderedView.h"
#import "MidtransUIThemeManager.h"
#import "MidtransTransactionDetailViewController.h"

@interface MIDDanamonOnlineViewController () <MidtransPaymentWebControllerDelegate>
@property (nonatomic) MidtransPaymentRequestV2Merchant *merchant;
@property (nonatomic) BOOL isShowInstructions;
@property (nonatomic,strong) VTSubGuideController *subGuide;
@property (weak, nonatomic) IBOutlet UILabel *instructionHeaderLabel1;
@property (weak, nonatomic) IBOutlet UILabel *instructionHeaderLabel2;
@property (weak, nonatomic) IBOutlet UIButton *indicatorButton;
@property (weak, nonatomic) IBOutlet MIdtransUIBorderedView *totalAmountBorderedView;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIView *instructionPage;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;

@end

@implementation MIDDanamonOnlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowInstructions = NO;

    self.title = self.paymentMethod.title;
    [self.view layoutIfNeeded];
    
    self.instructionHeaderLabel1.text = [VTClassHelper getTranslationFromAppBundleForString:@"danamon.instructions.header1"];
    self.instructionHeaderLabel2.text = [VTClassHelper getTranslationFromAppBundleForString:@"danamon.instructions.header2"];
    self.orderIdLabel.text = self.token.transactionDetails.orderId;
    self.amountLabel.text = self.token.transactionDetails.grossAmount.formattedCurrencyNumber;
    self.danamonStepLabel.text = [NSString stringWithFormat:[VTClassHelper getTranslationFromAppBundleForString:@"%@ step by step"], self.paymentMethod.title];
    self.totalAmountLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"total.amount"];
    [self.confirmButton setTitle:[VTClassHelper getTranslationFromAppBundleForString:@"confirm.payment"] forState:UIControlStateNormal];
    
    NSString* filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_%@", self.paymentMethod.internalBaseClassIdentifier];
    NSString *guidePath = [VTBundle pathForResource:filenameByLanguage ofType:@"plist"];
    if (guidePath == nil) {
        guidePath = [VTBundle pathForResource:[NSString stringWithFormat:@"en_%@",self.paymentMethod.internalBaseClassIdentifier] ofType:@"plist"];
    }
    NSArray *instructions = [VTClassHelper instructionsFromFilePath:guidePath];
    self.subGuide = [[VTSubGuideController alloc] initWithInstructions:instructions];
    [self.view updateConstraintsIfNeeded];
    [self addSubViewController:self.subGuide toView:self.instructionPage];
    self.subGuide.view.hidden = YES;
    
    [self.totalAmountBorderedView addGestureRecognizer:
     [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(totalAmountBorderedViewTapped:)]];
    self.amountLabel.textColor = [[MidtransUIThemeManager shared] themeColor];
}

- (void)totalAmountBorderedViewTapped:(id) sender {
    MidtransTransactionDetailViewController *transactionViewController = [[MidtransTransactionDetailViewController alloc] initWithNibName:@"MidtransTransactionDetailViewController" bundle:VTBundle];
    [transactionViewController presentAtPositionOfView:self.totalAmountBorderedView items:self.token.itemDetails];
}

- (IBAction)confirmPaymentDidTapped:(id)sender {
    [self showLoadingWithText:nil];

    id<MidtransPaymentDetails>paymentDetails;
    paymentDetails = [[MidtransPaymentDanamonOnline alloc] init];
    MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails token:self.token];
    [[MidtransMerchantClient shared]
     performTransaction:transaction
     completion:^(MidtransTransactionResult *result, NSError *error) {
         [self hideLoading];
         if (error) {
             [self handleTransactionError:error];
         }
         else {
             if (result.redirectURL) {
                 MidtransPaymentWebController *vc = [[MidtransPaymentWebController alloc]
                                                     initWithMerchant:self.merchant
                                                     result:result
                                                     identifier:self.paymentMethod.internalBaseClassIdentifier];
                 vc.delegate = self;
                 [self.navigationController pushViewController:vc animated:YES];
             }
             else {
                 [self handleTransactionSuccess:result];
             }
         }
     }];
}

- (IBAction)reloadInstructionDidTapped:(id)sender {
    if (!self.isShowInstructions) {
        self.subGuide.view.hidden = NO;
        self.isShowInstructions = 1;
    } else {
        self.subGuide.view.hidden = YES;
        self.isShowInstructions =0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - VTPaymentWebControllerDelegate

- (void)webPaymentController_transactionFinished:(MidtransPaymentWebController *)webPaymentController {
    [super handleTransactionSuccess:webPaymentController.result];
}

- (void)webPaymentController_transactionPending:(MidtransPaymentWebController *)webPaymentController {
    [self handleTransactionPending:webPaymentController.result];
}

- (void)webPaymentController:(MidtransPaymentWebController *)webPaymentController transactionError:(NSError *)error {
    [self handleTransactionError:error];
}
@end
