//
//  VTImageManager.h
//  MidtransCoreKit
//
//  Created by Arie on 8/11/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MidtransImageManager : NSObject
+(void)getImageFromURLwithUrl:(NSString*)imageUrlString;
+(UIImage *)merchantLogo;
@end
