//
//  CSAddressBookViewController.h
//  CitySocializer
//
//  Created by Luigi Colucci on 06/11/2012.
//
//

#import <AddressBookUI/AddressBookUI.h>
#import "ULAddressBook.h"

@interface CSPeoplePickerNavigationController : UINavigationController

@property (nonatomic, strong) NSString  *messageBody;

- (id)initWithType:(ULABContactType)type;

@end
