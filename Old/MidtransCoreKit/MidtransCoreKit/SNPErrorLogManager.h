//
//  SNPErrorLogManager.h
//  MidtransCoreKit
//
//  Created by Vanbungkring on 10/10/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNPErrorLogManager : NSObject
+ (SNPErrorLogManager *)shared;
@property(nonatomic,strong)NSString *className;
- (void)trackException:(NSException *)exceptionName className:(NSString *)className;
@end
