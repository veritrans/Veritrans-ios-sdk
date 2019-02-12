//
//  VTPaymentDirectView.m
//  MidtransKit
//
//  Created by Arie on 6/18/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIPaymentDirectView.h"
#import "MidtransDirectHeader.h"
#import "VTClassHelper.h"
#import "VTGuideCell.h"
#import "MidtransUIToast.h"

@interface MidtransUIPaymentDirectView() <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) MidtransDirectHeader *headerView;
@property (nonatomic) NSArray *guides;
@property (nonatomic) NSArray *mainGuides;
@end

@implementation MidtransUIPaymentDirectView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.totalAmountTextLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"total.amount"];
    [self.confirmPaymentButton setTitle:[VTClassHelper getTranslationFromAppBundleForString:@"confirm.payment"] forState:UIControlStateNormal];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.hidden = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"MidtransDirectHeader" bundle:VTBundle] forCellReuseIdentifier:@"MidtransDirectHeader"];
    [self.tableView registerNib:[UINib nibWithNibName:@"VTGuideCell" bundle:VTBundle] forCellReuseIdentifier:@"VTGuideCell"];
    
    self.headerView = [self.tableView dequeueReusableCellWithIdentifier:@"MidtransDirectHeader"];
    [self.headerView.showInstructionsButton addTarget:self action:@selector(showInstrunctions) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserverForName:VTTapableLabelDidTapLink object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [[UIPasteboard generalPasteboard] setString:note.object];
        [MidtransUIToast createToast:[VTClassHelper getTranslationFromAppBundleForString:@"toast.copy-text"] duration:1.5 containerView:self];
    }];

}
- (void)showInstrunctions {
    self.guides = self.mainGuides;
    [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.guides.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.headerView;
    }
    VTGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VTGuideCell"];
    if(indexPath.row % 2 > 0) {
         cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    }
    [cell setInstruction:self.guides[indexPath.row-1] number:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (IS_IOS8_OR_ABOVE) {
        return UITableViewAutomaticDimension;
    }
    else {
        if (indexPath.row == 0) {
            return [self.headerView.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        }
        else {
            static VTGuideCell *cell = nil;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                cell = [self.tableView dequeueReusableCellWithIdentifier:@"VTGuideCell"];
            });
            if(indexPath.row %2 ==0) {
                 cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
            }
            [cell setInstruction:self.guides[indexPath.row-1] number:indexPath.row];
            return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        }
    }
}

- (MidtransUITextField *)emailTextField {
    return self.headerView.emailTextField;
}

- (UILabel *)instructionTitleLabel {
    return self.headerView.tutorialTitleLabel;
}

- (MidtransVAType)paymentTypeWithID:(NSString *)paymentMethodID {
    if ([paymentMethodID isEqualToString:MIDTRANS_PAYMENT_BCA_VA]) {
        return VTVATypeBCA;
    }
    else if ([paymentMethodID isEqualToString:MIDTRANS_PAYMENT_ECHANNEL]) {
        return VTVATypeMandiri;
    }
    else if ([paymentMethodID isEqualToString:MIDTRANS_PAYMENT_PERMATA_VA]) {
        return VTVATypePermata;
    }
    else if ([paymentMethodID isEqualToString:MIDTRANS_PAYMENT_OTHER_VA]) {
        return VTVATypeOther;
    }
    else {
        return VTVATypeAll;
    }
}

- (void)initViewWithPaymentID:(NSString *)paymentMethodID email:(NSString *)email {
    NSString *filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_%@", paymentMethodID];
    
    NSString *guidePath = [VTBundle pathForResource:filenameByLanguage ofType:@"plist"];
    if (guidePath == nil) {
        guidePath = [VTBundle pathForResource:[NSString stringWithFormat:@"en_%@",paymentMethodID] ofType:@"plist"];
    }
    self.mainGuides = [VTClassHelper instructionsFromFilePath:guidePath];
        [self showInstrunctions];
    
    if ([paymentMethodID isEqualToString:MIDTRANS_PAYMENT_INDOSAT_DOMPETKU]) {
        self.headerView.emailTextField.keyboardType = UIKeyboardTypePhonePad;
        self.headerView.emailTextField.placeholder = [VTClassHelper getTranslationFromAppBundleForString:@"payment.indosat-dompetku.token-placeholder"];
        self.headerView.descLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"payment.indosat-dompetku.token-note"];
    }
    else {
        self.headerView.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        
        if ([paymentMethodID isEqualToString:MIDTRANS_PAYMENT_KLIK_BCA]) {
            self.headerView.emailTextField.placeholder = [VTClassHelper getTranslationFromAppBundleForString:@"KlikBCA User ID"];
            self.headerView.descriptionHeightConstraint.constant = 0.0f;
        }
        else if ([paymentMethodID isEqualToString:MIDTRANS_PAYMENT_TELKOMSEL_CASH]) {
            self.headerView.emailTextField.placeholder = [VTClassHelper getTranslationFromAppBundleForString:@"payment.telkomsel-cash.token-placeholder"];
            self.headerView.descLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"payment.telkomsel-cash.token-note"];
        }
        else {
            self.headerView.emailTextField.text = email;
            self.headerView.emailTextField.placeholder = [VTClassHelper getTranslationFromAppBundleForString:@"payment.email-placeholder"];
            self.headerView.descLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"payment.email-note"];
            
            if ([paymentMethodID isEqualToString:MIDTRANS_PAYMENT_KIOS_ON]) {
                self.headerView.descLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"payment.kioson.note"];
            }
        }
    }
}

@end
