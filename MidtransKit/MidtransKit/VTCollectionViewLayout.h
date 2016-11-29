//
//  VTCollectionViewLayout.h
//  MidtransKit
//
//  Created by Arie on 11/28/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTCollectionViewLayout : UICollectionViewFlowLayout
@property (nonatomic)NSInteger column;
@property (nonatomic)CGFloat height;
- (instancetype)initWithColumn:(NSInteger )column andHeight:(CGFloat)height;

@end
