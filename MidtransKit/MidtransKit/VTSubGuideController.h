//
//  VTSubGuideController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/22/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTViewController.h"
#import "VTInstruction.h"

@interface VTSubGuideController : VTViewController
- (instancetype)initWithInstructions:(NSArray <VTInstruction*>*)instructions;
@end
