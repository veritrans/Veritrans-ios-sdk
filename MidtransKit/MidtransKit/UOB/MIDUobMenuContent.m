//
//  MIDUobMenuModel.m
//  MidtransKit
//
//  Created by Muhammad Fauzi Masykur on 14/06/21.
//  Copyright © 2021 Midtrans. All rights reserved.
//

#import "MIDUobMenuContent.h"
#import "VTClassHelper.h"

@interface MIDUobMenuContent()
@property (nonatomic, readwrite) NSString *menuTitle;
@property (nonatomic, readwrite) NSString *menuDescription;
@property (nonatomic, readwrite) NSString *selectedTitle;
@property (nonatomic, readwrite) NSString *selectedOption;
@property (nonatomic, readwrite) NSString* menuImage;

@end

@implementation MIDUobMenuContent

- (instancetype)initWithMenuTitle:(NSString *)menuTitle menuDescription:(NSString *)menuDescription selectedTitle:(NSString *)selectedTitle selectedOption:(NSString *)selectedOptions{
    if (self = [super init]) {
        self.menuTitle = menuTitle;
        self.menuDescription = menuDescription;
        self.selectedTitle = selectedTitle;
        self.selectedOption = selectedOptions;
        
    }
    return self;
}
- (instancetype)initWithAppMenu{
    if (self = [super init]) {
        self.menuTitle = @"UOB EZ Pay Via TMRW App";
        self.menuDescription = [VTClassHelper getTranslationFromAppBundleForString:@"Pay with TMRW app"];
        self.selectedTitle = @"Via TMRW App";
        self.selectedOption = @"app";
        self.menuImage = @"uob_ezpay";
    }
    return self;
}
- (instancetype)initWithWebMenu{
    if (self = [super init]) {
        self.menuTitle = @"UOB EZ Pay Via UOB Web";
        self.menuDescription = [VTClassHelper getTranslationFromAppBundleForString:@"Pay with UOB Web"];
        self.selectedTitle = @"Via UOB Web";
        self.selectedOption = @"web";
        self.menuImage = @"uob_ezpay";
    }
    return self;
}
@end
