//
//  UITextField+WPTLocalize.m
//  Clipboard
//
//  Created by Graham Conway on 7/21/14.
//  Copyright (c) 2014 Agavelab. All rights reserved.
//

#import "UITextField+WPTLocalize.h"
#import "WPTUtilities.h"

@implementation UITextField (WPTLocalize)
- (NSString *)translationKey
{
    return nil;
}


// this method should be used as a key value pair for a textfield whose display value needs to be varied based on user's langauge.
// the language strings come from the Localizable.string file.
// this code selects the file from the lanaguage specific folder. 
- (void)setTranslationKey:(NSString *)translationKey
{
    
    NSString *str = [WPTUtilities translateToPatientLanguage:translationKey];

    self.placeholder = str;
}


@end
