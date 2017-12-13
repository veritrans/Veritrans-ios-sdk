//
//  MidtransSavedCardCell.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/2/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MDCardTableViewCell.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import <BKMoneyKit/BKCardNumberLabel.h>
@interface MDCardTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) IBOutlet UIImageView *ccImageView;
@property (strong, nonatomic) IBOutlet UIImageView *bankImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ccToBankPadding;

@end

@implementation MDCardTableViewCell
- (void)configureCard:(NSDictionary *)maskedCreditCard {
    NSLog(@"maskedCreditCard %@",maskedCreditCard);
    self.descLabel.text = @"";
    NSString *iconName = [MidtransCreditCardHelper nameFromString:[maskedCreditCard objectForKey:@"cardhash"]];
    [self.ccImageView setImage:[UIImage imageNamed:iconName]];
    self.titleLabel.text =[NSString stringWithFormat:@"%@ - %@",iconName, [self matchBankBIN:[maskedCreditCard objectForKey:@"cardhash"]]];
    [self.bankImageView setImage:[UIImage imageNamed:[[self matchBankBIN:[maskedCreditCard objectForKey:@"cardhash"]] lowercaseString]]];
    self.descLabel.text = [[self formattedCreditCardNumber:[maskedCreditCard objectForKey:@"cardhash"]] stringByReplacingOccurrencesOfString:@"X" withString:@"⋅"];
     
}
- (NSString *)matchBankBIN:(NSString *)bin {
    NSArray *binArray = [NSJSONSerialization JSONObjectWithData:[[NSData alloc]
                                                                initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bin" ofType:@"json"]]
                                                       options:kNilOptions error:nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"SELF['bins'] CONTAINS %@", [bin substringToIndex:6]];
    NSArray *filtered  = [binArray filteredArrayUsingPredicate:predicate];
    if (filtered.count) {
        MidtransBinResponse *response = [[MidtransBinResponse alloc] initWithDictionary:[filtered firstObject]];
        return  [response.bank uppercaseString];
    } else  {
        return @"Test Card";
    }
}
- (NSString *)formattedCreditCardNumber:(NSString *)cardNumber {
    NSString *result = @"";
    
    while (cardNumber.length > 0) {
        NSString *subString = [cardNumber substringToIndex:MIN(cardNumber.length, 4)];
        result = [result stringByAppendingString:subString];
        if (subString.length == 4) {
            result = [result stringByAppendingString:@" "];
        }
        cardNumber = [cardNumber substringFromIndex:MIN(cardNumber.length, 4)];
    }
    return result;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
