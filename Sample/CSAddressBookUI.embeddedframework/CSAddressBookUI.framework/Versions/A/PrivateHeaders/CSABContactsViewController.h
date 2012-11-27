//
//  CSABContactsViewController.h
//  CitySocializer
//
//  Created by Luigi Colucci on 06/11/2012.
//
//

#import <UIKit/UIKit.h>
#import "ULAddressBook.h"
#import <MessageUI/MessageUI.h>

typedef enum{
    CSContactsControllerAll,
    CSContactsControllerGrouped
}CSContactsControllerType;

@interface CSABContactsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *table;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *cancelItem;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *doneItem;
@property (nonatomic, weak) IBOutlet UISearchBar *barSearch;
@property (nonatomic, weak) IBOutlet UIToolbar *toolBar;
@property (nonatomic, strong) NSString *messageBody;

- (id)initWithContactType:(ULABContactType)type groupName:(NSString *)groupName;

@end
