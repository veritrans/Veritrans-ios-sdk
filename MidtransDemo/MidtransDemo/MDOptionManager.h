//
//  MDOptionManager.h
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 3/27/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDOptionManager : NSObject

+ (MDOptionManager *)shared;

@property (nonatomic) NSString *ccPaymentType;
@property (nonatomic) NSString *secure3D;
@property (nonatomic) NSString *issuingBank;
@property (nonatomic) NSString *customExpiry;
@property (nonatomic) NSString *saveCard;
@property (nonatomic) NSString *promo;
@property (nonatomic) NSString *preauth;
@property (nonatomic) NSString *colorTheme;

@end
