//
//  VTPaymentController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 5/11/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentController.h"
#import "VTClassHelper.h"
#import "VTHudView.h"
#import "VTKeyboardAccessoryView.h"
#import "VTMultiGuideController.h"
#import "VTSingleGuideController.h"
#import "VTThemeManager.h"

@interface VTPaymentController ()
@property (nonatomic) VTHudView *hudView;
@property (nonatomic) VTKeyboardAccessoryView *keyboardAccessoryView;
@end

@implementation VTPaymentController

- (instancetype)initWithCustomerDetails:(VTCustomerDetails *)customerDetails itemDetails:(NSArray <VTItemDetail*>*)itemDetails transactionDetails:(VTTransactionDetails *)transactionDetails paymentMethodName:(VTPaymentListModel *)paymentMethod; {
    
    @try {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Midtrans" bundle:VTBundle];
        self = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    } @catch (NSException *exception) {
        self = [[[self class] alloc] initWithNibName:NSStringFromClass([self class]) bundle:VTBundle];
    }
    
    if (self) {
        self.paymentMethod = paymentMethod;
        self.customerDetails = customerDetails;
        self.itemDetails = itemDetails;
        self.transactionDetails = transactionDetails;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.hudView = [[VTHudView alloc] init];
}

- (void)addNavigationToTextFields:(NSArray <UITextField*>*)fields {
    _keyboardAccessoryView = [[VTKeyboardAccessoryView alloc] initWithFrame:CGRectZero fields:fields];
}

- (void)showLoadingHud {
    [self.hudView showOnView:self.navigationController.view];
}

- (void)hideLoadingHud {
    [self.hudView hide];
}

- (void)handleTransactionError:(NSError *)error {
    VTErrorStatusController *vc = [[VTErrorStatusController alloc] initWithError:error];
    [self.navigationController pushViewController:(UIViewController *)vc animated:YES];
}

- (void)handleTransactionSuccess:(VTTransactionResult *)result {
    VTPaymentStatusViewModel *vm = [[VTPaymentStatusViewModel alloc] initWithTransactionResult:result];
    VTSuccessStatusController *vc = [[VTSuccessStatusController alloc] initWithSuccessViewModel:vm];
    [self.navigationController pushViewController:(UIViewController *)vc animated:YES];
}

- (void)showGuideViewController {
    if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_BCA_IDENTIFIER] ||
        [self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_MANDIRI_IDENTIFIER] ||
        [self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_PERMATA_IDENTIFIER] ||
        [self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_OTHER_IDENTIFIER]) {
        VTMultiGuideController *vc = [[VTMultiGuideController alloc] initWithPaymentMethodModel:self.paymentMethod];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        VTSingleGuideController *vc = [[VTSingleGuideController alloc] initWithPaymentMethodModel:self.paymentMethod];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
