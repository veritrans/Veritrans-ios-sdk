//
//  VTInstallmentCollectionViewCell.h
//  MidtransKit
//
//  Created by Arie on 11/28/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTInstallmentCollectionViewCell : UICollectionViewCell
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *installmentTextLabel;
- (void)configureInstallment:(NSString *)installment;
@end
