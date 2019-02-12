//
//  MidtransInstallmentCollectionViewCell.h
//  MidtransKit
//
//  Created by Vanbungkring on 1/12/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MidtransInstallmentCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *installmentLabel;
- (void)configureInstallmentWithText:(NSString *)title;
- (void)configurePointWithThext:(NSNumber *)number;
@end
