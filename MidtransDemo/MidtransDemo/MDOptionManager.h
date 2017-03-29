//
//  MDOptionManager.h
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 3/27/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDOptionManager : NSObject

+ (MDOptionManager *)shared;
+ (UIColor *)colorWithOption:(NSString *)colorOption;

@property (nonatomic) NSString *ccTypeOption;
@property (nonatomic) NSString *secure3DOption;
@property (nonatomic) NSString *issuingBankOption;
@property (nonatomic) NSString *expireTimeOption;
@property (nonatomic) NSString *saveCardOption;
@property (nonatomic) NSString *promoOption;
@property (nonatomic) NSString *preauthOption;
@property (nonatomic) NSString *colorOption;

@property (nonatomic) id ccTypeValue;
@property (nonatomic) id secure3DValue;
@property (nonatomic) id issuingBankValue;
@property (nonatomic) id expireTimeValue;
@property (nonatomic) id saveCardValue;
@property (nonatomic) id promoValue;
@property (nonatomic) id preauthValue;
@property (nonatomic) id colorValue;

@end
