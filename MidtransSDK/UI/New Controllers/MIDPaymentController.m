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
#import "MidtransVAViewController.h"
#import "MidtransUIPaymentDirectViewController.h"
#import "MIDPaymentIndomaretViewController.h"
#import "VTMandiriClickpayController.h"
#import "MIDDanamonOnlineViewController.h"
#import "MidtransUIPaymentGeneralViewController.h"

#import "MIDVendorUI.h"

@interface MIDPaymentController ()
@property (nonatomic) MIDPaymentMethod paymentMethod;
@property (nonatomic) MIDCheckoutTransaction *transaction;
@property (nonatomic) NSArray <NSObject <MIDCheckoutable>*> *options;

@property (nonatomic) MidtransLoadingView *loadingView;
@end

@implementation MIDPaymentController

- (instancetype)initWithTransaction:(MIDCheckoutTransaction *)transaction
                            options:(NSArray <NSObject <MIDCheckoutable>*> *_Nullable)options
                      paymentMethod:(MIDPaymentMethod)paymentMethod {
    if (self = [super initWithNibName:@"MIDPaymentController" bundle:VTBundle]) {
        self.transaction = transaction;
        self.options = options;
        self.paymentMethod = paymentMethod;
    }
    return self;
}

- (void)openPaymentPageWithInfo:(MIDPaymentInfo * _Nullable)info {
    [MIDVendorUI shared].info = info;
    
    UIViewController *vc = [self selectedViewController:self.paymentMethod];
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
}

- (NSArray *)loadPaymentMethodDetails {
    NSString* filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_%@", @"paymentMethods"];
    NSString *path = [VTBundle pathForResource:filenameByLanguage ofType:@"plist"];
    if (path == nil) {
        path = [VTBundle pathForResource:@"en_paymentMethods" ofType:@"plist"];
    }
    return [NSArray arrayWithContentsOfFile:path];
}

- (MIDPaymentDetail *)paymentMethodObject:(MIDPaymentMethod)pm {
    NSArray *details = [self loadPaymentMethodDetails];
    NSInteger index = [details indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj[@"id"] isEqualToString:[NSString stringFromPaymentMethod:pm]];
    }];
    if (index == NSNotFound) {
        return nil;
    } else {
        return [[MIDPaymentDetail alloc] initWithDictionary:details[index]];
    }
}

- (UIViewController *)selectedViewController:(MIDPaymentMethod)pm {
    MidtransUIPaymentController *vc;
    MIDPaymentDetail *model = [self paymentMethodObject:pm];
    
    //return all payment pages if the spesific payment isn't available
    if (model == nil) {
        return [[VTPaymentListController alloc] initWithNibName:@"VTPaymentListController" bundle:VTBundle];
    }
    
    switch (pm) {
        case MIDPaymentMethodBCAVA:
        case MIDPaymentMethodMandiriVA:
        case MIDPaymentMethodPermataVA:
        case MIDPaymentMethodBNIVA:
        case MIDPaymentMethodOtherVA:{
            vc = [[MidtransVAViewController alloc] initWithPaymentMethod:model];
            break;
        }
        case MIDPaymentMethodBCAKlikpay:
        case MIDPaymentMethodCIMBClicks:
        case MIDPaymentMethodBRIEpay:
        case MIDPaymentMethodMandiriECash:
        case MIDPaymentMethodAkulaku: {
            vc = [[MidtransUIPaymentGeneralViewController alloc] initWithModel:model];
            break;
        }
        case MIDPaymentMethodKlikbca:
        case MIDPaymentMethodTelkomselCash: {
            vc = [[MidtransUIPaymentDirectViewController alloc] initWithPaymentMethod:model];
            break;
        }
        case MIDPaymentMethodIndomaret: {
            vc = [[MIDPaymentIndomaretViewController alloc]initWithPaymentMethod:model];
            break;
        }
        case MIDPaymentMethodMandiriClickpay: {
            vc = [[VTMandiriClickpayController alloc] initWithPaymentMethod:model];
            break;
        }
        case MIDPaymentMethodDanamonOnline: {
            vc = [[MIDDanamonOnlineViewController alloc] initWithPaymentMethod:model];
            break;
        }
        default:
            vc = [[VTPaymentListController alloc] initWithNibName:@"VTPaymentListController" bundle:VTBundle];
            break;
    }
    
    [vc showDismissButton:YES];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // need to be in main thread to make the animation work
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self showLoadingWithText:@"Loading..."];
    }];
    
    if (self.transaction != nil) {
        [MIDClient checkoutWith:self.transaction
                        options:self.options
                     completion:^(MIDToken * _Nullable token, NSError * _Nullable error)
         {
             if (error) {
                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                message:error.localizedDescription
                                                                         preferredStyle:UIAlertControllerStyleAlert];
                 [alert addAction:[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                     [self dismissViewControllerAnimated:YES completion:nil];
                 }]];
                 return;
             }
             
             NSString *snapToken = token.token;
             [MIDVendorUI shared].snapToken = snapToken;
             
             [MIDClient getPaymentInfoWithToken:snapToken completion:^(MIDPaymentInfo * _Nullable info, NSError * _Nullable error) {
                 [self hideLoading];
                 
                 [self openPaymentPageWithInfo:info];
             }];
         }];
    }
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
