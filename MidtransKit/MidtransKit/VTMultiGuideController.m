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

@interface VTMultiGuideController ()<MBXPageControllerDataSource_vt, MBXPageControllerDataDelegate_vt>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentController;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) NSMutableArray *guideViewControllers;
@property (strong, nonatomic) VTPaymentListModel *model;
@end

@implementation VTMultiGuideController

- (instancetype)initWithPaymentMethodModel:(VTPaymentListModel *)model {
    self = [super initWithNibName:[self.class description] bundle:VTBundle];
    if (self) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setHeaderWithTitle:_model.title subTitle:NSLocalizedString(@"Payment Instructions", nil)];
    
    _guideViewControllers = [NSMutableArray new];
    NSString *guidePath = [VTBundle pathForResource:_model.internalBaseClassIdentifier ofType:@"plist"];
    NSArray *guideList = [NSArray arrayWithContentsOfFile:guidePath];
    for (int i=0; i<[guideList count]; i++) {
        NSDictionary *guide = guideList[i];
        
        if (i>1) {
            [_segmentController insertSegmentWithTitle:guide[@"name"] atIndex:i animated:NO];
        } else {
            [_segmentController setTitle:guide[@"name"] forSegmentAtIndex:i];
        }
        
        VTSubGuideController *vc = [[VTSubGuideController alloc] initWithList:guide[@"guides"]];
        [_guideViewControllers addObject:vc];
    }
    
    // Initiate MBXPageController
    MBXPageViewController_vt *MBXPageController = [MBXPageViewController_vt new];
    MBXPageController.MBXDataSource = self;
    MBXPageController.MBXDataDelegate = self;
    MBXPageController.pageMode = MBX_SegmentController;
    [MBXPageController reloadPages];
}

#pragma mark - MBXPageViewController Data Source

- (NSArray *)MBXPageButtons
{
    return @[self.segmentController];
}

- (UIView *)MBXPageContainer
{
    return self.containerView;
}

- (NSArray *)MBXPageControllers {
    return _guideViewControllers;
}

#pragma mark - MBXPageViewController Delegate

- (void)MBXPageChangedToIndex:(NSInteger)index
{
    
}

@end
