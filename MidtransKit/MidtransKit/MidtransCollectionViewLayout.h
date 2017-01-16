//
//  MidtransCollectionViewLayout.h
//  MidtransKit
//
//  Created by Vanbungkring on 1/12/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MidtransCollectionViewLayout : UICollectionViewFlowLayout
@property (nonatomic)NSInteger column;
@property (nonatomic)CGFloat height;
- (instancetype)initWithColumn:(NSInteger )column andHeight:(CGFloat)height;
@end

