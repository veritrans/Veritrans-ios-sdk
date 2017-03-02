//
//  VTMultiGuideController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/22/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTMultiGuideController.h"
#import "MBXPageViewController_vt.h"
#import "VTClassHelper.h"
#import "VTSubGuideController.h"
#import "UIViewController+HeaderSubtitle.h"
#import "VTInstruction.h"
#import "VTGroupedInstruction.h"

@interface VTMultiGuideController ()<MBXPageControllerDataSource_vt, MBXPageControllerDataDelegate_vt>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentController;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) NSMutableArray *guideViewControllers;
@property (strong, nonatomic) MidtransPaymentListModel *model;
@end

@implementation VTMultiGuideController

- (instancetype)initWithPaymentMethodModel:(MidtransPaymentListModel *)model {
    self = [super initWithNibName:[self.class description] bundle:VTBundle];
    if (self) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setHeaderWithTitle:_model.title
                    subTitle:NSLocalizedString(@"Payment Instructions", nil)];
     NSString *guidePath = [VTBundle pathForResource:_model.internalBaseClassIdentifier ofType:@"plist"];
    if ([_model.title isEqualToString:@"Other Bank"]) {
        guidePath =[VTBundle pathForResource:@"all_va" ofType:@"plist"];
    }

    self.guideViewControllers = [NSMutableArray new];

    NSArray *groupedInstructions = [VTClassHelper groupedInstructionsFromFilePath:guidePath];
    
    for (int i=0; i<[groupedInstructions count]; i++) {
        VTGroupedInstruction *groupedIns = groupedInstructions[i];
        
        if (i>1) {
            [self.segmentController insertSegmentWithTitle:groupedIns.name atIndex:i animated:NO];
        } else {
            [self.segmentController setTitle:groupedIns.name forSegmentAtIndex:i];
        }
        
        VTSubGuideController *vc = [[VTSubGuideController alloc] initWithInstructions:groupedIns.instructions];
        [self.guideViewControllers addObject:vc];
    }
    
    // Initiate MBXPageController
    MBXPageViewController_vt *MBXPageController = [MBXPageViewController_vt new];
    MBXPageController.MBXDataSource = self;
    MBXPageController.MBXDataDelegate = self;
    MBXPageController.pageMode = MBX_SegmentController;
    [MBXPageController reloadPages];
}

- (IBAction)gotitPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MBXPageViewController Data Source

- (NSArray *)MBXPageButtons {
    return @[self.segmentController];
}

- (UIView *)MBXPageContainer {
    return self.containerView;
}

- (NSArray *)MBXPageControllers {
    return self.guideViewControllers;
}

#pragma mark - MBXPageViewController Delegate

- (void)MBXPageChangedToIndex:(NSInteger)index {
    
}

@end
