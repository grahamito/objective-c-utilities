//
//  WPTPopoverController.h
//  Clipboard
//
//  Created by Graham Conway on 7/10/14.
//  Copyright (c) 2014 Agavelab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPTPopoverTVC.h"

@protocol WPTPopoverDelegate
@optional
- (void)optionWasSelected:(UITextField *)textField;
@end

@interface WPTPopoverController : NSObject <WPTPopoverTVCDelegate, UITextFieldDelegate>

@property (assign, nonatomic) id <WPTPopoverDelegate> delegate;

@property (strong, nonatomic) UIPopoverController *wptPopoverController;
@property (weak, nonatomic) UIControl *wptPopoverSourceControl;

/*
 * show popover
 *
 * @param sender - view (button) where the popup should appear.
 * @param data - array of strings
 */

- (void)wpt_showPopoverForControl:(UIControl *)sender
                        withData:(NSArray *)data;

/*
 * show popover with multiple sections
 *
 * @param sender - view (button) where the popup should appear.
 * @param dictionary - a dictionary with the section titles as keys, and arrays as objects
 */

- (void)wpt_showPopoverForControl:(UIControl *)sender
                         withDictionary:(NSDictionary *)dictionary;

- (void)wpt_showDatePopoverForControl:(UIControl *)sender;
@end
