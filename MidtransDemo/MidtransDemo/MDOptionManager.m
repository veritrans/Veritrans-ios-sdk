//
//  MDOptionManager.m
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 3/27/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MDOptionManager.h"
#import "MDUtils.h"
#import <MidtransKit/MidtransKit.h>

@interface MDOptionManager()

@end

@implementation MDOptionManager

@synthesize colorOption = _colorOption;
@synthesize secure3DOption = _secure3DOption;

+ (MDOptionManager *)shared {
    static MDOptionManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (instancetype)init {
    if (self = [super init]) {
        self.secure3DOption = [self unArchivedObject:@"md_3ds"];
        self.issuingBankOption = [self unArchivedObject:@"md_bank"];
        self.saveCardOption = [self unArchivedObject:@"md_savecard"];
        self.promoOption = [self unArchivedObject:@"md_promo"];
        self.preauthOption = [self unArchivedObject:@"md_preauth"];
        self.expireTimeOption = [self unArchivedObject:@"md_expire"];
        self.colorOption = [self unArchivedObject:@"md_color"];
        self.ccTypeOption = [self unArchivedObject:@"md_cc_type"];
        self.permataVAOption = [self unArchivedObject:@"md_permata_va"];
        self.bcaVAOption = [self unArchivedObject:@"md_bca_va"];
        self.bniPointOption = [self unArchivedObject:@"md_bni_point"];
        self.installmentOption = [self unArchivedObject:@"md_installment"];
    }
    return self;
}

- (void)setCcTypeOption:(MDOption *)ccTypeOption {
    _ccTypeOption = ccTypeOption;
    [self archiveObject:ccTypeOption key:@"md_cc_type"];
}
- (void)setSecure3DOption:(MDOption *)secure3DOption {
    _secure3DOption = secure3DOption;
    [self archiveObject:secure3DOption key:@"md_3ds"];
}
- (MDOption *)secure3DOption {
    if (!_secure3DOption) {
        self.secure3DOption = [MDOption optionGeneralWithName:@"Enable" value:@YES];
    }
    return _secure3DOption;
}
- (void)setIssuingBankOption:(MDOption *)issuingBankOption {
    _issuingBankOption = issuingBankOption;
    [self archiveObject:issuingBankOption key:@"md_bank"];
}
- (void)setExpireTimeOption:(MDOption *)expireTimeOption {
    _expireTimeOption = expireTimeOption;
    [self archiveObject:expireTimeOption key:@"md_expire"];
}
- (void)setSaveCardOption:(MDOption *)saveCardOption {
    _saveCardOption = saveCardOption;
    [self archiveObject:saveCardOption key:@"md_savecard"];
}
- (void)setPromoOption:(MDOption *)promoOption {
    _promoOption = promoOption;
    [self archiveObject:promoOption key:@"md_promo"];
}
- (void)setPreauthOption:(MDOption *)preauthOption {
    _preauthOption = preauthOption;
    [self archiveObject:preauthOption key:@"md_preauth"];
}
- (void)setColorOption:(MDOption *)colorOption {
    _colorOption = colorOption;
    [self archiveObject:colorOption key:@"md_color"];
}
- (MDOption *)colorOption {
    if (!_colorOption) {
        self.colorOption = [MDOption optionColorWithName:@"Blue" value:RGB(47, 128, 194)];
    }
    return _colorOption;
}
- (void)setBniPointOption:(MDOption *)bniPointOption {
    _bniPointOption = bniPointOption;
    [self archiveObject:bniPointOption key:@"md_bni_point"];
}
- (void)setPermataVAOption:(MDOption *)permataVAOption {
    _permataVAOption = permataVAOption;
    [self archiveObject:permataVAOption key:@"md_permata_va"];
}
- (void)setBcaVAOption:(MDOption *)bcaVAOption {
    _bcaVAOption = bcaVAOption;
    [self archiveObject:bcaVAOption key:@"md_bca_va"];
}
- (void)setInstallmentOption:(MDOption *)installmentOption {
    _installmentOption = installmentOption;
    [self archiveObject:installmentOption key:@"md_installment"];
}

- (id)unArchivedObject:(NSString *)key {
    NSData *data = defaults_object(key);
    id result;
    if (data) {
        result = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return result;
}

- (void)archiveObject:(id)object key:(NSString *)key {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    if (data) {
        defaults_set_object(key, data);
    }
}

@end
