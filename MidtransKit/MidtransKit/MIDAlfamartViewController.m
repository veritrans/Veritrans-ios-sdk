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

@interface MIDAlfamartViewController ()
@property (strong, nonatomic) IBOutlet MIDAlfamartView *view;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (nonatomic,strong) VTSubGuideController *subGuide;
@property (weak, nonatomic) IBOutlet UIView *instructionPage;
@property (weak, nonatomic) IBOutlet MIdtransUIBorderedView *totalAmountBorderedView;
@end

@implementation MIDAlfamartViewController
@dynamic view;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.totalAmountLabel.text = self.token.transactionDetails.grossAmount.formattedCurrencyNumber;
    self.orderIdLabel.text = self.token.transactionDetails.orderId;
    self.title = self.paymentMethod.title;
    [[SNPUITrackingManager shared] trackEventName:[NSString stringWithFormat:@"pg %@",self.paymentMethod.shortName]];
    NSString* filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_%@", self.paymentMethod.internalBaseClassIdentifier];
    NSString *guidePath = [VTBundle pathForResource:filenameByLanguage ofType:@"plist"];
    if (guidePath == nil) {
        guidePath = [VTBundle pathForResource:[NSString stringWithFormat:@"en_%@",self.paymentMethod.internalBaseClassIdentifier] ofType:@"plist"];
    }
    NSArray *instructions = [VTClassHelper instructionsFromFilePath:guidePath];
    self.subGuide = [[VTSubGuideController alloc] initWithInstructions:instructions];
    [self addSubViewController:self.subGuide toView:self.instructionPage];
    NSLog(@"data %@",instructions);
    
    // Do any additional setup after loading the view.
}
- (IBAction)confirmPaymentDidTapped:(id)sender {
    [self showLoadingWithText:nil];
    [[SNPUITrackingManager shared] trackEventName:@"btn confirm payment"];
    id<MidtransPaymentDetails> paymentDetails;
    paymentDetails = [[MidtransPaymentAlfa alloc] init];
    MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails token:self.token];
    [[MidtransMerchantClient shared] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
        [self hideLoading];
        if (error) {
            [self handleTransactionError:error];
        } else {
            MIDAlfamartPostPaymentViewController *postPaymentVAController = [[MIDAlfamartPostPaymentViewController alloc] initWithNibName:@"MIDAlfamartPostPaymentViewController" bundle:VTBundle];
            postPaymentVAController.transactionResult =  result;
            [self.navigationController pushViewController:postPaymentVAController animated:YES];
        }
    }];
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
