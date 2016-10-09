//
//  VTGuideView.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 8/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTInstruction.h"

@interface VTGuideView : UIView
@property (nonatomic, strong) NSArray <VTInstruction*>* instructions;
@end
