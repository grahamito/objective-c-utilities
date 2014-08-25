//
//  WPTUtilities.m
//  Clipboard
//
//  Created by Armando Ochoa on 7/7/14.
//  Copyright (c) 2014 Agavelab. All rights reserved.
//

#import "WPTUtilities.h"
#import "Reachability.h"

@implementation WPTUtilities

#pragma mark Formatting

/**
 * Get a formatted date representation of a NSDate object.
 * @author Armando Ochoa
 * @param rawDate date to be formatted
 * @param fullYear whether or not use a 4 digit year
 *
 * @return date formatter (MM/dd/yy or MM/dd/yyyy)
 */
+ (NSDateFormatter *)dateFormatterWithFullYear:(BOOL)fullYear;
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    if (fullYear) {
        dateFormatter.dateFormat = @"MM/dd/yyyy";
    } else {
        dateFormatter.dateFormat = @"MM/dd/yy";
    };
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    
    return dateFormatter;
}

/**
 * Get a formatted time representation of a NSDate object.
 * @author Armando Ochoa
 * @param rawDate date to be formatted
 *
 * @return the formatted time (h:mm aa)
 */
+ (NSDateFormatter *)dateFormatterForTime;
{
    NSDateFormatter *timeFormatter = [NSDateFormatter new];
    timeFormatter.dateFormat = @"h:mm aa";
    timeFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    return timeFormatter;
}

/**
 * Show standard formatting for phone numbers, based on number of digits
 * @author Graham Conway
 * @param Input Phone number with or without non numerics e.g.  (558) 283-3383
 *
 * @return number formatted in standard way if we can guess it
 */
+ (NSString *)formatPhoneNumForDisplay:(NSString *)originalPhoneNum
{
    NSString *justDigits = [WPTUtilities stripPunctuationFromPhoneNum:originalPhoneNum];
    
    NSString *formattedNumber = originalPhoneNum;
    
    //*
    //* regular usa  and canada number 10 digits
    //*
    if ([justDigits length] == 10 ) {
        
        NSMutableString *numWithPunctuation = [NSMutableString stringWithString:justDigits];
        [numWithPunctuation insertString:@"(" atIndex:0];
        [numWithPunctuation insertString:@")" atIndex:4];
        [numWithPunctuation insertString:@" " atIndex:5];
        [numWithPunctuation insertString:@"-" atIndex:9];
        
        formattedNumber = numWithPunctuation;
    }
    else if ([justDigits length] == 11 ) {
        
        if ([justDigits characterAtIndex:0] == '1') {
            // first num is 1 then ok for USA (it's usa country code)
            NSString *justTheTenDigits = [justDigits substringFromIndex:1];
            
            // recursive call so double check lenght is 10
            if ([justTheTenDigits length] == 10) {
                formattedNumber = [WPTUtilities formatPhoneNumForDisplay:justTheTenDigits];
            }
        }
    }
    
    return formattedNumber;
}

#pragma mark Validation

/**
 * Validate Phone Number
 * @author Graham Conway
 * @param Input Phone number with or without non numerics e.g.  (558) 283-3383
 *
 * @return Bool YES if phone num is USA number 10 digits or 11 digits with country code of 1
 */
+ (BOOL)phoneNumIsValid:(NSString *)originalPhoneNum
{
    NSString *justDigits = [WPTUtilities stripPunctuationFromPhoneNum:originalPhoneNum];
    
    BOOL answer = NO;
    
    //*
    //* regular usa  and canada number 10 digits
    //*
    if ([justDigits length] == 10 ) {
        
        answer = YES;
    }
    else if ([justDigits length] == 11 )
    {
        // if first num is 1 then ok for USA
        if ([justDigits characterAtIndex:0] == '1') {
            answer = YES;
        }
    }
    return answer;
}

#pragma mark Other

/**
 * Strip non numeric chars from phone num
 * @author Graham Conway
 * @param Input Phone number with non numerics e.g.  (558) 283-3383
 *
 * @return just decimal chars 5582833383
 */
+ (NSString *)stripPunctuationFromPhoneNum:(NSString *)phoneNum
{    
    NSString *origPhoneNum = phoneNum;
    
    NSCharacterSet *notDecimalDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    NSArray *numericParts = [origPhoneNum componentsSeparatedByCharactersInSet:notDecimalDigits];
    
    NSString *strippedNum = [numericParts componentsJoinedByString:@""];
    
    return strippedNum;
}

/**
 * Error message for Invalid phone num
 * @author Graham Conway
 * @param Input Phone number with or without non numerics e.g.  (558) 283-3383
 *
 * @return NSString containing error msg
 */
+ (NSString *)errMsgForInvalidPhoneNum:(NSString *)originalPhoneNum
{
    if ( [WPTUtilities phoneNumIsValid:originalPhoneNum]) {
        return @"";
    }
    else {
        return @"phone number should be 10 digits ";
    }
}

+ (NSString *)getPatientCurrentLanguageFromDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:@"currentPatientLanguage"];
}

+ (void)savePatientLanguageToDefaults:(NSString *)patientCurrentLanguage
{
    NSString *currLang = [self getPatientCurrentLanguageFromDefaults];
    
    // Save if different
    if (![patientCurrentLanguage isEqualToString:currLang]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults setObject:patientCurrentLanguage forKey:@"currentPatientLanguage"];
        [userDefaults synchronize];
    }
}


/**
* Return a language specific translation of a string
* @author Graham Conway
* @param Input String  e.g.  @"beginButton"
* @param LangCode - 2 letter code e.g. en = english, es = espanol
* @return string in language specified
*/
+ (NSString *)getTranslationForKey:(NSString *)inputString inLanguage:(NSString *)langCode
{
    NSString *path= [[NSBundle mainBundle] pathForResource:langCode ofType:@"lproj"];
    NSBundle* languageBundle = [NSBundle bundleWithPath:path];
    
    return [languageBundle localizedStringForKey:inputString value:inputString table:nil];
}

+ (NSString *)translateToPatientLanguage:(NSString *)inputString
{
    NSString *language = [WPTUtilities getPatientCurrentLanguageFromDefaults];
    return [self getTranslationForKey:inputString inLanguage:language];
}

@end
