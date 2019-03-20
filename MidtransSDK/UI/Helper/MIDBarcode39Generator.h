//
//  MIDBarcode39Generator.h
//  MidtransKit
//
//  Created by Vanbungkring on 4/10/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MIDBarcode39Generator : NSObject
+ (UIImage *)code39ImageFromString:(NSString *)strSource Width:(CGFloat)barcodew Height:(CGFloat)barcode;
@end
