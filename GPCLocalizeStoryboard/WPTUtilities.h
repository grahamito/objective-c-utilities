//
//  WPTUtilities.h
//  Clipboard
//
//  Created by Armando Ochoa on 7/7/14.
//  Copyright (c) 2014 Agavelab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPTUtilities : NSObject

+ (NSDateFormatter *)dateFormatterWithFullYear:(BOOL)fullYear;
+ (NSDateFormatter *)dateFormatterForTime;
+ (NSString *)formatPhoneNumForDisplay:(NSString *)originalPhoneNum;
+ (BOOL)phoneNumIsValid:(NSString *)originalPhoneNum;
+ (NSString *)stripPunctuationFromPhoneNum:(NSString *)originalPhoneNum;
+ (NSString *)errMsgForInvalidPhoneNum:(NSString *)originalPhoneNum;

+ (NSString *)getPatientCurrentLanguageFromDefaults;

+ (void)savePatientLanguageToDefaults:(NSString *)patientCurrentLanguage;
+ (NSString *)getTranslationForKey:(NSString *)inputString inLanguage:(NSString *)langCode;
+ (NSString *)translateToPatientLanguage:(NSString *)inputString;

@end
