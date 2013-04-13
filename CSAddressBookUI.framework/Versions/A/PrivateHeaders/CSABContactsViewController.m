//
//  CSABContactsViewController.m
//
// Copyright (c) 2012 Luigi Colucci - CitySocialising
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "CSABContactsViewController.h"
#import <AddressBook/AddressBook.h>
#import "CSABContactCell.h"
#import "CSUtils.h"

#define SELECTED    100
#define UNSELECTED  200

@interface CSABContactsViewController ()

@property (nonatomic, strong) NSDictionary *contactsDictArray;
@property (nonatomic, strong) NSArray *letterArray;
@property (nonatomic, assign) ULABContactType contactType;
@property (nonatomic, strong) NSMutableArray *selectedRowArray;
@property (nonatomic, strong) NSMutableArray *filteredListContent;
@property (nonatomic, strong) NSArray *groupedListPeople;
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, assign) CSContactsControllerType controllerType;
@property (nonatomic, strong) MFMailComposeViewController* mailComposer;

- (void)rightButtonItemPressed;
- (void)toolBarCancelButtonPressed;
- (void)toolBarDoneButtonPressed;

- (void)loadContacts;

- (void)setDoneButtonLabel;

@end

@implementation CSABContactsViewController

- (id)initWithContactType:(ULABContactType)type groupName:(NSString *)group
{
    self = [super initWithNibName:@"CSABContactsViewController" bundle:nil];
    if (self) {
        
        self.title = @"CS Contacts";
        self.groupName = group;
        
        _controllerType = [_groupName isValidString] ? CSContactsControllerGrouped : CSContactsControllerAll;

        _contactType = type;
        
        NSString *rightButtonTitle = _controllerType == CSContactsControllerAll ? @"Select All" : @"Deselect All";
        UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:rightButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonItemPressed)];
        rightButtonItem.tag = _controllerType == CSContactsControllerAll ? UNSELECTED : SELECTED;

        self.navigationItem.rightBarButtonItem = rightButtonItem;
        
        if (_controllerType == CSContactsControllerGrouped) {
            _groupedListPeople = [NSArray array];
        }
        else{
            _contactsDictArray = [NSDictionary dictionary];
        }
        
        self.selectedRowArray = [NSMutableArray array];
        self.filteredListContent = [NSMutableArray array];

        _letterArray = [[NSArray alloc] initWithObjects:@"{search}",@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#",nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _cancelItem.action = @selector(toolBarCancelButtonPressed);
	_doneItem.action = @selector(toolBarDoneButtonPressed);
    
    self.table.editing = NO;
    self.table.backgroundColor = [UIColor clearColor];
    [self.table setRowHeight:48];
    [self.table setTableHeaderView:self.barSearch];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 5.2) {
        
        // Request authorization to Address Book
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
        {
            ABAddressBookRequestAccessWithCompletion(addressBookRef,
                                                     ^(bool granted, CFErrorRef error) {
                                                         if (granted)
                                                             [self loadContacts];
                                                         
                                                     });
        }
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
        {
            // The user has previously given access, add the contact
            [self loadContacts];
        }
        else
        {
            
            NSString *msg = @"Unable to get your contacts, enable it on your privacy preferences.";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:msg
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
        }
        CFRelease(addressBookRef);
    }
    else{
        [self loadContacts];
        [self setDoneButtonLabel];
    }
}

#pragma mark -
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (tableView == self.searchDisplayController.searchResultsTableView || _controllerType == CSContactsControllerGrouped){
        return 1;
    }
	
	return [_letterArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return [_filteredListContent count];
    }
    else if (_controllerType == CSContactsControllerGrouped){
        return [_groupedListPeople count];
    }
    else{
        if (section == 0) {
            return 0;
        }
        else{
            NSString *firstLetter = [_letterArray objectAtIndex:section];
            NSArray *contactsArray = [_contactsDictArray valueForKey:firstLetter];
            
            if (contactsArray) {
                return [contactsArray count];
            }
            else{
                return 0;
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([(CSABContactCell *)cell checked]) {
        cell.backgroundColor = [UIColor colorWithHexString:@"e9f0fa"];
    }
    else{
        cell.backgroundColor = [UIColor whiteColor];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && tableView != self.searchDisplayController.searchResultsTableView && _controllerType == CSContactsControllerAll) {
        
        static NSString *CellIdentifier = @"Cell";
        
        CSABContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[CSABContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        return cell;
    }
    else{
    
        static NSString *CellIdentifier = @"Cell";
        
        CSABContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[CSABContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
                
        NSString *firstLetter = [_letterArray objectAtIndex:indexPath.section];
        NSArray *contactsArray = nil;
        
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            contactsArray = _filteredListContent;
        }
        else if (_controllerType == CSContactsControllerGrouped){
            contactsArray = _groupedListPeople;
        }
        else{
            contactsArray = [_contactsDictArray valueForKey:firstLetter];
        }
        
        if ([contactsArray count] > indexPath.row) {
            
            [cell.nameLabel clean];
            
            ULABContacts *contact = [contactsArray objectAtIndex:indexPath.row];
            [cell.nameLabel addString:contact.firstName];
            [cell.nameLabel addBoldString:contact.lastName];
            cell.contactLabel.text = contact.contactString;
            cell.checked = contact.checked;
            
            [cell setNeedsDisplay];
        }
        else{
            WLog(@"Woops...wrong index for header %@ contacts array %i asked index %i",firstLetter,[contactsArray count],indexPath.row);
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     
    CSABContactCell *cell = (CSABContactCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell didPressed];
    
    NSString *letter = [_letterArray objectAtIndex:indexPath.section];
    NSArray *contacts = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView){
        contacts = _filteredListContent;
    }
    else if (_controllerType == CSContactsControllerGrouped){
        contacts = _groupedListPeople;
    }
    else{
        contacts  = [_contactsDictArray valueForKey:letter];
    }
        
    if ([contacts count] > 0) {
        
        ULABContacts *contact = [contacts objectAtIndex:indexPath.row];
        contact.checked = cell.checked;
        
        if (cell.checked) {
            if ([_selectedRowArray containsObject:contact]) {
                WLog(@"Something screwed up on the contacts counter");
            }
            else{
                [_selectedRowArray addObject:contact];
            }
        }
        else{
            if ([_selectedRowArray containsObject:contact]) {
                [_selectedRowArray removeObject:contact];
            }
            else{
                WLog(@"Something screwed up on the contacts counter");
            }
        }
        
        [self setDoneButtonLabel];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	if (tableView == self.searchDisplayController.searchResultsTableView){
        return nil;
    }
    return _letterArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	if (tableView == self.searchDisplayController.searchResultsTableView){
        return 0;
    }
    
    if (index == 0)
    {
        [tableView setContentOffset:CGPointZero animated:NO];
        return NSNotFound;
    }
	
    return [_letterArray indexOfObject:title];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (tableView == self.searchDisplayController.searchResultsTableView || section == 0){
        return @"";
    }
	
	return [_letterArray objectAtIndex:section];
}

#pragma mark -
#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)_searchBar
{
	[self.searchDisplayController.searchBar setShowsCancelButton:NO];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar
{
	[self.searchDisplayController setActive:NO];
	[self.table reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar
{
	[self.searchDisplayController setActive:NO];
	[self.table reloadData];
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self filterContentForSearchText:searchString];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]];    
    return YES;
}

#pragma mark -
#pragma mark Utils

- (void)loadContacts{
    
    if (_controllerType == CSContactsControllerAll) {
        self.contactsDictArray = [ULAddressBook getAllContactsWithType:_contactType];
    }
    else{
        self.groupedListPeople = [ULAddressBook getGroupedContactsWithType:_contactType groupName:_groupName];
        self.selectedRowArray = [NSMutableArray arrayWithArray:_groupedListPeople];
    }
}

- (void)filterContentForSearchText:(NSString *)searchText
{
	[_filteredListContent removeAllObjects];
    
    if (_controllerType == CSContactsControllerAll) {
        
        for (NSString *letter in _letterArray)
        {
            NSArray *contacts = [_contactsDictArray valueForKey:letter];
            if (contacts) {
                
                for (ULABContacts *contact in contacts) {
                    
                    if (_contactType == ULABContactEmail) {
                        if ([contact.contactName containsString:searchText] || [contact.contactString containsString:searchText] ) {
                            [self.filteredListContent addObject:contact];
                        }
                    }
                    else{
                        if ([contact.contactName containsString:searchText]) {
                            [self.filteredListContent addObject:contact];
                        }
                    }
                }
            }
        }
    }
    else{
        for (ULABContacts *contact in _groupedListPeople) {
            
            if (_contactType == ULABContactEmail) {
                if ([contact.contactName containsString:searchText] || [contact.contactString containsString:searchText] ) {
                    [self.filteredListContent addObject:contact];
                }
            }
            else{
                if ([contact.contactName containsString:searchText]) {
                    [self.filteredListContent addObject:contact];
                }
            }
        }
    }
}

- (void)rightButtonItemPressed{
    // Select all items in the array
    
    BOOL checked = NO;
    
    if (self.navigationItem.rightBarButtonItem.tag == SELECTED) {
        self.navigationItem.rightBarButtonItem.tag = UNSELECTED;
        [self.navigationItem.rightBarButtonItem setTitle:@"Select All"];
        checked = NO;
    }
    else{
        self.navigationItem.rightBarButtonItem.tag = SELECTED;
        [self.navigationItem.rightBarButtonItem setTitle:@"Deselect All"];
        checked = YES;
    }    
    
    [_selectedRowArray removeAllObjects];

    if (_controllerType == CSContactsControllerAll) {
        for (NSString *letter in _letterArray)
        {
            NSArray *contacts = [_contactsDictArray valueForKey:letter];
            if (contacts) {
                
                for (ULABContacts *contact in contacts) {
                    contact.checked = checked;
                    
                    if (checked) {
                        [_selectedRowArray addObject:contact];
                    }
                }
            }
        }
    }
    else{
        for (ULABContacts *contact in _groupedListPeople) {
            contact.checked = checked;
            
            if (checked) {
                [_selectedRowArray addObject:contact];
            }
        }
    }
    
    [self.table reloadData];
    [self setDoneButtonLabel];
}

- (void)toolBarCancelButtonPressed{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)toolBarDoneButtonPressed{
    
    if (_contactType == ULABContactPhone) {

        if([MFMessageComposeViewController canSendText])
        {
            MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
            if ([_messageBody isValidString]) {
                controller.body = _messageBody;
            }
            controller.recipients = [_selectedRowArray contactStringArray];
            controller.messageComposeDelegate = self;

            [self.navigationController presentModalViewController:controller animated:YES];
        }
    }
    else if (_contactType == ULABContactEmail){

        if ([MFMailComposeViewController canSendMail]) {

            MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
            if ([_messageBody isValidString]) {
                [controller setMessageBody:_messageBody isHTML:NO];
            }
            [controller setToRecipients:[_selectedRowArray contactStringArray]];
            controller.mailComposeDelegate = self;
            
            [self.navigationController presentModalViewController:controller animated:YES];
            [self setMailComposer:controller];
        }
    }
}

- (void)setDoneButtonLabel{
    
    NSString *buttonTitle = @"Done";
    
    NSInteger numberOfSelectedRows = [_selectedRowArray count];
    if (numberOfSelectedRows > 0) {
        buttonTitle = [NSString stringWithFormat:@"Send %i invite",numberOfSelectedRows];
    }
    
    [self.doneItem setTitle:buttonTitle];
}

#pragma mark -
#pragma mark MF delegates

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
	NSString *messageError = nil;
	
	switch (result) {
            
		case MessageComposeResultSent:
        case MessageComposeResultCancelled:
            break;
            
		case MessageComposeResultFailed: messageError = @"Message sending error message";
			break;
	}

    WLog(@"%@", messageError);

    [controller dismissModalViewControllerAnimated:NO];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    
	NSString *mailError = nil;
	
	switch (result) {
            
		case MFMailComposeResultSent:
        case MFMailComposeResultCancelled:
        case MFMailComposeResultSaved:
            break;
            
		case MFMailComposeResultFailed:
            mailError = @"Email sending error message";
			break;
	}
    
    WLog(@"%@", mailError);
    
    [controller dismissModalViewControllerAnimated:NO];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
}

@end
