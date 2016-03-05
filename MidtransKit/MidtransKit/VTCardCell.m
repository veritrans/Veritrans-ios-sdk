//
//  VTCardCell.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/3/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCardCell.h"

@interface CellCache : NSObject
@property (nonatomic, strong) NSMutableDictionary *container;
@end

@implementation CellCache

+ (id)shared {
    static CellCache *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}
- (id)init {
    if (self = [super init]) {
        _container = [NSMutableDictionary new];
    }
    return self;
}

@end

#define ANIMATION_DURATION 0.6

@interface VTCardCell ()
@property (nonatomic) IBOutlet UILabel *numberLabel;
@property (nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic) IBOutlet UIImageView *cardIconView;
@property (nonatomic) IBOutlet UIButton *deleteButton;
@end

@implementation VTCardCell {
    UILongPressGestureRecognizer *startEditGesture;
    UITapGestureRecognizer *stopEditGesture;
}

- (void)awakeFromNib {
    [_frontCardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(frontTapped:)]];
    [_backCardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTapped:)]];
    
    startEditGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(startEditing:)];
    stopEditGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopEditing:)];
    
    [self addGestureRecognizer:startEditGesture];

    [_deleteButton addTarget:self action:@selector(deletePressed:) forControlEvents:UIControlEventTouchUpInside];
    _deleteButton.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldStartEditing:) name:@"startEditing" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldStopEditing:) name:@"stopEditing" object:nil];
    
    [self updateEditingState];
}

- (void)frontTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cardCell:willChangePage:duration:)]) {
        [self.delegate cardCell:self willChangePage:CardPageStateBack duration:ANIMATION_DURATION];
    }
    
    [UIView transitionFromView:_frontCardView toView:_backCardView duration:ANIMATION_DURATION options:UIViewAnimationOptionShowHideTransitionViews|UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {        
        if ([self.delegate respondsToSelector:@selector(cardCell:didChangePage:duration:)]) {
            [self.delegate cardCell:self didChangePage:CardPageStateBack duration:ANIMATION_DURATION];
        }
    }];
}

- (void)backTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cardCell:willChangePage:duration:)]) {
        [self.delegate cardCell:self willChangePage:CardPageStateFront duration:ANIMATION_DURATION];
    }
    
    [UIView transitionFromView:_backCardView toView:_frontCardView duration:ANIMATION_DURATION options:UIViewAnimationOptionShowHideTransitionViews|UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(cardCell:didChangePage:duration:)]) {
            [self.delegate cardCell:self didChangePage:CardPageStateFront duration:ANIMATION_DURATION];
        }
    }];
}

- (void)deletePressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cardCellShouldRemoveCell:)]) {
        [self.delegate cardCellShouldRemoveCell:self];
    }
}

- (void)setCreditCard:(VTCreditCard *)creditCard {
    _creditCard = creditCard;
    
}

- (void)startEditing:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startEditing" object:nil];
}

- (void)stopEditing:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopEditing" object:nil];
}

- (void)shouldStartEditing:(id)sender {
    [[[CellCache shared] container] setObject:@YES forKey:@"editing_state"];
    [self updateEditingState];
}

- (void)shouldStopEditing:(id)sender {
    [[[CellCache shared] container] setObject:@NO forKey:@"editing_state"];
    [self updateEditingState];
}

- (void)updateEditingState {
    BOOL editingState = [[[CellCache shared] container][@"editing_state"] boolValue];

    _frontCardView.userInteractionEnabled = !editingState;
    _backCardView.userInteractionEnabled = !editingState;
    _deleteButton.hidden = !editingState;
    
    if (editingState) {
        [self removeGestureRecognizer:startEditGesture];
        [self addGestureRecognizer:stopEditGesture];
    } else {
        [self removeGestureRecognizer:stopEditGesture];
        [self addGestureRecognizer:startEditGesture];
    }
}

@end
