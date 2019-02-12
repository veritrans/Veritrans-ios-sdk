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
@property (strong, nonatomic) MidtransPaymentListModel *model;
@end

@implementation VTSingleGuideController
@dynamic view;

- (instancetype)initWithPaymentMethodModel:(MidtransPaymentListModel *)model {
    self = [super initWithNibName:[self.class description] bundle:VTBundle];
    if (self) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.model.title;
    
    NSString* filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_%@", _model.internalBaseClassIdentifier];
    NSString *guidePath = [VTBundle pathForResource:filenameByLanguage ofType:@"plist"];
    if (guidePath == nil) {
        guidePath = [VTBundle pathForResource:[NSString stringWithFormat:@"en_%@",_model.internalBaseClassIdentifier] ofType:@"plist"];
    }
    
    NSArray *instructions = [VTClassHelper instructionsFromFilePath:guidePath];
    VTSubGuideController *vc = [[VTSubGuideController alloc] initWithInstructions:instructions];
    [self addSubViewController:vc toView:self.containerView];
}

- (IBAction)gotitPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
