//
//  VTCollectionViewLayout.m
//  MidtransKit
//
//  Created by Arie on 11/28/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCollectionViewLayout.h"

@implementation VTCollectionViewLayout
- (instancetype)init {
    self = [super init];
    if (self)
    {
        self.minimumLineSpacing = 1.0;
        self.minimumInteritemSpacing = 1.0;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}
- (instancetype)initWithColumn:(NSInteger)column andHeight:(CGFloat)height{
    self = [super init];
    if (self)
    {
        self.minimumLineSpacing = 5.0;
        self.column = column;
        self.height = height;
        self.minimumInteritemSpacing = 1.0;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}
- (CGSize)itemSize {
    NSInteger numberOfColumns = _column?:4;
    CGFloat itemWidth = (CGRectGetWidth(self.collectionView.frame) - (numberOfColumns - 1)) / numberOfColumns;
    return CGSizeMake(itemWidth, _height?_height:150);
}
@end
