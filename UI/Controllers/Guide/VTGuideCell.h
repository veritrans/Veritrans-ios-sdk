//
//  VTGuideCell.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 8/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTInstruction.h"
#import "VTTapableLabel.h"

@interface VTGuideCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageBottomInstruction;
@property (weak, nonatomic) IBOutlet VTTapableLabel *bottomNotes;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomImageInstructionsConstraints;
- (void)setInstruction:(VTInstruction *)instruction number:(NSInteger)number;
@end
