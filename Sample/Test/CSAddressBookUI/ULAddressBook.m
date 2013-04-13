//
//  ULAddressBook.m
//  UberLife
//
//  Created by luigi br on 26/05/12.
//  Copyright (c) 2012 la sua. All rights reserved.
//

#import "ULAddressBook.h"
#import "CSUtils.h"

typedef enum{
    CSListAll,
    CSListGrouped
} CSListType;

// Custom detail AB type - PhoneNumber and email allowed
@implementation ULABContacts

- (NSString *)contactName{
    
    NSString *fullName = @"";
    
    if ([_firstName isValidString]) {
        fullName = _firstName;
    }
    
    if ([_lastName isValidString]) {
        if ([fullName isValidString]) {
            fullName = [fullName stringByAppendingFormat:@" %@",_lastName];
        }
        else{
            fullName = _lastName;
        }
    }
    return fullName;
}

@end

// Custom detail AB type - Name and AB record
@implementation ULABPerson

+ (NSArray *)phoneArrayWithTypeRef:(CFTypeRef)phoneProperty{
    
    NSArray *phones = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(phoneProperty);
    
    NSMutableArray *phoneArray = [[NSMutableArray alloc] initWithCapacity:[phones count]];
    
    for (NSString *phone in phones) {
        
        if ([phone isValidString]) {
            ULABContacts *contact = [[ULABContacts alloc] init];
            contact.contactType = ULABContactPhone;
            contact.contactString = phone;
            [phoneArray addObject:contact];
        }
    }
    
    return phoneArray;
}

+ (NSArray *)emailArrayWithTypeRef:(CFTypeRef)emailProperty{
    
    NSArray *emails = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(emailProperty);
    
    NSMutableArray *emailArray = [[NSMutableArray alloc] initWithCapacity:[emails count]];
    
    for (NSString *email in emails) {
        
        ULABContacts *contact = [[ULABContacts alloc] init];
        contact.contactType = ULABContactEmail;
        contact.contactString = email;
        [emailArray addObject:contact];
    }
    return emailArray;
}

- (NSString *)nameWithRef:(ABRecordRef)person{
    
    NSString* compositeName = (__bridge_transfer NSString *)ABRecordCopyCompositeName(person);
    return compositeName;
}

- (NSString *)name{
    
    NSString* compositeName = (__bridge_transfer NSString *)ABRecordCopyCompositeName((__bridge ABRecordRef)(self.record));
    return compositeName;
}

+ (NSArray *)contactsWithRef:(ABRecordRef)person{
    
    // Get Phone
    CFTypeRef phoneProperty = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    NSArray *phonesArray = [self phoneArrayWithTypeRef:phoneProperty];
    
    //Get email
    CFTypeRef emailProperty = ABRecordCopyValue(person, kABPersonEmailProperty);
    NSArray *emailArray = [self emailArrayWithTypeRef:emailProperty];
    
    
    NSMutableArray *contactsArray = [[NSMutableArray alloc] initWithCapacity:([phonesArray count] + [emailArray count])];
    
    [contactsArray addObjectsFromArray:phonesArray];
    [contactsArray addObjectsFromArray:emailArray];
    
    CFRelease(emailProperty);
    CFRelease(phoneProperty);
    
    return contactsArray;
}

- (NSArray *)contacts{
    
    // Get Phone
    CFTypeRef phoneProperty = ABRecordCopyValue((__bridge ABRecordRef)(self.record), kABPersonPhoneProperty);
    
    NSArray *phonesArray = [ULABPerson phoneArrayWithTypeRef:phoneProperty];
    
    //Get email
    CFTypeRef emailProperty = ABRecordCopyValue((__bridge ABRecordRef)(self.record), kABPersonEmailProperty);
    NSArray *emailArray = [ULABPerson emailArrayWithTypeRef:emailProperty];
    
    NSMutableArray *contactsArray = [[NSMutableArray alloc] initWithCapacity:([phonesArray count] + [emailArray count])];
    
    [contactsArray addObjectsFromArray:phonesArray];
    [contactsArray addObjectsFromArray:emailArray];
    
    CFRelease(phoneProperty);
    CFRelease(emailProperty);

    return contactsArray;
}

@end

@implementation ULAddressBook

+ (NSArray *)getAddressBookPeopleList{
    
    ABAddressBookRef _addressBookRef = ABAddressBookCreate ();
    NSArray* allPeople = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(_addressBookRef);
    
    CFRelease(_addressBookRef);

    return allPeople;
    
    NSMutableArray* peopleName = [[NSMutableArray alloc] initWithCapacity:[allPeople count]];
    
    for (id record in allPeople) {
        
        ULABPerson *person = [[ULABPerson alloc] init];
        person.record = record;

        [peopleName addObject:person];
    }
}

+ (NSArray *)getGroupsNameArray{
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    NSArray *groups = (__bridge_transfer NSArray *) ABAddressBookCopyArrayOfAllGroups(addressBook);
    
    NSMutableArray *groupsName = [NSMutableArray arrayWithCapacity:[groups count]];
    [groupsName addObject:@"All Contacts"];
    
    // Check group in existing Address book groups
    for (id _group in groups)
    {
        CFTypeRef groupName = ABRecordCopyValue((__bridge_retained ABRecordRef)_group, kABGroupNameProperty);
        [groupsName addObject:(__bridge_transfer NSString*)groupName];
    }
    
    CFRelease(addressBook);
    
    return groupsName;
}

+ (NSDictionary *)getAllContactsWithType:(ULABContactType)contactType{
    return [self getContactsForListType:CSListAll type:contactType name:nil];
}

+ (NSArray *)getGroupedContactsWithType:(ULABContactType)contactType groupName:(NSString *)name{
    return [self getContactsForListType:CSListGrouped type:contactType name:name];
}

+ (id)getContactsForListType:(CSListType)listType type:(ULABContactType)contactType name:(NSString *)groupName{
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
    
    NSArray *groupPeople = nil;
    
    if (listType == CSListGrouped) {
        
        NSArray *groups = (__bridge_transfer NSArray *) ABAddressBookCopyArrayOfAllGroups(addressBook);
        
        NSMutableArray *groupsName = [NSMutableArray arrayWithCapacity:[groups count]];
        [groupsName addObject:@"All Contacts"];
        
        // Check group in existing Address book groups
        for (id _group in groups)
        {
            CFTypeRef groupNameProperty = ABRecordCopyValue((__bridge_retained ABRecordRef)_group, kABGroupNameProperty);
            if ([groupName isEqualToString:(__bridge_transfer NSString*)groupNameProperty]) {
                
                groupPeople = (__bridge NSArray *)(ABGroupCopyArrayOfAllMembers((__bridge_retained ABRecordRef)_group));
                break;
            };
            
            CFRelease(groupNameProperty);
        }
    }
    
    NSArray *allPeople = nil;
    if (groupPeople) {
        allPeople = [NSArray arrayWithArray:groupPeople];
    }
    else{
        allPeople = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByLastName);
    }
    
    id resultObject = nil;
    
    if (listType == CSListAll) {
        resultObject = [NSMutableDictionary dictionaryWithCapacity:40];
    }
    else{
        resultObject = [NSMutableArray arrayWithCapacity:[allPeople count]];
    }
        
    for (id person in allPeople) {
        
        CFStringRef name = ABRecordCopyValue((__bridge ABRecordRef)person, kABPersonFirstNameProperty);
        CFStringRef lastName = ABRecordCopyValue((__bridge ABRecordRef)person, kABPersonLastNameProperty);
        
        NSString *nameString = (__bridge NSString *)name;
        NSString *lastNameString = (__bridge NSString *)lastName;
        
        // Set the array according to the LastName, if present, otherwise use the FirstName
        NSString *firstLetter = nil;
        
        if ([lastNameString isValidString]){
            firstLetter = [lastNameString substringToIndex:1];
        }
        else if ([nameString isValidString]){
            firstLetter = [nameString substringToIndex:1];
        }
        
        if ([firstLetter isValidString]) {
            
            // Check if the array has been already created
            if ([firstLetter isValidNumber]) {
                firstLetter = @"#";
            }
            
            ABMultiValueRef property = ABRecordCopyValue((__bridge ABRecordRef)person, (contactType == ULABContactPhone) ? kABPersonPhoneProperty : kABPersonEmailProperty);
            
            NSArray *propertyArray = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(property);
            CFRelease(property);
            
            if (listType == CSListAll) {
                
                NSMutableArray *letterArray = [resultObject valueForKey:firstLetter];
                if (!letterArray) {
                    NSMutableArray *letterArray = [NSMutableArray array];
                    [resultObject setObject:letterArray forKey:firstLetter];
                }
                
                for (NSString *contact in propertyArray) {
                    
                    if ([nameString isValidString] || [lastNameString isValidString]) {
                        
                        ULABContacts *newContact = [[ULABContacts alloc] init];
                        newContact.firstName = nameString;
                        newContact.lastName = lastNameString;
                        newContact.contactString = contact;
                        
                        [[resultObject valueForKey:firstLetter] addObject:newContact];
                    }
                }
            }
            else{
                for (NSString *contact in propertyArray) {
                    
                    if ([nameString isValidString] || [lastNameString isValidString]) {
                        
                        ULABContacts *newContact = [[ULABContacts alloc] init];
                        newContact.firstName = nameString;
                        newContact.lastName = lastNameString;
                        newContact.contactString = contact;
                        newContact.checked = YES;
                        
                        [resultObject addObject:newContact];
                    }
                }
            }
            
            if (propertyArray) {
                CFRelease((__bridge CFTypeRef)(propertyArray));
            }
        }
        
        if (name) CFRelease(name);
        if (lastNameString) CFRelease(lastName);
    }
    
    CFRelease(addressBook);
    CFRelease(source);
    
    return resultObject;
}

@end

@implementation NSArray (ULABPerson)

- (NSArray *)contactStringArray{
    
    NSMutableArray *stringArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (ULABContacts *contact in self) {
        
        if ([contact.contactString isValidString]) {
            [stringArray addObject:contact.contactString];
        }
    }
    return [NSArray arrayWithArray:stringArray];
}

@end
