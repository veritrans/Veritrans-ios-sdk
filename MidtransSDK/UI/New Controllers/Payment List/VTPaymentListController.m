//
//  VTPaymentListController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/22/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//
#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#import "VTPaymentListController.h"
#import "VTClassHelper.h"
#import "MidtransUIListCell.h"
#import "VTPaymentHeader.h"
#import "MidGopayViewController.h"
#import "VTVAListController.h"
#import "MidtransVAViewController.h"
#import "VTMandiriClickpayController.h"
#import "MidtransUIPaymentGeneralViewController.h"
#import "MidtransUIPaymentDirectViewController.h"
#import "VTMandiriClickpayController.h"
#import "MIDPaymentIndomaretViewController.h"
#import "MidtransSavedCardController.h"
#import "VTPaymentListView.h"
#import "MidtransNewCreditCardViewController.h"
#import "MIDDanamonOnlineViewController.h"
#import "MidtransTransactionDetailViewController.h"
#import "MidtransUIThemeManager.h"
#import "UIColor+SNP_HexString.h"
#import "MIDVendorUI.h"
#import "MIDDanamonOnlineViewController.h"
#import "VTMandiriClickpayController.h"
#import "MIDUITrackingManager.h"
#import "MIDAlfamartViewController.h"

#define DEFAULT_HEADER_HEIGHT 80;
#define SMALL_HEADER_HEIGHT 40;

@interface VTPaymentListController () <UITableViewDelegate, VTPaymentListViewDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet VTPaymentListView *view;
//@property (nonatomic,strong) NSMutableArray *paymentMethodList;
//@property (nonatomic,strong) MidtransPaymentRequestV2Response *responsePayment;
@property (nonatomic) BOOL singlePayment;
@property (nonatomic) BOOL bankTransferOnly;
@property (nonatomic) CGFloat tableHeaderHeight;

//@property (nonatomic) MIDPaymentInfo *info;
@end

@implementation VTPaymentListController;

@dynamic view;

- (MIDPaymentInfo *)info {
    return [MIDVendorUI shared].info;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableDictionary *additionalData = [NSMutableDictionary dictionaryWithDictionary:@{@"card mode":@"normal"}];
    if (self.info.transaction.orderID) {
        [additionalData addEntriesFromDictionary:@{@"order id":self.info.transaction.orderID}];
    }
    [[MIDUITrackingManager shared] trackEventName:@"pg cc card details" additionalParameters:additionalData];
    self.view.delegate = self;

    self.tableHeaderHeight = DEFAULT_HEADER_HEIGHT;
    self.title =  [VTClassHelper getTranslationFromAppBundleForString:@"payment.list.title"];
    self.singlePayment = false;
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closePressed:)];
    self.navigationItem.leftBarButtonItem = closeButton;
    
    UIImage *logo = [MidtransImageManager merchantLogo];
    if (logo != nil) {
        UIView *titleViewWrapper = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 50)];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:titleViewWrapper.frame];
        [imgView setImage:[MidtransImageManager merchantLogo]];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.clipsToBounds = YES;
        [titleViewWrapper addSubview:imgView];
        self.navigationItem.titleView = titleViewWrapper;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.info.merchant.enabledPrinciples];
    NSString *imagePath = [NSString stringWithFormat:@"%@-seal",[array componentsJoinedByString:@"-"]];
    [self.view.secureBadgeImage setImage:[[UIImage imageNamed:imagePath inBundle:VTBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [self.view setPaymentInfo:self.info];
}

- (void)closePressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_CANCELED object:nil];
    UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
    if ([currentWindow viewWithTag:100101]) {
        [[currentWindow viewWithTag:100101] removeFromSuperview];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)reloadThemeColor {
    UIColor *color = [[MidtransUIThemeManager shared] themeColor];
    self.navigationController.navigationBar.tintColor = color;
}

- (UIColor *)colorFromSnapScheme:(NSString *)scheme {
    NSString *path = [VTBundle pathForResource:@"snap_colors" ofType:@"plist"];
    NSDictionary *snapColors = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *hex = snapColors[scheme];
    if (hex) {
        return [UIColor colorWithSNP_HexString:hex];
    }
    else {
        return nil;
    }
}

#pragma mark - VTPaymentListViewDelegate

- (void)paymentListView:(VTPaymentListView *)view didSelectModel:(MIDPaymentDetail *)model {
    if ([model.paymentID isEqualToString:@"va"]) {
        VTVAListController *vc = [[VTVAListController alloc] initWithPaymentMethod:model];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        MIDPaymentMethod method = model.method;
        if (method == MIDPaymentMethodCIMBClicks ||
            method == MIDPaymentMethodMandiriECash ||
            method == MIDPaymentMethodBCAKlikpay ||
            method == MIDPaymentMethodBRIEpay ||
            method == MIDPaymentMethodAkulaku) {
            
            MidtransUIPaymentGeneralViewController *vc = [[MidtransUIPaymentGeneralViewController alloc] initWithModel:model];
            [self.navigationController pushViewController:vc animated:!self.singlePayment];
        }
        else if (method == MIDPaymentMethodDanamonOnline) {
            MIDDanamonOnlineViewController *vc = [[MIDDanamonOnlineViewController alloc] initWithPaymentMethod:model];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (method == MIDPaymentMethodKlikbca ||
                 method == MIDPaymentMethodTelkomselCash) {
            MidtransUIPaymentDirectViewController *vc = [[MidtransUIPaymentDirectViewController alloc] initWithPaymentMethod:model];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (method == MIDPaymentMethodIndomaret) {
            MIDPaymentIndomaretViewController *vc = [[MIDPaymentIndomaretViewController alloc]initWithPaymentMethod:model];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (method == MIDPaymentMethodAlfamart) {
            MIDAlfamartViewController *vc = [[MIDAlfamartViewController alloc] initWithPaymentMethod:model];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (method == MIDPaymentMethodMandiriClickpay) {
            VTMandiriClickpayController *vc = [[VTMandiriClickpayController alloc] initWithPaymentMethod:model];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (method == MIDPaymentMethodCreditCard) {
            NSArray *cards = [MIDVendorUI shared].info.creditCard.savedCards;
            if (cards.count > 0) {
                MidtransSavedCardController *vc = [[MidtransSavedCardController alloc] initWithPaymentMethod:model];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else {
                MidtransNewCreditCardViewController *vc = [[MidtransNewCreditCardViewController alloc] initWithPaymentMethod:model];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
