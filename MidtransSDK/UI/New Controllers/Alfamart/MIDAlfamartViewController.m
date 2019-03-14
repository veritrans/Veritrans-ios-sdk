//
//  MIDAlfamartViewController.m
//  MidtransKit
//
//  Created by Arie.Prasetiyo on 18/02/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "MIDAlfamartViewController.h"
#import "MIdtransUIBorderedView.h"
#import "SNPPostPaymentGeneralViewController.h"
#import "VTClassHelper.h"
#import "MIDAlfamartView.h"
#import "MidtransUIThemeManager.h"
#import "MidtransTransactionDetailViewController.h"
#import "VTSubGuideController.h"
#import "MIDAlfamartPostPaymentViewController.h"
#import "MIDUITrackingManager.h"
#import "MidtransDeviceHelper.h"

@interface MIDAlfamartViewController ()
@property (strong, nonatomic) IBOutlet MIDAlfamartView *view;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (nonatomic,strong) VTSubGuideController *subGuide;
@property (weak, nonatomic) IBOutlet UIView *instructionPage;
@property (weak, nonatomic) IBOutlet UILabel *headerViewAlfamartLabel;
@property (weak, nonatomic) IBOutlet MIdtransUIBorderedView *totalAmountBorderedView;
@end

@implementation MIDAlfamartViewController
@dynamic view;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.totalAmountLabel.text = self.info.transaction.grossAmount.formattedCurrencyNumber;
    self.orderIdLabel.text = self.info.transaction.orderID;
    self.title = self.paymentMethod.title;
    [[MIDUITrackingManager shared] trackEventName:[NSString stringWithFormat:@"pg %@",self.paymentMethod.shortName]];
    NSString* filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_%@", self.paymentMethod.paymentID];
    NSString *guidePath = [VTBundle pathForResource:filenameByLanguage ofType:@"plist"];
    if (guidePath == nil) {
        guidePath = [VTBundle pathForResource:[NSString stringWithFormat:@"en_%@",self.paymentMethod.paymentID] ofType:@"plist"];
    }
    NSArray *instructions = [VTClassHelper instructionsFromFilePath:guidePath];
    self.subGuide = [[VTSubGuideController alloc] initWithInstructions:instructions];
    [self addSubViewController:self.subGuide toView:self.instructionPage];
    // Do any additional setup after loading the view.
}
- (IBAction)confirmPaymentDidTapped:(id)sender {
    [self showLoadingWithText:nil];
    [[MIDUITrackingManager shared] trackEventName:@"btn confirm payment"];
    
    [MIDStoreCharge alfamartWithToken:self.snapToken completion:^(MIDCStoreResult * _Nullable result, NSError * _Nullable error) {
        [self hideLoading];
        if (error) {
            [self handleTransactionError:error];
        } else {
            MIDAlfamartPostPaymentViewController *postPaymentVAController = [[MIDAlfamartPostPaymentViewController alloc] initWithResult:result paymentMethod:self.paymentMethod];
            [self.navigationController pushViewController:postPaymentVAController animated:YES];
        }
    }];
}

@end
