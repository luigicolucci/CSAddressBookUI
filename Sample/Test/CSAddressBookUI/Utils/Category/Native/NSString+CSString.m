//
//  NSString+CSString.m
//  CitySocializer
//
//  Created by Luigi Colucci on 11/09/2012.
//
//

#import "NSString+CSString.h"

@implementation NSString (CSString)

- (BOOL)isValidString{
    
    BOOL isValid = NO;
    
    if (self != nil) {
        if (![self isEqualToString:@""] && ![self isEqualToString:@"null"] && ![self isEqualToString:@"(null)"]){
            isValid = YES;
        }
    }
    
    return isValid;
}

- (BOOL)isLibraryUrlString{
    
    return [self containsString:@"assets-library"];
}

- (BOOL)containsString:(NSString *)string{
    
    if (self != nil && [string isValidString]) {
        NSRange range = [self rangeOfString:string options:NSCaseInsensitiveSearch];
        return range.location == NSNotFound ? NO : YES;
    }
    else {
        return NO;
    }
}

- (NSString *)decapitalizeFirstLetter{
    
    NSString *capitalize = self;
    capitalize = [NSString stringWithFormat:@"%@%@",[[capitalize substringToIndex:1] lowercaseString],[capitalize substringFromIndex:1]];
    return capitalize;
}

- (NSString *)capitalizeFirstLetter{
    
    NSString *capitalize = self;
    capitalize = [NSString stringWithFormat:@"%@%@",[[capitalize substringToIndex:1] uppercaseString],[capitalize substringFromIndex:1]];
    return capitalize;
}

- (BOOL)isValidEmail{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidNumber{
    
    NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange r = [self rangeOfCharacterFromSet: nonNumbers];
    return r.location == NSNotFound;
}

@end
