//
//  SNPPointViewController.m
//  MidtransKit
//
//  Created by Vanbungkring on 3/7/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "SNPPointViewController.h"
#import "MidtransInstallmentView.h"
@interface SNPPointViewController ()

@end

@implementation SNPPointViewController
-(instancetype _Nonnull)initWithToken:(MidtransTransactionTokenResponse *_Nullable)token
                        tokenizedCard:(NSString * _Nonnull)tokenizedCard
         andCompleteResponseOfPayment:(MidtransPaymentRequestV2Response * _Nonnull)responsePayment {
    if (self = [super initWithToken:token]) {
        NSLog(@"token-->%@",tokenizedCard);
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Redeem BNI Reward Point";
    
    // Do any additional setup after loading the view from its nib.
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
