//
//  SNPPointViewController.h
//  MidtransKit
//
//  Created by Vanbungkring on 3/7/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"

@interface SNPPointViewController : MidtransUIPaymentController

@property (nonatomic,strong)NSString *bankName;
@property (nonatomic,strong)NSString *secureURL;
@property (nonatomic) BOOL isSaveCard;

-(instancetype _Nonnull)initWithPaymentMethod:(MIDPaymentDetail *)paymentMethod cardToken:(NSString *)cardToken;

@end
