//
//  ULAddressBook.h
//  UberLife
//
//  Created by luigi br on 26/05/12.
//  Copyright (c) 2012 la sua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

typedef enum {
    ULABContactPhone = 0,
    ULABContactEmail
}ULABContactType;

// Custom detail AB type - PhoneNumber and email allowed
@interface ULABContacts : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *contactString;
@property (nonatomic, assign) ULABContactType contactType;
@property (nonatomic, assign) BOOL checked;

- (NSString *)contactName;

@end

// Custom detail AB type - Name and AB record
@interface ULABPerson : NSObject {
    
    id record;
}

@property (nonatomic, strong) id record;

- (NSString *)name;
- (NSString *)nameWithRef:(ABRecordRef)person;
- (NSArray *)contacts;
+ (NSArray *)contactsWithRef:(ABRecordRef)person;

@end

@interface ULAddressBook : NSObject

+ (NSArray *)getAddressBookPeopleList;

@end
