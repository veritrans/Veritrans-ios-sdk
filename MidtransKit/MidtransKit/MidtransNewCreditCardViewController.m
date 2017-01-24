//
//  MidtransNewCreditCardViewController.m
//  MidtransKit
//
//  Created by Vanbungkring on 1/19/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import "MidtransNewCreditCardViewController.h"
#import "MidtransNewCreditCardView.h"
#import "MidtransPaymentCCAddOnDataSource.h"
#import "VTClassHelper.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import <MidtransCoreKit/MidtransBinResponse.h>
@interface MidtransNewCreditCardViewController () <UITableViewDelegate>
@property (strong, nonatomic) IBOutlet MidtransNewCreditCardView *view;
@property (strong, nonatomic) MidtransPaymentCCAddOnDataSource *dataSource;
@property (strong,nonatomic) NSMutableArray *constraintsInView;
@property (nonatomic) NSInteger constraintsHeight;
@property (nonatomic,strong)NSArray *bankBinList;
@end

@implementation MidtransNewCreditCardViewController
@dynamic view;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[MidtransPaymentCCAddOnDataSource alloc] init];
    self.view.addOnTableView.dataSource  = self.dataSource;
    self.bankBinList = [NSJSONSerialization JSONObjectWithData:[[NSData alloc] initWithContentsOfFile:[VTBundle pathForResource:@"bin" ofType:@"json"]] options:kNilOptions error:nil];
      [self.view.addOnTableView registerNib:[UINib nibWithNibName:@"MidtransCreditCardAddOnComponentCell" bundle:VTBundle] forCellReuseIdentifier:@"MidtransCreditCardAddOnComponentCell"];
    self.view.addOnTableViewHeightConstraints.constant  = 2*40.0f;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (IS_IOS8_OR_ABOVE) {
        return UITableViewAutomaticDimension;
    }
    else {
        UITableViewCell *cell = [self.dataSource tableView:self.view.addOnTableView
                                     cellForRowAtIndexPath:indexPath];
        [cell updateConstraintsIfNeeded];
        [cell layoutIfNeeded];
        float height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        return height;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
