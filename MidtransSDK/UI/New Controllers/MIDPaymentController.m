//
//  MIDPaymentController.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 12/02/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "MIDPaymentController.h"
#import "VTClassHelper.h"
#import "MidtransUIPaymentViewController.h"
#import "MidtransLoadingView.h"
#import "MIDArrayHelper.h"
#import "VTPaymentListController.h"

#import "MIDVendorUI.h"

@interface MIDPaymentController ()
@property (nonatomic) MIDCheckoutTransaction *transaction;
@property (nonatomic) NSArray <NSObject <MIDCheckoutable>*> *options;

@property (nonatomic) MidtransLoadingView *loadingView;
@end

@implementation MIDPaymentController

- (instancetype)initWithTransaction:(MIDCheckoutTransaction *)transaction
                            options:(NSArray <NSObject <MIDCheckoutable>*> *_Nullable)options {
    if (self = [super initWithNibName:@"MIDPaymentController" bundle:VTBundle]) {
        self.transaction = transaction;
        self.options = options;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        //show loading
        [self showLoadingWithText:@"Loading..."];
    }];
    
    if (self.transaction != nil) {
        [MIDClient checkoutWith:self.transaction
                        options:self.options
                     completion:^(MIDToken * _Nullable token, NSError * _Nullable error)
         {
             NSString *snapToken = token.token;
             
             [MIDClient getPaymentInfoWithToken:snapToken completion:^(MIDPaymentInfo * _Nullable info, NSError * _Nullable error) {
                 //hide loading
                 [self hideLoading];
                 
                 [MIDVendorUI shared].info = info;
                 
                 VTPaymentListController *vc = [[VTPaymentListController alloc] initWithNibName:@"VTPaymentListController" bundle:VTBundle];
                 UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
                 
                 [self addChildViewController:nvc];
                 [self.view addSubview:nvc.view];
                 [nvc didMoveToParentViewController:self];
                 [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[main]-0-|"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:@{@"main": nvc.view}]];
                 [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[main]-0-|"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:@{@"main": nvc.view}]];

//                 MidtransUIPaymentViewController *paymentVC = [[MidtransUIPaymentViewController alloc] initWithToken:token];
//                 [self addChildViewController:paymentVC];
//                 [self.view addSubview:paymentVC.view];
//                 [paymentVC didMoveToParentViewController:self];
             }];
         }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)showLoadingWithText:(NSString *)text {
    if (self.loadingView == nil) {
        self.loadingView = [VTBundle loadNibNamed:@"MidtransLoadingView" owner:self options:nil].firstObject;
    }
    
    UIView *container = self.navigationController.view;
    if (container == nil) {
        container = self.view;
    }
    [self.loadingView showInView:container withText:text];
}

- (void)hideLoading {
    [self.loadingView hide];
}

@end
