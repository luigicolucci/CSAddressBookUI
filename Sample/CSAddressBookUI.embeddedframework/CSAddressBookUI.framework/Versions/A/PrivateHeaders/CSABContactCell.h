//
//  CSABContactCell.h
//  CitySocializer
//
//  Created by Luigi Colucci on 06/11/2012.
//
//

#import <UIKit/UIKit.h>
#import "CSUtils.h"

@interface CSABContactCell : UITableViewCell

@property (nonatomic, strong) ULBoldLabel   *nameLabel;
@property (nonatomic, strong) UILabel   *contactLabel;
@property (nonatomic, assign) BOOL      checked;

- (void)didPressed;

@end
