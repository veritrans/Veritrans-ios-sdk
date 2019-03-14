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
#import "MIDWebPaymentController.h"
#import "MidtransDeviceHelper.h"

@interface MIDDanamonOnlineViewController () <MIDWebPaymentControllerDelegate, MIDWebPaymentControllerDataSource>
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

@implementation MIDDanamonOnlineViewController {
    MIDWebPaymentResult *_paymentResult;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowInstructions = NO;
    
    self.title = self.paymentMethod.title;
    [self.view layoutIfNeeded];
    
    self.instructionHeaderLabel1.text = [VTClassHelper getTranslationFromAppBundleForString:@"danamon.instructions.header1"];
    self.instructionHeaderLabel2.text = [VTClassHelper getTranslationFromAppBundleForString:@"danamon.instructions.header2"];
    self.orderIdLabel.text = self.info.transaction.orderID;
    self.amountLabel.text = self.info.transaction.grossAmount.formattedCurrencyNumber;
    self.danamonStepLabel.text = [NSString stringWithFormat:[VTClassHelper getTranslationFromAppBundleForString:@"%@ step by step"], self.paymentMethod.title];
    self.totalAmountLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"total.amount"];
    [self.confirmButton setTitle:[VTClassHelper getTranslationFromAppBundleForString:@"confirm.payment"] forState:UIControlStateNormal];
    
    NSString* filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_%@", self.paymentMethod.paymentID];
    NSString *guidePath = [VTBundle pathForResource:filenameByLanguage ofType:@"plist"];
    if (guidePath == nil) {
        guidePath = [VTBundle pathForResource:[NSString stringWithFormat:@"en_%@",self.paymentMethod.paymentID] ofType:@"plist"];
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
    [transactionViewController presentAtPositionOfView:self.totalAmountBorderedView items:self.info.items];
}

- (void)handlCompletionWithError:(NSError * _Nullable)error result:(MIDWebPaymentResult * _Nullable)result {
    _paymentResult = result;
    
    [self hideLoading];
    
    if (error) {
        [self handleTransactionError:error];
    }
    else {
        if (result.redirectURL) {
            MIDWebPaymentController *vc = [[MIDWebPaymentController alloc] initWithPaymentURL:result.redirectURL];
            vc.delegate = self;
            vc.dataSource = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            [self handleTransactionSuccess:result];
        }
    }
}

- (IBAction)confirmPaymentDidTapped:(id)sender {
    [self showLoadingWithText:nil];
    
    [MIDDirectDebitCharge danamonOnlineWithToken:self.snapToken completion:^(MIDWebPaymentResult * _Nullable result, NSError * _Nullable error) {
        [self handlCompletionWithError:error result:result];
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

#pragma mark - MIDWebPaymentControllerDelegate

- (void)webPaymentController:(MIDWebPaymentController *)viewController didError:(NSError *)error {
    [self handleTransactionError:error];
}

- (void)webPaymentControllerDidPending:(MIDWebPaymentController *)viewController {
    if (_paymentResult) {
        [self handleTransactionPending:_paymentResult];
    }
}

#pragma mark - MIDWebPaymentControllerDataSource

- (NSString *)headerTitle {
    return self.paymentMethod.title;
}

- (NSString *)finishedSignText {
    return @"danamon/online/callback?";
}
@end
