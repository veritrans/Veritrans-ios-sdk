//
//  SNPPointViewController.m
//  MidtransKit
//
//  Created by Vanbungkring on 3/7/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "SNPPointViewController.h"
#import "MidtransInstallmentView.h"
#import "SNPPointView.h"
#import "VTClassHelper.h"
#import <MidtransCorekit/MidtransCorekit.h>
@interface SNPPointViewController ()<MidtransInstallmentViewDelegate>
@property (strong, nonatomic) IBOutlet SNPPointView *view;
@property (nonatomic,strong) NSString *creditCardToken;
@property (nonatomic,strong)MidtransInstallmentView *pointView;
@property (nonatomic,strong)SNPPointResponse *pointResponse;
@property (nonatomic,strong) NSMutableArray *pointRedeem;
@end

@implementation SNPPointViewController
@dynamic view;
-(instancetype _Nonnull)initWithToken:(MidtransTransactionTokenResponse *_Nullable)token
                        tokenizedCard:(NSString * _Nonnull)tokenizedCard
         andCompleteResponseOfPayment:(MidtransPaymentRequestV2Response * _Nonnull)responsePayment {
    if (self = [super initWithToken:token]) {
        self.creditCardToken = tokenizedCard;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Redeem BNI Reward Point";
    self.pointRedeem = [NSMutableArray new];
    [self.view configureAmountTotal:self.token];
    [self showLoadingWithText:@"Calculating your Point"];
    [self setupPointRedeem];
    [[MidtransMerchantClient shared] requestCustomerPointWithToken:self.token.tokenId
                                                andCreditCardToken:self.creditCardToken
                                                        completion:^(SNPPointResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            self.pointResponse = response;
            for (int i=1; i<=[response.pointBalanceAmount integerValue]; i++) {
                NSInteger reverse = [response.pointBalanceAmount intValue];
                [self.pointRedeem addObject:[NSNumber numberWithInteger:i]];
            }
            [self.pointView.installmentCollectionView reloadData];
            [self.pointView configureInstallmentView:self.pointRedeem];
         [self hideLoading];
        }
    }];

    
    // Do any additional setup after loading the view from its nib.
}
- (void)setupPointRedeem{
    self.view.pointViewWrapper.hidden = NO;
    self.pointView = [[VTBundle loadNibNamed:@"MidtransInstallmentView" owner:self options:nil] firstObject];
    self.pointView.delegate = self;
    self.pointView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view.pointViewWrapper addSubview:self.pointView];
    NSDictionary *views = @{@"view":self.pointView};
    [self.view.pointViewWrapper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:0 views:views]];
    [self.view.pointViewWrapper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:0 views:views]];
    [self.pointView setupInstallmentCollection];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
