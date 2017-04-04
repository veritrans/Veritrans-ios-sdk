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

@interface MidtransUIPaymentDirectView() <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) MidtransDirectHeader *headerView;
@property (nonatomic) NSArray *guides;
@end

@implementation MidtransUIPaymentDirectView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 60;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MidtransDirectHeader" bundle:VTBundle] forCellReuseIdentifier:@"MidtransDirectHeader"];
    [self.tableView registerNib:[UINib nibWithNibName:@"VTGuideCell" bundle:VTBundle] forCellReuseIdentifier:@"VTGuideCell"];
    
    self.headerView = [self.tableView dequeueReusableCellWithIdentifier:@"MidtransDirectHeader"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.guides.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.headerView;
    }
    VTGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VTGuideCell"];
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
    self.guides = [VTClassHelper instructionsFromFilePath:[VTBundle pathForResource:paymentMethodID ofType:@"plist"]];
    [self.tableView reloadData];
    
    if ([paymentMethodID isEqualToString:MIDTRANS_PAYMENT_INDOSAT_DOMPETKU]) {
        self.headerView.emailTextField.keyboardType = UIKeyboardTypePhonePad;
        self.headerView.emailTextField.placeholder = UILocalizedString(@"payment.indosat-dompetku.token-placeholder", nil);
        self.headerView.descLabel.text = UILocalizedString(@"payment.indosat-dompetku.token-note", nil);
    }
    else {
        self.headerView.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        
        if ([paymentMethodID isEqualToString:MIDTRANS_PAYMENT_KLIK_BCA]) {
            self.headerView.emailTextField.placeholder = UILocalizedString(@"KlikBCA User ID", nil);
            self.headerView.descLabel.text = UILocalizedString(@"payment.klikbca.userid-note", nil);
        }
        else if ([paymentMethodID isEqualToString:MIDTRANS_PAYMENT_TELKOMSEL_CASH]) {
            self.headerView.emailTextField.placeholder = UILocalizedString(@"payment.telkomsel-cash.token-placeholder", nil);
            self.headerView.descLabel.text = UILocalizedString(@"payment.telkomsel-cash.token-note", nil);
        }
        else {
            self.headerView.emailTextField.text = email;
            self.headerView.emailTextField.placeholder = UILocalizedString(@"payment.email-placeholder", nil);
            self.headerView.descLabel.text = UILocalizedString(@"payment.email-note", nil);
            
            if ([paymentMethodID isEqualToString:MIDTRANS_PAYMENT_KIOS_ON]) {
                self.headerView.descLabel.text = UILocalizedString(@"payment.kioson.note", nil);
            }
        }
    }
}

@end
