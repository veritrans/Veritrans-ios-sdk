//
//  VTSingleGuideController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/22/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTSingleGuideController.h"
#import "VTClassHelper.h"
#import "UIViewController+HeaderSubtitle.h"
#import "VTSubGuideController.h"

@interface VTSingleGuideController ()
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) VTPaymentListModel *model;
@end

@implementation VTSingleGuideController
@dynamic view;

- (instancetype)initWithPaymentMethodModel:(VTPaymentListModel *)model {
    self = [super initWithNibName:[self.class description] bundle:VTBundle];
    if (self) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setHeaderWithTitle:self.model.title
                    subTitle:NSLocalizedString(@"Payment Instructions",nil)];
    
    NSString *guidePath = [VTBundle pathForResource:_model.internalBaseClassIdentifier ofType:@"plist"];
    NSArray *guideList = [NSArray arrayWithContentsOfFile:guidePath];
    VTSubGuideController *vc = [[VTSubGuideController alloc] initWithList:guideList];
    [self addSubViewController:vc toView:self.containerView];
}

- (IBAction)gotitPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
