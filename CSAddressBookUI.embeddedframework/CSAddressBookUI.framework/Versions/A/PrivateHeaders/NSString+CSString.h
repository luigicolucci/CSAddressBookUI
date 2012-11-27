//
//  NSString+CSString.h
//  CitySocializer
//
//  Created by Luigi Again on 11/09/2012.
//
//

#import <Foundation/Foundation.h>

@interface NSString (CSString)

- (BOOL)isValidString;

- (NSString *)capitalizeFirstLetter;

- (NSString *)decapitalizeFirstLetter;

- (BOOL)containsString:(NSString *)string;

- (BOOL)isValidEmail;

- (BOOL)isValidNumber;

- (BOOL)isLibraryUrlString;

@end
