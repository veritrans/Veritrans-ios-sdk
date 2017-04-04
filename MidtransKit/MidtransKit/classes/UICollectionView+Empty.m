//
//  UICollectionView+Empty.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/14/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "UICollectionView+Empty.h"
#import <objc/runtime.h>

@implementation UICollectionView (Empty)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL layoutSubviewsSelector = @selector(layoutSubviews);
        SEL vt_layoutSubviewsSelector = @selector(vt_layoutSubviews);
        
        Method layoutSubviewsMethod = class_getInstanceMethod(class, layoutSubviewsSelector);
        Method vt_layoutSubviewsMethod = class_getInstanceMethod(class, vt_layoutSubviewsSelector);
        
        BOOL methodAdded = class_addMethod(class, layoutSubviewsSelector, method_getImplementation(vt_layoutSubviewsMethod), method_getTypeEncoding(vt_layoutSubviewsMethod));
        
        if (methodAdded) {
            class_replaceMethod(class, vt_layoutSubviewsSelector, method_getImplementation(layoutSubviewsMethod), method_getTypeEncoding(layoutSubviewsMethod));
        } else {
            method_exchangeImplementations(layoutSubviewsMethod, vt_layoutSubviewsMethod);
        }
    });
}

- (UIView *)emptyDataView {
    return objc_getAssociatedObject(self, @"emptyDataView");
}

- (void)setEmptyDataView:(UIView *)view {
    [self addSubview:view];
    
    objc_setAssociatedObject(self, @"emptyDataView", view,  OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)empty {
    for (int i=0; i<[self numberOfSections]; i++) {
        if ([self numberOfItemsInSection:i] > 0) return NO;
    }
    return YES;
}

- (void)vt_layoutSubviews {
    [self vt_layoutSubviews];
    
    [self emptyDataView].hidden = ![self empty];
    
    if ([self emptyDataView].hidden == NO) {
        [[self emptyDataView] setFrame:self.bounds];
    }
}

@end
