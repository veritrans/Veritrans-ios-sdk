//
//  MIDNetworkHelper.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 09/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (decode)
- (NSData*)MIDValidateUTF8;
@end

@interface NSString (encode)
- (NSString *)MIDURLEncodedString;
@end

@interface NSDictionary (parse)
- (NSString *)queryStringValue;
- (NSArray *)pairsOfArray:(NSArray *)values key:(NSString *)key;
@end

@interface NSError (builder)
+ (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message reasons:(id)reason;
@end
