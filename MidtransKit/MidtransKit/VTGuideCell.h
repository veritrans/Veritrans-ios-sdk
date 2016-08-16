//
//  VTGuideCell.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 8/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTInstruction.h"

@interface VTGuideCell : UITableViewCell
- (void)setInstruction:(VTInstruction *)instruction number:(NSInteger)number;
@end
