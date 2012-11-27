//
//  CSAddressBookViewController.h
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

#import <AddressBookUI/AddressBookUI.h>
#import "ULAddressBook.h"

@interface CSPeoplePickerNavigationController : UINavigationController

@property (nonatomic, strong) NSString  *messageBody; // Define the default message to be presented in the MFMessageComposeViewController or MFMailComposeViewController

/**
 Initialize the CSPeoplePickerNavigationController using the two different type available: phone and e-mail
 
 @param type The enum defining which type of objects the picker controller should be initialized with.
    type available: ULABContactPhone and ULABContactEmail
 
 @discussion This NavigationController allow an email or sms contacts multiple selection.
 */

- (id)initWithType:(ULABContactType)type;

@end
