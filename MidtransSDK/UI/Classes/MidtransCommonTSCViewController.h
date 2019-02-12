//
//  MidtransCommonTSCViewController.h
//  MidtransKit
//
//  Created by Vanbungkring on 4/2/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"


@protocol MidtransCommonTSCViewControllerDelegate <NSObject>
- (void)agreeTermAndConditionDidtapped:(NSString *)bankName;
@end

@interface MidtransCommonTSCViewController : MidtransUIPaymentController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSString *bankID;
@property (weak,nonatomic)id<MidtransCommonTSCViewControllerDelegate>delegate;
@end
